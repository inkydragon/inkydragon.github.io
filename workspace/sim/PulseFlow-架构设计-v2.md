# PulseFlow — 架构设计（v2，基于 DSO 参考实现）

> 基于 dsp-cpp 源码分析更新。关键变更标注 `[DSO→]`。

---

## 变更摘要

基于对 DSO（1997-now, ~10K 行 C++）的完整源码分析，以下是架构层面的关键更新：

| 主题 | 原设计 | DSO 发现 | 更新后 |
|------|--------|---------|--------|
| 单元调度 | 需要拓扑排序 | DSO 不做排序——双缓冲让顺序无关 | M1 不做拓扑排序（双缓冲即可），M2 再加 |
| 时间积分 | RK4/DP5 集中式 ODE | DSO 每单元内部 Euler + 钳制 | 两种模式双轨：DP5 集中式（推荐）+ Euler 分散式（兼容） |
| 流股结构 | MaterialStream/EnergyStream/InfoStream | DSO 只有 MaterialStream（能量/信息隐式传递） | 保留三种流，但 M1 只实现 Material |
| 单元操作为纯函数 | `calculate(inputs) → outputs` | DSO 单元内部直接写输出流股 | 分离：`compute()` 返回结果 + `apply()` 写入流股 |
| PID 为单元操作 | 在 flowsheet 中 | DSO 在 modelLoop 中单独循环 | 确认：PID 是单元操作，但可以批量并行执行 |
| 快照 | JSON.stringify(state) | DSO 单块 fwrite | 确认 JSON，加增量快照（只存变化） |
| 阀门 | 在 `units/fluid-flow/` | DSO 单独处理的复杂子系统 | M1 只做简单阀门（`Kv × sqrt(dp)`），管网拓扑后置 |
| 案例配置 | JSON/YAML | DSO 文本文件（pmpm/pmup/strm） | JSON + 明确 Schema，参考 DSO 的 pdmata.idx 索引模式 |
| 热力学 | PR/理想气体切换 | DSO 线性焓+理想K+弛豫化传质 | M1：线性焓（从 DSO 直译）。M2+：加入 EoS |

---

## 一、仿真核心 — 受 DSO 启发的最重要变更

### 1.1 不需要拓扑排序（M1）

**DSO 发现**：DSO 从来没有拓扑排序——单元按 `pmpm.XXX` 文件中的手动定义顺序执行。它依赖双缓冲来保证一致性：

```
时间步 N:
  所有单元从 ss[get] 读取 → 都是时间步 N-1 的输出 → 一致
  所有单元写入 ss[put] → 互不干扰
  时间步结束时: flip(get, put)
```

**PulseFlow 更新**：M1 不做拓扑排序。用户手动定义单元执行顺序（在 `flowsheet.json` 中的 `calculationSequence` 数组）。双缓冲保证结果不依赖顺序。M2 可以加入自动拓扑排序。

```typescript
// M1 的步骤：
for (const unitId of flowsheet.calculationSequence) {
  const unit = registry.get(unitId);
  unit.step();  // 内部从流股读 input、写 output
}
// 每个时间步结束时：
streams.forEach(s => s.flip());
```

### 1.2 单元操作内部做时间积分（而非集中式 ODE）

**DSO 发现**：DSO 不使用集中的 ODE 求解器。每个单元操作在 `step()` 内部自行处理 Euler 时间积分。这对非刚性系统很稳健。

**PulseFlow 更新**：两种模式并存：

- **模式 A（M1 默认）**：单元内部负责积分（同 DSO）。每个单元的 `step()` 内部执行 `Euler(dt)` 或 `RK4(dt)`。框架只负责时间推进循环。
- **模式 B（M2+）**：集中式 DP5(4)。框架收集所有单元的 ODE 右手边函数 `f(t, y)`，统一积分。

```typescript
// 模式 A: 单元自己积分
interface UnitOperation {
  /** 执行一个时间步（内部自己做 Euler/RK 积分） */
  step(dt: number): void;  // [DSO→] 签名变更：加 dt 参数
}

// 模式 B: 框架集中积分
interface ODEUnit extends UnitOperation {
  /** 返回 dy/dt（不修改内部状态） */
  rhs(): Float64Array;
  /** 接收积分后的 y 更新内部状态 */
  applyState(y: Float64Array): void;
}
```

**为什么 M1 选择模式 A**：
- 和 DSO 一致——调试友好（每个单元独立）
- TEP 非刚性 → Euler 足够
- 不需要构造全局 Jacobian 或状态向量
- 每个单元的内部状态是松耦合的（液位、温度、组成各自积分）

### 1.3 钳制比高精度更重要

**DSO 发现**：DSO 到处使用物理钳制——质量不能为负、温度不能低于环境、液位不能超过罐高。这些钳制比数值方法的精度对稳定性贡献更大。

**PulseFlow 更新**：每个单元操作必须实现物理边界检查：

```typescript
abstract class UnitOperation {
  /** 每个时间步执行后调用 */
  protected clamp(): void {
    // 子类实现：
    //   this.holdUp = Math.max(0, this.holdUp);
    //   this.temperature = Math.max(273.15, this.temperature);
    //   this.level = Math.min(this.maxLevel, Math.max(0, this.level));
  }

  step(dt: number): void {
    this.integrate(dt);  // Euler/RK4
    this.clamp();        // [DSO→] 新建：物理钳制
    this.writeOutputs(); // 更新输出流股
  }
}
```

### 1.4 流股平滑层

**DSO 发现**：`fm = 0.95×fm + 0.05×f_new` 是关键的工程技巧——用一阶惯性平滑流量的阶跃变化。

**PulseFlow 更新**：在 flowsheet 层加可选平滑：

```typescript
// flowsheet/dynamic.ts
interface SmoothingConfig {
  enabled: boolean;
  factor: number;  // 默认 0.95（DSO 的默认值）
}

function smoothStreams(streams: Stream[], config: SmoothingConfig): void {
  if (!config.enabled) return;
  for (const s of streams) {
    s.output.flow = config.factor * s.input.flow
                  + (1 - config.factor) * s.output.flow;
    s.output.flow = Math.min(s.output.flow, s.maxFlow);
  }
}
```

---

## 二、单元操作接口 — 重新设计

### 2.1 基于 DSO 的接口演进

**DSO 模式**（每个 `sub_*()` 函数）：
```
1. 从全局 strm[] 数组读取输入状态（通过 unit.flow[] 索引）
2. 执行质量/能量/相平衡计算，内部 Euler 积分
3. 将结果直接写入全局 strm[] 数组的输出槽位
4. 设置 s->maxf（最大允许流量）、s->pfr（上游压力）
```

**PulseFlow 将其拆分为三步**：

```typescript
// [DSO→] 重新设计的接口
abstract class UnitOperation {
  id: string;

  // ===== 单元操作必须实现的方法 =====

  /** 从输入端口读取，执行一个时间步的积分，返回输出端口的值 */
  protected abstract compute(dt: number): UnitOutputs;

  /** 物理边界钳制（质量、温度、液位等） */
  protected abstract clampOutputs(outputs: UnitOutputs): UnitOutputs;

  // ===== 框架处理的方法（单元不需要关心） =====

  /** 完整的 step：读 → 算 → 钳制 → 写 */
  step(dt: number): void {
    const outputs = this.clampOutputs(this.compute(dt));
    this.writeToStreams(outputs);
  }

  // 输入/输出端口由框架管理
  inputPorts: Map<string, StreamPort>;
  outputPorts: Map<string, StreamPort>;

  // 内部状态（用于快照）
  abstract getState(): Record<string, number>;
  abstract setState(state: Record<string, number>): void;
}
```

**关键改变**：`compute()` 不直接写流股——它返回一个中间结构 `UnitOutputs`。框架负责将输出写入流股缓冲。这使得：
- 单元操作可独立测试（给输入 → 检查 `compute()` 返回值，不需要真实流股）
- 输出流股的格式统一（框架保证 `maxf`、`pfr` 等辅助字段的一致性）

### 2.2 端口设计（DSO 只有数字流股）

**DSO 问题**：每个单元有 `flow[UNIT_STRM]` 数组，正负号表示方向。同一数组包含进料、出料、夹套进出口、换热介质——无结构。

**PulseFlow 更新**：

```typescript
interface PortDefinition {
  name: string;           // "feed", "vapor_out", "jacket_in", ...
  direction: 'input' | 'output';
  streamType: 'material' | 'energy' | 'info';  // [DSO→] DSO 只有 material
  required: boolean;
  maxConnections: number;
}

// 每个单元类型声明自己的端口
const CSTRPorts: PortDefinition[] = [
  { name: 'feed', direction: 'input', streamType: 'material', required: true, maxConnections: 1 },
  { name: 'product', direction: 'output', streamType: 'material', required: true, maxConnections: 1 },
  { name: 'jacket_in', direction: 'input', streamType: 'material', required: false, maxConnections: 1 },
  { name: 'jacket_out', direction: 'output', streamType: 'material', required: false, maxConnections: 1 },
  { name: 'duty', direction: 'output', streamType: 'energy', required: false, maxConnections: 1 },
];
```

**M1 只实现 `material` 端口**（和 DSO 一样）。Energy 和 Info 流在 M2+ 加入。

---

## 三、热力学 — M1 从 DSO 直译

### 3.1 M1 热力学范围

DSO 的热力学模型虽然简单，但有明确的接口和经过验证的实现。M1 直接参考其结构：

```typescript
// thermo/ — [DSO→] 参考 dsosrc/pmthermo.cpp:107-713

interface PureComponent {
  name: string;
  mw: number;              // 摩尔质量 [kg/kmol]
  tb: number;              // 常压沸点 [K]
  tc: number; pc: number;  // 临界温度/压力 [K, kPa]
  w: number;               // 偏心因子
  hc: number;              // Antoine 蒸气压参数 Hc
  cpl: [number, number];   // 液相热容 [cp0, cp1]
  cpv: [number, number];   // 气相热容
  hl: [number, number];    // 液相焓 [h0, h1]（线性模型）
  hv: [number, number];    // 气相焓
}

// 热力学方法接口 [DSO→] DSO 中没有这个抽象——它直接在全局函数中实现
// PulseFlow 把它抽象为可替换的策略
interface ThermoMethod {
  /** K值 = Pc/P * exp(Hc*(1-Tc/T)) [DSO→] 参考 pmthermo.cpp */
  kValue(comp: PureComponent, P: number, T: number): number;

  /** 焓 [kJ/kmol] [DSO→] 参考 enth(), pmthermo.cpp:226-241 */
  enthalpy(comp: PureComponent[], x: number[], T: number, phase: Phase): number;

  /** 等温闪蒸 [DSO→] 参考 flash_t(), pmthermo.cpp:554-645 */
  flashTP(P: number, T: number, z: number[]): FlashResult;

  /** 泡点温度 [DSO→] 参考 T_OF_VLE(), pmthermo.cpp:356-424 */
  bubblePoint(P: number, x: number[], t0: number): { T: number; y: number[] };
}
```

### 3.2 M1 默认实现：同 DSO

```typescript
// thermo/ideal.ts — 直接翻译 DSO 的算法
class IdealThermo implements ThermoMethod {
  kValue(c: PureComponent, P: number, T: number): number {
    return (c.pc / P) * Math.exp(c.hc * (1 - c.tc / T));
  }

  enthalpy(comps: PureComponent[], x: number[], T: number, phase: Phase): number {
    let h = 0;
    for (let i = 0; i < comps.length; i++) {
      const [h0, h1] = phase === 'vapor' ? comps[i].hv : comps[i].hl;
      h += x[i] * (h0 + T * h1);
    }
    return h;
  }

  // flash_t 直接翻译 DSO 的 Halley 三阶方法
  // 参考 dsp-docs/10-关键算法分析.md 第 1 节
}
```

---

## 四、单元操作库 — 按 DSO 分类 + 注册表

### 4.1 注册表模式（替代 DSO 的硬编码枚举）

```typescript
// [DSO→] 替代 subtype[] 函数指针数组
class UnitRegistry {
  private factories = new Map<string, UnitFactory>();

  register(type: string, factory: UnitFactory, ports: PortDefinition[]): void {
    this.factories.set(type.toLowerCase(), factory);
    this.portDefs.set(type.toLowerCase(), ports);
  }

  create(type: string, config: UnitConfig): UnitOperation {
    const factory = this.factories.get(type.toLowerCase());
    if (!factory) throw new Error(`Unknown unit type: ${type}`);
    return factory(config);
  }

  /** 列出所有已注册类型（用于 UI 选择器） */
  listTypes(): string[] { return [...this.factories.keys()]; }
}
```

### 4.2 M1 需要实现的单元（参考 DSO 对应实现）

| 单元 | DSO 参考 | M1 实现要点 |
|------|---------|-----------|
| **Mixer** | `sub_node` (mix≥1) | 组成+焓加权平均，和 DSO 一致 |
| **Splitter** | `sub_node` (flow[2]<0 分支) | 直接复制输入状态 |
| **Flash2** (气液分离器) | `flash_t` + `subdtank` 的简化版 | 等温闪蒸，气相/液相分别输出 |
| **CSTR** | `subatank` + `subtreac` | 罐动态（液位+组成+焓）+ 反应源项 |
| **Valve** | `Pmvalvpipe` (简单阀门) | Cv×√dp，不做管网拓扑 |
| **Compressor** | DSO 无直接对应 | 等熵压缩 + 效率因子 |

每个 M1 单元 ≤ 150 行 TS（最复杂的 CSTR 约 200 行）。

### 4.3 M2+ 的单元可以从 DSO 迁移

| 单元 | DSO 对应 | 复杂度 | 参考源码行数 |
|------|---------|--------|------------|
| HeatExchanger | `subghexc` | 中 | pmunit.cpp:381-472 (~90 行) |
| Distillation | `subpdist` | 高 | pmunit.cpp:867-1081 (~215 行) |
| DTANK | `subdtank` | 中高 | pmunit.cpp:1083-1414 (~330 行) |
| PlugFlow | `sub___32` | 高 | pmunit.cpp:~200 行 |

---

## 五、案例配置格式

### 5.1 基于 DSO 文件结构的 JSON 化

DSO 有 6 种配置文件。PulseFlow 将它们合并为结构化的 JSON：

```jsonc
// cases/tep/flowsheet.json
{
  "meta": {
    "name": "Tennessee Eastman Process",
    "description": "...",
    "version": "1.0.0",
    "timeStep": 0.5,           // [DSO→] sys.ts
    "smoothing": { "enabled": true, "factor": 0.95 }
  },

  "components": [               // [DSO→] 原 pmbc.XXX
    { "id": "A", "name": "Reactant A", "mw": 42.08, "tc": 364.9, "pc": 4600, "w": 0.142, ... },
    { "id": "B", "name": "Reactant B", ... }
  ],

  "units": [                    // [DSO→] 原 pmpm.XXX 中的设备定义
    { "id": "R101", "type": "cstr", "config": { "volume": 14.7, ... } },
    { "id": "S101", "type": "flash2", "config": { ... } },
    { "id": "V201", "type": "valve", "config": { "cv": 100, ... } },
    { "id": "TC101", "type": "pid", "config": { "kp": 1.5, "ti": 60, "td": 0, "sp": 350, "pvSource": "S101.temperature", "opTarget": "V201.opening" } }
  ],

  "connections": [              // [DSO→] 替代 unit[].flow[] 数字索引
    { "id": "S1", "from": { "unit": "R101", "port": "product" }, "to": { "unit": "S101", "port": "feed" } },
    { "id": "S2", "from": { "unit": "S101", "port": "vapor" }, "to": { "unit": "V201", "port": "inlet" } }
  ],

  "calculationSequence": [      // [DSO→] 替代 pmpm 中的手动顺序
    "R101", "S101", "V201", "TC101"
  ]
}
```

**关键设计决策**：`calculationSequence` 显式声明（参考 DSO 的手动顺序做法）。M1 不自动排序——用户必须在 JSON 中指定执行顺序。验证工具会检查：每个单元的输入是否在执行它之前被其上游单元的上一时间步产生（双缓冲使其总是满足）。

---

## 六、模型步进引擎

### 6.1 基于 DSO modelLoop 的精简版

```typescript
// flowsheet/engine.ts
// [DSO→] 参考 dsosrc/dsomain.cpp:2245-2380 modelLoop()
export class SimulationEngine {
  private registry: UnitRegistry;
  private flowsheet: FlowsheetConfig;
  private streams: Map<string, Stream>;   // [DSO→] 替代 strm[] 全局数组
  private units: Map<string, UnitOperation>;
  private instruments: Instrument[];

  // 时间管理 [DSO→] 参考 sys.dtime, sys.ts
  private time = 0;          // 仿真时间 [hr]
  private stepSize = 0.5;    // 步长 [s]，参考 DSO sys.ts=0.5
  private counter = 0;

  /** 执行一个时间步 [DSO→] 参考 modelLoop */
  step(): SimulationSnapshot {
    // 1. 双缓冲 flip [DSO→] 参考 sys.get ↔ sys.put toggle
    this.streams.forEach(s => s.flip());

    // 2. 按计算顺序执行所有单元 [DSO→] 参考 subtype[] dispatch
    for (const id of this.flowsheet.calculationSequence) {
      this.units.get(id)!.step(this.stepSize / 3600);  // s → hr
    }

    // 3. PID 控制 [DSO→] 原 modelLoop 第 8 步，但 PID 现在是单元操作
    // 已经在 calculationSequence 中按顺序执行

    // 4. 流股平滑 [DSO→] 原 modelLoop 第 13 步
    smoothStreams(this.streams, this.flowsheet.smoothing);

    // 5. 更新仪表 [DSO→] 原 subpv() — 现在配置驱动
    this.updateInstruments();

    // 6. 时间推进
    this.time += this.stepSize / 3600;
    this.counter++;

    return this.snapshot();
  }

  /** 运行多个时间步 */
  run(duration: number): SimulationSnapshot[] {
    const steps = Math.floor(duration / this.stepSize);
    const snapshots: SimulationSnapshot[] = [];
    for (let i = 0; i < steps; i++) {
      snapshots.push(this.step());
    }
    return snapshots;
  }

  /** [DSO→] 参考 stateRW() — 但用 JSON 替代二进制 */
  snapshot(): SimulationSnapshot {
    return {
      time: this.time,
      step: this.counter,
      streams: [...this.streams.values()].map(s => s.snapshot()),
      units: [...this.units.values()].map(u => ({ id: u.id, state: u.getState() })),
    };
  }

  restore(snapshot: SimulationSnapshot): void {
    this.time = snapshot.time;
    this.counter = snapshot.step;
    // 恢复流股和单元状态...
  }
}
```

### 6.2 与 DSO modelLoop 的差异

| DSO | PulseFlow | 理由 |
|-----|-----------|------|
| 报警检查在 modelLoop 显式调用 | 事件系统：`emit('alarm', ...)` | 解耦 |
| 网络通信（PV_OP、HEARTBEAT） | 无（单进程 Web） | 不需要 Controller |
| 评分系统（subscore） | 插件：`ScorePlugin.onStep(snapshot)` | 可选、非核心 |
| 联锁（interlock） | `InterlockPlugin` — 监控 + 回调 | 可选 |
| 阀门求解（subvalvri/pq）在末尾 | 阀门是普通单元操作，在序列中执行 | 简化 |

---

## 七、PID 与控制器

### 7.1 从 DSO 的 adjust() 翻译

```typescript
// units/control/pid.ts
// [DSO→] 参考 dsosrc/dsomain.cpp:456-495 adjust()
export class PIDController extends UnitOperation {
  // PID 参数
  kp = 1.0; ti = 60.0; td = 0.0;
  sp = 0;           // 设定值
  mode: 'manual' | 'auto' | 'cascade' = 'auto';

  // 内部状态
  private eps1 = 0;  // 上一周期偏差
  private eps2 = 0;  // 上上周期偏差
  private op = 0;    // 当前输出 [0, 1]

  protected compute(dt_hr: number): UnitOutputs {
    // 从输入端口读取 PV
    const pv = this.getInputValue('pv');

    // [DSO→] 位置式 PID，同 adjust()
    const eps = (pv - this.sp) / this.range;
    const ek = eps - this.eps1;
    const ed = ek - (this.eps1 - this.eps2);

    const dt_s = dt_hr * 3600;
    const dop = this.kp * (ek + eps * dt_s / this.ti + ed * this.td / dt_s);

    this.op += dop;
    this.op = Math.max(0, Math.min(1, this.op));  // [DSO→] 抗积分饱和

    this.eps2 = this.eps1;
    this.eps1 = eps;

    return { op: this.op };
  }
}
```

### 7.2 PID 如何连接到流程

```jsonc
// 在 flowsheet.json 的 connections 中:
{ "id": "C1", "from": { "unit": "TC101", "port": "op" },
              "to": { "unit": "V201", "port": "position" } }
// [DSO→] 用 InfoStream 连接（M2）或用配置中的 opTarget（M1）
```

**M1 简化**：PID 的输出目标通过配置字符串指定（如 `"opTarget": "V201.opening"`），框架在 step 后自动应用。M2 再改为显式的 InfoStream 连接。

---

## 八、快照与序列化

### 8.1 JSON 快照

```typescript
interface SimulationSnapshot {
  version: string;          // schema version
  timestamp: number;        // Date.now()
  meta: {
    time: number; step: number;
    stepSize: number;
  };
  streams: StreamSnapshot[];  // { id, input: State, output: State }
  units: UnitSnapshot[];      // { id, type, state }
  instruments: InstrumentSnapshot[];
}
```

### 8.2 增量快照（M2+）

```typescript
// [DSO→] DSO 无此功能，但 PulseFlow 可以在 Web 中轻松实现
interface DeltaSnapshot {
  baseSnapshotId: string;
  steps: number;
  changes: {
    streamId: string;
    field: string;       // "temperature" | "composition[3]" | ...
    oldValue: number;
    newValue: number;
  }[];
}
```

增量快照大幅度减少存储（只存变化，不是完整状态），适合长时间仿真的历史回溯。

---

## 九、项目结构（更新后）

```
pulseflow/
├── src/
│   ├── core/
│   │   ├── types.ts          # State, Stream, FlowDirection, PortDefinition
│   │   ├── registry.ts       # UnitRegistry
│   │   └── unit-base.ts      # UnitOperation 抽象类
│   ├── thermo/
│   │   ├── types.ts          # PureComponent, ThermoMethod
│   │   ├── ideal.ts          # [DSO→] 翻译 pmthermo.cpp
│   │   ├── flash.ts          # flash_t, T_OF_VLE, flash_h
│   │   └── data/             # 物性数据 JSON
│   ├── units/
│   │   ├── mixer.ts          # [DSO→] sub_node (mix 模式)
│   │   ├── splitter.ts
│   │   ├── flash2.ts         # [DSO→] flash_t + 简单罐
│   │   ├── cstr.ts           # [DSO→] subatank + subtreac
│   │   ├── valve.ts          # [DSO→] Pmvalvpipe 简单模式
│   │   ├── compressor.ts
│   │   └── pid.ts            # [DSO→] adjust()
│   ├── flowsheet/
│   │   ├── engine.ts         # SimulationEngine
│   │   ├── stream.ts         # Stream (双缓冲)
│   │   ├── config.ts         # 配置加载/验证
│   │   └── smoothing.ts      # 流股平滑
│   └── numerics/
│       ├── euler.ts          # 显式 Euler
│       └── rk4.ts            # RK4 / DP5(4)
├── cases/
│   └── tep/
│       ├── flowsheet.json    # 拓扑 + 连接 + 计算顺序
│       ├── thermo.json        # DSO pmbc.XXX 等价物
│       └── README.md
├── apps/
│   └── web/                  # React + React Flow + uPlot
└── tests/
    ├── thermo/               # 对 DSO 参考数据验证
    ├── units/                # 每个单元独立测试
    └── integration/          # TEP 全流程测试
```

---

## 十、M1 实现路径（更新后）

基于 DSO 参考，M1 的实现顺序可以更高效：

```
Step 1（3天）：core + thermo（理想模型）
  → State, Stream（含双缓冲）, PureComponent, ThermoMethod
  → 翻译 DSO 的 flash_t, T_OF_VLE, enth, enthalpy
  → 验证：对 DSO 的测试案例数据

Step 2（5天）：3 个核心单元 + 引擎
  → Mixer/Splitter (DSO sub_node)
  → Flash2 (DSO flash_t + 简化罐)
  → CSTR (DSO subatank + subtreac)
  → SimulationEngine + 手动计算序列

Step 3（3天）：PID + 阀门 + 完整 TEP
  → PID (DSO adjust)
  → Valve (简单 Cv×sqrt(dp))
  → TEP 案例 JSON 配置
  → 手动计算序列（参考 pyTEP 的拓扑顺序）

Step 4（2天）：Web 集成
  → React Flow 流程拓扑图渲染
  → uPlot 趋势图
  → Vercel 部署

总计：~2周可出最小可交互版本（比原估计的 5-6 周快，因为有 DSO 参考实现）
```

---

## 十一、关键设计原则（来自 DSO + PulseFlow 综合）

1. **双缓冲消除顺序依赖** — DSO 证明了这在实践中完全可行，不需要拓扑排序就能跑
2. **钳制 > 高精度** — Euler 不会发散如果每步都做物理钳制
3. **单元自己管积分** — 中心化的 ODE 求解器对非刚性系统是过度设计
4. **配置驱动 > 代码生成** — JSON 替代 pmpv2
5. **端口命名 > 数字索引** — 可读、可调试、可验证
6. **案例驱动 > 愿景驱动** — 每个案例 2-3 个新单元，不做完整的单元库
7. **JSON 快照 > 二进制** — 可 diff、可读、无平台依赖

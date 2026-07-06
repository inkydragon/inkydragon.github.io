# MaterialIdentity 设计

> 状态：**讨论阶段**
> 日期：2026-07-04
> 标签：`game-design` `data-model` `material-identity`

本文件定义游戏中 MaterialIdentity（物质身份）的数据结构。它是[工业化模拟游戏设计讨论](industrial-simulation-game-design.md)和[物质命名来源参考](material-naming-sources.md)的配套文档。

---

## 一、定位

MaterialIdentity 不是"物质的完整档案"或"世界的实体清单"。它是**配方的类型签名空间**——回答一个问题：**"在反应方程式中，这个物质是什么、它的计量关系是什么？"**

### 核心洞察

```
抽象层（MaterialIdentity）：
  "O₂"  — 不是任何地方的任何具体氧气
  "H₂SO₄"  — 不是任何罐子里的任何具体硫酸
  "chalcopyrite"  — 不是地图上坐标 (10,20) 的那个矿脉
  "copper_wire"  — 不是仓库里那 45 卷具体铜线

  这是"化学式上的东西"——反应的参与者，配方的输入输出签名。

实例层（运行时实体）：
  地图坐标 (10,20) 的矿脉     — 包含 50000kg 黄铜矿，品位 3.4%
  建筑 bld_030 输入槽里的      — 45kg 破碎黄铜矿，粒度 -200 目
  管道 P-47 中正在流动的       — 硫酸铜溶液，含 As 12ppm
  仓库 slot_17 里的            — 100 卷铜线，AWG 12

  每个实例指向一个 MaterialIdentity，并附加具体数据（数量、纯度、温度、杂质……）。
```

### 红线

进入 MaterialIdentity 的条件（三个，必须同时满足）：

1. **有 composition**（反应方程式的物质平衡基础）
2. **出现在至少一个 ReactionRule 的 inputs 或 outputs 中**
3. **可以在物流/库存系统中存在**（有数量的概念）

**不进入 MaterialIdentity 的**：

| 实体 | 去向 | 原因 |
|------|------|------|
| 设备/机器 | DeviceRegistry | 执行配方，不被配方消费 |
| 建筑/结构 | BuildingRegistry / BlueprintRegistry | 建造产出的目标，不是物流中的流动物 |
| 角色/NPC | CharacterRegistry | 独立 AI 系统 |
| 地形/矿脉 | 地图数据（实例层） | 引用 MaterialIdentity，附加位置和数量 |
| 能量 | ReactionRule 的独立输入维度 | 没有 composition |
| 劳动力 | ReactionRule 的独立输入维度 | 没有 composition |
| 知识/蓝图 | 各自的注册表 | 不是物质 |
| 工具/武器 | MVP 抽象化；Phase N 通过 Material + Attachment 模式处理 | 有耐久度等额外数据 |

---

## 二、字段定义

```typescript
interface MaterialIdentity {

  // ══════════════════════════════════════════════════════════
  // 必选字段（3 个）
  // 缺任何一个——物质就没有"身份"
  // ══════════════════════════════════════════════════════════

  /** 全局唯一标识符。
   *
   *  命名规范：小写字母 + 下划线 + 数字。不使用连字符、不使用大写。
   *  元素:     "cu", "fe", "s", "o", "h", "c", "au", "ag"
   *  矿物:     "malachite", "chalcopyrite", "hematite"
   *  化合物:   "sulfuric_acid", "sodium_hydroxide"
   *  合金:     "brass_alpha_70cu30zn"
   *  定义溶液: "sulfuric_acid_98pct"
   *  燃料:     "coal_anthracite"
   *  废物:     "anode_slime_copper"
   *  零件:     "copper_wire"
   *  消费品:   "bread"
   *
   *  不可变性：一旦分配，永不重命名。
   *  废弃的 ID 标记 deprecated，不删除。
   */
  readonly id: string;

  /** 物质类别。
   *
   *  决定此物质在 ReactionRule 匹配中的语义角色。
   *  总共 12 种。详见第三节 MaterialType 定义。
   *  此字段影响：配方匹配模式、实例层追踪的额外数据项。
   */
  readonly type: MaterialType;

  /** 反应方程式中的物质平衡。
   *
   *  key = 本库中另一个 MaterialIdentity 的 id（自引用闭环）。
   *  value = 质量分数，范围 (0, 1]。总和 = 1.0（±0.001 容差）。
   *
   *  纯化合物（自指——递归的基础情形）：
   *    { H2SO4: 1.0 }
   *
   *  矿物（化学计量比换算为质量分数）：
   *    chalcopyrite: { Cu: 0.346, Fe: 0.304, S: 0.350 }
   *    → CuFeS₂: Cu=63.55, Fe=55.85, 2S=64.14, 总=183.54
   *    → 63.55/183.54=0.346, 55.85/183.54=0.304, 64.14/183.54=0.350
   *
   *  合金（定义配比）：
   *    brass_alpha_70cu30zn: { Cu: 0.70, Zn: 0.30 }
   *
   *  定义溶液（标准化浓度）：
   *    sulfuric_acid_10pct: { H2SO4: 0.10, H2O: 0.90 }
   *
   *  废物（近似组成——用于回收/处理配方匹配）：
   *    anode_slime_copper: { Cu: 0.18, Ag: 0.05, Au: 0.01, Se: 0.08, Pb: 0.10, other: 0.58 }
   *
   *  燃料（工业分析）：
   *    coal_anthracite: { fixed_carbon: 0.92, volatile: 0.05, ash: 0.02, sulfur: 0.01 }
   *
   *  约束：
   *  1. 所有 key 必须在同一次编译的 MaterialIdentity 库中存在（无悬空引用）。
   *  2. 定义顺序：元素 → 纯化合物 → 矿物/合金/溶液/燃料 → 废物/零件。
   *  3. 对于纯化合物，key 指向自身（自指）。
   *  4. sum(values) = 1.0，容差 ±0.001。
   *     废物中如果有大量未知组分，使用 "other_impurities" 作为占位 key。
   */
  readonly composition: Record<string, number>;

  // ══════════════════════════════════════════════════════════
  // 可选字段 — 强烈建议填写
  // ══════════════════════════════════════════════════════════

  /** 化学式字符串。仅用于 UI 显示。
   *
   *  纯化合物/元素/矿物/合金——强烈建议填。
   *  commodity / waste / consumable——可以不填。
   *
   *  示例：
   *    "CuFeS₂", "H₂SO₄", "Cu₂CO₃(OH)₂", "Cu"
   *
   *  注意：这只是显示字符串。规则引擎不解析此字段。
   *  反应计量关系由 composition 字段提供。
   */
  readonly formula?: string;

  /** 默认显示名。
   *
   *  单一语言（英语），用于开发环境的调试输出和日志。
   *  多语言/历史名称 → MaterialName 库（独立）。
   */
  readonly display_name?: string;

  /** 来源溯源。
   *
   *  记录此物质在现实世界中的权威锚点。
   *  不是运行时需要的——但维护阶段极其重要：
   *  "黄铜矿 Cu 含量为什么是 34.6%？" → 看 ref → 有答案。
   *  "硫酸的 CAS 号是多少？" → 看 ref → CAS 7664-93-9。
   */
  readonly ref?: MaterialReference;

  // ══════════════════════════════════════════════════════════
  // 可选字段 — 生命周期管理
  // ══════════════════════════════════════════════════════════

  /** 记录版本号。源数据修订时递增。MVP 阶段可不填。 */
  readonly version?: number;

  /** 废弃标记。不再使用的物质标记此字段。
   *  运行时不应引用已废弃物质。
   *  废弃的 ID 不删除——存档迁移工具需要历史 ID 做映射。
   */
  readonly deprecated?: boolean;

  /** 废弃后的推荐替代物质 ID。存档迁移工具使用。 */
  readonly replaced_by?: string;

  /** 废弃原因。方便未来维护者理解历史决策。 */
  readonly deprecation_note?: string;
}
```

### 字段总结

```
必选 (3):
  id           — 全局唯一标识，永不重命名
  type         — 12 种物质类别，决定配方语义
  composition  — 反应方程式中的物质平衡

强烈建议 (3):
  formula      — 化学式（仅 UI 显示，不参与规则匹配）
  display_name — 默认显示名
  ref          — 来源溯源（维护必备）

可选 (3):
  version      — 记录版本（MVP 可不填）
  deprecated   — 废弃标记
  replaced_by  — 替代物质 ID

总共最多 9 个字段。
```

---

## 三、类型枚举

```typescript
/** 12 种物质类别。
 *
 *  分类标准：此物质在配方/反应系统中的语义角色。
 *  不是按化学本质分类（那是 IMA/Dana/周期表的事）。
 */
type MaterialType =
  // ── 不可再分的化学个体 ──
  | "element"              // Cu, Fe, S, O, H, C, Au, Ag, Pt, Zn, Sn, Pb, …
  | "pure_compound"        // H₂SO₄, NaOH, CuSO₄, CaCO₃, SiO₂, H₂O, CO₂, SO₂, O₂, …

  // ── 天然存在的混合物 ──
  | "mineral"              // 孔雀石、黄铜矿、褐铁矿、磁铁矿、方铅矿、闪锌矿、…

  // ── 人工制造的定义混合物 ──
  | "alloy"                // 黄铜(Cu-Zn)、青铜(Cu-Sn)、钢(Fe-C)、白铜(Cu-Ni)
  | "defined_solution"     // 稀硫酸(10%)、浓硫酸(98%)、盐酸(37%)、NaOH溶液(50%)

  // ── 按工艺角色分类 ──
  | "fuel"                 // 无烟煤、烟煤、褐煤、木炭、焦炭、重油、…
  | "intermediate"         // 粗铜、冰铜(matte)、生铁、海绵铜、纸浆、…
  | "refined_material"     // 电解铜(99.99%)、纯碱、汽油、…
  | "component"            // 铜线、齿轮、钢管、螺丝、水泥、电路板、…
  | "consumable"           // 面包、饮用水、药品、…
  | "waste";               // 铜炉渣、阳极泥、浮选尾矿、飞灰、废电解液、…
```

### 分类决策流程

```
Q1:  它是化学元素吗？
  → Yes: "element"
  → No:  继续

Q2:  它是单一的纯化学物质（固定化学式、100% 纯）吗？
  → Yes: "pure_compound"
  → No:  继续

Q3:  它是天然矿物（有 IMA 名称和已知化学计量比）吗？
  → Yes: "mineral"
  → No:  继续

Q4:  它是金属合金（有固定配比、有 UNS 编号或等效标准）吗？
  → Yes: "alloy"
  → No:  继续

Q5:  它是标准浓度的溶液（有配方明确引用此浓度）吗？
  → Yes: "defined_solution"
  → No:  继续

Q6:  它被燃烧产生热量吗？
  → Yes: "fuel"
  → No:  继续

Q7:  它是工艺中间产物（产出后需要进一步加工）吗？
  → Yes: "intermediate"
  → No:  继续

Q8:  它是终端工业材料（被其他配方作为原料消费）吗？
  → Yes: "refined_material"
  → No:  继续

Q9:  它是加工成形后的制成品（输入到组装/建造配方）吗？
  → Yes: "component"
  → No:  继续

Q10: 它被工人直接消费（食物/水/药品）吗？
  → Yes: "consumable"
  → No:  继续

Q11: 它是配方的强制副产物（主要价值在回收而非直接使用）吗？
  → Yes: "waste"
  → No:  回到 Q2——你可能定义了一个新的纯化合物
```

---

## 四、`composition` 字段规范

`composition` 是 MaterialIdentity 最核心的字段。不是"这个东西含有什么"，而是**"这个东西在反应方程式中的物质平衡等式"**。

### 基本约束

```
1. key 必须是本 MaterialIdentity 库中已存在的另一个 id。
   编译器验证：不存在悬空引用。
   → 定义顺序必须依赖有序：元素 → 纯化合物 → 矿物 → … → 废物。

2. value 是质量分数，范围 (0, 1]。
   所有 value 之和 = 1.0，容差 ±0.001。

3. 纯化合物自指——这是递归的基础情形。
   { H2SO4: 1.0 }

4. 废物中若存在大量未知组分，使用占位 key "other_impurities"。
   不使用 sum < 1 的"宽松模式"——占位 key 比特殊规则更干净。
```

### 各类别的示例

```
元素：
  { id: "Cu", composition: { Cu: 1.0 } }
  { id: "Fe", composition: { Fe: 1.0 } }

纯化合物：
  { id: "H2SO4", composition: { H2SO4: 1.0 } }
  { id: "H2O",   composition: { H2O: 1.0 } }
  { id: "CuSO4", composition: { CuSO4: 1.0 } }

矿物（化学计量比 → 质量分数）：
  { id: "chalcopyrite", composition: { Cu: 0.346, Fe: 0.304, S: 0.350 } }
    → CuFeS₂: 63.55 + 55.85 + 64.14 = 183.54
    → Cu: 63.55/183.54 = 0.346
    → Fe: 55.85/183.54 = 0.304
    → S:  64.14/183.54 = 0.350

定义溶液：
  { id: "sulfuric_acid_98pct", composition: { H2SO4: 0.98, H2O: 0.02 } }
  { id: "sulfuric_acid_10pct", composition: { H2SO4: 0.10, H2O: 0.90 } }

合金：
  { id: "brass_alpha_70cu30zn", composition: { Cu: 0.70, Zn: 0.30 } }

燃料（工业分析数据）：
  { id: "coal_anthracite", composition: {
      fixed_carbon: 0.92, volatile: 0.05,
      ash: 0.02, sulfur: 0.01
  }}

废物（含占位 key）：
  { id: "anode_slime_copper",  composition: {
      Cu: 0.18, Ag: 0.05, Au: 0.01, Se: 0.08,
      Pb: 0.10, other_impurities: 0.58
  }}
```

---

## 五、来源引用

```typescript
interface MaterialReference {
  /** 权威来源——此物质的"现实锚点" */
  primary: SourcePointer;

  /** 佐证来源——其他来源也记录了这个物质 */
  secondary?: SourcePointer[];

  /** 由几个原始来源记录合并而成。
   *  1 = 只有一个来源定义了它。
   *  >1 = 多个来源交叉验证后合并。
   *  如：硫酸可由 CAS + HS + PubChem + 历史文献共同描述 → merged_from=4。
   */
  merged_from: number;
}

interface SourcePointer {
  /** 来源名称 */
  source: SourceName;

  /** 该来源中的标识符 */
  id: string;

  /** 可选注释 */
  note?: string;
}

type SourceName =
  | "cas"        // CAS Registry Number — 化学物质的权威锚点
  | "pubchem"    // PubChem CID — 同义词库与结构数据
  | "ima"        // IMA 矿物编号 — 矿物的权威锚点
  | "mindat"     // Mindat — 伴生矿物、物理性质、产地
  | "uns"        // UNS 编号 — 金属合金的标准编号
  | "hs"         // HS 商品编码 — 工业商品的分类层级
  | "astm"       // ASTM 标准 — 燃料等级（D388 煤分类等）
  | "ewc"        // 欧洲废物名录 — 工业废物的标准代码
  | "historical" // 历史文献 — 古代名称映射（非定量来源）
  | "manual";    // 由游戏开发者手动定义 — 无权威来源对应的游戏特有物质
```

---

## 六、分离关注点——MaterialIdentity 不存储什么

| 数据 | 存储位置 | 分离原因 |
|------|---------|---------|
| **标签** (tags) | MaterialTag | 标签是游戏设计意见，不是物质身份。调整标签不应触及 ID 库。 |
| **物理属性** | MaterialProperty | 属性来自权威文献，数量庞大且全部可选。分开让 ID 库保持紧凑。 |
| **多语言名称** | MaterialName | 本地化团队独立工作。mod 翻译不碰物质定义。 |
| **经济数据** | MaterialBalance | 纯游戏设计数据。平衡调整最频繁，不应影响物质定义。 |
| **反应/配方** | ReactionRule | 反应是物质之间的外部关系。新工艺路线不应修改物质定义。 |

所有独立库通过 `material_id` 外键关联到 MaterialIdentity。MaterialIdentity 不引用任何其他库。

---

## 七、完整示例：铜的工业链

```
element:
  { id: "Cu", type: "element",        composition: { Cu: 1.0 },       formula: "Cu" }
  { id: "Fe", type: "element",        composition: { Fe: 1.0 },       formula: "Fe" }
  { id: "S",  type: "element",        composition: { S: 1.0 },        formula: "S" }
  { id: "O",  type: "element",        composition: { O: 1.0 },        formula: "O" }
  { id: "H",  type: "element",        composition: { H: 1.0 },        formula: "H" }
  { id: "C",  type: "element",        composition: { C: 1.0 },        formula: "C" }
  { id: "Au", type: "element",        composition: { Au: 1.0 },       formula: "Au" }
  { id: "Ag", type: "element",        composition: { Ag: 1.0 },       formula: "Ag" }
  { id: "Se", type: "element",        composition: { Se: 1.0 },       formula: "Se" }
  { id: "Zn", type: "element",        composition: { Zn: 1.0 },       formula: "Zn" }
  { id: "Sn", type: "element",        composition: { Sn: 1.0 },       formula: "Sn" }
  { id: "Pb", type: "element",        composition: { Pb: 1.0 },       formula: "Pb" }

pure_compound:
  { id: "H2SO4",       type: "pure_compound", composition: { H2SO4: 1.0 },       formula: "H₂SO₄" }
  { id: "H2O",         type: "pure_compound", composition: { H2O: 1.0 },         formula: "H₂O" }
  { id: "CuSO4",       type: "pure_compound", composition: { CuSO4: 1.0 },       formula: "CuSO₄" }
  { id: "CuSO4_5H2O",  type: "pure_compound", composition: { CuSO4_5H2O: 1.0 },  formula: "CuSO₄·5H₂O" }
  { id: "Fe2O3",       type: "pure_compound", composition: { Fe2O3: 1.0 },       formula: "Fe₂O₃" }
  { id: "Fe3O4",       type: "pure_compound", composition: { Fe3O4: 1.0 },       formula: "Fe₃O₄" }
  { id: "SiO2",        type: "pure_compound", composition: { SiO2: 1.0 },        formula: "SiO₂" }
  { id: "SO2",         type: "pure_compound", composition: { SO2: 1.0 },         formula: "SO₂" }
  { id: "CO2",         type: "pure_compound", composition: { CO2: 1.0 },         formula: "CO₂" }
  { id: "O2",          type: "pure_compound", composition: { O2: 1.0 },          formula: "O₂" }
  { id: "CaCO3",       type: "pure_compound", composition: { CaCO3: 1.0 },       formula: "CaCO₃" }
  { id: "CaO",         type: "pure_compound", composition: { CaO: 1.0 },         formula: "CaO" }
  { id: "Al2O3",       type: "pure_compound", composition: { Al2O3: 1.0 },       formula: "Al₂O₃" }
  { id: "SO3",         type: "pure_compound", composition: { SO3: 1.0 },         formula: "SO₃" }
  { id: "FeO",         type: "pure_compound", composition: { FeO: 1.0 },         formula: "FeO" }
  { id: "NaOH",        type: "pure_compound", composition: { NaOH: 1.0 },        formula: "NaOH" }
  { id: "NaCl",        type: "pure_compound", composition: { NaCl: 1.0 },        formula: "NaCl" }

mineral:
  { id: "malachite",    type: "mineral", composition: { Cu: 0.575, CO3: 0.195, OH: 0.175, H2O: 0.055 }, formula: "Cu₂CO₃(OH)₂" }
  { id: "azurite",      type: "mineral", composition: { Cu: 0.553, CO3: 0.245, OH: 0.123, H2O: 0.079 }, formula: "Cu₃(CO₃)₂(OH)₂" }
  { id: "chalcopyrite", type: "mineral", composition: { Cu: 0.346, Fe: 0.304, S: 0.350 },                formula: "CuFeS₂" }
  { id: "bornite",      type: "mineral", composition: { Cu: 0.633, Fe: 0.111, S: 0.256 },                formula: "Cu₅FeS₄" }
  { id: "chalcocite",   type: "mineral", composition: { Cu: 0.798, S: 0.202 },                           formula: "Cu₂S" }
  { id: "covellite",    type: "mineral", composition: { Cu: 0.665, S: 0.335 },                           formula: "CuS" }
  { id: "cuprite",      type: "mineral", composition: { Cu: 0.888, O: 0.112 },                           formula: "Cu₂O" }
  { id: "tenorite",     type: "mineral", composition: { Cu: 0.799, O: 0.201 },                           formula: "CuO" }
  { id: "native_copper", type: "mineral",composition: { Cu: 0.999 },                                     formula: "Cu" }
  { id: "hematite",     type: "mineral", composition: { Fe: 0.699, O: 0.301 },                           formula: "Fe₂O₃" }
  { id: "magnetite",    type: "mineral", composition: { Fe: 0.724, O: 0.276 },                           formula: "Fe₃O₄" }
  { id: "pyrite",       type: "mineral", composition: { Fe: 0.466, S: 0.534 },                           formula: "FeS₂" }
  { id: "galena",       type: "mineral", composition: { Pb: 0.866, S: 0.134 },                           formula: "PbS" }
  { id: "sphalerite",   type: "mineral", composition: { Zn: 0.671, S: 0.329 },                           formula: "ZnS" }
  { id: "cassiterite",  type: "mineral", composition: { Sn: 0.788, O: 0.212 },                           formula: "SnO₂" }
  { id: "limestone",    type: "mineral", composition: { CaCO3: 0.95, SiO2: 0.03, other: 0.02 },          formula: "CaCO₃" }

defined_solution:
  { id: "sulfuric_acid_98pct", type: "defined_solution", composition: { H2SO4: 0.98, H2O: 0.02 } }
  { id: "sulfuric_acid_10pct", type: "defined_solution", composition: { H2SO4: 0.10, H2O: 0.90 } }

alloy:
  { id: "brass_alpha_70cu30zn", type: "alloy", composition: { Cu: 0.70, Zn: 0.30 } }
  { id: "bronze_tin_88cu12sn",  type: "alloy", composition: { Cu: 0.88, Sn: 0.12 } }

fuel:
  { id: "coal_anthracite",    type: "fuel", composition: { fixed_carbon: 0.92, volatile: 0.05, ash: 0.02, sulfur: 0.01 } }
  { id: "coal_bituminous_hv", type: "fuel", composition: { fixed_carbon: 0.60, volatile: 0.30, ash: 0.06, sulfur: 0.03, moisture: 0.03 } }
  { id: "coal_lignite",       type: "fuel", composition: { fixed_carbon: 0.35, volatile: 0.25, ash: 0.10, sulfur: 0.02, moisture: 0.30 } }
  { id: "charcoal",           type: "fuel", composition: { fixed_carbon: 0.85, volatile: 0.10, ash: 0.03, moisture: 0.02 } }
  { id: "coke",               type: "fuel", composition: { fixed_carbon: 0.90, ash: 0.08, sulfur: 0.02 } }

intermediate:
  { id: "matte_copper",   type: "intermediate", composition: { Cu: 0.50, Fe: 0.25, S: 0.25 } }
  { id: "blister_copper", type: "intermediate", composition: { Cu: 0.98, O: 0.005, S: 0.005, other_impurities: 0.01 } }
  { id: "cement_copper",  type: "intermediate", composition: { Cu: 0.90, Fe: 0.05, other_impurities: 0.05 } }
  { id: "pig_iron",       type: "intermediate", composition: { Fe: 0.94, C: 0.04, Si: 0.01, Mn: 0.005, S: 0.003, P: 0.002 } }

refined_material:
  { id: "copper_cathode_9999", type: "refined_material", composition: { Cu: 0.9999 } }
  { id: "soda_ash",            type: "refined_material", composition: { Na2CO3: 0.99, NaCl: 0.005, other_impurities: 0.005 } }

component:
  { id: "copper_wire", type: "component", composition: { Cu: 0.999 } }
  { id: "copper_pipe", type: "component", composition: { Cu: 0.999 } }
  { id: "iron_gear",   type: "component", composition: { Fe: 0.995, C: 0.004 } }

waste:
  { id: "slag_copper_smelting", type: "waste", composition: { FeO: 0.40, SiO2: 0.35, CaO: 0.10, Al2O3: 0.08, Cu: 0.01, other_impurities: 0.06 } }
  { id: "anode_slime_copper",   type: "waste", composition: { Cu: 0.18, Ag: 0.05, Au: 0.01, Se: 0.08, Pb: 0.10, other_impurities: 0.58 } }
  { id: "tailings_flotation",   type: "waste", composition: { SiO2: 0.55, Fe: 0.20, S: 0.05, Cu: 0.005, moisture: 0.15, other_impurities: 0.045 } }
  { id: "fly_ash_coal",         type: "waste", composition: { SiO2: 0.55, Al2O3: 0.25, Fe2O3: 0.08, CaO: 0.05, SO3: 0.03, other_impurities: 0.04 } }

// 占位 key —— 废物中未知/不追踪的组分
  { id: "other_impurities",     type: "waste", composition: { other_impurities: 1.0 } }
```

---

## 八、与其他库的关系

```
MaterialIdentity
  (物质身份 — 配方的类型签名)
  │
  ├── material_id 被以下库引用（外键）：
  │
  ├── MaterialTag        (material_id → tags[])
  │     "这个物质在游戏分类中属于什么"
  │
  ├── MaterialProperty   (material_id → 物理/化学常数)
  │     "这个物质客观可测量的是什么"
  │
  ├── MaterialName       (material_id → 多语言名称+历史别名)
  │     "这个物质在不同语言/历史时期叫什么"
  │
  ├── MaterialBalance    (material_id → 价格/时代/战略物资)
  │     "这个物质在游戏经济中值多少"
  │
  └── ReactionRule       (引用 material_id 或 tag)
        "这个物质能参与什么反应"
        ← 注意：ReactionRule 是唯一"反向"引用 MaterialIdentity 的——
          它通过 tag 或 material_id 匹配，不受 MaterialIdentity 内部结构影响
```

---

## 九、编译器中的位置

回忆之前讨论的五层编译器架构，MaterialIdentity 是 Layer 4（Merger）的最终产出：

```
sources/cas/      ──→ CasNormalizer      ──→ normalized/
sources/pubchem/  ──→ PubChemNormalizer  ──→ normalized/
sources/ima/      ──→ ImaNormalizer      ──→ normalized/
sources/mindat/   ──→ MindatNormalizer   ──→ normalized/
sources/uns/      ──→ UnsNormalizer      ──→ normalized/
sources/hs/       ──→ HsNormalizer       ──→ normalized/
sources/astm/     ──→ AstmNormalizer     ──→ normalized/
sources/ewc/      ──→ EwcNormalizer      ──→ normalized/
sources/historical/──→ HistNormalizer    ──→ normalized/
                                              │
                    ┌─────────────────────────┘
                    ▼
            CrossReferenceResolver (跨来源匹配 + 分组)
                    │
                    ▼
                RecordMerger (多来源记录 → MaterialIdentity)
                    │
                    ▼
            MaterialValidator (验证悬空引用 + composition sum + 依赖顺序)
                    │
                    ▼
            output/material_identity.json (最终产物，随游戏发布)
```

MaterialIdentity 是所有独立库（Tag、Property、Name、Balance、ReactionRule）的基础——它们都通过 `material_id` 引用它。

---

> **本文档为讨论记录，内容将持续更新。**
> 关联文档：[工业化模拟游戏设计讨论](industrial-simulation-game-design.md) · [物质命名来源参考](material-naming-sources.md)

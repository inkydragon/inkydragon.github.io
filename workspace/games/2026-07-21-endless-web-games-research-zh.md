# 适用于移动端小程序嵌入的程序化生成无尽游戏：综合调研报告

## 1. 执行摘要

本报告综合了对约 180 个原始游戏条目（横跨 6 个类别）的详尽调查结果，经过去重后保留 65 个独立实现，旨在识别最适合移动端小程序（微信/支付宝）嵌入、具有无尽可重玩性和程序化生成能力的游戏类型。

**核心发现：** 最适合此目标用例的游戏类型是**原生竖屏、单点触控、Canvas 2D（二维画布）游戏，零外部资源、程序化生成内容**。单文件 HTML5 Canvas + 原生 JS 范式（以太空爆破：进化（Space Blaster: Evolved）、飞翔火箭（Flappy Rocket）和 oreore-rhythm 为代表）是移植性最强的架构——可直接映射到微信小游戏 API（应用程序接口），仅需最少量的适配工作。

### 快速对比表

| 游戏类型 | 移动端适配评分 | 屏幕方向 | 复杂度 | 小程序适配度 |
|---|---|---|---|---|
| 竖屏垂直射击 / 无尽波次生存 | 10 | 竖屏 | 中高 | 高 |
| 竖屏无尽飞行（飞扬的小鸟风格） | 10 | 竖屏 | 中 | 高 |
| 无尽跑酷节奏混合（钢琴块风格） | 10 | 竖屏 | 低中 | 高 |
| 3D 赛道无尽跑酷 | 8 | 横屏 | 中 | 中 |
| 程序化音频生存竞技场 / 弹幕天堂 | 9 | 横屏 | 中高 | 中 |
| 2D 横向卷轴无尽跑酷 | 8 | 横屏 | 中 | 高 |
| 3D 滚球/隧道跑酷 | 9 | 横屏/双方向 | 中高 | 中 |
| 竖屏无尽垂直跳跃 / 平台跳跃 | 9 | 竖屏 | 中 | 高 |
| 2D 程序化驾驶 / 公路赛车 | 9 | 横屏 | 中 | 高 |
| 浏览器内置无尽跑酷（Chrome小恐龙） | 9 | 横屏 | 低 | 高 |
| 滑块拼图 / 数字合成（2048） | 10 | 竖屏 | 中 | 高 |
| 物理合成掉落（西瓜游戏） | 9 | 竖屏 | 低中 | 中 |
| 无尽街机消除（俄罗斯方块） | 8 | 竖屏 | 中 | 中 |
| 无尽三消 / 方块交换 | 10 | 竖屏 | 中 | 高 |
| 无尽网格跳跃（天天过马路） | 9 | 竖屏 | 中 | 高 |
| 益智 / 逻辑网格程序化生成（数独/数织） | 9 | 双方向 | 中高 | 高 |
| 无尽街机波次射击（极简） | 7 | 双方向 | 低中 | 高 |
| 伪3D / 自研引擎无尽跑酷 | 8 | 双方向 | 高 | 低 |
| 程序化生物群系平台跑酷 | 7 | 横屏 | 高 | 低 |
| 音频驱动玩法生成（节奏+平台） | 5 | 不确定 | 高 | 低 |

---

## 2. 游戏类型深度解析

### 2.1 竖屏垂直射击 / 无尽波次生存

**描述与吸引力：** 一款俯视射击游戏，玩家操控飞船向上移动穿越无尽敌机波次。移动端优先的竖屏设计（390x844 逻辑分辨率）使其非常适合单手操作。触摸拖拽移动配合自动射击，消除了对第二只手或开火按钮的需求。

**核心无尽机制：** 无尽波次推进，每 5 波出现首领。每 3 波可选择一个 Roguelike 升级（3 选 1）。通过持久化水晶货币实现元进度成长（meta-progression）。15 项成就和 5 艘可解锁飞船提供长期参与动力。

**程序化生成方案：** 从加权稀有度池中随机选择升级项（普通权重=5，稀有=3，史诗=1）。基于波次门槛的敌机类型解锁表：第 1-2 波仅包含基础敌机，第 3-4 波增加锯齿和集群类型，第 5-7 波增加神风特攻和坦克类型，第 8-11 波增加分裂、护盾和狙击类型，第 12 波及以上包含全部 8 种类型，等权重。五种视觉区域每 5 波循环切换，以重置玩家的视觉疲劳感。

**难度缩放设计：**
- 敌机 HP（生命值）：`base + floor(wave / 3)`（每 3 波阶梯式增长）
- 敌机速度：`base + wave * 0.03`（渐进线性递增）
- 生成间隔：`max(300ms, 1300ms - wave * 40ms)`（线性递减，300ms 下限）
- 每波敌机数量：`5 + (wave - 1) * 2`
- 首领 HP：`base + wave * 8`，附带狂暴机制（HP 低于 30% 时射速翻倍）
- XP（经验值）升级：`100 * 1.15^level`（指数增长，使玩家战力与敌人强度之间的差距逐渐扩大）

**屏幕方向处理：** 固定竖屏锁定（390x844 逻辑分辨率，所有屏幕尺寸采用 CSS（层叠样式表）整数缩放）。横屏支持通过竖屏内嵌信箱模式实现，游戏区域居中，两侧填充黑色边栏。不建议为横屏重新设计。

**移动端专项考量：**
- 相对拖拽触摸输入（基于增量而非绝对位置），防止手指遮挡
- 对象池固定上限（300 颗子弹，400 个粒子），消除 GC（垃圾回收）卡顿
- 增量时间（delta-time）归一化，3 倍上限防止标签页重新聚焦时的物理爆炸
- 零外部资源——所有精灵图和音效均程序化生成
- CSS 信箱模式配合 `image-rendering: pixelated` 实现整数缩放
- 双区触摸布局：左侧 60% 用于移动，右侧 40% 用于开火

**小程序可行性：高。** Canvas 2D API 完全兼容。Web Audio API（网页音频接口）需适配为 `wx.createWebAudioContext()`。包体大小远低于 4MB 限制（约 50-100KB）。零外部资源是巨大优势。分包策略：主包（核心循环，前 3 个区域），分包 1（其余内容），分包 2（元进度 UI）。

**参考游戏：**
- **太空爆破：进化（Space Blaster: Evolved）**（waseemnasir2k26/Space-Blaster）——旗舰参考，单个 index.html（约 690 行），移动端优先
- **三角洲打击（Delta-Strike）**（eldermoraes/Delta-Strike）——支持 PWA（渐进式网页应用），含 Service Worker，Apache 2.0 协议，基于确定性和子的河流生成
- **太空拥堵（Space-Jam）**（DanMat/Space-Jam）——Supabase 排行榜，MIT 协议
- **蜂巢坠落（Hivefall）**（aimanh2250-lab/hivefall）——零依赖，程序化像素美术，VIVID 图形，可接入 WebSocket 合作模式

**技术栈：** 原生 JavaScript ES6+，HTML5 Canvas 2D，Web Audio API，单个 index.html（约 690 行），零依赖，零构建步骤。

---

### 2.2 竖屏无尽飞行 / 飞扬的小鸟风格（全程序化资源）

**描述与吸引力：** 点击/轻触对抗重力向上推进，穿越随机间隙位置的垂直滚动柱状障碍物。每通过一个间隙得 1 分。"全程序化资源"变体在运行时以程序化方式生成所有视觉元素（玩家角色、障碍物、背景、环境）和音频——零外部图片或音频文件。

**核心无尽机制：** 每通过一个间隙 = 1 分。碰到障碍物或地面边界则结束本轮。通过持久化在 localStorage 中的金币实现元进度成长，可在线内商店中解锁 15 款火箭皮肤和 10 种环境。

**程序化生成方案：**
- **随机垂直间隙定位：** `gapTop = Math.random() * (maxTop - minTop) + minTop`，约束与屏幕高度成比例
- **Canvas 2D 程序化火箭绘制：** 每帧使用路径操作绘制 15 种不同的火箭设计——火焰形状随机变化以产生有机闪烁效果
- **Web Audio API 程序化音效合成：** 所有音效（拍翅、得分、碰撞、菜单点击、背景音乐）通过 OscillatorNode + GainNode 配合频率扫描和 LFO（低频振荡器）调制生成
- **递归分形树生成**（404扑翼鸟（404 FlappingBird））：通过深度为 5 的递归分支、角度偏移和 5 色调色板集生成树木
- **环境专属粒子系统：** 10 种环境各具独特的粒子行为（星星、雪花、余烬、扫描线），根据画质等级控制粒子数量上限
- **位置重置对象池：** 预分配 3-4 对管道对象，滚出屏幕后通过位置重置循环利用

**难度缩放设计：**
- **多模式静态预设：** 普通（1x 速度），困难（1.2x 速度，0.82x 间隙），疯狂（1.45x 速度，0.65x 间隙）
- **10+ 自动递进等级：** 速度递增通过 `baseSpeed * (1 + level * speedIncrementPerLevel)` 实现，间隙缩小通过 `baseGap * max(minGapRatio, 1 - level * gapReductionPerLevel)` 实现
- **速度-间隙耦合：** 管道水平间距随速度增加自动变宽，防止出现无法通过的配置
- **二次/指数自适应缩放：** `speed = baseSpeed * (1 + 0.02 * score)^exponent`，其中 exponent < 1，确保边际难度递减

**屏幕方向处理：** 竖屏为主（垂直柱状间隙）。横屏通过 CSS 响应式宽度（30-100%）配合全高信箱模式支持。所有游戏尺寸从 viewHeight 推导，确保不同屏幕方向下难度一致。

**移动端专项考量：**
- HiDPI Canvas 缩放，使用 `devicePixelRatio` 设置后台缓冲分辨率
- 触摸输入去抖动，通过上升沿检测防止双击触发
- FPS（帧率）分层系统：低（30 FPS）、中（60 FPS）、高（无上限）
- 间隙大小与屏幕高度成比例（绝不使用固定像素值）
- 低端设备通过画质等级变量限制粒子数量上限
- Canvas 清除优化：每帧绘制背景填充而非调用 `clearRect`

**小程序可行性：高。** 已验证的品类，存在微信小游戏实现（iFangcy/flappybird-miniapp）。Canvas API 直接对应。包体大小在 500KB 以内。Web Audio 合成支持有限——可将短音频片段预合成为 base64 Data URI。屏幕方向锁定通过 `game.json: "deviceOrientation": "portrait"` 实现。

**参考游戏：**
- **飞翔火箭（Flappy Rocket）**（CodeCanyon）——商业精品，零 npm，全程序化视觉和音频，约 $19
- **cocos-creator-demo/cocos-flappy-bird**——Cocos Creator 官方演示，跨平台微信小游戏部署
- **iFangcy/flappybird-miniapp**——微信小游戏飞扬的小鸟，MIT 风格协议
- **js13kGames/404-flappingbird**——PWA/离线基准，总大小 <13KB，含 Service Worker，分形树障碍物

**技术栈：** Flappy Rocket：原生 JS + Canvas 2D（零依赖）。飞扬的小鸟变体：Cocos Creator，原生 JS + Canvas，PhaserJS 用于微信小游戏。PWA 变体：Service Worker + manifest.json。

---

### 2.3 无尽跑酷节奏混合 / 钢琴块风格

**描述与吸引力：** 方块向下滚动，玩家仅点击黑色方块，避开白色方块。无尽模式配合递增滚动速度。点击方块时播放音乐。该品类的核心吸引力在于交互的简洁性与令人满足的视听反馈循环。oreore-rhythm 在此基础上扩展，增加了应答机制（call-and-response）、需忽略的陷阱节拍以及休止提示。

**核心无尽机制：** 钢琴块：受音乐时间网格约束的随机方块列位置。黑白方块逐行生成。基于歌曲的模式使用预制谱面方块；无尽模式使用随机生成。oreore-rhythm：第 2 阶段题目每次游戏会话从数学/语言模板全新生成。

**程序化生成方案：**
- 每行单黑块约束：每行在 4 列中随机放置恰好 1 个（或 N 个）黑块——通过构造保证可解性
- 种子化 32 位 LCG（线性同余生成器）（oreore-rhythm）：`rngState = (state * 1664525 + 1013904223) >>> 0`——可通过 `?seed=` URL 参数设置种子，实现确定性回放
- 模式池配合程序化诱饵注入：6 种命名节奏模式，附带诱饵添加（30% 概率）、削减（25% 概率）和"忍耐"休止插入（约 25% 概率）
- 基于类别的问答题生成：4 个类别（奇偶性、整除性、假名行列匹配），配有参数化生成器
- 基于噪声的音频合成：所有音频通过 WebAudio 振荡器程序化合成——底鼓、踩镲、提示音、低音线、掌声

**难度缩放设计：**
- 阻尼双曲正割平方增长：`mode.speed += 0.01 * sech_squared(time() / 100)`，硬上限为 8.5
- 替代模式：耐力模式（恒定速度 3.5），随机速度模式（混乱），极速模式（起始即 4x 基础速度）
- oreore-rhythm：BPM（每分钟节拍数）选择（110/130/150/170），加速模式（每题 +6 BPM，上限 +48），可调判定窗口（"JUST"评级的 50-180ms），延迟偏移校准（-200ms 至 +250ms）

**屏幕方向处理：** 竖屏优先设计（4 列垂直布局，单拇指点按）。oreore-rhythm 确认横屏握持（"よこもちOK"），提供三种摇杆侧选项：底部（竖屏拇指），右侧（横屏右手拇指），左侧（横屏左手拇指）。动态缩放，无屏幕方向锁定。`viewport-fit=cover` 实现全面屏（刘海屏下方）全屏。

**移动端专项考量：**
- 使用 Pointer Events（而非 click/touchstart）实现零延迟点按检测
- DPR（设备像素比）上限为 2，防止 3x/4x 屏幕渲染 4 倍像素
- 激进的 viewport meta 标签：`user-scalable=no, viewport-fit=cover` + `touch-action: none`
- AudioContext 生命周期管理：`visibilitychange` / `pagehide` 处理器挂起/恢复音频上下文
- 延迟校准滑块，用于蓝牙音频补偿
- 安全区域安全边距通过 `env(safe-area-inset-bottom)` 实现
- 游戏过程中无 DOM（文档对象模型）操作——所有视觉内容在 Canvas 上绘制

**小程序可行性：高。** 最适合小程序的游戏类型之一。单文件 Canvas 游戏配合合成音频体积约 70KB。自基础库 2.9.0+ 起完整支持 Canvas 2D API。关键差异：小程序中**没有 Web Audio API**。必须使用 `wx.createInnerAudioContext()` 进行播放，并使用基于 `performance.now` 的时钟替代 `AudioContext.currentTime`。预录制的短音频样本替代实时合成。延迟影响：50-100ms 音频延迟不可避免。

**参考游戏：**
- **oreore-rhythm**（ozaki-taisuke）——单文件 HTML5 应答节奏游戏，约 1250 行，约 70KB，公有领域
- **tap-the-black-tiles**（316k）——15+ 游戏模式，MIT，约 700 行
- **react-piano-tiles**（cirocosta）——React + Flux 架构，27 stars
- **famous-white-tile-firebase**（IjzerenHein）——Firebase 实时多人，17 stars

**技术栈：** 原生 JS + Canvas（钢琴块复刻）。oreore-rhythm：单个 HTML 文件，Canvas，Web Audio API，无框架，无构建步骤。

---

### 2.4 3D 赛道无尽跑酷（地铁跑酷风格）

**描述与吸引力：** 自动向前移动穿越 3D 城市，支持三赛道切换（左/右）、跳跃（上）和滑铲（下）。收集金币得分。碰撞则结束本轮。3D 透视带来了 2D 跑酷无法实现的视觉深度和沉浸感。

**核心无尽机制：** 三赛道系统，基于滑动的赛道切换。跳跃越过低矮障碍物，滑铲穿过高杆障碍。金币收集路径引导玩家走安全赛道。基于 Three.js 的单文件 HTML 架构。

**程序化生成方案：**
- 距离门控确定性生成：当生成游标超过阈值且前一批障碍物已充分落后于摄像机时，生成障碍物
- 赛道约束随机选择：从 3 条赛道中选择 1-2 条，障碍物类型从数组中随机选取
- 前向生成并回收的对象池：预分配对象，通过将 Z 位置重置到玩家前方实现回收
- 通过随机化放置（树木、建筑、车辆）生成场景——不使用 Perlin 噪声或 WFC（波函数坍缩）
- Canvas 程序化地面纹理含车道标记，通过 `texture.offset.y` 递增实现滚动

**难度缩放设计：**
- 线性速度递增：`speed = min(MAX_SPEED, BASE_SPEED + distance * 0.045)`，含硬上限
- 得分累积：`score += speed * dt * 1.6`（距离加权）
- 摄像机 FOV 动态从 62 度扩大到 76 度，强化速度感知
- 速度 HUD（抬头显示）进度条映射到 20%-100% 填充范围，为玩家提供反馈

**屏幕方向处理：** 锁定横屏（竖屏时通过 CSS `@media` 显示警告覆盖层）。自适应摄像机 FOV 作为混合方案：竖屏时减小赛道宽度间距并将摄像机移高移远。真正的双方向支持需要两套完整的摄像机预设，配合平滑线性插值过渡（约 300ms）。

**移动端专项考量：**
- 触摸滑动检测：30px 死区阈值，通过比较 abs(deltaX) 与 abs(deltaY) 判断水平/垂直
- body 上设置 `touch-action: none` 以抑制浏览器手势
- `maximum-scale=1, user-scalable=no` viewport 以防止双指缩放
- Three.js `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))` 以限制 GPU（图形处理器）像素填充率
- 性能预算：限制绘制调用次数，阴影贴图分辨率上限 2048x2048，FogExp2 实现自然剔除，对象池实现零 GC 压力

**小程序可行性：中。** Three.js 压缩版（约 140KB gzip）可放入 4MB 主包限制。微信通过 `wx.createCanvasContext()` 支持 `<canvas type="webgl">`。关键限制：Web Audio API 不可用（必须使用 `wx.createInnerAudioContext()`），无 DOM 用于 UI（必须在 Canvas 上渲染所有内容），无 Service Workers（使用微信缓存 API）。裂隙奔跑者（Rift Runner）基于振荡器的音效合成必须用预录音频文件重写。

**参考游戏：**
- **无尽奔跑者3D（Endless-Runner-3D）**（manuka-rashen）——简洁 Three.js，单文件 HTML，16 stars，MIT 隐含协议
- **裂隙奔跑者（Rift Runner）**（KomaliAndhe）——赛博朋克主题，模块化 JS，Web Audio 合成，2 stars

**技术栈：** Three.js（WebGL），HTML5，CSS3，JavaScript ES6 Modules。单文件架构。Rift Runner 增加 Web Audio API + localStorage + Netlify。

---

### 2.5 程序化音频生存竞技场 / 弹幕天堂

**描述与吸引力：** 俯视生存游戏，玩家自动攻击最近的敌人，收集 XP 宝石，升级，并从 3 个随机升级中选择 1 项。每 3 分钟出现首领。多种敌机类型包含精英变体。持久化货币实现元进度成长。该品类的吸引力在于随着敌人潮不断升级，玩家获得越来越强大力量所带来的爽快感。

**核心无尽机制：** 自动攻击，目标锁定最近敌人。连杀连击。XP 收集和升级选择。带无敌帧的闪避冲刺。每 3 分钟首领战。持久化货币元进度成长。

**程序化生成方案：**
- **所有音乐程序化合成：** 5 种生物群系具有独特的调性/速度/音色，过渡时交叉淡入淡出。预判式音频调度器提前约 100ms 将 Web Audio 事件加入队列。带 LFO 调制的分层振荡器。
- **所有视觉内容程序化渲染：** Canvas 发光通过预渲染径向渐变精灵配合 `globalCompositeOperation = 'lighter'` 合成（不使用 `ctx.shadowBlur`——速度慢 10 倍）。敌人死亡时粒子爆发。通过正弦波摄像机偏移实现屏幕震动。
- **生物群系过渡系统：** 5 种环境每 60-120 秒循环切换，配备程序化调色板、环境粒子和独特的音频音色——均为同一旋律轮廓在不同调性上的变奏
- **波次指挥系统：** 10 个命名首领战窗口，具有特定的敌人组合
- **种子化 RNG（随机数生成器）用于速通和每日挑战模式**

**难度缩放设计：**
- 生成间隔：13 分钟内从 1.1s 递减到 0.16s（双曲线/倒数衰减）
- 新敌人类型在固定时间阈值解锁，产生离散难度跃升
- 敌人 HP 和速度遵循每分钟平缓曲线（配置文件常量，非硬编码）
- 首领 HP 倍率每周期递增（1.0x, 1.5x, 2.2x, …）
- 阶段修饰器施加乘法难度（如冻原：玩家速度 -10%，敌人 HP +20%）

**屏幕方向处理：** 仅横屏门控（霓虹生存竞技场（Neon Survival Arena）在设备旋转至横屏前阻止游戏开始）。推荐：响应式竞技场配合双布局 HUD（游戏 Canvas 通过摄像机/视口适配，HUD 根据屏幕方向重新定位）。竖屏时小地图补偿以揭示屏幕外敌人。

**移动端专项考量：**
- 双虚拟摇杆：左（移动），右（瞄准）
- 右下角专用 DASH 按钮，可见暂停按钮
- 触觉反馈通过 `navigator.vibrate` 实现
- 屏幕唤醒锁定通过 `navigator.wakeLock.request('screen')` 实现
- "减少特效"开关适用于低端设备
- 空间哈希（64px 网格）实现 O(n*k) 碰撞检测，替代 O(n²)
- 实体交换移除模式（与末尾交换 + pop），避免 O(n) 数组移位
- Canvas-in-React 分离：游戏循环在 `useRef` 持有的 Canvas 中运行，模拟层绝不分配 React 状态

**小程序可行性：中。** Canvas 2D API 完全支持。`wx.createWebAudioContext()` 可用于程序化音频合成（基础库 2.19.0+）。关键限制：无 Service Workers/PWA，无 Wake Lock API（使用 `wx.setKeepScreenOn()`），无 Gamepad API，Supabase 客户端 SDK（软件开发工具包）可能无法工作（必须使用微信云 API）。2MB 主包限制——零资源程序化游戏轻松适配（<500KB）。

**参考游戏：**
- **霓虹生存竞技场（Neon Survival Arena）**（dennis299）——React 19 + 原生 Canvas，5 种生物群系，完整移动端支持，MIT
- **canvas-vampire-survivors**（ricardo-foundry）——零依赖原生 JS ES2022，241+ 单元测试，MIT

**技术栈：** Neon Survival Arena：React 19，Vite，TypeScript，HTML5 Canvas，Web Audio API，Supabase，PWA。canvas-vampire-survivors：原生 JS ES2022，HTML5 Canvas（零依赖）。

---

### 2.6 难度设计精良的 2D 横版无尽跑酷（Side-Scrolling Endless Runner）

**玩法描述与吸引力：** 玩家固定在屏幕 x 坐标位置，场景自动向左卷轴滚动，通过程序化放置的障碍物。按住/松开实现可变高度的跳跃（提前松开可缩短跳跃弧线）。支持二段跳。三种障碍物按加权概率出现。其吸引力来自精确且文档完备的难度公式，使游戏感觉公平且可预判。

**核心无尽机制：** 自动横向卷轴滚动。可变高度跳跃（按住时长决定高度），二段跳。三种障碍物类型：地面尖刺（45%）、头顶障碍（30%）、地面缺口（25%）。金币沿抛物线轨迹生成（70% 概率）。连击系统：每连续收集 3 个金币 = +0.5x 倍率，上限 5x。

**程序化生成方案：**
- 带冷却约束的加权随机选择：根据概率表掷 0-100 范围随机数，强制障碍物类型之间的最小冷却间隔，验证是否违反不可行排列规则手册
- 抛物线轨迹放置：沿二次曲线 `y(t) = -(1 - t^2) * amplitude` 放置 5 个金币，水平间距 30px
- 滑动窗口式的瓦片回收：地面段每帧向左移动，移出屏幕时移除，在右边缘生成——摊销 O(1) 的创建/销毁操作
- 难度门控的内容解锁状态机：障碍物类型可用性在预定义的分数/速度阈值处发生变化，每次过渡均有视觉反馈

**难度缩放设计（在所有调研案例中文档最详尽）：**
- 速度：初始值 260px/s，每 4 秒 +3，上限 520px/s（~6 分钟达到最大值）
- 生成间隔压缩因子：基准速度时为 1.0，最大速度时为 0.7（障碍物间距缩小 30%）
- 复合效应：两个线性因子相乘，产生二次方难度曲线
- 有效反应窗口从 ~1.5 秒缩小到 ~0.5 秒
- `speed(t) = min(520, 260 + 3 * t/4)`
- `spawnGap = random(320, 520) * (1.0 - 0.3 * (speed - 260) / 260)`

**屏幕方向处理：** 锁定横屏，配合响应式 FIT 缩放（800x480，5:3 比例）。三级回退方案：(1) 理想横屏锁定——通过 Screen Orientation API（屏幕方向 API）；(2) 响应式 FIT 缩放并添加留黑边；(3) 竖屏重新布局，降低速度因子并显示轻柔的旋转提示。

**移动端专项考量：**
- 统一的指针 API（pointerdown/pointerup）实现触摸优先设计
- Phaser.Scale.FIT + CENTER_BOTH 实现自动留黑边
- 通过增量时间归一化（固定时间步长累加器）实现帧率无关
- 对象池（Object Pooling）管理障碍物、金币、粒子、地面瓦片
- 单物理碰撞体策略：一个不可见的静态矩形作为地面，缺口处切换开关
- SVG data URI 资源：零网络请求获取美术资源，整个游戏为单个 HTML + JS 包

**小程序可行性：高。** 最适合小程序部署的方案。使用 SVG data URI 后游戏总体积 <500KB。Canvas 2D（二维画布）API 完全兼容。Phaser 3 需要为小程序编写兼容适配层——推荐方案：Web 端使用 Phaser，小程序端重写渲染层，或使用 Cocos Creator 自带的原生小程序导出功能。推荐架构：共享 `game-core.ts`，Web 和小程序各自实现渲染器。

**参考游戏：**
- **Forest Runner**（GeneralistProgrammer）—— Phaser 3 + TypeScript + Vite 教程，难度公式文档最详尽
- **DinoX**（hardik-321）—— 原生 JavaScript ES6（ES6 模块），模块化架构，MIT 许可，部署于 GitHub Pages
- **Chrome Dino（T-Rex 跑酷）**—— 经典参考，Chromium 源码，约 2000 行原生 JavaScript

**技术栈：** Forest Runner：Phaser 3、TypeScript、Vite、Arcade Physics。DinoX：原生 JavaScript ES6 Modules、HTML5 Canvas（HTML5 画布）、CSS3（层叠样式表第3版）、GitHub Pages。

---

### 2.7 3D 滚球/隧道跑酷（3D Ball/Tunnel Runner）（商业级，移动端优化）

**玩法描述与吸引力：** 一个带挤压/拉伸物理效果的 3D 滚球，在程序化生成的环境中向前奔跑；或一架无人机穿越霓虹隧道。双模式：无尽模式（无限程序化生成）和关卡模式（可解锁关卡）。4 种道具、3 种障碍物类型、12 项成就。3D 视角和隧道纵深营造沉浸式感官体验。

**核心无尽机制：** 3D 向前奔跑或隧道视角。切换跑道或径向移动。基于速度计分。碰撞即游戏结束。商业级品质，包含元进度（meta-progression）、道具和成就系统。

**程序化生成方案：**
- 段/块循环：固定长度的隧道走廊（140 单位）向前滚动；经过相机后方的段重置到前方——无需动态几何体即可实现无限滚动
- 径向隧道段生成：16 边形截面，每段按概率 `1 - holeProb` 放置墙壁
- 基于 Fisher-Yates 洗牌算法的跑道生成：3 条跑道，每行随机封堵 1-2 条，保证至少有一条可通行
- 程序化音频生成：基于节拍调度（108 BPM（每分钟节拍数）），和弦进行 A-F-C-G，分层振荡器，低通滤波器截止频率随速度提升而升高，产生"渐强"音频张力
- 颜色循环/HSL（色相-饱和度-亮度）渐变：随分数增长，墙体和边缘颜色在 HSL 色彩空间中循环，场景背景色平滑过渡到新目标颜色

**难度缩放设计：**
- 带上限的线性速度增长：`speed = baseSpeed + Math.min(elapsed * rampRate, maxSpeedIncrease)`
- 速度 + 生成间隔双曲线：线性速度增长 + 逐渐缩短的生成间隔，产生乘法型难度
- 难度层级选择（Neon Runner）：普通（速度 20，空洞概率 15%）、困难（25，25%）、极限（32，40%）
- 通过加速道具实现自愿风险/收益选择：5 倍速度持续 5 秒，2 倍分数倍率

**屏幕方向处理：** A 型（向前奔跑视角）：锁定横屏。B 型（隧道视角）：同时支持两种方向，相机/FOV 微调。微信小程序：使用 `wx.onDeviceOrientationChange()` 检测方向，渲染 `wx.createCanvas()` 填满可用屏幕。PWA（渐进式 Web 应用）清单：根据子类型设置 `"orientation": "landscape"` 或 `"portrait"`。

**移动端专项考量：**
- 点击区域切换跑道（比滑动手势检测延迟更低）
- Viewport meta 标签设置 `user-scalable=no, viewport-fit=cover`
- 像素比（DPR（设备像素比））上限为 2
- 增量时间上限限制，防止标签页重新聚焦时物理引擎爆炸
- 几何体和网格实例使用对象池
- 帧预算：目标 30-60 FPS（每秒帧数），使用视锥体裁剪（FrustumCulling），避免阴影贴图，最小化后处理
- 通过 Web Audio API（Web 音频 API）程序化合成，零静态音频资源

**小程序可行性：中等。** Three.js 必须通过社区维护的移植版本适配。微信完整支持 WebGL 1.0。关键挑战：无标准 DOM（文档对象模型）API——Three.js 必须作为模块打包，将 `document.createElement('canvas')` 替换为 `wx.createCanvas()`。程序化音频的优势无法继承——Web Audio API 不可用，必须使用预录制音频文件。代码包 1-3 MB 在限制范围内。建议 fork 一个 Three.js 微信适配器（`weapp-adapter.js` 模式），将所有基于 DOM 的 UI 替换为 Canvas 等效实现。

**参考游戏：**
- **Velocity Run**（CodeCanyon）—— 商业级，单个 HTML 文件，程序化音乐，~$10-18
- **Neon Drone Rush**（CodeCanyon）—— 商业级，60 FPS 优化，兼容 WebView/Cordova，~$19
- **void-runner**（shadikulhossan）—— 开源 MIT，单文件 HTML，Three.js r128，合成波风格配乐，PWA
- **Neon Runner**（zzerodesigns）—— 开源，径向隧道生成，16 边形段截面

**技术栈：** Three.js（WebGL（Web 图形库））、HTML5、JavaScript ES6+、单文件 HTML。Velocity Run 额外使用 Web Audio API 实现程序化音乐。

---

### 2.8 竖屏无尽垂直平台跳跃（Portrait Endless Vertical Platformer / Jumper）

**玩法描述与吸引力：** 玩家角色在程序化放置的平台上向上弹跳。倾斜设备控制左右方向，点击跳跃。墙壁反弹连击。崩塌平台、巡逻敌人、导弹波。五个阶段化的难度层级，然后进入无尽阶段。纵向攀升营造强烈的渐进感。

**核心无尽机制：** RISING：5 个阶段层级（地面零点 → 红色警戒 → 弹幕 → 铁穹 → 传奇），然后进入无尽阶段。涂鸦跳跃（Doodle Jump）：带垂直间距约束的平台（保证可达），高度里程碑处更换主题。Cliff Escape：单手攀爬，旋转抓取岩石，水面上升。

**程序化生成方案：**
- 带重叠拒绝的约束随机放置（RISING）：20 次重试循环，检查水平重叠（margin=10px）
- 难度参数收窄：`state.difficulty = min(1, worldHeight / 4000)` 线性缩放平台宽度、移动平台出现概率、敌人生成概率和掉落延迟
- 间距约束的顺序放置（Doodle Jump）：自下而上放置平台，最小间距从 85px 增加到 175px
- 带回收的对象池（Cliff Escape）：滚动到可视边界下方的节点被回收，并在上方区域以新属性重新生成
- 所有参考实现均未使用柏林噪声（Perlin noise）、波函数坍缩（WFC（Wave Function Collapse））或种子化 PRNG（伪随机数生成器）

**难度缩放设计：**
- 五阶段模型，参数逐步升级：导弹间隔缩短（20s → 4s），平台掉落延迟缩短（6s → 2.5s），平台移动速度增加（0.4 → 1.2）
- 连续线性难度标量：前 4000 高度单位内 `state.difficulty = Math.min(1, state.worldHeight / 4000)`
- 平台最小宽度从 60 缩小到 38，最大宽度从 160 缩小到 80
- 无尽阶段重置为中等难度，以支持可持续的无限游玩
- Doodle Jump：平台间距每级 +5px，特殊平台出现概率每级 +1%，卷轴速度每 8 级 +1

**屏幕方向处理：** 锁定竖屏是标准且强烈推荐的做法。核心机制（向上攀登）需要纵向屏幕空间。RISING 使用固定的 400x600 画布居中显示。倾斜校准捕获用户的握持姿态，而非强制特定方向。

**移动端专项考量：**
- 倾斜死区（RISING 使用 0.5）防止微抖动
- 触摸跳跃公式 `velY = baseJump - abs(velX)`——水平速度越快，跳跃高度越短
- 增量时间上限 250ms
- 首次用户交互时调用 AudioContext.resume()
- 通过 Object.assign() 实现平台回收的对象池
- 固定时间步长累加器（FRAME_TIME = 16.67ms）
- 该游戏类型优先使用 Canvas 2D，而非 WebGL

**小程序可行性：高。** 非常适合小程序游戏沙盒。支持 Canvas 2D 和 WebGL 1.0。主包限制 4MB——原生 JavaScript Canvas 游戏（~200KB）轻松满足。`wx.onAccelerometerChange()` 获取倾斜输入（无需经历 DeviceOrientationEvent.requestPermission() 权限授权流程）。Web Audio 合成可能不可用——使用预录制音频。

**参考游戏：**
- **RISING**（Gallind）—— 权威开源实现，原生 JavaScript ES modules，5 个阶段层级，支持倾斜+触摸+键盘，约 30 个源文件
- **M-Adil-AS/Doodle-Jump** —— 面向对象 JavaScript 克隆，基于关卡难度缩放，约 500 行
- **Cliff Escape**（腾讯云教程）—— Cocos Creator、DragonBones 骨骼动画、NodePool 对象回收

**技术栈：** RISING：原生 JavaScript ES6+、HTML5 Canvas API、Web Audio API、requestAnimationFrame。Doodle Jump 克隆版本：Phaser 3、Pixi.js 或 Cocos Creator。

---

### 2.9 2D 程序化驾驶/公路竞速（2D Procedural Driving / Road Racer）

**玩法描述与吸引力：** 无尽高速公路驾驶，5 档变速器、生命值系统、多层难度向量。计分综合了行驶距离、速度维持和擦肩而过奖励。高速时触发警车追捕。每 5-10km 有服务区。模拟系统的丰富性使其区别于更简单的无尽跑酷游戏。

**核心无尽机制：** 5 档变速器形成自然的进度门槛。生命值系统（车辆颜色从绿色变为红色）。超速触发警车追捕。服务区提供维修。4 车道公路，不同车道限速不同（40/60/80/100 km/h）。道具：加速、护盾、维修、分数。

**程序化生成方案：**
- 回收/环绕式场景生成：山脉、建筑、树木、路灯以数组预生成，分配随机位置，以视差速度向上滚动，滚出底部后重新定位到顶部以上
- 基于偏移的道路标线：虚线车道线通过 `ctx.setLineDash([30, 30])` 并结合 `lineDashOffset = roadOffset % 60` 实现
- 概率驱动的天气状态机：每 5 分钟通过加权随机选择更换天气，带季节偏差（冬季 +20% 雪天概率，春秋 +15% 雨天概率，黎明/黄昏 +10% 雾天概率）
- 车道限速的交通生成：车辆在顶部边缘生成，速度 = 车道基准速度 + 随机浮动 (-30%, +30%)
- AI 交通具有变道感知和鸣笛反应

**难度缩放设计（多向量，无单一公式）：**
- 速度即难度：玩家通过档位选择控制；>150 km/h 时触发警车追捕
- 交通密度：基准生成概率 0.02，高峰时段（8-10 AM, 5-8 PM）2.5 倍乘数
- 天气修正：雨天（能见度 0.7，摩擦系数 0.8），雾天（能见度 0.5，摩擦系数 1.0），雪天（能见度 0.6，摩擦系数 0.7）
- 警车追捕：二元阈值触发，以玩家速度的 110% 追赶
- 值得注意：**无显式的基于距离的难度递增**——难度来自玩家行为、模拟时间和天气

**屏幕方向处理：** 推荐仅横屏。俯视/后方视角驾驶需要横向空间展示车道。混合方案：横屏使用 4 车道 + 触摸转向，竖屏使用 3 车道 + 陀螺仪转向 + 纵向滑块控件。

**移动端专项考量：**
- 粒子对象池（预分配 200 个）
- 图形质量层级与自动降级（粒子数量 50/100/200）
- FPS 监控，FPS 低于 30 时自动降低画质
- `imageSmoothingEnabled = false` 降低 GPU（图形处理器）填充率
- 碰撞时通过 `navigator.vibrate([100, 50, 100])` 触发触觉反馈
- 多点触控支持，使用 `Map<identifier, TouchData>` 逐手指追踪
- Fullscreen API 实现沉浸式体验

**小程序可行性：高（8/10）。** Canvas 2D + 触摸输入在微信和支付宝小程序中均完全支持。体积：~150KB JS + 2-4MB（含精灵图和音频）。关键挑战：Web Audio 引擎音效合成无法复现——必须使用 5 种转速级别的预录制循环音频，配合交叉淡化（crossfade）。微信 `wx.createWebAudioContext()`（基础库 2.19.0+）提供了部分 Web Audio 等价功能。推荐架构：共享 `game-core.js`，Web、微信和支付宝各自薄层平台适配器。

**参考游戏：**
- **Infinite Road Racer**（RReyvi）—— 功能最完整的开源 2D 驾驶游戏，12 个 JS 模块，PWA，支持手柄，天气系统，成就系统

**技术栈：** Canvas 2D API、JavaScript、PWA（Service Worker）、Web Audio API、Gamepad API。

---

### 2.10 浏览器内置无尽跑酷（Chrome Dino / Edge Surf）

**玩法描述与吸引力：** Chrome Dino：自动奔跑的霸王龙，跳过仙人掌、低头躲避翼龙。单一输入。分数阈值处触发昼夜交替。Edge Surf：俯视角自由移动冲浪者，完整的双轴操控，危险物包括游荡的海妖（kraken），3 种游戏模式，道具，可解锁角色。这些是无尽跑酷游戏超轻量级实现的经典参考。

**核心无尽机制：** Chrome Dino：单一跳跃输入，地面障碍物（仙人掌）和空中威胁（翼龙）。Edge Surf：双轴移动，多种障碍物类型（岛屿、礁石、浮标、漩涡），动态海妖威胁，4 种游戏模式（无尽、计时赛、Z 字形、收集者）。

**程序化生成方案：**
- 帧计数触发生成（Chrome Dino）：当上一个障碍物的右边缘 + 间距 < 画布宽度时生成新障碍物——事件驱动，而非计时器驱动
- 带重复抑制的伪随机分发：随机选择障碍物类型，上限为 MAX_OBSTACLE_DUPLICATION=2 次连续同类型
- 速度门控的类型池：障碍物类型有最低速度阈值要求，无需显式关卡系统即可形成自然递进
- 受速度影响的间距随机化：`minGap = round(obstacleWidth * currentSpeed + typeMinGap * gapCoefficient)`，`actualGap = random(minGap, maxGap)`
- Edge Surf：平铺的无限水面，程序化放置障碍物，密度逐渐增加，海妖作为动态漫游 AI 实体
- 可切换主题的程序化世界：地平线/海浪/滑雪主题定义不同的色板和障碍物集合，使用相同的生成逻辑

**难度缩放设计：**
- 线性固定速率加速：`currentSpeed = MIN(currentSpeed + ACCELERATION, MAX_SPEED)`，无自适应反馈
- 两种配置预设：普通（速度 6→13，间距系数 0.6）和慢速/无障碍模式（速度 4.2→9，间距系数 0.3）
- 三个不同的难度阶段：速度 0-4（仅单个仙人掌）、4-7（仙人掌组 1-3 个）、8.5-13（翼龙进入类型池）
- 间距公式：`minGap = round(obstacleWidth * currentSpeed + typeConfig.minGap * gapCoefficient)`——高速时更宽的间距保持大致相同的障碍物间隔时间
- 移动端速度补偿：`speed * screenWidth / 600 * 1.2`（屏幕越窄，游戏越慢）
- Edge Surf：用户可调节的 `gameSpeed` 倍增器，渐进式障碍物密度

**屏幕方向处理：** 两款游戏均为横屏自然适配。Chrome Dino：固定逻辑画布 600x150，竖屏时缩小比例并降低速度、简化飞行层级。Edge Surf：响应式 CSS 断点系统（基础 360x480，最高 640+），HUD（抬头显示）使用 `calc(40vh +/- Npx)` 定位。推荐：横屏锁定，竖屏时添加留黑边。

**移动端专项考量：**
- 全屏透明触控层 div 用于触摸输入
- Canvas DPI 缩放，自动检测 devicePixelRatio 与 backingStorePixelRatio 不匹配
- 移动端速度补偿公式
- 帧计时：Android 使用 `performance.now()`，iOS 回退使用 `Date.now()`
- 音频：通过 Web Audio API 使用 Base64 编码音效（iOS 上跳过，避免 AudioContext 手势要求）
- 通过 `navigator.vibrate(200)` 提供振动反馈
- Edge Surf 响应式断点，基于视口相对定位的 UI
- 性能底线：每帧约 10 个精灵 + 6 朵云，<20 次绘制调用（2015 年设备上可跑 60fps）

**小程序可行性：极易实现。** 代码包总量在 200KB 以内。Canvas 2D API 完全支持。触摸输入通过全局 `wx.onTouchStart`（比 DOM 命中检测更简单）。推荐：限制 30fps 以节省电量。所有 UI 必须在 Canvas 内绘制（不能使用 DOM/CSS）。音频：使用 `wx.createInnerAudioContext()` 配合预加载音效。

**参考游戏：**
- **wayou/t-rex-runner**（2,174 stars）—— 经典 Chromium 提取版，BSD-3-Clause 许可
- **devfolioco/t-rex-runner-game** —— 最干净的 ES6 重构版，模块化架构
- **jackbuehner/MicrosoftEdge-Surf**（109 stars）—— Edge Surf v1 镜像
- **yell0wsuit/ms-edge-surf-2**（12 stars）—— Edge Surf v2，含 4 种游戏模式和无障碍特性

**技术栈：** HTML5 Canvas，原生 JavaScript（Chromium 以 C++ 为核心、JS 处理游戏逻辑（Dino）；Edge 使用 iframe 沙箱架构）。

---

## 3. 程序化生成技术总结

### 3.1 各游戏类型技术矩阵

| 技术 | 射击 | 飞行 | 节奏 | 3D跑酷 | 生存 | 横版卷轴 | 隧道 | 平台跳跃 | 驾驶 | 小恐龙 | 2048 | 合成西瓜 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 加权随机选择 | X | X | X | X | X | X | X | X | X | X | X | X |
| 对象池 + 回收复用 | X | X | - | X | X | X | X | X | X | X | - | X |
| 基于种子的 PRNG（伪随机数生成器） | - | - | X | - | X | P | - | - | - | - | P | - |
| Perlin/Simplex 噪声 | - | - | - | - | - | - | P | - | - | - | - | - |
| 波函数坍缩 (Wave Function Collapse) | - | - | - | - | - | - | - | - | - | - | - | - |
| 确定性物理作为内容 | - | - | - | - | - | - | - | - | - | - | - | X |
| 音频分析 → 内容生成 | - | - | X | - | - | - | - | - | - | - | - | - |
| 程序化音频合成 | X | X | X | - | X | - | X | X | X | - | - | - |
| 程序化视觉绘制 | X | X | - | - | X | X | X | - | X | - | - | X |
| 递归分形生成 | - | X | - | - | - | - | - | - | - | - | - | - |
| 约束满足 | - | - | X | - | - | X | - | X | - | X | X | - |
| 状态机内容门控 | X | - | X | - | X | X | - | X | X | X | - | - |
| 概率驱动事件 | - | - | X | - | - | - | - | - | X | - | - | - |

X = 在参考实现中已确认，P = 潜在/计划中但参考代码中未出现，- = 不适用

### 3.2 基于种子的随机生成

所有游戏类型中最常用的方法。实现模式：

- **Mulberry32 / xoshiro128**：快速的 32 位种子化 PRNG（伪随机数生成器）。用于确定性回放、每日挑战和速通验证。种子从日期字符串或 `?seed=` URL 参数派生。
- **Fisher-Yates 洗牌算法：** 用于赛道随机化（void-runner）、节拍顺序洗牌（oreore-rhythm）和方块放置（钢琴块类游戏）。
- **32 位 LCG（线性同余生成器）**（oreore-rhythm）：`rngState = (state * 1664525 + 1013904223) >>> 0`，返回 `state / 4294967296`。

### 3.3 用于地形/障碍物的 Perlin/Simplex 噪声

**在大多数参考实现中明显缺失。** 2019 年的一篇学术论文（"Application of the Perlin Noise Algorithm as a Track Generator in the Endless Runner Genre Game"，Journal of Physics: Conference Series，vol. 1255）证实 Perlin 噪声被用于 2D 地形/赛道生成，但所调研的开源实现绝大多数使用更简单的基于赋值的方案：

- **Perlin 噪声理论上可用于：** 横版卷轴跑酷中的地形高度变化、生存竞技场中的生物群系边界生成、驾驶游戏中的障碍物密度映射、3D 跑酷中的隧道曲率
- **为什么在参考代码中未被使用：** 大多数游戏将障碍物放置在 1D 时间线上（而非 2D 地图），使得空间连贯性算法并非必要。更简单的随机 + 约束方案已足够，且更容易调参。
- **建议：** 仅在需要生成连续 2D 地形（地面高度、生物群系地图、资源放置）时才投入 Perlin 噪声——对于 1D 障碍物序列，加权随机选择更简单且同样有效。

### 3.4 用于关卡生成的波函数坍缩（WFC）

**在所有参考实现中均未使用。** WFC 是一种基于瓦片的约束满足算法，非常适合生成复杂且局部连贯的 2D 地图。对于所调研的游戏类型而言，它属于过度设计，因为这些游戏要么：
- 将障碍物放置在 1D 时间线上（不需要空间约束）
- 使用固定竞技场（不需要地图生成）
- 使用简单的约束满足，且通过构造即可平凡满足（例如：钢琴块的行生成、保证有可用车道的基于车道生成）

**未来工作的潜在应用：** 程序化生成的解谜关卡（数独约束、数织线索生成）、保证可解性的三消棋盘生成、生存竞技场的生物群系地图。

### 3.5 难度曲线（公式与概念）

**线性爬升（最常用）：**
```javascript
speed(t) = min(MAX, BASE + RATE * t)
difficulty(t) = base + rate * t  // 带有硬上限
```
使用者：Forest Runner、Chrome Dino、Endless-Runner-3D、RISING

**线性-指数混合：**
```javascript
enemyHP = base + floor(wave / 3)        // 阶梯式线性
xpToLevel = 100 * pow(1.15, level)       // 指数
```
使用者：Space Blaster

**阻尼双曲正割（节奏游戏）：**
```javascript
speed += 0.01 * sech_squared(time() / 100)
// 初始线性加速后逐渐减缓，上限为 8.5
```
使用者：钢琴块类游戏

**多杠杆复合（通过乘法实现二次增长）：**
```javascript
speed(t) = 线性爬升
spawnDensity(t) = 线性压缩
effectiveDifficulty = speed(t) * density(t)  // 二次增长
```
使用者：Forest Runner、void-runner

**涌现式难度（无显式爬升）：**
```javascript
// 难度来自物理拥挤效应、组合棋盘状态或玩家行为
// 没有编入代码的难度函数——挑战从系统动力学中涌现
```
使用者：2048、合成西瓜游戏、Infinite Road Racer

**分段阶梯 + 连续插值：**
```javascript
// 离散阶段，参数集逐步升级
// 每个阶段内进行连续线性插值
difficulty = min(1, worldHeight / 4000)
param = lerp(stageBase, stageMax, withinStageProgress)
```
使用者：RISING、Space Blaster（按波次解锁敌人）

**自适应难度（设计模式，代码中未观察到）：**
```javascript
if (playerPerformance > threshold) difficulty *= 1.05
elif (playerDeaths > threshold) difficulty *= 0.90
```
常被讨论但在参考游戏中未实现。机会领域。

---

## 4. 移动端与小程序技术考量

### 4.1 性能约束

**微信小游戏硬性限制：**
- 主包：4MB（使用分包可达 8MB）
- 所有包总计：20-30MB
- Canvas（画布）最大尺寸：Android 上为 1365x1365px（超出会导致崩溃）
- 内存：通常 300-500MB，低端设备上微信可能在超过 200MB 时终止进程
- iOS 上 JIT（即时编译）编译受限（WKWebView 模式下的 JavaScriptCore）
- 最多 10 个并发网络请求、5 个 WebSocket（网络套接字）连接、默认 60 秒超时

**性能优化模式（通用）：**
- **DPR（设备像素比）上限设为 2：** 防止 3x/4x 屏幕渲染 4 倍像素却无可见收益
- **Delta-time（帧间隔时间）上限：** 限制在 50-250ms，防止切后台后物理计算爆炸
- **对象池（Object Pooling）：** 预分配固定大小的池，通过位置重置回收——游戏运行期间零 GC（垃圾回收）分配
- **固定时间步长累加器：** `FRAME_TIME = 1000/60`，将物理与渲染帧率解耦
- **实体交换移除（Entity Swap-Remove）：** 使用与最后一个元素交换 + pop 代替 splice，避免 O(n) 的数组移位
- **Canvas 与框架分离：** 游戏循环在 `useRef` 持有的 canvas 中通过 `requestAnimationFrame` 运行，模拟逻辑永不分配框架状态
- **实体数量上限：** 粒子、浮动文本及其他高轮换实体设有硬上限

**低端设备策略：**
- 图形质量等级与自动降级（粒子数量、阴影、后处理特效）
- FPS（帧率）监控，帧率低于阈值时自动降低质量
- 启动时设备基准检测（`wx.getDeviceBenchmarkInfo()`、`navigator.hardwareConcurrency`）
- 内存压力处理（`wx.onMemoryWarning()`）动态降低粒子上限

### 4.2 各游戏类型的触控输入模式

| 游戏类型 | 主要输入 | 辅助输入 | 触控区域 | 多点触控 |
|---|---|---|---|---|
| 竖屏弹幕射击 | 拖拽移动（基于位移增量） | 自动射击 | 单全屏区域 | 否 |
| Flappy 飞行 | 点击（touchstart 时施加冲量） | 无 | 单全屏区域 | 否 |
| 钢琴块 | 点击（按列） | 无 | 4 个竖向分区 | 否 |
| 3D 跑酷（3D Lane Runner） | 滑动（4 方向） | 无 | 单全屏区域 | 否 |
| 弹幕天堂（Bullet Heaven） | 双虚拟摇杆 | 冲刺按钮、暂停 | 左摇杆 + 右摇杆 + 按钮 | 是（2+ 触控点） |
| 横版跑酷（Side-Scroll Runner） | 点击/长按（可变跳跃高度） | 无 | 单全屏区域 | 否 |
| 隧道跑酷（Tunnel Runner） | 点击分区（左/右半屏） | 滑动（跳跃/滑铲） | 分屏 + 滑动区域 | 可选 |
| 竖版跳跃平台 | 倾斜（移动）+ 点击（跳跃） | 无 | 倾斜传感器 + 全屏点击 | 否 |
| 驾驶 | 触控按钮或倾斜 | 档位按钮 | 转向区域 + 踏板区域 | 是（2+ 触控点） |
| Chrome 小恐龙 | 点击（跳跃）、长按（下蹲） | 无 | 单全屏区域 | 否 |
| 2048 | 滑动（4 方向） | 无 | 单全屏区域 | 否 |
| 合成西瓜（Suika Game） | 拖拽（水平瞄准）+ 释放（下落） | 无 | 单全屏区域 | 否 |

**关键输入设计原则：**
- 使用 `pointerdown`/`pointerup`（统一指针 API（Pointer Events）），而非分别处理 mouse 和 touch 事件
- 对 touch 事件调用 `preventDefault()` 并设置 `{ passive: false }`，以阻止滚动/缩放
- 死区阈值（5-10px 位移）区分点击与滑动
- 游戏 canvas 上设置 CSS `touch-action: none` 以抑制浏览器手势
- 单输入游戏不使用多点触控（若 `event.touches.length > 1` 则忽略）
- 仅需单输入的游戏使用全屏透明 controller div（点击任意位置即可）

### 4.3 屏幕方向适配模式

**模式 1：固定锁定（最简单，最佳用户体验）**
通过 Screen Orientation API（Web）或 `game.json` 中的 `deviceOrientation`（微信）锁定游戏的自然方向。当方向不正确时显示"旋转设备"覆盖层。大多数原生竖屏和原生横屏游戏均采用此模式。

**模式 2：信箱模式（Letterboxing）**
游戏逻辑在固定宽高比下运行。在方向不正确或宽高比异常的屏幕上，将游戏区域居中并添加装饰性侧边栏/顶栏。触控坐标从屏幕空间变换到游戏空间：`gameX = (touchX - offsetX) / scale`。

**模式 3：响应式 Canvas + 相机自适应**
Canvas 填满可用空间。游戏世界大小不变，但视口根据宽高比显示不同的子集。相机 FOV（视场角）/宽高比动态调整。HUD（抬头显示）根据方向重新定位。用于 oreore-rhythm 和 canvas-vampire-survivors。

**模式 4：双布局预设**
为竖屏和横屏分别维护独立的相机预设、赛道配置和 HUD 布局。方向变化时在预设之间使用平滑 lerp（线性插值）过渡。部分 3D 隧道跑酷游戏采用此模式。

**实现检查清单：**
1. 对方向/窗口大小变化处理器做防抖处理，延迟 250-500ms，避免旋转动画期间频繁重新计算
2. 方向变化期间暂停游戏循环
3. 带 DPR 重新计算 canvas 尺寸：`canvas.width = displayWidth * dpr; canvas.height = displayHeight * dpr`
4. 重新计算所有与屏幕相关的尺寸（间距大小、平台位置、UI 位置）
5. iOS Safari：`orientationchange` 在内部尺寸更新之前触发——使用 `setTimeout(handler, 100)` 或改为监听 `resize`
6. 微信：使用 `wx.onWindowResize()` 处理尺寸变化，使用 `wx.onDeviceOrientationChange()` 处理方向事件

### 4.4 小程序特有限制

**Canvas API 差异（Web vs 微信小游戏）：**
| 操作 | Web | 微信小游戏 |
|---|---|---|
| Canvas 创建 | `document.createElement('canvas')` | `wx.createCanvas()` |
| 2D 上下文 | `canvas.getContext('2d')` | `canvas.getContext('2d')`（相同） |
| WebGL 上下文 | `canvas.getContext('webgl')` | `canvas.getContext('webgl')`（SDK 2.7.0+ 起可用） |
| 动画帧 | `window.requestAnimationFrame` | `canvas.requestAnimationFrame`（相同签名） |
| DOM 访问 | 完整 DOM API | 无——只有单个全屏 Canvas |
| CSS | 完整 CSS | 无——必须在 Canvas 上渲染所有 UI |
| 字体 | 系统字体 + `@font-face` | `wx.loadFont(url)` |

**音频 API 差异（关键）：**
| 操作 | Web | 微信小游戏 |
|---|---|---|
| 音频播放 | Web Audio API（Web 音频 API）/ `<audio>` | `wx.createInnerAudioContext()` |
| 音频合成 | `AudioContext.createOscillator()` | `wx.createWebAudioContext()`（部分支持，SDK 2.19.0+） |
| 音频节点图 | 完整 AudioNode 图 | 有限的节点类型 |
| 延迟 | ~10ms（Web Audio） | 50-100ms（InnerAudioContext） |
| 后台音频 | 不适用 | `wx.getBackgroundAudioManager()` |

**对程序化音频游戏的影响：** Space Blaster、Flappy Rocket、oreore-rhythm 和 Neon Survival Arena 使用的程序化音频合成方案无法直接移植。可选方案：
1. 构建时预渲染短音频片段为 base64 data URI（总计 <100KB）
2. 使用 `wx.createWebAudioContext()` 配合有限的节点支持（需检查 SDK 兼容性）
3. 预录制音频文件并通过 `wx.createInnerAudioContext()` 加载

**存储差异：**
- `localStorage` -> `wx.setStorageSync()` / `wx.getStorageSync()`（每个 key 限制 10MB）
- 无 Service Workers -> 使用 `wx.getFileSystemManager()` 进行缓存
- 无 IndexedDB -> 使用微信云数据库或文件系统 API

**其他关键限制：**
- 无 Web Workers（单线程 JavaScript）
- 无 WebSocket 实时通信（必须使用云函数轮询或实时数据库监听器）
- 无 Gamepad API（手柄 API）
- 无 Wake Lock API（唤醒锁定 API）（使用 `wx.setKeepScreenOn()`）
- 无 Vibration API 直接访问（使用 `wx.vibrateShort()` / `wx.vibrateLong()`）
- 仅 HTTPS/WSS，网络请求域名必须完成 ICP 备案

### 4.5 节奏游戏的音频考量

**小程序的音频延迟问题：**
节奏游戏需要严格的音画同步。微信 `wx.createInnerAudioContext()` 存在 50-100ms 的不可避免延迟，使得实时合成的音频反馈在节奏游戏中无法用于点击判定。

**解决方案：**
1. **分离音频与判定时钟：** 使用 `performance.now()`（或 `Date.now()`）作为计时权威，而非音频输出位置。音频作为背景播放；游戏根据独立时钟判定点击。
2. **预渲染音效采样：** 用预录制的短音频文件（.mp3，每个 2-5KB）替代 Web Audio API 合成。使用 15-20 个音效，总共增加 30-100KB 的包体积。
3. **延迟校准：** 提供玩家可调延迟偏移（-200ms 至 +250ms），如 oreore-rhythm 所做，以补偿蓝牙音频延迟。
4. **无需 AudioContext 的 BPM（每分钟节拍数）同步：** 使用 `setInterval`（40ms 粒度）或游戏循环时间戳进行节拍计时。精度不如 `AudioContext.currentTime`，但对休闲玩法足够。
5. **音频上下文池：** 预创建 4-6 个 `InnerAudioContext` 实例并复用，避免创建开销。

---

## 5. 推荐方案

### 按匹配度排名的五大推荐游戏类型

**目标场景：** 移动端小程序嵌入（微信/支付宝），无尽重玩性，程序化生成，最小化包体积，适配单点触控。

---

### 排名第一：竖屏无尽飞行器（Portrait Endless Flyer，Flappy 风格，全程序化资源）

**评分：** 在所有维度上综合适配度最佳。兼具最低复杂度与最高移动端评分，经过验证的小程序成功案例，以及零素材架构——这一架构与小程序约束条件天然契合。

**预估工作量：** 2-4 周打磨出 MVP（最小可行产品）。核心循环可用不到 500 行原生 JS 实现。全程序化资源（15 种火箭设计、10 种环境、Web Audio 合成）将代码量推至约 1500-2000 行。

**最佳方向策略：** 锁定竖屏。间隙尺寸与屏幕高度成比例，确保跨设备难度一致。横屏通过居中游戏区域的留黑边（letterboxing）方式支持。

**技术栈推荐：** Vanilla JS + HTML5 Canvas 2D（二维画布），单文件、零依赖。应避免使用框架——游戏循环的简洁性使框架开销毫无必要。微信小游戏场景：使用 `wx.createCanvas()`，将 Web Audio 合成替换为预渲染的 base64 音频片段或 `wx.createInnerAudioContext()`。

**关键成功要素：**
- 速度-间隙耦合（管道间距随速度增大而变宽，防止出现无法通过的配置）
- 基于屏幕相对比例尺寸（所有尺寸从 viewHeight 推导）
- 对象池化回收管道（3-4 对管道，移出屏幕后重置位置）
- FPS（帧率）分级系统（30/60/无上限），适配不同设备性能

---

### 排名第二：竖屏纵向射击/无尽波次生存（Portrait Vertical Shmup / Endless Wave Survival）

**评分：** 移动端评分最高（10），单文件架构，零外部素材，极佳的小程序兼容性。代价是实现复杂度高于 Flappy 风格游戏，但换来的是功能更丰富、更具吸引力的游戏体验。

**预估工作量：** 2-3 周完成 MVP（核心循环 + 3 种敌人 + 1 个 Boss），4-6 周全面打磨（8 种敌人、3 个 Boss、升级系统、元进度、成就）。

**最佳方向策略：** 锁定竖屏（390x844 逻辑分辨率）。桌面端或强制横屏场景使用竖屏留黑边方案。

**技术栈推荐：** Vanilla JS + HTML5 Canvas 2D + Web Audio API（网页音频接口），单 index.html。从一开始就引入对象池化（300 发子弹，400 个粒子）。双区域触控布局（左侧 60% 移动，右侧 40% 开火）。微信场景：`wx.createCanvas()`，`wx.createWebAudioContext()` 用于程序化音频合成。

**关键成功要素：**
- 波次门槛敌人类型解锁表（阶梯式难度曲线）
- Roguelike 升级选择（每 3 波从 3 个选项中选 1 个）以提供流派多样性
- 每 5 波切换区域以实现心理难度重置
- 相对拖拽触控输入（基于增量，避免手指遮挡）

---

### 排名第三：无尽跑酷节奏混合型（Infinite Runner Rhythm Hybrid，钢琴块 + 问答式）

**评分：** 所有可行游戏类型中实现复杂度最低，小程序兼容性最高，且品类最为独特（没有传统无尽跑酷的直接竞品）。代价是小程序中的音频延迟是一个切实的挑战。

**预估工作量：** 1 周完成钢琴块 MVP（约 150 行代码）。2-3 周完成 oreore-rhythm 风格混合体（含问答式、测验模式及全面打磨，约 2000-3000 行代码）。

**最佳方向策略：** 竖屏优先，采用 4 列布局。横屏通过 3 列模式及通道重映射支持。oreore-rhythm 的三种 padSide 选项（bottom/right/left）提供了经过验证的模式。

**技术栈推荐：** Vanilla JS + Canvas 2D（单 HTML 文件）。基于种子的 32 位 LCG（线性同余生成器）用于确定性模式生成。Canvas 渲染的 UI（用户界面），游戏过程中不使用 DOM（文档对象模型）。微信场景：预渲染音频采样，基于 `performance.now()` 的计时时钟，延迟校准滑块。

**关键成功要素：**
- 每行单黑块约束（通过构造保证可解性）
- 阻尼双曲正割速度曲线（缓慢加速，硬上限）
- 模式池配合程序化诱饵注入以增加变化
- 延迟校准系统（-200ms 至 +250ms）对于移动端蓝牙音频至关重要

---

### 排名第四：2D 横版无尽跑酷（2D Side-Scrolling Endless Runner，Chrome 恐龙/森林跑酷风格）

**评分：** 有详尽的难度公式文档，优秀的小程序兼容性，以及普遍熟悉的游戏模式。横屏方向要求是单手移动端游玩的主要限制。

**预估工作量：** 2-4 周打磨 MVP。1 周完成核心循环（使用 Phaser 3 或原生 Canvas）。纯 Canvas 实现耗时约为 1.5 倍，但产出更小的包体积且更易于移植到小程序。

**最佳方向策略：** 锁定横屏。三级回退方案：(1) Screen Orientation API（应用程序接口）锁定，(2) 响应式 FIT 缩放配合留黑边，(3) 竖屏重排并降低速度。以 800x480（5:3 比例）为设计基准，以获得最佳跨设备兼容性。

**技术栈推荐：** Phaser 3 + TypeScript + Vite 用于 Web 版（开发速度最快）。Vanilla JS + Canvas 2D 共享核心用于小程序移植。共享 `game-core.ts` 配合独立渲染器：`renderer-web`（Phaser）和 `renderer-mini`（微信 Canvas）。SVG（可缩放矢量图形）Data URI 素材管线实现零网络请求。

**关键成功要素：**
- 双杆复合难度（线性速度增幅 × 线性生成压缩 = 二次方挑战增长）
- 可变高度跳跃配合按住时长敏感度（该类游戏的决定性手感特征）
- 连击倍率系统（每连续收集 3 枚金币 = +0.5x，上限 5x）以体现操作技巧
- 滑动窗口瓦片回收（每帧 O(1) 摊还创建/销毁）

---

### 排名第五：滑块拼图/数字合并（Slider Puzzle / Number Merge，2048）

**评分：** 移动端评分满分（10），实现体量极小（约 300 行核心逻辑），天然竖屏方向，以及数学上最优雅的程序化生成方案（单次随机格选择即可产生无尽组合重玩性）。局限在于它不属于"动作"类游戏——它在不同的参与度类别中竞争。

**预估工作量：** 1-2 周完成打磨后的网页版。2-4 周完成微信小游戏版（含云端排行榜、PvP（玩家对战）匹配和商业化），如 digital-space-lab 所展示。核心游戏逻辑作为纯状态机约 200 行代码。

**最佳方向策略：** 锁定竖屏。4x4 方形网格与方向无关，但竖屏手机提供自然的拇指可达范围。横屏：额外水平空间用于侧边栏 UI（分数历史、成就、排行榜预览）。

**技术栈推荐：** 核心逻辑为纯状态机（约 200 行，零渲染依赖）。分离渲染器：DOM + CSS 过渡（Web 端），Canvas 2D（小程序端）。小程序端：`wx.createCanvas()`，自定义 Canvas 动画系统配合逐帧插值，`wx.setStorageSync()` 用于持久化，云数据库用于排行榜。

**关键成功要素：**
- 可选种子 PRNG（伪随机数生成器），用于确定性重放和每日挑战
- 90/10 方块生成比例（2 vs 4）——唯一的难度调节旋钮
- 网格遍历顺序算法（4 行模式，确保正确的合并顺序）
- 每回合单次合并约束（防止平凡连锁合并，创造策略深度）

---

### 推荐方案总结

| 排名 | 游戏类型 | 预估工作量 | 方向 | 技术栈 | 主要风险 |
|---|---|---|---|---|---|
| 1 | Flappy 风格飞行器 | 2-4 周 | 锁定竖屏 | Vanilla JS + Canvas 2D | 小程序中音频合成 |
| 2 | 纵向波次射击 | 2-6 周 | 锁定竖屏 | Vanilla JS + Canvas 2D + Web Audio | 复杂度上限较高 |
| 3 | 节奏混合型 | 1-3 周 | 竖屏优先 | Vanilla JS + Canvas 2D | 音频延迟（50-100ms） |
| 4 | 横版跑酷 | 2-4 周 | 锁定横屏 | Phaser 3（Web）/ Canvas（小程序） | 横屏 = 移动端友好度较低 |
| 5 | 2048 滑块拼图 | 1-4 周 | 锁定竖屏 | 状态机 + Canvas 2D | 动作类参与度较低 |

**跨类型推荐：** 所有五种游戏类型共享一个共同的最优架构：**vanilla JS + Canvas 2D，配合纯状态机核心和平台无关设计**。将游戏逻辑构建为自包含模块，接收输入事件并产出帧状态，配合平台适配器分别对接 Web 平台（DOM 事件、Web Audio）和小程序平台（微信 API、InnerAudioContext）。该架构最大化代码复用（约 80% 共享），同时尊重各平台的约束条件。

---

## 6. 参考文献

### 主要参考实现（精选发现）

1. Space Blaster: Evolved — https://github.com/waseemnasir2k26/Space-Blaster
2. Delta-Strike — https://github.com/eldermoraes/Delta-Strike
3. Space-Jam — https://github.com/DanMat/Space-Jam
4. Hivefall — https://github.com/aimanh2250-lab/hivefall
5. Weltkriegsimulator — https://github.com/igorski/weltkriegsimulator
6. BombJack — https://github.com/DanMat/BombJack
7. Neon Vanguard — https://github.com/alliterhorst/neon-vanguard
8. Flappy Rocket — https://codecanyon.net/item/flappy-rocket-html5-game/63591526
9. cocos-flappy-bird — https://github.com/cocos-creator-demo/cocos-flappy-bird
10. flappybird-miniapp — https://github.com/iFangcy/flappybird-miniapp
11. 404-flappingbird — https://github.com/js13kGames/404-flappingbird
12. oreore-rhythm — https://github.com/ozaki-taisuke/oreore-rhythm
13. tap-the-black-tiles — https://github.com/316k/tap-the-black-tiles
14. react-piano-tiles — https://github.com/cirocosta/react-piano-tiles
15. famous-white-tile-firebase — https://github.com/IjzerenHein/famous-white-tile-firebase
16. RhythmRush-OnSite_Game — https://github.com/adityapatil343/RhythmRush-OnSite_Game
17. Piano-Tiles (AJLoveChina) — https://github.com/AJLoveChina/Piano-Tiles
18. piano-tiles (enzoftware) — https://github.com/enzoftware/piano-tiles
19. PianoTileJS — https://github.com/dvduongth/PianoTileJS
20. Endless-Runner-3D — https://github.com/manuka-rashen/Endless-Runner-3D
21. Rift Runner — https://github.com/KomaliAndhe/rift-runner
22. Neon Survival Arena — https://github.com/dennis299/neon-survival-arena
23. canvas-vampire-survivors — https://github.com/ricardo-foundry/canvas-vampire-survivors
24. vampire-survivors-clone (Godot) — https://github.com/tuwinal/vampire-survivors-clone
25. Forest Runner Tutorial — https://www.generalistprogrammer.com/tutorials/phaser-endless-runner-tutorial
26. DinoX — https://github.com/hardik-321/DinoX
27. Chrome Dino (Chromium source) — https://source.chromium.org/chromium/chromium/src/+/main:components/neterror/resources/offline_pages/
28. Velocity Run — https://codecanyon.net/item/velocity-run-html5-endless-runner-game/63284598
29. Neon Drone Rush — https://codecanyon.net/item/neon-drone-rush-3d-tunnel-endless-runner-html5-game-threejs/61012229
30. void-runner — https://github.com/shadikulhossan/void-runner
31. Neon-Runner — https://github.com/zzerodesigns/Neon-Runner
32. zigzag — https://github.com/michaelkolesidis/zigzag
33. threejs-endless-runner — https://github.com/ab192130/threejs-endless-runner
34. SlashSaber — https://github.com/honzaap/SlashSaber
35. RISING — https://github.com/Gallind/Rising
36. Doodle-Jump (M-Adil-AS) — https://github.com/M-Adil-AS/Doodle-Jump
37. doodlejump.js — https://github.com/kissmycodee/doodlejump.js
38. 2D-Unity-DoodleJump — https://github.com/wailywang/2D-Unity-DoodleJump
39. expo-doodle-jump — https://github.com/EvanBacon/expo-doodle-jump
40. Cliff Escape Tutorial — https://cloud.tencent.com.cn/developer/article/1554363
41. Infinite Road Racer — https://github.com/RReyvi/infinite-road-racer
42. javascript-racer — https://github.com/jakesgordon/javascript-racer
43. wayou/t-rex-runner — https://github.com/wayou/t-rex-runner
44. devfolioco/t-rex-runner-game — https://github.com/devfolioco/t-rex-runner-game
45. MicrosoftEdge-Surf — https://github.com/jackbuehner/MicrosoftEdge-Surf
46. ms-edge-surf-2 — https://github.com/yell0wsuit/ms-edge-surf-2
47. chrome-dinosaur-game (ImKennyYip) — https://github.com/ImKennyYip/chrome-dinosaur-game
48. chrome-dino-enhanced — https://github.com/yell0wsuit/chrome-dino-enhanced
49. chrome-dino-game-clone (WebDevSimplified) — https://github.com/WebDevSimplified/chrome-dino-game-clone
50. dino (Phaser 3) — https://github.com/Autapomorph/dino
51. t-rex-runner (Chinese) — https://github.com/lmk123/t-rex-runner
52. edge-surf-game (C) — https://github.com/ShirasawaSama/edge-surf-game
53. gabrielecirulli/2048 — https://github.com/gabrielecirulli/2048
54. digital-space-lab — https://github.com/Steven8427/digital-space-lab
55. 2048-in-react — https://github.com/mateuszsokola/2048-in-react
56. vue-2048 — https://github.com/pengfu/vue-2048
57. 2048 (Flutter) — https://github.com/shubhexists/2048
58. 2048.cpp — https://github.com/plibither8/2048.cpp
59. 2048-deep-reinforcement-learning — https://github.com/navjindervirdee/2048-deep-reinforcement-learning
60. 2048.nvim — https://github.com/NStefan002/2048.nvim
61. dao-2048 — https://github.com/DaoCloud/dao-2048
62. 2048 (EXL) — https://github.com/EXL/2048
63. 2048.c — https://github.com/mevdschee/2048.c
64. fruits-maker — https://github.com/yhw032/fruits-maker
65. suika-game (kookjd7759) — https://github.com/kookjd7759/suika-game
66. suika-game-js-beta — https://github.com/IceburgLettuce17/suika-game-js-beta
67. planetary-nursery-suika — https://github.com/ungabo/planetary-nursery-suika
68. mini_games — https://github.com/yahayuta/mini_games
69. tsuika — https://github.com/andrewn9/tsuika
70. Suika (MycroftKang) — https://github.com/MycroftKang/Suika
71. GalaxyBlasterX — https://github.com/jenuraepa/GalaxyBlasterX
72. VOID SURVIVORS — https://github.com/Amrendra-gupta/VOID-SURVIVORS
73. Pixel Blitz — https://github.com/OfficialMehadiBhai/Pixel-Blitz
74. ChickenHop — https://github.com/TheCodingRocket/ChickenHop
75. Frogger-HTML5 — https://github.com/sszczep/Frogger-HTML5
76. sudoku.js — https://github.com/robatron/sudoku.js
77. Nonogram — https://github.com/LiRohan/Nonogram
78. colloc — https://github.com/JetLua/colloc
79. Forest Loop Odyssey — https://github.com/Ayka11/forestLoop
80. Neolution — https://github.com/GareBear99/Neolution
81. RhythmForge — https://github.com/Kaftow/RhythmForge
82. Soundzcape — https://github.com/KryptonChicken/soundzcape
83. Abyssal-Groove-Lab — https://github.com/ancient1110/Abyssal-Groove-Lab
84. Metro-Run — https://forum.cursor.com/t/first-game-of-2026-metro-run-procedurally-generated-endless-runner-in-browser/149545
85. Urban Crosser — https://codecanyon.net/item/urban-crosser-3d-endless-crossing-game-html5/60151439
86. react-tetris — https://github.com/chvin/react-tetris
87. hextris — https://github.com/hextris/hextris
88. match-3 (Rich Harris) — https://github.com/Rich-Harris/match-3
89. juanlegejuan — https://github.com/ericdum/juanlegejuan
90. hustle-diary — https://github.com/WangChangxin0809/hustle-diary

### 引用的框架与库
91. Phaser 3 — https://phaser.io/ | https://github.com/photonstorm/phaser
92. Three.js — https://threejs.org/ | https://github.com/mrdoob/three.js
93. Matter.js — https://brm.io/matter-js/ | https://github.com/liabru/matter-js
94. Cocos Creator — https://www.cocos.com/creator
95. PixiJS — https://pixijs.com/

### 学术参考文献
- "Application of the Perlin Noise Algorithm as a Track Generator in the Endless Runner Genre Game" — Journal of Physics: Conference Series, vol. 1255 (2019)

---
name: zotero
description: >
  Access the local Zotero library via its HTTP API — search items, retrieve metadata,
  notes, and attachments, and create new entries. Use when the user asks to find, read,
  or manage Zotero references, or when a research workflow needs to pull bibliographic
  data from the user's collection.
compatibility: Designed for Claude Code (WSL2 ↔ Windows Zotero)
license: MIT
metadata:
  version: "1.1.0"
  author: Chengyu HAN
when_to_use: |
  Triggers on: Zotero, zotero, 参考文献, 我的文献库, 从 Zotero 找, 查一下 Zotero,
  search my library, find paper in Zotero, zotero search, zotero item, zotero note,
  zotero attachment, zotero collection, 保存到 Zotero, add to Zotero.
---

# Zotero Skill — 本地文献库访问

通过 Zotero 9+ 内建 HTTP API 访问用户的 Zotero 文献库。WSL2 使用镜像网络模式，`localhost` 直接可达 Windows 主机上的 Zotero。

> **前提**：Zotero 必须在 Windows 上保持运行，且已开启 "Allow other applications to connect"。

---

## 配置摘要

详见 [references/config.md](references/config.md)。

| 项目 | 值 |
|------|-----|
| Zotero 版本 | 9.0.6 |
| API Base URL | `http://localhost:23119/api/users/0` |
| User ID | `6191661`（我的文库） |
| 认证（读） | 无需认证 |
| 认证（写） | 需要本地 API 密钥（弹窗授权，Zotero 10+） |
| 连通性测试 | `curl -X POST localhost:23119/connector/ping -H "Content-Type: application/json" -d '{}'` |

---

## 可用 API 端点

所有路径以 `/api/users/0` 为前缀（`0` 自动映射为当前登录用户 `6191661`）。

### 搜索

```
GET /api/users/0/items?q=<URL-encoded-query>
GET /api/users/0/items?q=<query>&qmode=everything     # 全文搜索
GET /api/users/0/items?q=<query>&limit=10&start=0     # 分页
```

`qmode` 可选值：`titleCreatorYear`（默认）、`everything`（含附件全文）。

### 条目操作

```
GET    /api/users/0/items                        # 列出所有条目
GET    /api/users/0/items/<itemKey>              # 获取单条条目
POST   /api/users/0/items                        # 创建新条目
PATCH  /api/users/0/items/<itemKey>              # 更新条目
DELETE /api/users/0/items/<itemKey>              # 删除条目
```

### 子资源

```
GET    /api/users/0/items/<itemKey>/children     # 条目的子项（笔记、附件）
GET    /api/users/0/items/<itemKey>/fulltext     # 附件全文内容（需指向 attachment，非父条目）
GET    /api/users/0/items/<itemKey>/file         # 下载附件文件
```

### 合集 (Collections)

```
GET    /api/users/0/collections                  # 列出所有合集
GET    /api/users/0/collections/<collKey>/items  # 合集中的条目
```

### 其他

```
GET    /api/users/0/tags                         # 所有标签
GET    /api/itemTypes                            # 条目类型（中文本地化）
GET    /api/itemFields                           # 字段列表（中文本地化）
GET    /api/creatorFields                        # 创建者字段
POST   /api/local/authorize                      # 获取写权限密钥
```

---

## 工作流

### 工作流 1：搜索文献

```
用户："帮我找 Zotero 里关于 knowledge distillation 的论文"
```

```python
import urllib.request, json

query = urllib.request.quote("knowledge distillation")
url = f"http://localhost:23119/api/users/0/items?q={query}&limit=10"
results = json.loads(urllib.request.urlopen(url).read())

for item in results:
    d = item['data']
    print(f"[{item['key']}] ({d.get('itemType')}) {d.get('title')}")
```

### 工作流 2：获取条目详情（含笔记）

```
用户："把 Zotero 里这篇文章的笔记和全文提取出来"
```

1. 搜索定位 itemKey（如 `57F6ZABA`）。
2. `GET /api/users/0/items/<itemKey>` → 元数据（title、abstractNote、url、creators 等）
3. `GET /api/users/0/items/<itemKey>/children` → 找出 note 和 attachment 子项
4. 对 attachment：`GET /api/users/0/items/<attachmentKey>/fulltext` → 全文内容
5. 对 note：`GET /api/users/0/items/<noteKey>/children` → 笔记内容

### 工作流 3：创建条目

```
用户："把这篇知乎文章保存到 Zotero"
```

需要写权限（Zotero 10+）。先授权：

```bash
# 1. 获取写密钥
curl -X POST http://localhost:23119/api/local/authorize \
  -H "Content-Type: application/json" \
  -d '{"appName": "Claude Code"}'
# Zotero 弹窗 → 用户点击"允许" → 返回 {"key": "<32字符密钥>"}
```

```bash
# 2. 创建条目
curl -X POST http://localhost:23119/api/users/0/items \
  -H "Content-Type: application/json" \
  -H "Zotero-API-Key: <key>" \
  -d '{
    "itemType": "blogPost",
    "title": "文章标题",
    "url": "https://zhuanlan.zhihu.com/p/...",
    "abstractNote": "摘要内容"
  }'
```

> **注意**：Zotero 9.x 的写 API 行为可能不同；如遇问题可回退到直接操作用户手动保存（Ctrl+Shift+S）。

### 工作流 4：从 Zotero 读取文章并总结

```
用户："帮我总结 Zotero 里那篇《1.5万字速通LLM主流模型结构》"
```

1. 搜索定位 itemKey → `57F6ZABA`
2. 获取条目元数据 → title、author、abstractNote
3. 获取 children → 找到 attachment `CAVQFPZP`（Snapshot）
4. 获取全文 `GET /api/users/0/items/CAVQFPZP/fulltext` → 文章完整正文
5. 从 fulltext 中提取正文内容（去除知乎页面的导航/评论等噪声）
6. 结合 article abstractNote 和 fulltext 做总结

### 工作流 5：打通 paper-one-pager

```
用户："把 Zotero 里这篇论文做成一页纸笔记"
```

1. 从 Zotero 获取条目元数据（标题、作者、年份、DOI、摘要、已有笔记、全文）
2. 加载 `paper-one-pager` skill 的 7 栏模板
3. 用 Zotero 中的全文附件补充细节
4. 填写 One-Pager
5. **可选**：完成后把 One-Pager 内容作为新笔记写回 Zotero 条目

---

## 重要细节

### 全文获取

- **知乎/网页文章**：Zotero 会保存 HTML 快照（Snapshot），fulltext 端点返回的 `content` 字段包含页面全部文本（含导航、评论区等），需要做噪声过滤
- **PDF 论文**：fulltext 返回 `indexedPages`/`totalPages` 和索引文本，适合快速检索关键词。如需 PDF 原文，用 `/file` 端点下载
- Zotero 的全文索引需要在偏好设置中开启"索引附件文本"

### 搜索策略

- `qmode=titleCreatorYear`（默认）：搜索标题、创建者、年份字段
- `qmode=everything`：同时搜索附件的全文索引内容
- 中文搜索直接 URL-encode 中文字符即可

### 网络

- WSL2 使用**镜像网络模式**，`localhost` 直接指向 Windows 主机
- 无需 IP 发现步骤

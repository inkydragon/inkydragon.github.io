---
name: zotero-config
description: Zotero 本地配置参考 — 版本、端口、网络拓扑
metadata:
  type: reference
  version: "1.0.0"
---

# Zotero 配置

## 环境

| 项目 | 值 | 备注 |
|------|-----|------|
| **Zotero 版本** | 9.0.6 | Windows 原生安装 |
| **操作系统** | Windows 11（主机） + WSL2（Ubuntu） | Claude Code 运行在 WSL2 中 |
| **API 端口** | `23119` | Zotero 默认端口 |
| **协议** | HTTP（本地，无 TLS） | 仅限本地网络 |
| **Better BibTeX** | 待确认是否已安装 | 提供 `/better-bibtex/search` 端点 |

## 网络拓扑

| 项目 | 值 | 备注 |
|------|-----|------|
| **WSL2 网络模式** | 镜像网络 | `localhost` 直接指向 Windows 主机，无需查 IP |
| **验证方式** | `curl localhost:23119/connector/ping` → `Zotero is running` | |


## Zotero 配置清单（Windows 端）

- [ ] Edit → Preferences → Advanced → **Allow other applications to connect** → ✅
- [ ] Better BibTeX 插件（可选）

## API 已验证端点

| 端点 | 方法 | 用途 |
|------|------|------|
| `/api/users/0/items` | GET | 列出所有条目，`?q=` 搜索，`?qmode=everything` 全文搜索 |
| `/api/users/0/items/<key>` | GET | 获取单条条目详情 |
| `/api/users/0/items/<key>/children` | GET | 获取条目的子项（笔记、附件） |
| `/api/users/0/items/<key>/fulltext` | GET | 获取附件全文内容（HTML 快照文本 / PDF 索引文本） |
| `/api/users/0/collections` | GET | 列出所有合集 |
| `/api/users/0/tags` | GET | 列出所有标签 |
| `/api/itemTypes` | GET | 条目类型列表（中文本地化） |
| `/api/itemFields` | GET | 字段列表（中文本地化） |
| `/connector/ping` | POST | 连通性检测，返回 Zotero 版本和 connector 信息 |
| `/api/local/authorize` | POST | 写权限授权（Zotero 10+） |

- **User ID**: `6191661`（库名称：我的文库）
- **读取无需认证**，写入需要本地 API 密钥（弹窗授权）
- **路径规则**：`/api/users/0/...`（`0` 自动映射为当前登录用户）

## 相关文件

- Skill: `../SKILL.md`
- Zotero HTTP API 文档: https://www.zotero.org/support/dev/web_api/v3/start
- Better BibTeX: https://retorque.re/zotero-better-bibtex/

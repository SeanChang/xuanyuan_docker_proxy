---
image: mbentley/open-webui
description: "Open WebUI的Docker镜像，作为ghcr.io/open-webui/open-webui的直接镜像，提供每日更新的major.minor标签，便于用户获取最新bugfix版本，无需指定具体补丁版本。"
source: https://xuanyuan.cloud/zh/r/mbentley/open-webui
canonical: https://xuanyuan.cloud/zh/r/mbentley/open-webui
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mbentley/open-webui" title="mbentley/open-webui Docker 镜像中文简介、标签列表与拉取命令">mbentley/open-webui — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mbentley/open-webui" title="mbentley/open-webui Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mbentley/open-webui</a>

# mbentley/open-webui

## 镜像概述

mbentley/open-webui是Open WebUI的Docker镜像，作为`ghcr.io/open-webui/open-webui`官方镜像的直接镜像。该镜像解决了官方镜像仅提供特定标签（无`major.minor`标签）的问题，通过每日更新机制创建`major.minor`版本的清单标签，方便用户获取最新的bugfix版本。

## 核心功能与特性

- **每日更新机制**：通过脚本每日查询GitHub获取最新官方标签，解析后为`linux/amd64`架构镜像创建`major.minor`版本的清单标签
- **版本兼容性**：保持与官方镜像一致的镜像摘要，确保功能与官方最新bugfix版本完全一致
- **简化版本管理**：提供`major.minor`格式标签，用户无需指定具体补丁版本即可自动获取最新修复

## 镜像标签

### 主要标签（每日更新）
- `0.8`：对应官方最新的`0.8.x`系列bugfix版本
- `0`：对应官方最新的`0.x`系列bugfix版本

### 不再更新的历史标签
- `0.7`, `0.6`, `0.5`, `0.4`, `0.3`, `0.2`, `0.1`：这些版本已停止更新，建议使用最新的每日更新标签

## 使用场景

- 需要稳定获取Open WebUI最新bugfix版本的用户
- 希望简化版本管理，避免手动指定具体补丁版本的场景
- 基于`linux/amd64`架构的Docker环境部署Open WebUI

## 使用方法

### 基本使用

通过指定`major.minor`标签拉取并运行最新bugfix版本：

```bash
docker run -d --name open-webui -p 8080:8080 mbentley/open-webui:0.8
```

### 标签对应关系示例

- `mbentley/open-webui:0.3` 指向官方 `ghcr.io/open-webui/open-webui:v0.3.5`（示例版本，具体以最新bugfix版本为准）
- 所有清单标签均使用对应系列中最新bugfix版本的镜像摘要

### 注意事项

- 仅支持`linux/amd64`架构
- 每日更新标签（如`0.8`、`0`）会自动指向对应系列的最新bugfix版本
- 历史标签不再更新，如需使用旧版本需指定具体历史标签

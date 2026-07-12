---
image: cccs/assemblyline-service-capa
description: "Assemblyline 4服务，利用CAPA开源工具识别程序的潜在功能和能力。"
source: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-capa
canonical: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-capa
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-capa" title="cccs/assemblyline-service-capa Docker 镜像中文简介、标签列表与拉取命令">cccs/assemblyline-service-capa 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![Discord](https://img.shields.io/badge/chat-on%20discord-7289da.svg?sanitize=true)](https://discord.gg/GUAy9wErNu)
[![](https://img.shields.io/discord/908084610158714900)](https://discord.gg/GUAy9wErNu)
[![Static Badge](https://img.shields.io/badge/github-assemblyline-blue?logo=github)](https://github.com/CybercentreCanada/assemblyline)
[![Static Badge](https://img.shields.io/badge/github-assemblyline_service_capa-blue?logo=github)](https://github.com/CybercentreCanada/assemblyline-service-capa)
[![GitHub Issues or Pull Requests by label](https://img.shields.io/github/issues/CybercentreCanada/assemblyline/service-capa)](https://github.com/CybercentreCanada/assemblyline/issues?q=is:issue+is:open+label:service-capa)
[![License](https://img.shields.io/github/license/CybercentreCanada/assemblyline-service-capa)](./LICENSE)

# CAPA服务

此服务使用CAPA开源库识别目标程序的潜在功能和能力。

## 服务详情

### 参数：

- `renderer`：模块支持多种输出方式（未来可能调整），提供不同详细程度的信息。管理员可修改默认值，用户可在提交时选择渲染器：
  - "simple"：显示纯能力列表，无上下文信息。
  - "default"：模拟capa默认输出（不指定-v或-vv时），显示三个表格：ATT&CK、MBC和其他能力。
  - "verbose"：基于capa的-vv（非常详细）选项构建，不显示地址部分，仅展示命名空间、描述、ATT&CK和MBC值，每个能力为独立可折叠结果部分。

### 配置（管理员设置）：

- `max_file_size`：忽略超过此大小的文件（默认：500KB）。由于capa耗时较长，超过该大小的文件将被完全忽略，模块提前返回无结果，在UI的“空结果”部分显示。

### 重要的服务级配置：

- `timeout`：模块运行超时时间（默认：5分钟）
- `docker_config.ram_mb`：模块可用内存（默认：4GB）

## 镜像变体和标签

Assemblyline服务基于[Assemblyline服务基础镜像](https://hub.docker.com/r/cccs/assemblyline-v4-service-base)构建，该基础镜像基于Debian 11和Python 3.11。

Assemblyline服务使用以下标签定义：

| **标签类型** | **描述**                                                                 | **示例标签**               |
| :----------- | :----------------------------------------------------------------------- | :------------------------- |
| latest       | 最新构建（可能不稳定）                                                   | `latest`                   |
| build_type   | 构建类型：`dev`为最新不稳定构建，`stable`为最新稳定构建                   | `stable` 或 `dev`          |
| series       | 完整构建详情，包含版本和构建类型：`version.buildType`                     | `4.5.stable`、`4.5.1.dev3` |

## 运行此服务

此服务为Assemblyline服务，设计用于Assemblyline框架中运行。

若需本地测试，可直接从终端运行Docker镜像：

```bash
docker run \
    --name Capa \
    --env SERVICE_API_HOST=http://`ip docker.xuanyuan.run/addr show docker0 | grep "inet " | awk '{print $2}' | cut -f1 -d"/"`:5003 \
    --network=host \
    cccs/assemblyline-service-capa
```

要将此服务添加到Assemblyline部署，请遵循[指南](https://cybercentrecanada.github.io/assemblyline4_docs/developer_manual/services/run_your_service/#add-the-container-to-your-deployment)。

## 文档

Assemblyline通用文档可访问：https://cybercentrecanada.github.io/assemblyline4_docs/

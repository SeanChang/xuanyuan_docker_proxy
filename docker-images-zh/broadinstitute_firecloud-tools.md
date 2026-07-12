---
image: broadinstitute/firecloud-tools
description: "firecloud-tools GitHub仓库的自动化构建镜像，用于运行相关脚本和工具，提供便捷的环境配置与执行方式。"
source: https://xuanyuan.cloud/zh/r/broadinstitute/firecloud-tools
canonical: https://xuanyuan.cloud/zh/r/broadinstitute/firecloud-tools
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/broadinstitute/firecloud-tools" title="broadinstitute/firecloud-tools Docker 镜像中文简介、标签列表与拉取命令">broadinstitute/firecloud-tools 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# firecloud-tools Docker镜像文档

## 镜像概述

firecloud-tools Docker镜像是firecloud-tools GitHub仓库的自动化构建版本，旨在提供一个便捷的环境来运行firecloud-tools相关脚本和工具。该镜像封装了必要的依赖和配置，简化了工具的部署与使用流程。

## 核心功能与特性

- 提供预配置的运行环境，无需手动安装依赖
- 支持通过Docker快速运行firecloud-tools脚本
- 与Google Cloud SDK集成，便于进行云服务相关操作
- 轻量级设计，使用`--rm`参数可在运行后自动清理容器

## 使用场景

- 需要使用firecloud-tools工具集的开发者
- 需要在隔离环境中运行firecloud相关脚本的场景
- 希望简化firecloud-tools依赖管理的用户

## 使用方法

### 使用run.sh运行脚本

通过仓库中的`run.sh`脚本直接运行指定脚本：

```bash
./run.sh scripts/directory/script_name.py <arguments>
```

### 使用Docker运行脚本

通过Docker镜像运行脚本，需挂载本地配置目录：

```bash
docker run --rm -it -v "$HOME"/.config:/.config docker.xuanyuan.run/broadinstitute/firecloud-tools python /scripts/<script name.py> <arguments>
```

参数说明：
- `--rm`：容器退出后自动删除
- `-it`：以交互模式运行并分配终端
- `-v "$HOME"/.config:/.config`：挂载本地配置目录到容器，用于存储认证信息

## 前提条件

使用该镜像前需满足以下条件：

1. 安装Google Cloud SDK：从[https://cloud.google.com/sdk/downloads](https://cloud.google.com/sdk/downloads)下载并安装
2. 设置Application Default Credentials：运行命令`gcloud auth application-default login`进行认证
3. 本地环境需安装Python 2.7（当不使用run.sh或Docker时）

> 注意：若不使用run.sh或Docker运行脚本，需检查`run.sh`或Dockerfile中通过pip安装的依赖包，并手动安装。

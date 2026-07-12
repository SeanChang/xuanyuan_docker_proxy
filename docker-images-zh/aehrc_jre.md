---
image: aehrc/jre
description: "可用于运行Java应用程序的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/aehrc/jre
canonical: https://xuanyuan.cloud/zh/r/aehrc/jre
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/aehrc/jre" title="aehrc/jre Docker 镜像中文简介、标签列表与拉取命令">aehrc/jre 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenJDK Docker镜像

## 镜像概述

此仓库包含可用于运行Java应用程序的Docker镜像，提供了运行Java应用所需的基础环境。

## 核心功能与特性

- 提供运行Java应用程序的基础运行时环境
- 基于OpenJDK构建，确保与Java应用的兼容性

## 使用场景与适用范围

适用于容器化部署和运行Java应用程序的场景，包括开发、测试及生产环境中的Java应用部署。

## 使用方法与配置说明

### 基本使用步骤

1. **拉取镜像**  
   从仓库拉取对应标签的OpenJDK镜像（具体镜像名称及标签请参考仓库文档）：  
   ```bash
   docker pull docker.xuanyuan.run/[镜像仓库地址]/[镜像名称]:[标签]
   ```

2. **运行容器**  
   使用以下命令启动容器以运行Java应用（根据实际需求调整选项及命令）：  
   ```bash
   docker run [选项] [镜像名称]:[标签] java -jar [应用程序.jar]
   ```

## 版权与许可信息

版权所有 © 2022，澳大利亚联邦科学与工业研究组织（CSIRO）ABN 41 687 119 230。  
本镜像根据[CSIRO开源软件许可协议](https://github.com/aehrc/jre-docker/blob/main/LICENSE.md)授权使用，详细许可条款请参见链接文档。

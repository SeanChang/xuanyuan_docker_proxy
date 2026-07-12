---
image: opennms/openjdk
description: "基于原生CentOS 7的基础镜像，提供OpenJDK以支持OpenNMS服务。"
source: https://xuanyuan.cloud/zh/r/opennms/openjdk
canonical: https://xuanyuan.cloud/zh/r/opennms/openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opennms/openjdk" title="opennms/openjdk Docker 镜像中文简介、标签列表与拉取命令">opennms/openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenNMS OpenJDK 基础镜像文档

## 镜像概述

本镜像为OpenNMS服务提供基于原生CentOS 7的OpenJDK运行环境，是用于在容器中部署OpenNMS服务的基础镜像。

## 核心功能与特性

- 基于原生CentOS 7构建，提供稳定的操作系统环境
- 集成OpenJDK运行时，支持OpenNMS服务的Java依赖需求
- 提供多个OpenJDK 8版本标签，满足不同版本兼容性需求

## 支持的标签

- `8u191-jdk`、`latest`：OpenJDK 8 Update 191
- `8u181-jdk`：OpenJDK 8 Update 181
- `8u171-jdk`：OpenJDK 8 Update 171
- `8u161-jdk`：OpenJDK 8 Update 161
- `8u151-jdk`：OpenJDK 8 Update 151
- `8u144-jdk`：OpenJDK 8 Update 144
- `8u141-jdk`：OpenJDK 8 Update 141
- `8u131-jdk`：OpenJDK 8 Update 131
- `8u121-jdk`：OpenJDK 8 Update 121

## 使用场景

作为OpenNMS服务的基础镜像，用于构建和运行OpenNMS相关容器化应用，满足OpenNMS对Java运行环境的依赖需求。

## 使用方法

### 拉取镜像

使用以下命令拉取特定版本的镜像：

```bash
docker pull docker.xuanyuan.run/[镜像仓库地址]/opennms-openjdk:8u191-jdk
```

（注：请将`[镜像仓库地址]`替换为实际的镜像仓库地址）

### 作为基础镜像使用

在Dockerfile中使用本镜像作为基础镜像：

```dockerfile
FROM docker.xuanyuan.run/[镜像仓库地址]/opennms-openjdk:8u191-jdk

# 后续构建步骤...
```

选择标签时，建议根据OpenNMS服务的Java版本需求选择合适的OpenJDK Update版本标签。

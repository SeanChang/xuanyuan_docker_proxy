---
image: ericwong/firecrawl
description: "Firecrawl项目的API服务Docker镜像，用于构建和部署Firecrawl的API应用，支持通过Docker快速部署该服务，基于项目的apps/api目录构建。"
source: https://xuanyuan.cloud/zh/r/ericwong/firecrawl
canonical: https://xuanyuan.cloud/zh/r/ericwong/firecrawl
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ericwong/firecrawl" title="ericwong/firecrawl Docker 镜像中文简介、标签列表与拉取命令">ericwong/firecrawl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Firecrawl API服务Docker镜像

## 镜像概述
该Docker镜像用于构建和部署Firecrawl项目的API服务，基于Firecrawl项目的`apps/api`目录构建，提供了一种便捷的方式来部署Firecrawl的API应用服务。Firecrawl项目的具体功能和详细信息请参考其官方GitHub仓库。

## 核心功能与特性
- 基于Firecrawl项目的API模块构建，封装了项目API服务的运行环境
- 支持通过Docker容器化部署，简化部署流程
- 提供独立的API服务实例，便于集成到各类应用场景中

> **注**：具体功能特性请参考Firecrawl官方GitHub仓库文档以获取详细信息。

## 使用场景
适用于需要部署Firecrawl API服务的开发者或用户，可通过Docker快速构建并运行该服务，用于集成Firecrawl相关功能到应用系统中。

## 使用方法

### 前提条件
- 已安装Docker环境
- 已安装`docker-buildx`工具

### 构建镜像步骤
1. 安装docker-buildx（如未安装）：
   ```bash
   sudo apt install docker-buildx
   ```

2. 克隆Firecrawl项目仓库：
   ```bash
   git clone https://github.com/mendableai/firecrawl
   ```

3. 进入项目的API应用目录：
   ```bash
   cd firecrawl/apps/api
   ```

4. 构建Docker镜像：
   ```bash
   sudo docker build --no-cache -t firecrawl:1.4.1 ./
   ```

### 运行镜像
构建完成后，可通过以下命令运行镜像（具体参数需根据项目要求配置）：
```bash
docker run -d --name firecrawl-api -p <host-port>:<container-port> docker.xuanyuan.run/firecrawl:1.4.1
```
> **注**：请根据Firecrawl API服务的端口配置及需求，替换`<host-port>`和`<container-port>`为实际端口号。

## 配置说明
该镜像的具体配置参数、环境变量设置及服务运行要求等详细信息，请参考Firecrawl项目的官方文档或GitHub仓库说明。

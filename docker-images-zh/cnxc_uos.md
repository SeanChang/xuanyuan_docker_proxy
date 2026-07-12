---
image: cnxc/uos
description: "统信UOS服务器操作系统Docker基础镜像，基于UOS软件源构建，提供V20（A版）1050、1060、1070版本。"
source: https://xuanyuan.cloud/zh/r/cnxc/uos
canonical: https://xuanyuan.cloud/zh/r/cnxc/uos
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cnxc/uos" title="cnxc/uos Docker 镜像中文简介、标签列表与拉取命令">cnxc/uos 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 统信UOS服务器操作系统Docker镜像

## 镜像概述

统信UOS服务器操作系统Docker镜像是基于统信UOS官方软件源构建的基础镜像，旨在为用户提供稳定、可靠的UOS服务器操作系统运行环境。该镜像支持`V20（A版）`的1050、1060、1070三个版本，可作为各类应用部署、开发测试的基础环境。

## 核心功能与特性

- **官方软件源构建**：基于统信UOS官方软件源构建，确保系统组件的完整性和安全性。
- **多版本支持**：提供`V20（A版）`1050、1060、1070三个稳定版本，满足不同场景的版本需求。
- **基础镜像特性**：作为基础镜像，可直接用于构建上层应用镜像，或作为独立容器运行UOS服务器环境。

## 使用场景与适用范围

- **应用部署基础环境**：作为各类服务（如Web服务、数据库服务等）的底层操作系统环境。
- **开发测试环境**：为开发人员提供一致的UOS服务器操作系统环境，便于应用兼容性测试。
- **容器化应用构建**：作为Dockerfile中的基础镜像，构建基于UOS的应用镜像。

## 使用方法与配置说明

### 拉取镜像

根据需要的版本，通过以下命令拉取对应镜像（假设镜像名称为`uos/server`，实际使用时需替换为具体镜像仓库地址）：

```bash
# 拉取V20（A版）1050版本
docker pull docker.xuanyuan.run/uos/server:v20-a-1050

# 拉取V20（A版）1060版本
docker pull docker.xuanyuan.run/uos/server:v20-a-1060

# 拉取V20（A版）1070版本
docker pull docker.xuanyuan.run/uos/server:v20-a-1070
```

### 运行容器

以交互方式运行容器，进入UOS服务器操作系统环境：

```bash
docker run -it --name uos-server-container docker.xuanyuan.run/uos/server:v20-a-1070 /bin/bash
```

### 作为基础镜像构建应用

在Dockerfile中使用该镜像作为基础，构建自定义应用镜像：

```dockerfile
# 使用V20（A版）1070版本作为基础镜像
FROM docker.xuanyuan.run/uos/server:v20-a-1070

# 安装应用依赖（示例）
RUN apt-get update && apt-get install -y your-package

# 设置工作目录
WORKDIR /app

# 复制应用代码
COPY . /app

# 运行应用
CMD ["./your-app"]
```

### 基本配置说明

该镜像为基础操作系统镜像，无特殊环境变量配置。用户可根据需求在容器运行时或Dockerfile中添加自定义配置，如端口映射、数据卷挂载等：

```bash
# 运行容器并挂载数据卷
docker run -it -v /host/path:/container/path docker.xuanyuan.run/uos/server:v20-a-1070 /bin/bash

# 运行容器并映射端口
docker run -it -p 8080:80 docker.xuanyuan.run/uos/server:v20-a-1070 /bin/bash

---
image: fusondocker/kingbase
description: "提供x86和arm64架构的Kingbase数据库服务器Docker镜像，版本V008R002C001B0102，用于便捷部署和运行金仓数据库服务。"
source: https://xuanyuan.cloud/zh/r/fusondocker/kingbase
canonical: https://xuanyuan.cloud/zh/r/fusondocker/kingbase
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fusondocker/kingbase" title="fusondocker/kingbase Docker 镜像中文简介、标签列表与拉取命令">fusondocker/kingbase 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kingbase数据库Docker镜像文档

## 镜像概述

本镜像提供Kingbase数据库服务器的Docker化部署方案，支持x86和arm64两种架构，版本为V008R002C001B0102。旨在简化金仓数据库的安装配置流程，方便用户快速搭建数据库服务环境。

## 核心功能与特性

- **多架构支持**：提供x86和arm64两种架构版本，适配不同硬件环境
- **便捷部署**：通过Docker容器化部署，减少环境依赖和配置复杂度
- **预设配置**：包含默认数据库、用户及端口设置，开箱即可使用

## 使用场景

适用于开发测试环境的数据库快速部署，或作为轻量级应用的数据库服务运行环境，满足中小型应用的数据存储需求。

## 使用方法

### 1. 拉取镜像

根据服务器架构选择对应版本拉取：

- x86架构：
```bash
docker pull docker.xuanyuan.run/fusondocker/kingbase:8.2
```

- arm64架构：
```bash
docker pull docker.xuanyuan.run/fusondocker/kingbase:arrch64-8.2
```

### 2. 启动容器

启动容器并映射宿主机端口（确保54321端口未被占用）：

```bash
docker run -itd --name KESDB -p 54321:54321 docker.xuanyuan.run/fusondocker/kingbase:8.2 /bin/bash
```

### 3. 查看容器ID

获取运行中的容器ID：

```bash
docker ps -a
```

### 4. 启动数据库服务

使用容器ID启动数据库（将CON_ID替换为实际容器ID）：

```bash
docker exec -it CON_ID /root/setup.sh
```

## 数据库默认信息

- **数据库端口**：54321  
- **数据库用户名**：SYSTEM  
- **数据库密码**：123456  
- **默认数据库**：TEST  
- **命令行登录**：`ksql -USYSTEM -W123456 TEST`

---
image: mlikiowa/napcat-framework-docker
description: "napcat-framework-docker是NapCat框架的Docker镜像，用于简化NapCat框架的部署与运行，提供容器化环境以快速搭建基于NapCat的应用（如QQ机器人），支持环境隔离、配置持久化与便捷扩展，适用于开发和生产环境中NapCat服务的快速部署。"
source: https://xuanyuan.cloud/zh/r/mlikiowa/napcat-framework-docker
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[mlikiowa/napcat-framework-docker](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-framework-docker)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# napcat-framework-docker 镜像文档

## 镜像概述

napcat-framework-docker是NapCat框架的官方Docker镜像，旨在提供便捷、隔离的NapCat框架运行环境。NapCat是一款轻量级、高性能的应用框架（常用于构建QQ机器人等即时通讯应用），本镜像通过容器化技术简化其部署流程，消除环境依赖问题，支持快速启动和灵活配置。

## 核心功能与特性

- **容器化部署**：无需手动配置系统依赖，通过Docker一键启动NapCat框架
- **环境隔离**：独立运行环境，避免与主机系统环境冲突
- **配置持久化**：支持挂载外部配置文件和数据卷，确保配置和数据持久化存储
- **快速启动**：优化镜像构建，减少启动时间，支持秒级启动NapCat服务
- **多版本支持**：提供不同版本标签，适配NapCat框架的稳定版和开发版
- **日志集成**：支持标准输出日志，便于集成日志收集工具

## 使用场景与适用范围

- **个人开发者**：快速搭建基于NapCat的QQ机器人开发环境，简化本地测试流程
- **企业/团队**：在生产环境中部署稳定的NapCat服务，利用容器编排工具（如Docker Compose、Kubernetes）实现服务扩缩容
- **教学与演示**：标准化NapCat框架的运行环境，便于教学案例演示和学习

## 使用方法与配置说明

### 前提条件

- 已安装Docker Engine（20.10+版本）
- 已安装Docker Compose（可选，用于多容器编排）

### 获取镜像

从Docker Hub或私有仓库拉取镜像：

```bash
docker pull napcat/napcat-framework:latest  # 拉取最新稳定版
# 或指定版本标签
docker pull napcat/napcat-framework:v1.0.0
```

### 基本运行命令

#### 快速启动（默认配置）

```bash
docker run -d --name napcat-service \
  -p 8080:8080 \  # 映射服务端口（根据实际配置调整）
  napcat/napcat-framework:latest
```

#### 挂载配置文件与数据卷

为实现配置持久化，建议挂载外部配置目录和数据目录：

```bash
docker run -d --name napcat-service \
  -p 8080:8080 \
  -v /path/to/napcat/config:/app/config \  # 挂载配置目录
  -v /path/to/napcat/data:/app/data \      # 挂载数据目录
  napcat/napcat-framework:latest
```

#### 指定环境变量

通过环境变量自定义运行参数：

```bash
docker run -d --name napcat-service \
  -p 8080:8080 \
  -v /path/to/napcat/config:/app/config \
  -e NAPCAT_LOG_LEVEL=info \  # 日志级别（debug/info/warn/error）
  -e NAPCAT_PORT=8080 \       # 服务端口
  -e NAPCAT_AUTO_RESTART=true \  # 服务异常自动重启
  napcat/napcat-framework:latest
```

### Docker Compose 配置示例

创建`docker-compose.yml`文件，实现多容器协同或更复杂配置：

```yaml
version: '3.8'
services:
  napcat:
    image: napcat/napcat-framework:latest
    container_name: napcat-service
    restart: always
    ports:
      - "8080:8080"
    volumes:
      - ./config:/app/config
      - ./data:/app/data
    environment:
      - NAPCAT_LOG_LEVEL=info
      - NAPCAT_PORT=8080
    networks:
      - napcat-network

networks:
  napcat-network:
    driver: bridge
```

启动服务：

```bash
docker-compose up -d
```

### 环境变量说明

| 环境变量名               | 描述                     | 默认值       | 可选值                     |
|--------------------------|--------------------------|--------------|----------------------------|
| `NAPCAT_LOG_LEVEL`       | 日志输出级别             | `info`       | `debug`, `info`, `warn`, `error` |
| `NAPCAT_PORT`            | 服务监听端口             | `8080`       | 1-65535之间的整数          |
| `NAPCAT_AUTO_RESTART`    | 服务异常是否自动重启     | `false`      | `true`, `false`            |
| `NAPCAT_CONFIG_PATH`     | 配置文件路径             | `/app/config`| 容器内绝对路径             |
| `NAPCAT_DATA_PATH`       | 数据存储路径             | `/app/data`  | 容器内绝对路径             |

### 日志与监控

容器日志可通过Docker日志命令查看：

```bash
docker logs -f napcat-service  # 实时查看日志
```

## 注意事项

- 首次启动前，建议准备好NapCat框架的配置文件（如`config.json`），并通过数据卷挂载到容器内
- 生产环境中，建议使用固定版本标签（如`:v1.0.0`）而非`:latest`，避免版本更新导致兼容性问题
- 若需自定义网络或端口映射，确保主机端口未被占用，并在防火墙中开放对应端口

## 版本更新与维护

- 镜像版本与NapCat框架版本同步，可通过标签指定框架版本
- 定期拉取最新镜像以获取安全更新和功能优化：

```bash
docker pull napcat/napcat-framework:latest
docker-compose pull  # 使用Compose时更新镜像

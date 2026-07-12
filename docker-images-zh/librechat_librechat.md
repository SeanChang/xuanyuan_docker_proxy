---
image: librechat/librechat
description: "LibreChat的主镜像，由Dockerfile构建，用于部署LibreChat应用。"
source: https://xuanyuan.cloud/zh/r/librechat/librechat
canonical: https://xuanyuan.cloud/zh/r/librechat/librechat
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/librechat/librechat" title="librechat/librechat Docker 镜像中文简介、标签列表与拉取命令">librechat/librechat 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

该镜像为LibreChat的主镜像，基于Dockerfile构建，用于便捷部署LibreChat应用。LibreChat是一个开源的聊天解决方案，支持多种消息协议和自定义配置，适用于个人或团队搭建私有聊天服务。

## 核心功能与特性

- **官方主镜像**：LibreChat官方提供的主镜像，确保与应用版本同步更新
- **Dockerfile构建**：基于标准Dockerfile构建，环境可复现，保障部署一致性
- **容器化部署**：支持通过Docker快速部署，简化依赖配置与环境搭建流程
- **灵活配置**：可通过环境变量、配置文件等方式自定义应用参数

## 使用场景与适用范围

- 个人用户部署私有聊天服务
- 团队内部搭建协作沟通平台
- 开发测试环境中快速启动LibreChat实例
- 需要容器化、隔离部署聊天应用的场景

## 使用方法与配置说明

### 快速启动

使用以下命令快速部署LibreChat容器：

```bash
docker run -d --name librechat -p 3000:3000 docker.xuanyuan.run/librechat/main:latest
```

### 环境变量配置

通过`-e`参数设置环境变量自定义配置，常用参数包括：

- `PORT`：应用监听端口（默认3000）
- `DATABASE_URL`：数据库连接地址（如适用）
- `API_KEY`：第三方服务访问密钥（如适用）

示例（自定义端口与数据库）：

```bash
docker run -d \
  --name librechat \
  -p 8080:8080 \
  -e PORT=8080 \
  -e DATABASE_URL=postgres://user:pass@db:5432/librechat \
  docker.xuanyuan.run/librechat/main:latest
```

### Docker Compose配置

创建`docker-compose.yml`文件，示例配置如下：

```yaml
version: '3'
services:
  librechat:
    image: docker.xuanyuan.run/librechat/main:latest
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - DATABASE_URL=postgres://user:pass@db:5432/librechat
    depends_on:
      - db
  db:
    image: docker.xuanyuan.run/postgres:14
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=librechat
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

启动命令：`docker-compose up -d`

### 注意事项

- 首次启动可能需要初始化数据库，建议观察容器日志确认启动状态
- 生产环境建议挂载数据卷持久化应用数据，如：`-v ./librechat_data:/app/data`
- 修改端口时需同步调整容器内外端口映射，避免端口冲突

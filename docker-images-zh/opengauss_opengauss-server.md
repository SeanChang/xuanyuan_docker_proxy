---
image: opengauss/opengauss-server
description: "openGauss官方简化版镜像，提供轻量级企业级开源关系型数据库服务，精简非必要组件，保留核心功能，适用于开发、测试及轻量级生产环境，支持快速部署与简化配置。"
source: https://xuanyuan.cloud/zh/r/opengauss/opengauss-server
canonical: https://xuanyuan.cloud/zh/r/opengauss/opengauss-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opengauss/opengauss-server" title="opengauss/opengauss-server Docker 镜像中文简介、标签列表与拉取命令">opengauss/opengauss-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# openGauss 简化版官方镜像文档

## 镜像概述

openGauss简化版官方镜像是由openGauss社区官方构建的轻量级数据库镜像，基于openGauss稳定版本精简非必要组件，保留核心关系型数据库功能。该镜像体积更小、资源占用更低、启动速度更快，旨在为用户提供便捷、高效的数据库部署方案，适用于对资源敏感的场景及快速验证需求。

## 核心功能与特性

### 轻量级设计
- 精简镜像体积：去除调试工具、文档及部分扩展组件，镜像体积较完整版减少约40%
- 低资源占用：最小化内存需求（启动仅需512MB内存），CPU占用率低，适合资源受限环境

### 官方稳定支持
- 基于openGauss官方稳定版本构建，同步官方安全更新与漏洞修复
- 保留核心数据库功能：支持ACID事务、标准SQL语法、基本数据类型及索引机制

### 快速部署体验
- 简化初始化流程：自动完成数据库集群基础配置，无需手动执行初始化脚本
- 即开即用：容器启动后30秒内可完成数据库就绪，支持立即连接使用

## 使用场景

### 开发环境
- 本地开发调试：开发者无需复杂配置，通过容器快速搭建独立数据库环境
- CI/CD流程集成：作为自动化测试的数据库依赖，支持流水线中快速启停与重置

### 测试环境
- 功能验证：快速部署多版本实例，验证应用兼容性
- 性能基准测试：在资源隔离环境中测试数据库基础性能指标

### 轻量级生产环境
- 边缘计算场景：部署于边缘节点，支撑本地数据采集与简单分析
- 小流量应用：个人项目、内部工具等低并发场景，降低运维复杂度

## 使用方法

### 快速启动

通过`docker run`命令直接启动容器：

```bash
docker run -d \
  --name opengauss-simple \
  -p 5432:5432 \
  -e GS_PASSWORD="YourSecurePassword123" \
  docker.xuanyuan.run/opengauss/simple:latest
```

> 说明：
> - `-p 5432:5432`：映射容器内默认数据库端口到主机
> - `GS_PASSWORD`：必填环境变量，设置数据库超级用户（omm）密码，需满足复杂度要求（至少8位，包含大小写字母、数字及特殊符号）

### 环境变量说明

| 环境变量名       | 说明                          | 默认值       | 必要性  |
|------------------|-------------------------------|--------------|---------|
| `GS_PASSWORD`    | 超级用户（omm）密码           | 无           | 必填    |
| `GS_PORT`        | 数据库服务端口                | 5432         | 可选    |
| `GS_DB_NAME`     | 初始数据库名称                | postgres     | 可选    |
| `GS_ENCODING`    | 数据库默认编码                | UTF8         | 可选    |
| `GS_LOCALE`      | 数据库区域设置                | en_US.UTF-8  | 可选    |

### 数据持久化

通过挂载宿主机目录实现数据持久化，避免容器删除导致数据丢失：

```bash
docker run -d \
  --name opengauss-simple \
  -p 5432:5432 \
  -e GS_PASSWORD="YourSecurePassword123" \
  -v /path/on/host:/var/lib/opengauss/data \
  docker.xuanyuan.run/opengauss/simple:latest
```

> 注意：宿主机目录需提前创建并赋予读写权限（建议权限：`chmod 700 /path/on/host`）

### 连接数据库

容器启动后，通过`psql`客户端连接：

```bash
# 容器内连接
docker exec -it opengauss-simple gsql -U omm -d postgres -p 5432

# 外部客户端连接（需安装psql或兼容客户端）
psql -h localhost -p 5432 -U omm -d postgres
```

### Docker Compose 配置示例

创建`docker-compose.yml`文件：

```yaml
version: '3.8'
services:
  opengauss:
    image: docker.xuanyuan.run/opengauss/simple:latest
    container_name: opengauss-simple
    ports:
      - "5432:5432"
    environment:
      - GS_PASSWORD=YourSecurePassword123
      - GS_DB_NAME=appdb
    volumes:
      - ./data:/var/lib/opengauss/data
    restart: unless-stopped
```

启动服务：

```bash
docker-compose up -d
```

### 数据备份与恢复

#### 备份数据

```bash
# 进入容器执行备份
docker exec -it opengauss-simple \
  gs_dump -U omm -d postgres -f /tmp/backup.sql

# 复制备份文件到宿主机
docker cp opengauss-simple:/tmp/backup.sql ./backup.sql
```

#### 恢复数据

```bash
# 复制备份文件到容器内
docker cp ./backup.sql opengauss-simple:/tmp/backup.sql

# 进入容器执行恢复
docker exec -it opengauss-simple \
  gs_restore -U omm -d postgres /tmp/backup.sql
```

## 注意事项

- 密码安全：生产环境需使用强密码，并通过环境变量注入而非明文写在脚本中
- 资源限制：建议为容器设置内存限制（如`--memory=1g`），避免过度占用主机资源
- 版本管理：生产环境使用固定版本标签（如`2.1.0`）而非`latest`，确保部署一致性
- 数据备份：定期备份挂载卷中的数据，防止容器损坏导致数据丢失

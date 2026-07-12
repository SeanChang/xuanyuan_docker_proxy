---
image: cubejs/cube
description: "Cube.js的Docker镜像基于Debian环境，用于快速部署开源分析API平台，支持构建数据密集型应用后端，提供<version>、latest、dev等标签版本。"
source: https://xuanyuan.cloud/zh/r/cubejs/cube
canonical: https://xuanyuan.cloud/zh/r/cubejs/cube
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cubejs/cube" title="cubejs/cube Docker 镜像中文简介、标签列表与拉取命令">cubejs/cube 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Cube.js Docker 镜像文档


<p align="center"><a href="https://cube.dev"><img src="https://i.imgur.com/zYHXm4o.png" alt="Cube.js" width="300px"></a></p>

[官方网站](https://cube.dev) • [文档](https://cube.dev/docs) •
[博客](https://cube.dev/blog) • [Slack](https://slack.cube.dev) • [Twitter](https://twitter.com/the_cube_dev)


## 概述

### 镜像概述与主要用途
Cube.js 是一个开源分析 API 平台，主要用于构建内部业务智能（BI）工具或为现有应用添加客户面向的分析功能。该 Docker 镜像封装了 Cube.js 平台，提供便捷的部署方式，简化分析 API 服务的搭建流程。


## 核心功能与特性

- **无服务器查询引擎兼容**：专为 AWS Athena、Google BigQuery 等无服务器查询引擎设计，原生支持大规模数据查询场景。  
- **大规模数据处理能力**：采用多阶段查询方法，可高效处理万亿级数据点。  
- **广泛的数据库支持**：兼容主流关系型数据库（RDBMS），并可通过性能调优适配各类数据存储环境。  
- **模块化架构**：提供数据仓库转换建模、查询缓存、API 网关管理及 UI 构建等独立模块，专注单一功能优化。  


## 使用场景与适用范围

- **内部业务智能工具开发**：快速搭建企业内部数据可视化与分析平台，支持自定义报表与数据探索。  
- **客户面向的分析功能集成**：为 SaaS 应用或现有系统添加嵌入式分析模块，提供客户数据洞察。  
- **大规模数据分析平台**：需处理海量数据（如日志、用户行为数据）的场景，利用其高效查询能力实现低延迟分析。  


## 支持的标签与架构

### 镜像标签
基于 Debian 系统的镜像标签：  
- `<version>`：指定版本（如 `v0.34.0`）  
- `latest`：最新稳定版  
- `dev`：开发版  


### 支持的架构
- `amd64`  


## 快速参考

- **获取帮助**：  
  - [Slack 社区](https://slack.cube.dev/)  
  - [Stack Overflow](https://stackoverflow.com/search?q=cube.js)  
  - [GitHub Discussions](https://github.com/cube-js/cube.js/discussions)  

- **问题反馈**：通过 [GitHub Issues](https://github.com/cube-js/cube.js/issues) 提交。  

- **官方文档**：[Cube.js 文档网站](https://cube.dev/docs)  


## 使用方法

### 启动 Cube.js 实例

#### 拉取镜像
```bash
docker pull docker.xuanyuan.run/cubejs/cube:latest
```

#### 运行容器
```bash
docker run -d -p 3000:3000 -p 4000:4000 \
  -e CUBEJS_DB_HOST=<数据库主机地址> \
  -e CUBEJS_DB_NAME=<数据库名称> \
  -e CUBEJS_DB_USER=<数据库用户名> \
  -e CUBEJS_DB_PASS=<数据库密码> \
  -e CUBEJS_DB_TYPE=<数据库类型> \
  -e CUBEJS_API_SECRET=<API密钥> \
  -v $(pwd):/cube/conf \
  docker.xuanyuan.run/cubejs/cube:latest
```

**说明**：  
- 端口映射：`3000` 为仪表盘应用端口（若创建），`4000` 为 Cube.js API 与开发者 playground 端口。  
- 卷挂载：`$(pwd):/cube/conf` 将当前目录挂载到容器内的配置目录，用于持久化配置文件。  
- 启动后，开发者 playground 可通过 `http://localhost:4000` 访问。  


### 使用 Docker Compose 部署

推荐使用 Docker Compose 管理服务依赖（如 Redis 用于缓存），配置示例如下：

```yaml
version: '2.2'

services:
  cube:
    image: docker.xuanyuan.run/cubejs/cube:latest
    depends_on:
      - redis
    links:
      - redis
    ports:
      - 4000:4000  # Cube.js API 与开发者 playground
      - 3000:3000  # 仪表盘应用（若创建）
    env_file: .env  # 环境变量配置文件
    volumes:
      - .:/cube/conf  # 挂载本地配置目录，支持自定义依赖

  redis:
    image: docker.xuanyuan.run/redis:6
    restart: always  # Redis 服务自动重启
```

**说明**：  
- `depends_on` 确保 Cube.js 在 Redis 启动后运行。  
- `env_file: .env` 从本地 `.env` 文件加载环境变量，避免命令行硬编码敏感信息。  
- Redis 用于 Cube.js 的缓存功能，提升查询性能。  


## 配置参数说明

Cube.js 通过环境变量配置核心参数，常用变量如下：

| 环境变量                | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| `CUBEJS_DB_HOST`        | 数据库主机地址（如 `postgres://hostname` 或 IP 地址）                 |
| `CUBEJS_DB_NAME`        | 目标数据库名称                                                       |
| `CUBEJS_DB_USER`        | 数据库访问用户名                                                     |
| `CUBEJS_DB_PASS`        | 数据库访问密码                                                       |
| `CUBEJS_DB_TYPE`        | 数据库类型（如 `postgres`、`bigquery`、`athena` 等，需与数据库对应） |
| `CUBEJS_API_SECRET`     | API 访问密钥，用于验证客户端请求，建议使用强随机字符串               |
| `CUBEJS_REDIS_URL`      | Redis 服务地址（默认使用 `redis://redis:6379`，适用于 Docker Compose 部署） |


## 许可证

Cube.js Docker 镜像采用 [Apache 2.0 许可](https://github.com/cube-js/cube.js/blob/master/LICENSE)。

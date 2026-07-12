---
image: manageiq/memcached
description: "基于CentOS构建的包含memcached的容器，用于ManageIQ"
source: https://xuanyuan.cloud/zh/r/manageiq/memcached
canonical: https://xuanyuan.cloud/zh/r/manageiq/memcached
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/manageiq/memcached" title="manageiq/memcached Docker 镜像中文简介、标签列表与拉取命令">manageiq/memcached 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# container-memcached 技术文档


## 镜像概述和主要用途  
container-memcached 是基于 CentOS 7 构建的 memcached 服务器容器，集成了 memcached 缓存服务，专为 ManageIQ 平台及需要分布式缓存的应用场景设计。该镜像提供轻量级、高性能的键值对缓存能力，可作为应用层与数据库之间的中间缓存层，提升数据访问效率。


## 核心功能和特性  
### 核心功能  
- 基于 CentOS 7 系统环境，提供稳定的运行底座；  
- 集成 memcached 缓存服务，支持标准 memcached 协议；  
- 支持通过环境变量自定义配置，灵活适配不同场景需求。  

### 特性  
- **轻量级**：镜像体积精简，资源占用低；  
- **可配置**：支持内存分配、最大连接数等核心参数自定义；  
- **兼容性**：兼容主流 memcached 客户端（如 Python-memcached、Java Memcached Client 等）；  
- **ManageIQ 优化**：针对 ManageIQ 平台的缓存需求进行适配，可直接集成至 ManageIQ 部署架构。  


## 使用场景和适用范围  
### 典型场景  
1. **ManageIQ 平台部署**：作为 ManageIQ 平台的缓存组件，加速数据查询和状态管理；  
2. **分布式应用缓存**：为微服务、分布式系统提供跨节点数据缓存，减少数据库访问压力；  
3. **会话存储**：存储用户会话数据，支持多实例应用的会话共享；  
4. **高频访问数据缓存**：缓存静态资源、热点数据（如商品信息、用户配置等），提升应用响应速度。  

### 适用范围  
- 需要轻量级键值缓存的应用；  
- 基于 CentOS 7 环境的部署场景；  
- 对缓存性能要求中等、稳定性要求较高的业务；  
- 开发/测试环境的临时缓存服务。  


## 使用方法和配置说明  

### 快速启动（docker run）  
通过 `docker run` 命令可快速启动容器，默认配置下监听 11211 端口：  
```bash
docker run -d --name memcached-server -p 11211:11211 docker.xuanyuan.run/container-memcached
```  

#### 自定义配置示例  
指定分配 128MB 内存、最大 2048 个连接，并映射主机 11212 端口：  
```bash
docker run -d \
  --name memcached-custom \
  -p 11212:11211 \
  -e MEMCACHED_MEMORY=128 \
  -e MEMCACHED_CONNECTIONS=2048 \
  docker.xuanyuan.run/container-memcached
```  


### docker-compose 配置示例  
通过 `docker-compose.yml` 定义服务，适合多容器协同部署（如与 ManageIQ 联动）：  
```yaml
version: '3'
services:
  memcached:
    image: docker.xuanyuan.run/container-memcached
    container_name: memcached
    ports:
      - "11211:11211"
    environment:
      - MEMCACHED_MEMORY=256  # 分配 256MB 内存
      - MEMCACHED_CONNECTIONS=4096  # 最大连接数 4096
      - MEMCACHED_VERBOSE=yes  # 开启详细日志（可选）
    restart: unless-stopped
```  

启动命令：  
```bash
docker-compose up -d
```  


## 详细配置参数  
容器支持通过环境变量配置 memcached 核心参数，参数说明如下：  

| 环境变量                | 描述                          | 默认值    | 示例值       |
|-------------------------|-------------------------------|-----------|--------------|
| `MEMCACHED_PORT`        | 服务监听端口                  | 11211     | 11212        |
| `MEMCACHED_MEMORY`      | 分配内存大小（MB）            | 64        | 128          |
| `MEMCACHED_CONNECTIONS` | 最大并发连接数                | 1024      | 2048         |
| `MEMCACHED_VERBOSE`     | 是否开启详细日志（yes/no）    | no        | yes          |
| `MEMCACHED_USER`        | 运行 memcached 的用户         | memcached | root         |
| `MEMCACHED_MAX_ITEM`    | 最大单个 item 大小（bytes）   | 1048576   | 2097152      |


## 注意事项  
1. **端口映射**：若主机 11211 端口被占用，需通过 `MEMCACHED_PORT` 调整容器内端口，并同步修改主机映射端口；  
2. **内存配置**：根据实际业务需求调整 `MEMCACHED_MEMORY`，避免过度分配导致主机内存不足；  
3. **安全防护**：生产环境建议限制访问来源（如通过 `docker network` 隔离或主机防火墙策略），memcached 默认无认证机制；  
4. **持久化**：memcached 为内存数据库，重启后数据丢失，需结合业务场景评估是否需要外部持久化方案。

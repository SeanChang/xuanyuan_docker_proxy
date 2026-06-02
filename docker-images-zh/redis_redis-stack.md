---
image: redis/redis-stack
description: "Redis Stack是一个集成方案，它安装Redis服务器并赋予其额外的数据库功能，如搜索、JSON数据处理、时间序列管理等，同时包含RedisInsight这一可视化管理工具，帮助用户便捷部署、监控和管理Redis数据库，有效提升开发与运维效率。"
source: https://xuanyuan.cloud/zh/r/redis/redis-stack
canonical: https://xuanyuan.cloud/zh/r/redis/redis-stack
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redis/redis-stack" title="redis/redis-stack Docker 镜像中文简介、标签列表与拉取命令">redis/redis-stack 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 在 Docker 上运行 Redis Stack  
## 如何使用 Docker 安装 Redis Stack  


### 选择 Docker 镜像  
使用 Docker 安装 Redis Stack 前，需先选择合适的镜像：  
- `redis/redis-stack`：包含 Redis Stack 服务器和 RedisInsight 可视化工具，适合本地开发（可通过 RedisInsight 查看数据）。  
- `redis/redis-stack-server`：仅包含 Redis Stack 服务器，不含 RedisInsight，适合生产环境部署。  


### 开始使用  

默认配置下，Redis 无需密码即可访问。为提升安全性，建议通过 `requirepass` 指令设置密码，可在启动容器时通过环境变量配置。  


#### 启动 Redis Stack 服务器  
若使用 `redis/redis-stack` 镜像，在终端运行以下命令启动容器（包含端口映射与密码设置）：  
```bash  
docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 -e REDIS_ARGS="--requirepass mypassword" redis/redis-stack:latest  
```  
- `-d`：后台运行容器；`--name`：指定容器名称为 `redis-stack`；  
- `-p 6379:6379`：映射 Redis 服务器端口（宿主机:容器）；  
- `-p 8001:8001`：映射 RedisInsight 端口；  
- `-e REDIS_ARGS="--requirepass mypassword"`：通过环境变量设置 Redis 密码为 `mypassword`。  


#### 连接 Redis 服务器  
启动后，可通过 `redis-cli` 连接服务器，方式与常规 Redis 实例相同：  
```bash  
redis-cli -h localhost -p 6379 -a mypassword  
```  
若本地未安装 `redis-cli`，可直接从容器内运行：  
```bash  
docker exec -it redis-stack redis-cli -a mypassword  
```  


#### RedisInsight 访问  
上述启动命令已暴露 RedisInsight 到宿主机 8001 端口，打开浏览器访问 `[] 即可使用该工具。  

> 注：Redis Stack 支持多用户配置（含独立密码与权限控制），详见 [Redis 访问控制列表文档]([])。  


### 配置说明  

#### 持久化数据  
如需将 Redis 数据持久化到本地路径，可通过 `-v` 参数挂载本地卷。以下命令将数据存储到本地 `local-data` 目录：  
```bash  
docker run -v /local-data/:/data redis/redis-stack:latest  
```  


#### 自定义端口  
若需修改 Redis 服务器或 RedisInsight 的暴露端口，调整 `-p` 参数左侧的宿主机端口即可。例如，将服务器暴露到 10001 端口、RedisInsight 暴露到 13333 端口：  
```bash  
docker run -p 10001:6379 -p 13333:8001 redis/redis-stack:latest  
```  


#### 使用本地配置文件  
默认情况下，容器使用内部配置文件。如需加载本地配置文件，通过 `-v` 挂载文件到容器的 `/redis-stack.conf`：  
```bash  
docker run -v `pwd`/local-redis-stack.conf:/redis-stack.conf -p 6379:6379 -p 8001:8001 redis/redis-stack:latest  
```  


#### 环境变量配置  
可通过环境变量传递自定义配置参数，支持以下变量（按需设置）：  
- `REDIS_ARGS`：Redis 核心服务的额外参数  
- `REDISEARCH_ARGS`：RediSearch 模块参数  
- `REDISJSON_ARGS`：RedisJSON 模块参数  
- `REDISGRAPH_ARGS`：RedisGraph 模块参数  
- `REDISTIMESERIES_ARGS`：RedisTimeSeries 模块参数  
- `REDISBLOOM_ARGS`：RedisBloom 模块参数  


**示例**：  
- 通过 `REDIS_ARGS` 设置密码：  
  ```bash  
  docker run -e REDIS_ARGS="--requirepass redis-stack" redis/redis-stack:latest  
  ```  
- 通过 `REDISTIMESERIES_ARGS` 设置数据保留策略（如保留 20 秒）：  
  ```bash  
  docker run -e REDISTIMESERIES_ARGS="RETENTION_POLICY=20" redis/redis-stack:latest  
  ```

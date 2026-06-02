---
image: redis/redis-stack-server
description: "redis-stack-server是一款用于安装Redis服务器的工具，它在标准Redis服务器的基础上，集成了多种额外的数据库功能，包括对JSON数据类型的原生支持、高效的全文搜索能力、时间序列数据的专门管理机制以及概率数据结构（如布隆过滤器）等，这些扩展功能显著增强了Redis的数据处理多样性和应用灵活性，使其能够更好地满足实时数据分析、内容检索、多模型数据存储等复杂场景的需求。"
source: https://xuanyuan.cloud/zh/r/redis/redis-stack-server
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[redis/redis-stack-server](https://xuanyuan.cloud/zh/r/redis/redis-stack-server)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# 在Docker上运行Redis Stack


## 如何通过Docker安装Redis Stack  

使用Docker安装Redis Stack前，需先选择合适的Docker镜像：  

- `redis/redis-stack`：包含Redis Stack服务器和RedisInsight可视化工具，适合本地开发（可通过RedisInsight直观查看数据）。  
- `redis/redis-stack-server`：仅包含Redis Stack服务器，不含RedisInsight，适合生产环境部署。  


## 快速开始  

默认配置下，Redis无需密码即可连接。为提升安全性，建议通过`requirepass`指令设置密码，启动容器时可通过环境变量配置：  

### 启动Redis Stack服务器  
使用`redis-stack-server`镜像启动服务器，命令如下（后台运行，指定容器名、端口映射及密码）：  
```bash
docker run -d --name redis-stack -p 6379:6379 -e REDIS_ARGS="--requirepass mypassword" redis/redis-stack-server:latest
```  

### 连接服务器  
- 若本地已安装`redis-cli`，可直接连接：`redis-cli -h localhost -p 6379 -a mypassword`。  
- 若未安装，可通过容器内的`redis-cli`连接：  
  ```bash
  docker exec -it redis-stack redis-cli
  ```  

> 如需配置多用户及权限控制，可参考[Redis访问控制列表文档]([])。  


## 配置说明  

### 持久化数据  
通过`-v`参数挂载本地目录到容器的`/data`目录，实现数据持久化。例如，将数据存储到本地`local-data`目录：  
```bash
docker run -v /local-data/:/data redis/redis-stack-server:latest
```  

### 端口映射  
默认Redis Stack服务器端口为6379，RedisInsight（若使用`redis/redis-stack`镜像）为8001。如需修改宿主机端口，调整`-p`参数左侧值（宿主机端口:容器端口）。例如，将Redis服务器映射到10001端口，RedisInsight映射到13333端口：  
```bash
docker run -p 10001:6379 -p 13333:8001 redis/redis-stack:latest  # 注意：RedisInsight仅在redis/redis-stack镜像中可用
```  

### 使用本地配置文件  
默认容器使用内部配置文件。如需加载本地配置文件，通过`-v`挂载本地文件到容器的`/redis-stack.conf`：  
```bash
docker run -v `pwd`/local-redis-stack.conf:/redis-stack.conf -p 6379:6379 redis/redis-stack-server:latest
```  
（`pwd`表示当前目录，需确保本地配置文件路径正确）  


### 环境变量配置  
可通过环境变量传递额外配置参数，支持以下变量：  

| 环境变量               | 用途                     |  
|------------------------|--------------------------|  
| `REDIS_ARGS`           | Redis服务器的额外参数    |  
| `REDISEARCH_ARGS`       | RediSearch模块参数       |  
| `REDISJSON_ARGS`       | RedisJSON模块参数        |  
| `REDISGRAPH_ARGS`      | RedisGraph模块参数       |  
| `REDISTIMESERIES_ARGS` | RedisTimeSeries模块参数  |  
| `REDISBLOOM_ARGS`      | RedisBloom模块参数       |  


#### 示例  
- 通过`REDIS_ARGS`设置密码：  
  ```bash
  docker run -e REDIS_ARGS="--requirepass redis-stack" redis/redis-stack-server:latest
  ```  
- 通过`REDISTIMESERIES_ARGS`设置数据保留策略（如保留20秒）：  
  ```bash
  docker run -e REDISTIMESERIES_ARGS="RETENTION_POLICY=20" redis/redis-stack-server:latest
  ```

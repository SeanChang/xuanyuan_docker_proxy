---
image: cockroachdb/cockroach
description: "CockroachDB是用于支持持续可用客户体验的分布式SQL数据库"
source: https://xuanyuan.cloud/zh/r/cockroachdb/cockroach
canonical: https://xuanyuan.cloud/zh/r/cockroachdb/cockroach
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cockroachdb/cockroach" title="cockroachdb/cockroach Docker 镜像中文简介、标签列表与拉取命令">cockroachdb/cockroach 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CockroachDB Docker镜像文档


## 1. 镜像概述和主要用途

### 概述  
CockroachDB是一款分布式SQL数据库，专为提供"始终在线"（always-on）的客户体验设计。通过Docker镜像部署，可简化其在开发、测试及生产环境中的安装、配置与运行流程，支持从单节点本地部署到跨多主机的大规模分布式集群。

### 主要用途  
作为分布式SQL数据库，CockroachDB适用于需要**强一致性**、**高可用性**和**水平扩展能力**的业务场景，如金融交易系统、电商平台、实时分析服务等对数据可靠性和服务连续性要求极高的应用。


## 2. 核心功能和特性

- **分布式架构**：去中心化设计，数据自动分片并分布于集群节点，支持无缝水平扩展  
- **强一致性**：基于Raft共识算法，确保分布式环境下的数据一致性和事务ACID特性  
- **高可用性**：自动故障检测与恢复，节点故障不影响服务可用性，支持跨区域部署  
- **SQL兼容性**：兼容PostgreSQL协议，支持标准SQL语法、复杂查询、事务及索引等功能  
- **容错能力**：默认3副本数据复制，可容忍节点、机架甚至数据中心级别的故障  
- **动态扩展**：无需停机即可添加/移除节点，集群规模随业务需求动态调整  


## 3. 使用场景和适用范围

### 开发与测试环境  
- **单节点部署**：用于本地功能验证、单元测试或原型开发  
- **多节点单主机集群**：模拟分布式环境，测试集群容错、数据分片等特性  


### 生产环境  
- **单Docker主机多节点**：资源受限的小型应用或演示环境，通过容器隔离实现多节点集群  
- **跨多Docker主机分布式集群**：结合Kubernetes、Docker Swarm等编排工具，构建跨主机/跨区域的高可用集群，满足大规模生产业务需求  


### 适用业务类型  
- 需7x24小时连续服务的核心业务（如支付系统、用户数据管理）  
- 对数据强一致性和事务可靠性要求高的场景（如金融交易、订单系统）  
- 需支持高并发读写并随业务增长动态扩展的应用（如电商平台、实时监控）  


## 4. 详细使用方法和配置说明

### 4.1 安装CockroachDB Docker镜像  
通过Docker安装CockroachDB的详细步骤请参考官方文档：[Install CockroachDB](https://www.cockroachlabs.com/docs/stable/install-cockroachdb.html)  


### 4.2 单节点集群部署（本地测试）  
适用于开发或测试环境，启动单节点CockroachDB并暴露SQL端口（26257）和管理UI端口（8080）：  

```bash
# 启动单节点容器（--insecure用于测试，生产环境需启用TLS）
docker run -d \
  --name=roach-single \
  -p 26257:26257 \  # SQL客户端连接端口
  -p 8080:8080 \    # 管理UI端口
  -v "${PWD}/data:/cockroach/cockroach-data" \  # 持久化数据卷
  cockroachdb/cockroach:latest \
  start-single-node \  # 单节点模式启动命令
  --insecure \         # 禁用TLS（仅测试用）
  --listen-addr=0.0.0.0:26257 \  # 允许外部连接
  --http-addr=0.0.0.0:8080       # 管理UI监听地址
```

**验证部署**：访问 `http://localhost:8080` 查看管理UI，或通过SQL客户端连接 `postgres://root@localhost:26257/defaultdb?sslmode=disable`。


### 4.3 多节点集群（单Docker主机）  
在单Docker主机上部署多节点集群，需先创建专用网络以实现容器间通信：  

#### 步骤1：创建Docker网络  
```bash
docker network create roachnet  # 创建桥接网络，供集群节点通信
```

#### 步骤2：启动集群节点  
以3节点集群为例，节点间通过`--join`参数指定初始集群成员：  

```bash
# 节点1（初始化集群）
docker run -d \
  --name=roach1 \
  --net=roachnet \
  -p 26257:26257 \  # 暴露SQL端口到主机
  -p 8080:8080 \    # 暴露管理UI端口到主机
  -v "${PWD}/data/roach1:/cockroach/cockroach-data" \
  cockroachdb/cockroach:latest \
  start \
  --insecure \
  --listen-addr=roach1:26257 \  # 节点1容器内地址
  --http-addr=roach1:8080 \
  --join=roach1:26257,roach2:26257,roach3:26257  # 集群节点列表

# 节点2
docker run -d \
  --name=roach2 \
  --net=roachnet \
  -v "${PWD}/data/roach2:/cockroach/cockroach-data" \
  docker.xuanyuan.run/cockroachdb/cockroach:latest \
  start \
  --insecure \
  --listen-addr=roach2:26257 \
  --http-addr=roach2:8080 \
  --join=roach1:26257,roach2:26257,roach3:26257

# 节点3
docker run -d \
  --name=roach3 \
  --net=roachnet \
  -v "${PWD}/data/roach3:/cockroach/cockroach-data" \
  docker.xuanyuan.run/cockroachdb/cockroach:latest \
  start \
  --insecure \
  --listen-addr=roach3:26257 \
  --http-addr=roach3:8080 \
  --join=roach1:26257,roach2:26257,roach3:26257
```

**验证集群**：通过节点1的管理UI（`http://localhost:8080`）查看集群状态，或执行以下命令检查节点：  
```bash
docker exec -it roach1 cockroach node status --insecure --host=roach1:26257
```


### 4.4 跨多Docker主机的多节点集群  
对于生产环境的跨主机分布式集群，需结合容器编排工具实现节点发现、网络配置和服务管理，具体方案参考官方文档：  
- [使用Kubernetes编排](https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-kubernetes.html)  
- [使用Docker Swarm编排](https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-docker-swarm.html)  


### 4.5 核心配置参数说明  

| 参数                | 作用说明                                                                 |
|---------------------|--------------------------------------------------------------------------|
| `start-single-node` | 单节点模式启动命令（自动初始化集群）                                      |
| `start`             | 多节点模式启动命令（需配合`--join`指定集群节点）                         |
| `--insecure`        | 禁用TLS加密（仅测试用，生产环境需通过`--certs-dir`指定证书目录）          |
| `--listen-addr`     | 节点间通信地址（格式：`主机:端口`，容器内需使用容器名或IP）               |
| `--http-addr`       | 管理UI监听地址                                                           |
| `--join`            | 集群初始节点列表（格式：`节点1:端口,节点2:端口,...`，用于节点发现）       |
| `--store`           | 数据存储路径（默认`/cockroach/cockroach-data`，建议通过Docker卷挂载持久化） |


### 4.6 Docker Compose配置示例（单主机3节点集群）  

创建 `docker-compose.yml` 文件，简化多节点集群部署：  

```yaml
version: '3.8'

services:
  roach1:
    image: docker.xuanyuan.run/cockroachdb/cockroach:latest
    container_name: roach1
    command: start --insecure --listen-addr=roach1:26257 --http-addr=roach1:8080 --join=roach1:26257,roach2:26257,roach3:26257
    ports:
      - "26257:26257"  # SQL端口
      - "8080:8080"    # 管理UI端口
    volumes:
      - ./data/roach1:/cockroach/cockroach-data
    networks:
      - roachnet

  roach2:
    image: docker.xuanyuan.run/cockroachdb/cockroach:latest
    container_name: roach2
    command: start --insecure --listen-addr=roach2:26257 --http-addr=roach2:8080 --join=roach1:26257,roach2:26257,roach3:26257
    volumes:
      - ./data/roach2:/cockroach/cockroach-data
    networks:
      - roachnet

  roach3:
    image: docker.xuanyuan.run/cockroachdb/cockroach:latest
    container_name: roach3
    command: start --insecure --listen-addr=roach3:26257 --http-addr=roach3:8080 --join=roach1:26257,roach2:26257,roach3:26257
    volumes:
      - ./data/roach3:/cockroach/cockroach-data
    networks:
      - roachnet

networks:
  roachnet:
    driver: bridge  # 桥接网络，实现容器间通信

volumes:
  roach1-data:
  roach2-data:
  roach3-data:
```

**启动集群**：  
```bash
docker-compose up -d  # 后台启动所有节点
docker-compose logs -f  # 查看集群日志
```


## 5. 注意事项  
- **生产环境安全**：禁用`--insecure`，通过`--certs-dir`指定TLS证书目录（证书生成方法参考[官方文档](https://www.cockroachlabs.com/docs/stable/cockroach-cert)）。  
- **数据持久化**：必须通过Docker卷（`-v`参数）挂载数据目录，避免容器删除导致数据丢失。  
- **资源配置**：根据集群规模调整容器CPU/内存限制（如`--cpus=2 --memory=4g`），避免资源竞争影响性能。

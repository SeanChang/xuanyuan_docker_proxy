---
image: apache/seata-server
description: "Apache Seata是一款开源的分布式事务解决方案，致力于为微服务架构提供高性能、简单易用的分布式事务服务，支持AT、TCC、SAGA和XA四种事务模式，能够帮助开发者快速解决分布式系统中的数据一致性问题，具备良好的兼容性与可扩展性，适用于各类微服务场景，由Apache软件基金会孵化并维护，拥有活跃的社区支持。"
source: https://xuanyuan.cloud/zh/r/apache/seata-server
canonical: https://xuanyuan.cloud/zh/r/apache/seata-server
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/seata-server" title="apache/seata-server Docker 镜像中文简介、标签列表与拉取命令">apache/seata-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Seata Server


## 什么是Seata  
Seata 是一款适用于微服务架构的高性能、易用的分布式事务解决方案。


## 支持的镜像标签  
seata-server 镜像基于 openjdk8 构建。


## 快速开始  


### 启动 seata-server 实例  
通过以下命令快速启动一个默认配置的 seata-server 容器：  
```bash
$ docker run -p 8091:8091 -p 7091:7091 --name=seata-server --restart=always -d apache/seata-server:latest
```  


### 使用自定义配置文件启动  
若需使用自定义配置，需将配置文件挂载到容器内，并通过环境变量指定配置路径。步骤如下：  

1. **准备配置文件**：将自定义配置文件（如 `registry.conf`、`file.conf`）放在本地目录（例如 `/PATH/TO/CONFIG_FILE`）。  
2. **启动容器**：通过 `-v` 挂载本地配置目录，同时设置 `SEATA_CONFIG_NAME` 环境变量指定配置文件路径（需以 `file:` 开头）：  
```bash
$ docker run --name seata-server \
  -p 8091:8091 \
  -p 7091:7091 \
  -e SEATA_CONFIG_NAME=file:/root/seata-config/registry \  # 指定配置文件路径，对应 /root/seata-config/registry.conf
  -v /PATH/TO/CONFIG_FILE:/root/seata-config  \  # 挂载本地配置目录到容器内 /root/seata-config
  apache/seata-server
```  

> 说明：容器默认配置文件路径为 `/seata-server/resources`，建议将自定义配置放在其他目录（如上述 `/root/seata-config`），避免覆盖默认配置。  


### 指定服务器 IP 启动  
若需在注册中心（如 eureka）中使用指定 IP（而非容器 IP），可通过 `SEATA_IP` 环境变量设置：  
```bash
$ docker run --name seata-server \
  -p 8091:8091 \
  -p 7091:7091 \
  -e SEATA_IP=192.168.1.1  # 指定注册中心中使用的 IP
  apache/seata-server
```  


### 使用 Docker Compose 启动  
创建 `docker-compose.yaml` 文件，示例配置如下：  
```yaml
version: "3.1"

services:
  seata-server:
    image: apache/seata-server:latest
    hostname: seata-server
    ports:
      - 8091:8091  # 服务端口
      - 7091:7091  # 通信端口
    environment:
      - SEATA_PORT=8091  # 可选，指定服务端口（默认 8091）
    expose:
      - 8091
      - 7091
```  
执行启动命令：  
```bash
$ docker-compose up -d
```  


## 容器命令行访问与日志查看  


### 进入容器命令行  
通过 `docker exec` 进入运行中的容器：  
```bash
$ docker exec -it seata-server sh
```  


### 查看容器日志  
通过 `docker logs` 实时查看服务日志：  
```bash
$ docker logs -f seata-server
```  


## 环境变量  
可通过以下环境变量调整 seata-server 配置：  

| 环境变量          | 说明                                                                 |
|-------------------|----------------------------------------------------------------------|
| **SEATA_IP**      | 可选，指定注册中心中使用的 IP（替代容器 IP），适用于 eureka 等注册中心。 |
| **SEATA_PORT**    | 可选，指定服务端口，默认 `8091`。                                      |
| **STORE_MODE**    | 可选，事务日志存储方式，支持 `db`（数据库）或 `file`（文件），默认 `file`。 |
| **SERVER_NODE**   | 可选，节点 ID，如 `1`、`2` 等，默认 `1`（用于集群部署标识节点）。        |
| **SEATA_ENV**     | 可选，运行环境，如 `dev`、`test`，启动时将加载 `registry-dev.conf` 等环境特定配置。 |
| **SEATA_CONFIG_NAME** | 可选，指定配置文件路径，格式为 `file:/路径/文件名`（不含 `.conf` 后缀），例如 `file:/root/seata-config/registry` 会加载 `/root/seata-config/registry.conf`。 |  


## 快速参考  


### 获取帮助  
- [Seata 代码仓库]([])  
- [Seata 官方文档]([])  
- 钉钉群：扫码加入（群二维码见 [官方仓库]([])）  


### 提交问题  
若遇到问题，可在 [Seata Issue 页面]([]) 提交反馈。

---
image: seataio/seata-server
description: "这是一款专为微服务架构打造的分布式事务解决方案，兼具高性能与易用性核心特性。在微服务架构中，跨服务事务的数据一致性管理常面临复杂挑战，该方案通过优化底层处理逻辑实现低延迟、高吞吐量的高性能表现，同时简化集成流程并提供直观操作接口，大幅降低开发者的学习与使用门槛，助力技术团队高效应对分布式环境下的事务协调需求，切实保障业务数据的准确性及系统运行的稳定性。"
source: https://xuanyuan.cloud/zh/r/seataio/seata-server
canonical: https://xuanyuan.cloud/zh/r/seataio/seata-server
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/seataio/seata-server" title="seataio/seata-server Docker 镜像中文简介、标签列表与拉取命令">seataio/seata-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Seata Server 介绍


## 什么是 Seata  
Seata 是一款适用于微服务架构的分布式事务解决方案，具备高性能、易使用的特点。


## 镜像说明  
Seata Server 镜像基于 OpenJDK 8 构建，确保运行环境的稳定性和兼容性。


## 快速开始  

### 启动 Seata Server 实例  
通过以下命令快速启动一个默认配置的 Seata Server 容器，映射 8091（服务端口）和 7091（通信端口）：  
```bash
$ docker run -p 8091:8091 -p 7091:7091 --name=seata-server --restart=always -d seataio/seata-server:latest
```  
- `--restart=always`：容器退出时自动重启  
- `-d`：后台运行  


### 自定义配置文件启动  
如需使用本地自定义配置，需挂载配置文件目录并指定配置路径：  
1. 将本地配置文件（如 `registry.conf`、`file.conf`）放在 `/PATH/TO/CONFIG_FILE` 目录下；  
2. 通过 `-v` 挂载本地目录到容器内 `/root/seata-config`；  
3. 用 `SEATA_CONFIG_NAME` 指定配置文件路径（需以 `file:` 开头）：  
```bash
$ docker run --name seata-server \
  -p 8091:8091 -p 7091:7091 \
  -e SEATA_CONFIG_NAME=file:/root/seata-config/registry \  # 配置文件路径
  -v /PATH/TO/CONFIG_FILE:/root/seata-config  \  # 挂载本地配置目录
  seataio/seata-server
```  


### 指定服务器 IP 启动  
若需向注册中心（如 Eureka）注册特定 IP，可通过 `SEATA_IP` 环境变量指定：  
```bash
$ docker run --name seata-server \
  -p 8091:8091 -p 7091:7091 \
  -e SEATA_IP=192.168.1.1  # 替换为实际服务器 IP
  seataio/seata-server
```  


### Docker Compose 启动  
创建 `docker-compose.yaml` 文件，配置示例如下：  
```yaml
version: "3.1"
services:
  seata-server:
    image: seataio/seata-server:latest
    hostname: seata-server
    ports:
      - 8091:8091  # 服务端口
      - 7091:7091  # 通信端口
    environment:
      - SEATA_PORT=8091  # 指定服务端口（默认 8091）
    expose:
      - 8091
      - 7091
```  
启动命令：`docker-compose up -d`  


## 容器操作  

### 进入容器终端  
通过以下命令进入运行中的 Seata Server 容器：  
```bash
$ docker exec -it seata-server sh
```  


### 查看容器日志  
实时查看 Seata Server 运行日志：  
```bash
$ docker logs -f seata-server
```  


## 自定义配置文件说明  
- **默认配置路径**：容器内 `/seata-server/resources`（不建议直接修改）。  
- **自定义配置建议**：将配置文件放在本地目录，通过 `-v` 挂载到容器其他路径（如 `/root/seata-config`）。  
- **必须设置环境变量**：`SEATA_CONFIG_NAME`，格式为 `file:/路径/文件名`（无需 `.conf` 后缀），例如 `file:/root/seata-config/registry` 会加载 `/root/seata-config/registry.conf`。  


## 环境变量配置  
可通过环境变量调整 Seata Server 运行参数，常用变量说明如下：  

| 变量名            | 说明                                                                 | 可选性 | 默认值   |
|-------------------|----------------------------------------------------------------------|--------|----------|
| `SEATA_IP`        | 向注册中心注册的 IP（如 Eureka）                                      | 可选   | 容器 IP  |
| `SEATA_PORT`      | 服务端口                                                             | 可选   | 8091     |
| `STORE_MODE`      | 事务日志存储方式（支持 `db` 数据库或 `file` 文件）                    | 可选   | `file`   |
| `SERVER_NODE`     | 节点 ID（用于集群部署，如 `1`、`2`）                                 | 可选   | `1`      |
| `SEATA_ENV`       | 运行环境（如 `dev`、`test`），启动时加载 `registry-dev.conf` 这类配置 | 可选   | 无       |
| `SEATA_CONFIG_NAME` | 自定义配置文件路径（需以 `file:` 开头）                              | 可选   | 无       |  


## 参考与支持  

### 获取帮助  
- [Seata GitHub 仓库]([])  
- [官方文档]([])  
- []()  
- 钉钉群：扫码加入（群二维码见 [官方仓库]([])）  


### 提交反馈  
如遇问题，可在 [GitHub Issues]([]) 提交反馈。

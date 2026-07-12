---
image: dyrnq/rocketmq
description: "基于AdoptOpenJDK和Debian的RocketMQ Docker镜像，用于运行RocketMQ消息队列服务。"
source: https://xuanyuan.cloud/zh/r/dyrnq/rocketmq
canonical: https://xuanyuan.cloud/zh/r/dyrnq/rocketmq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dyrnq/rocketmq" title="dyrnq/rocketmq Docker 镜像中文简介、标签列表与拉取命令">dyrnq/rocketmq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-rocketmq 镜像文档


## 1. 镜像概述与主要用途

### 1.1 概述  
基于AdoptOpenJDK和Debian构建的RocketMQ Docker镜像，提供轻量、标准化的RocketMQ容器化部署环境。

### 1.2 主要用途  
用于快速部署RocketMQ消息队列服务，支持分布式系统中的异步通信、服务解耦、流量削峰等场景，适用于开发、测试及生产环境的容器化部署需求。


## 2. 核心功能与特性

- **时区配置支持**：通过`TZ`环境变量自定义容器时区，确保日志时间与业务环境一致。  
- **进程管理优化**：服务进程以PID 1运行，符合容器最佳实践，保障信号正确传递及进程生命周期管理。  
- **集成gosu工具**：内置gosu实现安全的用户身份切换，避免直接使用root权限运行服务，降低安全风险。  
- **默认用户配置**：预配置`rocketmq`用户（UID 3000），作为服务默认运行身份，规范权限管理。  
- **入口脚本支持**：包含`docker-entrypoint.sh`初始化脚本，负责环境变量注入、目录权限配置及服务启动流程。  
- **固定安装路径**：预设`ROCKETMQ_HOME=/opt/rocketmq`，统一RocketMQ安装目录，简化配置文件引用。  


## 3. 使用场景与适用范围

### 3.1 适用场景  
- 分布式系统异步通信：实现跨服务消息传递，降低服务耦合度。  
- 流量削峰与缓冲：应对高并发场景，平滑突发流量对后端服务的冲击。  
- 日志/数据异步处理：收集分布式系统日志或业务数据，异步转发至处理节点。  
- 事务消息支持：基于RocketMQ事务消息特性，保障分布式事务最终一致性。  

### 3.2 适用范围  
- 开发环境：快速搭建本地RocketMQ服务，简化依赖配置。  
- 测试环境：通过容器化确保多节点测试环境一致性，提升测试准确性。  
- 生产环境：结合Kubernetes等编排平台，实现高可用、可扩展的RocketMQ集群部署。  


## 4. 使用方法与配置说明

### 4.1 环境变量配置  

| 环境变量名       | 说明                                  | 默认值              |
|------------------|---------------------------------------|---------------------|
| `TZ`             | 容器时区，例如`Asia/Shanghai`         | 未设置（依赖系统默认） |
| `ROCKETMQ_HOME`  | RocketMQ安装根目录                    | `/opt/rocketmq`     |
| `USER`           | 服务运行用户（建议保持默认）          | `rocketmq`（UID 3000） |

> 注：RocketMQ核心配置（如namesrv端口、broker参数等）需通过挂载配置文件或启动命令参数指定，具体可参考[RocketMQ官方文档](https://github.com/apache/rocketmq)。


### 4.2 Docker部署示例  

#### 4.2.1 启动RocketMQ Namesrv  
```bash
docker run -d \
  --name rocketmq-namesrv \
  -p 9876:9876 \
  -e TZ=Asia/Shanghai \
  -v /local/path/namesrv/logs:/opt/rocketmq/logs \
  docker.xuanyuan.run/dyrnq/docker-rocketmq:latest \
  sh mqnamesrv
```  
- **参数说明**：  
  - `-p 9876:9876`：映射namesrv默认端口（客户端连接端口）。  
  - `-v /local/path/namesrv/logs`：挂载宿主机目录至容器日志路径，持久化日志数据。  
  - 最后参数`sh mqnamesrv`：通过入口脚本执行namesrv启动命令。  


#### 4.2.2 启动RocketMQ Broker  
```bash
docker run -d \
  --name rocketmq-broker \
  -p 10911:10911 \
  -p 10909:10909 \
  -e TZ=Asia/Shanghai \
  -e NAMESRV_ADDR=rocketmq-namesrv:9876 \
  -v /local/path/broker/logs:/opt/rocketmq/logs \
  -v /local/path/broker/store:/opt/rocketmq/store \
  -v /local/path/broker/conf/broker.conf:/opt/rocketmq/conf/broker.conf \
  docker.xuanyuan.run/dyrnq/docker-rocketmq:latest \
  sh mqbroker -c /opt/rocketmq/conf/broker.conf
```  
- **参数说明**：  
  - `-p 10911:10911`：映射broker普通客户端端口；`-p 10909:10909`：映射VIP通道端口（可选）。  
  - `-e NAMESRV_ADDR`：指定namesrv地址（需与namesrv容器网络互通，可通过`--link`或自定义网络实现）。  
  - `-v /local/path/broker/conf/broker.conf`：挂载自定义broker配置文件（如集群名称、存储路径等）。  


#### 4.2.3 Docker Compose配置示例  
```yaml
version: '3'
services:
  namesrv:
    image: docker.xuanyuan.run/dyrnq/docker-rocketmq:latest
    container_name: rocketmq-namesrv
    ports:
      - "9876:9876"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./namesrv/logs:/opt/rocketmq/logs
    command: sh mqnamesrv

  broker:
    image: docker.xuanyuan.run/dyrnq/docker-rocketmq:latest
    container_name: rocketmq-broker
    ports:
      - "10911:10911"
      - "10909:10909"
    environment:
      - TZ=Asia/Shanghai
      - NAMESRV_ADDR=namesrv:9876
    volumes:
      - ./broker/logs:/opt/rocketmq/logs
      - ./broker/store:/opt/rocketmq/store
      - ./broker/conf:/opt/rocketmq/conf
    depends_on:
      - namesrv
    command: sh mqbroker -c /opt/rocketmq/conf/broker.conf
```  


### 4.3 入口脚本说明  
`docker-entrypoint.sh`为镜像默认入口脚本，负责：  
1. 初始化环境变量（如`ROCKETMQ_HOME`）；  
2. 调整挂载目录权限（适配`rocketmq`用户）；  
3. 转发用户输入命令（如`sh mqnamesrv`）并以`rocketmq`用户执行，确保服务安全运行。  


## 5. 参考链接  
- 示例项目：[https://github.com/dyrnq/docker-rocketmq-example](https://github.com/dyrnq/docker-rocketmq-example)  
- RocketMQ官方文档：[https://github.com/apache/rocketmq](https://github.com/apache/rocketmq)

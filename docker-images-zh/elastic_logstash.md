---
image: elastic/logstash
description: "Elastic官方维护的Logstash Docker镜像，用于日志的收集、处理、转换与转发，适用于日志管理流程。"
source: https://xuanyuan.cloud/zh/r/elastic/logstash
canonical: https://xuanyuan.cloud/zh/r/elastic/logstash
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elastic/logstash" title="elastic/logstash Docker 镜像中文简介、标签列表与拉取命令">elastic/logstash 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Logstash Docker镜像文档


## 一、镜像概述

Logstash Docker镜像是由Elastic官方维护的容器化部署方案，旨在简化Logstash的安装、配置与运行流程。Logstash作为Elastic Stack（ELK Stack）的核心组件之一，主要用于日志收集、处理、转换与转发。该镜像基于官方稳定版本构建，确保与Elastic Stack其他组件（Elasticsearch、Kibana等）的兼容性，适用于各类日志处理场景的容器化部署。


## 二、核心功能和特性

### 2.1 官方维护与可靠性
- 由Elastic官方团队构建并维护，确保镜像安全性、稳定性及版本同步。
- 镜像发布与Logstash官方版本同步，支持指定版本号拉取（如`8.11.3`）。


### 2.2 多平台与环境适配
- 支持多架构（amd64、arm64等），适配主流容器运行环境（Docker、Kubernetes等）。
- 基于轻量级基础镜像构建，减少资源占用。


### 2.3 灵活的配置与集成能力
- 支持通过配置文件（`logstash.yml`、管道配置`*.conf`）自定义日志处理逻辑。
- 原生集成Elasticsearch、Kibana，支持与各类数据源（Filebeat、TCP/UDP、数据库等）对接。


### 2.4 开箱即用的功能支持
- 内置常用插件（如`file`、`syslog`、`elasticsearch`输出插件等），无需额外手动安装。
- 支持X-Pack监控、安全等企业级功能（需配置授权）。


## 三、使用场景和适用范围

### 3.1 日志收集与处理
- **场景**：从多源（服务器日志、应用日志、网络设备日志等）收集异构日志，统一处理（过滤、解析、格式化）。
- **示例**：通过Filebeat采集服务器日志，经Logstash解析后转发至Elasticsearch存储。


### 3.2 数据转换与清洗
- **场景**：对原始日志数据进行结构化处理（如JSON格式化、字段提取、数据脱敏），适配下游存储或分析需求。
- **示例**：将非结构化的Nginx访问日志转换为包含`client_ip`、`request_path`、`status_code`等字段的结构化数据。


### 3.3 日志聚合与分析前置
- **场景**：作为日志聚合层，接收多源日志并统一转发至Elasticsearch，配合Kibana实现可视化分析。
- **示例**：收集分布式系统多节点日志，经Logstash聚合后存储至Elasticsearch，通过Kibana生成性能监控仪表盘。


### 3.4 Elastic Stack集成部署
- **场景**：在ELK Stack或ECK（Elastic Cloud on Kubernetes）中作为日志处理中间件，与Elasticsearch、Kibana协同工作。


## 四、使用方法和配置说明

### 4.1 镜像拉取
通过Elastic官方镜像仓库拉取指定版本的镜像（版本号需与Elastic Stack其他组件匹配）：  
```bash
docker pull ***-elastic.xuanyuan.run/logstash/logstash:<版本号>
# 示例：拉取8.11.3版本
docker pull ***-elastic.xuanyuan.run/logstash/logstash:8.11.3
```


### 4.2 基本运行（默认配置）
使用默认配置启动Logstash容器（仅用于测试，生产环境需自定义配置）：  
```bash
docker run -d \
  --name logstash \
  -p 5044:5044 \  # Filebeat等输入源对接端口
  docker.elastic.co/logstash/logstash:8.11.3
```


### 4.3 自定义配置（推荐）
通过挂载本地配置文件或目录，覆盖默认配置（核心配置文件包括`logstash.yml`和管道配置`*.conf`）。

#### 4.3.1 目录结构准备
本地创建配置目录（如`./logstash/config`），存放自定义配置文件：  
```
./logstash/
└── config/
    ├── logstash.yml        # Logstash主配置（全局参数）
    └── pipeline/           # 管道配置目录（存放日志处理逻辑）
        └── main.conf       # 示例管道配置（输入、过滤、输出定义）
```


#### 4.3.2 启动容器（挂载配置）
通过`-v`参数挂载本地配置目录至容器内`/usr/share/logstash/config`（配置文件）和`/usr/share/logstash/pipeline`（管道配置）：  
```bash
docker run -d \
  --name logstash \
  -p 5044:5044 \  # Filebeat输入端口
  -p 9600:9600 \  # 监控API端口
  -v $(pwd)/logstash/config:/usr/share/logstash/config \  # 挂载主配置
  -v $(pwd)/logstash/config/pipeline:/usr/share/logstash/pipeline \  # 挂载管道配置
  docker.elastic.co/logstash/logstash:8.11.3
```


### 4.4 环境变量配置
通过`-e`参数设置环境变量，覆盖默认配置（如JVM参数、功能开关等）。常用环境变量如下：

| 环境变量                | 说明                                  | 示例值                          |
|-------------------------|---------------------------------------|---------------------------------|
| `LS_JAVA_OPTS`          | JVM参数配置（内存、GC等）             | `-Xms512m -Xmx1g`               |
| `XPACK_MONITORING_ENABLED` | 是否启用X-Pack监控（对接Elasticsearch） | `true`                          |
| `XPACK_MONITORING_ELASTICSEARCH_HOSTS` | 监控目标Elasticsearch地址 | `http://elasticsearch:9200`     |
| `LOGSTASH_HOME`         | Logstash安装路径（容器内默认固定）    | `/usr/share/logstash`           |


#### 示例：通过环境变量设置JVM内存
```bash
docker run -d \
  --name logstash \
  -e LS_JAVA_OPTS="-Xms1g -Xmx2g" \  # 设置JVM堆内存为1G-2G
  -v $(pwd)/logstash/config:/usr/share/logstash/config \
  docker.elastic.co/logstash/logstash:8.11.3
```


### 4.5 Docker Compose部署示例
通过`docker-compose.yml`定义Logstash服务，适用于多组件协同部署（如与Elasticsearch、Kibana联动）：

```yaml
version: '3.8'
services:
  logstash:
    image: ***-elastic.xuanyuan.run/logstash/logstash:8.11.3
    container_name: logstash
    ports:
      - "5044:5044"  # Filebeat输入端口
      - "9600:9600"  # 监控API端口
    environment:
      - LS_JAVA_OPTS=-Xms512m -Xmx1g
      - XPACK_MONITORING_ENABLED=true
      - XPACK_MONITORING_ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    volumes:
      - ./logstash/config:/usr/share/logstash/config  # 主配置目录
      - ./logstash/pipeline:/usr/share/logstash/pipeline  # 管道配置目录
      - logstash_data:/usr/share/logstash/data  # 数据持久化（插件、队列等）
    depends_on:
      - elasticsearch  # 依赖Elasticsearch（若需输出至ES）
    networks:
      - elk-network  # 与Elastic Stack其他组件共享网络

  elasticsearch:  # 示例Elasticsearch服务（需单独配置）
    image: ***-elastic.xuanyuan.run/elasticsearch/elasticsearch:8.11.3
    # ...（省略Elasticsearch配置）

volumes:
  logstash_data:

networks:
  elk-network:
    driver: bridge
```


## 四、配置参数与环境变量

### 4.1 核心配置文件说明
| 配置文件路径（容器内）              | 作用                                  | 自定义方式                          |
|-------------------------------------|---------------------------------------|-------------------------------------|
| `/usr/share/logstash/config/logstash.yml` | Logstash全局配置（如节点名称、端口） | 本地文件挂载覆盖                    |
| `/usr/share/logstash/pipeline/*.conf`     | 管道配置（输入、过滤、输出逻辑）     | 本地目录挂载至`/usr/share/logstash/pipeline` |


### 4.2 常用环境变量详解
| 环境变量                          | 功能描述                                                                 | 默认值/示例                          |
|-----------------------------------|--------------------------------------------------------------------------|--------------------------------------|
| `LS_JAVA_OPTS`                    | JVM运行参数，控制内存分配、GC策略等                                     | `-Xms1g -Xmx1g`（默认1G堆内存）     |
| `LOGSTASH_OPTS`                   | Logstash启动参数（如`--config.test_and_exit`测试配置）                  | 空（默认正常启动）                   |
| `XPACK_MONITORING_ELASTICSEARCH_USERNAME` | 监控Elasticsearch的认证用户名（若启用安全）                           | `elastic`（需配合密码变量使用）      |
| `XPACK_MONITORING_ELASTICSEARCH_PASSWORD` | 监控Elasticsearch的认证密码                                           | 需手动设置（如通过`-e`参数传入）     |


## 五、注意事项

1. **版本兼容性**：Logstash镜像版本需与Elasticsearch、Kibana版本保持一致（如均为`8.11.3`），避免因版本差异导致功能异常。  
2. **数据持久化**：通过挂载`/usr/share/logstash/data`目录持久化插件、队列数据，防止容器重启后数据丢失。  
3. **资源配置**：根据日志处理规模调整`LS_JAVA_OPTS`内存参数，避免因资源不足导致性能瓶颈。  
4. **安全配置**：生产环境需启用Elasticsearch安全认证（如配置`XPACK_MONITORING_ELASTICSEARCH_USERNAME/PASSWORD`），并限制容器端口访问权限。  
5. **配置测试**：通过`LOGSTASH_OPTS="--config.test_and_exit"`参数测试配置文件合法性，避免启动失败。


## 参考链接
- 官方文档：[Elastic Logstash Docker Guide](https://www.elastic.co/guide/en/logstash/current/docker.html)  
- 镜像仓库：[Elastic Docker Registry](https://www.docker.elastic.co)

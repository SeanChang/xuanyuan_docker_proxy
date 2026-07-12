---
image: apache/dolphinscheduler-helm
description: "Apache DolphinScheduler Docker镜像是用于部署分布式可视化DAG工作流任务调度系统的容器化解决方案，支持任务编排、定时调度与全链路监控，适用于大数据处理、ETL流程及复杂业务自动化调度场景。"
source: https://xuanyuan.cloud/zh/r/apache/dolphinscheduler-helm
canonical: https://xuanyuan.cloud/zh/r/apache/dolphinscheduler-helm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/dolphinscheduler-helm" title="apache/dolphinscheduler-helm Docker 镜像中文简介、标签列表与拉取命令">apache/dolphinscheduler-helm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache DolphinScheduler Docker镜像文档

## 镜像概述
Apache DolphinScheduler Docker镜像是容器化部署Apache DolphinScheduler的核心组件，提供开箱即用的分布式工作流调度能力。该镜像封装了DolphinScheduler的核心服务（Master/Worker/API/Alert）及依赖环境，简化了传统部署的复杂性，支持快速集成至容器化或Kubernetes环境，满足企业级任务调度需求。

## 核心功能与特性
- **可视化DAG编排**：通过Web UI拖拽式设计工作流，直观定义任务依赖关系，支持分支/并行/条件等复杂流程。
- **多任务类型支持**：内置Shell、SQL、Python、Spark、Flink等20+任务类型，适配大数据、数据库、脚本执行等场景。
- **分布式任务调度**：基于Master-Worker架构，支持水平扩展，单集群可承载十万级任务调度。
- **全链路监控告警**：实时跟踪任务执行状态，支持邮件、短信、企业微信等多渠道告警，保障任务可靠性。
- **高可用设计**：支持Master/Worker服务集群化部署，结合ZooKeeper实现故障自动转移，服务可用性达99.9%。
- **灵活的调度策略**：支持定时（CRON）、依赖触发、手动触发等调度方式，满足周期性与事件驱动型任务需求。

## 适用场景
- **大数据处理流程**：Hadoop/Spark/Flink作业的定时调度与依赖管理。
- **ETL数据集成**：数据库同步、数据清洗、指标计算等流程自动化。
- **业务系统自动化**：报表生成、日志分析、接口调用等周期性任务调度。
- **DevOps流程编排**：CI/CD流水线、脚本部署、环境检查等流程管理。
- **跨系统协作**：多系统间任务串联，如数据采集→处理→入库→通知全流程调度。

## 镜像标签说明
| 标签格式       | 说明                     |
|----------------|--------------------------|
| `latest`       | 最新稳定版本             |
| `x.y.z`        | 特定版本（如 `3.2.0`）   |
| `x.y.z-slim`   | 精简版镜像（去除部分工具）|
| `dev`          | 开发版（包含最新特性，不稳定） |

## 部署方式

### 1. 单机快速启动（Docker Run）
适用于测试或轻量场景，需提前准备MySQL（或PostgreSQL）和ZooKeeper服务。

```bash
# 拉取镜像
docker pull docker.xuanyuan.run/apache/dolphinscheduler:latest

# 启动Master服务（示例，需替换数据库/ZooKeeper地址）
docker run -d \
  --name dolphinscheduler-master \
  -p 5678:5678 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-host:3306/dolphinscheduler?useSSL=false" \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=password \
  -e DATABASE_TYPE=mysql \
  -e ZOOKEEPER_QUORUM=zk-host:2181 \
  docker.xuanyuan.run/apache/dolphinscheduler:latest master-server
```

### 2. Docker Compose集群部署
推荐用于中小规模生产环境，包含完整服务组件及依赖（需提前配置外部数据库/ZooKeeper）。

**docker-compose.yml示例**：
```yaml
version: '3.8'
services:
  master:
    image: docker.xuanyuan.run/apache/dolphinscheduler:latest
    command: master-server
    ports:
      - "5678:5678"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/dolphinscheduler
      - SPRING_DATASOURCE_USERNAME=root
      - SPRING_DATASOURCE_PASSWORD=password
      - DATABASE_TYPE=mysql
      - ZOOKEEPER_QUORUM=zookeeper:2181
    depends_on:
      - zookeeper
    restart: always

  worker:
    image: docker.xuanyuan.run/apache/dolphinscheduler:latest
    command: worker-server
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/dolphinscheduler
      - SPRING_DATASOURCE_USERNAME=root
      - SPRING_DATASOURCE_PASSWORD=password
      - DATABASE_TYPE=mysql
      - ZOOKEEPER_QUORUM=zookeeper:2181
      - WORKER_GROUPS=default
    depends_on:
      - zookeeper
    restart: always
    deploy:
      replicas: 2  # 启动2个Worker实例实现负载均衡

  api:
    image: docker.xuanyuan.run/apache/dolphinscheduler:latest
    command: api-server
    ports:
      - "12345:12345"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/dolphinscheduler
      - SPRING_DATASOURCE_USERNAME=root
      - SPRING_DATASOURCE_PASSWORD=password
      - DATABASE_TYPE=mysql
    restart: always

  zookeeper:
    image: docker.xuanyuan.run/zookeeper:3.8
    ports:
      - "2181:2181"
    environment:
      - ZOO_MY_ID=1
    restart: always
```

启动命令：`docker-compose up -d`

### 3. Kubernetes部署（Helm Chart）
适用于大规模生产环境，通过Helm Chart实现自动化部署与扩缩容。

#### 前置条件
- Kubernetes集群（1.18+）
- Helm 3.0+
- 持久化存储（如PVC）
- 数据库（MySQL 5.7+/PostgreSQL 11+）

#### 部署步骤
```bash
# 添加Helm仓库
helm repo add dolphinscheduler https://apache.github.io/dolphinscheduler-helm

# 更新仓库
helm repo update

# 安装（自定义配置参考官方values.yaml）
helm install dolphinscheduler dolphinscheduler/dolphinscheduler \
  --namespace dolphinscheduler --create-namespace \
  --set global.database.type=mysql \
  --set global.database.host=mysql-service \
  --set global.database.user=root \
  --set global.database.password=password \
  --set worker.replicas=3  # 配置Worker副本数
```

## 核心配置参数
通过环境变量或配置文件（`application.yaml`）调整服务参数，关键配置如下：

| 环境变量                          | 说明                          | 默认值                  |
|-----------------------------------|-------------------------------|-------------------------|
| `SPRING_DATASOURCE_URL`           | 数据库连接URL                 | `jdbc:mysql://localhost:3306/dolphinscheduler` |
| `SPRING_DATASOURCE_USERNAME`      | 数据库用户名                  | `root`                  |
| `SPRING_DATASOURCE_PASSWORD`      | 数据库密码                    | -                       |
| `ZOOKEEPER_QUORUM`                | ZooKeeper集群地址             | `localhost:2181`        |
| `MASTER_EXEC_THREADS`             | Master任务执行线程数          | `100`                   |
| `WORKER_EXEC_THREADS`             | Worker任务执行线程数          | `100`                   |
| `ALERT_SERVER_PORT`               | 告警服务端口                  | `50052`                 |
| `API_SERVER_PORT`                 | API服务端口                   | `12345`                 |

## 注意事项
- **数据持久化**：需挂载数据库存储卷（如MySQL数据目录）及DolphinScheduler日志目录，避免容器重启数据丢失。
- **资源配置**：根据任务量调整CPU/内存资源，建议生产环境Master节点≥2核4G，Worker节点≥4核8G。
- **版本兼容性**：镜像版本需与数据库版本匹配（如MySQL 5.7+、PostgreSQL 11+），ZooKeeper建议使用3.6+版本。
- **安全加固**：生产环境需修改默认密码（如Admin用户），配置网络隔离，限制容器权限。

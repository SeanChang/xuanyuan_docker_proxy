---
image: kafkace/kafka
description: "Docker/Kubernetes部署Apache Kafka"
source: https://xuanyuan.cloud/zh/r/kafkace/kafka
canonical: https://xuanyuan.cloud/zh/r/kafkace/kafka
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kafkace/kafka" title="kafkace/kafka Docker 镜像中文简介、标签列表与拉取命令">kafkace/kafka 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![CI](https://github.com/itboon/kafka-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/itboon/kafka-docker/actions/workflows/docker-publish.yml)
[![Docker pulls](https://img.shields.io/docker/pulls/kafkace/kafka)](https://hub.docker.com/r/kafkace/kafka)
![Docker Image](https://img.shields.io/docker/image-size/kafkace/kafka)

- [GitHub](https://github.com/itboon/kafka-docker)
- [Docker Hub](https://hub.docker.com/r/kafkace/kafka)

## Docker部署Kafka

### 快速启动
快速启动Kafka容器：
```shell
docker run -d --network host --name demo-kafka-server docker.xuanyuan.run/kafkace/kafka:v3.9.0
```

### 数据持久化
Kafka数据存储路径为`/var/lib/kafka/data`，可通过挂载数据卷实现持久化：
```shell
docker volume create demo-kafka-data

docker run -d \
  --network host \
  --name demo-kafka-server \
  -v demo-kafka-data:/var/lib/kafka/data \
  docker.xuanyuan.run/kafkace/kafka:v3.9.0
```

### Docker Compose配置
使用Docker Compose部署：
```yaml
version: "3"

volumes:
  kafka-data: {}

services:
  kafka:
    image: docker.xuanyuan.run/kafkace/kafka:v3.9.0
    restart: always
    network_mode: "host"
    volumes:
      - kafka-data:/var/lib/kafka/data
    environment:
      - KAFKA_HEAP_OPTS=-Xmx1024m -Xms1024m
```

## Helm部署Kafka

Helm charts可用于在Kubernetes中部署Kafka，以下为部署示例：

#### 演示部署（关闭持久化存储）
```shell
helm upgrade --install kafka \
  --namespace kafka-demo \
  --create-namespace \
  --set broker.persistence.enabled="false" \
  kafka-repo/kafka
```

#### 默认部署（开启持久化存储）
```shell
helm upgrade --install kafka \
  --namespace kafka-demo \
  --create-namespace \
  kafka-repo/kafka
```

## 文档目录

- [通过环境变量配置Kafka参数](https://github.com/itboon/kafka-docker/blob/main/docs/env.md)
- [Kafka高级网络配置](https://github.com/itboon/kafka-docker/blob/main/docs/network.md)
- [Helm部署kafka](https://github.com/itboon/kafka-docker/blob/main/docs/helm.md)
- [Kubernetes集群外访问](https://github.com/itboon/kafka-docker/blob/main/docs/external.md)

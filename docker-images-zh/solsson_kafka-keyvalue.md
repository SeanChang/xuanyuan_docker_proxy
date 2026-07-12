---
image: solsson/kafka-keyvalue
description: "这是一个Kafka键值缓存镜像，作为sidecar容器提供REST接口访问基于Kafka主题的键值数据，支持自动化构建和Kubernetes集成。"
source: https://xuanyuan.cloud/zh/r/solsson/kafka-keyvalue
canonical: https://xuanyuan.cloud/zh/r/solsson/kafka-keyvalue
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/solsson/kafka-keyvalue" title="solsson/kafka-keyvalue Docker 镜像中文简介、标签列表与拉取命令">solsson/kafka-keyvalue 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kafka键值缓存镜像

## 镜像概述
solsson/kafka-keyvalue是基于Kafka的键值缓存镜像，作为sidecar容器提供REST接口，允许通过键访问Kafka主题中的值，支持自动化Docker构建和Kubernetes环境集成。

## 核心功能
1. 作为sidecar与Kafka集群配合，提供键值数据的REST访问能力
2. 要求Kafka主题的键可序列化为String类型（用于REST URI路径）
3. 支持Quarkus日志配置，便于调试和监控

## 使用场景
适用于需要通过REST接口快速获取Kafka主题中键值数据的场景，例如在Kubernetes微服务架构中，作为数据访问层辅助组件，简化业务服务对Kafka数据的读取操作。

## 配置说明
- **日志配置**：参考[Quarkus日志指南](https://quarkus.io/guides/logging-guide)调整日志级别和输出格式
- **Kafka连接**：需配置Kafka集群地址（如`KAFKA_BOOTSTRAP_SERVERS`环境变量）以连接目标Kafka服务

## 部署示例
### Docker运行
```bash
docker run -d --name kkv-sidecar \
  -e KAFKA_BOOTSTRAP_SERVERS=your-kafka-server:9092 \
  docker.xuanyuan.run/solsson/kafka-keyvalue
```

### Kubernetes Sidecar部署
参考[示例YAML](kontrakt/kkv-example.yaml)中的`kkv` sidecar配置，将其添加到Pod中与Kafka客户端组件协同工作。

### 开发环境设置
使用Skaffold进行本地开发调试：
```bash
eval $(minikube docker-env)
kubectl apply -k github.com/Yolean/kubernetes-kafka/variants/dev-small?ref=v6.0.0
kubectl apply -f https://github.com/Yolean/kubernetes-kafka/raw/50345f266287861d7964d3339a2c2a28e79db2fe/variants/prometheus-operator-example/k8s-cluster-rbac.yaml
SKAFFOLD_NO_PRUNE=true skaffold dev

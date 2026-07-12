---
image: percona/percona-server-mongodb-operator
description: "PSMDB Operator的mongod镜像"
source: https://xuanyuan.cloud/zh/r/percona/percona-server-mongodb-operator
canonical: https://xuanyuan.cloud/zh/r/percona/percona-server-mongodb-operator
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/percona/percona-server-mongodb-operator" title="percona/percona-server-mongodb-operator Docker 镜像中文简介、标签列表与拉取命令">percona/percona-server-mongodb-operator 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Percona Operator for MongoDB

Percona Operator for MongoDB用于在Kubernetes上自动化创建和管理可靠的MongoDB生产集群。该Operator 100%源码可用，且无供应商锁定。

## 关键特性

- 在Kubernetes上部署和管理复杂的MongoDB拓扑结构。
- 分片支持，以满足您的扩展需求。
- 以完全自动化的方式扩展带有仲裁节点或非投票副本集节点的Percona Server for MongoDB集群。
- 默认使用TLS/SSL协议进行安全连接。
- 零停机自动软件升级。
- 通过Percona监控与管理工具（Percona Monitoring and Management）进行监控和管理。

## 部署方案示例

以下是在Kubernetes上部署Percona Operator for MongoDB及创建MongoDB集群的基本示例：

1. 部署Operator：
```bash
kubectl apply -f https://percona.github.io/percona-server-mongodb-operator/deploy/bundle.yaml
```

2. 创建MongoDB集群自定义资源（示例）：
```yaml
apiVersion: psmdb.percona.com/v1
kind: PerconaServerMongoDB
metadata:
  name: my-mongodb-cluster
spec:
  replicas: 3  # 副本集节点数
  sharding:
    enabled: true  # 启用分片
  arbiters: 1  # 仲裁节点数
  # 可根据需求添加其他配置（如资源限制、存储类、TLS设置等）
```

3. 应用上述自定义资源以创建集群：
```bash
kubectl apply -f my-mongodb-cluster.yaml
```

## 更多信息

更多信息请参阅[文档](https://percona.github.io/percona-server-mongodb-operator/)。

---
image: bitnamicharts/redis
description: "Bitnami提供的Redis Helm chart，用于在Kubernetes环境中快速部署和管理Redis服务。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/redis
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/redis
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/redis" title="bitnamicharts/redis Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/redis 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Redis® 镜像文档


## 镜像概述和主要用途

Redis® 是一个开源的高级键值存储系统，常被称为数据结构服务器，因为其键可以包含字符串、哈希、列表、集合和有序集合等多种数据结构。Bitnami Redis® 镜像提供了预配置、安全优化的Redis®部署方案，支持通过Docker容器或Kubernetes集群（使用Helm Chart）快速部署，适用于开发、测试及生产环境。

> **免责声明**：Redis是Redis Ltd.的注册商标。Bitnami对其的任何使用仅为参考目的，不表示Redis Ltd.的任何赞助、认可或关联。


## 核心功能和特性

### 1. 灵活的部署拓扑
- **主从复制（Master-Replica）**：单主节点写入，多从节点只读，支持数据备份与读写分离
- **Redis Cluster**：支持数据分片的分布式集群，多主节点写入，适合大规模数据集
- **哨兵（Sentinel）**：自动故障检测与主节点切换，提升高可用性
- **单机模式（Standalone）**：单节点部署，适用于简单测试场景

### 2. 安全与合规
- 支持通过TLS加密数据传输
- 密码认证机制，可通过环境变量或密钥文件配置
- 符合容器安全最佳实践，定期更新以修复CVE漏洞

### 3. 可观测性
- 集成Prometheus指标导出器（redis_exporter），支持监控关键性能指标
- 兼容Prometheus Operator，可自动创建ServiceMonitor资源

### 4. 数据持久化
- 支持RDB（快照）和AOF（Append-Only File）两种持久化机制
- 动态卷配置（PVC）支持，确保数据持久化存储

### 5. 扩展性
- 支持加载自定义Redis模块（如RediSearch、RedisBloom、RedisJSON等）
- 可配置资源请求与限制，适应不同负载需求


## 使用场景和适用范围

### 适用场景
- **开发环境**：快速部署单机或简单主从集群，验证应用与Redis的集成
- **读写分离架构**：通过主从拓扑实现写主节点、读从节点的流量拆分，提升读性能
- **高可用生产环境**：启用Sentinel实现自动故障转移，避免单点故障
- **大规模数据集**：使用Redis Cluster实现数据分片，支持TB级数据存储

### 版本支持说明
- **社区版镜像**：2025年8月28日后，非加固的Debian基础镜像将逐步从`docker.io/bitnami`迁移至`docker.io/bitnamilegacy`仓库，不再接收更新，仅保留`latest`标签供开发使用
- **生产环境建议**：采用[Bitnami Secure Images](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)，包含加固容器、SBOM、CVE透明度及企业支持


## 详细的使用方法和配置说明

### 一、Docker容器部署

#### 1. 快速启动（单机模式）
```bash
# 使用默认配置启动Redis容器（自动生成随机密码）
docker run --name redis -d docker.xuanyuan.run/bitnami/redis:latest

# 获取自动生成的密码
docker logs redis 2>&1 | grep "User requested password"
```

#### 2. 指定密码启动
```bash
docker run --name redis -d \
  -e REDIS_PASSWORD=mysecretpassword \
  docker.xuanyuan.run/bitnami/redis:latest
```

#### 3. 持久化数据
```bash
docker run --name redis -d \
  -e REDIS_PASSWORD=mysecretpassword \
  -v /path/on/host:/data \
  docker.xuanyuan.run/bitnami/redis:latest
```


### 二、Kubernetes部署（Helm Chart）

#### 前提条件
- Kubernetes集群 1.23+
- Helm 3.8.0+
- 集群支持持久卷（PV）动态供应

#### 1. 快速安装（主从模式）
```bash
helm install my-redis oci://registry-1.docker.io/bitnamicharts/redis
```

#### 2. 安装Redis Cluster（分片集群）
```bash
helm install my-redis-cluster oci://registry-1.docker.io/bitnamicharts/redis-cluster
```

#### 3. 安装参数说明
| 参数 | 描述 | 默认值 |
|------|------|--------|
| `architecture` | 部署拓扑：`replication`（主从）、`standalone`（单机） | `replication` |
| `auth.enabled` | 是否启用密码认证 | `true` |
| `auth.password` | Redis访问密码 | 随机生成 |
| `sentinel.enabled` | 是否启用Sentinel | `false` |
| `replica.replicaCount` | 从节点数量 | `1` |
| `persistence.enabled` | 是否启用持久化 | `true` |
| `persistence.size` | PVC存储大小 | `8Gi` |
| `metrics.enabled` | 是否启用Prometheus指标 | `false` |


### 三、关键配置详解

#### 1. 拓扑选择
##### 主从复制（默认）
- 单主节点（写入）+ 多从节点（只读）
- 暴露两个Service：
  - `my-redis-master`：指向主节点，支持读写操作
  - `my-redis-replicas`：指向从节点，仅支持读操作
```bash
helm install my-redis oci://registry-1.docker.io/bitnamicharts/redis \
  --set architecture=replication \
  --set replica.replicaCount=2
```

##### 主从+Sentinel（高可用）
- 启用Sentinel实现自动故障转移，主节点故障时自动晋升从节点
```bash
helm install my-redis oci://registry-1.docker.io/bitnamicharts/redis \
  --set architecture=replication \
  --set sentinel.enabled=true \
  --set replica.replicaCount=2
```

##### Redis Cluster（分片集群）
- 数据分片存储，多主多从，支持大规模数据
```bash
helm install my-redis-cluster oci://registry-1.docker.io/bitnamicharts/redis-cluster \
  --set cluster.nodes=6 \  # 总节点数（3主3从）
  --set cluster.replicasPerMaster=1
```

#### 2. 自定义Redis配置
通过`commonConfiguration`参数注入Redis配置文件内容：
```yaml
# values.yaml示例
commonConfiguration: |-
  # 启用AOF持久化
  appendonly yes
  # RDB快照策略
  save 900 1
  save 300 10
  # 最大内存策略
  maxmemory-policy allkeys-lru
```
安装时指定配置文件：
```bash
helm install my-redis -f values.yaml oci://registry-1.docker.io/bitnamicharts/redis
```

#### 3. 加载自定义模块
支持加载Redis模块（如RediSearch、RedisJSON等），需指定模块路径：
```yaml
# values.yaml示例
commonConfiguration: |-
  loadmodule /opt/bitnami/redis/lib/redis/modules/redisearch.so
  loadmodule /opt/bitnami/redis/lib/redis/modules/rejson.so
```

#### 4. TLS加密配置
1. 创建包含TLS证书的Secret：
```bash
kubectl create secret generic redis-tls --from-file=tls.crt=./server.crt --from-file=tls.key=./server.key --from-file=ca.crt=./ca.crt
```

2. 启用TLS部署：
```bash
helm install my-redis oci://registry-1.docker.io/bitnamicharts/redis \
  --set tls.enabled=true \
  --set tls.existingSecret=redis-tls \
  --set tls.certFilename=tls.crt \
  --set tls.certKeyFilename=tls.key \
  --set tls.certCAFilename=ca.crt
```

#### 5. 备份与恢复
##### 备份数据
1. 进入主节点容器执行RDB快照：
```bash
kubectl exec -it my-redis-master-0 -- redis-cli -a $REDIS_PASSWORD save
```

2. 拷贝快照文件到本地：
```bash
kubectl cp my-redis-master-0:/data/dump.rdb ./dump.rdb
```

##### 恢复数据
1. 创建临时Pod挂载目标PVC：
```bash
kubectl run -it --rm vol-pod --image=bitnami/minideb --overrides='
{
  "spec": {
    "containers": [{
      "name": "copy",
      "image": "bitnami/minideb",
      "command": ["sleep", "3600"],
      "volumeMounts": [{
        "mountPath": "/data",
        "name": "data-vol"
      }]
    }],
    "volumes": [{
      "name": "data-vol",
      "persistentVolumeClaim": {
        "claimName": "my-redis-master-0"
      }
    }]
  }
}'
```

2. 拷贝快照文件到PVC：
```bash
kubectl cp ./dump.rdb vol-pod:/data/dump.rdb
```

3. 重启Redis集群：
```bash
helm upgrade my-redis oci://registry-1.docker.io/bitnamicharts/redis --reuse-values
```


### 四、重要注意事项

#### 镜像仓库变更（2025年8月28日起）
- **社区版镜像**：非加固的Debian基础镜像将从`docker.io/bitnami`迁移至`docker.io/bitnamilegacy`，不再更新
- **标签策略**：社区版仅保留`latest`标签，适用于开发环境
- **生产环境**：推荐使用[Bitnami Secure Images](https://github.com/bitnami/containers/issues/83267)，提供加固容器、SBOM、CVE透明度及企业支持


## 参考链接
- [Redis官方文档](http://redis.io)
- [Bitnami Redis Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/redis)
- [Bitnami Redis Cluster Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/redis-cluster)
- [Bitnami Secure Images公告](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)

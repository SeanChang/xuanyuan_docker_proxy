---
image: longhornio/longhorn-manager
description: "Longhorn manager是管理Longhorn分布式块存储集群的核心组件，负责在Kubernetes环境中协调存储节点、卷生命周期管理及数据高可用，提供持久化存储解决方案。"
source: https://xuanyuan.cloud/zh/r/longhornio/longhorn-manager
canonical: https://xuanyuan.cloud/zh/r/longhornio/longhorn-manager
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/longhornio/longhorn-manager" title="longhornio/longhorn-manager Docker 镜像中文简介、标签列表与拉取命令">longhornio/longhorn-manager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Longhorn Manager Docker镜像文档


## 镜像概述和主要用途

Longhorn Manager 是 Longhorn（开源分布式块存储系统）的核心管理组件，负责协调 Longhorn 集群中的存储卷、副本、节点及备份等资源，确保分布式存储服务的稳定运行。其主要用途包括：  
- 作为 Longhorn 控制平面的核心，管理存储卷全生命周期（创建、删除、扩容、快照等）；  
- 协调数据副本的分布与一致性，实现故障自动恢复；  
- 集成备份目标（如 S3、NFS），管理数据备份与恢复流程；  
- 与 Kubernetes 集群深度集成，通过 CSI（Container Storage Interface）提供持久化存储服务。  


## 核心功能和特性

### 1. 存储卷生命周期管理  
- 支持创建、删除、扩容、克隆持久化卷（PV）；  
- 提供在线/离线快照（Snapshot）功能，支持基于快照创建新卷；  
- 动态调整卷的 QoS（IOPS、带宽限制）。  

### 2. 高可用副本协调  
- 自动管理数据副本分布，默认支持多副本（可配置副本数）；  
- 节点故障时自动触发副本重建，确保数据冗余与一致性；  
- 支持副本亲和性/反亲和性配置，优化数据分布。  

### 3. 备份与恢复管理  
- 集成备份目标（S3、NFS、Azure Blob 等），支持定时备份；  
- 备份数据去重与压缩，减少存储占用；  
- 支持从备份恢复卷数据，或跨集群迁移数据。  

### 4. Kubernetes 原生集成  
- 实现 CSI 接口，支持动态 PV 供应、PVC 绑定；  
- 兼容 Kubernetes StatefulSet、Deployment 等资源；  
- 提供 CRD（Custom Resource Definition）管理存储资源（如 Volume、Backup）。  

### 5. 监控与运维  
- 内置 Prometheus 指标暴露，监控卷性能、节点状态；  
- 详细日志记录（支持 debug 级别），便于问题排查；  
- 支持通过 Longhorn UI 可视化管理（需配合 longhorn-ui 组件）。  


## 使用场景和适用范围

### 适用场景  
- **Kubernetes 有状态应用**：如数据库（MySQL、PostgreSQL）、消息队列（Kafka、RabbitMQ）等需持久化存储的应用；  
- **高可用存储需求**：需数据冗余、故障自动恢复的场景；  
- **备份与容灾**：需定期备份数据、支持跨集群恢复的场景；  
- **边缘计算环境**：轻量级部署（单节点最小资源：CPU 1 核、内存 2GB），适配资源受限环境。  

### 适用范围  
- **集群环境**：Kubernetes 集群（支持版本 1.24+）；  
- **节点要求**：每个节点需满足：  
  - 已安装 `open-iscsi`  initiator（用于块设备挂载）；  
  - 至少 1 块空闲磁盘（支持 SSD/HDD，推荐 SSD 提升性能）；  
  - 网络互通（节点间需开放端口 8500、9500 等，具体见网络要求）；  
- **存储规模**：支持小规模（3 节点）到大规模（数百节点）集群，单卷最大容量 100TB。  


## 使用方法和配置说明

### 前置条件  
1. **Kubernetes 集群**：已部署 Kubernetes 1.24+，集群节点网络互通；  
2. **节点准备**：  
   - 所有节点安装 `open-iscsi`（如 Ubuntu: `apt install open-iscsi`，CentOS: `yum install iscsi-initiator-utils`）；  
   - 节点标签：建议为存储节点添加标签（如 `node-role.kubernetes.io/storage=longhorn`），便于调度；  
3. **网络要求**：节点间开放以下端口：  
   - 8500/tcp（Consul，用于组件通信）；  
   - 9500/tcp（Longhorn Manager API）；  
   - 20000-30000/tcp（引擎实例通信）。  


### 部署方法  
Longhorn Manager 需配合其他组件（如 longhorn-engine、longhorn-instance-manager）部署，推荐通过 Helm 或官方 YAML 部署。  

#### 方法 1：使用 Helm 部署（推荐）  
```bash
# 添加 Longhorn Helm 仓库
helm repo add longhorn https://charts.longhorn.io
helm repo update

# 安装 Longhorn（含 manager、engine、ui 等组件）
helm install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --version 1.5.1  # 指定版本（需与 K8s 版本兼容，详见官方文档）
```

#### 方法 2：使用 kubectl 部署  
```bash
# 部署 Longhorn 核心组件（含 manager）
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.5.1/deploy/longhorn.yaml
```


### 核心配置参数  
Longhorn Manager 配置通过环境变量或 Helm Values 定义，以下为主要参数说明：  

| 参数名                  | 环境变量对应          | 说明                                                                 | 默认值                  |
|-------------------------|-----------------------|----------------------------------------------------------------------|-------------------------|
| `defaultReplicaCount`   | `DEFAULT_REPLICA_COUNT` | 新建卷的默认副本数（建议 3，需 ≥1）                                 | 3                       |
| `backupTarget`          | `BACKUP_TARGET`        | 备份目标 URL（格式：`s3://bucket@region/path` 或 `nfs://<ip>/path`） | 空（需手动配置）        |
| `backupTargetCredentialSecret` | `BACKUP_TARGET_CREDENTIAL_SECRET` | 备份目标认证 Secret 名称（存储访问密钥等）                         | 空                      |
| `logLevel`              | `LOG_LEVEL`            | 日志级别（debug/info/warn/error）                                   | info                    |
| `storageMinimalAvailablePercentage` | `STORAGE_MINIMAL_AVAILABLE_PERCENTAGE` | 节点磁盘可用空间阈值（低于此值拒绝调度新副本）                     | 10（%）                 |
| `csiAttacherImage`      | `CSI_ATTACHER_IMAGE`   | CSI Attacher 镜像地址（Longhorn 依赖组件）                          | longhornio/csi-attacher:v4.2.0 |


### 常用操作  

#### 1. 创建存储卷（通过 Kubernetes PVC）  
```yaml
# pvc-example.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: longhorn-pvc
spec:
  accessModes:
    - ReadWriteOnce  # Longhorn 支持 ReadWriteOnce、ReadWriteMany（需配置）
  storageClassName: longhorn  # 需确保存在名为 longhorn 的 StorageClass
  resources:
    requests:
      storage: 10Gi  # 卷大小
```
应用配置：`kubectl apply -f pvc-example.yaml`

#### 2. 配置备份目标（通过 Longhorn UI）  
1. 访问 Longhorn UI（默认通过 NodePort 暴露，端口可通过 `kubectl get svc -n longhorn-system longhorn-frontend` 查看）；  
2. 进入「Settings」→「Backup」，配置 `Backup Target`（如 `s3://my-backup-bucket@us-east-1/longhorn-backup`）；  
3. 创建 Secret 存储 S3 访问密钥（`access-key` 和 `secret-key`），并在 UI 中指定 Secret 名称。  

#### 3. 扩容存储卷  
```bash
# 修改 PVC 的 storage.requests 字段
kubectl patch pvc longhorn-pvc -p '{"spec":{"resources":{"requests":{"storage":"20Gi"}}}}'
```


## 部署示例

### 示例 1：使用 Helm 自定义部署  
```bash
# 添加仓库
helm repo add longhorn https://charts.longhorn.io
helm repo update

# 创建自定义 values.yaml
cat > values.yaml << EOF
defaultReplicaCount: 2  # 副本数设为 2（适用于小规模集群）
backupTarget: "nfs://192.168.1.100/backup/longhorn"  # NFS 备份目标
storageMinimalAvailablePercentage: 15  # 磁盘可用空间阈值 15%
ingress:
  enabled: true  # 启用 Ingress 访问 Longhorn UI
  hosts:
    - host: longhorn.example.com
      paths: ["/"]
EOF

# 安装/升级 Longhorn
helm install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --version 1.5.1 \
  -f values.yaml
```

### 示例 2：Docker Compose 测试部署（仅用于单机测试）  
> 注意：生产环境需部署在 Kubernetes 集群，以下为单机模拟示例。

```yaml
# docker-compose.yml
version: '3'
services:
  longhorn-manager:
    image: docker.xuanyuan.run/longhorn/longhorn-manager:v1.5.1
    privileged: true  # 需特权模式访问主机设备
    network_mode: host  # 主机网络（模拟节点通信）
    environment:
      - POD_NAMESPACE=longhorn-system
      - NODE_NAME=test-node
      - DEFAULT_REPLICA_COUNT=1
      - LOG_LEVEL=debug
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /dev:/dev
      - /var/lib/longhorn:/var/lib/longhorn
      - /etc/iscsi:/etc/iscsi
```
启动：`docker-compose up -d`


## 注意事项  
1. **磁盘选择**：避免使用临时磁盘（如 `/tmp`）存储数据，建议使用持久化磁盘（如 `/dev/sdb`）；  
2. **网络安全**：限制 Longhorn 组件端口访问（如仅允许集群内部通信）；  
3. **版本兼容性**：Longhorn 版本需与 Kubernetes 版本匹配（详见 [官方兼容性矩阵](https://longhorn.io/docs/latest/overview/compatibility/)）；  
4. **备份验证**：定期测试备份恢复流程，确保数据可恢复性；  
5. **资源规划**：每个存储卷副本占用约 1GB 内存（用于缓存），需根据副本数预留节点内存。

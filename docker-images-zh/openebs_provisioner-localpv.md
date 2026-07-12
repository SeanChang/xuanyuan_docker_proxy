---
image: openebs/provisioner-localpv
description: "OpenEBS动态本地持久卷供应器，用于在容器环境中动态创建和管理本地持久卷，为应用提供本地化存储的持久化支持。"
source: https://xuanyuan.cloud/zh/r/openebs/provisioner-localpv
canonical: https://xuanyuan.cloud/zh/r/openebs/provisioner-localpv
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openebs/provisioner-localpv" title="openebs/provisioner-localpv Docker 镜像中文简介、标签列表与拉取命令">openebs/provisioner-localpv 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenEBS Dynamic Local PV Provisioner 镜像文档


## 1. 镜像概述和主要用途

OpenEBS Dynamic Local PV Provisioner 是 OpenEBS 项目提供的容器化工具，用于在 Kubernetes 集群中动态供应本地持久卷（Local Persistent Volume, Local PV）。其核心功能是根据用户定义的存储类（StorageClass）配置，自动创建和管理基于节点本地存储的 PV 资源，简化本地存储在 Kubernetes 环境中的使用流程。

该镜像主要适用于需要利用节点本地存储（如主机路径、LVM 卷、ZFS 数据集等）的场景，通过动态供应机制替代手动创建 PV 的繁琐操作，提升本地存储资源的管理效率。


## 2. 核心功能和特性

### 2.1 动态 PV 供应
- 支持基于 Kubernetes StorageClass 的声明式配置，自动响应 PVC（PersistentVolumeClaim）请求并创建 Local PV。
- 无需手动预创建 PV，降低运维复杂度。

### 2.2 多存储类型支持
- 兼容多种本地存储后端：
  - 主机路径（HostPath）：直接使用节点文件系统路径
  - LVM：基于逻辑卷管理的块存储
  - ZFS：基于 ZFS 文件系统的存储池
  - 自定义存储后端（通过插件扩展）

### 2.3 存储策略自定义
- 支持通过 StorageClass 参数定义存储特性，如文件系统类型（ext4、xfs）、存储路径前缀、容量限制等。
- 支持基于节点标签的存储节点选择，实现存储资源的定向分配。

### 2.4 存储生命周期管理
- 支持 PV 自动回收（当 PVC 删除且 StorageClass 配置 `reclaimPolicy: Delete` 时）。
- 存储容量监控：可集成 Prometheus 暴露存储使用 metrics。

### 2.5 Kubernetes 原生集成
- 符合 Kubernetes CSI（Container Storage Interface）规范，兼容 Kubernetes 1.14+ 版本。
- 支持 PV 节点亲和性（Node Affinity），确保 Pod 调度到 PV 所在节点。


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **低延迟应用**：如数据库（PostgreSQL、MySQL、MongoDB）、消息队列（Kafka、RabbitMQ）等需要本地存储低延迟特性的应用。
- **分布式存储本地缓存**：作为分布式存储系统（如 Ceph、GlusterFS）的本地缓存层，提升读写性能。
- **状态ful应用**：需要持久化本地数据的 StatefulSet 应用（如分布式数据库集群、服务注册中心）。
- **资源受限环境**：在无法使用共享存储的边缘节点或小型集群中，高效利用本地磁盘资源。

### 3.2 适用范围
- **环境要求**：Kubernetes 集群（1.14+ 版本，推荐 1.18+），节点需配置可用的本地存储（磁盘、分区或文件系统路径）。
- **存储限制**：仅支持节点本地存储，不提供跨节点数据共享或高可用能力（需结合应用层副本机制实现高可用）。


## 4. 使用方法和配置说明

### 4.1 部署前提
- Kubernetes 集群已运行（版本 ≥1.14），且节点已配置目标本地存储（如 `/var/openebs/local` 目录、LVM 卷组等）。
- 集群已安装 `kubectl` 命令行工具，且用户具有集群管理员权限。


### 4.2 Kubernetes 部署示例

#### 4.2.1 部署 Provisioner

通过 YAML 配置部署 Provisioner（以 DaemonSet 形式运行在目标节点）：

```yaml
# openebs-localpv-provisioner.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: openebs-localpv-provisioner
  namespace: openebs
spec:
  selector:
    matchLabels:
      name: openebs-localpv-provisioner
  template:
    metadata:
      labels:
        name: openebs-localpv-provisioner
    spec:
      serviceAccountName: openebs-localpv-provisioner
      containers:
      - name: provisioner
        image: docker.xuanyuan.run/openebs/provisioner-localpv:3.6.0  # 替换为最新版本
        env:
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: OPENEBS_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: PROVISIONER_NAME
          value: openebs.io/local
        - name: LOG_LEVEL
          value: "info"  # 可选：debug, info, warn, error
        volumeMounts:
        - name: localpv-mount
          mountPath: /var/openebs/local  # 宿主机本地存储根路径，需提前创建
      volumes:
      - name: localpv-mount
        hostPath:
          path: /var/openebs/local
          type: DirectoryOrCreate
```

应用部署：
```bash
kubectl create namespace openebs
kubectl apply -f openebs-localpv-provisioner.yaml
```


#### 4.2.2 创建 StorageClass

定义存储类（以 HostPath 为例）：

```yaml
# storageclass-localpv.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: openebs-local-hostpath
provisioner: openebs.io/local  # 需与 Provisioner 环境变量 PROVISIONER_NAME 一致
parameters:
  storage: "hostpath"  # 存储类型：hostpath/lvm/zfs
  path: "/var/openebs/local"  # 节点本地存储路径
  fsType: "ext4"  # 文件系统类型：ext4/xfs/btrfs
reclaimPolicy: Delete  # PV 回收策略：Delete/Retain
volumeBindingMode: WaitForFirstConsumer  # 延迟绑定，直到 Pod 调度后再创建 PV
allowedTopologies:  # 可选：限制存储节点（通过节点标签）
- matchLabelExpressions:
  - key: openebs.io/node
    values:
    - storage-node-1
    - storage-node-2
```

应用存储类：
```bash
kubectl apply -f storageclass-localpv.yaml
```


#### 4.2.3 创建 PVC 并使用

通过 PVC 请求本地 PV：

```yaml
# pvc-localpv.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-pvc
spec:
  accessModes:
    - ReadWriteOnce  # Local PV 仅支持 ReadWriteOnce 或 ReadOnlyMany
  resources:
    requests:
      storage: 10Gi  # 请求存储容量
  storageClassName: openebs-local-hostpath  # 关联上述创建的 StorageClass
```

应用 PVC：
```bash
kubectl apply -f pvc-localpv.yaml
```

在 Pod 中使用 PVC：
```yaml
# pod-using-localpv.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-using-localpv
spec:
  containers:
  - name: app
    image: docker.xuanyuan.run/busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: local-pvc
```


### 4.3 配置参数说明

#### 4.3.1 StorageClass 参数

| 参数名          | 说明                                                                 | 可选值                  | 默认值       |
|-----------------|----------------------------------------------------------------------|-------------------------|--------------|
| `storage`       | 本地存储类型                                                         | `hostpath`/`lvm`/`zfs`  | `hostpath`   |
| `path`          | 存储根路径（hostpath 类型必填）                                      | 节点存在的绝对路径      | `/var/openebs/local` |
| `fsType`        | 文件系统类型                                                         | `ext4`/`xfs`/`btrfs`    | `ext4`       |
| `lvm.vgName`    | LVM 卷组名称（lvm 类型必填）                                         | 节点上存在的 LVM 卷组   | -            |
| `zfs.poolName`  | ZFS 存储池名称（zfs 类型必填）                                       | 节点上存在的 ZFS 池     | -            |
| `capacity`      | 单 PV 最大容量限制（需配合 Provisioner 配置）                        | 如 `100Gi`              | 无限制       |


#### 4.3.2 Provisioner 环境变量

| 环境变量名               | 说明                                                                 | 默认值                 |
|--------------------------|----------------------------------------------------------------------|------------------------|
| `PROVISIONER_NAME`       | Provisioner 名称（需与 StorageClass `provisioner` 字段一致）         | `openebs.io/local`     |
| `NODE_NAME`              | 当前节点名称（自动从 fieldRef 获取，无需手动设置）                   | 节点 hostname          |
| `OPENEBS_NAMESPACE`      | Provisioner 所在命名空间                                             | `openebs`              |
| `LOG_LEVEL`              | 日志级别                                                             | `info`                 |
| `STORAGE_PATH`           | 默认存储根路径（当 StorageClass 未指定 `path` 时使用）               | `/var/openebs/local`   |
| `NODE_SELECTOR_LABEL`    | 节点选择标签（仅在 DaemonSet 中调度到匹配标签的节点）                | 无                     |
| `PV_RECLAIM_DELAY`       | PV 删除延迟时间（秒），用于防止误删除                               | `30`                   |


## 5. 常见问题与注意事项

- **PV 与节点绑定**：Local PV 与创建时所在节点强绑定，若节点故障，PV 将不可用，需手动处理数据恢复。
- **存储容量限制**：PVC 请求容量不得超过节点实际可用存储，否则 Provisioner 将拒绝创建 PV。
- **文件系统格式化**：Provisioner 会自动格式化指定 `fsType` 的文件系统，若路径已存在数据，需确保 `reclaimPolicy: Retain` 避免数据丢失。
- **升级兼容性**：升级 Provisioner 前需确保所有 PVC 处于 Bound 状态，避免影响正在使用的 PV。
- **监控集成**：通过配置 Prometheus ServiceMonitor，可采集 PV 使用率、供应成功率等 metrics，配置示例参考 [OpenEBS 官方文档](https://openebs.io/docs)。

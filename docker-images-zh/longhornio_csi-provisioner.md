<!-- xuanyuan-docker-images-zh
image: longhornio/csi-provisioner
source: https://xuanyuan.cloud/zh/r/longhornio/csi-provisioner
canonical: https://xuanyuan.cloud/zh/r/longhornio/csi-provisioner
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/longhornio/csi-provisioner" title="longhornio/csi-provisioner Docker 镜像中文简介、标签列表与拉取命令">longhornio/csi-provisioner — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/longhornio/csi-provisioner" title="longhornio/csi-provisioner Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/longhornio/csi-provisioner</a></p>

# CSI Provisioner 镜像文档

## 1. 镜像概述和主要用途

CSI Provisioner（容器存储接口供应者）是基于Container Storage Interface (CSI)规范实现的存储卷供应组件。该镜像封装了CSI Provisioner核心功能，主要用于与Kubernetes等容器编排平台集成，实现存储卷的动态创建、绑定、删除等生命周期管理，解决容器集群中存储资源的自动供应问题，为容器化应用提供可靠的存储支持。

## 2. 核心功能和特性

### 2.1 核心功能
- **动态存储卷供应**：根据容器集群的存储需求（通过PersistentVolumeClaim，PVC）自动创建存储卷（PersistentVolume，PV）
- **存储卷生命周期管理**：支持存储卷的创建、绑定、删除、扩容等全生命周期操作
- **CSI规范兼容**：遵循CSI 1.0+规范，可与符合CSI标准的存储驱动集成

### 2.2 关键特性
- **存储类支持**：与Kubernetes StorageClass资源深度集成，可基于存储类配置供应策略
- **拓扑感知**：支持根据节点拓扑信息（如区域、可用区）分配存储资源，满足数据本地化需求
- **重试机制**：内置操作失败重试逻辑，提高存储供应可靠性
- **多存储后端适配**：可与AWS EBS、GCP PD、Azure Disk、Ceph、NFS等多种存储后端集成
- **监控与日志**：支持标准日志输出，可集成Prometheus等监控工具监控供应状态

## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **Kubernetes集群存储自动化**：为Kubernetes集群提供存储卷的动态供应能力，替代手动创建PV的传统方式
- **多存储后端统一管理**：通过CSI接口标准化不同存储后端的接入，简化多存储系统的管理复杂度
- **大规模容器部署**：在微服务、大数据等大规模容器化部署场景中，实现存储资源的自动分配
- **存储卷动态扩缩容**：支持根据应用需求自动调整存储卷大小，满足业务增长需求

### 3.2 适用范围
- Kubernetes集群（1.13+版本，支持CSI规范）
- 需动态管理存储资源的容器化应用
- 采用CSI兼容存储驱动的存储系统（如Ceph RBD、GlusterFS、AWS EBS等）
- 需要存储资源隔离与权限控制的多租户环境

## 4. 使用方法和配置说明

### 4.1 部署方式
CSI Provisioner通常作为Kubernetes控制平面组件部署，以Deployment形式运行。需配合CSI驱动（如特定存储后端的CSI插件）使用。

#### 4.1.1 Kubernetes Deployment示例
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: csi-provisioner
  namespace: kube-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: csi-provisioner
  template:
    metadata:
      labels:
        app: csi-provisioner
    spec:
      serviceAccountName: csi-provisioner-sa
      containers:
      - name: csi-provisioner
        image: csi-provisioner:latest  # 替换为实际镜像名称
        args:
          - "--csi-address=$(CSI_ENDPOINT)"
          - "--provisioner=$(PROVISIONER_NAME)"
          - "--volume-name-prefix=csi"
          - "--v=5"  # 日志详细级别
        env:
          - name: CSI_ENDPOINT
            value: "unix:///csi/csi.sock"  # CSI驱动通信端点（需与CSI驱动共享）
          - name: PROVISIONER_NAME
            value: "storage.example.com/csi"  # 供应者名称（需与StorageClass匹配）
        volumeMounts:
          - name: csi-socket-dir
            mountPath: /csi
      volumes:
        - name: csi-socket-dir
          emptyDir: {}  # 通常与CSI驱动通过EmptyDir或HostPath共享套接字目录
```

#### 4.1.2 RBAC权限配置
CSI Provisioner需要访问Kubernetes API以管理PV、PVC等资源，需配置RBAC权限：
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: csi-provisioner-sa
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: csi-provisioner-role
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["create", "delete", "get", "list", "watch", "update"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  # 其他必要权限（如events、nodes等）
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: csi-provisioner-binding
subjects:
  - kind: ServiceAccount
    name: csi-provisioner-sa
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: csi-provisioner-role
  apiGroup: rbac.authorization.k8s.io
```

### 4.2 环境变量与配置参数

#### 4.2.1 核心环境变量
| 环境变量名               | 描述                                                                 | 示例值                          |
|--------------------------|----------------------------------------------------------------------|---------------------------------|
| `CSI_ENDPOINT`           | CSI驱动的通信端点，通常为unix域套接字路径                            | `unix:///csi/csi.sock`          |
| `PROVISIONER_NAME`       | 供应者名称，需与StorageClass中的`provisioner`字段一致                 | `storage.example.com/csi`       |
| `STORAGECLASS_WHITELIST` | 允许供应的StorageClass名称白名单（逗号分隔，默认允许所有）            | `standard,high-performance`     |
| `RETRY_INTERVAL`         | 操作失败后的重试间隔（秒）                                           | `30`                            |
| `VERBOSE`                | 日志详细程度（0-5，5为最详细）                                       | `5`                             |

#### 4.2.2 命令行参数
除环境变量外，可通过命令行参数配置（优先级高于环境变量）：
- `--csi-address`：同`CSI_ENDPOINT`
- `--provisioner`：同`PROVISIONER_NAME`
- `--storageclass-whitelist`：同`STORAGECLASS_WHITELIST`
- `--retry-interval-start`：初始重试间隔（秒），默认1
- `--retry-interval-max`：最大重试间隔（秒），默认300
- `--volume-name-prefix`：生成的PV名称前缀，默认`pvc`

### 4.3 使用步骤

1. **部署CSI驱动**：确保目标存储后端的CSI驱动已部署到Kubernetes集群（如Ceph CSI驱动）

2. **部署CSI Provisioner**：使用上述Deployment配置部署CSI Provisioner，确保与CSI驱动共享套接字目录

3. **创建StorageClass**：定义StorageClass资源，指定`provisioner`为`PROVISIONER_NAME`的值：
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: csi-storageclass
provisioner: storage.example.com/csi  # 需与PROVISIONER_NAME一致
parameters:
  storageBackend: "ceph"  # 存储后端参数，根据CSI驱动要求配置
  replicaCount: "3"
reclaimPolicy: Delete  # PV回收策略（Delete/Retain）
allowVolumeExpansion: true  # 允许卷扩容
```

4. **创建PVC**：创建PersistentVolumeClaim，引用上述StorageClass：
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: csi-storageclass  # 引用创建的StorageClass
```

5. **验证部署**：检查PV是否自动创建并与PVC绑定：
```bash
kubectl get pv
kubectl get pvc example-pvc
```

### 4.4 注意事项
- 确保CSI Provisioner与CSI驱动版本兼容（需同时支持相同的CSI规范版本）
- 配置正确的RBAC权限，避免因权限不足导致操作失败
- StorageClass的`parameters`需与CSI驱动要求匹配，否则可能导致供应失败
- 对于生产环境，建议部署多个Provisioner副本（通过Deployment的`replicas`配置）以提高可用性

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/longhornio/csi-provisioner" title="longhornio/csi-provisioner Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/longhornio/csi-provisioner</a></p>

---
image: rook/ceph
description: "开源分布式存储系统Ceph为Kubernetes集群提供文件存储（File Storage）、块存储（Block Storage）及对象存储（Object Storage）服务，可满足容器化应用在数据持久化、高可用性、可扩展性等核心场景下的存储需求，助力用户高效管理集群中的各类数据资源，实现存储与容器编排的无缝集成。"
source: https://xuanyuan.cloud/zh/r/rook/ceph
canonical: https://xuanyuan.cloud/zh/r/rook/ceph
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [rook/ceph — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/rook/ceph)

含镜像标签、拉取命令、部署文档与相关推荐。

[rook/ceph Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/rook/ceph)

# Ceph 存储服务：为 Kubernetes 集群提供文件、块和对象存储支持


## 一、概述  
Ceph 是一个开源分布式存储系统，具备高可用、高扩展、统一存储的特性，能够为 Kubernetes（K8s）集群提供全方位的存储服务。在 K8s 环境中，应用通常需要不同类型的持久化存储（如数据库需要低延迟的块存储、多节点应用需要共享文件存储、日志/图片等需要对象存储），而 Ceph 可通过统一的架构同时支持**块存储（Block）、文件存储（File）和对象存储（Object）** 三种类型，满足 K8s 集群中各类应用的存储需求。


## 二、核心存储服务类型  
Ceph 为 K8s 集群提供的三种存储服务，可分别适配不同应用场景：  


### 1. 块存储（Block Storage）  
- **特点**：提供块级存储，类似直接挂载物理硬盘，数据以固定大小的块（如 4KB、8KB）组织，支持随机读写，性能接近本地存储。  
- **适用场景**：K8s 中需要低延迟、高 IOPS 的应用，如数据库（MySQL、PostgreSQL）、分布式缓存（Redis 集群）、虚拟机镜像存储等。  
- **在 K8s 中的使用**：通过 Ceph RBD（RADOS Block Device）实现，可作为持久卷（PV）挂载给 Pod，支持动态 PV 供给（通过 StorageClass 配置）。  


### 2. 文件存储（File Storage）  
- **特点**：提供基于 POSIX 标准的共享文件系统，支持多节点同时读写，类似 NFS 但更可靠、可扩展。  
- **适用场景**：需要多 Pod 共享数据的应用，如日志聚合（ELK Stack）、媒体文件存储（视频/图片编辑）、代码仓库（GitLab）等。  
- **在 K8s 中的使用**：通过 Ceph FS（Ceph File System）实现，同样支持 K8s CSI 驱动，可动态创建共享文件系统 PV，供多个 Pod 同时挂载使用。  


### 3. 对象存储（Object Storage）  
- **特点**：以“对象”为单位存储数据（包含数据本身、元数据和唯一标识符），支持海量数据存储，通过 RESTful API（如 S3 兼容接口）访问，无需关心底层存储细节。  
- **适用场景**：K8s 中需要存储海量非结构化数据的场景，如用户上传的图片/视频、应用日志备份、静态资源（前端 JS/CSS）托管等。  
- **在 K8s 中的使用**：通过 Ceph RGW（RADOS Gateway）提供 S3/Swift 兼容接口，应用可直接通过 API 访问，或通过 K8s Secret 管理访问凭证。  


## 三、Ceph 与 Kubernetes 集成的核心价值  
在 K8s 集群中，Ceph 的优势在于“统一存储+动态供给”：  
- **适配多样化需求**：无论应用需要块存储（低延迟）、文件存储（共享访问）还是对象存储（海量数据），Ceph 都能通过一套系统满足，避免部署多套存储系统的复杂性；  
- **动态 PV 供给**：通过 K8s CSI（Container Storage Interface）驱动，Ceph 可与 K8s 的 StorageClass 结合，实现持久卷（PV）的动态创建和回收，无需手动管理存储资源；  
- **高可用与扩展**：Ceph 本身支持分布式部署，数据多副本存储，可容忍节点故障；存储容量可通过添加新节点线性扩展，适应 K8s 集群的动态扩缩容需求。  


## 四、部署与运维建议  
在 K8s 集群中使用 Ceph 存储时，可参考以下实践方向，提升可操作性：  

### 1. 简化部署：用 Rook 管理 Ceph 集群  
Rook 是一个开源的 K8s 存储编排工具，可将 Ceph 作为 K8s 的“存储插件”部署和管理。通过 Rook，无需手动配置 Ceph 集群（如 Monitor、OSD 节点），直接通过 K8s YAML 文件定义存储需求，Rook 会自动完成 Ceph 集群的部署、扩容和故障恢复。  

### 2. 按存储类型规划资源  
- **块存储**：优先使用 SSD 磁盘，提升 IOPS 和低延迟性能，适合数据库等核心应用；  
- **文件存储**：根据读写频率选择 SSD 或 HDD，若多节点并发读写频繁，建议用 SSD；  
- **对象存储**：以大容量、低成本为目标，可使用 HDD 磁盘，通过多节点扩展存储容量。  

### 3. 监控与容量管理  
- 集成 Prometheus + Grafana：通过 Rook 或 Ceph 自带的 Exporter 暴露监控指标（如 OSD 使用率、IO 延迟、PG 健康状态），实时监控存储性能和容量；  
- 设置容量阈值告警：当存储使用率达到 80% 左右时，及时扩容（添加 OSD 节点或磁盘），避免因容量不足影响应用。  

### 4. 配置 CSI 驱动，支持动态 PV  
在 K8s 中部署 Ceph CSI 驱动（Rook 已集成），并创建对应 StorageClass（如 `ceph-block`, `ceph-filesystem`, `ceph-object`），应用通过 `PersistentVolumeClaim`（PVC）声明存储需求，K8s 会自动从 Ceph 申请并挂载 PV。  


## 总结  
Ceph 凭借“统一存储架构+K8s 深度集成”的特性，成为 K8s 集群中持久化存储的理想选择。无论是数据库、共享文件服务还是海量对象存储，都能通过 Ceph 实现高效、可靠的存储支持，结合 Rook 等工具可进一步简化运维，让 K8s 应用的存储管理更高效、灵活。

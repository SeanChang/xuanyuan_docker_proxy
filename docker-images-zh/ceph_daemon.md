---
image: ceph/daemon
description: "该Docker镜像包含所有Ceph守护进程，用于部署和运行Ceph分布式存储系统。"
source: https://xuanyuan.cloud/zh/r/ceph/daemon
canonical: https://xuanyuan.cloud/zh/r/ceph/daemon
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ceph/daemon" title="ceph/daemon Docker 镜像中文简介、标签列表与拉取命令">ceph/daemon 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ceph 守护进程容器镜像文档


## 镜像概述和主要用途

本镜像包含所有 Ceph 守护进程，用于快速引导和部署 Ceph 集群。自 2021 年 8 月起，新的容器镜像仅推送到 `quay.io` 仓库，Docker Hub 不再接收更新，但现有镜像仍可使用。通过指定守护进程类型作为命令参数，可部署不同类型的 Ceph 守护进程，适用于容器化环境下的 Ceph 集群构建与管理。


## 核心功能和特性

- **多守护进程支持**：可部署 Monitor（`mon`）、OSD（多种类型）、MDS（`mds`）、RGW（`rgw`）、Manager、REST API、RBD Mirror 等所有 Ceph 核心组件。
- **灵活的 OSD 部署**：支持基于设备（`disk`）、预准备设备（`activate`）、目录（`directory`）、单目录单 OSD（`directory_single`）等多种 OSD 部署模式，适配不同存储场景。
- **KV 后端集成**：支持 etcd 作为配置、密钥和映射的存储后端，自动生成集群配置（`/etc/ceph`）。
- **设备管理工具**：提供 `zap_device` 功能，用于清理磁盘分区表，简化设备复用流程。
- **自动化配置**：通过环境变量或 `ceph.defaults` 文件灵活配置网络（`public_network`/`cluster_network`）、Journal 大小等核心参数。
- **多场景适配**：支持带/不带 KV 存储的部署模式，满足不同集群规模和管理需求。


## 使用场景和适用范围

- **Ceph 集群容器化部署**：适用于需要通过容器快速搭建 Ceph 集群的场景，支持开发、测试及生产环境。
- **灵活的存储配置**：支持多种 OSD 类型，适配物理磁盘、预格式化目录、加密存储（dmcrypt）、BlueStore 等存储需求。
- **动态集群管理**：结合 etcd KV 后端，实现配置集中化管理，简化集群扩缩容和配置更新。
- **混合环境部署**：支持主机网络（`--net=host`）或容器网络，适配不同网络架构；支持特权容器（设备直接访问）或非特权容器（目录挂载）模式。


## 前提条件

### SELinux 配置
若主机启用 SELinux，需执行以下命令配置目录权限：
```bash
sudo chcon -Rt svirt_sandbox_file_t /etc/ceph
sudo chcon -Rt svirt_sandbox_file_t /var/lib/ceph
```

### KV 后端准备
如需使用 KV 存储（etcd）管理配置，需提前部署 etcd 服务，并记录其 IP 和端口（默认端口 2379）。


## 详细使用方法和配置说明

### 通用参数
- `CLUSTER`：集群名称，默认值为 `ceph`。


### KV 存储填充
通过以下命令初始化 etcd KV 存储，用于存储集群配置、密钥和映射：
```bash
docker run -d --net=host \
  -e KV_TYPE=etcd \
  -e KV_IP=127.0.0.1 \  # etcd 服务 IP
  -e KV_PORT=2379 \      # etcd 服务端口
  ceph/daemon populate_kvstore
```


### 设备清理（Zap Device）
清理磁盘分区表（用于重新初始化 OSD 设备）：
```bash
docker run -d --privileged=true \
  -v /dev/:/dev/ \       # 挂载主机设备目录
  -e OSD_DEVICE=/dev/sdd \  # 需清理的设备路径（如 /dev/sdd）
  ceph/daemon zap_device
```


### 部署 Monitor
Monitor 需持久化存储（`/var/lib/ceph`），用于保存 CRUSH map 等数据。支持带/不带 KV 存储部署。

#### 不带 KV 存储
```bash
docker run -d --net=host \
  -v /etc/ceph:/etc/ceph \  # 挂载本地 Ceph 配置目录
  -v /var/lib/ceph/:/var/lib/ceph/ \  # 持久化存储目录
  -e MON_IP=192.168.0.20 \  # Monitor 主机 IP
  -e CEPH_PUBLIC_NETWORK=192.168.0.0/24 \  # 公共网络 CIDR
  ceph/daemon mon
```

#### 带 KV 存储（etcd）
```bash
docker run -d --net=host \
  -v /var/lib/ceph:/var/lib/ceph \  # 持久化存储目录（配置由 KV 生成）
  -e MON_IP=192.168.0.20 \
  -e CEPH_PUBLIC_NETWORK=192.168.0.0/24 \
  -e KV_TYPE=etcd \
  -e KV_IP=192.168.0.20 \  # etcd 服务 IP
  ceph/daemon mon
```

#### Monitor 专用参数
- `MON_NAME`：Monitor 名称，默认值为主机名。
- `MON_IP`：Monitor 主机 IP，必填。
- `CEPH_PUBLIC_NETWORK`：公共网络 CIDR（需包含 `MON_IP`），必填。
- `CEPH_CLUSTER_NETWORK`：集群复制网络 CIDR（可选，用于 OSD 内部通信）。
- `NETWORK_AUTO_DETECT`：IP/网络自动检测模式（0=禁用，1=IPv6 优先，4=仅 IPv4，6=仅 IPv6），默认 0（禁用）。


### 部署 Manager 守护进程
Luminous 及以上版本必须部署 Manager 守护进程：

#### 不带 KV 存储
```bash
docker run -d --net=host \
  -v /etc/ceph:/etc/ceph \
  -v /var/lib/ceph/:/var/lib/ceph/ \
  docker.xuanyuan.run/ceph/daemon mgr
```

#### 带 KV 存储
```bash
docker run -d --net=host \
  -v /var/lib/ceph:/var/lib/ceph \
  -e KV_TYPE=etcd \
  -e KV_IP=192.168.0.20 \  # etcd 服务 IP
  ceph/daemon mgr
```


### 部署 OSD
OSD 支持多种部署类型，通过 `OSD_TYPE` 指定，默认为自动检测（根据设备状态选择 `disk`/`activate`/`directory`）。

#### OSD_TYPE 说明
- `disk`：使用原始块设备（需指定 `OSD_DEVICE`），自动初始化 OSD。
- `activate`：激活预准备的 OSD 设备（需指定 `OSD_DEVICE`）。
- `directory`：使用预挂载的 OSD 目录（`/var/lib/ceph/osd/`），支持单容器多 OSD。
- `directory_single`：单容器单 OSD（使用预准备目录，无需特权模式）。

#### 通用 OSD 参数
- `OSD_DEVICE`：`disk`/`activate` 类型必填，指定 OSD 设备路径（如 `/dev/sdd`）。
- `OSD_JOURNAL`：Journal 文件路径（`disk`/`activate` 类型可选）。
- `OSD_JOURNAL_SIZE`：Journal 大小，通过 `ceph.defaults` 或环境变量配置。
- `CEPH_PUBLIC_NETWORK`/`CEPH_CLUSTER_NETWORK`：公共/集群网络 CIDR，可通过环境变量指定。
- `OSD_BLUESTORE`：启用 BlueStore（`1` 启用），默认禁用。
- `OSD_DMCRYPT`：启用磁盘加密（`1` 启用），默认禁用。

#### 示例 1：OSD_TYPE=disk（带 KV 存储，BlueStore）
```bash
docker run -d --net=host \
  --privileged=true \
  --pid=host \
  -v /dev/:/dev/ \
  -v /run/udev/:/run/udev/ \
  -e OSD_DEVICE=/dev/sdd \  # OSD 设备
  -e OSD_TYPE=disk \
  -e OSD_BLUESTORE=1 \      # 启用 BlueStore
  -e KV_TYPE=etcd \
  -e KV_IP=192.168.0.20 \
  ceph/daemon osd
```

#### 示例 2：OSD_TYPE=directory（非特权模式，单容器多 OSD）
1. 提前创建 OSD 目录并设置权限（UID/GID 167:167）：
   ```bash
   mkdir -p /var/lib/ceph/osd/ceph-{1,2}  # 创建 OSD 1 和 OSD 2 目录
   chown -R 167:167 /var/lib/ceph/osd/
   ```
2. 部署容器：
   ```bash
   docker run -d --net=host \
     -v /var/lib/ceph/osd/ceph-1:/var/lib/ceph/osd/ceph-1 \
     -v /var/lib/ceph/osd/ceph-2:/var/lib/ceph/osd/ceph-2 \
     -e OSD_TYPE=directory \
     docker.xuanyuan.run/ceph/daemon osd
   ```


### 部署 MDS（Ceph 文件系统元数据服务器）
MDS 需手动启用文件系统创建（`CEPHFS_CREATE=1`）：

#### 不带 KV 存储
```bash
docker run -d --net=host \
  -v /etc/ceph:/etc/ceph \
  -v /var/lib/ceph/:/var/lib/ceph/ \
  -e CEPHFS_CREATE=1 \  # 创建 CephFS（仅当文件系统不存在时）
  -e CEPHFS_NAME=myfs \  # 文件系统名称，默认 cephfs
  ceph/daemon mds
```

#### 带 KV 存储
```bash
docker run -d --net=host \
  -e CEPHFS_CREATE=1 \
  -e KV_TYPE=etcd \
  -e KV_IP=192.168.0.20 \
  docker.xuanyuan.run/ceph/daemon mds
```

#### MDS 参数
- `CEPHFS_CREATE`：是否创建文件系统（`1` 启用），默认 0。
- `CEPHFS_NAME`：文件系统名称，默认 `cephfs`。
- `MDS_NAME`：MDS 实例名称，默认 `mds-$(hostname)`。


### 部署 Rados Gateway（RGW）
默认使用 civetweb 作为 HTTP 前端，端口 8080：

#### 带 KV 存储
```bash
docker run -d --net=host \
  -e KV_TYPE=etcd \
  -e KV_IP=192.168.0.20 \
  -e RGW_CIVETWEB_PORT=8088 \  # 自定义端口（默认 8080）
  ceph/daemon rgw
```

#### RGW 参数
- `RGW_CIVETWEB_PORT`：civetweb 监听端口，默认 8080。
- `RGW_NAME`：RGW 实例名称，默认主机名。


### 部署 REST API
Luminous 及以上版本支持，用于集群管理：
```bash
docker run -d --net=host \
  -e KV_TYPE=etcd \
  -e KV_IP=192.168.0.20 \
  -e RESTAPI_PORT=5001 \  # 自定义端口（默认 5000）
  ceph/daemon restapi
```

#### REST API 参数
- `RESTAPI_IP`：监听 IP，默认 `0.0.0.0`。
- `RESTAPI_PORT`：监听端口，默认 5000。
- `RESTAPI_LOG_LEVEL`：日志级别，默认 `warning`。


### 部署 RBD Mirror
用于 RBD 镜像跨集群同步：
```bash
docker run -d --net=host \
  -e KV_TYPE=etcd \
  -e KV_IP=192.168.0.20 \
  docker.xuanyuan.run/ceph/daemon rbd_mirror
```


## 配置参数汇总

| 参数                  | 用途                                  | 默认值          | 适用场景               |
|-----------------------|---------------------------------------|-----------------|------------------------|
| `KV_TYPE`             | KV 存储类型                           | -               | 所有带 KV 部署         |
| `KV_IP`               | KV 服务 IP                            | -               | 所有带 KV 部署         |
| `KV_PORT`             | KV 服务端口                           | 2379            | 所有带 KV 部署         |
| `MON_IP`              | Monitor 主机 IP                       | -               | Monitor 部署           |
| `CEPH_PUBLIC_NETWORK` | 公共网络 CIDR                         | -               | Monitor/OSD 部署       |
| `OSD_DEVICE`          | OSD 设备路径                          | -               | OSD_TYPE=disk/activate |
| `OSD_TYPE`            | OSD 部署类型                          | 自动检测        | OSD 部署               |
| `CEPHFS_CREATE`       | 是否创建 CephFS                       | 0               | MDS 部署               |
| `RGW_CIVETWEB_PORT`   | RGW 监听端口                          | 8080            | RGW 部署               |
| `RESTAPI_PORT`        | REST API 监听端口                     | 5000            | REST API 部署          |

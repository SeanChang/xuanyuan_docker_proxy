---
image: portainer/pause
description: "Kubernetes官方构建的暂停容器，包含ARM32 v6和v7架构镜像，用于Kubernetes集群中Pod的基础网络命名空间管理。"
source: https://xuanyuan.cloud/zh/r/portainer/pause
canonical: https://xuanyuan.cloud/zh/r/portainer/pause
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/portainer/pause" title="portainer/pause Docker 镜像中文简介、标签列表与拉取命令">portainer/pause — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/portainer/pause" title="portainer/pause Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/portainer/pause</a>

# Kubernetes Pause容器


## 镜像概述

### 主要用途  
Kubernetes Pause容器（简称Pause容器）是由Kubernetes官方仓库构建的基础设施容器，主要作为Kubernetes Pod的"父容器"，为Pod内所有业务容器提供共享的网络命名空间和PID命名空间，是实现Pod网络隔离与容器共享环境的核心组件。该镜像特别包含对ARM32 v6和v7架构的支持，适用于嵌入式设备及低功耗ARM平台的Kubernetes集群。


## 核心功能和特性

### 1. 命名空间共享  
作为Pod的"基础设施容器"，Pause容器负责创建并持有Pod的网络命名空间（Network Namespace）和PID命名空间（PID Namespace），使Pod内的所有业务容器可共享同一网络栈（IP、端口、网络设备）和进程ID空间，实现容器间通信与资源隔离。

### 2. 轻量级设计  
镜像体积极小（通常仅几MB），基于极简的基础镜像（如alpine或scratch）构建，仅包含必要的`pause`系统调用逻辑，运行时几乎不消耗CPU和内存资源。

### 3. 多架构支持  
官方提供对ARM32 v6、ARM32 v7等架构的原生支持，可运行于树莓派、嵌入式网关等ARM32架构设备，同时兼容Kubernetes官方支持的其他主流架构（如amd64、arm64等）。

### 4. 官方兼容性保障  
由Kubernetes官方团队维护，镜像版本与Kubernetes核心组件严格同步，确保与各版本Kubernetes集群的兼容性，避免因基础设施容器差异导致的Pod启动失败或网络异常。


## 使用场景和适用范围

### 典型使用场景  
- **Kubernetes集群基础设施**：作为Pod的默认" Infra容器"，由kubelet自动创建并管理，用户无需手动部署。  
- **ARM32架构Kubernetes集群**：在基于ARM32 v6/v7架构的设备（如树莓派集群、工业嵌入式设备）上部署Kubernetes时，提供兼容的基础设施容器支持。  

### 适用范围  
- 所有Kubernetes集群环境（开发、测试、生产）；  
- 嵌入式设备、边缘计算节点等ARM32架构场景；  
- 需严格控制基础设施容器资源占用的轻量化集群。  


## 使用方法和配置说明

### 镜像拉取  
Pause容器通常由kubelet自动拉取，用户可通过以下命令手动拉取指定架构的镜像（以ARM32 v7为例）：  
```bash
# 拉取ARM32 v7架构镜像（需确保Docker环境支持ARM32架构，或通过buildx启用多架构支持）
docker pull registry.k8s.io/pause:3.9-arm32v7
```

### 手动运行示例  
Pause容器运行时仅执行`pause`系统调用（进程挂起），无实际业务逻辑，手动运行示例如下：  
```bash
# 运行ARM32 v7架构的Pause容器
docker run -d --name pause-demo registry.k8s.io/pause:3.9-arm32v7
```
> 说明：手动运行的Pause容器无实际功能，仅用于验证镜像可用性；实际集群中Pod的Pause容器由kubelet自动管理，用户无需干预。

### Kubernetes集群配置  
Kubernetes集群通过kubelet的`--pod-infra-container-image`参数指定Pause容器镜像地址及版本，配置方式如下：  

#### 1. kubelet命令行参数配置  
在kubelet启动参数中指定：  
```bash
kubelet --pod-infra-container-image=registry.k8s.io/pause:3.9-arm32v7 ...
```

#### 2. kubeadm部署时指定  
使用kubeadm初始化集群时，通过`--pod-infra-container-image`参数覆盖默认镜像：  
```bash
kubeadm init --pod-infra-container-image=registry.k8s.io/pause:3.9-arm32v7 ...
```

#### 3. 配置文件持久化（推荐）  
在kubelet配置文件（如`/var/lib/kubelet/config.yaml`）中设置：  
```yaml
podInfraContainerImage: "registry.k8s.io/pause:3.9-arm32v7"
```


## 配置参数说明  

### 核心配置参数  
| 参数名                  | 说明                                                                 | 默认值示例                  |  
|-------------------------|----------------------------------------------------------------------|-----------------------------|  
| `--pod-infra-container-image` | kubelet参数，指定Pause容器镜像地址（含架构标签）                          | `registry.k8s.io/pause:3.9` |  
| 镜像标签                | 通过标签区分架构（如`-arm32v6`对应ARM32 v6，`-arm32v7`对应ARM32 v7） | `3.9-arm32v7`               |  


## 镜像版本和架构支持  

### 版本命名规则  
镜像标签格式为 `<Kubernetes版本>-<架构>`，例如：  
- `3.9-arm32v6`：对应Kubernetes 1.24+版本，ARM32 v6架构；  
- `3.9-arm32v7`：对应Kubernetes 1.24+版本，ARM32 v7架构。  

### 支持的ARM32架构  
- **ARM32 v6**：适用于早期ARMv6架构设备（如树莓派1、部分嵌入式MCU）；  
- **ARM32 v7**：适用于ARMv7架构设备（如树莓派2/3、主流ARM嵌入式处理器）。  

> 注：完整架构列表及最新版本可参考[Kubernetes官方镜像仓库](https://console.cloud.google.com/gcr/images/k8s-artifacts-prod/us/pause)。

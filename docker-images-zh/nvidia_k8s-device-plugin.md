---
image: nvidia/k8s-device-plugin
description: "NVIDIA K8s设备插件镜像，用于在Kubernetes集群中部署设备插件，实现对NVIDIA GPU资源的管理与调度。"
source: https://xuanyuan.cloud/zh/r/nvidia/k8s-device-plugin
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[nvidia/k8s-device-plugin](https://xuanyuan.cloud/zh/r/nvidia/k8s-device-plugin)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# NVIDIA Kubernetes设备插件（k8s-device-plugin）镜像文档


## 重要通知

自GPU设备插件v0.12.0版本起，Docker Hub将不再发布新镜像。请使用NGC目录中的镜像：[`nvcr.io/nvidia/k8s-device-plugin`](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/k8s-device-plugin)


## 镜像概述和主要用途

NVIDIA Kubernetes设备插件（k8s-device-plugin）是一个符合Kubernetes设备插件框架规范的组件，用于在Kubernetes集群中实现NVIDIA GPU资源的自动发现、管理和调度。该插件允许集群中的Pod通过Kubernetes API请求GPU资源，并确保GPU资源被正确分配和隔离。

**主要用途**：作为Kubernetes节点级组件，为集群提供GPU资源的抽象和管理能力，使容器化应用能够便捷地使用NVIDIA GPU进行加速计算。


## 核心功能和特性

- **GPU资源自动发现**：自动识别节点上的NVIDIA GPU设备及属性（如型号、内存）
- **资源分配与隔离**：支持按整卡或MIG（多实例GPU）方式分配GPU资源
- **Kubernetes兼容性**：符合Kubernetes设备插件v1beta1 API规范
- **多基础镜像支持**：提供基于Ubuntu、CentOS、Red Hat UBI等多种基础镜像的版本
- **轻量化设计**：镜像体积小，资源占用低，适合作为DaemonSet在集群节点上长期运行


## 使用场景和适用范围

适用于需要在Kubernetes集群中运行GPU加速工作负载的场景，包括但不限于：
- 机器学习/深度学习训练与推理（如TensorFlow、PyTorch应用）
- 科学计算与数值模拟
- 视频编解码、图形渲染等GPU加速任务
- 基于MIG的GPU资源精细化管理场景

**适用环境**：
- 部署有NVIDIA GPU的Kubernetes集群（v1.10+）
- 节点已安装NVIDIA驱动（版本需与GPU型号匹配）
- 容器运行时支持NVIDIA容器运行时（如nvidia-container-runtime）


## 支持的标签和Dockerfile链接

### 最新支持版本（v0.11.0及更早）

| 版本号   | 标签名称                     | 基础镜像       | Dockerfile链接                                                                 |
|----------|------------------------------|----------------|--------------------------------------------------------------------------------|
| v0.11.0  | `v0.11.0`, `v0.11.0-ubuntu20.04` | Ubuntu 20.04   | [Dockerfile](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.11.0/deployments/container/Dockerfile.ubuntu) |
| v0.11.0  | `v0.11.0-ubi8`               | Red Hat UBI 8  | [Dockerfile](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.11.0/deployments/container/Dockerfile.ubi8) |
| v0.10.0  | `v0.10.0`, `v0.10.0-ubuntu20.04` | Ubuntu 20.04   | [Dockerfile](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.10.0/docker/Dockerfile) |
| v0.10.0  | `v0.10.0-ubi8`               | Red Hat UBI 8  | [Dockerfile](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.10.0/docker/Dockerfile) |
| v0.9.0   | `latest`, `v0.9.0`, `v0.9.0-ubuntu16.04` | Ubuntu 16.04 | [Dockerfile](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.9.0/docker/amd64/Dockerfile.ubuntu16.04) |
| v0.9.0   | `v0.9.0-centos7`             | CentOS 7       | [Dockerfile](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.9.0/docker/amd64/Dockerfile.centos7) |
| v0.9.0   | `v0.9.0-ubi8`                | Red Hat UBI 8  | [Dockerfile](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.9.0/docker/amd64/Dockerfile.ubi8) |
| v0.8.x   | `v0.8.2-ubuntu16.04`, `v0.8.2-centos7`, `v0.8.2-ubi8`等 | Ubuntu 16.04/CentOS 7/UBI 8 | [v0.8.2 Dockerfiles](https://github.com/NVIDIA/k8s-device-plugin/tree/v0.8.2/docker/amd64) |


### 旧版本标签（历史版本）

#### v0.7.x及更早版本（amd64架构）
包含`v0.7.3`、`v0.7.2`、`v0.6.0`、`v0.5.0`等版本，支持Ubuntu 16.04、CentOS 7、UBI 8基础镜像，标签格式为`v<版本>-<基础镜像>`（如`v0.7.0-ubuntu16.04`）。  
Dockerfile链接示例：[v0.7.0 Ubuntu 16.04](https://github.com/NVIDIA/k8s-device-plugin/blob/v0.7.0/docker/amd64/Dockerfile.ubuntu16.04)

#### 早期beta版本
包含`1.0.0-beta`、`1.0.0-beta1`至`1.0.0-beta6`等版本，标签格式为`<beta版本>-<基础镜像>`（如`1.0.0-beta6-centos7`）。

#### 1.x系列旧版本
包含`1.11`、`1.10`、`1.9`等版本，支持Ubuntu 16.04和CentOS 7基础镜像，标签格式为`<版本>-<基础镜像>`（如`1.11-ubuntu16.04`）。


## 部署方法

### Kubernetes DaemonSet部署（推荐）

通过Kubernetes DaemonSet在集群所有GPU节点上部署设备插件：

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nvidia-device-plugin-daemonset
  namespace: kube-system
spec:
  selector:
    matchLabels:
      name: nvidia-device-plugin-ds
  template:
    metadata:
      labels:
        name: nvidia-device-plugin-ds
    spec:
      tolerations:
      - key: nvidia.com/gpu
        operator: Exists
        effect: NoSchedule
      containers:
      - image: nvcr.io/nvidia/k8s-device-plugin:v0.14.1  # 使用NGC最新镜像
        name: nvidia-device-plugin-ctr
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop: ["ALL"]
        volumeMounts:
        - name: device-plugin
          mountPath: /var/lib/kubelet/device-plugins
      volumes:
      - name: device-plugin
        hostPath:
          path: /var/lib/kubelet/device-plugins
```

**部署命令**：
```bash
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.1/deployments/static/nvidia-device-plugin.yml
```


## 注意事项

1. **前置条件**：
   - 节点需安装NVIDIA驱动（版本≥418.81.07，推荐最新稳定版）
   - 容器运行时需配置nvidia-container-runtime（如containerd配置`[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]`）
   - Kubernetes集群版本≥1.10（推荐1.16+以支持最新设备插件API）

2. **版本兼容性**：
   - 设备插件版本需与Kubernetes版本兼容（参考[官方兼容性矩阵](https://docs.nvidia.com/datacenter/cloud-native/kubernetes/overview.html#compatibility-matrix)）
   - v0.12.0+版本仅在NGC发布，Docker Hub不再更新

3. **资源验证**：
   部署后可通过以下命令验证GPU资源是否被正确识别：
   ```bash
   kubectl describe nodes | grep nvidia.com/gpu
   ```


## 参考链接

- [NGC镜像地址](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/k8s-device-plugin)
- [GitHub项目主页](https://github.com/NVIDIA/k8s-device-plugin)
- [NVIDIA Kubernetes设备插件文档](https://docs.nvidia.com/datacenter/cloud-native/kubernetes/device-plugin.html)

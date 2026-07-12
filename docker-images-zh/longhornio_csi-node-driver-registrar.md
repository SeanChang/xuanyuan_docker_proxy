---
image: longhornio/csi-node-driver-registrar
description: "CSI节点驱动注册器，用于将CSI存储驱动注册到Kubernetes节点，实现存储插件的发现与注册，确保容器存储接口正常工作。"
source: https://xuanyuan.cloud/zh/r/longhornio/csi-node-driver-registrar
canonical: https://xuanyuan.cloud/zh/r/longhornio/csi-node-driver-registrar
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/longhornio/csi-node-driver-registrar" title="longhornio/csi-node-driver-registrar Docker 镜像中文简介、标签列表与拉取命令">longhornio/csi-node-driver-registrar 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述
CSI Node Driver Registrar是容器存储接口（CSI）规范定义的核心组件，运行在Kubernetes集群的每个节点上。其主要作用是将CSI存储驱动的元数据和能力信息注册到节点的kubelet组件，实现存储插件的节点级发现与注册，是CSI驱动与Kubernetes集群集成的关键辅助组件。

## 核心功能与特性
### 核心功能
- **驱动信息注册**：收集CSI驱动的名称、支持的存储能力、协议版本等元数据，并注册到kubelet的插件注册表。
- **kubelet通信桥梁**：通过Unix域套接字与节点kubelet建立通信，上报驱动状态及注册信息，确保kubelet能够发现并使用CSI驱动。
- **状态监控与报告**：实时监控CSI驱动运行状态，向kubelet反馈驱动健康状况，保障存储服务可用性。

### 关键特性
- **CSI规范兼容**：完全符合CSI v1.0+规范，支持主流CSI驱动的注册需求。
- **轻量级设计**：组件体积小，资源占用低，仅专注于注册功能。
- **可配置性**：支持通过命令行参数调整日志级别、套接字路径等关键配置。

## 使用场景
CSI Node Driver Registrar主要应用于Kubernetes集群中部署CSI兼容存储插件的场景，具体包括：
- 部署分布式存储系统（如Ceph RBD、GlusterFS）的CSI插件时，作为节点侧注册组件。
- 部署云厂商存储服务（如AWS EBS、Azure Disk、Google PD）的CSI插件时，实现驱动与kubelet的集成。
- 部署本地存储插件（如Local SSD、LVM、NVMe）的CSI插件时，完成节点级驱动发现。

## 使用方法与配置说明
### 部署方式
该组件通常以DaemonSet方式在Kubernetes集群中部署，确保每个节点运行一个实例，与CSI节点驱动容器共享主机存储卷以访问驱动套接字。

### 典型部署示例（DaemonSet）
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: csi-node-driver-registrar
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: csi-node-driver-registrar
  template:
    metadata:
      labels:
        app: csi-node-driver-registrar
    spec:
      containers:
      - name: csi-node-driver-registrar
        image: ***-k8s.xuanyuan.run/sig-storage/csi-node-driver-registrar:v2.9.0  # 示例镜像版本，需根据集群版本选择
        args:
        - --csi-address=/csi/csi.sock  # CSI驱动的Unix域套接字路径
        - --kubelet-registration-path=/var/lib/kubelet/plugins/csi.example.com/csi.sock  # 驱动在kubelet中的注册路径
        - --v=5  # 日志级别
        volumeMounts:
        - name: csi-plugin-dir
          mountPath: /csi  # 挂载CSI驱动的套接字目录
        - name: kubelet-registry-dir
          mountPath: /var/lib/kubelet/plugins_registry/  # 挂载kubelet插件注册目录
      volumes:
      - name: csi-plugin-dir
        hostPath:
          path: /var/lib/kubelet/plugins/csi.example.com/  # 主机上CSI驱动的安装路径
          type: DirectoryOrCreate
      - name: kubelet-registry-dir
        hostPath:
          path: /var/lib/kubelet/plugins_registry/  # kubelet插件注册目录
          type: Directory
```

### 配置参数说明
CSI Node Driver Registrar支持以下核心命令行参数：
- `--csi-address`: CSI驱动的Unix域套接字路径，用于与驱动通信（必填，如`/csi/csi.sock`）。
- `--kubelet-registration-path`: 驱动在kubelet中的注册路径，kubelet通过此路径发现驱动（必填，如`/var/lib/kubelet/plugins/csi.example.com/csi.sock`）。
- `--v`: 日志级别，数值范围1-10，默认2，数值越大日志越详细（可选）。
- `--registration-path`: 注册器自身的Unix域套接字路径（可选，默认`/registration/csi-node-driver-registrar.sock`）。

### 依赖与注意事项
- **存储卷共享**：需与CSI节点驱动容器共享主机卷，确保能够访问驱动的Unix域套接字文件。
- **权限要求**：运行用户需具备访问kubelet注册目录（通常为`/var/lib/kubelet/plugins_registry/`）的读写权限，建议使用root用户或配置CAP_SYS_ADMIN等权限。
- **版本兼容性**：需与Kubernetes集群版本匹配，建议使用Kubernetes SIG存储提供的官方镜像（如`registry.k8s.io/sig-storage/csi-node-driver-registrar`），并选择与集群版本兼容的镜像标签。

---
image: calico/pod2daemon-flexvol
description: "calico/pod2daemon-flexvol 是 Project Calico 提供的 Kubernetes FlexVolume 驱动镜像，用于在容器化环境中建立 Pod 与本地守护进程的安全通信通道。通过该镜像，用户可在 Kubernetes 集群中灵活挂载持久化存储卷，支持 IPv4/IPv6、macvlan 等多种网络模式，确保 Pod 与节点级服务（如 Calico 网络策略代理）的可靠交互。"
source: https://xuanyuan.cloud/zh/r/calico/pod2daemon-flexvol
canonical: https://xuanyuan.cloud/zh/r/calico/pod2daemon-flexvol
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/calico/pod2daemon-flexvol" title="calico/pod2daemon-flexvol Docker 镜像中文简介、标签列表与拉取命令">calico/pod2daemon-flexvol 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Calico Pod2Daemon FlexVol Docker 镜像使用指南

## 快速参考

### 维护方
由 Project Calico 团队维护。

### 帮助渠道
可通过 Calico 官方文档、GitHub 仓库或社区论坛获取支持。

### 支持的标签及对应 Dockerfile 链接
- 稳定版本标签：v3.26.1、v3.21.4 等（与 Calico 主版本同步）
- 基础镜像变体：基于 Debian 或 Alpine Linux（部分标签后缀标识）

### 问题反馈地址
Calico GitHub Issues：https://github.com/projectcalico/calico/issues

### 支持的架构
amd64（主流架构），部分版本可能支持 arm64（需参考镜像仓库）

### 镜像详情
包含元数据、传输大小等信息：Docker Hub 镜像页面

### 镜像更新
随 Calico 版本发布同步更新，支持通过镜像摘要（Digest）固定版本以确保安全性。


## 什么是 Calico Pod2Daemon FlexVol

该镜像通过 FlexVolume 插件机制，允许 Kubernetes Pod 直接访问节点级服务（如 Calico Felix 代理），实现网络策略的高效实施。其核心功能包括：

- 动态挂载卷插件，支持容器与本地守护进程的通信
- 兼容 Kubernetes 网络策略，确保 Pod 间流量的细粒度控制
- 轻量化设计，适用于大规模容器集群的部署


## 如何使用本镜像

### 启动 FlexVolume 驱动实例

```bash
docker run --name calico-flexvol -v /var/lib/kubelet/plugins:/host/var/lib/kubelet/plugins -v /etc/cni/net.d:/host/etc/cni/net.d -d docker.xuanyuan.run/calico/pod2daemon-flexvol:v3.26.1
```

挂载关键目录以确保插件与 Kubernetes 节点通信。

### 与 Calico CNI 集成

在 Kubernetes 集群中，通常与 calico/cni 和 calico/node 镜像配合使用，通过 DaemonSet 部署以实现全节点覆盖：

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: calico-node
spec:
  template:
    spec:
      containers:
        - name: calico-node
          image: docker.xuanyuan.run/calico/node:v3.26.1
        - name: calico-pod2daemon-flexvol
          image: docker.xuanyuan.run/calico/pod2daemon-flexvol:v3.26.1
          volumeMounts:
            - mountPath: /host/var/lib/kubelet/plugins
              name: flexvol-mount
```

通过 Volume 共享实现插件与节点的交互。


## 容器 shell 访问与日志查看

### 进入容器

```bash
docker exec -it calico-flexvol sh
```

### 查看日志

```bash
docker logs calico-flexvol
```


## 环境变量

无特殊环境变量，配置通过挂载目录和 Kubernetes 资源自动注入。


## 数据持久化

无需单独持久化数据，关键配置通过 Kubernetes 卷插件机制动态管理。


## 注意事项

- 需与 Calico CNI 插件版本保持一致，避免兼容性问题
- 确保容器对挂载目录（如 /host/var/lib/kubelet/plugins）有读写权限


## 许可信息

镜像遵循 Apache License 2.0，详情参考 Calico 开源协议 https://www.projectcalico.org/terms/

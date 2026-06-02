---
image: calico/kube-controllers
description: "calico/kube-controllers 是 Project Calico 提供的 Kubernetes 控制器镜像，负责监控 Kubernetes API 事件并同步 Calico 网络策略、命名空间、服务账户等资源到数据存储（如 etcd），确保集群状态的一致性。"
source: https://xuanyuan.cloud/zh/r/calico/kube-controllers
canonical: https://xuanyuan.cloud/zh/r/calico/kube-controllers
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [calico/kube-controllers — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/calico/kube-controllers)

含镜像标签、拉取命令、部署文档与相关推荐。

[calico/kube-controllers Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/calico/kube-controllers)

# Calico Kubernetes 控制器 Docker 镜像使用指南

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


## 什么是 Calico Kubernetes 控制器

该镜像包含多个控制器组件，核心功能包括：

- **策略控制器**：将 Kubernetes 网络策略同步到 Calico 策略存储
- **命名空间控制器**：管理命名空间生命周期，自动创建 Calico 配置文件
- **服务账户控制器**：为服务账户生成安全标签
- **节点控制器**：维护节点与 Calico 数据存储的一致性


## 如何使用本镜像

### 启动控制器实例

```bash
docker run --name calico-kube-controllers -e ETCD_ENDPOINTS=http://etcd:2379 -d calico/kube-controllers:v3.26.1
```

通过环境变量配置 etcd 连接信息。

### 与 Calico 数据存储集成

在 Kubernetes 集群中，通常通过 Deployment 部署，并配置与 etcd 的通信参数：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: calico-kube-controllers
spec:
  template:
    spec:
      containers:
        - name: calico-kube-controllers
          image: calico/kube-controllers:v3.26.1
          env:
            - name: ETCD_ENDPOINTS
              value: http://etcd-cluster:2379
```

确保控制器能访问 etcd 集群。


## 容器 shell 访问与日志查看

### 进入容器

```bash
docker exec -it calico-kube-controllers sh
```

### 查看日志

```bash
docker logs calico-kube-controllers
```


## 环境变量

- **ETCD_ENDPOINTS**：etcd 服务端点（必填）
- **ETCD_CA_CERT_FILE**：etcd 客户端 CA 证书路径（TLS 加密时需配置）
- **DATASTORE_TYPE**：数据存储类型（默认 etcdv3，也可配置为 kubernetes）


## 数据持久化

数据存储在 etcd 中，控制器本身无本地状态，无需单独持久化。


## 注意事项

- 需与 Calico 其他组件（如 calico/node）版本一致
- 生产环境建议启用 TLS 加密与 RBAC 授权
- 若使用 Kubernetes API 作为数据存储，需配置 DATASTORE_TYPE=kubernetes 并授予控制器相应权限


## 许可信息

镜像遵循 Apache License 2.0，详情参考 Calico 开源协议 https://www.projectcalico.org/terms/

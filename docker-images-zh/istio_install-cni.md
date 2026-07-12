---
image: istio/install-cni
description: "Istio CNI是Istio的CNI插件，用于在Kubernetes环境中自动配置容器网络规则，简化Istio Sidecar代理的网络集成，提升服务网格部署效率。"
source: https://xuanyuan.cloud/zh/r/istio/install-cni
canonical: https://xuanyuan.cloud/zh/r/istio/install-cni
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/istio/install-cni" title="istio/install-cni Docker 镜像中文简介、标签列表与拉取命令">istio/install-cni 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Istio CNI 镜像文档

## 1. 镜像概述

Istio CNI 镜像是 Istio 服务网格的核心组件之一，提供 Kubernetes 容器网络接口（CNI）插件功能。该镜像不支持直接运行，而是作为 Istio 部署流程的一部分，通过 Kubernetes DaemonSet 在集群节点上运行，负责 Pod 网络规则的配置与管理，替代传统的 `istio-init` 特权初始化容器，提升集群安全性。

## 2. 核心功能与特性

- **Pod 网络自动配置**：为 Istio 管理的 Pod 自动注入网络规则，实现流量拦截与重定向至 Sidecar 代理（Envoy）。
- **替代特权 init 容器**：无需使用 `istio-init` 特权容器即可完成 Pod 网络初始化，降低集群安全风险。
- **Kubernetes CNI 规范兼容**：遵循 Kubernetes CNI 框架标准，支持与主流 CNI 插件（如 Calico、Flannel）协同工作。
- **网络策略协同**：配合 Istio 网络策略实现精细化流量控制，支持 mTLS 加密、流量路由等高级功能。

## 3. 使用场景与适用范围

- **Istio 服务网格部署**：在 Kubernetes 集群中部署 Istio 时，需通过该镜像提供的 CNI 插件管理 Pod 网络。
- **安全合规需求**：适用于禁止使用特权容器的场景，通过 CNI 插件实现非特权方式的 Pod 网络配置。
- **大规模集群管理**：简化 Istio 对集群内 Pod 网络的批量配置，提升服务网格部署效率。

## 4. 使用方法与配置说明

### 4.1 前置条件

- Kubernetes 集群版本 ≥ 1.21
- 集群已部署基础 CNI 插件（需与 Istio CNI 兼容）
- 具备集群管理员权限（需部署 DaemonSet 及修改节点配置）

### 4.2 安装流程

Istio CNI 需通过 Istio 官方安装工具（`istioctl` 或 Helm）启用，不支持直接通过 `docker run` 运行。

#### 4.2.1 通过 `istioctl` 安装

```bash
# 下载 istioctl（参考 Istio 官方文档）
istioctl install --set profile=default \
  --set cni.enabled=true \
  --set cni.components.cni.namespace=kube-system \
  --set cni.logLevel=info
```

#### 4.2.2 通过 Helm 安装

```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

helm install istio-cni istio/istio-cni \
  --namespace kube-system \
  --set enabled=true \
  --set logLevel=info \
  --set cniBinDir=/opt/cni/bin \
  --set cniNetDir=/etc/cni/net.d
```

### 4.3 核心配置参数

#### 4.3.1 环境变量（容器级配置）

| 环境变量                | 描述                          | 默认值                  |
|-------------------------|-------------------------------|-------------------------|
| `ISTIO_CNI_LOG_LEVEL`   | 日志级别（debug/info/warn/error） | `info`                  |
| `ISTIO_CNI_NET_DIR`     | CNI 配置文件目录               | `/etc/cni/net.d`        |
| `ISTIO_CNI_BIN_DIR`     | CNI 二进制文件目录             | `/opt/cni/bin`          |
| `ISTIO_CNI_CONF_NAME`   | CNI 配置文件名                 | `istio-cni.conf`        |
| `KUBERNETES_SERVICE_HOST` | Kubernetes API 地址（自动注入） | 节点环境变量获取        |
| `KUBERNETES_SERVICE_PORT` | Kubernetes API 端口（自动注入） | 节点环境变量获取        |

#### 4.3.2 Helm/istioctl 配置参数（部署级配置）

| 参数路径                          | 描述                          | 默认值                  |
|-----------------------------------|-------------------------------|-------------------------|
| `cni.enabled`                     | 是否启用 CNI 插件              | `false`                 |
| `cni.namespace`                   | CNI DaemonSet 命名空间         | `kube-system`           |
| `cni.excludeNamespaces`           | 排除 CNI 处理的命名空间列表     | `["kube-system", "istio-system"]` |
| `cni.privileged`                  | 是否启用特权容器模式           | `false`                 |
| `cni.logLevel`                    | 日志级别                      | `info`                  |

## 5. 注意事项

- **版本兼容性**：Istio CNI 版本需与 Istio 控制平面版本一致，避免版本 mismatch 导致功能异常。
- **CNI 插件顺序**：Istio CNI 需作为链式 CNI 插件的一部分运行，配置时需确保执行顺序正确。
- **节点资源限制**：CNI DaemonSet 需配置适当的 CPU/内存资源限制（参考 Istio 官方推荐值）。
- **升级注意事项**：升级 Istio 时需同步更新 CNI 插件，避免控制平面与 CNI 版本不一致。

## 6. 参考文档

- [Istio 官方文档 - CNI 插件](https://istio.io/latest/docs/setup/additional-setup/cni/)
- [Istio GitHub 仓库 - CNI 组件](https://github.com/istio/istio/tree/master/cni)

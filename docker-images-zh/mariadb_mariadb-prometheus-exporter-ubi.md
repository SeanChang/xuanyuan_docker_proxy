---
image: mariadb/mariadb-prometheus-exporter-ubi
description: "用于与MariaDB Operator配合使用的Docker镜像"
source: https://xuanyuan.cloud/zh/r/mariadb/mariadb-prometheus-exporter-ubi
canonical: https://xuanyuan.cloud/zh/r/mariadb/mariadb-prometheus-exporter-ubi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mariadb/mariadb-prometheus-exporter-ubi" title="mariadb/mariadb-prometheus-exporter-ubi Docker 镜像中文简介、标签列表与拉取命令">mariadb/mariadb-prometheus-exporter-ubi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MariaDB Operator 配套 Docker 镜像文档


## 一、镜像概述和主要用途

### 1.1 镜像概述
本镜像为 [MariaDB Operator](https://github.com/mariadb-operator/mariadb-operator) 的配套组件，旨在为 Kubernetes 环境中 MariaDB 数据库的生命周期管理提供支持。MariaDB Operator 是一个开源 Kubernetes Operator，用于自动化部署、配置、扩展、备份、恢复及监控 MariaDB 实例，本镜像作为其核心运行时或辅助组件，确保 Operator 功能的完整实现。


### 1.2 主要用途
- 支持 MariaDB Operator 在 Kubernetes 集群中的部署与运行；
- 提供 Operator 与 Kubernetes API 及 MariaDB 实例的交互能力；
- 辅助实现 MariaDB 实例的生命周期管理（如初始化、配置同步、故障转移等）。


## 二、核心功能和特性

### 2.1 核心功能
- **Kubernetes 原生集成**：遵循 Kubernetes Operator 模式，通过 CustomResourceDefinitions (CRDs) 定义 MariaDB 资源，支持声明式配置；
- **MariaDB 生命周期管理**：自动化处理 MariaDB 实例的部署、升级、扩缩容（主从复制集群、读写分离）、删除等操作；
- **配置管理**：支持自定义 MariaDB 配置参数（如 my.cnf 配置），并自动同步至运行实例；
- **高可用性支持**：集成主从复制、自动故障转移机制，保障数据库服务连续性；
- **备份与恢复**：支持定时备份、手动备份及基于备份的恢复操作，兼容多种存储后端（如 S3、PVC 等）。


### 2.2 特性
- 轻量级设计，资源占用低；
- 支持多版本 MariaDB（具体版本依赖 Operator 兼容性，参考官方文档）；
- 可配置日志级别，便于问题排查；
- 兼容主流 Kubernetes 发行版（如 EKS、GKE、AKS、Minikube 等）。


## 三、使用场景和适用范围

### 3.1 使用场景
- **企业级 MariaDB 部署**：在 Kubernetes 集群中标准化部署 MariaDB，满足高可用、可扩展需求；
- **微服务架构数据库管理**：为微服务应用提供独立或共享的 MariaDB 实例，通过 Operator 简化管理复杂度；
- **DevOps 自动化流程**：集成 CI/CD 流程，实现 MariaDB 配置、版本升级的自动化部署；
- **灾备与数据保护**：通过内置备份功能，确保数据库数据可恢复性。


### 3.2 适用范围
- 运行 Kubernetes 1.21+ 的集群环境；
- 需要自动化管理 MariaDB 实例的场景；
- 对数据库高可用性、可扩展性有明确需求的业务系统。


## 四、使用方法和配置说明

### 4.1 获取镜像
镜像可通过 Docker Hub 或 GitHub Container Registry 获取（具体地址以 MariaDB Operator 官方文档为准）：
```bash
# 示例：从 GitHub Container Registry 拉取镜像（版本号需替换为实际版本）
docker pull ***-ghcr.xuanyuan.run/mariadb-operator/mariadb-operator:v0.0.1
```


### 4.2 基本使用方法
#### 4.2.1 本地 Docker 运行（测试环境）
> 注意：MariaDB Operator 主要面向 Kubernetes 环境，本地 Docker 运行仅建议用于功能验证或开发测试。

```bash
docker run -d \
  --name mariadb-operator \
  --network host \  # 需与 Kubernetes API 通信，本地测试可使用 host 网络
  -e LOG_LEVEL=info \
  -e WATCH_NAMESPACE=default \  # 监控的 Kubernetes 命名空间，默认监控所有命名空间
  ghcr.io/mariadb-operator/mariadb-operator:v0.0.1
```


#### 4.2.2 Kubernetes 环境部署（生产推荐）
通过 Kubernetes  manifests 部署 Operator（官方推荐方式）：

1. 应用 CRDs：
```bash
kubectl apply -f https://raw.githubusercontent.com/mariadb-operator/mariadb-operator/main/deploy/crds/mariadb.mariadb.com_mariadbs.yaml
kubectl apply -f https://raw.githubusercontent.com/mariadb-operator/mariadb-operator/main/deploy/crds/mariadb.mariadb.com_mariadbbackups.yaml
# 其他 CRDs 参考官方文档
```

2. 部署 Operator：
```bash
kubectl apply -f https://raw.githubusercontent.com/mariadb-operator/mariadb-operator/main/deploy/manifests/mariadb-operator.yaml
```

3. 验证部署：
```bash
kubectl get pods -n mariadb-operator  # 确认 operator pod 运行正常
```


### 4.3 配置参数与环境变量
Operator 支持通过环境变量或 Kubernetes ConfigMap/Secret 进行配置，核心参数如下：

| 参数名               | 类型   | 描述                                                                 | 默认值           |
|----------------------|--------|----------------------------------------------------------------------|------------------|
| `LOG_LEVEL`          | string | 日志级别，可选值：debug、info、warn、error                            | info             |
| `WATCH_NAMESPACE`    | string | 监控的 Kubernetes 命名空间，多命名空间用逗号分隔，空值表示所有命名空间 | ""               |
| `LEADER_ELECTION`    | bool   | 是否启用 leader 选举（多副本部署时确保操作唯一性）                     | true             |
| `MARIADB_DEFAULT_VERSION` | string | 默认部署的 MariaDB 版本                                         | 10.11.2          |
| `METRICS_ADDR`       | string | 指标暴露地址（Prometheus 监控用）                                    | :8080            |
| `HEALTH_PROBE_ADDR`  | string | 健康检查地址                                                         | :8081            |


### 4.4 自定义 MariaDB 实例部署
通过创建 `MariaDB` 自定义资源（CR）部署 MariaDB 实例，示例：

```yaml
apiVersion: mariadb.mariadb.com/v1alpha1
kind: MariaDB
metadata:
  name: my-mariadb
  namespace: default
spec:
  replicas: 3  # 主从复制集群，1 主 2 从
  rootPasswordSecretKeyRef:
    name: mariadb-root-password
    key: password
  service:
    type: ClusterIP
  storage:
    size: 10Gi  # PVC 存储大小
  backup:
    schedule: "0 3 * * *"  # 每日凌晨 3 点备份
    storage:
      pvc:
        size: 5Gi
```

应用上述配置：
```bash
kubectl apply -f my-mariadb.yaml
```


## 五、参考链接
- MariaDB Operator 官方文档：[https://github.com/mariadb-operator/mariadb-operator](https://github.com/mariadb-operator/mariadb-operator)
- Kubernetes Operator 模式：[https://kubernetes.io/docs/concepts/extend-kubernetes/operator/](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)

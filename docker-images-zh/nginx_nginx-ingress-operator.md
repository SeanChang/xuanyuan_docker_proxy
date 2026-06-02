---
image: nginx/nginx-ingress-operator
description: "用于NGINX和NGINX Plus入口控制器的NGINX入口操作器，基于Helm图表构建。"
source: https://xuanyuan.cloud/zh/r/nginx/nginx-ingress-operator
canonical: https://xuanyuan.cloud/zh/r/nginx/nginx-ingress-operator
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nginx/nginx-ingress-operator" title="nginx/nginx-ingress-operator Docker 镜像中文简介、标签列表与拉取命令">nginx/nginx-ingress-operator 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NGINX Ingress Operator

[![项目状态: 活跃 – 项目已达到稳定可用状态，且正在积极开发中。](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
![商业支持](https://badgen.net/badge/support/commercial/green?icon=awesome)


## 镜像概述和主要用途

NGINX Ingress Operator 是一个 Kubernetes/OpenShift 组件，用于部署和管理一个或多个 [NGINX/NGINX Plus Ingress Controller](https://github.com/nginx/kubernetes-ingress)，进而处理集群中运行的应用程序的 Ingress 流量。

关于 Operator 的更多信息，请参见 [Kubernetes 文档](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)。


## 核心功能和特性

1. **版本对应管理**：通过特定版本的 Operator 可安装对应版本的 NGINX Ingress Controller，版本映射关系明确。  
2. **Helm 驱动部署**：1.0.0 及以上版本基于 [NGINX Ingress Controller Helm 图表](http://helm.nginx.com/#nginx-ingress-controller) 构建，配置与 Helm 图表完全兼容。  
3. **多实例支持**：支持在集群中部署多个 NGINX Ingress Controller 实例，满足不同流量管理需求。  
4. **NGINX Plus 兼容**：可配置部署 NGINX Plus Ingress Controller，需指定对应镜像及认证信息。  
5. **灵活配置**：支持通过自定义资源（Custom Resource）配置 Ingress Controller 的各项参数，包括 TLS、服务账户、RBAC 等。  


## 使用场景和适用范围

- **Kubernetes/OpenShift 集群 Ingress 管理**：适用于需要统一管理集群入口流量的场景，支持 HTTP/HTTPS 路由、负载均衡等。  
- **多团队/多环境隔离**：通过部署多个 Ingress Controller 实例，实现不同团队或环境的流量隔离。  
- **NGINX Plus 企业级需求**：满足对商业支持、高级负载均衡特性（如会话保持、健康检查）有需求的企业环境。  
- **版本控制与标准化**：通过 Operator 简化 Ingress Controller 的版本管理和部署标准化。  


## 版本对应关系

使用 Operator 安装特定版本的 NGINX Ingress Controller 时，需确保 Operator 版本与 Controller 版本匹配。以下是两者的版本对应关系表：

| NGINX Ingress Controller 版本 | NGINX Ingress Operator 版本 |
|------------------------------|----------------------------|
| 5.2.x                        | 3.3.1                      |
| 5.1.x                        | 3.2.3                      |
| 5.0.x                        | 3.1.0                      |
| 4.0.x                        | 3.0.1                      |
| 3.7.x                        | 2.4.2                      |
| 3.6.x                        | 2.3.2                      |
| 3.5.x                        | 2.2.2                      |
| 3.4.x                        | 2.1.2                      |
| 3.3.x                        | 2.0.2                      |
| 3.2.x                        | 1.5.2                      |
| 3.1.x                        | 1.4.2                      |
| 3.0.x                        | 1.3.1                      |
| 2.4.x                        | 1.2.1                      |
| 2.3.x                        | 1.1.0                      |
| 2.2.x                        | 1.0.0                      |
| 2.1.x                        | 0.5.1                      |
| 2.0.x                        | 0.4.0                      |
| 1.12.x                       | 0.3.0                      |
| 1.11.x                       | 0.2.0                      |
| 1.10.x                       | 0.1.0                      |
| 1.9.x                        | 0.0.7                      |
| 1.8.x                        | 0.0.6                      |
| 1.7.x                        | 0.0.4                      |
| < 1.7.0                      | 不支持                     |

> **注意**：NGINX Ingress Operator 仅支持 NGINX Ingress Controller 版本 `1.7.0` 及以上。


## 使用方法和配置说明

### 前提条件

- Kubernetes 或 OpenShift 集群（版本需兼容目标 NGINX Ingress Controller）。  
- `kubectl` 或 `oc` 命令行工具已配置集群访问权限。  
- （可选）Helm 客户端（如需手动查看/调试 Helm 图表配置）。  


### 安装步骤

#### 1. 安装 NGINX Ingress Operator

参考 [安装文档](./docs/installation.md) 完成 Operator 安装。  

> **注意**：若需使用 TransportServers 配置，需在启动 Operator **前** 创建 GlobalConfiguration 资源，详情参见 [说明](./examples/deployment-oss-min/README.md#TransportServers)。


#### 2. 准备默认服务器证书（可选）

建议用户提供自定义证书，可参考 [示例文件](https://github.com/nginx/nginx-ingress-helm-operator/blob/main/examples/default-server-secret.yaml) 创建 `default-server-secret.yaml`，并应用到集群：

```shell
kubectl apply -f default-server-secret.yaml
```


#### 3. OpenShift 环境额外配置

在 OpenShift 集群中，需创建 SCC（Security Context Constraint）资源：

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-ingress-helm-operator/main/resources/scc.yaml
```


#### 4. 部署 NGINX Ingress Controller

通过自定义资源（Custom Resource）部署 Ingress Controller，示例配置如下（基于 [示例文件](https://github.com/nginx/nginx-ingress-helm-operator/blob/main/config/samples/charts_v1alpha1_nginxingress.yaml)）：

```yaml
apiVersion: charts.nginx.org/v1alpha1
kind: NginxIngress
metadata:
  name: example-nginxingress
spec:
  # 完整配置参考 Helm 文档：https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/#configuration
  controller:
    # 默认 TLS 证书（格式：namespace/name）
    defaultTLS:
      secret: "default/default-server-secret"
    # 若使用 NGINX Plus，需开启以下配置
    nginxPlus: true
    # NGINX Plus 镜像仓库及标签
    image:
      repository: "nginx-plus-ingress"
      tag: "5.2.0"
    # （可选）镜像拉取密钥（如需访问私有仓库）
    serviceAccount:
      imagePullSecretName: "nginx-plus-pull-secret"
```

应用自定义资源：

```shell
kubectl apply -f charts_v1alpha1_nginxingress.yaml
```


### 关键配置参数说明

配置参数基于 NGINX Ingress Controller Helm 图表，详细说明参见 [Helm 配置文档](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/#configuration)。常用参数如下：

| 参数路径                          | 说明                                                                 |
|-----------------------------------|----------------------------------------------------------------------|
| `controller.defaultTLS.secret`    | 默认 TLS 证书的 Secret 名称（格式：`namespace/name`）                |
| `controller.nginxPlus`            | 是否启用 NGINX Plus（`true`/`false`）                                |
| `controller.image.repository`     | Ingress Controller 镜像仓库地址                                      |
| `controller.image.tag`            | 镜像标签（需与 Operator 版本对应，参见版本表）                        |
| `controller.serviceAccount.imagePullSecretName` | 镜像拉取密钥名称（私有仓库时需配置）                           |
| `rbac.create`                     | 是否自动创建 RBAC 资源（多实例部署同一命名空间时需设为 `false`）     |


## 多实例部署注意事项

### 1. 通用多 Ingress Controller 说明

关于在集群中运行多个 NGINX Ingress Controller 的通用信息，参见 [NGINX 文档](https://docs.nginx.com/nginx-ingress-controller/installation/running-multiple-ingress-controllers/)。


### 2. 同一命名空间多实例部署

在同一命名空间部署多个由 Operator 管理的 Ingress Controller 实例时：

- 需将 `rbac.create` 设为 `false`，并独立创建 ServiceAccount 和 ClusterRoleBinding。  
- `controller.serviceAccount.imagePullSecretName` 参数将被忽略，需在独立创建的 ServiceAccount 中配置镜像拉取密钥。  
- ClusterRoleBinding 需绑定至 `nginx-ingress-operator-nginx-ingress-admin` ClusterRole。  

示例 RBAC 配置参见 [示例文件](./resources/rbac-example.yaml)。


### 3. 共享 IngressClass 的多实例部署

在不同命名空间部署多个实例并共享 IngressClass 时：

- 需将 `controller.ingressClass.name` 设为空字符串，并独立创建 IngressClass 资源。  
- `controller.ingressClass.setAsDefaultIngress` 参数将被忽略，需在独立创建的 IngressClass 中配置默认 ingress 类。  

示例 IngressClass 配置参见 [示例文件](./resources/ingress-class.yaml)。


## 升级说明

升级 NGINX Ingress Operator 需遵循版本对应关系，详细步骤参见 [升级文档](./docs/upgrades.md)。


## 发布信息

NGINX Ingress Operator 发布在 GitHub，最新稳定版本为 [3.3.1](https://github.com/nginx/nginx-ingress-helm-operator/releases/tag/v3.3.1)。生产环境建议使用最新稳定版。  

查看所有发布版本：[GitHub Releases](https://github.com/nginx/nginx-ingress-helm-operator/releases)。


## 开发指南

### 本地运行 Operator

适用于测试或开发场景：

1. 确保已访问 Kubernetes/OpenShift 集群。  
2. 安装自定义资源定义（CRD）：

   ```shell
   make install
   ```

3. 本地运行 Operator：

   ```shell
   make run
   ```

此时 Operator 将在本地运行，并与集群通信。


## 贡献

如需贡献代码，参见 [贡献指南](./CONTRIBUTING.md)。

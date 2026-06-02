---
image: nginx/nginx-ingress
description: "NGINX和NGINX Plus入口控制器是专为Kubernetes设计的流量管理工具，主要用于管理外部HTTP/HTTPS流量进入Kubernetes集群，支持请求路由、负载均衡、SSL终止、流量控制等功能，适用于容器化应用和微服务架构，其中NGINX Plus还提供商业支持、高级监控和增强的负载均衡能力，帮助提升集群流量管理的效率与安全性。"
source: https://xuanyuan.cloud/zh/r/nginx/nginx-ingress
canonical: https://xuanyuan.cloud/zh/r/nginx/nginx-ingress
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nginx/nginx-ingress" title="nginx/nginx-ingress Docker 镜像中文简介、标签列表与拉取命令">nginx/nginx-ingress 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NGINX Ingress Controller


## 项目状态与认证

[![OpenSSFScorecard]([])]([])
[![License]([])]([])
[![Go Report Card]([])]([])
[![codecov]([])]([])
[![GitHub release (latest SemVer)]([])]([])
![GitHub go.mod Go version]([])
[![Docker Pulls]([])]([])
![Docker Image Size (latest semver)]([])
[![Artifact Hub]([])]([])
[![项目状态：活跃 – 项目已达到稳定可用状态，且正在积极开发中。]([])]([])
![商业支持]([])


## NGINX Ingress Controller 简介

本仓库提供了由 NGINX 官方团队开发的 Ingress Controller 实现，适用于 NGINX 和 NGINX Plus。


## 参与社区会议

我们重视社区反馈，欢迎您参加下次社区会议。会议中将讨论社区成员提交的 PR、问题、讨论内容及功能需求。

**Microsoft Teams 链接**：[NIC - GitHub Issues Triage]([])

**会议 ID**：`298 140 979 789`

**密码**：`jpx5TM`

**时间**：每周一（隔周一次）16:00 爱尔兰时间 / [转换为您的时区]([])

| **社区会议日期** |
| ---------------- |
| **2025-10-06**   |
| **2025-10-20**   |
| **2025-11-03**   |
| **2025-11-17**   |
| **2025-12-01**   |
| **2025-12-15**   |

您也可以加入 [NGINX 社区论坛]([]) 交流 NGINX Ingress Controller 相关内容。


## 功能概述

NGINX Ingress Controller 同时支持 NGINX 和 NGINX Plus，具备标准 Ingress 功能——基于内容的路由和 TLS/SSL 终止。

此外，通过注解（annotations）和 ConfigMap 资源，可扩展 Ingress 资源以支持更多 NGINX 和 NGINX Plus 特性。除 HTTP 外，还支持 Websocket、gRPC、TCP 和 UDP 应用的负载均衡。详情可参考 [ConfigMap 文档]() 和 [注解文档]()。

作为 Ingress 资源的替代方案，NGINX Ingress Controller 支持 VirtualServer 和 VirtualServerRoute 资源，可实现 Ingress 不支持的场景（如流量拆分、高级基于内容的路由）。详见 [VirtualServer 和 VirtualServerRoute 资源文档]()。

同时支持 TCP、UDP 和 TLS 透传（TLS Passthrough）负载均衡，详见 [TransportServer 资源文档]()。

了解 NGINX Plus 版 Ingress Controller 可参考 [此文档]()。

> **注意**  
> 本项目与 [kubernetes/ingress-nginx]([]) 仓库中的 NGINX Ingress Controller 不同。


## Ingress 与 Ingress Controller

### 什么是 Ingress？

Ingress 是 Kubernetes 的一种资源，用于为运行在 Kubernetes 上的应用配置 HTTP 负载均衡器，这些应用由一个或多个 [Service]([]) 表示。此类负载均衡器是将应用暴露给集群外客户端的必要组件。

Ingress 资源支持以下特性：
- **基于内容的路由**：
  - *基于主机的路由*：例如，将主机头为 `foo.example.com` 的请求路由到一组服务，将 `bar.example.com` 的请求路由到另一组服务。
  - *基于路径的路由*：例如，将 URI 以 `/serviceA` 开头的请求路由到服务 A，以 `/serviceB` 开头的请求路由到服务 B。
- **TLS/SSL 终止**：为每个主机名（如 `foo.example.com`）配置 TLS/SSL 终止。

更多 Ingress 资源信息可参考 [Ingress 用户指南]([])。

### 什么是 Ingress Controller？

Ingress Controller 是运行在集群中的应用，根据 Ingress 资源配置 HTTP 负载均衡器。负载均衡器可以是集群内的软件负载均衡器，也可以是外部的硬件或云负载均衡器。不同的负载均衡器需要不同的 Ingress Controller 实现。

对于 NGINX，Ingress Controller 与负载均衡器一同部署在 Pod 中。


## 快速开始

> **注意**  
> 所有文档仅适用于最新稳定版本，具体版本信息见 GitHub 仓库的 [发布页面]([])。

1. 使用 [Helm 图表]() 或 Kubernetes [清单]() 安装 NGINX Ingress Controller。
2. 为简单 Web 应用配置负载均衡：
   - 使用 Ingress 资源：参考 [Cafe 示例]([])。
   - 或使用 VirtualServer 资源：参考 [基础配置示例]([])。
3. 查看更多配置 [示例]([])。
4. 详细配置与自定义说明见 [文档]()。


## 版本发布

NGINX Ingress Controller 在 GitHub 上发布版本，详见 [发布页面]([])。

最新稳定版本为 [5.2.0]([])，生产环境建议使用最新稳定版。

边缘版本（edge）适用于测试未发布到稳定版的新特性，基于 main 分支的 [最新提交]([]) 构建。

使用 NGINX Ingress Controller 需获取以下资源，且版本需匹配：
- NGINX Ingress Controller 镜像
- 安装清单或 Helm 图表
- 文档和示例

下表总结了各版本的镜像、Helm 图表、清单、文档和示例信息及链接：

| 版本          | 说明                     | NGINX 镜像                                                                                                                               | NGINX Plus 镜像                                                                                                                            | 安装清单和 Helm 图表                                                                              | 文档和示例                                                                                             |
|---------------|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| 最新稳定版    | 适用于生产环境           | 从 [DockerHub]([])、[GitHub Container]([])、[Amazon ECR Public Gallery]([]) 或 [Quay.io]([]) 获取 5.2.0 镜像，或 [自行构建]() | 从 [F5 容器仓库]() 获取 5.2.0 镜像，或 [自行构建]() | [清单]([])、[Helm 图表]([]) | [文档]()、[示例]() |
| 边缘/夜间版   | 适用于测试和实验         | 从上述仓库获取 edge 或 nightly 镜像，或 [自行构建]()                                                              | [自行构建]()                                                                 | [清单]([])、[Helm 图表]([]) | [文档]()、[示例]([]) |


## 软件物料清单（SBOM）

我们为二进制文件和 Docker 镜像生成 SBOM。

### 二进制文件

二进制文件的 SBOM 可在发布页面获取，使用 [syft]([]) 生成，格式为 SPDX。

### Docker 镜像

Docker 镜像的 SBOM 存储在 [DockerHub]([])、[GitHub Container]([])、[Amazon ECR Public Gallery]([]) 或 [Quay.io]([]) 仓库中，作为镜像清单的证明文件（attestation），使用 [syft]([]) 生成。

例如，从 Docker Hub 获取 `linux/amd64` 架构的 SBOM 并使用 [grype]([]) 分析，可执行以下命令：

```console
docker buildx imagetools inspect nginx/nginx-ingress:edge --format '{{ json (index .SBOM "linux/amd64").SPDX }}' | grype
```


## 联系我们

欢迎反馈！如有建议或遇到问题，请在 GitHub 上创建 issue 或提交 pull request。


## 贡献

如需贡献代码，请阅读 [贡献指南](CONTRIBUTING.md)。


## 支持

NGINX Plus 客户使用 NGINX Ingress Controller（配合 NGINX Plus）时，可享受商业支持服务。</think># NGINX Ingress Controller


## 项目状态与认证

[![OpenSSFScorecard]([])]([])
[![License]([])]([])
[![Go Report Card]([])]([])
[![codecov]([])]([])
[![GitHub release (latest SemVer)]([])]([])
![GitHub go.mod Go version]([])
[![Docker Pulls]([])]([])
![Docker Image Size (latest semver)]([])
[![Artifact Hub]([])]([])
[![项目状态：活跃 – 项目已达到稳定可用状态，且正在积极开发中。]([])]([])
![商业支持]([])


## 简介

本仓库提供由 NGINX 官方团队开发的 Ingress Controller 实现，适用于 NGINX 和 NGINX Plus。


## 参与社区会议

我们重视社区反馈，欢迎参与社区会议。会议将讨论社区 PR、问题、功能需求等内容：

- **Microsoft Teams 链接**：[NIC - GitHub Issues Triage]([])  
- **会议 ID**：`298 140 979 789`  
- **密码**：`jpx5TM`  
- **时间**：每周一（隔周一次）16:00 爱尔兰时间，可 [转换为本地时区]([])  

| 近期会议日期 |
|--------------|
| 2025-10-06   |
| 2025-10-20   |
| 2025-11-03   |
| 2025-11-17   |
| 2025-12-01   |
| 2025-12-15   |

也可通过 [NGINX 社区论坛]([]) 参与交流。


## 核心功能

### 基础能力
- 支持 NGINX 与 NGINX Plus，提供标准 Ingress 功能：基于内容的路由、TLS/SSL 终止。
- 通过注解（Annotations）和 ConfigMap 扩展功能，支持 Websocket、gRPC、TCP、UDP 负载均衡。

### 扩展资源
- **VirtualServer/VirtualServerRoute**：实现流量拆分、高级路由（Ingress 不支持场景），详见 [文档]()。  
- **TransportServer**：支持 TCP、UDP 和 TLS 透传负载均衡，详见 [

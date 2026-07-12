---
image: infrahq/infra
description: "Infra是一款基础设施访问管理工具，支持Kubernetes等资源，通过单个命令实现发现与访问，集成Okta、Google、Azure AD等身份提供商，避免凭证不同步，提供细粒度访问控制和API优先设计，简化基础设施访问管理。"
source: https://xuanyuan.cloud/zh/r/infrahq/infra
canonical: https://xuanyuan.cloud/zh/r/infrahq/infra
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/infrahq/infra" title="infrahq/infra Docker 镜像中文简介、标签列表与拉取命令">infrahq/infra 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Infra 镜像文档

## 镜像概述

Infra是一款基础设施访问管理工具，主要用于集中管理对Kubernetes等基础设施的访问权限。通过统一的身份验证和授权机制，简化用户对各类基础设施资源的访问流程，同时提供细粒度的权限控制和审计能力（即将推出）。

## 核心功能与特性

- **便捷访问**：通过单一命令`infra login`发现并访问基础设施
- **凭证同步**：消除用户凭证（如Kubeconfig）不同步问题
- **身份集成**：支持Okta、Google、Azure AD等身份提供商，简化用户入离职流程
- **细粒度控制**：针对特定资源的精细化访问权限，与现有RBAC规则兼容
- **API优先设计**：支持通过代码或现有工具管理访问权限
- **临时访问**：即将支持与PagerDuty等系统集成的临时访问协调功能
- **审计日志**：即将支持谁在何时执行了什么操作的审计日志，满足合规需求

## 使用场景与适用范围

- 多团队共享Kubernetes集群的企业环境
- 需要集中管理基础设施访问权限的组织
- 依赖Okta、Google或Azure AD进行身份管理的企业
- 希望简化基础设施访问流程并提高安全性的团队
- 需要满足合规审计要求的组织

## 安装与使用方法

### 前提条件

- Kubernetes集群环境
- Helm包管理工具

### 安装步骤

1. 添加Infra Helm仓库：
```bash
helm repo add infrahq https://helm.infrahq.com
helm repo update
```

2. 安装Infra：
```bash
helm install infra infrahq/infra
```

3. 获取暴露的主机名：
```bash
kubectl get service infra-server -o jsonpath="{.status.loadBalancer.ingress[*]['ip', 'hostname']}" -w
```

4. 在浏览器中打开获取到的主机名开始使用

## 连接器支持状态

| 连接器类型          | 状态        | 文档                                                         |
|-------------------|-------------|------------------------------------------------------------|
| Kubernetes         | ✅ 稳定     | [开始使用](https://infrahq.com/docs/connectors/kubernetes) |
| Postgres           | 即将推出    | 即将推出                                                    |
| SSH                | 即将推出    | 即将推出                                                    |
| AWS                | 即将推出    | 即将推出                                                    |
| 容器仓库           | 即将推出    | 即将推出                                                    |
| MongoDB            | 即将推出    | 即将推出                                                    |
| Snowflake          | 即将推出    | 即将推出                                                    |
| MySQL              | 即将推出    | 即将推出                                                    |
| RDP                | 即将推出    | 即将推出                                                    |

## 相关文档

- [通过Infra CLI登录](https://infrahq.com/docs/configuration/logging-in)
- [Helm Chart参考](https://infrahq.com/docs/reference/helm-reference)
- [什么是Infra？](https://infrahq.com/docs/getting-started/what-is-infra)
- [架构](https://infrahq.com/docs/reference/architecture)
- [安全性](https://infrahq.com/docs/reference/security)

## 社区支持

- [社区论坛](https://github.com/infrahq/infra/discussions)：适合获取构建帮助、讨论基础设施访问最佳实践
- [GitHub Issues](https://github.com/infrahq/infra/issues)：适合报告使用Infra时遇到的错误和问题

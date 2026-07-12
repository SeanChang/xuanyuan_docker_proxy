---
image: jb5r/gangway
description: "这是从heptiolabs/gangway分叉的镜像，用于为Kubernetes集群提供OIDC认证流程，帮助用户安全获取ID令牌并配置kubectl，实现集群身份验证。"
source: https://xuanyuan.cloud/zh/r/jb5r/gangway
canonical: https://xuanyuan.cloud/zh/r/jb5r/gangway
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jb5r/gangway" title="jb5r/gangway Docker 镜像中文简介、标签列表与拉取命令">jb5r/gangway 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# gangway镜像说明

## 镜像概述
本镜像基于heptiolabs/gangway分叉，是一款用于Kubernetes集群的OIDC认证工具，帮助用户通过OIDC协议完成身份验证，快速配置kubectl以访问集群，无需直接暴露凭据给应用。

## 核心功能
1. 支持OIDC认证流程：与上游身份服务对接，引导用户完成登录，获取合法ID令牌。
2. 安全凭据管理：用户凭据不直接传递给Gangway，保障身份信息安全。
3. kubectl配置指导：认证完成后提供清晰的kubectl配置步骤，简化用户操作。

## 使用场景
- 企业Kubernetes集群需要统一身份管理的场景。
- 团队成员需要通过OIDC（如Auth0、Keycloak等）访问集群的场景。
- 希望简化kubectl身份配置流程的开发/运维团队。

## 配置说明
### Kubernetes API Server要求
需在API Server中开启OIDC相关参数：
```bash
kube-apiserver \
  --oidc-issuer-url="https://your-oidc-issuer.com/" \
  --oidc-client-id="your-client-id" \
  --oidc-username-claim=email \
  --oidc-groups-claim=groups
```

### 镜像部署示例
```bash
docker run -d --name gangway \
  -p 8080:8080 \
  -e OIDC_ISSUER_URL="https://your-oidc-issuer.com" \
  -e OIDC_CLIENT_ID="your-client-id" \
  -e OIDC_CLIENT_SECRET="your-client-secret" \
  -e KUBERNETES_API_SERVER="https://your-k8s-api-server" \
  docker.xuanyuan.run/jb5r/gangway
```
访问`http://localhost:8080`即可开始OIDC认证流程。

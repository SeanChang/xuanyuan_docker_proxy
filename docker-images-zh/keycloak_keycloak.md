---
image: keycloak/keycloak
description: "开源身份与访问管理工具，可轻松为应用添加认证并保护服务，无需处理用户存储或用户认证。"
source: https://xuanyuan.cloud/zh/r/keycloak/keycloak
canonical: https://xuanyuan.cloud/zh/r/keycloak/keycloak
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/keycloak/keycloak" title="keycloak/keycloak Docker 镜像中文简介、标签列表与拉取命令">keycloak/keycloak 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Keycloak 镜像文档

## 镜像概述和主要用途

Keycloak 是一款开源身份与访问管理（IAM）解决方案，旨在帮助开发者以最小工作量为应用程序添加认证功能并保护服务，无需自行处理用户存储或用户认证逻辑。它提供完整的身份管理生态，简化应用安全集成流程。

## 核心功能和特性

- **用户联合**：支持与LDAP、Active Directory等身份源集成，实现用户数据统一管理
- **强认证机制**：提供多因素认证（MFA）、OTP、WebAuthn等安全认证方式
- **用户生命周期管理**：包含用户注册、角色分配、配置文件管理等功能
- **细粒度授权**：基于角色（RBAC）、属性（ABAC）等模型实现资源访问控制
- **标准协议支持**：兼容OAuth 2.0、OpenID Connect、SAML等主流安全协议

## 使用场景和适用范围

适用于需要身份验证与授权的各类场景：
- 企业级应用的统一身份认证系统
- Web应用、移动应用及API服务的访问保护
- 多系统单点登录（SSO）实现
- 需要强安全合规性的业务系统（如金融、医疗领域）

## 使用方法和配置说明

### 快速启动（开发环境）

通过以下命令可快速启动Keycloak开发实例：

```bash
docker run -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  quay.io/keycloak/keycloak:latest start-dev
```

**参数说明**：
- `-p 8080:8080`：映射容器端口至主机，用于访问管理界面
- `-e KEYCLOAK_ADMIN`：设置管理员用户名（示例为`admin`）
- `-e KEYCLOAK_ADMIN_PASSWORD`：设置管理员密码（示例为`admin`，生产环境需使用强密码）
- `start-dev`：启动开发模式，自动初始化管理员账号

启动后访问 `http://localhost:8080`，使用管理员账号登录即可进入管理控制台。

### 生产环境部署建议

生产环境需注意以下配置要点：
1. **启用HTTPS**：配置TLS证书确保通信加密
2. **外部数据库**：使用PostgreSQL/MySQL等外部数据库存储数据
3. **持久化存储**：挂载数据卷保存配置与状态信息
4. **资源限制**：根据负载配置CPU/内存资源

详细部署指南可参考[Keycloak官方Docker文档](https://www.keycloak.org/getting-started/getting-started-docker)。

## 核心能力扩展

Keycloak支持通过插件扩展功能，包括自定义认证流程、身份提供商集成、主题定制等，满足复杂业务场景需求。其活跃的社区生态提供丰富的文档和第三方扩展资源。

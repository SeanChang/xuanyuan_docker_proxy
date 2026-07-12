---
image: cleanstart/openldap
description: "企业级OpenLDAP服务器容器，基于CleanStart安全加固的最小化OS构建，提供TLS加密、高级访问控制和数据持久化，支持集中式身份认证、目录服务管理及SSO集成。"
source: https://xuanyuan.cloud/zh/r/cleanstart/openldap
canonical: https://xuanyuan.cloud/zh/r/cleanstart/openldap
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cleanstart/openldap" title="cleanstart/openldap Docker 镜像中文简介、标签列表与拉取命令">cleanstart/openldap 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CleanStart OpenLDAP 容器镜像

## 镜像概述

CleanStart OpenLDAP容器提供安全、企业级的OpenLDAP服务器部署，基于CleanStart安全加固的最小化操作系统构建。该镜像包含OpenLDAP服务器（slapd）、客户端工具及必要实用程序，配置遵循安全最佳实践，支持TLS加密、访问控制和数据持久化，适用于企业级目录服务场景。

📌 **CleanStart基础**：专为企业容器环境设计的安全加固、最小化基础操作系统。

## 核心功能与特性

- LDAP v3协议支持，集成TLS/SSL加密
- 高级访问控制与认证机制
- 灵活的模式管理和复制支持
- 企业级安全特性，符合FIPS合规要求

## 使用场景与适用范围

- 集中式用户认证与授权
- 企业目录服务管理
- 单点登录（SSO）集成
- 身份与访问管理（IAM）解决方案

## 使用方法与配置说明

### 快速开始

#### 拉取最新镜像

从镜像仓库下载容器镜像：

```bash
docker pull docker.xuanyuan.run/cleanstart/openldap:latest
docker pull docker.xuanyuan.run/cleanstart/openldap:latest-dev
```

#### 基本运行

使用基础配置运行容器：

```bash
docker run -d --name openldap-test -p 389:389 -p 636:636 docker.xuanyuan.run/cleanstart/openldap:latest
```

#### 生产环境部署

使用生产级安全设置部署：

```bash
docker run -d --name openldap-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  -p 389:389 -p 636:636 \
  -v ldap-data:/var/lib/ldap \
  -v ldap-config:/etc/ldap/slapd.d \
  docker.xuanyuan.run/cleanstart/openldap:latest
```

#### 卷挂载

挂载本地目录实现数据持久化：

```bash
docker run -v $(pwd)/ldap-data:/var/lib/ldap -v $(pwd)/ldap-config:/etc/ldap/slapd.d docker.xuanyuan.run/cleanstart/openldap:latest
```

#### 端口转发

自定义端口映射运行：

```bash
docker run -p 1389:389 -p 1636:636 docker.xuanyuan.run/cleanstart/openldap:latest
```

### 配置参数

#### 环境变量

| 变量名               | 默认值                                          | 描述                     |
|----------------------|-------------------------------------------------|--------------------------|
| PATH                 | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | 系统PATH配置             |
| LDAP_ORGANISATION    | Example Inc                                     | LDAP目录的组织名称       |
| LDAP_DOMAIN          | example.org                                     | LDAP域名                 |
| LDAP_ADMIN_PASSWORD  |                                                 | LDAP目录的管理员密码     |

## 安全与最佳实践

### 推荐安全上下文

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop: ['ALL']
```

### 最佳实践

- 生产环境使用特定镜像标签（避免使用latest）
- 配置资源限制：内存和CPU约束
- 尽可能启用只读根文件系统
- 使用非root用户运行容器（--user 1000:1000）
- 添加--security-opt=no-new-privileges标志
- 定期更新容器镜像以获取安全补丁
- 实施适当的网络分段
- 监控容器指标以检测异常

## 架构支持

### 多平台镜像

```bash
docker pull --platform linux/amd64 cleanstart/openldap:latest
docker pull --platform linux/arm64 cleanstart/openldap:latest
```

## 资源与文档

- **CleanStart官网**：[https://www.cleanstart.com](https://www.cleanstart.com)
- **OpenLDAP文档**：[https://www.openldap.org/doc/](https://www.openldap.org/doc/)
- **CleanStart社区镜像**：[https://hub.docker.com/u/cleanstart](https://hub.docker.com/u/cleanstart)
- **CleanStart镜像使用指南与示例项目**：[https://github.com/cleanstart-dev/cleanstart-containers](https://github.com/cleanstart-dev/cleanstart-containers)
  - 使用Dockerfile运行示例项目
  - 通过Kubernetes YAML部署
  - 从公共镜像迁移至CleanStart镜像

---

## 漏洞免责声明

CleanStart提供的Docker镜像包含由独立贡献者维护的第三方开源库和软件包。尽管CleanStart维护这些镜像并应用行业标准安全实践，但无法保证超出其控制范围的上游组件的安全性或完整性。

用户确认并同意，开源软件可能包含未发现的漏洞，或通过更新引入新风险。对于源自第三方库的安全问题，包括但不限于零日漏洞、供应链攻击或贡献者引入的风险，CleanStart不承担责任。

安全是共同责任：CleanStart会在可能的情况下提供更新的镜像和指导，而用户负责评估部署并实施适当的控制措施。

---
image: hashicorp/vault
description: "HashiCorp Vault官方Docker镜像，用于在容器环境中安全存储、访问和管理机密信息，提供官方认证的部署方案。"
source: https://xuanyuan.cloud/zh/r/hashicorp/vault
canonical: https://xuanyuan.cloud/zh/r/hashicorp/vault
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/vault" title="hashicorp/vault Docker 镜像中文简介、标签列表与拉取命令">hashicorp/vault — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/hashicorp/vault" title="hashicorp/vault Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/hashicorp/vault</a>

# Vault Docker 镜像文档

## 镜像概述和主要用途

Vault 是一个用于安全访问密钥的工具。密钥指任何需要严格控制访问的信息，如 API 密钥、密码、证书等。Vault 提供统一的密钥访问接口，同时具备严格的访问控制和详细的审计日志功能。本镜像为官方 Vault 容器化部署方案，基于轻量级 Alpine 系统构建，适用于开发环境和生产环境的容器化部署。

## 核心功能和特性

- **统一密钥管理**：提供单一接口管理各类密钥（API 密钥、密码、证书等），简化密钥生命周期管理。
- **严格访问控制**：通过细粒度的策略控制密钥访问权限，确保敏感信息仅被授权实体访问。
- **审计日志**：记录所有密钥访问和操作行为，支持持久化审计日志存储。
- **轻量级基础镜像**：基于 Alpine 构建，减少攻击面，适合安全敏感场景。
- **进程管理**：集成 `dumb-init` 处理僵尸进程并转发信号，确保容器内进程稳定运行。
- **灵活配置**：支持通过配置目录挂载或环境变量注入配置，适配不同部署需求。
- **持久化支持**：提供日志和数据存储的持久化卷，支持审计日志和密钥数据持久化。
- **内存锁定**：默认尝试锁定内存，防止敏感数据被交换到磁盘，增强安全性。

## 使用场景和适用范围

### 开发环境
- **快速测试**：通过开发模式（`dev` server）运行完全基于内存的 Vault 服务器，无需持久化配置，适合本地开发和功能验证。
- **临时密钥管理**：用于开发过程中临时存储和访问测试密钥，避免硬编码敏感信息。

### 生产环境注意事项
- **不建议直接使用默认配置**：开发模式的内存存储和无 TLS 配置不适合生产，需通过配置启用持久化存储（如 `file` 存储后端）和 TLS 加密。
- **需配合编排工具**：推荐在 Kubernetes、OpenShift 等容器编排平台部署，以确保高可用性和可扩展性。
- **安全加固**：必须启用内存锁定（`--cap-add=IPC_LOCK`）、配置持久化审计日志，并使用生产级存储后端（如 Consul、Raft）替代 `file` 后端。

## 详细的使用方法和配置说明

### 容器基础信息

#### 持久化卷（VOLUME）
容器提供两个可选卷用于持久化数据：
- `/vault/logs`：用于存储持久化审计日志。默认无数据写入，需手动启用 `file` 审计后端并配置路径至此目录。
- `/vault/file`：用于 `file` 数据存储插件的持久化数据。默认无数据写入（`dev` 服务器使用内存存储），需在启动前配置 `file` 存储后端。

#### 配置目录
容器默认配置目录为 `/vault/config`，支持两种配置方式：
- **目录挂载**：通过 `-v` 挂载包含 HCL/JSON 配置文件的目录至 `/vault/config`，Vault 会自动加载所有配置文件。
- **环境变量注入**：通过 `VAULT_LOCAL_CONFIG` 环境变量传入 JSON 格式配置，容器会将其写入 `/vault/config/local.json` 并加载。

### 内存锁定与 `setcap`

#### 内存锁定（必需配置）
Vault 需锁定内存以防止敏感数据交换到磁盘，因此启动容器时必须添加 `--cap-add=IPC_LOCK` 权限。例如：
```console
$ docker run --cap-add=IPC_LOCK ... hashicorp/vault
```

#### `setcap` 问题处理
由于 Vault 二进制以非 root 用户运行，容器通过 `setcap` 赋予二进制内存锁定权限。部分 Docker 存储插件（如 AUFS）或 Linux 发行版可能导致 `setcap` 调用失败，此时可通过设置环境变量 `SKIP_SETCAP` 为任意非空值禁用内存锁定：
```console
$ docker run --cap-add=IPC_LOCK -e SKIP_SETCAP=1 ... hashicorp/vault
```

### 开发模式运行

开发模式启动完全基于内存的 Vault 服务器，适合开发测试，**禁止用于生产**。

#### 基本命令
```console
$ docker run --cap-add=IPC_LOCK -d --name=dev-vault hashicorp/vault
```

#### 开发模式环境变量
- `VAULT_DEV_ROOT_TOKEN_ID`：设置初始 root 令牌 ID（默认自动生成）。
- `VAULT_DEV_LISTEN_ADDRESS`：设置开发服务器监听地址（默认 `0.0.0.0:8200`）。

#### 示例：自定义 root 令牌和监听地址
```console
$ docker run --cap-add=IPC_LOCK -d \
  -e VAULT_DEV_ROOT_TOKEN_ID=myroot \
  -e VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:1234 \
  --name=dev-vault hashicorp/vault
```

### 服务器模式运行

服务器模式需手动配置存储后端和网络，适合需要持久化或多节点部署的场景（开发阶段使用，生产需进一步加固）。

#### 基本配置示例
以下命令启动启用 `file` 存储后端、禁用 TLS（仅开发用）的 Vault 服务器：
```console
$ docker run --cap-add=IPC_LOCK -p 8200:8200 \
  -e 'VAULT_LOCAL_CONFIG={"storage": {"file": {"path": "/vault/file"}}, "listener": [{"tcp": {"address": "0.0.0.0:8200", "tls_disable": true}}], "default_lease_ttl": "168h", "max_lease_ttl": "720h", "ui": true}' \
  hashicorp/vault server
```
- `storage.file.path: "/vault/file"`：启用 `file` 存储后端，数据持久化至 `/vault/file` 卷。
- `listener.tcp.tls_disable: true`：禁用 TLS（生产环境必须启用 TLS）。
- `default_lease_ttl`/`max_lease_ttl`：设置默认和最大密钥租约期限（168h=7天，720h=30天）。

#### 配置目录挂载示例
通过挂载本地配置目录至 `/vault/config` 加载配置文件（支持 HCL/JSON）：
```console
$ docker run --cap-add=IPC_LOCK -v ./vault-config:/vault/config \
  hashicorp/vault server
```
本地 `vault-config` 目录需包含至少一个 HCL/JSON 配置文件（如 `vault.hcl`）。

#### 集群相关环境变量
自 0.6.3 版本起，容器支持以下集群配置环境变量：
- `VAULT_REDIRECT_INTERFACE`：指定用于重定向地址的容器内网络接口（如 `eth0`），自动获取该接口的 IP 作为重定向地址。
- `VAULT_CLUSTER_INTERFACE`：指定用于集群地址的容器内网络接口，自动获取该接口的 IP 作为集群通信地址。

### 其他命令执行
容器支持直接执行 `vault` 子命令，例如查看服务器状态：
```console
$ docker run hashicorp/vault status
```

## 许可证
查看镜像中软件的 [许可证信息](https://raw.githubusercontent.com/hashicorp/vault/main/LICENSE)。

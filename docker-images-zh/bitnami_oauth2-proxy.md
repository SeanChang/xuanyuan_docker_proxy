---
image: bitnami/oauth2-proxy
description: "Bitnami oauth2-proxy安全镜像，提供基于OAuth2协议的认证代理功能，用于保护Web应用访问安全，支持通过第三方OAuth2提供商验证用户身份并控制访问权限。"
source: https://xuanyuan.cloud/zh/r/bitnami/oauth2-proxy
canonical: https://xuanyuan.cloud/zh/r/bitnami/oauth2-proxy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/oauth2-proxy" title="bitnami/oauth2-proxy Docker 镜像中文简介、标签列表与拉取命令">bitnami/oauth2-proxy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami OAuth2 Proxy 镜像文档


## 镜像概述和主要用途

OAuth2 Proxy 是一款反向代理和静态文件服务器，通过 OAuth2 身份提供商（如 Google、GitHub 等）验证用户身份，支持基于邮箱、域名或用户组的访问控制。Bitnami 提供的该镜像基于安全加固理念构建，适用于为内部应用、API 服务或静态资源提供身份验证保护。


## 核心功能和特性

- **多身份提供商支持**：兼容 Google、GitHub、Azure、GitLab 等主流 OAuth2/OIDC 提供商。
- **细粒度访问控制**：可通过邮箱地址、域名或用户组限制访问权限。
- **安全加固**：采用非 root 用户运行容器，减少攻击面；基于 Photon Linux 构建，最小化系统组件。
- **灵活配置方式**：支持通过配置文件、命令行参数或环境变量进行配置。
- **FIPS 合规性**：Bitnami Secure Images 版本支持 FIPS 模式配置，满足安全合规需求。
- **可观测性**：日志输出至标准输出流（stdout），便于集成日志收集工具。


## 使用场景和适用范围

- **内部应用保护**：为未内置身份验证的内部系统（如仪表盘、管理后台）添加 OAuth2 认证层。
- **API 访问控制**：作为 API 网关前置组件，验证客户端身份后转发请求至上游服务。
- **单点登录（SSO）**：为多应用环境提供统一的 OAuth2 身份验证入口。
- **安全合规场景**：需满足 FIPS 140-2/3 标准的金融、政府等行业应用部署。


## 快速开始

### 基本运行命令

```bash
docker run --name oauth2-proxy docker.xuanyuan.run/bitnami/oauth2-proxy:latest
```


## 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级公共镜像目录，推出 **Bitnami Secure Images** 计划，聚焦安全加固镜像：

- **社区版变更**：免费 tier 将仅提供安全加固的 "latest" 标签镜像（用于开发），非加固的 Debian 基础镜像将逐步废弃。
- **镜像迁移**：现有所有镜像（含历史版本标签，如 2.50.0、10.6）将迁移至 `docker.io/bitnamilegacy` 仓库，不再更新。
- **生产环境建议**：生产 workload 需使用 Bitnami Secure Images，包含安全加固、CVE 透明度（VEX/KEV）、SBOM 和企业支持。

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 为什么选择 Bitnami Secure Images？

- **安全优化**：基于最小化 Photon Linux 构建，减少攻击面；通过 SLSA-3 合规工厂生成，包含签名、SBOM 和病毒扫描报告。
- **漏洞响应**：支持 VEX/KEV 标准，提供 CVE 可利用性透明化；上游补丁发布后数小时内更新镜像。
- **一致性体验**：容器、虚拟机和云镜像使用相同组件和配置逻辑，便于跨环境迁移。
- **FIPS 支持**：部分镜像提供 FIPS 模式配置，满足合规需求。


## 获取镜像

### 拉取预构建镜像

推荐从 Docker Hub 拉取最新版：

```bash
docker pull docker.xuanyuan.run/bitnami/oauth2-proxy:latest
```

指定版本（需注意 2025 年 8 月后历史版本迁移至 `bitnamilegacy` 仓库）：

```bash
docker pull docker.xuanyuan.run/bitnami/oauth2-proxy:[TAG]  # 例如：2.50.0
```

### 本地构建镜像

```bash
git clone https://github.com/bitnami/containers.git
cd bitnami/oauth2-proxy/[VERSION]/[OS]  # 替换为具体版本和操作系统
docker build -t bitnami/oauth2-proxy:latest .
```


## 部署方案

### Docker Compose 示例

创建 `docker-compose.yml`：

```yaml
version: '3'
services:
  oauth2-proxy:
    image: docker.xuanyuan.run/bitnami/oauth2-proxy:latest
    container_name: oauth2-proxy
    ports:
      - "4180:4180"  # 默认监听端口
    environment:
      - OAUTH2_PROXY_PROVIDER=github  # 身份提供商（github/google/azure等）
      - OAUTH2_PROXY_CLIENT_ID=your_github_client_id  # OAuth应用客户端ID
      - OAUTH2_PROXY_CLIENT_SECRET=your_github_client_secret  # OAuth应用密钥
      - OAUTH2_PROXY_REDIRECT_URL=http://localhost:4180/oauth2/callback  # 回调URL
      - OAUTH2_PROXY_UPSTREAMS=http://upstream-service:8080  # 上游服务地址
      - OAUTH2_PROXY_EMAIL_DOMAINS=*  # 允许所有域名邮箱（或指定域名如example.com）
      - OAUTH2_PROXY_LISTEN_ADDRESS=0.0.0.0:4180  # 监听地址
      - OPENSSL_FIPS=yes  # 启用FIPS模式（仅Secure Images支持）
    networks:
      - oauth2-network

  upstream-service:  # 示例上游服务（如需要保护的应用）
    image: docker.xuanyuan.run/nginx:alpine
    networks:
      - oauth2-network

networks:
  oauth2-network:
    driver: bridge
```

启动服务：

```bash
docker-compose up -d
```


## 网络配置

### 容器互联

通过 Docker 网络实现 OAuth2 Proxy 与上游服务通信：

1. 创建自定义网络：

```bash
docker network create oauth2-proxy-network --driver bridge
```

2. 启动 OAuth2 Proxy 并加入网络：

```bash
docker run --name oauth2-proxy --network oauth2-proxy-network \
  -e OAUTH2_PROXY_UPSTREAMS=http://upstream-app:8080 \
  docker.xuanyuan.run/bitnami/oauth2-proxy:latest
```

3. 启动上游服务（使用相同网络）：

```bash
docker run --name upstream-app --network oauth2-proxy-network docker.xuanyuan.run/nginx:alpine
```

容器间可通过容器名（如 `upstream-app`）作为 hostname 通信。


## 配置说明

### 配置方式

OAuth2 Proxy 支持三种配置方式（优先级：命令行参数 > 环境变量 > 配置文件）：

1. **配置文件**：挂载配置文件至容器，通过 `--config` 指定路径：

```bash
docker run --name oauth2-proxy -v /local/config.cfg:/etc/oauth2-proxy/config.cfg \
  docker.xuanyuan.run/bitnami/oauth2-proxy:latest --config=/etc/oauth2-proxy/config.cfg
```

2. **命令行参数**：直接在运行命令中添加，如 `--provider=github --client-id=xxx`。

3. **环境变量**：通过 `-e` 指定，环境变量名需添加 `OAUTH2_PROXY_` 前缀，如 `OAUTH2_PROXY_PROVIDER=github`。

### 核心环境变量

| 环境变量                  | 描述                                  | 示例值                          |
|---------------------------|---------------------------------------|---------------------------------|
| `OAUTH2_PROXY_PROVIDER`   | 身份提供商类型                        | `github`、`google`、`azure`     |
| `OAUTH2_PROXY_CLIENT_ID`   | OAuth应用客户端ID                     | `abcd1234`                      |
| `OAUTH2_PROXY_CLIENT_SECRET` | OAuth应用客户端密钥                  | `secret123`                     |
| `OAUTH2_PROXY_REDIRECT_URL` | 认证回调URL                          | `http://localhost:4180/oauth2/callback` |
| `OAUTH2_PROXY_UPSTREAMS`   | 上游服务地址（多个用逗号分隔）        | `http://app1:80,http://app2:8080` |
| `OAUTH2_PROXY_EMAIL_DOMAINS` | 允许访问的邮箱域名（`*`表示所有）    | `example.com,company.org`       |
| `OAUTH2_PROXY_LISTEN_ADDRESS` | 监听地址和端口                      | `0.0.0.0:4180`                  |
| `OAUTH2_PROXY_COOKIE_SECRET` | 加密Cookie的密钥（需16/32/64字节）   | `$(head -c 32 /dev/urandom | base64)` |

### FIPS 配置（仅 Secure Images）

通过环境变量启用/禁用 FIPS 模式：

- `OPENSSL_FIPS=yes`：启用 FIPS 模式（默认）
- `OPENSSL_FIPS=no`：禁用 FIPS 模式


## 日志管理

### 查看日志

容器日志输出至 `stdout`，通过 `docker logs` 查看：

```bash
docker logs oauth2-proxy
```

### 日志驱动配置

通过 `--log-driver` 指定日志驱动（如 `json-file`、`syslog`）：

```bash
docker run --name oauth2-proxy --log-driver=syslog docker.xuanyuan.run/bitnami/oauth2-proxy:latest
```


## 维护与升级

### 升级镜像

1. 拉取最新镜像：

```bash
docker pull docker.xuanyuan.run/bitnami/oauth2-proxy:latest
```

2. 停止并备份当前容器（如有持久化数据）：

```bash
docker stop oauth2-proxy
rsync -a /path/to/persistence /path/to/persistence.bkp.$(date +%Y%m%d-%H%M%S)  # 备份数据
```

3. 移除旧容器：

```bash
docker rm -v oauth2-proxy
```

4. 启动新容器：

```bash
docker run --name oauth2-proxy docker.xuanyuan.run/bitnami/oauth2-proxy:latest # 如需恢复数据，添加-v挂载
```


## 注意事项

- **2024年1月16日起**：官方移除了 `docker-compose.yaml` 文件（原用于内部测试），生产环境建议手动编写配置。
- **非root容器**：默认以非root用户（UID 1001）运行，挂载宿主机目录时需确保权限正确（如 `chown -R 1001:1001 /local/path`）。
- **敏感信息保护**：客户端密钥、Cookie密钥等敏感信息建议通过环境变量注入或配置文件加密，避免明文暴露。


## 贡献与问题反馈

- **贡献**：通过 [GitHub PR](https://github.com/bitnami/containers/pulls) 提交改进。
- **问题反馈**：提交 [GitHub Issue](https://github.com/bitnami/containers/issues)，需包含宿主机OS、Docker版本、容器日志等信息。


## 许可证

Copyright © 2025 Broadcom. 基于 Apache License 2.0 许可。详情参见 [LICENSE](http://www.apache.org/licenses/LICENSE-2.0)。

> **商标说明**：本镜像由 Bitnami 打包，相关商标归各自所有者所有，使用不代表关联或背书。

---
image: authelia/authelia
description: "云就绪的多因素认证门户，用于为应用提供安全认证服务。"
source: https://xuanyuan.cloud/zh/r/authelia/authelia
canonical: https://xuanyuan.cloud/zh/r/authelia/authelia
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/authelia/authelia" title="authelia/authelia Docker 镜像中文简介、标签列表与拉取命令">authelia/authelia 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Authelia Docker镜像文档

## 镜像概述和主要用途

Authelia是一个开源认证和授权服务器，通过Web门户为应用程序提供双因素认证和单点登录(SSO)功能。它作为[反向代理](#代理支持)的配套工具，允许、拒绝或重定向请求。

![Authelia架构图](https://www.authelia.com/images/archi.png)

Authelia可作为独立服务安装，也可通过Docker或Kubernetes作为容器部署，为各类应用提供集中式身份验证和授权控制。

## 核心功能和特性

### 认证与授权

- **OpenID Connect 1.0 / OAuth 2.0**：通过OpenID认证认证，符合Basic OP / Implicit OP / Hybrid OP / Form Post OP / Config OP配置文件标准
- **多种第二因素认证方法**：
  - **安全密钥**：支持FIDO2 WebAuthn的设备（如YubiKey）
  - **基于时间的一次性密码(TOTP)**：兼容认证器应用
  - **移动推送通知**：与Duo集成
- **无密码认证**：通过WebAuthn（Passkeys）实现
- **密码重置**：通过电子邮件确认进行身份验证
- **访问限制**：多次无效认证尝试后限制访问

### 访问控制

- **细粒度访问控制**：使用规则匹配子域、用户、用户组成员资格、请求URI、请求方法和网络等条件
- **每规则策略选择**：可针对不同规则选择单因素或双因素策略
- **基本认证支持**：支持受单因素策略保护的端点的基本认证

### 部署与集成

- **高可用性**：使用远程数据库和Redis作为高可用KV存储
- **反向代理兼容性**：与Traefik、Caddy、Nginx等多种反向代理兼容
- **Kubernetes支持**：
  - 兼容多种Kubernetes入口控制器和网关
  - 支持通过Helm Chart安装（测试版）

## 使用场景和适用范围

Authelia适用于需要集中式身份验证和授权控制的各种环境，包括：

- **企业内部应用**：为内部系统提供统一身份验证
- **自托管服务**：保护个人或组织自托管的Web服务
- **云环境应用**：为云部署的应用提供安全访问控制
- **开发/测试环境**：在开发阶段提供安全验证机制
- **多租户系统**：为不同用户组提供差异化访问权限

Authelia特别适合与反向代理配合使用，为多个应用程序提供统一的身份验证层，而无需修改应用程序本身。

## 详细使用方法和配置说明

### 前提条件

- Docker Engine 19.03+
- Docker Compose (可选)
- 反向代理服务器 (Nginx, Traefik, Caddy等)
- 域名和DNS配置
- TLS证书（生产环境）

### Docker部署方案

#### Docker Run命令示例

```bash
docker run -d \
  --name=authelia \
  -p 9091:9091 \
  -v /path/to/authelia/config:/config \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  docker.xuanyuan.run/authelia/authelia:latest
```

#### Docker Compose配置示例

##### Local模式（本地测试）

```yaml
version: '3.8'

services:
  authelia:
    image: docker.xuanyuan.run/authelia/authelia:latest
    container_name: authelia
    volumes:
      - ./authelia/config:/config
    ports:
      - "9091:9091"
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
    depends_on:
      - redis
      - mysql

  redis:
    image: docker.xuanyuan.run/redis:alpine
    container_name: authelia-redis
    volumes:
      - ./redis:/data
    restart: unless-stopped

  mysql:
    image: docker.xuanyuan.run/mariadb:10
    container_name: authelia-mysql
    volumes:
      - ./mysql:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_DATABASE=authelia
      - MYSQL_USER=authelia
      - MYSQL_PASSWORD=autheliapassword
    restart: unless-stopped
```

##### Lite模式（轻量级生产部署）

```yaml
version: '3.8'

services:
  authelia:
    image: docker.xuanyuan.run/authelia/authelia:latest
    container_name: authelia
    volumes:
      - ./authelia/config:/config
      - ./authelia/users:/users
    ports:
      - "9091:9091"
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
    networks:
      - authelia-network

  nginx:
    image: docker.xuanyuan.run/nginx:alpine
    container_name: authelia-nginx
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - authelia
    restart: unless-stopped
    networks:
      - authelia-network

networks:
  authelia-network:
    driver: bridge
```

### 配置说明

Authelia的主要配置文件是`configuration.yml`，位于配置目录中。以下是关键配置部分：

#### 基本配置

```yaml
server:
  host: 0.0.0.0
  port: 9091
  path: ""
  read_buffer_size: 4096
  write_buffer_size: 4096
  enable_pprof: false
  enable_expvars: false
  disable_healthcheck: false
  tls:
    key: ""
    certificate: ""
    client_certificates: []

log:
  level: info
  format: text
  file_path: ""
  keep_stdout: true
```

#### 认证配置

```yaml
authentication_backend:
  password_reset:
    enabled: true
    disable_notifier: false
    issuer: Authelia <support@example.com>
  
  file:
    path: /config/users_database.yml
    password:
      algorithm: argon2id
      iterations: 3
      key_length: 32
      memory: 65536
      parallelism: 4
      salt_length: 16
```

#### 会话配置

```yaml
session:
  name: authelia_session
  secret: unsecure_session_secret
  expiration: 3600
  inactivity: 300
  domain: example.com
  cookie:
    path: /
    secure: false
    http_only: true
    same_site: lax
    partitioned: false
```

#### 访问控制规则

```yaml
access_control:
  default_policy: deny
  rules:
    - domain: "public.example.com"
      policy: bypass
    
    - domain: "login.example.com"
      policy: one_factor
    
    - domain: "secure.example.com"
      policy: two_factor
      groups:
        - admins
    
    - domain: "singlefactor.example.com"
      policy: one_factor
```

### 环境变量

Authelia支持以下关键环境变量：

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| `TZ` | 设置时区 | `UTC` |
| `AUTHELIA_CONFIG` | 配置文件路径 | `/config/configuration.yml` |
| `AUTHELIA_SESSION_SECRET_FILE` | 会话密钥文件路径 | 无 |
| `AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE` | 存储加密密钥文件路径 | 无 |
| `AUTHELIA_JWT_SECRET_FILE` | JWT密钥文件路径 | 无 |

### 反向代理集成

#### Nginx配置示例

```nginx
location /authelia {
    internal;
    proxy_pass http://authelia:9091/api/verify;
    proxy_set_header Host $host;
    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-Uri $request_uri;
    proxy_set_header X-Forwarded-Ssl on;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
}

location / {
    auth_request /authelia;
    auth_request_set $target_url $scheme://$http_host$request_uri;
    auth_request_set $user $upstream_http_remote_user;
    auth_request_set $groups $upstream_http_remote_groups;
    auth_request_set $name $upstream_http_remote_name;
    auth_request_set $email $upstream_http_remote_email;
    
    proxy_set_header Remote-User $user;
    proxy_set_header Remote-Groups $groups;
    proxy_set_header Remote-Name $name;
    proxy_set_header Remote-Email $email;
    
    proxy_pass http://protected-service:80;
}
```

## 安全注意事项

- 生产环境中必须使用TLS加密
- 定期轮换敏感密钥和密码
- 使用强密码哈希算法（推荐Argon2id）
- 限制管理接口访问
- 定期更新Authelia到最新版本
- 遵循最小权限原则配置访问控制规则
- 保护配置文件和密钥文件的访问权限

## 社区支持和资源

- **官方文档**：https://www.authelia.com/
- **GitHub仓库**：https://github.com/authelia/authelia
- **Discord**：https://discord.authelia.com
- **Matrix**：https://matrix.to/#/#support:authelia.com
- **安全政策**：https://github.com/authelia/authelia/security/policy
- **贡献指南**：https://github.com/authelia/authelia/blob/master/CONTRIBUTING.md

## 许可证

Authelia采用**Apache 2.0**许可证。详细信息请参见[LICENSE](https://github.com/authelia/authelia/blob/master/LICENSE)文件。

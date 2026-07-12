---
image: avhost/go-imap-oauth2
description: "以IMAP为认证后端的OAuth服务"
source: https://xuanyuan.cloud/zh/r/avhost/go-imap-oauth2
canonical: https://xuanyuan.cloud/zh/r/avhost/go-imap-oauth2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/avhost/go-imap-oauth2" title="avhost/go-imap-oauth2 Docker 镜像中文简介、标签列表与拉取命令">avhost/go-imap-oauth2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# go-imap-oauth2 Docker镜像文档

## 镜像概述和主要用途

go-imap-oauth2是一个基于IMAP服务器作为认证后端的OAuth2服务提供商镜像。该镜像实现OAuth2协议标准流程，通过对接IMAP服务器验证用户身份，为客户端提供标准化的OAuth2授权服务。主要用途是简化依赖IMAP认证体系的应用集成，支持客户端通过OAuth2协议安全获取用户授权。

## 核心功能和特性

- **IMAP认证集成**：直接对接IMAP服务器（如Gmail、自建IMAP服务）验证用户凭据，无需独立用户数据库
- **OAuth2标准实现**：支持OAuth2核心授权流程（授权码模式等），提供标准`/authorize`（授权端点）和`/token`（令牌端点）
- **可配置连接参数**：支持自定义IMAP服务器地址、端口、域名，适配不同IMAP服务环境
- **SSL/TLS加密**：强制要求SSL/TLS证书，保障授权过程中数据传输安全性，避免客户端因安全策略拒绝连接

## 使用场景和适用范围

- **IMAP邮箱系统集成**：需基于现有IMAP邮箱（如企业自建IMAP服务器、Gmail）进行用户认证的应用场景
- **第三方客户端授权**：为Web应用、移动应用等客户端提供符合OAuth2标准的授权流程，实现安全的第三方登录
- **统一认证入口**：作为统一认证层，对接依赖IMAP协议的后端服务，简化多系统间用户身份核验

## 详细使用方法和配置说明

### 镜像获取

```bash
docker pull docker.xuanyuan.run/go-imap-oauth2:latest
```

### 配置参数说明

| 参数名          | 环境变量名       | 描述                                                                 | 是否必填 | 示例值                  |
|-----------------|------------------|----------------------------------------------------------------------|----------|-------------------------|
| --imapserver    | IMAP_SERVER      | IMAP服务器地址                                                       | 是       | imap.gmail.com          |
| --imapport      | IMAP_PORT        | IMAP服务器端口（143为非加密，993为SSL加密）                          | 是       | 993                     |
| --imapdomain    | IMAP_DOMAIN      | IMAP域名，用于构建用户邮箱地址（格式：user@imapdomain）               | 是       | gmail.com               |
| --clientdomain  | CLIENT_DOMAIN    | OAuth2服务自身域名（含协议），用于生成端点URL和验证回调地址           | 是       | https://oauth.example.com |
| --clientid      | CLIENT_ID        | OAuth2客户端标识，预分配给对接的客户端                               | 是       | xxxxxxxx-xxxx-xxxx      |
| --clientsecret  | CLIENT_SECRET    | OAuth2客户端密钥，客户端与服务端共享的安全凭证                       | 是       | xxxxxxxxxxxxxxxxxxxxxxx |
| --port          | PORT             | 服务监听端口（默认9096）                                             | 否       | 9096                    |

### Docker Run部署示例

#### 基础部署（需挂载SSL证书）

```bash
docker run -d \
  --name go-imap-oauth2 \
  -p 9096:9096 \
  -e IMAP_SERVER=imap.gmail.com \
  -e IMAP_PORT=993 \
  -e IMAP_DOMAIN=gmail.com \
  -e CLIENT_DOMAIN=https://oauth.example.com \
  -e CLIENT_ID=your-client-id-here \
  -e CLIENT_SECRET=your-client-secret-here \
  -v /path/to/ssl/cert.pem:/etc/ssl/certs/server.crt:ro \
  -v /path/to/ssl/key.pem:/etc/ssl/private/server.key:ro \
  docker.xuanyuan.run/go-imap-oauth2:latest
```

> **说明**：容器默认使用SSL模式启动，需通过`-v`参数挂载有效的SSL证书（公钥`server.crt`和私钥`server.key`）到容器内`/etc/ssl/certs/`和`/etc/ssl/private/`目录。

### Docker Compose部署示例

创建`docker-compose.yml`文件：

```yaml
version: '3'
services:
  oauth2-server:
    image: docker.xuanyuan.run/go-imap-oauth2:latest
    container_name: go-imap-oauth2
    ports:
      - "9096:9096"
    environment:
      - IMAP_SERVER=imap.gmail.com
      - IMAP_PORT=993
      - IMAP_DOMAIN=gmail.com
      - CLIENT_DOMAIN=https://oauth.example.com
      - CLIENT_ID=your-client-id-here
      - CLIENT_SECRET=your-client-secret-here
      - PORT=9096
    volumes:
      - ./ssl/cert.pem:/etc/ssl/certs/server.crt:ro
      - ./ssl/key.pem:/etc/ssl/private/server.key:ro
    restart: unless-stopped
```

启动服务：

```bash
docker-compose up -d
```

### 客户端配置说明

客户端需配置以下OAuth2端点对接服务：

- **授权端点（AuthURL）**：`https://<服务域名或IP>:9096/authorize`
- **令牌端点（TokenURL）**：`https://<服务域名或IP>:9096/token`

客户端请求时需携带预配置的`CLIENT_ID`和`CLIENT_SECRET`，并确保回调URL与`CLIENT_DOMAIN`匹配。

## 注意事项

- **SSL证书要求**：必须使用有效的SSL/TLS证书（如Let's Encrypt免费证书），否则客户端可能因安全策略拒绝连接
- **IMAP服务器兼容性**：确保IMAP服务器支持标准IMAP认证机制（如PLAIN），并开放对应端口（如993端口需启用SSL）
- **敏感信息保护**：`CLIENT_ID`和`CLIENT_SECRET`为敏感信息，需通过环境变量或安全存储方式注入，避免明文暴露

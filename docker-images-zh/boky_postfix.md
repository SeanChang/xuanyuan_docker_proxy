---
image: boky/postfix
description: "基于Alpine Linux的简单Postfix中继主机，适用于Docker容器。"
source: https://xuanyuan.cloud/zh/r/boky/postfix
canonical: https://xuanyuan.cloud/zh/r/boky/postfix
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/boky/postfix" title="boky/postfix Docker 镜像中文简介、标签列表与拉取命令">boky/postfix 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-postfix 中文技术文档


## 镜像概述和主要用途

docker-postfix 是一个基于 Alpine Linux 的轻量级 Postfix 中继主机镜像，专为 Docker 容器环境设计。它允许在 Docker 云/ swarm 部署中集中管理出站邮件发送，支持直接发送邮件或通过公司主服务器中继邮件。


## 核心功能和特性

- **轻量级基础**：基于 Alpine Linux，镜像体积小，资源占用低
- **灵活配置**：通过环境变量实现全配置，无需手动修改配置文件
- **安全端口**：默认使用提交端口（587），避免端口 25 被 ISP 封锁或占用
- **中继支持**：可配置外部中继主机，支持带认证的中继服务
- **访问控制**：通过 `MYNETWORKS` 限制允许发送邮件的网络范围
- **发件人验证**：通过 `ALLOWED_SENDER_DOMAINS` 限制允许的发件人域名
- **DKIM 支持**：内置 DKIM 签名功能，提升邮件送达率
- **可扩展性**：支持通过自定义脚本扩展 Postfix 配置


## 使用场景和适用范围

### 适用场景
- Docker 环境中应用程序的集中邮件发送管理
- 需要在容器集群内部提供 SMTP 服务的场景
- 应用程序需要通过中继服务器发送邮件的场景

### 不适用场景
- 终端用户的 Postfix 邮件服务器管理（不支持用户名/密码登录等客户端安全功能）
- 需要完整邮件接收和用户管理的场景


## 使用方法和配置说明

### 快速启动

```bash
docker run --rm --name postfix -e "ALLOWED_SENDER_DOMAINS=example.com" -p 1587:587 docker.xuanyuan.run/boky/postfix
```

启动后，可使用 `localhost:1587` 作为 SMTP 服务器地址发送邮件。**注意**：需确保 `example.com` 域名已正确配置 SPF 记录（参见 [openspf](http://www.openspf.org/)），否则邮件可能被标记为垃圾邮件。

> **重要**：镜像默认使用提交端口（587），不暴露端口 25（因常被 ISP 封锁或被其他服务占用）。


### 配置选项

#### 环境变量列表

| 环境变量                  | 描述                                                                 |
|--------------------------|----------------------------------------------------------------------|
| `HOSTNAME`               | Postfix 服务器标识主机名（默认使用 Docker 容器 ID）                  |
| `RELAYHOST`              | 中继主机地址（格式：`host` 或 `host:port` 或 `[ipv6]:port`）          |
| `RELAYHOST_USERNAME`     | 中继主机认证用户名（可选）                                           |
| `RELAYHOST_PASSWORD`     | 中继主机认证密码（可选）                                             |
| `MYNETWORKS`             | 允许发送邮件的网络范围（默认：`127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`） |
| `ALLOWED_SENDER_DOMAINS` | 允许的发件人域名（空格分隔多个域名，必填，除非设置 `ALLOW_EMPTY_SENDER_DOMAINS`） |
| `ALLOW_EMPTY_SENDER_DOMAINS` | 允许空发件人域名（设置为非空值如 "true" 时，`ALLOWED_SENDER_DOMAINS` 可省略） |
| `MASQUERADED_DOMAINS`    | 地址伪装域名（重写发件人地址，如 `user@sub.example.com` → `user@example.com`） |
| `RELAYHOST_TLS_LEVEL`    | 中继主机 TLS 安全级别（默认：`may`，详见 [Postfix 文档](http://www.postfix.org/postconf.5.html#smtp_tls_security_level)） |
| `MESSAGE_SIZE_LIMIT`     | 最大邮件大小（字节，默认 0 表示无限制）                              |
| `INBOUND_DEBUGGING`      | 启用来自 `MYNETWORKS` 的连接调试（设置为非空值如 "1" 启用）          |
| `SMTP_HEADER_CHECKS`     | SMTP 头检查配置（格式：`type:path`，设置为 "1" 时使用默认配置）       |


#### 详细配置说明

##### `HOSTNAME`
设置 Postfix 服务器标识主机名，默认使用容器 ID（如 `f73792d540a5`）。建议显式设置以方便日志追踪：
```bash
docker run --rm --name postfix -e HOSTNAME=postfix-docker -e "ALLOWED_SENDER_DOMAINS=example.com" -p 1587:587 docker.xuanyuan.run/boky/postfix
```


##### `RELAYHOST`, `RELAYHOST_USERNAME`, `RELAYHOST_PASSWORD`
配置中继主机，用于通过外部服务器发送邮件（如公司邮件服务器或第三方 SMTP 服务）：

- 基本中继（默认端口 25）：
  ```bash
  docker run --rm --name postfix -e "RELAYHOST=192.168.115.215" -e "ALLOWED_SENDER_DOMAINS=example.com" -p 1587:587 docker.xuanyuan.run/boky/postfix
  ```

- 指定端口：
  ```bash
  docker run --rm --name postfix -e "RELAYHOST=192.168.115.215:587" -e "ALLOWED_SENDER_DOMAINS=example.com" -p 1587:587 docker.xuanyuan.run/boky/postfix
  ```

- IPv6 地址：
  ```bash
  docker run --rm --name postfix -e 'RELAYHOST=[2001:db8::1]:587' -e "ALLOWED_SENDER_DOMAINS=example.com" -p 1587:587 docker.xuanyuan.run/boky/postfix
  ```

- 带认证的中继：
  ```bash
  docker run --rm --name postfix \
    -e "RELAYHOST=mail.google.com:587" \
    -e "RELAYHOST_USERNAME=hello@gmail.com" \
    -e "RELAYHOST_PASSWORD=your-password" \
    -e "ALLOWED_SENDER_DOMAINS=example.com" \
    -p 1587:587 docker.xuanyuan.run/boky/postfix
  ```


##### `MYNETWORKS`
限制允许发送邮件的网络范围（CIDR 格式，逗号分隔）。默认包含私有网络，如需收紧限制：
```bash
docker run --rm --name postfix -e "MYNETWORKS=10.1.2.0/24" -e "ALLOWED_SENDER_DOMAINS=example.com" -p 1587:587 docker.xuanyuan.run/boky/postfix
```


##### `ALLOWED_SENDER_DOMAINS`
必填项，指定允许的发件人域名（空格分隔多个域名），用于 Postfix 中继限制：
```bash
docker run --rm --name postfix -e "ALLOWED_SENDER_DOMAINS=example.com example.org" -p 1587:587 docker.xuanyuan.run/boky/postfix
```

若需仅限制收件人而非发件人，设置 `ALLOW_EMPTY_SENDER_DOMAINS=true` 并将 `ALLOWED_SENDER_DOMAINS` 设为空，然后通过自定义脚本扩展配置。


##### `MASQUERADED_DOMAINS`
启用地址伪装，重写发件人地址（如 `user@sub.example.com` → `user@example.com`）：
```bash
docker run --rm --name postfix \
  -e "ALLOWED_SENDER_DOMAINS=example.com example.org" \
  -e "MASQUERADED_DOMAINS=example.com" \
  -p 1587:587 docker.xuanyuan.run/boky/postfix
```


##### `SMTP_HEADER_CHECKS`
配置 SMTP 头检查（用于过滤或修改邮件头）。设置为 "1" 时使用默认配置（`regexp:/etc/postfix/smtp_header_checks`）：
```bash
docker run --rm --name postfix \
  -e "SMTP_HEADER_CHECKS=regexp:/etc/postfix/smtp_header_checks" \
  -e "ALLOWED_SENDER_DOMAINS=example.com" \
  -p 1587:587 docker.xuanyuan.run/boky/postfix
```


### DKIM 配置

#### 生成 DKIM 密钥
1. 安装 `opendkim-tools` 或 `opendkim-utils`（根据系统）
2. 为每个域名生成密钥：
   ```bash
   mkdir -p /host/keys && cd /host/keys
   
   for DOMAIN in example.com example.org; do
     # 生成 selector 为 "mail" 的密钥
     opendkim-genkey -b 2048 -h rsa-sha256 -r -v --subdomains -s mail -d $DOMAIN
     # 修复哈希算法标识
     sed -i 's/h=rsa-sha256/h=sha256/' mail.txt
     # 重命名文件
     mv mail.private $DOMAIN.private
     mv mail.txt $DOMAIN.txt
   done
   ```

#### 配置 DNS
将 `<domain>.txt` 文件中的内容添加到对应域名的 DNS TXT 记录（如 `mail._domainkey.example.com`）。

#### 启动容器并挂载密钥
```bash
docker run --rm --name postfix \
  -e "ALLOWED_SENDER_DOMAINS=example.com example.org" \
  -v /host/keys:/etc/opendkim/keys \
  -p 1587:587 docker.xuanyuan.run/boky/postfix
```


### 扩展镜像配置

通过自定义脚本扩展 Postfix 配置，脚本需放在 `/docker-init.db/` 目录（`.sh` 扩展名），启动时自动执行。

#### 示例：自定义 Dockerfile
```dockerfile
FROM docker.xuanyuan.run/boky/postfix
LABEL maintainer="Jack Sparrow <jack.sparrow@theblackpearl.example.com>"
ADD additional-config.sh /docker-init.db/
```

#### 示例：自定义脚本（additional-config.sh）
```bash
#!/bin/sh
# 添加自定义 Postfix 配置
postconf -e "address_verify_negative_cache=yes"
```


### docker-compose 示例

```yaml
version: '3'
services:
  postfix:
    image: docker.xuanyuan.run/boky/postfix
    container_name: postfix
    environment:
      - ALLOWED_SENDER_DOMAINS=example.com example.org
      - HOSTNAME=postfix.example.com
      - RELAYHOST=smtp.example.com:587
      - RELAYHOST_USERNAME=smtp-user@example.com
      - RELAYHOST_PASSWORD=smtp-password
      - MYNETWORKS=10.0.0.0/8,172.16.0.0/12
    ports:
      - "1587:587"
    volumes:
      - ./dkim-keys:/etc/opendkim/keys
      - ./custom-scripts:/docker-init.db
    restart: unless-stopped
```


## 安全说明

- Postfix 主进程以 `root` 运行（Postfix 设计如此），子进程以 `postfix` 用户（UID:GID 100:101）运行
- DKIM 进程以 `opendkim` 用户（UID:GID 102:103）运行
- 建议正确配置 DNS（SPF、DKIM、DMARC 记录）以避免邮件被标记为垃圾邮件
- 限制 `MYNETWORKS` 范围，避免未授权网络发送邮件


## 注意事项

- 邮件送达率取决于 DNS 配置（SPF、DKIM、反向 DNS 等），需确保相关记录正确
- 端口映射建议使用非标准端口（如示例中的 1587:587），避免与主机服务冲突
- 项目虽提交历史较旧，但仍在维护，最新代码见 [Docker Hub](https://hub.docker.com/r/boky/postfix)

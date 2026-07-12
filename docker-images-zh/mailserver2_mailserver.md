---
image: mailserver2/mailserver
description: "基于Docker的简单且功能全面的邮件服务器"
source: https://xuanyuan.cloud/zh/r/mailserver2/mailserver
canonical: https://xuanyuan.cloud/zh/r/mailserver2/mailserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mailserver2/mailserver" title="mailserver2/mailserver Docker 镜像中文简介、标签列表与拉取命令">mailserver2/mailserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# mailserver2/mailserver

## 镜像概述和主要用途

**mailserver2/mailserver** 是一个简单且功能全面的邮件服务器，基于多个 Docker 镜像构建，提供完整的邮件收发、存储、安全防护及管理功能。该镜像源自 [hardware/mailserver](https://github.com/hardware/mailserver) 项目的分支，专注于提供基础维护支持。

## 核心功能和特性

- **Postfix**：全功能 SMTP 邮件服务器
- **Dovecot**：安全的 IMAP 和 POP3 邮件服务器
- **Rspamd**：反垃圾邮件过滤器，支持 SPF、DKIM、DMARC、ARC、速率限制和灰名单功能
- **Clamav**：带自动更新和第三方签名数据库的防病毒软件
- **Zeyple**：自动 GPG 加密所有邮件
- **Sieve**：邮件过滤（假期自动回复、自动转发等）
- **Fetchmail**：从外部 IMAP/POP3 服务器获取邮件到本地邮箱
- **Rainloop**：基于 Web 的邮件客户端（可选）
- **Postfixadmin**：基于 Web 的管理界面
- **Unbound**：带 DNSSEC 支持的递归缓存 DNS 解析器
- **NSD**：带 DNSSEC 支持的权威 DNS 服务器
- **Træfik**：现代 HTTP 反向代理
- **SSL**：支持 Let's Encrypt 自动续期（含 SAN 和通配符证书）、自定义和自签名证书
- **OpenLDAP**：[BETA] LDAP 支持（目前仅在 `1.1-latest` 版本中可用）
- 支持基于 MySQL/PostgreSQL 后端的多虚拟域
- Travis CI 集成测试
- DockerHub 自动构建

## 使用场景和适用范围

适用于需要自建邮件服务器的个人、小型企业或组织，尤其适合以下场景：
- 需要完整控制邮件数据和隐私的环境
- 要求具备反垃圾邮件、防病毒等安全防护能力的邮件系统
- 需要多域名管理和虚拟用户支持的场景
- 希望通过 Web 界面进行邮件管理和客户端访问的用户
- 偏好 Docker 容器化部署以简化维护的技术团队

## 系统要求

### 数据库和 Redis 与邮件服务器同主机部署
| 类型 | 不含 ClamAV | 含 ClamAV |
|------|------------|----------|
| CPU | 1 GHz | 1 GHz |
| 内存 | 1.5 GiB | 2 GiB |

### 数据库和 Redis 部署在其他服务器
| 类型 | 不含 ClamAV | 含 ClamAV |
|------|------------|----------|
| CPU | 1 GHz | 1 GHz |
| 内存 | 512 MiB | 1 GiB |

## 前提条件

### 环境清理
建议使用干净的操作系统安装。若使用 Debian，需移除默认 MTA Exim4：
```bash
apt-get purge exim4*
```

确保没有其他应用占用邮件服务端口：
```bash
netstat -tulpn | grep -E -w '25|80|110|143|443|465|587|993|995|4190'
```
若有结果，需停止或移除占用端口的应用。

### 端口要求
若启用防火墙，需开放以下端口：

| 服务 | 软件 | 协议 | 端口 |
|------|------|------|------|
| SMTP | Postfix | TCP | 25 |
| HTTP | Nginx | TCP | 80 |
| POP3 | Dovecot | TCP | 110 |
| IMAP | Dovecot | TCP | 143 |
| HTTPS | Nginx | TCP | 443 |
| SMTPS | Postfix | TCP | 465 |
| Submission | Postfix | TCP | 587 |
| IMAPS | Dovecot | TCP | 993 |
| POP3S | Dovecot | TCP | 995 |
| ManageSieve | Dovecot | TCP | 4190 |

### DNS 配置
推荐使用 [hardware/nsd-dnssec](https://github.com/hardware/nsd-dnssec) 作为带 DNSSEC 功能的权威名称服务器。

#### DNS 记录和反向 PTR
正确的 DNS 配置至关重要，需设置以下记录：

| 主机名 | 类别 | 类型 | 优先级 | 值 |
|--------|------|------|--------|-----|
| mail | IN | A/AAAA | 任意 | 1.2.3.4（服务器IP） |
| spam | IN | CNAME | 任意 | mail.domain.tld. |
| webmail | IN | CNAME | 任意 | mail.domain.tld. |
| postfixadmin | IN | CNAME | 任意 | mail.domain.tld. |
| @ | IN | MX | 10 | mail.domain.tld. |
| @ | IN | TXT | 任意 | "v=spf1 a mx ip4:SERVER_IPV4 ~all" |
| {{selector}}._domainkey | IN | TXT | 任意 | "v=DKIM1; k=rsa; p=您的DKIM公钥" |
| _dmarc | IN | TXT | 任意 | "v=DMARC1; p=reject; rua=mailto:postmaster@domain.tld; ruf=mailto:admin@domain.tld; fo=0; adkim=s; aspf=s; pct=100; rf=afrf; sp=reject" |

**注意**：
- 确保服务器 IP 的 **PTR 记录** 与邮件服务器的 FQDN（默认：mail.domain.tld）匹配
- {{selector}} 默认值为 `mail`，可通过 `DKIM_SELECTOR` 环境变量修改
- 容器启动后，DKIM 公钥可在主机的 `/mnt/docker/mail/dkim/domain.tld/{{selector}}.public.key` 路径下找到
- 若需重新生成密钥对，删除 `/mnt/docker/mail/dkim/domain.tld` 文件夹即可

### 测试
可使用以下服务审计邮件服务器配置：
- https://www.mail-tester.com/
- https://www.hardenize.com/
- https://observatory.mozilla.org/
- https://www.emailprivacytester.com/（邮件客户端侧）

## 详细使用方法和配置说明

### 安装步骤

#### 1 - 准备环境
推荐使用 [Traefik](https://traefik.io/) 作为反向代理，也可使用 Nginx、Apache 等替代方案。

```bash
# 创建 Traefik 的 Docker 网络（仅 IPv4）
docker network create http_network

# 创建所需文件夹和文件
mkdir -p /mnt/docker/traefik/acme && cd /mnt/docker \
&& curl https://raw.githubusercontent.com/mailserver2/mailserver/master/docker-compose.sample.yml -o docker-compose.yml \
&& curl https://raw.githubusercontent.com/mailserver2/mailserver/master/sample.env -o .env \
&& curl https://raw.githubusercontent.com/mailserver2/mailserver/master/traefik.sample.toml -o traefik/traefik.toml \
&& touch traefik/acme/acme.json \
&& chmod 600 docker-compose.yml .env traefik/traefik.toml traefik/acme/acme.json
```

编辑 `.env` 和 `traefik.toml` 文件，根据需求调整配置，然后启动所有服务：
```bash
docker-compose up -d
```

#### 2 - Postfixadmin 安装
PostfixAdmin 是用于管理邮箱、虚拟域和别名的 Web 界面。
- Docker 镜像：https://github.com/hardware/postfixadmin
- 配置指南：[Postfixadmin 初始配置](https://github.com/mailserver2/mailserver/wiki/Postfixadmin-initial-configuration)

#### 3 - Rainloop 安装（可选）
Rainloop 是一个简单、现代且快速的 Web 邮件客户端，支持 Sieve 脚本（过滤器和假期回复）、GPG 加密。
- Docker 镜像：https://github.com/hardware/rainloop
- 配置指南：[Rainloop 初始配置](https://github.com/mailserver2/mailserver/wiki/Rainloop-initial-configuration)

#### 4 - 完成安装
首次启动容器时，需要几分钟时间生成 SSL 证书（如需）、DKIM 密钥对和更新 Clamav 数据库。默认包含自签名证书，建议替换为可信证书（详见下文 SSL 证书配置）。

**可用 Web 服务列表**：

| 服务 | URI |
|------|-----|
| Traefik 控制台 | https://mail.domain.tld/ |
| Rspamd 控制台 | https://spam.domain.tld/ |
| 管理界面 | https://postfixadmin.domain.tld/ |
| Web 邮件客户端 | https://webmail.domain.tld/ |

Traefik 控制台使用基本认证（默认用户：admin，密码：12345），可使用 `htpasswd` 生成加密密码。Rspamd 控制台密码在 `docker-compose.yml` 中定义。

查看启动日志：
```bash
docker logs -f mailserver
```

### Docker Compose 配置示例
以下是简化的 `docker-compose.yml` 示例：

```yaml
version: '3.8'

services:
  mailserver:
    image: docker.xuanyuan.run/mailserver2/mailserver:latest
    restart: always
    depends_on:
      - mariadb
      - redis
    environment:
      - DBPASS=your_secure_password
      - RSPAMD_PASSWORD=your_rspamd_password
      - DKIM_KEY_LENGTH=2048
      - ENABLE_POP3=true
      - DISABLE_CLAMAV=false
    volumes:
      - /mnt/docker/mail:/var/mail
      - /mnt/docker/mail/filter:/var/spool/sieve
      - /mnt/docker/mail/dkim:/etc/dkim
      - /mnt/docker/traefik/acme:/etc/letsencrypt
    ports:
      - "25:25"
      - "143:143"
      - "587:587"
      - "993:993"
    networks:
      - http_network

  mariadb:
    image: docker.xuanyuan.run/mariadb:10.5
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=your_root_password
      - MYSQL_DATABASE=postfix
      - MYSQL_USER=postfix
      - MYSQL_PASSWORD=your_secure_password
    volumes:
      - /mnt/docker/mysql:/var/lib/mysql
    networks:
      - http_network

  redis:
    image: docker.xuanyuan.run/redis:6-alpine
    restart: always
    volumes:
      - /mnt/docker/redis:/data
    networks:
      - http_network

  traefik:
    image: docker.xuanyuan.run/traefik:v2.5
    restart: always
    command:
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.letsencrypt.acme.email=admin@domain.tld"
      - "--certificatesresolvers.letsencrypt.acme.storage=/acme/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /mnt/docker/traefik/acme:/acme
    networks:
      - http_network

networks:
  http_network:
    external: true
```

### 环境变量详细说明

| 变量 | 描述 | 类型 | 默认值 |
|------|------|------|--------|
| **VMAILUID** | vmail 用户 ID | 可选 | 1024 |
| **VMAILGID** | vmail 组 ID | 可选 | 1024 |
| **VMAIL_SUBDIR** | 邮箱子目录名称 | 可选 | mail |
| **DKIM_KEY_LENGTH** | DKIM RSA 密钥对长度 | 可选 | 1024 |
| **DKIM_SELECTOR** | DKIM 选择器 | 可选 | mail |
| **DEBUG_MODE** | 启用详细日志（postfix,dovecot,rspamd,unbound） | 可选 | false |
| **PASSWORD_SCHEME** | 密码加密方案 | 可选 | SHA512-CRYPT |
| **DBDRIVER** | 数据库类型：mysql, pgsql, ldap | 可选 | mysql |
| **DBHOST** | 数据库地址 | 可选 | mariadb |
| **DBPORT** | 数据库端口 | 可选 | 3306 / 389 (sql/ldap) |
| **DBUSER** | 数据库用户名 | 可选 | postfix |
| **DBNAME** | 数据库名称 | 可选 | postfix |
| **DBPASS** | 数据库密码（或密码文件路径） | 必选* | null |
| **REDIS_HOST** | Redis 地址 | 可选 | redis |
| **REDIS_PORT** | Redis 端口 | 可选 | 6379 |
| **REDIS_PASS** | Redis 密码（或密码文件路径） | 可选 | null |
| **REDIS_NUMB** | Redis 数据库编号 | 可选 | 0 |
| **RSPAMD_PASSWORD** | Rspamd WebUI 密码 | 必选 | null |
| **ADD_DOMAINS** | 额外域名（逗号分隔） | 可选 | null |
| **RELAY_NETWORKS** | 无需认证的中继网络 | 可选 | null |
| **WHITELIST_SPAM_ADDRESSES** | 垃圾邮件白名单地址 | 可选 | null |
| **DISABLE_RSPAMD_MODULE** | 禁用的 Rspamd 模块 | 可选 | null |
| **DISABLE_CLAMAV** | 禁用防病毒 | 可选 | false |
| **DISABLE_SIEVE** | 禁用 Sieve 协议 | 可选 | false |
| **DISABLE_SIGNING** | 禁用 DKIM/ARC 签名 | 可选 | false |
| **DISABLE_GREYLISTING** | 禁用灰名单 | 可选 | false |
| **DISABLE_RATELIMITING** | 禁用速率限制 | 可选 | true |
| **DISABLE_DNS_RESOLVER** | 禁用本地 DNS 解析器 | 可选 | false |
| **DISABLE_SSL_WATCH** | 禁用 SSL 证书监控 | 可选 | false |
| **ENABLE_POP3** | 启用 POP3 协议 | 可选 | false |
| **ENABLE_FETCHMAIL** | 启用 Fetchmail | 可选 | false |
| **ENABLE_ENCRYPTION** | 启用 GPG 自动加密 | 可选 | false |
| **FETCHMAIL_INTERVAL** | Fetchmail 轮询间隔（分钟） | 可选 | 10 |
| **RECIPIENT_DELIMITER** | 收件人分隔符（单字符） | 可选 | + |

> *DBPASS 在使用 LDAP 认证时不需要

### 自动 GPG 加密配置

#### 工作原理
[Zeyple](https://infertux.com/labs/zeyple/) 从 Postfix 队列捕获邮件，若找到收件人的 GPG 公钥则自动加密，然后将加密后的邮件放回队列。

#### 启用自动加密
将环境变量 `ENABLE_ENCRYPTION` 设置为 `true`。公钥环存储在 `/var/mail/zeyple/keys`。

#### 导入公钥
确保公钥已上传至 GPG 密钥服务器，然后执行：
```bash
docker exec -ti mailserver encryption.sh import-key YOUR_KEY_ID
```

#### 导入所有收件人公钥
浏览所有邮箱目录并导入对应公钥：
```bash
docker exec -ti mailserver encryption.sh import-all-keys
```

### SSL 证书配置

#### Let's Encrypt 证书（通过 Traefik）
1. 确保 Traefik 正确配置并生成证书
2. 将 Traefik 的 acme 目录挂载到容器：`/mnt/docker/traefik/acme:/etc/letsencrypt`
3. 容器会自动检测并使用最新证书

#### 自定义证书
将证书文件放置在 `/mnt/docker/mail/ssl/` 目录，命名规则：
- 证书：`fullchain.pem`
- 私钥：`privkey.pem`
- CA 证书：`chain.pem`（可选）

### 第三方 Clamav 签名数据库

#### 所需端口
- TCP 80：下载签名数据库
- TCP 443：下载签名数据库（备用）

#### 启用 clamav-unofficial-sigs
1. 创建配置文件目录：`mkdir -p /mnt/docker/mail/clamav-unofficial-sigs`
2. 挂载目录到容器：`-v /mnt/docker/mail/clamav-unofficial-sigs:/etc/clamav-unofficial-sigs`
3. 容器会自动启用并配置第三方签名数据库

## 迁移指南

### 从 hardware/mailserver 迁移到 mailserver2/mailserver
1. 备份数据：`/mnt/docker/mail`、数据库和 DKIM 密钥
2. 更新 `docker-compose.yml` 中的镜像名称为 `mailserver2/mailserver:latest`
3. 启动新容器：`docker-compose up -d`

### 从 1.0 版本迁移到 1.1 版本
1.

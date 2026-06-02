---
image: mailserver/docker-mailserver
description: "一个全栈且简单易用的邮件服务器，支持SMTP、IMAP协议，集成LDAP、反垃圾邮件及反病毒等功能。"
source: https://xuanyuan.cloud/zh/r/mailserver/docker-mailserver
canonical: https://xuanyuan.cloud/zh/r/mailserver/docker-mailserver
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mailserver/docker-mailserver" title="mailserver/docker-mailserver Docker 镜像中文简介、标签列表与拉取命令">mailserver/docker-mailserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mailserver/docker-mailserver" title="mailserver/docker-mailserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mailserver/docker-mailserver</a>

# Docker Mailserver 镜像文档


## 一、镜像概述和主要用途

该镜像为生产就绪的容器化邮件服务器，提供全栈邮件服务功能，同时保持配置简洁。设计目标是通过纯配置文件管理服务（无需 SQL 数据库），实现简单部署、轻松升级和版本化管理。主要用于需要自托管邮件服务的场景，支持邮件发送、接收、用户认证及安全过滤等核心需求。


## 二、核心功能和特性

### 核心协议支持
- **邮件传输与接收**：支持 SMTP（邮件发送）和 IMAP（邮件接收）协议，满足基础邮件通信需求。
- **用户认证集成**：支持 LDAP 协议，可对接企业现有目录服务进行用户认证。

### 安全与过滤
- **反垃圾邮件**：内置反垃圾邮件机制，减少垃圾邮件干扰。
- **反病毒防护**：集成 antivirus 功能，扫描邮件内容以拦截恶意附件或病毒。

### 配置与部署
- **无数据库依赖**：仅通过配置文件管理服务，避免复杂的 SQL 数据库维护。
- **易于部署和升级**：容器化设计简化部署流程，支持版本化配置，升级便捷。
- **生产就绪**：经过测试验证，可直接用于生产环境。


## 三、使用场景和适用范围

### 适用用户
- 需要自托管邮件服务的中小企业或团队。
- 希望通过简单配置实现邮件服务的开发者或运维人员。
- 对邮件服务有基础功能需求（发送、接收、安全过滤），且注重部署效率的场景。

### 典型场景
- 企业内部邮件系统：用于员工间邮件通信，结合 LDAP 统一用户管理。
- 应用程序邮件服务：为自托管应用提供邮件发送（如通知、验证码）和接收功能。
- 个人或小型团队邮件服务器：需要低成本、易维护的邮件解决方案。


## 四、详细的使用方法和配置说明

### 4.1 部署准备
1. **环境要求**：Docker 19.03+ 或 Docker Compose 2.0+，服务器需开放邮件相关端口（25、143、587、993 等）。
2. **配置文件准备**：创建本地配置目录（如 `./docker-mailserver`），用于存放服务配置文件（具体配置项参考 [官方文档](https://docker-mailserver.github.io/docker-mailserver/latest/)）。


### 4.2 Docker Run 部署示例
通过 `docker run` 直接启动容器，需挂载配置目录、映射必要端口，并设置核心环境变量：

```bash
docker run -d \
  --name mailserver \
  --hostname mail.example.com \  # 邮件服务器主机名（需与域名匹配）
  -p 25:25 \          # SMTP 端口（邮件发送）
  -p 143:143 \        # IMAP 端口（明文，可选）
  -p 587:587 \        # SMTP 提交端口（TLS，用于客户端发送）
  -p 993:993 \        # IMAP 加密端口（TLS，推荐）
  -v $(pwd)/docker-mailserver:/tmp/docker-mailserver \  # 挂载配置目录
  -e MAIL_DOMAIN=example.com \  # 邮件域名
  -e ADMIN_EMAIL=admin@example.com \  # 管理员邮箱（用于管理操作）
  docker-mailserver/docker-mailserver:latest
```


### 4.3 Docker Compose 部署示例
使用 `docker-compose.yml` 定义服务，更便于管理配置和依赖：

```yaml
version: '3.8'

services:
  mailserver:
    image: docker-mailserver/docker-mailserver:latest
    container_name: mailserver
    hostname: mail.example.com
    ports:
      - "25:25"       # SMTP
      - "143:143"     # IMAP
      - "587:587"     # SMTP Submission (TLS)
      - "993:993"     # IMAPS (TLS)
    volumes:
      - ./docker-mailserver:/tmp/docker-mailserver  # 配置文件目录
      - ./maildata:/var/mail  # 邮件存储目录（可选，持久化邮件数据）
    environment:
      - MAIL_DOMAIN=example.com
      - ADMIN_EMAIL=admin@example.com
      - ENABLE_LDAP=0  # 0: 禁用 LDAP，1: 启用（需额外配置 LDAP 参数）
      - ENABLE_SPAMASSASSIN=1  # 启用反垃圾邮件（1: 启用，0: 禁用）
    restart: always
```


### 4.4 关键配置参数说明
| 参数名                | 作用                          | 示例值                  |
|-----------------------|-------------------------------|-------------------------|
| `MAIL_DOMAIN`         | 邮件服务域名                  | `example.com`           |
| `ADMIN_EMAIL`         | 管理员邮箱（用于管理命令）    | `admin@example.com`     |
| `ENABLE_LDAP`         | 是否启用 LDAP 认证            | `1`（启用）/ `0`（禁用）|
| `ENABLE_SPAMASSASSIN` | 是否启用反垃圾邮件（SpamAssassin） | `1`（启用）/ `0`（禁用） |
| `ENABLE_CLAMAV`       | 是否启用反病毒（ClamAV）      | `1`（启用）/ `0`（禁用）|
| `SMTP_PORT`           | 自定义 SMTP 端口（默认 25）   | `2525`                  |


## 五、补充信息
- **项目地址**：[GitHub](https://github.com/docker-mailserver/docker-mailserver)
- **官方文档**：[GitHub Pages](https://docker-mailserver.github.io/docker-mailserver/latest/)（最新稳定版文档）

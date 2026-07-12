---
image: mailcow/postfix
description: "mailcow Docker镜像是开源邮件服务器套件，集成SMTP、IMAP、POP3等核心服务，支持Docker快速部署，用于便捷搭建和管理自建邮件服务器。"
source: https://xuanyuan.cloud/zh/r/mailcow/postfix
canonical: https://xuanyuan.cloud/zh/r/mailcow/postfix
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mailcow/postfix" title="mailcow/postfix Docker 镜像中文简介、标签列表与拉取命令">mailcow/postfix 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# mailcow: dockerized - 容器化邮件服务器套件


## 1. 镜像概述和主要用途

mailcow: dockerized 是一个基于 Docker 容器化技术的开源邮件服务器套件，集成了完整的邮件服务组件，旨在提供开箱即用、易于部署和管理的邮件解决方案。该套件包含 SMTP、IMAP、POP3 协议支持、Web 管理界面、反垃圾邮件、防病毒、邮件存储等核心功能，通过容器化架构简化部署流程，降低维护复杂度，适用于构建自建邮件服务器。


## 2. 核心功能和特性

### 2.1 核心功能
- **全协议支持**：兼容 SMTP、IMAP、POP3 及 ESMTP，支持 STARTTLS 和 SSL/TLS 加密
- **Web 管理界面**：提供直观的管理面板，支持邮件域、用户、别名、权限等配置
- **反垃圾邮件**：集成 Rspamd 反垃圾引擎，支持自定义规则和评分系统
- **防病毒保护**：内置 ClamAV 防病毒引擎，实时扫描邮件附件
- **多域支持**：可管理多个独立邮件域，支持域级别的配置隔离
- **邮件存储**：基于 Dovecot 的高性能邮件存储，支持邮件搜索和过滤
- **API 支持**：提供 REST API，支持自动化管理和集成第三方系统
- **日历与联系人**：集成 SOGo Groupware，支持日历、联系人同步（CalDAV/CardDAV）


### 2.2 技术特性
- **容器化架构**：所有组件（Postfix、Dovecot、Nginx、数据库等）通过 Docker 容器部署，依赖清晰
- **自动配置**：内置 Let's Encrypt 客户端，自动生成和续期 SSL/TLS 证书
- **高可用性**：支持多节点部署和数据卷持久化，保障服务稳定性
- **轻量级设计**：优化资源占用，适合中小型部署场景
- **开源免费**：基于 MIT 许可证，代码完全开源，无商业许可限制


## 3. 使用场景和适用范围

### 3.1 适用场景
- **中小企业自建邮件服务器**：替代第三方邮件服务，实现数据自主可控
- **开发者测试环境**：快速搭建邮件服务用于应用测试（如邮件发送功能验证）
- **教育或非营利组织**：低成本构建自定义邮件系统，满足内部通信需求
- **需要定制化邮件服务的组织**：支持自定义反垃圾规则、域策略、集成内部系统

### 3.2 不适用场景
- **超大规模企业**：十万级以上用户规模需额外优化集群架构
- **无运维能力的个人**：需基础 Docker 和邮件协议知识（如 DNS 配置、MX 记录）


## 4. 详细的使用方法和配置说明

### 4.1 环境要求
- Docker Engine ≥ 20.10
- Docker Compose ≥ 2.12
- 至少 2GB RAM（推荐 4GB+）
- 20GB+ 磁盘空间（视邮件存储需求调整）
- 公网 IP 及域名（需解析 MX、SPF、DKIM 等 DNS 记录）


### 4.2 部署步骤

#### 4.2.1 安装基础依赖
```bash
# 安装 Docker 和 Docker Compose（以 Ubuntu 为例）
apt update && apt install -y docker.io docker-compose-plugin
systemctl enable --now docker
```

#### 4.2.2 获取 mailcow 代码
```bash
# 克隆官方仓库
git clone https://github.com/mailcow/mailcow-dockerized.git
cd mailcow-dockerized
```

#### 4.2.3 配置环境变量
```bash
# 复制示例配置文件并编辑
cp mailcow.conf.example .env

# 编辑 .env 文件（关键配置项见 5. 环境变量说明）
nano .env  # 或使用 vim 等编辑器
```

#### 4.2.4 启动服务
```bash
# 拉取镜像并启动容器
docker-compose up -d

# 检查服务状态
docker-compose ps
```

#### 4.2.5 访问管理界面
服务启动后，通过 `https://${MAILCOW_HOSTNAME}` 访问 Web 管理界面（默认管理员账号：`admin`，密码：`moohoo`，首次登录需修改）。


### 4.3 核心配置说明

#### 4.3.1 DNS 记录配置（必需）
邮件服务正常运行需配置以下 DNS 记录（以域 `example.com` 为例）：
- **MX 记录**：`example.com MX 10 mail.example.com`（指向 mailcow 服务器域名）
- **SPF 记录**：`example.com TXT "v=spf1 mx a -all"`（允许服务器发送邮件）
- **DKIM 记录**：在管理界面生成 DKIM 密钥后，添加 TXT 记录 `dkim._domainkey.example.com TXT "v=DKIM1; k=rsa; p=..."`
- **DMARC 记录**：`_dmarc.example.com TXT "v=DMARC1; p=quarantine; sp=quarantine; adkim=s; aspf=s"`（可选，增强邮件验证）

#### 4.3.2 反垃圾邮件配置
通过 Web 管理界面 **配置 > Rspamd** 调整反垃圾规则，支持：
- 自定义评分阈值（如垃圾邮件分数 ≥ 15 拒绝）
- 白名单/黑名单（IP、发件人、域名）
- 启用 DKIM/SPF/DMARC 验证并设置策略

#### 4.3.3 用户与域管理
- **添加域**：管理界面 **邮箱 > 域 > 添加域**，输入域名并启用
- **创建用户**：管理界面 **邮箱 > 邮箱 > 添加邮箱**，设置用户名、密码、配额
- **别名配置**：管理界面 **邮箱 > 别名**，设置邮件转发规则（如 `support@example.com` 转发至 `user1@example.com,user2@example.com`）


## 5. 环境变量说明（.env 文件）

| 变量名                | 说明                                  | 示例值                  |
|-----------------------|---------------------------------------|-------------------------|
| `MAILCOW_HOSTNAME`    | 邮件服务器主机名（管理界面域名）      | `mail.example.com`      |
| `HTTP_PORT`           | HTTP 端口（默认 80，用于重定向至 HTTPS） | `80`                    |
| `HTTPS_PORT`          | HTTPS 端口（管理界面端口）            | `443`                   |
| `SKIP_LETS_ENCRYPT`   | 是否跳过 Let's Encrypt 证书生成       | `n`（默认自动生成）     |
| `ADMIN_EMAIL`         | 管理员邮箱（接收系统通知）            | `admin@example.com`     |
| `DB_ROOT_PASSWORD`    | MySQL 根密码（自动生成，无需手动修改） | 随机字符串              |
| `MAILCOW_TZ`          | 时区设置                              | `Asia/Shanghai`         |


## 6. 部署方案示例

### 6.1 docker-compose 配置（默认）
mailcow 已内置 `docker-compose.yml`，无需手动编写，通过 `.env` 文件控制容器参数。关键服务组件包括：
- `nginx-mailcow`：反向代理和 Web 服务器
- `dovecot-mailcow`：IMAP/POP3 服务器
- `postfix-mailcow`：SMTP 服务器
- `rspamd-mailcow`：反垃圾邮件引擎
- `clamd-mailcow`：防病毒引擎
- `mysql-mailcow`：数据库服务


### 6.2 服务维护命令
```bash
# 查看日志（例如 postfix 日志）
docker-compose logs -f postfix-mailcow

# 更新 mailcow 版本
git pull
docker-compose pull
docker-compose up -d

# 停止服务
docker-compose down

# 备份数据（邮件、配置等）
./backup_and_restore.sh backup  # 官方提供的备份脚本
```


## 7. 注意事项
- **SSL 证书**：默认使用 Let's Encrypt 自动签发证书，需确保服务器 80/443 端口可被公网访问
- **反垃圾规则**：新部署建议运行 1-2 周后根据垃圾邮件日志微调 Rspamd 规则
- **数据备份**：定期备份 `data/` 目录（邮件存储）和 `.env` 文件（配置）
- **性能优化**：高并发场景可调整 `dovecot-mailcow` 和 `postfix-mailcow` 的进程数限制（通过 `.env` 中的 `DOVECOT_PROCS` 等参数）


## 参考链接
- 官方文档：[https://mailcow.github.io/mailcow-dockerized-docs/](https://mailcow.github.io/mailcow-dockerized-docs/)
- 项目仓库：[https://github.com/mailcow/mailcow-dockerized](https://github.com/mailcow/mailcow-dockerized)

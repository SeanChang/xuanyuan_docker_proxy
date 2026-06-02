---
image: onlyoffice/4testing-documentserver
description: "ONLYOFFICE Document Server Docker镜像提供在线文档编辑与协作功能，支持端口配置、HTTPS部署及数据存储，便于快速部署和集成到各类系统中。"
source: https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver
canonical: https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver" title="onlyoffice/4testing-documentserver Docker 镜像中文简介、标签列表与拉取命令">onlyoffice/4testing-documentserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver" title="onlyoffice/4testing-documentserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver</a>

# ONLYOFFICE 文档服务器 Docker 镜像文档


## 镜像概述和主要用途

ONLYOFFICE 文档服务器（ONLYOFFICE Document Server）是一款在线办公套件，包含文本、电子表格和演示文稿的查看器与编辑器，完全兼容 Office Open XML 格式（.docx、.xlsx、.pptx），并支持实时协同编辑。

从 6.0 版本开始，文档服务器以 ONLYOFFICE Docs 名称发布，提供[三个版本](https://github.com/ONLYOFFICE/DocumentServer#onlyoffice-document-server-editions)。本镜像安装的是免费的社区版（Community Edition）。

ONLYOFFICE Docs 可作为 ONLYOFFICE Workspace 的组成部分，或与第三方同步共享解决方案（如 Nextcloud、ownCloud、Seafile 等）集成，在其界面内启用协同编辑功能。


## 核心功能和特性

### 主要编辑器
- ONLYOFFICE 文档编辑器
- ONLYOFFICE 表格编辑器
- ONLYOFFICE 演示文稿编辑器
- ONLYOFFICE 文档 iOS 应用

### 核心功能
- 实时协同编辑
- 支持象形文字
- 兼容主流格式：DOC、DOCX、TXT、ODT、RTF、ODP、EPUB、ODS、XLS、XLSX、CSV、PPTX、HTML

### 与 ONLYOFFICE 社区服务器集成扩展功能
- 查看和编辑存储在 Drive、Box、Dropbox、OneDrive、OwnCloud（已连接至 ONLYOFFICE）的文件
- 文件共享
- 文档嵌入网站
- 文档访问权限管理


## 推荐系统要求

- **内存（RAM）**：4 GB 及以上
- **CPU**：双核 2 GHz 及以上
- **交换空间（Swap）**：至少 2 GB
- **硬盘空间（HDD）**：至少 2 GB 可用空间
- **操作系统**：64 位 Red Hat、CentOS 或其他兼容发行版（内核版本 3.8+）；64 位 Debian、Ubuntu 或其他兼容发行版（内核版本 3.8+）
- **Docker**：1.9.0 及以上版本


## 运行 Docker 镜像

若需单独安装 ONLYOFFICE 文档服务器，执行以下命令：

```bash
sudo docker run -i -t -d -p 80:80 onlyoffice/documentserver
```


## 配置 Docker 镜像

### 数据存储

文档服务器的所有数据存储在以下指定目录（数据卷）：
- `/var/log/onlyoffice`：ONLYOFFICE 文档服务器日志
- `/var/www/onlyoffice/Data`：证书
- `/var/lib/onlyoffice`：文件缓存
- `/var/lib/postgresql`：数据库

如需从容器外部访问数据，需通过 `-v` 参数挂载数据卷。示例命令：

```bash
sudo docker run -i -t -d -p 80:80 \
  -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
  -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
  -v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \
  -v /app/onlyoffice/DocumentServer/rabbitmq:/var/lib/rabbitmq \
  -v /app/onlyoffice/DocumentServer/redis:/var/lib/redis \
  -v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql  onlyoffice/documentserver
```

**挂载数据卷的优势**：
- 便于访问容器数据（如日志）
- 突破容器内数据大小限制
- 与容器外服务（如 PostgreSQL、Redis、RabbitMQ）配合使用时必需


### 在不同端口运行

通过 `-p` 参数修改端口。例如，使用 8080 端口访问：

```bash
sudo docker run -i -t -d -p 8080:80 onlyoffice/documentserver
```


### 使用 HTTPS 运行

#### 基本命令

```bash
sudo docker run -i -t -d -p 443:443 \
  -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  onlyoffice/documentserver
```

HTTPS 访问需准备：
- 私钥（.key）
- SSL 证书（.crt）

证书文件需放置在宿主机的以下路径（挂载至容器内 `/var/www/onlyoffice/Data/certs`）：
```
/app/onlyoffice/DocumentServer/data/certs/tls.key
/app/onlyoffice/DocumentServer/data/certs/tls.crt
```

CA 颁发的证书（如 Let's Encrypt）可直接使用；自签名证书需手动生成。


#### 使用 Let's Encrypt 自动生成 SSL 证书

通过环境变量自动获取和续期 Let's Encrypt 证书：

```bash
sudo docker run -i -t -d -p 443:443 \
  -e LETS_ENCRYPT_DOMAIN=your_domain -e LETS_ENCRYPT_MAIL=your_mail  onlyoffice/documentserver
```


#### 生成自签名证书

**步骤 1：创建服务器私钥**
```bash
openssl genrsa -out tls.key 2048
```

**步骤 2：创建证书签名请求（CSR）**
```bash
openssl req -new -key tls.key -out tls.csr
```

**步骤 3：使用私钥和 CSR 签名证书（有效期 365 天）**
```bash
openssl x509 -req -days 365 -in tls.csr -signkey tls.key -out tls.crt
```


#### 加强服务器安全性

生成更强的 DHE 参数：
```bash
openssl dhparam -out dhparam.pem 2048
```


#### 安装 SSL 证书

将 `tls.key`、`tls.crt` 和 `dhparam.pem` 复制到宿主机证书目录，并设置权限：
```bash
mkdir -p /app/onlyoffice/DocumentServer/data/certs
cp tls.key /app/onlyoffice/DocumentServer/data/certs/
cp tls.crt /app/onlyoffice/DocumentServer/data/certs/
cp dhparam.pem /app/onlyoffice/DocumentServer/data/certs/
chmod 400 /app/onlyoffice/DocumentServer/data/certs/tls.key
```


#### 可用配置参数

以下环境变量可通过 `docker run -e` 或 `--env-file` 指定：

| 参数名称 | 说明 | 默认值 |
|----------|------|--------|
| **ONLYOFFICE_HTTPS_HSTS_ENABLED** | 启用/禁用 HSTS 配置（仅 SSL 模式） | `true` |
| **ONLYOFFICE_HTTPS_HSTS_MAXAGE** | HSTS 最大有效期（秒） | `31536000` |
| **SSL_CERTIFICATE_PATH** | SSL 证书路径 | `/var/www/onlyoffice/Data/certs/tls.crt` |
| **SSL_KEY_PATH** | 私钥路径 | `/var/www/onlyoffice/Data/certs/tls.key` |
| **SSL_DHPARAM_PATH** | Diffie-Hellman 参数路径 | `/var/www/onlyoffice/Data/certs/dhparam.pem` |
| **SSL_VERIFY_CLIENT** | 启用客户端证书验证（需 CA 证书） | `false` |
| **DB_TYPE** | 数据库类型（`postgres`/`mariadb`/`mysql`） | `postgres` |
| **DB_HOST** | 数据库主机地址 | - |
| **DB_PORT** | 数据库端口 | - |
| **DB_NAME** | 数据库名称 | - |
| **DB_USER** | 数据库用户名 | - |
| **DB_PWD** | 数据库密码 | - |
| **AMQP_URI** | 消息代理连接 URI（RabbitMQ/ActiveMQ） | - |
| **AMQP_TYPE** | 消息代理类型（`rabbitmq`/`activemq`） | `rabbitmq` |
| **REDIS_SERVER_HOST** | Redis 服务器地址 | - |
| **REDIS_SERVER_PORT** | Redis 端口 | - |
| **NGINX_WORKER_PROCESSES** | Nginx 工作进程数 | - |
| **NGINX_WORKER_CONNECTIONS** | Nginx 单进程最大连接数 | - |
| **JWT_ENABLED** | 启用 JWT 验证 | `false` |
| **JWT_SECRET** | JWT 密钥 | `secret` |
| **JWT_HEADER** | 传递 JWT 的 HTTP 头 | `Authorization` |
| **JWT_IN_BODY** | 启用请求体中的 JWT 验证 | `false` |
| **USE_UNAUTHORIZED_STORAGE** | 允许自签名证书的存储服务器（如 Nextcloud） | `false` |
| **GENERATE_FONTS** | 启动时重新生成字体列表和缩略图 | `true` |
| **METRICS_ENABLED** | 启用 StatsD 指标收集 | `false` |
| **METRICS_HOST** | StatsD 主机 | `localhost` |
| **METRICS_PORT** | StatsD 端口 | `8125` |
| **METRICS_PREFIX** | 指标前缀 | `ds.` |
| **LETS_ENCRYPT_DOMAIN** | Let's Encrypt 域名 | - |
| **LETS_ENCRYPT_MAIL** | Let's Encrypt 邮箱 | - |


## 与社区和邮件服务器集成安装

ONLYOFFICE 文档服务器可与社区服务器、邮件服务器组成 ONLYOFFICE Community Edition。


### 手动安装步骤

**步骤 1：创建 Docker 网络**
```bash
docker network create --driver bridge onlyoffice
```

**步骤 2：安装 MySQL**  
参考 [MySQL 安装指南](https://dev.mysql.com/doc/refman/en/docker-mysql-getting-started.html)。

**步骤 3：安装文档服务器**
```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-document-server \
  -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
  -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
  -v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \
  -v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql \
  onlyoffice/documentserver
```

**步骤 4：安装邮件服务器**  
需指定主机名 `yourdomain.com`：
```bash
sudo docker run --init --net onlyoffice --privileged -i -t -d --restart=always --name onlyoffice-mail-server -p 25:25 -p 143:143 -p 587:587 \
  -e MYSQL_SERVER=onlyoffice-mysql-server \
  -e MYSQL_SERVER_PORT=3306 \
  -e MYSQL_ROOT_USER=root \
  -e MYSQL_ROOT_PASSWD=my-secret-pw \
  -e MYSQL_SERVER_DB_NAME=onlyoffice_mailserver \
  -v /app/onlyoffice/MailServer/data:/var/vmail \
  -v /app/onlyoffice/MailServer/data/certs:/etc/pki/tls/mailserver \
  -v /app/onlyoffice/MailServer/logs:/var/log \
  -h yourdomain.com \
  onlyoffice/mailserver
```

**步骤 5：安装社区服务器**  
替换 `${MAIL_SERVER_IP}` 为邮件服务器 IP（通过 `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' onlyoffice-mail-server` 获取）：
```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-community-server -p 80:80 -p 443:443 -p 5222:5222 \
  -e MYSQL_SERVER_ROOT_PASSWORD=my-secret-pw \
  -e MYSQL_SERVER_DB_NAME=onlyoffice \
  -e MYSQL_SERVER_HOST=onlyoffice-mysql-server \
  -e MYSQL_SERVER_USER=onlyoffice_user \
  -e MYSQL_SERVER_PASS=onlyoffice_pass \
  -e DOCUMENT_SERVER_PORT_80_TCP_ADDR=onlyoffice-document-server \
  -e MAIL_SERVER_API_HOST=${MAIL_SERVER_IP} \
  -e MAIL_SERVER_DB_HOST=onlyoffice-mysql-server \
  -e MAIL_SERVER_DB_NAME=onlyoffice_mailserver \
  -e MAIL_SERVER_DB_PORT=3306 \
  -e MAIL_SERVER_DB_USER=root \
  -e MAIL_SERVER_DB_PASS=my-secret-pw \
  -v /app/onlyoffice/CommunityServer/data:/var/www/onlyoffice/Data \
  -v /app/onlyoffice/CommunityServer/logs:/var/log/onlyoffice \
  onlyoffice/communityserver
```


### 自动安装

**使用脚本安装**：
```bash
wget https://download.onlyoffice.com/install/opensource-install.sh
bash opensource-install.sh -md yourdomain.com
```

**使用 docker-compose**：
```bash
wget https://raw.githubusercontent.com/ONLYOFFICE/Docker-CommunityServer/master/docker-compose.yml
docker-compose up -d
```


## 问题

### Docker 问题
- **推荐使用最新版 Docker**：Docker 仍在活跃开发中，新版本可能已修复已知问题。
- **RPM 发行版 SELinux 问题**：Fedora/RHEL/CentOS 用户若容器内进程启动失败，可尝试 `setenforce 0` 临时禁用 SELinux，或切换至 Ubuntu。


### 文档服务器使用问题
文档服务器仅在所有编辑用户关闭文档后保存更改。更新或重启前需强制断开用户连接，执行：
```bash
sudo docker exec <容器ID> documentserver-prepare4shutdown.sh
```
（断开用户可能需要 5 分钟）


## 项目信息

- **官方网站**：[https://www.onlyoffice.com](https://www.onlyoffice.com/?utm_source=github&utm_medium=cpc&utm_campaign=GitHubDockerDS)
- **代码仓库**：[https://github.com/ONLYOFFICE/DocumentServer](https://github.com/ONLYOFFICE/DocumentServer)
- **Docker 镜像**：[https://github.com/ONLYOFFICE/Docker-DocumentServer](https://github.com/ONLYOFFICE/Docker-DocumentServer)
- **许可证**：[GNU AGPL v3.0](https://help.onlyoffice.com/products/files/doceditor.aspx?fileid=4358397&doc=K0ZUdlVuQzQ0RFhhMzhZRVN4ZFIvaHlhUjN2eS9XMXpKR1M5WEppUk1Gcz0_IjQzNTgzOTci0)
- **版本对比**：[免费版 vs 商业版](https://github.com/ONLYOFFICE/DocumentServer#onlyoffice-document-server-editions)
- **SaaS 版本**：[https://www.onlyoffice.com/cloud-office.aspx](https://www.onlyoffice.com/cloud-office.aspx?utm_source=github&utm_medium=cpc&utm_campaign=GitHubDockerDS)


## 用户反馈和支持

- **官方论坛**：[dev.onlyoffice.org](https://dev.onlyoffice.org)
- **Stack Overflow**：[tagged/onlyoffice](https://stackoverflow.com/questions/tagged/onlyoffice)

---
image: onlyoffice/4testing-documentserver-de
description: "ONLYOFFICE开发者版的测试资源库，供开发者测试相关功能使用。"
source: https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver-de
canonical: https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver-de
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/onlyoffice/4testing-documentserver-de" title="onlyoffice/4testing-documentserver-de Docker 镜像中文简介、标签列表与拉取命令">onlyoffice/4testing-documentserver-de 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ONLYOFFICE Document Server Docker镜像文档


## 镜像概述

ONLYOFFICE Document Server 是一款在线办公套件，包含文本、电子表格和演示文稿的查看器与编辑器，完全兼容 Office Open XML 格式（.docx、.xlsx、.pptx），并支持实时协作编辑功能。


## 核心功能与特性

### 主要编辑器
- ONLYOFFICE 文档编辑器
- ONLYOFFICE 电子表格编辑器
- ONLYOFFICE 演示文稿编辑器
- ONLYOFFICE 文档 iOS 应用

### 协作与兼容性
- 实时协作编辑
- 支持象形文字
- 兼容主流文档格式：DOC、DOCX、TXT、ODT、RTF、ODP、EPUB、ODS、XLS、XLSX、CSV、PPTX、HTML

### 与社区服务器集成扩展功能
与 ONLYOFFICE Community Server 集成后，可实现：
- 查看和编辑存储在 Drive、Box、Dropbox、OneDrive、OwnCloud 等连接到 ONLYOFFICE 的文件
- 文件共享与权限管理
- 文档嵌入网站功能
- 精细化文档访问权限控制


## 推荐系统要求

- **内存（RAM）**：4 GB 及以上
- **CPU**：双核 2 GHz 及以上
- **交换空间（Swap）**：至少 2 GB
- **硬盘空间（HDD）**：至少 2 GB 可用空间
- **操作系统**：64 位 Red Hat、CentOS 或其他兼容发行版（内核 3.8+）；64 位 Debian、Ubuntu 或其他兼容发行版（内核 3.8+）
- **Docker**：1.9.0 及以上版本


## 使用方法与配置说明

### 基础运行命令

如需单独安装 ONLYOFFICE Document Server，执行以下命令：

```bash
sudo docker run -i -t -d -p 80:80 onlyoffice/documentserver
```


### 数据持久化配置

容器数据存储在以下指定目录（数据卷）：
- `/var/log/onlyoffice`：Document Server 日志
- `/var/www/onlyoffice/Data`：证书文件
- `/var/lib/onlyoffice`：文件缓存
- `/var/lib/postgresql`：数据库文件

通过 `-v` 参数挂载宿主机目录实现数据持久化：

```bash
sudo docker run -i -t -d -p 80:80 \
  -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \  # 日志目录
  -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \  # 证书目录
  -v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \  # 缓存目录
  -v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql  \  # 数据库目录
  onlyoffice/documentserver
```

**数据持久化适用场景**：
- 需要便捷访问容器日志
- 突破容器内数据大小限制
- 与外部服务（如 PostgreSQL、Redis）集成时


### 自定义端口运行

通过 `-p` 参数指定宿主机端口（格式：`宿主机端口:容器端口`），例如使用 8080 端口访问：

```bash
sudo docker run -i -t -d -p 8080:80 onlyoffice/documentserver
```


### HTTPS 安全配置

通过 HTTPS 访问需挂载证书目录并映射 443 端口：

```bash
sudo docker run -i -t -d -p 443:443 \
  -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
  onlyoffice/documentserver
```

#### 必要文件
实现 HTTPS 需准备：
- 私钥文件（.key）
- SSL 证书文件（.crt）

证书文件需放置在宿主机目录 `/app/onlyoffice/DocumentServer/data/certs/`，文件名为：
- `onlyoffice.key`（私钥）
- `onlyoffice.crt`（证书）


#### 自签名证书生成（适用于测试环境）
若无需 CA 认证证书，可按以下步骤生成自签名证书：

**步骤 1：生成服务器私钥**
```bash
openssl genrsa -out onlyoffice.key 2048
```

**步骤 2：生成证书签名请求（CSR）**
```bash
openssl req -new -key onlyoffice.key -out onlyoffice.csr
```

**步骤 3：使用私钥和 CSR 签名证书（有效期 365 天）**
```bash
openssl x509 -req -days 365 -in onlyoffice.csr -signkey onlyoffice.key -out onlyoffice.crt
```


#### 服务器安全增强
生成 Diffie-Hellman 参数提升安全性：
```bash
openssl dhparam -out dhparam.pem 2048
```


#### 证书安装
将生成的 `onlyoffice.key`、`onlyoffice.crt` 和 `dhparam.pem` 复制到宿主机证书目录，并设置权限：

```bash
mkdir -p /app/onlyoffice/DocumentServer/data/certs
cp onlyoffice.key /app/onlyoffice/DocumentServer/data/certs/
cp onlyoffice.crt /app/onlyoffice/DocumentServer/data/certs/
cp dhparam.pem /app/onlyoffice/DocumentServer/data/certs/
chmod 400 /app/onlyoffice/DocumentServer/data/certs/onlyoffice.key  # 限制私钥访问权限
```


#### 配置参数说明
通过环境变量自定义 HTTPS 及服务配置，支持以下参数：

| 参数名                          | 描述                                                                 | 默认值                                      |
|---------------------------------|----------------------------------------------------------------------|---------------------------------------------|
| ONLYOFFICE_HTTPS_HSTS_ENABLED   | 是否启用 HSTS 配置（仅 HTTPS 模式）                                  | `true`                                      |
| ONLYOFFICE_HTTPS_HSTS_MAXAGE    | HSTS 缓存时长（秒，仅 HTTPS 模式）                                   | `31536000`（1 年）                          |
| SSL_CERTIFICATE_PATH            | SSL 证书路径                                                         | `/var/www/onlyoffice/Data/certs/onlyoffice.crt` |
| SSL_KEY_PATH                    | 私钥路径                                                             | `/var/www/onlyoffice/Data/certs/onlyoffice.key` |
| SSL_DHPARAM_PATH                | Diffie-Hellman 参数路径                                              | `/var/www/onlyoffice/Data/certs/dhparam.pem` |
| SSL_VERIFY_CLIENT               | 是否验证客户端证书（需配合 CA_CERTIFICATES_PATH）                    | `false`                                     |
| POSTGRESQL_SERVER_HOST          | 外部 PostgreSQL 服务器地址                                           | -                                           |
| POSTGRESQL_SERVER_PORT          | 外部 PostgreSQL 端口                                                 | -                                           |
| POSTGRESQL_SERVER_DB_NAME       | PostgreSQL 数据库名                                                  | -                                           |
| POSTGRESQL_SERVER_USER          | PostgreSQL 用户名                                                    | -                                           |
| POSTGRESQL_SERVER_PASS          | PostgreSQL 密码                                                      | -                                           |
| RABBITMQ_SERVER_URL             | RabbitMQ 服务器 AMQP 连接 URL                                        | -                                           |
| REDIS_SERVER_HOST               | Redis 服务器地址                                                     | -                                           |
| REDIS_SERVER_PORT               | Redis 端口                                                           | -                                           |
| NGINX_WORKER_PROCESSES          | Nginx 工作进程数                                                     | -                                           |
| NGINX_WORKER_CONNECTIONS        | 单个 Nginx 进程最大连接数                                            | -                                           |
| JWT_ENABLED                     | 是否启用 JWT 验证                                                   | `false`                                     |
| JWT_SECRET                      | JWT 验证密钥                                                         | `secret`                                    |
| JWT_HEADER                      | 传递 JWT 的 HTTP 头字段                                             | `Authorization`                             |


## 与社区服务器及邮件服务器集成部署

### 前提条件
- 创建专用 Docker 网络：
  ```bash
  docker network create --driver bridge onlyoffice
  ```


### 部署步骤

#### 步骤 1：安装 MySQL 服务器
参考 [MySQL 官方 Docker 文档](https://hub.docker.com/_/mysql) 部署 MySQL。


#### 步骤 2：部署 Document Server
```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-document-server \
  -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
  -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
  -v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \
  -v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql \
  onlyoffice/documentserver
```


#### 步骤 3：部署 Mail Server
需指定邮件服务器域名（`yourdomain.com`）：
```bash
sudo docker run --init --net onlyoffice --privileged -i -t -d --restart=always --name onlyoffice-mail-server \
  -p 25:25 -p 143:143 -p 587:587 \
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


#### 步骤 4：部署 Community Server
```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-community-server \
  -p 80:80 -p 443:443 -p 5222:5222 \
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

**获取邮件服务器 IP**：
```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' onlyoffice-mail-server
```


### 一键部署脚本
使用官方脚本快速部署完整社区版：
```bash
# 下载脚本
wget http://download.onlyoffice.com/install/opensource-install.sh
# 执行安装（替换 yourdomain.com 为实际域名）
bash opensource-install.sh -md yourdomain.com
```


## 常见问题

### Docker 相关问题
- **问题**：RPM 系发行版（如 CentOS、Fedora）容器内进程启动失败。  
  **解决**：尝试临时禁用 SELinux：`setenforce 0`，或更换为 Ubuntu 系统。  
  **说明**：Docker 对 SELinux 的支持仍在优化中，禁用 SELinux 可能带来安全风险，建议生产环境使用 Ubuntu。


## 项目信息

- **官方网站**：[http://www.onlyoffice.org](http://www.onlyoffice.org)
- **代码仓库**：
  - Document Server：[https://github.com/ONLYOFFICE/DocumentServer](https://github.com/ONLYOFFICE/DocumentServer)
  - Docker 镜像：[https://github.com/ONLYOFFICE/Docker-DocumentServer](https://github.com/ONLYOFFICE/Docker-DocumentServer)
- **许可证**：GNU AGPL v3.0
- **SaaS 版本**：[http://www.onlyoffice.com](http://www.onlyoffice.com)


## 用户反馈与支持

- 官方论坛：[dev.onlyoffice.org](http://dev.onlyoffice.org)
- Stack Overflow：使用 `onlyoffice` 标签提问或解答问题

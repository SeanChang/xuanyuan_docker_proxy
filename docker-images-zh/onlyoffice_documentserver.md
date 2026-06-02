---
image: onlyoffice/documentserver
description: "功能丰富的基于Web的办公套件，具备广泛的协作功能。"
source: https://xuanyuan.cloud/zh/r/onlyoffice/documentserver
canonical: https://xuanyuan.cloud/zh/r/onlyoffice/documentserver
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/onlyoffice/documentserver" title="onlyoffice/documentserver Docker 镜像中文简介、标签列表与拉取命令">onlyoffice/documentserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/onlyoffice/documentserver" title="onlyoffice/documentserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/onlyoffice/documentserver</a>

# ONLYOFFICE Document Server Docker 镜像文档


## 概述

ONLYOFFICE Document Server 是一款在线办公套件，包含文本、电子表格和演示文稿的查看器与编辑器，完全兼容 Office Open XML 格式（.docx、.xlsx、.pptx），并支持实时协作编辑。作为功能丰富的基于 Web 的办公套件，其具备广泛的协作能力，可满足团队在线文档处理需求。


## 核心功能和特性

### 主要编辑器
- ONLYOFFICE 文档编辑器
- ONLYOFFICE 电子表格编辑器
- ONLYOFFICE 演示文稿编辑器
- ONLYOFFICE 文档 iOS 应用

### 核心功能
- 实时协作编辑
- 象形文字支持
- 兼容主流格式：DOC、DOCX、TXT、ODT、RTF、ODP、EPUB、ODS、XLS、XLSX、CSV、PPTX、HTML

### 与 ONLYOFFICE Community Server 集成扩展功能
- 查看和编辑存储在 Drive、Box、Dropbox、OneDrive、OwnCloud（已连接至 ONLYOFFICE）中的文件
- 文件共享
- 在网站上嵌入文档
- 管理文档访问权限


## 推荐系统要求

- **内存（RAM）**：4 GB 或更高
- **CPU**：双核 2 GHz 或更高
- **交换文件（Swap）**：至少 2 GB
- **硬盘空间（HDD）**：至少 2 GB 可用空间
- **操作系统**：64 位 Red Hat、CentOS 或其他兼容发行版（内核版本 3.8 或更高）；64 位 Debian、Ubuntu 或其他兼容发行版（内核版本 3.8 或更高）
- **Docker**：1.9.0 或更高版本


## 使用方法和配置说明

### 运行 Docker 镜像

若需单独安装 ONLYOFFICE Document Server，执行以下命令：

```bash
sudo docker run -i -t -d -p 80:80 onlyoffice/documentserver
```

### 配置 Docker 镜像

#### 数据存储

所有数据存储在专用数据卷中，路径如下：
- `/var/log/onlyoffice`：ONLYOFFICE Document Server 日志
- `/var/www/onlyoffice/Data`：证书等数据

如需从容器外部访问数据，需通过 `-v` 选项挂载卷：

```bash
sudo docker run -i -t -d -p 80:80 \
    -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
    onlyoffice/documentserver
```

将数据存储在主机上可确保更新镜像时数据不丢失。

#### 修改运行端口

通过 `-p` 参数指定端口映射，例如使用 8080 端口访问服务：

```bash
sudo docker run -i -t -d -p 8080:80 onlyoffice/documentserver
```

#### 配置 HTTPS 访问

通过以下命令运行启用 HTTPS 的容器（需提前准备证书）：

```bash
sudo docker run -i -t -d -p 443:443 \
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
    onlyoffice/documentserver
```

HTTPS 配置需准备：
- 私钥（.key）
- SSL 证书（.crt）

证书文件需放置在主机路径 `/app/onlyoffice/DocumentServer/data/certs/` 下，文件名为：
- `onlyoffice.key`（私钥）
- `onlyoffice.crt`（证书）

##### 生成自签名证书

若无需 CA 认证证书，可自行生成自签名证书，步骤如下：

**步骤 1：生成服务器私钥**
```bash
openssl genrsa -out onlyoffice.key 2048
```

**步骤 2：创建证书签名请求（CSR）**
```bash
openssl req -new -key onlyoffice.key -out onlyoffice.csr
```

**步骤 3：使用私钥和 CSR 签名证书（有效期 365 天）**
```bash
openssl x509 -req -days 365 -in onlyoffice.csr -signkey onlyoffice.key -out onlyoffice.crt
```

##### 加强服务器安全性

生成更强的 DHE 参数：
```bash
openssl dhparam -out dhparam.pem 2048
```

##### 安装 SSL 证书

将生成的 `onlyoffice.key`、`onlyoffice.crt` 和 `dhparam.pem` 复制到证书目录，并设置权限：

```bash
mkdir -p /app/onlyoffice/DocumentServer/data/certs
cp onlyoffice.key /app/onlyoffice/DocumentServer/data/certs/
cp onlyoffice.crt /app/onlyoffice/DocumentServer/data/certs/
cp dhparam.pem /app/onlyoffice/DocumentServer/data/certs/
chmod 400 /app/onlyoffice/DocumentServer/data/certs/onlyoffice.key
```

##### 可用配置参数

可通过环境变量自定义配置（推荐使用 `--env-file` 传入）：

| 参数                     | 说明                                                                 | 默认值                                      |
|--------------------------|----------------------------------------------------------------------|---------------------------------------------|
| ONLYOFFICE_HTTPS_HSTS_ENABLED | 启用/禁用 HSTS 配置（仅 SSL 模式下生效）                            | `true`                                      |
| ONLYOFFICE_HTTPS_HSTS_MAXAGE  | HSTS 配置的 max-age 值（仅 SSL 模式下生效）                         | `31536000`（秒）                            |
| SSL_CERTIFICATE_PATH     | SSL 证书路径                                                         | `/var/www/onlyoffice/Data/certs/onlyoffice.crt` |
| SSL_KEY_PATH             | 私钥路径                                                             | `/var/www/onlyoffice/Data/certs/onlyoffice.key` |
| SSL_DHPARAM_PATH         | Diffie-Hellman 参数路径                                              | `/var/www/onlyoffice/Data/certs/dhparam.pem` |
| SSL_VERIFY_CLIENT        | 启用客户端证书验证（需通过 `CA_CERTIFICATES_PATH` 指定 CA 证书）     | `false`                                     |


## 集成 Community Server 和 Mail Server 安装

ONLYOFFICE Document Server 可与 Community Server 和 Mail Server 组成 ONLYOFFICE Community Edition。安装步骤如下：

### 步骤 1：创建 `onlyoffice` 网络

```bash
docker network create --driver bridge onlyoffice
```

### 步骤 2：安装 Document Server

```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-document-server \
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data \
    -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice \
    onlyoffice/documentserver
```

### 步骤 3：安装 Mail Server

需指定主机名（如 `yourdomain.com`）：

```bash
sudo docker run --net onlyoffice --privileged -i -t -d --restart=always --name onlyoffice-mail-server \
    -p 25:25 -p 143:143 -p 587:587 \
    -v /app/onlyoffice/MailServer/data:/var/vmail \
    -v /app/onlyoffice/MailServer/data/certs:/etc/pki/tls/mailserver \
    -v /app/onlyoffice/MailServer/logs:/var/log \
    -v /app/onlyoffice/MailServer/mysql:/var/lib/mysql \
    -h yourdomain.com \
    onlyoffice/mailserver
```

### 步骤 4：安装 Community Server

```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-community-server \
    -p 80:80 -p 5222:5222 -p 443:443 \
    -v /app/onlyoffice/CommunityServer/data:/var/www/onlyoffice/Data \
    -v /app/onlyoffice/CommunityServer/mysql:/var/lib/mysql \
    -v /app/onlyoffice/CommunityServer/logs:/var/log/onlyoffice \
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/DocumentServerData \
    -e DOCUMENT_SERVER_PORT_80_TCP_ADDR=onlyoffice-document-server \
    -e MAIL_SERVER_DB_HOST=onlyoffice-mail-server \
    onlyoffice/communityserver
```

### 自动安装脚本

通过脚本一键安装 Community Edition（需指定 Mail Server 主机名）：

```bash
wget http://download.onlyoffice.com/install/opensource-install.sh
bash opensource-install.sh -md yourdomain.com
```

### Docker Compose 安装

```bash
wget https://raw.githubusercontent.com/ONLYOFFICE/Docker-CommunityServer/master/docker-compose.yml
docker-compose up -d
```


## 常见问题

### Docker 问题

建议使用最新版 Docker，以避免已知问题。对于基于 RPM 的发行版（如 Fedora、RHEL/CentOS），可能出现容器内进程启动失败问题，可尝试临时关闭 SELinux：

```bash
setenforce 0
```

若问题解决，可选择禁用 SELinux（不推荐）或更换为 Ubuntu 系统。

### Mono 问题

ONLYOFFICE 依赖 Mono（推荐版本 3.12.1 或更早），部分 Linux 内核版本可能存在兼容性问题，支持的内核版本列表见 [官方文档](http://onlyo.co/1PABPEI)。


## 项目信息

- 官方网站：[http://www.onlyoffice.org](http://www.onlyoffice.org)
- 代码仓库：[https://github.com/ONLYOFFICE/DocumentServer](https://github.com/ONLYOFFICE/DocumentServer)
- Docker 镜像：[https://github.com/ONLYOFFICE/Docker-DocumentServer](https://github.com/ONLYOFFICE/Docker-DocumentServer)
- 许可证：[GNU AGPL v3.0](https://help.onlyoffice.com/products/files/doceditor.aspx?fileid=4358397&doc=K0ZUdlVuQzQ0RFhhMzhZRVN4ZFIvaHlhUjN2eS9XMXpKR1M5WEppUk1Gcz0_IjQzNTgzOTci0)
- SaaS 版本：[http://www.onlyoffice.com](http://www.onlyoffice.com)


## 用户反馈与支持

如遇问题或有疑问，请通过 [dev.onlyoffice.org](http://dev.onlyoffice.org) 联系我们。

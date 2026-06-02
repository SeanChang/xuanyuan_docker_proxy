<!-- xuanyuan-docker-images-zh
image: onlyoffice/documentserver-de
source: https://xuanyuan.cloud/zh/r/onlyoffice/documentserver-de
canonical: https://xuanyuan.cloud/zh/r/onlyoffice/documentserver-de
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/onlyoffice/documentserver-de" title="onlyoffice/documentserver-de Docker 镜像中文简介、标签列表与拉取命令">onlyoffice/documentserver-de — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/onlyoffice/documentserver-de" title="onlyoffice/documentserver-de Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/onlyoffice/documentserver-de</a></p>

# ONLYOFFICE Document Server 中文使用指南


## 概述  
ONLYOFFICE Document Server 是一款在线办公套件，包含文本、表格、演示文稿的查看器与编辑器，完全兼容 Office Open XML 格式（.docx、.xlsx、.pptx），支持实时协作编辑。


## 功能特性  
### 核心功能  
- ONLYOFFICE 文档编辑器  
- ONLYOFFICE 表格编辑器  
- ONLYOFFICE 演示文稿编辑器  
- ONLYOFFICE Documents iOS 应用  
- 实时协作编辑  
- 多字符支持  
- 兼容主流格式：DOC、DOCX（文档）、TXT（文本）、ODT（开放文档）、RTF（富文本）、ODP（开放演示文稿）、EPUB（电子书）、ODS（开放表格）、XLS、XLSX（表格）、CSV（逗号分隔值）、PPTX（演示文稿）、HTML（网页）  

### 与 Community Server 集成后可实现  
- 查看/编辑存储在 Drive、Box、Dropbox、OneDrive、OwnCloud 等已连接云存储中的文件  
- 文件共享  
- 文档嵌入网站  
- 管理文档访问权限  


## 推荐系统配置  
- **内存（RAM）**：4 GB 及以上  
- **CPU**：双核 2 GHz 及以上  
- **交换空间（Swap）**：至少 2 GB  
- **硬盘（HDD）**：至少 2 GB 可用空间  
- **操作系统**：64 位 Red Hat、CentOS 或兼容发行版（内核 3.8 及以上）；64 位 Debian、Ubuntu 或兼容发行版（内核 3.8 及以上）  
- **Docker**：1.9.0 及以上版本  


## 运行 Docker 镜像  
若需单独安装 ONLYOFFICE Document Server，执行以下命令：  
```bash  
sudo docker run -i -t -d -p 80:80 onlyoffice/documentserver  
```  


## 配置 Docker 镜像  

### 数据存储  
容器数据默认存储在以下**数据卷**目录：  
- `/var/log/onlyoffice`：Document Server 日志  
- `/var/www/onlyoffice/Data`：证书文件  
- `/var/lib/onlyoffice`：文件缓存  
- `/var/lib/postgresql`：数据库  

若需从容器外部访问数据，需挂载数据卷，通过 `-v` 参数指定本地路径与容器路径映射。示例命令：  
```bash  
sudo docker run -i -t -d -p 80:80 \  
    -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \  
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \  
    -v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \  
    -v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql  onlyoffice/documentserver  
```  

**挂载数据卷的作用**：  
- 方便访问容器数据（如日志）  
- 突破容器内数据大小限制  
- 配合容器外服务（如 PostgreSQL、Redis、RabbitMQ）使用  


### 修改访问端口  
通过 `-p` 参数指定端口映射，例如通过 8080 端口访问：  
```bash  
sudo docker run -i -t -d -p 8080:80 onlyoffice/documentserver  
```  


### 启用 HTTPS 访问  
执行以下命令启动 HTTPS 服务（默认映射 443 端口）：  
```bash  
sudo docker run -i -t -d -p 443:443 \  
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  onlyoffice/documentserver  
```  

#### 准备 SSL 证书  
需准备以下文件（放置于 `/app/onlyoffice/DocumentServer/data/certs/` 目录）：  
- 私钥：`onlyoffice.key`  
- SSL 证书：`onlyoffice.crt`  

若使用 CA 颁发的证书，直接将文件放入目录；若使用自签名证书，需手动生成（步骤如下）。  


#### 生成自签名证书（三步法）  
**步骤 1：创建服务器私钥**  
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


#### 加强服务器安全性  
生成强 Diffie-Hellman 参数：  
```bash  
openssl dhparam -out dhparam.pem 2048  
```  


#### 安装 SSL 证书  
1. 创建证书目录并复制文件：  
```bash  
mkdir -p /app/onlyoffice/DocumentServer/data/certs  
cp onlyoffice.key /app/onlyoffice/DocumentServer/data/certs/  
cp onlyoffice.crt /app/onlyoffice/DocumentServer/data/certs/  
cp dhparam.pem /app/onlyoffice/DocumentServer/data/certs/  
```  

2. 限制私钥权限（仅所有者可读）：  
```bash  
chmod 400 /app/onlyoffice/DocumentServer/data/certs/onlyoffice.key  
```  


#### 可用配置参数  
通过环境变量自定义 SSL 配置（可写入 `.env` 文件，使用 `--env-file` 加载）：  

| 参数                     | 说明                                                                 | 默认值                                  |  
|--------------------------|----------------------------------------------------------------------|-----------------------------------------|  
| ONLYOFFICE_HTTPS_HSTS_ENABLED | 是否启用 HSTS（仅 SSL 模式）                                        | true                                    |  
| ONLYOFFICE_HTTPS_HSTS_MAXAGE  | HSTS 有效期（秒）                                                   | 31536000（1 年）                        |  
| SSL_CERTIFICATE_PATH     | SSL 证书路径                                                        | /var/www/onlyoffice/Data/certs/onlyoffice.crt |  
| SSL_KEY_PATH             | 私钥路径                                                            | /var/www/onlyoffice/Data/certs/onlyoffice.key |  
| SSL_DHPARAM_PATH         | Diffie-Hellman 参数路径                                             | /var/www/onlyoffice/Data/certs/dhparam.pem |  
| JWT_ENABLED              | 是否启用 JWT 验证                                                  | false                                   |  
| JWT_SECRET               | JWT 密钥                                                           | secret                                  |  


## 集成 Community Server 和 Mail Server  
ONLYOFFICE Document Server 可与 Community Server、Mail Server 集成，组成完整社区版套件，步骤如下：  

### 步骤 1：创建 onlyoffice 网络  
```bash  
docker network create --driver bridge onlyoffice  
```  


### 步骤 2：安装 MySQL  
按常规步骤安装 MySQL 服务器（需记录 root 密码、数据库名等信息）。  


### 步骤 3：安装 Document Server  
```bash  
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-document-server \  
    -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \  
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \  
    -v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \  
    -v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql \  
    onlyoffice/documentserver  
```  


### 步骤 4：安装 Mail Server  
指定主机名（如 `yourdomain.com`）：  
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


### 步骤 5：安装 Community Server  
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

**获取邮件服务器 IP**：  
```bash  
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' onlyoffice-mail-server  
```  


### 自动安装脚本（推荐）  
通过脚本一键安装完整社区版（需指定邮件服务器主机名）：  
```bash  
# 下载脚本  
wget []  
# 执行安装（替换 yourdomain.com 为实际域名）  
bash opensource-install.sh -md yourdomain.com  
```  


## 常见问题  

### Docker 问题  
- **建议使用最新版 Docker**：Docker 仍在活跃开发，新版本可能修复已知问题。  
- **RPM 系发行版进程启动失败**：Fedora/CentOS 用户可尝试临时禁用 SELinux（`setenforce 0`），若解决问题，建议切换至 Ubuntu 系统（SELinux 禁用不推荐）。  


### Mono 问题  
- 依赖 Mono 环境（推荐 3.12.1 或更早版本），部分 Linux 内核版本可能不兼容，兼容内核列表见 [官方文档]([])。  


## 项目信息  
- **官网**：[[]]([])  
- **代码仓库**：[[]]([])  
- **Docker 镜像**：[[]]([])  
- **许可证**：GNU AGPL v3.0  
- **SaaS 版本**：[[]]([])  


## 用户反馈与支持  
- 官方论坛：[dev.onlyoffice.org]([])  
- Stack Overflow：使用标签 [onlyoffice]([]) 提问

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/onlyoffice/documentserver-de" title="onlyoffice/documentserver-de Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/onlyoffice/documentserver-de</a></p>

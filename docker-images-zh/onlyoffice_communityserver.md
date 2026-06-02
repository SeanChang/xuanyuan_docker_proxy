---
image: onlyoffice/communityserver
description: "这是一款集成化的一站式协作系统，可在单一平台内集中管理文档、项目、客户关系及邮件，支持团队成员实时协作，有效整合各类信息资源，避免多平台切换的繁琐，简化工作流程，助力提升团队整体办公效率与协同效果。"
source: https://xuanyuan.cloud/zh/r/onlyoffice/communityserver
canonical: https://xuanyuan.cloud/zh/r/onlyoffice/communityserver
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/onlyoffice/communityserver" title="onlyoffice/communityserver Docker 镜像中文简介、标签列表与拉取命令">onlyoffice/communityserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/onlyoffice/communityserver" title="onlyoffice/communityserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/onlyoffice/communityserver</a>

# ONLYOFFICE Community Server 中文安装与配置指南


## 概述  
ONLYOFFICE Community Server 是一款免费开源协作系统，集成文档管理、项目管理、客户关系管理（CRM）及邮件通信功能于一体。自11.0版本起，该系统以ONLYOFFICE Groups名义发布，遵循Apache许可证。


## 功能特性  
* 跨平台支持：Linux、Windows  
* 文档管理：支持与Google Drive、Box、Dropbox、OneDrive、OwnCloud集成，支持文件共享、嵌入及权限管理  
* 自定义CRM：包含在线潜客表单、发票系统  
* 项目管理：甘特图、里程碑、任务依赖与子任务、时间跟踪、自动报告  
* 社区功能：博客、论坛、投票、Wiki  
* 办公工具：日历、邮件聚合器、员工数据库（People模块）  
* 多语言支持：超过20种语言  

**说明**：Community Server（即ONLYOFFICE Groups）是ONLYOFFICE Workspace的组成部分，后者还包含文档服务器（ONLYOFFICE Docs）、邮件服务器、即时通讯工具（Talk）及管理面板（Control Panel）。


## 推荐系统要求  
* **内存**：4GB及以上  
* **CPU**：双核2GHz及以上  
* **交换分区**：至少2GB  
* **硬盘空间**：至少2GB可用空间  
* **操作系统**：64位Red Hat/CentOS（内核3.8+）或Debian/Ubuntu（内核3.8+）  
* **Docker**：1.9.0及以上版本  


## 安装前提条件  
开始安装前，需创建以下文件夹（用于数据存储与配置）：  

### 1. MySQL服务器相关  
```bash
sudo mkdir -p "/app/onlyoffice/mysql/conf.d"   # MySQL配置文件目录
sudo mkdir -p "/app/onlyoffice/mysql/data"     # MySQL数据存储目录
sudo mkdir -p "/app/onlyoffice/mysql/initdb"   # MySQL初始化脚本目录
```

### 2. Community Server相关  
```bash
sudo mkdir -p "/app/onlyoffice/CommunityServer/data"      # 数据存储目录
sudo mkdir -p "/app/onlyoffice/CommunityServer/logs"      # 日志目录
sudo mkdir -p "/app/onlyoffice/CommunityServer/letsencrypt"  # Let's Encrypt证书目录
```

### 3. 文档服务器相关  
```bash
sudo mkdir -p "/app/onlyoffice/DocumentServer/data"  # 数据存储目录
sudo mkdir -p "/app/onlyoffice/DocumentServer/logs"  # 日志目录
```

### 4. 邮件服务器相关  
```bash
sudo mkdir -p "/app/onlyoffice/MailServer/data/certs"  # 证书目录
sudo mkdir -p "/app/onlyoffice/MailServer/logs"        # 日志目录
```

### 5. 管理面板相关  
```bash
sudo mkdir -p "/app/onlyoffice/ControlPanel/data"  # 数据存储目录
sudo mkdir -p "/app/onlyoffice/ControlPanel/logs"  # 日志目录
```

### 创建Docker网络  
```bash
sudo docker network create --driver bridge onlyoffice  # 创建名为onlyoffice的桥接网络，用于容器通信
```


## 安装MySQL  
### 1. 创建MySQL配置文件  
```bash
echo "[mysqld]
sql_mode = 'NO_ENGINE_SUBSTITUTION'
max_connections = 1000
max_allowed_packet = 1048576000
group_concat_max_len = 2048
log-error = /var/log/mysql/error.log" > /app/onlyoffice/mysql/conf.d/onlyoffice.cnf
```

### 2. 创建数据库用户与权限脚本  
以下脚本将创建Community Server所需的`onlyoffice_user`及邮件服务器所需的`mail_admin`用户：  
```bash
echo "CREATE USER 'onlyoffice_user'@'localhost' IDENTIFIED BY 'onlyoffice_pass';
CREATE USER 'mail_admin'@'localhost' IDENTIFIED BY 'Isadmin123';
GRANT ALL PRIVILEGES ON * . * TO 'root'@'%' IDENTIFIED BY 'my-secret-pw';
GRANT ALL PRIVILEGES ON * . * TO 'onlyoffice_user'@'%' IDENTIFIED BY 'onlyoffice_pass';
GRANT ALL PRIVILEGES ON * . * TO 'mail_admin'@'%' IDENTIFIED BY 'Isadmin123';
FLUSH PRIVILEGES;" > /app/onlyoffice/mysql/initdb/setup.sql
```  
**注意**：脚本中`%`表示允许从任意域名访问数据库，若需限制访问范围，可替换为具体IP或域名。

### 3. 启动MySQL容器（版本5.7）  
```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-mysql-server \
 -v /app/onlyoffice/mysql/conf.d:/etc/mysql/conf.d \  # 挂载配置文件目录
 -v /app/onlyoffice/mysql/data:/var/lib/mysql \        # 挂载数据存储目录
 -v /app/onlyoffice/mysql/initdb:/docker-entrypoint-initdb.d \  # 挂载初始化脚本目录
 -e MYSQL_ROOT_PASSWORD=my-secret-pw \  # root用户密码
 -e MYSQL_DATABASE=onlyoffice \         # 创建默认数据库onlyoffice
 mysql:5.7
```


## 安装Community Server  
通过以下命令启动Community Server容器：  
```bash
sudo docker run --net onlyoffice -i -t -d --privileged --restart=always --name onlyoffice-community-server -p 80:80 -p 443:443 -p 5222:5222 \
 -e MYSQL_SERVER_ROOT_PASSWORD=my-secret-pw \  # MySQL root密码（需与上文一致）
 -e MYSQL_SERVER_DB_NAME=onlyoffice \           # 数据库名称
 -e MYSQL_SERVER_HOST=onlyoffice-mysql-server \ # MySQL容器名称（用于网络通信）
 -e MYSQL_SERVER_USER=onlyoffice_user \         # Community Server数据库用户
 -e MYSQL_SERVER_PASS=onlyoffice_pass \         # 用户密码
 -v /app/onlyoffice/CommunityServer/data:/var/www/onlyoffice/Data \  # 挂载数据目录
 -v /app/onlyoffice/CommunityServer/logs:/var/log/onlyoffice \       # 挂载日志目录
 -v /app/onlyoffice/CommunityServer/letsencrypt:/etc/letsencrypt \   # 挂载证书目录
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \          # 挂载cgroup（用于容器内服务管理）
 onlyoffice/communityserver
```


## 配置Docker镜像  

### 数据存储  
为避免升级时丢失数据，需将容器内数据目录挂载到宿主机。通过`-v`参数指定挂载路径，例如：  
```bash
sudo docker run -i -t -d -p 80:80 \
 -v /app/onlyoffice/CommunityServer/logs:/var/log/onlyoffice \  # 日志目录
 -v /app/onlyoffice/CommunityServer/data:/var/www/onlyoffice/Data \  # 数据目录
 -v /app/onlyoffice/CommunityServer/letsencrypt:/etc/letsencrypt \   # 证书目录
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro onlyoffice/communityserver
```


### 修改访问端口  
如需修改默认端口（如将80端口改为8080），通过`-p`参数调整：  
```bash
sudo docker run -i -t -d --privileged -p 8080:80 \  # 宿主机8080端口映射容器80端口
 -v /app/onlyoffice/CommunityServer/logs:/var/log/onlyoffice \
 -v /app/onlyoffice/CommunityServer/data:/var/www/onlyoffice/Data \
 -v /app/onlyoffice/CommunityServer/letsencrypt:/etc/letsencrypt \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro onlyoffice/communityserver
```


### 开放额外端口  
容器需开放以下端口用于通信：  
- **入站端口**：80（HTTP）、443（HTTPS）、5222（XMPP即时通讯，Talk模块）  
- **出站端口**：80（HTTP）、443（HTTPS）  
- **邮件相关**：25（SMTP）、465（SMTPS）、143（IMAP）、993（IMAPS）、110（POP3）、995（POP3S）  

通过`-p`参数开放端口，例如：  
```bash
sudo docker run -i -t -d --privileged -p 80:80 -p 443:443 -p 5222:5222 -p 25:25 ...
```


### 配置HTTPS访问  
HTTPS配置需准备**私钥（.key）** 和**证书（.crt）**，文件需放置于宿主机`/app/onlyoffice/CommunityServer/data/certs/`目录，容器内路径为`/var/www/onlyoffice/Data/certs/`。


#### 自动生成Let's Encrypt证书  
进入Community Server容器执行脚本：  
```bash
sudo docker exec -it onlyoffice-community-server bash
bash /var/www/onlyoffice/Tools/letsencrypt.sh yourdomain.com subdomain1.yourdomain.com  # 替换为实际域名及子域名
```  
脚本将自动生成证书并重启Nginx，之后可通过`[] 生成自签名证书  
**步骤1：生成私钥**  
```bash
openssl genrsa -out onlyoffice.key 2048  # 生成2048位私钥
```

**步骤2：创建证书签名请求（CSR）**  
```bash
openssl req -new -key onlyoffice.key -out onlyoffice.csr  # 根据提示填写域名等信息
```

**步骤3：生成证书（有效期365天）**  
```bash
openssl x509 -req -days 365 -in onlyoffice.csr -signkey onlyoffice.key -out onlyoffice.crt
```


#### 增强服务器安全性  
生成DHE参数（用于强化SSL安全）：  
```bash
openssl dhparam -out dhparam.pem 2048
```


#### 安装证书  
将生成的`onlyoffice.key`、`onlyoffice.crt`、`dhparam.pem`复制到宿主机证书目录，并设置权限：  
```bash
mkdir -p /app/onlyoffice/CommunityServer/data/certs
cp onlyoffice.key onlyoffice.crt dhparam.pem /app/onlyoffice/CommunityServer/data/certs/
chmod 400 /app/onlyoffice/CommunityServer/data/certs/onlyoffice.key  # 限制私钥访问权限
```


#### 可用配置参数  
通过环境变量调整HTTPS相关配置（示例）：  
- `SSL_KEY_PATH`：私钥路径（默认`/var/www/onlyoffice/Data/certs/onlyoffice.key`）  
- `SSL_CERTIFICATE_PATH`：证书路径（默认`/var/www/onlyoffice/Data/certs/onlyoffice.crt`）  
- `ONLYOFFICE_HTTPS_HSTS_ENABLED`：是否启用HSTS（默认`true`）  


## 安装ONLYOFFICE Workspace  
Workspace包含Community Server、Document Server、Mail Server、Control Panel，需依次安装：  

### 步骤1：确保已创建Docker网络（同上文）  
```bash
docker network create --driver bridge onlyoffice
```

### 步骤2：安装MySQL（同上文“安装MySQL”章节）  

### 步骤3：安装文档服务器（Document Server）  
```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-document-server \
 -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice \
 -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data \
 -v /app/onlyoffice/DocumentServer/fonts:/usr/share/fonts/truetype/custom \
 -v /app/onlyoffice/DocumentServer/forgotten:/var/lib/onlyoffice/documentserver/App_Data/cache/files/forgotten \
 onlyoffice/documentserver
```

### 步骤4：安装邮件服务器（Mail Server）  
替换`yourdomain.com`为实际域名：  
```bash
sudo docker run --init --net onlyoffice --privileged -i -t -d --restart=always --name onlyoffice-mail-server -p 25:25 -p 143:143 -p 587:587 \
 -e MYSQL_SERVER=onlyoffice-mysql-server \  # MySQL容器名称
 -e MYSQL_ROOT_PASSWD=my-secret-pw \        # MySQL root密码
 -v /app/onlyoffice/MailServer/data:/var/vmail \  # 邮件数据目录
 -v /app/onlyoffice/MailServer/data/certs:/etc/pki/tls/mailserver \  # 证书目录
 -h yourdomain.com \  # 邮件服务器主机名
 onlyoffice/mailserver
```

### 步骤5：安装Control Panel  
```bash
docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-control-panel \
 -v /var/run/docker.sock:/var/run/docker.sock \  # 挂载Docker控制接口
 -v /app/onlyoffice/CommunityServer/data:/app/onlyoffice/CommunityServer/data \
 -v /app/onlyoffice/ControlPanel/data:/var/www/onlyoffice/Data \
 -v /app/onlyoffice/ControlPanel/logs:/var/log/onlyoffice onlyoffice/controlpanel
```

### 步骤6：启动Community Server（集成所有组件）  
需添加文档服务器、邮件服务器等环境变量：  
```bash
sudo docker run --net onlyoffice -i -t -d --privileged --restart=always --name onlyoffice-community-server -p 80:80 -p 443:443 -p 5222:5222 \
 -e MYSQL_SERVER_ROOT_PASSWORD=my-secret-pw \
 -e DOCUMENT_SERVER_PORT_80_TCP_ADDR=onlyoffice-document-server \  # 文档服务器容器名称
 -e MAIL_SERVER_API_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' onlyoffice-mail-server) \  # 邮件服务器IP
 ...（其他参数同上文）...
 onlyoffice/communityserver
```


## 升级Community Server  
### 步骤1：检查数据卷挂载  
```bash
sudo docker inspect --format='{{range $p,$conf:=.HostConfig.Binds}}{{$conf}};{{end}}' {{社区服务器ID}}  # 替换为容器ID/名称
```

### 步骤2：删除当前容器  
```bash
sudo docker rm -f {{社区服务器ID}}
```

### 步骤3：删除旧镜像  
```bash
sudo docker rmi -f $(sudo docker images | grep onlyoffice/communityserver | awk '{ print $3 }')
```

### 步骤4：启动新版本容器  
使用与原容器相同的挂载路径和环境变量启动新镜像：  
```bash
sudo docker run -i -t -d --privileged -p 80:80 \
 -e MYSQL_SERVER_ROOT_PASSWORD=my-secret-pw \  # 保持原参数不变
 ...（其他参数）...
 onlyoffice/communityserver  # 自动拉取最新镜像
```


## 连接自定义模块  
可开发并接入自定义模块，详细说明见[官方文档]([])。


## 项目信息  
- 官网：[[]]([])  
- 代码仓库：[[]]([])  
- 许可证：Apache 2.0  


## 用户反馈与支持  
- 技术论坛：[dev.onlyoffice.org]([])  
- Stack Overflow：[仅标记“onlyoffice”的问题]([])

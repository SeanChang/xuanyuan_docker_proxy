---
image: amiveth/docker-documentserver
description: "ONLYOFFICE Document Server是一款在线办公套件，提供文本、电子表格和演示文稿的查看与编辑功能，完全兼容Office Open XML格式（.docx、.xlsx、.pptx），并支持实时协作编辑。"
source: https://xuanyuan.cloud/zh/r/amiveth/docker-documentserver
canonical: https://xuanyuan.cloud/zh/r/amiveth/docker-documentserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amiveth/docker-documentserver" title="amiveth/docker-documentserver Docker 镜像中文简介、标签列表与拉取命令">amiveth/docker-documentserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述

ONLYOFFICE Document Server是一款在线办公套件，包含文本、电子表格和演示文稿的查看器与编辑器，完全兼容Office Open XML格式（.docx、.xlsx、.pptx），并支持实时协作编辑。

## 功能特性

* ONLYOFFICE文档编辑器
* ONLYOFFICE电子表格编辑器
* ONLYOFFICE演示文稿编辑器
* ONLYOFFICE Documents iOS应用
* 协作编辑功能
* 象形文字支持
* 支持所有主流格式：DOC、DOCX、TXT、ODT、RTF、ODP、EPUB、ODS、XLS、XLSX、CSV、PPTX、HTML

将其与ONLYOFFICE社区服务器集成后，您将能够：
* 查看和编辑存储在与ONLYOFFICE连接的Drive、Box、Dropbox、OneDrive、OwnCloud上的文件
* 共享文件
* 在网站上嵌入文档
* 管理文档的访问权限

## 推荐系统要求

* **内存**：4 GB或更高
* **CPU**：双核2 GHz或更高
* **交换空间**：至少2 GB
* **硬盘**：至少2 GB可用空间
* **操作系统**：64位Red Hat、CentOS或其他兼容发行版（内核版本3.8或更高），64位Debian、Ubuntu或其他兼容发行版（内核版本3.8或更高）
* **Docker**：1.9.0版或更高

## 运行Docker镜像

```bash
sudo docker run -i -t -d -p 80:80 onlyoffice/documentserver
```

如果您希望单独安装ONLYOFFICE文档服务器，请使用此命令。若要安装与社区服务器和邮件服务器集成的ONLYOFFICE文档服务器，请参考下面相应的说明。

## 配置Docker镜像

### 数据存储

所有数据都存储在专门指定的目录（**数据卷**）中，位置如下：
* **/var/log/onlyoffice**：ONLYOFFICE文档服务器日志
* **/var/www/onlyoffice/Data**：证书
* **/var/lib/onlyoffice**：文件缓存
* **/var/lib/postgresql**：数据库

要从容器外部访问数据，需要挂载这些卷。可通过在docker run命令中指定`-v`选项实现。

```bash
sudo docker run -i -t -d -p 80:80 \
    -v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
    -v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \
    -v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql  onlyoffice/documentserver
```

通常，您不需要存储容器数据，因为容器的运行不依赖于其状态。保存数据的用途包括：
* 便于访问容器数据（如日志）
* 消除容器内数据大小的限制
* 使用在容器外部启动的服务（如PostgreSQL、Redis、RabbitMQ）时

### 在不同端口运行ONLYOFFICE文档服务器

要更改端口，请使用`-p`命令。例如：要通过8080端口访问门户，执行以下命令：

```bash
sudo docker run -i -t -d -p 8080:80 onlyoffice/documentserver
```

### 使用HTTPS运行ONLYOFFICE文档服务器

```bash
sudo docker run -i -t -d -p 443:443 \
    -v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  onlyoffice/documentserver
```

可以使用SSL保护对onlyoffice应用的访问，以防止未授权访问。虽然CA认证的SSL证书允许通过CA验证信任，但自签名证书也可以提供同等级别的信任验证，前提是每个客户端采取一些额外步骤来验证您网站的身份。以下是实现此目的的说明。

要通过SSL保护应用，基本上需要两个文件：

- **私钥（.key）**
- **SSL证书（.crt）**

因此，您需要创建并安装以下文件：

```
/app/onlyoffice/DocumentServer/data/certs/onlyoffice.key
/app/onlyoffice/DocumentServer/data/certs/onlyoffice.crt
```

使用CA认证证书时，这些文件由CA提供。使用自签名证书时，您需要自行生成这些文件。如果您已有CA认证的SSL证书，请跳过以下部分。

#### 生成自签名证书

生成自签名SSL证书涉及简单的3步过程。

**步骤1**：创建服务器私钥

```bash
openssl genrsa -out onlyoffice.key 2048
```

**步骤2**：创建证书签名请求（CSR）

```bash
openssl req -new -key onlyoffice.key -out onlyoffice.csr
```

**步骤3**：使用私钥和CSR签名证书

```bash
openssl x509 -req -days 365 -in onlyoffice.csr -signkey onlyoffice.key -out onlyoffice.crt
```

现在您已生成有效期为365天的SSL证书。

#### 加强服务器安全性

本节提供[加强服务器安全性](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)的说明。
要实现此目的，您需要生成更强的DHE参数。

```bash
openssl dhparam -out dhparam.pem 2048
```

#### 安装SSL证书

在上面生成的四个文件中，您需要在onlyoffice服务器上安装`onlyoffice.key`、`onlyoffice.crt`和`dhparam.pem`文件。CSR文件不需要，但请确保安全备份该文件（以防将来需要）。

onlyoffice应用配置的SSL证书默认查找路径为`/var/www/onlyoffice/Data/certs`，但可以使用`SSL_KEY_PATH`、`SSL_CERTIFICATE_PATH`和`SSL_DHPARAM_PATH`配置选项更改。

`/var/www/onlyoffice/Data/`是数据存储路径，这意味着您必须在`/app/onlyoffice/DocumentServer/data/`内创建一个名为certs的文件夹，并将文件复制到其中，作为安全措施，您需要将`onlyoffice.key`文件的权限更新为仅所有者可读取。

```bash
mkdir -p /app/onlyoffice/DocumentServer/data/certs
cp onlyoffice.key /app/onlyoffice/DocumentServer/data/certs/
cp onlyoffice.crt /app/onlyoffice/DocumentServer/data/certs/
cp dhparam.pem /app/onlyoffice/DocumentServer/data/certs/
chmod 400 /app/onlyoffice/DocumentServer/data/certs/onlyoffice.key
```

现在，您距离保护应用仅一步之遥。

#### 可用配置参数

*请参考docker run命令的`--env-file`标志，您可以在单个文件中指定所有必需的环境变量。这将避免编写可能很长的docker run命令。*

以下是可通过环境变量设置的完整参数列表。

- **ONLYOFFICE_HTTPS_HSTS_ENABLED**：关闭HSTS配置的高级选项。仅在使用SSL时适用。默认值为`true`。
- **ONLYOFFICE_HTTPS_HSTS_MAXAGE**：在onlyoffice nginx虚拟主机配置中设置HSTS max-age的高级选项。仅在使用SSL时适用。默认值为`31536000`。
- **SSL_CERTIFICATE_PATH**：要使用的SSL证书路径。默认值为`/var/www/onlyoffice/Data/certs/onlyoffice.crt`。
- **SSL_KEY_PATH**：SSL证书私钥的路径。默认值为`/var/www/onlyoffice/Data/certs/onlyoffice.key`。
- **SSL_DHPARAM_PATH**：Diffie-Hellman参数的路径。默认值为`/var/www/onlyoffice/Data/certs/dhparam.pem`。
- **SSL_VERIFY_CLIENT**：使用`CA_CERTIFICATES_PATH`文件启用客户端证书验证。默认值为`false`。
- **POSTGRESQL_SERVER_HOST**：PostgreSQL服务器运行的主机IP地址或名称。
- **POSTGRESQL_SERVER_PORT**：PostgreSQL服务器端口号。
- **POSTGRESQL_SERVER_DB_NAME**：镜像启动时要创建的PostgreSQL数据库名称。
- **POSTGRESQL_SERVER_USER**：具有PostgreSQL账户超级用户权限的新用户名。
- **POSTGRESQL_SERVER_PASS**：为PostgreSQL账户设置的密码。
- **RABBITMQ_SERVER_URL**：连接到RabbitMQ服务器的[AMQP URL](http://www.rabbitmq.com/uri-spec.html "RabbitMQ URI Specification")。
- **REDIS_SERVER_HOST**：Redis服务器运行的主机IP地址或名称。
- **REDIS_SERVER_PORT**：Redis服务器端口号。
- **NGINX_WORKER_PROCESSES**：定义nginx工作进程数。
- **NGINX_WORKER_CONNECTIONS**：设置nginx工作进程可打开的最大同时连接数。
- **JWT_ENABLED**：指定是否启用ONLYOFFICE文档服务器的JSON Web Token验证。默认值为`false`。
- **JWT_SECRET**：定义用于验证对ONLYOFFICE文档服务器请求的JSON Web Token的密钥。默认值为`secret`。
- **JWT_HEADER**：定义用于发送JSON Web Token的HTTP头。默认值为`Authorization`。

## 安装与社区服务器和邮件服务器集成的ONLYOFFICE文档服务器

ONLYOFFICE文档服务器是ONLYOFFICE社区版的一部分，该社区版还包括社区服务器和邮件服务器。要安装它们，请按照以下简单步骤操作：

**步骤1**：创建`onlyoffice`网络。

```bash
docker network create --driver bridge onlyoffice
```

然后使用`docker run --net onlyoffice`选项在该网络上启动容器：

**步骤2**：安装MySQL。

按照[这些步骤](#installing-mysql)安装MySQL服务器。

**步骤3**：安装ONLYOFFICE文档服务器。

```bash
sudo docker run --net onlyoffice -i -t -d --restart=always --name onlyoffice-document-server \
	-v /app/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
	-v /app/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
	-v /app/onlyoffice/DocumentServer/lib:/var/lib/onlyoffice \
	-v /app/onlyoffice/DocumentServer/db:/var/lib/postgresql \
	onlyoffice/documentserver
```

**步骤4**：安装ONLYOFFICE邮件服务器。

为使邮件服务器正常工作，您需要指定其主机名“yourdomain.com”。

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

邮件服务器的其他参数可在[此处](https://github.com/ONLYOFFICE/Docker-CommunityServer/blob/master/docker-compose.yml#L75)找到。

要了解更多信息，请参阅[ONLYOFFICE邮件服务器文档](https://github.com/ONLYOFFICE/Docker-MailServer "ONLYOFFICE Mail Server documentation")。

**步骤5**：安装ONLYOFFICE社区服务器

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

其中`${MAIL_SERVER_IP}`是**ONLYOFFICE邮件服务器**的IP地址。您可以使用以下命令轻松获取：
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' onlyoffice-mail-server
```

或者，您可以使用自动安装脚本一次性安装整个ONLYOFFICE社区版。为使邮件服务器正常工作，您需要指定其主机名“yourdomain.com”。

**步骤1**：下载社区版Docker脚本文件

```bash
wget http://download.onlyoffice.com/install/opensource-install.sh
```

**步骤2**：执行以下命令安装ONLYOFFICE社区版：

```bash
bash opensource-install.sh -md yourdomain.com
```

或者，使用[docker-compose](https://docs.docker.com/compose/install "docker-compose")。为使邮件服务器正常工作，您需要指定其主机名“yourdomain.com”。假设您已安装docker-compose，执行以下命令：

```bash
wget https://raw.githubusercontent.com/ONLYOFFICE/Docker-CommunityServer/master/docker-compose.yml
docker-compose up -d
```

## 问题

### Docker问题

作为一个相对较新的项目，Docker由其社区积极开发和维护。因此，建议使用最新版本的Docker，因为您遇到的问题可能已在较新的Docker版本中修复。

在基于rpm的发行版上，ONLYOFFICE文档服务器已知的Docker问题是，有时容器内的进程无法启动。Fedora和RHEL/CentOS用户应尝试使用`setenforce 0`禁用selinux。如果这解决了问题，您可以选择保持SELinux禁用（RedHat不推荐），或切换到使用Ubuntu。

## 项目信息

官方网站：[http://www.onlyoffice.org](http://onlyoffice.org "http://www.onlyoffice.org")

代码仓库：[https://github.com/ONLYOFFICE/DocumentServer](https://github.com/ONLYOFFICE/DocumentServer "https://github.com/ONLYOFFICE/DocumentServer")

Docker镜像：[https://github.com/ONLYOFFICE/Docker-DocumentServer](https://github.com/ONLYOFFICE/Docker-DocumentServer "https://github.com/ONLYOFFICE/Docker-DocumentServer")

许可证：[GNU AGPL v3.0](https://help.onlyoffice.com/products/files/doceditor.aspx?fileid=4358397&doc=K0ZUdlVuQzQ0RFhhMzhZRVN4ZFIvaHlhUjN2eS9XMXpKR1M5WEppUk1Gcz0_IjQzNTgzOTci0 "GNU AGPL v3.0")

SaaS版本：[http://www.onlyoffice.com](http://www.onlyoffice.com "http://www.onlyoffice.com")

## 用户反馈与支持

如果您对此镜像有任何问题或疑问，请访问我们的官方论坛寻找答案：[dev.onlyoffice.org][1]，或者您可以在[Stack Overflow][2]上提问和回答ONLYOFFICE开发相关问题。

  [1]: http://dev.onlyoffice.org
  [2]: http://stackoverflow.com/questions/tagged/onlyoffice

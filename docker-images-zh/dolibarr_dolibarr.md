<!-- xuanyuan-docker-images-zh
image: dolibarr/dolibarr
source: https://xuanyuan.cloud/zh/r/dolibarr/dolibarr
canonical: https://xuanyuan.cloud/zh/r/dolibarr/dolibarr
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/dolibarr/dolibarr" title="dolibarr/dolibarr Docker 镜像中文简介、标签列表与拉取命令">dolibarr/dolibarr — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/dolibarr/dolibarr" title="dolibarr/dolibarr Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dolibarr/dolibarr</a></p>

# Docker 部署 Dolibarr


## 关于 Dolibarr

Dolibarr 是一款开源的 ERP 与 CRM 集成套件，可用于管理组织活动，包括联系人、报价单、发票、订单、库存、日程、人力资源、费用报表、会计、文档管理、生产制造等功能。  
[更多信息]([])


## Docker 镜像版本

Docker Hub 上的可用版本/标签见：<[]>  
*注：过旧的 Dolibarr 版本可能未在 Docker Hub 更新，可从 Dolibarr 官网下载标准 zip 包获取。*


## 支持架构

Linux x86-64（`amd64`）和 ARMv8 64 位（`arm64v8`）。


## 如何运行镜像

本镜像基于 [官方 PHP 仓库]([]) 和 [官方 Dolibarr 仓库]([]) 构建，构建工具见 [Dolibarr docker build 仓库]([])。  

镜像不含数据库，需关联数据库容器。推荐使用 Docker Compose 配合 MariaDB（也可使用 MySQL）部署，步骤如下：


### 1. 创建持久化目录

为确保重启或升级后数据不丢失，需先在主机创建以下目录，分别存储数据库数据、Dolibarr 文档文件和外部模块：  
```bash
mkdir /home/dolibarr_mariadb /home/dolibarr_documents /home/dolibarr_custom
```


### 2. 编写 docker-compose.yml

创建配置文件 `docker-compose.yml`，内容如下：  
```yaml
# 编辑后执行 
# docker-compose up -d
# docker-compose logs

services:
    mariadb:
        image: mariadb:latest
        environment:
            MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-root}  # 数据库 root 密码
            MYSQL_DATABASE: ${MYSQL_DATABASE:-dolidb}          # 数据库名
            MYSQL_USER: ${MYSQL_USER:-dolidbuser}              # 数据库用户
            MYSQL_PASSWORD: ${MYSQL_PASSWORD:-dolidbpass}      # 数据库用户密码
        volumes:
            - /home/dolibarr_mariadb:/var/lib/mysql  # 挂载数据库持久化目录

    web:
        # 选择镜像版本：
        # dolibarr/dolibarr:latest（最新稳定版）
        # dolibarr/dolibarr:develop（开发版）
        # dolibarr/dolibarr:x.y.z（指定版本）
        image: dolibarr/dolibarr:latest
        environment:
            DOLI_INIT_DEMO: ${DOLI_INIT_DEMO:-0}              # 是否加载演示数据（1=是）
            DOLI_DB_HOST: ${DOLI_DB_HOST:-mariadb}            # 数据库主机名（关联 mariadb 服务）
            DOLI_DB_NAME: ${DOLI_DB_NAME:-dolidb}             # 数据库名（需与 mariadb 配置一致）
            DOLI_DB_USER: ${DOLI_DB_USER:-dolidbuser}         # 数据库用户（需与 mariadb 配置一致）
            DOLI_DB_PASSWORD: ${DOLI_DB_PASSWORD:-dolidbpass} # 数据库密码（需与 mariadb 配置一致）
            DOLI_URL_ROOT: "${DOLI_URL_ROOT:-[]}" # 访问 URL
            DOLI_ADMIN_LOGIN: "${DOLI_ADMIN_LOGIN:-admin}"    # 管理员账号
            DOLI_ADMIN_PASSWORD: "${DOLI_ADMIN_PASSWORD:-admin}" # 管理员密码
            DOLI_CRON: ${DOLI_CRON:-0}                        # 是否启用定时任务（1=是）
            DOLI_CRON_KEY: ${DOLI_CRON_KEY:-mycronsecurekey}  # 定时任务安全密钥
            DOLI_COMPANY_NAME: ${DOLI_COMPANY_NAME:-MyBigCompany} # 公司名称
            WWW_USER_ID: ${WWW_USER_ID:-1000}                 # www-data 用户 ID（开发时可设为主机用户 ID）
            WWW_GROUP_ID: ${WWW_GROUP_ID:-1000}               # www-data 组 ID
        ports:
            - "80:80"  # 端口映射（主机端口:容器端口，若 80 被占用可改为主机空闲端口）
        links:
            - mariadb  # 关联 mariadb 服务
        volumes:
            - /home/dolibarr_documents:/var/www/documents  # 挂载文档持久化目录
            - /home/dolibarr_custom:/var/www/html/custom    # 挂载外部模块目录
```


### 3. 启动服务

执行以下命令启动容器（`-d` 后台运行）：  
```bash
sudo docker-compose up -d
```

查看服务状态和日志：  
```bash
sudo docker-compose ps   # 查看容器状态
sudo docker-compose logs # 查看日志
```

日志显示 "You can connect to your Dolibarr web application..." 时，访问 `[] `[] 为自定义端口），使用默认管理员账号 `admin/admin` 登录。


### 其他部署示例

更多场景的 docker-compose 配置示例见 `examples` 目录：  
- [带定时任务的部署]([])  
- [配置 Let's Encrypt 证书]([])  
- [使用 MySQL 数据库]([])  
- [搭配 Traefik 反向代理]([])  
- [使用 Docker Secrets 管理敏感信息]([])  


## 版本升级与数据库迁移

**警告**：仅持久化目录（docker-compose.yml 中 `volumes` 配置的目录）中的数据在容器升级后不会丢失。


### 步骤 1：删除 install.lock 文件

需删除容器内 `/var/www/documents` 目录下的 `install.lock` 文件，可通过以下任一方式：  
- 直接执行容器命令：  
  ```bash
  sudo docker exec [web容器名] bash -c "rm -f /var/www/documents/install.lock"
  ```
- 进入容器删除：  
  ```bash
  sudo docker exec -it [web容器名] bash
  rm -f /var/www/documents/install.lock; exit
  ```
- 若文档目录已挂载到主机，直接在主机删除：  
  ```bash
  rm -f /home/dolibarr_documents/install.lock
  ```


### 步骤 2：拉取新镜像并重启

```bash
sudo docker-compose pull  # 拉取最新镜像
sudo docker-compose up -d # 重启容器
sudo docker-compose logs  # 查看日志确认启动成功
```

**注意**：确保 `DOLI_INSTALL_AUTO=1`（默认值），容器会自动迁移数据库；也可通过访问 `/install` 页面手动升级。


## 环境变量说明

可通过以下环境变量自定义配置，表格列出常用变量及说明：

| 变量名                          | 默认值                          | 描述                                                                 |
|---------------------------------|---------------------------------|----------------------------------------------------------------------|
| **DOLI_INSTALL_AUTO**           | 1                               | 是否自动安装/迁移数据库（1=是）                                       |
| **DOLI_INIT_DEMO**              | 0                               | 是否加载演示数据（1=是）                                             |
| **DOLI_PROD**                   | 1                               | 是否启用生产模式（1=是）                                             |
| **DOLI_DB_TYPE**                | mysqli                          | 数据库类型（mysqli 或 pgsql）                                        |
| **DOLI_DB_HOST**                | mariadb                         | 数据库主机名                                                         |
| **DOLI_DB_NAME**                | dolidb                          | 数据库名                                                             |
| **DOLI_DB_USER**                | dolidbuser                      | 数据库用户名                                                         |
| **DOLI_DB_PASSWORD**            | dolidbpass                      | 数据库密码                                                           |
| **DOLI_URL_ROOT**               | []                | 应用访问根 URL                                                       |
| **DOLI_ADMIN_LOGIN**            | admin                           | 管理员账号                                                           |
| **DOLI_ADMIN_PASSWORD**         | admin                           | 管理员密码                                                           |
| **DOLI_AUTH**                   | dolibarr                        | 用户认证方式（dolibarr、ldap 或 ldap,dolibarr）                      |
| **DOLI_CRON**                   | 0                               | 是否启用定时任务（1=是）                                             |
| **DOLI_CRON_KEY**               | -                               | 定时任务安全密钥                                                     |
| **WWW_USER_ID**                 | -                               | www-data 用户 ID（留空则不修改，开发时可设为主机用户 ID）             |
| **PHP_INI_MEMORY_LIMIT**        | 256M                            | PHP 内存限制                                                         |


### Docker Secrets 支持

部分变量支持通过 Docker Secrets 管理，变量名后加 `_FILE` 后缀，值为密钥文件路径，例如：  
- `DOLI_DB_PASSWORD` → `DOLI_DB_PASSWORD_FILE=/run/secrets/db_password`  
支持的变量：`DOLI_INSTANCE_UNIQUE_ID`、`DOLI_DB_USER`、`DOLI_DB_PASSWORD`、`DOLI_ADMIN_LOGIN`、`DOLI_ADMIN_PASSWORD`、`DOLI_CRON_KEY`、`DOLI_CRON_USER`。


## 高级配置


### 自定义部署脚本

可通过挂载卷执行自定义脚本（支持 `.sh`、`.sql`、`.php`）：  
- 部署阶段执行：挂载目录到 `/var/www/scripts/docker-init.d`  
- 启动 Apache 前执行：挂载目录到 `/var/www/scripts/before-starting.d`  

示例配置（docker-compose.yml 中添加）：  
```yaml
volumes:
  - ./custom-scripts:/var/www/scripts/docker-init.d       # 部署脚本
  - ./pre-start-scripts:/var/www/scripts/before-starting.d # 启动前脚本
```


### Apache 配置调整

#### 解决 ServerName 警告  
若执行 `apache2ctl configtest` 提示 "Could not reliably determine the server's fully qualified domain name"，创建文件 `servername.conf`（内容 `ServerName dolibarr.example.com`），挂载到容器 `/etc/apache2/conf-enabled/servername.conf`（只读挂载 `:ro`）。

#### 代理后获取真实 IP  
若 Dolibarr 部署在代理后，需配置 Apache 模块 `mod_remoteip` 获取真实客户端 IP：  
1. 创建 `remoteip.load`（内容 `LoadModule remoteip_module /usr/lib/apache2/modules/mod_remoteip.so`），挂载到 `/etc/apache2/mods-enabled/remoteip.load:ro`  
2. 创建 `remoteip.conf`（示例内容 `RemoteIPHeader X-Forwarded-For`），挂载到 `/etc/apache2/mods-enabled/remoteip.conf:ro`  


### PostgreSQL 支持

设置 `DOLI_DB_TYPE=pgsql` 可使用 PostgreSQL 数据库，首次启动需手动安装：  
1. 访问 `[]  
2. 在容器文档目录创建 `install.lock`（例如 `docker-compose exec [web容器名] touch /var/www/html/documents/install.lock`）  

升级时：删除 `install.lock` → 访问 `/install` 升级数据库 → 重新创建 `install.lock`。


## 故障排除

- 若执行 `docker-compose` 时出现错误 "urllib3.exceptions.URLSchemeUnknown: Not supported URL scheme http+docker"，尝试调整 requests 版本：  
  ```bash
  pip install requests==2.31.0
  ```

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/dolibarr/dolibarr" title="dolibarr/dolibarr Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/dolibarr/dolibarr</a></p>

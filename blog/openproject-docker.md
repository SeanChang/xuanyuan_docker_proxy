# OpenProject Docker 容器化部署指南：从快速启动到生产环境配置

![OpenProject Docker 容器化部署指南：从快速启动到生产环境配置](https://img.xuanyuan.dev/docker/blog/docker-openproject.png)

*分类: OpenProject,部署教程,项目管理 | 标签: OpenProject,部署教程,项目管理 | 发布时间: 2026-02-03 03:10:05*

> OpenProject是一款功能全面的开源项目管理平台，支持敏捷管理、任务跟踪、工时记录、成本控制等多种项目管理需求，提供社区版和企业版两种部署选项，适配不同规模团队与组织的使用场景。

## 概述
OpenProject是一款功能全面的开源项目管理平台，支持敏捷管理、任务跟踪、工时记录、成本控制等多种项目管理需求，提供社区版和企业版两种部署选项，适配不同规模团队与组织的使用场景。

采用Docker容器化部署OpenProject，可显著简化传统部署中的环境配置复杂度，实现快速搭建、灵活扩展与便捷升级。本文基于**轩辕镜像访问支持平台**提供的`openproject/openproject`镜像（兼容官方镜像），详细介绍从环境准备、快速启动、进阶配置到生产环境集群部署的完整流程，同时覆盖插件定制、离线部署等高级操作，帮助用户高效搭建稳定、安全的OpenProject项目管理系统。

OpenProject Docker镜像提供两种核心版本，适配不同使用场景：
1.  `all-in-one`：内置PostgreSQL、Memcached等依赖服务，一键启动，适合**测试、PoC、演示或非关键小型业务**，可扩展性较差，**严禁用于大规模/核心生产环境**。
2.  `slim`：仅包含应用程序与应用服务器，需配合外部数据库、缓存服务使用（可通过Docker Compose/Swarm编排），资源占用更低、可扩展性更强，是**生产环境的唯一推荐选择**。

此外，OpenProject 12.5.6及以上版本支持`AMD64（x86）`和`ARM64`两种架构，其中BIM版仅支持`AMD64`架构。

## 环境准备
### Docker环境安装
部署OpenProject容器前，需确保目标服务器已安装Docker环境（推荐Docker 20.10及以上版本）。推荐使用轩辕镜像提供的一键安装脚本，自动配置Docker及相关依赖（兼容CentOS、Ubuntu等主流发行版）：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

#### 安全说明（重要）
1.  一键执行远程脚本存在潜在安全风险，建议先查看脚本内容确认无恶意代码：`wget -O docker.sh https://xuanyuan.cloud/docker.sh && cat docker.sh`。
2.  若需更高安全性，可通过官方文档手动安装Docker，避免执行未知来源的远程脚本。
3.  该脚本仅用于快速部署测试，生产环境建议通过系统包管理器（yum/apt）安装并验证Docker包的SHA校验值。

安装完成后，通过以下命令验证Docker是否正常运行：
```bash
docker --version  # 检查Docker版本，输出类似 Docker version 26.0.0, build 2ae903e
systemctl status docker  # 检查Docker服务状态，确保状态为 active (running)
```

若需开机自启Docker服务，可执行以下命令：
```bash
systemctl enable docker --now
```

### 轩辕镜像访问支持说明
轩辕镜像访问支持是面向开发者与科研用户的Docker镜像访问优化平台，镜像内容来源于官方公共仓库，平台不存储、不修改、不生产、不分发镜像内容，仅提供访问路径优化与技术支持能力，可有效提升`openproject/openproject`镜像的拉取速度，解决海外镜像拉取超时问题。

## 镜像准备
### 镜像标签选择
OpenProject镜像遵循语义化版本规范，标签分为**非浮动标签**和**浮动标签**，推荐生产环境使用**稳定版非浮动标签**以保证版本稳定性和数据兼容性：
1.  非浮动标签（生产环境推荐）：`X.Y.Z`、`X.Y.Z-slim`、`X.Y.Z-slim-bim`（如`17.0.0-slim-bim`），对应唯一稳定版本，需手动更新标签以升级版本，升级前需备份数据。
2.  浮动标签（测试环境专用）：`X.Y`、`X.Y-slim`（小版本自动更新）、`X`、`X-slim`（大/小版本自动更新）、`dev`、`dev-slim`（夜间开发版）、`X-rc`（候选发布版），不保证数据兼容性，升级可能导致服务异常，**严禁用于生产环境**。

### 拉取OpenProject镜像
使用轩辕镜像访问支持域名拉取**稳定版**OpenProject镜像（以`17.0.0-slim-bim`为例，测试环境如需`all-in-one`版本，可移除`-slim`后缀，如需RC/dev版本，可替换为`17-rc-slim-bim`/`dev-slim-bim`）：
```bash
# 拉取slim版（生产环境唯一推荐）
docker pull vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim

# 拉取all-in-one版（仅测试/PoC/演示使用）
docker pull vipxxx.xuanyuan.run/openproject/openproject:17.0.0-bim
```

若需直接拉取官方镜像，可执行以下命令：
```bash
docker pull openproject/openproject:17.0.0-slim
```

拉取完成后，通过以下命令验证镜像是否成功下载：
```bash
docker images | grep openproject
```

若输出类似以下内容，说明镜像拉取成功：
```
vipxxx.xuanyuan.run/openproject/openproject   17.0.0-slim-bim   <镜像ID>   <创建时间>   <大小>
```

## 容器部署
### 快速启动（All-in-One容器，仅测试/PoC/演示）
对于测试、PoC、演示或非关键小型业务快速上手场景，可使用`all-in-one`镜像一键启动OpenProject，无需额外配置外部依赖，**该方案严禁用于核心生产环境**：
```bash
docker run -td \
  --name openproject-test \
  --restart=unless-stopped \  # 测试环境可选，容器异常自动重启
  -p 8080:80 \
  -e SECRET_KEY_BASE=$(openssl rand -hex 32) \  # 仅测试环境临时生成，生产环境禁止动态生成
  -e OPENPROJECT_HOST__NAME=localhost:8080 \    # 应用访问域名/端口，需与外部访问地址一致
  -e OPENPROJECT_HTTPS=false \                  # 禁用HTTPS（仅测试环境）
  -e OPENPROJECT_DEFAULT__LANGUAGE=zh-CN \      # 默认语言（中文/英文：zh-CN/en）
  -v openproject_test_data:/var/openproject \   # 命名数据卷持久化测试数据
  vipxxx.xuanyuan.run/openproject/openproject:17.0.0-bim
```

#### 参数说明
-  `-td`：`-t`分配伪终端，解决某些Ruby logger在无TTY环境下写入`/dev/stdout`的权限异常问题；`-d`后台运行容器（如需查看实时日志，可移除`-d`，停止时按`CTRL-C`即可，`-i`无实际意义已移除）。
-  `--name openproject-test`：指定容器名称，便于后续管理。
-  `--restart=unless-stopped`：容器异常退出或服务器重启后自动重启，测试环境可选，生产环境需配置为`always`。
-  `-p 8080:80`：将容器内80端口映射到主机8080端口。
-  `SECRET_KEY_BASE`：Rails应用核心加密密钥，**所有实例必须保持一致**，测试环境可临时生成，**任何生产环境禁止在`docker run`中动态生成该密钥**，否则容器重建/扩容后会导致用户Session全部失效、Cookie解密失败，生产环境需通过Docker Secret/.env文件集中管理并固定值。
-  `OPENPROJECT_HOST__NAME`：应用对外访问的主机名与端口，用于生成邮件链接、表单地址，需与用户浏览器访问地址一致，避免HOST头注入漏洞；**不要填写0.0.0.0、*或纯内网IP，否则会导致登录跳转、邮件链接、CSRF校验异常**。
-  `OPENPROJECT_HTTPS`：是否启用HTTPS模式，生产环境需设为`true`，并配合SSL证书配置。
-  OpenProject官方镜像已内置健康检查，无需在`docker run`命令中额外配置，若需自定义健康检查，可使用`--health-cmd`等系列参数（示例见文末补充）。

#### 启动验证
容器首次启动需初始化数据库与静态资源，耗时约3-5分钟，可通过以下命令查看启动日志：
```bash
docker logs -f openproject-test
```

当日志中出现`Admin user created: login: admin, password: admin`（或随机密码）时，说明启动成功，可通过浏览器访问`http://<服务器IP>:8080`进入OpenProject登录页面。

### 进阶部署（自定义配置，生产前期准备，仅使用slim版）
对于需要自定义数据库、邮件服务、子目录部署的场景，**仅使用slim版镜像**（生产环境唯一推荐），需配合外部PostgreSQL数据库，并配置SMTP邮件服务与子目录访问，同时补充生产必备的重启策略与健康检查：
```bash
docker run -d \
  --name openproject-advanced \
  --restart=always \  # 生产环境必备，容器异常或服务器重启后自动重启
  -p 8080:80 \
  --cpus=2 \  # 限制CPU核心数，避免资源抢占
  --memory=4g \  # 限制内存使用
  --memory-swap=6g \  # 限制内存+交换空间（cgroup v2环境中可能无效，仅作参考）
  -e SECRET_KEY_BASE=your-fixed-secret-key-here \  # 生产环境固定值，禁止动态生成，后续替换为Docker Secret/.env
  -e OPENPROJECT_HOST__NAME=openproject.example.com \
  -e OPENPROJECT_HTTPS=true \
  -e OPENPROJECT_RAILS__RELATIVE__URL__ROOT=/openproject \  # 子目录部署，访问路径为 /openproject
  # 外部PostgreSQL数据库配置（生产环境建议使用Docker Secret存储凭据，避免明文）
  -e DATABASE_URL=postgresql://openproject_user:openproject_password@db-host:5432/openproject \
  # SMTP邮件服务配置（生产环境建议使用Docker Secret存储凭据，避免明文）
  -e EMAIL_DELIVERY_METHOD=smtp \
  -e SMTP_ADDRESS=smtp.example.com \
  -e SMTP_PORT=587 \
  -e SMTP_USER_NAME=notify@example.com \
  -e SMTP_PASSWORD=your-smtp-password \
  -e SMTP_AUTHENTICATION=login \
  -e SMTP_ENABLE_STARTTLS_AUTO=true \
  # 数据持久化（生产环境必备）
  -v openproject_data:/var/lib/openproject \
  -v openproject_config:/etc/openproject \
  -v openproject_logs:/var/log/openproject \
  vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim
```

#### 关键注意点
1.  外部数据库需提前创建`openproject`数据库与对应权限用户，PostgreSQL版本需**13–16（生产推荐14/15）**，生产环境建议单独部署数据库集群，实现高可用。
2.  OpenProject镜像默认以**非root用户**运行（用户名`openproject`，UID/GID固定），无需添加`--user root`参数，强行使用root用户会带来安全风险，且可能导致容器内文件权限错乱。
3.  子目录部署时，后续反向代理配置需与`OPENPROJECT_RAILS__RELATIVE__URL__ROOT`保持一致。
4.  邮件服务配置完成后，可在OpenProject系统设置中测试邮件发送功能，验证配置有效性。
5.  生产环境中，SMTP/数据库凭据严禁明文写入命令行，需通过`Docker Secret`或`.env`文件管理，避免泄露。
6.  在**cgroup v2环境（Ubuntu 22.04+/Debian 12+）**中，`--memory-swap`参数可能被忽略，生产环境资源限制请以`--memory`为主，如需精准控制交换空间，需额外配置系统cgroup参数并启用`swapaccount=1`。
7.  OpenProject镜像内置健康检查，无需额外配置，若需自定义健康检查，可添加如下参数（示例，兼容更多版本，避免`/health`路径404问题）：
    ```bash
    --health-cmd="curl -f http://localhost/ || exit 1" \
    --health-interval=30s \
    --health-timeout=5s \
    --health-retries=3 \
    --health-start-period=300s
    ```

---

#### 镜像数据路径对照表（避免挂载错误）
| 镜像类型       | 核心数据持久化路径                | 配置文件路径       | 日志文件路径       |
|----------------|-----------------------------------|--------------------|--------------------|
| all-in-one     | `/var/openproject`（包含所有数据） | 内置在核心路径中   | 内置在核心路径中   |
| slim（生产推荐）| `/var/lib/openproject`（应用数据） | `/etc/openproject` | `/var/log/openproject` |

---

## 生产环境优化配置
### 数据持久化（核心保障，避免数据丢失，仅使用slim版）
生产环境中，必须确保OpenProject的数据（配置、日志、静态资源）持久化存储，避免容器重启、删除导致数据丢失，**所有生产配置均基于slim版镜像，不支持all-in-one版**。推荐三种持久化方案，优先级从高到低：

#### 方案1：对象存储（S3/MinIO，集群部署强烈推荐）
OpenProject支持将附件、导出文件等存储到S3兼容对象存储，避免本地文件存储的多副本数据错乱问题，**是集群部署的唯一推荐方案**，支持高并发、高可用，无文件覆盖/丢失风险：
```bash
docker run -d \
  --name openproject-prod \
  --restart=always \
  -p 8080:80 \
  --cpus=4 \
  --memory=8g \
  --memory-swap=12g \  # cgroup v2环境中可能无效，仅作参考
  -e SECRET_KEY_BASE=your-fixed-secret-key-here \  # 集群环境后续替换为Docker Secret，禁止动态生成
  -e OPENPROJECT_HOST__NAME=openproject.example.com \
  -e OPENPROJECT_HTTPS=true \
  # 对象存储配置（S3/MinIO，集群部署必备）
  -e OPENPROJECT_ATTACHMENTS__STORAGE="fog" \
  -e OPENPROJECT_FOG_DIRECTORY="openproject-attachments" \
  -e OPENPROJECT_FOG_CREDENTIALS_PROVIDER="AWS" \
  -e OPENPROJECT_FOG_CREDENTIALS_AWS__ACCESS__KEY__ID="your-access-key" \
  -e OPENPROJECT_FOG_CREDENTIALS_AWS__SECRET__ACCESS__KEY="your-secret-key" \
  -e OPENPROJECT_FOG_CREDENTIALS_REGION="cn-north-1" \
  -e OPENPROJECT_FOG_CREDENTIALS_ENDPOINT="https://minio.example.com" \  # MinIO需添加端点配置
  # 基础数据持久化（配置、日志）
  -v openproject_prod_config:/etc/openproject \
  -v openproject_prod_logs:/var/log/openproject \
  vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim
```

#### 方案2：Docker命名数据卷（单节点生产环境推荐，易于管理）
Docker数据卷由Docker统一管理，权限配置自动优化，适合**单节点生产环境**，不支持集群多副本（多副本会导致数据错乱）：
```bash
# 提前创建所需数据卷（单节点生产环境）
docker volume create openproject_prod_config
docker volume create openproject_prod_logs
docker volume create openproject_prod_assets  # 非必需，仅在未启用S3对象存储时有效，新版slim多数静态资源走编译+对象存储

# 启动生产环境容器（slim版，单节点唯一推荐）
docker run -d \
  --name openproject-prod \
  --restart=always \
  -p 80:80 -p 443:443 \
  --cpus=4 \
  --memory=8g \
  --memory-swap=12g \  # cgroup v2环境中可能无效，仅作参考
  -e SECRET_KEY_BASE=your-fixed-secret-key-here \  # 固定值，禁止动态生成
  -e OPENPROJECT_HOST__NAME=openproject.example.com \
  -e OPENPROJECT_HTTPS=true \
  # 单节点本地静态资源存储（仅单副本支持，多副本禁用，该挂载非必需可省略）
  -v openproject_prod_assets:/var/openproject/assets \
  # 基础数据持久化
  -v openproject_prod_config:/etc/openproject \
  -v openproject_prod_logs:/var/log/openproject \
  vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim
```

#### 方案3：本地目录绑定/分布式存储（特殊场景，需谨慎使用）
1.  本地目录绑定：手动创建主机目录，将其挂载到容器内，适合需要手动备份、修改配置的**单节点特殊场景**，多副本禁用：
    ```bash
    # 提前创建主机目录（单节点生产环境）
    sudo mkdir -p /var/openproject/prod/{config,logs,assets}
    sudo chown -R 1000:1000 /var/openproject/prod  # 适配容器非root用户，避免写入失败
    sudo chmod -R 775 /var/openproject/prod

    # 启动生产环境容器（slim版，单节点）
    docker run -d \
      --name openproject-prod \
      --restart=always \
      -p 80:80 -p 443:443 \
      --cpus=4 \
      --memory=8g \
      --memory-swap=12g \  # cgroup v2环境中可能无效，仅作参考
      -e SECRET_KEY_BASE=your-fixed-secret-key-here \  # 固定值，禁止动态生成
      -e OPENPROJECT_HOST__NAME=openproject.example.com \
      -e OPENPROJECT_HTTPS=true \
      -v /var/openproject/prod/config:/etc/openproject \
      -v /var/openproject/prod/logs:/var/log/openproject \
      -v /var/openproject/prod/assets:/var/openproject/assets \  # 非必需，可省略
      vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim
    ```

2.  分布式存储（CephFS/GlusterFS，集群场景备选）：仅适合集群部署，需使用**POSIX语义强一致存储**，NFS在高并发写场景存在数据不一致风险（文件覆盖、丢失），**严禁用于高并发生产集群**，仅作为低并发场景的临时方案。

### HTTPS配置（保障数据传输安全，生产环境必选，仅使用slim版）
OpenProject生产环境必须启用HTTPS，避免数据明文传输，推荐使用**反向代理（Nginx/Traefik）**处理SSL终结（简化容器配置，便于证书管理），也可直接在容器内配置HTTPS（不推荐）。

#### 方案1：Nginx反向代理（推荐，支持根域名/子目录，适配单节点/集群）
##### 场景1：根域名部署（https://openproject.example.com）
1.  提前准备SSL证书（免费证书可通过Let's Encrypt获取），存放于`/etc/ssl/openproject/`目录（`cert.pem`为证书文件，`key.pem`为私钥文件）。
2.  创建Nginx配置文件`/etc/nginx/conf.d/openproject.conf`：
    ```nginx
    # 重定向HTTP到HTTPS
    server {
        listen 80;
        server_name openproject.example.com;
        return 301 https://$host$request_uri;
    }

    # HTTPS服务配置
    server {
        listen 443 ssl;
        server_name openproject.example.com;

        # SSL证书配置
        ssl_certificate /etc/ssl/openproject/cert.pem;
        ssl_certificate_key /etc/ssl/openproject/key.pem;
        # SSL优化配置
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;

        # 反向代理配置（适配单节点/集群OpenProject Web服务）
        location / {
            proxy_pass http://127.0.0.1:8080;  # 单节点：对应容器映射端口；集群：对应Traefik/集群内网地址
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto https;  # 告知OpenProject使用HTTPS协议，避免重定向循环
        }
    }
    ```

3.  验证Nginx配置并重启服务：
    ```bash
    nginx -t  # 验证配置语法正确性
    systemctl restart nginx
    ```

##### 场景2：子目录部署（https://example.com/openproject）
1.  容器启动时已配置`OPENPROJECT_RAILS__RELATIVE__URL__ROOT=/openproject`，创建Nginx配置文件`/etc/nginx/conf.d/openproject.conf`：
    ```nginx
    # 重定向HTTP子目录到HTTPS
    server {
        listen 80;
        server_name example.com;
        location /openproject {
            return 301 https://$host$request_uri;
        }
    }

    # HTTPS服务配置
    server {
        listen 443 ssl;
        server_name example.com;

        # SSL证书配置
        ssl_certificate /etc/ssl/openproject/cert.pem;
        ssl_certificate_key /etc/ssl/openproject/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;

        # 子目录反向代理配置
        location /openproject {
            proxy_pass http://127.0.0.1:8080/openproject;  # 与容器子目录配置保持一致
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto https;
            proxy_redirect off;
        }
    }
    ```

2.  验证配置并重启Nginx：
    ```bash
    nginx -t
    systemctl restart nginx
    ```

#### 方案2：容器内直接配置HTTPS（不推荐，证书管理繁琐）
如需直接在容器内启用HTTPS，可将SSL证书挂载到容器内，并配置相关环境变量（不推荐，证书管理繁琐，不利于批量更新）：
```bash
docker run -d \
  --name openproject-https \
  --restart=always \
  -p 443:443 \
  -e SECRET_KEY_BASE=your-fixed-secret-key-here \  # 固定值，禁止动态生成
  -e OPENPROJECT_HOST__NAME=openproject.example.com \
  -e OPENPROJECT_HTTPS=true \
  -e OPENPROJECT_SSL__CERTIFICATE=/etc/ssl/cert.pem \
  -e OPENPROJECT_SSL__KEY=/etc/ssl/key.pem \
  -v /etc/ssl/openproject/cert.pem:/etc/ssl/cert.pem \
  -v /etc/ssl/openproject/key.pem:/etc/ssl/key.pem \
  -v openproject_prod_config:/etc/openproject \
  vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim
```

### 定期备份（防止数据丢失，生产环境必配，仅使用slim版）
配置定期备份OpenProject数据，避免硬件故障、误操作导致数据丢失，以下提供两种备份方案，适配不同持久化方式：

#### 方案1：对象存储+配置/日志备份（集群生产环境推荐）
对象存储（S3/MinIO）自带数据冗余，只需备份OpenProject配置文件，创建备份脚本`/var/backups/openproject/backup_openproject.sh`：
```bash
#!/bin/bash
# OpenProject（对象存储版）备份脚本（集群生产环境推荐）
BACKUP_DIR="/var/backups/openproject"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONFIG_VOLUME="openproject_prod_config"  # 配置数据卷
LOGS_VOLUME="openproject_prod_logs"      # 日志数据卷（可选备份）

# 创建备份目录
mkdir -p $BACKUP_DIR

# 备份配置数据卷
docker run --rm -v $CONFIG_VOLUME:/source -v $BACKUP_DIR:/backup alpine \
  tar -czf /backup/${CONFIG_VOLUME}_${TIMESTAMP}.tar.gz -C /source .
echo "配置数据卷 $CONFIG_VOLUME 备份完成：${BACKUP_DIR}/${CONFIG_VOLUME}_${TIMESTAMP}.tar.gz"

# 可选：备份日志数据卷
docker run --rm -v $LOGS_VOLUME:/source -v $BACKUP_DIR:/backup alpine \
  tar -czf /backup/${LOGS_VOLUME}_${TIMESTAMP}.tar.gz -C /source .
echo "日志数据卷 $LOGS_VOLUME 备份完成：${BACKUP_DIR}/${LOGS_VOLUME}_${TIMESTAMP}.tar.gz"

# 保留最近30天备份，删除过期备份
find $BACKUP_DIR -name "openproject_prod_*_*.tar.gz" -mtime +30 -delete
echo "过期备份已清理（保留30天）"
```

#### 方案2：本地目录/数据卷备份（单节点生产环境）
适配单节点本地目录或数据卷持久化场景，创建备份脚本`/var/backups/openproject/backup_openproject.sh`：
```bash
#!/bin/bash
# OpenProject（单节点版）备份脚本
BACKUP_DIR="/var/backups/openproject"
SOURCE_DIR="/var/openproject/prod"  # 本地目录路径（数据卷可通过docker volume inspect获取挂载路径）
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="openproject-prod"

# 创建备份目录
mkdir -p $BACKUP_DIR

# 停止容器（避免备份过程中数据写入不一致，硬停会中断用户操作，生产环境更推荐数据库层备份）
docker stop $CONTAINER_NAME

# 打包备份本地目录
tar -czf $BACKUP_DIR/openproject_prod_${TIMESTAMP}.tar.gz -C $SOURCE_DIR .

# 启动容器
docker start $CONTAINER_NAME

# 保留最近30天备份，删除过期备份
find $BACKUP_DIR -name "openproject_prod_*.tar.gz" -mtime +30 -delete

echo "备份完成：$BACKUP_DIR/openproject_prod_${TIMESTAMP}.tar.gz"
echo "过期备份已清理（保留30天）"
echo "提示：容器级硬停备份仅适合小规模单机，生产环境优先使用pg_dump/RDS快照等数据库层备份方案"
```

#### 配置定时任务（crontab）
1.  给备份脚本添加执行权限：
    ```bash
    chmod +x /var/backups/openproject/backup_openproject.sh
    ```

2.  编辑crontab配置，设置每天凌晨2点自动执行备份（生产环境低峰期）：
    ```bash
    crontab -e
    ```

3.  添加以下内容（保存退出）：
    ```bash
    0 2 * * * /var/backups/openproject/backup_openproject.sh >> /var/backups/openproject/backup_logs.log 2>&1
    ```

### 集群部署（Docker Swarm，大规模团队生产环境，仅使用slim版）
对于需要支撑数千用户访问的大规模团队场景，可使用Docker Swarm搭建集群，实现服务水平扩展、高可用与负载均衡，**核心要求：使用S3/MinIO对象存储、统一加密密钥、专业反向代理**，以下为完整正确配置：

#### 1. 初始化Docker Swarm集群
```bash
# 在管理节点初始化Swarm（替换为管理节点内网IP）
docker swarm init --advertise-addr=10.0.0.100

# 如需添加工作节点，按照终端输出的命令在工作节点执行（示例）
docker swarm join --token SWMTKN-1-xxxxxx 10.0.0.100:2377
```

#### 2. 准备核心资源（Docker Secret+对象存储）
##### 1. 创建统一加密密钥（解决Session失效问题，生产必备）
```bash
# 生成高强度统一加密密钥
openssl rand -hex 64 > secret_key_base.txt

# 创建Docker Secret，所有实例共享同一密钥
docker secret create openproject_secret_key_base secret_key_base.txt

# 验证Secret创建成功
docker secret ls | grep openproject_secret_key_base
```

##### 2. 配置S3/MinIO对象存储（解决多副本数据错乱问题，集群必备）
提前搭建S3或MinIO对象存储服务，获取访问密钥、存储桶名称等信息，**确保所有集群节点均可访问对象存储服务**，禁用本地文件存储。

#### 3. 编写Swarm Stack配置文件（核心修正，使用Traefik反向代理）
创建`openproject-stack.yml`，编排OpenProject相关服务（web、db、cache、traefik反向代理），采用Traefik作为专业反向代理，修正TLS配置与PostgreSQL单点风险，给Worker服务添加资源限制，补充Traefik必要的router/rule/labels配置，修正depends_on的Swarm局限性，替换memcached为固定版本：
```yaml
version: '3.8'

# 定义Docker Secret，所有服务共享统一加密密钥
secrets:
  openproject_secret_key_base:
    external: true  # 引用已创建的外部Secret

services:
  # 1. 数据库服务（PostgreSQL，仅用于演示！生产环境必须使用独立高可用数据库）
  # 警告：该配置为单点本地存储，管理节点宕机/迁移会导致数据丢失，生产环境请使用RDS/Patroni/云数据库
  db:
    image: postgres:15  # 生产推荐14/15，限定13–16范围
    volumes:
      - /var/openproject/swarm/pgdata:/var/lib/postgresql/data  # 建议使用CephFS/GlusterFS持久化（仅演示）
    environment:
      - POSTGRES_USER=openproject
      - POSTGRES_PASSWORD=openproject_password  # 生产环境建议替换为Docker Secret
      - POSTGRES_DB=openproject
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      placement:
        constraints: [node.role == manager]  # 固定到管理节点，避免数据迁移（仅演示）
    networks:
      - openproject_internal
    healthcheck:  # 补充健康检查，为依赖服务提供就绪判断
      test: ["CMD-SHELL", "pg_isready -U openproject"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 2. 缓存服务（Memcached，单副本，使用固定版本避免行为变更）
  cache:
    image: memcached:1.6-alpine  # 替换latest为固定稳定版本，避免生产事故
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
    networks:
      - openproject_internal
    healthcheck:  # 补充健康检查
      test: ["CMD", "memcached-tool", "localhost:11211", "stats"]
      interval: 10s
      timeout: 5s
      retries: 3

  # 3. OpenProject Web服务（应用层，水平扩展，仅slim版）
  # 注意：必须配合S3/MinIO对象存储，否则附件/导出文件会出现丢失/错乱，未启用对象存储请保持replicas=1
  web:
    image: vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim
    environment:
      # 从Docker Secret读取统一加密密钥，避免Session失效
      - SECRET_KEY_BASE_FILE=/run/secrets/openproject_secret_key_base
      - OPENPROJECT_HOST__NAME=openproject.example.com
      - OPENPROJECT_HTTPS=true
      - DATABASE_URL=postgresql://openproject:openproject_password@db:5432/openproject  # 生产环境建议替换为Docker Secret
      - MEMCACHE_SERVER=cache:11211
      # 对象存储配置（集群必备，解决多副本数据错乱）
      - OPENPROJECT_ATTACHMENTS__STORAGE="fog"
      - OPENPROJECT_FOG_DIRECTORY="openproject-attachments"
      - OPENPROJECT_FOG_CREDENTIALS_PROVIDER="AWS"
      - OPENPROJECT_FOG_CREDENTIALS_AWS__ACCESS__KEY__ID="your-access-key"  # 生产环境建议替换为Docker Secret
      - OPENPROJECT_FOG_CREDENTIALS_AWS__SECRET__ACCESS__KEY="your-secret-key"  # 生产环境建议替换为Docker Secret
      - OPENPROJECT_FOG_CREDENTIALS_REGION="cn-north-1"
      - OPENPROJECT_FOG_CREDENTIALS_ENDPOINT="https://minio.example.com"
    secrets:
      - openproject_secret_key_base  # 挂载统一加密密钥
    depends_on:
      - db
      - cache
    deploy:
      replicas: 6  # 水平扩展6个web实例，启用对象存储后方可扩展
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 2  # 滚动更新，每次更新2个实例，避免服务中断
        delay: 30s
    networks:
      - openproject_internal
      - openproject_proxy
    # 健康检查（生产环境必备，兼容更多版本，替换/health路径）
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 300s
    labels:  # 补充Traefik所需标签，暴露OpenProject服务
      - traefik.enable=true
      - traefik.docker.network=openproject_proxy
      - traefik.http.routers.openproject.rule=Host(`openproject.example.com`)
      - traefik.http.routers.openproject.entrypoints=websecure
      - traefik.http.services.openproject.loadbalancer.server.port=80

  # 4. OpenProject Worker服务（任务处理，水平扩展，添加资源限制避免抢占Web资源）
  worker:
    image: vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim
    command: ./docker/prod/worker
    environment:
      - SECRET_KEY_BASE_FILE=/run/secrets/openproject_secret_key_base
      - DATABASE_URL=postgresql://openproject:openproject_password@db:5432/openproject
      - MEMCACHE_SERVER=cache:11211
    secrets:
      - openproject_secret_key_base
    depends_on:
      - db
      - cache
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
      resources:  # 新增：限制Worker资源，避免任务高峰期抢占Web服务资源
        limits:
          cpus: '1.0'
          memory: 1G
    networks:
      - openproject_internal

  # 5. 反向代理服务（Traefik，专业负载均衡，补充完整router/rule配置）
  traefik:
    image: traefik:v2.10
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro  # 只读挂载Docker套接字，获取服务信息
      - /etc/ssl/openproject:/ssl  # 挂载SSL证书（静态证书）
      - /var/traefik/acme.json:/acme.json  # ACME证书存储（如需自动申请Let's Encrypt）
    command:
      - --providers.docker=true
      - --providers.docker.swarmmode=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --entrypoints.web.http.redirections.entryPoint.to=websecure
      - --entrypoints.web.http.redirections.entryPoint.scheme=https
      - --entrypoints.websecure.http.tls=true  # 启用静态TLS
      # 如需自动申请Let's Encrypt证书，可添加以下配置（注释掉静态证书挂载，启用ACME）
      # - --certificatesresolvers.le.acme.email=admin@example.com
      # - --certificatesresolvers.le.acme.storage=/acme.json
      # - --certificatesresolvers.le.acme.httpchallenge.entrypoint=web
    deploy:
      replicas: 2  # 反向代理高可用，避免单点故障
      restart_policy:
        condition: on-failure
      placement:
        constraints: [node.role == manager]
    networks:
      - openproject_proxy

# 定义网络（隔离内部服务与外部代理）
networks:
  openproject_internal:
    driver: overlay
    internal: true  # 内部网络，不对外暴露
  openproject_proxy:
    driver: overlay
```

#### 4. 部署Swarm Stack并扩展服务
```bash
# 部署Stack（生产环境建议先在测试集群验证）
docker stack deploy -c openproject-stack.yml openproject

# 查看服务状态（确保所有服务replicas达到预期数量）
docker service ls | grep openproject

# 按需扩展web服务（示例：扩展到8个实例，仅启用对象存储后可执行）
docker service scale openproject_web=8
```

#### 5. 集群部署关键注意事项（必须遵守）
1.  所有Web/Worker实例必须使用**统一的SECRET_KEY_BASE**，通过Docker Secret管理，避免Session失效、Cookie无法解密，**严禁动态生成该密钥**。
2.  多副本Web服务必须配合**S3/MinIO对象存储**，严禁使用本地文件存储/NFS（高并发场景），否则会出现文件覆盖、丢失、下载404。
3.  反向代理必须使用**专业代理工具（Traefik/Nginx/HAProxy）**，禁止使用OpenProject应用镜像作为代理。
4.  **数据库服务警告**：Swarm示例中的PostgreSQL仅用于演示，生产环境必须使用独立高可用数据库（RDS/Patroni/云数据库），避免单点故障导致数据丢失。
5.  滚动更新时，建议设置`parallelism`为2-3，避免一次性更新所有实例导致服务不可用。
6.  Worker服务必须配置资源限制，避免任务高峰期抢占Web服务资源，导致用户访问卡顿。
7.  Docker Swarm中`depends_on`仅控制启动顺序，不保证依赖服务可用，需依赖**健康检查+应用自身重试机制**（OpenProject已内置数据库重试逻辑）。
8.  Traefik需通过`labels`配置router和service规则，否则无法暴露OpenProject服务，访问会出现404错误。

## 功能测试
容器/集群部署完成后，通过以下步骤验证服务是否正常运行（仅针对slim版生产环境）：

1.  **查看容器/服务状态**：
    ```bash
    # 单容器部署
    docker ps | grep openproject  # 确保状态为 Up
    # 补充：docker ps默认不显示健康状态，查看健康状态需执行以下命令
    docker inspect --format='{{.State.Health.Status}}' openproject-prod  # 确保输出为 healthy

    # Swarm集群部署
    docker service ls | grep openproject  # 确保所有服务 replicas 为 1/1 或指定数量
    docker service ps openproject_web  # 查看web服务实例运行状态，确保无失败
    ```

2.  **访问Web界面**：
    在浏览器中输入`https://<你的域名>`（或`https://<你的域名>/openproject`），若能看到OpenProject登录页面，说明反向代理与服务部署成功。

3.  **获取初始管理员账号**：
    容器首次启动时会生成默认管理员账号，可通过容器/服务日志获取：
    ```bash
    # 单容器部署
    docker logs openproject-prod | grep "Admin user"

    # Swarm集群部署（查看web服务日志）
    docker service logs openproject_web | grep "Admin user"
    ```
    补充：若未找到上述日志（新版本可能不打印或仅输出随机密码），可通过`openproject configure`命令或OpenProject Web界面重置管理员密码。

4.  **验证核心功能（生产环境必备）**：
    使用管理员账号登录后，验证以下核心功能是否正常：
    - 创建新项目、添加任务/工作包。
    - 上传附件、下载附件（集群环境重点验证，确保对象存储生效）。
    - 发送测试邮件（系统设置→邮件配置）。
    - 记录工时、生成项目报表并导出。
    - 集群环境：切换不同浏览器/设备登录，验证Session是否稳定（无频繁登出）。

## 故障排查
### 容器无法启动
1.  **查看详细启动日志**：
    ```bash
    docker logs <容器名称>  # 查看容器启动错误信息，常见错误：端口冲突、权限不足、数据库连接失败
    ```

2.  **检查端口占用**：
    ```bash
    ss -lntp | grep <映射端口>  # 替换netstat，适配Ubuntu 22.04+/Debian 12+等新系统，查看端口占用情况
    # 若端口已被占用，停止占用进程或修改映射端口
    ```

3.  **验证数据卷/目录权限**：
    ```bash
    # 数据卷权限检查
    docker volume inspect <数据卷名称>
    # 本地目录权限检查（确保适配容器非root用户 UID/GID 1000）
    ls -ld /var/openproject/prod  # 确保目录所有者为 1000:1000，权限为 775
    ```

4.  **解决伪TTY权限问题**：
    若出现`/dev/stdout: Permission denied`错误，添加`-t`参数重新启动容器：
    ```bash
    docker run -t -d --name openproject-prod ...
    ```
    补充：`-t`参数的作用是分配伪终端，解决某些Ruby logger在无TTY环境下写入`/dev/stdout`的权限异常，并非Docker stdout本身的权限问题。

5.  **Docker Secret相关故障**：
    若出现`SECRET_KEY_BASE`相关错误，验证Secret是否存在并正确挂载：
    ```bash
    docker secret ls | grep openproject_secret_key_base
    docker service inspect openproject_web | grep secret_key_base
    ```

### 服务访问异常
1.  **检查容器内服务状态**：
    ```bash
    docker exec -it <容器名称> curl -f http://localhost/  # 替换/health，兼容更多版本，验证容器内服务是否正常
    ```

2.  **检查反向代理配置**：
    ```bash
    nginx -t  # 验证Nginx配置语法
    tail -f /var/log/nginx/error.log  # 查看Nginx错误日志
    # Swarm集群（Traefik）
    docker service logs openproject_traefik
    ```

3.  **验证HOST头与HTTPS配置**：
    若出现`Invalid host`错误，确保`OPENPROJECT_HOST__NAME`与访问域名一致（不填写0.0.0.0/*/内网IP）；若出现重定向循环，确保`X-Forwarded-Proto`（Nginx）/Traefik TLS转发配置正确。

4.  **集群Session失效问题**：
    若出现用户频繁登出，验证所有Web/Worker实例是否使用统一的`SECRET_KEY_BASE`，确保Docker Secret正确挂载且未重复生成，**严禁在生产环境动态生成该密钥**。

### 数据卷/备份问题
1.  **数据卷损坏修复**：
    - 停止容器/服务：`docker stop <容器名称>` / `docker service scale openproject_web=0`
    - 创建新数据卷：`docker volume create <新数据卷名称>`
    - 从备份恢复数据：`docker run --rm -v <新数据卷名称>:/target -v <备份目录>:/backup alpine tar -xzf /backup/<备份文件>.tar.gz -C /target`
    - 使用新数据卷启动容器/服务。

2.  **备份脚本执行失败**：
    - 检查脚本执行权限：`chmod +x <备份脚本路径>`
    - 检查crontab日志：`tail -f /var/log/cron`
    - 手动执行脚本，查看错误信息：`/var/backups/openproject/backup_openproject.sh`
    - 集群环境：确保备份脚本可访问Swarm数据卷/对象存储。

### 集群多副本数据错乱问题
1.  若出现附件丢失、导出文件404，优先验证对象存储配置是否正确：
    ```bash
    docker service logs openproject_web | grep fog  # 查看对象存储相关日志
    ```
2.  未启用对象存储的集群，立即将Web服务副本数调整为1：`docker service scale openproject_web=1`
3.  更换为S3/MinIO对象存储，重新部署Stack。

## 高级操作
### 自定义插件安装
OpenProject官方镜像不直接支持插件安装，需通过构建自定义镜像实现，以下以安装`openproject-slack`插件为例，**仅使用slim版稳定镜像**：

#### 1. 准备构建文件
创建`custom-openproject`目录，在目录内创建以下文件：
- `Gemfile.plugins`（插件依赖配置）：
  ```ruby
  group :opf_plugins do
    gem "openproject-slack", git: "https://github.com/opf/openproject-slack.git", branch: "dev"
  end
  ```

- `Dockerfile`（构建自定义镜像，slim版稳定版示例）：
  ```dockerfile
  # 阶段1：安装插件并预编译资源
  FROM vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim AS plugin

  COPY Gemfile.plugins /app/

  # 安装插件依赖
  RUN bundle config unset deployment && bundle install && bundle config set deployment 'true'
  RUN ./docker/prod/setup/precompile-assets.sh

  # 阶段2：构建最终镜像
  FROM vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim

  # 复制插件相关文件
  COPY --from=plugin /usr/bin/git /usr/bin/git
  COPY --chown=$APP_USER:$APP_USER --from=plugin /app/vendor/bundle /app/vendor/bundle
  COPY --chown=$APP_USER:$APP_USER --from=plugin /app/public/assets /app/public/assets
  COPY --chown=$APP_USER:$APP_USER --from=plugin /app/config/frontend_assets.manifest.json /app/config/frontend_assets.manifest.json
  COPY --chown=$APP_USER:$APP_USER --from=plugin /app/Gemfile.* /app/
  ```

#### 2. 构建自定义镜像
```bash
cd custom-openproject
docker build --pull -t openproject-with-slack:17.0.0-slim .
```

#### 3. 运行自定义镜像
```bash
docker run -d \
  --name openproject-with-slack \
  --restart=always \
  -p 8080:80 \
  -e SECRET_KEY_BASE=your-fixed-secret-key-here \  # 固定值，禁止动态生成
  -e OPENPROJECT_HOST__NAME=localhost:8080 \
  -e OPENPROJECT_HTTPS=false \
  openproject-with-slack:17.0.0-slim
```

### 自签名证书导入
若需连接使用自签名证书的外部服务（如SMTP、MinIO），需将根证书导入容器，提供两种方案（仅针对slim版）：

#### 方案1：挂载证书并配置环境变量
```bash
docker run -d \
  --name openproject-with-ca \
  --restart=always \
  -p 8080:80 \
  -e SECRET_KEY_BASE=your-fixed-secret-key-here \  # 固定值，禁止动态生成
  -e OPENPROJECT_HOST__NAME=localhost:8080 \
  -e OPENPROJECT_HTTPS=false \
  --mount type=bind,source=$(pwd)/root.crt,target=/tmp/root.crt \
  -e SSL_CERT_FILE=/tmp/root.crt \
  vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim
```

#### 方案2：构建自定义镜像导入证书
```dockerfile
FROM vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim

USER root
COPY ./root.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates
USER $APP_USER
```

构建并运行镜像：
```bash
docker build -t openproject-with-custom-ca:17.0.0-slim .
docker run -d --name openproject-with-ca --restart=always -p 8080:80 openproject-with-custom-ca:17.0.0-slim
```

### 离线/气隙环境部署
在无互联网访问的服务器上部署OpenProject，需先在有网络的环境下拉取镜像并导出，再传输到目标服务器导入（仅针对slim版稳定镜像）：

#### 1. 有网络环境导出镜像
```bash
# 拉取稳定版slim镜像
docker pull vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim

# 导出镜像为压缩包
docker save vipxxx.xuanyuan.run/openproject/openproject:17.0.0-slim-bim | gzip > openproject-17.0.0-slim-bim.tar.gz
```

#### 2. 传输镜像到目标服务器
通过SFTP、SCP或U盘等方式，将`openproject-17.0.0-slim-bim.tar.gz`传输到离线服务器。

#### 3. 离线服务器导入镜像
```bash
# 导入镜像
gunzip openproject-17.0.0-slim-bim.tar.gz
docker load -i openproject-17.0.0-slim-bim.tar

# 后续部署步骤与在线环境一致（需提前准备外部数据库、对象存储等依赖）
```

### 生产环境升级流程（滚动升级，避免服务中断）
OpenProject升级需遵循"备份→验证→升级→测试"流程，生产环境推荐滚动升级，避免服务中断：

#### 1. 升级前准备（必备）
- 备份所有数据（配置、数据库、对象存储）。
- 查看官方升级文档，确认版本间兼容性（如16.x→17.x是否有重大变更）。
- 拉取目标版本稳定版slim镜像：`docker pull vipxxx.xuanyuan.run/openproject/openproject:17.1.0-slim-bim`。

#### 2. 单节点部署升级（停机升级，适合小型业务）
- 停止容器：`docker stop openproject-prod`
- 备份容器数据：`docker commit openproject-prod openproject-prod-backup:17.0.0`
- 启动新版本容器（使用原有数据卷/配置）：`docker run -d --name openproject-prod --restart=always ... vipxxx.xuanyuan.run/openproject/openproject:17.1.0-slim-bim`
- 验证服务状态：`docker logs -f openproject-prod`，确认无报错且健康状态为`healthy`（通过`docker inspect`查看）。

#### 3. 集群部署升级（滚动升级，适合大规模业务）
- 拉取目标版本镜像（所有集群节点）：`docker pull vipxxx.xuanyuan.run/openproject/openproject:17.1.0-slim-bim`
- 更新Stack配置文件中的镜像版本为`17.1.0-slim-bim`
- 滚动更新Stack：`docker stack deploy -c openproject-stack.yml openproject`
- 查看升级进度：`docker service ps openproject_web`，确保所有实例均已更新且无失败
- 验证服务功能：访问Web界面，测试核心功能（附件上传、任务创建等）。

## 参考资源
1.  轩辕镜像OpenProject文档：[https://xuanyuan.cloud/r/openproject/openproject](https://xuanyuan.cloud/r/openproject/openproject)
2.  轩辕镜像OpenProject标签列表：[https://xuanyuan.cloud/r/openproject/openproject/tags](https://xuanyuan.cloud/r/openproject/openproject/tags)
3.  OpenProject官方Docker安装指南：[https://docs.openproject.org/installation-and-operations/installation/docker/](https://docs.openproject.org/installation-and-operations/installation/docker/)
4.  OpenProject环境变量配置文档：[https://docs.openproject.org/installation-and-operations/configuration/environment-variables/](https://docs.openproject.org/installation-and-operations/configuration/environment-variables/)
5.  Docker Swarm官方文档：[https://docs.docker.com/swarm/](https://docs.docker.com/swarm/)
6.  Traefik Swarm部署指南：[https://doc.traefik.io/traefik/providers/docker/](https://doc.traefik.io/traefik/providers/docker/)

## 总结
### 核心要点
1.  OpenProject Docker镜像分为`all-in-one`（仅测试/PoC/演示）和`slim`（生产环境唯一推荐），生产环境必须使用**稳定版非浮动标签**（如17.0.0-slim-bim），严禁使用RC/dev标签。
2.  生产环境核心保障：**数据持久化（对象存储优先）、定期自动备份、HTTPS加密**，其中集群部署必须使用S3/MinIO对象存储解决多副本数据错乱问题。
3.  Docker Swarm集群部署关键：统一`SECRET_KEY_BASE`（Docker Secret，禁止动态生成）、专业反向代理（Traefik/Nginx，补充完整router/rule配置）、明确PostgreSQL单点演示风险、给Worker服务添加资源限制，避免生产事故。
4.  容器运行默认非root用户，生产环境凭据（SMTP/DB）严禁明文，推荐使用Docker Secret/.env文件管理，同时配置`--restart=always`，依赖官方镜像内置健康检查（兼容方案为`curl -f http://localhost/`）。
5.  自定义插件、自签名证书等高级需求，需通过构建自定义Docker镜像实现，升级前必须备份数据，遵循官方兼容性文档；`--memory-swap`在cgroup v2环境中存在无效风险，`OPENPROJECT_HOST__NAME`禁止填写0.0.0.0/*/内网IP。
6.  生产环境中，`SECRET_KEY_BASE`必须固定值，严禁在`docker run`中动态生成，否则容器重建/扩容后会导致Session失效、用户频繁登出。

### 典型生产事故案例（避坑指南）
1.  `SECRET_KEY_BASE`不一致/动态生成：集群多副本各自生成密钥，导致用户频繁登出、Cookie解密失败，解决方案：使用Docker Secret统一管理并固定密钥。
2.  多副本Web+本地文件存储：附件覆盖、丢失、下载404，解决方案：切换到S3/MinIO对象存储，或保持单副本。
3.  OpenProject作为反向代理：资源浪费、架构混乱，后期维护困难，解决方案：替换为Traefik/Nginx专业代理，并补充完整暴露规则。
4.  all-in-one用于核心生产：无法独立扩容、升级风险高、故障影响范围大，解决方案：迁移到slim版+外部依赖（DB/Cache/对象存储）。
5.  HTTPS重定向循环：`X-Forwarded-Proto`配置缺失，导致OpenProject无法识别HTTPS协议，解决方案：在反向代理中添加该请求头配置。
6.  Swarm示例PostgreSQL照抄到生产：管理节点宕机导致数据丢失，解决方案：使用RDS/Patroni等独立高可用数据库（PostgreSQL推荐13–16）。
7.  memcached:latest镜像导致行为变更：生产环境缓存服务异常，解决方案：使用固定稳定版本（如memcached:1.6-alpine）。

### 后续建议
1.  深入学习OpenProject官方文档，配置LDAP用户认证、插件管理等高级功能，适配团队业务需求。
2.  结合监控工具（Prometheus、Grafana）监控容器/集群运行状态，及时发现并解决资源不足、服务异常等问题。
3.  定期关注轩辕镜像与OpenProject官方版本更新，及时升级镜像以获取新功能与安全补丁，升级前需先备份数据并在测试环境验证。
4.  对于超大规模团队，可考虑使用Kubernetes替代Docker Swarm，实现更精细的资源管理与服务编排，配合Helm Chart简化部署流程。
5.  生产环境建议配置数据库主从复制、对象存储多区域备份，进一步提升系统高可用与数据安全性；单节点生产环境优先使用数据库层备份（pg_dump）替代容器硬停备份。

---

### 架构对照表（清晰区分不同场景）
| 部署场景 | 镜像版本 | 核心架构 | 适用规模 | 关键注意事项 |
|----------|----------|----------|----------|--------------|
| 测试/PoC/演示 | all-in-one | 单容器内置所有依赖 | 个人/小型团队演示 | 严禁用于核心生产，无需额外配置外部服务，数据路径`/var/openproject` |
| 单节点生产 | slim | 单容器+外部DB+本地/数据卷持久化 | 中小团队核心业务 | 配置HTTPS、定期备份、非root运行，数据路径`/var/lib/openproject`+`/etc/openproject`，`assets`目录非必需可省略，`--memory-swap`仅作参考 |
| 集群生产 | slim | Swarm/K8s+专业代理+外部高可用DB+S3/MinIO | 大规模团队/高并发场景 | 统一加密密钥、对象存储、滚动升级、高可用代理，PostgreSQL禁止使用Swarm单点配置，Traefik需补充labels暴露服务 |

---


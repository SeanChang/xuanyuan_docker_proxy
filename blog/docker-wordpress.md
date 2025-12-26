---
id: 37
title: Docker 部署 WordPress 全流程教程
slug: docker-wordpress
summary: WordPress 是全球最流行的开源内容管理系统（CMS），基于 PHP + MySQL 架构，截至目前，全球超过 43% 的网站使用 WordPress 构建，从个人博客到大型媒体平台（如《纽约时报》部分栏目）均有应用，是入门建站和快速迭代业务的首选工具。
category: Docker,WordPress
tags: wordPress,docker,部署教程
image_name: library/wordpress
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-wordpress.png"
status: published
created_at: "2025-10-23 13:43:41"
updated_at: "2025-10-23 13:43:41"
---

# Docker 部署 WordPress 全流程教程

> WordPress 是全球最流行的开源内容管理系统（CMS），基于 PHP + MySQL 架构，截至目前，全球超过 43% 的网站使用 WordPress 构建，从个人博客到大型媒体平台（如《纽约时报》部分栏目）均有应用，是入门建站和快速迭代业务的首选工具。

在开始 WordPress 镜像拉取与部署操作前，先明确其核心价值与 Docker 部署的优势——帮你更清晰理解每一步操作的实际意义，避免机械执行命令。

## 关于 WordPress：核心功能与价值
WordPress 是全球最流行的开源内容管理系统（CMS），基于 PHP + MySQL 架构，核心价值体现在三大场景：  
- **快速建站**：无需复杂开发，通过模板和插件即可搭建博客、企业官网、电商平台、知识库等各类网站，零基础也能上手；  
- **高度可扩展**：支持 5 万+ 免费插件（如 SEO 优化、表单提交、支付集成）和 1 万+ 模板，可按需扩展功能和外观，无需修改核心代码；  
- **轻量易维护**：占用服务器资源少，后台管理界面直观，日常更新、备份、内容编辑操作简单，适合个人和中小企业使用。  

截至目前，全球超过 43% 的网站使用 WordPress 构建，从个人博客到大型媒体平台（如《纽约时报》部分栏目）均有应用，是入门建站和快速迭代业务的首选工具。

## 为什么用 Docker 部署 WordPress？核心优势
传统部署 WordPress（通过 `yum`/`apt` 安装 PHP、MySQL、Apache 等组件）常面临**环境配置繁琐、版本冲突、数据迁移困难、多站点隔离差**等问题（例如：手动配置 PHP 扩展时遗漏依赖导致安装失败；多站点共用服务器时，一个站点故障影响所有站点）。而 Docker 部署能彻底解决这些痛点，核心优势如下：  

1. **环境一键就绪**：WordPress 镜像已打包所有运行依赖（PHP 解释器、Apache/Nginx 服务器、核心代码），配合 MySQL 镜像，无需单独配置运行环境，拉取镜像即可启动，新手也能 10 分钟完成部署；  
2. **数据与环境隔离**：WordPress 程序文件、用户数据、数据库数据通过容器卷挂载到宿主机，与主机环境完全隔离，避免误操作删除数据，同时多站点部署时可通过独立容器隔离，互不干扰；  
3. **迁移与备份便捷**：迁移网站时，只需复制宿主机挂载目录和镜像，在新服务器启动容器即可恢复，无需重新配置环境；备份时直接打包挂载目录，比传统备份数据库+程序文件更高效；  
4. **版本灵活切换**：支持拉取不同 PHP 版本（8.1-8.4）、不同运行模式（Apache/FPM/Alpine）的 WordPress 镜像，切换版本只需更换镜像标签，测试新版本时不影响现有站点；  
5. **资源占用可控**：Docker 容器可限制 CPU、内存使用，WordPress 容器默认占用内存仅几十 MB，比传统部署节省 30% 以上资源，适合低配服务器或多服务混布场景。

## 🧰 准备工作
若你的系统尚未安装 Docker 和 Docker Compose，请先通过轩辕镜像提供的一键脚本完成安装（支持主流 Linux 发行版）。

### Linux Docker & Docker Compose 一键安装
该脚本会自动安装最新稳定版 Docker、Docker Compose，并配置轩辕镜像访问支持源（解决官方镜像拉取慢的问题），无需手动修改配置文件。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

#### 验证安装成功
执行以下命令，若能显示 Docker 版本信息，说明安装完成：
```bash
docker --version && docker compose --version
```

## 1、查看 WordPress 镜像
你可以在 **轩辕镜像平台** 查看 WordPress 镜像的详细信息（包括支持的标签、镜像大小、更新记录等）：  
👉 [https://xuanyuan.cloud/r/library/wordpress](https://xuanyuan.cloud/r/library/wordpress)

镜像支持多种 PHP 版本（8.1-8.4）和运行模式（Apache/FPM/Alpine），推荐新手使用默认标签（PHP 8.3 + Apache，标签为 `latest`），兼容性最好、配置最简单。

## 2、下载 WordPress 镜像
以下提供 4 种镜像拉取方式，优先推荐「免登录拉取」（无需配置账户，新手友好），所有方式拉取的镜像内容完全一致。

### 2.1 登录验证拉取（需轩辕镜像账户）
若已注册轩辕镜像账户，可通过以下命令拉取：
```bash
docker pull docker.xuanyuan.run/library/wordpress:latest
```

### 2.2 拉取后重命名（简化后续命令）
若觉得镜像名称过长，可拉取后重命名为官方标准名称，方便后续使用：
```bash
# 拉取轩辕镜像
docker pull docker.xuanyuan.run/library/wordpress:latest \
# 重命名为官方名称
&& docker tag docker.xuanyuan.run/library/wordpress:latest library/wordpress:latest \
# 删除原标签，节省存储空间
&& docker rmi docker.xuanyuan.run/library/wordpress:latest
```

### 2.3 免登录拉取（推荐，新手首选）
无需注册账户，直接通过免登录地址拉取，步骤更简洁：
```bash
# 基础拉取命令
docker pull xxx.xuanyuan.run/library/wordpress:latest

# 带重命名的完整命令（推荐）
docker pull xxx.xuanyuan.run/library/wordpress:latest \
&& docker tag xxx.xuanyuan.run/library/wordpress:latest library/wordpress:latest \
&& docker rmi xxx.xuanyuan.run/library/wordpress:latest
```

### 2.4 官方直连拉取（需配置镜像访问支持）
若已通过轩辕镜像一键脚本配置了加速器，可直接使用官方命令拉取（底层仍通过轩辕镜像访问支持）：
```bash
docker pull library/wordpress:latest
```

### 2.5 验证镜像拉取成功
执行以下命令，若输出包含 `library/wordpress:latest`，说明拉取成功：
```bash
docker images
```

示例输出：
```
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
library/wordpress   latest    7f2f1b48991f   1 week ago     630MB
```

## 3、部署 WordPress
WordPress 依赖 MySQL 数据库（存储文章、用户、配置等数据），以下提供 3 种部署方案，可根据使用场景选择。

### 3.1 快速部署（适合测试/临时使用）
无需手动配置数据库，通过 `--link` 关联 MySQL 容器，一键启动 WordPress，适合快速体验功能。

#### 第一步：启动 MySQL 容器（提供数据库服务）
```bash
docker run -d \
  --name wp-mysql \
  -e MYSQL_ROOT_PASSWORD=wp@123456 \  # MySQL  root 密码（自定义，建议复杂密码）
  -e MYSQL_DATABASE=wordpress \       # 自动创建 WordPress 数据库
  -e MYSQL_USER=wpuser \              # WordPress 数据库用户
  -e MYSQL_PASSWORD=wpuser@123 \      # WordPress 数据库密码
  library/mysql:8.0  # 使用 MySQL 8.0 镜像（兼容性最好）
```

#### 第二步：启动 WordPress 容器（关联 MySQL）
```bash
docker run -d \
  --name wp-test \
  --link wp-mysql:db \  # 关联 MySQL 容器，容器内可通过「db」访问数据库
  -p 80:80 \            # 宿主机 80 端口映射到容器 80 端口（WordPress 默认端口）
  -e WORDPRESS_DB_HOST=db \          # 数据库地址（对应 --link 的别名）
  -e WORDPRESS_DB_USER=wpuser \      # 数据库用户（与 MySQL 容器配置一致）
  -e WORDPRESS_DB_PASSWORD=wpuser@123 \  # 数据库密码（与 MySQL 容器配置一致）
  -e WORDPRESS_DB_NAME=wordpress \   # 数据库名称（与 MySQL 容器配置一致）
  library/wordpress:latest
```

#### 验证方式
浏览器访问 `http://服务器IP`，若显示 WordPress 安装向导页面，说明部署成功。

### 3.2 挂载目录部署（推荐，适合生产使用）
通过挂载宿主机目录，实现「数据持久化」（容器删除后数据不丢失）、「文件独立管理」（可直接在宿主机修改主题/插件），步骤如下：

#### 第一步：创建宿主机目录（存储数据和配置）
```bash
# 一次性创建 4 个目录，分别存储网页文件、插件/主题、日志、配置
mkdir -p /data/wordpress/{html,wp-content,logs,conf}
```

#### 第二步：启动 MySQL 容器（挂载数据目录）
```bash
docker run -d \
  --name wp-mysql \
  -e MYSQL_ROOT_PASSWORD=wp@123456 \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=wpuser@123 \
  -v /data/wordpress/mysql:/var/lib/mysql \  # 挂载 MySQL 数据目录（持久化数据）
  --restart always \  # 容器退出后自动重启（保障服务可用性）
  library/mysql:8.0
```

#### 第三步：启动 WordPress 容器（挂载目录）
```bash
docker run -d \
  --name wp-prod \
  --link wp-mysql:db \
  -p 80:80 \
  -e WORDPRESS_DB_HOST=db \
  -e WORDPRESS_DB_USER=wpuser \
  -e WORDPRESS_DB_PASSWORD=wpuser@123 \
  -e WORDPRESS_DB_NAME=wordpress \
  -e TZ=Asia/Shanghai \  # 设置时区（避免时间显示错误）
  -v /data/wordpress/html:/var/www/html \  # 挂载网页根目录
  -v /data/wordpress/wp-content:/var/www/html/wp-content \  # 挂载插件/主题目录
  -v /data/wordpress/logs:/var/log/apache2 \  # 挂载 Apache 日志目录
  -v /data/wordpress/conf:/etc/apache2/conf-enabled \  # 挂载 Apache 配置目录
  --restart always \
  library/wordpress:latest
```

#### 目录映射说明（重要）
| 宿主机目录                | 容器内目录                  | 用途                                  |
|---------------------------|-----------------------------|---------------------------------------|
| `/data/wordpress/html`    | `/var/www/html`             | 存储 WordPress 核心程序文件            |
| `/data/wordpress/wp-content` | `/var/www/html/wp-content` | 存储插件、主题、上传的图片/文件        |
| `/data/wordpress/logs`    | `/var/log/apache2`          | 存储 Apache 访问日志、错误日志        |
| `/data/wordpress/conf`    | `/etc/apache2/conf-enabled` | 存储 Apache 自定义配置（如 HTTPS 配置）|

#### 第四步：完成 WordPress 安装
浏览器访问 `http://服务器IP`，按向导完成以下步骤：
1. 选择语言（推荐「简体中文」）；
2. 填写站点标题、管理员用户名、密码、邮箱；
3. 点击「安装 WordPress」，完成后跳转到登录页面；
4. 输入管理员账号密码，进入后台管理界面。

### 3.3 Docker Compose 部署（适合企业级场景）
通过 `docker-compose.yml` 文件统一管理 WordPress 和 MySQL 容器，支持一键启动/停止/备份，适合长期维护和多服务管理。

#### 第一步：创建 docker-compose.yml 文件
在任意目录（如 `/data/wordpress`）创建文件，内容如下：
```yaml
version: '3'  # 指定 Compose 语法版本
services:
  # MySQL 服务配置
  db:
    image: library/mysql:8.0
    container_name: wp-mysql
    environment:
      MYSQL_ROOT_PASSWORD: wp@123456  # 自定义 root 密码
      MYSQL_DATABASE: wordpress       # 自动创建数据库
      MYSQL_USER: wpuser              # 数据库用户
      MYSQL_PASSWORD: wpuser@123      # 数据库密码
    volumes:
      - ./mysql:/var/lib/mysql        # 挂载 MySQL 数据目录
    restart: always  # 自动重启
    networks:
      - wp-network  # 加入自定义网络（隔离其他服务）

  # WordPress 服务配置
  wordpress:
    image: library/wordpress:latest
    container_name: wp-service
    depends_on:
      - db  # 先启动 db 服务再启动 WordPress
    environment:
      WORDPRESS_DB_HOST: db           # 数据库地址（对应 db 服务名）
      WORDPRESS_DB_USER: wpuser       # 数据库用户（与 db 配置一致）
      WORDPRESS_DB_PASSWORD: wpuser@123  # 数据库密码（与 db 配置一致）
      WORDPRESS_DB_NAME: wordpress    # 数据库名称（与 db 配置一致）
      TZ: Asia/Shanghai               # 时区配置
    ports:
      - "80:80"                       # 端口映射
      - "443:443"                     # 预留 HTTPS 端口
    volumes:
      - ./html:/var/www/html          # 挂载网页目录
      - ./wp-content:/var/www/html/wp-content  # 挂载插件/主题目录
      - ./logs:/var/log/apache2       # 挂载日志目录
      - ./conf:/etc/apache2/conf-enabled  # 挂载配置目录
    restart: always
    networks:
      - wp-network

# 自定义网络（隔离容器）
networks:
  wp-network:
```

#### 第二步：启动服务
在 `docker-compose.yml` 所在目录执行以下命令，一键启动所有服务：
```bash
docker compose up -d
```

#### 常用命令（运维必备）
- 停止服务：`docker compose down`（不会删除挂载数据）
- 查看服务状态：`docker compose ps`
- 查看日志：`docker compose logs -f wordpress`（实时查看 WordPress 日志）
- 重启服务：`docker compose restart`

## 4、结果验证
通过以下 3 种方式确认 WordPress 服务正常运行：

### 4.1 浏览器验证（最直观）
- 访问 `http://服务器IP`，能看到 WordPress 前台页面或登录页面；
- 访问 `http://服务器IP/wp-admin`，能正常登录后台管理界面，说明服务正常。

### 4.2 容器状态验证
执行以下命令，若 `STATUS` 列均显示 `Up`，说明容器运行正常：
```bash
docker ps
```

示例输出：
```
CONTAINER ID   IMAGE                     COMMAND                  CREATED         STATUS         PORTS                                      NAMES
a1b2c3d4e5f6   library/wordpress:latest  "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   wp-service
f6e5d4c3b2a1   library/mysql:8.0         "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes   3306/tcp, 33060/tcp                        wp-mysql
```

### 4.3 日志验证
查看 WordPress 容器日志，无报错信息即表示启动正常：
```bash
# 若用 docker run 启动，容器名为 wp-prod
docker logs wp-prod

# 若用 docker compose 启动，容器名为 wp-service
docker logs wp-service
```

正常日志示例（包含 `Apache/2.4.56 (Debian) configured -- resuming normal operations`）：
```
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.3. Set the 'ServerName' directive globally to suppress this message
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.3. Set the 'ServerName' directive globally to suppress this message
[Mon Oct 09 10:00:00.000000 2024] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.56 (Debian) PHP/8.3.10 configured -- resuming normal operations
[Mon Oct 09 10:00:00.000000 2024] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D FOREGROUND'
```

## 5、常见问题排查
### 5.1 访问不到 WordPress 安装页面？
#### 排查方向：
1. **端口冲突**：执行 `netstat -tuln | grep 80`，查看 80 端口是否被其他服务（如 Nginx、Apache）占用，若占用则更换宿主机端口（如 `-p 8080:80`）；
2. **安全组/防火墙**：  
   - 云服务器：检查安全组是否放行 80 端口；  
   - 本地服务器：执行 `sudo ufw allow 80/tcp`（Ubuntu）或 `sudo firewall-cmd --add-port=80/tcp --permanent && sudo firewall-cmd --reload`（CentOS）开放端口；
3. **容器未启动**：执行 `docker ps -a` 查看容器状态，若 `STATUS` 为 `Exited`，执行 `docker logs 容器名` 查看报错原因（如数据库连接失败）。

### 5.2 数据库连接失败？
#### 排查方向：
1. **环境变量配置错误**：确认 WordPress 容器的 `WORDPRESS_DB_HOST`、`WORDPRESS_DB_USER`、`WORDPRESS_DB_PASSWORD`、`WORDPRESS_DB_NAME` 与 MySQL 容器配置一致；
2. **MySQL 容器未启动**：执行 `docker start wp-mysql` 启动 MySQL 容器，等待 30 秒后再重启 WordPress 容器；
3. **MySQL 权限问题**：若使用 MySQL 8.0，需确认用户权限已授权远程访问（可进入 MySQL 容器执行 `mysql -u root -p`，然后运行 `GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%'; FLUSH PRIVILEGES;`）；
4. **网络隔离**：若用 Docker Compose，确认两个容器在同一网络（如 `wp-network`），可通过 `docker network inspect wp-network` 查看容器是否在网络内。

### 5.3 插件/主题安装失败（提示权限不足）？
#### 解决方法：
1. 给宿主机挂载目录设置权限：
```bash
chmod -R 755 /data/wordpress/wp-content
chown -R www-data:www-data /data/wordpress/wp-content
```
2. 若仍失败，在 WordPress 后台「外观→主题」或「插件→安装插件」页面，选择「上传插件/主题」（通过本地文件上传，绕开权限限制）。

### 5.4 容器重启后数据丢失？
#### 原因：
未挂载数据目录，容器删除后数据随容器一起删除。

#### 解决方法：
1. 停止并删除现有容器：
```bash
docker stop wp-prod wp-mysql && docker rm wp-prod wp-mysql
```
2. 按照「3.2 挂载目录部署」或「3.3 Docker Compose 部署」重新启动容器（确保挂载了 `/data/wordpress/mysql` 和 `/data/wordpress/wp-content` 目录）；
3. 若已丢失数据，可通过 MySQL 备份文件恢复（若之前有备份）。

### 5.5 如何启用 HTTPS？
#### 步骤：
1. 准备 SSL 证书（如 Let's Encrypt 免费证书），获取 `fullchain.pem`（证书链）和 `privkey.pem`（私钥）；
2. 在宿主机创建证书目录：`mkdir -p /data/wordpress/certs`，将证书文件放入该目录；
3. 启动容器时添加证书挂载参数（以挂载目录部署为例）：
```bash
-v /data/wordpress/certs:/etc/apache2/certs \  # 挂载证书目录
```
4. 创建 Apache HTTPS 配置文件 `/data/wordpress/conf/ssl.conf`，内容如下：
```apache
<VirtualHost *:443>
    ServerName 你的域名（如 example.com）
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/apache2/certs/fullchain.pem
    SSLCertificateKeyFile /etc/apache2/certs/privkey.pem

    ErrorLog /var/log/apache2/ssl-error.log
    CustomLog /var/log/apache2/ssl-access.log combined
</VirtualHost>
```
5. 重启 WordPress 容器：`docker restart wp-prod`；
6. 访问 `https://你的域名`，验证 HTTPS 是否生效。

## 结尾
至此，你已掌握基于轩辕镜像的 WordPress 镜像拉取与 Docker 部署全流程——从环境准备、镜像下载，到不同场景的部署方案，再到常见问题排查，每个步骤都配备了可直接复制的命令和清晰说明。

对于初学者，建议先从「快速部署」熟悉流程，再尝试「挂载目录部署」理解数据持久化的重要性，最后根据业务需求进阶到「Docker Compose」管理（适合长期维护）。在实际使用中，若遇到文档未覆盖的问题，可通过 `docker logs 容器名` 查看日志定位原因，或参考 WordPress 官方文档、轩辕镜像平台帮助中心补充学习。

随着实践深入，你还可以基于本文基础，进一步探索 WordPress 的备份策略、插件优化、性能调优（如开启缓存插件、配置 CDN）等功能，让 WordPress 站点更稳定、更高效地支撑你的业务需求。


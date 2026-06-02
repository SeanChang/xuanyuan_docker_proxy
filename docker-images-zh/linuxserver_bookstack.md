<!-- xuanyuan-docker-images-zh
image: linuxserver/bookstack
source: https://xuanyuan.cloud/zh/r/linuxserver/bookstack
canonical: https://xuanyuan.cloud/zh/r/linuxserver/bookstack
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/bookstack" title="linuxserver/bookstack Docker 镜像中文简介、标签列表与拉取命令">linuxserver/bookstack — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/linuxserver/bookstack" title="linuxserver/bookstack Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/bookstack</a></p>

# LinuxServer.io BookStack 容器介绍  


## LinuxServer.io 团队简介  
LinuxServer.io 团队专注于提供高质量容器，主要特点包括：  
- 定期及时的应用更新  
- 简化的用户权限映射（PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周系统更新，通过跨生态通用层减少存储空间、 downtime 和带宽消耗  
- 定期安全更新  


## BookStack 容器概述  
[BookStack]([]) 是一款免费开源的 Wiki 工具，专为创建美观文档设计。它提供直观的 WYSIWYG 编辑器，同时支持 Markdown，帮助团队轻松构建详细实用的文档。BookStack 基于 SQL 数据库，致力于让文档编写从负担变为享受。  


## 支持的架构  
容器通过 Docker 清单实现多平台支持，拉取 `lscr.io/linuxserver/bookstack:latest` 即可自动匹配对应架构。也可通过标签指定架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\>|  


## 应用设置  

### 初始访问  
默认用户名：`[邮箱已删除]`，密码：`password`。访问地址：`http://<主机IP>:6875`。  

### 依赖说明  
需搭配 MariaDB 数据库（可使用 [LinuxServer MariaDB 容器]([])）。  

### 反向代理配置  
若通过子路径反向代理（如 SWAG 或 Traefik），**必须**设置 `APP_URL` 环境变量为外部域名，否则无法正常使用。  

### 文件路径映射  
容器将 BookStack 关键文件/目录持久化到 `/config` 目录，方便数据持久化。以下为容器内路径与 BookStack 原生路径的映射关系：  

| 容器内路径                  | BookStack 相对路径               |  
|-----------------------------|----------------------------------|  
| `/config/www/.env`          | `.env`（配置文件）               |  
| `/config/log/bookstack/laravel.log` | `storage/logs/laravel.log`（日志） |  
| `/config/backups/`          | `storage/backups/`（备份）       |  
| `/config/www/files/`        | `storage/uploads/files/`（文件上传） |  
| `/config/www/images/`       | `storage/uploads/images/`（图片上传） |  
| `/config/www/themes/`       | `themes/`（主题）                |  
| `/config/www/uploads/`      | `public/uploads/`（公共上传）    |  


### 修改 APP_URL  
若初始安装后需更改 `APP_URL`，需在主机终端运行以下命令更新数据库条目：  
```shell  
docker exec -it bookstack php /app/www/artisan bookstack:update-url ${旧URL} ${新URL}  
```  

### 高级配置（自定义 .env 文件）  
如需配置邮件、LDAP 等高级功能，可通过环境变量或自定义 `.env` 文件实现。容器会自动在 `/config/www/.env` 生成示例配置文件，可参考 [BookStack 官方文档]([]) 修改。  


## 只读运行  
本镜像支持只读容器文件系统，需注意：  
- 必须将 `/tmp` 挂载为 tmpfs  
- 详情参考 [LinuxServer 只读文档]([])  


## 使用方法  

### 前置说明  
除非参数标记为“可选”，否则为必填项，必须提供值。  


### Docker Compose（推荐）  
```yaml  
---  
services:  
  bookstack:  
    image: lscr.io/linuxserver/bookstack:latest  
    container_name: bookstack  
    environment:  
      - PUID=1000               # 用户ID，详见下方说明  
      - PGID=1000               # 组ID，详见下方说明  
      - TZ=Etc/UTC              # 时区，参考时区列表  
      - APP_URL=                # 应用访问地址（如 []  
      - APP_KEY=                # 会话加密密钥，需通过命令生成（详见参数说明）  
      - DB_HOST=                # 数据库主机名  
      - DB_PORT=3306            # 数据库端口  
      - DB_USERNAME=            # 数据库用户名  
      - DB_PASSWORD=            # 数据库密码（至少4位，特殊字符需转义）  
      - DB_DATABASE=            # 数据库名  
      - QUEUE_CONNECTION=       # 可选，设为 database 启用异步操作（如邮件发送）  
    volumes:  
      - /path/to/bookstack/config:/config  # 持久化配置目录  
    ports:  
      - 6875:80                 # Web访问端口  
    restart: unless-stopped  
```  


### Docker CLI  
```bash  
docker run -d \  
  --name=bookstack \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -e APP_URL= \  
  -e APP_KEY= \  
  -e DB_HOST= \  
  -e DB_PORT=3306 \  
  -e DB_USERNAME= \  
  -e DB_PASSWORD= \  
  -e DB_DATABASE= \  
  -e QUEUE_CONNECTION= `#可选` \  
  -p 6875:80 \  
  -v /path/to/bookstack/config:/config \  
  --restart unless-stopped \  
  lscr.io/linuxserver/bookstack:latest  
```  


## 参数说明  

| 参数                  | 功能说明                                                                 |  
|-----------------------|--------------------------------------------------------------------------|  
| `-p 6875:80`          | Web访问端口映射                                                          |  
| `-e PUID=1000`        | 用户ID，避免权限问题，通过 `id your_user` 命令获取                       |  
| `-e PGID=1000`        | 组ID，同上                                                               |  
| `-e TZ=Etc/UTC`       | 时区，参考 [时区列表]() |  
| `-e APP_URL=`         | 应用外部访问地址（含协议、IP/域名、端口）                                |  
| `-e APP_KEY=`         | 会话加密密钥，生成命令：`docker run -it --rm --entrypoint /bin/bash lscr.io/linuxserver/bookstack:latest appkey` |  
| `-e DB_HOST=`         | 数据库主机名                                                            |  
| `-e DB_PORT=3306`     | 数据库端口                                                              |  
| `-e DB_USERNAME=`     | 数据库用户名                                                            |  
| `-e DB_PASSWORD=`     | 数据库密码（至少4位，特殊字符需转义）                                    |  
| `-e DB_DATABASE=`     | 数据库名                                                                |  
| `-e QUEUE_CONNECTION=`| 可选，设为 database 启用异步操作（参考 [官方文档]([])） |  
| `-v /config`          | 持久化配置目录                                                          |  
| `--read-only=true`    | 启用只读文件系统（需配合 tmpfs 挂载）                                   |  


## 环境变量文件（Docker Secrets）  
可通过 `FILE__` 前缀从文件加载环境变量，例如：  
```bash  
-e FILE__MYVAR=/run/secrets/mysecretvariable  
```  
此命令会将 `/run/secrets/mysecretvariable` 文件内容作为 `MYVAR` 的值。  


## Umask 设置  
可通过 `-e UMASK=022` 覆盖默认 umask（文件权限掩码）。注意 umask 是权限减法，而非直接设置权限，详情参考 [umask 说明]()。  


## 用户/组 ID  
使用卷挂载时，主机与容器可能出现权限冲突。通过 `PUID` 和 `PGID` 指定用户/组 ID，确保主机卷目录所有者与容器内一致即可解决。获取当前用户 ID：  
```bash  
id your_user  
```  
输出示例：`uid=1000(your_user) gid=1000(your_user)`  


## Docker Mods  
可通过 Docker Mods 扩展容器功能，支持 BookStack 的 Mods 及通用 Mods 列表见 [LinuxServer Mods 页面]([])。  


## 支持信息  

### 容器内操作  
- 进入容器 shell：  
  ```bash  
  docker exec -it bookstack /bin/bash  
  ```  
- 实时查看日志：  
  ```bash  
  docker logs -f bookstack  
  ```  

### 版本查询  
- 容器版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' bookstack  
  ```  
- 镜像版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/bookstack:latest  
  ```  


## 更新方法  

### 通过 Docker Compose  
- 更新镜像（全部或单个）：  
  ```bash  
  docker-compose pull        # 全部镜像  
  # 或  
  docker-compose pull bookstack  # 单个镜像  
  ```  
- 重启容器（全部或单个）：  
  ```bash  
  docker-compose up -d       # 全部容器  
  # 或  
  docker-compose up -d bookstack  # 单个容器  
  ```  
- 清理旧镜像：  
  ```bash  
  docker image prune  
  ```  


### 通过 Docker Run  
- 更新镜像：  
  ```bash  
  docker pull lscr.io/linuxserver/bookstack:latest  
  ```  
- 停止并删除旧容器：  
  ```bash  
  docker stop bookstack  
  docker rm bookstack  
  ```  
- 用原参数重新创建容器（卷映射正确则配置保留）  
- 清理旧镜像：  
  ```bash  
  docker image prune  
  ```  


### 镜像更新通知  
推荐使用 [Diun]([]) 接收更新通知，不建议使用自动更新工具。  


## 本地构建  
如需自定义镜像：  
```bash  
git clone []  
cd docker-bookstack  
docker build \  
  --no-cache \  
  --pull \  
  -t lscr.io/linuxserver/bookstack:latest .  
```  
跨架构构建（如 x86_64 构建 ARM 镜像）需先运行：  
```bash  
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset  
```  
然后指定架构 Dockerfile（如 `-f Dockerfile.aarch64`）。  


## 版本历史  
- **05.07.25:** 基于 Alpine 3.22 重构  
- **04.01.25:** 添加 php-opcache  
- **17.12.24:** 基于 Alpine 3.21 重构  
- **11.10.24:** 默认优先使用环境变量配置（而非 .env 文件）  
- **06.09.24:** 添加 php-exif 支持图片 EXIF 数据读取  
- **27.05.24:** 基于 Alpine 3.20 重构，用户需更新 nginx 配置避免 http2 警告  
- **25.01.24:** 用户需更新 site-confs/default.conf（清理默认站点配置）  
- **23.12.23:** 基于 Alpine 3.19 重构，使用 PHP 8.3  
- **31.10.23:** 优化 sed 替换逻辑  
- **07.06.23:** 添加 mariadb-client 支持 bookstack-system-cli  
- **25.05.23:** 基于 Alpine 3.18 重构，移除 armhf 支持  
- **13.04.23:** 将 ssl.conf 引入 default.conf  
- **01.03.23:** 添加 php iconv  
- **19.01.23:** 基于 Alpine 3.17 重构，使用 PHP 8.1  
- **16.01.23:** .env 文件值添加引号包裹  
- **05.01.23:** 修复数据库密码设置（sed 转义 & 符号）  
- **21.12.22:** 环境变量更新时自动同步 .env 文件  
- **10.10.22:** 移除密码转义逻辑（解决部分用户问题）  
- **20.08.22:** 基于 Alpine 3.15 重构，使用 PHP 8，调整 nginx 配置  
- **14.03.22:** 添加主题支持符号链接  
- **11.07.21:** 基于 Alpine 3.14 重构  
- **12.01.21:** 移除 0.31.0 版本后不再需要的依赖  
- **17.12.20:** APP_URL 设为必填项（上游变更）  
- **17.09.20:** 基于 Alpine 3.12 重构，修复 APP_URL 设置，默认上传大小调整为 100MB  
- **19.12.19:** 基于 Alpine 3.11 重构  
- **26.07.19:** 使用旧版 tidyhtml 等待上游修复  
- **28.06.19:** 基于 Alpine 3.10 重构  
- **14.06.19:** 添加 wkhtmltopdf 支持 PDF 导出  
- **20.04.19:** 基于 Alpine 3.9 重构，添加 MySQL 初始化逻辑  
- **22.03.19:** 切换基础镜像，使用 arm32v7 标签  
- **20.01.19:** 添加 php7-curl  
- **04.11.18:** 添加 php7-ldap  
- **15.10.18:** 优化高级用户功能  
- **08.10.18:** 高级模式、符号链接调整、sed 修复、文档更新  
- **23.09.28:** 更新预发布版本  
- **02.07.18:** 初始发布  


## 社区资源  
- [博客]([])：容器使用指南、教程及观点  
- []()：实时支持与社区交流  
- [论坛]([])：社区讨论  
- [GitHub]([])：源码仓库  
- [Open Collective]([])：支持我们的开发

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/bookstack" title="linuxserver/bookstack Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/bookstack</a></p>

---
image: linuxserver/nginx
description: "LinuxServer.io提供的Nginx容器，用于部署Web服务器、实现反向代理及HTTP缓存等基础Web服务。"
source: https://xuanyuan.cloud/zh/r/linuxserver/nginx
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[linuxserver/nginx](https://xuanyuan.cloud/zh/r/linuxserver/nginx)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/nginx Docker 镜像文档

## 镜像概述和主要用途

[linuxserver/nginx](https://github.com/linuxserver/docker-nginx) 是由 LinuxServer.io 团队提供的 Nginx 容器镜像。Nginx 是一款轻量级 Web 服务器，支持 PHP 功能，配置文件存放于 `/config` 目录，便于用户自定义修改。该镜像旨在提供稳定、易用的 Nginx 部署方案，适用于各类 Web 服务场景。


## 核心功能和特性

### LinuxServer.io 团队特性
- **定期应用更新**：及时同步上游 Nginx 及 PHP 版本更新
- **灵活用户映射**：通过 PUID/PGID 轻松配置容器内用户权限，避免宿主机权限冲突
- **自定义基础镜像**：集成 s6 overlay 进程管理系统，确保服务稳定运行
- **每周系统更新**：统一维护基础 OS 层，减少存储空间占用、 downtime 及带宽消耗
- **定期安全更新**：及时修复已知安全漏洞，保障服务安全性

### Nginx 镜像特性
- **PHP 支持**：内置 PHP 环境，可直接运行 PHP 应用
- **易配置性**：所有配置文件集中于 `/config` 目录，便于持久化和自定义
- **多架构支持**：适配 x86-64、arm64 等主流架构
- **只读文件系统**：支持以只读模式运行容器（需特殊配置）
- **配置自动重载**：支持监控配置文件变化并自动重启 Nginx，无需手动干预


## 使用场景和适用范围

- **个人网站托管**：部署静态网站或 PHP 动态网站（如 WordPress、Typecho 等）
- **开发测试环境**：快速搭建本地 Web 服务，模拟生产环境
- **轻量级应用服务**：作为反向代理、负载均衡器或静态资源服务器
- **容器化部署**：与 Docker Compose 或 Kubernetes 集成，实现服务编排


## 详细使用方法和配置说明

### 支持的架构

该镜像通过 Docker 清单实现多平台支持，拉取 `lscr.io/linuxserver/nginx:latest` 即可自动匹配对应架构。也可通过标签指定特定架构：

| 架构       | 支持情况 | 标签格式               |
| :--------- | :------- | :--------------------- |
| x86-64     | ✅        | amd64-\<version tag\>   |
| arm64      | ✅        | arm64v8-\<version tag\> |


### 应用配置

1. **网站文件部署**：将网站文件放入宿主机映射到容器 `/config/www` 的目录中
2. **配置文件修改**：Nginx、PHP 及站点配置文件位于容器 `/config` 目录下，可直接修改并持久化到宿主机


### 只读模式运行

支持以只读文件系统模式运行容器，需注意：
- 必须将 `/tmp` 挂载为 tmpfs（临时文件系统）


### 部署示例

#### Docker Compose（推荐）

```yaml
---
services:
  nginx:
    image: lscr.io/linuxserver/nginx:latest
    container_name: nginx
    environment:
      - PUID=1000               # 用户ID（详见下方说明）
      - PGID=1000               # 组ID（详见下方说明）
      - TZ=Etc/UTC              # 时区（如 Asia/Shanghai）
      - NGINX_AUTORELOAD=       # 可选，设为true启用配置自动重载
      - NGINX_AUTORELOAD_WATCHLIST=  # 可选，额外监控目录（竖线分隔，如 /config/php）
    volumes:
      - /path/to/nginx/config:/config  # 配置文件持久化目录
      - /tmp:/tmp                       # 只读模式需挂载tmpfs（如 --tmpfs /tmp）
    ports:
      - 80:80                   # HTTP端口映射
      - 443:443                 # HTTPS端口映射
    restart: unless-stopped
    read_only: false            # 如需只读模式，设为true并配置/tmp
```

#### Docker CLI

```bash
docker run -d \
  --name=nginx \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e NGINX_AUTORELOAD= `# 可选，设为true启用配置自动重载` \
  -e NGINX_AUTORELOAD_WATCHLIST= `# 可选，竖线分隔的额外监控目录` \
  -p 80:80 \
  -p 443:443 \
  -v /path/to/nginx/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/nginx:latest
```


### 参数说明

容器运行时通过参数（如上述示例）进行配置，格式为 `<外部>:<内部>`。

| 参数                  | 功能说明                                                                 |
| :-------------------- | :----------------------------------------------------------------------- |
| `-p 80:80`            | HTTP 端口映射（宿主机:容器）                                             |
| `-p 443:443`          | HTTPS 端口映射（宿主机:容器）                                            |
| `-e PUID=1000`        | 用户ID，用于解决宿主机与容器权限冲突，通过 `id your_user` 命令获取       |
| `-e PGID=1000`        | 组ID，同上                                                               |
| `-e TZ=Etc/UTC`       | 时区设置，参考 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e NGINX_AUTORELOAD=` | 设为 `true` 启用配置自动重载（需文件系统支持 inotify）                   |
| `-e NGINX_AUTORELOAD_WATCHLIST=` | 额外监控目录（竖线分隔），默认监控 `/config/nginx`          |
| `-v /config`          | 配置文件持久化目录（包含 Nginx 配置、PHP 配置、网站文件等）             |
| `--read-only=true`    | 以只读文件系统模式运行容器（需配合 `/tmp` 挂载 tmpfs）                   |


### 从文件加载环境变量（Docker Secrets）

支持通过 `FILE__` 前缀从文件加载环境变量，例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

上述命令会将 `/run/secrets/mysecretvariable` 文件内容作为 `MYVAR` 环境变量的值。


### 应用权限掩码（Umask）

可通过 `-e UMASK=022` 覆盖容器内服务的默认 umask 设置。注意：umask 是权限掩码，通过减法而非加法调整权限，详情参考 [umask 说明](https://en.wikipedia.org/wiki/Umask)。


### 用户/组标识符（PUID/PGID）

使用卷挂载（`-v`）时，宿主机与容器可能出现权限冲突。通过指定 PUID（用户ID）和 PGID（组ID），确保宿主机卷目录与容器内用户权限一致。获取当前用户的 PUID/PGID：

```bash
id your_user
```

示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```


### Docker Mods

该镜像支持通过 Docker Mods 扩展功能，可查看 [专用 Mods](https://mods.linuxserver.io/?mod=nginx) 或 [通用 Mods](https://mods.linuxserver.io/?mod=universal) 获取更多信息。


### 支持信息

- **容器内命令行访问**：
  ```bash
  docker exec -it nginx /bin/bash
  ```

- **实时日志监控**：
  ```bash
  docker logs -f nginx
  ```

- **查看容器版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' nginx
  ```

- **查看镜像版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/nginx:latest
  ```


### 更新说明

该镜像为静态版本，需通过更新镜像并重建容器来升级应用。

#### 通过 Docker Compose 更新

- **更新镜像**：
  ```bash
  # 更新所有镜像
  docker-compose pull
  # 仅更新 nginx 镜像
  docker-compose pull nginx
  ```

- **更新容器**：
  ```bash
  # 更新所有容器
  docker-compose up -d
  # 仅更新 nginx 容器
  docker-compose up -d nginx
  ```

- **清理旧镜像**：
  ```bash
  docker image prune
  ```

#### 通过 Docker Run 更新

- **更新镜像**：
  ```bash
  docker pull lscr.io/linuxserver/nginx:latest
  ```

- **停止并删除旧容器**：
  ```bash
  docker stop nginx
  docker rm nginx
  ```

- **重建容器**：使用原 `docker run` 参数重建，`/config` 目录持久化确保配置保留

- **清理旧镜像**：
  ```bash
  docker image prune
  ```

#### 镜像更新通知工具

推荐使用 [Diun](https://crazymax.dev/diun/) 监控镜像更新，不建议使用自动更新容器的工具。


### 本地构建

如需自定义镜像，可本地构建：

```bash
git clone https://github.com/linuxserver/docker-nginx.git
cd docker-nginx
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/nginx:latest .
```

跨架构构建（如 x86_64 构建 arm64 镜像）需先注册 qemu-static：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

然后使用对应架构的 Dockerfile（如 `-f Dockerfile.aarch64`）。


## 版本历史

- **13.07.25**：修复自动重载功能
- **16.06.25**：基于 Alpine 3.22 构建，PHP 8.4，新增自动重载功能，移除不再维护的 mcrypt PHP 扩展
- **17.12.24**：基于 Alpine 3.21 构建
- **31.05.24**：基于 Alpine 3.20 构建，现有用户需更新 Nginx 配置以避免 http2 弃用警告
- **05.03.24**：基于 Alpine 3.19 构建，PHP 8.3
- **25.05.23**：基于 Alpine 3.18 构建，移除 armhf 架构支持
- **16.01.23**：移除 nchan 模块（频繁导致崩溃）
- **22.12.22**：基于 Alpine 3.17 构建，PHP 8.1，迁移至 s6v3
- **20.08.22**：基于 Alpine 3.15 构建，PHP 8.0，重构 Nginx 配置
- **22.05.22**：安装 Alpine 3.14 版本的 Nginx
- **01.07.21**：基于 Alpine 3.14 构建
- **24.06.21**：更新默认 Nginx 配置目录
- **12.04.21**：新增 php7-gmp 和 php7-pecl-mailparse
- **13.02.21**：移除 php7-pecl-imagick（可通过 docker mod 安装）
- **09.02.21**：基于 Alpine 3.13 构建，新增 nginx brotli 和 dav-ext 模块，移除 lua 相关模块
- **08.09.20**：新增 php7-xsl
- **01.06.20**：基于 Alpine 3.12 构建
- **18.04.20**：修复容器意外关闭问题
- **11.03.20**：新增 php7-sodium
- **18.02.20**：新增 geoip2，抑制 lua 警告
- **19.12.19**：基于 Alpine 3.11 构建
- **18.12.19**：新增 php7-imap 和 php7-pecl-apcu
- **13.11.19**：新增 php7-pdo_odbc
- **24.10.19**：新增 php7-pecl-imagick
- **06.08.19**：新增 php7-bcmath、ph7-pear、php7-xmlrpc、php7-ftp
- **02.08.19**：新增 php7-ldap
- **28.06.19**：基于 Alpine 3.10 构建
- **08.05.19**：Nginx 升级时移除 default.conf
- **30.04.19**：新增 php-redis
- **23.03.19**：切换至新基础镜像，使用 arm32v7 标签
- **02.03.19**：新增 php intl 和 posix 模块
- **28.02.19**：新增 php7-opcache，移除 memcached 服务（aarch64 兼容性问题）
- **22.02.19**：基于 Alpine 3.9 构建
- **18.11.18**：构建时尝试升级软件包
- **28.09.18**：多架构镜像支持
- **17.08.18**：基于 Alpine 3.8 构建，继承 nginx 基础镜像的 nginx.conf
- **11.05.18**：新增 php pgsql 支持
- **19.04.18**：memcached 绑定 localhost，新增 php7-sqlite3
- **05.01.18**：基于 Alpine 3.7 构建
- **08.11.17**：新增 php7 soap 模块
- **31.10.17**：新增 php7 exif 和 xmlreader 模块
- **30.09.17**：复制额外根文件到镜像
- **24.09.17**：新增 memcached 服务
- **31.08.17**：新增 php7-phar
- **14.07.17**：在 nginx.conf 中动态启用模块
- **22.06.17**：新增多种 nginx 模块并在默认配置中启用
- **05.06.17**：新增 php7-bz2
- **25.05.17**：基于 Alpine 3.6 构建
- **18.04.17**：新增 php7-sockets
- **27.02.17**：基于 Alpine 3.5 构建，Nginx 1.10.2，PHP 7
- **14.10.16**：添加版本层信息
- **10.09.16**：添加 README 徽章
- **05.12.15**：初始发布

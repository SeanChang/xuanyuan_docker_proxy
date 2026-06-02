<!-- xuanyuan-docker-images-zh
image: linuxserver/librespeed
source: https://xuanyuan.cloud/zh/r/linuxserver/librespeed
canonical: https://xuanyuan.cloud/zh/r/linuxserver/librespeed
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/librespeed" title="linuxserver/librespeed Docker 镜像中文简介、标签列表与拉取命令">linuxserver/librespeed — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/linuxserver/librespeed" title="linuxserver/librespeed Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/librespeed</a></p>

# linuxserver/librespeed

## 镜像概述和主要用途

[Librespeed](https://github.com/librespeed/speedtest) 是一个轻量级的网速测试工具，采用Javascript实现，使用XMLHttpRequest和Web Workers。无需Flash、Java、Websocket等额外组件，实现纯粹的网速测试功能。

LinuxServer.io团队提供的此镜像具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间占用、停机时间和带宽
- 定期安全更新

## 核心功能和特性

- 纯Web前端实现，无需任何浏览器插件
- 支持自定义测试模板和结果页面
- 可配置的数据库存储（SQLite、MySQL、PostgreSQL）
- 支持IP信息查询（通过ipinfo.io API）
- 多架构支持（x86-64、arm64）
- 简单的用户权限管理
- 完全可定制的前端界面

## 使用场景和适用范围

- 个人或企业内部网络速度测试
- 网络服务提供商的客户自助测速工具
- 网络性能监控和故障排查
- 网站或应用程序的性能测试辅助工具
- 需要在多种设备上进行网速测试的场景

## 支持的架构

该镜像支持以下架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

只需拉取 `lscr.io/linuxserver/librespeed:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

## 应用设置

访问 `http://SERVERIP` 即可打开测速Web界面。结果数据库可通过 `http://SERVERIP/results/stats.php` 使用设置的密码访问。

默认使用的模板基于 `example-singleServer-full.html`。所有模板都位于 `/config/www/` 目录中，供参考。您可以根据需要自定义 `/config/www/index.html`，删除该文件并重启容器可恢复默认设置。

您还可以选择将自定义的 `speedtest.js` 和 `speedtest_worker.js` 文件放在 `/config/www` 目录下，容器启动后会优先使用这些文件。请注意，自定义后这些文件将不再自动更新，删除它们并重新创建容器可恢复默认设置。

如果要设置MySQL或PostgreSQL数据库，需要先按照以下链接中的说明将表导入数据库：
https://github.com/librespeed/speedtest/blob/master/doc.md#creating-the-database

要启用自定义结果页面，请设置环境变量 `CUSTOM_RESULTS=true` 并启动（或重启）容器，系统会创建 `/config/www/results/index.php` 文件，您可以根据需要修改此文件。

## 使用方法和配置说明

您可以使用docker-compose或docker cli来创建容器。

> [!NOTE]
> 除非参数标记为"可选"，否则均为必填项，必须提供值。

### docker-compose (推荐)

```yaml
---
services:
  librespeed:
    image: lscr.io/linuxserver/librespeed:latest
    container_name: librespeed
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - PASSWORD=PASSWORD
      - CUSTOM_RESULTS=false #可选
      - DB_TYPE=sqlite #可选
      - DB_NAME=DB_NAME #可选
      - DB_HOSTNAME=DB_HOSTNAME #可选
      - DB_USERNAME=DB_USERNAME #可选
      - DB_PASSWORD=DB_PASSWORD #可选
      - DB_PORT=DB_PORT #可选
      - IPINFO_APIKEY=ACCESS_TOKEN #可选
    volumes:
      - /path/to/librespeed/config:/config
    ports:
      - 80:80
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=librespeed \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PASSWORD=PASSWORD \
  -e CUSTOM_RESULTS=false `#可选` \
  -e DB_TYPE=sqlite `#可选` \
  -e DB_NAME=DB_NAME `#可选` \
  -e DB_HOSTNAME=DB_HOSTNAME `#可选` \
  -e DB_USERNAME=DB_USERNAME `#可选` \
  -e DB_PASSWORD=DB_PASSWORD `#可选` \
  -e DB_PORT=DB_PORT `#可选` \
  -e IPINFO_APIKEY=ACCESS_TOKEN `#可选` \
  -p 80:80 \
  -v /path/to/librespeed/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/librespeed:latest
```

## 参数说明

容器通过运行时传递的参数进行配置，格式为 `<外部>:<内部>`。

| 参数 | 功能 |
| :----: | --- |
| `-p 80:80` | Web界面端口 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e PASSWORD=PASSWORD` | 设置结果数据库的密码 |
| `-e CUSTOM_RESULTS=false` | （可选）设为`true`以启用`/config/www/results/index.php`中的自定义结果页面 |
| `-e DB_TYPE=sqlite` | 默认值为`sqlite`，也可设置为`mysql`或`postgresql` |
| `-e DB_NAME=DB_NAME` | 数据库名称，MySQL和PostgreSQL必填 |
| `-e DB_HOSTNAME=DB_HOSTNAME` | 数据库地址，MySQL和PostgreSQL必填 |
| `-e DB_USERNAME=DB_USERNAME` | 数据库用户名，MySQL和PostgreSQL必填 |
| `-e DB_PASSWORD=DB_PASSWORD` | 数据库密码，MySQL和PostgreSQL必填 |
| `-e DB_PORT=DB_PORT` | 数据库端口，MySQL必填 |
| `-e IPINFO_APIKEY=ACCESS_TOKEN` | ipinfo.io的访问令牌，获取详细IP信息时必填 |
| `-v /config` | 持久化配置文件目录 |

## 环境变量与Docker Secrets

您可以通过特殊的前缀`FILE__`从文件中设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 运行应用的Umask设置

所有镜像都提供了使用可选的`-e UMASK=022`设置来覆盖容器内启动的服务的默认umask设置的能力。请注意，umask不是chmod，它基于其值减去权限，而不是添加权限。

## 用户/组标识符

使用卷（`-v`标志）时，主机操作系统和容器之间可能会出现权限问题。我们通过允许您指定用户`PUID`和组`PGID`来避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，所有权限问题都将迎刃而解。

在此示例中`PUID=1000`和`PGID=1000`，要查找您的PUID和PGID，请使用：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=librespeed&query=%24.mods%5B%27librespeed%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=librespeed "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的附加功能。可通过上方动态徽章访问此镜像可用的Mods列表（如有）以及可应用于我们任何镜像的通用Mods。

## 支持信息

### 容器运行时的Shell访问

```bash
docker exec -it librespeed /bin/bash
```

### 实时监控容器日志

```bash
docker logs -f librespeed
```

### 容器版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' librespeed
```

### 镜像版本号

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/librespeed:latest
```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器来更新内部的应用程序。除了一些例外情况（在相关的readme.md中注明），我们不建议或支持在容器内更新应用程序。请参考上面的[应用设置](#应用设置)部分，了解是否推荐对该镜像进行更新。

以下是更新容器的说明：

### 通过Docker Compose更新

#### 更新镜像：

- 所有镜像：

```bash
docker-compose pull
```

- 单个镜像：

```bash
docker-compose pull librespeed
```

#### 更新容器：

- 所有容器：

```bash
docker-compose up -d
```

- 单个容器：

```bash
docker-compose up -d librespeed
```

- 您还可以删除旧的悬空镜像：

```bash
docker image prune
```

### 通过Docker Run更新

- 更新镜像：

```bash
docker pull lscr.io/linuxserver/librespeed:latest
```

- 停止运行中的容器：

```bash
docker stop librespeed
```

- 删除容器：

```bash
docker rm librespeed
```

- 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）

- 您还可以删除旧的悬空镜像：

```bash
docker image prune
```

### 镜像更新通知 - Diun (Docker Image Update Notifier)

> [!TIP]
> 我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-librespeed.git
cd docker-librespeed
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/librespeed:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`定义要使用的dockerfile。

## 版本历史

- **27.07.25:** - 重新基于Alpine 3.22构建
- **27.06.24:** - 重新基于Alpine 3.20构建。现有用户应更新其nginx配置，以避免http2弃用警告
- **23.12.23:** - 重新基于Alpine 3.19与php 8.3构建
- **06.12.23:** - 用php pdo_pgsql替换php mysqli
- **25.05.23:** - 重新基于Alpine 3.18构建，弃用armhf架构
- **14.05.23:** - 增加对ipinfo.io的支持
- **20.01.23:** - 重新基于alpine 3.17与php8.1构建
- **20.08.22:** - 重新基于alpine 3.15与php8构建，重构nginx配置
- **01.03.21:** - 修复数据库设置，确保`index.html`被重新创建
- **28.02.21:** - 添加php7-ctype
- **23.01.21:** - 重新基于alpine 3.13构建
- **01.06.20:** - 重新基于alpine 3.12构建
- **29.04.20:** - 为LibreSpeed添加捐赠链接到Github赞助按钮和容器日志
- **09.01.20:** - 初始发布

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/librespeed" title="linuxserver/librespeed Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/librespeed</a></p>

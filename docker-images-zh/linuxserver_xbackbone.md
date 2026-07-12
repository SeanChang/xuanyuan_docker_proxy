---
image: linuxserver/xbackbone
description: "Xbackbone是一个简单的自托管轻量级PHP文件管理器，支持ShareX和*NIX系统，可上传、显示和分享图片、GIF、视频、代码等文件，提供Web UI、多用户管理、上传历史及搜索功能。"
source: https://xuanyuan.cloud/zh/r/linuxserver/xbackbone
canonical: https://xuanyuan.cloud/zh/r/linuxserver/xbackbone
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/xbackbone" title="linuxserver/xbackbone Docker 镜像中文简介、标签列表与拉取命令">linuxserver/xbackbone 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/xbackbone

[Xbackbone](https://github.com/SergiX44/XBackBone) 是一个简单的自托管轻量级PHP文件管理器，支持即时分享工具ShareX和*NIX系统。它支持上传和显示图片、GIF、视频、代码、格式化文本，以及文件下载和上传功能。同时提供带多用户管理、上传历史记录和搜索支持的Web界面。

![xbackbone](https://raw.githubusercontent.com/SergiX44/XBackBone/master/docs/img/xbackbone.png)

## 支持的架构

我们利用docker manifest实现多平台支持。只需拉取 `lscr.io/linuxserver/xbackbone:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

通过 \<your-ip>:80/443 访问WebUI，按照安装向导操作。更多信息请查看 [XBackBone](https://github.com/SergiX44/XBackBone)。

如需修改PHP最大上传大小，可通过在 `/config/php/php-local.ini` 中添加选项覆盖php.ini文件：

```ini
upload_max_filesize = 25M
post_max_size = 25M
```

对于反向代理，若初始设置使用本地URL，需在 `/config/www/xbackbone/config.php` 中修改 `base_url` 为您的域名，例如：`'base_url' => 'https://images.yourdomain.com',`

## 使用方法

以下提供docker-compose和docker cli两种使用方式帮助您创建容器。

>[!NOTE]
>除非参数标记为“可选”，否则均为必填项，必须提供值。

### docker-compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  xbackbone:
    image: docker.xuanyuan.run/linuxserver/xbackbone:latest
    container_name: xbackbone
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/xbackbone/config:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
```

### docker cli（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=xbackbone \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 80:80 \
  -p 443:443 \
  -v /path/to/xbackbone/config:/config \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/xbackbone:latest
```

## 参数

容器通过运行时传递的参数进行配置（如上所示）。参数以冒号分隔，表示`<外部>:<内部>`。例如，`-p 8080:80` 表示将容器内的80端口映射到主机的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 80:80` | HTTP Web界面 |
| `-p 443:443` | HTTPS Web界面 |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，查看[列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)获取可用时区 |
| `-v /config` | 持久化配置文件目录 |

## 来自文件的环境变量（Docker secrets）

您可以使用特殊前缀 `FILE__` 从文件中设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 应用运行的Umask设置

我们所有的镜像都支持使用可选的 `-e UMASK=022` 设置来覆盖容器内服务的默认umask。请注意，umask不是chmod，它基于其值减去权限而非添加。请在请求支持前阅读[此处](https://en.wikipedia.org/wiki/Umask)了解更多信息。

## 用户/组标识符

使用卷（`-v` 标志）时，主机OS和容器之间可能出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都归您指定的用户所有，权限问题将迎刃而解。

在此示例中 `PUID=1000` 和 `PGID=1000`，使用 `id your_user` 命令查找您的ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=xbackbone&query=%24.mods%5B%27xbackbone%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=xbackbone "查看此容器可用的mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的额外功能。上述动态徽章可访问此镜像可用的Mods列表（如有）以及可应用于任何LinuxServer.io镜像的通用Mods。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it xbackbone /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f xbackbone
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' xbackbone
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/xbackbone:latest
    ```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部应用。除相关readme.md中注明的例外情况，我们不建议或支持在容器内更新应用。请参考上文的[应用设置](#application-setup)部分，了解是否推荐对此镜像进行应用更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull xbackbone
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d xbackbone
        ```

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/xbackbone:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop xbackbone
    ```

* 删除容器：

    ```bash
    docker rm xbackbone
    ```

* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的 `/config` 文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker Image Update Notifier）

>[!TIP]
>我们推荐使用[Diun](https://crazymax.dev/diun/)获取更新通知。不推荐或支持其他自动更新容器的工具。

## 本地构建

如果您想为开发目的对这些镜像进行本地修改或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-xbackbone.git
cd docker-xbackbone
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/xbackbone:latest .
```

可以使用 `lscr.io/linuxserver/qemu-static` 在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，您可以使用 `-f Dockerfile.aarch64` 指定要使用的dockerfile。

## 版本历史

* **27.05.24:** - 基于Alpine 3.20重建。现有用户应更新其nginx配置以避免http2弃用警告。
* **28.12.23:** - 基于Alpine 3.19和php 8.3重建。
* **25.12.23:** - 现有用户应更新：site-confs/default.conf - 清理默认站点配置。
* **25.05.23:** - 基于Alpine 3.18重建，弃用armhf架构。
* **13.04.23:** - 将ssl.conf包含移动到default.conf。
* **19.01.23:** - 基于Alpine 3.17和php8.1重建。
* **04.11.22:** - 基于Alpine 3.16重建，迁移到s6v3。
* **01.11.22:** - 将应用安装到/app/www/public，为现有用户添加迁移通知。容器更新现在应能正确更新应用
* **20.08.22:** - 基于Alpine 3.15和php8重建。重构nginx配置（[查看变更公告](https://info.linuxserver.io/issues/2022-08-20-nginx-base)）。
* **02.08.22:** - 添加更新说明。
* **06.06.21:** - 初始发布。

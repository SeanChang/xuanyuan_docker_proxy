---
image: linuxserver/kavita
description: "Kavita是一款快速、功能丰富的跨平台阅读服务器，支持搭建个人阅读服务器并与亲友分享漫画、漫画和书籍等阅读收藏，提供完整的阅读解决方案。"
source: https://xuanyuan.cloud/zh/r/linuxserver/kavita
canonical: https://xuanyuan.cloud/zh/r/linuxserver/kavita
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/kavita" title="linuxserver/kavita Docker 镜像中文简介、标签列表与拉取命令">linuxserver/kavita 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/kavita

[Kavita](https://github.com/Kareadita/Kavita) 是一款快速、功能丰富的跨平台阅读服务器。专注于成为满足所有阅读需求的完整解决方案，您可以搭建自己的服务器并与亲友分享您的阅读收藏！

![kavita](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/kavita-logo.png)

## 支持的架构

我们利用 Docker manifest 实现多平台支持。只需拉取 `lscr.io/linuxserver/kavita:latest` 即可获取适合您架构的正确镜像，也可通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

通过 `<your-ip>:5000` 访问 Web 界面，初始安装时将引导您完成设置向导。

Docker CLI 和 Compose 示例中列出了单个 `/data` 文件夹用于媒体存储，但您可以根据需要设置多个挂载点，例如 `/manga`、`/comics` 和 `/books`，分别映射到主机上的不同文件夹。

## 使用方法

以下提供 Docker Compose 和 Docker CLI 两种方式帮助您创建容器。

> [!NOTE]
> 除非参数标记为“可选”，否则均为必填项，必须提供值。

### Docker Compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  kavita:
    image: docker.xuanyuan.run/linuxserver/kavita:latest
    container_name: kavita
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/kavita/config:/config
      - /path/to/data:/data #可选
    ports:
      - 5000:5000
    restart: unless-stopped
```

### Docker CLI（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=kavita \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 5000:5000 \
  -v /path/to/kavita/config:/config \
  -v /path/to/data:/data `#optional` \
  --restart unless-stopped \
  lscr.io/linuxserver/kavita:latest
```

## 参数

容器通过运行时传递的参数进行配置（如上所示）。参数以冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 表示将容器内的 80 端口映射到主机的 8080 端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 5000:5000` | Web 界面端口 |
| `-e PUID=1000` | 用户 ID - 详见下文说明 |
| `-e PGID=1000` | 组 ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 包含所有相关配置文件 |
| `-v /data` | 媒体库，包含漫画、漫画和书籍 |

## 来自文件的环境变量（Docker secrets）

您可以通过特殊前缀 `FILE__` 从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 应用运行的 Umask

我们的所有镜像都支持通过可选的 `-e UMASK=022` 设置覆盖容器内服务的默认 umask。请注意，umask 不是 chmod，它基于其值减去权限而非添加。请在请求支持前参考 [umask 说明](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机 OS 和容器之间可能出现权限问题。通过指定用户 `PUID` 和组 `PGID` 可以避免此问题。

确保主机上的任何卷目录都归您指定的用户所有，权限问题将迎刃而解。

此处 `PUID=1000` 和 `PGID=1000`，通过以下命令获取您的 PUID 和 PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=kavita&query=%24.mods%5B%27kavita%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=kavita "查看此容器的可用 mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用 mods")

我们发布了各种 [Docker Mods](https://github.com/linuxserver/docker-mods) 以启用容器内的附加功能。上述动态徽章可访问此镜像的可用 mods 列表以及可应用于任何 LinuxServer 镜像的通用 mods。

## 支持信息

* 容器运行时的 Shell 访问：

  ```bash
  docker exec -it kavita /bin/bash
  ```

* 实时监控容器日志：

  ```bash
  docker logs -f kavita
  ```

* 容器版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' kavita
  ```

* 镜像版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/kavita:latest
  ```

## 更新信息

我们的大多数镜像都是静态、版本化的，需要更新镜像并重新创建容器以更新内部应用。除相关 readme.md 中注明的例外情况，我们不建议或支持在容器内更新应用。请参考上文的 [应用设置](#应用设置) 部分了解是否推荐更新。

以下是更新容器的说明：

### 通过 Docker Compose

* 更新镜像：
  * 所有镜像：

    ```bash
    docker-compose pull
    ```

  * 单个镜像：

    ```bash
    docker-compose pull kavita
    ```

* 更新容器：
  * 所有容器：

    ```bash
    docker-compose up -d
    ```

  * 单个容器：

    ```bash
    docker-compose up -d kavita
    ```

* 移除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 通过 Docker Run

* 更新镜像：

  ```bash
  docker pull docker.xuanyuan.run/linuxserver/kavita:latest
  ```

* 停止运行中的容器：

  ```bash
  docker stop kavita
  ```

* 删除容器：

  ```bash
  docker rm kavita
  ```

* 使用上述相同的 docker run 参数重新创建容器（若正确映射到主机文件夹，`/config` 文件夹和设置将被保留）
* 移除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun（Docker 镜像更新通知器）

> [!TIP]
> 我们推荐使用 [Diun](https://crazymax.dev/diun/) 获取更新通知。不建议或支持使用其他自动更新容器的工具。

## 本地构建

如需为开发目的或自定义逻辑对这些镜像进行本地修改：

```bash
git clone https://github.com/linuxserver/docker-kavita.git
cd docker-kavita
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/kavita:latest .
```

可使用 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可使用 `-f Dockerfile.aarch64` 指定要使用的 dockerfile。

## 版本历史

* **2025年7月5日：** - 更新初始化脚本以兼容 0.8.7 版本。
* **2024年7月10日：** - 重新基于 Ubuntu Noble 构建。
* **2023年8月12日：** - 修复应用文件权限以防止高 UID 问题。
* **2023年8月7日：** - 初始发布。

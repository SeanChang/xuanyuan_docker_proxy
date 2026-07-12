---
image: linuxserver/grocy
description: "LinuxServer提供的grocy镜像，用于部署开源家庭库存管理系统，支持食品库存跟踪、购物清单管理及食谱规划，轻量高效且易于集成。"
source: https://xuanyuan.cloud/zh/r/linuxserver/grocy
canonical: https://xuanyuan.cloud/zh/r/linuxserver/grocy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/grocy" title="linuxserver/grocy Docker 镜像中文简介、标签列表与拉取命令">linuxserver/grocy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/grocy Docker镜像文档

## 镜像概述和主要用途

[Grocy](https://github.com/grocy/grocy) 是一款面向厨房的ERP系统！这款出色的工具能帮助您减少食物浪费并管理日常家务。通过这个开源工具，您可以跟踪购买记录、监控食物浪费情况、管理待办家务以及需要充电的电池等。

LinuxServer.io团队提供的该Docker镜像具有以下特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 带有s6覆盖层的自定义基础镜像
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间使用、停机时间和带宽
- 定期安全更新

![grocy](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/grocy-logo.png)

## 核心功能和特性

- 食品库存管理，减少浪费
- 购物清单创建和跟踪
- 家务管理和提醒
- 电池充电状态跟踪
- 完全开源的解决方案
- 简洁直观的Web界面
- 多平台支持

## 使用场景和适用范围

Grocy适合以下用户和场景：
- 家庭用户管理厨房库存和减少食物浪费
- 小型企业（如小型餐厅、咖啡馆）跟踪食材
- 需要管理家务和日常任务的家庭或共享居住空间
- 关注减少浪费和提高生活效率的个人

## 支持的架构

该镜像利用Docker manifest实现多平台支持。只需拉取 `lscr.io/linuxserver/grocy:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

Grocy的运行非常简单。按照以下说明配置容器并启动后，您可以通过访问 http://your.ip:9283 来使用它。页面加载后，您可以使用默认用户名和密码 admin / admin 登录。

### 升级说明

容器升级后，请确保访问根路径（点击左上角的logo）以运行任何必要的数据库迁移。更多详情请参见 [https://github.com/grocy/grocy#how-to-update](https://github.com/grocy/grocy#how-to-update)。

## 使用方法和配置说明

以下是使用Docker Compose或Docker CLI启动容器的方法。除非参数标记为"可选"，否则均为"必填"项，必须提供值。

### Docker Compose（推荐）

```yaml
---
services:
  grocy:
    image: docker.xuanyuan.run/linuxserver/grocy:latest
    container_name: grocy
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/grocy/config:/config
    ports:
      - 9283:80
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=grocy \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 9283:80 \
  -v /path/to/grocy/config:/config \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/grocy:latest
```

## 参数说明

容器通过运行时传递的参数进行配置。这些参数用冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的80端口暴露到主机IP的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 9283:80` | 将容器的80端口映射到主机的9283端口 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定使用的时区，详见 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 持久化配置文件目录 |

## 环境变量配置

您可以通过使用特殊的前缀 `FILE__` 从文件中设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## Umask设置

对于所有镜像，我们提供了使用可选的 `-e UMASK=022` 设置来覆盖容器内启动的服务的默认umask设置。请记住，umask不是chmod，它基于其值减去权限，而不是添加权限。在请求支持之前，请先 [了解umask](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机操作系统和容器之间可能会出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

请确保主机上的任何卷目录都由您指定的相同用户拥有，这样所有权限问题都会像魔术一样消失。

在此示例中 `PUID=1000` 和 `PGID=1000`，您可以使用 `id your_user` 命令查找您的PUID和PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=grocy&query=%24.mods%5B%27grocy%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=grocy "查看此容器的可用mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种 [Docker Mods](https://github.com/linuxserver/docker-mods)，以启用容器内的附加功能。上方的动态徽章可访问此镜像可用的Mods列表（如有）以及可应用于我们任何镜像的通用Mods。

## 支持信息

### 容器运行时的Shell访问：

```bash
docker exec -it grocy /bin/bash
```

### 实时监控容器日志：

```bash
docker logs -f grocy
```

### 容器版本号：

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' grocy
```

### 镜像版本号：

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/grocy:latest
```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部的应用程序。除了某些例外情况（在相关的readme.md中注明），我们不建议或支持在容器内更新应用程序。请参考上方的"应用设置"部分，了解是否推荐对该镜像执行应用更新。

### 通过Docker Compose更新

* 更新镜像：
  * 所有镜像：

    ```bash
    docker-compose pull
    ```

  * 单个镜像：

    ```bash
    docker-compose pull grocy
    ```

* 更新容器：
  * 所有容器：

    ```bash
    docker-compose up -d
    ```

  * 单个容器：

    ```bash
    docker-compose up -d grocy
    ```

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run更新

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/grocy:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop grocy
    ```

* 删除容器：

    ```bash
    docker rm grocy
    ```

* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的 `/config` 文件夹和设置将被保留）

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

> **提示**：我们推荐使用 [Diun](https://crazymax.dev/diun/) 进行更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-grocy.git
cd docker-grocy
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/grocy:latest .
```

可以使用 `lscr.io/linuxserver/qemu-static` 在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，您可以使用 `-f Dockerfile.aarch64` 指定要使用的dockerfile。

## 版本历史

* **02.05.24:** - 重新基于Alpine 3.21构建。添加php-opcache包。
* **30.06.24:** - 重新基于Alpine 3.20构建。现有用户应更新其nginx配置以避免http2弃用警告。
* **29.03.24:** - 添加 `clear_env = no` 到 `php-fpm` 以将环境变量传递给工作线程
* **06.03.24:** - 现有用户应更新：site-confs/default.conf - 清理默认站点配置。
* **06.03.24:** - 重新基于Alpine 3.19与php 8.3构建。
* **25.05.23:** - 重新基于Alpine 3.18构建，弃用armhf。
* **13.04.23:** - 将ssl.conf包含移动到default.conf。
* **19.01.23:** - 重新基于Alpine 3.17与php8.1构建。
* **20.08.22:** - 重新基于Alpine 3.15与php8构建。重构nginx配置（[参见变更公告](https://info.linuxserver.io/issues/2022-08-20-nginx-base)）。
* **22.08.21:** - 重新基于Alpine 3.14和PHP 8构建。
* **25.07.21:** - 添加'int'、'json'和'zlib' PHP扩展。
* **10.05.21:** - 减小镜像大小。
* **08.04.21:** - 更新文档以反映Jenkins构建器更改。
* **17.02.21:** - 重新基于Alpine 3.13构建。
* **26.01.21:** - 添加'ldap' PHP扩展。
* **22.12.20:** - 添加'ctype' PHP扩展。
* **01.06.20:** - 重新基于Alpine 3.12构建。
* **19.12.19:** - 重新基于Alpine 3.11构建。
* **22.09.19:** - 添加'gd' PHP扩展。
* **28.06.19:** - 重新基于Alpine 3.10构建。
* **23.03.19:** - 切换到新的基础镜像，迁移到arm32v7标签。
* **22.02.19:** - 重新基于Alpine 3.9构建。
* **27.12.18:** - 初始发布。

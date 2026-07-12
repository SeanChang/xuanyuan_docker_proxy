---
image: linuxserver/series-troxide
description: "LinuxServer.io提供的series-troxide容器镜像，用于运行Series Troxide应用，支持媒体剧集的管理与跟踪功能。"
source: https://xuanyuan.cloud/zh/r/linuxserver/series-troxide
canonical: https://xuanyuan.cloud/zh/r/linuxserver/series-troxide
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/series-troxide" title="linuxserver/series-troxide Docker 镜像中文简介、标签列表与拉取命令">linuxserver/series-troxide 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/series-troxide

## 镜像概述和主要用途

[Series Troxide](https://github.com/MaarifaMaarifa/series-troxide) 是一个简单现代的剧集追踪器，本镜像由 [LinuxServer.io](https://linuxserver.io) 团队维护，提供稳定、安全的容器化部署方案。该镜像基于LinuxServer.io自定义基础镜像构建，集成s6 overlay，并支持多平台架构，适用于需要便捷管理和追踪电视剧集观看进度的用户。

![series-troxide](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/series-troxide-logo.png)


## 核心功能和特性

### LinuxServer.io 镜像特性
- **定期应用更新**：及时同步上游应用版本
- **用户权限映射**：通过PUID/PGID轻松配置容器内用户权限
- **自定义基础镜像**：集成s6 overlay，提供可靠的进程管理
- **统一基础层更新**：每周更新基础系统，减少存储空间占用、 downtime和带宽消耗
- **定期安全更新**：保障容器运行环境安全

### 应用本身特性
- 简洁现代的用户界面
- 剧集追踪与管理功能
- 支持Web访问（HTTP/HTTPS）


## 使用场景和适用范围

- **个人媒体中心**：在家庭服务器或NAS上部署，追踪个人剧集观看进度
- **多设备访问**：通过Web界面在不同设备上访问剧集信息
- **轻量级管理**：无需复杂配置，快速搭建剧集追踪系统


## 支持的架构

该镜像利用Docker清单实现多平台识别，拉取 `lscr.io/linuxserver/series-troxide:latest` 即可自动获取对应架构的镜像，也可通过标签指定具体架构：

| 架构 | 是否可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<版本标签\> |
| arm64 | ✅ | arm64v8-\<版本标签\> |
| armhf | ❌ | |


## 应用设置

应用可通过以下地址访问：
- HTTP: `http://yourhost:3000/`
- HTTPS: `https://yourhost:3001/`

### KasmVNC 基础GUI容器通用选项

本容器基于 [Docker Baseimage KasmVNC](https://github.com/linuxserver/docker-baseimage-kasmvnc) 构建，支持以下额外环境变量和运行配置：

#### 可选环境变量

| 变量 | 描述 |
| :----: | --- |
| CUSTOM_PORT | 容器内部监听的HTTP端口，如需更改默认3000端口 |
| CUSTOM_HTTPS_PORT | 容器内部监听的HTTPS端口，如需更改默认3001端口 |
| CUSTOM_USER | HTTP基本认证用户名，默认为abc |
| PASSWORD | HTTP基本认证密码，默认为abc；若不设置则禁用认证 |
| SUBFOLDER | 子文件夹反向代理时使用，需包含首尾斜杠，如`/subfolder/` |
| TITLE | 网页浏览器中显示的页面标题，默认为"KasmVNC Client" |
| FM_HOME | 文件管理器的主目录（起始目录），默认为`/config` |
| START_DOCKER | 设为false时，特权容器将不会自动启动DinD（Docker-in-Docker）环境 |
| DRINODE | 挂载`/dev/dri`用于[DRI3 GPU加速](https://www.kasmweb.com/kasmvnc/docs/master/gpu_acceleration.html)时，指定设备路径，如`/dev/dri/renderD128` |

#### 可选运行配置

| 配置 | 描述 |
| :----: | --- |
| `--privileged` | 启动DinD环境，允许在容器内隔离使用Docker；为提升性能，可将主机Docker目录挂载到容器，如`-v /home/user/docker-data:/var/lib/docker` |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载主机Docker套接字，用于通过CLI交互或运行Docker相关应用 |
| `--device /dev/dri:/dev/dri` | 将GPU设备挂载到容器，可配合`DRINODE`环境变量使用主机显卡实现GPU加速；仅支持开源驱动（如Intel、AMDGPU、Radeon、ATI、Nouveau） |


## 使用方法

以下提供docker-compose和docker cli两种部署方式。除非标记为“可选”，否则所有参数为必填项。

### docker-compose（推荐，[查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  series-troxide:
    image: docker.xuanyuan.run/linuxserver/series-troxide:latest
    container_name: series-troxide
    environment:
      - PUID=1000        # 用户ID，详见下方说明
      - PGID=1000        # 组ID，详见下方说明
      - TZ=Etc/UTC       # 时区，如Asia/Shanghai
    volumes:
      - /path/to/config:/config  # 配置文件存储路径，替换为实际路径
    ports:
      - 3000:3000        # HTTP访问端口
      - 3001:3001        # HTTPS访问端口
    shm_size: "1gb"      # 应用运行必需的共享内存大小
    restart: unless-stopped
```

### docker cli（[查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=series-troxide \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  docker.xuanyuan.run/linuxserver/series-troxide:latest
```


## 参数说明

容器运行参数格式为`<外部>:<内部>`，例如`-p 8080:80`表示将容器内80端口映射到主机8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | Series Troxide桌面GUI的HTTP端口 |
| `-p 3001:3001` | Series Troxide桌面GUI的HTTPS端口 |
| `-e PUID=1000` | 用户ID，详见下方说明 |
| `-e PGID=1000` | 组ID，详见下方说明 |
| `-e TZ=Etc/UTC` | 时区，参考[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-v /config` | 容器内用户主目录，存储本地文件和配置 |
| `--shm-size=` | 应用运行必需的共享内存大小，建议设为1gb |


## 环境变量从文件（Docker secrets）

可通过特殊前缀`FILE__`从文件中设置环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

将根据`/run/secrets/mysecretvariable`文件内容设置`MYVAR`环境变量。


## 应用运行的Umask设置

所有镜像支持通过`-e UMASK=022`覆盖默认umask设置。注意umask通过减法调整权限，而非直接设置权限，详情参考[umask说明](https://en.wikipedia.org/wiki/Umask)。


## 用户/组标识符（PUID/PGID）

使用卷（`-v`参数）时，主机与容器可能出现权限问题。通过指定`PUID`（用户ID）和`PGID`（组ID），可确保容器内用户与主机用户权限一致。

确保主机卷目录由指定用户拥有，即可避免权限问题。通过以下命令获取当前用户的PUID和PGID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```


## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=series-troxide&query=%24.mods%5B%27series-troxide%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=series-troxide "查看此容器可用的Mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看通用Mods")

LinuxServer.io提供多种[Docker Mods](https://github.com/linuxserver/docker-mods)以扩展容器功能。上方徽章链接可查看此容器专用Mods及适用于所有镜像的通用Mods。


## 支持信息

- 容器运行时访问shell：

  ```bash
  docker exec -it series-troxide /bin/bash
  ```

- 实时监控容器日志：

  ```bash
  docker logs -f series-troxide
  ```

- 查看容器版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' series-troxide
  ```

- 查看镜像版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/series-troxide:latest
  ```


## 更新信息

大部分镜像为静态版本，需更新镜像并重建容器以更新应用（部分镜像除外，详见应用设置）。以下是更新容器的方法：

### 通过Docker Compose

- 更新镜像：
  - 所有镜像：

    ```bash
    docker-compose pull
    ```

  - 单个镜像：

    ```bash
    docker-compose pull series-troxide
    ```

- 更新容器：
  - 所有容器：

    ```bash
    docker-compose up -d
    ```

  - 单个容器：

    ```bash
    docker-compose up -d series-troxide
    ```

- 清理旧镜像：

  ```bash
  docker image prune
  ```

### 通过Docker Run

- 更新镜像：

  ```bash
  docker pull docker.xuanyuan.run/linuxserver/series-troxide:latest
  ```

- 停止运行中的容器：

  ```bash
  docker stop series-troxide
  ```

- 删除容器：

  ```bash
  docker rm series-troxide
  ```

- 使用相同参数重建容器（若卷映射正确，`/config`目录及配置将保留）

- 清理旧镜像：

  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun（Docker Image Update Notifier）

> [!TIP]
> 推荐使用[Diun](https://crazymax.dev/diun/)接收更新通知。不建议使用自动更新容器的工具。


## 本地构建

如需本地修改或开发，可按以下步骤构建镜像：

```bash
git clone https://github.com/linuxserver/docker-series-troxide.git
cd docker-series-troxide
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/series-troxide:latest .
```

可使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可通过`-f Dockerfile.aarch64`指定架构对应的Dockerfile。


## 版本历史

- **16.09.23：** - 初始发布。

---
image: linuxserver/scrutiny
description: "此镜像已弃用，建议使用官方镜像。Scrutiny 是一个硬盘健康监控仪表盘，用于合并制造商提供的 S.M.A.R.T 指标与 Backblaze 的实际故障率数据，提供 WebUI 界面进行监控。"
source: https://xuanyuan.cloud/zh/r/linuxserver/scrutiny
canonical: https://xuanyuan.cloud/zh/r/linuxserver/scrutiny
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/scrutiny" title="linuxserver/scrutiny Docker 镜像中文简介、标签列表与拉取命令">linuxserver/scrutiny 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 弃用通知

此镜像已被弃用。我们将不再为此镜像提供支持，也不会更新它。
建议使用官方镜像：https://github.com/AnalogJ/scrutiny#docker

# [linuxserver/scrutiny](https://github.com/linuxserver/docker-scrutiny)

[Scrutiny](https://github.com/AnalogJ/scrutiny) 是 smartd S.M.A.R.T 监控的 WebUI。Scrutiny 是一个硬盘健康仪表盘和监控解决方案，将制造商提供的 S.M.A.R.T 指标与 Backblaze 的实际故障率数据相结合。

## 支持的架构

我们利用 docker manifest 实现多平台支持。只需拉取 `lscr.io/linuxserver/scrutiny:latest` 即可获取适合您架构的正确镜像，您也可以通过标签拉取特定架构的镜像。

此镜像支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<version tag> |
| arm64 | ✅ | arm64v8-<version tag> |
| armhf| ✅ | arm32v7-<version tag> |

## 应用设置

此容器可以作为“一体化”部署运行，也可以作为 hub/spoke 部署运行。使用环境变量 `SCRUTINY_WEB` 和 `SCRUTINY_COLLECTOR` 控制容器的模式。将两者都设置为 `true` 将容器部署为收集器和 Web UI——这是最简单直接的部署方法。要使用 hub 和 spoke 模型，通过指定 `SCRUTINY_API_ENDPOINT` 以“收集器”模式运行此容器。将其设置为运行 API 的主机。为此，您需要直接从容器公开 API 端口（默认情况下为 `8080`）。

您可能需要手动进入容器运行 `scrutiny-collector-metrics run` 来执行首次任务，或者等待午夜左右自动启动。

完整的带注释示例配置 yaml 文件可在原始项目仓库 [此处](https://github.com/AnalogJ/scrutiny/blob/master/example.scrutiny.yaml) 找到。将此文件放在挂载到 `/config` 的位置。

关于此容器的 `--cap-add` 注意事项：
* `SYS_RAWIO` 是允许 smartctl 权限查询设备 SMART 数据所必需的。
* 根据上游问题 [#26](https://github.com/AnalogJ/scrutiny/issues/26#issuecomment-696817130)，NVMe 驱动器需要 `SYS_ADMIN`。

## 使用方法

以下是一些示例片段，可帮助您开始创建容器。

### docker-compose（推荐，[点击此处了解更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
version: "2.1"
services:
  scrutiny:
    image: docker.xuanyuan.run/linuxserver/scrutiny:latest
    container_name: scrutiny
    cap_add:
      - SYS_RAWIO
      - SYS_ADMIN #可选
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - SCRUTINY_API_ENDPOINT=http://localhost:8080
      - SCRUTINY_WEB=true
      - SCRUTINY_COLLECTOR=true
    volumes:
      - /path/to/config:/config
      - /run/udev:/run/udev:ro
    ports:
      - 8080:8080
    devices:
      - /dev/sda:/dev/sda
      - /dev/sdb:/dev/sdb
      - /dev/nvme1n1:/dev/nvme1n1
    restart: unless-stopped
```

### docker cli（[点击此处了解更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=scrutiny \
  --cap-add=SYS_RAWIO \
  --cap-add=SYS_ADMIN `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e SCRUTINY_API_ENDPOINT=http://localhost:8080 \
  -e SCRUTINY_WEB=true \
  -e SCRUTINY_COLLECTOR=true \
  -p 8080:8080 \
  -v /path/to/config:/config \
  -v /run/udev:/run/udev:ro \
  --device /dev/sda:/dev/sda \
  --device /dev/sdb:/dev/sdb \
  --device /dev/nvme1n1:/dev/nvme1n1 \
  --restart unless-stopped \
  lscr.io/linuxserver/scrutiny:latest
```

## 参数

容器镜像使用运行时传递的参数进行配置（如上所示）。这些参数用冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的端口 `80` 暴露出来，可通过主机 IP 的端口 `8080` 访问。

| 参数 | 功能 |
| :----: | --- |
| `-p 8080` | Scrutiny Web 界面和 API 的端口。 |
| `-e PUID=1000` | 用户 ID - 详见下方说明 |
| `-e PGID=1000` | 组 ID - 详见下方说明 |
| `-e TZ=Europe/London` | 指定要使用的时区，例如 Europe/London。 |
| `-e SCRUTINY_API_ENDPOINT=http://localhost:8080` | # 可选 - Scrutiny UI 的 API 端点。除非用作远程收集器，否则不要更改 |
| `-e SCRUTINY_WEB=true` | # 可选 - 运行 Web 服务。 |
| `-e SCRUTINY_COLLECTOR=true` | # 可选 - 运行指标收集器。 |
| `-v /config` | 配置文件存储位置。 |
| `-v /run/udev:ro` | 为 Scrutiny 提供必要的元数据。 |
| `--device /dev/sda` | Scrutiny 访问驱动器的方式。也可选择提供 `/dev:/dev` 以访问所有设备。 |
| `--device /dev/sdb` | 第二个驱动器。 |
| `--device /dev/nvme1n1` | NVMe 驱动器。NVMe 需要 `--cap-add=SYS_ADMIN`。 |

### Portainer 注意事项

此镜像利用 `cap_add` 或 `sysctl` 才能正常工作。某些版本的 Portainer 未正确实现此功能，因此通过 Portainer 部署时此镜像可能无法工作。

## 用户/组标识符

使用卷（`-v` 标志）时，主机操作系统和容器之间可能会出现权限问题，我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都归您指定的同一用户所有，这样任何权限问题都会像魔术一样消失。

在这个例子中 `PUID=1000` 和 `PGID=1000`，要找到您的 ID，请像下面这样使用 `id user`：

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## 支持信息

* 容器运行时的 Shell 访问：`docker exec -it scrutiny /bin/bash`
* 实时监控容器日志：`docker logs -f scrutiny`
* 容器版本号
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' scrutiny`
* 镜像版本号
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/scrutiny:latest`

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部的应用程序。除了一些例外（如 nextcloud、plex），我们不建议或支持在容器内更新应用程序。请参考上面的[应用设置](#application-setup)部分，了解是否建议对该镜像进行更新。

以下是更新容器的说明：

### 通过 Docker Compose

* 更新所有镜像：`docker-compose pull`
  * 或更新单个镜像：`docker-compose pull scrutiny`
* 让 Compose 必要时更新所有容器：`docker-compose up -d`
  * 或更新单个容器：`docker-compose up -d scrutiny`
* 您还可以删除旧的悬空镜像：`docker image prune`

### 通过 Docker Run

* 更新镜像：`docker pull docker.xuanyuan.run/linuxserver/scrutiny:latest`
* 停止运行中的容器：`docker stop scrutiny`
* 删除容器：`docker rm scrutiny`
* 使用与上面指示相同的 docker run 参数重新创建新容器（如果正确映射到主机文件夹，您的 `/config` 文件夹和设置将被保留）
* 您还可以删除旧的悬空镜像：`docker image prune`

## 版本历史

* **13.06.22:** - 弃用容器。
* **19.01.22:** - 重新基于 Alpine 3.15 构建。
* **22.11.20:** - 添加了 `nsswitch.conf` 的修复以解析本地主机
* **17.09.20:** - 初始发布。

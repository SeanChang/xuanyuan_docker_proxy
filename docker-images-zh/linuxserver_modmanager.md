---
image: linuxserver/modmanager
description: "Modmanager是一个集中式工具，用于下载和更新其他Linuxserver容器的Docker mods，支持通过环境变量指定mods或Docker发现，定期检查更新，可将mod缓存挂载到其他容器以避免重复下载。"
source: https://xuanyuan.cloud/zh/r/linuxserver/modmanager
canonical: https://xuanyuan.cloud/zh/r/linuxserver/modmanager
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/modmanager" title="linuxserver/modmanager Docker 镜像中文简介、标签列表与拉取命令">linuxserver/modmanager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/modmanager

Modmanager是一个集中式工具，用于下载和更新其他Linuxserver容器的Docker mods。它能集中管理mod的下载与更新，减少重复下载，提升容器部署效率。

## 支持的架构

该镜像利用Docker manifest实现多平台支持。只需拉取`lscr.io/linuxserver/modmanager:latest`即可获取适合您架构的镜像，也可通过标签拉取特定架构镜像。支持的架构如下：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

您可以通过`DOCKER_MODS`环境变量指定要下载的mods（如同其他容器），或通过将Docker套接字挂载到容器中（或通过内置的`DOCKER_HOST`环境变量配置合适的替代端点）允许通过Docker发现mods。无论选择哪种方式，需要安装mods的容器仍需设置相应的`DOCKER_MODS`环境变量。

Modmanager容器会在启动时下载所有需要的mods，然后每6小时检查一次更新；如果使用Docker发现，它会自动检测新的mods。

您可以将`/modcache`路径挂载到其他Linuxserver容器中，这些容器将从该路径获取mods，而非每次重新下载。

如果mod需要安装额外的包，每个容器在重新创建时仍需下载这些包。

**注意：Modmanager容器本身不支持应用mod或自定义文件/服务。Modmanager仅支持2025年1月1日之后构建的Linuxserver镜像，虽然它可能与使用我们镜像作为基础的第三方容器兼容，但我们不提供支持。**

### 安全考虑

映射`docker.sock`可能带来安全风险，因为Docker在主机上具有root权限，任何完全访问`docker.sock`的进程也将获得主机的root权限。Docker API本身没有内置访问限制，但您可以通过如[我们的Docker套接字代理](https://github.com/linuxserver/docker-socket-proxy)这样的解决方案为`docker.sock`使用代理，该方案能限制API对特定端点的访问。

### 多主机支持

>[!NOTE]
>在尝试设置前，请确保完全了解操作流程，否则可能因猜测导致多种问题。

Modmanager可以查询和下载远程主机以及本地主机的mods。如果仅使用`DOCKER_MODS`环境变量而不使用Docker发现，只需在远程主机上挂载`/modcache`文件夹，并确保所有参与容器都映射该目录。

如果使用Docker发现，我们唯一支持的连接远程主机的方式是[我们的套接字代理容器](https://github.com/linuxserver/docker-socket-proxy/)。在每个远程主机上运行一个实例：

>[!WARNING]
>如果套接字代理允许任何写操作（`POST=1`、`ALLOW_RESTART=1`等）或暴露非必要的API元素，请勿将其暴露到局域网。绝对不要将套接字代理暴露到广域网。

```yml
  modmanager-dockerproxy:
    image: docker.xuanyuan.run/linuxserver/socket-proxy:latest
    container_name: modmanager-dockerproxy
    environment:
      - CONTAINERS=1
      - POST=0
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    tmpfs:
      - /run
    ports:
      - 2375:2375
    restart: unless-stopped
    read_only: true
```

然后通过`DOCKER_MODS_EXTRA_HOSTS`环境变量添加远程主机，使用完整协议和端口，多个服务器用竖线（`|`）分隔，例如：

```yaml
  - DOCKER_MODS_EXTRA_HOSTS=tcp://host1.example.com:2375|tcp://host2.example.com:2375|tcp://192.168.0.5:2375
```

如上所述，您需要在远程主机上挂载`/modcache`文件夹，并确保所有参与容器都映射该目录。

## 使用方法

以下是使用该镜像创建容器的方法，您可以使用docker compose或docker cli。

>[!NOTE]
>除非参数标记为“可选”，否则均为必填项，必须提供值。

### docker compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  modmanager:
    image: docker.xuanyuan.run/linuxserver/modmanager:latest
    container_name: modmanager
    environment:
      - DOCKER_MODS= `#可选`
      - DOCKER_HOST= `#可选`
      - DOCKER_MODS_EXTRA_HOSTS= `#可选`
    volumes:
      - /path/to/modcache:/modcache
      - /var/run/docker.sock:/var/run/docker.sock:ro `#可选`
    restart: unless-stopped
```

### docker cli（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=modmanager \
  -e DOCKER_MODS= `#可选` \
  -e DOCKER_HOST= `#可选` \
  -e DOCKER_MODS_EXTRA_HOSTS= `#可选` \
  -v /path/to/modcache:/modcache \
  -v /var/run/docker.sock:/var/run/docker.sock:ro `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/modmanager:latest
```

## 参数

容器通过运行时传递的参数进行配置（如上所示）。参数格式为`<外部>:<内部>`。例如，`-p 8080:80`表示将容器内的80端口映射到主机的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-e DOCKER_MODS=` | 竖线分隔（`\|`）的要下载的mods列表 |
| `-e DOCKER_HOST=` | 指定Docker端点（如果不使用docker.sock） |
| `-e DOCKER_MODS_EXTRA_HOSTS=` | 竖线分隔（`\|`）的其他要查询和下载mods的主机列表，详见应用设置部分 |
| `-v /modcache` | Modmanager的mod缓存目录 |
| `-v /var/run/docker.sock:ro` | 将主机的Docker套接字挂载到容器中（只读） |

## 支持信息

* 容器运行时进入shell：

```bash
docker exec -it modmanager /bin/sh
```

* 实时监控容器日志：

```bash
docker logs -f modmanager
```

* 容器版本号：

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' modmanager
```

* 镜像版本号：

```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/modmanager:latest
```

## 更新信息

我们的大多数镜像都是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部应用。除相关readme.md中特别说明外，不建议或支持在容器内更新应用。请参考上述“应用设置”部分了解是否推荐更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
  * 所有镜像：

  ```bash
  docker compose pull
  ```

  * 单个镜像：

  ```bash
  docker compose pull modmanager
  ```

* 更新容器：
  * 所有容器：

  ```bash
  docker compose up -d
  ```

  * 单个容器：

  ```bash
  docker compose up -d modmanager
  ```

* 还可以删除旧的悬空镜像：

```bash
docker image prune
```

### 通过Docker Run

* 更新镜像：

```bash
docker pull docker.xuanyuan.run/linuxserver/modmanager:latest
```

* 停止运行中的容器：

```bash
docker stop modmanager
```

* 删除容器：

```bash
docker rm modmanager
```

* 还可以删除旧的悬空镜像：

```bash
docker image prune
```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

>[!TIP]
>我们推荐使用[Diun](https://crazymax.dev/diun/)获取更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-modmanager.git
cd docker-modmanager
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/modmanager:latest .
```

可以使用`lscr.io/linuxserver/docker-qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/docker-qemu-static --reset
```

注册后，可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

* **05.07.25:** - 基于Alpine 3.22重建。
* **05.01.25:** - 支持多主机。
* **22.12.24:** - 初始发布。

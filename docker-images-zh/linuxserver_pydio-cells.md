---
image: linuxserver/pydio-cells
description: "Pydio Cells是企业级下一代文件共享平台，采用Go语言和微服务架构重写，提供安全高效的文件管理与协作功能，支持多架构部署及灵活的访问控制。"
source: https://xuanyuan.cloud/zh/r/linuxserver/pydio-cells
canonical: https://xuanyuan.cloud/zh/r/linuxserver/pydio-cells
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/pydio-cells" title="linuxserver/pydio-cells Docker 镜像中文简介、标签列表与拉取命令">linuxserver/pydio-cells 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/pydio-cells

[Pydio-cells](https://pydio.com/) 是企业级下一代文件共享平台。它是Pydio项目的全新重写版本，采用Go语言开发并遵循微服务架构设计。

![pydio-cells](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/pydio-cells-icon.png)

## 支持的架构

该镜像利用Docker manifest实现多平台支持。更多信息可参考Docker的[官方文档](https://distribution.github.io/distribution/spec/manifest-v2-2/#manifest-list)及LinuxServer.io的[公告](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/)。

直接拉取 `lscr.io/linuxserver/pydio-cells:latest` 即可获取对应架构的镜像，也可通过标签指定特定架构。

支持的架构如下：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

必须先为Pydio Cells创建MySQL数据库，推荐使用[我们的mariadb镜像](https://hub.docker.com/r/linuxserver/mariadb)。

然后通过Web向导进行设置：本地访问使用 `https://SERVER_IP:8080`（需设置`SERVER_IP`环境变量），反向代理访问使用 `https://pydio-cells.domain.com`。

### 严格模式反向代理

此镜像默认使用自签名证书，因此默认协议为`https`。如果使用验证证书的反向代理，需[禁用对容器的证书检查](https://docs.linuxserver.io/faq#strict-proxy)。

## 使用方法

以下提供docker-compose和docker cli两种方式帮助您创建容器。

>[!NOTE]
>除非标记为“可选”，否则所有参数均为必填项，必须提供值。

### docker-compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  pydio-cells:
    image: docker.xuanyuan.run/linuxserver/pydio-cells:latest
    container_name: pydio-cells
    hostname: pydio-cells
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - EXTERNALURL=yourdomain.url
      - SERVER_IP=0.0.0.0 #可选
    volumes:
      - /path/to/pydio-cells/config:/config
    ports:
      - 8080:8080
    restart: unless-stopped
```

### docker cli（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=pydio-cells \
  --hostname=pydio-cells \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e EXTERNALURL=yourdomain.url \
  -e SERVER_IP=0.0.0.0 `#可选` \
  -p 8080:8080 \
  -v /path/to/pydio-cells/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/pydio-cells:latest
```

## 参数

容器通过运行时传递的参数进行配置（如上述示例）。参数以冒号分隔，表示`<外部>:<内部>`。例如，`-p 8080:80`表示将容器内的80端口映射到主机的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `--hostname=` | Pydio Cells使用主机名验证本地文件，此设置为必填项，设置后不应更改。 |
| `-p 8080:8080` | HTTP端口 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)。 |
| `-e EXTERNALURL=yourdomain.url` | 用于访问Pydio Cells的外部URL（可以是https://domain.url或https://IP:PORT）。 |
| `-e SERVER_IP=0.0.0.0` | Docker服务器的LAN IP。通过IP本地访问时必填，会添加到自签名证书的SAN中（仅通过反向代理访问时不需要）。 |
| `-v /config` | 所有配置文件存放目录。 |

## 从文件读取环境变量（Docker secrets）

可以使用特殊前缀`FILE__`从文件设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这会根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 应用程序的Umask设置

我们的所有镜像都支持通过可选的`-e UMASK=022`设置来覆盖容器内服务的默认umask。请注意，umask不是chmod，它基于其值减去权限，而不是添加。请在请求支持前[了解umask](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v`标志）时，主机OS和容器之间可能出现权限问题。我们通过允许指定用户`PUID`和组`PGID`来避免此问题。

确保主机上的任何卷目录都由您指定的相同用户拥有，权限问题将迎刃而解。

在此示例中`PUID=1000`和`PGID=1000`，使用`id your_user`命令可获取您的ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pydio-cells&query=%24.mods%5B%27pydio-cells%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=pydio-cells "查看此容器的可用mods") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "查看可用的通用mods")

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。上述动态徽章可访问此镜像的可用mods列表（如有）以及可应用于我们任何镜像的通用mods。

## 支持信息

* 容器运行时进入shell：

    ```bash
    docker exec -it pydio-cells /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f pydio-cells
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' pydio-cells
    ```

* 镜像版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/pydio-cells:latest
    ```

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器才能更新内部应用。除了相关readme.md中注明的例外情况，我们不建议或支持在容器内更新应用。请查阅上述[应用设置](#应用设置)部分，了解是否推荐对此镜像进行应用更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 单个镜像：

        ```bash
        docker-compose pull pydio-cells
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 单个容器：

        ```bash
        docker-compose up -d pydio-cells
        ```

* 还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull docker.xuanyuan.run/linuxserver/pydio-cells:latest
    ```

* 停止运行中的容器：

    ```bash
    docker stop pydio-cells
    ```

* 删除容器：

    ```bash
    docker rm pydio-cells
    ```

* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

>[!TIP]
>我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知。不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想为开发目的对这些镜像进行本地修改或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-pydio-cells.git
cd docker-pydio-cells
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/pydio-cells:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

注册后，可以使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

* **27.07.25:** - 基于Alpine 3.22重新构建。
* **27.06.24:** - 基于Alpine 3.20重新构建。
* **14.03.24:** - 基于Alpine 3.19重新构建。Grpc端口默认设为8080。
* **11.10.23:** - 基于Alpine 3.18重新构建。使用Go 1.21在Alpine edge上构建。
* **06.07.23:** - 弃用armhf架构。如[此处](https://www.linuxserver.io/blog/a-farewell-to-arm-hf)公告。
* **01.12.22:** - 基于Alpine 3.17重新构建。添加多架构支持。更新v4兼容性的命令行参数。
* **19.10.22:** - 基于Alpine 3.16重新构建。升级到s6v3。更新v4的构建说明。
* **19.09.22:** - 基于Alpine 3.15重新构建。
* **23.01.21:** - 基于Alpine 3.13重新构建。
* **01.06.20:** - 基于Alpine 3.12重新构建。
* **18.04.20:** - 默认切换为https（仅影响新安装）。添加自签名证书，添加`SERVER_IP`变量以添加到证书的SAN中。添加CellsSync的可选gRPC端口映射。
* **17.04.20:** - 更新编译选项，修复先前版本对新安装的支持问题。
* **19.12.19:** - 基于Alpine 3.11重新构建。
* **12.12.19:** - 初始发布。

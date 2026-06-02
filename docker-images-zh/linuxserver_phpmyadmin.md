---
image: linuxserver/phpmyadmin
description: "phpMyAdmin是一款用PHP编写的免费软件工具，旨在通过Web界面管理MySQL和MariaDB，支持广泛的数据库操作。LinuxServer.io提供的此镜像包含定期更新、用户映射和安全更新等特性。"
source: https://xuanyuan.cloud/zh/r/linuxserver/phpmyadmin
canonical: https://xuanyuan.cloud/zh/r/linuxserver/phpmyadmin
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/phpmyadmin" title="linuxserver/phpmyadmin Docker 镜像中文简介、标签列表与拉取命令">linuxserver/phpmyadmin — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/linuxserver/phpmyadmin" title="linuxserver/phpmyadmin Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/phpmyadmin</a>

# linuxserver/phpmyadmin

[Phpmyadmin](https://github.com/phpmyadmin/phpmyadmin/) 是一款用PHP编写的免费软件工具，旨在通过Web界面管理MySQL。phpMyAdmin支持对MySQL和MariaDB进行广泛的操作。

## LinuxServer.io团队特点

LinuxServer.io团队提供的容器具有以下特点：
* 定期及时的应用更新
* 简单的用户映射（PGID、PUID）
* 带有s6覆盖层的自定义基础镜像
* 每周基础操作系统更新，整个LinuxServer.io生态系统共享通用层，以最小化空间占用、停机时间和带宽
* 定期安全更新

## 支持的架构

该镜像利用Docker manifest实现多平台支持。只需拉取`lscr.io/linuxserver/phpmyadmin:latest`即可获取适合您架构的正确镜像，也可通过标签拉取特定架构镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<version tag> |
| arm64 | ✅ | arm64v8-<version tag> |

## 应用设置

此镜像使用nginx，与官方镜像的fpm-only或Apache变体不同。

我们支持所有官方[环境变量](https://docs.phpmyadmin.net/en/latest/setup.html#docker-environment-variables)进行配置，也支持直接编辑配置文件。更多信息请查看[phpmyadmin文档](https://www.phpmyadmin.net/docs/)。

## 只读操作

此镜像可在只读容器文件系统下运行。详情请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。

### 注意事项
* `/tmp`必须挂载到tmpfs
* 不支持自定义主题

## 非Root操作

此镜像可使用非root用户运行。详情请[阅读文档](https://docs.linuxserver.io/misc/non-root/)。

### 注意事项
* 不支持自定义主题

## 使用方法

以下提供docker-compose和docker cli两种方式帮助您启动容器。

> [!NOTE]
> 除非参数标记为“可选”，否则均为必填项，必须提供值。

### docker-compose（推荐，[点击查看更多信息](https://docs.linuxserver.io/general/docker-compose)）

```yaml
---
services:
  phpmyadmin:
    image: lscr.io/linuxserver/phpmyadmin:latest
    container_name: phpmyadmin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - PMA_ARBITRARY=1 #可选
      - PMA_ABSOLUTE_URI=https://phpmyadmin.example.com #可选
    volumes:
      - /path/to/phpmyadmin/config:/config
    ports:
      - 80:80
    restart: unless-stopped
```

### docker cli（[点击查看更多信息](https://docs.docker.com/engine/reference/commandline/cli/)）

```bash
docker run -d \
  --name=phpmyadmin \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PMA_ARBITRARY=1 `#可选` \
  -e PMA_ABSOLUTE_URI=https://phpmyadmin.example.com `#可选` \
  -p 80:80 \
  -v /path/to/phpmyadmin/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/phpmyadmin:latest
```

## 参数

容器通过运行时传递的参数进行配置。参数格式为`<外部>:<内部>`。例如，`-p 8080:80`表示将容器内的80端口映射到主机的8080端口。

| 参数 | 功能 |
| :----: | --- |
| `-p 80:80` | Web前端端口 |
| `-e PUID=1000` | 用户ID - 详见下方说明 |
| `-e PGID=1000` | 组ID - 详见下方说明 |
| `-e TZ=Etc/UTC` | 指定时区，查看[列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)。 |
| `-e PMA_ARBITRARY=1` | 设置为`1`允许连接到任何服务器；设置为`0`仅允许连接到指定主机（见应用设置） |
| `-e PMA_ABSOLUTE_URI=https://phpmyadmin.example.com` | 设置访问Web前端的URL |
| `-v /config` | 持久化配置文件 |
| `--read-only=true` | 以只读文件系统运行容器。请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。 |
| `--user=1000:1000` | 以非root用户运行容器。请[阅读文档](https://docs.linuxserver.io/misc/non-root/)。 |

## 来自文件的环境变量（Docker secrets）

可使用特殊前缀`FILE__`从文件设置任何环境变量。例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

这将根据`/run/secrets/mysecretvariable`文件的内容设置环境变量`MYVAR`。

## 应用运行的Umask

所有镜像均支持使用可选的`-e UMASK=022`设置覆盖容器内服务的默认umask。注意umask不是chmod，它基于其值减去权限而非添加。请在寻求支持前[阅读相关内容](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v`标志）时，主机OS和容器之间可能出现权限问题。通过指定用户`PUID`和组`PGID`可避免此问题。确保主机上的卷目录由您指定的相同用户拥有，权限问题将迎刃而解。

此处`PUID=1000`和`PGID=1000`，可通过`id your_user`命令获取您的ID：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

我们发布了各种[Docker Mods](https://github.com/linuxserver/docker-mods)以启用容器内的额外功能。可通过上方动态徽章访问此镜像可用的Mods列表以及可应用于任何LinuxServer.io镜像的通用Mods。

## 支持信息

* 容器运行时的Shell访问：

  ```bash
  docker exec -it phpmyadmin /bin/bash
  ```

* 实时监控容器日志：

  ```bash
  docker logs -f phpmyadmin
  ```

* 容器版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' phpmyadmin
  ```

* 镜像版本号：

  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/phpmyadmin:latest
  ```

## 更新信息

大多数镜像为静态、版本化的，需要更新镜像并重新创建容器以更新内部应用。除相关readme.md中注明的例外情况，不建议或支持在容器内更新应用。请参考上方[应用设置](#应用设置)部分查看是否推荐对该镜像进行应用更新。

### 通过Docker Compose更新

* 更新镜像：
  * 所有镜像：

    ```bash
    docker-compose pull
    ```
  * 单个镜像：

    ```bash
    docker-compose pull phpmyadmin
    ```
* 更新容器：
  * 所有容器：

    ```bash
    docker-compose up -d
    ```
  * 单个容器：

    ```bash
    docker-compose up -d phpmyadmin
    ```
* 可删除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 通过Docker Run更新

* 更新镜像：

  ```bash
  docker pull lscr.io/linuxserver/phpmyadmin:latest
  ```

* 停止运行中的容器：

  ```bash
  docker stop phpmyadmin
  ```

* 删除容器：

  ```bash
  docker rm phpmyadmin
  ```

* 使用上述docker run参数重新创建新容器（若正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）
* 可删除旧的悬空镜像：

  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

> [!TIP]
> 推荐使用[Diun](https://crazymax.dev/diun/)获取更新通知。不建议或支持使用其他自动更新容器的工具。

## 本地构建

如需为开发目的或自定义逻辑对这些镜像进行本地修改：

```bash
git clone https://github.com/linuxserver/docker-phpmyadmin.git
cd docker-phpmyadmin
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/phpmyadmin:latest .
```

可使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，可使用`-f Dockerfile.aarch64`指定要使用的dockerfile。

## 版本历史

* **23.08.25:** - 添加mTLS支持。现有用户需删除config.inc.php并重启容器。
* **05.07.25:** - 基于Alpine 3.22重建。
* **19.12.24:** - 基于Alpine 3.21重建。
* **27.05.24:** - 现有用户应更新nginx配置以避免http2弃用警告。
* **24.05.24:** - 基于Alpine 3.20重建。
* **28.12.23:** - 基于Alpine 3.19和php 8.3重建。
* **25.12.23:** - 现有用户应更新：site-confs/default.conf - 清理默认站点配置。
* **06.09.23:** - 添加自定义主题支持。
* **25.05.23:** - 基于Alpine 3.18重建，弃用armhf。
* **13.04.23:** - 将ssl.conf包含移至default.conf。
* **20.01.23:** - 基于Alpine 3.17和php8.1重建。
* **18.11.22:** - 基于Alpine 3.16重建，迁移至s6v3。
* **20.08.22:** - 基于Alpine 3.15和php8重建。重构nginx配置（[查看变更公告](https://info.linuxserver.io/issues/2022-08-20-nginx-base)）。
* **23.01.22:** - 版本固定为5.x.x。
* **14.06.21:** - 初始发布。

---
image: linuxserver/mariadb
description: "LinuxServer.io提供的Mariadb容器，用于部署和运行Mariadb关系型数据库服务。"
source: https://xuanyuan.cloud/zh/r/linuxserver/mariadb
canonical: https://xuanyuan.cloud/zh/r/linuxserver/mariadb
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [linuxserver/mariadb — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/mariadb)

含镜像标签、拉取命令、部署文档与相关推荐。

[linuxserver/mariadb Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/linuxserver/mariadb)

# linuxserver/mariadb

## 镜像概述和主要用途

[MariaDB](https://mariadb.org/) 是最流行的数据库服务器之一，由MySQL的原始开发人员创建。LinuxServer.io团队提供的此容器镜像旨在提供一个简单、安全且易于配置的MariaDB数据库服务部署方案。

## 核心功能和特性

LinuxServer.io团队提供的容器具有以下特点：

* 定期和及时的应用更新
* 简单的用户映射（PGID、PUID）
* 带有s6覆盖层的自定义基础镜像
* 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间使用、停机时间和带宽
* 定期安全更新

## 支持的架构

该镜像利用Docker清单实现多平台支持。只需拉取 `lscr.io/linuxserver/mariadb:latest` 即可获取适合您架构的正确镜像，也可以通过标签拉取特定架构的镜像。

支持的架构：

| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 使用场景和适用范围

适用于需要在Docker环境中快速部署可靠的MariaDB数据库服务的场景，包括：

* 开发和测试环境数据库
* 小型生产环境数据库服务
* 需要隔离部署的数据库实例
* 与其他LinuxServer.io容器集成的应用栈

## 应用设置

根据[上游行为](https://mariadb.com/docs/server/security/user-account-management/authentication-from-mariadb-10-4)，通过localhost（docker exec）访问的root用户不再需要密码。如果在初始启动时未设置远程访问的root密码，请按照容器日志中的说明操作。

> **注意**：容器设置初始数据库后，更改任何MYSQL_变量都不会生效，请使用mysqladmin工具或命令行进行更改。

> **注意**：如果要使用（MYSQL_DATABASE、MYSQL_USER、MYSQL_PASSWORD），这三个变量都需要设置，不能只选择其中几个。

Unraid用户建议在设置后编辑模板/webui，并删除对此变量的引用。

配置更改可在 `/config/custom.cnf` 中进行（需重启容器生效），数据库文件位于 `/config/databases`，日志位于 `/config/log/mysql`。

### 从文件加载密码和用户

`MYSQL_ROOT_PASSWORD`、`MYSQL_DATABASE`、`MYSQL_USER`、`MYSQL_PASSWORD`、`REMOTE_SQL` 环境变量的值可以通过以下文件设置：

```path
/config/env
```

格式如下：

```env
MYSQL_ROOT_PASSWORD="ROOT_ACCESS_PASSWORD"
MYSQL_DATABASE="USER_DB_NAME"
MYSQL_USER="MYSQL_USER"
MYSQL_PASSWORD="DATABASE_PASSWORD"
REMOTE_SQL="http://URL1/your.sql,https://URL2/your.sql"
```

这些设置可以与Docker环境变量混合使用，但文件中的设置始终优先。

### 引导新实例

支持在初始化时一次性运行自定义SQL文件。为此，将 `*.sql` 文件放在：

```path
/config/initdb.d/
```

这与设置 `REMOTE_SQL` 环境变量具有相同效果。SQL文件仅在容器首次启动和设置时运行。

### 检查和修复

如果用户数据库处于不健康状态（有时由升级失败引起），可以通过运行以下命令修复：

```shell
mariadb-check -c -A # 检查所有数据库错误
mariadb-check -r -A # 修复所有数据库
mariadb-check -a -A # 分析所有数据库
mariadb-check -o -A # 优化所有数据库
```

运行上述命令后，可能需要再次运行升级命令。

### 升级

当容器初始化时，如果设置了 `MYSQL_ROOT_PASSWORD`，将运行升级检查。如果需要升级，日志将指示需要停止所有访问此容器中数据库的服务，然后运行命令：

```shell
mariadb-upgrade
```

## 只读操作

此镜像可以在只读容器文件系统中运行。有关详细信息，请[阅读文档](https://docs.linuxserver.io/misc/read-only/)。

### 注意事项

* `/tmp` 必须挂载到tmpfs
* 首次运行时不支持

## 非root用户操作

此镜像可以使用非root用户运行。有关详细信息，请[阅读文档](https://docs.linuxserver.io/misc/non-root/)。

## 详细的使用方法和配置说明

以下是使用Docker Compose或Docker CLI创建容器的方法。

### Docker Compose（推荐）

```yaml
---
services:
  mariadb:
    image: lscr.io/linuxserver/mariadb:latest
    container_name: mariadb
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - MYSQL_ROOT_PASSWORD=ROOT_ACCESS_PASSWORD
      - MYSQL_DATABASE=USER_DB_NAME #可选
      - MYSQL_USER=MYSQL_USER #可选
      - MYSQL_PASSWORD=DATABASE_PASSWORD #可选
      - REMOTE_SQL=http://URL1/your.sql,https://URL2/your.sql #可选
    volumes:
      - /path/to/mariadb/config:/config
    ports:
      - 3306:3306
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=mariadb \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e MYSQL_ROOT_PASSWORD=ROOT_ACCESS_PASSWORD \
  -e MYSQL_DATABASE=USER_DB_NAME `#可选` \
  -e MYSQL_USER=MYSQL_USER `#可选` \
  -e MYSQL_PASSWORD=DATABASE_PASSWORD `#可选` \
  -e REMOTE_SQL=http://URL1/your.sql,https://URL2/your.sql `#可选` \
  -p 3306:3306 \
  -v /path/to/mariadb/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/mariadb:latest
```

## 参数说明

容器通过运行时传递的参数进行配置。这些参数用冒号分隔，表示 `<外部>:<内部>`。例如，`-p 8080:80` 会将容器内的80端口暴露到主机的8080端口。

### 端口参数

| 参数 | 功能 |
| :----: | --- |
| `-p 3306:3306` | MariaDB监听端口 |

### 环境变量

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 用户ID - 详见下文说明 |
| `-e PGID=1000` | 组ID - 详见下文说明 |
| `-e TZ=Etc/UTC` | 指定时区，详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e MYSQL_ROOT_PASSWORD=ROOT_ACCESS_PASSWORD` | 设置安装时的root密码（至少4个字符，非字母数字密码必须正确转义）。（仅首次运行有效） |
| `-e MYSQL_DATABASE=USER_DB_NAME` | 指定要创建的数据库名称。（仅首次运行有效） |
| `-e MYSQL_USER=MYSQL_USER` | 此用户将对MYSQL_DATABASE指定的数据库拥有超级用户访问权限（此处不要使用root）。（仅首次运行有效） |
| `-e MYSQL_PASSWORD=DATABASE_PASSWORD` | 为MYSQL_USER设置密码（至少4个字符，非字母数字密码必须正确转义）。（仅首次运行有效） |
| `-e REMOTE_SQL=http://URL1/your.sql,https://URL2/your.sql` | 设置从http/https端点获取sql文件（逗号分隔的数组） |

### 卷参数

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | 持久化配置文件 |

### 其他参数

| 参数 | 功能 |
| :----: | --- |
| `--read-only=true` | 以只读文件系统运行容器。请[阅读文档](https://docs.linuxserver.io/misc/read-only/) |
| `--user=1000:1000` | 以非root用户运行容器。请[阅读文档](https://docs.linuxserver.io/misc/non-root/) |

## 来自文件的环境变量（Docker secrets）

您可以使用特殊前缀 `FILE__` 从文件中设置任何环境变量。

例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

将根据 `/run/secrets/mysecretvariable` 文件的内容设置环境变量 `MYVAR`。

## 运行应用的Umask

对于所有镜像，我们提供了使用可选的 `-e UMASK=022` 设置来覆盖容器内启动的服务的默认umask设置的能力。请记住，umask不是chmod，它基于其值减去权限而不是添加权限。在请求支持之前，请先[了解umask](https://en.wikipedia.org/wiki/Umask)。

## 用户/组标识符

使用卷（`-v` 标志）时，主机操作系统和服容器之间可能会出现权限问题。我们通过允许您指定用户 `PUID` 和组 `PGID` 来避免此问题。

确保主机上的任何卷目录都由您指定相同的用户拥有，这样任何权限问题都会神奇地消失！

在这个例子中 `PUID=1000` 和 `PGID=1000`，要找到您的PUID和PGID，请使用 `id your_user` 命令：

```bash
id your_user
```

示例输出：

```text
uid=1000(your_user) gid=xxx(your_user) groups=1000(your_user)
```

## Docker Mods

我们发布各种[Docker Mod](https://github.com/linuxserver/docker-mods)以启用容器内的附加功能。可用于此镜像的Mod列表以及可应用于我们任何镜像的通用Mod可通过上方的动态徽章访问。

## 支持信息

* 容器运行时的Shell访问：

    ```bash
    docker exec -it mariadb /bin/bash
    ```

* 实时监控容器日志：

    ```bash
    docker logs -f mariadb
    ```

* 容器版本号：

    ```bash
    docker inspect -f '{{ index .Config.Labels "build_version" }}' mariadb
    ```

* 镜像版本号：

    ```bash 
    docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/mariadb:latest 
    ``` 

## 更新信息

我们的大多数镜像是静态的、版本化的，需要更新镜像并重新创建容器来更新内部的应用程序。除了一些例外情况（在相关的readme.md中注明）外，我们不建议或支持在容器内更新应用程序，请咨询上面的[应用设置](#应用设置)部分，了解是否推荐对镜像进行更新。

以下是更新容器的说明：

### 通过Docker Compose

* 更新镜像：
    * 所有镜像：

        ```bash
        docker-compose pull
        ```

    * 指定镜像：

        ```bash
        docker-compose pull mariadb
        ```

* 更新容器：
    * 所有容器：

        ```bash
        docker-compose up -d
        ```

    * 指定容器：

        ```bash
        docker-compose up -d mariadb
        ```

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 通过Docker Run

* 更新镜像：

    ```bash
    docker pull lscr.io/linuxserver/mariadb:latest 
    ```

* 停止运行中的容器：

    ```bash
    docker stop mariadb
    ```

* 删除容器：
  
    ```bash
    docker rm mariadb
    ```

* 使用上述相同的docker run参数重新创建新容器（如果正确映射到主机文件夹，您的`/config`文件夹和设置将被保留）

* 您还可以删除旧的悬空镜像：

    ```bash
    docker image prune
    ```

### 镜像更新通知 - Diun（Docker镜像更新通知器）

我们推荐使用[Diun](https://crazymax.dev/diun/)进行更新通知提醒。我们不推荐或支持其他自动无人值守更新容器的工具。

## 本地构建

如果您想对这些镜像进行本地修改以用于开发目的或自定义逻辑：

```bash
git clone https://github.com/linuxserver/docker-mariadb.git
cd docker-mariadb
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/mariadb:latest .
```

可以使用`lscr.io/linuxserver/qemu-static`在x86_64硬件上构建ARM变体，反之亦然：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，您可以使用`-f Dockerfile.aarch64`定义要使用Dockerfile。

## 版本历史

* **09.07.25:** - 基于Alpine 3.22重建
* **11.01.25:** - 添加日志轮换，请按照容器日志中的说明操作
* **06.01.25:** - 基于Alpine 3.2重建
* **31.05.24:** - 基于Alpine 3.20重建
* **23.12.23:** - 基于Alpine 3.19重建 
* **09.06.23:** - 更新已提供的custom.cnf中的lc_messages路径以匹配上游
* **25.05.23:** - 基于Alpine 3.18重建，弃用armhf
* **04.02.**- custom.cnf中默认值的小更新
* **31.01.23:** - 基于3.17重建
* **09.12.22:** - 添加升级检查警告
* **11.10.22:** - 将主分支基于Alpine 3.16重建，迁移到s6v3，删除导致一小部分用户出现问题的密码转义逻辑
* **06.07.21:** - 将主分支基于Alpine重建
* **03.07.21:** - 基于3.14重建
* **08.02.**21:** - 修复新安装
* **08.02.21:** - 基于Alpine重建，添加mariadb-backup
* **08.02.21:** - 发布Alpine标签，Alpine版本将在不久的将来取代latest标签
* **27.10.19:** - 升级到10.4版本，能够在初始初始化时使用自定义SQL，通过文件定义root密码
* **23.03.19:** - 切换到新的基础镜像，迁移到arm32v7标签
* **07.03.19:** - 添加在首次启动时设置数据库和默认用户的功能
* **26.01.19:** - 添加流水线逻辑和多架构支持
* **10.09.18:** - 基于Ubuntu Bionic重建，并使用MariaDB 10.3仓库
* **09.12.17:** - 修复连续行
* **12.09.17:** - 优雅关闭MariaDB 
* **27.10.16:** - 实施数据库初始化脚本的 linting 建议 
* **11.10.16:** - 基于Ubuntu Xenial重建，添加版本标签
* **09.03.16:** - 更新到MariaDB 10.1版本，改为在/config中使用custom.cnf而非my.cnf，重构初始化文件以在启动时更改配置选项，而不是在dockerfile中
* **26.01.**16:** - 将mysqld_safe脚本的用户更改为abc，更好地处理重启时不干净的关闭
* **23.12.15:** - 移除自动更新功能，某些版本更新之间容器可能会中断
* **12.08.15:** - 初始发布

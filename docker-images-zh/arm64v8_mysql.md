---
image: arm64v8/mysql
description: "MySQL是一款被广泛使用的开源关系型数据库管理系统（RDBMS），具有跨平台兼容性强、数据处理高效稳定、部署与维护便捷等特点，广泛应用于网站开发、企业级应用系统、数据存储与管理等多种场景，为全球众多开发者、中小型企业及大型机构提供可靠的结构化数据存储与查询支持。"
source: https://xuanyuan.cloud/zh/r/arm64v8/mysql
canonical: https://xuanyuan.cloud/zh/r/arm64v8/mysql
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/mysql" title="arm64v8/mysql Docker 镜像中文简介、标签列表与拉取命令">arm64v8/mysql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# mysql (arm64v8 架构) 镜像说明


## 说明  
此仓库为 [mysql 官方镜像]([]) 的 arm64v8 架构构建版本专用仓库（按架构拆分）。更多信息可参考官方镜像文档中的 **“除 amd64 外的其他架构？”** [“Architectures other than amd64?”]([]) 以及官方镜像 FAQ 中的 **“镜像源码在 Git 中变更后如何处理？”** [“An image's source changed in Git, now what?”]([])。


## 快速参考  

### 维护与支持  
- **维护方**：  
  [Docker 社区及 MySQL 团队]([])  

- **获取帮助**：  
  [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


### 支持的标签及对应 Dockerfile 链接  
- [9.4.0, 9.4, 9, innovation, latest, 9.4.0-oraclelinux9, 9.4-oraclelinux9, 9-oraclelinux9, innovation-oraclelinux9, oraclelinux9, 9.4.0-oracle, 9.4-oracle, 9-oracle, innovation-oracle, oracle]([])  

- [8.4.6, 8.4, 8, lts, 8.4.6-oraclelinux9, 8.4-oraclelinux9, 8-oraclelinux9, lts-oraclelinux9, 8.4.6-oracle, 8.4-oracle, 8-oracle, lts-oracle]([])  

- [8.0.43, 8.0, 8.0.43-oraclelinux9, 8.0-oraclelinux9, 8.0.43-oracle, 8.0-oracle]([])  


### 快速参考（续）  
- **问题反馈地址**：  
  [[]]([])  

- **支持的架构**：（[更多信息]([])）  
  [`amd64`]([])、[`arm64v8`]([])  

- **镜像制品详情**：  
  [repo-info 仓库的 `repos/mysql/` 目录]([])（[历史记录]([])）  
  （包含镜像元数据、传输大小等信息）  

- **镜像更新**：  
  [official-images 仓库的 `library/mysql` 标签]([])  
  [official-images 仓库的 `library/mysql` 文件]([])（[历史记录]([])）  

- **本说明文档来源**：  
  [docs 仓库的 `mysql/` 目录]([])（[历史记录]([])）  


## 什么是 MySQL？  

MySQL 是全球最受欢迎的开源数据库。凭借其成熟的性能、可靠性和易用性，MySQL 已成为基于 Web 的应用程序的首选数据库，应用范围从个人项目和网站，到电子商务和信息服务，再到 、、、! 等知名网络平台。  

如需 MySQL 服务器及其他 MySQL 产品的更多信息和相关下载，请访问 [www.mysql.com]([])。  

![logo]([])  


## 如何使用此镜像  


### 启动 arm64v8/mysql 服务器实例  
启动 MySQL 实例非常简单：  

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d arm64v8/mysql:tag
```  

其中 `some-mysql` 是你为容器分配的名称，`my-secret-pw` 是为 MySQL root 用户设置的密码，`tag` 是指定 MySQL 版本的标签（可参考上方标签列表选择合适的标签）。  


### 通过 MySQL 命令行客户端连接  
以下命令启动另一个 `arm64v8/mysql` 容器实例，并针对你原有的 `arm64v8/mysql` 容器运行 `mysql` 命令行客户端，允许你对数据库实例执行 SQL 语句：  

```console
$ docker run -it --network some-network --rm arm64v8/mysql mysql -hsome-mysql -uexample-user -p
```  

其中 `some-mysql` 是你原有的 `arm64v8/mysql` 容器名称（需连接到 `some-network` Docker 网络）。  

此镜像也可用作非 Docker 或远程 MySQL 实例的客户端：  

```console
$ docker run -it --rm arm64v8/mysql mysql -hsome.mysql.host -usome-mysql-user -p
```  

更多关于 MySQL 命令行客户端的信息可参考 [MySQL 文档]([])。  


### 通过 docker compose 使用  
`mysql` 的 `compose.yaml` 示例：  

```yaml
# 使用 root/example 作为用户名/密码凭据

services:
  db:
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
    # （仅为示例，不建议用于生产环境配置）
```  

运行 `docker compose up`，等待初始化完成后，访问 `[] 或 `[]  


### 容器 shell 访问及查看 MySQL 日志  
`docker exec` 命令允许你在 Docker 容器内运行命令。以下命令将为你的 `arm64v8/mysql` 容器打开 bash shell：  

```console
$ docker exec -it some-mysql bash
```  

日志可通过 Docker 容器日志查看：  

```console
$ docker logs some-mysql
```  


### 使用自定义 MySQL 配置文件  
MySQL 的默认配置因基础镜像而异：  

- **基于 Oracle 的镜像（默认）**：默认配置位于 `/etc/my.cnf`，可能通过 `!includedir` 包含额外目录（如 `/etc/mysql/conf.d`）。  
- **基于 Debian 的 MySQL 8 镜像**：默认配置位于 `/etc/mysql/my.cnf`，可能通过 `!includedir` 包含额外目录（如 `/etc/mysql/conf.d`）。  

可在 `arm64v8/mysql` 镜像内检查相关文件和目录以获取更多详情。  

若 `/my/custom/config-file.cnf` 是你的自定义配置文件路径和名称，可按以下方式启动 `arm64v8/mysql` 容器（注意命令中仅使用自定义配置文件的目录路径）：  

```console
$ docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d arm64v8/mysql:tag
```  

此命令将启动名为 `some-mysql` 的新容器，MySQL 实例将使用默认配置文件和 `/etc/mysql/conf.d/config-file.cnf` 的组合启动设置，后者的设置优先级更高。  


#### 无需 cnf 文件的配置  
许多配置选项可通过 `mysqld` 的标志传递。这使你无需 cnf 文件即可自定义容器。例如，若要将所有表的默认编码和排序规则更改为 UTF-8（`utf8mb4`），可运行：  

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d arm64v8/mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```  

如需查看所有可用选项，可运行：  

```console
$ docker run -it --rm arm64v8/mysql:tag --verbose --help
```  


### 环境变量  
启动 `arm64v8/mysql` 镜像时，可通过 `docker run` 命令行传递一个或多个环境变量调整 MySQL 实例配置。注意：若容器启动时数据目录已包含数据库，则以下变量均无效——任何预存数据库在容器启动时均保持不变。  

另请参考 [] 了解 MySQL 本身支持的环境变量（尤其是 `MYSQL_HOST` 等可能导致此镜像使用问题的变量）。  


#### MYSQL_ROOT_PASSWORD  
必填变量，指定 MySQL `root` 超级用户账户的密码。在上述示例中，密码设为 `my-secret-pw`。  


#### MYSQL_DATABASE  
可选变量，用于指定镜像启动时创建的数据库名称。若同时提供了用户/密码（见下文），则该用户将被授予对该数据库的超级用户权限（对应 `GRANT ALL`，详见 [创建账户文档]([])）。  


#### MYSQL_USER、MYSQL_PASSWORD  
可选变量，需配合使用以创建新用户并设置密码。该用户将被授予对 `MYSQL_DATABASE` 指定数据库的超级用户权限（见上文）。创建用户需同时提供这两个变量。  

无需通过此机制创建 root 超级用户，root 用户默认创建，密码由 `MYSQL_ROOT_PASSWORD` 变量指定。  


#### MYSQL_ALLOW_EMPTY_PASSWORD  
可选变量。设为非空值（如 `yes`），允许容器以 root 用户空密码启动。**注意**：除非确知风险，否则不建议设为 `yes`，这会使 MySQL 实例完全无保护，任何人可获取超级用户权限。  


#### MYSQL_RANDOM_ROOT_PASSWORD  
可选变量。设为非空值（如 `yes`），将为 root 用户生成随机初始密码（使用 `openssl`）。生成的 root 密码将打印到标准输出（格式：`GENERATED ROOT PASSWORD: .....`）。  


#### MYSQL_ONETIME_PASSWORD  
将 root 用户（非 `MYSQL_USER` 指定的用户）设置为初始化完成后过期，强制首次登录时修改密码。任何非空值均可激活此设置。**注意**：此功能仅支持 MySQL 5.6+，在 MySQL 5.5 上使用会在初始化时抛出错误。  


#### MYSQL_INITDB_SKIP_TZINFO  
默认情况下，入口点脚本会自动加载 `CONVERT_TZ()` 函数所需的时区数据。若不需要，设为非空值可禁用时区加载。  


### Docker Secrets  
作为通过环境变量传递敏感信息的替代方式，可在上述环境变量后添加 `_FILE` 后缀，使初始化脚本从容器内的文件加载变量值。尤其适用于从 Docker Secrets 加载存储在 `/run/secrets/<secret_name>` 文件中的密码。例如：  

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root -d arm64v8/mysql:tag
```  

目前仅支持 `MYSQL_ROOT_PASSWORD`、`MYSQL_ROOT_HOST`、`MYSQL_DATABASE`、`MYSQL_USER` 和 `MYSQL_PASSWORD`。  


### 初始化新实例  
容器首次启动时，将创建指定名称的新数据库并使用提供的配置变量初始化。此外，将执行 `/docker-entrypoint-initdb.d` 目录中扩展名为 `.sh`、`.sql`、`.sql.gz`、`.sql.bz2`、`.sql.xz` 和 `.sql.zst` 的文件，执行顺序为字母顺序。对于无执行权限的 `.sh` 文件，将通过 `source` 而非直接执行。  

你可通过 [将 SQL 转储文件挂载到该目录]([]) 或提供 [自定义镜像]([]) 来填充 `arm64v8/mysql` 服务的数据。SQL 文件默认导入到 `MYSQL_DATABASE` 指定的数据库。  


## 注意事项  


### 数据存储位置  
重要提示：运行 Docker 容器中的应用时，有多种存储数据的方式。建议 `arm64v8/mysql` 镜像用户熟悉可用选项，包括：  

- **让 Docker 通过内部卷管理在主机系统磁盘上写入数据库文件**：默认方式，简单且对用户透明。缺点是主机系统上的工具和应用可能难以定位文件（即容器外的程序）。  
- **在主机系统上创建数据目录（容器外）并 [挂载到容器内可见目录]([])**：将数据库文件放在主机系统的已知位置，方便主机工具和应用访问。缺点是用户需确保目录存在，并正确设置主机系统上的目录权限和其他安全机制。  

Docker 文档是了解不同存储选项和变体的良好起点，也有许多博客和论坛帖子讨论此领域的建议。以下仅展示上述第二种方式的基本步骤：  

1. 在主机系统的合适卷上创建数据目录，例如 `/my/own/datadir`。  
2. 按以下方式启动 `arm64v8/mysql` 容器：  

```console
$ docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d arm64v8/mysql:tag
```  

命令中的 `-v /my/own/datadir:/var/lib/mysql` 将主机系统的 `/my/own/datadir` 目录挂载为容器内的 `/var/lib/mysql`（MySQL 默认写入数据文件的位置）。  


### MySQL 初始化完成前无法连接  
若容器启动时未初始化数据库，则会创建默认数据库。虽为预期行为，但这意味着初始化完成前容器不接受传入连接。这可能导致使用 Docker Compose 等自动化工具同时启动多个容器时出现问题。  

若你连接 MySQL 的应用无法优雅处理 MySQL  downtime 或等待 MySQL 启动，则可能需要在服务启动前添加连接重试循环。官方镜像中的实现示例可参考 [WordPress]([]) 或 [Bonita]([])。  


### 针对现有数据库使用  
若启动 `arm64v8/mysql` 容器时数据目录已包含数据库（具体为 `mysql` 子目录），则运行命令行中应省略 `$MYSQL_ROOT_PASSWORD` 变量；该变量会被忽略，且现有数据库不会以任何方式更改。  


### 以任意用户运行  
若已知目录权限已正确设置（如针对现有数据库运行，见上文），或需以特定 UID/GID 运行 `mysqld`，可使用 `--user` 参数指定任意值（`root`/`0` 除外）以实现所需访问/配置：  

```console
$ mkdir data
$ ls -lnd data
drwxr-xr-x 2 1000 1000 4096 Aug 27 15:54 data
$ docker run -v "$PWD/data":/var/lib/mysql --user 1000:1000 --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d arm64v8/mysql:tag
```  


### 创建数据库转储  
大多数常规工具均可使用，但为确保能访问 `mysqld` 服务器，使用方式可能略复杂。简单方法是使用 `docker exec` 从同一容器运行工具，例如：  

```console
$ docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```  


### 从转储文件恢复数据  
恢复数据时，可使用带 `-i` 标志的 `docker exec` 命令，例如：  

```console
$ docker exec -i some-mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT

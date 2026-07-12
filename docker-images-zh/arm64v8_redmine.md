---
image: arm64v8/redmine
description: "Redmine是一个使用Ruby on Rails框架开发的灵活的项目管理Web应用程序"
source: https://xuanyuan.cloud/zh/r/arm64v8/redmine
canonical: https://xuanyuan.cloud/zh/r/arm64v8/redmine
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/redmine" title="arm64v8/redmine Docker 镜像中文简介、标签列表与拉取命令">arm64v8/redmine 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**注意：** 这是[`redmine`官方镜像](https://hub.docker.com/_/redmine)的`arm64v8`架构构建的“per-architecture”仓库——更多信息，请参见官方镜像文档中的“[除amd64之外的架构？](https://github.com/docker-library/official-images#architectures-other-than-amd64)”和官方镜像FAQ中的“[Git中的镜像源已更改，现在该怎么办？](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)”。

# 快速参考

- **维护者：**  
  [Docker社区](https://github.com/docker-library/redmine)

- **获取帮助：**  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的`Dockerfile`链接

- [`6.1.0`, `6.1`, `6`, `latest`, `6.1.0-trixie`, `6.1-trixie`, `6-trixie`, `trixie`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.1/trixie/Dockerfile)

- [`6.1.0-bookworm`, `6.1-bookworm`, `6-bookworm`, `bookworm`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.1/bookworm/Dockerfile)

- [`6.1.0-alpine3.22`, `6.1-alpine3.22`, `6-alpine3.22`, `alpine3.22`, `6.1.0-alpine`, `6.1-alpine`, `6-alpine`, `alpine`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.1/alpine3.22/Dockerfile)

- [`6.1.0-alpine3.21`, `6.1-alpine3.21`, `6-alpine3.21`, `alpine3.21`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.1/alpine3.21/Dockerfile)

- [`6.0.7`, `6.0`, `6.0.7-trixie`, `6.0-trixie`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.0/trixie/Dockerfile)

- [`6.0.7-bookworm`, `6.0-bookworm`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.0/bookworm/Dockerfile)

- [`6.0.7-alpine3.22`, `6.0-alpine3.22`, `6.0.7-alpine`, `6.0-alpine`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.0/alpine3.22/Dockerfile)

- [`6.0.7-alpine3.21`, `6.0-alpine3.21`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/6.0/alpine3.21/Dockerfile)

- [`5.1.10`, `5.1`, `5`, `5.1.10-trixie`, `5.1-trixie`, `5-trixie`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/5.1/trixie/Dockerfile)

- [`5.1.10-bookworm`, `5.1-bookworm`, `5-bookworm`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/5.1/bookworm/Dockerfile)

- [`5.1.10-alpine3.22`, `5.1-alpine3.22`, `5-alpine3.22`, `5.1.10-alpine`, `5.1-alpine`, `5-alpine`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/5.1/alpine3.22/Dockerfile)

- [`5.1.10-alpine3.21`, `5.1-alpine3.21`, `5-alpine3.21`](https://github.com/docker-library/redmine/blob/01d5e42cea07875240d7a6f4f6b3a1e13fdcf411/5.1/alpine3.21/Dockerfile)

# 快速参考（续）

- **提交issue的位置：**  
  [https://github.com/docker-library/redmine/issues](https://github.com/docker-library/redmine/issues?q=)

- **支持的架构：** ([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/redmine/)、[`arm32v5`](https://hub.docker.com/r/arm32v5/redmine/)、[`arm32v6`](https://hub.docker.com/r/arm32v6/redmine/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/redmine/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/redmine/)、[`i386`](https://hub.docker.com/r/i386/redmine/)、[`mips64le`](https://hub.docker.com/r/mips64le/redmine/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/redmine/)、[`riscv64`](https://hub.docker.com/r/riscv64/redmine/)、[`s390x`](https://hub.docker.com/r/s390x/redmine/)

- **已发布的镜像工件详情：**  
  [repo-info仓库的`repos/redmine/`目录](https://github.com/docker-library/repo-info/blob/master/repos/redmine) ([历史记录](https://github.com/docker-library/repo-info/commits/master/repos/redmine))  
 （镜像元数据、传输大小等）

- **镜像更新：**  
  [official-images仓库的`library/redmine`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fredmine)  
  [official-images仓库的`library/redmine`文件](https://github.com/docker-library/official-images/blob/master/library/redmine) ([历史记录](https://github.com/docker-library/official-images/commits/master/library/redmine))

- **本描述的来源：**  
  [docs仓库的`redmine/`目录](https://github.com/docker-library/docs/tree/master/redmine) ([历史记录](https://github.com/docker-library/docs/commits/master/redmine))

# 什么是Redmine？

Redmine是一个免费开源的基于Web的项目管理和问题跟踪工具。它允许用户管理多个项目及相关子项目。其功能包括每个项目的维基和论坛、时间跟踪以及灵活的基于角色的访问控制。它包含日历和甘特图，以帮助直观展示项目及其截止日期。Redmine与各种版本控制系统集成，并包含仓库浏览器和差异查看器。

> [wikipedia.org/wiki/Redmine](https://en.wikipedia.org/wiki/Redmine)

![logo](https://raw.githubusercontent.com/docker-library/docs/969091c4c590befe236a71d4a7bce5823fff020d/redmine/logo.png)

# 如何使用本镜像

## 使用SQLite3运行Redmine

这是最简单的设置；只需运行Redmine即可。

```console
$ docker run -d --name some-redmine arm64v8/redmine
```

> 不适合多用户生产环境使用 ([redmine维基](http://www.redmine.org/projects/redmine/wiki/RedmineInstall#Supported-database-back-ends))

## 使用数据库容器运行Redmine

推荐使用数据库服务器运行Redmine。

1. 启动数据库容器

   - PostgreSQL

     ```console
     $ docker run -d --name some-postgres --network some-network -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=redmine postgres
     ```

   - MySQL（运行Redmine时，将`-e REDMINE_DB_POSTGRES=some-postgres`替换为`-e REDMINE_DB_MYSQL=some-mysql`）

     ```console
     $ docker run -d --name some-mysql --network some-network -e MYSQL_USER=redmine -e MYSQL_PASSWORD=secret -e MYSQL_DATABASE=redmine -e MYSQL_RANDOM_ROOT_PASSWORD=1 mysql:5.7
     ```

2. 启动Redmine

   ```console
   $ docker run -d --name some-redmine --network some-network -e REDMINE_DB_POSTGRES=some-postgres -e REDMINE_DB_USERNAME=redmine -e REDMINE_DB_PASSWORD=secret arm64v8/redmine
   ```

## ... 通过 [`docker compose`](https://github.com/docker/compose)

`redmine`的`compose.yaml`示例：

```yaml
services:

  redmine:
    image: docker.xuanyuan.run/redmine
    restart: always
    ports:
      - 8080:3000
    environment:
      REDMINE_DB_MYSQL: db
      REDMINE_DB_PASSWORD: example
      REDMINE_SECRET_KEY_BASE: supersecretkey

  db:
    image: docker.xuanyuan.run/mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: redmine
```

运行`docker compose up`，等待其完全初始化，然后访问`http://localhost:8080`或`http://主机IP:8080`（视情况而定）。

## 访问应用程序

当前，上游的默认用户名和密码是admin/admin（[登录应用程序](https://www.redmine.org/projects/redmine/wiki/RedmineInstall#Step-10-Logging-into-the-application)）。

## 数据存储位置

重要提示：有多种方式可以存储Docker容器中运行的应用程序所使用的数据。我们建议`redmine`镜像的用户熟悉可用的选项，包括：

- 让Docker通过[使用其自己的内部卷管理将文件写入主机系统的磁盘](https://docs.docker.com/storage/volumes/)来管理文件存储。这是默认选项，对用户来说简单且相当透明。缺点是对于直接在主机系统（即容器外部）运行的工具和应用程序来说，文件可能难以定位。
- 在主机系统上（容器外部）创建一个数据目录，并[将其挂载到容器内可见的目录](https://docs.docker.com/storage/bind-mounts/)。这会将数据库文件放在主机系统上的已知位置，并使主机系统上的工具和应用程序易于访问这些文件。缺点是用户需要确保目录存在，并且主机系统上的目录权限和其他安全机制设置正确。

Docker文档是了解不同存储选项和变体的良好起点，有多个博客和论坛帖子讨论并提供了这方面的建议。我们在此仅展示上述后一种选项的基本步骤：

1. 在主机系统的合适卷上创建一个数据目录，例如`/my/own/datadir`。
2. 像这样启动`redmine`容器：

   ```console
   $ docker run -d --name some-redmine -v /my/own/datadir:/usr/src/redmine/files --link some-postgres:postgres arm64v8/redmine
   ```

命令中的`-v /my/own/datadir:/usr/src/redmine/files`部分将底层主机系统的`/my/own/datadir`目录挂载为容器内的`/usr/src/redmine/files`，Redmine将在其中存储上传的文件。

## 端口映射

如果您希望能够从主机访问实例而无需使用容器的IP，可以使用标准端口映射。只需将`-p 3000:3000`添加到`docker run`参数中，然后在浏览器中访问`http://localhost:3000`或`http://主机IP:3000`。

## 环境变量

启动`redmine`镜像时，您可以通过在`docker run`命令行上传递一个或多个环境变量来调整实例的配置。

### `REDMINE_DB_MYSQL`、`REDMINE_DB_POSTGRES` 或 `REDMINE_DB_SQLSERVER`

这些变量允许您分别设置MySQL、PostgreSQL或Microsoft SQL主机的主机名或IP地址。这些值是互斥的，因此如果设置了其中任意两个，行为是未定义的。如果未设置任何变量，镜像将回退到使用SQLite。

### `REDMINE_DB_PORT`

此变量允许您指定自定义的数据库连接端口。如果未指定，将默认为常规连接端口：MySQL为3306，PostgreSQL为5432，SQLite为空字符串。

### `REDMINE_DB_USERNAME`

此变量设置Redmine和任何rake任务用于连接到指定数据库的用户。如果未指定，MySQL将默认为`root`，PostgreSQL为`postgres`，SQLite为`redmine`。

### `REDMINE_DB_PASSWORD`

此变量设置指定用户连接数据库时使用的密码。没有默认值。

### `REDMINE_DB_DATABASE`

此变量设置Redmine在指定数据库服务器中使用的数据库。如果未指定，MySQL将默认为`redmine`，PostgreSQL为`REDMINE_DB_USERNAME`的值，SQLite为`sqlite/redmine.db`。

### `REDMINE_DB_ENCODING`

此变量设置连接数据库服务器时使用的字符编码。如果未指定，MySQL将使用`mysql2`库的默认值（[`UTF-8`](https://github.com/brianmario/mysql2/tree/18673e8d8663a56213a980212e1092c2220faa92#mysql2---a-modern-simple-and-very-fast-mysql-library-for-ruby---binding-to-libmysql)），PostgreSQL为`utf8`，SQLite为`utf8`。

### `REDMINE_NO_DB_MIGRATE`

此变量允许您控制是否在容器启动时运行`rake db:migrate`。只需将变量设置为非空字符串，如`1`或`true`，迁移脚本将不会在容器启动时自动运行。

如果您使用默认`CMD`以外的命令（如`bash`）启动镜像，`db:migrate`也不会运行。有关详细信息，请参阅镜像中的当前`docker-entrypoint.sh`。

### `REDMINE_PLUGINS_MIGRATE`

此变量允许您控制是否在容器启动时运行`rake redmine:plugins:migrate`。只需将变量设置为非空字符串，如`1`或`true`，迁移脚本将在每次容器启动时自动运行。它将在`db:migrate`之后运行。

如果您使用默认`CMD`以外的命令（如`bash`）启动镜像，`redmine:plugins:migrate`将不会运行。有关详细信息，请参阅镜像中的当前`docker-entrypoint.sh`。

### `SECRET_KEY_BASE`

这是一个通用的Rails环境变量。在使用负载均衡副本维护会话连接时，此变量很有用。它“被Rails用于编码存储会话数据的cookie，从而防止其被篡改。生成新的密钥令牌会在重启后使所有现有会话失效”（[会话存储](https://www.redmine.org/projects/redmine/wiki/RedmineInstall#Step-5-Session-store-secret-generation)）。如果您未设置此变量，则`secret_key_base`值将使用`rake generate_secret_token`生成。

为了向后兼容，已弃用的Docker特定变量`REDMINE_SECRET_KEY_BASE`将自动填充`SECRET_KEY_BASE`环境变量。用户应将其部署迁移为直接使用`SECRET_KEY_BASE`变量。

##

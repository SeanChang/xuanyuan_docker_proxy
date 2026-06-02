<!-- xuanyuan-docker-images-zh
image: amd64/mysql
source: https://xuanyuan.cloud/zh/r/amd64/mysql
canonical: https://xuanyuan.cloud/zh/r/amd64/mysql
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/amd64/mysql" title="amd64/mysql Docker 镜像中文简介、标签列表与拉取命令">amd64/mysql — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/amd64/mysql" title="amd64/mysql Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amd64/mysql</a></p>

** 注意 **：这是[`mysql`官方镜像](https://hub.docker.com/_/mysql)的`amd64`架构构建的“每个架构”仓库——更多信息，请参见官方镜像文档中的[“除amd64之外的架构？”](https://github.com/docker-library/official-images#architectures-other-than-amd64)和官方镜像FAQ中的[“镜像的源代码在Git中已更改，现在该怎么办？”](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

# 快速参考

-** 维护者 **：  
  [Docker社区和MySQL团队](https://github.com/docker-library/mysql)

-** 获取帮助的地方 **：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)或[Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的Dockerfile链接

- [`9.4.0`, `9.4`, `9`, `innovation`, `latest`, `9.4.0-oraclelinux9`, `9.4-oraclelinux9`, `9-oraclelinux9`, `innovation-oraclelinux9`, `oraclelinux9`, `9.4.0-oracle`, `9.4-oracle`, `9-oracle`, `innovation-oracle`, `oracle`](https://github.com/docker-library/mysql/blob/7a5e9fbb739c7d423437b8687dfd400ea84fdb20/innovation/Dockerfile.oracle)

- [`8.4.6`, `8.4`, `8`, `lts`, `8.4.6-oraclelinux9`, `8.4-oraclelinux9`, `8-oraclelinux9`, `lts-oraclelinux9`, `8.4.6-oracle`, `8.4-oracle`, `8-oracle`, `lts-oracle`](https://github.com/docker-library/mysql/blob/7a5e9fbb739c7d423437b8687dfd400ea84fdb20/8.4/Dockerfile.oracle)

- [`8.0.43`, `8.0`, `8.0.43-oraclelinux9`, `8.0-oraclelinux9`, `8.0.43-oracle`, `8.0-oracle`](https://github.com/docker-library/mysql/blob/7a5e9fbb739c7d423437b8687dfd400ea84fdb20/8.0/Dockerfile.oracle)

- [`8.0.43-bookworm`, `8.0-bookworm`, `8.0.43-debian`, `8.0-debian`](https://github.com/docker-library/mysql/blob/7a5e9fbb739c7d423437b8687dfd400ea84fdb20/8.0/Dockerfile.debian)

# 快速参考（续）

-** 问题反馈地址 **：  
  [https://github.com/docker-library/mysql/issues](https://github.com/docker-library/mysql/issues?q=)

-** 支持的架构 **：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/mysql/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/mysql/)

-** 镜像 artifact 详情 **：  
  [repo-info仓库的`repos/mysql/`目录](https://github.com/docker-library/repo-info/blob/master/repos/mysql)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/mysql)）  
  （镜像元数据、传输大小等）

-** 镜像更新 **：  
  [official-images仓库的`library/mysql`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fmysql)  
  [official-images仓库的`library/mysql`文件](https://github.com/docker-library/official-images/blob/master/library/mysql)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/mysql)）

-** 本描述的来源 **：  
  [docs仓库的`mysql/`目录](https://github.com/docker-library/docs/tree/master/mysql)（[历史记录](https://github.com/docker-library/docs/commits/master/mysql)）

# 什么是MySQL？

MySQL是世界上最流行的开源数据库。凭借其经过验证的性能、可靠性和易用性，MySQL已成为基于Web的应用程序的首选数据库，涵盖从个人项目和网站，到电子商务和信息服务，再到包括Facebook、Twitter、YouTube、Yahoo!等在内的高知名度网络属性。

有关MySQL Server和其他MySQL产品的更多信息及相关下载，请访问[www.mysql.com](http://www.mysql.com)。

![logo](https://raw.githubusercontent.com/docker-library/docs/c408469abbac35ad1e4a50a6618836420eb9502e/mysql/logo.png)

# 如何使用此镜像

## 启动一个`amd64/mysql`服务器实例

启动MySQL实例非常简单：

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d amd64/mysql:tag
```

其中`some-mysql`是你要分配给容器的名称，`my-secret-pw`是要为MySQL root用户设置的密码，`tag`是指定你想要的MySQL版本的标签。请参见上面的列表获取相关标签。

## 通过MySQL命令行客户端连接到MySQL

以下命令启动另一个`amd64/mysql`容器实例，并针对原始`amd64/mysql`容器运行`mysql`命令行客户端，允许你对数据库实例执行SQL语句：

```console
$ docker run -it --network some-network --rm amd64/mysql mysql -hsome-mysql -uexample-user -p
```

其中`some-mysql`是原始`amd64/mysql`容器的名称（连接到`some-network`Docker网络）。

此镜像也可用作非Docker或远程实例的客户端：

```console
$ docker run -it --rm amd64/mysql mysql -hsome.mysql.host -usome-mysql-user -p
```

有关MySQL命令行客户端的更多信息，请参见[MySQL文档](http://dev.mysql.com/doc/en/mysql.html)。

## ... 通过[`docker compose`](https://github.com/docker/compose)

`mysql`的`compose.yaml`示例：

```yaml
# 使用root/example作为用户/密码凭据

services:
  db:
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
    # （这只是示例，不旨在作为生产配置）
```

运行`docker compose up`，等待其完全初始化，然后访问`http://localhost:8080`或`http://host-ip:8080`（视情况而定）。

## 容器shell访问和查看MySQL日志

`docker exec`命令允许你在Docker容器内运行命令。以下命令将为你提供`amd64/mysql`容器内的bash shell：

```console
$ docker exec -it some-mysql bash
```

日志可通过Docker的容器日志查看：

```console
$ docker logs some-mysql
```

## 使用自定义MySQL配置文件

MySQL的默认配置因基础镜像而异：

**基于Oracle的镜像（默认）**：默认配置位于`/etc/my.cnf`，可能通过`!includedir`包含其他目录，如`/etc/mysql/conf.d`。

**基于Debian的MySQL 8镜像**：默认配置位于`/etc/mysql/my.cnf`，可能通过`!includedir`包含其他目录，如`/etc/mysql/conf.d`。

请在`amd64/mysql`镜像内检查相关文件和目录以获取更多详细信息。

如果`/my/custom/config-file.cnf`是你的自定义配置文件的路径和名称，你可以这样启动`amd64/mysql`容器（注意此命令中仅使用自定义配置文件的目录路径）：

```console
$ docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d amd64/mysql:tag
```

这将启动一个新容器`some-mysql`，其中MySQL实例使用默认配置文件和`/etc/mysql/conf.d/config-file.cnf`的组合启动设置，后者的设置优先。

### 不使用cnf文件的配置

许多配置选项可以作为`mysqld`的标志传递。这使你能够自定义容器而无需cnf文件。例如，如果你想将所有表的默认编码和排序规则更改为使用UTF-8（`utf8mb4`），只需运行以下命令：

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d amd64/mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

如果你想查看所有可用选项的完整列表，只需运行：

```console
$ docker run -it --rm amd64/mysql:tag --verbose --help
```

## 环境变量

启动`amd64/mysql`镜像时，你可以通过在`docker run`命令行上传递一个或多个环境变量来调整MySQL实例的配置。请注意，如果启动容器时数据目录已包含数据库，则以下变量均不会生效：任何预先存在的数据库在容器启动时都将保持不变。

另请参见https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html了解MySQL本身所尊重的环境变量文档（特别是`MYSQL_HOST`等变量，已知在与此镜像一起使用时会导致问题）。

### `MYSQL_ROOT_PASSWORD`

此变量是必需的，指定将为MySQL`root`超级用户账户设置的密码。在上面的示例中，它被设置为`my-secret-pw`。

### `MYSQL_DATABASE`

此变量是可选的，允许你指定在镜像启动时要创建的数据库名称。如果提供了用户/密码（见下文），则该用户将被授予对该数据库的超级用户访问权限（对应于[`GRANT ALL`](https://dev.mysql.com/doc/refman/en/creating-accounts.html)）。

### `MYSQL_USER`、`MYSQL_PASSWORD`

这些变量是可选的，结合使用以创建新用户并设置该用户的密码。此用户将被授予对`MYSQL_DATABASE`变量指定的数据库的超级用户权限（见上文）。创建用户需要这两个变量。

请注意，无需使用此机制创建root超级用户，该用户默认使用`MYSQL_ROOT_PASSWORD`变量指定的密码创建。

### `MYSQL_ALLOW_EMPTY_PASSWORD`

这是一个可选变量。设置为非空值（如`yes`），允许容器以root用户空密码启动。** 注意 **：除非你确实知道自己在做什么，否则不建议将此变量设置为`yes`，因为这会使你的MySQL实例完全不受保护，允许任何人获得完全的超级用户访问权限。

### `MYSQL_RANDOM_ROOT_PASSWORD`

这是一个可选变量。设置为非空值（如`yes`），为root用户生成随机初始密码（使用`openssl`）。生成的root密码将打印到标准输出（`GENERATED ROOT PASSWORD: .....`）。

### `MYSQL_ONETIME_PASSWORD`

初始化完成后将root用户（不是`MYSQL_USER`指定的用户！）设置为过期状态，强制首次登录时更改密码。任何非空值都将激活此设置。** 注意 **：此功能仅在MySQL 5.6+上受支持。在MySQL 5.5上使用此选项将在初始化期间抛出相应错误。

### `MYSQL_INITDB_SKIP_TZINFO`

默认情况下，入口点脚本会自动加载`CONVERT_TZ()`函数所需的时区数据。如果不需要，任何非空值都会禁用时区加载。

## Docker Secrets

作为通过环境变量传递敏感信息的替代方法，可以将`_FILE`附加到前面列出的环境变量，使初始化脚本从容器中存在的文件加载这些变量的值。特别是，这可用于从存储在`/run/secrets/<secret_name>`文件中的Docker Secrets加载密码。例如：

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root -d amd64/mysql:tag
```

目前，仅`MYSQL_ROOT_PASSWORD`、`MYSQL_ROOT_HOST`、`MYSQL_DATABASE`、`MYSQL_USER`和`MYSQL_PASSWORD`支持此功能。

# 初始化新实例

当容器首次启动时，将创建具有指定名称的新数据库，并使用提供的配置变量进行初始化。此外，它将执行`/docker-entrypoint-initdb.d`中找到的扩展名为`.sh`、`.sql`、`.sql.gz`、`.sql.bz2`、`.sql.xz`和`.sql.zst`的文件。文件将按字母顺序执行。当解析没有执行位的`.sh`文件时，它们会被`source`而不是执行。

你可以通过[将SQL转储挂载到该目录](https://docs.docker.com/storage/bind-mounts/)并提供[自定义镜像](https://docs.docker.com/reference/dockerfile/)来轻松填充`amd64/mysql`服务。SQL文件默认将导入到`MYSQL_DATABASE`变量指定的数据库中。

# 注意事项

## 数据存储位置

重要提示：有多种方式存储Docker容器中运行的应用程序所使用的数据。我们鼓励`amd64/mysql`镜像的用户熟悉可用的选项，包括：

- 让Docker通过使用其自己的内部卷管理[将数据库文件写入主机系统的磁盘](https://docs.docker.com/storage/volumes/)来管理数据库数据的存储。这是默认选项，对用户来说简单且相当透明。缺点是对于直接在主机系统（即容器外部）运行的工具和应用程序，文件可能难以定位。
- 在主机系统上（容器外部）创建数据目录，并[将其挂载到容器内可见的目录](https://docs.docker.com/storage/bind-mounts/)。这将数据库文件放置在主机系统上的已知位置，并使主机系统上的工具和应用程序易于访问这些文件。缺点是用户需要确保目录存在，并且主机系统上的目录权限和其他安全机制设置正确。

Docker文档是了解不同存储选项和变体的良好起点，有许多博客和论坛帖子讨论并提供了这方面的建议。我们在这里仅展示上述后一种选项的基本过程：

1. 在主机系统的合适卷上创建数据目录，例如`/my/own/datadir`。
2. 像这样启动`amd64/mysql`容器：

   ```console
   $ docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d amd64/mysql:tag
   ```

命令中的`-v /my/own/datadir:/var/lib/mysql`部分将底层主机系统的`/my/own/datadir`目录挂载为容器内的`/var/lib/mysql`，MySQL默认会在此处写入其数据文件。

## MySQL初始化完成前无连接

如果容器启动时没有初始化数据库，则会创建默认数据库。虽然这是预期行为，但这意味着在初始化完成之前，它不会接受传入连接。当使用自动化工具（如Docker Compose）同时启动多个容器时，这可能会导致问题。

如果你尝试连接到MySQL的应用程序不能优雅地处理MySQL停机或等待MySQL启动，那么在服务启动前放置一个连接重试循环可能是必要的。有关官方镜像中此类实现的示例，请参见[WordPress](https://github.com/docker-library/wordpress/blob/1b48b4bccd7adb0f7ea1431c7b470a40e186f3da/docker-entrypoint.sh#L195-L235)或[Bonita](https://github.com/docker-library/docs/blob/9660a0cccb87d8db842f33bc0578d769caaf3ba9/bonita/stack.yml#L28-L44)。

## 针对现有数据库的使用

如果你启动`amd64/mysql`容器实例时，数据目录已包含数据库（特别是`mysql`子目录），则`$MYSQL_ROOT_PASSWORD`变量应从运行命令行中省略；无论如何它都会被忽略，并且预先存在的数据库不会以任何方式更改。

## 以任意用户运行

如果你知道目录的权限已适当设置（例如针对现有数据库运行，如上所述），或者你需要以特定UID/GID运行`mysqld`，则可以使用`--user`将此镜像调用为任何值（`root`/`0`除外）以实现所需的访问/配置：

```console
$ mkdir data
$ ls -lnd data
drwxr-xr-x 2 1000 1000 4096 Aug 27 15:54 data
$ docker run -v "$PWD/data":/var/lib/mysql --user 1000:1000 --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d amd64/mysql:tag
```

## 创建数据库备份

大多数常规工具都可以使用，尽管在某些

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/amd64/mysql" title="amd64/mysql Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/amd64/mysql</a></p>

---
image: centos/mysql-57-centos7
description: "MySQL 5.7 SQL数据库服务器容器镜像，适用于OpenShift和一般用途，支持RHEL、CentOS和Fedora基础镜像，提供环境变量配置、数据持久化及扩展功能。"
source: https://xuanyuan.cloud/zh/r/centos/mysql-57-centos7
canonical: https://xuanyuan.cloud/zh/r/centos/mysql-57-centos7
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/centos/mysql-57-centos7" title="centos/mysql-57-centos7 Docker 镜像中文简介、标签列表与拉取命令">centos/mysql-57-centos7 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

MySQL 5.7 SQL Database Server 容器镜像
==========================================

此容器镜像包含适用于 OpenShift 和一般用途的 MySQL 5.7 SQL 数据库服务器。用户可选择基于 RHEL、CentOS 和 Fedora 的镜像。RHEL 镜像可在 [Red Hat Container Catalog](https://access.redhat.com/containers/) 获取，CentOS 镜像可在 [Docker Hub](https://hub.docker.com/r/centos/) 获取，Fedora 镜像可在 [Fedora Registry](https://registry.fedoraproject.org/) 获取。生成的镜像可使用 [podman](https://github.com/containers/libpod) 或 Docker 运行。

注意：本文档中的示例使用 `podman`，但所有此类命令均可替换为 `docker`，参数保持不变。

## 描述

此容器镜像提供 MySQL mysqld 守护进程和客户端应用的容器化打包。mysqld 服务器守护进程接受客户端连接，并代表客户端提供对 MySQL 数据库内容的访问。有关 MySQL 项目的更多信息，请访问项目网站 (https://www.mysql.com/)。

## 使用

以下示例假设使用 Red Hat Container Catalog 中的 MySQL 5.7 容器镜像 `rhscl/mysql-57-rhel7`。

若只需设置必填环境变量且不将数据库存储在主机目录中，执行以下命令：

```
$ docker run -d --name mysql_database -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=db -p 3306:3306 rhscl/mysql-57-rhel7
```

此命令将创建名为 `mysql_database` 的容器，运行 MySQL 数据库 `db`，并创建用户凭据 `user:pass`。端口 3306 将暴露并映射到主机。若需数据库在容器重启后持久化，需添加 `-v /host/db/path:/var/lib/mysql/data` 参数，此路径为 MySQL 数据目录。

若数据库目录未初始化，入口脚本将首先运行 [`mysql_install_db`](https://dev.mysql.com/doc/refman/en/mysql-install-db.html) 并设置必要的数据库用户和密码。数据库初始化后（或已存在），`mysqld` 将作为 PID 1 执行。可通过 `docker stop mysql_database` 停止后台运行的容器。

## 环境变量和卷

镜像支持以下环境变量，可在初始化时通过 `docker run` 命令的 `-e VAR=VALUE` 参数设置。

**`MYSQL_USER`**
用户要创建的 MySQL 账户名

**`MYSQL_PASSWORD`**
用户账户的密码

**`MYSQL_DATABASE`**
数据库名称

**`MYSQL_ROOT_PASSWORD`**
root 用户的密码（可选）

以下环境变量影响 MySQL 配置文件，均为可选：

**`MYSQL_LOWER_CASE_TABLE_NAMES (默认: 0)`**
设置表名的存储和比较方式

**`MYSQL_MAX_CONNECTIONS (默认: 151)`**
允许的最大同时客户端连接数

**`MYSQL_MAX_ALLOWED_PACKET (默认: 200M)`**
单个数据包或生成/中间字符串的最大大小

**`MYSQL_FT_MIN_WORD_LEN (默认: 4)`**
FULLTEXT 索引中包含的单词最小长度

**`MYSQL_FT_MAX_WORD_LEN (默认: 20)`**
FULLTEXT 索引中包含的单词最大长度

**`MYSQL_AIO (默认: 1)`**
控制 `innodb_use_native_aio` 设置值（当原生 AIO 损坏时）。参见 http://help.directadmin.com/item.php?id=529

**`MYSQL_TABLE_OPEN_CACHE (默认: 400)`**
所有线程打开的表数量

**`MYSQL_KEY_BUFFER_SIZE (默认: 32M 或可用内存的 10%)`**
用于索引块的缓冲区大小

**`MYSQL_SORT_BUFFER_SIZE (默认: 256K)`**
用于排序的缓冲区大小

**`MYSQL_READ_BUFFER_SIZE (默认: 8M 或可用内存的 5%)`**
用于顺序扫描的缓冲区大小

**`MYSQL_INNODB_BUFFER_POOL_SIZE (默认: 32M 或可用内存的 50%)`**
InnoDB 缓存表和索引数据的缓冲池大小

**`MYSQL_INNODB_LOG_FILE_SIZE (默认: 8M 或可用内存的 15%)`**
日志组中每个日志文件的大小

**`MYSQL_INNODB_LOG_BUFFER_SIZE (默认: 8M 或可用内存的 15%)`**
InnoDB 用于写入磁盘日志文件的缓冲区大小

**`MYSQL_DEFAULTS_FILE (默认: /etc/my.cnf)`**
指向替代配置文件的路径

**`MYSQL_BINLOG_FORMAT (默认: statement)`**
设置 binlog 格式，支持 `row` 和 `statement`

**`MYSQL_LOG_QUERIES_ENABLED (默认: 0)`**
设置为 `1` 以启用查询日志

可通过 `docker run` 的 `-v /host:/container` 参数设置以下挂载点：

**`/var/lib/mysql/data`**
MySQL 数据目录

**注意：从主机挂载目录到容器时，确保挂载目录具有适当的权限，且目录的所有者和组与容器内运行的用户 UID 或名称匹配。**

## MySQL 自动调优

当 MySQL 镜像使用 `--memory` 参数运行且未指定某些参数值时，这些参数值将根据可用内存自动计算：

**`MYSQL_KEY_BUFFER_SIZE (默认: 10%)`**
对应 `key_buffer_size`

**`MYSQL_READ_BUFFER_SIZE (默认: 5%)`**
对应 `read_buffer_size`

**`MYSQL_INNODB_BUFFER_POOL_SIZE (默认: 50%)`**
对应 `innodb_buffer_pool_size`

**`MYSQL_INNODB_LOG_FILE_SIZE (默认: 15%)`**
对应 `innodb_log_file_size`

**`MYSQL_INNODB_LOG_BUFFER_SIZE (默认: 15%)`**
对应 `innodb_log_buffer_size`

## MySQL root 用户

root 用户默认无密码，仅允许本地连接。可通过设置 `MYSQL_ROOT_PASSWORD` 环境变量设置密码，允许远程登录 root 账户。本地连接仍无需密码。

要禁用远程 root 访问，只需取消设置 `MYSQL_ROOT_PASSWORD` 并重启容器。

## 更改密码

由于密码是镜像配置的一部分，更改数据库用户（`MYSQL_USER`）和 root 用户密码的唯一支持方法是分别更改环境变量 `MYSQL_PASSWORD` 和 `MYSQL_ROOT_PASSWORD`。

通过 SQL 语句或上述环境变量以外的任何方式更改数据库密码，会导致变量中存储的值与实际密码不匹配。数据库容器每次启动时，都会将密码重置为环境变量中存储的值。

## 默认 my.cnf 文件

通过环境变量可自定义许多 MySQL 引导配置参数。若希望使用自己的配置文件，可通过 `MYSQL_DEFAULTS_FILE` 环境变量覆盖默认路径。例如，默认位置为 `/etc/my.cnf`，可通过设置 `MYSQL_DEFAULTS_FILE=/etc/mysql/my.cnf` 更改为 `/etc/mysql/my.cnf`。

## 扩展镜像

此镜像可在 OpenShift 中使用 `Source` 构建策略，或通过独立的 [source-to-image](https://github.com/openshift/source-to-image) 应用（如可用）进行扩展。以下示例假设使用 `rhscl/mysql-57-rhel7` 镜像（在 OpenShift 中通过 `mysql:5.7` 镜像流标签可用）。

例如，要构建包含来自 `https://github.com/sclorg/mysql-container/tree/master/examples/extend-image` 配置的自定义 MySQL 数据库镜像 `my-mysql-rhel7`，运行：

```
$ oc new-app mysql:5.7~https://github.com/sclorg/mysql-container.git \
	--name my-mysql-rhel7 \
	--context-dir=examples/extend-image \
	--env MYSQL_OPERATIONS_USER=opuser \
	--env MYSQL_OPERATIONS_PASSWORD=oppass \
	--env MYSQL_DATABASE=opdb \
	--env MYSQL_USER=user \
	--env MYSQL_PASSWORD=pass
```

或通过 s2i：

```
$ s2i build --context-dir=examples/extend-image https://github.com/sclorg/mysql-container.git rhscl/mysql-57-rhel7 my-mysql-rhel7
```

传递给 OpenShift 的目录可包含以下子目录：

`mysql-cfg/`
容器启动时，此目录中的文件将用作 `mysqld` 守护进程的配置。会对文件运行 `envsubst` 命令，以便仍可通过环境变量自定义镜像。

`mysql-pre-init/`
此目录中的 Shell 脚本（`*.sh`）在 `mysqld` 守护进程启动前执行。

`mysql-init/`
此目录中的 Shell 脚本（`*.sh`）在 `mysqld` 守护进程本地启动时执行。在此阶段，可使用 `${mysql_flags}` 连接到本地运行的守护进程，例如 `mysql $mysql_flags < dump.sql`

可在提供给 s2i 的脚本中使用的变量：

`$mysql_flags`
初始化期间连接到本地运行的 `mysqld` 的 `mysql` 工具参数

`$MYSQL_RUNNING_AS_MASTER`
当容器使用 `run-mysqld-master` 命令运行时定义

`$MYSQL_RUNNING_AS_SLAVE`
当容器使用 `run-mysqld-slave` 命令运行时定义

`$MYSQL_DATADIR_FIRST_INIT`
当容器从空数据目录初始化时定义

`s2i build` 期间，所有提供的文件将复制到结果镜像的 `/opt/app-root/src` 目录。若目标目录中已存在同名配置文件，将被覆盖。用户提供的文件优先于 `/usr/share/container-scripts/mysql/` 中的默认文件，因此可覆盖默认文件。

每次使用 `docker run` 启动镜像时，也可使用相同的配置目录结构自定义镜像。需将目录挂载到镜像的 `/opt/app-root/src/`（`-v ./image-configuration/:/opt/app-root/src/`）。这将覆盖镜像中内置的自定义配置。

## 使用 SSL 保护连接

要使用 SSL 保护连接，可使用上述扩展功能。具体而言，将 SSL 证书放入单独目录：

    sslapp/mysql-certs/server-cert-selfsigned.pem
    sslapp/mysql-certs/server-key.pem

然后在 mysql-cfg 中放置单独的配置文件：

    $> cat sslapp/mysql-cfg/ssl.cnf
    [mysqld]
    ssl-key=${APP_DATA}/mysql-certs/server-key.pem
    ssl-cert=${APP_DATA}/mysql-certs/server-cert-selfsigned.pem

可通过 `-v` 将 `sslapp` 目录挂载到容器，或使用 s2i 构建新容器镜像。

## 升级和数据目录版本检查

MySQL 和 MariaDB 使用 X.Y.Z 格式的版本号（如 5.6.23）。Z 部分的版本变更中，服务器的二进制数据格式保持兼容，无需特殊升级步骤。从 X.Y 升级到 X.Y+1 时，需考虑按 https://dev.mysql.com/doc/refman/5.7/en/upgrading-from-previous-series.html 中的说明执行手动步骤。

不支持跳过版本（如从 X.Y 升级到 X.Y+2）或降级到低版本；唯一例外是从 MariaDB 5.5 升级到 MariaDB 10.0。

**重要**：升级到新版本始终存在风险，用户应在升级前对所有数据进行完整备份。

更安全的升级方案是使用 `mysqldump` 或 `mysqldbexport` 导出所有数据，然后使用 `mysql` 或 `mysqldbimport` 将数据加载到空（新初始化的）数据库中。

另一种升级方式是启动新版本的 `mysqld` 守护进程，并在启动后立即运行 `mysql_upgrade`。这种所谓的原地升级通常对大型数据目录更快，但仅支持从紧接的上一版本升级，不支持跳过版本。

此容器会检测数据是否需要使用 `mysql_upgrade` 升级，可通过设置 `MYSQL_DATADIR_ACTION` 变量控制，该变量可包含以下一个或多个值：

* `upgrade-warn` -- 若可确定数据版本且数据来自不同版本的守护进程，将打印警告但容器继续启动。这是默认值。由于历史上未创建版本文件 `mysql_upgrade_info`，使用此选项时，若版本文件不存在将自动创建，但不会调用 `mysql_upgrade`。不过，此自动创建功能将在几个月后移除，因为届时大多数部署应已创建版本文件。
* `upgrade-auto` -- 容器启动时，若可确定数据版本且数据来自紧接的上一版本，将在本地守护进程运行时执行 `mysql_upgrade`。若数据来自更早或更新版本，将打印警告。此值实际上启用自动升级，但始终存在风险，用户仍应在启动新版本容器前备份所有数据。
* `upgrade-force` -- 容器启动时，无论数据来自哪个版本的守护进程，只要本地守护进程运行，就会执行 `mysql_upgrade --force`。这也是在数据目录根目录中创建缺失的版本文件 `mysql_upgrade_info` 的方法；该文件存储数据版本信息。

还可在容器启动时执行以下操作（无论检测到的数据版本如何）：

* `optimize` -- 运行 `mysqlcheck --optimize`，优化所有表。
* `analyze` -- 运行 `mysqlcheck --analyze`，分析所有表。
* `disable` -- 不执行任何与数据目录版本相关的操作。

多个值用逗号分隔并按顺序执行，例如 `MYSQL_DATADIR_ACTION="optimize,analyze"`。

## 更改复制 binlog 格式

某些应用可能希望使用 `row` binlog 格式（例如，那些基于变更数据捕获构建的应用）。默认复制/binlog 格式为 `statement`，但可通过设置 `MYSQL_BINLOG_FORMAT` 环境变量更改。例如 `MYSQL_BINLOG_FORMAT=row`。当使用主复制模式运行数据库（即，将 Docker/容器 `cmd` 设置为 `run-mysqld-master`）时，binlog 将输出更改行的实际数据，而非导致更改的语句（如 DML 语句 insert...）。

## 故障排除

容器中的 mysqld 守护进程日志输出到标准输出，因此可通过容器日志查看。可运行以下命令检查日志：

    docker logs <container>

## 参见

此容器镜像的 Dockerfile 和其他源代码可在 https://github.com/sclorg/mysql-container 获取。在该仓库中，CentOS 的 Dockerfile 名为 Dockerfile，RHEL7 的为 Dockerfile.rhel7，RHEL8 的为 Dockerfile.rhel8，Fedora 的为 Dockerfile.fedora。

---
image: guacamole/guacamole
description: "Apache Guacamole是一款无客户端远程桌面网关，支持VNC和RDP等协议。"
source: https://xuanyuan.cloud/zh/r/guacamole/guacamole
canonical: https://xuanyuan.cloud/zh/r/guacamole/guacamole
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/guacamole/guacamole" title="guacamole/guacamole Docker 镜像中文简介、标签列表与拉取命令">guacamole/guacamole — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/guacamole/guacamole" title="guacamole/guacamole Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/guacamole/guacamole</a>

# 什么是 Apache Guacamole？

[Apache Guacamole](https://guacamole.apache.org/) 是一款无客户端远程桌面网关，支持VNC和RDP等标准协议。之所以称为“无客户端”，是因为无需安装任何插件或客户端软件。

借助HTML5技术，一旦在服务器上安装Guacamole，只需通过Web浏览器即可访问您的桌面。

# 如何使用此镜像

使用此镜像需满足以下条件：已运行的 [guacd 镜像](https://registry.hub.docker.com/u/guacamole/guacd/) Docker容器，以及提供PostgreSQL或MySQL数据库的另一Docker容器。

数据库名称及所有相关凭据通过创建容器时指定的环境变量进行配置，其他配置信息通过Docker链接生成。请注意，您需要手动初始化数据库：Guacamole不会自动创建表，但提供了用于初始化的SQL脚本。

Guacamole容器运行后，可通过 `http://[容器地址]:8080/guacamole/` 访问。以下说明中使用 `-p 8080:8080` 选项将该端口映射到Docker主机，以便外部访问。

## 使用PostgreSQL认证部署

```bash
docker run --name some-guacamole --link some-guacd:guacd \
    --link some-postgres:postgres      \
    -e POSTGRES_DATABASE=guacamole_db  \
    -e POSTGRES_USER=guacamole_user    \
    -e POSTGRES_PASSWORD=some_password \
    -d -p 8080:8080 guacamole/guacamole
```

将Guacamole链接到PostgreSQL需指定三个环境变量，若缺少任何一个，镜像将报错并停止：
1. `POSTGRES_DATABASE` - Guacamole认证使用的数据库名称。
2. `POSTGRES_USER` - Guacamole连接PostgreSQL所用的用户名。
3. `POSTGRES_PASSWORD` - Guacamole以`POSTGRES_USER`身份连接PostgreSQL时使用的密码。

### 初始化PostgreSQL数据库

若数据库尚未初始化Guacamole schema，需在使用Guacamole前完成。Guacamole镜像中包含生成必要SQL脚本的工具。

生成用于初始化全新PostgreSQL数据库的SQL脚本（如[Guacamole手册](https://guacamole.apache.org/doc/gug/jdbc-auth.html#jdbc-auth-postgresql)所述）：

```bash
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > initdb.sql
```

生成脚本后，需执行以下步骤：
1. 在PostgreSQL中为Guacamole创建数据库（如`guacamole_db`）。
2. 在新创建的数据库上运行该脚本。
3. 在PostgreSQL中为Guacamole创建用户（如`guacamole_user`），并授予对该数据库表和序列的访问权限。

通过PostgreSQL提供的`psql`和`createdb`工具执行此过程的详细说明，请参见[Guacamole手册](https://guacamole.apache.org/doc/gug/jdbc-auth.html#jdbc-auth-postgresql)。

## 使用MySQL认证部署

```bash
docker run --name some-guacamole --link some-guacd:guacd \
    --link some-mysql:mysql         \
    -e MYSQL_DATABASE=guacamole_db  \
    -e MYSQL_USER=guacamole_user    \
    -e MYSQL_PASSWORD=some_password \
    -d -p 8080:8080 guacamole/guacamole
```

将Guacamole链接到MySQL需指定三个环境变量，若缺少任何一个，镜像将报错并停止：
1. `MYSQL_DATABASE` - Guacamole认证使用的数据库名称。
2. `MYSQL_USER` - Guacamole连接MySQL所用的用户名。
3. `MYSQL_PASSWORD` - Guacamole以`MYSQL_USER`身份连接MySQL时使用的密码。

### 初始化MySQL数据库

若数据库尚未初始化Guacamole schema，需在使用Guacamole前完成。Guacamole镜像中包含生成必要SQL脚本的工具。

生成用于初始化全新MySQL数据库的SQL脚本（如[Guacamole手册](https://guacamole.apache.org/doc/gug/jdbc-auth.html#jdbc-auth-mysql)所述）：

```bash
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
```

生成脚本后，需执行以下步骤：
1. 在MySQL中为Guacamole创建数据库（如`guacamole_db`）。
2. 在MySQL中为Guacamole创建用户（如`guacamole_user`），并授予对该数据库的访问权限。
3. 在新创建的数据库上运行该脚本。

通过MySQL提供的`mysql`工具执行此过程的详细说明，请参见[Guacamole手册](https://guacamole.apache.org/doc/gug/jdbc-auth.html#jdbc-auth-mysql)。

# 问题反馈

如遇到任何bug，请通过[JIRA](https://issues.apache.org/jira/browse/GUACAMOLE/)创建新issue进行报告。

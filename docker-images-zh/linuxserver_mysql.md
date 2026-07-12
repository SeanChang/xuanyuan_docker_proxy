---
image: linuxserver/mysql
description: "由LinuxServer.io提供的MySQL容器，MySQL是世界上最流行的开源数据库，适用于各种Web应用程序。请注意：该镜像已弃用，不再维护和/或更新。"
source: https://xuanyuan.cloud/zh/r/linuxserver/mysql
canonical: https://xuanyuan.cloud/zh/r/linuxserver/mysql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/mysql" title="linuxserver/mysql Docker 镜像中文简介、标签列表与拉取命令">linuxserver/mysql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 已弃用：不再维护和/或更新

## linuxserver/mysql

[![版本](https://images.microbadger.com/badges/version/linuxserver/mysql.svg)](https://microbadger.com/images/linuxserver/mysql) [![镜像](https://images.microbadger.com/badges/image/linuxserver/mysql.svg)](https://microbadger.com/images/linuxserver/mysql) [![Docker拉取量](https://img.shields.io/docker/pulls/linuxserver/mysql.svg)](https://hub.docker.com/r/linuxserver/mysql/) [![Docker星级](https://img.shields.io/docker/stars/linuxserver/mysql.svg)](https://hub.docker.com/r/linuxserver/mysql/) [![构建状态](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/x86-64/x86-64-mysql)](https://ci.linuxserver.io/job/Docker-Builders/job/x86-64/job/x86-64-mysql/)

MySQL是世界上最流行的开源数据库。凭借其成熟的性能、可靠性和易用性，MySQL已成为基于Web的应用程序的首选数据库，应用范围从个人项目和网站，到电子商务和信息服务，再到包括Facebook、Twitter、YouTube、Yahoo!等在内的知名网络平台。

## 使用方法

```
docker create \
--name=mysql \
-p 3306:3306 \
-e PUID=<用户ID> \
-e PGID=<组ID> \
-e MYSQL_ROOT_PASSWORD=<数据库密码> \
-v </path/to/appdata>:/config \
linuxserver/mysql
```

## 参数说明

参数格式为冒号分隔的两部分，左侧表示主机，右侧表示容器内部。例如端口映射 `-p 外部端口:内部端口`，表示将容器内部端口映射到主机的外部端口。

* `-p 3306` - MySQL服务端口
* `-v /config` - 包含数据库本身和所有相关设置
* `-e MYSQL_ROOT_PASSWORD` - 设置root用户密码（至少4个字符）
* `-e PGID` - 组ID，详见下方说明
* `-e PUID` - 用户ID，详见下方说明

该镜像基于移除了SSH的phusion-baseimage构建。若要在容器运行时访问shell，请执行 `docker exec -it mysql /bin/bash`。

### 用户/组标识符

使用数据卷（`-v`参数）时，主机操作系统和容器之间可能会出现权限问题。通过指定用户`PUID`和组`PGID`可以避免此问题。确保主机上的数据卷目录归您指定的用户所有，即可正常工作。

例如`PUID=1001`和`PGID=1001`。使用以下命令查看您的用户ID和组ID：

```
$ id <用户名>
  uid=1001(用户名) gid=1001(组名) groups=1001(组名)
```

## 应用设置

如果在安装过程中未设置密码（请查看日志中的警告），可以在Docker命令行使用 `mysqladmin -u root password <密码>` 来设置。注意：容器初始数据库设置后，修改MYSQL_ROOT_PASSWORD变量将不会生效。建议在设置完成后编辑运行命令或模板/webui，删除对该变量的引用。

配置文件位于 `/config/custom.cnf`（修改后需重启容器生效），数据库文件位于 `/config/databases`，日志文件位于 `/config/log/mysql`。

容器还包含mysqltuner工具，可以通过exec进入容器内部运行，或执行 `docker exec -it mysql mysqltuner` 从外部运行。如果已为root用户设置密码，系统会提示输入凭据。

## 常用操作

* 容器运行时的Shell访问：`docker exec -it mysql /bin/bash`
* 实时监控容器日志：`docker logs -f mysql`
* 查看容器版本号：`docker inspect -f '{{ index .Config.Labels "build_version" }}' mysql`
* 查看镜像版本号：`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/mysql`

## 版本历史

+ **14.10.16:** 添加版本层信息
+ **14.09.16:** 因USN-3078-1更新版本号
+ **14.03.16:** 移除自动更新功能（某些版本更新会导致容器崩溃），改为在初始化脚本中添加配置选项，使用custom.cnf代替my.cnf
+ **26.01.16:** 将mysqld_safe脚本用户改为abc，改进重启时的异常关闭处理
+ **12.08.15:** 初始发布

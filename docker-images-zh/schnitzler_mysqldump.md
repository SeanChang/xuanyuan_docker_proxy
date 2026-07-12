---
image: schnitzler/mysqldump
description: "一个用于运行mysqldump的轻量级容器，支持直接执行单次备份或通过cron定时执行备份任务。"
source: https://xuanyuan.cloud/zh/r/schnitzler/mysqldump
canonical: https://xuanyuan.cloud/zh/r/schnitzler/mysqldump
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/schnitzler/mysqldump" title="schnitzler/mysqldump Docker 镜像中文简介、标签列表与拉取命令">schnitzler/mysqldump 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# schnitzler/mysqldump 镜像文档

## 支持的标签及对应Dockerfile链接

- ([`3.18` `latest`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.18/Dockerfile))
- ([`3.17`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.17/Dockerfile))
- ([`3.16`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.16/Dockerfile))
- ([`3.15`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.15/Dockerfile))
- ([`3.14`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.14/Dockerfile))
- ([`3.13`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.13/Dockerfile))
- ([`3.12`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.12/Dockerfile))
- ([`3.11`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.11/Dockerfile))
- ([`3.10`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.10/Dockerfile))
- ([`3.9`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.9/Dockerfile))
- ([`3.8`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.8/Dockerfile))
- ([`3.7`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.7/Dockerfile))
- ([`3.6`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.6/Dockerfile))
- ([`3.4`](https://github.com/alexanderschnitzler/docker-mysqldump/blob/3.4/Dockerfile))

## 镜像概述

schnitzler/mysqldump是一个轻量级容器，主要用于执行MySQL数据库备份。该容器支持两种使用方式：默认运行crond服务以通过定时任务执行周期性备份，或直接运行单次备份任务。

## 核心功能与特性

- 支持通过cron定时执行数据库备份
- 支持执行单次数据库备份
- 可自定义备份脚本和定时任务配置
- 轻量级设计，资源占用低
- 环境变量配置数据库连接信息，使用灵活

## 使用场景

- 需要定期自动备份MySQL/MariaDB数据库的场景
- 需要快速执行单次数据库备份的场景
- Docker Compose环境中的数据库备份组件

## 使用方法

### 作为定时任务容器使用

以下是使用crontab配置定时备份的示例。

#### 目录结构

```
.
├── backup              # 备份文件存储目录
├── bin                 # 脚本和配置文件目录
│   ├── backup          # 备份执行脚本
│   └── crontab         # cron任务配置文件
└── docker-compose.yml  # Docker Compose配置文件
```

#### bin目录文件权限设置

确保文件权限正确：
```bash
chown 0:0 bin/backup && chmod 700 bin/backup
chown 0:0 bin/crontab && chmod 600 bin/crontab
```

#### docker-compose.yml配置

```yaml
version: '2'
services:
  db:
    image: docker.xuanyuan.run/mariadb:10.1
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_USER: user
      MYSQL_PASSWORD: password
      MYSQL_DATABASE: database
  cron:
    image: docker.xuanyuan.run/schnitzler/mysqldump
    restart: always
    volumes:
      - ./bin/crontab:/var/spool/cron/crontabs/root  # 挂载crontab配置
      - ./bin/backup:/usr/local/bin/backup          # 挂载备份脚本
    volumes_from:
      - backup                                      # 共享备份存储卷
    command: ["-l", "8", "-d", "8"]                 # crond日志级别和调试级别
    environment:
      MYSQL_HOST: db                                # 数据库主机
      MYSQL_USER: user                              # 数据库用户名
      MYSQL_PASSWORD: password                      # 数据库密码
      MYSQL_DATABASE: database                      # 要备份的数据库名
  backup:
    image: docker.xuanyuan.run/busybox
    volumes:
      - ./backup:/backup                            # 备份文件存储卷
```

#### bin/crontab配置

```
# 分 时 日 月 周 命令
0       0       *       *       *       /usr/local/bin/backup  # 每天0点执行备份
```

#### bin/backup脚本

```bash
#!/bin/sh

now=$(date +"%s_%Y-%m-%d")  # 生成包含时间戳的文件名
/usr/bin/mysqldump --opt -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} > "/backup/${now}_${MYSQL_DATABASE}.sql"
```

### 作为定时任务容器使用（不覆盖bin/crontab）

容器默认包含以下crontab配置：

```
# 日常/每周/每月维护任务
# 分 时 日 月 周 命令
*/15	*	*	*	*	run-parts /etc/periodic/15min  # 每15分钟执行
0	*	*	*	*	run-parts /etc/periodic/hourly   # 每小时执行
0	2	*	*	*	run-parts /etc/periodic/daily    # 每天2点执行
0	3	*	*	6	run-parts /etc/periodic/weekly   # 每周六3点执行
0	5	1	*	*	run-parts /etc/periodic/monthly  # 每月1日5点执行
```

如果默认执行时间满足需求，可直接将备份脚本挂载到相应的周期性任务目录：

```yaml
version: '2'
services:
  ...
  cron:
    image: docker.xuanyuan.run/schnitzler/mysqldump
    restart: always
    volumes:
      - ./bin/backup:/etc/periodic/daily/backup  # 将备份脚本挂载到每日任务目录
    volumes_from:
      - backup
    command: ["-l", "8", "-d", "8"]
    environment:
      MYSQL_HOST: db
      MYSQL_USER: user
      MYSQL_PASSWORD: password
      MYSQL_DATABASE: database
  ...
```

### 执行单次备份

通过清空入口点并直接运行mysqldump命令执行单次备份：

```bash
docker run \
    --rm --entrypoint "" \
    -v `pwd`/backup:/backup \  # 挂载本地备份目录到容器内/backup
    --link="container:alias" \  # 链接到数据库容器（container为数据库容器名，alias为别名）
    schnitzler/mysqldump \
    mysqldump --opt -h alias -u user -p"password" "--result-file=/backup/dumps.sql" database  # 执行备份命令
```

## 环境变量说明

| 环境变量 | 描述 | 示例 |
|---------|------|------|
| MYSQL_HOST | 数据库主机地址 | db |
| MYSQL_USER | 数据库用户名 | user |
| MYSQL_PASSWORD | 数据库密码 | password |
| MYSQL_DATABASE | 要备份的数据库名 | database |

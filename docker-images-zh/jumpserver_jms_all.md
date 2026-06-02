---
image: jumpserver/jms_all
description: "JumpServer all-in-one Docker 镜像，提供一体化部署方案，支持快速部署和使用 JumpServer，适用于纯 B/S 架构 Web 端访问。"
source: https://xuanyuan.cloud/zh/r/jumpserver/jms_all
canonical: https://xuanyuan.cloud/zh/r/jumpserver/jms_all
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jumpserver/jms_all" title="jumpserver/jms_all Docker 镜像中文简介、标签列表与拉取命令">jumpserver/jms_all — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jumpserver/jms_all" title="jumpserver/jms_all Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jumpserver/jms_all</a>

# JumpServer all-in-one Docker 镜像

该项目提供 JumpServer 一体化部署方式的 Docker 镜像生成代码，便于用户快速部署和使用 JumpServer。

## 重要注意事项

环境迁移和更新升级时，请确保 SECRET_KEY 与之前设置一致，不得随机生成，否则数据库中所有加密字段将无法解密。

all-in-one 部署方式不支持 Client 相关功能，仅支持在纯 B/S 架构 Web 端使用。

## 快速启动

```sh
docker-compose up -d
```

## 标准启动（使用外置数据库和缓存）

### 前置要求

- 外置数据库：MariaDB 版本需 ≥ 10.6
- 外置 Redis：Redis 版本需 ≥ 6.2

### 部署外置 MySQL 数据库

```sh
# 自行部署 MySQL 可参考 (https://docs.jumpserver.org/zh/master/install/setup_by_lb/#mysql)
# 创建用户并赋予权限，请自行替换 nu4x599Wq7u0Bn8EABh3J91G 为自定义密码
mysql -u root -p
```

```mysql
create database jumpserver default charset 'utf8';
create user 'jumpserver'@'%' identified by 'nu4x599Wq7u0Bn8EABh3J91G';
grant all on jumpserver.* to 'jumpserver'@'%';
flush privileges;
```

### 部署外置 Redis

```sh
# 自行部署 Redis 可参考 (https://docs.jumpserver.org/zh/master/install/setup_by_lb/#redis)
```

### 环境变量设置

| 环境变量 | 说明 |
|---------|------|
| SECRET_KEY | 自行生成随机字符串，不要包含特殊字符，长度推荐 ≥ 50 |
| BOOTSTRAP_TOKEN | 自行生成随机字符串，不要包含特殊字符，长度推荐 ≥ 24 |
| LOG_LEVEL | 日志等级，测试环境推荐设置为 DEBUG |
| DB_ENGINE | 数据库引擎，设置为 mysql |
| DB_HOST | MySQL 数据库 IP 地址 |
| DB_PORT | MySQL 数据库端口，默认 3306 |
| DB_USER | MySQL 数据库认证用户 |
| DB_PASSWORD | MySQL 数据库认证密码 |
| DB_NAME | JumpServer 使用的数据库名称，默认 jumpserver |
| REDIS_HOST | Redis 服务器 IP 地址 |
| REDIS_PORT | Redis 端口，默认 6379 |
| REDIS_PASSWORD | Redis 认证密码 |

### 数据持久化

需挂载以下目录以实现数据持久化：

- /opt/jumpserver/data: Core 持久化目录，存储录像日志
- /opt/koko/data: Koko 持久化目录
- /opt/lion/data: Lion 持久化目录
- /opt/kael/data: Kael 持久化目录
- /opt/chen/data: Chen 持久化目录
- /var/log/nginx: Nginx 日志持久化目录

> 注意：请记录所有设置信息，升级时需要重新输入使用。

## Docker 部署方案示例

### 启动 JumpServer

```bash
docker run --name jms_all -d \
  -v /opt/jumpserver/core/data:/opt/jumpserver/data \
  -v /opt/jumpserver/koko/data:/opt/koko/data \
  -v /opt/jumpserver/lion/data:/opt/lion/data \
  -p 80:80 \
  -p 2222:2222 \
  -p 30000-30100:30000-30100 \
  -e SECRET_KEY=xxxxxx \
  -e BOOTSTRAP_TOKEN=xxxxxx \
  -e LOG_LEVEL=ERROR \
  -e DB_HOST=192.168.x.x \
  -e DB_PORT=3306 \
  -e DB_USER=jumpserver \
  -e DB_PASSWORD=weakPassword \
  -e DB_NAME=jumpserver \
  -e REDIS_HOST=192.168.x.x \
  -e REDIS_PORT=6379 \
  -e REDIS_PASSWORD=weakPassword \
  --privileged=true \
  -v /opt/jumpserver/core/data:/opt/jumpserver/data \
  -v /opt/jumpserver/koko/data:/opt/koko/data \
  -v /opt/jumpserver/lion/data:/opt/lion/data \
  -v /opt/jumpserver/kael/data:/opt/kael/data \
  -v /opt/jumpserver/chen/data:/opt/chen/data \
  -v /opt/jumpserver/web/log:/var/log/nginx \
  jumpserver/jms_all:latest
```

### 升级 JumpServer

```bash
# 查询当前 JumpServer 配置
docker exec -it jms_all env

# 停止当前容器
docker stop jms_all

# 备份数据库（以下 DB-xxx 参数从上述查询结果获取）
mysqldump -h$DB_HOST -p$DB_PORT -u$DB_USER -p$DB_PASSWORD $DB_NAME > /opt/jumpserver-<版本号>.sql
# 示例: mysqldump -h192.168.100.11 -p3306 -ujumpserver -pnu4x599Wq7u0Bn8EABh3J91G jumpserver > /opt/jumpserver-v2.12.0.sql

# 拉取新版本镜像
docker pull jumpserver/jms_all:latest

# 删除旧版本容器
docker rm jms_all

# 启动新版本容器（请替换以下参数为实际配置）
docker run --name jms_all -d \
  -p 80:80 \
  -p 2222:2222 \
  -p 30000-30100:30000-30100 \
  -e SECRET_KEY= \
  -e BOOTSTRAP_TOKEN= \
  -e LOG_LEVEL=ERROR \
  -e DB_HOST=192.168.x.x \
  -e DB_PORT=3306 \
  -e DB_USER=jumpserver \
  -e DB_PASSWORD= \
  -e DB_NAME=jumpserver \
  -e REDIS_HOST=192.168.x.x \
  -e REDIS_PORT=6379 \
  -e REDIS_PASSWORD= \
  --privileged=true \
  -v /opt/jumpserver/core/data:/opt/jumpserver/data \
  -v /opt/jumpserver/koko/data:/opt/koko/data \
  -v /opt/jumpserver/lion/data:/opt/lion/data \
  -v /opt/jumpserver/kael/data:/opt/kael/data \
  -v /opt/jumpserver/chen/data:/opt/chen/data \
  -v /opt/jumpserver/web/log:/var/log/nginx \
  jumpserver/jms_all:latest
```

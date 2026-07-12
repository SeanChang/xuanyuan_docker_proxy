---
image: alpine/mysql
description: "基于Alpine的MySQL命令行客户端Docker镜像，提供轻量级MySQL命令行交互环境，适用于临时执行SQL命令或容器化环境中的数据库管理。"
source: https://xuanyuan.cloud/zh/r/alpine/mysql
canonical: https://xuanyuan.cloud/zh/r/alpine/mysql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/mysql" title="alpine/mysql Docker 镜像中文简介、标签列表与拉取命令">alpine/mysql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### 概述
mysql Docker镜像是基于Alpine Linux的MySQL命令行客户端容器化版本，提供轻量级的MySQL命令行交互环境，适用于临时执行MySQL命令或容器化环境中的数据库管理。

### Dockerfile来源
https://github.com/alpine-docker/multi-arch-libs/blob/master/mysql/Dockerfile

### 注意事项
- `/usr/bin/mysql`：已弃用的程序名称，未来版本将移除，建议使用 `/usr/bin/mariadb` 替代。
- 版本信息：基于11.4.4-MariaDB构建，客户端版本15.2，适用于Linux (x86_64)，使用readline 5.1。

### 每日CI构建日志
不适用（N/A）

### Docker镜像标签
https://hub.docker.com/repository/docker/alpine/mysql/tags

### 快速开始（部署示例）
可通过别名将容器命令集成到系统环境，实现本地化使用体验：
```
alias mysql="docker run -ti --rm alpine/mysql"
```
配置后即可直接执行MySQL命令，例如连接数据库：
```
mysql -h localhost -u username -p
```

### 使用场景
适用于需要临时执行SQL命令、在无本地MySQL客户端的环境中管理数据库，或在容器化部署中通过命令行工具操作MySQL/MariaDB的场景。轻量级设计使其适合资源受限的环境。

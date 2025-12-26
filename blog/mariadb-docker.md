---
id: 18
title: MariaDB 在 Docker 中的部署
slug: mariadb-docker
summary: 以下教程分为初学者快速上手与进阶生产级注意事项两部分，覆盖镜像拉取、容器启动、数据持久化、初始化脚本、配置定制、备份/恢复、升级与常见故障排查。开头先用官方资料介绍 MariaDB 是什么、有什么用，再进入实操步骤。本文同时给出轩辕镜像（国内加速）的拉取示例。
category: Docker,MariaDB
tags: MariaDB,docker,部署教程
image_name: library/mariadb
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-mariadb.png"
status: published
created_at: "2025-10-08 06:36:39"
updated_at: "2025-10-08 06:44:34"
---

# MariaDB 在 Docker 中的部署

> 以下教程分为初学者快速上手与进阶生产级注意事项两部分，覆盖镜像拉取、容器启动、数据持久化、初始化脚本、配置定制、备份/恢复、升级与常见故障排查。开头先用官方资料介绍 MariaDB 是什么、有什么用，再进入实操步骤。本文同时给出轩辕镜像（国内加速）的拉取示例。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

##  一、什么是 MariaDB？为什么用它？

MariaDB Server 是由 MySQL 的原始开发者继续维护的开源关系型数据库，兼顾性能与可扩展性，并尽可能保持与 MySQL 的二进制兼容与相同 API，广泛用于生产环境（例如维基百科等）。它既可以作为事务型数据库，也常用于 OLTP、分析、以及作为后端存储。官方提供了用于容器化部署的“官方镜像”（Docker Official Image），方便在 Docker 环境中快速启动与管理。

---

##  二、准备：先决条件

* 已安装 Docker（或 Docker Engine + docker-compose / Docker Compose v2）。
* 如果用于生产，建议提前规划存储（host volume / docker volume / NAS），备份策略，以及 secrets 管理（不要把明文密码放在版本库）。
* 本教程在示例里使用 3306 端口、并假设宿主机能访问该端口（生产环境请结合防火墙与网络策略）。

---

##  三、镜像拉取（官方与轩辕镜像）

官方镜像（Docker Hub）：

```bash
docker pull mariadb:latest
##  或指定版本
docker pull mariadb:10.6
```

如果你希望使用镜像访问支持，可以使用你提供的轩辕镜像页面（示例拉取地址）：`https://xuanyuan.cloud/r/library/mariadb`（下文示例以 `docker.xuanyuan.run/library/mariadb:latest` 形式展示）。([xuanyuan.cloud][1])

使用轩辕镜像拉取并重命名（示例）：

```bash
docker pull docker.xuanyuan.run/library/mariadb:latest \
  && docker tag docker.xuanyuan.run/library/mariadb:latest library/mariadb:latest \
  && docker rmi docker.xuanyuan.run/library/mariadb:latest
```

说明：`docker tag` 后你可以用标准 `library/mariadb:latest` 的名字来运行与管理容器（和官方镜像名一致，方便移植）。([轩辕镜像][2])

---

##  四、快速上手（最简易方式，适合练习/开发）

最基本、能跑起来的命令（**必须**设置根密码，或使用等价选项）：

```bash
docker run --detach \
  --name some-mariadb \
  -p 3306:3306 \
  -e MARIADB_ROOT_PASSWORD=my-secret-pw \
  mariadb:latest
```

可选替代（随机 root 密码 / 允许空密码——开发环境谨慎使用）：

```bash
##  随机密码（会输出到容器日志）
docker run -d --name mdb -e MARIADB_RANDOM_ROOT_PASSWORD=1 mariadb:latest

##  允许空密码（危险，仅限测试）
docker run -d --name mdb -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1 mariadb:latest
```

> 关于这些环境变量（`MARIADB_ROOT_PASSWORD`、`MARIADB_RANDOM_ROOT_PASSWORD`、`MARIADB_ALLOW_EMPTY_ROOT_PASSWORD`、以及其他初始化相关变量）的完整说明，请参考官方环境变量文档（强烈建议在生产环境使用 secrets 文件而非明文）。([MariaDB][3])

启动后，查看日志以获取随机密码或排查启动过程：

```bash
docker logs some-mariadb
```

连接到数据库（从另一个临时容器使用客户端）：

```bash
docker run -it --rm --network container:some-mariadb mariadb mariadb -h 127.0.0.1 -u root -p
##  或进入容器
docker exec -it some-mariadb mariadb -uroot -p
```

（上面命令在容器内或客户端中输入密码即可获得 MariaDB 提示符）

---

##  五、持久化（生产必做）

**不要把数据只留在容器内**。常见做法有两种：

1. **命名卷（推荐）**

```bash
docker volume create mariadb_data

docker run -d --name some-mariadb \
  -v mariadb_data:/var/lib/mysql \
  -e MARIADB_ROOT_PASSWORD=securepw \
  -p 3306:3306 \
  mariadb:latest
```

2. **宿主机目录映射（可见性更好）**

> 在 SELinux 系统上，建议用 `:Z` 或 `:z` 标记来设置合适的上下文。

```bash
mkdir -p /data/mariadb
docker run -d --name some-mariadb \
  -v /data/mariadb:/var/lib/mysql:Z \
  -e MARIADB_ROOT_PASSWORD=securepw \
  -p 3306:3306 \
  mariadb:latest
```

如果启动时数据目录已有 mysql 子目录（即已有数据库），镜像的初始化环境变量（如 MARIADB_DATABASE、MARIADB_USER 等）将不会生效 —— 因为镜像会保留已有数据。若需要对已有数据执行升级，可能需要设置 `MARIADB_AUTO_UPGRADE`（见后文）并谨慎操作。([MariaDB][3])

---

##  六、初始化数据库（`/docker-entrypoint-initdb.d`）

首次启动（即数据目录为空）时，镜像会自动执行挂载到容器 `/docker-entrypoint-initdb.d` 目录下的脚本/SQL 文件（按字母顺序执行）。支持文件类型：`.sh`（可执行或可被 source）、`.sql`、以及压缩格式如 `.sql.gz`。常用于建库、导入初始数据、设置权限等。示例：

```bash
##  假设当前目录有 init/01_schema.sql
docker run -d --name some-mariadb \
  -v "$(pwd)/init":/docker-entrypoint-initdb.d \
  -e MARIADB_ROOT_PASSWORD=securepw \
  mariadb:latest
```

当容器首次初始化时，`01_schema.sql` 会被自动导入到数据库中。注意：只有在数据目录为空时才会触发该初始化流程。([MariaDB][4])

---

##  七、自定义配置（`.cnf` 文件）

自定义 `.cnf` 文件应挂载到容器的 `/etc/mysql/conf.d`（只需写变更的最小配置），例如：

```bash
##  在宿主机 /data/mariadb/conf/custom.cnf 中写入：[mysqld] max_connections=500
docker run -d --name some-mariadb \
  -v /data/mariadb/conf/custom.cnf:/etc/mysql/conf.d/custom.cnf:ro \
  -v mariadb_data:/var/lib/mysql \
  -e MARIADB_ROOT_PASSWORD=securepw \
  mariadb:latest
```

镜像会读取 `/etc/mysql/conf.d` 的 `.cnf`，建议仅写必要改动（保持与默认配置的“差异最小化”）。若需要查看容器内最终生效的配置，可以运行：

```bash
docker exec some-mariadb my_print_defaults --mysqld
```

或使用官方 README 中的说明来打印实际配置。([hub.docker.com][1])

---

##  八、通过文件/Secrets 传递密码（更安全）

不要在版本库或 CI 日志中明文写入密码。官方镜像支持 `*_FILE` 形式来从文件读取敏感信息（例如 Docker Secrets）：

```bash
##  假设将 secret 放到 /run/secrets/mariadb-root（Docker Swarm secrets）
docker run -d --name some-mariadb \
  -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb-root \
  --secret source=mariadb-root,target=mariadb-root \
  mariadb:latest
```

或在普通 Docker 中将一个文件挂载到容器内并通过 `MARIADB_ROOT_PASSWORD_FILE` 指向该文件。官方文档有关于这些 env 与 *_FILE 用法的说明，生产环境强烈建议使用此类方式。([MariaDB][3])

---

##  九、Docker Compose 示例（生产/开发常用）

下面给出一个较为完整的 `docker-compose.yml` 示例，包含数据持久化、配置文件、初始化脚本与重启策略（示例使用 Compose v3）：

```yaml
version: '3.8'
services:
  db:
    image: mariadb:10.6
    container_name: mariadb
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD_FILE: /run/secrets/mariadb_root
      MARIADB_DATABASE: exampledb
      MARIADB_USER: example
      MARIADB_PASSWORD_FILE: /run/secrets/mariadb_userpw
    volumes:
      - db_data:/var/lib/mysql
      - ./conf/custom.cnf:/etc/mysql/conf.d/custom.cnf:ro
      - ./init:/docker-entrypoint-initdb.d:ro
    expose:
      - "3306"
    ports:
      - "3306:3306"
    secrets:
      - mariadb_root
      - mariadb_userpw

volumes:
  db_data:

secrets:
  mariadb_root:
    file: ./secrets/mariadb_root
  mariadb_userpw:
    file: ./secrets/mariadb_userpw
```

说明：把密码放在 `./secrets/`（宿主机）里，并在 Compose 中以 `secrets` 方式注入容器，这比直接在 `environment` 明文更安全。([MariaDB][3])

---

##  十、备份与恢复

* **简单备份（mysqldump）**：

```bash
docker exec some-mariadb mysqldump -u root -p'根密码' --all-databases > all.sql
```

* **使用容器内 mariadb-backup（与服务器版本强耦合）**：官方建议使用与 server 相同版本的 `mariadb-backup` 来做备份/恢复。例如：

```bash
docker run --volume /backup-volume:/backup --rm mariadb:10.6 mariadb-backup --backup --target-dir=/backup
```

注意：`mariadb-backup` 与 server 版本高度相关，备份/恢复时请使用对应版本的工具。恢复流程请参考 MariaDB 的备份/恢复官方文档并在非生产环境先验证。([MariaDB][4])

---

##  十一、升级（谨慎操作）

* 如果数据目录已有数据库，镜像启动时默认**不会**重新初始化这些数据库，环境变量也不会生效（这可以防止覆盖数据）。如需执行系统表升级可使用 `MARIADB_AUTO_UPGRADE=1`，但这会运行 `mariadb-upgrade` 并可能影响向下兼容（升级前请备份系统表）。升级时务必要先备份并在测试环境演练。([MariaDB][3])

---

##  十二、健康检查（HEALTHCHECK）

官方镜像没有强制内置一个默认且通用的 `HEALTHCHECK`（不同版本可用的工具不同，例如 `mysqladmin` 在某些版本里不可用），官方/社区提供了 `healthcheck.sh` 脚本供选择。Compose 或 Kubernetes 中可以使用自定义的 SQL 或客户端命令做健康探针，例如：

```yaml
healthcheck:
  test: ["CMD", "mariadb", "-uroot", "-p${MARIADB_ROOT_PASSWORD}", "-e", "select 1"]
  interval: 30s
  timeout: 5s
  retries: 5
```

注意：在使用时要考虑镜像内是否包含相应客户端命令，以及环境变量/密码的注入方式（不要把敏感密码暴露到编排日志）。如需通用健康脚本，参考官方或仓库提供的 `healthcheck.sh`。([MariaDB.org][5])

---

##  十三、常见问题与排查要点

* **容器启动但无法连接**：检查容器日志 `docker logs <name>`；若是首次初始化，可能尚在创建数据库（先等完成）。
* **端口不可达**：检查宿主机防火墙（`ufw` / `firewall-cmd`）与 Docker 的端口映射；容器内 `bind-address` 配置也可能限制远程连接。
* **初始化脚本没执行**：确认数据目录是否为空（只有空数据目录时 `/docker-entrypoint-initdb.d` 中的脚本才会执行）；脚本权限/格式也会影响（`.sh` 需要可执行权限或可被 source）。([MariaDB][4])

---

##  十四、进阶方向（概览）

* **主从复制 / GTID / binlog 配置**：适用于读写分离与备份恢复，需配置 `server-id`、`binlog` 等参数并在网络上建立复制关系（参考 MariaDB 官方复制文档）。
* **Galera / 集群 / 多主模式**：MariaDB 提供 Galera Cluster 支持（适合高可用写场景），部署更复杂，建议先在测试环境熟悉。
* **Operator / Kubernetes 部署**：如果你在 K8s 上部署，考虑使用 MariaDB Operator 或 StatefulSet + PVC 的方案（MariaDB 官方与厂商有相应指南）。([MariaDB][4])

---

##  十五、快速小结

* 开发环境：使用最简 `docker run` 快速启动，便于测试与开发。
* 线上/生产：使用命名卷或宿主机目录持久化、以 `*_FILE` 或 secrets 注入密码、配置自定义 `.cnf`、实现自动化备份并演练恢复流程、在升级前务必备份并在测试环境先跑一次升级演练。([MariaDB][3])

---


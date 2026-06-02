---
image: library/mariadb
description: "MariaDB Server 是一款从 MySQL 分叉而来的高性能开源关系型数据库，它继承了 MySQL 的核心架构与兼容性，同时凭借持续的技术革新和社区驱动的优化，在查询效率、并发处理及数据安全等方面实现了显著提升，广泛应用于企业级系统、Web服务平台及各类数据存储场景，成为全球开发者和组织青睐的开源数据库解决方案之一。"
source: https://xuanyuan.cloud/zh/r/library/mariadb
canonical: https://xuanyuan.cloud/zh/r/library/mariadb
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/mariadb" title="library/mariadb Docker 镜像中文简介、标签列表与拉取命令">library/mariadb — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/mariadb" title="library/mariadb Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/mariadb</a>

# MariaDB Docker 镜像使用指南


## 快速参考

### 维护者  
由 [MariaDB 基金会]([])、[MariaDB 公司]([]) 维护，社区贡献见 [GitHub 仓库]([])。


### 帮助渠道  
- [数据库管理员 Stack Exchange]([])（标签：`docker+mariadb`）  
- [MariaDB 知识库]([])（可[直接提问]([])）  
- 更多帮助见知识库文章：[获取 MariaDB 帮助]([])  


## 支持的标签及对应 Dockerfile 链接  

以下标签按版本分组，对应 Dockerfile 源码链接：  

- **12.1.x 候选版本（RC）**  
  `12.1.1-ubi10-rc`、`12.1-ubi10-rc`、`12.1.1-ubi-rc`、`12.1-ubi-rc`  
  [Dockerfile]([])  

- **12.1.x 候选版本（基于 Ubuntu Noble）**  
  `12.1.1-noble-rc`、`12.1-noble-rc`、`12.1.1-rc`、`12.1-rc`  
  [Dockerfile]([])  

- **12.0.x 稳定版（基于 UBI）**  
  `12.0.2-ubi10`、`12.0-ubi10`、`12-ubi10`、`12.0.2-ubi`、`12.0-ubi`、`12-ubi`  
  [Dockerfile]([])  

- **12.0.x 稳定版（默认标签）**  
  `12.0.2-noble`、`12.0-noble`、`12-noble`、`noble`、`12.0.2`、`12.0`、`12`、`latest`  
  [Dockerfile]([])  

- **11.8.x LTS 版（基于 UBI）**  
  `11.8.3-ubi9`、`11.8-ubi9`、`11-ubi9`、`lts-ubi9`、`11.8.3-ubi`、`11.8-ubi`、`11-ubi`、`lts-ubi`  
  [Dockerfile]([])  

- **11.8.x LTS 版（默认 LTS 标签）**  
  `11.8.3-noble`、`11.8-noble`、`11-noble`、`lts-noble`、`11.8.3`、`11.8`、`11`、`lts`  
  [Dockerfile]([])  

- **其他版本**（11.4.x、10.11.x、10.6.x 等）  
  标签及 Dockerfile 见 [MariaDB Docker 仓库]([])。  


## 更多快速参考  

### 问题反馈  
- Jira：[MDEV 项目 Docker 组件]([])  
- GitHub：[mariadb-docker  issues]([])  


### 支持的架构  
`amd64`、`arm64v8`、`ppc64le`、`s390x`（架构镜像见 [Docker Hub]([])）。  


### 镜像详情  
- 元数据、传输大小等：[repo-info 仓库 mariadb 目录]([])（含[历史记录]([])）。  


### 镜像更新  
- 官方镜像更新跟踪：[library/mariadb 标签]([])  
- 镜像定义文件：[library/mariadb]([])（含[历史记录]([])）。  


### 本文档来源  
[docker-library/docs mariadb 目录]([])（含[历史记录]([])）。  


## 关于 MariaDB  

MariaDB 是全球广泛使用的数据库服务器，由 MySQL 原开发团队打造，保证开源。知名用户包括维基百科、星展银行、ServiceNow 等。其目标是与 MySQL 高度兼容，确保库二进制等效性及 API/命令完全匹配，同时持续开发新功能并优化性能。  

![MariaDB 标志]([])  


## 如何使用镜像  

镜像标签说明：`latest` 为最新稳定版，`lts` 为长期支持版。  


### 运行容器  

#### 基础配置  

##### 端口绑定  
默认容器内数据库监听 3306 端口，可通过 `-p` 映射到主机：  
```console
$ docker run --name some-mariadb -p 3306:3306 mariadb:latest
```  


##### 最小化配置  
启动容器需设置 root 用户密码，支持以下三种方式：  
1. **指定密码**：  
   ```console
   $ docker run --detach --name some-mariadb --env MARIADB_ROOT_PASSWORD=my-secret-pw mariadb:latest
   ```  
2. **允许空密码**：  
   ```console
   $ docker run --detach --name some-mariadb --env MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1 mariadb:latest
   ```  
3. **随机密码**（日志中会输出自动生成的密码）：  
   ```console
   $ docker run --detach --name some-mariadb --env MARIADB_RANDOM_ROOT_PASSWORD=1 mariadb:latest
   ```  


#### 使用 docker compose  
示例 `compose.yaml`：  
```yaml
# 用户/密码：root/example
services:
  db:
    image: mariadb
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: example

  adminer:  # 数据库管理工具
    image: adminer
    restart: always
    ports:
      - 8080:8080  # 访问 [] 管理数据库
```  
启动：`docker compose up`，等待初始化完成后访问上述地址。  


#### 创建用户、密码及数据库  
启动时指定普通用户、密码和数据库：  
```console
$ docker run --detach --name some-mariadb \
  --env MARIADB_USER=example-user \
  --env MARIADB_PASSWORD=my_cool_secret \
  --env MARIADB_DATABASE=example-database \
  --env MARIADB_ROOT_PASSWORD=my-secret-pw \
  mariadb:latest
```  


#### 网络配置  
应用需与 MariaDB 在同一网络中通信：  
```console
# 创建网络
$ docker network create some-network 

# 启动 MariaDB（加入网络）
$ docker run --detach --network some-network --name some-mariadb \
  --env MARIADB_USER=example-user \
  --env MARIADB_PASSWORD=my_cool_secret \
  --env MARIADB_ROOT_PASSWORD=my-secret-pw \
  mariadb:latest

# 启动应用（同一网络，通过容器名访问 MariaDB）
$ docker run --detach --network some-network --name some-application \
  --env APP_DB_HOST=some-mariadb \
  --env APP_DB_USER=example-user \
  --env APP_DB_PASSWD=my_cool_secret \
  some-application
```  


### 连接 MariaDB 命令行客户端  

#### 容器内客户端  
在同一网络中启动临时容器，连接目标 MariaDB：  
```console
$ docker run -it --network some-network --rm mariadb \
  mariadb -h some-mariadb -u example-user -p
```  
（`some-mariadb` 为目标容器名，输入密码后进入 SQL 交互界面）。  


#### 远程连接  
连接非 Docker 或远程实例：  
```console
$ docker run -it --rm mariadb \
  mariadb --host <服务器IP> --user example-user --password --database test
```  
测试连接：输入 `\s` 查看服务器信息。  


### 容器操作  

#### 进入容器 Shell  
```console
$ docker exec -it some-mariadb bash
```  


#### 备份（MariaDB-Backup）  
使用与服务器版本匹配的容器执行备份工具：  
```console
$ docker run --volume /backup-volume:/backup --rm mariadb:10.6.15 \
  mariadb-backup --help  # 查看帮助
```  


#### 查看日志  
```console
$ docker logs some-mariadb
```  


### 自定义配置  

#### 使用自定义配置文件  
配置文件需以 `.cnf` 结尾，挂载到容器 `/etc/mysql/conf.d`（只读）。文件格式示例：  
```ini
[mariadb]
max_connections = 1000
innodb_buffer_pool_size = 512M
```  
默认配置已包含 Ubuntu MariaDB 变量，及容器优化：`host-cache-size=0`（禁用主机缓存）、`skip-name-resolve`（禁用域名解析）。如需启用域名解析，可设置 `disable-skip-name-resolve`。  

查看最终配置：  
```console
$ docker run --name some-mariadb -v /my/custom:/etc/mysql/conf.d --rm mariadb:latest \
  my_print_defaults --mysqld
```  


#### 无配置文件时传参  
可直接通过命令行参数传递配置（覆盖默认值），例如修改端口：  
```console
$ docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw -d \
  mariadb:latest --port 3808
```  
查看所有可用参数：  
```console
$ docker run -it --rm mariadb:latest --verbose --help
```  


### 环境变量  

首次启动且数据目录为空时，需设置以下**必填**环境变量之一（或其 `_FILE` 变体，从文件读取值）：  
- `MARIADB_ROOT_PASSWORD`：设置 root 密码  
- `MARIADB_ALLOW_EMPTY_ROOT_PASSWORD`：允许空 root 密码（设为 `1`）  
- `MARIADB_RANDOM_ROOT_PASSWORD`：生成随机 root 密码（日志中输出）  
- `MARIADB_ROOT_PASSWORD_HASH`：直接传入密码哈希  

其他可选变量（如 `MARIADB_USER`、`MARIADB_DATABASE` 等）及完整列表见 [MariaDB 知识库]([])。  

**注意**：若数据目录已存在数据库，除 `MARIADB_AUTO_UPGRADE`（触发 `mariadb-upgrade`）外，其他初始化变量均无效。  


### 密钥文件（Secrets）  
敏感信息可通过 `_FILE` 后缀从文件读取（如 Docker Secrets）：  
```console
$ docker run --name some-mariadb -e MARIADB_ROOT_PASSWORD_FILE=/run/secrets/mariadb-root -d \
  mariadb:latest
```  


## 初始化数据库内容  

首次启动时，容器会执行 `/docker-entrypoint-initdb.d` 目录下的 `.sh`、`.sql`、`.sql.gz`、`.sql.xz`、`.sql.zst` 文件（按字母顺序）。SQL 文件默认导入到 `MARIADB_DATABASE` 指定的数据库。  

示例：挂载初始化脚本目录：  
```console
$ docker run --name some-mariadb -v /my/init-scripts:/docker-entrypoint-initdb.d -d mariadb:latest
```  


## 注意事项  

### 数据存储  

推荐两种数据持久化方式：  

#### 1. 主机目录挂载（推荐）  
- 在主机创建目录（如 `/my/own/datadir`），挂载到容器 `/var/lib/mysql`：  
  ```console
  $ docker run --name some-mariadb \
    -v /my/own/datadir:/var/lib/mysql:Z \  # :Z 修复 SELinux 权限
    -e MARIADB_ROOT_PASSWORD=my-secret-pw \
    -d mariadb:latest
  ```  
  优点：主机可直接访问数据文件；需确保目录权限正确。  


#### 2. Docker 命名卷  
由 Docker 管理存储，无需关心主机路径：  
```console
$ docker volume create mariadb-data
$ docker run --name some-mariadb -v mariadb-data:/var/lib/mysql -d mariadb:latest
```  


### 初始化完成前无连接  
首次启动时，数据库初始化期间容器不接受连接。自动化工具（如 `docker compose`）需注意等待初始化完成。  


### 健康检查  
官方镜像未默认配置 `HEALTHCHECK`，可使用 `healthcheck.sh` 脚本自定义检查逻辑，详见 [MariaDB 知识库]([])。  


### 现有数据库使用  
若数据目录已存在数据库（含 `mysql` 子目录），初始化变量（除 `MARIADB_AUTO_UPGRADE`）均不生效，数据库结构保持不变。  


### 备份与恢复  
详见 [MariaDB 知识库：容器备份与恢复]([])。  


### 密码重置  
参考 [FAQ：如何重置密码]([])。  


### 安装插件  
详见 [添加插件到 Docker 镜像]([])。  


## 相关镜像  
- [MariaDB MaxScale]([])（数据库代理）  
- [MariaDB ColumnStore]([])（列式存储引擎）  


## Compose 文件示例  
更多示例见 [mariadb-docker 仓库 /examples 目录]([])。  


## 许可证  
镜像中软件的许可信息见 [MariaDB 许可 FAQ]([])。镜像可能包含其他软件（如 Bash），其许可需用户自行确认合规性。

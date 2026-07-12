---
image: centos/postgresql-10-centos7
description: "PostgreSQL是一款高级的对象-关系型数据库管理系统，它开源免费，全面支持SQL标准及扩展功能，提供复杂数据类型（如JSON、数组、地理信息）、强大的事务处理与ACID特性，具备高度可定制性与扩展性，支持高级索引、全文搜索及并发控制，广泛应用于企业级应用、数据仓库、Web开发等领域，以稳定性、安全性和高性能著称。"
source: https://xuanyuan.cloud/zh/r/centos/postgresql-10-centos7
canonical: https://xuanyuan.cloud/zh/r/centos/postgresql-10-centos7
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/centos/postgresql-10-centos7" title="centos/postgresql-10-centos7 Docker 镜像中文简介、标签列表与拉取命令">centos/postgresql-10-centos7 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PostgreSQL 10 SQL数据库服务器容器镜像  


## 简介  
该容器镜像包含PostgreSQL 10 SQL数据库服务器，适用于OpenShift环境及通用场景。用户可选择基于RHEL、CentOS或Fedora的版本：  
- RHEL镜像：[Red Hat Container Catalog]   
- CentOS镜像：[Docker Hub]   
- Fedora镜像：[Fedora Registry]   

镜像可通过 [podman]  运行，也可将命令中的 `podman` 替换为 `docker`（参数不变）。  


## 功能说明  
该镜像封装了PostgreSQL的`postgres`守护进程及客户端工具。`postgres`守护进程接收客户端连接，并代表客户端提供PostgreSQL数据库的访问服务。更多信息可参考 [PostgreSQL官网] 。  


## 基本使用  

### 本地运行（podman/docker）  
以下示例基于 `rhscl/postgresql-10-rhel7` 镜像（OpenShift中对应镜像流标签 `postgresql:10`）。  

#### 非持久化运行  
仅设置必要环境变量，不挂载主机目录（数据仅保存在容器生命周期内）：  
```bash  
$ podman run -d --name postgresql_database \  
  -e POSTGRESQL_USER=user \       # 自定义数据库用户名  
  -e POSTGRESQL_PASSWORD=pass \   # 自定义用户密码  
  -e POSTGRESQL_DATABASE=db \     # 自定义数据库名  
  -p 5432:5432 \                  # 映射容器5432端口到主机  
  rhscl/postgresql-10-rhel7  
```  
- 执行后会创建名为 `postgresql_database` 的容器，包含数据库 `db` 及用户 `user:pass`。  
- **注意**：`postgres` 用户为内部保留账户，不可用于自定义。  
- 停止容器：`podman stop postgresql_database`。  


#### 持久化运行  
若需数据在容器重启后保留，需挂载主机目录到容器内数据库集群目录 `/var/lib/pgsql/data`：  
```bash  
$ podman run -d --name postgresql_database \  
  -e POSTGRESQL_USER=user -e POSTGRESQL_PASSWORD=pass -e POSTGRESQL_DATABASE=db \  
  -p 5432:5432 \  
  -v /host/db/path:/var/lib/pgsql/data \  # 主机目录映射到容器数据目录  
  rhscl/postgresql-10-rhel7  
```  


### OpenShift环境使用  
可通过OpenShift内置模板或 [示例模板]  部署，例如：  
```bash  
$ oc process -f examples/postgresql-ephemeral-template.json \  
  -p POSTGRESQL_VERSION=10 \  
  -p POSTGRESQL_USER=user \  
  -p POSTGRESQL_PASSWORD=pass \  
  -p POSTGRESQL_DATABASE=db \  
  | oc create -f -  
```  


## 环境变量与挂载卷  

### 环境变量  
初始化容器时，可通过 `-e VAR=VALUE` 设置以下环境变量：  

#### 基础配置（必选/常用）  
- **`POSTGRESQL_USER`**：需创建的数据库用户名  
- **`POSTGRESQL_PASSWORD`**：对应用户的密码  
- **`POSTGRESQL_DATABASE`**：需创建的数据库名  
- **`POSTGRESQL_ADMIN_PASSWORD`**（可选）：`postgres` 管理员账户密码（默认仅允许本地无密码登录）  


#### 数据迁移相关（可选）  
用于从远程PostgreSQL服务器迁移数据：  
- **`POSTGRESQL_MIGRATION_REMOTE_HOST`**：远程数据库主机名/IP  
- **`POSTGRESQL_MIGRATION_ADMIN_PASSWORD`**：远程 `postgres` 管理员密码  
- **`POSTGRESQL_MIGRATION_IGNORE_ERRORS`**（可选，默认 `no`）：设为 `yes` 可忽略迁移时的SQL错误  


#### 性能配置（可选）  
影响PostgreSQL配置文件，均有默认值：  
- **`POSTGRESQL_MAX_CONNECTIONS`**：最大客户端连接数（默认100）  
- **`POSTGRESQL_MAX_PREPARED_TRANSACTIONS`**：最大预准备事务数（默认0，若使用需≥`max_connections`）  
- **`POSTGRESQL_SHARED_BUFFERS`**：数据库缓存内存（默认32M）  
- **`POSTGRESQL_EFFECTIVE_CACHE_SIZE`**：系统+数据库缓存估计值（默认128M）  


### 挂载卷  
- **`/var/lib/pgsql/data`**：PostgreSQL数据库集群目录，需持久化时挂载主机目录（如 `-v /host/db/path:/var/lib/pgsql/data`）。  

#### 权限注意事项  
挂载主机目录时，需确保目录权限与容器内运行用户（默认UID 26）匹配。例如，在Linux主机上设置权限：  
```bash  
$ setfacl -m u:26:-wx /your/data/dir  # 授予容器内用户对主机目录的读写权限  
$ podman run <...> -v /your/data/dir:/var/lib/pgsql/data:Z <...>  # 挂载目录  
```  


## 数据迁移  
支持从远程PostgreSQL服务器迁移数据，通过 `pg_dumpall` 远程导出并流式导入本地（无中间文件）。  

### 迁移命令示例  
```bash  
$ podman run -d --name postgresql_database \  
  -e POSTGRESQL_MIGRATION_REMOTE_HOST=172.17.0.2 \  # 远程数据库IP/主机名  
  -e POSTGRESQL_MIGRATION_ADMIN_PASSWORD=remoteAdminP@ssword \  # 远程管理员密码  
  [其他可选配置变量] \  
  openshift/postgresql-92-centos7  # 目标镜像  
```  


### 迁移说明  
- **默认行为**：迁移过程中若SQL命令失败，会终止迁移（保证数据一致性）。  
- **忽略错误**：若需强制继续（可能丢失数据），设置 `POSTGRESQL_MIGRATION_IGNORE_ERRORS=yes`，事后需手动检查日志修复问题。  
- **安全提示**：远程与本地集群通信默认不加密，需自行通过SSL或其他方式保障安全。  


## PostgreSQL自动调优  
若运行容器时通过 `--memory` 参数限制内存，且未手动设置 `POSTGRESQL_SHARED_BUFFERS` 和 `POSTGRESQL_EFFECTIVE_CACHE_SIZE`，镜像会自动计算这两个值：  
- `shared_buffers` = 内存的1/4  
- `effective_cache_size` = 内存的1/2  


## 管理员账户（postgres）  
- 默认无密码，仅允许本地连接（容器内）。  
- 可通过 `POSTGRESQL_ADMIN_PASSWORD` 环境变量设置密码，允许远程登录（本地连接仍无需密码）。  


## 密码修改  
数据库用户（`POSTGRESQL_USER`）和管理员（`postgres`）的密码**仅支持通过环境变量修改**（`POSTGRESQL_PASSWORD` 和 `POSTGRESQL_ADMIN_PASSWORD`）。直接通过SQL命令修改会导致环境变量与实际密码不一致，容器重启后会自动重置为环境变量值。  


## 数据库升级（切换至新版本镜像）  
> **警告**：升级前务必备份数据，确保可手动回滚！  

该镜像支持自动升级由sclorg PostgreSQL 9.6镜像创建的数据目录，通过 `POSTGRESQL_UPGRADE` 变量指定升级方式（基于 `pg_upgrade` 工具）：  

### 升级方式  
- **`copy`**：复制旧数据目录到新目录（安全，升级失败可回滚）。  
- **`hardlink`**：硬链接旧数据文件到新目录（速度快，但旧目录会失效，失败无法回滚）。  

### 注意事项  
- 需保证磁盘空间充足（复制模式需双倍空间）。  
- 仅支持从PostgreSQL 9.6升级，其他版本需手动处理。  


## 扩展镜像  
可通过OpenShift的 `Source` 构建策略或 [s2i]  工具扩展镜像，自定义启动脚本、配置文件等。  


### 扩展目录说明  
在源码目录中添加以下子目录，构建时会被复制到镜像的 `/opt/app-root/src` 下（用户文件优先于默认文件）：  
- **`postgresql-pre-start/`**：容器启动初期执行的 `.sh` 脚本（PostgreSQL未运行）。  
- **`postgresql-cfg/`**：`.conf` 配置文件，会追加到 `postgresql.conf` 末尾。  
- **`postgresql-init/`**：数据库首次初始化后执行的 `.sh` 脚本（仅在数据目录为空时运行）。  
- **`postgresql-start/`**：每次容器启动时执行的 `.sh` 脚本（在 `postgresql-init/` 之后运行）。  


### 扩展示例（s2i方式）  
```bash  
$ s2i build --context-dir examples/extending-image/ \  
  [] \  # 源码仓库  
  rhscl/postgresql-10-rhel7 \  # 基础镜像  
  new-postgresql  # 新镜像名  
```  


## 故障排除  
- **查看日志**：PostgreSQL启动初期日志输出到标准输出，可通过 `podman logs <容器名>` 查看；之后日志会重定向到容器内 `pg_log` 目录。  


## 相关资源  
镜像的Dockerfile及源码见 [GitHub仓库] ，其中：  
- CentOS：`Dockerfile`  
- RHEL7：`Dockerfile.rhel7`  
- RHEL8：`Dockerfile.rhel8`  
- Fedora：`Dockerfile.fedora`

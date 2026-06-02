---
image: library/odoo
description: "Odoo（前身为OpenERP）是一套开源商业应用套件，集成了企业资源规划（ERP）、客户关系管理（CRM）、电子商务、人力资源管理、项目管理、会计、库存管理等多种功能模块，旨在为各类企业提供一体化的业务管理解决方案，支持用户根据需求灵活定制和扩展，凭借开源特性降低企业信息化成本，助力提升运营效率。"
source: https://xuanyuan.cloud/zh/r/library/odoo
canonical: https://xuanyuan.cloud/zh/r/library/odoo
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/odoo" title="library/odoo Docker 镜像中文简介、标签列表与拉取命令">library/odoo — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/odoo" title="library/odoo Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/odoo</a>

# Odoo Docker 镜像使用指南


## 快速参考  
### 维护与支持  
- **维护者**：[Odoo]([])  
- **获取帮助**：可通过 [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([]) 提问  


### 支持的标签及对应 Dockerfile  
以下是当前支持的镜像标签及其 Dockerfile 链接：  
- [`19.0-20251008`, `19.0`, `19`, `latest`]([])  
- [`18.0-20251008`, `18.0`, `18`]([])  
- [`17.0-20251008`, `17.0`, `17`]([])  


### 快速参考（续）  
- **提交 issue**：[Odoo Docker 仓库 issue 页面]([])  
- **支持的架构**（[更多信息]([])）：  
  [`amd64`]([])、[`arm64v8`]([])、[`ppc64le`]([])  
- **镜像工件详情**：可在 [repo-info 仓库的 `repos/odoo/` 目录]([])（[历史记录]([])）查看（包括元数据、传输大小等）。  
- **镜像更新**：通过 [official-images 仓库的 `library/odoo` 标签]([]) 或 [文件]([])（[历史记录]([])）跟踪。  
- **本文档来源**：[docs 仓库的 `odoo/` 目录]([])（[历史记录]([])）  


## 什么是 Odoo？  
Odoo（前身为 OpenERP）是一套开源业务应用套件，采用 Python 开发，基于 LGPL 许可证发布。该套件覆盖从网站/电商到制造、库存、会计等全业务流程，且各模块无缝集成，是目前功能覆盖最全面的企业软件之一。全球有超过 200 万用户使用 Odoo，涵盖从单人小微企业到 30 万用户的大型企业。  

> 官网：[www.odoo.com]([])  


## 如何使用此镜像  
使用 Odoo 镜像需配合运行中的 PostgreSQL 服务器。  


### 1. 启动 PostgreSQL 服务器  
先运行 PostgreSQL 容器，设置数据库用户、密码和初始数据库：  
```console
$ docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:15
```  


### 2. 启动 Odoo 实例  
通过 `--link` 连接到 PostgreSQL 容器（容器别名必须为 `db`，Odoo 才能自动识别）：  
```console
$ docker run -p 8069:8069 --name odoo --link db:db -t odoo
```  
启动后，访问 `[] 即可打开 Odoo。  


### 3. 停止与重启  
- **停止 Odoo**：  
  ```console
  $ docker stop odoo
  ```  
- **重启 Odoo**（保留之前的配置）：  
  ```console
  $ docker start -a odoo
  ```  


### 4. 使用命名卷持久化数据  
默认情况下，Odoo 的文件存储（如附件）位于容器内部，删除容器会丢失数据。推荐使用 **命名卷** 持久化数据：  

#### 持久化 Odoo 数据  
```console
$ docker run -v odoo-data:/var/lib/odoo -d -p 8069:8069 --name odoo --link db:db -t odoo
```  
- `odoo-data` 为命名卷，即使删除容器也会保留数据，下次启动时可复用。  
- 挂载路径 `/var/lib/odoo` 需与 Odoo 配置文件中的 `data_dir` 一致。  

#### 持久化 PostgreSQL 数据  
同理，为 PostgreSQL 数据目录挂载命名卷，避免数据库丢失：  
```console
$ docker run -d -v odoo-db:/var/lib/postgresql/data -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:15
```  


### 5. 自定义配置  
#### 覆盖默认配置文件  
Odoo 默认配置文件位于 `/etc/odoo/odoo.conf`，可通过挂载本地配置文件覆盖：  
```console
$ docker run -v /path/to/your/config:/etc/odoo -p 8069:8069 --name odoo --link db:db -t odoo
```  
> 配置文件模板参考：[官方模板]([])（已包含 Docker 环境必要参数）。  

#### 直接传递命令行参数  
在命令末尾添加 `--` 后接 Odoo 参数，例如过滤数据库：  
```console
$ docker run -p 8069:8069 --name odoo --link db:db -t odoo -- --db-filter=odoo_db_.*
```  


### 6. 挂载自定义插件  
将本地插件目录挂载到容器的 `/mnt/extra-addons`，Odoo 会自动加载：  
```console
$ docker run -v /path/to/your/addons:/mnt/extra-addons -p 8069:8069 --name odoo --link db:db -t odoo
```  
> **注意**：即使没有官方企业版镜像，也可通过此方式挂载 Odoo Enterprise 模块。  


### 7. 运行多个 Odoo 实例  
通过映射不同主机端口，可启动多个 Odoo 实例（均连接同一 PostgreSQL）：  
```console
$ docker run -p 8070:8069 --name odoo2 --link db:db -t odoo  # 第二个实例，端口 8070
$ docker run -p 8071:8069 --name odoo3 --link db:db -t odoo  # 第三个实例，端口 8071
```  
> **注意**：若主机端口与容器端口不同（如 8070:8069），需在 Odoo 中设置 `Settings->Parameters->System Parameters`（需开启开发者模式），将 `web.base.url` 设为容器端口（如 `127.0.0.1:8069`），否则邮件、报表功能可能异常。  


### 8. 环境变量配置  
通过环境变量自定义 PostgreSQL 连接信息（无需修改配置文件）：  

| 变量名       | 说明                                      | 默认值   |  
|--------------|-------------------------------------------|----------|  
| `HOST`       | PostgreSQL 服务器地址（容器名或 IP）       | `db`     |  
| `PORT`       | PostgreSQL 端口                           | `5432`   |  
| `USER`       | 数据库连接用户（需与 PostgreSQL 配置一致） | `odoo`   |  
| `PASSWORD`   | 数据库连接密码（需与 PostgreSQL 配置一致） | `odoo`   |  

示例：连接自定义 PostgreSQL 服务器  
```console
$ docker run -e HOST=192.168.1.100 -e USER=myuser -e PASSWORD=mypass -p 8069:8069 --name odoo -t odoo
```  


### 9. Docker Compose 示例  
使用 `compose.yaml` 简化多容器管理，以下是常见场景配置。  

#### 基础配置  
```yaml
services:
  web:
    image: odoo:17.0  # 指定 Odoo 版本
    depends_on: [db]   # 依赖 db 服务
    ports: ["8069:8069"]
  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
```  

#### 自定义数据库 credentials  
```yaml
services:
  web:
    image: odoo:17.0
    depends_on: [mydb]
    ports: ["8069:8069"]
    environment:
      - HOST=mydb       # 连接名为 mydb 的 PostgreSQL 服务
      - USER=odoo       # 数据库用户
      - PASSWORD=myodoo # 数据库密码
  mydb:
    image: postgres:15
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=myodoo  # 与 web 服务的 PASSWORD 一致
      - POSTGRES_USER=odoo        # 与 web 服务的 USER 一致
```  

#### 完整配置（含数据持久化、自定义插件和配置）  
```yaml
services:
  web:
    image: odoo:17.0
    depends_on: [db]
    ports: ["8069:8069"]
    volumes:
      - odoo-web-data:/var/lib/odoo        # Odoo 数据卷
      - ./config:/etc/odoo                 # 挂载自定义配置（本地 ./config 目录）
      - ./addons:/mnt/extra-addons         # 挂载自定义插件（本地 ./addons 目录）
    environment:
      - PASSWORD_FILE=/run/secrets/postgresql_password  # 从 secret 文件读取密码
    secrets:
      - postgresql_password
  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD_FILE=/run/secrets/postgresql_password  # 从 secret 文件读取密码
      - POSTGRES_USER=odoo
      - PGDATA=/var/lib/postgresql/data/pgdata  # PostgreSQL 数据路径
    volumes:
      - odoo-db-data:/var/lib/postgresql/data/pgdata  # PostgreSQL 数据卷
    secrets:
      - postgresql_password

volumes:
  odoo-web-data:  # Odoo 数据卷（自动创建）
  odoo-db-data:   # PostgreSQL 数据卷（自动创建）

secrets:
  postgresql_password:
    file: odoo_pg_pass  # 本地密码文件（仅含密码字符串）
```  

**启动命令**：在 `compose.yaml` 所在目录执行  
```console
$ docker compose up -d
```  


## 如何升级镜像  
Odoo 镜像每日更新（同步 [nightly 版本]([])）。**以下步骤适用于同一主版本内的升级**（如从 17.0 旧版本升级到 17.0 最新版本），跨主版本升级需参考 [Odoo 官方升级文档]([]) 或 [OpenUpgrade 项目]([])。  

### 升级步骤  
1. 假设旧实例名为 `old-odoo`，需保留其文件存储（Odoo 16.0+ 附件默认存储在 `/var/lib/odoo/filestore/`）。  
2. 启动新实例时，通过 `--volumes-from` 复用旧实例的文件存储：  
   ```console
   $ docker run --volumes-from old-odoo -p 8070:8069 --name new-odoo --link db:db -t odoo
   ```  


## 许可证  
镜像中 Odoo 软件的许可证信息见 [Odoo 源码仓库 LICENSE 文件]([])。  
Docker 镜像可能包含基础系统（如 Bash）及依赖软件，其许可证可能不同。更多信息可参考 [repo-info 仓库的 `odoo/` 目录]([])。  

使用前请确保遵守所有软件的许可证要求。

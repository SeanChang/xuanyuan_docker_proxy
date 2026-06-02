---
image: postgis/postgis
description: "PostGIS是PostgreSQL对象关系型数据库的空间数据库扩展器，它为PostgreSQL增添了对空间数据类型（如点、线、面、几何体集合等）的支持，提供空间索引功能以提升空间数据查询效率，并集成了丰富的空间分析函数（包括距离计算、缓冲区分析、叠加操作等），使PostgreSQL能够高效存储、管理与分析空间数据，广泛应用于地理信息系统（GIS）、位置服务、地图绘制等领域。"
source: https://xuanyuan.cloud/zh/r/postgis/postgis
canonical: https://xuanyuan.cloud/zh/r/postgis/postgis
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/postgis/postgis" title="postgis/postgis Docker 镜像中文简介、标签列表与拉取命令">postgis/postgis — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/postgis/postgis" title="postgis/postgis Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/postgis/postgis</a>

# postgis/postgis 镜像介绍


## 镜像概述

`postgis/postgis` 镜像是在官方 [`postgres`]([]) 镜像基础上构建的，预装了 [PostGIS]([]) 空间数据库扩展。该镜像提供 Debian 和 Alpine 两种版本，支持 PostGIS 3.5.x，兼容 PostgreSQL 13、14、15、16、17 版本。此外，还提供基于最新两个 PostgreSQL 版本（16、17）构建的镜像，其中 PostGIS 及其依赖项均从各自的 master 分支编译。


### 默认数据库扩展

该镜像会为父镜像（`postgres`）创建的默认数据库自动安装以下扩展，其中部分已完成初始化：

| 扩展名称                 | 是否初始化 |
|--------------------------|------------|
| `postgis`                | 是         |
| `postgis_topology`       | 是         |
| `postgis_tiger_geocoder` | 是         |
| `postgis_raster`         |            |
| `postgis_sfcgal`         |            |
| `address_standardizer`   |            |
| `address_standardizer_data_us` |      |

默认数据库名称与管理员用户一致（若未通过 `-e POSTGRES_DB` 指定，用户名为 `postgres` 或通过 `-e POSTGRES_USER` 自定义）。如需使用旧版模板数据库机制启用 PostGIS，镜像还提供名为 `template_postgis` 的预配置模板库。


## 版本信息（2025-09-26）

支持架构：`amd64`（即 X86-64）  
**新手推荐版本**：`postgis/postgis:17-3.5`、`postgis/postgis:16-3.5`


### Debian 版本（推荐）

- **特点**：发布周期保守，稳定性高（不总是包含 geos、proj、gdal、sfcgal 的最新版本），依赖 Debian 官方仓库的预编译包，易于扩展，成熟度高。
- **依赖版本**：
  - Debian Bullseye（适配 PostgreSQL 12-17）：geos=3.9、gdal=3.2、proj=7.2、sfcgal=1.3.9  
  - Debian Trixie（适配 PostgreSQL 18+）：geos=3.13、gdal=3.10、proj=9.6、sfcgal2=2.0  

| DockerHub 镜像                          | Dockerfile 链接                                                                 | 操作系统          | PostgreSQL 版本 | PostGIS 版本 |
|----------------------------------------|--------------------------------------------------------------------------------|-------------------|----------------|--------------|
| [postgis/postgis:13-3.5]([]) | [Dockerfile]([]) | debian:bullseye   | 13             | 3.5.2        |
| [postgis/postgis:14-3.5]([]) | [Dockerfile]([]) | debian:bullseye   | 14             | 3.5.2        |
| [postgis/postgis:15-3.5]([]) | [Dockerfile]([]) | debian:bullseye   | 15             | 3.5.2        |
| [postgis/postgis:16-3.5]([]) | [Dockerfile]([]) | debian:bullseye   | 16             | 3.5.2        |
| [postgis/postgis:17-3.5]([]) | [Dockerfile]([]) | debian:bullseye   | 17             | 3.5.2        |
| [postgis/postgis:18-3.6]([]) | [Dockerfile]([]) | debian:trixie     | 18             | 3.6.0        |


### Alpine 版本

- **特点**：基于轻量级 Alpine Linux，体积小、安全性高（基于 musl libc），PostGIS 从源码编译，扩展难度略高。
- **依赖版本**（Alpine 3.22）：geos=3.13.1、gdal=3.10.2、proj=9.6.0、sfcgal=2.0.0  

| DockerHub 镜像                                | Dockerfile 链接                                                                         | 操作系统        | PostgreSQL 版本 | PostGIS 版本 |
|----------------------------------------------|----------------------------------------------------------------------------------------|-----------------|----------------|--------------|
| [postgis/postgis:13-3.5-alpine]([]) | [Dockerfile]([]) | alpine:3.22     | 13             | 3.5.3        |
| [postgis/postgis:14-3.5-alpine]([]) | [Dockerfile]([]) | alpine:3.22     | 14             | 3.5.3        |
| [postgis/postgis:15-3.5-alpine]([]) | [Dockerfile]([]) | alpine:3.22     | 15             | 3.5.3        |
| [postgis/postgis:16-3.5-alpine]([]) | [Dockerfile]([]) | alpine:3.22     | 16             | 3.5.3        |
| [postgis/postgis:17-3.5-alpine]([]) | [Dockerfile]([]) | alpine:3.22     | 17             | 3.5.3        |
| [postgis/postgis:17-3.6-alpine]([]) | [Dockerfile]([]) | alpine:3.22     | 17             | 3.6.0        |
| [postgis/postgis:18-3.6-alpine]([]) | [Dockerfile]([]) | alpine:3.22     | 18             | 3.6.0        |


### 测试版本

提供 alpha、beta、rc（发布候选版）及开发版（标记为 ~master），适用于测试新功能。开发版基于 PostgreSQL 16/17，PostGIS 及其依赖从 master 分支编译，模板更新需手动触发（可能延迟数周）。

| DockerHub 镜像                          | Dockerfile 链接                                                                 | 操作系统        | PostgreSQL 版本 | PostGIS 版本                |
|----------------------------------------|--------------------------------------------------------------------------------|-----------------|----------------|-----------------------------|
| [postgis/postgis:16-master]([]) | [Dockerfile]([]) | debian:bullseye | 16             | 开发版（postgis/geos/proj/gdal） |
| [postgis/postgis:17-master]([]) | [Dockerfile]([]) | debian:bullseye | 17             | 开发版（postgis/geos/proj/gdal） |


## 使用方法


### 启动容器

运行基础 PostGIS 数据库容器：  
```bash
docker run --name some-postgis -e POSTGRES_PASSWORD=mysecretpassword -d postgis/postgis
```

更多启动与管理细节，参考 [官方 postgres 镜像文档]([])。


### 连接数据库

#### 直接连接运行中的容器  
```bash
docker exec -ti some-postgis psql -U postgres
```

#### 通过客户端容器连接  
1. 创建自定义网络：  
   ```bash
   docker network create some-network
   ```  
2. 启动服务端容器：  
   ```bash
   docker run --name some-postgis --network some-network -e POSTGRES_PASSWORD=mysecretpassword -d postgis/postgis
   ```  
3. 启动客户端容器连接：  
   ```bash
   docker run -it --rm --network some-network postgis/postgis psql -h some-postgis -U postgres
   ```

关于创建和使用空间数据库的更多选项，参考 [PostGIS 官方文档]([])。


## 支持的环境变量

继承自官方 PostgreSQL 镜像，支持以下环境变量：  
- `POSTGRES_PASSWORD`：数据库密码  
- `POSTGRES_USER`：管理员用户名（默认 `postgres`）  
- `POSTGRES_DB`：默认数据库名（未指定时与用户名一致）  
- `POSTGRES_INITDB_ARGS`：初始化数据库参数  
- `POSTGRES_INITDB_WALDIR`：WAL 目录路径  
- `POSTGRES_HOST_AUTH_METHOD`：主机认证方式  
- `PGDATA`：数据存储路径  

> **注意**：仅当容器首次启动且数据目录为空时，这些变量才生效；若数据目录已存在，启动时将忽略变量配置。  
> 镜像环境变量与 PostgreSQL 客户端库（libpq）的变量（如 `PGDATABASE`、`PGUSER`）不同，需注意区分。  
> 详细说明：[] 故障排查建议

若遇到问题，建议先测试是否可复现于 [官方 PostgreSQL 镜像]([])，再按以下方向排查：  

- **PostgreSQL 相关**：  
  - 上游仓库：[] issues）  
  - Docker 社区论坛：[]  
  - Stack Overflow：[]  

- **PostGIS 相关**：  
  - Stack Overflow（docker + postgis 标签）：[]  
  - PostGIS 问题追踪：[]  

- **新手参考**：  
  Docker 官方 PostgreSQL 使用指南：[]  


## 安全注意事项


### 风险提示

默认配置下，云环境中暴露端口的容器易受攻击（如加密货币挖矿程序入侵）。需注意：  
- 若未指定绑定到本地地址（如 `-p 5432:5432` 而非 `-p 127.0.0.1:5432:5432`），端口将对外暴露，且 Docker 自身 iptables 规则可能覆盖 UFW 配置。  
  详细：[]  


### 安全建议

1. **启用 SSL**：  
   ```bash
   docker run ... -e POSTGRES_INITDB_ARGS="-c ssl=on -c ssl_cert_file=/var/lib/postgresql/server.crt -c ssl_key_file=/var/lib/postgresql/server.key"
   ```  
2. **使用 SSH 隧道**：限制端口绑定为本地地址（`-p 127.0.0.1:5432:5432`）。  


### 安全扫描

- **扫描基础镜像**：安全扫描需同时检查上游 `postgres` 镜像，可参考 Docker 官方 FAQ：[]  
- **仅扫描可修复问题**：  
  ```bash
  trivy image --ignore-unfixed postgis/postgis:16-3.5-alpine  # 扫描 PostGIS 镜像
  trivy image --ignore-unfixed postgres:16-alpine             # 扫描基础 postgres 镜像
  ```  
  详细：[]  


### 更新限制

`postgis/postgis` 镜像每周一自动重建以包含最新依赖更新，但 Debian/Alpine 系统及上游 `postgres` 镜像的更新不受本项目控制，部分问题可能无法立即修复。欢迎提出安全优化建议。


## 已知问题与解决方法

若因 PostGIS 更新导致错误（如 `OperationalError: could not access file "$libdir/postgis-X.X"`），执行以下命令更新：  
```bash
docker exec some-postgis update-postgis.sh
```  
该命令为幂等操作，重复执行无害，输出类似：  
```
Updating PostGIS extensions template_postgis to X.X.X
NOTICE:  version "X.X.X" of extension "postgis" is already installed
...
```


## 贡献指南

本项目是 [PostGIS 官方项目]([]) 的一部分，贡献规则较灵活：  
1. 提交前请先查看现有 issues、讨论及 PR；  
2. 重大变更建议先发起讨论；  
3. 修改模板后需运行 `./update.sh` 脚本。  


## 行为准则

参见：[]

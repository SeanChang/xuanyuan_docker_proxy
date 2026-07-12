---
image: iboates/osm2pgsql
description: "基于官方osm2pgsql仓库构建的最小化Docker镜像，仅包含osm2pgsql及其兼容工具，解决现有镜像版本硬编码、包含额外功能或长期未更新的问题。"
source: https://xuanyuan.cloud/zh/r/iboates/osm2pgsql
canonical: https://xuanyuan.cloud/zh/r/iboates/osm2pgsql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/iboates/osm2pgsql" title="iboates/osm2pgsql Docker 镜像中文简介、标签列表与拉取命令">iboates/osm2pgsql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# osm2pgsql-docker

预构建的最小化Docker镜像，用于运行[osm2pgsql](https://github.com/osm2pgsql-dev/osm2pgsql)。

目前镜像大小尚有优化空间，未来将通过分离运行时依赖与构建依赖进一步减小镜像体积。

## 镜像概述和主要用途

现有Docker Hub上的osm2pgsql镜像普遍存在版本硬编码、包含数据库或其他GIS工具等额外功能、或多年未更新等问题。本镜像基于osm2pgsql官方仓库的构建说明，仅包含osm2pgsql及其兼容的额外工具，旨在提供一套全面、最小化且版本可控的镜像。

## 核心功能和特性

- **最小化设计**：仅包含osm2pgsql核心程序及兼容的额外工具（`osm2pgsql-replication`、`osm2pgsql-gen`、`osm2pgsql-expire`）
- **版本可控**：支持通过标签指定具体版本（对应osm2pgsql官方[发布版本](https://github.com/osm2pgsql-dev/osm2pgsql/releases)）
- **直接URL导入**：支持直接传入PBF文件URL，自动下载、导入后清理文件
- **自定义配置**：可通过环境变量设置PBF文件下载目录，支持自定义样式文件
- **容器协作**：可与PostGIS容器通过Docker Compose集成，简化本地部署流程

## 使用场景和适用范围

适用于需要将OpenStreetMap (OSM) 数据导入PostgreSQL/PostGIS数据库的场景，如GIS应用开发、地图服务部署、空间数据分析等。尤其适合需要轻量级、版本可控的osm2pgsql运行环境的用户。

## 详细使用方法和配置说明

### 快速开始

以下示例拉取最新镜像并运行（无命令时打印帮助文档）。将`latest`替换为具体版本标签可使用指定版本。

```sh
docker run docker.xuanyuan.run/iboates/osm2pgsql:latest
```

也可本地构建镜像：

```shell
docker build \
  --tag custom-osm2pgsql-image \
  --file dockerfiles/2.0.0/Dockerfile \
  scripts
```

> **注意**：对于支持的版本，镜像已内置`osm2pgsql-replication`、`osm2pgsql-gen`等额外工具，使用方法见[使用额外工具](#使用额外工具)。

### 最小化导入

假设本地已运行PostGIS实例（localhost:5432），示例如下：

```sh
# 下载示例PBF文件
wget -O data.pbf https://download.geofabrik.de/europe/andorra-latest.osm.pbf

# 运行导入
docker run -v $(pwd):/data -e PGPASSWORD=<你的密码> --network="host" docker.xuanyuan.run/iboates/osm2pgsql:latest \
 -d o2p \
 -U o2p \
 -H 127.0.0.1 \
 -P 5432 \
 /data/data.pbf
```

> **注意**：访问主机PostGIS实例需指定`--network="host"`以允许容器访问主机端口。更推荐通过Docker Compose与PostGIS容器一同部署（见下文示例）。文件路径需使用容器内挂载路径（示例中当前目录挂载为`/data`，故文件路径为`/data/data.pbf`）。

### 从URL直接导入

镜像支持直接传入PBF文件URL，自动处理下载和导入：

```sh
docker run -v $(pwd):/data -e PGPASSWORD=<你的密码> --network="host" docker.xuanyuan.run/iboates/osm2pgsql:latest \
 -d o2p \
 -U o2p \
 -H 127.0.0.1 \
 -P 5432 \
 https://download.geofabrik.de/europe/andorra-latest.osm.pbf
```

默认下载目录为容器内`/tmp`，可通过环境变量`PBF_DOWNLOAD_DIR`自定义：

```sh
docker run -v $(pwd):/data -e PGPASSWORD=<你的密码> -e PBF_DOWNLOAD_DIR=<自定义路径> --network="host" docker.xuanyuan.run/iboates/osm2pgsql:latest \
 -d o2p \
 -U o2p \
 -H 127.0.0.1 \
 -P 5432 \
 https://download.geofabrik.de/europe/andorra-latest.osm.pbf
```

### 使用样式文件导入

以下示例展示如何使用自定义样式文件导入：

```sh
docker run -v $(pwd):/data -e PGPASSWORD=<你的密码> --network="host" docker.xuanyuan.run/iboates/osm2pgsql:latest \
 -d o2p \
 -U o2p \
 -H 127.0.0.1 \
 -P 5432 \
 -O flex \
 -S /data/style.lua \
 https://download.geofabrik.de/europe/andorra-latest.osm.pbf
```

> 样式文件需挂载到容器内，示例中当前目录挂载为`/data`，故样式文件路径为`/data/style.lua`。关于`-O`参数及样式配置的详细说明，参见osm2pgsql[官方手册](https://osm2pgsql.org/doc/manual.html#output-options)。

### 使用Docker Compose与PostGIS集成

以下示例通过Docker Compose部署osm2pgsql及PostGIS容器：

```yaml
version: '3.8'

services:
  
  postgis:
    image: docker.xuanyuan.run/postgis/postgis:latest
    environment:
      POSTGRES_DB: o2p
      POSTGRES_USER: o2p
      POSTGRES_PASSWORD: o2p
    volumes:
      - postgis_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
        
  osm2pgsql:
    image: docker.xuanyuan.run/iboates/osm2pgsql:latest
    environment:
      PGPASSWORD: o2p

volumes:
  postgis_data:
```

启动服务：

```sh
docker compose up -d
```

执行导入：

```sh
docker compose run osm2pgsql \
 -d o2p \
 -U o2p \
 -H postgis \
 -P 5432 \
 https://download.geofabrik.de/europe/andorra-latest.osm.pbf
```

验证导入结果：

1. 连接数据库：
   ```sh
   export PGPASSWORD=o2p; psql -h 127.0.0.1 -p 5432 -d o2p -U o2p
   ```

2. 执行SQL查询：
   ```sql
   SELECT osm_id FROM planet_osm_point LIMIT 1;
   ```

### 使用额外工具

镜像包含`osm2pgsql`主程序及配套工具：`osm2pgsql-replication`、`osm2pgsql-expire`、`osm2pgsql-gen`。可通过以下命令格式调用：

| **命令**                                                   | **对应原生工具**                   |
|-----------------------------------------------------------|----------------------------------|
| `docker run osm2pgsql:latest <参数>`                       | `osm2pgsql <参数>`               |
| `docker run osm2pgsql:latest osm2pgsql <参数>`             | `osm2pgsql <参数>`               |
| `docker run osm2pgsql:latest replication <参数>`           | `osm2pgsql-replication <参数>`   |
| `docker run osm2pgsql:latest osm2pgsql-replication <参数>` | `osm2pgsql-replication <参数>`   |
| `docker run osm2pgsql:latest gen <参数>`                   | `osm2pgsql-gen <参数>`           |
| `docker run osm2pgsql:latest generalization <参数>`        | `osm2pgsql-gen <参数>`           |
| `docker run osm2pgsql:latest osm2pgsql-gen <参数>`         | `osm2pgsql-gen <参数>`           |
| `docker run osm2pgsql:latest expire <参数>`                | `osm2pgsql-expire <参数>`        |
| `docker run osm2pgsql:latest osm2pgsql-expire <参数>`      | `osm2pgsql-expire <参数>`        |

工具详细说明参见官方文档：
- [osm2pgsql-replication](https://osm2pgsql.org/doc/man/osm2pgsql-replication-1.6.0.html)
- [osm2pgsql-expire](https://osm2pgsql.org/doc/manual.html#expire)
- [osm2pgsql-gen](https://osm2pgsql.org/doc/manual.html#generalization)

##  credits

- 本镜像由Isaac Boates在[2024年2月OSM黑客松](https://wiki.openstreetmap.org/wiki/Karlsruhe_Hack_Weekend_February_2024)开发，感谢osm2pgsql作者及参会者的帮助。
- `osm2pgsql`主要由[Jochen Topf](https://www.jochentopf.com/de/)维护。

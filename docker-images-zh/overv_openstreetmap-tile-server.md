---
image: overv/openstreetmap-tile-server
description: "一个能轻松设置OpenStreetMap PNG瓦片服务器的Docker镜像，基于.osm.pbf文件，使用默认OpenStreetMap样式，简化瓦片服务部署流程，支持数据导入、自动更新及性能调优等功能。"
source: https://xuanyuan.cloud/zh/r/overv/openstreetmap-tile-server
canonical: https://xuanyuan.cloud/zh/r/overv/openstreetmap-tile-server
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/overv/openstreetmap-tile-server" title="overv/openstreetmap-tile-server Docker 镜像中文简介、标签列表与拉取命令">overv/openstreetmap-tile-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/overv/openstreetmap-tile-server" title="overv/openstreetmap-tile-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/overv/openstreetmap-tile-server</a>

# openstreetmap-tile-server

该容器允许你基于.osm.pbf文件轻松设置OpenStreetMap PNG瓦片服务器。它基于[switch2osm.org](https://switch2osm.org/)的[最新Ubuntu 18.04 LTS指南](https://switch2osm.org/serving-tiles/manually-building-a-tile-server-18-04-lts/)构建，因此使用默认的OpenStreetMap样式。

## 服务器设置

首先创建一个Docker卷来存储包含OpenStreetMap数据的PostgreSQL数据库：

    docker volume create osm-data

接下来，从geofabrik.de下载你感兴趣区域的.osm.pbf提取文件。然后通过运行容器并将该文件挂载为`/data/region.osm.pbf`，开始将其导入PostgreSQL。例如：

```
docker run \
    -v /绝对路径/至/luxembourg.osm.pbf:/data/region.osm.pbf \
    -v osm-data:/data/database/ \
    overv/openstreetmap-tile-server \
    import
```

如果容器无错误退出，则数据已成功导入，现在可以运行瓦片服务器了。

注意，导入过程需要互联网连接，而运行过程不需要。如果你想在隔离的计算机上运行openstreetmap-tile服务器，必须先在联网计算机上导入，将`osm-data`卷导出为tar文件，然后在目标计算机系统上恢复数据卷。

此外，在隔离系统上运行时，容器的默认`index.html`将无法正常工作，因为它需要访问网络获取leaflet包。

### 自动更新（可选）

如果你的导入文件是星球数据的提取版本，并且关联了多边形边界（如[geofabrik.de](https://download.geofabrik.de/)提供的文件），则可以将服务器设置为自动更新。确保在`import`过程中同时引用OSM文件和多边形文件，并包含`UPDATES=enabled`变量：

```
docker run \
    -e UPDATES=enabled \
    -v /绝对路径/至/luxembourg.osm.pbf:/data/region.osm.pbf \
    -v /绝对路径/至/luxembourg.poly:/data/region.poly \
    -v osm-data:/data/database/ \
    overv/openstreetmap-tile-server \
    import
```

有关在运行瓦片服务器时实际启用更新的方法，请参考“自动更新和瓦片过期”部分。

请注意：如果你未导入整个星球数据，则`.poly`文件是必要的，用于将自动更新限制到相关区域。因此，当你只有`.osm.pbf`文件而没有`.poly`文件时，不应启用自动更新。

### 让容器自动下载文件

你也可以通过`DOWNLOAD_PBF`和`DOWNLOAD_POLY`参数让容器自动下载文件，而无需提前挂载：

```
docker run \
    -e DOWNLOAD_PBF=https://download.geofabrik.de/europe/luxembourg-latest.osm.pbf \
    -e DOWNLOAD_POLY=https://download.geofabrik.de/europe/luxembourg.poly \
    -v osm-data:/data/database/ \
    overv/openstreetmap-tile-server \
    import
```

### 使用替代样式

默认情况下，如果未指定，容器将使用openstreetmap-carto样式。但你可以在运行时修改样式。注意，由于需要运行Lua脚本，你需要在`run`和`import`时都挂载样式：

```
docker run \
    -e DOWNLOAD_PBF=https://download.geofabrik.de/europe/luxembourg-latest.osm.pbf \
    -e DOWNLOAD_POLY=https://download.geofabrik.de/europe/luxembourg.poly \
    -e NAME_LUA=sample.lua \
    -e NAME_STYLE=test.style \
    -e NAME_MML=project.mml \
    -e NAME_SQL=test.sql \
    -v /home/user/openstreetmap-carto-modified:/data/style/ \
    -v osm-data:/data/database/ \
    overv/openstreetmap-tile-server \
    import
```

如果你未定义“NAME_*”变量，脚本将默认使用openstreetmap-carto样式中的文件。

确保在`run`时使用相同的`-v /home/user/openstreetmap-carto-modified:/data/style/`挂载卷。

如果在`run`时未看到预期样式，请检查路径，因为样式可能未在指定目录中找到。默认情况下，如果找不到样式，将使用openstreetmap-carto。

**仅支持openstreetmap-carto及类似样式（例如，包含一个lua脚本、一个style文件、一个mml文件和一个SQL文件的样式）**

## 运行服务器

这样运行服务器：

```
docker run \
    -p 8080:80 \
    -v osm-data:/data/database/ \
    -d overv/openstreetmap-tile-server \
    run
```

瓦片现在可通过`http://localhost:8080/tile/{z}/{x}/{y}.png`访问。`leaflet-demo.html`中的演示地图可通过`http://localhost:8080`访问。注意，首次渲染较大瓦片最初需要相当长的时间。

### 使用Docker Compose

此仓库包含的`docker-compose.yml`文件展示了如何使用Docker Compose运行服务器。

### 保留渲染瓦片

已渲染的瓦片将存储在`/data/tiles/`中。为确保此数据在容器重启后保留，你应创建另一个卷：

```
docker volume create osm-tiles
docker run \
    -p 8080:80 \
    -v osm-data:/data/database/ \
    -v osm-tiles:/data/tiles/ \
    -d overv/openstreetmap-tile-server \
    run
```

**如果你这样做，请确保在导入时也运行`osm-tiles`卷，以确保跨更新的缓存正常工作！**

### 启用自动更新（可选）

如果在服务器设置期间已按照“自动更新”部分设置导入，则可以通过在运行服务器时设置`UPDATES`变量来启用更新过程：

```
docker run \
    -p 8080:80 \
    -e REPLICATION_URL=https://planet.openstreetmap.org/replication/minute/ \
    -e MAX_INTERVAL_SECONDS=60 \
    -e UPDATES=enabled \
    -v osm-data:/data/database/ \
    -v osm-tiles:/data/tiles/ \
    -d overv/openstreetmap-tile-server \
    run
```

这将启用一个后台进程，自动从OpenStreetMap服务器下载更改，根据你指定的区域多边形过滤，更新数据库，并最终标记受影响的瓦片以重新渲染。

### 瓦片过期（可选）

指定自定义瓦片过期设置，以控制更新时哪些缩放级别的瓦片被标记为过期。瓦片可以在缓存中标记为过期（TOUCHFROM），但在新瓦片渲染完成前仍会提供服务；或从缓存中删除（DELETEFROM），因此在新瓦片渲染完成前不会提供服务。

以下示例瓦片过期值为默认值：

```
docker run \
    -p 8080:80 \
    -e REPLICATION_URL=https://planet.openstreetmap.org/replication/minute/ \
    -e MAX_INTERVAL_SECONDS=60 \
    -e UPDATES=enabled \
    -e EXPIRY_MINZOOM=13 \
    -e EXPIRY_TOUCHFROM=13 \
    -e EXPIRY_DELETEFROM=19 \
    -e EXPIRY_MAXZOOM=20 \
    -v osm-data:/data/database/ \
    -v osm-tiles:/data/tiles/ \
    -d overv/openstreetmap-tile-server \
    run
```

### 跨域资源共享

要启用`Access-Control-Allow-Origin`头以允许从其他域检索瓦片，只需将`ALLOW_CORS`变量设置为`enabled`：

```
docker run \
    -p 8080:80 \
    -v osm-data:/data/database/ \
    -e ALLOW_CORS=enabled \
    -d overv/openstreetmap-tile-server \
    run
```

### 连接到Postgres

要连接容器内的PostgreSQL数据库，请确保暴露5432端口：

```
docker run \
    -p 8080:80 \
    -p 5432:5432 \
    -v osm-data:/data/database/ \
    -d overv/openstreetmap-tile-server \
    run
```

使用用户`renderer`和数据库`gis`进行连接：

```
psql -h localhost -U renderer gis
```

默认密码为`renderer`，但可通过`PGPASSWORD`环境变量更改：

```
docker run \
    -p 8080:80 \
    -p 5432:5432 \
    -e PGPASSWORD=secret \
    -v osm-data:/data/database/ \
    -d overv/openstreetmap-tile-server \
    run
```

##性能调优和调整

有关更新过程和调用脚本的详细信息，请参见[链接](https://ircama.github.io/osm-carto-tutorials/updating-data/)。

### 线程（THREADS）

导入和瓦片服务进程默认使用4个线程，但可通过`THREADS`环境变量更改。例如：
```
docker run \
    -p 8080:80 \
    -e THREADS=24 \
    -v osm-data:/data/database/ \
    -d overv/openstreetmap-tile-server \
    run
```

### 缓存（CACHE）

导入和瓦片服务进程默认使用800 MB RAM缓存，但可通过`-C`选项更改。例如：
```
docker run \
    -p 8080:80 \
    -e "OSM2PGSQL_EXTRA_ARGS=-C 4096" \
    -v osm-data:/data/database/ \
    -d overv/openstreetmap-tile-server \
    run
```

### 自动清理（AUTOVACUUM）

数据库默认使用自动清理功能。可通过`AUTOVACUUM`环境变量更改此行为。例如：
```
docker run \
    -p 8080:80 \
    -e AUTOVACUUM=off \
    -v osm-data:/data/database/ \
    -d overv/openstreetmap-tile-server \
    run
```

### 平面节点（FLAT_NODES）

如果你计划导入整个星球数据或遇到内存错误，可能需要为osm2pgsql启用`--flat-nodes`选项。可在导入过程中如下使用：

```
docker run \
    -v /绝对路径/至/luxembourg.osm.pbf:/data/region.osm.pbf \
    -v osm-data:/data/database/ \
    -e "FLAT_NODES=enabled" \
    overv/openstreetmap-tile-server \
    import
```

警告：将`FLAT_NODES`与`UPDATES`一起启用仅适用于整个星球数据导入（无.poly文件）。否则会破坏自动更新脚本，因为使用平面节点时目前不支持将差异更新修剪到特定区域。

### 基准测试

你可以在[OpenStreetMap wiki](https://wiki.openstreetmap.org/wiki/Osm2pgsql/benchmarks#debian_9_.2F_openstreetmap-tile-server)上找到该镜像导入性能的示例。

## 故障排除

### ERROR: 无法调整共享内存段 / 设备上没有空间

如果日志中出现此类条目，说明容器的默认共享内存限制（64 MB）过低，应提高：
```
renderd[121]: ERROR: failed to render TILE default 2 0-3 0-3
renderd[121]: reason: Postgis Plugin: ERROR: could not resize shared memory segment "/PostgreSQL.790133961" to 12615680 bytes: ### No space left on device
```
要提高限制，请使用`--shm-size`参数。例如：
```
docker run \
    -p 8080:80 \
    -v osm-data:/data/database/ \
    --shm-size="192m" \
    -d overv/openstreetmap-tile-server \
    run
```
值过高可能会导致CPU负载和内存使用过高。你可能需要通过实验找到最佳值。

### 导入过程意外退出

你可能在导入期间遇到内存使用问题。请查看本README中的“平面节点”部分。

## 许可证

```
Copyright 2019 Alexander Overvoorde

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

---
image: geonode/geoserver
description: "用于GeoNode的GeoServer镜像，提供地理空间数据发布与管理服务，支持在GeoNode环境中集成地图服务功能。"
source: https://xuanyuan.cloud/zh/r/geonode/geoserver
canonical: https://xuanyuan.cloud/zh/r/geonode/geoserver
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/geonode/geoserver" title="geonode/geoserver Docker 镜像中文简介、标签列表与拉取命令">geonode/geoserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/geonode/geoserver" title="geonode/geoserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/geonode/geoserver</a>

# geoserver-docker

## 镜像概述和主要用途

[GeoServer](http://geoserver.org) 是一款开源的地理空间数据服务器，用于共享地理空间数据。本镜像是为 [GeoNode](https://github.com/GeoNode/geoserver-geonode-ext) 专门构建的 Docker 镜像，简化了 GeoServer 的部署流程，包含独立的数据目录，基于官方 Tomcat 9 镜像构建。


## 核心功能和特性

- **GeoNode 集成**：针对 GeoNode 优化，支持其地理空间数据共享需求
- **独立数据目录**：数据存储路径 `/geoserver_data/data` 作为卷暴露，便于配置持久化
- **多版本支持**：提供不同标签版本，适配 GeoNode 的 Cookie-based 和 OAuth2 两种认证机制
- **基于 Tomcat 9**：采用官方 Tomcat 9 镜像作为基础，确保运行稳定性
- **数据持久化**：支持数据卷挂载，容器重启或升级时保留配置和数据
- **数据库集成**：可与 PostGIS 等空间数据库链接，扩展数据存储能力


## 使用场景和适用范围

- 需与 GeoNode 集成的地理空间数据服务部署
- 快速搭建开发、测试或生产环境中的 GeoServer 服务
- 需要灵活配置数据存储和认证机制的地理信息系统项目
- 对数据持久化和版本控制有要求的地理空间应用


## 使用方法

### 安装

#### 从 Docker Hub 拉取镜像（推荐）
本镜像已发布至 Docker Hub 可信构建，直接拉取即可：
```bash
docker pull geonode/geoserver
```

#### 本地构建镜像
如需自定义构建，可通过源码构建：
```bash
git clone https://github.com/GeoNode/geoserver-docker.git
cd geoserver-docker
docker build -t "geonode/geoserver" .
```


### 快速启动

#### 准备数据目录
1. 从 [https://build.geo-solutions.it/geonode/geoserver/latest/](https://build.geo-solutions.it/geonode/geoserver/latest/) 下载最新的 `data-2.xx.x.zip` 数据文件（如 `data-2.18.2.zip`）
2. 在主机创建数据目录并解压数据：
   ```bash
   sudo mkdir -p /opt/geoserver/
   sudo unzip ~/Download/data-2.18.2.zip -d /opt/geoserver/
   ```

#### 启动容器
```bash
docker run --name "geoserver" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /opt/geoserver/data/:/geoserver_data/data \
  -d -p 8080:8080 \
  geonode/geoserver
```

#### 访问服务
- 在浏览器中访问 `http://localhost:8080/geoserver`
- 使用默认凭据登录：
  - 用户名：`admin`
  - 密码：`geoserver`


### 不同版本使用

本镜像提供多个标签版本，适配 GeoNode 的不同认证机制：

#### Cookie-based 认证版本
- `geonode/geoserver:2.9.x`

#### OAuth2 认证版本
- `geonode/geoserver:2.9.x-oauth2`
- `geonode/geoserver:2.10.x`
- `geonode/geoserver:2.12.x`
- `geonode/geoserver:2.13.x`
- `geonode/geoserver:2.14.x`
- `geonode/geoserver:2.18.2`

> **注意**：使用时需确保 GeoServer 镜像标签与数据目录版本一一对应。


## 配置说明

### 数据卷

容器的数据目录 `/geoserver_data/data` 已作为卷暴露，用于持久化 GeoServer 配置和数据。建议将其挂载到主机目录，便于数据管理和升级：

```bash
-v /your/host/data/path:/geoserver_data/data  # 将主机目录映射到容器数据卷
```


### 数据卷容器

在使用 Docker Compose 部署时，可通过数据卷容器预加载 GeoNode 专用的 `GEOSERVER_DATA_DIR`。需先确保 `geonode/geoserver_data` 镜像可用（从 Docker Hub 拉取或本地构建）：

#### 构建数据卷容器
```bash
git clone https://github.com/GeoNode/data-docker.git
cd data-docker
docker build -t geonode/geoserver_data .
```


### 持久化行为

#### 保留数据（停止容器）
```bash
docker-compose stop  # 停止容器，数据保留在 GEOSERVER_DATA_DIR 中
docker-compose up    # 重启后可继续使用原数据
```

#### 清除数据（删除容器）
```bash
docker-compose down  # 删除容器，数据将丢失，需重新加载基础数据目录
```


### 数据目录版本对应关系

GeoServer 镜像标签与数据目录版本需严格对应，以下为可用组合：

| GeoServer 镜像标签       | 数据目录镜像版本                |
|-------------------------|--------------------------------|
| `2.9.x`                 | `geonode/geoserver_data:2.9.x` |
| `2.9.x-oauth2`          | `geonode/geoserver_data:2.9.x-oauth2` |
| `2.10.x`                | `geonode/geoserver_data:2.10.x` |
| `2.12.x`                | `geonode/geoserver_data:2.12.x` |
| `2.13.x`                | `geonode/geoserver_data:2.13.x` |
| `2.14.x`                | `geonode/geoserver_data:2.14.x` |
| `2.18.2`                | `geonode/geoserver_data:2.18.2` |


### 数据库集成

GeoServer 推荐使用空间数据库存储数据，以下为与 PostGIS 容器集成示例：

#### 启动 PostGIS 容器
```bash
docker run -d --name="postgis" kartoza/postgis  # 使用 kartoza/postgis 镜像
```

#### 链接 GeoServer 与 PostGIS
启动 GeoServer 容器时添加 `--link` 参数：
```bash
docker run --name "geoserver" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /opt/geoserver/data/:/geoserver_data/data \
  --link postgis:postgis  # 链接 PostGIS 容器，别名 postgis
  -d -p 8080:8080 \
  geonode/geoserver
```


### Docker Compose 部署示例

创建 `docker-compose.yml` 文件：
```yaml
version: '3'
services:
  geoserver:
    image: geonode/geoserver:2.18.2
    ports:
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - geoserver_data:/geoserver_data/data
    depends_on:
      - postgis
    links:
      - postgis:postgis

  postgis:
    image: kartoza/postgis
    environment:
      - POSTGRES_USER=geonode
      - POSTGRES_PASSWORD=geonode
      - POSTGRES_DB=geonode

volumes:
  geoserver_data:
    driver: local
    driver_opts:
      type: none
      device: /opt/geoserver/data  # 主机数据目录
      o: bind
```

启动服务：
```bash
docker-compose up -d

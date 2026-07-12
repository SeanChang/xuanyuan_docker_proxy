---
image: maptiler/tileserver-gl
description: "MapTiler TileServer GL是用于生成、托管和提供地图瓦片服务的工具，支持多种地图数据格式，可为Web及移动应用高效提供标准地图瓦片服务。"
source: https://xuanyuan.cloud/zh/r/maptiler/tileserver-gl
canonical: https://xuanyuan.cloud/zh/r/maptiler/tileserver-gl
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/maptiler/tileserver-gl" title="maptiler/tileserver-gl Docker 镜像中文简介、标签列表与拉取命令">maptiler/tileserver-gl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TileServer GL

![tileserver-gl](https://cloud.githubusercontent.com/assets/59284/18173467/fa3aa2ca-7069-11e6-86b1-0f1266befeb6.jpeg)

[![Build Status](https://travis-ci.org/maptiler/tileserver-gl.svg?branch=master)](https://travis-ci.org/maptiler/tileserver-gl)
[![Docker Hub](https://img.shields.io/badge/docker-hub-blue.svg)](https://hub.docker.com/r/maptiler/tileserver-gl/)


## 镜像概述和主要用途

TileServer GL 是一个支持矢量与栅格地图瓦片的服务器应用，基于 Mapbox GL Native 实现服务器端渲染，支持 GL 样式定义。其核心用途是为各类客户端提供地图瓦片服务，包括 Web 地图应用（如 Mapbox GL JS、Leaflet、OpenLayers）、移动应用（Android、iOS）及 GIS 系统（通过 WMTS 等协议访问）。


## 核心功能和特性

- **多类型地图支持**：同时支持矢量地图瓦片和栅格地图瓦片，满足不同场景需求。
- **GL 样式渲染**：支持 Mapbox GL 样式规范，可自定义地图视觉呈现效果。
- **服务器端栅格化**：基于 Mapbox GL Native 实现矢量瓦片的服务器端栅格化，降低客户端渲染压力。
- **MBTiles 兼容**：支持读取 MBTiles 格式的矢量瓦片数据，简化数据管理与部署。
- **多客户端适配**：兼容 Mapbox GL JS、Leaflet、OpenLayers、Android、iOS 地图 SDK 及 GIS 系统（通过 WMTS 等标准协议）。
- **轻量级版本可选**：提供 `tileserver-gl-light` 纯 JavaScript 版本，无原生依赖，可在更多环境运行，但不包含服务器端栅格化功能。


## 使用场景和适用范围

- **Web 地图应用**：为网页端地图应用（如基于 Mapbox GL JS 或 Leaflet 开发的应用）提供地图瓦片服务。
- **移动应用开发**：支持 Android、iOS 等移动平台地图 SDK 的瓦片数据接入。
- **GIS 系统集成**：通过 WMTS 等标准协议为 GIS 系统（如 QGIS）提供地图数据。
- **轻量化部署**：在资源受限环境下，可使用 `tileserver-gl-light` 版本实现基础矢量瓦片服务。


## 详细的使用方法和配置说明

### 环境准备

- **Docker 环境**：需提前安装 [Docker](https://www.docker.com/) 或 [Docker Kitematic](https://kitematic.com/)（图形化工具）。
- **MBTiles 数据**：需准备 MBTiles 格式的矢量瓦片文件（可从 [OpenMapTiles](https://openmaptiles.org/downloads/) 获取示例数据）。


### Docker 部署方法

#### 基础命令行部署

在存放 MBTiles 文件的目录下，执行以下命令启动容器：

```bash
docker run --rm -it -v $(pwd):/data -p 8080:80 docker.xuanyuan.run/maptiler/tileserver-gl
```

**参数说明**：
- `--rm`：容器停止后自动删除，避免残留。
- `-it`：以交互模式运行，支持终端输出。
- `-v $(pwd):/data`：将当前目录（存放 MBTiles 文件）挂载到容器内 `/data` 目录，容器会自动识别该目录下的 MBTiles 文件。
- `-p 8080:80`：将容器内 80 端口映射到主机 8080 端口，通过 `localhost:8080` 访问服务。

服务启动后，可通过浏览器访问 `http://localhost:8080` 查看地图服务界面及示例。


#### Docker Kitematic 图形化部署

1. 安装并启动 [Docker Kitematic](https://kitematic.com/)。
2. 在搜索框输入 `tileserver-gl`，选择官方镜像并点击“Create”。
3. 进入容器管理界面，通过“Volumes”选项卡将本地存放 MBTiles 文件的目录挂载到容器 `/data` 目录。
4. 启动容器后，通过界面显示的 URL（通常为 `http://localhost:8080`）访问服务。


### npm 安装部署（补充说明）

除 Docker 外，也可通过 npm 直接安装：

1. 确保 Node.js 10 环境（执行 `node -v` 验证版本为 `v10.x.x`）。
2. 全局安装：
   ```bash
   npm install -g tileserver-gl
   ```
3. 启动服务（指定 MBTiles 文件路径）：
   ```bash
   tileserver-gl /path/to/your/file.mbtiles
   ```

> 注：npm 方式需处理原生依赖，推荐优先使用 Docker 部署以简化环境配置。


## 配置参数与环境变量

TileServer GL 默认读取 `/data` 目录下的 MBTiles 文件及配置文件（如 `config.json`）。常用配置项可通过自定义 `config.json` 调整（如瓦片缓存策略、样式定义等），详细配置说明可参考 [官方文档](https://tileserver.readthedocs.io/)。

**默认配置说明**：
- 数据目录：容器内 `/data`（需通过 `-v` 挂载本地目录）。
- 服务端口：容器内默认 80 端口（可通过 `-p` 映射到主机其他端口）。
- 配置文件：默认加载 `/data/config.json`（如不存在，自动基于 MBTiles 文件生成默认配置）。


## 参考文档

完整文档请访问：[https://tileserver.readthedocs.io/](https://tileserver.readthedocs.io/)

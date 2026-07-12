---
image: opentripplanner/opentripplanner
description: "OpenTripPlanner (OTP) Docker镜像是开源多模式出行规划引擎的容器化部署方案，支持公共交通、步行、自行车等多种出行方式规划，提供便捷的容器化部署方式，帮助快速搭建出行规划服务。"
source: https://xuanyuan.cloud/zh/r/opentripplanner/opentripplanner
canonical: https://xuanyuan.cloud/zh/r/opentripplanner/opentripplanner
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opentripplanner/opentripplanner" title="opentripplanner/opentripplanner Docker 镜像中文简介、标签列表与拉取命令">opentripplanner/opentripplanner 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenTripPlanner Docker镜像文档

## 概述
OpenTripPlanner (OTP) 是一款开源的多模式出行规划引擎，能够为用户提供整合公共交通、步行、自行车及驾车等多种出行方式的路径规划服务。本Docker镜像将OTP引擎容器化，简化部署流程，降低环境配置复杂度，使用户能够快速搭建功能完善的出行规划服务。

## 核心功能与特性
- **多模式出行规划**：支持公共交通（含公交、地铁等）、步行、自行车、驾车及组合出行方式的路径计算。
- **GTFS数据支持**：兼容通用公交信息规范（GTFS）数据，可加载并解析公交时刻表、线路、站点等静态数据。
- **实时数据集成**：支持GTFS-realtime数据接入，提供实时公交位置、延误等动态信息查询。
- **REST API接口**：提供标准化RESTful API，支持路径规划、站点查询、线路信息获取等功能调用。
- **可配置性**：支持通过参数自定义规划偏好（如步行速度、换乘惩罚等）及服务端口、日志级别等运行参数。
- **容器化优势**：隔离运行环境，简化依赖管理，支持快速扩缩容及跨平台部署。

## 使用场景
- **城市交通管理部门**：快速部署城市级出行规划服务，辅助市民出行决策。
- **出行服务应用开发者**：集成OTP API到移动应用或网站，为用户提供出行规划功能。
- **研究机构**：基于标准化容器环境开展交通行为分析、规划算法优化等研究。
- **企业内部服务**：为员工提供园区或城市范围内的通勤规划工具。

## 使用方法

### 前提条件
- 已安装Docker Engine（20.10+版本推荐）
- 已准备GTFS数据文件（可选：GTFS-realtime数据文件）

### 获取镜像
从Docker Hub拉取最新版本镜像：
```bash
docker pull docker.xuanyuan.run/opentripplanner/opentripplanner:latest
```

### 基本部署命令
#### 1. 基础模式（加载GTFS数据并启动服务）
```bash
docker run -d \
  --name otp-service \
  -p 8080:8080 \
  -v /path/to/local/gtfs:/var/otp/graphs \
  docker.xuanyuan.run/opentripplanner/opentripplanner:latest \
  --build /var/otp/graphs --serve
```
- `-v /path/to/local/gtfs:/var/otp/graphs`：挂载本地GTFS数据目录到容器内，用于构建出行规划图
- `--build`：指定数据目录并构建规划图（首次运行需执行，后续可省略）
- `--serve`：启动OTP服务，默认监听8080端口

#### 2. 集成实时数据
```bash
docker run -d \
  --name otp-realtime \
  -p 8080:8080 \
  -v /path/to/gtfs:/var/otp/graphs \
  -v /path/to/gtfs-rt:/var/otp/rt \
  docker.xuanyuan.run/opentripplanner/opentripplanner:latest \
  --build /var/otp/graphs --serve --rt /var/otp/rt
```
- `--rt /var/otp/rt`：指定GTFS-realtime数据目录，启用实时数据支持

### 配置参数说明
启动命令支持以下核心参数（完整列表见[官方文档](https://docs.opentripplanner.org/en/dev-2.x/Container-Image/)）：
- `--build <dir>`：从指定目录加载数据并构建规划图
- `--serve`：启动HTTP服务
- `--port <port>`：指定服务端口（默认8080）
- `--rt <dir>`：指定GTFS-realtime数据目录
- `--inMemory`：内存模式运行，不持久化规划图（适用于开发环境）

### 环境变量配置
通过`-e`参数设置环境变量，自定义运行时行为：
- `OTP_JAVA_OPTS`：JVM参数，如`-Xmx4G`（默认`-Xmx2G`）
- `OTP_LOG_LEVEL`：日志级别，可选`DEBUG`/`INFO`/`WARN`/`ERROR`（默认`INFO`）
- `OTP_GRAPH_CACHE`：是否启用规划图缓存（`true`/`false`，默认`true`）

### Docker Compose示例
创建`docker-compose.yml`文件，定义服务配置：
```yaml
version: '3.8'
services:
  otp:
    image: docker.xuanyuan.run/opentripplanner/opentripplanner:latest
    container_name: otp-service
    ports:
      - "8080:8080"
    volumes:
      - ./gtfs-data:/var/otp/graphs  # 本地GTFS数据目录
      - ./rt-data:/var/otp/rt        # 本地GTFS-realtime数据目录（可选）
    environment:
      - OTP_JAVA_OPTS=-Xmx8G         # 根据数据规模调整内存
      - OTP_LOG_LEVEL=INFO
    command: --build /var/otp/graphs --serve --rt /var/otp/rt
    restart: unless-stopped
```
启动服务：
```bash
docker-compose up -d
```

## 验证服务
服务启动后，通过以下方式验证：
- 访问API端点：`http://localhost:8080/otp/routers/default/index`（检查规划图构建状态）
- 调用路径规划API：`http://localhost:8080/otp/routers/default/plan?fromPlace=纬度,经度&toPlace=纬度,经度&mode=TRANSIT,WALK`

## 注意事项
- GTFS数据需符合规范，建议使用[GTFS Validator](https://gtfsvalidator.mobilitydata.org/)预处理
- 服务性能与数据规模相关，建议根据GTFS数据大小调整JVM内存参数（`OTP_JAVA_OPTS`）
- 生产环境建议挂载持久化卷存储规划图，避免重复构建

详细配置及高级功能请参考[官方文档](https://docs.opentripplanner.org/en/dev-2.x/Container-Image/)。

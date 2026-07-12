---
image: vroomvrp/vroom-docker
description: "VROOM Docker镜像包含运行vroom-express和vroom所需的所有依赖，可在2分钟内快速部署路由优化引擎，支持OSRM、Valhalla或OpenRouteService作为路由层。"
source: https://xuanyuan.cloud/zh/r/vroomvrp/vroom-docker
canonical: https://xuanyuan.cloud/zh/r/vroomvrp/vroom-docker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vroomvrp/vroom-docker" title="vroomvrp/vroom-docker Docker 镜像中文简介、标签列表与拉取命令">vroomvrp/vroom-docker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# VROOM Docker镜像

## 镜像概述和主要用途

该镜像包含运行[vroom-express](https://github.com/VROOM-Project/vroom-express)（基于[vroom](https://github.com/VROOM-Project/vroom)）所需的所有依赖和项目。通过该镜像，可在2分钟内在本地部署一个功能完善的路由优化引擎。

## 核心功能和特性

- 集成vroom和vroom-express的完整依赖环境
- 支持三种路由引擎：OSRM、Valhalla和OpenRouteService（ORS）
- 提供灵活的配置方式，支持环境变量和配置文件自定义
- 可通过卷挂载实现配置文件和日志的持久化存储
- 提供docker-compose配置，便于快速搭建完整服务栈

## 使用场景和适用范围

适用于需要路径优化的各类场景，包括但不限于：
- 物流配送路线规划
- 车辆路径优化
- 多站点配送调度
- 基于地理位置的资源分配

## 使用方法和配置说明

### 快速启动

使用以下命令快速启动VROOM容器：

```bash
docker run -dt --name vroom \
    --net host \  # 或在config.yml中将主机设为容器名称，使用--port 3000:3000替代（见下文）
    -v $PWD/conf:/conf \ # 映射配置和日志的卷
    -e VROOM_ROUTER=osrm \ # 路由层：osrm、valhalla或ors
    vroomvrp/vroom-docker:v1.10.0
```

### 构建镜像

如需自行构建镜像，执行以下命令：

```bash
docker build -t vroomvrp/vroom-docker:v1.10.0 --build-arg VROOM_RELEASE=v1.10.0 --build-arg VROOM_EXPRESS_RELEASE=v0.9.0 .
```

> **注意**：需要访问自托管的OSRM、Valhalla或OpenRouteService路由服务器实例，可参考[`docker-compose.yml`](docker-compose.yml)示例。

## 标签说明

镜像标签遵循vroom核心项目的发布约定。

## 自定义配置

### 环境变量

- `VROOM_ROUTER`：指定使用的路由引擎，可选值为`osrm`、`valhalla`或`ors`，默认值为`osrm`。

路由服务器的预配置主机为`localhost`，端口分别为：ORS使用8080，OSRM使用5000，Valhalla使用8002。

> **注意**：环境变量`VROOM_ROUTER`的优先级高于`config.yml`中的`router`设置。

### 卷挂载

容器内所有相关文件位于`/conf`目录，可通过卷挂载与主机共享，包括：

- `access.log`：vroom-express的服务器日志
- `config.yml`：服务器配置文件，可完全控制vroom-express的配置。修改配置后需执行`docker restart vroom`重启服务使设置生效。

在`docker run`命令中添加`-v $PWD/vroom-conf:/conf`实现卷挂载。

### 构建参数

如需从源码构建镜像，有两个构建参数可用：

- `VROOM_RELEASE`：指定容器中安装的VROOM的git分支、提交哈希或发布版本（如`v1.10.0`）
- `VROOM_EXPRESS_RELEASE`：指定容器中安装的vroom-express的git分支、提交哈希或发布版本（如`v0.9.0`）

> **注意**：并非所有版本之间都兼容。

## docker-compose使用

项目中包含[`docker-compose.yml`](docker-compose.yml)配置文件，便于快速启动服务：

```bash
docker-compose up -d
```

该命令将拉取最新的`vroom-docker`镜像和最新的`openrouteservice`镜像。

## 路由服务器设置

可选择使用[OSRM](https://github.com/Project-OSRM/osrm-backend)、[Valhalla](https://github.com/valhalla/valhalla)或[OpenRouteService](https://github.com/GIScience/openrouteservice)作为路由服务器。Docker或docker-compose中的具体设置取决于路由服务器的运行方式。

### 本地Docker容器中的路由服务器

如果通过`docker run`在单独的Docker容器中启动路由层，需将vroom容器加入`host`网络，添加`--net host`参数。缺点是需要在主机上分配vroom-express配置的端口。若主机3000端口已被占用，可在`config.yml`中配置其他端口。

或者，可将两个容器加入私有Docker网络，并在`config.yml`中将路由服务器主机修改为路由服务器容器名称，然后重启vroom容器。相关概念超出本项目范围。

### 使用docker-compose启动整个服务栈

确保在vroom服务部分包含`network_mode: host`，效果等同于在`docker run`中添加`--net host`参数。

另一种方案是创建私有Docker网络，服务仅发布运行所需的端口。需在`config.yml`中将主机修改为docker-compose.yml中定义的服务名称。

### 远程服务器上的路由服务器

这种情况下，需编辑映射的`config.yml`，添加路由服务器发布的主机和端口。

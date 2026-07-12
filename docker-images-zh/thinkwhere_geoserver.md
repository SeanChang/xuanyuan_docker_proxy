---
image: thinkwhere/geoserver
description: "GeoServer地理信息服务器Docker镜像，用于发布地图数据和提供空间服务，支持多种地理信息标准，实现便捷部署与地理空间服务快速搭建。"
source: https://xuanyuan.cloud/zh/r/thinkwhere/geoserver
canonical: https://xuanyuan.cloud/zh/r/thinkwhere/geoserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/thinkwhere/geoserver" title="thinkwhere/geoserver Docker 镜像中文简介、标签列表与拉取命令">thinkwhere/geoserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GeoServer Docker 镜像文档


## 一、镜像概述

GeoServer 是一款开源地理空间数据服务器，支持通过开放标准发布来自多种空间数据源的数据。本 Docker 镜像基于 GeoServer 构建，集成了常用插件与字体，旨在简化部署流程，帮助用户快速搭建地理空间数据服务。


## 二、核心功能与特性

### 2.1 基础镜像
所有镜像均基于官方 Tomcat 镜像构建，不同版本对应如下：
- **v2.15+**：基于 `tomcat:9.0-JRE11-slim`（Tomcat 9，Java 11）
- **< v2.15**：基于 `tomcat:8.5`（Tomcat 8.5，Java 8）


### 2.2 内置 GeoServer 插件
镜像包含以下插件，不同版本支持情况如下：
- **所有版本**：Inspire、Monitor、Control-Flow 插件
- **v2.12.1+ 与 v2.11.3+**：新增 css、ysld 插件
- **v2.16.0+**：新增 sldservice 插件
- **v2.17.0+**：新增 web-resource browser 插件


### 2.3 捆绑字体
镜像内置多种字体以支持地图渲染，包括：
- **基础字体**（所有版本）：DejaVu Sans、DejaVu Serif、Dialog、DialogInput、Monospaced
- **新增字体**（按版本）：
  - **2.10.4、2.11.1+**：UN OCHA 人道主义救援地图字体（http://reliefweb.int/report/world/world-humanitarian-and-country-icons-2012）
  - **2.11.5、2.12.3+、2.13.0+**：Google Roboto 字体（https://github.com/google/roboto/）
  - **2.16.5、2.17.4+、2.18.2+**：Red Hat Liberation Sans 字体（https://www.dafont.com/liberation-sans.font）


## 三、使用场景

本镜像适用于以下场景：
- **地理空间数据发布**：通过开放标准（如WMS、WFS）发布 shp、PostGIS、GeoTIFF 等多源空间数据
- **地图服务部署**：快速搭建地图瓦片服务、矢量数据服务，支持自定义样式（CSS/YSLD）
- **多源数据集成**：整合不同格式的空间数据，提供统一数据访问接口
- **开发与测试环境**：简化 GeoServer 功能验证、插件兼容性测试的部署流程


## 四、安装与使用

### 4.1 获取镜像

#### 直接拉取镜像
从 Docker Hub 拉取官方镜像：
```bash
docker pull docker.xuanyuan.run/thinkwhere/geoserver
```

#### 构建自定义镜像
若需自定义配置，可克隆源码仓库后构建：
```bash
git clone https://github.com/thinkwhere/GeoServer-docker.git
cd GeoServer-docker
# 根据需求修改 Dockerfile 后执行构建
docker build -t custom-geoserver .
```


### 4.2 运行容器

#### 基础运行命令
推荐挂载外部 `geoserver_data` 目录以持久化配置，示例命令：
```bash
# 创建本地数据目录
mkdir -p ~/geoserver_data

# 启动容器
docker run \
    --name=geoserver_8085 \  # 容器名称（建议包含端口号以便区分多实例）
    -p 8085:8080 \           # 端口映射（主机端口:容器内Tomcat端口）
    -d \                     # 后台运行
    -v $HOME/geoserver_data:/opt/geoserver/data_dir \  # 挂载外部数据目录
    -e "GEOSERVER_LOG_LOCATION=/opt/geoserver/data_dir/logs/geoserver_8085.log" \  # 日志文件路径
    -t thinkwhere/geoserver  # 镜像名称
```

#### 多实例部署注意事项
- 不同实例需映射不同主机端口（如 `-p 8086:8080`）
- 容器名称建议包含端口号（如 `geoserver_8086`）
- 每个实例使用独立日志文件（通过 `GEOSERVER_LOG_LOCATION` 指定）


## 五、配置说明

### 5.1 环境变量

| 环境变量                | 说明                          | 示例值                                          |
|-------------------------|-------------------------------|------------------------------------------------|
| `GEOSERVER_LOG_LOCATION` | GeoServer 日志文件路径        | `/opt/geoserver/data_dir/logs/geoserver_8085.log` |


### 5.2 Tomcat 配置

可通过挂载 `setenv.sh` 文件自定义 Tomcat 参数（如 JVM 内存配置）：

#### 创建 setenv.sh 文件
```bash
# 示例：设置 JVM 最大堆内存为 1024M，启用 headless 模式及 GC 优化
JAVA_OPTS="$JAVA_OPTS -Xmx1024M"
JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
```

#### 挂载配置文件
启动容器时挂载 `setenv.sh`：
```bash
docker run -d \
    -v $HOME/tomcat/setenv.sh:/usr/local/tomcat/bin/setenv.sh \  # 挂载配置文件
    thinkwhere/geoserver
```


## 六、支持的标签版本

| 标签                          | GeoServer 版本 | 基础镜像                  | 说明                     |
|-------------------------------|----------------|---------------------------|--------------------------|
| `2.19`, `2.19.0`              | 2.19.0         | tomcat:9.0-JRE11-slim     |                          |
| `2.18`, `2.18.3`, `latest`    | 2.18.3         | tomcat:9.0-JRE11-slim     | 包含 `2.18.0`, `2.18.1`, `2.18.2` 版本 |
| `2.17`, `2.17.5`              | 2.17.5         | tomcat:9.0-JRE11-slim     | 包含 `2.17.0`-`2.17.4` 版本 |
| `2.16`, `2.16.5`              | 2.16.5         | tomcat:9.0-JRE11-slim     | 包含 `2.16.0`-`2.16.4` 版本 |
| `2.15`, `2.15.4`              | 2.15.4         | tomcat:9.0-JRE11-slim     | 包含 `2.15.0-slim`, `2.15.1`-`2.15.3` 版本 |
| `2.14`, `2.14.5`              | 2.14.5         | -                         | 包含 `2.14.0`-`2.14.4` 版本 |
| `2.13`, `2.13.4`              | 2.13.4         | -                         | 包含 `2.13.0`-`2.13.3` 版本 |
| `2.12`, `2.12.5`              | 2.12.5         | -                         | 包含 `2.12.4` 版本 |
| `2.11`, `2.11.5`              | 2.11.5         | -                         |                          |
| `2.10`, `2.10.4`              | 2.10.4         | -                         |                          |
| `2.9`, `2.9.4`                | 2.9.4          | -                         |                          |
| `2.8`, `2.8.5`                | 2.8.5          | -                         |                          |
| `2.8-nogwc`, `2.8.5-nogwc`    | 2.8.5          | -                         | 禁用 GeoWebCache 插件   |


**注**：`v2.15+` 版本基于 Tomcat 9 + Java 11，`v2.15` 以下版本基于 Tomcat 8.5 + Java 8。

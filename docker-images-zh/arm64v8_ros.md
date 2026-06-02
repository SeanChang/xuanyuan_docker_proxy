---
image: arm64v8/ros
description: "机器人操作系统（ROS）是一个致力于简化机器人应用开发流程的开源项目，它通过提供丰富的工具、库和标准化约定，支持开发者高效构建从感知、规划到控制的各类机器人功能模块，兼容多种硬件平台并促进跨团队协作，广泛应用于科研探索、工业自动化、教育实践等领域，为全球机器人开发者社区提供了灵活且强大的技术框架。"
source: https://xuanyuan.cloud/zh/r/arm64v8/ros
canonical: https://xuanyuan.cloud/zh/r/arm64v8/ros
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/ros" title="arm64v8/ros Docker 镜像中文简介、标签列表与拉取命令">arm64v8/ros — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/arm64v8/ros" title="arm64v8/ros Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/arm64v8/ros</a>

# ROS 官方镜像 arm64v8 架构仓库说明  


## 说明  
本仓库是 [ROS 官方镜像]([]) 的 `arm64v8` 架构专用构建仓库。关于非 amd64 架构的更多信息，可参考官方镜像文档中的 [“除 amd64 外的架构？”]([]) 章节；若需了解镜像源码变更相关内容，参见官方镜像 FAQ 的 [“Git 中的镜像源码已变更，该如何处理？”]([])。  


## 快速参考  

### 维护方  
[开源机器人基金会（Open Source Robotics Foundation）]([])  


### 求助渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

- [`humble-ros-core`, `humble-ros-core-jammy`]([])  
- [`humble-ros-base`, `humble-ros-base-jammy`, `humble`]([])  
- [`humble-perception`, `humble-perception-jammy`]([])  
- [`jazzy-ros-core`, `jazzy-ros-core-noble`]([])  
- [`jazzy-ros-base`, `jazzy-ros-base-noble`, `jazzy`, `latest`]([])  
- [`jazzy-perception`, `jazzy-perception-noble`]([])  
- [`kilted-ros-core`, `kilted-ros-core-noble`]([])  
- [`kilted-ros-base`, `kilted-ros-base-noble`, `kilted`]([])  
- [`kilted-perception`, `kilted-perception-noble`]([])  
- [`rolling-ros-core`, `rolling-ros-core-noble`]([])  
- [`rolling-ros-base`, `rolling-ros-base-noble`, `rolling`]([])  
- [`rolling-perception`, `rolling-perception-noble`]([])  


## 快速参考（续）  

### 问题反馈渠道  
[[]]([])  


### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm64v8`]([])  


### 镜像制品详情  
[repo-info 仓库的 `repos/ros/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
[official-images 仓库的 `library/ros` 标签]([])  
[official-images 仓库的 `library/ros` 文件]([])（[历史记录]([])）  


### 本文档源码  
[docs 仓库的 `ros/` 目录]([])（[历史记录]([])）  


# 什么是 ROS？  
机器人操作系统（ROS）是一套用于构建机器人应用的软件库和工具集，涵盖从驱动程序到前沿算法，配合强大的开发工具，为各类机器人项目提供所需功能。ROS 完全开源。  

> 参考：[.org/wiki/Robot_Operating_System]()  

[![ROS 标志]([])]([])  


# 如何使用本镜像  


## 通过 Dockerfile 安装 ROS 包  
如需创建自定义 ROS 镜像并安装特定包，以下示例展示了如何通过 `apt-get` 安装官方发布的 Debian 包（以 C++ 和 Python 客户端库示例包为例）：  

```dockerfile
FROM arm64v8/ros:rolling-ros-core as aptgetter

# 安装 ROS 包
RUN apt-get update && apt-get install -y \
      ros-${ROS_DISTRO}-demo-nodes-cpp \
      ros-${ROS_DISTRO}-demo-nodes-py && \
    rm -rf /var/lib/apt/lists/*

# 启动 ROS 包
CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener_launch.py"]
```  

**说明**：所有 ROS 镜像均包含默认入口点（entrypoint），会在执行命令前自动加载 ROS 环境配置。上述示例中，入口点会先加载环境，再执行示例包的启动文件。  

构建并运行镜像的命令如下：  

```console
$ docker build -t my/ros:aptgetter .
$ docker run -it --rm my/ros:aptgetter
[INFO] [launch]: process[talker-1]: started with pid [813]
[INFO] [launch]: process[listener-2]: started with pid [814]
[INFO] [talker]: Publishing: 'Hello World: 1'
[INFO] [listener]: I heard: [Hello World: 1]
[INFO] [talker]: Publishing: 'Hello World: 2'
[INFO] [listener]: I heard: [Hello World: 2]
...
```  


## 通过 Dockerfile 构建 ROS 包  
如需从源码构建自定义 ROS 包并生成镜像，以下示例展示了多阶段构建流程：安装构建依赖、编译源码、将产物复制到最终运行镜像，以减小镜像体积。  

```dockerfile
ARG FROM_IMAGE=arm64v8/ros:rolling
ARG OVERLAY_WS=/opt/ros/overlay_ws

# 阶段 1：缓存依赖信息
FROM $FROM_IMAGE AS cacher
ARG OVERLAY_WS

# 更新 apt 和 ROS 索引，持久化缓存配置
RUN rosdep update --rosdistro $ROS_DISTRO && \
    cat <<EOF > /etc/apt/apt.conf.d/docker-clean && apt-get update
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

# 克隆示例源码到工作空间
WORKDIR $OVERLAY_WS/src
RUN cat <<EOF | vcs import .
repositories:
  ros2/demos:
    type: git
    url: []    version: ${ROS_DISTRO}
EOF

# 提取构建和运行依赖
RUN bash -e <<'EOF'
declare -A types=(
  [exec]="--dependency-types=exec"
  [build]="")
for type in "${!types[@]}"; do
  rosdep install -y \
    --from-paths \
      ros2/demos/demo_nodes_cpp \
      ros2/demos/demo_nodes_py \
    --ignore-src \
    --reinstall \
    --simulate \
    ${types[$type]} \
    | grep 'apt-get install' \
    | awk '{gsub(/'\''/,"",$4); print $4}' \
    | sort -u > /tmp/${type}_debs.txt
done
EOF

# 阶段 2：构建源码
FROM $FROM_IMAGE AS builder
ARG OVERLAY_WS

# 安装构建依赖
COPY --from=cacher /tmp/build_debs.txt /tmp/build_debs.txt
RUN --mount=type=cache,target=/etc/apt/apt.conf.d,from=cacher,source=/etc/apt/apt.conf.d \
    --mount=type=cache,target=/var/lib/apt/lists,from=cacher,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    < /tmp/build_debs.txt xargs apt-get install -y

# 编译源码
WORKDIR $OVERLAY_WS
COPY --from=cacher $OVERLAY_WS/src ./src
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build \
      --packages-select \
        demo_nodes_cpp \
        demo_nodes_py \
      --mixin release

# 阶段 3：生成运行镜像
FROM $FROM_IMAGE-ros-core AS runner
ARG OVERLAY_WS

# 安装运行依赖
COPY --from=cacher /tmp/exec_debs.txt /tmp/exec_debs.txt
RUN --mount=type=cache,target=/etc/apt/apt.conf.d,from=cacher,source=/etc/apt/apt.conf.d \
    --mount=type=cache,target=/var/lib/apt/lists,from=cacher,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    < /tmp/exec_debs.txt xargs apt-get install -y

# 复制编译产物并配置环境
ENV OVERLAY_WS=$OVERLAY_WS
COPY --from=builder $OVERLAY_WS/install $OVERLAY_WS/install
RUN sed --in-place --expression \
      '$isource "$OVERLAY_WS/install/setup.bash"' \
      /ros_entrypoint.sh

# 启动示例
CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener_launch.py"]
```  

**优化说明**：  
- **多阶段构建**：分离依赖提取、编译、运行阶段，减少最终镜像体积；  
- **缓存持久化**：通过 `--mount` 复用缓存数据，避免重复网络请求；  
- **最小化镜像**：基于 `ros-core` 构建最终镜像，仅复制必要的编译产物。  

构建后镜像体积对比（示例）：  

```console
$ docker image ls my/ros --format "table {{.Tag}}\t{{.Size}}"
TAG                SIZE
aptgetter          504MB  # 通过 apt 安装的镜像
runner             510MB  # 多阶段构建的运行镜像
builder            941MB  # 编译阶段临时镜像
$ docker image ls ros --format "table {{.Tag}}\t{{.Size}}"
TAG                SIZE
rolling-ros-core   489MB  # 基础 ros-core 镜像
rolling            876MB  # 完整 ros 镜像
```  


## 部署场景  
本镜像基于 [官方 Ubuntu 镜像]([]) 和 ROS 官方 Debian 包构建，提供稳定的机器人应用开发/部署平台。适用于科研和工业场景，简化自主控制、任务规划、定位导航、群体行为等复杂系统的开发、复用和交付流程。  

容器化技术解决了 ROS 软件的可重复性和跨平台部署难题，帮助中小团队降低协作成本，专注于算法创新而非环境配置。  


## 部署建议  

### 镜像标签选择  
- `ros-core`：最小化 ROS 安装（仅含核心组件）；  
- `ros-base`：包含基础工具和库（通常以发行版名称为标签，LTS 版本标记为 `latest`）。  

**注意**：`ros-core` 不含 `rosdep`、`colcon` 等开发工具，需使用 `ros-base` 获取完整开发环境。图形化相关的 `desktop` 等元包可在 [OSRF 的 Docker Hub 仓库]([]) 获取。  


### 数据持久化  
ROS 日志等数据默认存储在 `~/.ros/` 目录。如需持久化，可将该目录挂载到主机卷：  

```console
$ docker run -v "/home/ubuntu/.ros/:/root/.ros/" arm64v8/ros
```  


### 设备访问  
如需访问相机、输入设备或 GPU，可通过 `--device` 参数挂载设备：  

```console
$ docker run --device /dev/video0:/dev/video0 arm64v8/ros  # 挂载摄像头
```  


### 网络配置  
ROS 支持分布式通信，建议通过 Docker 网络连接多个容器。如需简化外部通信，可使用 `host` 网络模式（注意：此模式会移除容器网络隔离，可能影响 DDS 通信，详情参见 [相关文档]([])）。  


## 部署示例：Docker Compose  
以下示例通过 `docker compose` 启动两个容器（发布者和订阅者），演示跨容器 ROS 通信。  

### 步骤 1：准备文件  
创建目录 `~/ros_demos`，放入前文“通过 Dockerfile 安装 ROS 包”中的 `Dockerfile`，并新建 `compose.yaml`：  

```yaml
services:
  talker:
    build: ./
    command: ros2 run demo_nodes_cpp talker  # C++ 发布节点

  listener:
    build: ./
    environment:
      - "PYTHONUNBUFFERED=1"  # 实时输出 Python 日志
    command: ros2 run demo_nodes_py listener  # Python 订阅节点
```  


### 步骤 2：启动与验证  
```console
# 构建并启动容器（后台运行）
$ cd ~/ros_demos && docker compose up -d

# 查看订阅节点日志
$ docker compose logs listener

# 停止并清理容器
$ docker compose stop && docker compose rm

# （可选）删除自动创建的网络
$ docker compose down
```  


# 更多资源  
- [ROS 开发者文档]([])  
- [ROS 问答社区]([])  
- [ROS 论坛]([])  
- [ROS 包索引]([])  
- [开源机器人基金会（OSRF）]([])  


# 许可证  
镜像中软件的许可证信息可在 [包索引]([]) 中查询。  
Docker 镜像可能包含基础系统（如 Bash）及依赖软件，其许可证需

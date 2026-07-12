---
image: amd64/ros
description: "机器人操作系统（ROS）是用于构建机器人应用的开源项目。"
source: https://xuanyuan.cloud/zh/r/amd64/ros
canonical: https://xuanyuan.cloud/zh/r/amd64/ros
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/ros" title="amd64/ros Docker 镜像中文简介、标签列表与拉取命令">amd64/ros 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ROS Docker 镜像文档

## 镜像概述与主要用途

**注意：** 本仓库是 [官方 `ros` 镜像](https://hub.docker.com/_/ros) 的 `amd64` 架构构建版本。更多信息请参见官方镜像文档中的 ["除 amd64 外的架构？"](https://github.com/docker-library/official-images#architectures-other-than-amd64) 和官方镜像 FAQ 中的 ["镜像源在 Git 中已更改，该怎么办？"](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

机器人操作系统（ROS）是一个开源项目，用于构建机器人应用程序。本 Docker 镜像是 ROS 官方镜像的 amd64 架构版本，基于官方 Ubuntu 镜像和 ROS 官方 Debian 软件包构建，提供了简化且一致的平台，用于开发、构建和部署分布式机器人应用。

## 核心功能与特性

### 多版本与变体支持
提供多种 ROS 发行版（如 humble、jazzy、kilted、rolling）及不同功能层级的镜像变体：
- `ros-core`：最小化 ROS 安装，包含核心组件
- `ros-base`：基础工具和库，包含 `ros-core` 及额外基础功能（部分发行版以此为默认标签）
- `perception`：包含感知相关功能包的扩展版本

### 构建优化
- 支持多阶段构建（Multi-Stage Build），分离依赖推导、编译和运行环境，减小最终镜像体积
- 集成缓存机制（如 apt 缓存、构建依赖缓存），加速镜像构建过程
- 支持通过 `rosdep` 自动解析依赖，简化第三方包集成

### 部署灵活性
- 兼容 Docker 网络，支持多容器分布式 ROS 应用部署
- 支持设备挂载（如相机、GPU）以实现硬件访问
- 可持久化日志目录（`~/.ros/`），便于调试和数据留存

## 支持的标签及对应 Dockerfile 链接

| 标签 | Dockerfile 链接 |
|------|----------------|
| `humble-ros-core`, `humble-ros-core-jammy` | [链接](https://github.com/osrf/docker_images/blob/eb5634cf92ba079897e44fb7541d3b78aa6cf717/ros/humble/ubuntu/jammy/ros-core/Dockerfile) |
| `humble-ros-base`, `humble-ros-base-jammy`, `humble` | [链接](https://github.com/osrf/docker_images/blob/20e3ba685bb353a3c00be9ba01c1b7a6823c9472/ros/humble/ubuntu/jammy/ros-base/Dockerfile) |
| `humble-perception`, `humble-perception-jammy` | [链接](https://github.com/osrf/docker_images/blob/20d40c96b426b8956dec203e236abff2ec29b188/ros/humble/ubuntu/jammy/perception/Dockerfile) |
| `jazzy-ros-core`, `jazzy-ros-core-noble` | [链接](https://github.com/osrf/docker_images/blob/eb5634cf92ba079897e44fb7541d3b78aa6cf717/ros/jazzy/ubuntu/noble/ros-core/Dockerfile) |
| `jazzy-ros-base`, `jazzy-ros-base-noble`, `jazzy`, `latest` | [链接](https://github.com/osrf/docker_images/blob/0038f1c3a11aa0fc573d698b39ab5c204aad5a40/ros/jazzy/ubuntu/noble/ros-base/Dockerfile) |
| `jazzy-perception`, `jazzy-perception-noble` | [链接](https://github.com/osrf/docker_images/blob/0038f1c3a11aa0fc573d698b39ab5c204aad5a40/ros/jazzy/ubuntu/noble/perception/Dockerfile) |
| `kilted-ros-core`, `kilted-ros-core-noble` | [链接](https://github.com/osrf/docker_images/blob/eb5634cf92ba079897e44fb7541d3b78aa6cf717/ros/kilted/ubuntu/noble/ros-core/Dockerfile) |
| `kilted-ros-base`, `kilted-ros-base-noble`, `kilted` | [链接](https://github.com/osrf/docker_images/blob/b835a530495c0b411a0d15db858710a2748ee0a0/ros/kilted/ubuntu/noble/ros-base/Dockerfile) |
| `kilted-perception`, `kilted-perception-noble` | [链接](https://github.com/osrf/docker_images/blob/b835a530495c0b411a0d15db858710a2748ee0a0/ros/kilted/ubuntu/noble/perception/Dockerfile) |
| `rolling-ros-core`, `rolling-ros-core-noble` | [链接](https://github.com/osrf/docker_images/blob/8cf2903c0f8813aacd3042c71d4d2d56d5068ad5/ros/rolling/ubuntu/noble/ros-core/Dockerfile) |
| `rolling-ros-base`, `rolling-ros-base-noble`, `rolling` | [链接](https://github.com/osrf/docker_images/blob/8cf2903c0f8813aacd3042c71d4d2d56d5068ad5/ros/rolling/ubuntu/noble/ros-base/Dockerfile) |
| `rolling-perception`, `rolling-perception-noble` | [链接](https://github.com/osrf/docker_images/blob/8cf2903c0f8813aacd3042c71d4d2d56d5068ad5/ros/rolling/ubuntu/noble/perception/Dockerfile) |

## 使用场景与适用范围

本镜像适用于需要快速构建、测试和部署机器人应用的场景，包括但不限于：

### 学术研究
- 机器人算法验证（如路径规划、SLAM）
- 多机器人系统协作研究
- 可重复的实验环境搭建

### 工业应用
- 自动化生产线机器人控制
- 物流仓储机器人系统部署
- 服务机器人应用开发

### 教育与开发
- ROS 入门学习环境
- 机器人应用原型快速迭代
- 开源项目二次开发与分发

## 使用方法与配置说明

### 快速参考信息
- **维护方**：[开源机器人基金会（OSRF）](https://github.com/osrf/docker_images)
- **获取帮助**：[Docker 社区 Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)
- **提交 issue**：[https://github.com/osrf/docker_images/issues](https://github.com/osrf/docker_images/issues?q=)
- **支持架构**：`amd64`、`arm64v8`
- **镜像元数据**：[repo-info 仓库的 `ros/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/ros)

### 通过 apt 安装 ROS 包

创建 `Dockerfile` 安装预编译的 ROS 包（以 `demo-nodes-cpp` 和 `demo-nodes-py` 为例）：

```dockerfile
FROM docker.xuanyuan.run/amd64/ros:rolling-ros-core as aptgetter

# 安装 ROS 包
RUN apt-get update && apt-get install -y \
      ros-${ROS_DISTRO}-demo-nodes-cpp \
      ros-${ROS_DISTRO}-demo-nodes-py && \
    rm -rf /var/lib/apt/lists/*

# 启动 ROS 包
CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener_launch.py"]
```

**构建与运行**：

```console
$ docker build -t my/ros:aptgetter .
$ docker run -it --rm my/ros:aptgetter
[INFO] [launch]: process[talker-1]: started with pid [813]
[INFO] [launch]: process[listener-2]: started with pid [814]
[INFO] [talker]: Publishing: 'Hello World: 1'
[INFO] [listener]: I heard: [Hello World: 1]
...
```

> **说明**：所有 ROS 镜像包含默认入口点（entrypoint），会在执行命令前自动加载 ROS 环境变量（如 `ROS_DISTRO`）。

### 从源码构建 ROS 包

使用多阶段构建从源码编译 ROS 包，优化镜像体积：

```dockerfile
ARG FROM_IMAGE=amd64/ros:rolling
ARG OVERLAY_WS=/opt/ros/overlay_ws

# 阶段 1：依赖推导与缓存
FROM $FROM_IMAGE AS cacher
ARG OVERLAY_WS

# 更新 rosdep 并配置 apt 缓存
RUN rosdep update --rosdistro $ROS_DISTRO && \
    cat <<EOF > /etc/apt/apt.conf.d/docker-clean && apt-get update
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

# 克隆源码（以 ros2/demos 为例）
WORKDIR $OVERLAY_WS/src
RUN cat <<EOF | vcs import .
repositories:
  ros2/demos:
    type: git
    url: https://github.com/ros2/demos.git
    version: ${ROS_DISTRO}
EOF

# 推导构建/运行依赖
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

# 阶段 2：编译源码
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

# 阶段 3：运行环境
FROM $FROM_IMAGE-ros-core AS runner
ARG OVERLAY_WS

# 安装运行依赖
COPY --from=cacher /tmp/exec_debs.txt /tmp/exec_debs.txt
RUN --mount=type=cache,target=/etc/apt/apt.conf.d,from=cacher,source=/etc/apt/apt.conf.d \
    --mount=type=cache,target=/var/lib/apt/lists,from=cacher,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    < /tmp/exec_debs.txt xargs apt-get install -y

# 配置环境
ENV OVERLAY_WS=$OVERLAY_WS
COPY --from=builder $OVERLAY_WS/install $OVERLAY_WS/install
RUN sed --in-place --expression \
      '$isource "$OVERLAY_WS/install/setup.bash"' \
      /ros_entrypoint.sh

# 启动命令
CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener_launch.py"]
```

**构建结果对比**（示例）：

```console
$ docker image ls my/ros --format "table {{.Tag}}\t{{.Size}}"
TAG                SIZE
aptgetter          504MB  # apt 安装版
runner             510MB  # 源码编译版（多阶段优化后）
builder            941MB  # 编译阶段镜像（不用于部署）
```

### 部署建议

#### 数据卷（Volumes）
持久化 ROS 日志目录（`~/.ros/`）：

```console
$ docker run -v "/home/ubuntu/.ros/:/root/.ros/" amd64/ros
```

#### 设备访问
通过 `--device` 参数挂载硬件设备（如相机、GPU）：

```console
$ docker run --device=/dev/video0:/dev/video0 amd64/ros  # 挂载摄像头
```

#### 网络配置
- **Docker 网络**：使用自定义网络连接多个 ROS 容器（推荐）
- **Host 网络**：使用 `--net=host` 共享主机网络栈（简化外部通信，但降低隔离性）

### Docker Compose 部署示例

使用 `docker compose` 部署分布式 ROS 应用（发布者-订阅者模型）：

1. 创建目录 `~/ros_demos`，放入上述 `Dockerfile`（aptgetter 版本）
2. 创建 `compose.yaml`：

```yaml
services:
  talker:  # C++ 发布者节点
    build: ./
    command: ros2 run demo_nodes_cpp talker

  listener:  # Python 订阅者节点
    build: ./
    environment:
      - "PYTHONUNBUFFERED=1"  # 实时输出 Python 日志
    command: ros2 run demo_nodes_py listener
```

3. 启动与管理：

```console
# 构建并后台启动
$ docker compose up -d

# 查看自动创建的网络
$ docker network inspect ros_demos_default

# 查看 listener 节点日志
$ docker compose logs listener

# 停止并清理
$ docker compose stop
$ docker compose rm
$ docker compose down  # 同时删除网络
```

## 更多资源

- [ROS 官方文档](https://docs.ros.org/)
- [ROS 问答社区](https://robotics.stackexchange.com/)
- [ROS 论坛](https://discourse.ros.org/)
- [ROS 包索引](https://index.ros.org/?search_packages=true)
- [开源机器人基金会（OSRF）](https://www.openrobotics.org/)

## 许可证

本镜像包含的软件许可证信息可通过以下途径获取：
- [ROS 包索引](https://index.ros.org/packages/)
- [repo-info 仓库的 `ros/` 目录](https://github.com/docker-library/repo-info/tree/master/repos/ros)

使用本镜像时，用户需自行确保遵守其中所有软件的相关许可证。

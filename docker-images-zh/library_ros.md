---
image: library/ros
description: "机器人操作系统（ROS）是一个开源项目，旨在为构建机器人应用提供全面支持，它集成了丰富的工具、库和通信协议，能够实现硬件抽象、设备驱动管理、节点间消息传递及软件包分发等关键功能，通过模块化架构和跨平台兼容性，有效简化了从简单移动机器人到复杂人机交互系统的开发流程，广泛应用于科研实验、工业自动化、服务机器人及智能家居等领域，极大促进了机器人技术的协作创新与快速迭代发展。"
source: https://xuanyuan.cloud/zh/r/library/ros
canonical: https://xuanyuan.cloud/zh/r/library/ros
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/ros" title="library/ros Docker 镜像中文简介、标签列表与拉取命令">library/ros — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/ros" title="library/ros Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/ros</a>

# ROS Docker 镜像使用指南


## 快速参考

- **维护方**：  
  [开源机器人基金会（Open Source Robotics Foundation）]([])

- **获取帮助**：  
  [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应 Dockerfile 链接

以下是各 ROS 发行版支持的镜像标签，标签后附对应 Dockerfile 的 GitHub 链接：

### Humble 发行版
- [`humble-ros-core`, `humble-ros-core-jammy`]([])  
- [`humble-ros-base`, `humble-ros-base-jammy`, `humble`]([])  
- [`humble-perception`, `humble-perception-jammy`]([])  

### Jazzy 发行版
- [`jazzy-ros-core`, `jazzy-ros-core-noble`]([])  
- [`jazzy-ros-base`, `jazzy-ros-base-noble`, `jazzy`, `latest`]([])  
- [`jazzy-perception`, `jazzy-perception-noble`]([])  

### Kilted 发行版
- [`kilted-ros-core`, `kilted-ros-core-noble`]([])  
- [`kilted-ros-base`, `kilted-ros-base-noble`, `kilted`]([])  
- [`kilted-perception`, `kilted-perception-noble`]([])  

### Rolling 发行版
- [`rolling-ros-core`, `rolling-ros-core-noble`]([])  
- [`rolling-ros-base`, `rolling-ros-base-noble`, `rolling`]([])  
- [`rolling-perception`, `rolling-perception-noble`]([])  


## 快速参考（续）

- **问题反馈地址**：  
  [osrf/docker_images 仓库 Issues]([])  

- **支持的架构**：（[更多信息]([])）  
  [`amd64`]([])、[`arm64v8`]([])  

- **镜像详情**：  
  [repo-info 仓库的 `repos/ros/` 目录]([])（[历史记录]([])）  
  （包含镜像元数据、传输大小等）  

- **镜像更新**：  
  [official-images 仓库的 `library/ros` 标签]([])  
  [official-images 仓库的 `library/ros` 文件]([])（[历史记录]([])）  

- **本文档来源**：  
  [docs 仓库的 `ros/` 目录]([])（[历史记录]([])）  


## 什么是 ROS？

机器人操作系统（ROS）是一套帮助构建机器人应用的软件库和工具集。从驱动程序到前沿算法，再到强大的开发工具，ROS 为你的下一个机器人项目提供所需的一切，且全部开源。

> 参考：[维基百科 - 机器人操作系统]()

[![ROS 标志]([])]([])


## 如何使用本镜像

### 通过 Dockerfile 安装 ROS 包

若需创建自定义 ROS 镜像并安装特定包，以下示例展示了如何通过 `apt-get` 安装 C++ 和 Python 客户端库示例（基于官方 Debian 包）：

```dockerfile
FROM ros:rolling-ros-core as aptgetter

# 安装 ROS 包
RUN apt-get update && apt-get install -y \
      ros-${ROS_DISTRO}-demo-nodes-cpp \
      ros-${ROS_DISTRO}-demo-nodes-py && \
    rm -rf /var/lib/apt/lists/*

# 启动 ROS 包
CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener_launch.py"]
```

**说明**：所有 ROS 镜像默认包含入口点脚本，会在执行命令前自动配置 ROS 环境。构建并运行镜像的命令如下：

```bash
$ docker build -t my/ros:aptgetter .
$ docker run -it --rm my/ros:aptgetter
```

运行后将启动发布者和订阅者节点，输出类似：  
`[INFO] [talker]: Publishing: 'Hello World: 1'`  
`[INFO] [listener]: I heard: [Hello World: 1]`  


### 通过 Dockerfile 编译 ROS 包

若需从源码编译自定义 ROS 包，可使用多阶段构建优化镜像大小和构建效率。以下示例包含依赖推导、编译和运行环境分离：

```dockerfile
ARG FROM_IMAGE=ros:rolling
ARG OVERLAY_WS=/opt/ros/overlay_ws

# 阶段 1：推导依赖（缓存优化）
FROM $FROM_IMAGE AS cacher
ARG OVERLAY_WS

# 更新依赖索引并配置 apt
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
    url: []    version: ${ROS_DISTRO}
EOF

# 提取构建/运行依赖列表
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

# 编译工作空间
WORKDIR $OVERLAY_WS
COPY --from=cacher $OVERLAY_WS/src ./src
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build \
      --packages-select \
        demo_nodes_cpp \
        demo_nodes_py \
      --mixin release

# 阶段 3：运行环境（最小化镜像）
FROM $FROM_IMAGE-ros-core AS runner
ARG OVERLAY_WS

# 安装运行依赖
COPY --from=cacher /tmp/exec_debs.txt /tmp/exec_debs.txt
RUN --mount=type=cache,target=/etc/apt/apt.conf.d,from=cacher,source=/etc/apt/apt.conf.d \
    --mount=type=cache,target=/var/lib/apt/lists,from=cacher,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    < /tmp/exec_debs.txt xargs apt-get install -y

# 配置环境变量并启动
ENV OVERLAY_WS=$OVERLAY_WS
COPY --from=builder $OVERLAY_WS/install $OVERLAY_WS/install
RUN sed --in-place --expression \
      '$isource "$OVERLAY_WS/install/setup.bash"' \
      /ros_entrypoint.sh

CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener_launch.py"]
```

**优化点**：  
- 多阶段分离依赖推导、编译和运行环境，减少最终镜像体积；  
- 使用 `--mount` 缓存 apt 数据，避免重复下载；  
- 仅复制编译产物到运行镜像，基于 `ros-core` 进一步精简。  


## 部署建议

### 数据持久化（Volumes）

ROS 默认将日志等数据存储在 `~/.ros/` 目录。若需持久化，可通过 `-v` 参数挂载主机目录：

```bash
$ docker run -v "/home/yourname/.ros/:/root/.ros/" ros
```


### 设备访问（Devices）

如需访问相机、GPU 等硬件，使用 `--device` 参数挂载设备：

```bash
$ docker run --device=/dev/video0:/dev/video0 ros  # 挂载摄像头
```


### 网络配置（Networks）

ROS 节点间通信依赖网络。推荐使用 Docker 网络隔离节点，或通过 `--net=host` 共享主机网络（简化外部通信，但需注意网络隔离性）。


## 部署示例：Docker Compose

以下示例通过 `docker compose` 启动两个独立容器（发布者+订阅者），演示跨容器 ROS 通信：

### 步骤 1：准备文件

创建目录 `~/ros_demos`，并添加上述 **安装 ROS 包** 的 Dockerfile。在同一目录创建 `compose.yaml`：

```yaml
services:
  talker:
    build: ./
    command: ros2 run demo_nodes_cpp talker

  listener:
    build: ./
    environment:
      - "PYTHONUNBUFFERED=1"
    command: ros2 run demo_nodes_py listener
```

### 步骤 2：启动服务

```bash
$ cd ~/ros_demos
$ docker compose up -d  # 后台启动
```

### 步骤 3：查看日志

```bash
$ docker compose logs listener  # 查看订阅者日志
```

### 步骤 4：停止服务

```bash
$ docker compose stop  # 停止容器
$ docker compose rm    # 删除容器
$ docker compose down  # 清理网络（如需）
```


## 更多资源

- [ROS 官方文档]([])  
- [ROS 问答社区]([])  
- [ROS 论坛]([])  
- [ROS 包索引]([])  
- [开源机器人基金会（OSRF）]([])  


## 许可证说明

镜像中软件的许可证信息可通过 [ROS 包索引]([]) 查询。使用本镜像时，需确保遵守其中所有软件的许可条款。

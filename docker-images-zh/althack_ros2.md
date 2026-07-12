---
image: althack/ros2
description: "一系列适用于ROS 2的开发容器"
source: https://xuanyuan.cloud/zh/r/althack/ros2
canonical: https://xuanyuan.cloud/zh/r/althack/ros2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/althack/ros2" title="althack/ros2 Docker 镜像中文简介、标签列表与拉取命令">althack/ros2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# althack/ros2 Docker镜像文档

## 镜像概述与主要用途

althack/ros2是一系列专为ROS 2开发设计的Docker镜像，旨在提供便捷、一致的开发环境，尤其适用于与VSCode集成的开发工作流。该镜像集合支持多个ROS 2版本，提供不同功能变体，并可选CUDA加速支持，满足从基础开发到仿真验证的多样化需求。

## 核心功能与特性

- **多ROS 2版本支持**：涵盖当前活跃版本（如rolling、jazzy、humble、kilted）及部分历史版本（如iron、galactic等，已停止维护）。
- **多样化功能变体**：每个ROS 2版本提供四种功能变体，适应不同开发阶段：
  - `base`：基础ROS 2运行环境，包含核心组件
  - `dev`：增强开发工具链，包含编译器、调试器等开发必需工具
  - `full`：完整版本，包含扩展组件及额外依赖
  - `gazebo`：集成Gazebo仿真器，支持ROS 2仿真应用开发
- **CUDA加速选项**：部分版本提供CUDA支持（标签含`-cuda`），适用于需要GPU加速的计算任务
- **版本固定机制**：所有镜像均附加创建日期标签（格式：`{镜像名称}-{年}-{月}-{日}`），支持固定到特定软件包版本，确保环境一致性

## 使用场景与适用范围

- **ROS 2应用开发**：提供标准化开发环境，简化多开发者协作配置
- **仿真验证**：通过`gazebo`变体快速搭建ROS 2仿真环境，进行算法验证
- **GPU加速开发**：借助CUDA-enabled镜像，开发涉及深度学习、计算机视觉等需GPU加速的ROS 2节点
- **多版本兼容性测试**：支持在不同ROS 2版本间切换，验证应用兼容性
- **VSCode集成开发**：优化配置以支持VSCode远程容器开发，提升开发效率

## 镜像标签组织

### ROS 2版本与变体矩阵

| ROS 2版本   | CUDA支持 | 可用变体标签                                  | 维护状态       |
|-------------|----------|---------------------------------------------|----------------|
| rolling     | 否       | rolling-base, rolling-dev, rolling-full, rolling-gazebo | 活跃           |
| rolling     | 是       | rolling-cuda-base, rolling-cuda-dev, rolling-cuda-full, rolling-cuda-gazebo | 活跃 |
| jazzy       | 否       | jazzy-base, jazzy-dev, jazzy-full, jazzy-gazebo | 活跃           |
| jazzy       | 是       | jazzy-cuda-base, jazzy-cuda-dev, jazzy-cuda-full, jazzy-cuda-gazebo | 活跃 |
| kilted      | 否       | kilted-base, kilted-dev, kilted-full, kilted-gazebo | 活跃           |
| humble      | 否       | humble-base, humble-dev, humble-full, humble-gazebo | 活跃           |
| humble      | 是       | humble-cuda-base, humble-cuda-dev, humble-cuda-full, humble-cuda-gazebo | 活跃 |
| iron        | 否/是    | iron-base, iron-dev, ..., iron-cuda-*       | 已停止维护(EOL)|
| galactic    | 否/是    | galactic-base, galactic-dev, ..., galactic-cuda-* | 已停止维护(EOL)|
| foxy        | 否/是    | foxy-base, foxy-dev, ..., foxy-cuda-*       | 已停止维护(EOL)|
| eloquent    | 否       | eloquent-base, eloquent-dev, ...            | 已停止维护(EOL)|
| dashing     | 否       | dashing-base, dashing-dev, ...              | 已停止维护(EOL)|

> **注**：标记为“已停止维护(EOL)”的版本不再接收更新，建议优先使用活跃版本进行开发

### 日期标签格式

所有镜像标签支持日期后缀，格式为`{变体标签}-{年}-{月}-{日}`，例如：
- `rolling-dev-2024-01-15`：2024年1月15日构建的rolling-dev版本
- `humble-cuda-gazebo-2023-11-30`：2023年11月30日构建的humble-cuda-gazebo版本

## 详细使用方法与配置说明

### 拉取镜像

使用`docker pull`命令拉取所需镜像，基本格式为：

```bash
docker pull docker.xuanyuan.run/althack/ros2:<标签>
```

**示例**：
- 拉取rolling版本的开发变体：
  ```bash
  docker pull docker.xuanyuan.run/althack/ros2:rolling-dev
  ```
- 拉取带CUDA的jazzy完整版本：
  ```bash
  docker pull docker.xuanyuan.run/althack/ros2:jazzy-cuda-full
  ```
- 拉取特定日期的humble仿真版本：
  ```bash
  docker pull docker.xuanyuan.run/althack/ros2:humble-gazebo-2024-03-20
  ```

### 运行容器

#### 基础开发环境

启动基础ROS 2开发容器，挂载工作目录并支持交互终端：

```bash
docker run -it --rm \
  --name ros2-dev-container \
  -v $(pwd):/workspace \
  docker.xuanyuan.run/althack/ros2:rolling-dev
```

#### 带GUI支持的仿真环境（Gazebo）

运行包含Gazebo的容器，需配置显示转发以支持GUI应用：

```bash
docker run -it --rm \
  --name ros2-gazebo-container \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $(pwd):/workspace \
  --net=host \  # 简化网络配置，适用于本地开发
  althack/ros2:rolling-gazebo
```

#### CUDA加速环境

运行带CUDA支持的容器（需主机已安装NVIDIA驱动及nvidia-docker运行时）：

```bash
docker run -it --rm \
  --name ros2-cuda-container \
  --gpus all \  # 映射所有GPU设备
  -v $(pwd):/workspace \
  althack/ros2:humble-cuda-dev
```

### Docker Compose配置示例

创建`docker-compose.yml`文件，定义包含Gazebo仿真环境的服务：

```yaml
version: '3.8'
services:
  ros2-gazebo:
    image: docker.xuanyuan.run/althack/ros2:rolling-gazebo
    container_name: ros2-simulation
    volumes:
      - ./workspace:/workspace
      - /tmp/.X11-unix:/tmp/.X11-unix
    environment:
      - DISPLAY=${DISPLAY}
      - QT_X11_NO_MITSHM=1  # 解决部分GUI应用共享内存问题
    network_mode: host
    stdin_open: true
    tty: true
```

启动服务：
```bash
docker-compose up -d
```

进入容器：
```bash
docker-compose exec ros2-gazebo bash
```

## 版本固定与环境一致性

为确保开发环境的一致性，建议使用带日期标签的镜像版本。例如，指定2024年5月10日构建的rolling-dev镜像：

```bash
docker pull docker.xuanyuan.run/althack/ros2:rolling-dev-2024-05-10
```

在Docker Compose中指定固定版本：

```yaml
services:
  ros2-dev:
    image: docker.xuanyuan.run/althack/ros2:rolling-dev-2024-05-10
    # ... 其他配置
```

通过日期标签可避免因镜像更新导致的依赖版本变化问题，保障开发环境的稳定性。

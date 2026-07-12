---
image: rwthika/ros2
description: "docker-ros-ml-images提供多架构且支持机器学习的ROS Docker镜像。"
source: https://xuanyuan.cloud/zh/r/rwthika/ros2
canonical: https://xuanyuan.cloud/zh/r/rwthika/ros2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rwthika/ros2" title="rwthika/ros2 Docker 镜像中文简介、标签列表与拉取命令">rwthika/ros2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-ros-ml-images – 集成机器学习能力的ROS Docker镜像


## 1. 镜像概述与主要用途

`docker-ros-ml-images` 是一套提供多架构支持、集成机器学习能力的ROS Docker镜像。其核心用途是为ROS（机器人操作系统）应用开发与部署提供开箱即用的机器学习环境，简化ROS与深度学习框架（如PyTorch、TensorFlow）的集成流程，支持跨架构（如x86_64、ARM）部署需求。


## 2. 核心功能与特性

- **多架构支持**：适配多种硬件架构，满足不同部署场景（如服务器、嵌入式设备）需求。  
- **机器学习框架集成**：预安装主流深度学习框架，无需手动配置依赖。  
- **ROS版本兼容**：支持ROS 1与ROS 2多个稳定版本，覆盖主流机器人开发环境。  
- **GPU加速支持**：兼容NVIDIA GPU，可利用硬件加速提升机器学习任务性能。  


## 3. 支持版本信息

### 3.1 ROS版本支持
| ROS类型   | 支持版本                  |
|-----------|---------------------------|
| ROS 1     | noetic                    |
| ROS 2     | humble, iron, jazzy, rolling |

### 3.2 机器学习框架版本
| 框架名称          | 版本号       |
|-------------------|--------------|
| PyTorch           | 2.3.0        |
| TensorFlow        | 2.16.1       |
| NVIDIA Triton Inference Server | 2.48.0 |


## 4. 使用场景与适用范围

- **机器人感知任务**：集成目标检测、图像分割等基于深度学习的感知算法到ROS节点。  
- **端到端机器人控制**：部署基于神经网络的机器人决策与控制模型（如强化学习策略）。  
- **跨架构项目开发**：需在x86服务器与ARM嵌入式设备（如NVIDIA Jetson、树莓派）间统一部署环境的场景。  
- **快速原型验证**：无需手动搭建ROS与机器学习依赖，直接基于镜像开发和测试算法。  


## 5. 使用方法与配置说明

### 5.1 基础运行命令

使用 `docker run` 启动镜像（以ROS 1 noetic版本、x86_64架构为例）：

```bash
# 启用GPU支持（需安装nvidia-docker）
docker run -it --rm \
  --gpus all \
  --network host \
  -v /path/to/ros_ws:/root/catkin_ws \  # 挂载本地ROS工作空间
  ika-rwth-aachen/docker-ros-ml-images:noetic-x86_64
```

**参数说明**：  
- `--gpus all`：启用所有GPU设备，用于机器学习任务加速。  
- `--network host`：共享主机网络，简化ROS节点通信（适用于开发环境）。  
- `-v /path/to/ros_ws:/root/catkin_ws`：挂载本地ROS工作空间至容器，实现代码持久化与实时修改。  


### 5.2 Docker Compose配置示例

创建 `docker-compose.yml` 配置文件，用于管理容器服务：

```yaml
version: '3.8'
services:
  ros-ml:
    image: docker.xuanyuan.run/ika-rwth-aachen/docker-ros-ml-images:humble-arm64  # ROS 2 humble，ARM64架构
    runtime: nvidia  # 启用NVIDIA运行时
    network_mode: host
    volumes:
      - ./ros2_ws:/root/ros2_ws  # 挂载ROS 2工作空间
    environment:
      - ROS_DOMAIN_ID=0  # 设置ROS 2域ID
      - PYTHONPATH=/root/ros2_ws/install/lib/python3.10/site-packages  # 添加工作空间Python路径
    command: bash -c "source /opt/ros/humble/setup.bash && ros2 run my_ml_node ml_inference_node"
```


## 6. 相关工具推荐

`docker-ros-ml-images` 推荐与以下工具配合使用，提升开发与部署效率：

- **docker-ros**  
  自动化构建ROS应用的最小容器镜像，减少镜像体积并优化部署流程。  
  项目地址：[https://github.com/ika-rwth-aachen/docker-ros](https://github.com/ika-rwth-aachen/docker-ros)

- **docker-run**  
  简化Docker镜像交互的命令行工具，支持快速启动、配置容器参数。  
  项目地址：[https://github.com/ika-rwth-aachen/docker-run](https://github.com/ika-rwth-aachen/docker-run)


## 7. 许可证信息

本项目采用开源许可证，具体条款请参见GitHub仓库：[https://github.com/ika-rwth-aachen/docker-ros-ml-images](https://github.com/ika-rwth-aachen/docker-ros-ml-images)


## 8. 更多信息

完整文档与更新说明请访问项目GitHub主页：  
[https://github.com/ika-rwth-aachen/docker-ros-ml-images](https://github.com/ika-rwth-aachen/docker-ros-ml-images)

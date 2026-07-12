---
image: gezp/ubuntu-desktop
description: "Ubuntu桌面版Docker镜像，支持硬件GPU加速的GUI应用。"
source: https://xuanyuan.cloud/zh/r/gezp/ubuntu-desktop
canonical: https://xuanyuan.cloud/zh/r/gezp/ubuntu-desktop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gezp/ubuntu-desktop" title="gezp/ubuntu-desktop Docker 镜像中文简介、标签列表与拉取命令">gezp/ubuntu-desktop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ubuntu Desktop Docker 镜像文档


## 镜像概述和主要用途

### 概述
`gezp/ubuntu-desktop` 是一个基于 Docker 的 Ubuntu 桌面环境镜像，专为支持硬件 GPU 加速的 GUI 应用设计。该镜像将 Ubuntu 桌面环境容器化，提供隔离、可移植的图形应用运行环境。

### 主要用途
- 在容器中运行需要 GPU 加速的图形界面应用
- 提供标准化的 Ubuntu 桌面开发/测试环境
- 实现图形应用的跨平台部署与环境一致性保障


## 核心功能和特性

- **完整 Ubuntu 桌面环境**：集成 Ubuntu 官方桌面环境（如 GNOME），支持标准 GUI 应用运行
- **硬件 GPU 加速**：支持 NVIDIA/AMD 等硬件 GPU 资源直通，满足图形密集型应用需求
- **容器化隔离**：通过 Docker 容器实现应用与宿主环境的隔离，避免依赖冲突
- **环境一致性**：统一的基础镜像确保不同部署环境中应用行为一致
- **轻量级优化**：在保留核心功能基础上精简镜像体积，降低资源占用


## 使用场景和适用范围

### 典型使用场景
- **开发环境**：图形应用开发（游戏引擎、CAD 软件、图形渲染工具）
- **测试环境**：GUI 应用跨版本兼容性测试，快速切换基础环境
- **远程图形工作站**：在服务器/云环境中部署，通过网络访问 GPU 加速桌面
- **科学计算可视化**：运行需要 GPU 加速的数据可视化工具（如 Matplotlib、ParaView）

### 适用范围
- 需要 GPU 加速的图形应用开发者
- 追求环境隔离与标准化的测试团队
- 需在无图形界面服务器上运行桌面应用的场景
- 教学/演示环境的快速部署


## 使用方法和配置说明

### 前提条件
- Docker Engine 20.10+
- 若启用 GPU 加速：
  - NVIDIA 显卡需安装 `nvidia-container-toolkit`
  - AMD 显卡需安装 `rocm-container-runtime`
- 本地显示：X11 服务器（Linux）或 X Server 客户端（Windows/macOS，如 VcXsrv）
- 远程访问：VNC 客户端或 Web 浏览器（如启用 VNC 服务）


### 基础使用（本地 X11 转发）

#### 无 GPU 加速
```bash
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --net=host \
  docker.xuanyuan.run/gezp/ubuntu-desktop
```

#### 带 GPU 加速（NVIDIA）
```bash
docker run -it --rm \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/Projects:/home/user/Projects \  # 挂载工作目录
  gezp/ubuntu-desktop
```


### 远程访问（VNC 服务）

#### 基本 VNC 配置
```bash
docker run -d --name ubuntu-desktop \
  --gpus all \
  -p 5900:5900 \  # VNC 默认端口
  -e VNC_PASSWORD=SecurePass123 \  # 设置 VNC 密码
  -v $HOME/data:/home/user/data \  # 持久化数据卷
  gezp/ubuntu-desktop
```
> 连接方式：使用 VNC 客户端访问 `host_ip:5900`，输入密码 `SecurePass123`


### Docker Compose 配置示例

```yaml
version: '3.8'
services:
  ubuntu-desktop:
    image: docker.xuanyuan.run/gezp/ubuntu-desktop
    container_name: ubuntu-desktop
    restart: unless-stopped
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]  # NVIDIA GPU 配置（AMD 需替换为 rocm）
    ports:
      - "5900:5900"    # VNC 端口
      - "6080:6080"    # Web VNC 端口（如支持）
    environment:
      - VNC_PASSWORD=Admin@2024
      - USER=developer  # 容器内用户名
      - UID=1000        # 与宿主机用户 UID 保持一致（避免权限问题）
      - GID=1000        # 与宿主机用户 GID 保持一致
    volumes:
      - ./workspace:/home/developer/workspace  # 工作目录挂载
      - ./config:/home/developer/.config       # 应用配置持久化
    shm_size: "2g"  # 增加共享内存（部分 GUI 应用需求）
```


## 配置参数和环境变量

### 核心环境变量

| 变量名          | 描述                          | 默认值       | 示例值               |
|-----------------|-------------------------------|--------------|----------------------|
| `DISPLAY`       | X11 显示设备地址              | `:0`         | `host.docker.internal:0` (Windows) |
| `VNC_PASSWORD`  | VNC 访问密码                  | `password`   | `SecurePass123`      |
| `USER`          | 容器内默认用户名              | `user`       | `developer`          |
| `UID`           | 用户 UID（匹配宿主机权限）    | `1000`       | `1001`               |
| `GID`           | 用户 GID（匹配宿主机权限）    | `1000`       | `1001`               |
| `RESOLUTION`    | 桌面分辨率（VNC 模式）        | `1920x1080`  | `2560x1440`          |


### 关键运行参数

| 参数                  | 描述                          | 示例                                  |
|-----------------------|-------------------------------|---------------------------------------|
| `--gpus all`          | 启用所有 GPU 设备（NVIDIA）   | `docker run --gpus all ...`           |
| `-v /tmp/.X11-unix`   | 挂载 X11 套接字（本地显示）   | `-v /tmp/.X11-unix:/tmp/.X11-unix`    |
| `-p 5900:5900`        | 映射 VNC 端口（远程访问）     | `-p 5901:5900`（自定义端口 5901）     |
| `--shm-size`          | 调整共享内存大小              | `--shm-size "4g"`（4GB 共享内存）     |
| `-v <host>:<container>` | 数据卷挂载（持久化）        | `-v $HOME/data:/home/user/data`       |


### 高级配置：GPU 资源限制

#### NVIDIA GPU 显存限制
```bash
docker run -it --rm \
  --gpus 'all,"capabilities=compute,utility",device=0,count=1,memory=4G' \
  docker.xuanyuan.run/gezp/ubuntu-desktop
```

#### AMD ROCm 配置
```bash
docker run -it --rm \
  --device=/dev/kfd \
  --device=/dev/dri \
  -v /etc/OpenCL/vendors:/etc/OpenCL/vendors \
  docker.xuanyuan.run/gezp/ubuntu-desktop
```


## 注意事项

1. **权限问题**：挂载宿主机目录时，建议通过 `UID/GID` 环境变量保持与宿主机用户 ID 一致，避免文件权限冲突
2. **GPU 驱动兼容性**：容器内 GPU 驱动版本需与宿主机驱动版本匹配（NVIDIA 推荐使用相同大版本）
3. **网络配置**：本地 X11 转发需关闭 Docker 网络隔离（`--net=host`）或配置 X11 访问控制（`xhost +local:root`）
4. **性能优化**：图形密集型应用建议使用直接 GPU 直通，避免软件渲染 overhead

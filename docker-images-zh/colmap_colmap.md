---
image: colmap/colmap
description: "COLMAP开源摄影测量项目的Docker镜像，用于从多张图像重建三维场景结构与相机姿态，提供便捷部署方式以简化环境配置。"
source: https://xuanyuan.cloud/zh/r/colmap/colmap
canonical: https://xuanyuan.cloud/zh/r/colmap/colmap
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/colmap/colmap" title="colmap/colmap Docker 镜像中文简介、标签列表与拉取命令">colmap/colmap 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## COLMAP Docker镜像文档

### 镜像概述和主要用途
COLMAP是一个开源摄影测量项目，专注于从多张二维图像中重建三维场景结构与相机姿态。本Docker镜像封装了COLMAP及其依赖环境，旨在提供便捷、一致的部署方式，使用户无需手动配置复杂的系统依赖即可快速使用COLMAP的核心功能。

### 核心功能和特性
#### COLMAP核心功能
- **图像特征处理**：支持SIFT、SURF等特征提取与匹配，实现图像间对应关系建立
- **相机标定**：自动或手动标定相机内参，支持多种相机模型
- **三维重建**：包含稀疏重建（生成点云）和稠密重建（生成密集点云/网格）流程
- **场景优化**：对重建结果进行光束平差法优化，提升精度

#### Docker镜像特性
- **环境隔离**：封装所有依赖库，避免与主机系统环境冲突
- **跨平台兼容**：支持Linux、macOS、Windows（需Docker环境）
- **快速部署**：一键拉取镜像并运行，无需手动编译安装

### 使用场景和适用范围
- **计算机视觉研究**：三维重建算法开发与验证
- **三维建模领域**：文物、建筑、室内外场景的三维数字化
- **机器人与SLAM**：视觉定位与地图构建（VSLAM）辅助工具
- **虚拟现实/增强现实**：生成虚拟场景的三维几何基础

### 使用方法和配置说明

#### 前提条件
- 已安装Docker Engine（版本20.10+）
- 若使用图形界面功能，需配置X11转发（Linux/macOS）或支持GUI的Docker环境（Windows）

#### 获取镜像
从Docker Hub拉取官方镜像（假设镜像名为`colmap/colmap`，实际请以项目官方为准）：
```bash
docker pull docker.xuanyuan.run/colmap/colmap:latest
```

#### 基本使用示例
##### 命令行模式运行三维重建
```bash
# 创建数据目录（存放输入图像和输出结果）
mkdir -p ./colmap_data/images ./colmap_data/workspace

# 运行自动重建流程
docker run -it --rm \
  -v $(pwd)/colmap_data/images:/input \
  -v $(pwd)/colmap_data/workspace:/output \
  docker.xuanyuan.run/colmap/colmap \
  colmap automatic_reconstructor \
    --image_path /input \
    --workspace_path /output
```
- `-v`：挂载主机目录到容器，`/input`为输入图像目录，`/output`为重建结果输出目录
- `automatic_reconstructor`：COLMAP自动重建命令，自动完成特征匹配、稀疏重建、稠密重建全流程

##### 图形界面模式（Linux/macOS）
```bash
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $(pwd)/colmap_data:/data \
  docker.xuanyuan.run/colmap/colmap \
  colmap gui --database_path /data/database.db --image_path /data/images
```
- `-e DISPLAY=$DISPLAY`：传递显示环境变量
- `-v /tmp/.X11-unix:/tmp/.X11-unix`：共享X11套接字，实现图形界面显示

### 配置参数说明
| 参数/挂载项 | 说明 | 示例 |
|------------|------|------|
| `-v /input` | 输入图像目录挂载 | `-v /host/images:/input` |
| `-v /output` | 输出结果目录挂载 | `-v /host/results:/output` |
| `--database_path` | 数据库文件路径（存储特征和匹配信息） | `--database_path /data/db.db` |
| `--image_path` | 图像文件所在目录 | `--image_path /data/images` |

### 参考链接
- COLMAP官方项目：[https://github.com/colmap/colmap](https://github.com/colmap/colmap)
- Docker Hub镜像（如有）：[https://hub.docker.com/r/colmap/colmap](https://hub.docker.com/r/colmap/colmap)

---
image: jjm2473/jellyfin-mpp
description: "支持Rockchip MPP/RGA的Jellyfin镜像，适用于Rockchip SoC设备，提供媒体服务器功能，支持硬件加速转码，已在RK3568（R68s）和RK3588s（R6S）设备测试通过。"
source: https://xuanyuan.cloud/zh/r/jjm2473/jellyfin-mpp
canonical: https://xuanyuan.cloud/zh/r/jjm2473/jellyfin-mpp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jjm2473/jellyfin-mpp" title="jjm2473/jellyfin-mpp Docker 镜像中文简介、标签列表与拉取命令">jjm2473/jellyfin-mpp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jellyfin (Rockchip MPP/RGA支持版)

## 镜像概述
本镜像为Jellyfin媒体服务器的定制版本，专门针对Rockchip系列SoC设备优化，集成了MPP（多媒体处理平台）和RGA（2D图形加速引擎）支持，实现硬件加速转码功能，提升媒体播放和转码性能。

## 核心功能与特性
- **硬件加速支持**：集成Rockchip MPP/RGA硬件加速模块，优化视频转码性能
- **设备兼容性**：已在RK3568（R68s，搭载iStoreOS 20221111固件）和RK3588s（R6S，测试固件）设备验证通过
- **标准Jellyfin功能**：保留Jellyfin核心媒体服务器功能，支持媒体库管理、多设备流式传输等

## 系统要求
使用前需确保主机系统满足以下条件：
- 必须存在设备文件：`/dev/rga`
- 至少存在以下设备文件之一：`/dev/dri` 或 `/dev/dma_heap`

## 使用方法

### Docker Run 部署
```bash
docker run --name jellyfin \
    --privileged \
    --restart=unless-stopped -td \
    `for dev in iep rga dri dma_heap mpp_service mpp-service vpu_service vpu-service \
        hevc_service hevc-service rkvdec rkvenc avsd vepu h265e ; do \
      [ -e "/dev/$dev" ] && echo " --device /dev/$dev"; \
    done` \
    --dns=172.17.0.1 \
    -p 8096:8096 \
    -v /root/jellyfin/config:/config \
    -v /mnt:/mnt \
    jjm2473/jellyfin-mpp:latest
```

#### 参数说明
- `--privileged`：授予容器特权模式，确保硬件设备访问权限
- `--restart=unless-stopped`：容器退出时自动重启（除非手动停止）
- `--device`：自动挂载主机存在的Rockchip硬件加速相关设备文件
- `--dns=172.17.0.1`：设置DNS服务器
- `-p 8096:8096`：映射Jellyfin Web管理端口
- `-v /root/jellyfin/config:/config`：挂载配置文件目录
- `-v /mnt:/mnt`：挂载媒体文件存储目录（根据实际情况调整）

## 注意事项
- **转码失败处理**：若出现转码失败，尝试删除主机上的`/dev/ion`文件后重启容器
- **设备文件依赖**：确保主机系统已加载必要的Rockchip驱动模块，以提供所需设备文件

## 源码链接
- Jellyfin定制源码：https://github.com/jjm2473/jellyfin/tree/release-10.8.z-jjm
- 定制FFmpeg源码：https://github.com/jjm2473/ffmpeg-rk/tree/enc

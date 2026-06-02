---
image: linuxserver/ffmpeg
description: "linuxserver/ffmpeg是LinuxServer团队优化的轻量级Docker镜像，集成FFmpeg全功能多媒体处理工具，支持音视频编解码、格式转换、滤镜特效及流媒体推流/拉流。镜像采用高效打包技术，体积小巧且兼容多架构平台，持续同步官方更新确保功能前沿。适用于开发者批量处理音视频文件、搭建媒体服务器实时转码或家庭影院系统自动化格式转换，为多媒体处理提供高效稳定的容器化解决方案。"
source: https://xuanyuan.cloud/zh/r/linuxserver/ffmpeg
canonical: https://xuanyuan.cloud/zh/r/linuxserver/ffmpeg
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/ffmpeg" title="linuxserver/ffmpeg Docker 镜像中文简介、标签列表与拉取命令">linuxserver/ffmpeg — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/linuxserver/ffmpeg" title="linuxserver/ffmpeg Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/ffmpeg</a>

# LinuxServer.io ffmpeg 容器介绍


## LinuxServer.io 团队简介  
LinuxServer.io 团队专注于提供高质量容器解决方案，其发布的容器具有以下特点：  
- 定期及时的应用更新  
- 简化的用户权限映射（通过 PGID、PUID 设置）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周基础系统更新，通过共享通用层减少存储空间占用、 downtime 和带宽消耗  
- 常规安全更新  


## 社区与支持渠道  
- **博客**：<[]>（容器使用指南、教程及技术观点）  
- *：<  
- **论坛**：<[]>（社区讨论与问题反馈）  
- **Fleet**：<[]>（在线查看所有维护中的镜像）  
- **GitHub**：<[]>（源代码仓库）  
- **捐赠支持**：<[]>（欢迎通过捐赠或贡献支持团队）  


# linuxserver/ffmpeg 容器  

[FFmpeg]([]) 是一套跨平台的音视频处理工具，支持录制、转换和流式传输音视频。LinuxServer.io 提供的此容器封装了 FFmpeg，便于通过 Docker 临时运行自定义音视频处理命令。  


## 支持的架构  
容器通过 Docker manifest 实现多平台支持，直接拉取 `lscr.io/linuxserver/ffmpeg:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅ 支持   | amd64-\<版本标签\>     |  
| arm64      | ✅ 支持   | arm64v8-\<版本标签\>   |  
| armhf      | ❌ 不支持 | -                      |  


## 使用方法  
该容器需通过命令行临时运行，需熟悉 Docker 基础操作及 FFmpeg 命令构造。以下示例均假设当前工作目录包含输入文件 `input.mkv`，并通过绑定挂载将当前目录映射到容器内的 `/config`。  


### 包含的硬件加速驱动（Intel x86 平台）  
- **iHD 驱动**：支持第 8 代及以上 Intel 处理器（默认启用）  
- **i965 驱动**：支持第 5-9.5 代 Intel 处理器（通过环境变量 `LIBVA_DRIVER_NAME=i965` 启用）  
- **VAAPI**：配合 i965 驱动支持第 5 代及以上，配合 iHD 驱动支持第 8 代及以上  
- **Qsv 调度器**：OneVPL（自动切换 OneVPL 和 MSDK 运行时）  
- **Qsv 运行时**：OneVPL（支持第 12 代及以上）、MSDK（支持第 8-12 代）  


### 基础转码示例  
```bash
docker run --rm -it \
  -v $(pwd):/config \
  linuxserver/ffmpeg \
  -i /config/input.mkv \  # 输入文件路径（容器内路径）
  -c:v libx264 \          # 视频编码器（libx264 软件编码）
  -b:v 4M \               # 视频比特率
  -vf scale=1280:720 \    # 视频尺寸缩放
  -c:a copy \             # 音频流直接复制（不重新编码）
  /config/output.mkv      # 输出文件路径（容器内路径，映射到宿主机当前目录）
```  


### VAAPI 硬件加速（Intel/AMD iGPU）  
```bash
docker run --rm -it \
  --device=/dev/dri:/dev/dri \  # 挂载 GPU 设备
  -v $(pwd):/config \
  linuxserver/ffmpeg \
  -vaapi_device /dev/dri/renderD128 \  # 指定 VAAPI 设备
  -i /config/input.mkv \
  -c:v h264_vaapi \                   # VAAPI 视频编码器
  -b:v 4M \
  -vf 'format=nv12|vaapi,hwupload,scale_vaapi=w=1280:h=720' \  # 硬件缩放
  -c:a copy \
  /config/output.mkv
```  


### QSV 硬件加速（Intel CPU）  
```bash
docker run --rm -it \
  --device=/dev/dri:/dev/dri \
  -v $(pwd):/config \
  linuxserver/ffmpeg \
  -hwaccel qsv \          # 启用 QSV 硬件加速
  -c:v h264_qsv \         # QSV 视频编码器
  -i /config/input.mkv \
  -global_quality 25 \    # 视频质量（数值越低质量越高）
  /config/output.mkv
```  


### Nvidia 硬件加速  
需先在宿主机安装 [Nvidia 容器工具包]([]) 及驱动：  
```bash
docker run --rm -it \
  --runtime=nvidia \      # 使用 Nvidia 运行时
  -v $(pwd):/config \
  linuxserver/ffmpeg \
  -hwaccel nvdec \        # Nvidia 硬件解码
  -i /config/input.mkv \
  -c:v h264_nvenc \       # Nvidia 硬件编码
  -b:v 4M \
  -vf scale=1280:720 \
  -c:a copy \
  /config/output.mkv
```  


### Vulkan 支持（Intel/AMD iGPU）  
需根据显卡类型设置环境变量启用对应驱动：  
```bash
# Intel 显卡（设置 ANV 驱动）
docker run --rm -it \
  --device=/dev/dri:/dev/dri \
  -v $(pwd):/config \
  -e ANV_VIDEO_DECODE=1 \
  linuxserver/ffmpeg \
  -init_hw_device "vulkan=vk:0" \  # 初始化 Vulkan 设备
  -hwaccel vulkan \
  -hwaccel_output_format vulkan \
  -i /config/input.mkv \
  -f null - -benchmark  # 测试转码性能（无输出文件）
```  
- **AMD 显卡**：添加环境变量 `-e RADV_PERFTEST=video_decode`  
- **Nvidia 显卡**：需安装 Nvidia Vulkan Beta 驱动  


## 本地构建  
如需修改镜像源码或自定义构建：  
```bash
# 克隆仓库
git clone [] docker-ffmpeg

# 构建镜像（x86_64）
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/docker-ffmpeg:latest .

# 构建 ARM 架构（需先注册 qemu）
docker run --rm --privileged multiarch/qemu-user-static:register --reset
# 例如构建 arm64：
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/docker-ffmpeg:arm64v8-latest .
```  


## 版本更新记录  
- **2023.08.25**：更新 ffmpeg 至 8.0，同步更新 harfbuzz、Intel 驱动、libdovi 等依赖  
- **2023.08.06**：更新 svt-av1  
- **2023.06.07**：更新 harfbuzz、libass、libdovi、libplacebo 等依赖  
- **2023.06.04**：为 arm64 镜像添加 libdrm 和 rkmpp 支持  
- **2023.04.21**：更新 aom、Intel 驱动、mesa、svt-av1 等依赖  
- **2023.03.07**：更新 ffmpeg 至 7.1.1，同步更新 aom、fontconfig 等依赖  
- **更早版本**：包含 ffmpeg 版本升级、硬件加速支持优化、依赖库更新等（详细历史见 [GitHub]([])）  


通过以上步骤，用户可基于此容器快速实现音视频转码，结合硬件加速提升处理效率。如需更多帮助，可通过社区渠道获取支持。

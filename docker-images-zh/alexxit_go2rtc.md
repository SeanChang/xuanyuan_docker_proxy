---
image: alexxit/go2rtc
description: "全能的摄像头流媒体应用，支持RTSP、WebRTC、MJPEG、HomeKit、FFmpeg等协议与工具。"
source: https://xuanyuan.cloud/zh/r/alexxit/go2rtc
canonical: https://xuanyuan.cloud/zh/r/alexxit/go2rtc
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alexxit/go2rtc" title="alexxit/go2rtc Docker 镜像中文简介、标签列表与拉取命令">alexxit/go2rtc — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/alexxit/go2rtc" title="alexxit/go2rtc Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/alexxit/go2rtc</a>

# go2rtc Docker镜像技术文档


## 镜像概述与主要用途

go2rtc 是一款终极摄像头流媒体应用，支持 RTSP、WebRTC、MJPEG、HomeKit、FFmpeg 等多种协议与功能，可实现摄像头流的采集、转换与分发，适用于各类视频监控与流媒体场景。


## 核心功能与特性

- **多协议支持**：兼容 RTSP、WebRTC、MJPEG、HomeKit 等主流流媒体协议，满足多样化接入与输出需求。
- **硬件转码加速**：支持 Intel iGPU、Raspberry Pi、AMD GPU 及 NVidia GPU 硬件转码，提升性能并降低 CPU 占用。
- **多架构适配**：提供 `amd64`、`386`、`arm`、`arm64` 架构支持，适配 x86 服务器、嵌入式设备（如树莓派）等多种硬件环境。
- **WebUI 配置**：支持通过 Web 界面编辑配置文件（`go2rtc.yaml`），简化配置流程。
- **自动重启机制**：配置变更或故障时可自动重启，保障服务稳定性。


## 使用场景与适用范围

- 家庭/企业 IP 摄像头监控系统搭建。
- 需要多协议转换的流媒体服务（如将 RTSP 流转为 WebRTC 供网页访问）。
- 对硬件资源敏感，需通过硬件加速降低 CPU 占用的场景。
- 需跨平台部署（如 x86 服务器与 ARM 嵌入式设备）的流媒体应用。


## 版本说明

| 镜像标签                | 基础系统          | 特性描述                                                                 |
|-------------------------|-------------------|--------------------------------------------------------------------------|
| `alexxit/go2rtc:latest` | Alpine Linux      | 最新稳定版，支持 `amd64`、`386`、`arm`、`arm64` 架构，包含 Intel iGPU 与树莓派硬件转码支持。 |
| `alexxit/go2rtc:master` | Alpine Linux      | 最新开发版（不稳定），基础特性与 `latest` 一致。                          |
| `alexxit/go2rtc:master-hardware` | Debian 13（amd64） | 最新开发版，支持 Intel iGPU、AMD GPU 及 NVidia GPU 硬件转码。            |


## 使用方法与配置说明

### Docker Compose 配置

通过 `docker-compose.yml` 快速部署，配置示例如下：

```yaml
services:
  go2rtc:
    image: alexxit/go2rtc  # 默认使用 latest 标签
    network_mode: host       # 必须：WebRTC、HomeKit、UDP 摄像头依赖主机网络
    privileged: true         # 必须：FFmpeg 硬件转码需特权模式
    restart: unless-stopped  # 配置：故障或 WebUI 配置变更后自动重启
    environment:
      - TZ=Atlantic/Bermuda  # 可选：设置日志时区（如 Asia/Shanghai）
    volumes:
      - "~/go2rtc:/config"   # 必须：挂载配置目录，用于存储 go2rtc.yaml（支持 WebUI 编辑）
```

启动命令：`docker-compose up -d`


### 基本部署命令

使用 `docker run` 直接部署稳定版：

```bash
docker run -d \
  --name go2rtc \
  --network host \
  --privileged \
  --restart unless-stopped \
  -e TZ=Atlantic/Bermuda \  # 替换为实际时区，如 Asia/Shanghai
  -v ~/go2rtc:/config \     # 本地配置目录路径，可自定义（如 /opt/go2rtc:/config）
  alexxit/go2rtc
```


### GPU 加速部署命令

如需启用 GPU 硬件转码（支持 NVidia/AMD/Intel GPU），使用硬件加速版本镜像：

```bash
docker run -d \
  --name go2rtc \
  --network host \
  --privileged \
  --restart unless-stopped \
  -e TZ=Atlantic/Bermuda \  # 替换为实际时区
  --gpus all \              # 必须：启用所有 GPU 设备（需 Docker 支持 GPU 驱动）
  -v ~/go2rtc:/config \
  alexxit/go2rtc:latest-hardware  # 使用硬件加速版本镜像
```


## 环境变量与卷挂载说明

### 环境变量

| 变量名 | 作用                | 示例值              |
|--------|---------------------|---------------------|
| `TZ`   | 设置日志时区        | `Asia/Shanghai`     |


### 卷挂载

| 本地路径       | 容器路径  | 作用                                  |
|----------------|-----------|---------------------------------------|
| `~/go2rtc`     | `/config` | 存储应用配置文件 `go2rtc.yaml`，支持通过 WebUI 编辑配置，重启后生效。 |


> 硬件转码详细说明参见：[官方硬件加速文档](https://github.com/AlexxIT/go2rtc/wiki/Hardware-acceleration)

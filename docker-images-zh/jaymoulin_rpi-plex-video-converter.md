---
image: jaymoulin/rpi-plex-video-converter
description: "用于树莓派的Plex视频转换器Docker镜像，可将Plex不支持的视频文件递归转换为mp4格式，也提供PC版本以利用更强性能加速转换。"
source: https://xuanyuan.cloud/zh/r/jaymoulin/rpi-plex-video-converter
canonical: https://xuanyuan.cloud/zh/r/jaymoulin/rpi-plex-video-converter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jaymoulin/rpi-plex-video-converter" title="jaymoulin/rpi-plex-video-converter Docker 镜像中文简介、标签列表与拉取命令">jaymoulin/rpi-plex-video-converter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 树莓派 - Plex 视频转换器 - Docker 镜像

## 镜像概述和主要用途
该Docker镜像专为树莓派设计，用于将Plex不支持的视频文件转换为mp4格式（Plex支持的格式）。同时提供PC版本，可利用更强大的设备性能加速视频转换过程。

## 核心功能和特性
- **视频格式转换**：将Plex不支持的视频文件（如avi）递归转换为mp4格式
- **跨平台支持**：提供树莓派版本和PC版本，满足不同设备需求
- **简单易用**：通过挂载媒体目录即可自动处理视频文件
- **轻量级**：基于Docker容器化，部署简单，不依赖复杂环境配置

## 使用场景和适用范围
- 树莓派用户需要在Plex媒体服务器上播放不兼容格式视频时
- 需要批量转换媒体库中不支持格式文件的场景
- 希望利用PC更强性能加速视频转换的用户

## 使用方法和配置说明

### 树莓派版本使用
通过以下命令运行容器，将媒体文件夹挂载到容器的`/media`目录，镜像会递归转换该目录下的不支持视频文件：

```bash
docker run --rm -t -v /path/to/your/media/folder:/media docker.xuanyuan.run/jaymoulin/rpi-plex-video-converter
```

### PC版本使用
若需利用PC更强性能加速转换，使用`:pc`标签：

```bash
docker run --rm -t -v /path/to/your/media/folder:/media docker.xuanyuan.run/jaymoulin/rpi-plex-video-converter:pc
```

## 附录

### 树莓派安装Docker
如未安装Docker，可通过以下命令一键安装：

```bash
curl -sSL "https://gist.githubusercontent.com/jaymoulin/e749a189511cd965f45919f2f99e45f3/raw/0e650b38fde684c4ac534b254099d6d5543375f1/ARM%20(Raspberry%20PI)%20Docker%20Install" | sudo sh && sudo usermod -aG docker $USER
```

### 相关链接
- [源代码](https://github.com/jaymoulin/docker-rpi-plex-video-converter)
- [问题反馈](https://github.com/jaymoulin/docker-rpi-plex-video-converter/issues)

---
image: jrottenberg/ffmpeg
description: "FFmpeg 2.8 - 3.x - 4.x Docker镜像，由FFmpeg开发者版权所有(C) 2000-2017，从源码编译，支持多种基础镜像和硬件加速。"
source: https://xuanyuan.cloud/zh/r/jrottenberg/ffmpeg
canonical: https://xuanyuan.cloud/zh/r/jrottenberg/ffmpeg
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jrottenberg/ffmpeg" title="jrottenberg/ffmpeg Docker 镜像中文简介、标签列表与拉取命令">jrottenberg/ffmpeg 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FFmpeg Docker镜像

[![Docker Stars](https://img.shields.io/docker/stars/jrottenberg/ffmpeg.svg?style=plastic)](https://registry.hub.docker.com/v2/repositories/jrottenberg/ffmpeg/stars/count/) [![Docker pulls](https://img.shields.io/docker/pulls/jrottenberg/ffmpeg.svg?style=plastic)](https://registry.hub.docker.com/v2/repositories/jrottenberg/ffmpeg/)
[![gitlab pipeline status](https://gitlab.com/jrottenberg/ffmpeg/badges/master/pipeline.svg)](https://gitlab.com/jrottenberg/ffmpeg/commits/master)
[![Azure Build Status](https://dev.azure.com/video-tools/ffmpeg/_apis/build/status/jrottenberg.ffmpeg)](https://dev.azure.com/video-tools/ffmpeg/_build/latest?definitionId=1)
[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg?maxAge=2592000?style=plastic)](https://github.com/jrottenberg/ffmpeg/)

本项目提供一个包含FFmpeg的极简Docker镜像。它根据[编译指南](https://trac.ffmpeg.org/wiki/CompilationGuide)的说明从源代码编译FFmpeg。

您可以通过运行`docker pull jrottenberg/ffmpeg`安装此镜像的最新构建版本。

该镜像可用作编码服务器的基础。

## 构建版本

您可以使用jrottenberg/ffmpeg或jrottenberg/ffmpeg:3.3获取基于Ubuntu的最新构建版本。

注意：3.1版本后，已将Ubuntu设为默认基础镜像。

基于CentOS的镜像使用`ffmpeg:X.Y-centos`或`ffmpeg:centos`获取最新版本；Alpine镜像使用`ffmpeg:X.Y-alpine`；Scratch镜像使用`ffmpeg:X.Y-scratch`（仅包含FFmpeg和库的实验性镜像）。

格式为`ffmpeg:MAJOR.MINOR-VARIANT`，其中MAJOR.MINOR包括：2.8、3.0、3.1、3.2、3.3、3.4、4.0、4.1、snapshot；VARIANT包括：alpine、centos、nvidia、scratch、ubuntu、vaapi。

近期镜像：

```
snapshot-vaapi      74mb
snapshot-ubuntu     86mb
snapshot-scratch    20mb
snapshot-nvidia     640mb
snapshot-centos     97mb
snapshot-alpine     35mb
4.1-vaapi           73mb
4.1-ubuntu          85mb
4.1-scratch         20mb
4.1-nvidia          640mb
4.1-centos          97mb
4.1-alpine          34mb
4.0-vaapi           73mb
4.0-ubuntu          83mb
4.0-scratch         20mb
4.0-nvidia          639mb
4.0-centos          97mb
4.0-alpine          34mb
3.4-vaapi           71mb
3.4-ubuntu          83mb
3.4-scratch         18mb
3.4-nvidia          637mb
3.4-centos          97mb
3.4-alpine          32mb
3.4                 83mb
3.3-vaapi           71mb
3.3-ubuntu          83mb
3.3-scratch         18mb
3.3-nvidia          637mb
3.3-centos          96mb
3.3-alpine          31mb
3.3                 82mb
3.2-vaapi           83mb
3.2-ubuntu          83mb
3.2-scratch         18mb
3.2-nvidia          623mb
3.2-centos          96mb
3.2-alpine          32mb
3.1-vaapi           83mb
3.1-ubuntu          82mb
3.1-scratch         17mb
3.1-nvidia          623mb
3.1-centos          96mb
3.1-alpine          32mb
3.1                 81mb
3.0-ubuntu          82mb
3.0-scratch         17mb
3.0-nvidia          623mb
3.0-centos          96mb
3.0-alpine          31mb
2.8-vaapi           82mb
2.8-ubuntu          81mb
2.8-scratch         17mb
2.8-nvidia          622mb
2.8-centos          95mb
2.8-alpine          30mb
```

## 使用示例

### 从00:49:42处提取5秒视频转为GIF

```
docker run jrottenberg/ffmpeg -stats  \
        -i http://archive.org/download/thethreeagesbusterkeaton/Buster.Keaton.The.Three.Ages.ogv \
        -loop 0  \
        -final_delay 500 -c:v gif -f gif -ss 00:49:42 -t 5 - > trow_ball.gif
```

### 将本地GIF转换为mp4

假设当前目录中有original.gif文件：

```
docker run -v $(pwd):$(pwd) -w $(pwd)\
        jrottenberg/ffmpeg:3.2-scratch -stats \
        -i original.gif \
        original-converted.mp4
```

### 使用nvidia硬件加速

```
# 硬件编码示例
docker run --runtime=nvidia jrottenberg/ffmpeg:2.8-nvidia -i INPUT -c:v nvenc_h264 -preset hq OUTPUT

# 完全硬件加速示例
docker run --runtime=nvidia jrottenberg/ffmpeg:4.1-nvidia -hwaccel cuvid -c:v h264_cuvid -i INPUT -vf scale_npp=-1:720 -c:v h264_nvenc -preset slow OUTPUT
```

### 基本视频转换

```
docker run jrottenberg/ffmpeg \
            -i http://url/to/media.mp4 \
            -stats \
            $ffmpeg_options  - > out.mp4
```

## 硬件加速版本使用

### VAAPI加速

```
docker run --device /dev/dri:/dev/dri -v $(pwd):$(pwd) -w $(pwd) jrottenberg/ffmpeg:vaapi [...]
```

需在主机上安装Intel驱动，可运行vainfo命令检查显卡是否被正确识别。

### NVIDIA加速

需在主机上安装nvidia驱动和nvidia-docker，运行容器时使用"--runtime=nvidia"标志。

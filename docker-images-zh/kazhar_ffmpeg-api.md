---
image: kazhar/ffmpeg-api
description: "一个基于FFmpeg的简单Web API，用于转换音频、视频和图像文件。"
source: https://xuanyuan.cloud/zh/r/kazhar/ffmpeg-api
canonical: https://xuanyuan.cloud/zh/r/kazhar/ffmpeg-api
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kazhar/ffmpeg-api" title="kazhar/ffmpeg-api Docker 镜像中文简介、标签列表与拉取命令">kazhar/ffmpeg-api 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FFMPEG API

一个用于通过FFmpeg转换音频、视频和图像文件的Web服务。基于多个开源项目构建，以Docker镜像形式提供，便于快速部署和使用。

## 核心功能与API端点

### 基础端点
- `GET /` - API说明文档
- `GET /endpoints` - 返回JSON格式的服务端点列表

### 转换功能
- `POST /convert/audio/to/mp3` - 将请求体中的音频文件转换为MP3格式并返回
- `POST /convert/audio/to/wav` - 将请求体中的音频文件转换为WAV格式并返回
- `POST /convert/video/to/mp4` - 将请求体中的视频文件转换为MP4格式并返回
- `POST /convert/image/to/jpg` - 将请求体中的图像文件转换为JPG格式并返回

### 视频处理
- `POST /video/extract/audio` - 从视频文件中提取音轨，默认返回单声道WAV
  - 查询参数：`mono=no` - 返回所有声道的音轨
- `POST /video/extract/images` - 从视频中提取PNG图像（默认FPS=1），返回包含下载链接的JSON
  - 查询参数：`compress=zip|gzip` - 返回ZIP或tar.gz压缩包
  - 查询参数：`fps=2` - 指定提取帧率（如fps=0.5表示每2秒1张）
- `GET /video/extract/download/:filename` - 下载提取的图像文件并从服务器删除
  - 查询参数：`delete=no` - 下载后不删除文件

### 媒体探测
- `POST /probe` - 探测媒体文件元数据，返回FFprobe格式的JSON结果

## Docker部署与配置

### 构建自定义镜像
```bash
# 克隆仓库
git clone https://github.com/surebert/docker-ffmpeg-service.git
cd docker-ffmpeg-service

# 构建镜像
docker build -t ffmpeg-api .

# 前台运行
docker run -it --rm --name docker.xuanyuan.run/ffmpeg-api -p 3000:3000 ffmpeg-api

# 后台运行
docker run -d --name docker.xuanyuan.run/ffmpeg-api -p 3000:3000 ffmpeg-api
```

### 使用现有镜像
```bash
# 前台运行
docker run -it --rm --name ffmpeg-api -p 3000:3000 docker.xuanyuan.run/kazhar/ffmpeg-api

# 后台运行
docker run -d --name ffmpeg-api -p 3000:3000 docker.xuanyuan.run/kazhar/ffmpeg-api
```

### 环境变量配置
- `LOG_LEVEL` - 日志级别（默认info），示例：`-e LOG_LEVEL=debug`
- `FILE_SIZE_LIMIT_BYTES` - 最大上传文件大小（默认512MB），示例：`-e FILE_SIZE_LIMIT_BYTES=1048576`（1MB）
- `KEEP_ALL_FILES` - 是否保留所有文件（默认下载后删除），示例：`-e KEEP_ALL_FILES=true`
- `EXTERNAL_PORT` - 外部访问端口（用于生成正确下载链接），示例：`-e EXTERNAL_PORT=3001`（当容器端口映射为3001:3000时）

## 使用示例

### 文件转换
```bash
# 音频转MP3
curl -F "file=@input.wav" 127.0.0.1:3000/convert/audio/to/mp3 > output.mp3

# 视频转MP4
curl -F "file=@input.mov" 127.0.0.1:3000/convert/video/to/mp4 > output.mp4

# 图像转JPG
curl -F "file=@input.png" 127.0.0.1:3000/convert/image/to/jpg > output.jpg
```

### 视频图像提取
```bash
# 提取图像（FPS=2，ZIP压缩）
curl -F "file=@input.mov" "127.0.0.1:3000/video/extract/images?fps=2&compress=zip" > images.zip

# 下载提取的图像
curl "127.0.0.1:3000/video/extract/download/ba0f565c-0001.png" > frame1.png
```

### 音轨提取
```bash
# 提取单声道音频
curl -F "file=@input.mov" 127.0.0.1:3000/video/extract/audio > audio_mono.wav

# 提取所有声道音频
curl -F "file=@input.mov" "127.0.0.1:3000/video/extract/audio?mono=no" > audio_stereo.wav
```

### 媒体探测
```bash
# 获取媒体文件元数据
curl -F "file=@input.mov" 127.0.0.1:3000/probe > metadata.json
```

## 背景信息

该项目最初由Paul Visco开发，后续经过功能扩展、Node.js版本更新、基于Alpine的Docker镜像优化、日志系统完善及其他重大重构。支持所有FFmpeg兼容的媒体格式，具体可参考[FFmpeg官方文档](https://www.ffmpeg.org/general.html#Supported-File-Formats_002c-Codecs-or-Features)。

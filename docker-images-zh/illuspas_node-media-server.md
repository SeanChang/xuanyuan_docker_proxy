---
image: illuspas/node-media-server
description: "基于Node.js实现的RTMP/HTTP-FLV/WS-FLV媒体服务器，支持跨平台部署，提供实时音视频流的接收、转发、转码及分发功能，适用于直播、监控等场景。"
source: https://xuanyuan.cloud/zh/r/illuspas/node-media-server
canonical: https://xuanyuan.cloud/zh/r/illuspas/node-media-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/illuspas/node-media-server" title="illuspas/node-media-server Docker 镜像中文简介、标签列表与拉取命令">illuspas/node-media-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Node-Media-Server

## 镜像概述和主要用途
Node-Media-Server是一个基于Node.js实现的媒体服务器，支持RTMP、HTTP-FLV、WS-FLV、HLS、DASH等多种音视频流协议。它提供了实时音视频流的接收、转发、转码、分发及管理功能，可跨Windows、Linux、Unix等平台部署，适用于直播平台、视频监控系统、实时视频会议等需要高效处理实时音视频流的场景。

## 核心功能和特性
- **跨平台支持**：可在Windows、Linux、Unix系统上运行
- **多协议支持**：支持RTMP、HTTP-FLV、WS-FLV、HLS、DASH等协议
- **编解码支持**：支持H.264/H.265(flv_id=12)、AAC、MP3、SPEEX、NELLYMOSER、G.711、OPUS(flv_id=13)等音视频编码格式
- **流处理功能**：支持GOP缓存、实时转码（多分辨率）、流中继（RTSP/RTMP）、事件回调等
- **安全与认证**：支持xycdn风格认证、HTTPS/WSS加密传输
- **管理与监控**：提供Web管理面板，支持服务器状态监控、流预览及API控制
- **灵活部署**：支持npx快速启动、全局安装、Docker部署及npm集成到项目中

## 使用场景和适用范围
- **直播平台**：作为直播流接收和分发服务器，支持低延迟播放
- **视频监控**：接收摄像头RTSP/RTMP流，转码后通过HTTP-FLV/WS-FLV分发
- **实时教育**：支持课堂实时音视频流传输，低延迟互动
- **企业视频会议**：提供音视频流的实时转发和多终端分发
- **内容分发网络**：作为边缘节点，接收中心流并向本地用户分发

## 详细使用方法和配置说明

### Docker部署示例
```bash
docker run --name nms -d -p 1935:1935 -p 8000:8000 -p 8443:8443 docker.xuanyuan.run/illuspas/node-media-server
```
- **端口说明**：1935(RTMP)、8000(HTTP/WS-FLV)、8443(HTTPS/WSS)

### 其他部署方式

#### npx快速启动
```bash
npx node-media-server
```

#### 全局安装
```bash
npm i node-media-server -g
node-media-server
```

#### npm集成（推荐）
1. 创建项目目录并安装依赖
```bash
mkdir nms && cd nms
npm install node-media-server
```

2. 创建配置文件`app.js`
```js
const NodeMediaServer = require('node-media-server');

const config = {
  rtmp: {
    port: 1935,
    chunk_size: 60000,
    gop_cache: true,
    ping: 30,
    ping_timeout: 60
  },
  http: {
    port: 8000,
    allow_origin: '*'
  }
};

var nms = new NodeMediaServer(config)
nms.run();
```

3. 启动服务
```bash
node app.js
```

### 发布直播流

#### 使用FFmpeg发布
- 若源文件为H.264/AAC编码：
```bash
ffmpeg -re -i INPUT_FILE_NAME -c copy -f flv rtmp://localhost/live/STREAM_NAME
```

- 若源文件为其他编码格式（需转码）：
```bash
ffmpeg -re -i INPUT_FILE_NAME -c:v libx264 -preset veryfast -tune zerolatency -c:a aac -ar 44100 -f flv rtmp://localhost/live/STREAM_NAME
```

#### 使用OBS发布
1. 打开OBS，进入`设置 > 流`
2. 流类型选择`自定义流媒体服务器`
3. URL填写：`rtmp://localhost/live`
4. 流密钥填写：`STREAM_NAME`（自定义流名称）
5. 点击`确定`并开始推流

### 访问直播流

#### 支持的协议格式
- **RTMP**：`rtmp://localhost/live/STREAM_NAME`
- **HTTP-FLV**：`http://localhost:8000/live/STREAM_NAME.flv`
- **WS-FLV**：`ws://localhost:8000/live/STREAM_NAME.flv`
- **HLS**：`http://localhost:8000/live/STREAM_NAME/index.m3u8`
- **DASH**：`http://localhost:8000/live/STREAM_NAME/index.mpd`

#### 使用flv.js播放示例

##### 通过HTTP-FLV播放
```html
<script src="https://cdn.bootcss.com/flv.js/1.5.0/flv.min.js"></script>
<video id="videoElement"></video>
<script>
    if (flvjs.isSupported()) {
        var videoElement = document.getElementById('videoElement');
        var flvPlayer = flvjs.createPlayer({
            type: 'flv',
            url: 'http://localhost:8000/live/STREAM_NAME.flv'
        });
        flvPlayer.attachMediaElement(videoElement);
        flvPlayer.load();
        flvPlayer.play();
    }
</script>
```

##### 通过WS-FLV播放
```html
<script src="https://cdn.bootcss.com/flv.js/1.5.0/flv.min.js"></script>
<video id="videoElement"></video>
<script>
    if (flvjs.isSupported()) {
        var videoElement = document.getElementById('videoElement');
        var flvPlayer = flvjs.createPlayer({
            type: 'flv',
            url: 'ws://localhost:8000/live/STREAM_NAME.flv'
        });
        flvPlayer.attachMediaElement(videoElement);
        flvPlayer.load();
        flvPlayer.play();
    }
</script>
```

### 关键配置说明

#### 日志配置
通过`logType`控制日志输出级别（0-3）：
- 0：不输出日志
- 1：仅输出错误日志
- 2：输出错误和基本信息（默认）
- 3：输出所有日志（调试模式）

配置示例：
```js
const config = {
  logType: 3, // 调试模式
  rtmp: { ... },
  http: { ... }
};
```

#### 认证配置
支持URL签名认证，配置示例：
```js
const config = {
  rtmp: { ... },
  http: { ... },
  auth: {
    play: true, // 播放认证
    publish: true, // 发布认证
    secret: 'your_private_key' // 密钥
  }
};
```
认证URL格式：`rtmp://hostname:port/appname/stream?sign=expires-HashValue`（expires为时间戳，HashValue为MD5哈希值）

#### HTTPS/WSS配置
1. 生成证书：
```bash
openssl genrsa -out privatekey.pem 1024
openssl req -new -key privatekey.pem -out certrequest.csr 
openssl x509 -req -in certrequest.csr -signkey privatekey.pem -out certificate.pem
```

2. 配置HTTPS：
```js
const config = {
  rtmp: { ... },
  http: { ... },
  https: {
    port: 8443,
    key: './privatekey.pem',
    cert: './certificate.pem'
  }
};
```

#### 转码与中继配置
支持HLS/DASH转码、RTSP/RTMP中继，配置示例（转码为HLS/DASH）：
```js
const config = {
  rtmp: { ... },
  http: {
    port: 8000,
    mediaroot: './media', // 媒体文件存储路径
    allow_origin: '*'
  },
  trans: {
    ffmpeg: '/usr/local/bin/ffmpeg', // ffmpeg路径
    tasks: [
      {
        app: 'live', // 应用名称
        hls: true, // 启用HLS
        hlsFlags: '[hls_time=2:hls_list_size=3:hls_flags=delete_segments]', // HLS参数
        dash: true, // 启用DASH
        dashFlags: '[f=dash:window_size=3:extra_window_size=5]' // DASH参数
      }
    ]
  }
};
```

### Web管理面板
服务启动后，可通过`http://server_ip:8000/admin`访问管理面板，支持流监控、预览及配置管理。

## 事件回调
支持多种事件回调，可用于流状态监控和业务逻辑处理，示例：
```js
nms.on('prePublish', (id, StreamPath, args) => {
  console.log('[事件回调 prePublish]', `id=${id} 流路径=${StreamPath} 参数=${JSON.stringify(args)}`);
  // 可在此处拒绝发布：session.reject()
});

nms.on('postPlay', (id, StreamPath, args) => {
  console.log('[事件回调 postPlay]', `id=${id} 流路径=${StreamPath} 参数=${JSON.stringify(args)}`);
});
```

## API接口
启用API认证后，可通过HTTP接口获取服务器状态和流信息：
- 服务器状态：`http://localhost:8000/api/server`
- 流信息：`http://localhost:8000/api/streams`

API认证配置：
```js
const config = {
  auth: {
    api: true,
    api_user: 'admin', // API用户名
    api_pass: 'your_password' // API密码
  }
};

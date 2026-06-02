---
image: mccloud/subgen
description: "通过OpenAI和Plex、Bazarr、Emby、Jellyfin或Tautulli的webhooks自动生成字幕的Docker镜像"
source: https://xuanyuan.cloud/zh/r/mccloud/subgen
canonical: https://xuanyuan.cloud/zh/r/mccloud/subgen
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mccloud/subgen" title="mccloud/subgen Docker 镜像中文简介、标签列表与拉取命令">mccloud/subgen — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mccloud/subgen" title="mccloud/subgen Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mccloud/subgen</a>

# subgen Docker镜像文档

## 镜像概述和主要用途

subgen是一个基于Docker容器化的字幕自动生成工具，通过集成OpenAI API与主流媒体服务器及工具的webhooks，实现媒体文件字幕的自动化生成。该工具支持Plex、Bazarr、Emby、Jellyfin及Tautulli等平台的webhook事件触发，结合OpenAI的AI能力，为个人媒体库提供高效、智能的字幕解决方案。

## 核心功能和特性

- **多平台webhook集成**：兼容Plex、Bazarr、Emby、Jellyfin、Tautulli等主流媒体服务器及工具的webhook事件，支持通过媒体添加、播放等事件自动触发字幕生成流程。
- **OpenAI驱动**：集成OpenAI API，利用AI技术生成高质量、多语言字幕，支持语音转文字及字幕翻译功能。
- **自动化工作流**：无需人工干预，从webhook事件接收、媒体信息解析到字幕生成、输出全程自动化。
- **灵活配置**：支持自定义字幕语言、生成策略、API参数及输出路径，适配不同使用场景需求。
- **轻量部署**：基于Docker容器化设计，简化依赖管理，易于集成到现有媒体服务架构。

## 使用场景和适用范围

- **个人媒体库管理**：为Plex/Emby/Jellyfin媒体库自动生成新添加影片、剧集的字幕，解决无字幕或字幕质量不佳问题。
- **媒体服务器自动化**：与Bazarr等字幕管理工具配合，作为AI字幕生成补充方案，覆盖稀缺字幕资源。
- **Tautulli事件响应**：基于Tautulli的媒体播放统计数据，为高频播放但无字幕的内容优先生成字幕。
- **多语言字幕需求**：针对外语影片，自动生成双语或多语言字幕，提升观看体验。

## 使用方法和配置说明

### 前置条件

- 有效的OpenAI API密钥（需具备访问语音转文字/字幕生成API权限）。
- 运行中的媒体服务器/工具（Plex/Emby等），并支持配置webhook。
- Docker环境（Docker Engine 20.10+ 或 Docker Desktop）。

### Docker部署方式

#### 1. 直接使用docker run部署

```bash
docker run -d \
  --name subgen \
  -p 8080:8080 \
  -v /path/to/local/subtitles:/app/subtitles \
  -e OPENAI_API_KEY="your_openai_api_key" \
  -e SUPPORTED_SERVICES="plex,bazarr,emby" \
  -e SUBTITLE_LANGUAGES="en,zh-CN" \
  -e LOG_LEVEL="info" \
  mcclouds/subgen:latest
```

#### 2. 使用docker-compose部署

创建`docker-compose.yml`配置文件：

```yaml
version: '3.8'

services:
  subgen:
    image: mcclouds/subgen:latest
    container_name: subgen
    restart: unless-stopped
    ports:
      - "8080:8080"  # 映射webhook服务端口
    volumes:
      - ./subtitles:/app/subtitles  # 挂载本地目录存储生成的字幕
    environment:
      - OPENAI_API_KEY=your_openai_api_key  # 替换为实际OpenAI API密钥（必填）
      - WEBHOOK_PORT=8080                  # webhook服务监听端口（默认8080）
      - SUPPORTED_SERVICES=plex,bazarr,jellyfin  # 启用的webhook服务（逗号分隔）
      - SUBTITLE_LANGUAGES=en,zh-CN,ja     # 生成的字幕语言（ISO 639-1代码，逗号分隔）
      - LOG_LEVEL=info                     # 日志级别（debug/info/warn/error，默认info）
      - OPENAI_MODEL=whisper-1             # OpenAI字幕生成模型（默认whisper-1）
      - SUBTITLE_OUTPUT_PATH=/app/subtitles  # 容器内字幕输出路径（默认/app/subtitles）
      - OPENAI_API_BASE_URL=https://api.openai.com/v1  # OpenAI API基础URL（默认官方地址）
```

启动服务：

```bash
docker-compose up -d
```

### 配置参数说明

#### 环境变量配置

| 参数名                  | 描述                                                                 | 是否必填 | 默认值                          |
|-------------------------|----------------------------------------------------------------------|----------|---------------------------------|
| OPENAI_API_KEY          | OpenAI API密钥，用于调用字幕生成接口                                  | 是       | -                               |
| WEBHOOK_PORT            | 容器内webhook服务监听端口                                            | 否       | 8080                            |
| SUPPORTED_SERVICES      | 启用的webhook服务，可选值：plex,bazarr,emby,jellyfin,tautulli（逗号分隔） | 否       | 全部支持                        |
| SUBTITLE_LANGUAGES      | 生成的字幕语言，使用ISO 639-1代码（如en,zh-CN,ja），逗号分隔          | 否       | en                              |
| LOG_LEVEL               | 日志输出级别，可选值：debug/info/warn/error                          | 否       | info                            |
| OPENAI_MODEL            | OpenAI字幕生成模型，如whisper-1                                      | 否       | whisper-1                       |
| SUBTITLE_OUTPUT_PATH    | 容器内字幕文件输出目录路径                                            | 否       | /app/subtitles                  |
| WEBHOOK_ENDPOINT_PREFIX | webhook端点URL前缀（如"/hooks"），用于自定义路径                      | 否       | /                               |
| OPENAI_API_BASE_URL     | OpenAI API基础URL（用于代理或私有部署）                              | 否       | https://api.openai.com/v1       |

### Webhook服务配置

需在对应媒体服务器/工具中配置webhook，指向subgen容器的服务地址。以Plex为例：

1. 登录Plex Media Server管理界面，进入**设置 > 服务器 > 网络**。
2. 在**Webhooks**区域点击**添加webhook**，输入URL：`http://<subgen_container_ip>:<WEBHOOK_PORT>/plex`（如`http://192.168.1.100:8080/plex`）。
3. 保存配置后，Plex将在触发指定事件（如媒体添加）时向该URL发送请求，触发字幕生成。

其他服务（如Emby、Bazarr）配置步骤类似，webhook端点路径通常为`http://<ip>:<port>/<service_name>`（如Emby对应`/emby`，Tautulli对应`/tautulli`）。

## 捐赠支持

如该工具对您有帮助，欢迎通过[PayPal](https://www.paypal.com/donate/?hosted_button_id=SU4QQP6LH5PF6)进行捐赠支持。

## 项目地址

GitHub仓库：[https://github.com/McCloudS/subgen](https://github.com/McCloudS/subgen)（包含详细安装及配置说明）

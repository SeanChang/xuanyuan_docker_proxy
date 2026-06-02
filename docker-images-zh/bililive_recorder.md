---
image: bililive/recorder
description: "B站录播姬(BililiveRecorder)的Docker镜像，用于便捷录制B站直播内容，支持直播自动录制与管理，提供稳定可靠的录播解决方案。"
source: https://xuanyuan.cloud/zh/r/bililive/recorder
canonical: https://xuanyuan.cloud/zh/r/bililive/recorder
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bililive/recorder" title="bililive/recorder Docker 镜像中文简介、标签列表与拉取命令">bililive/recorder — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bililive/recorder" title="bililive/recorder Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bililive/recorder</a>

## 镜像概述
B站录播姬(BililiveRecorder)的Docker镜像，旨在提供便捷、稳定的B站直播录制功能。该镜像基于官方录播工具封装，可帮助用户轻松实现B站直播的自动录制、管理与存档，无需复杂环境配置。

- 官方网站：[https://rec.danmuji.org](https://rec.danmuji.org)
- 源码仓库：[https://github.com/BililiveRecorder/BililiveRecorder](https://github.com/BililiveRecorder/BililiveRecorder)

## 核心功能与特性
- **直播自动录制**：支持配置指定直播间，实现直播开播后自动启动录制，无需人工干预。
- **录播文件管理**：录播文件按规则命名并存储，便于后续查找与管理。
- **容器化部署优势**：环境隔离，减少系统依赖冲突，部署简单，跨平台兼容性好。
- **数据持久化**：通过Docker数据卷挂载，确保录播文件安全保存至本地。

## 使用场景
- B站UP主直播内容存档，用于后续剪辑或回放。
- 直播爱好者录制喜爱主播的直播内容，防止错过精彩片段。
- 机构或个人需要批量、定时录制指定B站直播的场景。

## 使用方法与配置说明### 基本运行命令
通过以下命令启动容器，需挂载本地目录以保存录播文件：
```bash
docker run -d \
  --name bililive-recorder \
  -v /本地目录路径/recordings:/app/Recordings \
  bililiverecorder/bililive-recorder
```
- `-d`：后台运行容器。
- `--name bililive-recorder`：指定容器名称，便于管理。
- `-v /本地目录路径/recordings:/app/Recordings`：挂载本地目录至容器内录播存储路径，确保录播文件持久化。

### 自定义配置（可选）
如需修改录播配置（如录制画质、文件格式等），可挂载配置目录：
```bash
docker run -d \
  --name bililive-recorder \
  -v /本地目录路径/recordings:/app/Recordings \
  -v /本地目录路径/config:/app/Config \
  bililiverecorder/bililive-recorder
```
配置文件位于容器内`/app/Config`目录，可通过本地挂载的配置目录进行自定义修改。

### 查看录播文件
录播文件默认保存在本地挂载的`/本地目录路径/recordings`目录下，可直接在该目录访问录制完成的视频文件。

## 官方资源
- 详细使用文档：[官方网站说明](https://rec.danmuji.org)
- 源码与更新日志：[GitHub仓库](https://github.com/BililiveRecorder/BililiveRecorder)

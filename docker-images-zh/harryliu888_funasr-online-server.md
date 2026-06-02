---
image: harryliu888/funasr-online-server
description: "FunASR模型的整理与集成Docker镜像，支持一键启动，实现高准确度的语音实时识别"
source: https://xuanyuan.cloud/zh/r/harryliu888/funasr-online-server
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[harryliu888/funasr-online-server](https://xuanyuan.cloud/zh/r/harryliu888/funasr-online-server)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# FunASR 语音识别Docker镜像

## 镜像概述
本Docker镜像整合了FunASR语音识别模型，提供一键启动功能，能够快速部署并实现高准确度的实时语音识别服务，简化语音转文字应用的开发与部署流程。

## 核心功能与特性
- **模型集成**：内置FunASR开源语音识别模型，无需额外配置模型文件
- **一键部署**：通过Docker容器化封装，支持快速启动，降低部署复杂度
- **实时识别**：支持实时语音输入处理，响应迅速
- **高准确度**：基于FunASR模型的优秀识别能力，确保识别结果准确性

## 使用场景与适用范围
- 语音转文字应用开发与测试
- 会议实时记录系统
- 实时字幕生成工具
- 语音交互类应用后端服务
- 语音数据处理与分析

## 使用方法与配置说明

### 前提条件
- 已安装Docker Engine（20.10+版本推荐）
- 具备网络连接（首次启动需拉取镜像）

### 快速启动命令
```bash
docker run -d --name funasr-asr -p 8000:8000 harry0703/audio-notes:latest
```

### 参数说明
- `-d`：后台运行容器
- `--name funasr-asr`：指定容器名称为funasr-asr
- `-p 8000:8000`：映射容器8000端口到主机8000端口，用于访问服务

### 服务访问
容器启动后，通过访问 `http://localhost:8000` 即可使用语音识别服务界面，具体操作方式可参考详细文档。

## 相关资源
- 项目地址：[https://github.com/harry0703/AudioNotes](https://github.com/harry0703/AudioNotes)
- FunASR开源仓库：[https://github.com/modelscope/FunASR](https://github.com/modelscope/FunASR)
- 详细使用文档：[https://harryai.cc/post/realtime-funasr/](https://harryai.cc/post/realtime-funasr/)

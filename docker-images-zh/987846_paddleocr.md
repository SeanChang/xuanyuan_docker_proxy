---
image: 987846/paddleocr
description: "百度PaddleOCR服务调用，端口8866，支持国产ARM架构与OCR-V4模型，镜像大小1.57G。"
source: https://xuanyuan.cloud/zh/r/987846/paddleocr
canonical: https://xuanyuan.cloud/zh/r/987846/paddleocr
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/987846/paddleocr" title="987846/paddleocr Docker 镜像中文简介、标签列表与拉取命令">987846/paddleocr 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PaddleOCR Docker镜像文档

## 镜像概述

本镜像基于百度PaddleOCR构建，提供便捷的OCR（光学字符识别）服务部署方案。通过容器化方式快速搭建OCR服务，支持多架构运行，适用于各类文字识别场景。

## 核心功能与特性

- **多模型支持**：提供超轻量OCR-V4模型与高精度OCR-V4模型
- **跨架构兼容**：支持arm64与amd64架构（部分版本仅支持amd64）
- **CPU运行**：所有版本均为CPU版本，无需GPU支持
- **便捷部署**：通过简单命令即可启动OCR服务，提供HTTP API接口

## 使用场景

- 文档扫描与文字提取
- 图片文字识别与信息提取
- 自动化办公中的文字识别需求
- 需要快速集成OCR能力的应用开发

## 使用方法

### 容器部署

通过以下命令创建并启动PaddleOCR容器：

```bash
docker run -d --name ppdocr -p 8866:8866 -d docker.xuanyuan.run/987846/paddleocr:latest
```

### API请求

使用curl发送POST请求调用OCR服务：

```bash
curl -H "Content-Type:application/json" -X POST --data "{\"images\": [\"Base64编码(需要删除 data:image/jpg;base64, ）\"]}" http://localhost:8866/predict/ocr_system
```

> 注意：请求中的图片需进行Base64编码，并删除编码字符串开头的"data:image/jpg;base64,"前缀

### Dockerfile获取

镜像Dockerfile源码可通过以下链接获取：  
[https://github.com/XimfengYao/docker-PaddleOCR](https://github.com/XimfengYao/docker-PaddleOCR)

## 版本说明

所有版本均为CPU版本，具体说明如下：

- `latest`：默认与`server-v2.7.1`版本保持一致
- `v2.7.1`：原始超轻量OCR-V4模型，支持arm64/amd64架构
- `server-v2.7.1`：原始高精度OCR-V4模型，支持arm64/amd64架构
- `v1.1`：原始高精度OCR-V2模型，仅支持amd64架构，建议升级至`server-v2.7.1`版本

## 使用建议

- **ARM架构设备**：由于计算能力限制，建议使用超轻量模型（`v2.7.1`版本）
- **高精度需求**：优先选择`server-v2.7.1`版本
- **版本选择**：对于amd64架构，推荐使用最新的`server-v2.7.1`版本以获得更好性能

## 支持与更新

本镜像持续更新中，如有使用问题可在GitHub仓库提交issue获取帮助。

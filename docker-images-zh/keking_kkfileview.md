---
image: keking/kkfileview
description: "kkFileView是文件文档在线预览解决方案，基本支持主流办公文档的在线预览，如doc、docx、xls、xlsx、ppt、pptx、pdf、txt、zip、rar、图片、视频、音频等。"
source: https://xuanyuan.cloud/zh/r/keking/kkfileview
canonical: https://xuanyuan.cloud/zh/r/keking/kkfileview
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/keking/kkfileview" title="keking/kkfileview Docker 镜像中文简介、标签列表与拉取命令">keking/kkfileview — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/keking/kkfileview" title="keking/kkfileview Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/keking/kkfileview</a>

# kkFileView 镜像文档

## 镜像概述

kkFileView是一款文件文档在线预览解决方案，旨在为各类系统提供便捷、高效的文件在线预览能力。通过独立部署的方式，可快速集成到现有业务系统中，满足多样化的文件预览需求。

## 核心功能与特性

### 1. 一键部署，快速接入
简化部署流程，支持Docker容器化部署，无需复杂配置即可快速启动服务，降低集成门槛。

### 2. 全面的文件格式支持
兼容主流办公文档格式，包括但不限于：
- 文字文档：doc、docx、txt
- 表格文档：xls、xlsx
- 演示文档：ppt、pptx
- 其他格式：pdf、zip、rar、图片（jpg、png等）、视频、音频等
同时支持新版Office文档的预览兼容性。

### 3. 灵活的预览模式
支持多种预览模式切换，可根据业务需求选择在线预览、下载、打印等功能，满足不同场景下的使用需求。

### 4. 微服务友好架构
采用独立部署模式，提供RESTful接口，可无缝集成到微服务架构中，支持跨系统、跨平台调用。

## 使用场景与适用范围

适用于需要文件在线预览功能的各类系统，包括但不限于：
- 企业内部文档管理系统
- 在线教育平台（课件预览）
- 协同办公系统（OA系统）
- 内容管理系统（CMS）
- 云存储服务

## 使用方法与配置说明

### 快速部署（Docker Run）

通过以下命令快速启动kkFileView服务：

```bash
docker run -d -p 8012:8012 --name kkfileview keking/kkfileview:latest
```

- `-p 8012:8012`：映射容器端口8012到宿主机端口8012
- `--name kkfileview`：指定容器名称为kkfileview
- `keking/kkfileview:latest`：使用最新版本镜像

### Docker Compose配置

创建`docker-compose.yml`文件，内容如下：

```yaml
version: '3'
services:
  kkfileview:
    image: keking/kkfileview:latest
    ports:
      - "8012:8012"
    restart: always
    container_name: kkfileview
```

执行以下命令启动服务：

```bash
docker-compose up -d
```

### 访问服务

服务启动后，通过浏览器访问 `http://localhost:8012` 即可打开kkFileView预览界面。

## 官方资源

- 官网：[https://kkfileview.keking.cn](https://kkfileview.keking.cn)
- 码云开源地址：[https://gitee.com/kekingcn/file-online-preview](https://gitee.com/kekingcn/file-online-preview)
- GitHub开源地址：[https://github.com/kekingcn/file-online-preview](https://github.com/kekingcn/file-online-preview)

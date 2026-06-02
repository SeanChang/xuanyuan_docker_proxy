---
image: demisto/python
description: "基于python:2.7的Demisto基础Python镜像，包含requests、olefile、pip和stix等基本Python库，适用于构建依赖这些特定库的Python 2.7应用环境。"
source: https://xuanyuan.cloud/zh/r/demisto/python
canonical: https://xuanyuan.cloud/zh/r/demisto/python
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/demisto/python" title="demisto/python Docker 镜像中文简介、标签列表与拉取命令">demisto/python — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/demisto/python" title="demisto/python Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/demisto/python</a>

# Demisto基础Python镜像文档

## 镜像概述
本镜像为Demisto的基础Python镜像，基于官方`python:2.7`镜像构建，预安装了requests、olefile、pip和stix等常用Python库，旨在提供一个开箱即用的Python 2.7运行环境，简化依赖这些库的应用构建流程。

## 核心功能与特性
- **基础镜像**：基于官方`python:2.7`镜像，继承其完整的Python 2.7运行环境
- **预安装库**：包含以下基本Python库：
  - `requests`：用于HTTP请求处理
  - `olefile`：用于OLE文件格式解析
  - `pip`：Python包管理工具
  - `stix`：结构化威胁信息表达式（STIX）相关处理库

## 适用场景
- 作为Demisto相关应用或组件的基础镜像
- 开发或运行依赖上述特定库的Python 2.7应用程序
- 需要快速搭建包含这些预安装库的Python 2.7开发/测试环境

## 使用方法

### 拉取镜像
（假设镜像托管于Demisto官方仓库，具体拉取命令需根据实际仓库地址调整）
```bash
docker pull demisto/python-base:latest
```

### 运行容器
通过以下命令启动一个交互式容器，可直接使用预安装的库：
```bash
docker run -it --rm demisto/python-base:latest python
```
进入Python交互环境后，可验证库是否安装：
```python
import requests
import olefile
import stix
print("requests version:", requests.__version__)
print("stix version:", stix.__version__)
```

### 作为基础镜像构建应用
在Dockerfile中使用本镜像作为基础，构建自定义应用：
```dockerfile
FROM demisto/python-base:latest

# 复制应用代码
COPY . /app
WORKDIR /app

# 安装额外依赖（如需）
RUN pip install additional-package

# 运行应用
CMD ["python", "app.py"]
```

## 注意事项
- 本镜像基于Python 2.7，该版本已停止官方维护，建议仅在有明确兼容性需求时使用
- 预安装库版本取决于基础构建时的版本，如需特定版本，可在基于本镜像构建时通过`pip install --upgrade`命令调整
- 镜像用途主要面向Demisto生态相关应用，也可用于其他需要相同依赖组合的Python 2.7环境构建

---
image: apache/tika
description: "Apache Tika Server的容器镜像，提供内容检测、元数据及文本提取的HTTP服务，便于便捷部署和集成到应用系统中。"
source: https://xuanyuan.cloud/zh/r/apache/tika
canonical: https://xuanyuan.cloud/zh/r/apache/tika
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/tika" title="apache/tika Docker 镜像中文简介、标签列表与拉取命令">apache/tika — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/tika" title="apache/tika Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/tika</a>

# Apache Tika Server Docker 镜像文档


## 镜像概述与主要用途

本镜像由 [Apache Tika](http://tika.apache.org) 开发团队维护，提供便捷的 Apache Tika Server 容器化部署方案。基于 Ubuntu 系统构建，内置对应版本的 Java 运行环境，可快速启动 Tika Server 实例，实现文档内容提取、格式解析等功能。镜像分为两个版本：  
- **基础版（minimal）**：仅包含 Apache Tika 核心依赖  
- **完整版（full）**：额外集成 GDAL 和 Tesseract OCR 解析器依赖，并预装英文、法语、德语、意大利语、西班牙语的语言包  


## 核心功能与特性

### 基础功能  
- **多格式文档解析**：支持解析上千种文件格式（如 PDF、Office、HTML 等），提取文本内容与元数据  
- **跨版本 Java 支持**：根据 Tika 版本自动适配 Java 环境（1.20 及以下用 Java 8，1.21-1.24.1 用 Java 11，1.27/2.0.0 前用 Java 14，新版本用 Java 16）  
- **轻量级部署**：基础版镜像体积较小，适合仅需核心解析能力的场景  

### 完整版增强特性  
- **OCR 支持**：集成 Tesseract OCR 引擎，可提取图片或扫描文档中的文本  
- **地理数据解析**：通过 GDAL 支持地理空间数据格式解析  
- **多语言扩展**：预装常用语言包，支持多语言文本识别  


## 使用场景与适用范围  

- **内容提取**：需从各类文档中批量提取文本内容的应用（如搜索引擎索引、内容管理系统）  
- **文档处理流水线**：作为微服务集成到文档转换、元数据提取流程中  
- **OCR 需求场景**：需处理扫描文档、图片中的文字识别（仅完整版支持）  
- **开发与测试环境**：快速搭建 Tika Server 进行功能验证  


## 使用方法与配置说明  

### 1. 拉取镜像  

通过 Docker Hub 拉取指定版本镜像：  
```bash
docker pull apache/tika:<version>
```  
- `<version>`：Tika Server 版本号，格式为 `x.y.z`（基础版）或 `x.y.z-full`（完整版），例如 `2.5.0` 或 `2.5.0-full`  


### 2. 运行容器  

#### 基础运行命令  
```bash
docker run -d -p 127.0.0.1:9998:9998 apache/tika:<version>
```  
- **参数说明**：  
  - `-d`：后台运行容器  
  - `-p 127.0.0.1:9998:9998`：将容器内 9998 端口映射到宿主机的 `127.0.0.1:9998`（仅本地访问）  

#### 公开网络访问（需谨慎）  
若确认容器运行在隔离网络中，可移除 `127.0.0.1` 绑定，允许外部访问：  
```bash
docker run -d -p 9998:9998 apache/tika:<version>
```  

#### Docker Compose 示例  
创建 `docker-compose.yml`：  
```yaml
version: '3'
services:
  tika-server:
    image: apache/tika:2.5.0-full  # 使用完整版示例
    ports:
      - "127.0.0.1:9998:9998"  # 仅本地访问
    restart: unless-stopped  # 容器退出时自动重启（非必要）
```  
启动服务：  
```bash
docker-compose up -d
```  


### 3. 构建自定义镜像  

从源码构建镜像：  
```bash
docker build -t 'apache/tika' github.com/apache/tika-docker
```  
构建后运行：  
```bash
docker run -d -p 127.0.0.1:9998:9998 apache/tika
```  


### 4. 自定义配置  

#### 扩展语言包  
完整版默认预装 5 种语言包，如需添加其他语言：  
1. 修改 Dockerfile 中的 `apt-get` 命令，添加目标语言包（如日语包 `tesseract-ocr-jpn`）  
2. 或通过 `ADD` 命令添加自定义语言包文件  


## 注意事项  

- **安全建议**：默认推荐绑定 `127.0.0.1`，避免 Docker 调整 iptables 后将 Tika Server 暴露至公网  
- **官方发布说明**：Docker 镜像中的二进制 JAR 源自 Apache Tika 官方分发站点，但 Apache 官方仅将源代码发布视为正式发布 artefact，详见 [发布分发政策](https://www.apache.org/dev/release-distribution.html)  


## 变更记录  

2.5.0.1 及后续版本的详细变更，参见 [CHANGES.md](https://github.com/apache/tika-docker/blob/master/CHANGES.md)  


## 更多信息  

- Apache Tika Server 文档：[Apache Tika JAXRS 文档](http://wiki.apache.org/tika/TikaJAXRS)  
- Apache Tika 官方网站：[http://tika.apache.org](http://tika.apache.org)  
- Apache 软件基金会：[http://apache.org](http://apache.org)  


## 贡献者  

GitHub 贡献者列表：[tika-docker 贡献者](https://github.com/apache/tika-docker/graphs/contributors)，包括 @grossws、@arjunyel、@mpdude、@laszlocsontosuw、@tballison 等  


## 免责声明  

本 Docker 镜像下载并使用 Apache Tika 团队在 Apache 软件基金会分发站点发布的二进制 JAR，但根据 Apache 发布政策，仅源代码发布为官方正式 artefact。详情参见 [Apache 发布分发政策](https://www.apache.org/dev/release-distribution.html)。

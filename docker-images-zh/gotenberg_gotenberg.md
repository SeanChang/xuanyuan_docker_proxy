---
image: gotenberg/gotenberg
description: "提供无缝PDF转换功能的容器化API Docker镜像。"
source: https://xuanyuan.cloud/zh/r/gotenberg/gotenberg
canonical: https://xuanyuan.cloud/zh/r/gotenberg/gotenberg
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [gotenberg/gotenberg — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/gotenberg/gotenberg)

含镜像标签、拉取命令、部署文档与相关推荐。

[gotenberg/gotenberg Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/gotenberg/gotenberg)

# Gotenberg Docker镜像文档


## 1. 镜像概述和主要用途

Gotenberg 是一个容器化工具，提供开发者友好的 API 接口，用于与 Chromium 和 LibreOffice 等强大工具交互，实现多种文档格式（如 HTML、Markdown、Word、Excel 等）到 PDF 的转换及其他文档处理功能。其核心价值在于简化文档转换流程，通过标准化 API 降低集成复杂度，支持多场景下的自动化文档处理需求。


## 2. 核心功能和特性

- **多格式转换**：支持 HTML、Markdown、Word（.docx）、Excel（.xlsx）、PowerPoint（.pptx）等多种输入格式，输出为 PDF 或其他指定格式。
- **强大依赖集成**：基于 Chromium（用于网页/HTML 渲染）和 LibreOffice（用于办公文档处理），确保转换质量和兼容性。
- **开发者友好 API**：提供简洁的 HTTP API 接口，支持同步/异步转换请求，易于集成到各类应用系统。
- **跨架构支持**：适配多种硬件架构，满足不同部署环境需求。
- **环境优化版本**：提供针对 Cloud Run、AWS Lambda 等云环境的优化镜像，适合Serverless场景部署。


## 3. 支持的架构

Gotenberg 镜像支持以下架构（详细信息请参考 [Docker 官方镜像架构说明](https://github.com/docker-library/official-images#architectures-other-than-amd64)）：  
`amd64`、`arm64v8`、`arm32v7`、`i386`、`ppc64le`


## 4. 镜像标签说明

镜像标签遵循语义化版本控制（SemVer，格式：MAJOR.MINOR.PATCH），具体标签及用途如下：

### 4.1 标准版本（Standard）
- 标签格式：`latest`（最新稳定版）、`8`（主版本号，如8.x.x系列）  
- 用途：通用场景部署，包含完整功能。  
- 版本查询：具体版本标签可参考 [Docker Hub 标签列表](https://hub.docker.com/repository/docker/gotenberg/gotenberg/tags)。

### 4.2 Cloud Run 优化版
- 标签格式：`latest-cloudrun`（最新Cloud Run优化版）、`8-cloudrun`（主版本号优化版）  
- 用途：针对 Google Cloud Run 环境优化，适配Serverless容器特性。  

### 4.3 AWS Lambda 优化版
- 标签格式：`latest-aws-lambda`（最新AWS Lambda优化版）、`8-aws-lambda`（主版本号优化版）  
- 用途：针对 AWS Lambda 环境优化，适合无服务器函数部署。  

### 4.4 开发版
- 标签格式：`edge`（主分支最新开发构建）、`edge-cloudrun`（Cloud Run优化开发版）  
- 用途：开发测试场景，包含未发布的新功能，稳定性不保证。  

### 4.5 快照版
- 仓库地址：[gotenberg/snapshot](https://hub.docker.com/r/gotenberg/snapshot)  
- 用途：包含特定开发阶段的快照构建，用于功能预览或问题修复验证。


## 5. 使用场景和适用范围

Gotenberg 适用于需要自动化文档处理的各类场景，包括但不限于：  
- **Web应用文档导出**：将动态生成的 HTML 页面（如报表、发票）转换为 PDF 供用户下载。  
- **办公文档批量处理**：企业内部系统中，将 Word/Excel 文档批量转换为 PDF 进行归档或分发。  
- **自动化工作流集成**：CI/CD 流程中生成文档报告，或与低代码平台（如 Zapier、Make）结合实现文档处理自动化。  
- **云原生部署**：在 Kubernetes、Cloud Run、AWS Lambda 等云环境中轻量级部署，满足弹性扩展需求。  


## 6. 使用方法和配置说明

### 6.1 快速启动（Docker Run）

#### 官方仓库镜像
```bash
docker run --rm -p 3000:3000 gotenberg/gotenberg:8
```

#### 赞助商仓库镜像（历史兼容）
由赞助商 TheCodingMachine 提供的镜像：
```bash
docker run --rm -p 3000:3000 thecodingmachine/gotenberg:8
```

启动后，API 服务将在本地 `http://localhost:3000` 可用，可通过 API 接口发起转换请求。


### 6.2 Docker Compose 部署示例

创建 `docker-compose.yml` 文件：
```yaml
version: '3.8'
services:
  gotenberg:
    image: gotenberg/gotenberg:8
    container_name: gotenberg
    ports:
      - "3000:3000"  # API服务端口
    restart: unless-stopped
    # 可选：挂载本地目录用于临时文件存储（如需持久化转换结果）
    volumes:
      - ./gotenberg-data:/tmp/gotenberg
    # 可选：设置环境变量（具体参数参考官方文档）
    environment:
      - LOG_LEVEL=info  # 日志级别：debug/info/warn/error
```

启动服务：
```bash
docker-compose up -d
```


### 6.3 配置参数说明

Gotenberg 的配置可通过环境变量或 API 请求参数实现，核心配置项如下（详细参数请参考 [官方文档](https://gotenberg.dev/docs/getting-started/introduction)）：  

| 环境变量         | 描述                     | 默认值       |
|------------------|--------------------------|--------------|
| `LOG_LEVEL`      | 日志输出级别             | `info`       |
| `API_TIMEOUT`    | API请求超时时间（秒）    | `30`         |
| `CHROMIUM_ARGS`  | Chromium额外启动参数     | 空           |
| `LIBREOFFICE_ARGS` | LibreOffice额外参数    | 空           |

**示例**：调整日志级别为 `debug` 并延长超时时间：
```bash
docker run --rm -p 3000:3000 \
  -e LOG_LEVEL=debug \
  -e API_TIMEOUT=60 \
  gotenberg/gotenberg:8
```


## 7. 获取帮助与反馈

- **社区支持**：通过 [Gotenberg 社区论坛](https://github.com/gotenberg/gotenberg/discussions/categories/q-a) 提问或交流经验。  
- **问题反馈**：若发现 Bug 或需功能改进，可在 [GitHub Issues](https://github.com/gotenberg/gotenberg/issues) 提交。  


## 8. 相关资源链接

- **源代码仓库**：[https://github.com/gotenberg/gotenberg](https://github.com/gotenberg/gotenberg)  
- **发布说明**：[https://github.com/gotenberg/gotenberg/releases](https://github.com/gotenberg/gotenberg/releases)  
- **官方文档**：[https://gotenberg.dev/docs/getting-started/introduction](https://gotenberg.dev/docs/getting-started/introduction)  
- **快照镜像仓库**：[https://hub.docker.com/r/gotenberg/snapshot](https://hub.docker.com/r/gotenberg/snapshot)

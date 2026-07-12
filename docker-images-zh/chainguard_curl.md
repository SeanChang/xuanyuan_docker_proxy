---
image: chainguard/curl
description: "使用Chainguard的低至零CVE容器镜像构建、交付和运行安全软件。"
source: https://xuanyuan.cloud/zh/r/chainguard/curl
canonical: https://xuanyuan.cloud/zh/r/chainguard/curl
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/chainguard/curl" title="chainguard/curl Docker 镜像中文简介、标签列表与拉取命令">chainguard/curl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Chainguard curl 镜像文档


## 镜像概述与主要用途  
Chainguard curl 镜像是一款专注于安全性的容器镜像，基于 Chainguard 低至零 CVE（常见漏洞和暴露）的容器技术构建，旨在为用户提供安全、可靠的 curl 工具运行环境。其核心用途是在构建、交付和运行软件的全流程中，通过最小化漏洞暴露风险，保障网络请求、数据传输等操作的安全性。


## 核心功能与特性  
### 1. 高安全性  
镜像经过严格优化，实现低至零 CVE 漏洞暴露，大幅降低安全风险，适用于安全敏感场景。  

### 2. 轻量级设计  
基于精简基础镜像构建，体积小巧，资源占用低，提升运行效率。  

### 3. 多源可用  
镜像同时发布于 Docker Hub 和 Chainguard 私有仓库（CGR），支持灵活选择拉取渠道。  

### 4. 扩展版本支持  
提供包括 FIPS 合规版本在内的多种衍生版本，满足特定安全标准需求（需参考版本目录获取）。  

### 5. 官方支持  
提供完善的安全公告（SBOMs）、漏洞跟踪及技术支持渠道，便于问题排查与维护。  


## 使用场景与适用范围  
### 适用场景  
- **高安全性网络请求**：需执行 HTTP/HTTPS 请求且对漏洞敏感的场景（如安全审计、合规检查）。  
- **CI/CD 流程集成**：在自动化流水线中作为轻量级网络工具，用于 API 测试、资源拉取等操作。  
- **安全环境文件传输**：在隔离或敏感环境中，通过 curl 安全下载文件、传输数据。  
- **自动化脚本工具**：作为容器化工具集成到脚本中，避免主机环境依赖及漏洞影响。  

### 适用范围  
- 安全敏感型应用开发与运维  
- 需满足低漏洞标准的企业级环境  
- 对容器镜像安全性有严格要求的 DevSecOps 流程  


## 使用方法与配置说明  

### 1. 下载镜像  
镜像可从 Docker Hub 或 Chainguard 私有仓库（CGR）拉取，推荐生产环境使用 CGR 以避免速率限制。  

#### 从 Docker Hub 拉取  
```bash
docker pull docker.xuanyuan.run/chainguard/curl:latest
```  

#### 从 Chainguard Registry 拉取  
```bash
docker pull cgr.dev/chainguard/curl:latest
```  


### 2. 运行容器示例  
#### 基本用法（执行 curl 命令）  
运行容器并执行单次网络请求（完成后自动清理容器）：  
```bash
docker run --rm docker.xuanyuan.run/chainguard/curl:latest https://example.com
```  

#### 带参数的请求示例  
发送 GET 请求并显示响应头：  
```bash
docker run --rm docker.xuanyuan.run/chainguard/curl:latest -I https://example.com
```  

#### 持久化配置（如需）  
若需保存 curl 配置（如自定义 CA 证书），可通过挂载目录实现：  
```bash
docker run --rm -v $(pwd)/certs:/etc/ssl/certs docker.xuanyuan.run/chainguard/curl:latest --cacert /etc/ssl/certs/custom-ca.pem https://secure.example.com
```  


### 3. 配置参数说明  
该镜像的核心功能通过 curl 命令行参数实现，具体配置可参考 [curl 官方文档](https://curl.se/docs/manpage.html)。常用参数示例：  
- `-X`：指定 HTTP 方法（GET/POST/PUT 等）  
- `-H`：添加请求头（如 `-H "Content-Type: application/json"`）  
- `-d`：发送 POST 数据  
- `-k`：忽略 SSL 证书验证（仅测试环境使用）  


## 附加信息  

### 版本与合规  
- **多版本支持**：包括 FIPS 合规版本、特定标签版本等，详见 [Chainguard 镜像版本目录](https://images.chainguard.dev/directory/image/curl/versions)。  
- **安全元数据**：可获取镜像的 SBOM（软件物料清单）、安全公告及漏洞信息，详见 [Chainguard 镜像目录](https://images.chainguard.dev/directory/image/curl)。  


### 支持与反馈  
- 速率限制问题：建议使用 CGR 仓库拉取镜像。  
- 技术支持：参考 [Chainguard 镜像 FAQ](https://edu.chainguard.dev/chainguard/chainguard-images/faq/) 或通过 [联系页面](https://www.chainguard.dev/contact) 获取帮助。  


更多详细文档可参考 [Chainguard 镜像目录概述](https://images.chainguard.dev/directory/image/curl/overview)。

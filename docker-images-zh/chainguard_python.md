---
image: chainguard/python
description: "Chainguard的低至零CVE漏洞容器镜像，用于构建、交付和运行安全软件。"
source: https://xuanyuan.cloud/zh/r/chainguard/python
canonical: https://xuanyuan.cloud/zh/r/chainguard/python
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [chainguard/python — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/chainguard/python)

含镜像标签、拉取命令、部署文档与相关推荐。

[chainguard/python Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/chainguard/python)

# Chainguard Python 容器镜像文档

![Chainguard Logo](https://images.chainguard.dev/logo.svg)


## 1. 镜像概述与主要用途

Chainguard Python 容器镜像是由 Chainguard 提供的安全强化版 Python 运行环境，旨在帮助用户构建、交付和运行具有低到零 CVE（常见漏洞和暴露）漏洞的安全软件。该镜像专注于最小化安全风险，为 Python 应用提供可靠的基础运行环境。


## 2. 核心功能与特性

- **低到零 CVE 漏洞**：镜像经过严格安全优化，显著降低漏洞暴露风险，提供接近零 CVE 的安全环境。  
- **多源可用**：同时发布于 Docker Hub 和 Chainguard Registry，满足不同环境的拉取需求。  
- **丰富版本支持**：提供包括 FIPS 合规版本在内的多种变体（FIPS 版本适用于需符合联邦信息处理标准的场景）。  
- **供应链安全增强**：支持软件物料清单（SBOMs），便于追踪和验证镜像组件，提升供应链透明度。  


## 3. 使用场景与适用范围

适用于对安全性要求较高的 Python 应用开发、测试与部署场景，尤其适合：  
- 企业级 Python 应用开发与生产环境部署  
- 金融、医疗、政务等对合规性和漏洞敏感的领域  
- 需要满足严格安全审计或供应链安全要求的场景  
- 希望降低基础镜像安全风险的开发团队  


## 4. 使用方法与配置说明

### 4.1 拉取镜像

#### 从 Docker Hub 拉取
```bash
docker pull chainguard/python:latest
```

#### 从 Chainguard Registry 拉取
若从 Docker Hub 拉取时遇到速率限制问题，可使用 Chainguard Registry：
```bash
docker pull cgr.dev/chainguard/python:latest
```


### 4.2 运行示例

拉取镜像后，可通过以下命令验证基本功能（如查看 Python 版本）：
```bash
docker run --rm chainguard/python:latest python --version
```


### 4.3 配置说明

当前镜像的详细配置参数（如环境变量、构建选项等）请参考官方文档。Chainguard 提供了针对不同使用场景的定制化指南，包括构建优化、安全加固等最佳实践。


## 5. 额外信息

### 5.1 版本与变体
- **标准版本**：默认标签（如 `latest`）提供通用 Python 环境。  
- **FIPS 合规版本**：适用于需要符合联邦信息处理标准（FIPS）的场景，可在[额外版本页面](https://images.chainguard.dev/directory/image/python/versions)获取。  


### 5.2 SBOMs 与安全信息
- **软件物料清单（SBOMs）**：镜像提供 SBOM 文件，可通过[SBOMs 页面](https://images.chainguard.dev/directory/image/python/sbom)查看，帮助验证组件完整性。  
- **安全 advisories**：最新安全公告与修复信息请访问[安全 advisories 页面](https://images.chainguard.dev/directory/image/python/advisories)。  
- **漏洞信息**：实时漏洞状态可通过[漏洞页面](https://images.chainguard.dev/directory/image/python/vulnerabilities)查询。  


### 5.3 支持与帮助
- 若遇到使用问题，可参考 [Chainguard 镜像 FAQ](https://edu.chainguard.dev/chainguard/chainguard-images/faq/)。  
- 如需进一步支持，请访问 [Chainguard 联系页面](https://www.chainguard.dev/contact)。  


## 6. 参考文档

- [Chainguard 镜像目录 - Python 镜像概述](https://images.chainguard.dev/directory/image/python/overview)  
- [Chainguard 镜像目录 - Python 镜像完整文档](https://images.chainguard.dev/directory/image/python)

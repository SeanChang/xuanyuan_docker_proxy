---
image: aquasec/trivy
description: "Trivy是一款一体化云原生安全扫描器"
source: https://xuanyuan.cloud/zh/r/aquasec/trivy
canonical: https://xuanyuan.cloud/zh/r/aquasec/trivy
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [aquasec/trivy — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/aquasec/trivy)

含镜像标签、拉取命令、部署文档与相关推荐。

[aquasec/trivy Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/aquasec/trivy)

# Trivy Docker镜像文档


## 镜像概述

Trivy 是一款一体化云原生安全扫描工具（all-in-one, cloud native security scanner），主要用于扫描代码项目和构建工件中的安全问题，包括漏洞、IaC（基础设施即代码）配置错误、密钥信息泄露等。作为轻量级且易于集成的工具，Trivy 适用于云原生环境下的安全检测需求，支持多种扫描目标和输出格式。


## 核心功能与特性

- **多类型安全问题检测**：支持扫描容器镜像、文件系统、代码仓库中的漏洞（CVE等）、IaC配置错误（如Terraform、Kubernetes清单）、敏感信息（密钥、令牌）等。
- **SBOM生成**：可生成软件物料清单（Software Bill of Materials），帮助梳理软件组件构成。
- **缓存机制**：支持重用已下载的漏洞数据库和拉取的镜像层，提升扫描效率。
- **云原生友好**：轻量级设计，易于集成到CI/CD管道、容器化环境中。
- **多目标支持**：支持容器镜像、本地目录、Git仓库、AWS ECR等多种扫描目标。


## 使用场景与适用范围

- **容器镜像安全扫描**：检测容器镜像中的系统漏洞、应用依赖漏洞。
- **IaC配置合规检查**：扫描本地目录或代码仓库中的Terraform、Kubernetes YAML等配置文件，识别安全风险（如权限过高、未加密存储等）。
- **SBOM生成与管理**：为软件项目生成标准化的组件清单，支持供应链安全追溯。
- **开发流程集成**：嵌入CI/CD管道，在代码提交、构建阶段自动执行安全扫描，提前发现风险。
- **云原生环境审计**：适用于Kubernetes集群、云服务配置等场景的安全合规检测。


## 使用方法与配置说明

### 基本使用示例

#### 1. 扫描容器镜像漏洞
扫描指定容器镜像（如`python:3.4-alpine`）中的漏洞：
```bash
docker run aquasec/trivy image python:3.4-alpine
```

#### 2. 扫描本地目录IaC配置错误
扫描本地目录（需挂载到容器内）的IaC配置文件（如Terraform、Kubernetes YAML）：
```bash
# 将当前目录（$PWD）挂载到容器内的/myapp目录，扫描该目录
docker run -v $PWD:/myapp aquasec/trivy config /myapp
```

#### 3. 生成软件物料清单（SBOM）
为指定镜像（如`alpine:3.15`）生成SBOM：
```bash
docker run aquasec/trivy sbom alpine:3.15
```


### 高级配置

#### 缓存目录挂载
为避免重复下载漏洞数据库和镜像层，可将主机的缓存目录挂载到容器内的`/root/.cache/`路径，提升扫描效率：
```bash
# 将主机的[本地缓存目录]挂载到容器缓存目录
docker run -v [本地缓存目录]:/root/.cache/ aquasec/trivy image python:3.4-alpine
```
> 示例：`-v $HOME/trivy-cache:/root/.cache/`（需确保主机目录存在）


#### Docker Socket挂载
若需扫描主机本地Docker守护进程中的镜像（而非远程仓库镜像），需挂载Docker socket以访问本地Docker服务：
```bash
# 挂载Docker socket和缓存目录
docker run -v /var/run/docker.sock:/var/run/docker.sock -v [本地缓存目录]:/root/.cache/ aquasec/trivy image my-local-image:latest
```


## 参考信息

- **维护者**：[Aqua Security](https://www.aquasec.com)
- **官方文档**：[Trivy 文档](https://aquasecurity.github.io/trivy)
- **帮助渠道**：[GitHub Discussions](https://github.com/aquasecurity/trivy/discussions)、[Slack](https://slack.aquasec.com)
- **源代码**：[Trivy GitHub仓库](https://github.com/aquasecurity/trivy)


## 许可信息

Trivy 基于 [Apache 2.0 许可](https://www.apache.org/licenses/LICENSE-2.0) 开源。

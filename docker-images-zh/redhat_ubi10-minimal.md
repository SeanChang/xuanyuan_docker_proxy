---
image: redhat/ubi10-minimal
description: "红帽通用基础镜像10最小化版本，为容器化应用提供精简、安全的基础环境，适用于构建轻量级生产级容器。"
source: https://xuanyuan.cloud/zh/r/redhat/ubi10-minimal
canonical: https://xuanyuan.cloud/zh/r/redhat/ubi10-minimal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redhat/ubi10-minimal" title="redhat/ubi10-minimal Docker 镜像中文简介、标签列表与拉取命令">redhat/ubi10-minimal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Red Hat Universal Base Image 10 Minimal


## 镜像概述与主要用途  
Red Hat Universal Base Image 10 Minimal（简称 UBI 10 Minimal）是一款经过精简优化的 Docker 基础镜像，采用 microdnf 作为轻量级包管理器。该镜像可自由再分发，由 Red Hat 官方团队维护并定期更新，核心用途是作为构建轻量级、安全的应用镜像的基础层，为上层应用提供最小化的运行环境。


## 核心功能与特性  
- **精简设计**：镜像体积经过深度优化，仅包含运行基础系统所需的核心组件，有效减少资源占用和潜在攻击面。  
- **microdnf 包管理器**：集成 microdnf（DNF 的轻量级实现），支持高效的软件包安装、更新与卸载，满足基础依赖管理需求。  
- **自由再分发**：无需额外许可，可基于该镜像构建并分发衍生应用镜像。  
- **官方维护与更新**：由 Red Hat 官方持续维护，定期推送安全补丁和版本更新，确保基础环境稳定性。  
- **订阅支持范围**：Red Hat 仅通过官方订阅服务对基于该镜像的 Red Hat 技术组件（如 RHEL 相关工具链）提供支持。  


## 使用场景与适用范围  
- **轻量级应用构建**：适用于对镜像体积有严格要求的场景，如边缘计算、微服务部署等，减少存储和网络传输开销。  
- **安全敏感环境**：精简的镜像结构降低了潜在漏洞暴露风险，适合需最小化攻击面的生产环境。  
- **CI/CD 流程基础**：作为持续集成/部署（CI/CD）流程中的基础镜像，确保构建环境一致性并加速构建过程。  
- **开发与测试环境**：为本地开发或测试提供统一的最小化基础运行时，减少环境差异导致的问题。  


## 使用方法与配置说明  

### 1. 拉取镜像  
UBI 10 Minimal 镜像可从 Red Hat 容器镜像仓库拉取：  
```bash
docker pull registry.access.redhat.com/ubi10/ubi-minimal:latest
```  
（注：如需指定版本，可替换 `latest` 为具体版本标签，如 `10.9-1014`）


### 2. 基本运行命令  
启动容器并进入交互式终端（用于环境验证或调试）：  
```bash
docker run -it --rm registry.access.redhat.com/ubi10/ubi-minimal:latest /bin/bash
```  
- `-it`：启用交互式终端  
- `--rm`：容器退出后自动删除  
- `/bin/bash`：启动 bash shell  


### 3. 包管理操作  
通过 microdnf 安装、更新或卸载软件包（需在容器内执行）：  

#### 安装软件包（如 `curl`）：  
```bash
microdnf install -y curl
```  
（`-y` 自动确认安装）

#### 更新所有已安装包：  
```bash
microdnf update -y
```

#### 卸载软件包：  
```bash
microdnf remove -y curl
```


### 4. Docker Compose 配置示例  
以下是基于 UBI 10 Minimal 构建应用的简单 `docker-compose.yml` 示例（以运行一个基础服务为例）：  
```yaml
version: '3.8'
services:
  app-base:
    image: registry.access.redhat.com/ubi10/ubi-minimal:latest
    container_name: ubi10-minimal-demo
    command: ["/bin/sh", "-c", "echo 'UBI 10 Minimal running'; sleep infinity"]
    restart: unless-stopped
```  
启动服务：  
```bash
docker-compose up -d
```


### 5. 注意事项  
- 该镜像无预设环境变量或配置文件，需根据应用需求通过 `Dockerfile` 或运行时命令自定义环境。  
- 如需使用 Red Hat 技术组件（如 OpenJDK、Node.js 等），建议通过 Red Hat 订阅获取官方支持的软件包。  
- 镜像定期更新，生产环境建议固定版本标签（而非 `latest`）以确保构建一致性。

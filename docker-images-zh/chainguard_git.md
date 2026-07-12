---
image: chainguard/git
description: "Chainguard低至零CVE容器镜像用于构建、交付和运行安全软件。"
source: https://xuanyuan.cloud/zh/r/chainguard/git
canonical: https://xuanyuan.cloud/zh/r/chainguard/git
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/chainguard/git" title="chainguard/git Docker 镜像中文简介、标签列表与拉取命令">chainguard/git 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Chainguard Git 容器镜像文档


## 镜像概述和主要用途

Chainguard Git 镜像是由 Chainguard 提供的 Git 容器化解决方案，旨在提供低至零 CVE（通用漏洞和暴露）漏洞的安全环境，支持 Git 版本控制操作。其核心用途是在安全要求高的场景中构建、交付和运行软件，通过最小化漏洞暴露风险，确保代码管理流程的安全性。


## 核心功能和特性

- **高安全性**：基于 Chainguard 安全构建流程，镜像具有低至零 CVE 漏洞，有效降低攻击面和安全风险。  
- **轻量级设计**：采用精简基础架构（通常基于 Distroless 或类似最小化系统），减少镜像体积和运行时依赖，提升部署效率。  
- **兼容性**：完整支持标准 Git 命令，与主流 Git 工作流无缝集成，可直接替换传统 Git 环境。  


## 使用场景和适用范围

- **CI/CD 流水线**：在持续集成/部署流程中安全执行代码拉取、版本校验、提交等 Git 操作。  
- **安全开发环境**：为开发团队提供隔离的 Git 运行环境，避免主机系统漏洞影响代码管理。  
- **高合规场景**：适用于金融、医疗、政府等对漏洞容忍度低、需满足严格合规要求的行业。  
- **临时 Git 操作**：快速启动容器执行临时任务（如克隆仓库、查看提交历史），无需在主机安装 Git。  


## 详细使用方法和配置说明

### 镜像拉取

该镜像发布于 Docker Hub 和 Chainguard Registry，可通过以下命令拉取：

#### 从 Docker Hub 拉取
```bash
docker pull docker.xuanyuan.run/chainguard/git:latest
```

#### 从 Chainguard Registry 拉取
```bash
docker pull cgr.dev/chainguard/git:latest
```


### 基本使用示例

#### 验证 Git 版本
运行容器并检查 Git 版本，确认镜像可用性：
```bash
docker run --rm docker.xuanyuan.run/chainguard/git:latest git --version
```

#### 克隆 Git 仓库
挂载本地目录以保存克隆结果，执行仓库克隆操作：
```bash
# 将当前目录挂载到容器的 /workspace，克隆仓库到本地
docker run --rm -v $(pwd):/workspace -w /workspace docker.xuanyuan.run/chainguard/git:latest git clone https://github.com/example/repo.git
```

#### 配置 Git 用户信息
通过环境变量传递 Git 配置（如用户名、邮箱），支持提交等需要身份信息的操作：
```bash
docker run --rm \
  -e "GIT_CONFIG_PARAMETERS=user.name='Your Name' user.email='your.email@example.com'" \
  -v $(pwd):/workspace -w /workspace \
  docker.xuanyuan.run/chainguard/git:latest \
  git commit -m "Initial commit"
```


### 高级配置：Docker Compose 示例

创建 `docker-compose.yml` 文件定义 Git 服务，便于集成到多容器环境：
```yaml
version: '3.8'
services:
  git:
    image: docker.xuanyuan.run/chainguard/git:latest
    volumes:
      - ./repo:/workspace  # 挂载本地目录到容器工作区
    working_dir: /workspace  # 设置工作目录
    environment:
      - GIT_CONFIG_PARAMETERS=user.name='CI Bot' user.email='ci@example.com'  # 配置默认用户信息
```

启动服务并执行 Git 命令：
```bash
# 克隆仓库到本地 ./repo 目录
docker-compose run --rm git git clone https://github.com/example/repo.git
```


### 版本与安全信息

- **版本支持**：包含 FIPS 合规版本等更多变体，详见 [Chainguard 镜像版本页](https://images.chainguard.dev/directory/image/git/versions)。  
- **SBOM 信息**：查看镜像软件物料清单（SBOM），访问 [Chainguard 镜像 SBOM 页](https://images.chainguard.dev/directory/image/git/sbom)。  
- **安全公告**：获取漏洞修复和安全更新，访问 [Chainguard 安全 advisories 页](https://images.chainguard.dev/directory/image/git/advisories)。  
- **漏洞详情**：查看已知漏洞和风险评估，访问 [Chainguard 漏洞页](https://images.chainguard.dev/directory/image/git/vulnerabilities)。  


### 支持与文档

- **官方文档**：完整概述请参考 [Chainguard 镜像目录 - Git 概述页](https://images.chainguard.dev/directory/image/git/overview)。  
- **常见问题**：访问 [Chainguard 镜像 FAQ](https://edu.chainguard.dev/chainguard/chainguard-images/faq/)。  
- **技术支持**：联系支持团队请访问 [Chainguard 联系页](https://www.chainguard.dev/contact)。

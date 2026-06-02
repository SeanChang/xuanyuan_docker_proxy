---
image: redhat/ubi9-init
description: "Red Hat通用基础镜像9初始化版，支持容器初始化功能，是构建需Init进程管理的企业级应用镜像的基础。"
source: https://xuanyuan.cloud/zh/r/redhat/ubi9-init
canonical: https://xuanyuan.cloud/zh/r/redhat/ubi9-init
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redhat/ubi9-init" title="redhat/ubi9-init Docker 镜像中文简介、标签列表与拉取命令">redhat/ubi9-init — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/redhat/ubi9-init" title="redhat/ubi9-init Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/redhat/ubi9-init</a>

# Red Hat Universal Base Image 9 Init

## 镜像概述和主要用途

Red Hat Universal Base Image 9 Init（以下简称UBI 9 Init）是由Red Hat官方维护的基础容器镜像，设计目标是在容器内以PID 1身份运行init系统，从而支持在单个容器中管理和运行多个服务进程。该镜像可自由再分发，Red Hat通过订阅为使用Red Hat技术的产品提供技术支持，并定期进行更新维护。

## 核心功能和特性

- **PID 1进程管理**：作为容器内首个进程（PID 1）运行init系统，负责容器内其他进程的启动、监控、信号处理及资源回收。
- **多服务支持**：提供基础架构支持在单个容器中运行多个协同服务，满足复杂应用场景下的多进程管理需求。
- **官方维护与更新**：由Red Hat专业团队维护，确保与Red Hat技术栈的兼容性，并定期推送安全更新和功能优化。
- **合规性与可分发性**：遵循开源许可协议，允许自由再分发，适合企业级生产环境使用。

## 使用场景和适用范围

### 典型使用场景
- 需在单个容器内运行多个依赖进程的应用（如Web服务+数据库代理、应用服务器+缓存服务等）。
- 传统应用容器化迁移场景中，依赖init系统进行进程生命周期管理的场景。
- 需要统一处理容器内进程信号（如SIGTERM、SIGKILL）及僵尸进程回收的场景。

### 适用范围
适用于需要在容器环境中实现多服务协同运行的用户，尤其适合基于Red Hat技术栈（如RHEL、OpenShift）构建应用的开发者和运维团队。

## 使用方法和配置说明

### Dockerfile构建示例

基于UBI 9 Init构建自定义镜像时，需通过Dockerfile添加服务依赖和配置，示例如下：

```dockerfile
# 基于UBI 9 Init镜像构建
FROM registry.access.redhat.com/ubi9/ubi-init:latest

# 安装并配置示例服务（以nginx和redis为例）
RUN dnf install -y nginx redis && \
    # 启用服务（通过systemd管理）
    systemctl enable nginx.service redis.service

# 暴露服务端口（根据实际服务调整）
EXPOSE 80 6379
```

### 运行命令示例（docker run）

使用`docker run`启动容器时，需显式指定init系统启动命令，确保以PID 1运行：

```bash
# 后台运行容器并指定init启动命令
docker run -d --name ubi9-multi-service \
  --privileged  # 如需systemd完整功能可添加（根据实际需求） \
  registry.access.redhat.com/ubi9/ubi-init:latest \
  /sbin/init
```

**参数说明**：  
- `--privileged`：可选参数，如容器内服务需要访问系统资源（如cgroup、设备）时添加。  
- `/sbin/init`：init系统入口命令，确保以PID 1启动并接管进程管理。

### 配置参数说明

UBI 9 Init镜像本身不提供预设配置参数，用户可通过以下方式自定义容器行为：  
- **服务配置**：通过Dockerfile添加systemd服务配置文件（如`/etc/systemd/system/`目录），或使用`systemctl enable`启用内置服务。  
- **启动参数**：通过`docker run`命令的命令参数传递init系统启动选项（如`/sbin/init --log-level=debug`）。  
- **环境变量**：在Dockerfile中通过`ENV`指令或`docker run -e`参数定义环境变量，供容器内服务使用（具体变量取决于运行的服务类型）。

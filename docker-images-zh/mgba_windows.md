---
image: mgba/windows
description: "用于Windows环境的自动化构建Docker镜像，集成编译工具链与CI/CD工具，支持.NET项目、桌面应用及服务端程序的源码拉取、编译、测试与打包全流程自动化。"
source: https://xuanyuan.cloud/zh/r/mgba/windows
canonical: https://xuanyuan.cloud/zh/r/mgba/windows
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mgba/windows" title="mgba/windows Docker 镜像中文简介、标签列表与拉取命令">mgba/windows — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mgba/windows" title="mgba/windows Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mgba/windows</a>

## Windows autobuilds 镜像文档

### 概述
Windows autobuilds 是一个专为Windows操作系统设计的Docker镜像，集成了自动化构建工具链，旨在简化Windows应用的CI/CD流程。该镜像预装了编译环境、测试框架及打包工具，支持从源码拉取、代码编译、自动化测试到产物打包的全流程自动化，适用于Windows桌面应用、服务端程序及.NET框架项目的构建场景。

### 核心特性
- **环境预置**：包含Visual Studio Build Tools、.NET SDK、PowerShell Core及Git等基础工具，无需额外配置即可启动构建任务。
- **多版本支持**：提供基于Windows Server Core LTSC及SAC版本的镜像标签，适配不同Windows环境需求。
- **灵活性**：支持自定义构建脚本，可通过环境变量或挂载外部配置文件调整构建流程。
- **兼容性**：兼容主流CI/CD平台（如Jenkins、GitHub Actions、GitLab CI），可无缝集成至现有流水线。

### 使用场景
- Windows桌面应用（如.NET WinForms/WPF项目）的自动化构建与测试。
- 服务端程序（如ASP.NET Core服务）的持续集成与部署包生成。
- 多版本Windows应用的并行构建验证（如Windows 10/11兼容性测试）。

### 部署示例
#### 1. 拉取镜像
```bash
docker pull [镜像仓库地址]/windows-autobuilds:ltsc2022  # 基于Windows Server 2022 LTSC版本
```

#### 2. 运行构建容器
```bash
docker run -d \
  --name win-build-agent \
  -v C:\local\src:/app/src \
  -v C:\local\output:/app/output \
  -e BUILD_SCRIPT=build.ps1 \
  -e GIT_REPO=https://github.com/example/win-app.git \
  [镜像仓库地址]/windows-autobuilds:ltsc2022
```
> 参数说明：
> - `-v`：挂载宿主机目录至容器内，分别用于源码输入（/app/src）和产物输出（/app/output）。
> - `-e BUILD_SCRIPT`：指定容器内执行的构建脚本路径（支持相对路径或绝对路径）。
> - `-e GIT_REPO`：可选参数，自动拉取远程Git仓库源码至/app/src目录。

#### 3. 查看构建日志
```bash
docker logs -f win-build-agent
```

### 注意事项
- 需在Windows容器模式下运行（通过`docker switch windows`切换Docker引擎模式）。
- 镜像标签需与宿主机Windows版本匹配（如ltsc2022对应Windows Server 2022/Windows 11）。
- 构建产物需通过挂载卷持久化，避免容器销毁后数据丢失。

### 版本标签
- `ltsc2022`：基于Windows Server 2022 LTSC，支持长期稳定构建需求。
- `ltsc2019`：基于Windows Server 2019 LTSC，兼容旧版本环境。

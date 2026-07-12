---
image: linuxserver/jenkins-builder
description: "用于LSIO CI流程的构建工具，作为CI过程的一部分运行，非公开使用。"
source: https://xuanyuan.cloud/zh/r/linuxserver/jenkins-builder
canonical: https://xuanyuan.cloud/zh/r/linuxserver/jenkins-builder
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/jenkins-builder" title="linuxserver/jenkins-builder Docker 镜像中文简介、标签列表与拉取命令">linuxserver/jenkins-builder 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/jenkins-builder

## 镜像概述和主要用途

`linuxserver/jenkins-builder` 是 LinuxServer.io (LSIO) 内部 CI 流程的专用组件，旨在支持 LSIO 项目的持续集成相关文件生成与处理。**该镜像非公开使用，仅用于 LSIO 内部开发流程**。


## 核心功能和特性

- **CI 文件生成**：可基于项目中的 `jenkins-vars.yml` 配置文件，自动生成或更新项目所需的 CI 相关文件（如 `README.md`、`Jenkinsfile`、issue 模板等），覆盖当前工作目录的现有文件。
- **本地构建支持**：支持从源码克隆并本地构建镜像，方便开发调试和功能定制。
- **跨架构构建**：通过 `lscr.io/linuxserver/qemu-static` 工具，可在 x86_64 硬件上构建 ARM 架构变体镜像，反之亦然。


## 使用场景和适用范围

- **LSIO 项目 CI 流程测试**：本地验证项目 CI 配置生成逻辑，确保 `jenkins-vars.yml` 配置正确生成所需 CI 文件。
- **镜像本地开发与定制**：修改镜像源码后，本地构建并测试自定义版本的 `jenkins-builder` 镜像。
- **跨架构镜像构建**：在不同架构硬件上（如 x86_64 构建 ARM 镜像）生成多架构支持的 `jenkins-builder` 变体。


## 详细使用方法和配置说明

### 针对本地项目运行

当需要测试项目中 CI 文件生成功能时，可在包含 `jenkins-vars.yml` 的项目目录中执行以下命令：

```bash
docker pull docker.xuanyuan.run/linuxserver/jenkins-builder:latest && \
docker run --rm \
  -v $(pwd):/tmp \  # 将当前目录挂载到容器内/tmp目录
  -e PUID=$(id -u) -e PGID=$(id -g) \  # 指定运行用户的UID和GID，避免权限问题
  lscr.io/linuxserver/jenkins-builder:latest && \
rm -rf .jenkins-external  # 清理临时目录
```

**说明**：  
执行后，容器会基于 `jenkins-vars.yml` 生成新的 CI 文件（如 `README.md`、`Jenkinsfile` 等），并覆盖当前工作目录中的现有文件。


### 本地构建镜像

如需修改镜像源码进行开发或定制，可按以下步骤本地构建镜像：

#### 1. 克隆源码仓库
```bash
git clone https://github.com/linuxserver/docker-jenkins-builder.git
cd docker-jenkins-builder
```

#### 2. 构建镜像
```bash
docker build \
  --no-cache \  # 不使用缓存，强制重新拉取依赖
  --pull \  # 拉取最新基础镜像
  -t lscr.io/linuxserver/jenkins-builder:latest .  # 镜像标签设为latest
```


### 跨架构构建

可通过 `lscr.io/linuxserver/qemu-static` 在 x86_64 硬件上构建 ARM 架构镜像（反之亦然）：

#### 1. 注册 QEMU 静态二进制文件
```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```

#### 2. 指定架构对应的 Dockerfile 构建
注册后，可通过 `-f` 参数指定架构对应的 Dockerfile（如 ARM64 架构使用 `Dockerfile.aarch64`）：
```bash
docker build \
  --no-cache \
  --pull \
  -f Dockerfile.aarch64 \  # 指定ARM64架构的Dockerfile
  -t lscr.io/linuxserver/jenkins-builder:latest .
```


### 环境变量说明

| 环境变量 | 说明 |
|----------|------|
| `PUID`   | 指定容器运行用户的 UID（用户 ID），用于文件权限映射，通常通过 `$(id -u)` 获取当前用户 UID。 |
| `PGID`   | 指定容器运行用户的 GID（组 ID），用于文件权限映射，通常通过 `$(id -g)` 获取当前用户 GID。 |


## 版本信息

以下版本信息仅用于该仓库的循环测试：  
- { date: "01.01.50:", desc: "I am the release message for this internal repo." }

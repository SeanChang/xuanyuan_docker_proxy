---
image: jenkins/agent
description: "提供Jenkins代理可执行文件agent.jar的基础镜像。"
source: https://xuanyuan.cloud/zh/r/jenkins/agent
canonical: https://xuanyuan.cloud/zh/r/jenkins/agent
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkins/agent" title="jenkins/agent Docker 镜像中文简介、标签列表与拉取命令">jenkins/agent — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jenkins/agent" title="jenkins/agent Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jenkins/agent</a>

# Jenkins Agent Docker 镜像文档

[![Join the chat at https://gitter.im/jenkinsci/docker](https://badges.gitter.im/jenkinsci/docker.svg)](https://gitter.im/jenkinsci/docker?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Docker Pulls](https://img.shields.io/docker/pulls/jenkins/agent.svg)](https://hub.docker.com/r/jenkins/agent/)
[![GitHub release](https://img.shields.io/github/release/jenkinsci/docker-agent.svg?label=changelog)](https://github.com/jenkinsci/docker-agent/releases/latest)


## 1. 镜像概述和主要用途

本镜像为 Docker 基础镜像，包含 Java 运行环境及 Jenkins 代理可执行文件（`agent.jar`）。该可执行文件基于 [Jenkins Remoting 库](https://github.com/jenkinsci/remoting) 实现。Java 版本因镜像类型和平台而异，详见下文 **镜像标签配置** 章节。

主要用途：
- 作为 [Docker Inbound Agent](https://github.com/jenkinsci/docker-agent/tree/master/README_inbound-agent.md) 镜像的基础镜像，支持外部启动容器并连接到 Jenkins 控制器
- 通过 Jenkins 控制器的 **通过在控制器上执行命令启动代理** 方式启动代理


## 2. 核心功能和特性

- **基础环境封装**：内置 Java 运行时和 `agent.jar`，无需额外配置即可作为 Jenkins 代理运行
- **跨平台支持**：提供 Linux 和 Windows 容器版本，适配不同操作系统环境
- **多版本兼容**：支持 Java 17（默认）和 Java 21，满足不同构建环境需求
- **多样化基础镜像**：Linux 版本基于 Debian、Alpine、Red Hat UBI9 等，Windows 版本基于 Nano Server 和 Server Core，可根据资源需求选择
- **工作目录支持**：从 Remoting 3.8 开始支持工作目录，默认提供日志记录并优化 JAR 缓存行为


## 3. 使用场景和适用范围

### 适用场景
- 作为 Jenkins 分布式构建环境的代理节点基础
- 需要快速部署轻量级 Jenkins 代理的场景
- 构建环境标准化，确保代理节点配置一致性
- 需在 Linux 或 Windows 容器中运行 Jenkins 任务的场景

### 适用范围
- Jenkins 控制器版本需兼容 Remoting 库版本（详见 [Remoting 发布日志](https://github.com/jenkinsci/remoting/releases)）
- 支持 Linux 容器（amd64/arm64 架构）和 Windows 容器（基于 Windows Server 2019/2022 等 LTSC 版本）
- 生产环境建议使用带版本号的镜像标签（如 `jenkins/agent:3.35-1-jdk17`）以确保稳定性


## 4. 使用方法和配置说明

### 4.1 基本使用

#### Linux 容器
通过控制器命令启动代理时，需先在 Jenkins 控制器中设置 **远程根目录** 为 `/home/jenkins/agent`，然后执行以下命令：

```sh
docker run -i --rm --name agent --init jenkins/agent java -jar /usr/share/jenkins/agent.jar
```

#### Windows 容器
对于 Windows 容器，需设置 **远程根目录** 为 `C:\Users\jenkins\Agent`，然后执行（以 `jdk17-windowsservercore-ltsc2019` 标签为例）：

```powershell
docker run -i --rm --name agent --init jenkins/agent:jdk17-windowsservercore-ltsc2019 java -jar C:/ProgramData/Jenkins/agent.jar
```

### 4.2 代理工作目录

自 [Remoting 3.8](https://github.com/jenkinsci/remoting/blob/master/CHANGELOG.md#38) 起支持工作目录，可默认启用日志记录并修改 JAR 缓存行为。

#### Linux 示例
```sh
docker run -i --rm --name agent1 --init -v agent1-workdir:/home/jenkins/agent jenkins/agent java -jar /usr/share/jenkins/agent.jar -workDir /home/jenkins/agent
```

#### Windows 容器示例
```powershell
docker run -i --rm --name agent1 --init -v agent1-workdir:C:/Users/jenkins/Work jenkins/agent:jdk17-windowsservercore-ltsc2019 java -jar C:/ProgramData/Jenkins/agent.jar -workDir C:/Users/jenkins/Work
```

### 4.3 时区配置

默认时区为 `Etc/UTC`，可通过以下方式自定义时区：

#### 方式 1：挂载主机时区文件
将主机的 `/etc/localtime` 和 `/etc/timezone` 文件挂载到容器：

```bash
docker run --rm --tty --interactive --entrypoint=date \
  --volume=/etc/localtime:/etc/localtime:ro \
  --volume=/etc/timezone:/etc/timezone:ro \
  jenkins/agent
```

#### 方式 2：设置 `TZ` 环境变量
通过 `TZ` 环境变量指定时区（[时区列表参考](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)）：

```bash
docker run --rm --tty --interactive --env TZ=Asia/Shanghai --entrypoint=date jenkins/agent
```

#### 方式 3：基于本镜像构建自定义镜像时配置
在 Dockerfile 中设置时区：

```dockerfile
FROM jenkins/agent as agent
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata
```


## 5. 镜像标签配置

镜像提供多种标签配置，适配不同 Java 版本、基础镜像和操作系统，具体如下：

### 5.1 Linux 镜像

#### Java 17（默认）
- **Debian（基于 `debian:trixie-${builddate}`）**
  ```
  jenkins/agent:latest              # 默认标签，等价于 trixie-jdk17
  jenkins/agent:jdk17               # 显式指定 Java 17
  jenkins/agent:trixie-jdk17        # Debian trixie + Java 17
  jenkins/agent:latest-trixie       # 最新 trixie 基础镜像
  jenkins/agent:latest-trixie-jdk17 # 最新 trixie + Java 17
  jenkins/agent:latest-jdk17        # 最新 Java 17
  ```

- **Alpine（基于 `alpine:${version}`，轻量级）**
  ```
  jenkins/agent:alpine              # Alpine 基础镜像（默认 Java 17）
  jenkins/agent:alpine-jdk17        # Alpine + Java 17
  jenkins/agent:latest-alpine       # 最新 Alpine 基础镜像
  jenkins/agent:latest-alpine-jdk17 # 最新 Alpine + Java 17
  ```

- **Red Hat UBI9（基于 Red Hat Universal Base Image 9）**
  ```
  jenkins/agent:rhel-ubi9           # RHEL UBI9 基础镜像（默认 Java 17）
  jenkins/agent:rhel-ubi9-jdk17     # RHEL UBI9 + Java 17
  jenkins/agent:latest-rhel-ubi9    # 最新 RHEL UBI9 基础镜像
  jenkins/agent:latest-rhel-ubi9-jdk17 # 最新 RHEL UBI9 + Java 17
  ```

#### Java 21
- **Debian（基于 `debian:trixie-${builddate}`）**
  ```
  jenkins/agent:trixie              # Debian trixie（默认 Java 21）
  jenkins/agent:trixie-jdk21        # Debian trixie + Java 21
  jenkins/agent:jdk21               # 显式指定 Java 21
  jenkins/agent:latest-trixie-jdk21 # 最新 trixie + Java 21
  ```

- **Alpine（基于 `alpine:${version}`）**
  ```
  jenkins/agent:alpine-jdk21        # Alpine + Java 21
  jenkins/agent:latest-alpine-jdk21 # 最新 Alpine + Java 21
  ```

- **Red Hat UBI9**
  ```
  jenkins/agent:rhel-ubi9-jdk21     # RHEL UBI9 + Java 21
  jenkins/agent:latest-rhel-ubi9-jdk21 # 最新 RHEL UBI9 + Java 21
  ```

### 5.2 Windows 镜像

#### Java 17（默认）
- **Nano Server**
  ```
  jenkins/agent:jdk17-nanoserver-1809      # Nano Server 1809 + Java 17
  jenkins/agent:jdk17-nanoserver-ltsc2019  # Nano Server LTSC2019 + Java 17
  jenkins/agent:jdk17-nanoserver-ltsc2022  # Nano Server LTSC2022 + Java 17
  ```

#### Java 21
- **Nano Server**
  ```
  jenkins/agent:jdk21-nanoserver-1809      # Nano Server 1809 + Java 21
  jenkins/agent:jdk21-nanoserver-ltsc2019  # Nano Server LTSC2019 + Java 21
  jenkins/agent:jdk21-nanoserver-ltsc2022  # Nano Server LTSC2022 + Java 21
  ```

- **Windows Server Core**
  ```
  jenkins/agent:jdk21-windowsservercore-1809    # Server Core 1809 + Java 21
  jenkins/agent:jdk21-windowsservercore-ltsc2019 # Server Core LTSC2019 + Java 21
  jenkins/agent:jdk21-windowsservercore-ltsc2022 # Server Core LTSC2022 + Java 21
  ```

> 所有 Linux 镜像的配置定义于 [docker-bake.hcl](https://github.com/jenkinsci/docker-agent/blob/master/docker-bake.hcl)。生产环境建议使用带版本号的标签（如 `jenkins/agent:3.35-1-jdk17`），标签完整列表见 [Docker Hub](https://hub.docker.com/r/jenkins/agent/tags)。


## 6. 更新日志

- **镜像版本**：`3.35-1` 及以上版本的更新日志见 [GitHub Releases](https://github.com/jenkinsci/docker-agent/releases)，更早版本无单独日志，可参考提交历史。
- **Remoting 库**：更新日志见 [Jenkins Remoting Releases](https://github.com/jenkinsci/remoting/releases)。

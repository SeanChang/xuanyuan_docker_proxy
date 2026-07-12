---
image: jetbrains/teamcity-minimal-agent
description: "TeamCity最小化构建代理，用于执行CI/CD流程中的构建任务，具备精简轻量特性，适用于基础构建环境。"
source: https://xuanyuan.cloud/zh/r/jetbrains/teamcity-minimal-agent
canonical: https://xuanyuan.cloud/zh/r/jetbrains/teamcity-minimal-agent
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jetbrains/teamcity-minimal-agent" title="jetbrains/teamcity-minimal-agent Docker 镜像中文简介、标签列表与拉取命令">jetbrains/teamcity-minimal-agent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TeamCity Minimal Build Agent

![official JetBrains project](https://jb.gg/badges/official-flat-square.svg)

这是官方的[JetBrains TeamCity](https://www.jetbrains.com/teamcity/)最小构建代理镜像。

<img src="https://raw.githubusercontent.com/JetBrains/teamcity-docker-images/master/docs/media/GitHub.png" height="20" align="center"/> 有关标签和组件的更多详情，请参见[此处](https://github.com/JetBrains/teamcity-docker-images/blob/master/context/generated/teamcity-minimal-agent.md)。

[TeamCity构建代理](https://www.jetbrains.com/help/teamcity/build-agent.html)连接到TeamCity服务器并生成实际的构建进程。您可以使用`jetbrains/teamcity-server`镜像运行TeamCity服务器。有关如何一次性启动TeamCity服务器和代理的方法，请参见这些[Docker Compose示例](https://github.com/JetBrains/teamcity-docker-samples)。

## 镜像概述和主要用途

该最小镜像仅包含TeamCity代理，不附带VCS客户端等任何工具。适用于简单构建任务，并可作为自定义镜像的基础。对于Java或.NET开发，建议使用默认构建代理镜像[jetbrains/teamcity-agent](https://hub.docker.com/r/jetbrains/teamcity-agent/)。

## 核心功能和特性

- **轻量级设计**：仅包含TeamCity代理核心组件，无额外开发工具（如VCS客户端）
- **灵活扩展**：可作为自定义镜像模板，按需添加构建工具
- **自动升级**：连接到升级后的服务器时，代理会自动完成升级
- **跨平台支持**：兼容Linux和Windows容器环境

## 使用场景和适用范围

### 适用场景
- 执行简单构建任务，无需依赖额外工具
- 作为基础镜像构建自定义代理（如添加特定构建工具）
- 资源受限环境中运行轻量级构建代理

### 不适用场景
- Java或.NET开发项目（推荐使用`jetbrains/teamcity-agent`）
- 需要VCS客户端（Git、SVN等）或构建工具（Maven、Gradle等）的复杂构建

## 使用方法和配置说明

### 拉取镜像

从Docker Hub仓库拉取TeamCity最小镜像：

```
jetbrains/teamcity-minimal-agent
```

### 启动容器

#### Linux容器

使用以下命令在Linux容器中启动TeamCity代理：

```bash
docker run -e SERVER_URL="<TeamCity服务器URL>" \
    -v <代理配置文件夹路径>:/data/teamcity_agent/conf \
    docker.xuanyuan.run/jetbrains/teamcity-minimal-agent
```

#### Windows容器

使用以下命令在Windows容器中启动：

```powershell
docker run -e SERVER_URL="<TeamCity服务器URL>" `
    -v <代理配置文件夹路径>:C:/BuildAgent/conf `
    jetbrains/teamcity-minimal-agent
```

参数说明：
- `<TeamCity服务器URL>`：代理可访问的TeamCity服务器完整URL（`localhost`通常不可用，因其指向容器内部）
- `<代理配置文件夹路径>`：主机上用于持久化代理配置（如授权信息）的目录路径，每个代理需映射独立文件夹

> 自2020.1版本起，TeamCity代理Docker镜像**在非root用户下运行**。有关受影响的用例，请参阅[升级说明](https://www.jetbrains.com/help/teamcity/upgrade-notes.html#UpgradeNotes-AgentDockerimagesrunundernon-rootuser)。

首次运行代理时，需通过TeamCity服务器UI授权：在浏览器中访问**未授权代理**页面。详情参见[TeamCity文档](https://www.jetbrains.com/help/teamcity/build-agent.html)。代理授权信息存储在配置文件夹中，使用相同配置文件夹启动新容器时，代理名称和授权状态将保留。

### 环境变量配置

| 环境变量       | 说明                                                                 | 是否必需 |
|----------------|----------------------------------------------------------------------|----------|
| SERVER_URL     | 代理连接的TeamCity服务器完整URL（如`http://teamcity-server:8111`）   | 是       |
| AGENT_NAME     | 代理在TeamCity UI中显示的名称，未设置则自动生成                       | 否       |
| AGENT_TOKEN    | 代理授权令牌，未设置需通过TeamCity UI手动授权                         | 否       |
| OWN_ADDRESS    | Linux容器专用，代理绑定的IP地址，未设置则自动检测                     | 否       |
| OWN_PORT       | Linux容器专用，代理绑定端口（默认9090）                              | 否       |

### Windows容器限制

Windows容器的已知问题详情，请参见[TeamCity文档](https://www.jetbrains.com/help/teamcity/known-issues.html#KnownIssues-WindowsDockerContainers)。

## 自定义镜像

通过以下步骤基于该镜像创建自定义代理：

1. 启动基础容器并命名：

```bash
docker run -e SERVER_URL="<TeamCity服务器URL>" \
    -v <代理配置文件夹路径>:/data/teamcity_agent/conf \
    --name="my-custom-agent" \
    docker.xuanyuan.run/jetbrains/teamcity-minimal-agent
```

2. 进入容器修改配置或安装工具：

```bash
docker exec -it my-custom-agent bash
```

3. 提交容器为新镜像：

```bash
docker commit my-custom-agent <目标镜像仓库地址>
```

## 许可证

本镜像遵循[TeamCity许可证](https://www.jetbrains.com/teamcity/buy/license.html)。TeamCity可永久免费使用，限制为100个构建配置（任务）和3个代理。[许可详情](https://www.jetbrains.com/help/teamcity/licensing-policy.html)。

## 反馈

报告问题或建议至官方TeamCity[issue跟踪器](https://youtrack.jetbrains.com/issues/TW)。

## 其他TeamCity镜像

- [TeamCity Server](https://hub.docker.com/r/jetbrains/teamcity-server/)
- [默认构建代理](https://hub.docker.com/r/jetbrains/teamcity-agent/)

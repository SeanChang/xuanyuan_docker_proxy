---
image: jetbrains/teamcity-agent
description: "JetBrains官方TeamCity构建代理镜像，用于连接TeamCity服务器并执行构建任务，基于minimal-agent扩展，包含Git/Mercurial客户端检出、更多构建工具及Docker支持。"
source: https://xuanyuan.cloud/zh/r/jetbrains/teamcity-agent
canonical: https://xuanyuan.cloud/zh/r/jetbrains/teamcity-agent
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jetbrains/teamcity-agent" title="jetbrains/teamcity-agent Docker 镜像中文简介、标签列表与拉取命令">jetbrains/teamcity-agent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## TeamCity 构建代理

![official JetBrains project](https://jb.gg/badges/official-flat-square.svg)

这是官方[JetBrains TeamCity](https://www.jetbrains.com/teamcity/)构建代理镜像。

<img src="https://raw.githubusercontent.com/JetBrains/teamcity-docker-images/master/docs/media/GitHub.png" height="20" align="center"/> 有关标签和组件的更多详情，请参见[此处](https://github.com/JetBrains/teamcity-docker-images/blob/master/context/generated/teamcity-agent.md)。

[TeamCity 构建代理](https://www.jetbrains.com/help/teamcity/build-agent.html)用于连接TeamCity服务器并生成实际构建进程。可使用`jetbrains/teamcity-server`镜像运行TeamCity服务器。如需了解如何一次性启动服务器和代理，请参见[Docker Compose示例](https://github.com/JetBrains/teamcity-docker-samples)。

本镜像提供适用于Java开发的TeamCity代理，基于`jetbrains/teamcity-minimal-agent`扩展，具备更多优势，例如：
- 支持Git或Mercurial的客户端检出
- 更多预安装构建工具
- Linux环境下的"docker-in-docker"支持

## 使用方法

### 拉取镜像
从Docker Hub拉取TeamCity代理镜像：
```
jetbrains/teamcity-agent
```

### 启动容器

#### Linux容器
```
docker run -e SERVER_URL="<TeamCity服务器URL>" \
    -v <代理配置目录路径>:/data/teamcity_agent/conf  \
    docker.xuanyuan.run/jetbrains/teamcity-agent
```

#### Windows容器
```
docker run -e SERVER_URL="<TeamCity服务器URL>"
    -v <代理配置目录路径>:C:/BuildAgent/conf
    jetbrains/teamcity-agent
```

其中，`<TeamCity服务器URL>`是代理可访问的服务器完整URL。注意："localhost"通常不可用，因容器内的"localhost"指向容器自身。

## 环境变量
- `SERVER_URL`：代理连接的TeamCity服务器URL（必填）
- `AGENT_NAME`：（可选）代理在TeamCity UI中的名称，未设置则自动生成
- `AGENT_TOKEN`：（可选）代理授权令牌，未设置时需通过TeamCity UI授权
- `OWN_ADDRESS`：（可选，仅Linux）代理绑定的IP地址，自动检测
- `OWN_PORT`：（可选，仅Linux）代理绑定的端口，默认9090
- `DOCKER_IN_DOCKER`：（可选，仅Linux）启用容器内Docker服务

## 持久化Checkout目录
重启代理容器后默认会重新检出构建源。如需避免此情况，需挂载以下目录以持久化代理状态：
1. 已检出的源码目录：`-v /opt/buildagent/work:/opt/buildagent/work`
2. 代理内部缓存：`-v /opt/buildagent/system:/opt/buildagent/system`

除非通过`docker.sock`使用Docker Wrapper，否则可自定义主机上的路径前缀。

## 运行需Docker的构建
如需在构建中使用Docker守护进程，有两种方案：使用主机Docker（docker-out-of-docker）或在容器内启动Docker（docker-in-docker）。**注意：两种方案均需信任构建任务，因构建可能获取主机root权限**，详情参见[OWASP Docker安全指南](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)及[TeamCity安全说明](https://www.jetbrains.com/help/teamcity/security-notes.html)。

### 使用主机Docker
通过挂载主机Docker套接字实现，共享主机Docker缓存，但存在安全风险：
```
docker run -e SERVER_URL="<TeamCity服务器URL>" \
    -u 0 \
    -v <代理配置目录路径>:/data/teamcity_agent/conf \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /opt/buildagent/work:/opt/buildagent/work \
    -v /opt/buildagent/temp:/opt/buildagent/temp \
    -v /opt/buildagent/tools:/opt/buildagent/tools \
    -v /opt/buildagent/plugins:/opt/buildagent/plugins \
    -v /opt/buildagent/system:/opt/buildagent/system \
    docker.xuanyuan.run/jetbrains/teamcity-agent
```

`-v /opt/buildagent/*`挂载是使用[Docker Wrapper](https://www.jetbrains.com/help/teamcity/docker-wrapper.html)的必要条件。若省略，则Docker Wrapper不可用，但可运行多个代理（需指定不同配置目录）。

### 在容器内启动Docker
容器内启动独立Docker守护进程，需使用`--privileged`标志及带`-linux-sudo`后缀的镜像：
```
docker run -e SERVER_URL="<TeamCity服务器URL>" \
    -u 0 \
    -v <代理配置目录路径>:/data/teamcity_agent/conf \
    -v docker_volumes:/var/lib/docker \
    --privileged -e DOCKER_IN_DOCKER=start \
    docker.xuanyuan.run/jetbrains/teamcity-agent:2021.1.1-linux-sudo
```

`-v docker_volumes:/var/lib/docker`用于解决aufs文件系统及Windows主机启动时的问题（[相关issue](https://youtrack.jetbrains.com/issue/TW-52939)）。多代理需指定不同卷，如`agent1_volumes:/var/lib/docker`。

## Windows容器限制
Windows容器的已知问题详情参见[TeamCity文档](https://www.jetbrains.com/help/teamcity/known-issues.html#KnownIssues-WindowsDockerContainers)。

## 自定义镜像
通过以下步骤自定义镜像：
1. 启动基础代理容器：
```
docker run -e SERVER_URL="<TeamCity服务器URL>" \
    -v <代理配置目录路径>:/data/teamcity_agent/conf \
    --name="my-customized-agent" \
    docker.xuanyuan.run/jetbrains/teamcity-minimal-agent
```
2. 进入容器：
```
docker exec -it my-customized-agent bash
```
3. 进行所需修改后退出，提交为新镜像：
```
docker commit my-customized-agent <目标镜像仓库>
```

## 许可证与反馈
本镜像遵循[TeamCity许可证](https://www.jetbrains.com/teamcity/buy/license.html)，免费版支持100个构建配置和3个代理，详情参见[许可政策](https://www.jetbrains.com/help/teamcity/licensing-policy.html)。

问题反馈请提交至官方[issue跟踪器](https://youtrack.jetbrains.com/issues/TW)。

## 其他TeamCity镜像
- [TeamCity Server](https://hub.docker.com/r/jetbrains/teamcity-server/)
- [Minimal Build Agent](https://hub.docker.com/r/jetbrains/teamcity-minimal-agent/)

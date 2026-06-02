---
image: library/eclipse-temurin
description: "Eclipse Temurin构建的OpenJDK二进制文件官方镜像，隶属于Eclipse Adoptium项目，提供高质量、免费且合规的OpenJDK发行版，适用于开发、测试及生产环境，确保良好的兼容性与稳定性，是企业级应用开发的可靠选择。"
source: https://xuanyuan.cloud/zh/r/library/eclipse-temurin
canonical: https://xuanyuan.cloud/zh/r/library/eclipse-temurin
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [library/eclipse-temurin — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/eclipse-temurin)

含镜像标签、拉取命令、部署文档与相关推荐。

[library/eclipse-temurin Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/library/eclipse-temurin)

# Eclipse Temurin Docker 镜像使用指南


## 快速参考

### 维护者  
[Adoptium]([])  


### 获取帮助  
[Adoptium Slack]([])；[Adoptium 支持页面]([])  


## 支持的标签及对应 Dockerfile 链接  

**说明**：由于镜像描述长度超过 Docker Hub 25000 字符限制，"支持的标签"列表已精简。完整列表请参见：  
[GitHub 文档中的“支持的标签及对应 Dockerfile 链接”]([])  


## 快速参考（续）

### 问题反馈  
[GitHub Issues]([])；关于 Eclipse Temurin 构建的质量、路线图和支持级别，可参考 [Adoptium 支持页面]([])。非 Temurin 本身的漏洞（如 Ubuntu 系统漏洞）需直接反馈给对应项目。  


### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])、[`windows-amd64`]([])  


### 镜像 artifact 详情  
[repo-info 仓库的 `repos/eclipse-temurin/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
[official-images 仓库的 `library/eclipse-temurin` 标签]([])  
[official-images 仓库的 `library/eclipse-temurin` 文件]([])（[历史记录]([])）  


### 描述来源  
[docs 仓库的 `eclipse-temurin/` 目录]([])（[历史记录]([])）  


## 概述  

本仓库中的镜像包含由 Eclipse Temurin 构建的 OpenJDK 二进制文件。  


## 什么是 Eclipse Temurin？  

Eclipse Temurin 项目提供代码和流程，支持构建高性能、企业级、跨平台、开源许可且通过 Java SE TCK 测试的运行时二进制文件及相关技术，供 Java 生态系统通用。  

![logo]([])  


## 是否提供 JRE（Java 运行时环境）镜像？  

所有版本的 Eclipse Temurin 均提供 JRE 镜像，但建议使用 `jlink` 生成自定义 JRE 类运行时（见下方使用示例）。  


## 如何添加内部 CA 证书到信任库？  

除 Windows 镜像外，所有镜像均可添加 CA 证书。证书格式需符合基础镜像 OS 的要求，PEM 格式且扩展名为 `.crt` 是通用选择。  

操作步骤：  
1. 将 CA 证书放入容器内 `/certificates` 目录（可通过挂载卷实现）；  
2. 设置环境变量 `USE_SYSTEM_CA_CERTS`（任意值）以启用证书处理（若自定义入口脚本，需调用 `/__cacert_entrypoint.sh`）。  

**Docker CLI 示例**：  
```console
$ docker run -v $(pwd)/certs:/certificates/ -e USE_SYSTEM_CA_CERTS=1 eclipse-temurin:21
```

此时，证书会添加到 JVM 信任库和系统 CA 存储（供 `curl` 等工具使用）。但在默认限制环境（如 Red Hat OpenShift）中存在以下差异：  

- **非 root 用户运行**：JVM 和系统信任库不可写，系统 CA 存储不更新，但会为 JVM 创建独立信任库，证书添加至此，并通过 `JAVA_TOOL_OPTIONS` 自动切换 JVM 使用新信任库。自定义入口脚本需手动指定新信任库路径（通过 `JRE_CACERTS_PATH` 环境变量获取）。  

- **只读文件系统**：与非 root 用户限制相同，需在 `/tmp` 挂载可写卷以创建新信任库。  


## 如何使用镜像  

### 基础用法（运行 jar 文件）  
**Dockerfile**：  
```dockerfile
FROM eclipse-temurin:21
RUN mkdir /opt/app
COPY japp.jar /opt/app
CMD ["java", "-jar", "/opt/app/japp.jar"]
```

**构建并运行**：  
```console
docker build -t japp .
docker run -it --rm japp
```


### 使用自定义基础镜像  
若需基于其他发行版构建，可复制 JDK：  
```dockerfile
# 示例
FROM <base image>
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:21 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
```


### 用 jlink 创建自定义 JRE（OpenJDK 21+）  
**多阶段构建示例**：  
```dockerfile
# 阶段 1：构建 JRE
FROM eclipse-temurin:21 as jre-build
RUN $JAVA_HOME/bin/jlink \
         --add-modules java.base \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

# 阶段 2：部署应用
FROM debian:buster-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME

RUN mkdir /opt/app
COPY japp.jar /opt/app
CMD ["java", "-jar", "/opt/app/japp.jar"]
```


### 挂载主机 jar 文件  
将主机 jar 目录挂载到容器：  

**Dockerfile**：  
```dockerfile
FROM eclipse-temurin:21.0.2_13-jdk
CMD ["java", "-jar", "/opt/app/japp.jar"]
```

**构建并运行**：  
```console
docker build -t japp .
docker run -it -v /path/on/host/system/jars:/opt/app japp
```


## 镜像变体  

### `eclipse-temurin:<version>`  
默认镜像，适用于大多数场景（临时容器或基础镜像）。标签中含 `jammy`/`noble` 等 Ubuntu 发行版代号，指定基础系统版本，安装额外包时建议显式指定以减少兼容性问题。  


### `eclipse-temurin:<version>-alpine`  
基于 [Alpine Linux]([])，体积极小（~5MB 基础镜像），适合追求最小镜像体积的场景。注意：使用 `musl libc` 而非 `glibc`，部分依赖 libc 的软件可能存在兼容性问题。  


### `eclipse-temurin:<version>-windowsservercore`  
基于 Windows Server Core，仅支持 Windows 环境（如 Windows 10 专业版/企业版、Windows Server 2016+）。  


## 许可证  

- **Dockerfile 及脚本**：[Apache License 2.0]([])  
- **镜像中软件**：  
  - OpenJDK：GNU GPL v2 带 Classpath Exception  
  - 其他软件（如基础系统的 Bash 等）可能涉及其他许可证，需用户自行确保合规。  

更多许可证信息可参考 [repo-info 仓库的 `eclipse-temurin/` 目录]([])。  

使用前请确保遵守所有包含软件的许可证要求。

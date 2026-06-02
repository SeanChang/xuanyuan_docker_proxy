---
image: library/maven
description: "Apache Maven是一款基于项目对象模型（POM）的软件项目管理与理解工具，主要用于自动化项目构建流程、统一管理项目依赖、整合项目信息（如文档、报告等），并通过标准化的项目结构和生命周期管理，帮助开发团队提高协作效率、简化构建过程，确保项目开发的一致性与可重复性。"
source: https://xuanyuan.cloud/zh/r/library/maven
canonical: https://xuanyuan.cloud/zh/r/library/maven
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/maven" title="library/maven Docker 镜像中文简介、标签列表与拉取命令">library/maven — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/maven" title="library/maven Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/maven</a>

# Maven Docker镜像使用指南


## 快速参考

### 维护者  
[Carlos Sanchez]([])（GitHub仓库）


### 获取帮助渠道  
- [Docker社区Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


### 提交issue地址  
[[]]([])  


### 支持的架构  
（更多信息见[官方说明]([])）  
`amd64`、`arm32v7`、`arm64v8`、`ppc64le`、`riscv64`、`s390x`  


### 镜像详情  
[repo-info仓库的`repos/maven/`目录]([])（含镜像元数据、传输大小等，[历史记录]([])）  


### 镜像更新  
- [official-images仓库的`library/maven`标签]([])  
- [official-images仓库的`library/maven`文件]([])（[历史记录]([])）  


### 描述来源  
[docs仓库的`maven/`目录]([])（[历史记录]([])）  


## 支持的标签及对应Dockerfile链接  

### 基于Eclipse Temurin JDK的镜像  
#### JDK 8  
- Alpine基础镜像：`3.9.11-eclipse-temurin-8-alpine`、`3.9-eclipse-temurin-8-alpine`、`3-eclipse-temurin-8-alpine`  
  [Dockerfile]([])  
- Noble基础镜像：`3.9.11-eclipse-temurin-8-noble`、`3.9.11-eclipse-temurin-8`、`3.9-eclipse-temurin-8-noble`、`3.9-eclipse-temurin-8`、`3-eclipse-temurin-8-noble`、`3-eclipse-temurin-8`  
  [Dockerfile]([])  


#### JDK 11  
- Alpine基础镜像：`3.9.11-eclipse-temurin-11-alpine`、`3.9-eclipse-temurin-11-alpine`、`3-eclipse-temurin-11-alpine`  
  [Dockerfile]([])  
- Noble基础镜像：`3.9.11-eclipse-temurin-11-noble`、`3.9.11-eclipse-temurin-11`、`3.9-eclipse-temurin-11-noble`、`3.9-eclipse-temurin-11`、`3-eclipse-temurin-11-noble`、`3-eclipse-temurin-11`  
  [Dockerfile]([])  


#### JDK 17  
- Alpine基础镜像（Maven 3）：`3.9.11-eclipse-temurin-17-alpine`、`3.9-eclipse-temurin-17-alpine`、`3-eclipse-temurin-17-alpine`  
  [Dockerfile]([])  
- Alpine基础镜像（Maven 4 RC）：`4.0.0-rc-4-eclipse-temurin-17-alpine`  
  [Dockerfile]([])  
- Noble基础镜像（Maven 3）：`3.9.11-eclipse-temurin-17-noble`、`3.9.11-eclipse-temurin-17`、`3.9-eclipse-temurin-17-noble`、`3.9-eclipse-temurin-17`、`3-eclipse-temurin-17-noble`、`3-eclipse-temurin-17`  
  [Dockerfile]([])  
- Noble基础镜像（Maven 4 RC）：`4.0.0-rc-4-eclipse-temurin-17-noble`、`4.0.0-rc-4-eclipse-temurin-17`  
  [Dockerfile]([])  


#### JDK 21  
- Alpine基础镜像（Maven 3）：`3.9.11-eclipse-temurin-21-alpine`、`3.9-eclipse-temurin-21-alpine`、`3-eclipse-temurin-21-alpine`  
  [Dockerfile]([])  
- Alpine基础镜像（Maven 4 RC）：`4.0.0-rc-4-eclipse-temurin-21-alpine`  
  [Dockerfile]([])  
- Noble基础镜像（Maven 3）：`3.9.11-eclipse-temurin-21-noble`、`3.9.11-eclipse-temurin-21`、`3.9-eclipse-temurin-21-noble`、`3.9-eclipse-temurin-21`、`3-eclipse-temurin-21-noble`、`3-eclipse-temurin-21`  
  [Dockerfile]([])  
- Noble基础镜像（Maven 4 RC）：`4.0.0-rc-4-eclipse-temurin-21-noble`、`4.0.0-rc-4-eclipse-temurin-21`  
  [Dockerfile]([])  


#### JDK 25（最新稳定版）  
- Alpine基础镜像（Maven 3）：`3.9.11-eclipse-temurin-25-alpine`、`3.9-eclipse-temurin-25-alpine`、`3-eclipse-temurin-25-alpine`  
  [Dockerfile]([])  
- Alpine基础镜像（Maven 4 RC）：`4.0.0-rc-4-eclipse-temurin-25-alpine`  
  [Dockerfile]([])  
- Noble基础镜像（Maven 3，含默认标签）：`3.9.11-eclipse-temurin-25-noble`、`3.9.11`、`3.9.11-eclipse-temurin`、`3.9.11-eclipse-temurin-25`、`3.9-eclipse-temurin-25-noble`、`3.9`、`3.9-eclipse-temurin`、`3.9-eclipse-temurin-25`、`3-eclipse-temurin-25-noble`、`3`、`latest`、`3-eclipse-temurin`、`eclipse-temurin`、`3-eclipse-temurin-25`  
  [Dockerfile]([])  
- Noble基础镜像（Maven 4 RC）：`4.0.0-rc-4-eclipse-temurin-25-noble`、`4.0.0-rc-4`、`4.0.0-rc-4-eclipse-temurin`、`4.0.0-rc-4-eclipse-temurin-25`  
  [Dockerfile]([])  


### 基于IBM Java/IBM Semeru JDK的镜像  
#### IBM Java 8  
- 标签：`3.9.11-ibmjava-8`、`3.9.11-ibmjava`、`3.9-ibmjava-8`、`3.9-ibmjava`、`3-ibmjava-8`、`3-ibmjava`、`ibmjava`  
  [Dockerfile]([])  


#### IBM Semeru JDK 11/17/21（Noble基础镜像）  
- JDK 11：`3.9.11-ibm-semeru-11-noble`、`3.9-ibm-semeru-11-noble`、`3-ibm-semeru-11-noble`  
  [Dockerfile]([])  
- JDK 17（Maven 3）：`3.9.11-ibm-semeru-17-noble`、`3.9-ibm-semeru-17-noble`、`3-ibm-semeru-17-noble`  
  [Dockerfile]([])  
- JDK 17（Maven 4 RC）：`4.0.0-rc-4-ibm-semeru-17-noble`  
  [Dockerfile]([])  
- JDK 21（Maven 3）：`3.9.11-ibm-semeru-21-noble`、`3.9-ibm-semeru-21-noble`、`3-ibm-semeru-21-noble`  
  [Dockerfile]([])  
- JDK 21（Maven 4 RC）：`4.0.0-rc-4-ibm-semeru-21-noble`  
  [Dockerfile]([])  


### 基于Amazon Corretto JDK的镜像  
（涵盖JDK 8/11/17/21/24/25，支持Alpine/Al2023/Debian/Noble基础镜像，部分提供Maven 4 RC版本，详情参见原始标签列表）  


### 基于SAP Machine JDK的镜像  
（涵盖JDK 11/17/21/25，支持Maven 3和4 RC版本，JDK 25为默认标签，详情参见原始标签列表）  


## 什么是Maven？  

[Apache Maven]([])是一款软件项目管理工具，基于项目对象模型（POM），可从中央信息源管理项目的构建、报告和文档。  


## 如何使用本镜像  

### 直接运行Maven项目  
通过`docker run`命令传递Maven命令，直接运行项目：  
```console
# 将当前目录挂载到容器内工作目录，执行mvn clean install
$ docker run -it --rm --name my-maven-project -v "$(pwd)":/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn clean install
```


### 构建本地Docker镜像（可选）  
如需添加自定义依赖，可基于此镜像构建本地镜像。例如，修改`Dockerfile`后执行：  
```console
# 构建标签为my_local_maven:3.5.2-jdk-8的本地镜像
$ docker build --tag my_local_maven:3.5.2-jdk-8 .
```


### 重用Maven本地仓库  
通过创建卷挂载`/root/.m2`目录，实现本地仓库跨容器复用：  
```console
# 创建名为maven-repo的卷
$ docker volume create --name maven-repo
# 首次运行下载依赖，存储到卷中
$ docker run -it -v maven-repo:/root/.m2 maven mvn archetype:generate
# 后续运行直接重用已下载的依赖
$ docker run -it -v maven-repo:/root/.m2 maven mvn archetype:generate
```

或直接挂载本地`.m2`目录（与本地IDE共享缓存）：  
```console
# 挂载当前目录、本地.m2缓存和target目录，执行打包
$ docker run -it --rm -v "$PWD":/usr/src/mymaven -v "$HOME/.m2":/root/.m2 -

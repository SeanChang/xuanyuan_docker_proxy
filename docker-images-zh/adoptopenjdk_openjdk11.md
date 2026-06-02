---
image: adoptopenjdk/openjdk11
description: "这是由开源社区AdoptOpenJDK构建的OpenJDK 11版本二进制文件的Docker镜像，旨在为容器环境中基于Java 11开发的各类应用程序提供标准化、轻量级的部署与运行支持，方便开发者快速搭建一致的运行环境，确保应用在不同平台间的可移植性和稳定性。"
source: https://xuanyuan.cloud/zh/r/adoptopenjdk/openjdk11
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[adoptopenjdk/openjdk11](https://xuanyuan.cloud/zh/r/adoptopenjdk/openjdk11)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# AdoptOpenJDK Docker镜像使用说明


## 一、官方与AdoptOpenJDK维护镜像的区别  
AdoptOpenJDK在DockerHub提供两类镜像，均基于相同的AdoptOpenJDK Java二进制文件构建，但适用场景不同：  

### 1. DockerHub官方维护镜像  
- **仓库地址**：[DockerHub官方镜像]([])  
- **支持系统**：Ubuntu、Windows（常规JDK/JRE镜像）  
- **更新机制**：操作系统修复可用时即时更新  


### 2. AdoptOpenJDK维护镜像（本仓库）  
- **适用场景**：需使用更多操作系统或精简版镜像时选择  
- **支持系统**：Alpine、CentOS、ClefOS、Debian、Debian-Slim、UBI、UBI-Minimal，以及所有支持系统的精简版（Slim）镜像  
- **更新机制**：每日自动重建  


## 二、支持的标签及Dockerfile链接  
以下标签按**发布版本（稳定版）** 和**夜间版本（开发版）** 分类，包含不同操作系统、架构、JDK/JRE及完整/精简版本。  


### 2.1 发布版本（Release Builds）  
按操作系统分类，每个系统提供JDK（完整版/精简版）和JRE版本，标签格式及示例如下：  

#### Alpine  
- **JDK完整版**：`alpine`、`jdk-11.0.11_9-alpine`、`x86_64-alpine-jdk-11.0.11_9`  
  [Dockerfile]([])  
- **JDK精简版**：`alpine-slim`、`jdk-11.0.11_9-alpine-slim`  
  [Dockerfile]([])  
- **JRE**：`alpine-jre`、`jre-11.0.11_9-alpine`  
  [Dockerfile]([])  


#### CentOS（支持多架构：aarch64/armv7l/ppc64le/x86_64）  
- **JDK完整版**：`centos`、`jdk-11.0.11_9-centos`、`aarch64-centos-jdk-11.0.11_9`  
  [Dockerfile]([])  
- **JDK精简版**：`centos-slim`、`jdk-11.0.11_9-centos-slim`  
  [Dockerfile]([])  
- **JRE**：`centos-jre`、`jre-11.0.11_9-centos`  
  [Dockerfile]([])  


#### 其他系统（Debian/Debian-Slim/UBI/UBI-Minimal等）  
类似上述格式，标签包含系统名称（如`debian`、`ubi`）、JDK/JRE、版本及架构，可通过[GitHub仓库]([])查看完整列表。  


### 2.2 夜间版本（Nightly Builds）  
开发中的每日构建版本，标签格式在发布版基础上添加 `-nightly` 后缀，例如：  
- Alpine JDK完整版：`alpine-nightly`、`jdk11u-alpine-nightly`  
- CentOS JDK精简版：`centos-nightly-slim`、`jdk11u-centos-nightly-slim`  
- 对应Dockerfile链接可在[GitHub仓库]([])中搜索 `nightly` 相关文件。  


## 三、快速参考  

### 帮助与支持  
- **社区支持**：[AdoptOpenJDK支持页面]([])  
- **Slack交流**：[加入AdoptOpenJDK Slack]([])  


### 问题反馈  
- 提交问题至 [GitHub Issues]([])  


### 支持架构  
`aarch64`、`amd64`（x86_64）、`ppc64le`、`s390x`  


## 四、概述  
Java是全球主流的编程语言和平台，其开源代码由[OpenJDK]([])维护。AdoptOpenJDK通过全开源的[构建脚本]([])和基础设施，提供预构建的OpenJDK二进制文件。  

**多架构支持**：镜像已适配所有支持架构，相同命令可在不同架构环境中直接使用。  


## 五、如何使用镜像  

### 基础用法（以Java 11 UBI镜像为例）  
1. **编写Dockerfile**：  
```dockerfile
FROM adoptopenjdk/openjdk11:ubi  # 使用UBI系统的JDK 11镜像
RUN mkdir /opt/app  # 创建应用目录
COPY japp.jar /opt/app  # 复制应用JAR包
CMD ["java", "-jar", "/opt/app/japp.jar"]  # 运行应用
```  

2. **构建并运行镜像**：  
```bash
$ docker build -t my-java-app .  # 构建镜像
$ docker run -it --rm my-java-app  # 运行容器（--rm表示退出后删除容器）
```  


### 指定具体版本  
如需使用特定版本，在镜像标签后添加构建号，例如：  
```bash
$ docker run --rm -it adoptopenjdk/openjdk11:jdk-11.0.9.1_1 java -version
# 输出示例：openjdk version "11.0.9.1" 2020-11-04...
```  


## 六、许可证  
- **Dockerfile及脚本**：[Apache License 2.0]([])  
- **OpenJDK**：[GNU GPL v2 with Classpath Exception]([])  

> 注意：镜像中可能包含其他依赖软件，使用前请确保符合其各自的许可证要求。

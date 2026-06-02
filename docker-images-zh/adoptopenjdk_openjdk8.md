---
image: adoptopenjdk/openjdk8
description: "这是由AdoptOpenJDK构建的OpenJDK 8版本二进制文件的Docker镜像，AdoptOpenJDK作为社区驱动的项目，致力于提供高质量、免费且开源的Java开发工具包（JDK）二进制文件，而Docker镜像则通过容器化技术将OpenJDK 8的运行环境打包，便于开发者和企业快速部署、运行基于Java 8的应用程序，确保环境一致性和跨平台兼容性，满足各类Java应用的开发与生产需求。"
source: https://xuanyuan.cloud/zh/r/adoptopenjdk/openjdk8
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[adoptopenjdk/openjdk8](https://xuanyuan.cloud/zh/r/adoptopenjdk/openjdk8)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# AdoptOpenJDK Docker镜像使用指南


## 一、官方与AdoptOpenJDK维护的Docker镜像区别  
AdoptOpenJDK在DockerHub提供两类镜像，均基于相同的Java二进制文件构建，但在OS支持和更新策略上存在差异：  

### 1. DockerHub官方镜像  
- **仓库地址**：[DockerHub官方仓库]([])  
- **OS支持**：Ubuntu、Windows系统的常规JDK/JRE镜像  
- **更新策略**：底层OS修复发布后同步更新  


### 2. AdoptOpenJDK维护镜像（本仓库）  
- **适用场景**：需使用Alpine、CentOS、ClefOS、Debian、Debian-Slim、UBI、UBI-Minimal等系统，或所有支持OS的Slim版本镜像  
- **更新策略**：每日自动重建  


## 二、支持的标签及Dockerfile链接  

### （一）发布版本（Release Builds）  
按基础OS分类，以下为常用标签格式及示例（完整标签含版本号、架构等信息，可点击Dockerfile链接查看详情）：  

#### Alpine  
- **JDK完整版本**：`alpine`（示例：`jdk8u292-b10-alpine`、`x86_64-alpine-jdk8u292-b10`）  
  [Dockerfile]([])  
- **JDK Slim版本**：`alpine-slim`（示例：`jdk8u292-b10-alpine-slim`）  
  [Dockerfile]([])  
- **JRE完整版本**：`alpine-jre`（示例：`jre8u292-b10-alpine`）  
  [Dockerfile]([])  


#### CentOS  
- **JDK完整版本**：`centos`（示例：`jdk8u292-b10-centos`，支持aarch64/armv7l/ppc64le/x86_64架构）  
  [Dockerfile]([])  
- **JDK Slim版本**：`centos-slim`（示例：`jdk8u292-b10-centos-slim`）  
  [Dockerfile]([])  
- **JRE完整版本**：`centos-jre`（示例：`jre8u292-b10-centos`）  
  [Dockerfile]([])  


#### 其他OS（Debian、UBI、Ubuntu等）  
类似上述格式，支持`debian`/`debian-slim`/`debian-jre`、`ubi`/`ubi-slim`/`ubi-jre`、`latest`（默认Ubuntu）/`slim`/`jre`等标签，具体可参考：  
- [Debian系列]([])  
- [UBI系列]([])  
- [Ubuntu系列]([])  


### （二）夜间构建版本（Nightly Builds）  
基于最新代码构建，标签格式在发布版本基础上添加`-nightly`后缀，例如：  
- Alpine JDK完整版本：`alpine-nightly`（示例：`jdk8u-alpine-nightly`）  
  [Dockerfile]([])  
- CentOS JRE版本：`centos-jre-nightly`（示例：`jre8u-centos-nightly`）  
  [Dockerfile]([])  


## 三、快速参考  

### 帮助与支持  
- **社区支持**：[AdoptOpenJDK支持页面]([])  
- **即时沟通**：加入[AdoptOpenJDK Slack社区]([])  


### 问题反馈  
- 提交Issue至[GitHub仓库]([])  


### 支持架构  
`aarch64`、`amd64`（x86_64）、`ppc64le`、`s390x`  


## 四、使用示例  

### 1. 基础用法（以UBI系统JDK为例）  
创建Dockerfile：  
```dockerfile
FROM adoptopenjdk/openjdk8:ubi  # 使用UBI系统的JDK镜像
RUN mkdir /opt/app
COPY your-app.jar /opt/app/
CMD ["java", "-jar", "/opt/app/your-app.jar"]
```  

构建并运行：  
```bash
docker build -t your-app .
docker run -it --rm your-app  # --rm：容器退出后自动删除
```  


### 2. 指定版本和架构  
如需使用特定版本（如JRE 8u282-b08）：  
```bash
docker run --rm -it adoptopenjdk/openjdk8:jre8u282-b08 java -version
```  
输出示例：  
```
openjdk version "1.8.0_282"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_282-b08)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.282-b08, mixed mode)
```  


## 五、许可证  
- **Dockerfile及脚本**：[Apache License 2.0]([])  
- **OpenJDK**：[GNU GPL v2许可证（含Classpath例外条款）]([])  

> 注：镜像中可能包含其他软件（如基础系统的Bash等），使用前请确保符合其各自许可证要求。

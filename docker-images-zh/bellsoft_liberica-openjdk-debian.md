---
image: bellsoft/liberica-openjdk-debian
description: "Liberica是由BellSoft开发的100%开源Java实现，它完全符合Java SE标准，支持Windows、Linux、macOS等多种操作系统及ARM、x86等架构，提供长期支持（LTS）版本以确保稳定性与安全性，广泛应用于企业级开发、云服务及嵌入式系统等场景，为开发者和企业提供可靠的Java运行环境与开发工具支持。"
source: https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-debian
canonical: https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-debian
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-debian" title="bellsoft/liberica-openjdk-debian Docker 镜像中文简介、标签列表与拉取命令">bellsoft/liberica-openjdk-debian 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# bellsoft/liberica-openjdk-debian 镜像介绍


## 什么是 Liberica JDK？  
Liberica JDK 是免费且完全开源的渐进式 Java 运行时，适用于现代 Java 部署场景，由 OpenJDK 主要贡献者 BellSoft 开发并提供支持。使用 Liberica JDK 进行应用开发具有以下特点：  

- **灵活性**：支持当前主流架构和操作系统，可作为桌面、服务器、云及嵌入式场景的统一 Java 运行时。  
- **成本与时间效率**：BellSoft 基于 Liberica Lite 和 Alpine Linux 制作了全球体积最小的容器，帮助企业缩短部署时间、降低云资源成本。  
- **安全性**：通过 Java SE 规范的 TCK 验证，每次发布前均经过全面漏洞测试；采用 CPU 发布周期，及时提供安全补丁和 bug 修复，确保运行时持续安全高效。  

Spring 推荐并使用 Liberica JDK 作为 Spring Native 应用的端到端解决方案（[参考] ）。BellSoft 服务全球数百万开发者及各行业企业，更多信息可访问 [www.bell-sw.com] 。  


## 如何选择合适的 Java 镜像？  
我们整理了交互式选择指南，帮助确定适合项目的 BellSoft 镜像：  
![Java 镜像选择指南]   


## 本镜像包含什么？  
此仓库提供基于 Debian 的 Liberica JDK 镜像，支持以下架构：  
- x86_64（即 amd64）  
- aarch64（即 ARM64）  
- armhf（适用于树莓派 2/3 等设备）  


### 镜像标签规则  
标签由 **Java 版本**（紧跟操作系统名称后）和 **架构类型** 组成，格式为 `X-Y`：  
- `X` 为 Java 版本，`Y` 为架构类型；若标签中未指定架构，则默认支持 AMD64 和 ARM64。  
- `latest` 标签指向最新版本镜像。  
- 含 `-cds` 的标签包含 CDS（Class Data Sharing）归档文件。  

**示例**：`bellsoft/liberica-openjdk-debian:17` 是基于 Debian 的 Liberica JDK 17 版本镜像，支持 AMD64 或 ARM64 架构（[查看详情] ）。  


## 标签列表  
- [`latest`] , [`latest-cds`] , [`25`] , [`25-cds`]   
- [`24`] , [`24-cds`]   
- [`23`] , [`23-cds`]   
- [`22`] , [`22-cds`]   
- [`21.0.6`] , [`21.0.6-cds`] , [`21.0.7`] , [`21.0.7-cds`] , [`21`] , [`21-cds`]   
- [`20`] , [`19`] , [`18`]   
- [`17.0.16`] , [`17.0.16-cds`] , [`17`] , [`17-cds`]   
- [`16`] , [`15`] , [`14`] , [`13`] , [`12`]   
- [`11.0.28`] , [`11.0.28-cds`] , [`11`] , [`11-cds`]   
- [`10`] （仅 armhf 架构，适用于树莓派 2/3）  
- [`9.0.1`] （仅 armhf 架构，适用于树莓派 2/3）  
- [`8u462`] , [`8u462-cds`] , [`8`] , [`8-cds`] （仅 amd64 和 aarch64 架构）  


## 使用方法  

### 基本示例  
运行容器查看 Java 版本：  
```bash
docker run -it --rm docker.xuanyuan.run/bellsoft/liberica-openjdk-debian:latest java -version
```

### 运行应用  
通过挂载卷运行本地 JAR 包：  
```bash
docker run -it --rm -v /home/user/project/:/data docker.xuanyuan.run/bellsoft/liberica-openjdk-debian:latest java -jar /data/MyApp.jar
```

### 版本特定配置  

#### JDK 8u* 版本  
- `LIBERICA_USE_LITE`：控制镜像内容。`0` 保留完整 JDK；`1`（默认）生成精简镜像，移除演示、示例及源码文件。  


#### JDK 11* 和 JDK 17* 版本  
- `LIBERICA_IMAGE_VARIANT`：指定镜像变体，可选值：  
  - `base`：含 `java.base` 模块的服务器 VM  
  - `base-minimal`：含 `java.base` 模块的最小 VM  
  - `lite`（默认）：最小体积精简 JDK  
  - `standard`：标准 JDK  

- `LIBERICA_VM`：指定精简/标准变体中包含的 VM，可选值：  
  - `server`（默认）：包含 server VM  
  - `client`：包含 client VM  
  - `minimal`：包含 minimal VM  
  - `all`：包含原始包中所有 VM  


通过以上配置，可根据项目需求灵活调整镜像内容与性能。

---
image: library/amazoncorretto
description: "Corretto是一款免费的、可直接用于生产环境的开放Java开发工具包（OpenJDK）发行版，它经过专门优化以确保在实际生产场景中的稳定性与可靠性，为开发者及企业提供了无需额外成本即可部署的高性能Java运行环境，满足从开发测试到大规模生产应用的全流程需求。"
source: https://xuanyuan.cloud/zh/r/library/amazoncorretto
canonical: https://xuanyuan.cloud/zh/r/library/amazoncorretto
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/amazoncorretto" title="library/amazoncorretto Docker 镜像中文简介、标签列表与拉取命令">library/amazoncorretto — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/amazoncorretto" title="library/amazoncorretto Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/amazoncorretto</a>

# Amazon Corretto Docker镜像介绍


## 快速参考

### 维护者  
由 [AWS JDK团队]([]) 维护。

### 获取帮助  
可通过 [Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([]) 获取支持。


## 支持的标签及对应Dockerfile链接  

以下标签按Java版本分组，可根据需求选择对应版本、基础系统（如Al2、Al2023、Alpine）及组件（JDK/JRE等）：


### Java 8  
- [`8`, `8u462`, `8u462-al2`, `8-al2-full`, `8-al2-jdk`, `8-al2-generic`, `8u462-al2-generic`, `8-al2-generic-jdk`, `latest`]([])  
- [`8-al2023`, `8u462-al2023`, `8-al2023-jdk`, `8-al2023-jre`, `8u462-al2023-jre`]([])  
- [`8-al2-native-jre`, `8u462-al2-native-jre`]([])  
- [`8-al2-native-jdk`, `8u462-al2-native-jdk`]([])  
- Alpine系列（3.19~3.22）：  
  - [`8-alpine3.19`, `8u462-alpine3.19`, `8-alpine3.19-full`, `8-alpine3.19-jdk`]([])  
  - [`8-alpine3.22`, `8u462-alpine3.22`, `8-alpine3.22-full`, `8-alpine3.22-jdk`, `8-alpine`, `8u462-alpine`, `8-alpine-full`, `8-alpine-jdk`]([])  
  - （其他Alpine版本标签及JRE变体详见原文链接）  


### Java 11  
- [`11`, `11.0.28`, `11.0.28-al2`, `11-al2-full`, `11-al2-jdk`, `11-al2-generic`, `11.0.28-al2-generic`, `11-al2-generic-jdk`]([])  
- [`11-al2023`, `11.0.28-al2023`, `11-al2023-jdk`]([])  
- Alpine系列（3.19~3.22）：  
  - [`11-alpine3.22`, `11.0.28-alpine3.22`, `11-alpine3.22-full`, `11-alpine3.22-jdk`, `11-alpine`, `11.0.28-alpine`, `11-alpine-full`, `11-alpine-jdk`]([])  
  - （其他标签及headless/headful变体详见原文链接）  


### Java 17  
- [`17`, `17.0.16`, `17.0.16-al2`, `17-al2-full`, `17-al2-jdk`, `17-al2-generic`, `17.0.16-al2-generic`, `17-al2-generic-jdk`]([])  
- Alpine系列（3.19~3.22）：  
  - [`17-alpine3.22`, `17.0.16-alpine3.22`, `17-alpine3.22-full`, `17-alpine3.22-jdk`, `17-alpine`, `17.0.16-alpine`, `17-alpine-full`, `17-alpine-jdk`]([])  
  - （其他标签及变体详见原文链接）  


### Java 21/24/25  
- **Java 21**：包含Al2、Al2023及Alpine 3.19~3.22版本标签，如 [`21`, `21.0.8-al2`, `21-alpine3.22-jdk`]([])。  
- **Java 24/25**：包含Al2023及Alpine 3.19~3.22版本标签，如 [`24`, `24-al2023-jdk`, `25-alpine-jdk`]([])。  
- （完整标签列表及Dockerfile链接详见原文）  


## 快速参考（续）  

### 问题反馈  
若发现问题，可在 [GitHub仓库issue页]([]) 提交。

### 支持架构  
- `amd64`：[查看镜像]([])  
- `arm64v8`：[查看镜像]([])  

### 镜像详情  
包含元数据、传输大小等信息，可查看 [repo-info仓库的amazoncorretto目录]([])。

### 镜像更新  
通过 [official-images仓库的library/amazoncorretto标签]([]) 跟踪更新。

### 描述来源  
本文档内容源自 [docs仓库的amazoncorretto目录]([])。


## 关于Amazon Corretto  

### 什么是Amazon Corretto？  
Corretto是OpenJDK的二进制发行版，由亚马逊提供长期支持，通过Java SE标准认证（TCK），适用于Linux、Windows和macOS。包含亚马逊在生产环境中验证过的补丁，提升稳定性和性能。

### 为什么选择Corretto？  
- 免费长期支持，无需额外付费；  
- 基于亚马逊内部数千个服务的运行经验，补丁经过实战验证；  
- 紧急安全修复可在季度周期外快速发布。

### 与OpenJDK的区别  
Corretto基于OpenJDK构建，额外包含亚马逊开发的补丁（尚未合并到OpenJDK更新项目中），专注于提升性能、稳定性（如优化高频函数、垃圾回收调度、避免内存溢出等）。

### 包含哪些类型的补丁？  
- 安全修复；  
- 性能优化（如高频函数加速）；  
- 垃圾回收与线程管理增强；  
- 监控与报告功能改进。

### 使用成本  
完全免费，基于GPLv2+CPE许可证分发，亚马逊不收取使用或分发费用。

### 长期支持范围  
- Corretto 8：至少支持至2023年6月，季度更新；  
- Corretto 11：至少支持至2024年8月，季度更新。

### 是否可作为其他JDK的替代品？  
是的，除非依赖OpenJDK未包含的功能（如Java Flight Recorder）。安装后可直接替换现有JDK，命令行参数、调优参数等无需修改。

### 安全扫描显示镜像存在CVE怎么办？  
1. **优先拉取更新镜像**：官方会自动重建基于最新基础镜像的版本；  
2. **手动更新系统包**：若暂无更新镜像，可在Dockerfile中运行命令更新（Alpine：`apk -U upgrade`；Amazon Linux：`yum update -y --security`）；  
3. **反馈问题**：若基础镜像未更新，可联系基础镜像维护者，或通过 [AWS安全漏洞报告流程]([]) 反馈（邮箱：[邮箱已删除]）。  
   *注：CVE可能为误报，详见 [Docker库常见问题]([])。*


## 镜像变体  

### 默认版本（amazoncorretto:<version>）  
适用于大多数场景，可直接运行应用或作为基础镜像构建其他镜像，兼容性好。

### Alpine版本（amazoncorretto:<version>-alpine）  
基于Alpine Linux，镜像体积更小（基础镜像~5MB），适合对镜像大小敏感的场景。注意：使用musl libc而非glibc，部分依赖glibc的功能可能存在兼容性问题。


## 许可证  
Corretto基于GPLv2+CPE许可证分发（与OpenJDK相同）。Docker镜像可能包含其他软件（如Bash），用户需自行确保所有组件的使用符合相关许可证要求。详细信息可查看 [repo-info仓库的amazoncorretto目录]([])。

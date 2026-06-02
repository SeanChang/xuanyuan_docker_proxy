---
image: jenkins/openjdk
description: "这些Docker镜像是基于多种AdoptOpenJDK二进制文件构建的，旨在为Java应用提供便捷、高效的容器化部署方案，支持不同Java版本与平台，确保应用在各类环境中稳定运行，满足开发者对开源Java运行时的多样化需求，具备轻量级、可移植性强等特点，便于快速集成到开发与生产流程中。"
source: https://xuanyuan.cloud/zh/r/jenkins/openjdk
canonical: https://xuanyuan.cloud/zh/r/jenkins/openjdk
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkins/openjdk" title="jenkins/openjdk Docker 镜像中文简介、标签列表与拉取命令">jenkins/openjdk — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jenkins/openjdk" title="jenkins/openjdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jenkins/openjdk</a>

# 基于AdoptOpenJDK二进制文件的Docker镜像


## 简介  
这些Docker镜像基于AdoptOpenJDK的各类二进制文件构建。AdoptOpenJDK是开源的Java开发工具包，提供稳定的LTS（长期支持）版本和多样的构建选项，适合开发、测试及生产环境使用。通过Docker镜像，可快速获取预配置的Java环境，避免手动配置麻烦，保证不同环境下的一致性，简化应用部署流程。


## 镜像特点  
### 1. 多版本覆盖  
支持AdoptOpenJDK的主流LTS版本，包括JDK 8、11、17等，满足不同项目对Java版本的需求（例如老项目用JDK 8，新项目用JDK 17）。  

### 2. 多架构适配  
适配常见硬件架构，如x86_64（适用于多数服务器、PC）和aarch64（适用于ARM设备，如树莓派、ARM架构云服务器），可在不同硬件环境中直接使用。  

### 3. 多样JVM类型  
提供两种主流JVM实现的镜像：  
- **HotSpot**：Oracle JDK默认JVM，兼容性好、生态成熟，适合多数常规场景；  
- **OpenJ9**：IBM开发的JVM，内存占用低、启动速度快，适合资源受限的场景（如边缘设备、轻量服务器）。  


## 使用指南  
### 1. 获取镜像  
镜像托管在Docker Hub的`adoptopenjdk`仓库，通过标签指定具体版本、架构和JVM类型。标签格式一般为 `<JDK版本>-<JVM类型>-<架构>-<基础系统>`（例如 `11-hotspot-x86_64-ubuntu`）。  

### 2. 拉取镜像示例  
根据需求选择标签拉取，例如拉取JDK 11、HotSpot JVM、x86_64架构的镜像：  
```bash
docker pull adoptopenjdk:11-hotspot-x86_64-ubuntu
```  

### 3. 运行容器示例  
拉取后可直接启动容器验证环境，例如查看Java版本：  
```bash
docker run --rm adoptopenjdk:11-hotspot-x86_64-ubuntu java -version
```  
输出类似以下内容即表示环境可用：  
```
openjdk version "11.0.18" 2023-01-17
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.18+10)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.18+10, mixed mode)
```  


## 选择建议  
- **版本选择**：根据项目依赖的Java版本选对应标签（如项目需JDK 8则用 `8-*` 标签）；  
- **架构选择**：根据部署环境的硬件架构选x86_64或aarch64；  
- **JVM类型选择**：常规场景用HotSpot（兼容性优先），资源紧张场景（如低内存服务器）用OpenJ9（轻量优先）。

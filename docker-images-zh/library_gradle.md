---
image: library/gradle
description: "Gradle是一款快速高效、稳定可靠且灵活易用的开源构建工具，它凭借优雅简洁且高度可扩展的领域特定语言（DSL），广泛应用于各类软件项目的构建流程中，能够自动化处理编译、测试、打包等复杂任务，有效简化构建配置，提升开发效率，同时支持多语言开发环境，满足不同项目的个性化构建需求，为开发者提供了强大而便捷的构建解决方案。"
source: https://xuanyuan.cloud/zh/r/library/gradle
canonical: https://xuanyuan.cloud/zh/r/library/gradle
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/gradle" title="library/gradle Docker 镜像中文简介、标签列表与拉取命令">library/gradle — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/gradle" title="library/gradle Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/gradle</a>

# Gradle Docker镜像使用指南


## 一、快速参考

### 维护方  
[Gradle, Inc.]([])（官方GitHub仓库）


### 帮助支持渠道  
- [Gradle社区Slack]([])  
- [Gradle社区论坛]([])  
- [Docker社区Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


## 二、支持的标签及Dockerfile链接  

以下标签按**JDK版本**和**基础镜像类型**分组，可直接用于拉取对应Gradle镜像，点击标签组名称可查看对应的Dockerfile源码：  


### 1. 基于JDK 25的镜像  
- **Ubuntu Noble基础版**（含`latest`标签）：  
  `9.1.0-jdk25`、`9.1-jdk25`、`9-jdk25`、`jdk25`、`latest`等  
  [Dockerfile链接]([])  

- **Alpine基础版**（轻量版）：  
  `9.1.0-jdk25-alpine`、`9.1-jdk25-alpine`、`jdk25-alpine`、`alpine`等  
  [Dockerfile链接]([])  

- **Corretto基础版**（Amazon JDK）：  
  `9.1.0-jdk25-corretto`、`jdk25-corretto`、`corretto`等  
  [Dockerfile链接]([])  

- **UBI基础版**（Red Hat通用基础镜像）：  
  `9.1.0-jdk25-ubi`、`jdk25-ubi`、`ubi`等  
  [Dockerfile链接]([])  

- **GraalVM基础版**（支持原生镜像）：  
  `9.1.0-jdk25-graal`、`jdk25-graal`、`graal`等  
  [Dockerfile链接]([])  


### 2. 其他JDK版本标签  
支持JDK 21、17、11、8等版本，标签命名规则与JDK 25类似，例如：  
- JDK 21系列：`9.1.0-jdk21`、`9.1.0-jdk21-alpine`、`9.1.0-jdk21-corretto`等  
- JDK 17系列：`9.1.0-jdk17`、`9.1.0-jdk17-ubi`、`9.1.0-jdk17-graal`等  
- 历史版本：Gradle 8.x（如`8.14.3-jdk21`）、7.x（如`7.6.6-jdk17`）、6.x（如`6.9.4-jdk11`）  

> 完整标签列表及对应Dockerfile可通过[官方GitHub仓库]([])查询。  


## 三、补充参考信息  

### 问题反馈渠道  
[GitHub Issues]([])  


### 支持的架构  
- `amd64`、`arm32v7`、`arm64v8`、`ppc64le`、`riscv64`、`s390x`  
（各架构镜像链接可通过[Docker Hub]([])查看）  


### 镜像详情与更新  
- 镜像元数据、传输大小等：[repo-info仓库]([])  
- 镜像更新记录：[official-images仓库]([])  


## 四、Gradle简介  

[Gradle]([])是一款快速、可靠、灵活的开源构建自动化工具，采用优雅的声明式构建语言，支持多语言项目构建（如Java、Kotlin、C++等），广泛用于企业级项目。  


## 五、如何使用本镜像  

### 运行Gradle任务  
在项目根目录执行以下命令，可直接运行Gradle任务（如编译、测试等）：  

```bash
docker run --rm -u gradle \
  -v "$PWD":/home/gradle/project \
  -w /home/gradle/project \
  gradle gradle <任务名称>
```  

#### 参数说明：  
- `--rm`：任务执行完成后自动删除容器  
- `-u gradle`：使用容器内的`gradle`用户执行命令（避免权限问题）  
- `-v "$PWD":/home/gradle/project`：将当前目录挂载到容器内的项目路径  
- `-w /home/gradle/project`：设置容器内的工作目录为项目路径  
- `<任务名称>`：替换为实际Gradle任务（如`build`、`test`、`clean`）  

#### 示例：  
执行项目构建任务：  
```bash
docker run --rm -u gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle gradle build
```  


## 六、镜像变体说明  

### 1. 默认镜像（`gradle:<version>`）  
- 基于Ubuntu系统（如`noble`、`jammy`版本），包含完整依赖，适合大多数场景。  
- 标签示例：`gradle:9.1.0`、`gradle:9-jdk25`、`gradle:latest`（默认指向最新稳定版）。  


### 2. Alpine精简版（`gradle:<version>-alpine`）  
- 基于[Alpine Linux]([])，镜像体积更小（约5MB基础镜像），适合对镜像大小敏感的场景。  
- 注意：Alpine使用`musl libc`而非`glibc`，部分依赖`glibc`的工具可能存在兼容性问题。  


### 3. 其他特殊变体  
- **Corretto**：基于Amazon Corretto JDK，优化AWS环境兼容性。  
- **UBI**：基于Red Hat通用基础镜像，适合企业级Linux环境。  
- **Graal**：集成GraalVM，支持原生镜像编译（提升应用启动速度）。  


## 七、许可证信息  

- Gradle软件许可证：[详见官方说明]([])。  
- 镜像包含的其他软件（如基础系统工具、JDK等）可能涉及不同许可证，用户需自行确保合规使用。  
- 镜像许可证详情可参考[repo-info仓库]([])。

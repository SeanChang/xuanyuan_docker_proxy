---
image: amd64/openjdk
description: "OpenJDK的预发布/非生产版本是Java平台开源实现的早期构建版本，主要供开发者进行功能验证、兼容性测试和新特性预览，不适合部署在生产环境中；这类版本通常包含最新开发阶段的功能更新，但可能存在稳定性或兼容性问题，需经过进一步测试与优化后才能作为正式生产版本发布，为Java生态系统的持续迭代和技术创新提供前期验证支持。"
source: https://xuanyuan.cloud/zh/r/amd64/openjdk
canonical: https://xuanyuan.cloud/zh/r/amd64/openjdk
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/openjdk" title="amd64/openjdk Docker 镜像中文简介、标签列表与拉取命令">amd64/openjdk — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/amd64/openjdk" title="amd64/openjdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amd64/openjdk</a>

# OpenJDK (amd64) 镜像介绍


## 说明  
本文档对应 [openjdk 官方镜像]([]) 的 `amd64` 架构专用仓库。更多信息可参考官方文档：  
- [“非 amd64 架构说明”]([])  
- [“镜像源码在 Git 中变更后如何处理？”]([])  


## 弃用通知  
该镜像已**正式弃用**，建议所有用户尽快寻找并迁移至合适的替代方案。以下是官方推荐的替代镜像（按字母顺序排列，无优先级暗示）：  
- [`amazoncorretto`]([])  
- [`eclipse-temurin`]([])  
- [`ibm-semeru-runtimes`]([])  
- [`ibmjava`]([])  
- [`sapmachine`]([])  

详见 [docker-library/openjdk#505]([])。  

**2022 年 7 月后，仅 Early Access 构建（源码来自 [jdk.java.net]([])）会继续更新**，此类构建未被上述替代项目支持或发布。  


## 快速参考  

### 维护者  
[Docker 社区]([])  

### 获取帮助的途径  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  
（关于“共享标签”与“简单标签”的区别，见 FAQ：[“‘Shared’和‘Simple’标签有何不同？”]([])）  

### 简单标签（Simple Tags）  
- [`26-ea-18-jdk-oraclelinux9`, `26-ea-18-oraclelinux9`, `26-ea-jdk-oraclelinux9`, `26-ea-oraclelinux9`, `26-jdk-oraclelinux9`, `26-oraclelinux9`, `26-ea-18-jdk-oracle`, `26-ea-18-oracle`, `26-ea-jdk-oracle`, `26-ea-oracle`, `26-jdk-oracle`, `26-oracle`]([])  
- [`26-ea-18-jdk-oraclelinux8`, `26-ea-18-oraclelinux8`, `26-ea-jdk-oraclelinux8`, `26-ea-oraclelinux8`, `26-jdk-oraclelinux8`, `26-oraclelinux8`]([])  
- [`26-ea-18-jdk-trixie`, `26-ea-18-trixie`, `26-ea-jdk-trixie`, `26-ea-trixie`, `26-jdk-trixie`, `26-trixie`]([])  
- [`26-ea-18-jdk-slim-trixie`, `26-ea-18-slim-trixie`, `26-ea-jdk-slim-trixie`, `26-ea-slim-trixie`, `26-jdk-slim-trixie`, `26-slim-trixie`, `26-ea-18-jdk-slim`, `26-ea-18-slim`, `26-ea-jdk-slim`, `26-ea-slim`, `26-jdk-slim`, `26-slim`]([])  
- [`26-ea-18-jdk-bookworm`, `26-ea-18-bookworm`, `26-ea-jdk-bookworm`, `26-ea-bookworm`, `26-jdk-bookworm`, `26-bookworm`]([])  
- [`26-ea-18-jdk-slim-bookworm`, `26-ea-18-slim-bookworm`, `26-ea-jdk-slim-bookworm`, `26-ea-slim-bookworm`, `26-jdk-slim-bookworm`, `26-slim-bookworm`]([])  


### 共享标签（Shared Tags）  
- `26-ea-18-jdk`, `26-ea-18`, `26-ea-jdk`, `26-ea`, `26-jdk`, `26`:  
  - 对应镜像：[`26-ea-18-jdk-oraclelinux9`]([])  


## 快速参考（续）  

### 提交 issue 的位置  
[[]]([])  

### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm64v8`]([])、[`windows-amd64`]([])  

### 镜像 artifact 详情  
[repo-info 仓库的 `repos/openjdk/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  

### 镜像更新  
- [official-images 仓库的 `library/openjdk` 标签]([])  
- [official-images 仓库的 `library/openjdk` 文件]([])（[历史记录]([])）  

### 本文档来源  
[docs 仓库的 `openjdk/` 目录]([])（[历史记录]([])）  


## 什么是 OpenJDK？  
OpenJDK（Open Java Development Kit）是 Java 平台标准版（Java SE）的免费开源实现。自版本 7 起，OpenJDK 成为 Java SE 的官方参考实现。  

> 来源：[.org/wiki/OpenJDK]()  

Java 是 Oracle 及其关联公司的注册商标。  


## 如何使用该镜像  

### 在应用中启动 Java 实例  
最直接的用法是将 Java 容器同时作为构建和运行环境。在 `Dockerfile` 中编写如下内容，可编译并运行项目：  

```dockerfile
FROM amd64/openjdk:11
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```  

构建并运行 Docker 镜像：  

```console
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```  


### 在 Docker 容器内编译应用  
若无需在容器内运行应用，仅需编译，可执行以下命令：  

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp amd64/openjdk:11 javac Main.java
```  

该命令会将当前目录挂载为容器卷，设置工作目录为该卷，然后执行 `javac Main.java` 编译 `Main.java` 并生成 `Main.class`。  


### 让 JVM 尊重 CPU 和 RAM 限制  
JVM 启动时会探测可用 CPU 核心数和 RAM，以调整内部参数（如垃圾回收线程数）。若容器限制了 CPU/RAM，旧版 JVM 可能仍使用主机级别的资源值，导致 CPU 占用过高或内存分配错误。  

- **Linux 容器**：OpenJDK 8 及以上版本可正确识别容器限制的 CPU 和 RAM，默认启用该功能。  
- **Windows Server 容器（非 Hyper-V）**：CPU 核心限制不生效（被 Host Compute Service 忽略），需手动设置 CPU 亲和性，例如：  
  ```console
  $ start /b /wait /affinity 0x3 path/to/java.exe ...
  ```  
  （示例中 `0x3` 为十六进制掩码，限制 JVM 使用 2 个 CPU 核心）。  
  RAM 限制受支持，但 JVM 无法自动探测，需通过 `-XX:MaxRAM=...` 指定不超过容器 RAM 限制的值。  


### 环境变量名称含句点的问题  
部分 shell（如 Alpine Linux 中包含的 BusyBox `/bin/sh`）不支持名称含句点的环境变量（技术上不符合 POSIX 标准），会直接剥离这类变量（Bash 则会保留）。若应用依赖此类环境变量，可：  
- 直接使用 `CMD ["java", ...]`（不通过 shell）；  
- 显式安装并使用 Bash 替代 `/bin/sh`。  


## 镜像变体  
`amd64/openjdk` 提供多种变体，适用于不同场景：  

### `amd64/openjdk:<version>`  
默认镜像。若不确定需求，建议使用此变体。既可作为临时容器（挂载源码并启动应用），也可作为基础镜像构建其他镜像。  

部分标签含 `bookworm` 或 `trixie` 等名称，这些是 [Debian]([]) 的版本代号，标识镜像基于的 Debian 版本。若需安装额外包，建议显式指定版本代号，以减少 Debian 新版本发布时的兼容性问题。  


### `amd64/openjdk:<version>`（12 及以上版本）、`amd64/openjdk:<version>-oracle` 和 `amd64/openjdk:<version>-oraclelinux8`  
- `openjdk:12` 及以上的默认镜像、`-oracle` 和 `-oraclelinux8` 变体基于官方 [Oracle Linux 8 镜像]([])，遵循 [Oracle Linux 最终用户许可协议（EULA）]([])（GPLv2 许可）。  
- `-oraclelinux7` 变体基于 [Oracle Linux 7 镜像]([])，遵循 [Oracle Linux 7 EULA]([])。  

OpenJDK 二进制由 Oracle 构建，源码来自 [OpenJDK 社区]([])，许可为 [GPLv2 附带 Classpath 例外条款]([])。  


## 许可证  
查看镜像中软件的 [许可证信息]([])。  

与所有 Docker 镜像一样，其中可能包含其他软件（如基础发行版的 Bash 及依赖），可能适用其他许可证。  

自动检测到的额外许可证信息可在 [repo-info 仓库的 `openjdk/` 目录]([]) 中找到。  

使用预构建镜像时，用户需自行确保对镜像中所有软件的使用符合相关许可证要求。

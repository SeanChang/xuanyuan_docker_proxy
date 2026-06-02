<!-- xuanyuan-docker-images-zh
image: arm64v8/openjdk
source: https://xuanyuan.cloud/zh/r/arm64v8/openjdk
canonical: https://xuanyuan.cloud/zh/r/arm64v8/openjdk
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [arm64v8/openjdk — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/arm64v8/openjdk "arm64v8/openjdk Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/arm64v8/openjdk

# arm64v8/openjdk 镜像说明  


## 说明  
本仓库是 [openjdk 官方镜像]([]) 的 `arm64v8` 架构专用仓库。更多信息可参考官方镜像文档中的 [“非 amd64 架构说明”]([]) 和 FAQ 中的 [“镜像源码变更后如何处理”]([])。  


## 弃用通知  
该镜像已官方弃用，建议用户尽快寻找并使用合适的替代方案。以下是其他官方镜像替代选项（按字母顺序排列，不代表任何偏好）：  
- [`amazoncorretto`]([])  
- [`eclipse-temurin`]([])  
- [`ibm-semeru-runtimes`]([])  
- [`ibmjava`]([])  
- [`sapmachine`]([])  

详细信息见 [docker-library/openjdk#505]([])。  
2022 年 7 月后，仅有 Early Access 版本（源码来自 [jdk.java.net]([])）会继续更新，因上述替代项目暂不提供该版本支持。  


## 快速参考  

### 维护者  
[Docker 社区]([])  


### 获取帮助  
可通过 [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([]) 寻求帮助。  


### 支持的标签及对应 Dockerfile 链接  
（关于“Shared 标签与 Simple 标签的区别”，见 FAQ [相关说明]([])。）  

#### Simple Tags  
- [`26-ea-18-jdk-oraclelinux9`, `26-ea-18-oraclelinux9`, `26-ea-jdk-oraclelinux9`, `26-ea-oraclelinux9`, `26-jdk-oraclelinux9`, `26-oraclelinux9`, `26-ea-18-jdk-oracle`, `26-ea-18-oracle`, `26-ea-jdk-oracle`, `26-ea-oracle`, `26-jdk-oracle`, `26-oracle`]([])  
- [`26-ea-18-jdk-oraclelinux8`, `26-ea-18-oraclelinux8`, `26-ea-jdk-oraclelinux8`, `26-ea-oraclelinux8`, `26-jdk-oraclelinux8`, `26-oraclelinux8`]([])  
- [`26-ea-18-jdk-trixie`, `26-ea-18-trixie`, `26-ea-jdk-trixie`, `26-ea-trixie`, `26-jdk-trixie`, `26-trixie`]([])  
- [`26-ea-18-jdk-slim-trixie`, `26-ea-18-slim-trixie`, `26-ea-jdk-slim-trixie`, `26-ea-slim-trixie`, `26-jdk-slim-trixie`, `26-slim-trixie`, `26-ea-18-jdk-slim`, `26-ea-18-slim`, `26-ea-jdk-slim`, `26-ea-slim`, `26-jdk-slim`, `26-slim`]([])  
- [`26-ea-18-jdk-bookworm`, `26-ea-18-bookworm`, `26-ea-jdk-bookworm`, `26-ea-bookworm`, `26-jdk-bookworm`, `26-bookworm`]([])  
- [`26-ea-18-jdk-slim-bookworm`, `26-ea-18-slim-bookworm`, `26-ea-jdk-slim-bookworm`, `26-ea-slim-bookworm`, `26-jdk-slim-bookworm`, `26-slim-bookworm`]([])  

#### Shared Tags  
- `26-ea-18-jdk`, `26-ea-18`, `26-ea-jdk`, `26-ea`, `26-jdk`, `26`:  
  - 对应镜像：[`26-ea-18-jdk-oraclelinux9`]([])  


### 快速参考（续）  
- **提交 issue 地址**：[[]]([])  
- **支持的架构**（[更多信息]([])）：  
  [`amd64`]([])、[`arm64v8`]([])、[`windows-amd64`]([])  
- **镜像 artifact 详情**：[repo-info 仓库的 `repos/openjdk/` 目录]([])（含镜像元数据、传输大小等，[历史记录]([])）  
- **镜像更新**：  
  - [official-images 仓库的 `library/openjdk` 标签]([])  
  - [official-images 仓库的 `library/openjdk` 文件]([])（[历史记录]([])）  
- **本文档来源**：[docs 仓库的 `openjdk/` 目录]([])（[历史记录]([])）  


## 什么是 OpenJDK？  
OpenJDK（Open Java Development Kit）是 Java 平台标准版（Java SE）的免费开源实现。自 Java SE 7 起，OpenJDK 成为官方参考实现。  

> 参考：[.org/wiki/OpenJDK]()  

*Java 是 Oracle 及其关联公司的注册商标。*  


## 如何使用该镜像  

### 在应用中启动 Java 实例  
最直接的用法是将 Java 容器同时作为构建和运行环境。在 `Dockerfile` 中按以下方式编写，可编译并运行项目：  

```dockerfile
FROM arm64v8/openjdk:11
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
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp arm64v8/openjdk:11 javac Main.java
```  

该命令会将当前目录挂载为容器卷，设置工作目录为该卷，然后执行 `javac Main.java` 编译 `Main.java` 并生成 `Main.class` 文件。  


### 让 JVM 识别 CPU 和 RAM 限制  
JVM 启动时会探测可用 CPU 核心数和 RAM，以调整内部参数（如垃圾回收线程数）。若容器限制了 CPU/RAM，旧版 JVM 可能仍使用主机全局资源值，导致 CPU 占用过高或内存分配错误。  

- **Linux 容器**：OpenJDK 8 及以上版本可正确识别容器限制的 CPU 和 RAM，默认启用该功能。  
- **Windows Server 容器（非 Hyper-V）**：  
  - CPU 核心限制无法自动识别，需手动设置 CPU 亲和性，例如：  
    ```console
    $ start /b /wait /affinity 0x3 path/to/java.exe ...
    ```  
    （示例中 `0x3` 为十六进制掩码，限制 JVM 使用 2 个 CPU 核心。）  
  - RAM 限制受支持，但 JVM 无法自动探测，需通过 `-XX:MaxRAM=...` 显式指定不超过容器 RAM 限制的值。  


### 环境变量名称含句点的问题  
部分 shell（如 Alpine Linux 中 BusyBox 的 `/bin/sh`）不支持名称含句点的环境变量（技术上不符合 POSIX 标准），会直接剥离这类变量（Bash 则会保留）。若应用需使用此类环境变量，可：  
- 直接使用 `CMD ["java", ...]`（不通过 shell）；  
- 安装并显式使用 Bash 替代 `/bin/sh`。  


## 镜像变体  
`arm64v8/openjdk` 提供多种变体，适用于不同场景：  

### `arm64v8/openjdk:<version>`  
默认镜像，适合大多数场景。可作为临时容器（挂载源码并启动应用）或构建其他镜像的基础。  
部分标签含 `bookworm` 或 `trixie` 等名称，这些是 [Debian]([]) 的版本代号，标识镜像基于的 Debian 版本。若需安装额外包，建议显式指定此类标签以减少 Debian 版本更新带来的兼容性问题。  


### `arm64v8/openjdk:<version>`（12 及以上版本）、`arm64v8/openjdk:<version>-oracle` 和 `arm64v8/openjdk:<version>-oraclelinux8`  
- `openjdk:12` 及以上的默认镜像、`-oracle` 和 `-oraclelinux8` 变体基于 [Oracle Linux 8 官方镜像]([])，遵循 [Oracle Linux 最终用户协议（EULA）]([]) 的 GPLv2 许可。  
- `-oraclelinux7` 变体基于 [Oracle Linux 7 官方镜像]([])，遵循 [Oracle Linux 7 EULA]([])。  
- OpenJDK 二进制文件由 Oracle 构建，源码来自 [OpenJDK 社区]([])，遵循 [GPLv2 及 Classpath 例外条款]([])。  


## 许可证  
- 镜像中软件的许可证信息：[[]]([])。  
- 所有 Docker 镜像可能包含其他软件（如 Bash 等基础发行版组件），这些软件可能采用其他许可证。  
- 自动检测到的额外许可证信息可在 [repo-info 仓库的 `openjdk/` 目录]([]) 中查看。  

使用预构建镜像时，用户需确保符合其中所有软件的许可证要求。

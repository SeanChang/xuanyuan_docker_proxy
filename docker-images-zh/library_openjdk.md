<!-- xuanyuan-docker-images-zh
image: library/openjdk
source: https://xuanyuan.cloud/zh/r/library/openjdk
canonical: https://xuanyuan.cloud/zh/r/library/openjdk
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/openjdk" title="library/openjdk Docker 镜像中文简介、标签列表与拉取命令">library/openjdk — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/openjdk" title="library/openjdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/openjdk</a></p>

# 弃用通知  

该镜像已正式弃用，建议所有用户尽快寻找并使用合适的替代方案。以下是部分官方镜像替代方案示例（按字母顺序排列，无优先级暗示）：  

- <a href="https://docker.xuanyuan.run/r/library/amazoncorretto" target="_blank">`amazoncorretto`</a>  
- <a href="https://docker.xuanyuan.run/r/library/eclipse-temurin" target="_blank">`eclipse-temurin`</a>  
- <a href="https://docker.xuanyuan.run/r/library/ibm-semeru-runtimes" target="_blank">`ibm-semeru-runtimes`</a>  
- <a href="https://docker.xuanyuan.run/r/library/ibmjava" target="_blank">`ibmjava`</a>  
- <a href="https://docker.xuanyuan.run/r/library/sapmachine" target="_blank">`sapmachine`</a>  

更多信息可查看[docker-library/openjdk#505]([])。  

2022年7月后，仅早期访问版（Early Access builds，源码来自[jdk.java.net]([])）标签会继续更新，因为上述项目均不发布或支持此类版本。  


# 快速参考  

## 维护者  
[Docker社区]([])  


## 获取帮助途径  
[Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


# 支持的标签及对应`Dockerfile`链接  

（关于“共享标签”与“简单标签”的区别，参见FAQ中的[“‘Shared’和‘Simple’标签有何不同？”]([])）  


## 简单标签（Simple Tags）  

- [`26-ea-18-jdk-oraclelinux9`, `26-ea-18-oraclelinux9`, `26-ea-jdk-oraclelinux9`, `26-ea-oraclelinux9`, `26-jdk-oraclelinux9`, `26-oraclelinux9`, `26-ea-18-jdk-oracle`, `26-ea-18-oracle`, `26-ea-jdk-oracle`, `26-ea-oracle`, `26-jdk-oracle`, `26-oracle`]([])  

- [`26-ea-18-jdk-oraclelinux8`, `26-ea-18-oraclelinux8`, `26-ea-jdk-oraclelinux8`, `26-ea-oraclelinux8`, `26-jdk-oraclelinux8`, `26-oraclelinux8`]([])  

- [`26-ea-18-jdk-trixie`, `26-ea-18-trixie`, `26-ea-jdk-trixie`, `26-ea-trixie`, `26-jdk-trixie`, `26-trixie`]([])  

- [`26-ea-18-jdk-slim-trixie`, `26-ea-18-slim-trixie`, `26-ea-jdk-slim-trixie`, `26-ea-slim-trixie`, `26-jdk-slim-trixie`, `26-slim-trixie`, `26-ea-18-jdk-slim`, `26-ea-18-slim`, `26-ea-jdk-slim`, `26-ea-slim`, `26-jdk-slim`, `26-slim`]([])  

- [`26-ea-18-jdk-bookworm`, `26-ea-18-bookworm`, `26-ea-jdk-bookworm`, `26-ea-bookworm`, `26-jdk-bookworm`, `26-bookworm`]([])  

- [`26-ea-18-jdk-slim-bookworm`, `26-ea-18-slim-bookworm`, `26-ea-jdk-slim-bookworm`, `26-ea-slim-bookworm`, `26-jdk-slim-bookworm`, `26-slim-bookworm`]([])  

- [`26-ea-18-jdk-windowsservercore-ltsc2025`, `26-ea-18-windowsservercore-ltsc2025`, `26-ea-jdk-windowsservercore-ltsc2025`, `26-ea-windowsservercore-ltsc2025`, `26-jdk-windowsservercore-ltsc2025`, `26-windowsservercore-ltsc2025`]([])  

- [`26-ea-18-jdk-windowsservercore-ltsc2022`, `26-ea-18-windowsservercore-ltsc2022`, `26-ea-jdk-windowsservercore-ltsc2022`, `26-ea-windowsservercore-ltsc2022`, `26-jdk-windowsservercore-ltsc2022`, `26-windowsservercore-ltsc2022`]([])  

- [`26-ea-18-jdk-nanoserver-ltsc2025`, `26-ea-18-nanoserver-ltsc2025`, `26-ea-jdk-nanoserver-ltsc2025`, `26-ea-nanoserver-ltsc2025`, `26-jdk-nanoserver-ltsc2025`, `26-nanoserver-ltsc2025`]([])  

- [`26-ea-18-jdk-nanoserver-ltsc2022`, `26-ea-18-nanoserver-ltsc2022`, `26-ea-jdk-nanoserver-ltsc2022`, `26-ea-nanoserver-ltsc2022`, `26-jdk-nanoserver-ltsc2022`, `26-nanoserver-ltsc2022`]([])  


## 共享标签（Shared Tags）  

- `26-ea-18-jdk`, `26-ea-18`, `26-ea-jdk`, `26-ea`, `26-jdk`, `26`:  
  - [`26-ea-18-jdk-oraclelinux9`]([])  
  - [`26-ea-18-jdk-windowsservercore-ltsc2025`]([])  
  - [`26-ea-18-jdk-windowsservercore-ltsc2022`]([])  

- `26-ea-18-jdk-windowsservercore`, `26-ea-18-windowsservercore`, `26-ea-jdk-windowsservercore`, `26-ea-windowsservercore`, `26-jdk-windowsservercore`, `26-windowsservercore`:  
  - [`26-ea-18-jdk-windowsservercore-ltsc2025`]([])  
  - [`26-ea-18-jdk-windowsservercore-ltsc2022`]([])  

- `26-ea-18-jdk-nanoserver`, `26-ea-18-nanoserver`, `26-ea-jdk-nanoserver`, `26-ea-nanoserver`, `26-jdk-nanoserver`, `26-nanoserver`:  
  - [`26-ea-18-jdk-nanoserver-ltsc2025`]([])  
  - [`26-ea-18-jdk-nanoserver-ltsc2022`]([])  


# 快速参考（续）  

## 提交问题地址  
[[]]([])  


## 支持的架构  
（更多信息参见[官方镜像文档]([])）  
[`amd64`]([])、[`arm64v8`]([])、[`windows-amd64`]([])  


## 发布的镜像工件详情  
[repo-info仓库的`repos/openjdk/`目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


## 镜像更新  
[official-images仓库的`library/openjdk`标签]([])  
[official-images仓库的`library/openjdk`文件]([])（[历史记录]([])）  


## 本文档来源  
[docs仓库的`openjdk/`目录]([])（[历史记录]([])）  


# 什么是OpenJDK？  

OpenJDK（开放Java开发工具包）是Java平台标准版（Java SE）的免费开源实现。自版本7起，OpenJDK成为Java SE的官方参考实现。  

> [.org/wiki/OpenJDK]()  

Java是Oracle及其关联公司的注册商标。  

![logo]([])  


# 如何使用此镜像  

## 在应用中启动Java实例  

使用该镜像最直接的方式是将Java容器同时作为构建和运行环境。在`Dockerfile`中，可以按以下方式编写，以编译并运行项目：  

```dockerfile
FROM openjdk:11
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```  

然后构建并运行Docker镜像：  

```console
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```  


## 在Docker容器内编译应用  

有时可能不需要在容器内运行应用，仅需编译。可通过以下命令在Docker实例内编译（但不运行）应用：  

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openjdk:11 javac Main.java
```  

该命令会将当前目录挂载为容器卷，设置工作目录为该卷，然后执行`javac Main.java`编译`Main.java`，输出`Main.class`文件。  


## 让JVM尊重CPU和RAM限制  

JVM启动时会尝试检测可用CPU核心数和RAM，以调整内部参数（如垃圾回收线程数）。若容器限制了CPU/RAM，JVM用于探测的标准系统API可能返回主机级别的值，导致旧版JVM出现CPU过度使用或内存分配错误。  

在Linux容器中，OpenJDK 8及更高版本可正确检测容器限制的CPU核心数和可用RAM，且默认启用此功能。  

在Windows Server（非Hyper-V）容器中，CPU核心数限制不生效（被主机计算服务忽略）。需手动设置限制，例如通过以下命令启动JVM：  

```console
$ start /b /wait /affinity 0x3 path/to/java.exe ...
```  

示例中，CPU亲和性十六进制掩码`0x3`将JVM限制为2个CPU核心。  

RAM限制在Windows Server容器中受支持，但JVM目前无法检测。需通过`-XX:MaxRAM=...`参数指定不超过容器RAM限制的值，避免内存分配过度。  


## 环境变量名称含点的情况  

部分shell（如Alpine Linux中包含的[BusyBox `/bin/sh`]([])）不支持名称含点的环境变量（技术上不符合POSIX标准），会将其剥离（Bash则会保留）。若应用需要此类环境变量，可直接使用`CMD ["java", ...]`（不通过shell），或安装并显式使用Bash替代`/bin/sh`。  


# 镜像变体  

`openjdk`镜像有多种版本，适用于不同场景。  

## `openjdk:<version>`  

这是默认镜像。若不确定需求，建议使用此版本。既可作为临时容器（挂载源码并启动容器运行应用），也可作为基础镜像构建其他镜像。  

部分标签含`bookworm`或`trixie`等名称，这些是[Debian]([])的版本代号，标识镜像基于哪个Debian版本。若需安装镜像自带之外的包，建议显式指定此类标签，以减少Debian版本更新时的兼容性问题。  


## `openjdk:<version>`（12及以上版本）、`openjdk:<version>-oracle` 和 `openjdk:<version>-oraclelinux8`  

从`openjdk:12`开始，默认镜像及`-oracle`、`-oraclelinux8`变体基于官方[Oracle Linux 8镜像]([])，该镜像根据[Oracle Linux最终用户协议（EULA）]([]

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/openjdk" title="library/openjdk Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/openjdk</a></p>

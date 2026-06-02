---
image: library/java
description: "此内容已弃用，不再被推荐使用，后续可能停止维护或缺乏更新支持，建议改用“openjdk”（或其他JDK实现，如Oracle JDK等），这些替代方案通常更受社区支持、更新及时且功能完善，适合继续进行Java相关的开发与应用部署工作。"
source: https://xuanyuan.cloud/zh/r/library/java
canonical: https://xuanyuan.cloud/zh/r/library/java
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/java" title="library/java Docker 镜像中文简介、标签列表与拉取命令">library/java — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/java" title="library/java Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/java</a>

# 镜像弃用通知  

此镜像已正式弃用，推荐迁移至 [`openjdk` 镜像]([])，2016年12月31日后将不再提供更新，请及时调整使用方式。  

该镜像自发布起即基于 OpenJDK 构建，2016年8月10日起官方同时提供了 [`ibmjava` 镜像]([])。为明确每个仓库应对应单一上游版本（而非语言栈或社区），此次重命名旨在优化仓库定位。  


# 支持的标签及对应 Dockerfile 链接  

## OpenJDK 6  
- `6b38-jdk`、`6b38`、`6-jdk`、`6`、`openjdk-6b38-jdk`、`openjdk-6b38`、`openjdk-6-jdk`、`openjdk-6`  
  [Dockerfile 链接]([])  
- `6b38-jre`、`6-jre`、`openjdk-6b38-jre`、`openjdk-6-jre`  
  [Dockerfile 链接]([])  


## OpenJDK 7  
- **JDK**：`7u111-jdk`、`7u111`、`7-jdk`、`7`、`openjdk-7u111-jdk`、`openjdk-7u111`、`openjdk-7-jdk`、`openjdk-7`  
  [Dockerfile 链接]([])  
- **JRE**：`7u111-jre`、`7-jre`、`openjdk-7u111-jre`、`openjdk-7-jre`  
  [Dockerfile 链接]([])  
- **Alpine 版本（JDK）**：`7u121-jdk-alpine`、`7u121-alpine`、`7-jdk-alpine`、`7-alpine`、`openjdk-7u121-jdk-alpine`、`openjdk-7u121-alpine`、`openjdk-7-jdk-alpine`、`openjdk-7-alpine`  
  [Dockerfile 链接]([])  
- **Alpine 版本（JRE）**：`7u121-jre-alpine`、`7-jre-alpine`、`openjdk-7u121-jre-alpine`、`openjdk-7-jre-alpine`  
  [Dockerfile 链接]([])  


## OpenJDK 8  
- **JDK**：`8u111-jdk`、`8u111`、`8-jdk`、`8`、`jdk`、`latest`、`openjdk-8u111-jdk`、`openjdk-8u111`、`openjdk-8-jdk`、`openjdk-8`  
  [Dockerfile 链接]([])  
- **JRE**：`8u111-jre`、`8-jre`、`jre`、`openjdk-8u111-jre`、`openjdk-8-jre`  
  [Dockerfile 链接]([])  
- **Alpine 版本（JDK）**：`8u111-jdk-alpine`、`8u111-alpine`、`8-jdk-alpine`、`8-alpine`、`jdk-alpine`、`alpine`、`openjdk-8u111-jdk-alpine`、`openjdk-8u111-alpine`、`openjdk-8-jdk-alpine`、`openjdk-8-alpine`  
  [Dockerfile 链接]([])  
- **Alpine 版本（JRE）**：`8u111-jre-alpine`、`8-jre-alpine`、`jre-alpine`、`openjdk-8u111-jre-alpine`、`openjdk-8-jre-alpine`  
  [Dockerfile 链接]([])  


## OpenJDK 9  
- **JDK**：`9-b149-jdk`、`9-b149`、`9-jdk`、`9`、`openjdk-9-b149-jdk`、`openjdk-9-b149`、`openjdk-9-jdk`、`openjdk-9`  
  [Dockerfile 链接]([])  
- **JRE**：`9-b149-jre`、`9-jre`、`openjdk-9-b149-jre`、`openjdk-9-jre`  
  [Dockerfile 链接]([])  


# 快速参考  

- **获取帮助**：  
  [Docker 社区论坛]([])、[Docker 社区 Slack]([])、[Stack Overflow]([])  

- **提交问题**：  
  [[]]([])  

- **维护者**：  
  [Docker 社区]([])  

- **镜像详情**：  
  [repo-info 仓库的 `repos/java/` 目录]([])（含元数据、传输大小等，[历史记录]([])）  

- **镜像更新**：  
  [带有 `library/java` 标签的 official-images PR]([])  
  [official-images 仓库的 `library/java` 文件]([])（[历史记录]([])）  

- **本文档来源**：  
  [docs 仓库的 `java/` 目录]([])（[历史记录]([])）  

- **支持的 Docker 版本**：  
  [最新稳定版]([])（最低支持 1.6，尽力兼容）  


# 什么是 Java？  

Java 是一种并发、基于类、面向对象的编程语言，设计目标是减少实现依赖，让开发者实现“一次编写，到处运行”——即代码无需重新编译即可在不同平台运行。  

Java 是 Oracle 及其关联公司的注册商标。  

> 更多信息：[维基百科 - Java（编程语言）]()  

![Java 标志]([])  


# 如何使用此镜像  

## 在应用中启动 Java 实例  

最直接的用法是将 Java 容器同时作为构建和运行环境。在 `Dockerfile` 中按以下方式编写，即可编译并运行项目：  

```dockerfile
FROM java:7
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


## 在容器内编译应用  

若无需在容器中运行应用，仅需编译，可执行以下命令：  

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp java:7 javac Main.java
```  

该命令会将当前目录挂载为容器卷，设置工作目录为该卷，然后执行 `javac Main.java` 编译 `Main.java` 并生成 `Main.class` 文件。  


# 为什么仅提供 OpenJDK/OpenJRE？  

主流 Linux 发行版均不自带 Oracle Java 分发，因此本镜像仅包含 OpenJDK/OpenJRE。具体原因如下：  
- Ubuntu：Oracle 终止“操作系统分发许可”后，停止在 `sun-java6` 包中提供 Oracle Java（[参考]([])）。  
- Debian：需用户手动从 Oracle 下载 tar 包，再通过 `java-package` 安装（[参考]([])）。  
- Ubuntu/Debian 的 webupd8 PPA：需用户接受 Oracle 许可协议后，才会下载安装 Oracle Java（[参考]([])）。  
- Gentoo：要求用户手动从 Oracle 网站下载 tar 包（含许可协议确认）（[参考]([])）。  
- CentOS：需用户下载 Oracle 提供的 rpm 包（[参考]([])）。  
- RedHat：需添加 Oracle 维护的仓库（[参考]([])）。  


# 镜像变体  

## `java:<version>`  

默认镜像，基于 [`buildpack-deps`]([])，包含大量常用 Debian 包，适合作为构建基础或直接运行应用，能减少衍生镜像的安装依赖，降低整体镜像体积。  


## `java:alpine`  

基于 [Alpine Linux]([])（[`alpine` 官方镜像]([])），体积极小（约 5MB），适合对最终镜像大小有严格要求的场景。  

**注意**：Alpine 使用 [musl libc]([]) 而非 glibc，部分依赖 glibc 的软件可能存在兼容性问题，但多数软件可正常运行。  


# 许可  

查看镜像中软件的许可信息：[OpenJDK 许可]([])。

---
image: arm32v7/openjdk
description: "OpenJDK的预发布/非生产环境构建版本"
source: https://xuanyuan.cloud/zh/r/arm32v7/openjdk
canonical: https://xuanyuan.cloud/zh/r/arm32v7/openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm32v7/openjdk" title="arm32v7/openjdk Docker 镜像中文简介、标签列表与拉取命令">arm32v7/openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**注意**：这是[`openjdk`官方镜像](https://hub.docker.com/_/openjdk)的`arm32v7`架构构建的“按架构”仓库——更多信息请参见官方镜像文档中的“[除amd64之外的架构？](https://github.com/docker-library/official-images#architectures-other-than-amd64)”和官方镜像FAQ中的“[Git中镜像的源代码已更改，现在该怎么办？](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)”。

# **弃用通知**

此镜像已正式弃用，建议所有用户尽快寻找并使用合适的替代方案。以下是其他官方镜像替代方案的示例（按字母顺序排列，不代表任何偏好）：

- [`amazoncorretto`](https://hub.docker.com/_/amazoncorretto)
- [`eclipse-temurin`](https://hub.docker.com/_/eclipse-temurin)
- [`ibm-semeru-runtimes`](https://hub.docker.com/_/ibm-semeru-runtimes)
- [`ibmjava`](https://hub.docker.com/_/ibmjava)
- [`sapmachine`](https://hub.docker.com/_/sapmachine)

更多信息请参见[docker-library/openjdk#505](https://github.com/docker-library/openjdk/issues/505)。

2022年7月之后，唯一将继续接收更新的标签是早期访问构建版本（源自[jdk.java.net](https://jdk.java.net/)），因为这些版本未由上述任何项目发布/支持。

# 快速参考

- **维护者**：  
  [Docker社区](https://github.com/docker-library/openjdk)

- **获取帮助**：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的`Dockerfile`链接

**警告**：此镜像在`arm32v7`架构上**不受支持**

# 快速参考（续）

- **问题提交地址**：  
  [https://github.com/docker-library/openjdk/issues](https://github.com/docker-library/openjdk/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/openjdk/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/openjdk/)、[`windows-amd64`](https://hub.docker.com/r/winamd64/openjdk/)

- **已发布镜像工件详情**：  
  [repo-info仓库的`repos/openjdk/`目录](https://github.com/docker-library/repo-info/blob/master/repos/openjdk)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/openjdk)）  
  （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的`library/openjdk`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fopenjdk)  
  [official-images仓库的`library/openjdk`文件](https://github.com/docker-library/official-images/blob/master/library/openjdk)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/openjdk)）

- **此描述的来源**：  
  [docs仓库的`openjdk/`目录](https://github.com/docker-library/docs/tree/master/openjdk)（[历史记录](https://github.com/docker-library/docs/commits/master/openjdk)）

# 什么是OpenJDK？

OpenJDK（开放Java开发工具包）是Java平台标准版（Java SE）的免费开源实现。自版本7起，OpenJDK成为Java SE的官方参考实现。

> [wikipedia.org/wiki/OpenJDK](http://en.wikipedia.org/wiki/OpenJDK)

Java是Oracle及其关联公司的注册商标。

![logo](https://raw.githubusercontent.com/docker-library/docs/a3439b66b7980d1811f6b3835a3c541747172970/openjdk/logo.png)

# 如何使用此镜像

## 在应用中启动Java实例

使用此镜像最直接的方式是将Java容器同时用作构建和运行时环境。在`Dockerfile`中，编写类似以下内容可编译并运行项目：

```dockerfile
FROM docker.xuanyuan.run/arm32v7/openjdk:11
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```

然后可以构建并运行Docker镜像：

```console
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```

## 在Docker容器内编译应用

有时可能不适合在容器内运行应用。要在Docker实例内编译（而非运行）应用，可使用类似以下命令：

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp arm32v7/openjdk:11 javac Main.java
```

这会将当前目录作为卷挂载到容器，将工作目录设置为该卷，并运行`javac Main.java`命令，该命令会让Java编译`Main.java`中的代码，并将Java类文件输出到`Main.class`。

## 让JVM尊重CPU和RAM限制

JVM启动时会尝试检测可用CPU核心数和RAM，以调整内部参数（如生成的垃圾回收线程数）。当容器以有限的CPU/RAM运行时，JVM用于探测的标准系统API会返回主机范围的值。这可能导致旧版本JVM出现CPU过度使用和内存分配错误。

在Linux容器中，OpenJDK 8及更高版本可正确检测容器限制的CPU核心数和可用RAM。对于所有当前支持的OpenJDK版本，此功能默认启用。

在Windows Server（非Hyper-V）容器中，可用CPU核心数限制不生效（被主机计算服务忽略）。要手动设置限制，可按以下方式启动JVM：

```console
$ start /b /wait /affinity 0x3 path/to/java.exe ...
```

在此示例中，CPU亲和性十六进制掩码`0x3`会将JVM限制为2个CPU核心。

Windows Server容器支持RAM限制，但JVM目前无法检测。为防止过度内存分配，必须使用`-XX:MaxRAM=...`选项，并指定不大于容器RAM限制的值。

## 名称带点的环境变量

某些shell（特别是Alpine Linux中包含的[BusyBox `/bin/sh`](https://github.com/docker-library/openjdk/issues/135)）不支持名称带点的环境变量（技术上不符合POSIX标准），因此会剥离这些变量而非传递（如Bash的行为）。如果应用需要此类环境变量，可直接使用`CMD ["java", ...]`（不使用shell），或（安装并）明确使用Bash而非`/bin/sh`。

# 许可证

查看此镜像中包含的软件的[许可证信息](http://openjdk.java.net/legal/gplv2+ce.html)。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可证（如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

一些能够自动检测到的额外许可证信息可能位于[`repo-info`仓库的`openjdk/`目录](https://github.com/docker-library/repo-info/tree/master/repos/openjdk)中。

对于任何预构建镜像的使用，镜像用户有责任确保对此镜像的任何使用都符合其中包含的所有软件的相关许可证。

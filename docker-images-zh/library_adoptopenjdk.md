<!-- xuanyuan-docker-images-zh
image: library/adoptopenjdk
source: https://xuanyuan.cloud/zh/r/library/adoptopenjdk
canonical: https://xuanyuan.cloud/zh/r/library/adoptopenjdk
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/adoptopenjdk" title="library/adoptopenjdk Docker 镜像中文简介、标签列表与拉取命令">library/adoptopenjdk — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/adoptopenjdk" title="library/adoptopenjdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/adoptopenjdk</a></p>

# ⚠️ 镜像弃用通知

**该镜像已正式弃用**，推荐使用 [`eclipse-temurin` 镜像](https://hub.docker.com/_/eclipse-temurin/) 替代。本镜像自 2021-08-01 起不再接收任何更新，请尽快调整使用方案。


# AdoptOpenJDK Docker 镜像文档


## 1. 镜像概述与主要用途

### 1.1 概述
AdoptOpenJDK Docker 镜像包含由 AdoptOpenJDK 社区构建的 OpenJDK 二进制文件，支持 HotSpot 和 Eclipse OpenJ9 两种 Java 虚拟机（JVM）实现。镜像提供 Java 开发工具包（JDK）和 Java 运行时环境（JRE）两种类型，适用于构建和运行 Java 应用程序。

### 1.2 主要用途
- 提供标准化的 Java 运行环境，用于开发、测试和部署 Java 应用
- 支持基于 HotSpot 或 OpenJ9 JVM 的应用运行需求
- 适配多种硬件架构，满足不同平台的部署需求


## 2. 核心功能与特性

### 2.1 支持的 JVM 类型
- **HotSpot**：Oracle 开发的主流 JVM，广泛用于各类 Java 应用
- **Eclipse OpenJ9**：由 IBM 贡献给 Eclipse 基金会的高性能 JVM，以低内存占用和快速启动著称

### 2.2 镜像类型
- **JDK（Java 开发工具包）**：包含编译器（`javac`）、调试工具等，适用于开发和构建场景
- **JRE（Java 运行时环境）**：仅包含运行 Java 应用所需的组件，体积更小，适用于生产环境

### 2.3 多架构支持
| JVM 类型   | 支持架构                                                                 |
|------------|--------------------------------------------------------------------------|
| HotSpot    | `amd64`、`arm32v7`、`arm64v8`、`ppc64le`、`s390x`、`windows-amd64`       |
| Eclipse OpenJ9 | `amd64`、`ppc64le`、`s390x`、`windows-amd64`                              |


## 3. 使用场景与适用范围

### 3.1 开发环境
- 使用 JDK 镜像进行 Java 应用的开发、编译和调试
- 适配多架构开发环境，支持 x86、ARM 等硬件平台

### 3.2 生产环境
- 使用 JRE 镜像运行 Java 应用，减少资源占用
- 选择 OpenJ9 JVM 优化内存使用和启动速度，适用于微服务或容器化部署

### 3.3 跨平台部署
- 支持多种硬件架构，可在服务器、嵌入式设备等不同环境中部署 Java 应用


## 4. 使用方法与配置说明

### 4.1 基础使用示例

#### 4.1.1 使用 HotSpot JRE 运行应用
创建 `Dockerfile`：
```dockerfile
FROM adoptopenjdk:11-jre-hotspot
RUN mkdir /opt/app
COPY japp.jar /opt/app
CMD ["java", "-jar", "/opt/app/japp.jar"]
```

构建并运行：
```console
docker build -t japp .
docker run -it --rm japp
```

#### 4.1.2 使用 OpenJ9 JRE 运行应用
创建 `Dockerfile`：
```dockerfile
FROM adoptopenjdk:11-jre-openj9
RUN mkdir /opt/app
COPY japp.jar /opt/app
CMD ["java", "-jar", "/opt/app/japp.jar"]
```

构建并运行：
```console
docker build -t japp .
docker run -it --rm japp
```

### 4.2 挂载主机目录运行应用
适用于需要动态更新应用 jar 包的场景：

创建 `Dockerfile`：
```dockerfile
FROM adoptopenjdk:12.0.1_12-jdk-openj9-0.14.1
CMD ["java", "-jar", "/opt/app/japp.jar"]
```

构建并运行（挂载主机目录 `/path/on/host/system/jars` 到容器 `/opt/app`）：
```console
docker build -t japp .
docker run -it -v /path/on/host/system/jars:/opt/app japp
```


## 5. 镜像变体

### 5.1 默认镜像（基于 Ubuntu）
标签格式：`adoptopenjdk:<version>`（如 `adoptopenjdk:11-jdk-hotspot`），基于 Ubuntu 系统，适用于大多数 Linux 环境。部分标签包含 Ubuntu 版本代号（如 `focal`），用于指定基础系统版本，建议显式指定以避免兼容性问题。

### 5.2 Windows Server Core 镜像
标签格式：`adoptopenjdk:<version>-windowsservercore`，基于 Windows Server Core 系统，仅支持 Windows 容器环境，需在 Windows 10 专业版/企业版（周年更新及以上）或 Windows Server 2016 及以上系统中使用。

使用前需配置 Windows 容器环境，参考 Microsoft 文档：
- [Windows Server 快速入门](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server)
- [Windows 10 快速入门](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_10)


## 6. 维护与支持

### 6.1 快速参考
- **维护者**：[AdoptOpenJDK](https://github.com/AdoptOpenJDK/openjdk-docker)
- **获取帮助**：
  - AdoptOpenJDK Slack：[https://adoptopenjdk.net/slack.html](https://adoptopenjdk.net/slack.html)
  - AdoptOpenJDK 邮件列表：[https://mail.openjdk.java.net/mailman/listinfo/adoption-discuss](https://mail.openjdk.java.net/mailman/listinfo/adoption-discuss)
  - Eclipse OpenJ9 Slack：[https://www.eclipse.org/openj9/oj9_joinslack.html](https://www.eclipse.org/openj9/oj9_joinslack.html)
- **提交 issue**：[GitHub Issues](https://github.com/AdoptOpenJDK/openjdk-docker/issues)
- **支持的标签与 Dockerfile**：[查看完整列表](https://github.com/docker-library/docs/tree/master/adoptopenjdk/README.md#supported-tags-and-respective-dockerfile-links)


## 7. 许可信息

### 7.1 Dockerfile 与脚本许可
Dockerfile 及相关脚本采用 [Apache 许可证 2.0 版](http://www.apache.org/licenses/LICENSE-2.0.html) 授权。

### 7.2 镜像中软件许可
- **Eclipse OpenJ9 + OpenJDK**：组合作品采用 [GNU GPL v2 许可证（含 Classpath 例外）](http://openjdk.java.net/legal/gplv2+ce.html)
- **OpenJDK**：采用 GNU GPL v2 许可证（含 Classpath 例外）

### 7.3 用户责任
使用本镜像时，用户需确保遵守所有包含软件的许可协议。镜像可能包含其他开源软件，其许可信息可参考 [repo-info 仓库](https://github.com/docker-library/repo-info/tree/master/repos/adoptopenjdk)。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/adoptopenjdk" title="library/adoptopenjdk Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/adoptopenjdk</a></p>

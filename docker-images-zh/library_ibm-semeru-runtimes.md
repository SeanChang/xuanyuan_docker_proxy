---
image: library/ibm-semeru-runtimes
description: "library/ibm-semeru-runtimes 是 IBM 官方提供的 OpenJDK 运行时 Docker 镜像，基于 Eclipse OpenJ9 虚拟机（JVM）构建，集成了 OpenJDK 类库，提供免费、生产级别的 Java 运行环境。该镜像以轻量、高性能、低内存占用为核心优势，支持 Java 8 至 Java 25 等多个长期支持（LTS）及最新版本，适配 amd64、arm64v8 等多架构，广泛用于企业级 Java 应用（如 Spring Boot、微服务）的容器化部署。"
source: https://xuanyuan.cloud/zh/r/library/ibm-semeru-runtimes
canonical: https://xuanyuan.cloud/zh/r/library/ibm-semeru-runtimes
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/ibm-semeru-runtimes" title="library/ibm-semeru-runtimes Docker 镜像中文简介、标签列表与拉取命令">library/ibm-semeru-runtimes — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/ibm-semeru-runtimes" title="library/ibm-semeru-runtimes Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/ibm-semeru-runtimes</a>

# IBM Semeru Runtimes Docker 镜像使用指南

## 快速参考

### 维护方
由 IBM Semeru Runtimes 官方团队维护。

### 帮助渠道
- Docker 社区支持：Docker Community Slack、Server Fault、Unix & Linux、Stack Overflow
- 官方支持：IBM Semeru Runtimes 支持页面（提供质量、路线图等详细信息）

### 支持的标签及对应 Dockerfile 链接

标签命名规则：open-Java版本-JDK/JRE-基础镜像，其中基础镜像 jammy 对应 Ubuntu 22.04，noble 对应 Ubuntu 24.04；Simple Tags 为完整标签，Shared Tags 为简化标签（自动关联最新基础镜像版本）。

#### 1. Simple Tags（完整标签）

- Java 8: open-8u462-b08-jdk-jammy、open-8u462-b08-jdk-noble（JDK）；open-8u462-b08-jre-jammy、open-8u462-b08-jre-noble（JRE）
- Java 11: open-11.0.28_6-jdk-jammy、open-11.0.28_6-jdk-noble（JDK）；open-11.0.28_6-jre-jammy、open-11.0.28_6-jre-noble（JRE）
- Java 17: open-17.0.16_8-jdk-jammy、open-17.0.16_8-jdk-noble（JDK）；open-17.0.16_8-jre-jammy、open-17.0.16_8-jre-noble（JRE）
- Java 21: open-21.0.8_9-jdk-jammy、open-21.0.8_9-jdk-noble（JDK）；open-21.0.8_9-jre-jammy、open-21.0.8_9-jre-noble（JRE）
- Java 24: open-jdk-24.0.2_12-jdk-jammy、open-jdk-24.0.2_12-jdk-noble（JDK）；open-jdk-24.0.2_12-jre-jammy、open-jdk-24.0.2_12-jre-noble（JRE）
- Java 25: open-jdk-25.0.0_36-jdk-jammy、open-jdk-25.0.0_36-jdk-noble（JDK）；open-jdk-25.0.0_36-jre-jammy、open-jdk-25.0.0_36-jre-noble（JRE）

#### 2. Shared Tags（简化标签）

- Java 8: open-8-jdk（关联 open-8u462-b08-jdk-noble）、open-8-jre（关联 open-8u462-b08-jre-noble）
- Java 11: open-11-jdk（关联 open-11.0.28_6-jdk-noble）、open-11-jre（关联 open-11.0.28_6-jre-noble）
- Java 17-25: 同理，格式为 open-版本-jdk/open-版本-jre，自动关联最新基础镜像版本

### 问题反馈地址
- GitHub Issues: https://github.com/ibmruntimes/semeru-containers/issues
- 官方支持页: https://developer.ibm.com/languages/java/semeru-runtimes/support/

### 支持的架构
amd64、arm64v8、ppc64le、s390x（覆盖 x86、ARM、Power、Z 系列服务器）

### 镜像详情
包含元数据、传输大小等信息，可查看 repo-info 仓库的 repos/ibm-semeru-runtimes/ 目录（历史记录）。

### 镜像更新
- 跟踪更新：official-images 仓库的 library/ibm-semeru-runtimes 标签
- 更新记录：official-images 仓库的 library/ibm-semeru-runtimes 文件（历史记录）

### 本文档来源
docs 仓库的 ibm-semeru-runtimes/ 目录（历史记录）


## 什么是 IBM Semeru Runtimes

IBM Semeru Runtimes 是 IBM 推出的免费开源 Java 运行时，核心特性包括：

1. **底层依赖**：基于 OpenJDK 类库（兼容 Java SE 标准）和 Eclipse OpenJ9 JVM（而非传统 HotSpot JVM）
2. **性能优势**：OpenJ9 JVM 具备低内存占用（比 HotSpot 节省约 30% 内存）、快速启动（启动时间缩短约 50%）、动态内存调整（适合微服务/容器化场景）等特点
3. **生产级保障**：提供长期支持（LTS），包含安全补丁更新，通过 Java Compatibility Kit（JCK）认证，确保与现有 Java 应用的兼容性
4. **跨平台适配**：支持 Windows、Linux、macOS 等操作系统，以及多架构（如 ARM 服务器、IBM Power 服务器），满足多样化部署需求

该镜像将 IBM Semeru Runtimes 封装为容器化环境，避免手动配置 Java 环境的繁琐，同时确保不同部署节点的环境一致性。


## 如何使用本镜像

### 场景 1：直接运行 Java JAR 包

若需部署预编译的 Java 应用（如 app.jar），可创建如下 Dockerfile：

```dockerfile
# 选择 Java 11 JDK 镜像（基础镜像为 Ubuntu Noble）
FROM library/ibm-semeru-runtimes:open-11-jdk

# 创建应用目录
RUN mkdir -p /opt/app

# 复制 JAR 包到容器
COPY app.jar /opt/app/

# 启动命令（运行 JAR 包）
CMD ["java", "-jar", "/opt/app/app.jar"]
```

构建并运行镜像：

```bash
# 构建镜像（标签为 my-java-app）
docker build -t my-java-app .

# 交互式运行容器（退出时自动删除容器）
docker run -it --rm my-java-app
```

### 场景 2：复制 JDK 到自定义基础镜像

若需基于其他基础镜像（如 Alpine、CentOS）构建环境，可从本镜像复制 JDK 目录：

```dockerfile
# 自定义基础镜像（示例：Alpine Linux）
FROM alpine:3.20

# 定义 JAVA_HOME 环境变量
ENV JAVA_HOME=/opt/java/openjdk

# 从 IBM Semeru 镜像复制 JDK（使用 Java 17 版本）
COPY --from=library/ibm-semeru-runtimes:open-17-jdk $JAVA_HOME $JAVA_HOME

# 将 Java 二进制目录加入 PATH
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# 验证 Java 版本（可选）
RUN java -version
```

### 场景 3：直接执行 Java 命令

无需构建 Dockerfile，可直接启动容器并执行 Java 命令（如编译、运行单个 .java 文件）：

```bash
# 运行 Java 版本查询
docker run --rm library/ibm-semeru-runtimes:open-11-jre java -version

# 编译并运行本地 Java 源文件（挂载本地目录到容器 /src）
docker run -it --rm -v $(pwd):/src library/ibm-semeru-runtimes:open-11-jdk sh -c "cd /src && javac HelloWorld.java && java HelloWorld"
```


## 配置说明

### 核心环境变量

- **JAVA_HOME**: /opt/java/openjdk（Java 安装根目录，容器内已预配置）
- **PATH**: ${JAVA_HOME}/bin:${PATH}（包含 Java 二进制目录，可直接执行 java/javac 等命令）

### Eclipse OpenJ9 JVM 自定义参数（可选）

由于镜像使用 OpenJ9 JVM，可通过 java 命令参数优化性能，示例：

- 限制最大堆内存：java -Xmx512m -jar app.jar（最大堆内存 512MB）
- 启用快速启动：java -Xquickstart -jar app.jar（适合微服务短生命周期场景）
- 动态内存调整：java -Xtune:virtualized -jar app.jar（优化容器化环境内存使用）


## 注意事项

### 版本选择建议
- 生产环境优先使用 LTS 版本（Java 8、11、17、21），避免非 LTS 版本（如 Java 24、25）的短期支持风险
- 避免使用 latest 标签，建议指定具体版本标签（如 open-17.0.16_8-jdk-jammy），确保环境一致性

### 架构适配
- 在 ARM 架构服务器（如 AWS Graviton、阿里云 ARM 实例）上，需选择 arm64v8 架构镜像（标签自动适配，无需额外配置）
- Power（ppc64le）、Z 系列（s390x）服务器需确保宿主机架构与镜像架构匹配

### 基础镜像差异
- jammy（Ubuntu 22.04）：兼容性更广，适合大多数企业环境
- noble（Ubuntu 24.04）：更新的基础镜像，包含较新系统库，适合需要新依赖的应用

### 安全更新
- 定期拉取最新标签镜像，获取 Java 安全补丁（IBM 会定期更新镜像以修复漏洞）
- 生产环境可通过镜像扫描工具（如 Trivy）检查潜在安全风险

### JDK 与 JRE 选择
- 仅运行已编译 JAR 包：选择 JRE 标签（如 open-11-jre），镜像体积更小
- 需要编译 Java 源码：必须选择 JDK 标签（如 open-11-jdk），包含 javac 编译器


## 许可信息

- **Dockerfile 及关联脚本**：遵循 Apache License 2.0 许可协议
- **IBM Semeru Runtime Open Edition**：遵循 GNU General Public License v2（GPLv2），并附带 Classpath Exception（允许基于该运行时构建商业应用，无需开源应用代码）
- **基础镜像软件**：镜像中包含的基础系统组件（如 Bash、Ubuntu 库）可能遵循其他开源许可（如 MIT、Apache 等），具体可查看 repo-info 仓库的 ibm-semeru-runtimes/ 目录

使用前请确保遵守所有包含软件的许可条款，商业场景需确认 GPLv2 Classpath Exception 的适用范围。

---
image: arm64v8/amazoncorretto
description: "Corretto是免费的生产就绪型Open Java Development Kit（OpenJDK）发行版。"
source: https://xuanyuan.cloud/zh/r/arm64v8/amazoncorretto
canonical: https://xuanyuan.cloud/zh/r/arm64v8/amazoncorretto
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/amazoncorretto" title="arm64v8/amazoncorretto Docker 镜像中文简介、标签列表与拉取命令">arm64v8/amazoncorretto — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/arm64v8/amazoncorretto" title="arm64v8/amazoncorretto Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/arm64v8/amazoncorretto</a>

# Amazon Corretto Docker 镜像 (arm64v8 架构)

## 镜像概述和主要用途

`arm64v8/amazoncorretto` 是 Amazon Corretto JDK 的 Docker 镜像，专为 ARM64 架构优化。Corretto 是 Open Java Development Kit (OpenJDK) 的免费、生产就绪型发行版，由 Amazon 提供长期支持，已通过 Java 技术兼容性工具包 (TCK) 认证，确保符合 Java SE 标准。

该镜像适用于在 ARM64 架构环境中运行 Java 应用程序，提供了稳定、安全且高性能的 Java 运行时环境，可作为其他 JDK 发行版的直接替代品。

![Amazon Corretto Logo](https://raw.githubusercontent.com/docker-library/docs/e7106eecc0140176d9c3dec8986f2e61b443e0fb/amazoncorretto/logo.png)

## 核心功能和特性

- **长期支持**：Amazon 提供长期安全更新，Corretto 8 支持至 2023 年 6 月，Corretto 11 支持至 2024 年 8 月
- **企业级稳定性**：包含 Amazon 内部服务使用的性能和稳定性增强补丁
- **多平台支持**：基于不同操作系统提供多种变体（Amazon Linux 2、Amazon Linux 2023、Alpine Linux）
- **安全保障**：定期更新安全补丁，支持紧急安全修复的快速发布
- **兼容性**：与 Java SE 标准完全兼容，可作为其他 JDK 的无缝替代品
- **多种镜像变体**：提供 JDK、JRE、Headless 和 Headful 等多种版本满足不同需求

## 使用场景和适用范围

- **ARM64 架构环境**：专为 ARM64 平台优化，适合在 AWS Graviton 处理器等 ARM 架构环境中部署
- **生产环境 Java 应用**：为企业级 Java 应用提供稳定可靠的运行时环境
- **容器化部署**：适合 Docker 和 Kubernetes 等容器化平台
- **开发环境**：可用于 Java 应用的开发、测试和构建
- **微服务架构**：轻量级镜像变体适合微服务部署
- **云原生应用**：与 AWS 服务生态系统紧密集成，适合云原生应用开发

## 支持的标签和版本

### Java 8
- `8`, `8u462`, `8u462-al2`, `8-al2-full`, `8-al2-jdk`, `8-al2-generic`, `8u462-al2-generic`, `8-al2-generic-jdk`, `latest`
- `8-al2023`, `8u462-al2023`, `8-al2023-jdk`, `8-al2023-jre`, `8u462-al2023-jre`
- `8-al2-native-jre`, `8u462-al2-native-jre`
- `8-al2-native-jdk`, `8u462-al2-native-jdk`
- `8-alpine3.19`, `8u462-alpine3.19`, `8-alpine3.19-full`, `8-alpine3.19-jdk`
- `8-alpine3.19-jre`, `8u462-alpine3.19-jre`
- `8-alpine3.20`, `8u462-alpine3.20`, `8-alpine3.20-full`, `8-alpine3.20-jdk`
- `8-alpine3.20-jre`, `8u462-alpine3.20-jre`
- `8-alpine3.21`, `8u462-alpine3.21`, `8-alpine3.21-full`, `8-alpine3.21-jdk`
- `8-alpine3.21-jre`, `8u462-alpine3.21-jre`
- `8-alpine3.22`, `8u462-alpine3.22`, `8-alpine3.22-full`, `8-alpine3.22-jdk`, `8-alpine`, `8u462-alpine`, `8-alpine-full`, `8-alpine-jdk`
- `8-alpine3.22-jre`, `8u462-alpine3.22-jre`, `8-alpine-jre`, `8u462-alpine-jre`

### Java 11
- `11`, `11.0.28`, `11.0.28-al2`, `11-al2-full`, `11-al2-jdk`, `11-al2-generic`, `11.0.28-al2-generic`, `11-al2-generic-jdk`
- `11-al2023`, `11.0.28-al2023`, `11-al2023-jdk`
- `11-al2023-headless`, `11.0.28-al2023-headless`
- `11-al2023-headful`, `11.0.28-al2023-headful`
- `11-al2-native-headless`, `11.0.28-al2-native-headless`
- `11-al2-native-jdk`, `11.0.28-al2-native-jdk`
- `11-alpine3.19`, `11.0.28-alpine3.19`, `11-alpine3.19-full`, `11-alpine3.19-jdk`
- `11-alpine3.20`, `11.0.28-alpine3.20`, `11-alpine3.20-full`, `11-alpine3.20-jdk`
- `11-alpine3.21`, `11.0.28-alpine3.21`, `11-alpine3.21-full`, `11-alpine3.21-jdk`
- `11-alpine3.22`, `11.0.28-alpine3.22`, `11-alpine3.22-full`, `11-alpine3.22-jdk`, `11-alpine`, `11.0.28-alpine`, `11-alpine-full`, `11-alpine-jdk`

### Java 17
- `17`, `17.0.16`, `17.0.16-al2`, `17-al2-full`, `17-al2-jdk`, `17-al2-generic`, `17.0.16-al2-generic`, `17-al2-generic-jdk`
- `17-al2023`, `17.0.16-al2023`, `17-al2023-jdk`
- `17-al2023-headless`, `17.0.16-al2023-headless`
- `17-al2023-headful`, `17.0.16-al2023-headful`
- `17-al2-native-headless`, `17.0.16-al2-native-headless`
- `17-al2-native-headful`, `17.0.16-al2-native-headful`
- `17-al2-native-jdk`, `17.0.16-al2-native-jdk`
- `17-alpine3.19`, `17.0.16-alpine3.19`, `17-alpine3.19-full`, `17-alpine3.19-jdk`
- `17-alpine3.20`, `17.0.16-alpine3.20`, `17-alpine3.20-full`, `17-alpine3.20-jdk`
- `17-alpine3.21`, `17.0.16-alpine3.21`, `17-alpine3.21-full`, `17-alpine3.21-jdk`
- `17-alpine3.22`, `17.0.16-alpine3.22`, `17-alpine3.22-full`, `17-alpine3.22-jdk`, `17-alpine`, `17.0.16-alpine`, `17-alpine-full`, `17-alpine-jdk`

### Java 21
- `21`, `21.0.8`, `21.0.8-al2`, `21-al2-full`, `21-al2-jdk`, `21-al2-generic`, `21.0.8-al2-generic`, `21-al2-generic-jdk`
- `21-al2023`, `21.0.8-al2023`, `21-al2023-jdk`
- `21-al2023-headless`, `21.0.8-al2023-headless`
- `21-al2023-headful`, `21.0.8-al2023-headful`
- `21-alpine3.19`, `21.0.8-alpine3.19`, `21-alpine3.19-full`, `21-alpine3.19-jdk`
- `21-alpine3.20`, `21.0.8-alpine3.20`, `21-alpine3.20-full`, `21-alpine3.20-jdk`
- `21-alpine3.21`, `21.0.8-alpine3.21`, `21-alpine3.21-full`, `21-alpine3.21-jdk`
- `21-alpine3.22`, `21.0.8-alpine3.22`, `21-alpine3.22-full`, `21-alpine3.22-jdk`, `21-alpine`, `21.0.8-alpine`, `21-alpine-full`, `21-alpine-jdk`

### Java 24
- `24-al2023`, `24.0.2-al2023`, `24-al2023-jdk`, `24`, `24-jdk`
- `24-al2023-headless`, `24.0.2-al2023-headless`, `24-headless`
- `24-al2023-headful`, `24.0.2-al2023-headful`, `24-headful`
- `24-alpine3.19`, `24.0.2-alpine3.19`, `24-alpine3.19-full`, `24-alpine3.19-jdk`
- `24-alpine3.20`, `24.0.2-alpine3.20`, `24-alpine3.20-full`, `24-alpine3.20-jdk`
- `24-alpine3.21`, `24.0.2-alpine3.21`, `24-alpine3.21-full`, `24-alpine3.21-jdk`
- `24-alpine3.22`, `24.0.2-alpine3.22`, `24-alpine3.22-full`, `24-alpine3.22-jdk`, `24-alpine`, `24.0.2-alpine`, `24-alpine-full`, `24-alpine-jdk`

### Java 25
- `25-al2023`, `25.0.0-al2023`, `25-al2023-jdk`, `25`, `25-jdk`
- `25-al2023-headless`, `25.0.0-al2023-headless`, `25-headless`
- `25-al2023-headful`, `25.0.0-al2023-headful`, `25-headful`
- `25-alpine3.19`, `25.0.0-alpine3.19`, `25-alpine3.19-full`, `25-alpine3.19-jdk`
- `25-alpine3.20`, `25.0.0-alpine3.20`, `25-alpine3.20-full`, `25-alpine3.20-jdk`
- `25-alpine3.21`, `25.0.0-alpine3.21`, `25-alpine3.21-full`, `25-alpine3.21-jdk`
- `25-alpine3.22`, `25.0.0-alpine3.22`, `25-alpine3.22-full`, `25-alpine3.22-jdk`, `25-alpine`, `25.0.0-alpine`, `25-alpine-full`, `25-alpine-jdk`

## 镜像变体

### 标准镜像 (`arm64v8/amazoncorretto:<version>`)
这是默认镜像，包含完整的 JDK 环境，适用于大多数场景。如果不确定需求，建议使用此镜像。它既可以作为临时容器使用（挂载源代码并启动容器运行应用），也可以作为构建其他镜像的基础。

### Alpine 镜像 (`arm64v8/amazoncorretto:<version>-alpine`)
基于 Alpine Linux 项目，镜像体积更小（约5MB基础镜像），适合对镜像大小有严格要求的场景。该变体使用 musl libc 而非 glibc，可能与某些依赖特定 libc 功能的软件不兼容。

## 使用方法和配置说明

### 基本使用

#### 检查 Java 版本
```bash
docker run --rm arm64v8/amazoncorretto:17 java -version
```

#### 运行 Java 应用
```bash
docker run --rm -v $(pwd):/app arm64v8/amazoncorretto:17 java -jar /app/your-application.jar
```

### Dockerfile 示例

#### 基于标准镜像构建应用
```dockerfile
FROM arm64v8/amazoncorretto:17

WORKDIR /app

COPY target/your-application.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

#### 基于 Alpine 镜像构建轻量级应用
```dockerfile
FROM arm64v8/amazoncorretto:17-alpine

WORKDIR /app

COPY target/your-application.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Docker Compose 配置示例

```yaml
version: '3.8'

services:
  app:
    image: arm64v8/amazoncorretto:17
    container_name: java-app
    volumes:
      - ./target/your-application.jar:/app/app.jar
    ports:
      - "8080:8080"
    environment:
      - JAVA_OPTS="-Xmx512m -Xms256m"
    entrypoint: ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
```

### 环境变量配置

可以通过环境变量配置 JVM 参数：

```bash
docker run --rm -e JAVA_OPTS="-Xmx512m -Xms256m" arm64v8/amazoncorretto:17 java $JAVA_OPTS -jar your-application.jar
```

常用的 JVM 配置参数：
- `-Xmx`: 最大堆内存
- `-Xms`: 初始堆内存
- `-XX:+UseG1GC`: 使用 G1 垃圾收集器
- `-XX:+UseContainerSupport`: 启用容器支持（自动调整 JVM 资源）
- `-Dfile.encoding`: 设置文件编码

## 安全注意事项

### CVE 漏洞处理

如果安全扫描器报告 `amazoncorretto` 镜像包含 CVE 漏洞，建议采取以下步骤：

1. **拉取更新的镜像**：首先尝试拉取最新版本的镜像
   ```bash
   docker pull arm64v8/amazoncorretto:<version>
   ```

2. **更新基础镜像包**：如果没有更新的镜像可用，运行适当的命令更新平台包
   - Alpine: `apk -U upgrade`
   - Amazon Linux: `yum update -y --security`

   Dockerfile 示例：
   ```dockerfile
   FROM arm64v8/amazoncorretto:17-alpine
   RUN apk -U upgrade
   # 其他配置...
   ```

3. **报告安全问题**：如果没有可用的更新包，请按照 [AWS 安全漏洞报告流程](https://aws.amazon.com/security/vulnerability-reporting/) 报告，或直接发送邮件至 [aws-security@amazon.com](mailto:aws-security@amazon.com)

## 维护和支持

- **维护者**: AWS JDK 团队
- **获取帮助**: Docker Community Slack、Server Fault、Unix & Linux、Stack Overflow
- **提交问题**: [https://github.com/corretto/corretto-docker/issues](https://github.com/corretto/corretto-docker/issues)
- **镜像更新**: [official-images repo's library/amazoncorretto 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Famazoncorretto)

## 许可信息

Amazon Corretto 根据 GNU 公共许可证第 2

---
image: amd64/amazoncorretto
description: "Corretto是免费、生产就绪的OpenJDK发行版。"
source: https://xuanyuan.cloud/zh/r/amd64/amazoncorretto
canonical: https://xuanyuan.cloud/zh/r/amd64/amazoncorretto
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/amazoncorretto" title="amd64/amazoncorretto Docker 镜像中文简介、标签列表与拉取命令">amd64/amazoncorretto 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Amazon Corretto Docker 镜像文档 (amd64 架构)

## 镜像概述与主要用途

**注意**：本仓库是 [amazoncorretto 官方镜像](https://hub.docker.com/_/amazoncorretto) 的 `amd64` 架构专用构建版本。更多信息请参见官方镜像文档中的 ["除 amd64 外的架构？"](https://github.com/docker-library/official-images#architectures-other-than-amd64) 和官方镜像 FAQ 中的 ["镜像源码在 Git 中变更后如何处理？"](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

Amazon Corretto 是一款免费的、生产就绪型 Open Java Development Kit (OpenJDK) 发行版，由 Amazon 提供长期支持。该 Docker 镜像基于 Corretto 构建，主要用于：
- 运行 Java 应用程序的容器化部署
- 作为构建 Java 应用程序的基础镜像
- 在开发、测试和生产环境中提供标准化的 Java 运行时环境

## 核心功能与特性

### 主要特性
- **长期支持**：Amazon 为 Corretto 提供长期安全更新（例如 Corretto 8 支持至 2023 年 6 月，Corretto 11 支持至 2024 年 8 月）
- **兼容性认证**：通过 Java 技术兼容性工具包 (TCK) 认证，确保符合 Java SE 标准
- **优化补丁**：包含 Amazon 内部验证的补丁，提升性能、稳定性及安全性（如垃圾回收调度、内存管理优化等）
- **多平台支持**：基于多种基础镜像构建，包括 Amazon Linux 2 (AL2)、Amazon Linux 2023 (AL2023) 和 Alpine Linux
- **零成本**：遵循 GPLv2 with CPE 许可协议，免费用于商业和非商业场景
- **无缝替换**：可直接替代其他 JDK 发行版，无需修改现有应用程序配置或命令行参数

## 支持的标签

以下是按 Java 版本分组的常用标签及对应 Dockerfile 链接：

### Java 8
- [`8`, `8u462`, `8u462-al2`, `8-al2-full`, `8-al2-jdk`, `8-al2-generic`, `8u462-al2-generic`, `8-al2-generic-jdk`, `latest`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/8/jdk/al2-generic/Dockerfile)
- [`8-al2023`, `8u462-al2023`, `8-al2023-jdk`, `8-al2023-jre`, `8u462-al2023-jre`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/8/jdk/al2023/Dockerfile)
- [`8-al2-native-jre`, `8u462-al2-native-jre`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/8/jre/al2/Dockerfile)
- [`8-al2-native-jdk`, `8u462-al2-native-jdk`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/8/jdk/al2/Dockerfile)
- Alpine 版本：`8-alpine3.19`、`8-alpine3.20`、`8-alpine3.21`、`8-alpine3.22` 及其衍生标签（如 `-jdk`、`-jre`）

### Java 11
- [`11`, `11.0.28`, `11.0.28-al2`, `11-al2-full`, `11-al2-jdk`, `11-al2-generic`, `11.0.28-al2-generic`, `11-al2-generic-jdk`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/11/jdk/al2-generic/Dockerfile)
- [`11-al2023`, `11.0.28-al2023`, `11-al2023-jdk`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/11/jdk/al2023/Dockerfile)
- AL2 原生版本：`11-al2-native-headless`、`11-al2-native-jdk` 及其衍生标签
- Alpine 版本：`11-alpine3.19`、`11-alpine3.20`、`11-alpine3.21`、`11-alpine3.22` 及其衍生标签

### Java 17
- [`17`, `17.0.16`, `17.0.16-al2`, `17-al2-full`, `17-al2-jdk`, `17-al2-generic`, `17.0.16-al2-generic`, `17-al2-generic-jdk`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/17/jdk/al2-generic/Dockerfile)
- [`17-al2023`, `17.0.16-al2023`, `17-al2023-jdk`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/17/jdk/al2023/Dockerfile)
- AL2 原生版本：`17-al2-native-headless`、`17-al2-native-headful`、`17-al2-native-jdk` 及其衍生标签
- Alpine 版本：`17-alpine3.19`、`17-alpine3.20`、`17-alpine3.21`、`17-alpine3.22` 及其衍生标签

### Java 21
- [`21`, `21.0.8`, `21.0.8-al2`, `21-al2-full`, `21-al2-jdk`, `21-al2-generic`, `21.0.8-al2-generic`, `21-al2-generic-jdk`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/21/jdk/al2-generic/Dockerfile)
- [`21-al2023`, `21.0.8-al2023`, `21-al2023-jdk`](https://github.com/corretto/corretto-docker/blob/da3b725e5c2e6dd6732320efc68288938486b3cd/21/jdk/al2023/Dockerfile)
- Alpine 版本：`21-alpine3.19`、`21-alpine3.20`、`21-alpine3.21`、`21-alpine3.22` 及其衍生标签

### Java 24/25
包含 `24-al2023`、`24-alpine`、`25-al2023`、`25-alpine` 等标签，具体版本及衍生标签可参考 [官方 Dockerfile 链接](https://github.com/corretto/corretto-docker)。

## 使用场景与适用范围

- **生产环境**：需要长期支持和安全更新的企业级 Java 应用
- **开发/测试**：提供与生产一致的 Java 运行时环境，减少环境差异问题
- **容器化构建**：作为多阶段构建中的基础镜像，编译和打包 Java 应用
- **微服务架构**： lightweight 镜像（如 Alpine 版本）适合资源受限的微服务部署
- **AWS 生态**：与 AWS 服务集成时的首选 Java 运行时（Amazon 内部服务广泛使用 Corretto）

## 使用方法与配置说明

### 基础信息

- **维护者**：[AWS JDK 团队](https://github.com/corretto/corretto-docker)
- **获取帮助**：[Docker Community Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Stack Overflow](https://stackoverflow.com/help/on-topic)
- **提交问题**：[GitHub Issues](https://github.com/corretto/corretto-docker/issues?q=)
- **支持架构**：`amd64`、`arm64v8`

### Docker 基本使用示例

#### 1. 检查 Java 版本
```bash
docker run --rm docker.xuanyuan.run/amd64/amazoncorretto:17 java -version
```

#### 2. 运行 Java 应用（JAR 文件）
假设当前目录有 `app.jar`，可通过以下命令运行：
```bash
docker run --rm -v $(pwd):/app -w /app docker.xuanyuan.run/amd64/amazoncorretto:17 java -jar app.jar
```

#### 3. 构建自定义镜像
创建 `Dockerfile`：
```dockerfile
FROM docker.xuanyuan.run/amd64/amazoncorretto:17-alpine
WORKDIR /app
COPY target/app.jar .
CMD ["java", "-jar", "app.jar"]
```
构建并运行：
```bash
docker build -t my-java-app .
docker run --rm docker.xuanyuan.run/my-java-app
```

### Docker Compose 配置示例

```yaml
version: '3.8'
services:
  java-app:
    image: docker.xuanyuan.run/amd64/amazoncorretto:17
    container_name: java-service
    volumes:
      - ./app:/app
    working_dir: /app
    command: java -jar app.jar
    ports:
      - "8080:8080"
    environment:
      - JAVA_OPTS="-Xmx512m -Xms256m"  # 自定义 JVM 参数
```

启动服务：
```bash
docker-compose up -d
```

## 镜像变体

`amd64/amazoncorretto` 提供多种变体，适用于不同场景：

### 1. 默认变体 (`<version>`)
- 基于 Amazon Linux 2 (AL2) 或 AL2023，包含完整 JDK
- 用途：通用场景，适合大多数 Java 应用（推荐优先选择）
- 示例：`amd64/amazoncorretto:17`、`amd64/amazoncorretto:11.0.28-al2`

### 2. Alpine 变体 (`<version>-alpine`)
- 基于 [Alpine Linux](https://alpinelinux.org)，镜像体积更小（约 5MB 基础镜像）
- 特点：使用 musl libc（替代 glibc），适合对镜像大小敏感的场景
- 限制：部分依赖 glibc 的 native 库可能不兼容
- 示例：`amd64/amazoncorretto:17-alpine`、`amd64/amazoncorretto:8-alpine3.22-jre`

### 3. JRE 变体 (`<version>-jre`)
- 仅包含 Java 运行时环境（JRE），不包含开发工具（javac 等）
- 用途：仅需运行 Java 应用，无需编译代码的场景（减小镜像体积）
- 示例：`amd64/amazoncorretto:8-al2023-jre`、`amd64/amazoncorretto:11-alpine-jre`

### 4. Headless 变体 (`<version>-headless`)
- 不包含 GUI 相关依赖（如 AWT/Swing）
- 用途：服务器端应用（无图形界面需求），进一步减小镜像体积
- 示例：`amd64/amazoncorretto:17-al2023-headless`

## 注意事项

### CVE 安全扫描问题
若安全扫描报告镜像包含 CVE 漏洞，建议按以下步骤处理：
1. **拉取最新镜像**：`docker pull docker.xuanyuan.run/amd64/amazoncorretto:<version>`
2. **更新基础镜像包**：
   - Alpine：`apk -U upgrade`
   - Amazon Linux：`yum update -y --security`
3. **提交反馈**：若问题未解决，通过 [AWS 安全漏洞报告流程](https://aws.amazon.com/security/vulnerability-reporting/) 或邮件联系 `aws-security@amazon.com`

> 注：镜像 CVE 可能源于基础镜像，需等待基础镜像维护者提供更新（Corretto 镜像会自动重建当基础镜像更新时）。

## 许可协议

- **Corretto 许可**：遵循 GNU 通用公共许可证第 2 版及类路径例外条款 ([GPLv2 with CPE](https://openjdk.java.net/legal/gplv2+ce.html))
- **基础镜像许可**：包含的其他软件（如 Bash、操作系统工具等）可能遵循不同许可，详细信息见 [repo-info 仓库](https://github.com/docker-library/repo-info/tree/master/repos/amazoncorretto)

使用前请确保符合所有包含软件的许可要求。

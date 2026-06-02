---
image: amd64/eclipse-temurin
description: "Eclipse Temurin构建的OpenJDK二进制文件官方镜像"
source: https://xuanyuan.cloud/zh/r/amd64/eclipse-temurin
canonical: https://xuanyuan.cloud/zh/r/amd64/eclipse-temurin
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/eclipse-temurin" title="amd64/eclipse-temurin Docker 镜像中文简介、标签列表与拉取命令">amd64/eclipse-temurin — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/amd64/eclipse-temurin" title="amd64/eclipse-temurin Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amd64/eclipse-temurin</a>

# Eclipse Temurin (amd64) 镜像文档

## 镜像概述与主要用途

本镜像为 [Eclipse Temurin](https://adoptium.net/) 官方镜像的 `amd64` 架构专用版本，包含由 Eclipse Temurin 项目构建的 OpenJDK 二进制文件。Eclipse Temurin 提供高性能、企业级、跨平台、开源许可且通过 Java SE TCK 测试的 Java 运行时及开发工具，适用于 Java 应用程序的开发、测试与生产环境部署。

## 核心功能与特性

- **多 Java 版本支持**：涵盖 Java 8、11、17、21、25 等多个长期支持（LTS）及最新版本。
- **多样化基础镜像**：基于 Ubuntu（Jammy、Noble）、Alpine Linux、Red Hat UBI 10/9 Minimal 等操作系统，满足不同场景需求。
- **JDK 与 JRE 分离**：提供包含完整开发工具的 JDK 版本及仅含运行时的 JRE 版本，可按需选择。
- **轻量级选项**：Alpine Linux 基础镜像版本体积小巧（约 5MB 基础镜像），适合对镜像大小敏感的场景。
- **CA 证书集成**：支持通过环境变量与卷挂载添加自定义 CA 证书，自动更新 JVM 信任库及系统 CA 存储。
- **企业级兼容性**：提供基于 UBI Minimal 的镜像，适配 Red Hat OpenShift 等企业级容器平台。

## 使用场景与适用范围

- **Java 应用容器化**：将 Java 应用（如 Spring Boot、Micronaut 等）打包为容器镜像，简化部署流程。
- **开发与测试环境**：快速搭建隔离的 Java 开发环境，支持多版本切换。
- **CI/CD 流水线**：集成到持续集成/部署流程，用于自动化测试与构建。
- **轻量级部署**：Alpine 版本适用于边缘计算、微服务等对资源受限的场景。
- **企业生产环境**：UBI Minimal 版本满足企业级安全合规要求，适合生产环境部署。

## 详细使用方法与配置说明

### 基本使用

#### 直接运行 JAR 文件

使用 `docker run` 命令直接运行 Java 应用 JAR 文件：

```bash
docker run -it --rm -v /path/to/your/app.jar:/app.jar amd64/eclipse-temurin:21 java -jar /app.jar
```

#### 通过 Dockerfile 构建应用镜像

创建包含 Java 应用的 Dockerfile：

```dockerfile
FROM amd64/eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY target/app.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

构建并运行：

```bash
docker build -t my-java-app .
docker run -it --rm -p 8080:8080 my-java-app
```

### 生成自定义 JRE

使用 `jlink` 工具创建最小化运行时，减小最终镜像体积（适用于 Java 11+）：

```dockerfile
# 阶段 1: 构建自定义 JRE
FROM amd64/eclipse-temurin:21-jdk-alpine as jre-builder
RUN $JAVA_HOME/bin/jlink \
    --add-modules java.base,java.sql,java.net.http \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /javaruntime

# 阶段 2: 构建应用镜像
FROM alpine:3.22
ENV JAVA_HOME=/opt/java/jre
ENV PATH="$JAVA_HOME/bin:$PATH"
COPY --from=jre-builder /javaruntime $JAVA_HOME
WORKDIR /app
COPY target/app.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

### 添加自定义 CA 证书

#### 基本配置

通过挂载证书目录并设置 `USE_SYSTEM_CA_CERTS` 环境变量，自动添加 CA 证书：

```bash
docker run -it --rm \
  -v /path/to/your/certs:/certificates \  # 挂载包含 .crt 证书的目录
  -e USE_SYSTEM_CA_CERTS=1 \             # 启用 CA 证书处理
  amd64/eclipse-temurin:21
```

#### 非 Root 用户与只读文件系统场景

在 OpenShift 等环境中，容器可能以非 root 用户运行或使用只读文件系统：

- **非 root 用户**：自动创建独立 JVM 信任库，通过 `JAVA_TOOL_OPTIONS` 注入，`JRE_CACERTS_PATH` 环境变量提供信任库路径。
- **只读文件系统**：需挂载可写的 `/tmp` 卷以创建临时信任库：

```bash
docker run -it --rm \
  -v /path/to/certs:/certificates \
  -v /tmp:/tmp \                        # 挂载可写 /tmp 卷
  -e USE_SYSTEM_CA_CERTS=1 \
  --user 1001 \                         # 非 root 用户
  --read-only \                         # 只读文件系统
  amd64/eclipse-temurin:21
```

## 配置参数与环境变量

| 环境变量              | 说明                                                                 |
|-----------------------|----------------------------------------------------------------------|
| `USE_SYSTEM_CA_CERTS` | 设置为任意值（如 `1`）启用自定义 CA 证书处理，需配合 `/certificates` 卷挂载。 |
| `JAVA_TOOL_OPTIONS`   | 自动注入 JVM 参数（如信任库路径），非 root 用户场景下会自动扩展。          |
| `JRE_CACERTS_PATH`    | 非 root 用户场景下，指向生成的自定义 JVM 信任库路径。                    |

## 部署示例

### Docker Run 示例

#### 运行 Spring Boot 应用

```bash
docker run -d \
  --name spring-app \
  -p 8080:8080 \
  -v /app/config:/config \          # 挂载配置文件
  -e SPRING_PROFILES_ACTIVE=prod \  # 设置 Spring 环境
  amd64/eclipse-temurin:17-jdk-jammy \
  java -jar /app.jar --spring.config.location=/config/
```

#### 添加自定义 CA 证书并运行应用

```bash
docker run -it --rm \
  -v $(pwd)/certs:/certificates \  # 当前目录下 certs 文件夹包含 .crt 证书
  -v $(pwd)/app.jar:/app.jar \
  -e USE_SYSTEM_CA_CERTS=1 \
  amd64/eclipse-temurin:21 \
  java -jar /app.jar
```

### Docker Compose 示例

创建 `docker-compose.yml` 部署 Java 应用与数据库：

```yaml
version: '3.8'
services:
  app:
    build: .
    image: my-java-app:latest
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/mydb
      - SPRING_DATASOURCE_USERNAME=user
      - SPRING_DATASOURCE_PASSWORD=pass
      - USE_SYSTEM_CA_CERTS=1  # 启用 CA 证书处理（若需）
    volumes:
      - ./certs:/certificates  # 挂载 CA 证书（若需）
    depends_on:
      - db
  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=rootpass
      - MYSQL_DATABASE=mydb
      - MYSQL_USER=user
      - MYSQL_PASSWORD=pass
    volumes:
      - db-data:/var/lib/mysql

volumes:
  db-data:
```

启动服务：

```bash
docker-compose up -d
```

## 镜像标签与变体

### 标签格式说明

镜像标签格式为：`[版本]-[jdk|jre]-[基础系统]`，其中：

- **版本**：Java 版本（如 `8u462-b08`、`11.0.28_6`、`21`、`25`），支持精确版本（带更新号）或简写版本。
- **jdk/jre**：`jdk` 包含开发工具，`jre` 仅含运行时（默认省略时为 `jdk`）。
- **基础系统**：`alpine-<版本>`（Alpine Linux）、`jammy`/`noble`（Ubuntu）、`ubi10-minimal`/`ubi9-minimal`（Red Hat UBI）。

### 主要标签列表

#### Simple Tags（部分示例）

- **Java 8**
  - `8u462-b08-jdk-alpine-3.22`, `8-jdk-alpine`, `8-alpine`（Alpine 3.22）
  - `8u462-b08-jdk-jammy`, `8-jdk-jammy`, `8-jammy`（Ubuntu Jammy）
  - `8u462-b08-jdk-ubi9-minimal`, `8-jdk-ubi9-minimal`（UBI 9 Minimal）

- **Java 11**
  - `11.0.28_6-jdk-alpine-3.22`, `11-jdk-alpine`, `11-alpine`（Alpine 3.22）
  - `11.0.28_6-jdk-noble`, `11-jdk-noble`, `11-noble`（Ubuntu Noble）
  - `11.0.28_6-jdk-ubi10-minimal`, `11-ubi10-minimal`（UBI 10 Minimal）

- **Java 17**
  - `17.0.16_8-jdk-alpine`, `17-jdk-alpine`, `17-alpine`（Alpine 最新版）
  - `17.0.16_8-jdk-jammy`, `17-jammy`（Ubuntu Jammy）

- **Java 21**
  - `21.0.8_9-jdk-alpine-3.22`, `21-jdk-alpine`, `21-alpine`（Alpine 3.22）
  - `21.0.8_9-jdk-noble`, `21-jdk`, `21`（Ubuntu Noble，默认）

- **Java 25**
  - `25_36-jdk-alpine-3.22`, `25-jdk-alpine`, `25-alpine`（Alpine 3.22）
  - `25_36-jdk-noble`, `25-jdk`, `25`, `latest`（Ubuntu Noble，最新版默认）

#### Shared Tags（共享标签）

共享标签自动指向最新稳定基础系统版本（通常为 Ubuntu Noble）：

- `8-jdk`, `8` → `8u462-b08-jdk-noble`
- `11-jdk`, `11` → `11.0.28_6-jdk-noble`
- `17-jdk`, `17` → `17.0.16_8-jdk-noble`
- `21-jdk`, `21` → `21.0.8_9-jdk-noble`
- `25-jdk`, `25`, `latest` → `25_36-jdk-noble`

### 镜像变体说明

#### `amd64/eclipse-temurin:<version>`（默认）

基于 Ubuntu 系统（如 Jammy、Noble），包含完整系统工具，适合需要安装额外依赖的场景。推荐用于生产环境，稳定性高，兼容性好。

#### `amd64/eclipse-temurin:<version>-alpine`

基于 Alpine Linux，体积小巧，使用 musl libc。适合对镜像大小要求严格的场景，但需注意部分依赖 glibc 的应用可能存在兼容性问题。

#### `amd64/eclipse-temurin:<version>-ubi<version>-minimal`

基于 Red Hat UBI Minimal，精简的企业级基础镜像，适配 OpenShift 等平台，满足安全合规需求。

## 支持与资源

### 维护与支持

- **维护者**：[Adoptium](https://github.com/adoptium/containers)
- **获取帮助**：[Adoptium Slack](https://adoptium.net/slack)、[Adoptium Support](https://github.com/adoptium/adoptium-support/issues/new/choose)
- **提交 Issue**：[GitHub Issues](https://github.com/adoptium/containers/issues)（针对镜像相关问题）

### 其他资源

- **支持架构**：`amd64`、`arm32v7`、`arm64v8`、`ppc64le`、`riscv64`、`s390x`、`windows-amd64`（本镜像为 `amd64` 专用）
- **镜像详情**：[repo-info 仓库](https://github.com/docker-library/repo-info/blob/master/repos/eclipse-temurin)（包含元数据、传输大小等）
- **更新记录**：[official-images 仓库](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Feclipse-temurin)

## 许可证

- **Dockerfile 及脚本**：[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)
- **OpenJDK 二进制文件**：[GNU GPL v2 带 Classpath Exception](https://openjdk.org/legal/gplv2+ce.html)
- **基础镜像许可证**：取决于基础系统（如 Ubuntu 为 [Ubuntu License](https://ubuntu.com/legal/terms-and-policies/intellectual-property)，Alpine 为 [MIT License](https://alpinelinux.org/licenses/)）

> 注：使用前请确保遵守所有组件的许可证要求。

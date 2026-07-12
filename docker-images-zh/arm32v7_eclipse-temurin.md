---
image: arm32v7/eclipse-temurin
description: "由Eclipse Temurin构建的OpenJDK二进制文件的官方Docker镜像。"
source: https://xuanyuan.cloud/zh/r/arm32v7/eclipse-temurin
canonical: https://xuanyuan.cloud/zh/r/arm32v7/eclipse-temurin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm32v7/eclipse-temurin" title="arm32v7/eclipse-temurin Docker 镜像中文简介、标签列表与拉取命令">arm32v7/eclipse-temurin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm32v7/eclipse-temurin Docker镜像文档

## 镜像概述和主要用途

`arm32v7/eclipse-temurin`是针对ARM 32位架构的Eclipse Temurin官方Docker镜像，提供经Java SE TCK测试的OpenJDK二进制文件。该镜像包含由Eclipse Temurin项目构建的高质量、企业级、跨平台的开源Java运行时环境，适用于在ARM 32位架构设备上运行Java应用程序。

> 注：这是[`eclipse-temurin`官方镜像](https://hub.docker.com/_/eclipse-temurin)的"每架构"仓库，专门用于`arm32v7`架构构建。

## 核心功能和特性

- 提供JDK(Java开发工具包)和JRE(Java运行时环境)两种镜像变体
- 基于Ubuntu LTS版本构建，确保稳定性和安全性
- 支持Java 8、11和17等长期支持(LTS)版本
- 可添加自定义CA证书到JVM信任存储和系统CA存储
- 支持非root用户运行和只读文件系统环境
- 符合Java SE规范并通过TCK测试，确保兼容性

## 使用场景和适用范围

- ARM 32位架构嵌入式设备上的Java应用部署
- IoT设备上运行Java微服务
- 开发和测试ARM平台上的Java应用程序
- 需要在资源受限环境中运行Java应用的场景
- 构建ARM架构的Java应用容器镜像

## 支持的标签和对应Dockerfile链接

### 简单标签(Simple Tags)

- **Java 8 JDK**:
  - [`8u462-b08-jdk-jammy`, `8-jdk-jammy`, `8-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jdk/ubuntu/jammy/Dockerfile)
  - [`8u462-b08-jdk-noble`, `8-jdk-noble`, `8-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jdk/ubuntu/noble/Dockerfile)

- **Java 8 JRE**:
  - [`8u462-b08-jre-jammy`, `8-jre-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jre/ubuntu/jammy/Dockerfile)
  - [`8u462-b08-jre-noble`, `8-jre-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jre/ubuntu/noble/Dockerfile)

- **Java 11 JDK**:
  - [`11.0.28_6-jdk-jammy`, `11-jdk-jammy`, `11-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jdk/ubuntu/jammy/Dockerfile)
  - [`11.0.28_6-jdk-noble`, `11-jdk-noble`, `11-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jdk/ubuntu/noble/Dockerfile)

- **Java 11 JRE**:
  - [`11.0.28_6-jre-jammy`, `11-jre-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jre/ubuntu/jammy/Dockerfile)
  - [`11.0.28_6-jre-noble`, `11-jre-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jre/ubuntu/noble/Dockerfile)

- **Java 17 JDK**:
  - [`17.0.16_8-jdk-jammy`, `17-jdk-jammy`, `17-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jdk/ubuntu/jammy/Dockerfile)
  - [`17.0.16_8-jdk-noble`, `17-jdk-noble`, `17-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jdk/ubuntu/noble/Dockerfile)

- **Java 17 JRE**:
  - [`17.0.16_8-jre-jammy`, `17-jre-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jre/ubuntu/jammy/Dockerfile)
  - [`17.0.16_8-jre-noble`, `17-jre-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jre/ubuntu/noble/Dockerfile)

### 共享标签(Shared Tags)

- **Java 8**:
  - `8u462-b08-jdk`, `8-jdk`, `8` (基于Ubuntu Noble)
  - `8u462-b08-jre`, `8-jre` (基于Ubuntu Noble)

- **Java 11**:
  - `11.0.28_6-jdk`, `11-jdk`, `11` (基于Ubuntu Noble)
  - `11.0.28_6-jre`, `11-jre` (基于Ubuntu Noble)

- **Java 17**:
  - `17.0.16_8-jdk`, `17-jdk`, `17` (基于Ubuntu Noble)
  - `17.0.16_8-jre`, `17-jre` (基于Ubuntu Noble)

## 详细的使用方法和配置说明

### 环境变量

| 环境变量 | 描述 |
|---------|------|
| `USE_SYSTEM_CA_CERTS` | 设置为任意值以启用CA证书处理 |
| `JAVA_TOOL_OPTIONS` | JVM启动参数，容器可能会自动添加信任存储配置 |
| `JRE_CACERTS_PATH` | 非root用户运行时，指向自定义JVM信任存储的路径 |

### 添加自定义CA证书

可以将自定义CA证书添加到容器的信任存储中，方法如下：

1. 将PEM格式的证书文件(.crt扩展名)放入宿主机的某个目录
2. 运行容器时挂载该目录到容器的`/certificates`目录
3. 设置`USE_SYSTEM_CA_CERTS`环境变量

```bash
docker run -v $(pwd)/certs:/certificates/ -e USE_SYSTEM_CA_CERTS=1 docker.xuanyuan.run/arm32v7/eclipse-temurin:17
```

#### 特殊环境注意事项

- **非root用户运行**：系统CA存储无法更新，但会创建单独的JVM信任存储，路径通过`JRE_CACERTS_PATH`环境变量提供
- **只读文件系统**：需要在`/tmp`目录挂载可写卷以创建新的信任存储

### 基本使用示例

#### 运行简单Java应用

```dockerfile
FROM docker.xuanyuan.run/arm32v7/eclipse-temurin:17
RUN mkdir /opt/app
COPY your-app.jar /opt/app/
CMD ["java", "-jar", "/opt/app/your-app.jar"]
```

构建并运行：

```bash
docker build -t your-java-app .
docker run -it --rm docker.xuanyuan.run/your-java-app
```

#### 直接运行JAR文件

```bash
docker run -it --rm -v $(pwd)/your-app.jar:/app.jar docker.xuanyuan.run/arm32v7/eclipse-temurin:17 java -jar /app.jar
```

#### 使用外部配置文件

```bash
docker run -it --rm -v $(pwd)/config:/config -v $(pwd)/your-app.jar:/app.jar docker.xuanyuan.run/arm32v7/eclipse-temurin:17 java -jar /app.jar --spring.config.location=/config/
```

### 使用jlink创建自定义JRE

对于Java 11及以上版本，可以使用jlink创建自定义运行时镜像：

```dockerfile
# 构建阶段：创建自定义JRE
FROM docker.xuanyuan.run/arm32v7/eclipse-temurin:17-jdk-jammy as jre-build

# 创建最小化的JRE
RUN $JAVA_HOME/bin/jlink \
         --add-modules java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

# 运行阶段：使用自定义JRE
FROM docker.xuanyuan.run/arm32v7/ubuntu:jammy
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME

COPY your-app.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
```

### 使用docker-compose部署

```yaml
version: '3.8'
services:
  java-app:
    image: docker.xuanyuan.run/arm32v7/eclipse-temurin:17
    container_name: java-service
    volumes:
      - ./your-app.jar:/app.jar
      - ./certs:/certificates
    environment:
      - USE_SYSTEM_CA_CERTS=1
      - JAVA_OPTS=-Xmx512m
    restart: unless-stopped
    command: ["java", "-jar", "/app.jar"]
```

## 维护和支持

- **维护者**: [Adoptium](https://github.com/adoptium/containers)
- **获取帮助**: [Adoptium Slack](https://adoptium.net/slack); [Adoptium Support](https://github.com/adoptium/adoptium-support/issues/new/choose)
- **提交问题**: [GitHub Issues](https://github.com/adoptium/containers/issues)

## 许可证信息

- Dockerfiles和相关脚本: [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)
- OpenJDK: GNU GPL v2 with Classpath Exception

镜像中包含的其他软件可能具有不同的许可证，如基础发行版中的Bash等。用户有责任确保对该镜像的任何使用符合其中包含的所有软件的相关许可证。

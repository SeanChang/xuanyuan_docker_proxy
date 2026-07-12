---
image: epicsoft/openjdk
description: "基于官方镜像构建的Java OpenJDK Docker镜像，包含JDK和JRE，适用于Java应用的开发与运行环境。"
source: https://xuanyuan.cloud/zh/r/epicsoft/openjdk
canonical: https://xuanyuan.cloud/zh/r/epicsoft/openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/epicsoft/openjdk" title="epicsoft/openjdk Docker 镜像中文简介、标签列表与拉取命令">epicsoft/openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenJDK Docker镜像文档


## 镜像概述和主要用途

本镜像由[epicsoft LLC](https://epicsoft.one)管理并持续更新，提供基于官方镜像构建的OpenJDK JDK（Java开发工具包）和JRE（Java运行时环境）Docker镜像。JDK版本适用于Java应用的构建环境（如CI/CD流水线），JRE版本适用于Java应用的运行时环境，二者均基于轻量级Alpine Linux系统，确保镜像体积小、资源占用低。


## 核心功能与特性

- **双版本支持**：提供JDK（构建环境）和JRE（运行时环境）两种镜像，满足开发到部署全流程需求。  
- **轻量级基础**：JRE镜像直接基于`alpine`官方镜像，JDK镜像基于`docker:dind`（Docker-in-Docker）间接依赖Alpine，均继承Alpine Linux的轻量特性。  
- **定期更新**：每周自动构建，确保基础镜像、Java版本及依赖包为最新稳定版。  
- **扩展工具包**：预装必要系统依赖，包括：  
  - 通用包（JDK/JRE均包含）：`ca-certificates`（证书支持）、`ttf-dejavu`（字体支持）；  
  - JDK独有包：`jq`（JSON处理工具，便于构建流程中的数据解析）。  


## 版本信息

| 镜像标签组                          | 基础镜像                  | Java版本       | Alpine包版本                          | 更新周期 |
|-----------------------------------|-------------------------|---------------|-------------------------------------|--------|
| `jdk` `jdk21` `jdk21.0.8` `jdk21-latest` `jdk-latest` | `docker:28.3.2-dind`（间接基于`alpine:3.22.1`） | JDK 21.0.8    | `openjdk21-jdk-21.0.8_p9-r0`        | 每周    |
| `jre` `jre21` `jre21.0.8` `jre21-latest` `jre-latest` `latest` | `alpine:3.22.1`         | JRE 21.0.8    | `openjdk21-jre-21.0.8_p9-r0`        | 每周    |
| `jdk17` `jdk17.0.16` `jdk17-latest` | `docker:28.3.2-dind`（间接基于`alpine:3.22.1`） | JDK 17.0.16   | `openjdk17-jdk-17.0.16_p8-r0`       | 每周    |
| `jre17` `jre17.0.16` `jre17-latest` | `alpine:3.22.1`         | JRE 17.0.16   | `openjdk17-jre-17.0.16_p8-r0`       | 每周    |
| `jdk11` `jdk11.0.28` `jdk11-latest` | `docker:28.3.2-dind`（间接基于`alpine:3.22.1`） | JDK 11.0.28   | `openjdk11-jdk-11.0.28_p6-r0`       | 每周    |
| `jre11` `jre11.0.28` `jre11-latest` | `alpine:3.22.1`         | JRE 11.0.28   | `openjdk11-jre-11.0.28_p6-r0`       | 每周    |

> 注：旧版本可查看GitLab仓库子目录：[OpenJDK 11](https://gitlab.com/epicsoft-networks/openjdk/tree/main/openjdk11)、[OpenJDK 17](https://gitlab.com/epicsoft-networks/openjdk/tree/main/openjdk17)、[OpenJDK 21](https://gitlab.com/epicsoft-networks/openjdk/tree/main/openjdk21)。


## 使用场景和适用范围

### JDK镜像（`jdk*`标签）
- **CI/CD构建流水线**：用于Java项目的编译、测试、打包（如Maven/Gradle构建）。  
- **开发环境**：本地开发时快速搭建统一的Java构建环境。  
- **Docker镜像构建**：结合`docker:dind`特性，在容器内构建其他Docker镜像（需挂载Docker socket）。

### JRE镜像（`jre*`标签、`latest`）
- **生产环境部署**：运行已编译的Java应用（如Spring Boot、微服务jar包）。  
- **轻量级运行时**：适用于资源受限环境（如边缘设备、轻量容器平台）。  


## 使用方法和配置说明

### 1. GitLab CI/CD流水线配置
使用JDK镜像在GitLab CI中构建Java项目并推送Docker镜像：

```yaml
# .gitlab-ci.yml
stages:
  - build

variables:
  VERSION: "1.0.0" 

exampleProjectBuild:
  stage: build
  image: docker.xuanyuan.run/epicsoft/openjdk:jdk-latest  # 使用最新JDK镜像
  services:
    - docker:dind  # 启用Docker-in-Docker服务
  variables:
    DOCKER_IMAGE: $CI_REGISTRY:$VERSION  # 目标镜像地址
    JAVA_JAR_PATH: build/libs  # 构建产物路径
  before_script:
    - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY  # 登录私有仓库
  after_script:
    - docker logout $CI_REGISTRY  # 登出仓库
  script:
    - ./gradlew build --warning-mode all  # 执行Gradle构建
    # 构建并推送应用镜像（基于JRE运行时）
    - docker build -t $DOCKER_IMAGE . --build-arg JAR_FILE=$JAVA_JAR_PATH/exampleProject-${VERSION}.jar --build-arg VERSION=$VERSION --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
    - docker push $DOCKER_IMAGE
```


### 2. 直接运行Java应用（JRE镜像）
使用`docker run`命令启动Java应用：

```bash
# 运行Spring Boot应用（假设当前目录有app.jar）
docker run -d \
  --name java-app \
  -p 8080:8080 \  # 映射端口（应用端口:容器端口）
  -v $(pwd)/app.jar:/app.jar \  # 挂载本地jar包到容器
  -e JAVA_OPTS="-Xmx512m -Xms256m" \  # 自定义JVM参数
  -e JAVA_TIMEZONE="Asia/Shanghai" \  # 设置时区为上海
  epicsoft/openjdk:jre-latest  # 使用最新JRE镜像
```


### 3. Docker Compose配置
通过`docker-compose.yml`管理多服务应用：

```yaml
# docker-compose.yml
version: '3.8'

services:
  java-app:
    image: docker.xuanyuan.run/epicsoft/openjdk:jre-latest  # JRE运行时镜像
    container_name: java-app
    restart: always  # 自动重启
    ports:
      - "8080:8080"  # 端口映射
    volumes:
      - ./app.jar:/app.jar  # 挂载应用jar包
    environment:
      - JAVA_SERVER="-server"  # 启用服务器VM模式
      - JAVA_DOCKER="-XX:+UseContainerSupport -XX:MaxRAMPercentage=70"  # 容器内存配置（限制70%可用RAM）
      - JAVA_SECURITY="-Djava.security.egd=file:/dev/./urandom"  # 优化随机数生成
      - JAVA_ENCODING="-Dfile.encoding=UTF-8"  # 设置文件编码
      - JAVA_TIMEZONE="-Duser.timezone=Asia/Shanghai"  # 时区配置
      - JAVA_ERROR="-XX:+ExitOnOutOfMemoryError"  # OOM时退出容器
      - JAVA_OPTS="-Xmx1g"  # 自定义JVM参数（如堆内存）
```

启动命令：`docker-compose up -d`


### 4. 基于JRE镜像构建应用镜像（Dockerfile）
创建自定义应用镜像，继承本JRE镜像：

```dockerfile
# Dockerfile
FROM docker.xuanyuan.run/epicsoft/openjdk:jre-latest  # 基础镜像：最新JRE

# 构建参数（可通过docker build --build-arg传入）
ARG VERSION="development"
ARG BUILD_DATE="development"

# 镜像元数据
LABEL org.label-schema.name="exampleProject" \
      org.label-schema.description="Example Java application" \
      org.label-schema.version="$VERSION" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date="$BUILD_DATE"

# JVM配置环境变量（可在运行时通过-e覆盖）
ENV JAVA_SERVER="-server" \  # 启用服务器VM模式（优化长时间运行应用）
    JAVA_DOCKER="-XX:+UseContainerSupport -XX:MaxRAMPercentage=80" \  # 容器内存支持，使用80%可用RAM
    JAVA_SECURITY="-Djava.security.egd=file:/dev/./urandom" \  # 加速随机数生成（避免阻塞）
    JAVA_ENCODING="-Dfile.encoding=UTF-8" \  # 默认UTF-8编码
    JAVA_TIMEZONE="-Duser.timezone=GMT" \  # 默认时区GMT
    JAVA_ERROR="-XX:+ExitOnOutOfMemoryError" \  # 内存溢出时退出容器
    JAVA_OPTS=""  # 用户自定义JVM参数（运行时追加）

# 复制应用jar包（通过--build-arg JAR_FILE指定路径）
ARG JAR_FILE
COPY $JAR_FILE /app.jar

# 暴露应用端口
EXPOSE 8080

# 启动命令（拼接所有JVM参数并执行jar包）
ENTRYPOINT [ "sh", "-c", "java $JAVA_SERVER $JAVA_DOCKER $JAVA_SECURITY $JAVA_ENCODING $JAVA_TIMEZONE $JAVA_ERROR $JAVA_OPTS -jar /app.jar" ]
```

构建命令：  
`docker build -t my-java-app:1.0 --build-arg JAR_FILE=./build/libs/app.jar --build-arg VERSION=1.0 --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') .`


### 环境变量说明
JRE镜像支持通过环境变量自定义JVM行为，默认值及作用如下：

| 环境变量          | 默认值                                      | 说明                                  |
|-------------------|---------------------------------------------|---------------------------------------|
| `JAVA_SERVER`     | `-server`                                   | 启用服务器VM模式（优化吞吐量和长时间运行） |
| `JAVA_DOCKER`     | `-XX:+UseContainerSupport -XX:MaxRAMPercentage=80` | 容器支持：自动检测容器内存限制，使用80%可用RAM |
| `JAVA_SECURITY`   | `-Djava.security.egd=file:/dev/./urandom`   | 指定随机数生成器（避免/dev/random阻塞） |
| `JAVA_ENCODING`   | `-Dfile.encoding=UTF-8`                     | 设置默认文件编码为UTF-8               |
| `JAVA_TIMEZONE`   | `-Duser.timezone=GMT`                       | 设置JVM时区（如Asia/Shanghai）        |
| `JAVA_ERROR`      | `-XX:+ExitOnOutOfMemoryError`               | JVM内存溢出时立即退出容器              |
| `JAVA_OPTS`       | 空                                          | 用户自定义JVM参数（如`-Xmx1g -Xms512m`） |


## 许可证
本镜像使用[MIT许可证](https://gitlab.com/epicsoft-networks/openjdk/blob/main/LICENSE)（仅适用于epicsoft LLC创建的文件）。第三方软件（如OpenJDK、Alpine Linux）可能遵循其各自的许可证。


## 相关链接
- Docker Hub：[epicsoft/openjdk](https://hub.docker.com/r/epicsoft/openjdk)  
- GitLab仓库：[epicsoft-networks/openjdk](https://gitlab.com/epicsoft-networks/openjdk/tree/main)  
- 容器Registry：[GitLab Container Registry](https://gitlab.com/epicsoft-networks/openjdk/container_registry)

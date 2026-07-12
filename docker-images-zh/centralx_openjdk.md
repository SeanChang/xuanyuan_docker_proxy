---
image: centralx/openjdk
description: "封装Azul Zulu OpenJDK的Docker镜像，为Java可执行程序提供运行环境，支持JDK/JRE多版本及Ubuntu、Alpine系统。"
source: https://xuanyuan.cloud/zh/r/centralx/openjdk
canonical: https://xuanyuan.cloud/zh/r/centralx/openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/centralx/openjdk" title="centralx/openjdk Docker 镜像中文简介、标签列表与拉取命令">centralx/openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenJDK

## 概述
本镜像封装了 Azul Zulu OpenJDK[[链接](https://www.azul.com)]，为 Java 可执行程序提供可靠的运行环境。

## 版本号

### 命名规则
本镜像的 tag 遵循 `[jdk/jre]${major/version}[-${os}]` 的命名规则，例如:

- `centralx/openjdk:8`: Ubuntu 系统中的 OpenJDK 8 (JDK)
- `centralx/openjdk:jre11`: Ubuntu 系统中的 OpenJDK 11 (JRE)
- `centralx/openjdk:jdk17.0.9-alpine`: Alpine 系统中的 OpenJDK 17.0.9 (JDK)
- `centralx/openjdk:21-ubuntu`: Ubuntu 系统中的 OpenJDK 21 (JDK)

### 支持的版本号
本镜像支持以下 OpenJDK 版本:

- OpenJDK 8: `8`、`8.0.432`、`8.0.422`、`8.0.402`、`8.0.392`
- OpenJDK 11: `11`、`11.0.25`、`11.0.24`、`11.0.22`、`11.0.21`
- OpenJDK 17: `17`、`17.0.13`、`17.0.12`、`17.0.10`、`17.0.9`
- OpenJDK 21: `21`、`21.0.5`、`21.0.4`、`21.0.2`、`21.0.1`

### 支持的系统
本镜像支持以下操作系统:

- Ubuntu Jammy: `ubuntu`
- Alpine 3: `alpine`

## 核心功能与特性

- **可靠的OpenJDK发行版**: 基于Azul Zulu OpenJDK，提供经过测试和验证的Java运行环境
- **多版本支持**: 覆盖OpenJDK 8、11、17、21等主流LTS版本及最新版本
- **灵活的系统选择**: 支持Ubuntu (完整系统) 和 Alpine (轻量级系统)，满足不同场景需求
- **JDK/JRE可选**: 通过tag指定JDK或JRE，减少资源占用（JRE仅包含运行时环境）

## 使用场景

- Java应用程序的容器化部署
- 确保开发、测试和生产环境中Java版本一致性
- CI/CD流程中集成Java应用构建或运行步骤
- 轻量级Java服务部署（选用Alpine系统版本）

## 使用方法

### 基本使用

#### 查看Java版本
```bash
docker run --rm docker.xuanyuan.run/centralx/openjdk:17 java -version
```

#### 运行Java应用JAR文件
将本地JAR文件挂载到容器中并运行：
```bash
docker run --rm -v /path/to/your/app.jar:/app.jar docker.xuanyuan.run/centralx/openjdk:11 java -jar /app.jar
```

### Docker Compose配置示例

创建`docker-compose.yml`文件：
```yaml
version: '3'
services:
  java-app:
    image: docker.xuanyuan.run/centralx/openjdk:17-alpine
    volumes:
      - ./app.jar:/app.jar
    command: java -jar /app.jar
    environment:
      - JAVA_OPTS=-Xmx512m -Xms256m
```

启动服务：
```bash
docker-compose up
```

### 环境变量

- **JAVA_HOME**: 容器内Java安装路径，默认已设置（例如`/usr/lib/jvm/zulu-openjdk`）
- **JAVA_OPTS**: 可自定义JVM参数，如内存配置、系统属性等，在运行命令中使用

## 注意事项

- 选择JRE版本可减小镜像体积，适合仅需运行Java应用的场景；JDK版本包含开发工具，适合需要编译或调试的场景
- Alpine系统版本体积更小，但部分原生库可能与Ubuntu系统存在差异，需注意应用兼容性
- 建议使用具体版本tag（如`17.0.13`）而非主版本tag（如`17`），以确保环境一致性

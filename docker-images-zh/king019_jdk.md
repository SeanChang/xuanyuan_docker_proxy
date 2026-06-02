<!-- xuanyuan-docker-images-zh
image: king019/jdk
source: https://xuanyuan.cloud/zh/r/king019/jdk
canonical: https://xuanyuan.cloud/zh/r/king019/jdk
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/king019/jdk" title="king019/jdk Docker 镜像中文简介、标签列表与拉取命令">king019/jdk — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/king019/jdk" title="king019/jdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/king019/jdk</a></p>

# JDK Docker镜像

## 概述
本镜像基于官方JDK构建，提供稳定的Java运行环境，适用于开发、测试及生产环境中Java应用程序的部署。支持多种JDK版本（如8、11、17等），可根据需求选择对应标签版本。

## 特性
- 基于轻量化基础镜像（如Alpine Linux），减少镜像体积
- 预配置JAVA_HOME环境变量，便于应用程序引用
- 包含常用Java工具（如javac、java、jar等）
- 支持多架构（amd64、arm64）

## 使用场景
- 开发环境：快速搭建本地Java开发环境，避免版本冲突
- 持续集成/持续部署（CI/CD）：作为构建或运行阶段的基础镜像
- 生产环境：部署Spring Boot、微服务等Java应用程序

## 使用方法

### 基本运行
```bash
docker run -it --rm [镜像名称]:[标签] java -version
```
此命令将输出JDK版本信息，验证环境是否正常。

### 部署Java应用
1. 将Java应用程序JAR包挂载到容器中：
```bash
docker run -d -v /path/to/your/app.jar:/app/app.jar --name java-app [镜像名称]:[标签] java -jar /app/app.jar
```

2. 编译并运行Java源代码（开发场景）：
```bash
# 假设本地有HelloWorld.java文件，路径为./src/HelloWorld.java
docker run -it --rm -v $(pwd)/src:/src [镜像名称]:[标签] sh -c "cd /src && javac HelloWorld.java && java HelloWorld"
```

## 环境变量
- `JAVA_HOME`: Java安装路径，默认值为`/usr/lib/jvm/default-java`
- `JAVA_OPTS`: 启动Java应用时的额外参数，如`-Xmx512m`（可通过`docker run -e JAVA_OPTS="-Xmx512m"`设置）

## 版本标签
- `8`: JDK 8版本
- `11`: JDK 11版本
- `17`: JDK 17版本（LTS）
- `latest`: 最新稳定LTS版本

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/king019/jdk" title="king019/jdk Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/king019/jdk</a></p>

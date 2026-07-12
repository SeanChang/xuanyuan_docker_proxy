---
image: bellsoft/liberica-openjdk-rocky
description: "Liberica JDK是由BellSoft开发的100%开源Java运行时，适用于现代Java部署，支持x86_64和aarch64架构，提供安全、高效的Java运行环境，适用于桌面、服务器、云和嵌入式场景。"
source: https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-rocky
canonical: https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-rocky
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bellsoft/liberica-openjdk-rocky" title="bellsoft/liberica-openjdk-rocky Docker 镜像中文简介、标签列表与拉取命令">bellsoft/liberica-openjdk-rocky 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# bellsoft/liberica-openjdk-rocky

## 什么是Liberica JDK？
Liberica JDK是一款免费且100%开源的渐进式Java运行时，适用于现代Java部署。由BellSoft开发并提供支持，BellSoft是OpenJDK的主要贡献者。使用Liberica JDK进行应用开发具有以下特点：

* **灵活性**：支持广泛的架构和操作系统，是适用于桌面、服务器、云和嵌入式用例的统一Java运行时。
* **成本和时间效益**：基于Liberica Lite和Alpine Linux构建的容器体积小，可最小化部署时间并降低云支出。
* **安全性**：通过Java SE规范的TCK验证，每次发布前均经过全面漏洞测试。CPU发布周期确保及时提供安全补丁和错误修复。

[Liberica JDK被Spring推荐并使用](https://spring.io/quickstart)作为Spring Native应用程序的端到端解决方案。BellSoft为全球各行各业的数百万开发人员和公司提供服务。更多信息，请访问[www.bell-sw.com](https://www.bell-sw.com)。

## 如何选择最佳Java镜像？
我们编制了一个交互式方案，帮助您确定哪个BellSoft镜像最适合您的项目。
![如何选择最佳Java镜像](https://download.bell-sw.com/static/images/how-to-choose-optimal-java-image.jpg)

## 此镜像包含什么？
本仓库包含适用于Rocky Linux的Liberica JDK镜像，支持以下架构：

* x86_64 (amd64)
* aarch64 (ARM64)

标签指向Java版本（紧跟在操作系统名称之后）和支持的架构。镜像名称结构为X-Y，其中X是Java版本，Y是架构类型。如果名称中未包含架构类型，则默认支持AMD64和ARM64。'latest'标签指向最新版本。标签中包含'-cds'的镜像包含CDS（类数据共享）归档。

例如，[bellsoft/liberica-openjdk-rocky:8u432-7-x86_64](https://hub.docker.com/layers/bellsoft/liberica-openjdk-rocky/8u432-7-x86_64/images/sha256-3e36546c8525d36a26bd6005eecb6c403db9a54b4d3ce9ca901c65609eb70544?context=explore)是适用于Rocky Linux、运行在AMD64架构上的Liberica JDK 8u432版本镜像。

## 标签
* [`latest`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/25/Dockerfile), [`latest-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/25/Dockerfile), [`25`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/25/Dockerfile), [`25-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/25/Dockerfile)
* [`24`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/24/Dockerfile), [`24-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/24/Dockerfile)
* [`23`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/23/Dockerfile), [`23-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/23/Dockerfile)
* [`21.0.8`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile), [`21.0.8-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile), [`21.0.7`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile), [`21.0.7-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile), [`21.0.6`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile), [`21.0.6-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile), [`21`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile), [`21-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/21/Dockerfile)
* [`17.0.16`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile), [`17.0.16-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile), [`17.0.15`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile), [`17.0.15-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile), [`17.0.14`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile), [`17.0.14-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile), [`17`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile), [`17-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/17/Dockerfile)
* [`11.0.28`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile), [`11.0.28-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile), [`11.0.27`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile), [`11.0.27-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile), [`11.0.26`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile), [`11.0.26-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile), [`11`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile), [`11-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/11/Dockerfile)
* [`8u462`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8u462-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8u452`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8u452-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8u442`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8u442-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8u`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8u-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile), [`8-cds`](https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-rocky/8/Dockerfile)

## 使用方法

### 基础使用
运行Liberica OpenJDK 17容器并检查版本：
`docker run -it --rm bellsoft/liberica-openjdk-rocky:17 java -version`

### 运行应用程序
可通过挂载卷运行应用程序：
`docker run -it --rm -v /home/user/project/:/data bellsoft/liberica-openjdk-rocky:latest java -jar /data/MyApp.jar`

### 特定版本选项

* **JDK 8u* 版本**
  * `LIBERICA_USE_LITE` - 定义JDK内容。`0`表示保持JDK不变，`1`（默认）创建精简版镜像（移除演示、示例和源代码）。

* **JDK 11* 和 JDK 17* 版本**
  * `LIBERICA_IMAGE_VARIANT` - 镜像变体选项：
    * `base` - 包含`java.base`模块的服务器VM
    * `base-minimal` - 包含`java.base`模块的最小VM
    * `lite`（默认）- 最小占用空间的精简JDK
    * `standard` - 标准JDK
  * `LIBERICA_VM` - VM类型选项：
    * `server`（默认）- 添加server VM
    * `client` - 添加client VM
    * `minimal` - 添加minimal VM
    * `all` - 添加所有VM

## Docker部署方案示例

### 1. 基础部署
```dockerfile
FROM docker.xuanyuan.run/bellsoft/liberica-openjdk-rocky:17
WORKDIR /app
COPY target/app.jar /app/
CMD ["java", "-jar", "app.jar"]
```
构建并运行：
`docker build -t my-app . && docker run -d -p 8080:8080 my-app`

### 2. 使用环境变量自定义
```dockerfile
FROM docker.xuanyuan.run/bellsoft/liberica-openjdk-rocky:17
ENV LIBERICA_IMAGE_VARIANT=standard
ENV LIBERICA_VM=server
WORKDIR /app
COPY target/app.jar /app/
CMD ["java", "-XX:+UseContainerSupport", "-jar", "app.jar"]
```

### 3. 使用CDS优化启动时间
```dockerfile
FROM docker.xuanyuan.run/bellsoft/liberica-openjdk-rocky:17-cds
WORKDIR /app
COPY target/app.jar /app/
CMD ["java", "-jar", "app.jar"]
```

### 4. 多阶段构建减小镜像体积
```dockerfile
# 构建阶段
FROM docker.xuanyuan.run/maven:3.8-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

# 运行阶段
FROM docker.xuanyuan.run/bellsoft/liberica-openjdk-rocky:17
WORKDIR /app
COPY --from=builder /app/target/app.jar .
CMD ["java", "-jar", "app.jar"]
```

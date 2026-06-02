---
image: ringcentral/jdk
description: "这是一个包含glibc和JDK的阿尔卑斯Linux镜像，它融合了阿尔卑斯Linux轻量级、高效的系统特性与glibc的广泛兼容性，同时集成JDK以提供完整的Java开发及运行环境，适用于需在精简系统中部署Java应用的场景，有效解决了原生阿尔卑斯Linux使用musl libc可能导致的兼容性问题，为开发者打造了既精简又功能完善的运行载体。"
source: https://xuanyuan.cloud/zh/r/ringcentral/jdk
canonical: https://xuanyuan.cloud/zh/r/ringcentral/jdk
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ringcentral/jdk" title="ringcentral/jdk Docker 镜像中文简介、标签列表与拉取命令">ringcentral/jdk — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ringcentral/jdk" title="ringcentral/jdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ringcentral/jdk</a>

# JDK


## 构建状态

- **Oracle JDK 8**  
  ![Build JDK 8]([])  

- **AdoptOpenJDK 11**  
  ![Build AdoptOpenJDK 11]([])  


## 镜像说明

本镜像基于最新版官方 Alpine Docker 镜像构建，基础镜像信息可查看：[Alpine 官方镜像]([])。  

### Oracle JDK 8  
- **拉取命令**：  
  ```bash
  docker pull ringcentral/jdk:8u202
  ```  

- **版本信息**：  
  ```bash
  java version "1.8.0_202"
  Java(TM) SE Runtime Environment (build 1.8.0_202-b08)
  Java HotSpot(TM) 64-Bit Server VM (build 25.202-b08, mixed mode)
  javac 1.8.0_202
  ```  


### AdoptOpenJDK 11  
- **拉取命令**：  
  ```bash
  docker pull ringcentral/maven:3.6.3-jdk11.0.7
  ```  

- **版本信息**：  
  ```bash
  Picked up JAVA_TOOL_OPTIONS: -XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle
  openjdk version "11.0.7" 2020-04-14
  OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.7+10)
  OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.7+10, mixed mode)
  Picked up JAVA_TOOL_OPTIONS: -XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle
  javac 11.0.7
  ```  


## 如何使用此镜像  

### 在应用中启动 Java 实例  
最简便的方式是将 Java 容器同时作为构建和运行环境。在 Dockerfile 中，可以像下面这样编写，实现项目的编译和运行：  

```Docker
FROM ringcentral/jdk:latest
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```  

构建并运行 Docker 镜像的命令如下：  
```bash
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```  


## 获取镜像  

拉取最新版镜像：  
```bash
docker pull ringcentral/jdk:latest
```  

更多详细信息可参考以下链接：  
- [GitHub 仓库]([])  
- [Docker Hub 镜像页]([])

---
image: amd64/tomcat
description: "Apache Tomcat是Java Servlet和JavaServer Pages技术的开源实现，主要用于运行Java Web应用。"
source: https://xuanyuan.cloud/zh/r/amd64/tomcat
canonical: https://xuanyuan.cloud/zh/r/amd64/tomcat
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/tomcat" title="amd64/tomcat Docker 镜像中文简介、标签列表与拉取命令">amd64/tomcat 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Tomcat Docker镜像文档

## 镜像概述和主要用途

本镜像是[Tomcat官方镜像](https://hub.docker.com/_/tomcat)的`amd64`架构专用仓库，Apache Tomcat（简称Tomcat）是由Apache软件基金会开发的开源Web服务器和Servlet容器。它实现了Java Servlet和JavaServer Pages（JSP）规范，提供纯Java环境用于运行Java Web应用程序。在简单配置下，Tomcat以单进程模式运行，通过Java虚拟机（JVM）处理HTTP请求，每个请求由独立线程处理。

## 核心功能和特性

- **规范支持**：实现Java Servlet和JSP规范，兼容Java EE标准
- **纯Java环境**：完全基于Java开发，具备跨平台运行能力
- **多线程处理**：通过独立线程处理每个HTTP请求，支持高并发
- **可配置性**：提供灵活的配置文件（如`server.xml`、`web.xml`），支持自定义服务器行为
- **轻量级架构**：相比完整Java EE服务器更轻量，资源占用低
- **安全性**：默认禁用示例Web应用，遵循上游安全建议
- **扩展性**：支持多种连接器（HTTP、AJP等）和生命周期监听器

## 使用场景和适用范围

- **Java Web应用部署**：作为生产环境中的Java Web应用服务器，运行Servlet、JSP应用
- **开发测试环境**：快速搭建本地开发环境，验证Web应用功能
- **CI/CD流水线**：集成到持续集成/部署流程，自动化测试和部署Java应用
- **微服务架构**：作为微服务架构中的应用节点，处理HTTP请求
- **教学和演示**：用于Java Web开发教学，展示Servlet和JSP技术实现

## 支持的标签及Dockerfile链接

### Tomcat 11.x

| 标签格式 | 示例标签 | Dockerfile链接 |
|----------|----------|----------------|
| JDK 25 + Temurin + Ubuntu Noble | `11.0.13-jdk25-temurin-noble`, `11-jdk25-temurin-noble`, `jdk25-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jdk25/temurin-noble/Dockerfile) |
| JRE 25 + Temurin + Ubuntu Noble | `11.0.13-jre25-temurin-noble`, `11-jre25-temurin-noble`, `jre25-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jre25/temurin-noble/Dockerfile) |
| JDK 25 + Temurin + Ubuntu Jammy | `11.0.13-jdk25-temurin-jammy`, `11-jdk25-temurin-jammy` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jdk25/temurin-jammy/Dockerfile) |
| JRE 25 + Temurin + Ubuntu Jammy | `11.0.13-jre25-temurin-jammy`, `11-jre25-temurin-jammy` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jre25/temurin-jammy/Dockerfile) |
| JDK 21 + Temurin + Ubuntu Noble | `11.0.13-jdk21-temurin-noble`, `11-jdk21-temurin-noble`, `jdk21-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jdk21/temurin-noble/Dockerfile) |
| JRE 21 + Temurin + Ubuntu Noble | `11.0.13-jre21-temurin-noble`, `11-jre21-temurin-noble`, `jre21-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jre21/temurin-noble/Dockerfile) |
| JDK 17 + Temurin + Ubuntu Noble | `11.0.13-jdk17-temurin-noble`, `11-jdk17-temurin-noble`, `jdk17-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jdk17/temurin-noble/Dockerfile) |
| JRE 17 + Temurin + Ubuntu Noble | `11.0.13-jre17-temurin-noble`, `11-jre17-temurin-noble`, `jre17-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/1ecfffb225b58096cf8b93aed73fa25c2320d99c/11.0/jre17/temurin-noble/Dockerfile) |

### Tomcat 10.x

| 标签格式 | 示例标签 | Dockerfile链接 |
|----------|----------|----------------|
| JDK 25 + Temurin + Ubuntu Noble | `10.1.48-jdk25-temurin-noble`, `10-jdk25-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/480e55f6c958e717cc9aa8923cffa4fa3d362133/10.1/jdk25/temurin-noble/Dockerfile) |
| JRE 25 + Temurin + Ubuntu Noble | `10.1.48-jre25-temurin-noble`, `10-jre25-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/480e55f6c958e717cc9aa8923cffa4fa3d362133/10.1/jre25/temurin-noble/Dockerfile) |
| JDK 21 + Temurin + Ubuntu Noble | `10.1.48-jdk21-temurin-noble`, `10-jdk21-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/480e55f6c958e717cc9aa8923cffa4fa3d362133/10.1/jdk21/temurin-noble/Dockerfile) |
| JRE 21 + Temurin + Ubuntu Noble | `10.1.48-jre21-temurin-noble`, `10-jre21-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/480e55f6c958e717cc9aa8923cffa4fa3d362133/10.1/jre21/temurin-noble/Dockerfile) |
| JDK 17 + Temurin + Ubuntu Noble | `10.1.48-jdk17-temurin-noble`, `10-jdk17-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/480e55f6c958e717cc9aa8923cffa4fa3d362133/10.1/jdk17/temurin-noble/Dockerfile) |
| JRE 17 + Temurin + Ubuntu Noble | `10.1.48-jre17-temurin-noble`, `10-jre17-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/480e55f6c958e717cc9aa8923cffa4fa3d362133/10.1/jre17/temurin-noble/Dockerfile) |

### Tomcat 9.x

| 标签格式 | 示例标签 | Dockerfile链接 |
|----------|----------|----------------|
| JDK 25 + Temurin + Ubuntu Noble | `9.0.111-jdk25-temurin-noble`, `9-jdk25-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jdk25/temurin-noble/Dockerfile) |
| JRE 25 + Temurin + Ubuntu Noble | `9.0.111-jre25-temurin-noble`, `9-jre25-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jre25/temurin-noble/Dockerfile) |
| JDK 21 + Temurin + Ubuntu Noble | `9.0.111-jdk21-temurin-noble`, `9-jdk21-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jdk21/temurin-noble/Dockerfile) |
| JRE 21 + Temurin + Ubuntu Noble | `9.0.111-jre21-temurin-noble`, `9-jre21-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jre21/temurin-noble/Dockerfile) |
| JDK 17 + Temurin + Ubuntu Noble | `9.0.111-jdk17-temurin-noble`, `9-jdk17-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jdk17/temurin-noble/Dockerfile) |
| JRE 17 + Temurin + Ubuntu Noble | `9.0.111-jre17-temurin-noble`, `9-jre17-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jre17/temurin-noble/Dockerfile) |
| JDK 8 + Temurin + Ubuntu Noble | `9.0.111-jdk8-temurin-noble`, `9-jdk8-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jdk8/temurin-noble/Dockerfile) |
| JRE 8 + Temurin + Ubuntu Noble | `9.0.111-jre8-temurin-noble`, `9-jre8-temurin-noble` | [链接](https://github.com/docker-library/tomcat/blob/64514e960376b7e889c705ce48f6a57af1cff0de/9.0/jre8/temurin-noble/Dockerfile) |

> **标签说明**：标签格式为`[Tomcat版本]-[JDK/JRE版本]-[JVM提供商]-[基础镜像]`，如`11.0.13-jdk25-temurin-noble`表示Tomcat 11.0.13、JDK 25、Temurin JVM、基于Ubuntu Noble。

## 详细使用方法和配置说明

### 基本运行

运行默认Tomcat服务器（使用`catalina.sh run`启动）：

```bash
docker run -it --rm docker.xuanyuan.run/amd64/tomcat:latest
```

### 端口映射

将容器的8080端口映射到主机的8888端口，便于外部访问：

```bash
docker run -it --rm -p 8888:8080 docker.xuanyuan.run/amd64/tomcat:9.0
```

访问`http://localhost:8888`或`http://主机IP:8888`即可访问Tomcat（默认无Web应用，会显示404页面）。

### 部署Web应用

通过挂载本地Web应用到容器的`webapps`目录部署应用：

```bash
docker run -it --rm -p 8080:8080 -v /path/to/your/webapp:/usr/local/tomcat/webapps/your-webapp docker.xuanyuan.run/amd64/tomcat:latest
```

> **注意**：上游提供的示例Web应用默认未启用，位于容器内`/usr/local/tomcat/webapps.dist`目录，如需启用可复制到`webapps`目录：
> ```bash
> docker run -it --rm -p 8080:8080 amd64/tomcat:latest bash -c "cp -r /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps/ && catalina.sh run"
> ```

### Docker Compose部署

创建`docker-compose.yml`文件：

```yaml
version: '3.8'
services:
  tomcat:
    image: docker.xuanyuan.run/amd64/tomcat:11.0-jdk21-temurin-noble
    container_name: tomcat-server
    ports:
      - "8080:8080"  # HTTP端口
      - "8009:8009"  # AJP端口（如需要）
    volumes:
      - ./webapps:/usr/local/tomcat/webapps  # 挂载Web应用目录
      - ./conf:/usr/local/tomcat/conf        # 挂载配置文件目录（可选）
      - tomcat-logs:/usr/local/tomcat/logs   # 挂载日志目录
    environment:
      - CATALINA_OPTS=-Xms512m -Xmx1024m     # JVM内存配置
      - TZ=Asia/Shanghai                     # 设置时区
    restart: unless-stopped

volumes:
  tomcat-logs:  # 持久化日志数据
```

启动服务：

```bash
docker-compose up -d
```

### 配置文件

Tomcat配置文件位于容器内`/usr/local/tomcat/conf/`目录，主要配置文件包括：

- `server.xml`：服务器核心配置（端口、连接器、引擎等）
- `web.xml`：Web应用默认配置
- `tomcat-users.xml`：用户认证配置
- `context.xml`：上下文配置

如需自定义配置，可通过挂载本地配置文件覆盖：

```bash
docker run -it --rm -p 8080:8080 -v /path/to/your/server.xml:/usr/local/tomcat/conf/server.xml docker.xuanyuan.run/amd64/tomcat:latest
```

### 添加管理用户

默认`tomcat-users.xml`中无用户配置，无法访问"/manager/html"管理页面。需编辑`tomcat-users.xml`添加用户：

```xml
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <user username="admin" password="securepassword" roles="manager-gui,admin-gui"/>
</tomcat-users>
```

挂载修改后的配置文件启动：

```bash
docker run -it --rm -p 8080:8080 -v /path/to/your/tomcat-users.xml:/usr/local/tomcat/conf/tomcat-users.xml docker.xuanyuan.run/amd64/tomcat:latest
```

## 配置参数与环境变量

容器内

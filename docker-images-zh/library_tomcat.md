<!-- xuanyuan-docker-images-zh
image: library/tomcat
source: https://xuanyuan.cloud/zh/r/library/tomcat
canonical: https://xuanyuan.cloud/zh/r/library/tomcat
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/tomcat" title="library/tomcat Docker 镜像中文简介、标签列表与拉取命令">library/tomcat — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/tomcat" title="library/tomcat Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/tomcat</a></p>

# Tomcat Docker镜像介绍


## 快速参考

### 维护者  
由[Docker社区]([])维护。


### 获取帮助  
可通过以下渠道获取支持：  
- [Docker社区Slack]([])  
- [Server Fault]([])  
- [Unix & Linux Stack Exchange]([])  
- [Stack Overflow]([])  


## 支持的标签及对应Dockerfile链接  

以下标签按Tomcat版本分类，每个版本包含不同JDK/JRE、Java发行版（Temurin/Corretto）及基础镜像（Ubuntu Noble/Jammy、Amazon Linux 2）组合，标签后附Dockerfile源码链接。


### Tomcat 11.0.x  
#### JDK系列（开发环境，含编译器）  
- **JDK 25（Temurin）**  
  - 基于Ubuntu Noble：`11.0.12-jdk25-temurin-noble`、`11.0-jdk25-temurin-noble`、`11-jdk25-temurin-noble`、`jdk25-temurin-noble`、`11.0.12-jdk25-temurin`、`11.0-jdk25-temurin`、`11-jdk25-temurin`、`jdk25-temurin`、`11.0.12-jdk25`、`11.0-jdk25`、`11-jdk25`、`jdk25`、`11.0.12`、`11.0`、`11`、`latest`  
    [Dockerfile]([])  
  - 基于Ubuntu Jammy：`11.0.12-jdk25-temurin-jammy`、`11.0-jdk25-temurin-jammy`、`11-jdk25-temurin-jammy`、`jdk25-temurin-jammy`  
    [Dockerfile]([])  

- **JDK 21（Temurin）**  
  - 基于Ubuntu Noble：`11.0.12-jdk21-temurin-noble`、`11.0-jdk21-temurin-noble`、`11-jdk21-temurin-noble`、`jdk21-temurin-noble`、`11.0.12-jdk21-temurin`、`11.0-jdk21-temurin`、`11-jdk21-temurin`、`jdk21-temurin`、`11.0.12-jdk21`、`11.0-jdk21`、`11-jdk21`、`jdk21`  
    [Dockerfile]([])  
  - 基于Ubuntu Jammy：`11.0.12-jdk21-temurin-jammy`、`11.0-jdk21-temurin-jammy`、`11-jdk21-temurin-jammy`、`jdk21-temurin-jammy`  
    [Dockerfile]([])  

- **JDK 17（Temurin）**  
  - 基于Ubuntu Noble：`11.0.12-jdk17-temurin-noble`、`11.0-jdk17-temurin-noble`、`11-jdk17-temurin-noble`、`jdk17-temurin-noble`、`11.0.12-jdk17-temurin`、`11.0-jdk17-temurin`、`11-jdk17-temurin`、`jdk17-temurin`、`11.0.12-jdk17`、`11.0-jdk17`、`11-jdk17`、`jdk17`  
    [Dockerfile]([])  
  - 基于Ubuntu Jammy：`11.0.12-jdk17-temurin-jammy`、`11.0-jdk17-temurin-jammy`、`11-jdk17-temurin-jammy`、`jdk17-temurin-jammy`  
    [Dockerfile]([])  


#### JRE系列（运行环境，不含编译器）  
- **JRE 25（Temurin）**  
  - 基于Ubuntu Noble：`11.0.12-jre25-temurin-noble`、`11.0-jre25-temurin-noble`、`11-jre25-temurin-noble`、`jre25-temurin-noble`、`11.0.12-jre25-temurin`、`11.0-jre25-temurin`、`11-jre25-temurin`、`jre25-temurin`、`11.0.12-jre25`、`11.0-jre25`、`11-jre25`、`jre25`  
    [Dockerfile]([])  
  - 基于Ubuntu Jammy：`11.0.12-jre25-temurin-jammy`、`11.0-jre25-temurin-jammy`、`11-jre25-temurin-jammy`、`jre25-temurin-jammy`  
    [Dockerfile]([])  

- **JRE 21（Temurin）**、**JRE 17（Temurin）** 结构同上，分别对应JDK 21、17的JRE版本，标签及Dockerfile链接可参考原始标签列表。  


### Tomcat 10.1.x  
支持JDK/JRE 25/21/17/11（Temurin），基于Ubuntu Noble/Jammy，标签格式与11.0类似（如`10.1.47-jdk25-temurin-noble`）。详细标签及Dockerfile链接可参考原始列表。  


### Tomcat 9.0.x  
除支持JDK/JRE 25/21/17/11/8（Temurin，基于Ubuntu Noble/Jammy）外，还支持Corretto发行版（基于Amazon Linux 2，如`9.0.110-jdk21-corretto-al2`）。详细标签及Dockerfile链接可参考原始列表。  


## 快速参考（续）  

### 提交issue  
若遇到问题，可在[GitHub仓库]([])提交issue。  


### 支持的架构  
包括`amd64`、`arm32v7`、`arm64v8`、`ppc64le`、`riscv64`、`s390x`（[架构详情]([])）。  


### 镜像详情  
镜像元数据、传输大小等信息可在[repo-info仓库的tomcat目录]([])查看。  


### 镜像更新  
镜像更新记录可通过[official-images仓库的library/tomcat标签]([])或[Dockerfile历史]([])追踪。  


### 描述来源  
本文档内容来源于[docs仓库的tomcat目录]([])。  


## 什么是Tomcat？  

Apache Tomcat是Apache软件基金会开发的开源Web服务器及Servlet容器，实现Java Servlet和JavaServer Pages（JSP）规范，提供纯Java环境运行Java代码。默认单进程运行，每个HTTP请求由独立线程处理。  

> 更多信息：[维基百科]()  


## 使用方法  

### 基本运行  
默认命令为`catalina.sh run`，直接启动Tomcat：  
```bash
docker run -it --rm tomcat:9.0
```  
（`--rm`表示容器退出后自动删除，`-it`启用交互终端）  


### 端口映射  
若需外部访问，将容器8080端口映射到主机端口（如8888）：  
```bash
docker run -it --rm -p 8888:8080 tomcat:9.0
```  
访问`[]  


### 环境变量与配置  
默认环境变量：  
- `CATALINA_BASE`、`CATALINA_HOME`：`/usr/local/tomcat`  
- `CATALINA_TMPDIR`：`/usr/local/tomcat/temp`  
- `JRE_HOME`：`/usr`  
- `CLASSPATH`：`/usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar`  

配置文件位于`/usr/local/tomcat/conf/`。如需使用`/manager/html`管理界面，需在`tomcat-users.xml`中定义具有`manager-gui`角色的用户。  


### 启用默认webapps  
默认情况下，上游提供的示例webapps未启用（遵循[安全建议]([])），但保留在`webapps.dist`目录。可通过以下方式启用：  
```bash
# 启动时将webapps.dist复制为webapps
docker run -it --rm -p 8888:8080 tomcat:9.0 sh -c "cp -r webapps.dist/* webapps && catalina.sh run"
```  


## 许可证  

- 软件许可证：[Apache License 2.0]([])  
- 镜像可能包含基础系统（如Bash）及依赖软件，其许可证需用户自行确认合规性。  
- 自动检测的许可证信息可参考[repo-info仓库]([])。  

使用前请确保遵守所有包含软件的许可证要求。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/tomcat" title="library/tomcat Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/tomcat</a></p>

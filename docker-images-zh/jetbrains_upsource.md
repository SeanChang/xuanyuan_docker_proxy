---
image: jetbrains/upsource
description: "JetBrains Upsource官方Docker镜像，用于团队代码审查与协作。"
source: https://xuanyuan.cloud/zh/r/jetbrains/upsource
canonical: https://xuanyuan.cloud/zh/r/jetbrains/upsource
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jetbrains/upsource" title="jetbrains/upsource Docker 镜像中文简介、标签列表与拉取命令">jetbrains/upsource 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# JetBrains Upsource Docker镜像文档


## 1. 镜像概述和主要用途  
本镜像为JetBrains Upsource的官方Docker镜像，适用于代码审查、项目管理及源代码分析场景，支持评估环境快速部署与生产环境稳定运行。Upsource是一款集成化代码协作工具，提供多语言代码导航、智能分析及团队协作功能。


## 2. 核心功能和特性  
- **多语言支持**：原生支持Java、Kotlin、JavaScript、PHP、Python等语言的代码导航与分析，部分语言需集成第三方工具。  
- **数据持久化**：通过卷映射（Volume Mount）确保配置、数据、日志及备份文件持久化存储，避免容器删除导致数据丢失。  
- **灵活配置**：支持通过配置文件自定义环境参数、JVM选项及Hub集成设置。  
- **安全运行**：以非root账户（13001:13001）运行服务，降低权限风险。  
- **升级兼容性**：提供Minor（小版本）和Major（大版本）升级路径，支持备份恢复机制。  
- **第三方工具集成**：可扩展集成源代码分析所需的第三方工具，支持自定义镜像构建。  


## 3. 使用场景和适用范围  
- **开发团队协作**：中小型开发团队进行代码审查、版本跟踪及项目管理。  
- **源代码集中分析**：需对多语言项目进行统一代码质量分析与问题定位的场景。  
- **评估与生产环境**：支持短期功能评估（非持久化配置）及长期生产部署（需卷映射）。  
- **用户规模**：免费支持最多10用户，超出需商业许可。  


## 4. 详细的使用方法和配置说明  

### 4.1 拉取镜像  
从Docker Hub拉取指定版本的镜像，版本标签需包含Upsource发行版及构建号：  
```bash
docker pull docker.xuanyuan.run/jetbrains/upsource:{version}
```  
> 版本标签列表参见[Docker Hub Tags](https://hub.docker.com/r/jetbrains/upsource/tags/)。


### 4.2 查看支持的命令  
通过`help`命令查看镜像入口点支持的命令：  
```bash
docker run -it --rm docker.xuanyuan.run/jetbrains/upsource:{version} help
```  


### 4.3 启动Upsource服务  
#### 4.3.1 基础启动命令  
通过以下命令启动Upsource容器，需映射必要目录以确保数据持久化：  
```bash
docker run -it --name upsource-server-instance  \
    -v {宿主机数据目录}:/opt/upsource/data \
    -v {宿主机配置目录}:/opt/upsource/conf  \
    -v {宿主机日志目录}:/opt/upsource/logs  \
    -v {宿主机备份目录}:/opt/upsource/backups  \
    -p {宿主机端口}:8080 \
    docker.xuanyuan.run/jetbrains/upsource:{version}
```  

#### 4.3.2 参数说明  
| 占位符                | 描述                                                                 |
|-----------------------|----------------------------------------------------------------------|
| `{宿主机数据目录}`    | 存储Apache Cassandra数据库文件，新实例需为空目录；**生产环境必须映射**，否则容器删除后数据丢失。 |
| `{宿主机配置目录}`    | 存储环境设置、JVM选项、Hub集成配置等文件。                           |
| `{宿主机日志目录}`    | 存储服务运行日志文件。                                               |
| `{宿主机备份目录}`    | 存储自动/手动备份文件，备份管理详情参见[Upsource文档](https://www.jetbrains.com/help/upsource/backing-up-and-restoring-data.html#CreatingSchedulingBackups)。 |
| `{宿主机端口}`        | 宿主机端口，映射容器内8080端口（Upsource默认服务端口）。             |

> **注意**：非生产环境（如测试/演示）可省略目录映射，但数据会存储在匿名卷中，存在容器删除后丢失的风险，且难以定位文件路径。


#### 4.3.3 目录权限配置  
Upsource服务以非root账户`13001:13001`运行，首次启动前需为宿主机目录设置权限：  
```bash
# 创建目录并设置权限（权限掩码750）
mkdir -p -m 750 {宿主机数据目录} {宿主机日志目录} {宿主机配置目录} {宿主机备份目录}

# 递归设置目录所有者为13001:13001
chown -R 13001:13001 {宿主机数据目录} {宿主机日志目录} {宿主机配置目录} {宿主机备份目录}
```  


### 4.4 访问运行中的服务  
服务启动后，通过宿主机IP和映射端口访问：  
- 容器内默认地址：`0.0.0.0:8080`  
- 外部访问地址：`http://{宿主机IP}:{宿主机端口}`  


### 4.5 停止Upsource服务  
#### 4.5.1 优雅停止  
通过容器内命令触发服务正常关闭：  
```bash
docker exec {容器ID} stop
```  

#### 4.5.2 外部信号停止  
使用`docker stop`命令并指定超时时间（建议30分钟，确保数据写入完成）：  
```bash
docker stop -t 1800 {容器ID}  # 1800秒=30分钟
```  
> **警告**：直接使用`docker kill`或未指定超时的`docker stop`可能导致数据 corruption。


### 4.6 配置Upsource  
#### 4.6.1 首次启动配置向导  
首次启动时，服务会在默认端口启动浏览器配置向导，支持设置管理员账户、基础URL等参数。配置完成后跳转至Upsource欢迎页面。  

#### 4.6.2 命令行配置  
通过`configure`命令可跳过向导或修改现有配置（需停止服务）：  
```bash
docker run -it --rm \
    -v {宿主机数据目录}:/opt/upsource/data \
    -v {宿主机配置目录}:/opt/upsource/conf  \
    -v {宿主机日志目录}:/opt/upsource/logs  \
    -v {宿主机备份目录}:/opt/upsource/backups  \
    docker.xuanyuan.run/jetbrains/upsource:{version} \
    configure \
    {配置参数}
```  
- `{配置参数}`：支持产品属性（如`--base-url`）或JVM选项（如`-J-Xmx4g`）。  
- 查看参数格式：执行`docker run -it jetbrains/upsource:{version} help`。  

#### 4.6.3 跳过配置向导  
首次启动时若需直接使用默认配置，需通过`configure`命令禁用向导并显式设置`base-url`：  
```bash
docker run -it --rm \
    -v {宿主机数据目录}:/opt/upsource/data \
    -v {宿主机配置目录}:/opt/upsource/conf  \
    docker.xuanyuan.run/jetbrains/upsource:{version} \
    configure \
    -J-Ddisable.configuration.wizard.on.clean.install=true \
    --base-url={外部访问URL}  # 如http://upsource.example.com:8080
```  


## 5. 源代码分析工具  
Upsource对部分语言的高级分析功能依赖第三方工具（如Python解释器、PHP环境等）。具体需求参见[项目配置指南](https://www.jetbrains.com/help/upsource/creating-a-project-code-intelligence.html)。可基于官方镜像构建包含第三方工具的自定义镜像，示例Dockerfile参见[GitHub仓库](https://github.com/JetBrains/upsource-with-tools-docker)。


## 6. 升级Upsource  

### 6.1 Minor升级（小版本）  
适用于同一主版本内的bugfix更新（如`3.5.xxxx`→`3.5.yyyy`）：  
1. 停止当前容器：`docker stop {容器ID}`。  
2. 拉取新版本镜像：`docker pull docker.xuanyuan.run/jetbrains/upsource:{新版本标签}`。  
3. 使用原卷映射命令启动新容器：数据会自动迁移，启动后通过日志或控制台输出的“Upgrade Wizard URL”完成升级向导。  


### 6.2 Major升级（大版本）  
适用于跨主版本更新（如`3.5.xxxx`→`2017.1.yyyy`），需通过备份恢复：  
1. **创建备份**：在当前实例运行时生成备份（存储于`{宿主机备份目录}`）。  
2. **停止服务**：`docker stop {容器ID}`。  
3. **清理目录**：删除`{宿主机数据目录}`和`{宿主机配置目录}`下的所有文件。  
4. **准备备份**：确保备份目录（日期命名的文件夹）位于`{宿主机备份目录}`下。  
5. **拉取新镜像**：`docker pull docker.xuanyuan.run/jetbrains/upsource:{新版本标签}`。  
6. **启动新容器**：使用原卷映射命令启动，通过配置向导选择“Upgrade”并指定备份路径，完成后服务自动启动。  


## 7. 许可证  
本镜像遵循Upsource许可协议，免费支持最多10用户永久使用。商业许可详情参见[JetBrains Upsource Licensing](https://www.jetbrains.com/upsource/buy/license.html)。


## 8. 发布说明  
当前版本发布说明可在[Upsource下载页](https://www.jetbrains.com/upsource/download)查看；历史版本发布说明参见[Previous Upsource Releases](https://www.jetbrains.com/upsource/download/previous.html)。


## 9. 反馈  
问题反馈或功能建议请提交至[Upsource Issue Tracker](https://youtrack.jetbrains.com/issues/UP)。


## 10. 底层信息  
本镜像基于以下基础组件构建：  
- 操作系统：`debian:stretch-slim`  
- JDK环境：Amazon Corretto Jdk 8u222  


## 11. Upsource分布式集群  
如需部署大规模分布式集群（支持1000+用户或超大型代码库），可参考[分布式安装文档](https://www.jetbrains.com/help/upsource/upsource-distributed-installation.html)。相关组件镜像包括：  
- `jetbrains/upsource-analyzer`  
- `jetbrains/upsource-frontend`  
- `jetbrains/upsource-opscenter`  
- `jetbrains/upsource-psi-broker`  
- `jetbrains/upsource-psi-agent`  
- `jetbrains/upsource-cluster-init`  
- `jetbrains/upsource-proxy`  
- `jetbrains/upsource-file-clustering`

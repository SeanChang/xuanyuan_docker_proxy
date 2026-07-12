---
image: hiromuhota/webspoon
description: "webSpoon是基于Web的Spoon，是Pentaho Data Integration的图形化设计器，支持通过浏览器进行ETL流程的可视化设计与开发。"
source: https://xuanyuan.cloud/zh/r/hiromuhota/webspoon
canonical: https://xuanyuan.cloud/zh/r/hiromuhota/webspoon
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hiromuhota/webspoon" title="hiromuhota/webspoon Docker 镜像中文简介、标签列表与拉取命令">hiromuhota/webspoon 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# webSpoon Docker镜像文档

## 镜像概述和主要用途
webSpoon是基于Web的Spoon，作为Pentaho Data Integration（PDI）的图形化设计器，允许用户通过浏览器访问和使用，无需本地安装Spoon客户端。该镜像提供便捷部署方式，支持自定义配置、数据持久化和安全管理，适用于数据集成开发人员进行ETL流程的设计与管理。

## 核心功能和特性
- **Web化访问**：通过浏览器访问Spoon界面，无需本地安装客户端
- **灵活配置**：支持自定义Java堆大小、web.xml和security.xml等配置文件
- **数据持久化**：可通过卷挂载实现配置文件和数据的共享与持久化
- **安全管理**：支持用户认证和自定义安全管理器，增强访问控制
- **多标签支持**：提供不同版本和功能的镜像标签，满足不同场景需求

## 使用场景和适用范围
- 数据集成开发人员通过Web界面设计、编辑和测试ETL流程
- 需要在多环境间共享ETL配置和数据的团队协作场景
- 对服务器资源有限，需调整Java堆大小以优化性能的环境
- 需要自定义安全策略和访问控制的企业级应用场景

## 镜像构建方法
```bash
$ docker build --no-cache -t hiromuhota/webspoon:latest .
```

## 标签说明
| 标签 | 0.8.1.ZZ及更低版本 | 0.8.2.ZZ | 0.8.3.ZZ及更高版本 |
| --- | --- | --- | --- |
| nightly | webSpoon的最新提交（无插件） | webSpoon的最新提交（带插件） | 同上 |
| nightly-full | webSpoon的最新提交（带插件） | 与nightly相同，已弃用 | 已停止提供 |
| latest | webSpoon的最新发布版（无插件） | webSpoon的最新发布版（带插件） | 同上 |
| latest-full | webSpoon的最新发布版（带插件） | 与latest相同，已弃用 | 已停止提供 |
| 0.X.Y.ZZ | webSpoon的0.X.Y.ZZ版本（无插件） | webSpoon的0.X.Y.ZZ版本（带插件） | 同上 |
| 0.X.Y.ZZ-full | webSpoon的0.X.Y.ZZ版本（带插件） | 与0.X.Y.ZZ相同，已弃用 | 已停止提供 |

## 使用方法

### 基本使用
```bash
$ docker run -d -p 8080:8080 hiromuhota/webspoon
```
访问地址：`http://ip-address:8080/spoon/spoon`

### 高级使用

#### Java堆大小配置
默认Java堆大小配置为`-Xms1024m -Xmx2048m`，可通过`JAVA_OPTS`环境变量覆盖。例如，在仅2GB内存的服务器上：
```bash
$ docker run -d -p 8080:8080 \
-e JAVA_OPTS="-Xms1024m -Xmx1920m" \
hiromuhota/webspoon
```

#### 用户配置和数据持久化/共享
若需在容器间共享配置文件，可添加卷挂载：
```bash
$ docker run -d -p 8080:8080 \
-v kettle:/home/tomcat/.kettle -v pentaho:/home/tomcat/.pentaho \
hiromuhota/webspoon
```
或使用docker-compose：
```bash
$ docker-compose up -d
```

#### webSpoon配置
从0.8.0.14版本开始，spoon.war已预提取至`$CATALINA_HOME/webapps/spoon`，可通过绑定挂载在运行时配置`web.xml`等文件。例如，启用用户认证：
1. 下载[web.xml](https://github.com/HiromuHota/pentaho-kettle/blob/webspoon-8.2/assemblies/static/src/main/resources-filtered/WEB-INF/web.xml)
2. 按[说明](https://github.com/HiromuHota/pentaho-kettle#user-authentication)编辑
3. 添加挂载命令：
```bash
$ docker run -d -p 8080:8080 \
-v $(pwd)/web.xml:/usr/local/tomcat/webapps/spoon/WEB-INF/web.xml \
hiromuhota/webspoon
```
类似地，可配置`$CATALINA_HOME/webapps/spoon/WEB-INF/spring/security.xml`。

#### 安全管理器
要启用[自定义安全管理器](https://github.com/HiromuHota/pentaho-kettle/wiki/Admin%3A-Security#file-access-control-by-a-custom-security-manager-experimental)，需先启用[用户认证](https://github.com/HiromuHota/pentaho-kettle/wiki/Admin%3A-Security#user-authentication)，并添加`CATALINA_OPTS`环境变量：
```bash
$ docker run -d -p 8080:8080 \
-e CATALINA_OPTS="-Djava.security.manager=org.pentaho.di.security.WebSpoonSecurityManager -Djava.security.policy=/usr/local/tomcat/conf/catalina.policy" \
-v $(pwd)/web.xml:/usr/local/tomcat/webapps/spoon/WEB-INF/web.xml \
-v $(pwd)/catalina.policy:/usr/local/tomcat/conf/catalina.policy \
hiromuhota/webspoon
```

### 调试
```bash
$ docker run -d -p 8080:8080 -p 8000:8000 \
-e JPDA_ADDRESS=8000 \
-e CATALINA_OPTS="-Dorg.eclipse.rap.rwt.developmentMode=true" \
hiromuhota/webspoon catalina.sh jpda run

---
image: flowable/flowable-task
description: "用于执行Flowable工作流的Spring Boot 2应用程序，是Flowable生态系统的一部分。"
source: https://xuanyuan.cloud/zh/r/flowable/flowable-task
canonical: https://xuanyuan.cloud/zh/r/flowable/flowable-task
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/flowable/flowable-task" title="flowable/flowable-task Docker 镜像中文简介、标签列表与拉取命令">flowable/flowable-task 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Flowable Task Docker镜像文档

## 概述
Flowable Task镜像属于Flowable生态系统的一部分，用于运行基于Spring Boot 2构建的工作流执行应用。更多信息请访问[Flowable官网](http://flowable.org)。有关预配置的Docker Compose配置和启动/停止脚本，请参见[GitHub仓库](https://github.com/flowable/flowable-engine/tree/master/docker)。

## 使用方法

### 启动容器（内存H2数据库）
要使用内存H2数据库启动容器（需确保IDM应用已运行）：

```sh
docker run -p9999:9999 \
  -e FLOWABLE_COMMON_APP_IDM-URL=http://<host-ip>:8080/flowable-idm \
  -e FLOWABLE_COMMON_APP_IDM-ADMIN_USER=admin \
  -e FLOWABLE_COMMON_APP_IDM-ADMIN_PASSWORD=test \
  docker.xuanyuan.run/flowable/flowable-task
```

## 环境变量配置

### 必填环境变量
- **FLOWABLE_COMMON_APP_IDM-URL**：IDM应用的完整URL，用于服务器间通信
- **FLOWABLE_COMMON_APP_IDM-ADMIN_USER**：IDM管理员用户名（默认配置下为`admin`）
- **FLOWABLE_COMMON_APP_IDM-ADMIN_PASSWORD**：IDM管理员密码（默认配置下为`test`）

### 可选环境变量
- **SERVER_PORT**：Tomcat服务器端口（默认值：`9999`）
- **FLOWABLE_COMMON_APP_IDM-REDIRECT-URL**：IDM应用的完整URL，用于客户端浏览器重定向（例如：`http://localhost:8080/flowable-idm`）
- **SPRING_DATASOURCE_DRIVER-CLASS-NAME**：数据库驱动类名（例如：`org.postgresql.Driver`）
- **SPRING_DATASOURCE_URL**：数据库连接URL（例如：`jdbc:postgresql://<db-ip>:5432/flowable`）
- **SPRING_DATASOURCE_USERNAME**：数据库用户名（例如：`flowable`）
- **SPRING_DATASOURCE_PASSWORD**：数据库密码（例如：`flowable`）

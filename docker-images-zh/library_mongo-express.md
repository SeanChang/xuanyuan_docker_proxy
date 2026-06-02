---
image: library/mongo-express
description: "这是一款基于Web的MongoDB管理界面，专为MongoDB数据库设计，使用Node.js后端框架及Express构建，提供便捷的Web端管理功能，支持用户在浏览器中进行数据库的日常管理操作，如数据查询、文档管理、索引配置等，具备轻量高效、易于部署的特点，适用于开发人员和管理员快速管理MongoDB数据库实例。"
source: https://xuanyuan.cloud/zh/r/library/mongo-express
canonical: https://xuanyuan.cloud/zh/r/library/mongo-express
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/mongo-express" title="library/mongo-express Docker 镜像中文简介、标签列表与拉取命令">library/mongo-express — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/mongo-express" title="library/mongo-express Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/mongo-express</a>

# mongo-express 镜像使用指南


## 快速参考

### 维护者  
[mongo-express]([])（GitHub 仓库）


### 获取帮助  
可通过以下渠道获取支持：  
- [Docker 社区 Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


## 支持的标签  
无支持的标签  


## 快速参考（续）

### 问题反馈  
提交问题至：[mongo-express-docker  Issues]([])  


### 支持的架构  
无支持的架构（更多信息见 [官方镜像架构说明]([])）  


### 镜像工件详情  
发布的镜像元数据、传输大小等信息，可查看 [repo-info 仓库的 `repos/mongo-express/` 目录]([])（[历史记录]([])）  


### 镜像更新  
- 关注 [official-images 仓库的 `library/mongo-express` 标签]([])  
- 查看 [official-images 仓库的 `library/mongo-express` 文件]([])（[历史记录]([])）  


### 描述来源  
本文档内容来源于 [docs 仓库的 `mongo-express/` 目录]([])（[历史记录]([])）  


## 什么是 mongo-express？  
mongo-express 是一个基于 Node.js、Express.js 和 Bootstrap3 开发的 MongoDB 网页管理界面。  

> 项目地址：[github.com/mongo-express/mongo-express]([])  

![logo]([])  


## 如何使用此镜像  

### 基本用法  
运行以下命令启动容器：  
```console
$ docker run --network some-network -e ME_CONFIG_MONGODB_SERVER=some-mongo -p 8081:8081 mongo-express
```  
启动后，在浏览器中访问 `[] 或 `[] 即可打开管理界面。  


### 安全注意事项  
JSON 文档通过 JavaScript 虚拟机解析，因此网页界面可能被用于在服务器上执行恶意代码。**mongo-express 仅应在私人开发环境中使用**。  


## 配置  

通过环境变量配置容器，以下是常用配置项（通过 `docker run` 命令的 `-e` 参数传入）：  


### 通用配置项  

| 环境变量名称                  | 默认值           | 描述                                                                 |
|-------------------------------|------------------|----------------------------------------------------------------------|
| ME_CONFIG_BASICAUTH_USERNAME   | ''               | mongo-express 网页登录用户名                                         |
| ME_CONFIG_BASICAUTH_PASSWORD   | ''               | mongo-express 网页登录密码                                           |
| ME_CONFIG_MONGODB_ENABLE_ADMIN | 'true'           | 是否启用所有数据库的管理员访问权限（字符串值："true" 或 "false"）    |
| ME_CONFIG_MONGODB_ADMINUSERNAME| ''               | MongoDB 管理员用户名                                                 |
| ME_CONFIG_MONGODB_ADMINPASSWORD| ''               | MongoDB 管理员密码                                                   |
| ME_CONFIG_MONGODB_PORT         | 27017            | MongoDB 端口                                                         |
| ME_CONFIG_MONGODB_SERVER       | 'mongo'          | MongoDB 容器名称（副本集使用逗号分隔的主机名列表）                   |
| ME_CONFIG_OPTIONS_EDITORTHEME  | 'default'        | 编辑器主题（查看 [可选主题]([])） |
| ME_CONFIG_REQUEST_SIZE         | '100kb'          | 最大请求 payload 大小（超过此值的 CRUD 操作会因 body-parser 失败）   |
| ME_CONFIG_SITE_BASEURL         | '/'              | 网站基础路径（需包含首尾斜杠，用于子目录挂载）                       |
| ME_CONFIG_SITE_COOKIESECRET    | 'cookiesecret'   | cookie-parser 中间件签名密钥                                         |
| ME_CONFIG_SITE_SESSIONSECRET   | 'sessionsecret'  | express-session 中间件会话 ID 签名密钥                               |
| ME_CONFIG_SITE_SSL_ENABLED     | 'false'          | 是否启用 SSL（字符串值："true" 或 "false"）                          |
| ME_CONFIG_SITE_SSL_CRT_PATH    | ''               | SSL 证书文件路径                                                     |
| ME_CONFIG_SITE_SSL_KEY_PATH    | ''               | SSL 密钥文件路径                                                     |  


### 非管理员模式配置项（当 `ME_CONFIG_MONGODB_ENABLE_ADMIN="false"` 时需配置）  

| 环境变量名称                  | 默认值           | 描述                                                                 |
|-------------------------------|------------------|----------------------------------------------------------------------|
| ME_CONFIG_MONGODB_AUTH_DATABASE| 'db'             | 目标数据库名称                                                       |
| ME_CONFIG_MONGODB_AUTH_USERNAME| 'admin'          | 目标数据库用户名                                                     |
| ME_CONFIG_MONGODB_AUTH_PASSWORD| 'pass'           | 目标数据库密码                                                       |  


## 配置示例  

以下示例通过 `docker run` 命令启动容器，配置了网络、自定义编辑器主题和基础认证：  

```console
$ docker run -it --rm \
    --network web_default \
    --name mongo-express \
    -p 8081:8081 \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_SERVER="web_db_1" \
    -e ME_CONFIG_BASICAUTH_USERNAME="user" \
    -e ME_CONFIG_BASICAUTH_PASSWORD="较长的密码" \
    mongo-express
```  

说明：  
- `--network web_default`：连接到 docker compose 生成的默认网络  
- `web_db_1`：典型的 docker compose 容器名称格式  
- `ambiance`：编辑器主题  
- `user` 和 `较长的密码`：启用基础认证  


## 许可证  

软件许可证信息见 [项目仓库说明]([])。  
Docker 镜像可能包含基础系统（如 Bash）及依赖软件，这些软件可能有独立许可证。部分自动检测的许可证信息可在 [repo-info 仓库的 `mongo-express/` 目录]([]) 查看。  

使用前请确保遵守所有包含软件的许可证要求。

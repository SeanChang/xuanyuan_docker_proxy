---
image: library/rocket.chat
description: "这是一套完整的开源聊天解决方案，具备实时消息传递、文件分享、音视频通话、群组管理等全面功能，支持多平台部署与高度自定义开发，依托开源社区持续优化安全性能与兼容性，适用于企业协作、社交互动、客户服务等多样化场景，为用户提供无许可限制、低成本且灵活可控的通讯工具。"
source: https://xuanyuan.cloud/zh/r/library/rocket.chat
canonical: https://xuanyuan.cloud/zh/r/library/rocket.chat
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/rocket.chat" title="library/rocket.chat Docker 镜像中文简介、标签列表与拉取命令">library/rocket.chat — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/rocket.chat" title="library/rocket.chat Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/rocket.chat</a>

# Rocket.Chat Docker镜像使用指南


## 快速参考

### 维护者  
[Rocket.Chat]([])（官方GitHub仓库）


### 获取帮助  
可通过以下渠道寻求支持：  
- Docker社区Slack：[[]]([])  
- Server Fault（服务器运维问题）：[[]]([])  
- Unix & Linux（系统相关问题）：[[]]([])  
- Stack Overflow（开发相关问题）：[[]]([])  


## 支持的标签及对应Dockerfile链接  

以下是当前支持的镜像标签及其Dockerfile源码链接：  

- [`7.10.0`, `7.10`, `7`, `latest`]([])  
- [`7.9.3`, `7.9`]([])  
- [`7.8.4`, `7.8`]([])  
- [`7.7.8`, `7.7`]([])  
- [`7.6.5`, `7.6`]([])  
- [`7.5.4`, `7.5`]([])  
- [`7.4.5`, `7.4`]([])  


## 快速参考（续）  

### 问题反馈地址  
[[]]([])  


### 支持的架构  
仅支持 [`amd64`]([])（更多架构信息可参考[官方说明]([])）  


### 镜像详情  
可查看 [repo-info仓库的`repos/rocket.chat/`目录]([])（含镜像元数据、传输大小等信息，[历史记录]([])）  


### 镜像更新  
- 关注 [official-images仓库的`library/rocket.chat`标签]([])  
- 查看 [official-images仓库的`library/rocket.chat`文件]([])（[历史更新记录]([])）  


### 本文档来源  
[docs仓库的`rocket.chat/`目录]([])（[历史编辑记录]([])）  


## Rocket.Chat简介  

Rocket.Chat 是一款 Web 聊天服务器，基于 JavaScript 开发，采用 Meteor 全栈框架构建。适合社区或企业私有化部署聊天服务，也可供开发者搭建和扩展自定义聊天平台。  


## 如何使用本镜像  

### 步骤1：启动MongoDB并初始化副本集  
Rocket.Chat依赖MongoDB，需先启动Mongo容器并配置副本集（用于数据备份和高可用）：  

```console
# 启动Mongo容器，启用小文件模式，设置副本集名称为rs0，操作日志大小128MB
$ docker run --name db -d mongo:4.0 --smallfiles --replSet rs0 --oplogSize 128
```  

```console
# 进入Mongo容器，初始化副本集
$ docker exec -ti db mongo --eval "printjson(rs.initiate())"
```  


### 步骤2：启动Rocket.Chat容器  
将Rocket.Chat容器链接到Mongo容器，并配置必要环境变量：  

```console
# 启动Rocket.Chat，链接db容器，指定Mongo操作日志地址
$ docker run --name rocketchat --link db --env MONGO_OPLOG_URL=mongodb://db:27017/local -d rocket.chat
```  

此时Rocket.Chat默认监听容器内的3000端口。  


### 步骤3：映射主机端口（可选）  
如需通过主机标准端口访问，可添加`-p`参数映射端口（例如映射主机80端口到容器3000端口）：  

```console
# 映射主机80端口，设置访问域名（替换localhost为实际域名）
$ docker run --name rocketchat -p 80:3000 --link db --env ROOT_URL=[] --env MONGO_OPLOG_URL=mongodb://db:27017/local -d rocket.chat
```  

启动后通过 `[] 访问（若替换为实际域名，需确保域名解析正确）。  


### 使用第三方Mongo服务（如云数据库或Kubernetes环境）  
若使用外部Mongo服务，需手动指定`MONGO_URL`环境变量（数据库连接地址）：  

```console
$ docker run --name rocketchat -p 80:3000 \
  --env ROOT_URL=[] \
  --env MONGO_URL=mongodb://mymongourl/mydb \  # 替换为实际Mongo连接地址
  --env MONGO_OPLOG_URL=mongodb://mymongourl:27017/local \  # 替换为Mongo操作日志地址
  -d rocket.chat
```  


## 参考文档与社区  

- **生产环境部署指南**：[[]]([])  
- **社区帮助**：访问 [Rocket.Chat社区论坛]([]) 获取技术支持  


## 许可证信息  

- 本镜像包含的软件许可证信息：[查看Rocket.Chat许可证]([])  
- 镜像可能包含基础系统或依赖软件（如Bash等），其许可证需用户自行确认合规性。  
- 额外许可证信息可参考 [repo-info仓库的`rocket.chat/`目录]([])。  

使用前请确保遵守所有包含软件的许可证要求。

---
image: timonier/webui-aria2
description: "aria2下载工具的Web管理界面，提供直观交互方式，支持配置调整与容器化部署，可配合aria2镜像快速搭建下载管理环境。"
source: https://xuanyuan.cloud/zh/r/timonier/webui-aria2
canonical: https://xuanyuan.cloud/zh/r/timonier/webui-aria2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/timonier/webui-aria2" title="timonier/webui-aria2 Docker 镜像中文简介、标签列表与拉取命令">timonier/webui-aria2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
timonier/webui-aria2是aria2下载工具的Web用户界面，旨在提供简洁直观的可视化交互方式，帮助用户管理aria2的下载任务。该镜像基于NGINX运行，支持灵活的容器配置与安全运行模式。

## 核心功能
- 可视化管理aria2下载任务：支持查看、添加、暂停、继续及删除下载任务
- 灵活调整容器参数：通过环境变量修改运行NGINX的用户UID/GID
- 安全运行模式：支持只读模式，需挂载指定目录为tmpfs或卷
- 协同部署：可与timonier/aria2镜像配合，通过docker-compose快速搭建完整下载环境

## 使用场景
- 个人用户需要可视化管理aria2下载任务的场景
- 容器化环境中部署aria2及其Web管理界面的需求
- 对容器安全性有要求，希望以只读模式运行的场景

## 配置说明
1. **修改NGINX用户ID/组ID**：通过环境变量`NGINX_UID`和`NGINX_GID`指定运行NGINX的用户ID和组ID
2. **只读模式运行**：需挂载`/run`（带exec标志）、`/tmp`、`/var/cache/nginx`为tmpfs；若需修改UID/GID，还需挂载`/etc`为卷
3. **RPC认证配置**：与aria2配合时，需设置`RPC_SECRET`环境变量作为认证令牌，确保安全通信

## 部署示例
### 基础运行
```sh
docker run --interactive --publish 80:80 --rm --tty docker.xuanyuan.run/timonier/webui-aria2
```

### 修改NGINX用户ID/组ID
```sh
docker run --env NGINX_GID=1005 --env NGINX_UID=1005 --interactive --publish 80:80 --rm --tty docker.xuanyuan.run/timonier/webui-aria2
```

### 只读模式运行（无需修改UID/GID）
```sh
docker run --interactive --publish 80:80 --read-only --rm --tmpfs /run:exec --tmpfs /tmp --tmpfs /var/cache/nginx --tty docker.xuanyuan.run/timonier/webui-aria2
```

### 与aria2配合部署（docker-compose）
```sh
# 准备项目：设置RPC认证令牌
export RPC_SECRET=0fd9094d-76ca-4a76-be82-eaf513a1ccd2
# 启动服务
docker-compose up -d
# 访问http://localhost/管理下载任务

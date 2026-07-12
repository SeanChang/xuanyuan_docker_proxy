---
image: mbentley/teamspeak
description: "基于Alpine或Debian的TeamSpeak 3服务器Docker镜像，提供轻量级部署选项，支持持久化存储、自定义UID/GID及GDPR合规配置，便于快速搭建语音通信服务器。"
source: https://xuanyuan.cloud/zh/r/mbentley/teamspeak
canonical: https://xuanyuan.cloud/zh/r/mbentley/teamspeak
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mbentley/teamspeak" title="mbentley/teamspeak Docker 镜像中文简介、标签列表与拉取命令">mbentley/teamspeak 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# mbentley/teamspeak

TeamSpeak 3服务器的Docker镜像，基于`alpine:latest`或`debian:bookworm`构建，提供轻量级部署方案，适用于快速搭建语音通信服务。

## 镜像概述

该镜像提供两种版本：基于Alpine Linux的轻量级版本（约30 MB，含TS3）和基于Debian的标准版本（约175 MB，含TS3），两者功能完全一致。镜像始终包含最新版TeamSpeak 3服务器，更新时需重新拉取镜像并重建容器（数据需存储在容器外部以持久化）。

## 标签说明

- `latest`、`alpine`：基于Alpine Linux的轻量级版本
- `debian`：基于Debian bookworm的标准版本

拉取镜像命令：
```bash
docker pull docker.xuanyuan.run/mbentley/teamspeak
```

## 使用示例

### 测试用例（无持久化存储）
仅用于测试，容器删除后数据会丢失：
```bash
docker run -d --name teamspeak \
  -e PUID=503 \
  -e PGID=503 \
  -e TS3SERVER_GDPR_SAVE=false \
  -e TS3SERVER_LICENSE=accept \
  -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 \
  docker.xuanyuan.run/mbentley/teamspeak
```

## 许可协议

自[TeamSpeak 3.1.0](https://support.teamspeakusa.com/index.php?/Knowledgebase/Article/View/344/16/how-to-accept-the-server-license-agreement-server--310)起，运行服务器前需接受许可协议。可通过以下方式之一：
- 添加环境变量：`-e TS3SERVER_LICENSE=accept`
- 在运行命令末尾添加参数：`license_accepted=1`
- 在持久化存储目录创建文件：`.ts3server_license_accepted`

## 持久化存储配置

### 步骤
1. 在主机创建目录并设置权限：
   ```bash
   mkdir -p /data/teamspeak
   chown -R 503:503 /data/teamspeak
   ```

2. 启动容器（数据持久化至`/data/teamspeak`）：
   ```bash
   docker run -d --restart=always --name teamspeak \
     -e PUID=503 \
     -e PGID=503 \
     -e TS3SERVER_GDPR_SAVE=false \
     -e TS3SERVER_LICENSE=accept \
     -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 \
     -v /data/teamspeak:/data \
     docker.xuanyuan.run/mbentley/teamspeak
   ```

### 获取服务器凭据
服务器管理员密码（`serveradmin`）和特权密钥（`ServerAdmin`）可通过容器日志查看：
```bash
docker logs teamspeak
```

## 自定义UID/GID

通过`PUID`和`PGID`环境变量设置运行用户的UID和GID，默认均为`503`。例如：
```bash
-e PUID=1000 -e PGID=1000
```

## GDPR合规配置

为禁用客户端IP地址日志以符合通用数据保护条例（GDPR），设置环境变量：
```bash
-e TS3SERVER_GDPR_SAVE=true
```
默认值为`false`（启用IP日志）。

## 额外参数配置

### 查看官方文档
TeamSpeak服务器快速启动指南包含命令行参数说明，可通过以下命令查看：
```bash
docker run -t --rm --entrypoint cat docker.xuanyuan.run/mbentley/teamspeak /opt/teamspeak/doc/server_quickstart.md
```

### 直接传递参数
参数可直接添加在镜像名称后。例如，设置服务器管理员密码：
```bash
docker run -d --restart=always --name teamspeak \
  -e PUID=503 \
  -e PGID=503 \
  -e TS3SERVER_GDPR_SAVE=false \
  -e TS3SERVER_LICENSE=accept \
  -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 \
  -v /data/teamspeak:/data \
  docker.xuanyuan.run/mbentley/teamspeak \
  serveradmin_password=test1234
```

## 使用自定义.ini配置文件

### 步骤
1. 创建目录、配置文件并设置权限：
   ```bash
   mkdir -p /data/teamspeak
   touch /data/teamspeak/ts3server.ini
   chown -R 503:503 /data/teamspeak
   ```

2. 编辑`ts3server.ini`添加配置参数：
   ```ini
   default_voice_port=9987
   filetransfer_ip=0.0.0.0
   filetransfer_port=30033
   query_port=10011
   query_ssh_port=10022
   ```

3. 启动容器时指定ini文件路径：
   ```bash
   docker run -d --restart=always --name teamspeak \
     -e PUID=503 \
     -e PGID=503 \
     -e TS3SERVER_LICENSE=accept \
     -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 \
     -v /data/teamspeak:/data \
     mbentley/teamspeak \
     inifile=/data/ts3server.ini

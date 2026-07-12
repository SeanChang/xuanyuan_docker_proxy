---
image: itzg/minecraft-bedrock-server
description: "可选择版本的Minecraft基岩版专用服务器"
source: https://xuanyuan.cloud/zh/r/itzg/minecraft-bedrock-server
canonical: https://xuanyuan.cloud/zh/r/itzg/minecraft-bedrock-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/itzg/minecraft-bedrock-server" title="itzg/minecraft-bedrock-server Docker 镜像中文简介、标签列表与拉取命令">itzg/minecraft-bedrock-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![Discord](https://img.shields.io/discord/660567679458869252?label=Discord&logo=discord)](https://discord.gg/ScbTrAw)
[![](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-orange.svg)](https://www.buymeacoffee.com/itzg)

## 快速开始

以下命令启动运行默认版本并暴露默认UDP端口的基岩版专用服务器：

```bash
docker run -d -it -e EULA=TRUE -p 19132:19132/udp -v mc-bedrock-data:/data docker.xuanyuan.run/itzg/minecraft-bedrock-server
```

## 寻找Java版服务器

如需Minecraft Java版服务器，请使用此镜像：
[itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server)

## 环境变量

### 容器特定

- `EULA`（无默认值）：必须设置为`TRUE`以接受[Minecraft最终用户许可协议](https://minecraft.net/terms)
- `VERSION`（默认`LATEST`）：可设置为特定服务器版本或以下特殊值：
  - `LATEST`：获取最新版本，容器启动时可自动升级
  - `PREVIOUS`：使用先前维护的主要版本，适用于移动应用逐步升级场景
  - `1.11`、`1.12`、`1.13`、`1.14`、`1.16`：对应主版本的最新版
  - 其他特定版本：用于临时规避漏洞等情况
- `UID`（默认从`/data`所有者派生）：运行基岩服务器进程的用户ID
- `GID`（默认从`/data`所有者派生）：运行基岩服务器进程的组ID
- `PACKAGE_BACKUP_KEEP`（默认`2`）：保留的包备份数量

### 服务器属性

以下环境变量对应`server.properties`中的属性，详细说明见[此处](https://minecraft.gamepedia.com/Server.properties#Bedrock_Edition_3)：

`SERVER_NAME`、`SERVER_PORT`、`SERVER_PORT_V6`、`GAMEMODE`、`DIFFICULTY`、`LEVEL_TYPE`、`ALLOW_CHEATS`、`MAX_PLAYERS`、`ONLINE_MODE`、`WHITE_LIST`、`VIEW_DISTANCE`、`TICK_DISTANCE`、`PLAYER_IDLE_TIMEOUT`、`MAX_THREADS`、`LEVEL_NAME`、`LEVEL_SEED`、`DEFAULT_PLAYER_PERMISSION_LEVEL`、`TEXTUREPACK_REQUIRED`、`SERVER_AUTHORITATIVE_MOVEMENT`、`PLAYER_MOVEMENT_SCORE_THRESHOLD`、`PLAYER_MOVEMENT_DISTANCE_THRESHOLD`、`PLAYER_MOVEMENT_DURATION_THRESHOLD_IN_MS`、`CORRECT_PLAYER_MOVEMENT`

例如，配置平面创造模式服务器：

```bash
docker run -d -it --name bds-flat-creative \
  -e EULA=TRUE -e LEVEL_TYPE=flat -e GAMEMODE=creative \
  -p 19132:19132/udp docker.xuanyuan.run/itzg/minecraft-bedrock-server
```

## 暴露端口

- **UDP** 19132：基岩服务器端口。**注意**：暴露端口时必须附加`/udp`，如`-p 19132:19132/udp`

## 卷

- `/data`：服务器文件存储目录，包含`server.properties`配置文件

创建并使用命名卷：
```shell
docker volume create mc-volume
docker run -d -it --name mc-server -e EULA=TRUE -p 19132:19132/udp -v mc-volume:/data docker.xuanyuan.run/itzg/minecraft-bedrock-server
```

非root用户运行时需预先设置卷权限（如UID/GID 1000）：
```shell script
docker run --rm -v bedrock:/data docker.xuanyuan.run/alpine chown 1000:1000 /data
```

Compose文件中声明外部卷：
```yaml
volumes:
  bedrock:
    external:
      name: bedrock
```

## 连接

局域网内运行时，可在"好友"选项卡的"局域网游戏"中找到并连接服务器。

## 权限配置

通过XUID定义操作员（OPS）、成员（MEMBERS）和访客（VISITORS）权限：
```shell
-e OPS "1234567890,0987654321"
-e MEMBERS "1234567890,0987654321"
-e VISITORS "1234567890,0987654321"
```

## 白名单设置

两种方式：1. 设置`WHITE_LIST=TRUE`并映射自定义`whitelist.json`；2. 使用`WHITE_LIST_USERS`指定玩家名称列表：
```shell
-e WHITE_LIST_USERS="player1,player2,player3"
```
> 1.16.230.50版本起，将使用`ALLOW_LIST`、`ALLOW_LIST_USERS`和`allowlist.json`。

## 执行服务器命令

使用`-it`启动容器后，通过以下命令附加到控制台：
```shell script
docker attach CONTAINER_NAME_OR_ID
```
执行命令（如设置管理员）：
```
op YOUR_XBOX_USERNAME
```
使用Ctrl-p+Ctrl-q分离控制台。

## Docker Compose部署

examples目录包含[示例compose文件](examples/docker-compose.yml)，声明服务、卷及环境变量配置：
```yaml
environment:
  EULA: "TRUE"
  GAMEMODE: survival
  DIFFICULTY: normal
```
部署命令：
```bash
docker-compose up -d
```
查看日志：
```bash
docker-compose logs -f bds
```

## Kubernetes部署

examples目录包含[示例Kubernetes清单](examples/kubernetes.yml)，声明PVC、部署和服务。部署命令：
```bash
kubectl apply -f examples/kubernetes.yml
```
查看日志：
```bash
kubectl logs -f deployment/bds
```

## 数据备份方案

- [kaiede/minecraft-bedrock-backup镜像](https://hub.docker.com/r/kaiede/minecraft-bedrock-backup)（@Kaiede提供）

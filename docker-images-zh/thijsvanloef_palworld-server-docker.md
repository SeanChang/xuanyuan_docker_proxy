---
image: thijsvanloef/palworld-server-docker
description: "一个用于轻松运行幻兽帕鲁专用服务器的Docker容器。"
source: https://xuanyuan.cloud/zh/r/thijsvanloef/palworld-server-docker
canonical: https://xuanyuan.cloud/zh/r/thijsvanloef/palworld-server-docker
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/thijsvanloef/palworld-server-docker" title="thijsvanloef/palworld-server-docker Docker 镜像中文简介、标签列表与拉取命令">thijsvanloef/palworld-server-docker — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/thijsvanloef/palworld-server-docker" title="thijsvanloef/palworld-server-docker Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/thijsvanloef/palworld-server-docker</a>

# Palworld Dedicated Server Docker

[![Release](https://img.shields.io/github/v/release/thijsvanloef/palworld-server-docker)](https://github.com/thijsvanloef/palworld-server-docker/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/thijsvanloef/palworld-server-docker)](https://hub.docker.com/r/thijsvanloef/palworld-server-docker)
[![Docker Stars](https://img.shields.io/docker/stars/thijsvanloef/palworld-server-docker)](https://hub.docker.com/r/thijsvanloef/palworld-server-docker)
[![Image Size](https://img.shields.io/docker/image-size/thijsvanloef/palworld-server-docker/latest)](https://hub.docker.com/r/thijsvanloef/palworld-server-docker/tags)
[![Discord](https://img.shields.io/discord/1200397673329594459?logo=discord&label=Discord&link=https%3A%2F%2Fdiscord.gg%2FUxBxStPAAE)](https://discord.com/invite/UxBxStPAAE)

## 镜像概述和主要用途

这是一个Docker容器，帮助您快速搭建和运行自己的[Palworld](https://store.steampowered.com/app/1623730/Palworld/)专用服务器。该Docker容器已在Linux（Ubuntu/Debian）和Windows 10系统上测试并正常工作。

## 核心功能和特性

- 简化Palworld服务器部署流程
- 支持自动更新服务器
- 内置备份和恢复功能
- 支持RCON管理
- 可配置的自动备份、更新和重启
- 支持Discord通知集成
- 多平台兼容（Linux、Windows）
- 可定制的服务器设置
- 支持锁定特定游戏版本

## 服务器要求

| 资源 | 最低要求 | 推荐配置 |
|------|----------|----------|
| CPU | 4核 | 4+核 |
| 内存 | 16GB | 32GB以上（稳定运行） |
| 存储 | 4GB | 12GB |

## 使用场景和适用范围

- 个人或小团体搭建私人Palworld服务器
- 社区服务器托管
- 希望自定义服务器设置的玩家
- 需要可靠服务器管理和备份功能的场景
- 企业或组织内部游戏服务器部署

## 使用方法和配置说明

### Docker Compose

本仓库包含一个示例的[docker-compose.yml](https://github.com/thijsvanloef/palworld-server-docker/blob/main/docker-compose.yml)文件，可用于设置服务器：

```yaml
services:
   palworld:
      image: thijsvanloef/palworld-server-docker:latest
      restart: unless-stopped
      container_name: palworld-server
      stop_grace_period: 30s # 设置等待容器优雅停止的时间
      ports:
        - 8211:8211/udp
        - 27015:27015/udp
      environment:
         PUID: 1000
         PGID: 1000
         PORT: 8211 # 可选但推荐设置
         PLAYERS: 16 # 可选但推荐设置
         SERVER_PASSWORD: "worldofpals" # 可选但推荐设置
         MULTITHREADING: true
         RCON_ENABLED: true
         RCON_PORT: 25575
         TZ: "UTC"
         ADMIN_PASSWORD: "adminPasswordHere"
         COMMUNITY: false  # 如果希望服务器显示在社区服务器列表中，请启用此项，需配合SERVER_PASSWORD使用
         SERVER_NAME: "palworld-server-docker by Thijs van Loef"
         SERVER_DESCRIPTION: "palworld-server-docker by Thijs van Loef"
      volumes:
         - ./palworld:/palworld/
```

作为替代方案，您可以将[.env.example](https://github.com/thijsvanloef/palworld-server-docker/blob/main/.env.example)文件复制到名为**.env**的新文件中，根据需要修改，并将docker-compose.yml修改为：

```yaml
services:
   palworld:
      image: thijsvanloef/palworld-server-docker:latest
      restart: unless-stopped
      container_name: palworld-server
      stop_grace_period: 30s # 设置等待容器优雅停止的时间
      ports:
        - 8211:8211/udp
        - 27015:27015/udp
      env_file:
         -  .env
      volumes:
         - ./palworld:/palworld/
```

### Docker Run

将所有`<>`替换为您自己的配置：

```bash
docker run -d \
    --name palworld-server \
    -p 8211:8211/udp \
    -p 27015:27015/udp \
    -v ./palworld:/palworld/ \
    -e PUID=1000 \
    -e PGID=1000 \
    -e PORT=8211 \
    -e PLAYERS=16 \
    -e MULTITHREADING=true \
    -e RCON_ENABLED=true \
    -e RCON_PORT=25575 \
    -e TZ=UTC \
    -e ADMIN_PASSWORD="adminPasswordHere" \
    -e SERVER_PASSWORD="worldofpals" \
    -e COMMUNITY=false \
    -e SERVER_NAME="palworld-server-docker by Thijs van Loef" \
    -e SERVER_DESCRIPTION="palworld-server-docker by Thijs van Loef" \
    --restart unless-stopped \
    --stop-timeout 30 \
    thijsvanloef/palworld-server-docker:latest
```

作为替代方案，您可以使用.env文件：

```bash
docker run -d \
    --name palworld-server \
    -p 8211:8211/udp \
    -p 27015:27015/udp \
    -v ./palworld:/palworld/ \
    --env-file .env \
    --restart unless-stopped \
    --stop-timeout 30 \
    thijsvanloef/palworld-server-docker:latest
```

### Kubernetes

部署此容器到Kubernetes所需的所有文件都位于[k8s文件夹](https://github.com/thijsvanloef/palworld-server-docker/tree/main/k8s)中。请按照[k8s/readme.md](https://github.com/thijsvanloef/palworld-server-docker/blob/main/k8s/readme.md)中的步骤进行部署。

### 非root用户运行

这仅适用于高级用户。可以运行此容器并[覆盖默认用户](https://docs.docker.com/engine/reference/run/#user)（此镜像中的默认用户是root）。

指定用户和组后，`PUID`和`PGID`将被忽略。

要查找您的UID：`id -u`
要查找您的GID：`id -g`

您必须将用户设置为`数字UID:数字GID`

假设您的UID是1000，GID是1001：

* 在docker run命令中添加`--user 1000:1001 \`
* 在docker compose中添加`user: 1000:1001`

如果希望使用与自己不同的UID/GID运行，需要更改绑定目录的所有权：`chown UID:GID palworld/`或更改所有用户的权限：`chmod o=rwx palworld/`

### Helm Chart

官方helm chart位于单独的仓库：[palworld-server-chart](https://github.com/Twinki14/palworld-server-chart)

## 环境变量详解

您可以使用以下值在启动时更改服务器设置。强烈建议在启动服务器前设置以下环境变量：
* PLAYERS
* PORT
* PUID
* PGID

| 变量名 | 说明 | 默认值 | 允许值 |
|--------|------|--------|--------|
| TZ | 用于备份服务器时间戳的时区 | UTC | 参见[TZ标识符](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_Zone_abbreviations) |
| PLAYERS* | 服务器最大玩家数量 | 16 | 1-32 |
| PORT* | 服务器暴露的UDP端口 | 8211 | 1024-65535 |
| PUID* | 服务器运行用户的UID | 1000 | 非0 |
| PGID* | 服务器运行组的GID | 1000 | 非0 |
| MULTITHREADING** | 提高多线程CPU环境中的性能。最多对约4个线程有效，分配更多线程意义不大。 | false | true/false |
| COMMUNITY | 服务器是否显示在社区服务器浏览器中（需配合SERVER_PASSWORD使用） | false | true/false |
| PUBLIC_IP | 可手动指定服务器运行网络的全局IP地址。未指定则自动检测。 | | x.x.x.x |
| PUBLIC_PORT | 可手动指定服务器运行网络的端口号。未指定则自动检测。 | | 1024-65535 |
| SERVER_NAME | 服务器名称 | | "字符串" |
| SERVER_PASSWORD | 社区服务器密码 | | "字符串" |
| ADMIN_PASSWORD | 服务器管理访问密码 | | "字符串" |
| UPDATE_ON_BOOT** | 启动Docker容器时更新/安装服务器（首次运行容器时必须启用） | true | true/false |
| RCON_ENABLED | 启用Palworld服务器的RCON | true | true/false |
| RCON_PORT | RCON连接端口 | 25575 | 1024-65535 |
| QUERY_PORT | 用于与Steam服务器通信的查询端口 | 27015 | 1024-65535 |

*强烈建议设置
** 启用此选项时请确保了解其作用
 Docker停止时保存和优雅关闭服务器所需

> **重要提示**：环境变量中使用的布尔值区分大小写，必须使用`true`或`false`才能使选项生效。

## 游戏端口说明

| 端口 | 说明 |
|------|------|
| 8211 | 游戏端口（UDP） |
| 27015 | 查询端口（UDP） |
| 25575 | RCON端口（TCP） |

## RCON使用方法

palworld-server-docker镜像默认启用RCON。打开RCON命令行非常简单：

```bash
docker exec -it palworld-server rcon-cli
```

这将打开一个使用RCON向Palworld服务器发送命令的命令行界面。

### 服务器命令列表

| 命令 | 说明 |
|------|------|
| Shutdown {Seconds} {MessageText} | 服务器将在指定秒数后关闭 |
| DoExit | 强制停止服务器 |
| Broadcast | 向服务器所有玩家发送消息 |
| KickPlayer {SteamID} | 将玩家踢出服务器 |
| BanPlayer {SteamID} | 封禁玩家 |
| TeleportToPlayer {SteamID} | 传送到目标玩家当前位置 |
| TeleportToMe {SteamID} | 目标玩家传送到你的当前位置 |
| ShowPlayers | 显示所有连接玩家的信息 |
| Info | 显示服务器信息 |
| Save | 保存世界数据 |

完整命令列表请访问：[https://tech.palworldgame.com/server-commands](https://tech.palworldgame.com/server-commands)

## 备份与恢复

### 创建备份

要创建当前游戏存档的备份，请使用以下命令：

```bash
docker exec palworld-server backup
```

这将在`/palworld/backups/`目录下创建一个备份。如果启用了rcon，服务器将在备份前运行保存。

### 从备份恢复

要从备份恢复，请使用以下命令：

```bash
docker exec -it palworld-server restore
```

必须将`RCON_ENABLED`环境变量设置为`true`才能使用此命令。

> **重要提示**：如果docker重启策略未设置为`always`或`unless-stopped`，服务器将关闭并需要手动重启。示例docker run命令和docker compose文件已使用所需策略。

### 手动从备份恢复

在`/palworld/backups/`中找到要恢复的备份并解压缩。需要先停止服务器：

```bash
docker compose down
```

删除位于`palworld/Pal/Saved/SaveGames/0/<旧哈希值>`的旧存档文件夹。

将新解压缩的存档文件夹`Saved/SaveGames/0/<新哈希值>`的内容复制到`palworld/Pal/Saved/SaveGames/0/<新哈希值>`。

在`palworld/Pal/Saved/Config/LinuxServer/GameUserSettings.ini`中，将DedicatedServerName替换为新文件夹名称：

```ini
DedicatedServerName=<新哈希值>  # 替换为你的文件夹名称
```

重启游戏（如果使用Docker Compose）：

```bash
docker compose up -d
```

## 自动备份配置

服务器将根据TZ设置的时区在每天午夜自动备份。

设置BACKUP_ENABLED启用或禁用自动备份（默认启用）。

BACKUP_CRON_EXPRESSION是cron表达式，用于定义作业运行间隔。

> **提示**：此镜像使用Supercronic处理crons，参见[supercronic](https://github.com/aptible/supercronic#crontab-format)或[Crontab Generator](https://crontab-generator.org)。

设置BACKUP_CRON_EXPRESSION更改默认计划。例如，将BACKUP_CRON_EXPRESSION设置为`0 2 * * *`，备份脚本将在每天凌晨2:00运行。

## 自动更新配置

要使用服务器自动更新功能，必须将以下环境变量设置为`true`：
* RCON_ENABLED
* UPDATE_ON_BOOT

> **重要提示**：如果docker重启策略未设置为`always`或`unless-stopped`，服务器将关闭并需要手动重启。示例docker run命令和docker compose文件已使用所需策略。

设置AUTO_UPDATE_ENABLED启用或禁用自动更新（默认禁用）。

AUTO_UPDATE_CRON_EXPRESSION是cron表达式，用于定义作业运行间隔。

## 自动重启配置

要使用服务器自动重启功能，需启用RCON_ENABLED。

> **重要提示**：如果docker重启策略未设置为`always`或`unless-stopped`，服务器将关闭并需要手动重启。示例docker run命令和docker compose文件已使用所需策略。

设置AUTO_REBOOT_ENABLED启用或禁用自动重启（默认禁用）。

AUTO_REBOOT_CRON_EXPRESSION是cron表达式，用于定义作业运行间隔，默认根据TZ设置的时区在每天午夜重启。

## 服务器设置编辑

### 使用环境变量

> **重要提示**：由于游戏仍处于测试阶段，这些环境变量/设置可能会发生变化。请查看[官方网页获取支持的参数](https://tech.palworldgame.com/optimize-game-balance)。

将服务器设置转换为环境变量遵循相同原则（有一些例外）：
* 全部大写字母
* 用下划线分隔单词
* 如果设置以单个字母开头（如'b'），删除该字母

例如：
* Difficulty -> DIFFICULTY
* PalSpawnNumRate -> PAL_SPAWN_NUM_RATE
* bIsPvP -> IS_PVP

所有变量：https://palworld-server-docker.loef.dev/getting-started/configuration/game-settings

### 手动编辑配置文件

服务器启动时，将在以下位置创建`PalWorldSettings.ini`文件：`<挂载文件夹>/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`

请注意，环境变量将始终覆盖对`PalWorldSettings.ini`所做的更改。

> **重要提示**：只能在服务器关闭时对`PalWorldSettings.ini`进行更改。服务器运行时所做的任何更改将在服务器停止时被覆盖。

详细的服务器设置列表请访问：[Palworld Wiki](https://palworld.wiki.gg/wiki/PalWorldSettings.ini)

更详细的服务器设置说明请访问：[shockbyte](https://shockbyte.com/billing/knowledgebase/1189/How-to-Configure-your-Palworld-server.html)

## Discord Webhooks使用

1. 在Discord服务器设置中为您的Discord服务器生成webhook URL。

2. 使用Discord webhook URL设置环境变量：

docker run方式：
```sh
-e DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1234567890/abcde" \
-e DISCORD_PRE_UPDATE_BOOT_MESSAGE="服务器正在更新..." \
```

docker compose方式：
```yaml
- DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/1234567890/abcde
- DISCORD_PRE_UPDATE_BOOT_MESSAGE=服务器正在更新...
```

## 锁定特定游戏版本

> **警告**：可以降级到较低的游戏版本，但尚不清楚这对现有存档有什么影响。请自行承担风险！

如果设置了**TARGET_MANIFEST_ID**环境变量，将把服务器版本锁定到特定的manifest。manifest对应发布日期/更新版本。可以使用SteamCMD或[SteamDB](https://steamdb.info/depot/2394012/manifests/)等网站找到manifest

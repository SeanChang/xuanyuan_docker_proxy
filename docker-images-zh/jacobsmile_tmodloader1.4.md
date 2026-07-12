---
image: jacobsmile/tmodloader1.4
description: "一个易于配置的tModLoader 1.4服务器Docker镜像，支持模组下载和自动更新功能。"
source: https://xuanyuan.cloud/zh/r/jacobsmile/tmodloader1.4
canonical: https://xuanyuan.cloud/zh/r/jacobsmile/tmodloader1.4
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jacobsmile/tmodloader1.4" title="jacobsmile/tmodloader1.4 Docker 镜像中文简介、标签列表与拉取命令">jacobsmile/tmodloader1.4 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# tModLoader Docker镜像

在Github上查看 | [在Dockerhub上查看](https://registry.hub.docker.com/r/jacobsmile/tmodloader1.4)

此Docker镜像旨在简化基于tModLoader的模组化Terraria服务器的配置和搭建过程。

## 特性
- 通过Workshop ID轻松下载tModLoader模组
- 计划世界保存功能
- 优雅关闭机制
- 配置文件可选
- Github自动化以保持与tModLoader发布周期同步更新

## 致谢与提及
- Terraria
  - [官方网站](https://terraria.org/)
  - [Steam商店页面](https://store.steampowered.com/app/105600/Terraria/)
- tModLoader
  - [官方网站](https://www.tmodloader.net/)
  - [Steam商店页面](https://store.steampowered.com/app/1281930/tModLoader/)
  - [Github仓库](https://github.com/tModLoader/tModLoader)
- [ldericher](https://github.com/ldericher/tmodloader-docker) 的Terraria 1.3 tModLoader Docker实现及命令注入功能
- [rfvgyhn](https://github.com/rfvgyhn/tmodloader-docker) 的Terraria 1.3 tModLoader Docker实现
- [guillheu](https://github.com/guillheu/tmodloader-docker) 的Terraria 1.4 tModLoader Docker实现
- [FlorentLM](https://github.com/FlorentLM/tmodloader1.4) 帮助优化Dockerfile并解决部分安全问题

## 查看我的所有Terraria镜像!

1.4 原版Terraria: [Github](https://github.com/JACOBSMILE/terraria1.4) | [Dockerhub](https://hub.docker.com/r/jacobsmile/terraria1.4)

1.4 tModLoader: [Github](https://github.com/JACOBSMILE/tmodloader1.4) | [Dockerhub](https://hub.docker.com/r/jacobsmile/tmodloader1.4)

## 容器准备

### 数据目录
在主机上创建一个目录用于存储持久化文件。

```bash
# 创建数据目录
mkdir /path/to/data/directory
```

```bash
# 以下是Docker容器的映射卷配置
-v /path/to/data/directory:/data
```

此目录将包含以下文件结构:
```
/data/
├─ steamMods/
│  ├─ steamapps/
│  │  ├─ workshop/
│  │  │  ├─ content/
│  │  │  │  ├─ 1281930/
├─ tModLoader/
│  ├─ ModConfigs/
│  ├─ Mods/
│  │  ├─ enabled.json
│  ├─ Worlds/
```

Steam Workshop内容存储在`steamMods`目录中。

服务器的模组配置、模组目录和世界目录存储在`tModLoader`目录中。

## 下载模组
Steam上的每个Workshop项目都有唯一标识符，可通过访问商店页面获取。例如，[Calamity Mod](https://steamcommunity.com/sharedfiles/filedetails/?id=2824688072)的URL中，**2824688072**即为Workshop ID。此Docker容器支持直接从Steam Workshop下载tModLoader模组，简化搭建流程。

在运行容器时传递的环境变量中，指定`TMOD_AUTODOWNLOAD`变量，值为逗号分隔的模组ID列表。

例如，要下载Calamity模组和Calamity模组音乐，指定以下变量:
```bash
-e TMOD_AUTODOWNLOAD=2824688072,2824688266
```

## 启用模组
要成功运行容器，需理解**下载模组**和**启用模组**的区别。

**下载**模组仅将其存储在Steam Workshop缓存中（位于`/data/mods`目录），映射`/data`到主机目录可实现容器重启间的持久化。

**启用**模组是指将模组名称写入tModLoader启动时读取的`enabled.json`文件。模组必须先通过`TMOD_AUTODOWNLOAD`下载后才能启用。

要在服务器上启用模组，指定`TMOD_ENABLEDMODS`环境变量，值为逗号分隔的模组ID列表:

```bash
-e TMOD_ENABLEDMODS=2824688072,2824688266
```

## 环境变量
以下是容器支持的所有环境变量，用于处理服务器功能和Terraria服务器配置。

| 变量 | 默认值 | 描述 |
|------|--------|------|
| TMOD_SHUTDOWN_MESSAGE | Server is shutting down NOW! | 容器关闭时发送到游戏内聊天的消息 |
| TMOD_AUTOSAVE_INTERVAL | 10 | 世界自动保存间隔（分钟） |
| TMOD_AUTODOWNLOAD | N/A | 逗号分隔的Steam Workshop模组ID列表，用于启动时下载 |
| TMOD_ENABLEDMODS | N/A | 逗号分隔的Steam Workshop模组ID列表，用于启动时启用 |
| TMOD_USECONFIGFILE | No | 是否使用配置文件指定服务器设置（已弃用） |
| TMOD_MOTD | A tModLoader server powered by Docker! | 玩家加入时显示的服务器每日消息 |
| TMOD_PASS | docker | 玩家加入服务器需提供的密码，设为"N/A"可禁用密码（不推荐） |
| TMOD_MAXPLAYERS | 8 | 服务器最大玩家数量 |
| TMOD_WORLDNAME | Docker | 世界文件名（游戏内可见，同时作为.WLD文件名称） |
| TMOD_WORLDSIZE | 3 | 生成新世界时的尺寸：1=小型，2=中型，3=大型 |
| TMOD_WORLDSEED | Docker | 新世界的种子 |
| TMOD_DIFFICULTY | 1 | 生成新世界时的难度：0=普通，1=专家，2=大师，3=旅途 |
| TMOD_SECURE | 0 | 启用额外作弊保护 |
| TMOD_LANGUAGE | en-US | 服务器语言，可选值：`en-US`（英语）、`de-DE`（德语）、`it-IT`（意大利语）、`fr-FR`（法语）、`es-ES`（西班牙语）、`ru-RU`（俄语）、`zh-Hans`（中文）、`pt-BR`（葡萄牙语）、`pl-PL`（波兰语） |
| TMOD_NPCSTREAM | 60 | 减少敌人跳帧（值越低跳帧越少但带宽占用越高，0为关闭） |
| TMOD_UPNP | 0 | 启用uPNP自动端口转发（未测试，可能因网络配置无法工作） |

以下是控制旅途模式设置的环境变量，所有设置值含义：
* 0 = 所有人锁定
* 1 = 仅主机可更改
* 2 = 所有人可更改

默认值均为0（未显式设置时）：

* TMOD_JOURNEY_SETFROZEN
* TMOD_JOURNEY_SETDAWN
* TMOD_JOURNEY_SETNOON
* TMOD_JOURNEY_SETDUSK
* TMOD_JOURNEY_SETMIDNIGHT
* TMOD_JOURNEY_GODMODE
* TMOD_JOURNEY_WIND_STRENGTH
* TMOD_JOURNEY_RAIN_STRENGTH
* TMOD_JOURNEY_TIME_SPEED
* TMOD_JOURNEY_RAIN_FROZEN
* TMOD_JOURNEY_WIND_FROZEN
* TMOD_JOURNEY_PLACEMENT_RANGE
* TMOD_JOURNEY_SET_DIFFICULTY
* TMOD_JOURNEY_BIOME_SPREAD
* TMOD_JOURNEY_SPAWN_RATE

## 运行容器

### Docker命令

```bash
# 拉取镜像
docker pull docker.xuanyuan.run/jacobsmile/tmodloader1.4:latest

# 运行容器
docker run -p 7777:7777 --name tmodloader --rm \
  -v /path/to/data:/data \
  -e TMOD_SHUTDOWN_MESSAGE='再见！' \
  -e TMOD_AUTOSAVE_INTERVAL='15' \
  -e TMOD_AUTODOWNLOAD='2824688072,2824688266' \
  -e TMOD_ENABLEDMODS='2824688072,2824688266' \
  -e TMOD_MOTD='欢迎来到我的tModLoader服务器！' \
  -e TMOD_PASS='secret' \
  -e TMOD_MAXPLAYERS='16' \
  -e TMOD_WORLDNAME='地球' \
  -e TMOD_WORLDSIZE='2' \
  -e TMOD_WORLDSEED='not the bees!' \
  -e TMOD_DIFFICULTY='3' \
  docker.xuanyuan.run/jacobsmile/tmodloader1.4
```

### Docker Compose

Github仓库中包含示例`docker-compose.yml`文件。配置完成后，使用以下命令启动：
```bash
docker compose up --build
```

## 与服务器交互

服务器启动后，可通过主机执行以下命令向服务器发送指令。例如，发送"Hello World"到游戏聊天：

```bash
docker exec tmodloader inject "say Hello World!"
```

如果未命名容器，可使用容器ID代替`tmodloader`。

（此命令注入方法归功于[ldericher](https://github.com/ldericher/tmodloader-docker)）

## 注意事项

我不拥有tModLoader或Terraria的所有权。此Docker镜像仅为玩家提供便捷的Docker化服务器搭建方式，无意侵犯任何版权、商标或知识产权。

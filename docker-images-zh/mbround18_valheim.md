---
image: mbround18/valheim
description: "Valheim专用服务器Docker镜像，由Odin工具驱动，支持自动更新、自动备份及完整mod支持，简化服务器部署与管理。"
source: https://xuanyuan.cloud/zh/r/mbround18/valheim
canonical: https://xuanyuan.cloud/zh/r/mbround18/valheim
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mbround18/valheim" title="mbround18/valheim Docker 镜像中文简介、标签列表与拉取命令">mbround18/valheim 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Valheim

<a href="https://hub.docker.com/r/mbround18/valheim"><img src="https://img.shields.io/docker/pulls/mbround18/valheim?style=for-the-badge" alt="Docker拉取量"></a>
<a href="https://github.com/mbround18/valheim-docker/actions/workflows/docker-publish.yml"><img src="https://img.shields.io/github/workflow/status/mbround18/valheim-docker/Rust?label=Rust&style=for-the-badge" alt="Rust工作流状态"></a>
<a href="https://github.com/mbround18/valheim-docker/actions/workflows/rust.yml"><img src="https://img.shields.io/github/workflow/status/mbround18/valheim-docker/Rust?label=Docker&style=for-the-badge" alt="Docker工作流状态"></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![所有贡献者](https://img.shields.io/badge/all_contributors-8-orange.svg?style=flat-square)](#贡献者-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

## 在Linux服务器上运行

本仓库的工具可以无需安装Docker直接运行！如果只想在Linux系统上不使用Docker运行，请查看以下链接 <3

- [安装和使用Odin](https://raw.githubusercontent.com/mbround18/valheim-docker/main/src/odin/README.md)
  工具[Odin]负责管理服务器，执行启动、停止和管理Valheim服务器实例的大部分工作。
- [安装和使用Huginn](https://raw.githubusercontent.com/mbround18/valheim-docker/main/src/huginn/README.md)
  想查看服务器状态？[Huginn]就是答案！[Huginn]是一个基于[Odin]相同源代码构建的HTTP服务器，提供几个HTTP端点用于状态查询。

> 在Ubuntu服务器上使用二进制文件运行时，你需要手动配置一些内容。如果希望轻松管理服务器，建议查看Docker部分 <3

## 使用Docker运行

> [如需入门指南，请点击此处](https://github.com/mbround18/valheim-docker/discussions/28)
>
> Mod支持！支持使用BepInEx启动服务器，但请注意！你需要自行负责调试服务器启动问题。Valheim官方尚未正式支持mod，因此可能会遇到错误。本仓库已测试ValheimPlus作为示例mod，无明显问题。详见[mod入门指南]

### 下载地址

#### DockerHub

<a href="https://hub.docker.com/r/mbround18/valheim"><img alt="DockerHub Valheim" src="https://img.shields.io/badge/DockerHub-Valheim-blue?style=for-the-badge"></a>
<a href="https://hub.docker.com/r/mbround18/valheim-odin"><img alt="DockerHub Odin" src="https://img.shields.io/badge/DockerHub-Odin-blue?style=for-the-badge"></a>

#### GitHub容器注册表

<a href="https://github.com/users/mbround18/packages/container/package/valheim"><img alt="GHCR Valheim" src="https://img.shields.io/badge/GHCR-Valheim-blue?style=for-the-badge"></a>
<a href="https://github.com/users/mbround18/packages/container/package/valheim-odin"><img alt="GHCR Odin" src="https://img.shields.io/badge/GHCR-Odin-blue?style=for-the-badge"></a>

### 环境变量

> 高级环境变量详见下文。

| 变量名              | 默认值              | 是否必填 | 描述                                                                                                                                                                                                                                   |
|---------------------|---------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PORT                | `2456`              | 是       | 设置服务器监听端口，同时会监听+2端口（如2456、2457、2458）                                                                                                                                                                               |
| NAME                | `Valheim Docker`    | 是       | 服务器名称，建议设置得有趣且独特！                                                                                                                                                                                                     |
| WORLD               | `Dedicated`         | 是       | 用于生成世界名称                                                                                                                                                                                                                       |
| PUBLIC              | `1`                 | 否       | 设置服务器是否在服务器列表中公开                                                                                                                                                                                                       |
| PASSWORD            | `<please set me>`   | 是       | 设置服务器密码，建议使用独特密码！                                                                                                                                                                                                     |
| TYPE                | `Vanilla`           | 否       | 可设置为`ValheimPlus`、`BepInEx`、`BepInExFull`或`Vanilla`                                                                                                                                                                              |
| MODS                | `<nothing>`         | 否       | 以逗号和换行分隔的mod数组。[点击查看示例](./docs/getting_started_with_mods.md) 支持的文件类型：`zip`、`dll`和`cfg`                                                                                                                         |
| WEBHOOK_URL         | `<nothing>`         | 否       | 提供Webhook URL可获取服务器状态通知（如Discord）。[点击查看如何获取Discord Webhook URL](https://help.dashe.io/en/articles/2521940-how-to-create-a-discord-webhook-url)                                                                     |
| UPDATE_ON_STARTUP   | `1`                 | 否       | 容器启动时尝试更新服务器                                                                                                                                                                                                               |

#### 容器环境变量

| 变量名 | 默认值                | 是否必填 | 描述                                                                                                                                                                                           |
|--------|-----------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| TZ     | `America/Los_Angeles` | 否       | 设置容器时区，用于时间戳和Cron任务。[点击查看有效时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)                                                                          |
| PUID   | `1000`                | 否       | 设置steam用户的用户ID                                                                                                                                                                          |
| PGID   | `1000`                | 否       | 设置steam用户的组ID                                                                                                                                                                           |

#### 自动更新

| 变量名                          | 默认值     | 是否必填 | 描述                                                                                                                                                                                                                             |
|---------------------------------|------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AUTO_UPDATE                     | `0`        | 否       | 设置为`1`启用自动更新。容器将在`AUTO_UPDATE_SCHEDULE`指定的时间检查服务器更新，如有更新，会关闭服务器、更新并重新启动（仅当服务器之前运行时）                                                                                              |
| AUTO_UPDATE_SCHEDULE            | `0 1 * * *`| 否       | 与`AUTO_UPDATE`配合使用，设置自动更新的Cron计划任务。[如需帮助设置Cron计划任务，请点击此处]                                                                                                                                        |
| AUTO_UPDATE_PAUSE_WITH_PLAYERS  | `0`        | 否       | 如果有玩家在线，则不执行更新                                                                                                                                                                                                     |

自动更新任务会查询Steam并比较本地文件版本差异。

#### 自动备份

| 变量名                          | 默认值          | 是否必填 | 描述                                                                                                                                                                                                                             |
|---------------------------------|-----------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AUTO_BACKUP                     | `0`             | 否       | 设置为`1`启用自动备份。备份存储在`/home/steam/backups`，需为此目录挂载卷                                                                                                                                                             |
| AUTO_BACKUP_SCHEDULE            | `*/15 * * * *`  | 否       | 设置自动备份的频率（Cron计划任务）。[如需帮助设置Cron计划任务，请点击此处]                                                                                                                                                           |
| AUTO_BACKUP_REMOVE_OLD          | `1`             | 否       | 设置为`0`保留所有备份，需手动管理                                                                                                                                                                                                 |
| AUTO_BACKUP_DAYS_TO_LIVE        | `3`             | 否       | 备份保留天数。备份已压缩，通常体积较小，可根据需要调整此值                                                                                                                                                                           |
| AUTO_BACKUP_ON_UPDATE           | `0`             | 否       | 在更新和启动服务器前创建备份                                                                                                                                                                                                     |
| AUTO_BACKUP_ON_SHUTDOWN         | `0`             | 否       | 关闭服务器时创建备份                                                                                                                                                                                                             |
| AUTO_BACKUP_PAUSE_WITH_NO_PLAYERS| `0`            | 否       | 如果没有玩家在线，则跳过备份。`PUBLIC`需设置为`1`才能生效                                                                                                                                                                         |

自动备份生成`*.tar.gz`文件，平均4人经常游玩的世界备份约30MB。注意：若将服务器文件夹放在存档文件夹中，备份体积可能会变得极大。为避免此问题，请按`docker-compose.yml`中的指南正确挂载卷。

#### [Huginn] HTTP服务器

| 变量名   | 默认值           | 是否必填 | 描述                                                                                                                                                                 |
|----------|------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ADDRESS  | `Your Public IP` | 否       | 与`odin status`配合使用，设置后`odin`将停止尝试获取公网IP                                                                                                             |
| HTTP_PORT| `1024以上任意值` | 否       | 设置后将启动小型HTTP服务器，提供两个端点：                                                                                                                                 |

- `/metrics`：提供Prometheus风格的指标输出
- `/status`：提供传统状态页面

> 关于`ADDRESS`：可设置为`127.0.0.1:<查询端口>`或`<公网IP>:<查询端口>`，无需必填。注意，查询端口是Valheim服务器`PORT`变量值+1。

### Docker Compose

#### 简单配置

> 以下是基础Docker Compose示例，可在`environment`部分添加上述任何变量，但需遵循各变量的描述说明！

```yaml
version: "3"
services:
  valheim:
    image: docker.xuanyuan.run/mbround18/valheim:latest
    ports:
      - 2456:2456/udp
      - 2457:2457/udp
      - 2458:2458/udp
    environment:
      PORT: 2456
      NAME: "使用Valheim Docker创建"
      WORLD: "Dedicated"
      PASSWORD: "Banana Phone"
      TZ: "America/Chicago"
      PUBLIC: 1
    volumes:
      - ./valheim/saves:/home/steam/.config/unity3d/IronGate/Valheim
      - ./valheim/server:/home/steam/valheim
```

#### 完整配置

```yaml
version: "3"
services:
  valheim:
    image: docker.xuanyuan.run/mbround18/valheim:latest
    ports:
      - 2456:2456/udp
      - 2457:2457/udp
      - 2458:2458/udp
    environment:
      PORT: 2456
      NAME: "使用Valheim Docker创建"
      WORLD: "Dedicated"
      PASSWORD: "Strong! Password @ Here"
      TZ: "America/Chicago"
      PUBLIC: 1
      AUTO_UPDATE: 1
      AUTO_UPDATE_SCHEDULE: "0 1 * * *"
      AUTO_BACKUP: 1
      AUTO_BACKUP_SCHEDULE: "*/15 * * * *"
      AUTO_BACKUP_REMOVE_OLD: 1
      AUTO_BACKUP_DAYS_TO_LIVE: 3
      AUTO_BACKUP_ON_UPDATE: 1
      AUTO_BACKUP_ON_SHUTDOWN: 1
      WEBHOOK_URL: "https://discord.com/api/webhooks/IM_A_SNOWFLAKE/AND_I_AM_A_SECRET"
      UPDATE_ON_STARTUP: 0
    volumes:
      - ./valheim/saves:/home/steam/.config/unity3d/IronGate/Valheim
      - ./valheim/server:/home/steam/valheim
      - ./valheim/backups:/home/steam/backups
```

### [Odin]

本仓库包含名为[Odin]的CLI工具，用于在容器内管理服务器。[点击查看Odin使用说明](https://raw.githubusercontent.com/mbround18/valheim-docker/main/src/odin/README.md)

[点击查看Odin的高级环境变量](https://raw.githubusercontent.com/mbround18/valheim-docker/main/src/odin/README.md)

### [BepInEx支持](https://raw.githubusercontent.com/mbround18/valheim-docker/main/docs/bepinex.md)

本仓库自动为BepInEx设置必要的环境变量，但由于Valheim mod社区尚在发展初期，你需要手动在容器中安装BepInEx。

[点击查看BepInEx支持文档](https://raw.githubusercontent.com/mbround18/valheim-docker/main/docs/bepinex.md)

### [Webhook支持](https://raw.githubusercontent.com/mbround18/valheim-docker/main/docs/webhooks.md)

通过`WEBHOOK_URL`变量可自动向Discord发送通知。如需高级设置，请查看以下文档：

[点击查看Webhook支持文档](https://raw.githubusercontent.com/mbround18/valheim-docker/main/docs/webhooks.md)

### [文件传输指南](https://raw.githubusercontent.com/mbround18/valheim-docker/main/docs/tutorials/how-to-transfer-files.md)

本指南介绍如何在主机间传输文件（如世界文件、BepInEx配置或备份）。

[点击查看文件传输教程](https://raw.githubusercontent.com/mbround18/valheim-docker/main/docs/tutorials/how-to-transfer-files.md)

## 赞助商

寻找赞助商中！

## 版本通知

如需将版本通知集成到Discord服务器，请点击：

<a href="https://discord.gg/3kTNUZz276"><img src="https://img.shields.io/badge/Discord-Release%20Notifications-blue?label=Docker&style=for-the-badge"   alt="Discord Banner"/></a>

**注意**：此Discord仅用于版本通知，已禁用所有聊天消息权限。[本仓库支持需在Discussions中进行](https://github.com/mbround18/valheim-docker/discussions)

## 版本历史

- latest（稳定版）：支持mod，代码库优化
- 1.4.x（稳定版）：Discord Webhook升级
- 1.3.x（稳定版）：代码库健康度改进
- 1.2.0（稳定版）：新增停止功能和信号处理
- 1.1.1（稳定版）：修复参数补丁
- 1.1.0（不稳定版）：镜像清理和提速
- 1.0.0（稳定版）：基础功能可用

[//]: <> (链接以下...................)
[Odin]: https://raw.githubusercontent.com/mbround18/valheim-docker/main/src/odin/README.md
[Huginn]: https://raw.githubusercontent.com/mbround18/valheim-docker/main/src/huginn/README.md
[Valheim]: https://www.valheimgame.com/
[mod入门指南]: https://raw.githubusercontent.com/mbround18/valheim-docker/main/docs/tutorials/getting_started_with_mods.md
[如需帮助设置Cron计划任务，请点击此处]: https://crontab.guru/#0_1*\_\_\_\_\*

[//]: <> (图片基础URL: https://github.com/mbround18/valheim-docker/blob/main/docs/assets/name.png?raw=true)

## 贡献者 ✨

感谢以下贡献者（[emoji键](https://allcontributors.org/docs/en/emoji-key)）：

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://arneman.me/"><img src="https://avatars.githubusercontent.com/u/3298808?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Mark</b></sub></a><br /><a href="https://github.com/mbround18/valheim-docker/commits?author=bearlikelion" title="文档">📖</a></td>
    <td align="center"><a href="https://m.bruno.fyi/"><img src="https://avatars.githubusercontent.com/u/12646562?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Michael</b></sub></a><br /><a href="#infra-mbround18" title="基础设施（托管、构建工具等）">🚇</a> <a href="https://github.com/mbround18/valheim-docker/commits?author=mbround18" title="代码">💻</a> <a href="https://github.com/mbround18/valheim-docker/commits?author=mbround18" title="文档">📖</a></td>
    <td align="center"><a href="https://github.com/apps/imgbot"><img src="https://avatars.githubusercontent.com/in/4706?v=4?s=100" width="100px;" alt=""/><br /><sub><b>imgbot[bot]</b></sub></a><br /><a href="https://github.com/mbround18/valheim-docker/commits?author=imgbot[bot]" title="文档">📖</a></td>
    <td align="center"><a href="https://github.com/AGhost-7"><img src="https://avatars.githubusercontent.com/u/6957411?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Jonathan Boudreau</b></sub></a><br /><a href="https://github.com

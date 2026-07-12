---
image: beardedio/terraria
description: "用于运行Terraria服务器的Docker镜像，提供TShock Server（服务器修改版）和Vanilla Server（原版服务器）两种版本选择。"
source: https://xuanyuan.cloud/zh/r/beardedio/terraria
canonical: https://xuanyuan.cloud/zh/r/beardedio/terraria
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/beardedio/terraria" title="beardedio/terraria Docker 镜像中文简介、标签列表与拉取命令">beardedio/terraria 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# terraria

用于运行Terraria服务器的Docker镜像，提供[TShock Server](https://github.com/Pryaxis/TShock)（服务器修改版）和[Vanilla Server](https://terraria.gamepedia.com/Server)（原版服务器）两种版本。


[![自动构建](https://github.com/beardedio/terraria/actions/workflows/main.yml/badge.svg)](https://github.com/beardedio/terraria/actions/workflows/main.yml) ![Docker镜像大小（标签）](https://img.shields.io/docker/image-size/beardedio/terraria/latest) [![Docker拉取量](https://img.shields.io/docker/pulls/beardedio/terraria.svg)]() [![Docker星标数](https://img.shields.io/docker/stars/beardedio/terraria.svg)]()

## 镜像概述和主要用途
Terraria服务器镜像提供玩家通过互联网或其他网络连接进行多人游戏的平台，基于[Terraria](https://terraria.org/)游戏。该镜像支持两种服务器版本：TShock Server（功能增强的修改版）和Vanilla Server（官方原版），满足不同玩家对服务器功能的需求。

## 核心功能和特性
- **多版本支持**：提供TShock和Vanilla两种服务器版本，各版本包含多个具体游戏版本标签
- **持久化存储**：通过卷挂载实现世界数据、配置文件的持久化保存
- **灵活配置**：支持通过环境变量指定世界文件，以及附加命令行参数
- **即开即用**：简化服务器部署流程，无需手动配置依赖环境

## 支持的标签及对应Dockerfile链接
* vanilla-1.4.4.9, vanilla-latest, latest [(containers/vanilla/1.4.4.9/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/vanilla/1.4.4.9/Dockerfile) - 原版1.4.4.9版本、原版最新版本、最新版本
* vanilla-1.4.3.6 [(containers/vanilla/1.4.3.6/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/vanilla/1.4.3.6/Dockerfile) - 原版1.4.3.6版本
* vanilla-1.4.2.3 [(containers/vanilla/1.4.2.3/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/vanilla/1.4.2.3/Dockerfile) - 原版1.4.2.3版本
* vanilla-1.4.1.2 [(containers/vanilla/1.4.1.2/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/vanilla/1.4.1.2/Dockerfile) - 原版1.4.1.2版本
* tshock-5.2.4, tshock-latest [(containers/tshock/5.2.4/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/tshock/5.2.4/Dockerfile) - TShock 5.2.4版本、TShock最新版本
* tshock-5.2.3 [(containers/tshock/5.2.3/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/tshock/5.2.3/Dockerfile) - TShock 5.2.3版本
* tshock-5.2.2 [(containers/tshock/5.2.2/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/tshock/5.2.2/Dockerfile) - TShock 5.2.2版本
* tshock-5.2.1 [(containers/tshock/5.2.1/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/tshock/5.2.1/Dockerfile) - TShock 5.2.1版本
* tshock-5.2.0 [(containers/tshock/5.2.0/Dockerfile)](https://github.com/beardedio/terraria/blob/main/containers/tshock/5.2.0/Dockerfile) - TShock 5.2.0版本

## 快速参考
- **获取帮助**：[TShock讨论区](https://github.com/Pryaxis/TShock/discussions) 或 [Terraria论坛](https://forums.terraria.org/index.php?forums/)
- **问题反馈地址**：https://github.com/beardedio/terraria/issues
- **维护者**：[Bearded.io的Henry Skrtich](https://www.bearded.io/#footer)
- **支持的Docker版本**：[支持最新版本](https://github.com/docker/docker-ce/releases/latest)（对1.8版本及以上提供尽力支持）

## 使用方法和配置说明

### 基本使用命令
```bash
docker create --rm -it \
  --name=terraria \
  -v <宿主机数据目录>:/config \
  -e world=<世界文件名> \
  -p 7777:7777 \
  ghcr.io/beardedio/terraria:latest
```

Docker镜像可在 [ghcr.io](https://github.com/beardedio/terraria/pkgs/container/terraria) 和 [Docker Hub](https://hub.docker.com/r/beardedio/terraria) 获取。

### 生成新世界
要在无需用户干预的情况下运行Terraria服务器，需配置使用已生成的世界。你可以使用已有的世界，或通过以下命令生成新世界：
```bash
sudo docker run --rm -it -p 7777:7777 \
    -v $HOME/terraria/config:/config \
    --name=terraria \
    ghcr.io/beardedio/terraria:latest
```
执行后按照提示创建新世界。

### 使用已有世界启动服务器
世界文件需存在于config文件夹中。使用已有世界启动服务器的命令：
```bash
sudo docker run --rm -dit \
  --name=terraria \
  -v $HOME/terraria/config:/config \
  -e world=<世界文件名>.wld \
  -p 7777:7777 \
  ghcr.io/beardedio/terraria:latest
```

#### 常见问题处理
- 若Docker提示容器名称已存在，需删除旧容器：`sudo docker rm terraria`
- 重新附加到运行中的容器：`sudo docker attach terraria`（可执行服务器命令，按Ctrl-p Ctrl-q断开连接）

### Docker Compose配置示例
以下是使用原版服务器的docker-compose示例：
```yaml
version: '3'

services:
  terraria:
    image: ***-ghcr.xuanyuan.run/beardedio/terraria:latest
    ports:
      - '7777:7777'
    restart: unless-stopped
    environment:
      - world=<世界文件名>.wld
    volumes:
      - $HOME/terraria/config:/config
    tty: true
    stdin_open: true
```

### 不同版本说明
#### beardedio/terraria:tshock-latest
TShock是Terraria的服务器修改版，基于Terraria Server API开发，使用JSON进行配置管理，提供原版服务器不具备的多种功能（如权限管理、插件支持等）。

#### beardedio/terraria:tshock-dev-latest
TShock开发版，包含未发布的开发构建。这些版本可能不稳定，但更新速度快于正式版，因此能更快支持Terraria新版本。

#### beardedio/terraria:vanilla-latest
Vanilla Terraria服务器是Terraria官方提供的服务器软件，功能基础但与游戏主版本同步更新，确保兼容性。

## 常见问题解答
- **Q: 能否管理TShock的自定义插件？**  
  A: 可以。如需管理TShock容器的插件，可通过`-v <插件目录>:/tshock/ServerPlugins`添加卷挂载。若需保留TShock自带插件，需将其复制到挂载的插件目录中。挂载插件目录会覆盖TShock自带插件。

- **Q: 启动容器后不断提示选择世界，如何解决？**  
  A: 需使用已有世界启动（服务器将自动启动），或使用-it参数交互式运行容器以创建新世界。

- **Q: 加载世界时服务器返回"System.NullReferenceException"异常，如何解决？**  
  A: 服务器需要tty连接，使用docker run启动时确保包含-it参数；使用docker-compose时需添加tty: true（参见此[问题](https://github.com/beardedio/terraria/issues/7)）。

### 注意事项
* 请查看[TShock使用说明](https://tshock.readme.io/docs/getting-started)以正确安装和配置服务器。
* 任何[额外命令行参数](https://tshock.readme.io/docs/command-line-parameters)可添加到服务器启动命令的末尾。Docker将$HOME/terraria/world（Linux主机目录）映射到/tshock/world（容器目录）。
* 更多关于运行服务器的信息可在[维基](https://terraria.gamepedia.com/Server)中找到。

### 许可证
MIT许可证（MIT）  
版权所有 (c) 2025 Henry Skrtich

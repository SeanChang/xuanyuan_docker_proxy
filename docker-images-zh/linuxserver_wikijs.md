---
image: linuxserver/wikijs
description: "LinuxServer.io的wikijs镜像提供轻量级、易于部署的现代维基引擎，适用于个人或团队快速创建和管理知识库。"
source: https://xuanyuan.cloud/zh/r/linuxserver/wikijs
canonical: https://xuanyuan.cloud/zh/r/linuxserver/wikijs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/wikijs" title="linuxserver/wikijs Docker 镜像中文简介、标签列表与拉取命令">linuxserver/wikijs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/wikijs Docker镜像文档


## 镜像概述和主要用途

[linuxserver/wikijs](https://github.com/linuxserver/docker-wikijs) 是由LinuxServer.io团队构建的Docker镜像，用于运行[Wikijs](https://github.com/Requarks/wiki)——一个基于NodeJS开发的现代、轻量级且功能强大的wiki应用。该镜像继承了LinuxServer.io系列镜像的核心优势，包括定期更新、简化的用户权限管理、自定义基础镜像等，为快速部署和运行Wikijs提供了可靠的容器化解决方案。


## 核心功能和特性

### LinuxServer.io镜像特性
- **定期应用更新**：及时同步上游Wikijs版本更新
- **用户权限映射**：通过PUID/PGID参数轻松配置容器内用户权限，避免主机与容器间的权限冲突
- **自定义基础镜像**：基于s6 overlay构建，提供稳定的进程管理
- **高效层复用**：每周基础OS更新，跨镜像共享公共层，减少存储空间占用、 downtime和带宽消耗
- **定期安全更新**：及时修复基础系统和依赖组件的安全漏洞

### Wikijs应用特性
- 现代Web界面，支持响应式设计
- 多数据库支持（SQLite、PostgreSQL等）
- 丰富的内容编辑功能（Markdown、可视化编辑等）
- 版本控制与历史记录
- 多用户权限管理
- 插件扩展系统


## 支持架构

该镜像通过Docker manifest支持多平台架构，拉取`lscr.io/linuxserver/wikijs:latest`即可自动匹配对应架构。也可通过标签指定特定架构：

| 架构       | 支持状态 | 标签格式               |
| :--------- | :------- | :--------------------- |
| x86-64     | ✅        | amd64-\<version tag\>  |
| arm64      | ✅        | arm64v8-\<version tag\> |


## 应用设置

- **数据库配置**：首次运行时，数据库相关环境变量（如`DB_TYPE`、`DB_HOST`等）会生效并生成配置文件。后续如需修改数据库设置，需直接编辑容器内的`/config/config.yml`文件。
- **官方文档**：更多配置细节请参考[Wikijs官方文档](https://docs.requarks.io/)。
- **只读操作**：支持以只读容器文件系统运行，详见[LinuxServer.io只读文档](https://docs.linuxserver.io/misc/read-only/)。
- **非Root运行**：支持以非root用户身份运行容器，详见[LinuxServer.io非Root文档](https://docs.linuxserver.io/misc/non-root/)。


## 使用场景和适用范围

Wikijs适用于以下场景：
- 团队知识库与文档协作平台
- 个人笔记与知识管理系统
- 项目文档与API文档托管
- 内部Wiki与帮助中心
- 开源项目文档站点


## 使用方法和配置说明

### Docker Compose（推荐）

```yaml
---
services:
  wikijs:
    image: docker.xuanyuan.run/linuxserver/wikijs:latest
    container_name: wikijs
    environment:
      - PUID=1000               # 运行用户ID（必填）
      - PGID=1000               # 运行组ID（必填）
      - TZ=Etc/UTC              # 时区（必填，如Asia/Shanghai）
      - DB_TYPE=sqlite          # 数据库类型（可选，默认sqlite，支持postgres）
      - DB_HOST=                # 数据库主机（可选，PostgreSQL时必填）
      - DB_PORT=                # 数据库端口（可选，PostgreSQL时必填）
      - DB_NAME=                # 数据库名称（可选，PostgreSQL时必填）
      - DB_USER=                # 数据库用户（可选，PostgreSQL时必填）
      - DB_PASS=                # 数据库密码（可选，PostgreSQL时必填）
    volumes:
      - /path/to/wikijs/config:/config  # 配置文件存储（必填）
      - /path/to/data:/data             # 数据存储（必填）
    ports:
      - 3000:3000               # Web界面端口（必填）
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=wikijs \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e DB_TYPE=sqlite `#可选` \
  -e DB_HOST= `#可选` \
  -e DB_PORT= `#可选` \
  -e DB_NAME= `#可选` \
  -e DB_USER= `#可选` \
  -e DB_PASS= `#可选` \
  -p 3000:3000 \
  -v /path/to/wikijs/config:/config \
  -v /path/to/data:/data \
  --restart unless-stopped \
  lscr.io/linuxserver/wikijs:latest
```


## 参数说明

### 端口映射（-p）
| 参数         | 功能说明                  |
| :----------- | :------------------------ |
| `-p 3000:3000` | Wikijs Web界面访问端口 |

### 环境变量（-e）
| 参数             | 功能说明                                                                 | 是否必填 |
| :--------------- | :----------------------------------------------------------------------- | :------- |
| `PUID=1000`      | 容器内运行用户ID，用于权限映射，通过`id your_user`命令获取                | 是       |
| `PGID=1000`      | 容器内运行组ID，同上                                                     | 是       |
| `TZ=Etc/UTC`     | 容器时区，如`Asia/Shanghai`（上海）、`Europe/London`（伦敦）             | 是       |
| `DB_TYPE=sqlite` | 数据库类型，支持`sqlite`（默认）或`postgres`                             | 否       |
| `DB_HOST=`       | 数据库主机地址（仅PostgreSQL时需要）                                     | 否       |
| `DB_PORT=`       | 数据库端口（仅PostgreSQL时需要，如5432）                                 | 否       |
| `DB_NAME=`       | 数据库名称（仅PostgreSQL时需要）                                         | 否       |
| `DB_USER=`       | 数据库用户名（仅PostgreSQL时需要）                                       | 否       |
| `DB_PASS=`       | 数据库密码（仅PostgreSQL时需要）                                         | 否       |
| `UMASK=022`      | 应用权限掩码，控制新创建文件的权限（默认022）                            | 否       |

### 数据卷（-v）
| 参数                          | 功能说明                  |
| :---------------------------- | :------------------------ |
| `-v /path/to/wikijs/config:/config` | 存储Wikijs配置文件        |
| `-v /path/to/data:/data`            | 存储Wikijs数据（如页面内容） |

### 高级参数
| 参数                  | 功能说明                                  |
| :-------------------- | :---------------------------------------- |
| `--read-only=true`    | 以只读文件系统运行容器（需配合临时目录挂载） |
| `--user=1000:1000`    | 指定非root用户运行容器（PUID:PGID）        |


## 环境变量与Docker Secrets

支持通过文件注入环境变量，使用`FILE__`前缀指定文件路径，例如：
```bash
-e FILE__DB_PASS=/run/secrets/db_password
```
容器将从`/run/secrets/db_password`文件中读取`DB_PASS`变量的值。


## Umask设置

通过`-e UMASK=022`可自定义应用的umask值（默认022）。umask用于控制新创建文件的权限，其值为权限掩码（非直接权限值），具体规则参考[umask文档](https://en.wikipedia.org/wiki/Umask)。


## 用户/组标识符（PUID/PGID）

当使用数据卷（`-v`）时，主机与容器间可能存在权限冲突。通过`PUID`和`PGID`可将容器内用户映射到主机用户，确保数据卷权限一致。获取当前用户的PUID/PGID：
```bash
id your_user
```
输出示例：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```


## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=wikijs&query=%24.mods%5B%27wikijs%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=wikijs)  
[![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal)

Docker Mods是用于扩展容器功能的插件，可通过上述链接查看适用于Wikijs的Mods及通用Mods。


## 支持信息

### 容器管理命令
- **进入容器shell**：
  ```bash
  docker exec -it wikijs /bin/bash
  ```
- **查看实时日志**：
  ```bash
  docker logs -f wikijs
  ```
- **查看容器版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' wikijs
  ```
- **查看镜像版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/wikijs:latest
  ```


## 更新方法

### 使用Docker Compose
```bash
# 更新镜像
docker-compose pull wikijs

# 重启容器
docker-compose up -d wikijs

# 清理旧镜像
docker image prune
```

### 使用Docker Run
```bash
# 更新镜像
docker pull docker.xuanyuan.run/linuxserver/wikijs:latest

# 停止并删除旧容器
docker stop wikijs && docker rm wikijs

# 重新创建容器（使用原参数）
docker run -d [原参数] lscr.io/linuxserver/wikijs:latest

# 清理旧镜像
docker image prune
```

### 镜像更新通知
推荐使用[Diun](https://crazymax.dev/diun/)监控镜像更新，不建议使用自动更新工具。


## 本地构建

```bash
# 克隆仓库
git clone https://github.com/linuxserver/docker-wikijs.git
cd docker-wikijs

# 构建镜像
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/wikijs:latest .

# 构建ARM架构（需qemu-static）
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/wikijs:arm64v8-latest .
```


## 版本历史

- **14.10.25:** 基于Alpine 3.22重建
- **18.01.25:** 基于Alpine 3.21重建
- **01.06.24:** 基于Alpine 3.20重建
- **23.12.23:** 基于Alpine 3.19重建
- **25.08.22:** 基于Alpine 3.18重建
- **07.07.23:** 移除armhf架构支持
- **21.03.23:** 恢复git和openssh包以支持git存储；修复系统信息页面
- **10.10.22:** 基于Alpine 3.16重建，迁移至s6v3
- **23.01.21:** 基于Alpine 3.13重建
- **01.06.20:** 基于Alpine 3.12重建
- **28.04.20:** 添加python依赖（用于NPM模块）和git（用于存储模块）
- **14.12.19:** 初始发布

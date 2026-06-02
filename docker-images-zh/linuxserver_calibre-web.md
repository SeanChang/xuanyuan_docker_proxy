---
image: linuxserver/calibre-web
description: "这是由LinuxServer.io为您提供的Calibre-Web容器，其中Calibre-Web是一款基于Calibre的网页版电子书管理工具，支持通过浏览器便捷管理、搜索、分类及阅读电子书库，而该容器由LinuxServer.io团队精心打造，旨在提供稳定、高效且易于部署的电子书管理解决方案，帮助用户无需复杂配置即可快速搭建个人或团队的电子书管理系统，轻松实现电子书的一站式管理与访问。"
source: https://xuanyuan.cloud/zh/r/linuxserver/calibre-web
canonical: https://xuanyuan.cloud/zh/r/linuxserver/calibre-web
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/calibre-web" title="linuxserver/calibre-web Docker 镜像中文简介、标签列表与拉取命令">linuxserver/calibre-web 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io docker-calibre-web 容器介绍


## LinuxServer.io 容器特点

LinuxServer.io 团队推出的容器具有以下核心特性：  
- 定期及时的应用更新  
- 简单的用户映射（通过 PGID、PUID 配置权限）  
- 基于 s6 覆盖层的自定义基础镜像  
- 每周基础系统更新，通过统一层设计减少存储空间占用、 downtime 和带宽消耗  
- 定期安全更新  


## calibre-web 简介

[calibre-web]([]) 是一款基于 Web 的电子书管理工具，可通过现有 Calibre 数据库提供电子书浏览、阅读和下载功能。支持集成 Google Drive，也可直接通过界面编辑元数据和管理 Calibre 库。该软件基于 library 项目开发，采用 GPL v3 协议开源。


## 支持架构

通过 docker 镜像清单实现多平台支持，拉取 `lscr.io/linuxserver/calibre-web:latest` 即可自动匹配对应架构。也可通过标签指定架构：  

| 架构       | 支持状态 | 标签格式               |
|------------|----------|------------------------|
| x86-64     | ✅        | amd64-\<版本标签\>     |
| arm64      | ✅        | arm64v8-\<版本标签\>   |


## 版本标签

| 标签    | 支持状态 | 说明                     |
|---------|----------|--------------------------|
| latest  | ✅        | calibre-web 稳定版本     |
| nightly | ✅        | calibre-web 开发分支版本 |


## 应用设置

1. **初始访问**：Web 界面地址为 `[]  
2. **库路径配置**：首次设置时，输入 `/books` 作为 Calibre 库路径  
3. **默认登录信息**：  
   - 用户名：admin  
   - 密码：admin123  
4. **密码重置**：若忘记密码，需通过命令行指定数据库文件重置（需替换 `<user>` 和 `<pass>`）：  
   ```bash
   docker exec -it calibre-web python3 /app/calibre-web/cps.py -p /config/app.db -s <user>:<pass>
   ```  
5. **Unrar 配置**：默认已集成 unrar，需在管理界面（基础配置 > 外部程序）设置路径为 `/usr/bin/unrar`  
6. **电子书转换功能**（仅 64 位架构）：  
   - 添加环境变量 `DOCKER_MODS=linuxserver/mods:universal-calibre` 启用转换依赖  
   - 版本 0.6.21 及以下：在管理界面设置“Calibre 转换工具路径”为 `/usr/bin/ebook-convert`  
   - 版本 0.6.22 及以上：设置路径为 `/usr/bin/`  
7. **kepubify 配置**：默认集成 epub 转 kepub 工具，在管理界面设置路径为 `/usr/bin/kepubify`  


## 使用方法

### docker-compose（推荐）

创建 `docker-compose.yml` 文件，填入以下内容（替换 `<路径>` 为实际目录）：  

```yaml
---
services:
  calibre-web:
    image: lscr.io/linuxserver/calibre-web:latest
    container_name: calibre-web
    environment:
      - PUID=1000          # 用户ID（必填）
      - PGID=1000          # 组ID（必填）
      - TZ=Etc/UTC         # 时区（必填，如 Asia/Shanghai）
      - DOCKER_MODS=linuxserver/mods:universal-calibre  # 可选，启用转换功能（仅x86-64）
      - OAUTHLIB_RELAX_TOKEN_SCOPE=1  # 可选，支持Google OAuth
    volumes:
      - /path/to/calibre-web/data:/config  # 配置文件目录（必填）
      - /path/to/calibre/library:/books    # Calibre库目录（必填）
    ports:
      - 8083:8083          # Web界面端口映射（必填）
    restart: unless-stopped
```

启动容器：  
```bash
docker-compose up -d
```


### docker cli

直接执行命令（替换 `<路径>` 为实际目录）：  

```bash
docker run -d \
  --name=calibre-web \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e DOCKER_MODS=linuxserver/mods:universal-calibre `# 可选` \
  -e OAUTHLIB_RELAX_TOKEN_SCOPE=1 `# 可选` \
  -p 8083:8083 \
  -v /path/to/calibre-web/data:/config \
  -v /path/to/calibre/library:/books \
  --restart unless-stopped \
  lscr.io/linuxserver/calibre-web:latest
```


## 参数说明

| 参数                          | 功能说明                                                                 |
|-------------------------------|--------------------------------------------------------------------------|
| `-p 8083:8083`                | Web界面端口映射（主机端口:容器端口）                                     |
| `-e PUID=1000`                | 用户ID，用于权限映射（通过 `id 用户名` 命令获取）                        |
| `-e PGID=1000`                | 组ID，同上                                                               |
| `-e TZ=Etc/UTC`               | 时区设置，如 `Asia/Shanghai`                                             |
| `-e DOCKER_MODS=...`          | 可选，添加转换功能依赖（仅x86-64架构）                                   |
| `-e OAUTHLIB_RELAX_TOKEN_SCOPE=1` | 可选，允许Google OAuth授权                                               |
| `-v /config`                  | 容器配置文件目录（需映射到主机目录）                                     |
| `-v /books`                   | Calibre库目录（需映射到主机现有Calibre数据库目录）                       |


## 环境变量与权限配置

### 从文件读取环境变量  
通过 `FILE__变量名` 格式可从文件加载环境变量，例如：  
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable  # 从文件加载 MYVAR 变量
```

### Umask 设置  
通过 `-e UMASK=022` 自定义容器内服务的文件权限掩码（默认值 022，详见 [umask 说明]()）。

### 用户/组ID（PUID/PGID）  
为避免权限问题，需确保主机目录所有者的 UID/GID 与容器内 `PUID/PGID` 一致。通过 `id 用户名` 命令获取当前用户的 UID/GID：  
```bash
id your_user  # 示例输出：uid=1000(your_user) gid=1000(your_user)
```


## Docker Mods

可通过 Docker Mods 扩展容器功能，支持的 mods 包括：  
- **calibre-web 专用 mods**：[查看列表]([])  
- **通用 mods**：[查看列表]([])  


## 支持与维护

### 容器管理命令  
- 进入容器终端：  
  ```bash
  docker exec -it calibre-web /bin/bash
  ```  
- 实时查看日志：  
  ```bash
  docker logs -f calibre-web
  ```  
- 查看容器版本：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' calibre-web
  ```  
- 查看镜像版本：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/calibre-web:latest
  ```


### 更新容器

#### 通过 docker-compose  
```bash
# 拉取最新镜像
docker-compose pull calibre-web

# 更新容器（保留配置）
docker-compose up -d calibre-web

# 清理旧镜像
docker image prune
```

#### 通过 docker run  
```bash
# 拉取最新镜像
docker pull lscr.io/linuxserver/calibre-web:latest

# 停止并删除旧容器
docker stop calibre-web && docker rm calibre-web

# 重新创建容器（使用原参数，配置会保留）
docker run -d [原参数] lscr.io/linuxserver/calibre-web:latest
```


### 本地构建

如需自定义镜像，可克隆源码并构建：  
```bash
git clone [] docker-calibre-web

# 构建x86-64镜像
docker build --no-cache --pull -t lscr.io/linuxserver/calibre-web:latest .

# 构建ARM镜像（需先安装qemu-static）
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
docker build -f Dockerfile.aarch64 --no-cache --pull -t lscr.io/linuxserver/calibre-web:arm64v8-latest .
```


## 版本历史

| 日期       | 变更说明                                                                 |
|------------|--------------------------------------------------------------------------|
| 07.01.25   | 默认配置 kepubify 路径                                                   |
| 05.12.24   | 基于 noble 系统重构                                                      |
| 26.08.24   | 添加依赖 xdg-utils                                                       |
| 07.07.24   | 添加依赖 libmagic1                                                       |
| 17.10.23   | 移除 calibre mod 非必需依赖                                              |
| 07.10.23   | 从 LinuxServer 仓库安装 unrar，切换到 Python 虚拟环境                    |
| 13.04.23   | 弃用 armhf 架构                                                          |
| 27.03.23   | 添加 cmake 作为 Levenshtein 构建依赖                                    |
| 27.12.22   | 添加 ghostscript、libxtst6、libxkbfile-dev 依赖                          |
| 19.10.22   | 基于 jammy 系统重构，升级 s6v3，清理构建依赖                             |
| 04.11.21   | 更新 pip 参数以忽略系统预装包                                            |
| 24.06.21   | 添加 Google OAUTH 支持说明（OAUTHLIB_RELAX_TOKEN_SCOPE）                 |
| 17.05.21   | 添加 linuxserver wheel 索引                                              |
| 25.01.21   | 添加 nightly 标签                                                        |
| 13.01.21   | 基于 Ubuntu Focal 重构                                                  |
| 13.06.19   | 添加 docker mod 支持电子书转换（仅x86-64），集成 unrar                   |
| 17.07.17   | 初始发布                                                                |


---

更多资源：  
- [LinuxServer.io 博客]([])（教程与指南）  
- []()（实时支持）  
- [论坛]([])（社区讨论）  
- [GitHub]([])（源码仓库）  
- [Open Collective]([])（支持我们的开发）

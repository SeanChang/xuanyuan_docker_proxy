---
image: lsiodev/ombi
description: "linuxserver/ombi是一款媒体请求管理工具，允许用户请求电影、电视剧等内容，适用于配合Plex、Emby等媒体服务器使用。"
source: https://xuanyuan.cloud/zh/r/lsiodev/ombi
canonical: https://xuanyuan.cloud/zh/r/lsiodev/ombi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lsiodev/ombi" title="lsiodev/ombi Docker 镜像中文简介、标签列表与拉取命令">lsiodev/ombi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/ombi

![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)

## 镜像概述和主要用途

[Ombi](https://ombi.io) 是一个Plex请求和用户管理系统，允许您托管自己的内容请求平台。如果您正在与其他用户共享Plex服务器，Ombi可让用户通过易于管理的界面请求新内容。该镜像由LinuxServer.io团队维护，提供稳定、安全且易于部署的Ombi运行环境。

LinuxServer.io团队的镜像特点：
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 基于s6 overlay的自定义基础镜像
- 每周基础操作系统更新，跨生态系统共享公共层以减少空间占用、 downtime和带宽
- 定期安全更新


## 核心功能和特性

### Ombi核心功能
- **内容请求管理**：用户可请求电影和电视内容，管理员集中处理
- **用户管理**：维护Plex用户列表，控制请求权限
- **通知系统**：用户请求时发送通知，支持多种通知方式
- **问题反馈**：允许用户对请求内容提交问题（如音频问题）
- **自动通讯**：定期向用户发送Plex服务器新增内容的新闻通讯

### LinuxServer.io镜像特性
- **多架构支持**：适配x86-64、arm64、armhf架构
- **灵活部署**：支持Docker Compose和Docker CLI部署
- **权限控制**：通过PUID/PGID实现主机与容器权限映射
- **环境变量配置**：支持通过环境变量自定义设置（如时区、基础URL）
- **数据持久化**：配置文件集中存储，支持卷挂载


## 使用场景和适用范围

### 适用场景
- 个人或家庭Plex服务器共享场景，需要用户请求内容功能
- 小型团队或社区Plex共享环境，需集中管理内容请求
- 需要自动化内容请求通知和问题反馈的Plex管理场景

### 适用用户
- Plex服务器管理员
- 共享媒体库的个人或组织
- 需要简化用户内容请求流程的管理员


## 支持的架构

该镜像通过Docker manifest支持多平台，拉取`lscr.io/linuxserver/ombi:latest`即可自动获取对应架构的镜像，也可通过标签指定特定架构：

| 架构 | 支持状态 | 标签格式 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<版本标签> |
| arm64 | ✅ | arm64v8-<版本标签> |
| armhf | ✅ | arm32v7-<版本标签> |


## 版本标签

| 标签 | 支持状态 | 描述 |
| :----: | :----: |--- |
| latest | ✅ | Ombi稳定版本 |
| development | ✅ | Ombi开发分支版本（来自`develop`分支） |


## 应用设置

1. 容器启动后，通过 `<您的IP>:3579` 访问Web界面
2. 首次使用需完成设置向导，配置Plex服务器连接
3. 根据向导提示完成用户管理、请求规则等基础配置


## 使用方法和配置说明

### Docker Compose部署（推荐）

```yaml
---
version: "2.1"
services:
  ombi:
    image: docker.xuanyuan.run/linuxserver/ombi:latest
    container_name: ombi
    environment:
      - PUID=1000               # 用户ID，详见下文说明
      - PGID=1000               # 组ID，详见下文说明
      - TZ=Europe/London        # 时区，如Asia/Shanghai
      - BASE_URL=/ombi          # 可选，反向代理子路径（移除则使用Web界面设置）
    volumes:
      - /path/to/appdata/config:/config  # 配置文件存储路径
    ports:
      - 3579:3579               # Web界面端口
    restart: unless-stopped
```

### Docker CLI部署

```bash
docker run -d \
  --name=ombi \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e BASE_URL=/ombi `#可选` \
  -p 3579:3579 \
  -v /path/to/appdata/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/ombi:latest
```


## 参数说明

### 端口参数

| 参数 | 功能 |
| :----: | --- |
| `-p 3579` | Web管理界面端口 |


### 环境变量参数

| 参数 | 功能 | 默认值 |
| :----: | --- | --- |
| `-e PUID=1000` | 运行应用的用户ID，用于权限映射 | 1000 |
| `-e PGID=1000` | 运行应用的组ID，用于权限映射 | 1000 |
| `-e TZ=Europe/London` | 容器时区，格式如`Asia/Shanghai` | Europe/London |
| `-e BASE_URL=/ombi` | 反向代理子路径（设置后Web界面设置失效） | 无 |
| `-e UMASK=022` | 文件权限掩码（可选） | 022 |


### 卷挂载参数

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | 存储Ombi所有配置文件 |


## 高级配置

### 环境变量从文件读取（Docker Secrets）

支持通过`FILE__`前缀从文件加载环境变量，例如：

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

将从`/run/secrets/mysecretpassword`文件内容设置`PASSWORD`环境变量。


### 用户/组ID（PUID/PGID）

为避免主机与容器权限冲突，通过PUID/PGID指定容器内用户的ID。获取主机用户ID和组ID的方法：

```bash
id username  # 替换为实际用户名
```

输出示例：
```
uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

其中`uid`对应PUID，`gid`对应PGID。


### Docker Mods

可通过Docker Mods扩展容器功能，支持的Mods可通过以下链接查看：
- [Ombi专用Mods](https://mods.linuxserver.io/?mod=ombi)
- [通用Mods](https://mods.linuxserver.io/?mod=universal)


## 支持信息

- **容器内Shell访问**：`docker exec -it ombi /bin/bash`
- **实时日志查看**：`docker logs -f ombi`
- **容器版本查询**：`docker inspect -f '{{ index .Config.Labels "build_version" }}' ombi`
- **镜像版本查询**：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/ombi:latest`


## 更新说明

### 通过Docker Compose更新
```bash
# 更新镜像
docker-compose pull ombi

# 更新容器
docker-compose up -d ombi

# 清理旧镜像
docker image prune
```

### 通过Docker CLI更新
```bash
# 更新镜像
docker pull docker.xuanyuan.run/linuxserver/ombi:latest

# 停止并删除旧容器
docker stop ombi && docker rm ombi

# 重新创建容器（保留/config卷则配置不会丢失）
docker run -d \
  --name=ombi \
  [原参数] \
  lscr.io/linuxserver/ombi:latest

# 清理旧镜像
docker image prune
```

### 通过Watchtower自动更新（不推荐用于生产环境）
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker.xuanyuan.run/containrrr/watchtower \
  --run-once ombi
```


## 本地构建

```bash
# 克隆仓库
git clone https://github.com/linuxserver/docker-ombi.git
cd docker-ombi

# 构建x86-64镜像
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/ombi:latest .

# 构建ARM架构镜像（需先注册qemu）
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static:register --reset
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/ombi:arm64v8-latest .
```


## 版本历史

- **11.09.22:** 迁移至s6v3基础架构
- **01.05.22:** 基于Jammy重建基础镜像
- **26.04.21:** 更新tarball名称，支持v4稳定版构建
- **18.01.21:** 更新上游仓库，废弃`v4-preview`标签（合并至`development`标签）
- **14.04.20:** 添加Ombi捐赠链接
- **10.05.19:** 新增基础URL环境变量配置
- **23.03.19:** 切换至新基础镜像，使用arm32v7标签
- **22.02.19:** 澄清标签和开发构建说明
- **25.01.19:** 添加标签和开发构建信息
- **09.01.19:** 支持多架构构建，添加aarch64镜像
- **11.03.18:** 在Dockerfile中添加HOME环境变量
- **05.03.18:** 切换至基于.net core的Ombi v3稳定版
- **26.01.18:** 修复续行符
- **16.04.17:** 切换至内部mono基础镜像
- **17.02.17:** 初始发布

---
image: linuxserver/sonarr
description: "由LinuxServer.io提供的Sonarr容器，是一款专为电视节目集管理设计的自动化工具，能够监控指定剧集的更新信息、自动从索引器获取下载链接并通过下载客户端（如Deluge、qBittorrent等）完成资源下载，同时支持按自定义规则整理文件结构、重命名剧集文件以保持媒体库整洁有序；LinuxServer.io作为专注于提供高质量容器化应用的团队，其构建的Sonarr容器基于轻量级Linux系统，优化了资源占用与运行稳定性，适合家庭媒体服务器或个人影视库的自动化管理场景使用。"
source: https://xuanyuan.cloud/zh/r/linuxserver/sonarr
canonical: https://xuanyuan.cloud/zh/r/linuxserver/sonarr
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/sonarr" title="linuxserver/sonarr Docker 镜像中文简介、标签列表与拉取命令">linuxserver/sonarr — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/linuxserver/sonarr" title="linuxserver/sonarr Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/sonarr</a>

# linuxserver/sonarr 容器介绍


## LinuxServer.io 团队简介  
[LinuxServer.io]([]) 团队专注于提供高质量容器镜像，其特点包括：  
- 应用定期及时更新  
- 简单的用户权限映射（通过 PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周更新基础系统，通过共享层减少存储空间、 downtime 和带宽消耗  
- 定期安全更新  


## Sonarr 应用说明  
[Sonarr]([])（前身为 NZBdrone）是一款面向 Usenet 和 BT 用户的 PVR 工具，可监控多个 RSS 源获取新剧集，自动下载、分类并重命名文件，还能在更高质量版本发布时自动升级已下载文件。  


## 支持的架构  
通过 Docker 清单实现多平台支持，拉取 `lscr.io/linuxserver/sonarr:latest` 即可自动匹配对应架构，也可通过标签指定：  

| 架构       | 支持状态 | 标签格式               |  
| :--------- | :------- | :--------------------- |  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\> |  


## 版本标签  
| 标签    | 支持状态 | 说明                     |  
| :------ | :------- | :----------------------- |  
| latest  | ✅        | Sonarr 稳定版 release    |  
| develop | ✅        | Sonarr 开发版            |  


## 应用设置  
- **Web 界面访问**：通过 `<你的IP>:8989` 访问管理界面，更多信息见 [Sonarr 官网]([])。  

- **媒体文件夹配置**：  
  镜像默认提供 `/tv`（电视库）和 `/downloads`（下载目录）作为可选路径，适合快速上手，但可能失去硬链接（同一文件多路径引用，节省空间）和原子移动（即时文件移动，非复制+删除）功能。若需这些特性，建议参考 [Servarr 官方文档]([]) 规划路径。  


## 使用方法  
### 前置说明  
除非标记为“可选”，否则以下参数为必填项。  


### docker-compose（推荐）  
创建 `docker-compose.yml` 文件：  
```yaml
---
services:
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000          # 用户ID（见下方说明）
      - PGID=1000          # 组ID（见下方说明）
      - TZ=Etc/UTC         # 时区，如 Asia/Shanghai
    volumes:
      - /path/to/sonarr/data:/config          # 配置文件目录（必填）
      - /path/to/tvseries:/tv                 # 电视库目录（可选）
      - /path/to/downloads:/downloads         # 下载客户端输出目录（可选）
    ports:
      - 8989:8989          # Web界面端口
    restart: unless-stopped
```  
启动容器：`docker-compose up -d`  


### docker cli  
直接执行命令：  
```bash
docker run -d \
  --name=sonarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8989:8989 \
  -v /path/to/sonarr/data:/config \
  -v /path/to/tvseries:/tv `# 可选` \
  -v /path/to/downloads:/downloads `# 可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/sonarr:latest
```  


## 参数说明  

| 参数                          | 功能说明                                                                 |  
| :---------------------------- | :----------------------------------------------------------------------- |  
| `-p 8989:8989`                | Web 管理界面端口映射                                                     |  
| `-e PUID=1000`                | 用户ID，用于解决权限问题（见下方“用户/组ID”说明）                        |  
| `-e PGID=1000`                | 组ID，同上                                                               |  
| `-e TZ=Etc/UTC`               | 时区设置，格式参考 [时区列表]() |  
| `-v /config`                  | 配置文件和数据库存储目录（必填）                                         |  
| `-v /tv`                      | 电视库目录（可选，需配合应用设置）                                       |  
| `-v /downloads`               | 下载客户端输出目录（可选，需配合应用设置）                               |  
| `--read-only=true`            | 只读文件系统运行（需参考 [文档]([])） |  
| `--user=1000:1000`            | 非root用户运行（需参考 [文档]([])） |  


## 用户/组ID（PUID/PGID）  
卷映射时，主机与容器可能出现权限冲突。通过指定 `PUID` 和 `PGID`，确保容器内用户与主机目录所有者一致。  

**获取方法**：在主机执行 `id 你的用户名`，输出示例：  
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```  
其中 `uid=1000` 即 PUID，`gid=1000` 即 PGID。  


## 支持与维护  

### 常用操作命令  
- **进入容器终端**：  
  ```bash
  docker exec -it sonarr /bin/bash
  ```  
- **实时查看日志**：  
  ```bash
  docker logs -f sonarr
  ```  
- **查看容器版本**：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' sonarr
  ```  


### 更新容器  
#### docker-compose  
```bash
# 拉取最新镜像
docker-compose pull sonarr
# 重启容器（保留配置）
docker-compose up -d sonarr
# 清理旧镜像
docker image prune
```  

#### docker cli  
```bash
# 拉取最新镜像
docker pull lscr.io/linuxserver/sonarr:latest
# 停止并删除旧容器
docker stop sonarr && docker rm sonarr
# 用原参数重建容器（/config目录会保留配置）
docker run -d [原参数] lscr.io/linuxserver/sonarr:latest
# 清理旧镜像
docker image prune
```  


### 本地构建  
如需自定义镜像，可克隆源码并构建：  
```bash
git clone [] docker-sonarr
docker build --no-cache --pull -t lscr.io/linuxserver/sonarr:latest .
```  


## 版本历史  
- **2025.07.05**：基于 Alpine 3.22 重构  
- **2025.01.09**：修复无root用户入口  
- **2024.12.23**：基于 Alpine 3.21 重构  
- **2023.12.30**：主分支基于 Alpine 3.19 重构  
- **2023.02.15**：主分支基于 Jammy 重构  
- **2022.11.24**：develop 分支升级至 v4，基于 Alpine 3.16  


## 相关资源  
- [LinuxServer 博客]([])：容器使用指南与教程  
- [ 社区]()：实时支持与交流  
- [论坛]([])：社区讨论  
- [GitHub 源码]([])：查看所有仓库  
- [捐赠支持]([])：支持团队发展

---
image: linuxserver/jackett
description: "这是由LinuxServer.io提供的Jackett容器，其中Jackett是一款实用的种子索引聚合工具，能够整合多个torrent追踪器的搜索结果，为qBittorrent、Deluge等各类P2P下载客户端提供统一的搜索接口，帮助用户更便捷地查找和获取所需资源；而LinuxServer.io团队凭借专业的容器化技术，确保该Jackett容器具备稳定的运行环境、简便的部署流程以及持续的更新支持，可满足用户在不同系统环境下高效使用Jackett的需求。"
source: https://xuanyuan.cloud/zh/r/linuxserver/jackett
canonical: https://xuanyuan.cloud/zh/r/linuxserver/jackett
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [linuxserver/jackett — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/jackett)

含镜像标签、拉取命令、部署文档与相关推荐。

[linuxserver/jackett Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/linuxserver/jackett)

# LinuxServer.io Jackett 容器介绍


## LinuxServer.io 容器特点  
LinuxServer.io 团队推出的容器具有以下优势：  
- 定期及时的应用更新  
- 简单的用户映射（支持 PGID、PUID 设置）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周基础系统更新，全生态共享通用层，减少存储空间占用、 downtime 和带宽消耗  
- 定期安全更新  


## 关于 Jackett  
[Jackett]([]) 是一款代理服务器工具，可将应用（如 Sonarr、SickRage、CouchPotato、Mylar 等）的查询请求转换为特定追踪器网站的 HTTP 查询，解析 HTML 响应后将结果返回给请求应用。支持获取最新上传内容（如 RSS 订阅）和执行搜索，集中维护索引器的抓取与转换逻辑，减轻其他应用的负担。  


## 支持的架构  
通过 Docker 清单实现多平台适配，拉取 `lscr.io/:latest` 即可自动匹配对应架构，也可通过标签指定具体版本：  

| 架构       | 是否支持 | 标签格式               |  
| :--------- | :------- | :--------------------- |  
| x86-64     | ✅        | amd64-\<版本标签\>     |  
| arm64      | ✅        | arm64v8-\<版本标签\>   |  


## 应用设置  
Web 管理界面地址为 `<你的IP>:9117`，可在此配置追踪器和与其他应用的连接。更多详情参考 [Jackett 官方文档]([])。  


## 特殊运行模式  

### 只读文件系统  
本镜像支持以只读容器文件系统运行，详情参考 [LinuxServer.io 只读模式文档]([])。  
**注意**：只读模式下 `AUTO_UPDATE` 功能不可用。  

### 非 root 用户运行  
支持以非 root 用户身份运行容器，详情参考 [LinuxServer.io 非 root 模式文档]([])。  
**注意**：非 root 模式下 `AUTO_UPDATE` 功能不可用。  


## 使用方法  

### 推荐：Docker Compose  
创建 `docker-compose.yml` 文件，内容如下（替换路径和参数）：  
```yaml
---
services:
  jackett:
    image: lscr.io/:latest
    container_name: jackett
    environment:
      - PUID=1000          # 用户ID（详见下文说明）
      - PGID=1000          # 组ID（详见下文说明）
      - TZ=Etc/UTC         # 时区，参考时区列表：      - AUTO_UPDATE=true   # 可选：允许容器内自动更新 Jackett
      - RUN_OPTS=          # 可选：传递额外启动参数
    volumes:
      - /path/to/jackett/data:/config   # 本地 Jackett 配置文件路径
      - /path/to/blackhole:/downloads   # 本地种子黑洞路径
    ports:
      - 9117:9117          # WebUI 端口映射
    restart: unless-stopped
```


### Docker CLI 命令  
直接通过命令行启动容器（替换路径和参数）：  
```bash
docker run -d \
  --name=jackett \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e AUTO_UPDATE=true `#可选` \
  -e RUN_OPTS= `#可选` \
  -p 9117:9117 \
  -v /path/to/jackett/data:/config \
  -v /path/to/blackhole:/downloads \
  --restart unless-stopped \
  lscr.io/:latest
```


## 参数说明  
容器通过运行时参数配置，格式为 `<外部>:<内部>`。以下是核心参数说明：  

| 参数                  | 作用                                                                 |  
| :-------------------- | :------------------------------------------------------------------- |  
| `-p 9117:9117`        | WebUI 端口映射（容器内端口固定为 9117）                               |  
| `-e PUID=1000`        | 用户ID，用于解决宿主机与容器的权限问题，详见下文“用户/组ID说明”         |  
| `-e PGID=1000`        | 组ID，同上                                                           |  
| `-e TZ=Etc/UTC`       | 时区设置，如 `Asia/Shanghai` 表示中国时区                             |  
| `-e AUTO_UPDATE=true` | 允许 Jackett 在容器内自动更新（只读/非 root 模式下不可用）             |  
| `-e RUN_OPTS=`        | 传递额外启动参数（如 `--proxy []                     |  
| `-v /config`          | Jackett 配置文件存储路径（需映射宿主机目录）                          |  
| `-v /downloads`       | 种子黑洞路径（用于接收下载任务）                                      |  
| `--read-only=true`    | 启用只读文件系统（需配合 [文档]([]) 配置） |  
| `--user=1000:1000`    | 以非 root 用户运行容器（需配合 [文档]([]) 配置） |  


## 环境变量与 Docker Secrets  
可通过文件传递环境变量，格式为 `-e FILE__<变量名>=/path/to/file`。例如：  
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable  # 将 /run/secrets/mysecretvariable 文件内容作为 MYVAR 的值
```


## Umask 设置  
可通过 `-e UMASK=022` 覆盖默认权限掩码（umask）。注意 umask 是权限减法，而非直接设置权限，详情参考 [umask 说明]()。  


## 用户/组ID（PUID/PGID）说明  
使用 `-v` 挂载宿主机目录时，需确保宿主机目录所有者与容器内用户ID（PUID）、组ID（PGID）一致，避免权限问题。  

**查看宿主机用户ID和组ID**：  
运行 `id your_user`（替换 `your_user` 为你的用户名），示例输出：  
```text
uid=1000(你的用户名) gid=1000(你的用户名) groups=1000(你的用户名)
```  
其中 `uid=1000` 即 PUID，`gid=1000` 即 PGID。  


## Docker Mods  
可通过 Docker Mods 扩展容器功能，支持为 Jackett 添加额外工具或配置。详情参考：  
- [Jackett 专用 Mods]([])  
- [通用 Mods]([])  


## 支持与维护  

### 常用操作命令  
- 进入运行中的容器 shell：  
  ```bash
  docker exec -it jackett /bin/bash
  ```  
- 实时查看容器日志：  
  ```bash
  docker logs -f jackett
  ```  
- 查看容器版本：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' jackett
  ```  
- 查看镜像版本：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/:latest
  ```  


### 更新容器  

#### 通过 Docker Compose  
- 更新所有镜像：  
  ```bash
  docker-compose pull
  ```  
- 更新单个镜像（如 Jackett）：  
  ```bash
  docker-compose pull jackett
  ```  
- 重启容器（应用更新）：  
  ```bash
  docker-compose up -d  # 重启所有容器
  # 或仅重启 Jackett：docker-compose up -d jackett
  ```  
- 清理旧镜像：  
  ```bash
  docker image prune
  ```  


#### 通过 Docker Run  
- 更新镜像：  
  ```bash
  docker pull lscr.io/:latest
  ```  
- 停止并删除旧容器：  
  ```bash
  docker stop jackett && docker rm jackett
  ```  
- 用原参数重新创建容器（配置文件通过 `/config` 目录保留）：  
  ```bash
  # 重新执行前文的 docker run 命令
  ```  


### 镜像更新通知  
推荐使用 [Diun]([]) 接收镜像更新通知，不建议使用自动更新工具。  


## 本地构建  
如需自定义镜像，可通过以下步骤本地构建：  
```bash
git clone [] docker-jackett
docker build \
  --no-cache \
  --pull \
  -t lscr.io/:latest .
```  

**跨架构构建**：需先注册 qemu-static：  
```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```  
然后通过 `-f Dockerfile.aarch64` 指定架构（如 ARM64）。  


## 版本历史  
- **2025年7月9日**：基于 Alpine 3.22 重构。  
- **2025年1月12日**：基于 Alpine 3.21 重构。  
- **2024年5月31日**：基于 Alpine 3.20 重构。  
- **2024年3月11日**：基于 Alpine 3.19 重构，移除开发标签（上游已提供 nightly 稳定版）。  
- **2023年7月11日**：基于 Alpine 3.18 重构。  
- **2023年7月1日**：停止支持 armhf 架构。  
- **2023年2月13日**：添加 icu-data-full 以解决西里尔字符集相关 ICU 问题。  
- **2023年2月11日**：基于 Alpine 3.17 重构，迁移至 s6v3。  
- **2022年5月10日**：基于 Ubuntu Focal 重构。  
- **2020年5月24日**：支持用户手动启用自动更新。  


## 相关资源  
- [LinuxServer.io 博客]([])：容器使用指南、教程及更多内容。  
- []()：实时社区支持与团队交流。  
- [论坛]([])：社区讨论与问题反馈。  
- [GitHub]([])：源码仓库。  
- [赞助支持]([])：欢迎通过捐赠或贡献支持开发。

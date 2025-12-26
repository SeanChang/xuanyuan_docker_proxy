# Docker 中部署 qBittorrent 全指南

![Docker 中部署 qBittorrent 全指南](https://img.xuanyuan.dev/docker/blog/docker-qbittorrent.png)

*分类: Docker,qBittorrent  | 标签: qBittorrent,docker,部署教程 | 发布时间: 2025-10-03 12:53:27*

> 本文详细介绍在Docker中部署linuxserver/qbittorrent的完整流程，包括查看该镜像特点、通过轩辕镜像或官方方式下载镜像，提供快速部署（测试用）、挂载目录（生产用）、docker-compose（企业级）三种部署方式，以及验证部署结果的方法和解决登录密码、下载速度等常见问题的方案。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1、查看 qBittorrent 镜像详情
你可以在 轩辕镜像 中找到 qBittorrent 镜像页面：
👉 [https://xuanyuan.cloud/r/linuxserver/qbittorrent](https://xuanyuan.cloud/r/linuxserver/qbittorrent)

该镜像由 **LinuxServer.io 团队** 维护，具有以下特点：
- 持续更新，安全补丁及时
- 支持多架构（x86-64 / arm64）
- 提供非 root 用户运行支持（PUID/PGID）
- 内置配置持久化机制，方便数据和配置保留


## 2、下载 qBittorrent 镜像

### 2.1 使用轩辕镜像拉取（推荐）
```bash
docker pull docker.xuanyuan.run/linuxserver/qbittorrent:latest
```

### 2.2 拉取后改名（可选）
```bash
docker pull docker.xuanyuan.run/linuxserver/qbittorrent:latest \
&& docker tag docker.xuanyuan.run/linuxserver/qbittorrent:latest linuxserver/qbittorrent:latest \
&& docker rmi docker.xuanyuan.run/linuxserver/qbittorrent:latest
```

**说明**：
- `docker tag` 把镜像改名为官方名称 `linuxserver/qbittorrent:latest`，后续命令更简洁
- `docker rmi` 删除临时标签，避免占用额外空间

### 2.3 官方直连方式
若网络能直接访问 Docker Hub，可以执行：
```bash
docker pull lscr.io/linuxserver/qbittorrent:latest
```

### 2.4 查看镜像是否下载成功
```bash
docker images
```

输出类似：
```
REPOSITORY                 TAG       IMAGE ID       CREATED        SIZE
linuxserver/qbittorrent    latest    7d3c9b4a1a22   5 days ago     250MB
```


## 3、部署 qBittorrent
以下使用 `linuxserver/qbittorrent:latest` 镜像，提供三种部署方式。

### 3.1 快速部署（适合测试）
```bash
docker run -d \
  --name=qbittorrent-test \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /tmp/qbt/config:/config \
  -v /tmp/qbt/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/qbittorrent:latest
```

👉 浏览器访问：`http://服务器IP:8080`  
首次启动时，容器日志会输出一个临时密码，请使用该密码登录 WebUI，然后在 **设置 → Web UI** 中修改用户名和密码。

### 3.2 挂载目录（推荐生产环境）
适合长期使用，确保配置和下载内容持久化。

第一步：创建目录
```bash
mkdir -p /data/qbt/{config,downloads}
```

第二步：启动容器
```bash
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /data/qbt/config:/config \
  -v /data/qbt/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/qbittorrent:latest
```

**目录映射说明**：

| 宿主机目录         | 容器内目录 | 作用               |
|--------------------|------------|--------------------|
| /data/qbt/config   | /config    | 保存配置文件       |
| /data/qbt/downloads| /downloads | 保存下载内容       |

### 3.3 docker-compose 部署（企业级推荐）
在 `/data/qbt` 下创建 `docker-compose.yml`：
```yaml
version: '3.3'
services:
  qbittorrent:
    image: linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - WEBUI_PORT=8080
      - TORRENTING_PORT=6881
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```

启动服务：
```bash
docker compose up -d
```

管理命令：
- 停止：`docker compose down`
- 查看状态：`docker compose ps`


## 4、验证部署结果

### 访问 WebUI
在浏览器打开 `http://服务器IP:8080`，使用容器日志中的临时密码登录（`docker logs qbittorrent` 查看）。

### 查看容器状态
```bash
docker ps
```
`STATUS` 为 `Up` 表示运行正常。

### 查看日志
```bash
docker logs -f qbittorrent
```
可以看到 qBittorrent 启动信息和 WebUI 初始密码。


## 5、常见问题

### 5.1 登录密码在哪里？
首次启动时，默认密码会打印到容器日志中：
```bash
docker logs qbittorrent | grep -i password
```
登录后请立即修改密码。

### 5.2 下载访问表现慢？
- 检查是否开放了 6881 TCP/UDP 端口
- 确认公网 IP 防火墙和云服务器安全组已放行端口
- 在设置里启用 DHT / PeX / UPnP

### 5.3 WEBUI_PORT 改为其他端口？
需同时修改 `-p` 和环境变量：
```bash
docker run -d \
  -e WEBUI_PORT=8123 \
  -p 8123:8123 \
  ...
```

### 5.4 下载目录权限问题？
容器使用 PUID 和 PGID 映射宿主机用户，请执行：
```bash
id your_user
```
输出示例：
```
uid=1000(your_user) gid=1000(your_user)
```
然后将 `PUID=1000`，`PGID=1000` 设置到容器。

### 5.5 如何更新？
- docker-compose 更新：
  ```bash
  docker compose pull
  docker compose up -d
  ```
- docker run 更新：
  ```bash
  docker pull linuxserver/qbittorrent:latest
  docker stop qbittorrent
  docker rm qbittorrent
  # 重新运行容器，配置会保留
  ```


## 结尾
至此，你已经掌握了 基于 Docker 部署 qBittorrent 的完整流程：
- 从镜像拉取到快速部署
- 生产环境持久化配置
- docker-compose 企业级管理
- 常见问题排查与优化

推荐顺序： 初学者先使用「快速部署」测试，熟悉 WebUI → 再迁移到「挂载目录」方案 → 最后使用 docker-compose 管理生产环境。

未来，你还可以基于此进一步配置 反向代理（Nginx / Traefik），为 WebUI 添加 HTTPS 访问，甚至与 NAS / Plex / Jellyfin 联动，实现家庭媒体中心的自动下载与播放。


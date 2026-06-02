<!-- xuanyuan-docker-images-zh
image: linuxserver/qbittorrent
source: https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent
canonical: https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent" title="linuxserver/qbittorrent Docker 镜像中文简介、标签列表与拉取命令">linuxserver/qbittorrent — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent" title="linuxserver/qbittorrent Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent</a></p>

# LinuxServer.io qBittorrent Docker容器介绍


## LinuxServer.io团队简介  
LinuxServer.io团队专注于提供高质量Docker容器，其容器具有以下特点：  
- 定期及时的应用更新  
- 简单的用户权限映射（通过PGID、PUID设置）  
- 基于s6 overlay的自定义基础镜像  
- 每周系统更新，统一基础层以减少存储空间占用、 downtime和带宽消耗  
- 定期安全更新  


## qBittorrent容器说明  
本容器基于[qBittorrent]([])开源项目构建。qBittorrent是µTorrent的开源替代方案，基于Qt工具包和libtorrent-rasterbar库开发，支持跨平台使用。  


## 支持的架构  
容器通过Docker manifest实现多平台支持，拉取`lscr.io/linuxserver/qbittorrent:latest`即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅ 支持   | amd64-\<版本标签\>     |  
| arm64      | ✅ 支持   | arm64v8-\<版本标签\>   |  


## 版本标签  
容器提供以下版本标签，按需选择：  

| 标签          | 支持状态 | 说明                     |  
|---------------|----------|--------------------------|  
| latest        | ✅ 支持   | qBittorrent稳定版        |  
| libtorrentv1  | ✅ 支持   | 基于libtorrent v1的静态构建 |  


## 应用设置  

### 初始访问与密码配置  
Web管理界面地址为 `<你的IP>:8080`。首次启动时，`admin`用户的临时密码会输出到容器日志中。**必须在Web界面的设置中修改用户名/密码**，否则每次容器重启都会生成新密码。  


### 旧内核兼容问题  
若运行于3.x版本内核，可能遇到[兼容性问题]([])，可参考[解决方法]([])。  


### 修改WebUI端口（WEBUI_PORT）  
因CSRF和端口映射限制，修改Web界面端口时需同时调整端口映射和环境变量：  
- 例如改为8123端口：  
  - 端口映射：`-p 8123:8123`  
  - 环境变量：`-e WEBUI_PORT=8123`  


### 修改BT连接端口（TORRENTING_PORT）  
BT客户端需开放端口以提高连接效率。修改端口时需同时映射TCP/UDP端口并设置环境变量：  
- 例如改为6887端口：  
  - 端口映射：`-p 6887:6887`（TCP）、`-p 6887:6887/udp`（UDP）  
  - 环境变量：`-e TORRENTING_PORT=6887`  


## 高级配置  

### 只读模式运行  
容器支持只读文件系统，详情参考[官方文档]([])。  


### 非root用户运行  
容器支持非root用户权限，详情参考[官方文档]([])。  


## 使用方法  

### 通过docker-compose部署（推荐）  
创建`docker-compose.yml`文件，内容如下：  

```yaml
---
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000          # 用户ID（参考下文“用户/组ID”）
      - PGID=1000          # 组ID（参考下文“用户/组ID”）
      - TZ=Etc/UTC         # 时区（如Asia/Shanghai）
      - WEBUI_PORT=8080    # Web界面端口
      - TORRENTING_PORT=6881  # BT连接端口
    volumes:
      - /path/to/qbittorrent/appdata:/config  # 配置文件目录（必填）
      - /path/to/downloads:/downloads         # 下载文件目录（可选）
    ports:
      - 8080:8080          # Web界面端口映射
      - 6881:6881          # BT TCP端口映射
      - 6881:6881/udp      # BT UDP端口映射
    restart: unless-stopped  # 自动重启策略
```  

启动容器：  
```bash
docker-compose up -d
```  


### 通过docker run部署  
直接执行命令：  

```bash
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /path/to/qbittorrent/appdata:/config \
  -v /path/to/downloads:/downloads `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/qbittorrent:latest
```  


## 参数说明  

| 参数                  | 作用说明                                                                 |  
|-----------------------|--------------------------------------------------------------------------|  
| `-p 8080:8080`        | Web管理界面端口映射                                                     |  
| `-p 6881:6881`        | BT TCP连接端口映射                                                      |  
| `-p 6881:6881/udp`    | BT UDP连接端口映射                                                      |  
| `-e PUID=1000`        | 用户ID，解决权限问题（参考下文“用户/组ID”）                             |  
| `-e PGID=1000`        | 组ID，解决权限问题（参考下文“用户/组ID”）                               |  
| `-e TZ=Etc/UTC`       | 时区设置，可参考[时区列表]() |  
| `-e WEBUI_PORT=8080`  | Web界面端口（需与端口映射一致）                                         |  
| `-e TORRENTING_PORT=6881` | BT连接端口（需与端口映射一致）                                       |  
| `-v /config`          | 配置文件存储目录（必填）                                                |  
| `-v /downloads`       | 下载文件存储目录（可选）                                                |  
| `--read-only=true`    | 启用只读文件系统（需参考官方文档配置）                                  |  
| `--user=1000:1000`    | 以非root用户运行（需参考官方文档配置）                                  |  


## 环境变量与文件配置  
可通过`FILE__`前缀从文件读取环境变量，例如：  
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```  
此时`MYVAR`的值将从`/run/secrets/mysecretvariable`文件中读取。  


## 用户/组ID（PUID/PGID）  
使用卷挂载（`-v`）时，需确保宿主目录与容器内用户权限一致，避免权限问题。通过`PUID`（用户ID）和`PGID`（组ID）指定容器内用户：  

1. 在宿主终端执行 `id 你的用户名`，获取类似输出：  
   ```text
   uid=1000(你的用户名) gid=1000(你的用户名) groups=1000(你的用户名)
   ```  
2. 将`PUID=1000`和`PGID=1000`填入环境变量即可。  


## Docker Mods  
容器支持通过[Docker Mods]([])扩展功能，可访问以下链接查看可用Mods：  
- [qbittorrent专用Mods]([])  
- [通用Mods]([])  


## 支持与调试  

### 常用命令  
- 进入容器Shell：  
  ```bash
  docker exec -it qbittorrent /bin/bash
  ```  
- 实时查看日志：  
  ```bash
  docker logs -f qbittorrent
  ```  
- 查看容器版本：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' qbittorrent
  ```  
- 查看镜像版本：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/qbittorrent:latest
  ```  


## 更新容器  

### 通过docker-compose更新  
- 拉取最新镜像：  
  ```bash
  docker-compose pull qbittorrent  # 更新单个容器
  # 或 docker-compose pull  # 更新所有容器
  ```  
- 重启容器：  
  ```bash
  docker-compose up -d qbittorrent  # 重启单个容器
  # 或 docker-compose up -d  # 重启所有容器
  ```  
- 清理旧镜像：  
  ```bash
  docker image prune
  ```  


### 通过docker run更新  
- 拉取最新镜像：  
  ```bash
  docker pull lscr.io/linuxserver/qbittorrent:latest
  ```  
- 停止并删除旧容器：  
  ```bash
  docker stop qbittorrent && docker rm qbittorrent
  ```  
- 用原参数重新创建容器（配置文件在`/config`目录中，会自动保留）。  


## 本地构建  
如需自定义镜像，可按以下步骤构建：  

```bash
# 克隆仓库
git clone [] docker-qbittorrent

# 构建镜像（x86_64）
docker build --no-cache --pull -t lscr.io/linuxserver/qbittorrent:latest .

# 构建ARM架构镜像（需先注册qemu-static）
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
docker build -f Dockerfile.aarch64 --no-cache --pull -t lscr.io/linuxserver/qbittorrent:latest .
```  


## 版本历史  
- **17.07.24**：恢复qbittorrent-cli（已支持openssl 3）。  
- **25.05.24**：移除qbittorrent-cli（依赖已停止维护的openssl 1.1）。  
- **14.02.24**：仅在设置`TORRENTING_PORT`时覆盖BT端口。  
- **14.02.24**：新增BT端口支持。  
- **31.01.24**：移除过时兼容包。  
- **25.12.23**：仅拉取qbittorrent-cli稳定版本。  
- **07.10.23**：从LinuxServer仓库安装unrar。  
- **10.08.23**：更新unrar至6.2.10。  
- **17.06.23**：停止支持armhf架构。  
- **10.06.23**：更新unrar至6.2.8。  
- **23.02.23**：添加qt6-qtbase-sqlite以支持SQLite恢复文件数据库。  
- **29.11.22**：添加openssl1.1-compat支持qbittorrent-cli。  
- **31.10.22**：新增libtorrentv1分支。  
- **31.08.22**：基于Alpine Edge重构，跟踪最新版本。  
- **12.08.22**：更新unrar至6.2.10。  
- **16.06.23**：停止支持armhf架构。  
- **01.08.17**：初始发布。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent" title="linuxserver/qbittorrent Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/qbittorrent</a></p>

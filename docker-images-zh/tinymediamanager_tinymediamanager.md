---
image: tinymediamanager/tinymediamanager
description: "官方tinyMediaManager Docker镜像是专为媒体文件管理打造的容器化工具，可高效整理电影、电视剧等媒体资源，自动从网络获取元数据、海报、剧情简介等信息，通过Docker容器化部署简化安装与配置流程，具备跨平台兼容性，能在不同操作系统环境中稳定运行，确保媒体管理工具的运行环境一致性，适用于个人媒体库或小型服务器的媒体资源管理需求。"
source: https://xuanyuan.cloud/zh/r/tinymediamanager/tinymediamanager
canonical: https://xuanyuan.cloud/zh/r/tinymediamanager/tinymediamanager
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tinymediamanager/tinymediamanager" title="tinymediamanager/tinymediamanager Docker 镜像中文简介、标签列表与拉取命令">tinymediamanager/tinymediamanager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# tinyMediaManager Docker 镜像使用指南


## 概述  
tinyMediaManager 提供基于 Debian Buster 的实验性官方 Docker 镜像（旨在确保最大兼容性）。该镜像包含所有必要组件（如最新版 libmediainfo、FFmpeg 等），可提供最佳使用体验，适用于各类 x86_64 设备。通过此镜像，你可部署完整功能的 tinyMediaManager 实例，并通过 web/VNC 进行远程访问。


## 使用说明  

### 1. 端口映射  
- 将本地任意端口映射到容器的 `4000` 端口，用于 web 访问（基于 noVNC）。  


### 2. 数据卷映射  
- **核心数据卷**：需将本地文件夹映射到容器的 `/data` 目录，用于存储 tinyMediaManager 的所有本地数据（如 `data`、`logs`、`cache`、`backups` 等）。若不映射此目录，升级镜像时所有配置和数据会丢失。  
- **媒体文件卷**：需将本地媒体文件所在目录映射到容器的 `/media/xxx` 目录（`xxx` 可自定义，需与本地媒体类型对应）。例如：  
  - 本地电影目录 `/mnt/movies` → 容器内 `/media/movies`  
  - 本地剧集目录 `/mnt/tvshows` → 容器内 `/media/tvshows`  
- **自定义刮削器**：若需添加自定义元数据刮削器（scrapers），需将存放自定义插件的本地文件夹映射到容器的 `/app/addons` 目录。  
- **HTTP API 端口**：若使用 v4.3 及以上版本并需启用 HTTP API，需额外映射 HTTP API 端口。  
- **自定义启动参数**：若需配置自定义启动参数，需映射本地的 `/app/launcher-extra.yml` 文件（配置方法见 [官方文档]([])）。  


## 示例运行命令  
通过以下 Docker 命令快速启动容器：  

```bash
docker run \
    --name=tinymediamanager \
    -p 4000:4000 \
    -v </path/to/local/data/>:/data \
    -v </path/to/movies>:/media/movies \
    -v </path/to/tvshows>:/media/tvshows \
    -v </path/to/addons/>:/app/addons \
    tinymediamanager/tinymediamanager:latest
```  

启动后，通过 `[] 访问 tinyMediaManager。  


## 示例 Compose 文件  
若使用 Docker Compose 管理，可参考以下配置（适用于 `version: "2.1"`）：  

```yaml
---
version: "2.1"
services:
  tinymediamanager:
    image: tinymediamanager/tinymediamanager:latest
    container_name: tinymediamanager
    environment:
      - USER_ID=1000          # 运行用户ID（需与本地用户匹配，见“权限设置”）
      - GROUP_ID=1000         # 运行组ID（同上）
      - ALLOW_DIRECT_VNC=true # 允许直接VNC连接
      - LC_ALL=en_US.UTF-8    # 强制UTF-8编码
      - LANG=en_US.UTF-8      # 强制UTF-8编码
      - PASSWORD=<password>   # 远程访问密码
    volumes:
      - </path/to/local/data/>:/data         # 核心数据卷（必须映射）
      - </path/to/movies>:/media/movies      # 电影文件卷
      - </path/to/tvshows>:/media/tvshows    # 剧集文件卷
      - </path/to/addons/>:/app/addons       # 自定义刮削器卷（如有）
    ports:
      - 5900:5900 # VNC直接访问端口（需开启 ALLOW_DIRECT_VNC=true）
      - 4000:4000 # Web界面访问端口
    restart: unless-stopped  # 容器退出后自动重启
```  


## 数据卷说明  
以下卷必须映射，否则可能导致功能异常或数据丢失：  
- `/data`：存储配置、日志、缓存等核心数据，**不映射会导致升级镜像时数据丢失**。  
- `/media/xxx`：媒体文件目录，需按实际媒体类型（如 movies、tvshows）映射。  
- `/app/addons`：存放自定义刮削器插件（如有）。  
- `/app/launcher-extra.yml`：自定义启动参数文件（如需），需添加以下内容以确保正常运行：  
  ```yaml
  ---
  javaHome: ""
  jvmOpts:
    - "-Dtmm.contentfolder=/data"
    - "-Dtmm.noupdate=true"
  env: [ ]
  ```  

**注意**：所有映射的本地卷需确保容器有读写权限。  


## 配置参数  
可通过环境变量调整容器配置，参数说明如下：  

| 变量名           | 描述                                                                 | 默认值  |
|------------------|----------------------------------------------------------------------|---------|
| USER_ID          | tinyMediaManager 运行用户的 UID（需与本地媒体文件所有者匹配，见“权限设置”） | 1000    |
| GROUP_ID         | tinyMediaManager 运行用户的 GID（同上）                                | 1000    |
| PASSWORD         | 远程访问（web/VNC）的密码                                             | 无      |
| LC_ALL / LANG    | 字符编码设置，建议设为 `en_US.UTF-8` 以避免中文乱码                    | 无      |
| TZ               | 时区设置（如 `Asia/Shanghai`）                                         | 无      |
| ALLOW_DIRECT_VNC | 是否允许通过 VNC 直接连接（需映射 5900 端口）                          | false   |  


## 权限设置  
使用数据卷（`-v` 参数）时，若本地用户 ID（UID）/组 ID（GID）与容器内默认用户不匹配，可能导致文件读写权限问题（如容器无法访问媒体文件）。解决方法：通过 `USER_ID` 和 `GROUP_ID` 环境变量指定容器运行用户的 UID/GID，确保与本地媒体文件所有者一致。  

### 获取本地用户 UID/GID  
在主机终端执行以下命令（将 `<username>` 替换为本地媒体文件所有者的用户名）：  
```bash
id <username>
```  
输出示例：  
```
uid=1000(myuser) gid=1000(myuser) groups=1000(myuser),...
```  
其中 `uid` 即为 USER_ID，`gid` 即为 GROUP_ID，填入 Compose 文件或 run 命令的环境变量即可。  


## 剪贴板使用  
由于浏览器安全限制，本地剪贴板无法直接同步到 tinyMediaManager 容器内。若需复制/粘贴内容，需通过 noVNC 的剪贴板功能：  
1. 打开 web 界面后，点击窗口左侧的 noVNC 控制面板（图标为齿轮）。  
2. 在控制面板中使用剪贴板功能，手动输入或粘贴内容进行同步。  


通过以上步骤，即可快速部署并使用 tinyMediaManager Docker 镜像，管理本地媒体文件。

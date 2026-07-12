---
image: inglebard/retroarch-web
description: "自托管的RetroArch网页播放器，供用户自行部署并通过网页使用RetroArch模拟器功能。"
source: https://xuanyuan.cloud/zh/r/inglebard/retroarch-web
canonical: https://xuanyuan.cloud/zh/r/inglebard/retroarch-web
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/inglebard/retroarch-web" title="inglebard/retroarch-web Docker 镜像中文简介、标签列表与拉取命令">inglebard/retroarch-web 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# inglebard/retroarch-web 镜像文档


## 镜像概述与主要用途

### 概述  
inglebard/retroarch-web 是一个自托管的 RetroArch 网页播放器镜像，基于 RetroArch 的 WebAssembly 版本构建，旨在提供便捷的复古游戏远程游玩体验。通过该镜像，用户可在个人服务器或私有环境中部署 RetroArch 网页版服务，实现通过浏览器直接访问并游玩复古游戏。

### 主要用途  
- 自托管复古游戏网页播放服务  
- 远程访问与游玩本地复古游戏库  
- 无需客户端安装，通过浏览器即可体验 RetroArch 功能  


## 核心功能与特性  

- **自托管部署**：无需依赖第三方服务，可在个人服务器、NAS 或本地环境中独立运行  
- **网页化访问**：基于浏览器的访问方式，支持多设备（电脑、手机、平板）访问  
- **远程游戏支持**：实现复古游戏的远程加载与游玩，支持主流复古游戏平台（如 NES、SNES、MD 等）  
- **轻量高效**：基于 nginx 作为 Web 服务器，资源占用低，部署简单  
- **开源构建**：基于 RetroArch 官方 WebAssembly 包（libretro/RetroArch）构建，兼容性与稳定性有保障  


## 使用场景与适用范围  

### 适用场景  
- **个人复古游戏服务器**：玩家在私有服务器上托管游戏 ROM，通过网页安全访问个人游戏库，保障数据隐私  
- **家庭娱乐中心**：家庭内多设备（如电视、手机、电脑）通过局域网或广域网访问同一游戏服务，实现跨设备游戏体验  
- **远程游戏需求**：外出时通过浏览器远程连接家中服务器，访问并游玩本地存储的复古游戏  

### 适用人群  
- 复古游戏爱好者  
- 需自托管游戏服务的个人用户  
- 追求跨设备、免客户端游戏体验的玩家  


## 详细使用方法与配置说明  

### 基本运行命令  
通过 `docker run` 命令可快速启动镜像，基本语法如下：  

```bash
docker run --rm -it -p 8080:80 docker.xuanyuan.run/inglebard/retroarch-web
```  

#### 参数说明  
- `--rm`：容器停止后自动删除容器文件  
- `-it`：以交互模式运行，支持终端输入  
- `-p 8080:80`：端口映射，将容器内的 80 端口（nginx 默认端口）映射到主机的 8080 端口（可替换为其他主机端口，如 80、8888 等）  


### 游戏文件夹挂载  
为使容器能够访问本地复古游戏 ROM，需通过卷（Volume）挂载本地游戏目录至容器内。假设本地游戏 ROM 存储在 `/path/to/local/roms`，可通过 `-v` 参数挂载：  

```bash
docker run --rm -it -p 8080:80 -v /path/to/local/roms:/usr/share/nginx/html/roms docker.xuanyuan.run/inglebard/retroarch-web
```  

> 说明：容器内 nginx 的网页根目录通常为 `/usr/share/nginx/html`（基于 nginx 官方镜像默认配置），建议将本地游戏目录挂载至该路径下的子目录（如 `roms`），以便通过网页访问 ROM 文件。


### docker-compose 配置示例  
对于长期部署，推荐使用 `docker-compose` 管理容器。创建 `docker-compose.yml` 文件如下：  

```yaml
version: '3'
services:
  retroarch-web:
    image: docker.xuanyuan.run/inglebard/retroarch-web
    container_name: retroarch-web
    ports:
      - "8080:80"  # 主机端口:容器端口（容器端口固定为80）
    volumes:
      - /path/to/local/roms:/usr/share/nginx/html/roms  # 挂载本地游戏目录
    restart: unless-stopped  # 容器退出时自动重启（除非手动停止）
```  

启动服务：  
```bash
docker-compose up -d
```  


## 技术信息  

### 软件栈  
- **Web 服务器**：nginx（提供网页服务与静态资源托管）  


### 端口说明  
- 容器暴露端口：`80`（nginx 默认 HTTP 端口，不可修改）  
- 主机映射端口：需通过 `-p` 参数自定义（如 `8080:80`、`80:80` 等）  


### 数据卷  
- **游戏目录挂载**：必须挂载本地游戏 ROM 目录至容器内，否则无法加载游戏。建议挂载路径：`/usr/share/nginx/html/roms`（可根据实际网页目录调整）  


## 致谢  
本镜像基于以下项目构建：  
- [libretro/RetroArch](https://github.com/libretro/RetroArch/tree/master/pkg/emscripten)（RetroArch 的 WebAssembly 包）  


## 相关链接  
- [GitHub 仓库](https://github.com/Inglebard/dockerfiles/tree/retroarch-web/)  
- [Docker Hub 镜像页](https://hub.docker.com/r/inglebard/retroarch-web/)

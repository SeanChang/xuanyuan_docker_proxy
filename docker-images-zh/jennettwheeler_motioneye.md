---
image: jennettwheeler/motioneye
description: "基于LinuxServer架构的Motioneye容器，为motion守护进程提供Web前端，支持用户权限映射、时区设置等功能，用于监控系统的Web管理与配置。"
source: https://xuanyuan.cloud/zh/r/jennettwheeler/motioneye
canonical: https://xuanyuan.cloud/zh/r/jennettwheeler/motioneye
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jennettwheeler/motioneye" title="jennettwheeler/motioneye Docker 镜像中文简介、标签列表与拉取命令">jennettwheeler/motioneye 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# jennettwheeler/motioneye

[Motioneye](https://github.com/ccrisan/motioneye) 是motion守护进程的Web前端，本镜像基于LinuxServer架构构建，提供便捷的监控系统Web管理能力。


## 镜像概述
本镜像采用LinuxServer生态系统的架构设计：  
- 支持用户ID（PUID）和组ID（PGID）映射，避免主机与容器间的权限冲突  
- 基于含s6 overlay的自定义基础镜像  
- 使用每周更新的基础OS，与LinuxServer.io生态共享通用层，减少空间占用、 downtime及带宽消耗  
- 仅在Motioneye发布新版本时更新镜像  


## 核心功能
1. 灵活的用户权限映射（PUID/PGID）  
2. 基于s6 overlay的稳定运行环境  
3. 多版本标签支持（latest、0.42、0.41等）  
4. 兼容Docker Secrets的环境变量配置  


## 使用场景
适用于需要通过Web界面管理motion监控系统的场景，如家庭监控、小型办公场所监控、个人项目中的视频流管理等。


## 配置说明

### 版本标签
| 标签 | 描述 |
| :----: | --- |
| latest | 最新稳定版Motioneye |
| 0.42 | 最新稳定版Motioneye |
| 0.41 | 上一稳定版Motioneye |


### Docker部署示例
```bash
docker create \
  --name=motioneye \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e UMASK_SET=022 `#可选` \
  -p 8765:8765 \
  -p 8081-8099:8081-8099 `#可选，用于视频流` \
  -v /path/to/your/config:/config \
  --restart unless-stopped \
  jennettwheeler/motioneye
```


### Docker Compose示例
```yaml
---
version: "2"
services:
  motioneye:
    image: docker.xuanyuan.run/jennettwheeler/motioneye
    container_name: motioneye
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - UMASK_SET=022 #可选
    volumes:
      - /path/to/your/config:/config
    ports:
      - 8765:8765
      - 8081-8085:8081-8085 #可选
    restart: unless-stopped
```


### 参数说明
| 参数 | 功能 |
| :----: | --- |
| `-p 8765` | Motioneye Web界面端口 |
| `-p 8081-xxxx` | 视频流端口（用于监控视频输出） |
| `-e PUID=1000` | 用户ID，解决权限问题（可通过`id username`获取） |
| `-e PGID=1000` | 组ID，解决权限问题（可通过`id username`获取） |
| `-e TZ=Asia/Shanghai` | 设置时区（如亚洲/上海） |
| `-e UMASK_SET=022` | 控制文件/目录权限 |
| `-v /config` | 挂载配置、媒体及日志目录 |


### 应用设置
访问Web界面：`http://你的IP:8765`，更多信息请参考[Motioneye官方文档](https://github.com/ccrisan/motioneye)。


### 更新说明
1. 拉取最新镜像：`docker pull docker.xuanyuan.run/jennettwheeler/motioneye`  
2. 停止旧容器：`docker stop motioneye`  
3. 删除旧容器：`docker rm motioneye`  
4. 用原参数重建容器：`docker create ...`（配置目录挂载正确则设置会保留）  
5. 启动新容器：`docker start motioneye`  
6. 清理悬空镜像：`docker image prune`  

（Docker Compose用户可使用`docker-compose pull` + `docker-compose up -d`更新）

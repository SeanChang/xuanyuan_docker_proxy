---
image: linuxserver/speedtest-tracker
description: "linuxserver/speedtest-tracker 是一款基于 Docker 的网络速度测试跟踪工具，支持通过 Speedtest.net 自动定期执行下载/上传速度、延迟等测试，实时记录并可视化历史数据。提供直观的 Web 管理界面，可自定义测试频率、选择测试服务器，并支持数据持久化存储。镜像轻量易部署，兼容多种系统，适合个人或企业监控网络性能，快速定位网络波动问题，助力优化网络环境。"
source: https://xuanyuan.cloud/zh/r/linuxserver/speedtest-tracker
canonical: https://xuanyuan.cloud/zh/r/linuxserver/speedtest-tracker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/speedtest-tracker" title="linuxserver/speedtest-tracker Docker 镜像中文简介、标签列表与拉取命令">linuxserver/speedtest-tracker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io docker-speedtest-tracker 容器介绍


## LinuxServer.io 团队简介

[LinuxServer.io]  团队致力于提供高质量容器，其容器具有以下特点：  
- 定期且及时的应用更新  
- 便捷的用户映射（支持 PGID、PUID 设置）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周更新基础操作系统，通过共享通用层减少存储空间占用、停机时间和带宽消耗  
- 定期安全更新  


## 关于 speedtest-tracker 容器

[speedtest-tracker]  是一款自托管的网络性能跟踪应用，可通过 Ookla 的 Speedtest 服务定期执行网速测试并记录结果。LinuxServer.io 团队将其打包为容器，方便用户快速部署和使用。


## 支持的架构

该容器通过 Docker 清单支持多平台，拉取 `lscr.io/linuxserver/speedtest-tracker:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持情况 | 标签格式               |
|------------|----------|------------------------|
| x86-64     | ✅        | amd64-\<version tag\>   |
| arm64      | ✅        | arm64v8-\<version tag\> |


## 应用设置

1. **访问 Web 界面**：部署后通过 `<你的IP>:80` 访问，默认登录凭据为 `[邮箱已删除] / password`。  
2. **详细文档**：更多配置可参考 [官方文档] 。  


## 使用方法

可通过 `docker-compose`（推荐）或 `docker run` 命令部署容器。以下为具体配置示例：  


### docker-compose 配置

创建 `docker-compose.yml` 文件，内容如下：  

```yaml
---
services:
  speedtest-tracker:
    image: docker.xuanyuan.run/linuxserver/speedtest-tracker:latest
    container_name: speedtest-tracker
    environment:
      - PUID=1000               # 用户ID（详见下方说明）
      - PGID=1000               # 组ID（详见下方说明）
      - TZ=Etc/UTC              # 时区（如 Asia/Shanghai）
      - APP_KEY=                # 数据加密密钥（必填，生成方法见官方文档）
      - APP_URL=                # 应用访问地址（如 []      - DB_CONNECTION=sqlite    # 数据库类型（sqlite/pgsql/mysql）
      - SPEEDTEST_SCHEDULE=     # 测试计划（Cron格式，如 0 */6 * * * 每6小时一次）
      - SPEEDTEST_SERVERS=      # 测试服务器ID（逗号分隔，获取方法见下方说明）
      - DB_HOST=                # 数据库主机（仅pgsql/mysql需填，可选）
      - DB_PORT=                # 数据库端口（仅pgsql/mysql需填，可选）
      - DB_DATABASE=            # 数据库名（仅pgsql/mysql需填，可选）
      - DB_USERNAME=            # 数据库用户名（仅pgsql/mysql需填，可选）
      - DB_PASSWORD=            # 数据库密码（仅pgsql/mysql需填，可选）
      - DISPLAY_TIMEZONE=Etc/UTC # 界面显示时区（可选）
      - PRUNE_RESULTS_OLDER_THAN=0 # 结果保留天数（0为不删除，可选）
    volumes:
      - /path/to/speedtest-tracker/data:/config  # 配置和数据库存储路径
    ports:
      - 80:80                   # Web界面端口映射
    restart: unless-stopped     # 重启策略
```

启动容器：  
```bash
docker-compose up -d
```


### docker run 命令

直接通过命令行部署：  

```bash
docker run -d \
  --name=speedtest-tracker \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e APP_KEY= \
  -e APP_URL= \
  -e DB_CONNECTION=sqlite \
  -e SPEEDTEST_SCHEDULE= \
  -e SPEEDTEST_SERVERS= \
  -e DB_HOST= `#可选` \
  -e DB_PORT= `#可选` \
  -e DB_DATABASE= `#可选` \
  -e DB_USERNAME= `#可选` \
  -e DB_PASSWORD= `#可选` \
  -e DISPLAY_TIMEZONE=Etc/UTC `#可选` \
  -e PRUNE_RESULTS_OLDER_THAN=0 `#可选` \
  -p 80:80 \
  -v /path/to/speedtest-tracker/data:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/speedtest-tracker:latest
```


## 参数说明

| 参数                          | 作用说明                                                                 |
|-------------------------------|--------------------------------------------------------------------------|
| `-p 80:80`                    | Web 界面端口映射（主机端口:容器端口）                                    |
| `-e PUID=1000`                | 用户ID，用于权限映射（通过 `id 用户名` 命令获取）                        |
| `-e PGID=1000`                | 组ID，同上                                                               |
| `-e TZ=Etc/UTC`               | 容器时区，如 `Asia/Shanghai` 表示上海时区                                |
| `-e APP_KEY=`                 | 数据加密密钥，需按 [官方文档]  生成  |
| `-e APP_URL=`                 | 应用访问地址（如 `[] 或域名）                      |
| `-e DB_CONNECTION=sqlite`     | 数据库类型（支持 sqlite、pgsql、mysql）                                  |
| `-e SPEEDTEST_SCHEDULE=`      | 测试计划（Cron格式，如 `0 */6 * * *` 表示每6小时执行一次）               |
| `-e SPEEDTEST_SERVERS=`       | 测试服务器ID列表（逗号分隔，运行 `docker run -it --rm --entrypoint /bin/bash lscr.io/linuxserver/speedtest-tracker:latest list-servers` 获取附近服务器） |
| `-v /config`                  | 配置和数据库存储目录（sqlite数据库文件位于此）                           |


## 环境变量与文件（Docker Secrets）

可通过文件传递环境变量，格式为 `-e FILE__变量名=/路径/文件名`，例如：  
```bash
-e FILE__APP_KEY=/run/secrets/app_key  # 从文件 /run/secrets/app_key 读取 APP_KEY 值
```


## 用户/组权限（PUID/PGID）

容器通过 PUID 和 PGID 映射主机用户权限，避免权限问题。通过 `id 用户名` 命令获取当前用户的 UID 和 GID，例如：  
```bash
id your_username  # 输出类似 uid=1000(your_username) gid=1000(your_username)
```


## Docker Mods

可通过 [Docker Mods]  扩展容器功能，支持该容器的 Mods 可通过官方链接查看。


## 支持与维护

### 常用操作
- **进入容器命令行**：  
  ```bash
  docker exec -it speedtest-tracker /bin/bash
  ```
- **实时查看日志**：  
  ```bash
  docker logs -f speedtest-tracker
  ```
- **查看容器版本**：  
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' speedtest-tracker
  ```


### 更新容器

#### 通过 Docker Compose
```bash
# 更新镜像
docker-compose pull speedtest-tracker
# 重启容器
docker-compose up -d speedtest-tracker
# 清理旧镜像
docker image prune
```

#### 通过 Docker Run
```bash
# 更新镜像
docker pull docker.xuanyuan.run/linuxserver/speedtest-tracker:latest
# 停止并删除旧容器
docker stop speedtest-tracker && docker rm speedtest-tracker
# 重新创建容器（保留 /config 目录则配置不会丢失）
docker run -d [原参数...] lscr.io/linuxserver/speedtest-tracker:latest
```


## 本地构建

如需自定义容器，可本地构建：  
```bash
git clone [] docker-speedtest-tracker
docker build --no-cache --pull -t lscr.io/linuxserver/speedtest-tracker:latest .
```

构建 ARM 架构镜像（需先安装 qemu-static）：  
```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
docker build -f Dockerfile.aarch64 --no-cache --pull -t lscr.io/linuxserver/speedtest-tracker:latest .
```


## 版本历史
- **05.07.25**：基于 Alpine 3.22 重构  
- **20.12.24**：基于 Alpine 3.21 重构  
- **07.06.24**：缓存 Filament 组件，新增 APP_KEY 为必填参数  
- **27.05.24**：现有用户需更新 nginx 配置以避免 http2 弃用警告  
- **24.05.24**：基于 Alpine 3.20 重构  
- **16.04.24**：基于 Alpine 3.19 重构，升级至 PHP 8.3  
- **10.02.24**：初始发布  


如需更多帮助，可访问 LinuxServer.io 官方社区：[Blog] 、[]()、[论坛] 。

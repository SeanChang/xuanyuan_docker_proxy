---
image: linuxserver/freshrss
description: "LinuxServer.io提供的Freshrss容器，用于RSS订阅与内容聚合阅读。"
source: https://xuanyuan.cloud/zh/r/linuxserver/freshrss
canonical: https://xuanyuan.cloud/zh/r/linuxserver/freshrss
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [linuxserver/freshrss — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/freshrss)

含镜像标签、拉取命令、部署文档与相关推荐。

[linuxserver/freshrss Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/linuxserver/freshrss)

# linuxserver/freshrss 镜像文档

## 镜像概述和主要用途

[Freshrss](https://freshrss.org/) 是一个免费、自托管的 RSS 订阅聚合器，允许用户集中管理多个 RSS 源。本镜像由 [LinuxServer.io](https://linuxserver.io) 团队提供容器化部署方案，具备定期更新、简化的用户权限管理和跨平台支持等特性，适用于需要自建 RSS 服务的个人或组织。


## 核心功能和特性

### LinuxServer.io 容器通用特性
- **定期应用更新**：确保应用始终为最新版本
- **简化用户映射**：通过 PUID/PGID 轻松配置容器内用户权限
- **自定义基础镜像**：集成 s6 overlay 进程管理系统
- **高效资源利用**：每周基础 OS 更新，跨生态共享通用层以减少存储空间、 downtime 和带宽消耗
- **定期安全更新**：持续修补基础系统和应用安全漏洞

### Freshrss 核心功能
- 自托管 RSS 订阅聚合，保护数据隐私
- 支持多用户和 feed 分类管理
- 响应式 Web 界面，适配桌面和移动设备
- 支持外部数据库（MySQL/MariaDB）和内置 SQLite
- 可扩展架构，支持通过扩展插件增强功能


## 支持的架构

本镜像通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/freshrss:latest` 即可自动匹配对应架构。也可通过标签指定特定架构：

| 架构 | 支持状态 | 标签格式 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |


## 使用场景和适用范围

- **个人用户**：自建 RSS 服务，聚合博客、新闻、技术站点等订阅源
- **小型团队**：共享 RSS 源集合，协同关注特定信息源
- **隐私敏感场景**：避免使用第三方 RSS 服务，完全掌控订阅数据
- **本地化数据管理**：将 RSS 数据存储在自有服务器，确保数据安全性和可访问性


## 应用设置

1. **初始配置**：容器启动后，通过 `http://服务器IP:端口` 访问 WebUI 安装向导，完成基础设置
   
2. **外部数据库配置**（可选）：
   - 在 MySQL/MariaDB 服务器中创建专用数据库和用户（非 root 账户）
   - 在 WebUI 安装向导中，数据库主机填写数据库服务器 IP 地址，输入创建的用户名和密码

3. **扩展安装**：
   - 将扩展文件放入宿主机的 `/path/to/freshrss/config/www/freshrss/extensions` 目录
   - 重启容器后扩展自动生效


## 使用方法

### Docker Compose（推荐）

```yaml
---
services:
  freshrss:
    image: lscr.io/linuxserver/freshrss:latest
    container_name: freshrss
    environment:
      - PUID=1000        # 用户ID（详见用户/组标识符）
      - PGID=1000        # 组ID（详见用户/组标识符）
      - TZ=Etc/UTC       # 时区（如 Asia/Shanghai）
    volumes:
      - /path/to/freshrss/config:/config  # 配置文件持久化目录
    ports:
      - 80:80            # WebUI 端口映射
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=freshrss \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 80:80 \
  -v /path/to/freshrss/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/freshrss:latest
```


## 参数说明

容器运行参数采用 `<外部>:<内部>` 格式映射，以下为必填和可选参数说明：

### 端口参数

| 参数 | 功能 |
| :----: | --- |
| `-p 80:80` | WebUI 访问端口，容器内固定为 80 |

### 环境变量

| 参数 | 功能 |
| :----: | --- |
| `-e PUID=1000` | 容器内运行用户的 UID，用于权限映射（必填） |
| `-e PGID=1000` | 容器内运行用户组的 GID，用于权限映射（必填） |
| `-e TZ=Etc/UTC` | 容器时区，如 `Asia/Shanghai`（必填） |
| `-e UMASK=022` | 进程权限掩码（可选，默认 022） |

### 卷参数

| 参数 | 功能 |
| :----: | --- |
| `-v /config` | 存储 Freshrss 配置文件、数据库和扩展的持久化目录（必填） |


## 环境变量从文件设置（Docker Secrets）

可通过 `FILE__` 前缀从文件加载环境变量，适用于敏感信息管理：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

上述命令会将 `/run/secrets/mysecretvariable` 文件内容作为 `MYVAR` 环境变量的值。


## Umask 设置

通过 `-e UMASK=022` 可自定义容器内服务的权限掩码。Umask 用于控制新创建文件的默认权限（权限 = 0777 - umask），默认值 022 对应权限为 0755（所有者读写执行，组和其他读执行）。


## 用户/组标识符

容器通过 PUID（用户ID）和 PGID（组ID）确保宿主机与容器间的权限一致性，避免卷挂载时的权限问题。

### 获取当前用户的 PUID/PGID：
```bash
id your_user
```

示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

> 确保宿主机上的 `/path/to/freshrss/config` 目录所有者为上述命令显示的 UID/GID。


## Docker Mods

LinuxServer.io 提供 [Docker Mods](https://github.com/linuxserver/docker-mods) 扩展容器功能，可通过动态标签查看本镜像支持的 Mods：

- [Freshrss 专用 Mods](https://mods.linuxserver.io/?mod=freshrss)
- [通用 Mods](https://mods.linuxserver.io/?mod=universal)


## 支持信息

### 容器内 Shell 访问
```bash
docker exec -it freshrss /bin/bash
```

### 实时日志监控
```bash
docker logs -f freshrss
```

### 版本信息查询
- 容器版本：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' freshrss
  ```
- 镜像版本：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/freshrss:latest
  ```


## 更新说明

本镜像为静态版本，需通过更新镜像并重建容器实现应用升级（配置文件通过卷持久化，不会丢失）。

### 通过 Docker Compose 更新
```bash
# 拉取最新镜像
docker-compose pull freshrss

# 重建并启动容器
docker-compose up -d freshrss

# 清理旧镜像（可选）
docker image prune
```

### 通过 Docker Run 更新
```bash
# 拉取最新镜像
docker pull lscr.io/linuxserver/freshrss:latest

# 停止并删除旧容器
docker stop freshrss && docker rm freshrss

# 用原参数重建容器（配置通过 /config 卷保留）
docker run -d \
  --name=freshrss \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 80:80 \
  -v /path/to/freshrss/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/freshrss:latest

# 清理旧镜像（可选）
docker image prune
```

### 镜像更新通知

推荐使用 [Diun](https://crazymax.dev/diun/) 监控镜像更新，不建议使用自动更新工具。


## 本地构建

如需自定义镜像，可通过以下步骤本地构建：

```bash
# 克隆仓库
git clone https://github.com/linuxserver/docker-freshrss.git
cd docker-freshrss

# 构建镜像
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/freshrss:latest .
```

### 多架构构建（需 qemu-static）
```bash
# 注册 qemu 模拟器
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset

# 构建特定架构（如 arm64v8）
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/freshrss:arm64v8-latest .
```


## 版本历史

- **2025年7月27日**：基础镜像更新至 Alpine 3.22
- **2024年6月19日**：基础镜像更新至 Alpine 3.20，修复 nginx http2 弃用警告
- **2024年4月10日**：添加 php-exif 模块以解决 fever api 问题
- **2024年3月6日**：优化默认 nginx 配置文件（现有用户需更新 site-confs/default.conf）
- **2023年12月23日**：基础镜像更新至 Alpine 3.19（PHP 8.3）
- **2023年5月25日**：基础镜像更新至 Alpine 3.18，移除 armhf 架构支持
- **2023年4月13日**：将 ssl.conf 引用移至 default.conf
- **2023年3月2日**：拆分 cron 任务至独立初始化步骤，修复 crontab 权限
- **2023年1月19日**：基础镜像更新至 Alpine 3.17（PHP 8.1）
- **2022年10月21日**：修复 cron 初始化逻辑，支持现有安装迁移至新应用路径
- **2022年8月20日**：基础镜像更新至 Alpine 3.15（PHP 8.0），重构 nginx 配置
- **2021年1月23日**：基础镜像更新至 Alpine 3.13
- **2020年6月1日**：基础镜像更新至 Alpine 3.12
- **2020年3月31日**：应用内部化，支持现有用户更新，允许自定义 crontab
- **2019年12月19日**：基础镜像更新至 Alpine 3.11
- **2019年6月28日**：基础镜像更新至 Alpine 3.10
- **2019年3月23日**：切换至新基础镜像，使用 arm32v7 标签
- **2019年2月22日**：基础镜像更新至 Alpine 3.9
- **2019年1月14日**：支持多架构构建
- **2018年9月5日**：基础镜像更新至 Alpine 3.8
- **2018年3月17日**：更新 nginx 配置以修复 api 访问问题
- **2018年1月8日**：基础镜像更新至 Alpine 3.7
- **2017年5月25日**：基础镜像更新至 Alpine 3.6
- **2017年2月23日**：基础镜像更新至 Alpine 3.5（nginx）
- **2016年12月19日**：添加版本层信息
- **2016年10月8日**：添加 SQLite 支持（独立运行模式）
- **2016年9月27日**：修复 cron 任务问题
- **2016年9月11日**：添加层标签至 README
- **2015年11月23日**：更新依赖至最新版本
- **2015年8月21日**：初始版本发布

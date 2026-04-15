# 1Panel Docker 容器化部署指南：轻松管理你的 Linux 服务器

![1Panel Docker 容器化部署指南：轻松管理你的 Linux 服务器](https://img.xuanyuan.dev/docker/blog/docker-1panel.png)

*分类: 1Panel,baota,面板,linux | 标签: linux,部署教程 | 发布时间: 2026-03-11 13:05:57*

> 使用 Docker 部署 1Panel，不仅能让环境隔离更彻底，还能让迁移和备份变得超级简单。
> 
> 本文会从环境准备、镜像拉取、到最终部署运行，一步步带你上车，还会用到国内加速源解决大家最头疼的网络问题。同时整合了 1Panel Docker 镜像的详细参数、版本说明及常见问题，让部署更顺畅、避坑更高效。
> 

今天给大家带来一篇 1Panel 开源 Linux 服务器运维管理面板 的 Docker 容器化部署教程。使用 Docker 部署 1Panel，不仅能让环境隔离更彻底，还能让迁移和备份变得超级简单。

本文会从环境准备、镜像拉取、到最终部署运行，一步步带你上车，还会用到国内加速源解决大家最头疼的网络问题。同时整合了 1Panel Docker 镜像的详细参数、版本说明及常见问题，让部署更顺畅、避坑更高效。

---

## 一、1Panel 是什么？

1Panel 是一个现代化的 Linux 服务器运维管理面板，本项目提供其 Docker 容器化部署方案，支持 V1 和 V2 两个主要版本，具备以下核心优势：

- 🚀 一键建站：WordPress、Discuz、Typecho 等
- 🐳 Docker 管理：可视化管理容器和镜像
- 💾 数据备份：支持定时备份到云端
- 🔐 安全管理：防火墙、SSL 证书一键配置
- ✅ 多架构支持：兼容 amd64, arm64, armv7, ppc64le, s390x 架构，适配鲲鹏、飞腾等国产服务器
- ✅ 自动化更新：镜像支持自动化构建和版本更新，提供中国版（CN）和国际版（Global）
- ✅ 云原生架构：采用 Supervisor 进程管理 + 动态配置，支持环境变量灵活配置（V1 需 v1.10.34-lts+）

而通过 Docker 部署，我们可以获得即开即用、易于迁移、环境隔离的额外 buff，同时规避宿主机环境冲突问题。

---

## 二、环境准备：一键安装 Docker (推荐方案)

在部署 1Panel 之前，我们需要先装好 Docker 环境。这里强烈推荐使用 轩辕镜像的一键安装脚本，它能自动处理好 Docker、Docker Compose 的安装，并配置好国内镜像源，一步到位！

一键脚本特点：

- ✅ 支持 13+ 种 Linux 发行版（包括 openEuler、Anolis、麒麟等国产系统）
- ✅ 完整支持 x86_64 和 ARM 架构（鲲鹏、飞腾都能用）
- ✅ 自动配置轩辕镜像源，拉取镜像快人一步，完美适配 1Panel 中国版镜像

执行命令：

在终端中输入以下命令并运行：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本运行后，耐心等待几分钟即可完成 Docker 环境部署。

---

## 三、镜像拉取：使用国内加速 + 镜像标签选择

由于 Docker Hub 在国内访问较慢，我们可以通过 轩辕镜像 来加速拉取（注：轩辕镜像作为 Docker Hub 的镜像缓存，配置好上述一键脚本后，拉取官方镜像时会自动走加速通道）。

1Panel 目前有 V1 和 V2 两个主要版本，重要提示：V1 和 V2 无法直接跨版本升级！如需从 V1 迁移到 V2，请参考官方迁移文档: https://1panel.cn/docs/v2/installation/v1_migrate/。

### 版本说明与镜像标签选择

| 版本 | 下载源 | 状态 | 推荐使用人群 | 镜像标签（轩辕加速前缀：docker.xuanyuan.run/moelin/1panel） |
| ---- | ---- | ---- | ---- | ---- |
| V1 | 国内/国际 | 维护中 | 已有 V1 部署、追求稳定性的用户 | 国内版：v1.10.22（具体版本）、v1（浮动标签，最新V1）；国际版：global-v1.10.22、global-v1 |
| V2 | 国内 | 最新版 | 新用户首次部署、需要最新功能的用户 | v2.0.6（具体版本）、v2（浮动标签）、latest（全局最新，指向V2） |

### 标签选择建议

- 生产环境：使用具体版本号（如 v1.10.22、v2.0.6），避免版本自动更新导致异常
- 测试环境：使用浮动标签（如 v1、v2），方便快速获取对应版本的最新更新
- 追求最新：使用 latest（目前指向 V2 版本）

### 具体拉取命令

#### 拉取 V2 版本 (推荐新用户)

V2 是最新版本，功能更强，架构更优，支持环境变量动态配置、数据目录映射，首次启动自动配置，无需手动初始化：

```bash
docker pull docker.xuanyuan.run/moelin/1panel:v2
```

#### 拉取 V1 版本 (老用户维护)

V1 版本稳定，适合已有 V1 部署的用户，注意：v1.10.34-lts 及以后版本才支持环境变量配置：

```bash
docker pull docker.xuanyuan.run/moelin/1panel:v1
```

#### 拉取国际版 (需外网环境)

```bash
docker pull docker.xuanyuan.run/moelin/1panel:global-v1
```

---

## 四、开始部署：V2 版本 (新用户首选)

我们先从最新的 V2 版本开始。这里提供 Docker 命令直接运行 和 Docker Compose 两种方式，大家可以任选其一。V2 版本支持通过环境变量灵活配置，首次启动若未设置密码，会自动生成随机密码（可通过日志查看）。

### 方式一：使用 docker run 命令 (快速上手)

复制以下命令，你可以根据需要修改环境变量（如端口、密码、安全入口等）：

```bash
docker run -d \
  --name 1panel-v2 \
  --restart always \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /opt:/opt \
  -e TZ=Asia/Shanghai \
  -e PORT=10086 \
  -e USERNAME=admin \
  -e PASSWORD=your_secure_password \
  -e ENTRANCE=myentrance \
  -e BASE_DIR=/opt \
  docker.xuanyuan.run/moelin/1panel:v2
```

#### 关键优化说明：

- `--restart always`：容器异常退出或 Docker 重启后自动拉起，保障面板持续运行
- `--network host`：使用宿主机网络，避免端口映射冲突，简化配置
- `-v /var/run/docker.sock:/var/run/docker.sock`：映射 Docker 守护进程，实现面板对 Docker 的可视化管理
- `-v /opt:/opt`：数据卷持久化，结合 `BASE_DIR` 环境变量，避免容器删除后配置、数据丢失
- `-e TZ=Asia/Shanghai`：设置时区为中国标准时间，确保日志和定时任务时间正确

### 环境变量配置详情（V2 版本）

| 变量名 | 默认值 | 说明 |
| ---- | ---- | ---- |
| PORT | 10086 | 面板访问端口 |
| USERNAME | 1panel | 管理员用户名 |
| PASSWORD | 1panel_password | 管理员密码，未设置或使用默认值时，首次启动会自动生成随机密码（日志中查看） |
| ENTRANCE | entrance | 安全入口路径，访问地址格式：http://IP:端口/入口路径 |
| BASE_DIR | /opt | 数据存储目录，需与挂载目录保持一致 |
| TZ | Asia/Shanghai | 时区设置 |
| RESET | false | 设为 true 可强制重置面板配置 |

### 方式二：使用 docker-compose (推荐)

使用 Compose 更方便管理和维护，可直接固化配置，后续启动、停止更便捷，还可添加标签便于识别。

创建一个 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  1panel-v2:
    container_name: 1panel-v2
    restart: always
    network_mode: "host"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt:/opt
    environment:
      - TZ=Asia/Shanghai
      - PORT=10086
      - USERNAME=admin
      - PASSWORD=your_secure_password
      - ENTRANCE=myentrance
      - BASE_DIR=/opt
    image: docker.xuanyuan.run/moelin/1panel:v2
    labels:
      createdBy: "Apps"
```

启动服务：

```bash
docker-compose up -d
```

---

## 五、老用户专区：V1 版本部署

如果你是 V1 的老用户，或者出于稳定考虑想使用 V1，部署步骤如下。重要注意事项：V1 版本禁止点击面板右下角更新按钮，应通过拉取新镜像并重新部署来更新；仅 v1.10.34-lts 及以后版本支持环境变量配置。

### V1 版本默认配置

- 端口：10086
- 账户：1panel
- 密码：1panel_password（首次启动可自动生成随机密码，日志中查看）
- 入口：entrance
- 支持架构：amd64, arm64, armv7, ppc64le, s390x

### Docker Run 命令

#### 中国版 (CN) - 基础安装（无自定义配置）

```bash
docker run -d \
  --name 1panel \
  --restart always \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -v /opt:/opt \
  -v /root:/root \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/moelin/1panel:v1
```

#### 中国版 (CN) - 自定义配置（v1.10.34-lts+）

```bash
docker run -d \
  --name 1panel \
  --restart always \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -v /opt:/opt \
  -v /root:/root \
  -e TZ=Asia/Shanghai \
  -e PORT=10086 \
  -e USERNAME=admin \
  -e PASSWORD=your_secure_password \
  -e ENTRANCE=myentrance \
  -e BASE_DIR=/opt \
  docker.xuanyuan.run/moelin/1panel:v1
```

#### 国际版 (Global) - 基础安装

```bash
docker run -d \
  --name 1panel-global \
  --restart always \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -v /opt:/opt \
  -v /root:/root \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/moelin/1panel:global-v1
```

### Docker Compose 安装

#### 基础配置

创建 docker-compose.yml:

```yaml
version: '3'
services:
  1panel:
    container_name: 1panel
    restart: always
    network_mode: "host"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
      - /opt:/opt
      - /root:/root
    environment:
      - TZ=Asia/Shanghai
    image: docker.xuanyuan.run/moelin/1panel:v1
    labels:
      createdBy: "Apps"
```

#### 自定义配置 (v1.10.34-lts+)

```yaml
version: '3'
services:
  1panel:
    container_name: 1panel
    restart: always
    network_mode: "host"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
      - /opt:/opt
      - /root:/root
    environment:
      - TZ=Asia/Shanghai
      - PORT=10086
      - USERNAME=admin
      - PASSWORD=your_secure_password
      - ENTRANCE=myentrance
      - BASE_DIR=/opt
    image: docker.xuanyuan.run/moelin/1panel:v1
    labels:
      createdBy: "Apps"
```

启动服务：

```bash
docker-compose up -d
```

### 修改面板显示版本（可选）

自 2023-09-19 起，镜像已支持自动修改面板显示版本，无需手动操作；如需手动修改，步骤如下：

1. 安装 SQLite3
```bash
# Debian/Ubuntu
apt-get update && apt-get install sqlite3 -y

# RedHat/CentOS
yum install sqlite -y
```

2. 修改版本信息
```bash
# 备份数据库
cp /opt/1panel/db/1Panel.db /opt/1panel/db/1Panel.db.bak

# 打开数据库
sqlite3 /opt/1panel/db/1Panel.db

# 修改版本 (替换 v1.10.22 为实际版本)
UPDATE settings SET value = 'v1.10.22' WHERE key = 'SystemVersion';

# 退出
.exit

# 重启容器
docker restart 1panel
```

---

## 六、常用操作与维护

### 1. 查看面板信息与日志

如果你忘记了端口、入口或自动生成的密码，可以通过日志查看，支持实时查看日志排查问题：

```bash
# V2 查看日志
docker logs 1panel-v2
# V2 实时查看日志
docker logs -f 1panel-v2

# V1 查看日志
docker logs 1panel
# V1 实时查看日志
docker logs -f 1panel
```

### 2. 在容器内使用 1pctl 命令行工具

如果需要执行 1Panel 的命令行工具（如查看版本、执行运维操作），步骤如下：

```bash
# 进入容器（V2）
docker exec -it 1panel-v2 bash
# 进入容器（V1）
docker exec -it 1panel bash

# 执行命令 (例如查看版本)
1pctl version
```

### 3. 镜像更新（避免面板内更新）

无论是 V1 还是 V2 版本，均不建议在面板内点击更新按钮，正确的更新方式为：

1. 拉取最新镜像（对应版本标签）
2. 停止并删除旧容器
3. 使用原配置命令重新启动新容器（确保数据卷挂载正确，避免数据丢失）

---

## 七、常见问题 (FAQ)

### Q1: V1 和 V2 怎么选？我能直接升级吗？

- 新用户：无脑选 V2，功能更强、架构更优，支持更多便捷配置。
- 老用户：建议继续用 V1 稳定运行，无需强行迁移。
- ⚠️ 重要：V1 和 V2 无法直接跨版本升级。如果一定要迁移，需要先把 Docker 版的 1Panel 用迁移脚本转到宿主机运行，升级后再转回来。

### Q2: 如何从 V1 迁移到 V2？

具体迁移步骤如下（Docker 运行模式专用）：

1. 使用迁移脚本将 1Panel 从 Docker 运行模式切换到宿主机运行模式（国内推荐使用 jsDelivr 源，任选其一）：
```bash
# GitHub 源
wget -O 1panel_docker_to_sys.sh https://raw.githubusercontent.com/okxlin/ToolScript/refs/heads/main/1Panel/1panel-execution-mode/1panel_docker_to_sys.sh
# jsDelivr 源（国内加速）
wget -O 1panel_docker_to_sys.sh https://cdn.jsdelivr.net/gh/okxlin/ToolScript@main/1Panel/1panel-execution-mode/1panel_docker_to_sys.sh
wget -O 1panel_docker_to_sys.sh https://testingcf.jsdelivr.net/gh/okxlin/ToolScript@main/1Panel/1panel-execution-mode/1panel_docker_to_sys.sh
wget -O 1panel_docker_to_sys.sh https://quantil.jsdelivr.net/gh/okxlin/ToolScript@main/1Panel/1panel-execution-mode/1panel_docker_to_sys.sh
# 下载完成后，添加执行权限并运行
chmod +x 1panel_docker_to_sys.sh && bash 1panel_docker_to_sys.sh
```

2. 使用官方升级工具将 V1 升级到 V2，参考官方文档: https://1panel.cn/docs/v2/installation/v1_migrate/

3. 升级完成后，如需切换回 Docker 运行模式，可重新使用迁移脚本切换。

### Q3: 面板启动了但访问不了？

- 检查防火墙是否放行了你设置的端口（默认 10086）。
- 如果是云服务器，检查安全组规则，确保对应端口对外开放。
- 检查容器是否正常运行（docker ps），若未运行，查看日志排查异常（docker logs 容器名）。

### Q4: 容器内如何执行 1pctl 命令？

```bash
# 进入容器（V2）
docker exec -it 1panel-v2 bash
# 进入容器（V1）
docker exec -it 1panel bash

# 执行命令 (例如查看版本)
1pctl version
```

### Q5: 忘记管理员密码怎么办？

- 若未设置自定义密码，首次启动的随机密码可通过容器日志查看（docker logs 容器名）。
- 若已设置密码，可通过重新启动容器，添加 `-e RESET=true` 环境变量，强制重置配置（会清空原有配置，谨慎使用）。

---

## 八、总结

通过 Docker 部署 1Panel，我们可以在几分钟内获得一个功能强大的服务器管理面板。配合轩辕镜像的一键脚本，无论是国产服务器架构还是国内网络环境，都能实现快速部署、稳定运行。

本文整合了 1Panel 两个版本的详细部署步骤、镜像标签选择、环境变量配置及常见问题解决方案，覆盖新老用户需求，助力大家避坑高效运维。

---

- 1Panel 官方文档: https://1panel.cn
- 1Panel V1 迁移到 V2 官方文档: https://1panel.cn/docs/v2/installation/v1_migrate/


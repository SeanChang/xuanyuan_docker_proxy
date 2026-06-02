<!-- xuanyuan-docker-images-zh
image: moelin/1panel
source: https://xuanyuan.cloud/zh/r/moelin/1panel
canonical: https://xuanyuan.cloud/zh/r/moelin/1panel
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/moelin/1panel" title="moelin/1panel Docker 镜像中文简介、标签列表与拉取命令">moelin/1panel — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/moelin/1panel" title="moelin/1panel Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/moelin/1panel</a></p>

# 1Panel Docker 部署指南


[![Docker Image Version (latest semver)]([])]([])
[![Docker Image Version (latest semver)]([])]([])
[![Docker Pulls]([])]([])
[![Docker Stars]([])]([])
[![GitHub Repo stars]([])]([])


## 目录
- [1. 注意事项](#1-注意事项)
- [2. 基础信息](#2-基础信息)
- [3. 参数说明](#3-参数说明)
- [4. 架构支持](#4-架构支持)
- [5. 部署方式](#5-部署方式)
  - [5.1 Docker 命令部署](#51-docker-命令部署)
  - [5.2 Docker Compose 部署](#52-docker-compose-部署)
- [6. 版本显示调整（备用）](#6-版本显示调整备用)


## 1. 注意事项
- 容器化部署的 1Panel 受 `systemd` 限制，部分功能暂不完整。
- **重要**：不要通过面板右下角的更新按钮升级，需拉取新镜像后重新部署以应用更新。
- 20230919 起，镜像已支持自动修改面板显示的应用版本，无需手动操作数据库。


## 2. 基础信息
- 默认端口：`10086`
- 默认登录账户：`1panel`
- 默认登录密码：`1panel_password`
- 默认访问入口：`entrance`


## 3. 参数说明
### 不可调整参数
- 必须保留 `/var/run/docker.sock` 映射，否则影响容器管理功能。

### 可调整参数
> 推荐使用 `/opt` 路径映射，避免本地文件调用异常
- 数据存储映射：`/opt:/opt`（核心路径，建议必选）、`/root:/root`（可选）
- 时区设置：`TZ=Asia/Shanghai`（建议设置为上海时区）
- 容器名称：`1panel`（可自定义，需保持命令中一致）
- 存储卷映射：`/var/lib/docker/volumes:/var/lib/docker/volumes`（可选，管理 Docker 存储卷用）
- Docker 配置映射：`/etc/docker:/etc/docker`（可选，管理 Docker 配置用）


## 4. 架构支持
镜像支持多架构平台，直接拉取即可自动匹配：
- amd64（x86_64）
- arm64（aarch64）
- armv7
- ppc64le
- s390x

拉取命令：`docker pull moelin/1panel:latest`


## 5. 部署方式
### 5.1 Docker 命令部署
直接执行以下命令启动容器：
```bash
docker run -d \
    --name 1panel \
    --restart always \
    --network host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    -v /opt:/opt \
    -v /root:/root \
    -v /etc/docker:/etc/docker \
    -e TZ=Asia/Shanghai \
    moelin/1panel:latest
```

### 5.2 Docker Compose 部署
1. 创建 `docker-compose.yml` 文件，内容如下：
```yaml
version: '3'
services:
  1panel:
    container_name: 1panel  # 容器名，可自定义
    restart: always
    network_mode: "host"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
      - /opt:/opt  # 核心数据存储，推荐必选
      - /root:/root  # 可选，按需添加
      - /etc/docker:/etc/docker  # 可选，Docker 配置管理用
    environment:
      - TZ=Asia/Shanghai  # 时区设置
    image: moelin/1panel:latest
    labels:
      createdBy: "Apps"
```

2. 在文件所在目录执行部署命令：
```bash
docker-compose up -d
```


## 6. 版本显示调整（备用）
> 仅当自动版本调整失效时使用，正常情况无需操作

### 6.1 安装 SQLite3
根据系统类型执行命令：
- Debian/Ubuntu：`apt-get update && apt-get install sqlite3 -y`
- RedHat/CentOS：`yum install sqlite3 -y`

### 6.2 修改版本信息
1. **备份数据库**（避免操作失误）：
```bash
cp /opt/1panel/db/1Panel.db /opt/1panel/db/1Panel.db.bak
```

2. **修改版本记录**：
```bash
# 进入 SQLite 交互模式
sqlite3 /opt/1panel/db/1Panel.db

# 执行 SQL 命令（将 v1.5.2 替换为目标版本号）
UPDATE settings SET value = 'v1.5.2' WHERE key = 'SystemVersion';

# 退出交互模式
.exit
```

3. **重启容器生效**：
```bash
docker restart 1panel
```

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/moelin/1panel" title="moelin/1panel Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/moelin/1panel</a></p>

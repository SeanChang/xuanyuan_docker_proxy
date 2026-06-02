---
image: linuxserver/paperless-ngx
description: "LinuxServer.io提供的paperless-ngx镜像，用于纸质文档的数字化管理，支持扫描、索引、存储与检索，帮助用户高效管理电子文档。"
source: https://xuanyuan.cloud/zh/r/linuxserver/paperless-ngx
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[linuxserver/paperless-ngx](https://xuanyuan.cloud/zh/r/linuxserver/paperless-ngx)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/paperless-ngx 镜像文档


## 镜像概述和主要用途

**注意：此镜像已废弃**。LinuxServer.io 团队不再提供支持和更新。建议迁移至官方容器：[paperless-ngx/paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)。

`linuxserver/paperless-ngx` 是 LinuxServer.io 团队发布的 Docker 镜像，用于部署 [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) 应用。Paperless-ngx 是一款文档管理工具，可索引扫描文档、支持全文搜索，并允许用户为文档存储元数据，实现纸质文档的数字化管理和高效检索。


## 核心功能和特性

### LinuxServer.io 镜像特性
- **定期应用更新**：及时同步上游应用版本
- **用户权限映射**：通过 PUID/PGID 轻松配置容器内用户权限
- **自定义基础镜像**：集成 s6 overlay 进程管理系统
- **高效资源利用**：每周基础 OS 更新，跨镜像共享公共层，减少存储空间占用、 downtime 和带宽消耗
- **安全更新**：定期进行安全补丁更新

### Paperless-ngx 应用功能
- 扫描文档自动索引与全文搜索
- 文档元数据管理与自定义标签
- 支持多种文档格式处理


## 使用场景和适用范围

适用于个人或小型团队的纸质文档数字化管理需求，例如：
- 家庭账单、合同等重要文档的电子化存储与检索
- 小型办公室的发票、收据等财务文档管理
- 需要集中管理扫描文档并快速查询的场景

**注意**：由于此镜像已废弃，不建议用于新部署。现有用户应迁移至 [官方容器](https://github.com/paperless-ngx/paperless-ngx)。


## 详细使用方法和配置说明

### 支持的架构

| 架构       | 支持状态 | 标签格式               |
|------------|----------|------------------------|
| x86-64     | ✅        | amd64-\<version tag\>   |
| arm64      | ✅        | arm64v8-\<version tag\> |
| armhf      | ✅        | arm32v7-\<version tag\> |

默认标签 `latest` 会自动匹配当前系统架构。


### 应用初始化设置

- **默认登录**：Web 界面默认账号 `admin`，密码 `admin`
- **访问地址**：`http://服务器IP:8000`
- **管理命令**：通过容器执行管理命令，格式为 `docker exec -it <容器名> manage <命令>`，例如重建文档索引：  
  `docker exec -it paperless manage document_retagger -tT`  
  完整命令列表参考 [官方文档](https://paperless-ng.readthedocs.io/en/latest/administration.html)


### 部署示例

#### Docker Compose (推荐)

```yaml
---
version: "2.1"
services:
  paperless-ngx:
    image: lscr.io/linuxserver/paperless-ngx:latest
    container_name: paperless-ngx
    environment:
      - PUID=1000               # 运行用户ID
      - PGID=1000               # 运行组ID
      - TZ=America/New_York     # 时区设置
      - REDIS_URL=              # 可选，外部Redis地址
    volumes:
      - /path/to/appdata/config:/config  # 配置文件存储路径
      - /path/to/appdata/data:/data      # 文档数据存储路径
    ports:
      - 8000:8000               # Web服务端口映射
    restart: unless-stopped
```

#### Docker Run

```bash
docker run -d \
  --name=paperless-ngx \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e REDIS_URL= `#可选` \
  -p 8000:8000 \
  -v /path/to/appdata/config:/config \
  -v /path/to/appdata/data:/data \
  --restart unless-stopped \
  lscr.io/linuxserver/paperless-ngx:latest
```


### 配置参数说明

#### 端口映射

| 参数        | 功能描述                |
|-------------|-------------------------|
| `-p 8000`   | Web 管理界面访问端口    |


#### 环境变量

| 变量名       | 可选性 | 描述                                                                 |
|--------------|--------|----------------------------------------------------------------------|
| `PUID`       | 必选   | 用户ID，通过 `id 用户名` 命令获取，确保宿主机目录权限匹配             |
| `PGID`       | 必选   | 组ID，同上                                                           |
| `TZ`         | 必选   | 时区，格式如 `Asia/Shanghai`                                         |
| `REDIS_URL`  | 可选   | 外部Redis服务地址，如 `redis://redis-host:6379/0`；留空则使用内置Redis |


#### 数据卷挂载

| 卷路径        | 描述                                                                 |
|---------------|----------------------------------------------------------------------|
| `/config`     | 配置文件存储目录，包含应用设置、数据库等                             |
| `/data`       | 文档数据存储目录，包含扫描文件、索引数据等                           |


### 环境变量文件 (Docker Secrets)

支持通过文件注入敏感环境变量，格式为 `-e FILE__<变量名>=/路径/文件`，例如：  
`-e FILE__REDIS_PASSWORD=/run/secrets/redis_password`  
容器会自动读取指定文件内容作为环境变量值。


### Umask 权限设置

通过 `-e UMASK=022` 自定义文件权限掩码，默认值 `022`（对应权限 `755`/`644`）。


### 用户/组ID配置

为避免权限问题，需确保宿主机挂载目录的所有者ID与容器内 `PUID`/`PGID` 一致。通过以下命令获取当前用户ID：  
```bash
id 用户名
# 输出示例：uid=1000(用户) gid=1000(组) 组=1000(组)
```


## 支持信息

- **容器Shell访问**：`docker exec -it paperless-ngx /bin/bash`
- **实时日志查看**：`docker logs -f paperless-ngx`
- **容器版本查询**：  
  `docker inspect -f '{{ index .Config.Labels "build_version" }}' paperless-ngx`
- **镜像版本查询**：  
  `docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/paperless-ngx:latest`


## 镜像更新方法

### Docker Compose 更新

```bash
# 拉取最新镜像
docker-compose pull paperless-ngx

# 更新容器
docker-compose up -d paperless-ngx

# 清理旧镜像
docker image prune
```

### Docker Run 更新

```bash
# 拉取最新镜像
docker pull lscr.io/linuxserver/paperless-ngx:latest

# 停止并删除旧容器
docker stop paperless-ngx && docker rm paperless-ngx

# 用原参数重建容器（数据卷挂载正确时配置会保留）
docker run -d [原参数] lscr.io/linuxserver/paperless-ngx:latest

# 清理旧镜像
docker image prune
```

### Watchtower 自动更新（不推荐）

```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once paperless-ngx
```


## 本地构建方法

```bash
# 克隆仓库
git clone https://github.com/linuxserver/docker-paperless-ngx.git
cd docker-paperless-ngx

# 构建镜像
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/paperless-ngx:latest .

# ARM架构构建（需先注册qemu）
docker run --rm --privileged multiarch/qemu-user-static:register --reset
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/paperless-ngx:arm64v8-latest .
```


## 版本历史

- **2022.09.05**：镜像废弃公告
- **2022.05.16**：修复ARM架构下libqpdf.so依赖
- **2022.05.14**：优化Redis禁用逻辑
- **2022.05.12**：修复Redis禁用问题，添加PostgreSQL依赖
- **2022.04.11**：替换uwsgi为gunicorn解决WebSocket问题
- **2022.03.11**：初始发布

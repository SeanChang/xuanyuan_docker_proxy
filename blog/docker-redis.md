---
id: 3
title: 手把手教你用 Docker 部署 Redis
slug: docker-redis
summary: 本文详细介绍从轩辕镜像拉取Redis镜像的多种方式（登录验证、免登录、官方直连等），提供快速部署、持久化部署（推荐）、docker-compose部署（企业级）三种方案，还包含结果验证方法及无法远程连接、设置密码等常见问题的解决办法，助力用户掌握Redis的Docker部署全流程。
category: Docker,Redis
tags: redis,docker,部署教程
image_name: library/redis
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-redis.png"
status: published
created_at: "2025-10-03 06:24:12"
updated_at: "2025-10-08 06:46:53"
---

# 手把手教你用 Docker 部署 Redis

> 本文详细介绍从轩辕镜像拉取Redis镜像的多种方式（登录验证、免登录、官方直连等），提供快速部署、持久化部署（推荐）、docker-compose部署（企业级）三种方案，还包含结果验证方法及无法远程连接、设置密码等常见问题的解决办法，助力用户掌握Redis的Docker部署全流程。

Redis是一款开源的高性能内存数据存储系统，常用作数据库、缓存和消息代理。它支持字符串、哈希、列表等多种数据结构，凭借内存存储特性提供毫秒级响应访问表现，广泛应用于高并发场景下的数据快速访问。

使用Docker部署Redis具有显著优势：首先，容器化确保了环境一致性，避免因操作系统、依赖库差异导致的"在我这能跑"问题；其次，部署过程标准化，通过简单命令即可快速启动，大幅降低配置复杂度；再者，容器隔离性强，能有效避免Redis与其他应用的资源冲突；此外，便于版本管理和快速迁移，可轻松切换不同Redis版本或在不同环境间移植。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1、查看 Redis 镜像详情
你可以在 轩辕镜像 中找到 Redis 镜像页面：
👉 https://xuanyuan.cloud/r/library/redis

在镜像页面中，你会看到多种拉取方式，下面我们逐一说明如何部署。


## 2、下载 Redis 镜像
### 2.1 使用轩辕镜像登录验证的方式拉取
```bash
docker pull docker.xuanyuan.run/library/redis:latest
```

### 2.2 拉取后改名
```bash
docker pull docker.xuanyuan.run/library/redis:latest \
  && docker tag docker.xuanyuan.run/library/redis:latest library/redis:latest \
  && docker rmi docker.xuanyuan.run/library/redis:latest
```

说明：
- docker pull：从轩辕镜像访问支持拉取镜像
- docker tag：将镜像重命名为官方标准名称 `library/redis:latest`，后续运行命令更简洁
- docker rmi：删除临时镜像标签，避免占用额外存储空间

### 2.3 使用免登录方式拉取（推荐）
基础拉取命令：
```bash
docker pull xxx.xuanyuan.run/library/redis:latest
```

带重命名的完整命令：
```bash
docker pull xxx.xuanyuan.run/library/redis:latest \
  && docker tag xxx.xuanyuan.run/library/redis:latest library/redis:latest \
  && docker rmi xxx.xuanyuan.run/library/redis:latest
```

说明：
免登录方式无需配置账户信息，新手可直接使用；镜像内容与 `docker.xuanyuan.run` 源完全一致，仅拉取地址不同。

### 2.4 官方直连方式
若网络可直连 Docker Hub，或已配置轩辕镜像访问支持器，可直接拉取官方镜像：
```bash
docker pull library/redis:latest
```

### 2.5 查看镜像是否拉取成功
```bash
docker images
```

若输出类似以下内容，说明镜像下载成功：
```
REPOSITORY     TAG       IMAGE ID       CREATED        SIZE
library/redis  latest    7614ae9453d1   3 weeks ago    120MB
```


## 3、部署 Redis
以下使用已下载的 `library/redis:latest` 镜像，提供三种部署方案，可根据场景选择。

### 3.1 快速部署（最简方式）
适合测试或临时使用，命令如下：
```bash
# 启动 Redis 容器，命名为 redis-test
# 宿主机 6379 端口映射到容器 6379 端口（Redis 默认端口）
docker run -d --name redis-test -p 6379:6379 library/redis:latest
```

核心参数说明：
- `--name redis-test`：为容器指定名称，便于后续管理（如停止、重启）
- `-p 6379:6379`：端口映射，格式为「宿主机端口:容器端口」
- `-d`：后台运行容器

验证方式：
在宿主机执行：
```bash
docker exec -it redis-test redis-cli ping
```

输出 `PONG` 即表示 Redis 运行正常。

### 3.2 持久化部署（推荐方式，适合实际项目）
通过挂载宿主机目录，实现「数据持久化」「配置独立管理」，步骤如下：

#### 第一步：创建宿主机目录
```bash
mkdir -p /data/redis/{data,conf}
```

#### 第二步：准备配置文件
新建 `/data/redis/conf/redis.conf`，写入简单配置：
```conf
bind 0.0.0.0
protected-mode no
port 6379
appendonly yes
```

说明：
- `bind 0.0.0.0`：允许外部访问（生产环境可改为内网 IP）
- `appendonly yes`：启用 AOF 持久化，避免数据丢失

#### 第三步：启动容器并挂载目录
```bash
docker run -d --name redis-web \
  -p 6379:6379 \
  -v /data/redis/data:/data \
  -v /data/redis/conf/redis.conf:/usr/local/etc/redis/redis.conf \
  library/redis:latest redis-server /usr/local/etc/redis/redis.conf
```

目录映射说明：
| 宿主机目录          | 容器内目录                          | 用途               |
|---------------------|-------------------------------------|--------------------|
| /data/redis/data    | /data                               | Redis 数据持久化   |
| /data/redis/conf/   | /usr/local/etc/redis/redis.conf     | Redis 配置文件     |

### 3.3 docker-compose 部署（适合企业级场景）
通过 `docker-compose.yml` 统一管理容器配置，支持一键启动/停止。

#### 第一步：创建 docker-compose.yml 文件
```yaml
version: '3'
services:
  redis:
    image: library/redis:latest
    container_name: redis-service
    ports:
      - "6379:6379"
    volumes:
      - ./data:/data
      - ./conf/redis.conf:/usr/local/etc/redis/redis.conf
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]
    restart: always
```

#### 第二步：启动服务
在 `docker-compose.yml` 所在目录执行：
```bash
docker compose up -d
```

补充说明：
- 修改配置文件后可直接 `docker restart redis-service` 生效
- 停止服务命令：`docker compose down`
- 查看状态：`docker compose ps`


## 4、结果验证
通过以下方式确认 Redis 服务正常运行：

### 4.1 客户端验证
```bash
redis-cli -h 服务器IP -p 6379
> ping
PONG
```

### 4.2 查看容器状态
```bash
docker ps
```
若 STATUS 列显示 `Up`，说明容器正常运行。

### 4.3 查看容器日志
```bash
docker logs redis-web
```
无报错信息即表示服务启动正常。


## 5、常见问题
### 5.1 无法远程连接？
排查方向：
1. 防火墙：确认宿主机 6379 端口已开放
   ```bash
   ufw allow 6379/tcp
   ```
   ```bash
   firewall-cmd --add-port=6379/tcp --permanent && firewall-cmd --reload
   ```
2. 配置问题：确认 `redis.conf` 中 `bind 0.0.0.0`、`protected-mode no`

### 5.2 如何设置密码？
1. 在 `redis.conf` 文件中添加：
   ```conf
   requirepass 你的密码
   ```
2. 修改后重启容器：
   ```bash
   docker restart redis-web
   ```
3. 验证：
   ```bash
   redis-cli -a 你的密码 ping
   ```

### 5.3 数据丢失怎么办？
- AOF 持久化：启用 `appendonly yes`（推荐）
- RDB 快照：默认开启，可在配置文件调整快照规则
- 外部备份：定期将 `/data/redis/data` 目录打包存档

### 5.4 容器内时区不正确？
在启动容器时，增加环境变量：
```bash
-e TZ=Asia/Shanghai
```

完整示例：
```bash
docker run -d -e TZ=Asia/Shanghai \
  --name redis-web \
  -p 6379:6379 \
  -v /data/redis/data:/data \
  -v /data/redis/conf/redis.conf:/usr/local/etc/redis/redis.conf \
  library/redis:latest redis-server /usr/local/etc/redis/redis.conf
```


## 结尾
至此，你已掌握基于轩辕镜像的 Redis 镜像拉取与 Docker 部署全流程——从镜像下载验证，到不同场景的部署实践，再到问题排查，每个步骤都配备了完整的操作命令和说明。

- 初学者：建议先从「快速部署」熟悉流程
- 进阶用户：使用「持久化部署」保障数据安全
- 企业级场景：采用「docker-compose」实现配置管理与高可用

在实际使用中，若遇到文档未覆盖的问题，可结合 `docker logs 容器名` 查看日志定位原因，或参考 Redis 官方文档深入学习。随着实践深入，你还可以探索 Redis 的 主从复制、哨兵模式、集群部署 等高级功能，让 Redis 更好地支撑你的业务需求。


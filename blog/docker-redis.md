# 手把手教你用 Docker 部署 Redis

![手把手教你用 Docker 部署 Redis](https://img.xuanyuan.dev/docker/blog/docker-redis.png)

*分类: Docker,Redis | 标签: redis,docker,部署教程 | 发布时间: 2025-10-03 06:24:12*

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

## 1、Redis 镜像拉取（整合版，避免重复）
你可以在轩辕镜像中找到 Redis 镜像页面：👉 https://xuanyuan.cloud/r/library/redis
以下提供4种拉取方式，按需选择即可：

### 1.1  轩辕镜像（登录验证方式）
```bash
docker pull docker.xuanyuan.run/library/redis:7.2.4  # 推荐使用具体版本，避免latest版本不可控
```

### 1.2  轩辕镜像（免登录方式，新手推荐）
```bash
# 拉取并自动重命名为官方标准名称，节省存储空间
docker pull xxx.xuanyuan.run/library/redis:7.2.4 \
  && docker tag xxx.xuanyuan.run/library/redis:7.2.4 library/redis:7.2.4 \
  && docker rmi xxx.xuanyuan.run/library/redis:7.2.4
```

### 1.3  官方直连方式（需网络通畅或配置镜像加速器）
```bash
docker pull library/redis:7.2.4
```

### 1.4  验证镜像拉取成功
```bash
docker images
```
若输出类似以下内容，说明镜像下载成功：
```
REPOSITORY     TAG       IMAGE ID       CREATED        SIZE
library/redis  7.2.4     7614ae9453d1   3 weeks ago    120MB
```

### 1.5  多架构镜像说明（可选，支持ARM/x86）
轩辕镜像默认提供多架构支持，ARM架构（如树莓派、阿里云ARM服务器）无需额外配置，直接拉取即可自动匹配架构：
```bash
docker pull xxx.xuanyuan.run/library/redis:7.2.4  # 自动适配ARM/x86架构
```

---

## 2、部署 Redis（分层部署，明确测试/生产/企业级）
### 2.1  测试环境：快速部署（最简方式，仅用于测试/临时使用）
适合快速验证Redis功能，无持久化、无安全配置，步骤完整可直接复现：

#### 第一步：拉取镜像（补充步骤，避免跳步）
```bash
# 若未拉取镜像，先执行拉取命令
docker pull library/redis:7.2.4
```

#### 第二步：启动容器
```bash
# 测试环境直接映射6379端口，后台运行
docker run -d --name redis-test -p 6379:6379 library/redis:7.2.4
```

核心参数说明：
- `--name redis-test`：为容器指定名称，便于后续管理
- `-p 6379:6379`：测试环境直接端口映射，生产环境不推荐
- `-d`：后台运行容器

#### 第三步：验证运行状态
```bash
docker exec -it redis-test redis-cli ping
```
输出 `PONG` 即表示 Redis 运行正常。

### 2.2  生产环境：持久化部署（推荐，保障数据安全/可维护性）
通过目录挂载、权限控制、资源限制实现生产级部署，支持数据持久化、配置独立管理，避免安全风险和资源滥用。

#### 第一步：创建宿主机目录并配置权限
```bash
# 创建数据、配置、日志目录
mkdir -p /data/redis/{data,conf,log}

# 创建独立用户（避免使用root权限，降低安全风险）
useradd -u 1001 redis-user || echo "redis-user已存在"

# 修改目录权限，指定Redis运行用户
chown -R 1001:1001 /data/redis
chmod 755 /data/redis  # 限制目录访问权限
```

#### 第二步：准备生产级安全配置文件
新建 `/data/redis/conf/redis.conf`，写入安全且可用的配置：
```conf
# 生产环境：仅绑定内网IP，禁止公网直接绑定（若需公网访问，通过防火墙/安全组转发）
bind 192.168.1.100  # 替换为你的宿主机内网IP
protected-mode yes  # 启用保护模式，配合密码使用
port 6379           # 容器内端口保持默认，宿主机可修改映射端口

# 持久化配置（推荐AOF+RDB混合模式）
appendonly yes      # 启用AOF持久化，避免数据丢失
appendfsync everysec  # 每秒同步一次，兼顾性能和数据安全性
save 900 1          # RDB快照：900秒内至少1个键修改则生成快照
save 300 10         # 300秒内至少10个键修改则生成快照
save 60 10000       # 60秒内至少10000个键修改则生成快照

# 安全配置：强制设置复杂密码（必须修改为你的强密码）
requirepass YourStrongRedisPassword@123  # 密码要求：大小写+数字+特殊字符

# 性能优化配置
maxmemory 1G        # 限制最大内存使用，避免占用过多宿主机资源
maxmemory-policy allkeys-lru  # 内存满时，淘汰最少使用的键
timeout 300         # 空闲连接300秒后断开，释放资源

# 日志配置
logfile /var/log/redis/redis-server.log  # 容器内日志路径
loglevel notice     # 日志级别，生产环境不推荐debug
```

#### 第三步：启动容器（带资源限制、权限挂载、日志持久化）
```bash
docker run -d --name redis-prod \
  -p 6380:6379  # 生产环境修改宿主机映射端口，避免默认6379端口被扫描攻击
  --memory 1g   # 限制容器最大使用1G内存
  --cpus 1      # 限制容器最大使用1个CPU核心
  -u 1001:1001  # 指定运行用户，与宿主机目录权限匹配
  -v /data/redis/data:/data  # 数据持久化挂载
  -v /data/redis/conf/redis.conf:/usr/local/etc/redis/redis.conf  # 配置文件挂载
  -v /data/redis/log:/var/log/redis  # 日志持久化挂载，便于问题排查
  -e TZ=Asia/Shanghai  # 统一时区，避免时间不一致问题
  library/redis:7.2.4 redis-server /usr/local/etc/redis/redis.conf
```

目录映射说明：
| 宿主机目录          | 容器内目录                          | 用途               |
|---------------------|-------------------------------------|--------------------|
| /data/redis/data    | /data                               | Redis 数据持久化   |
| /data/redis/conf/redis.conf | /usr/local/etc/redis/redis.conf | Redis 配置文件     |
| /data/redis/log     | /var/log/redis                      | Redis 日志持久化   |

#### 第四步：验证生产环境可用性
```bash
# 带密码连接验证
redis-cli -h 192.168.1.100 -p 6380 -a YourStrongRedisPassword@123 ping
```
输出 `PONG` 即表示生产环境Redis运行正常。

### 2.3  企业级环境：docker-compose 部署（统一配置，一键启停）
通过 `docker-compose.yml` 统一管理容器配置，支持资源限制、健康检查、自动重启，便于扩展为哨兵/集群模式。

#### 第一步：创建 docker-compose.yml 文件
```yaml
version: '3'
services:
  redis:
    image: library/redis:7.2.4  # 固定版本，保证部署一致性
    container_name: redis-service
    ports:
      - "6380:6379"  # 生产环境修改宿主机映射端口
    volumes:
      - redis-data:/data  # 使用docker volume，比直接挂载宿主机目录更安全
      - ./conf/redis.conf:/usr/local/etc/redis/redis.conf
      - ./log:/var/log/redis
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]
    restart: on-failure:3  # 非永久重启：失败后重启3次，避免无限重启
    user: "1001:1001"      # 指定运行用户，匹配目录权限
    environment:
      - TZ=Asia/Shanghai   # 统一时区
    # 资源限制：避免占用过多宿主机资源
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
    # 健康检查：自动检测容器状态，异常时可触发重启
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "YourStrongRedisPassword@123", "ping"]
      interval: 30s        # 每30秒检查一次
      timeout: 5s          # 检查超时时间5秒
      retries: 3           # 连续3次失败则标记为不健康
      start_period: 60s    # 容器启动后60秒再开始健康检查

# 使用docker volume管理数据，自动维护权限，比宿主机目录更可靠
volumes:
  redis-data:
    driver: local
```

#### 第二步：准备配套目录和配置
```bash
# 创建配置和日志目录
mkdir -p ./conf ./log
# 复制生产级配置文件到./conf目录
cp /data/redis/conf/redis.conf ./conf/
# 修改目录权限
chown -R 1001:1001 ./conf ./log
```

#### 第三步：一键启停服务
```bash
# 启动服务（后台运行）
docker compose up -d

# 停止服务（保留数据卷）
docker compose down

# 停止服务并删除数据卷（谨慎使用，会丢失数据）
docker compose down -v

# 查看服务状态
docker compose ps

# 查看健康检查状态
docker inspect --format '{{.State.Health.Status}}' redis-service
```

### 2.4  企业级高可用扩展（可选：Sentinel 哨兵模式模板）
针对需要高可用的业务场景，提供简易Sentinel模板，实现Redis主从切换：
```yaml
# docker-compose-sentinel.yml
version: '3'
services:
  # 主Redis
  redis-master:
    image: library/redis:7.2.4
    container_name: redis-master
    ports:
      - "6381:6379"
    volumes:
      - redis-master-data:/data
      - ./conf/master-redis.conf:/usr/local/etc/redis/redis.conf
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]
    restart: on-failure:3
    user: "1001:1001"
    environment:
      - TZ=Asia/Shanghai

  # 从Redis
  redis-slave:
    image: library/redis:7.2.4
    container_name: redis-slave
    ports:
      - "6382:6379"
    volumes:
      - redis-slave-data:/data
      - ./conf/slave-redis.conf:/usr/local/etc/redis/redis.conf
    command: ["redis-server", "/usr/local/etc/redis/redis.conf"]
    restart: on-failure:3
    user: "1001:1001"
    environment:
      - TZ=Asia/Shanghai
    depends_on:
      - redis-master

  # 哨兵节点
  redis-sentinel:
    image: library/redis:7.2.4
    container_name: redis-sentinel
    ports:
      - "26379:26379"
    volumes:
      - ./conf/sentinel.conf:/usr/local/etc/redis/sentinel.conf
    command: ["redis-sentinel", "/usr/local/etc/redis/sentinel.conf"]
    restart: on-failure:3
    user: "1001:1001"
    environment:
      - TZ=Asia/Shanghai
    depends_on:
      - redis-master
      - redis-slave

volumes:
  redis-master-data:
  redis-slave-data:
```

---

## 3、结果验证（通用方法，适配所有部署模式）
### 3.1  客户端连接验证
```bash
# 测试环境
redis-cli -h 127.0.0.1 -p 6379 ping

# 生产/企业级环境（带端口和密码）
redis-cli -h 192.168.1.100 -p 6380 -a YourStrongRedisPassword@123 ping
```
输出 `PONG` 即表示 Redis 运行正常。

### 3.2  容器状态验证
```bash
# 查看单个容器状态
docker ps | grep redis

# 企业级docker-compose查看状态
docker compose ps
```
若 STATUS 列显示 `Up`（健康检查正常显示 `Up (healthy)`），说明容器正常运行。

### 3.3  日志验证
```bash
# 单个容器日志
docker logs redis-prod  # 生产环境容器名
docker logs --tail 100 redis-prod  # 查看最后100行日志

# docker-compose 日志
docker compose logs redis
docker compose logs --tail 50 redis  # 查看最后50行日志
```
无报错信息、包含 "Ready to accept connections" 即表示服务启动正常。

### 3.4  持久化验证
```bash
# 写入测试数据
redis-cli -h 192.168.1.100 -p 6380 -a YourStrongRedisPassword@123 set test_key 123

# 重启容器
docker restart redis-prod

# 重新连接并读取数据
redis-cli -h 192.168.1.100 -p 6380 -a YourStrongRedisPassword@123 get test_key
```
输出 `123` 即表示持久化配置生效，数据未丢失。

---

## 4、常见问题排查（补充新增问题，全面覆盖）
### 4.1  无法远程连接？
排查方向：
1.  防火墙/安全组：确认宿主机映射端口（如6380）已开放
    ```bash
    # Ubuntu/Debian
    ufw allow 6380/tcp

    # CentOS/RHEL
    firewall-cmd --add-port=6380/tcp --permanent && firewall-cmd --reload
    ```
2.  配置问题：确认 `redis.conf` 中 `bind` 为内网IP、`protected-mode yes`、已配置密码
3.  容器端口映射：确认 `docker ps` 显示端口映射正确（如0.0.0.0:6380->6379/tcp）

### 4.2  端口占用？
排查与解决：
```bash
# 查看端口占用情况
netstat -tulpn | grep 6380  # 替换为你的映射端口

# 杀死占用端口的进程（替换为实际PID）
kill -9 12345

# 重新启动Redis容器
docker restart redis-prod
```

### 4.3  容器重启异常/无法启动？
排查方向：
1.  查看容器日志，定位报错信息
    ```bash
    docker logs redis-prod
    ```
2.  检查配置文件语法错误：进入容器验证配置文件
    ```bash
    docker exec -it redis-prod redis-server --test-config /usr/local/etc/redis/redis.conf
    ```
3.  检查目录权限：确认宿主机目录权限为1001:1001
    ```bash
    ls -ld /data/redis
    ls -l /data/redis/conf/redis.conf
    ```
4.  检查资源限制：确认宿主机有足够内存/CPU资源
    ```bash
    free -m  # 查看内存使用
    top      # 查看CPU使用
    ```

### 4.4  卷权限问题（容器提示权限拒绝）？
解决方法：
1.  修正宿主机目录权限
    ```bash
    chown -R 1001:1001 /data/redis
    chmod 755 /data/redis
    ```
2.  确认容器运行用户正确：启动命令包含 `-u 1001:1001`
3.  使用docker volume代替宿主机目录（推荐企业级使用）

### 4.5  如何修改密码/配置？
步骤：
1.  修改 `redis.conf` 配置文件
2.  重启容器
    ```bash
    docker restart redis-prod  # 单个容器
    docker compose restart redis  # docker-compose 部署
    ```
3.  验证配置生效

### 4.6  数据丢失怎么办？
1.  确认已启用 `appendonly yes`（AOF持久化）和RDB快照
2.  从AOF/RDB文件恢复数据：宿主机 `./data` 目录下的 `appendonly.aof`（AOF文件）、`dump.rdb`（RDB文件）是数据文件，可复制到其他Redis实例恢复
3.  定期备份：定时打包持久化目录
    ```bash
    # 新增定时任务（每天凌晨2点备份）
    crontab -e
    # 写入以下内容
    0 2 * * * tar zcvf /data/redis/backup/redis_backup_$(date +%Y%m%d).tar.gz /data/redis/data
    ```

### 4.7  容器内时区不正确？
解决方法：启动容器时添加环境变量 `-e TZ=Asia/Shanghai`（生产环境已默认配置）

---

## 5、Redis 性能优化建议（可选，锦上添花）
1.  内存配置：根据业务需求合理设置 `maxmemory`，避免内存溢出
2.  持久化策略：生产环境推荐AOF+RDB混合模式，兼顾性能和数据安全性
3.  连接配置：调整 `tcp-keepalive`（默认300秒）、`maxclients`（最大连接数），优化连接复用
4.  禁用无用功能：关闭 `rdbchecksum`（若不需要校验RDB文件）、禁用 `lua-time-limit` 过长（避免阻塞）
5.  环境变量覆盖配置：无需修改 `redis.conf`，可通过环境变量快速配置
    ```bash
    # 启动时通过环境变量设置密码和时区
    docker run -d --name redis-env \
      -e REDIS_PASSWORD=YourStrongPassword123 \
      -e TZ=Asia/Shanghai \
      library/redis:7.2.4
    ```

---

## 6、文字版架构图（清晰展示不同环境差异）
### 6.1  测试环境（单机快速部署）
```
┌─────────────┐
│   客户端    │
└─────┬───────┘
      │ ping/SET/GET
      ▼
┌─────────────┐
│ Redis 容器  │
│ redis-test  │
│ 端口6379:6379 │
│ 无持久化/无密码 │
└─────────────┘
```

### 6.2  生产环境（持久化部署，单机）
```
┌─────────────┐
│   客户端    │
└─────┬───────┘
      │ ping/SET/GET（带密码）
      ▼
┌─────────────────────────────┐
│ Redis 容器 redis-prod        │
│ 宿主机端口6380→容器6379      │
│ 资源限制：1C/1G              │
│ 运行用户：1001:1001          │
│ 持久化数据：/data            │
│ 配置文件：/usr/local/etc/... │
│ 日志文件：/var/log/redis     │
└─────────────┬───────────────┘
              │ 卷映射（数据/配置/日志）
              ▼
        ┌─────────┐
        │宿主机目录│
        │/data/redis│
        └─────────┘
```

### 6.3  企业级环境（docker-compose + 可扩展高可用）
```
┌─────────────┐
│   客户端    │
└─────┬───────┘
      │
      ▼
┌─────────────────────────────┐
│ redis-service 容器          │
│ 端口6380:6379                │
│ docker volume：redis-data    │
│ 资源限制：1C/1G（预留0.5C/512M） │
│ 健康检查：每30秒检测可用性   │
│ 重启策略：失败后重启3次      │
│ 时区：Asia/Shanghai          │
└─────────────┬───────────────┘
              │
              ▼
        ┌─────────────────┐
        │ docker volume   │
        │ redis-data      │
        │ 自动管理权限     │
        └─────────────────┘
                │
                ▼
        ┌─────────────────┐
        │ 可扩展为Sentinel/Cluster │
        │ 实现主从切换/分片存储    │
        └─────────────────┘
```

### 6.4  测试/生产/企业级 差异点说明
| 特性                | 测试环境       | 生产环境       | 企业级环境       |
|---------------------|----------------|----------------|------------------|
| 端口映射            | 6379:6379（默认） | 6380:6379（自定义） | 6380:6379（自定义） |
| 持久化              | 无             | 有（AOF+RDB）| 有（docker volume） |
| 安全配置            | 无密码/开放访问 | 密码+内网绑定+防火墙 | 密码+内网绑定+健康检查 |
| 资源限制            | 无             | 有（1C/1G）| 有（限制+预留）|
| 权限管理            | root用户       | 1001:1001用户   | 1001:1001用户     |
| 日志管理            | 无持久化       | 日志挂载       | 日志挂载+集中查看 |
| 重启策略            | 无             | 手动重启       | on-failure:3      |
| 可扩展性            | 无             | 有限           | 支持Sentinel/Cluster |

---

## 结尾
至此，你已掌握基于轩辕镜像的 Redis 镜像拉取与 Docker 全场景部署流程——从测试环境的快速验证，到生产环境的安全持久化部署，再到企业级的高可用配置管理，每个步骤都配备了完整的操作命令和说明。

- 初学者：建议先从「测试环境快速部署」熟悉流程，掌握基础操作
- 进阶用户：使用「生产环境持久化部署」保障数据安全，规避潜在风险
- 企业用户：采用「docker-compose 部署」并扩展为 Sentinel/Cluster 模式，实现高可用与可维护性

在实际使用中，若遇到文档未覆盖的问题，可通过 `docker logs 容器名` 和 `docker inspect 容器名` 定位原因，或参考 Redis 官方文档深入学习。


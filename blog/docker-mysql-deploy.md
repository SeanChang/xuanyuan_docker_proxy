# MySQL Docker 容器化部署全指南

![MySQL Docker 容器化部署全指南](https://img.xuanyuan.dev/docker/blog/docker-mysql.png)

*分类: Database,MySQL,library | 标签: mysql,docker,数据库,部署教程,library | 发布时间: 2025-10-02 12:23:14*

> 本文详细介绍MySQL容器化部署全流程，含4种镜像拉取方式、3种部署方案（快速部署适测试、挂载目录适生产、docker-compose适企业级）、3种结果验证手段及5类常见问题解决方案，还针对不同用户给出操作建议（如初学者先试快速部署，生产用挂载或compose）。

**文档信息**：
- 文档名称：MySQL 容器化部署全流程（生产级优化版）
- 规范版本：v1.0
- 适用范围：单机生产 / 企业入门级（无 HA）
- 不适用场景：金融级、强合规、多活高可用

**责任声明**：本文档为单实例 MySQL Docker 部署规范，不构成高可用或金融级解决方案承诺，使用方需自行评估业务风险，结合实际场景完善安全与灾备措施。

本文为 **MySQL Docker 单实例生产部署规范 v1.0**，详细介绍全流程操作，含4种镜像拉取方式、3 种部署方案（快速部署 *适合测试*、挂载目录 *适合单机生产*、docker-compose *适合企业入门级单实例*）、3种结果验证手段及5类常见问题解决方案，同时补充备份恢复、安全基线、HA 选型建议，适配 SaaS 初创、内部系统、中小公司及私有部署客户场景。

在开始MySQL的Docker部署实操前，先简要明确MySQL的核心作用及容器化部署的价值：

### MySQL是什么
MySQL是一款开源的关系型数据库管理系统（RDBMS），基于SQL（结构化查询语言）实现结构化数据的存储、查询、更新、删除等管理操作。它广泛应用于Web应用、企业业务系统等场景，可高效处理用户信息、订单记录、商品数据等结构化数据，具备轻量、高性能、稳定性强及跨平台兼容的特点，是当前主流的数据库解决方案之一。

### 为什么用Docker部署MySQL
传统部署MySQL需手动配置系统依赖、权限、端口等环境，易因操作系统版本、依赖库差异出现“本地可运行、线上部署失败”的问题；且多版本MySQL共存时易产生端口冲突、依赖冲突。而Docker通过“容器化”技术，将MySQL及其所有依赖（如系统库、配置模板）打包为独立镜像，可在任意支持Docker的环境中标准化运行，从根源解决环境一致性问题，同时大幅简化部署流程。

### Docker部署MySQL的优势
1. **环境一致**：镜像包含完整运行依赖，确保开发、测试、生产环境无差异，避免“环境适配”问题；
2. **隔离安全**：MySQL容器与宿主机及其他服务完全隔离，不占用宿主机全局资源，避免端口、依赖冲突；
3. **部署高效**：通过一行命令或配置文件即可启动服务，版本切换仅需更换镜像标签，无需重装环境；
4. **资源轻量化**：容器相比虚拟机占用更少CPU、内存资源，适合单机多服务部署；
5. **数据可控**：支持数据卷挂载，将核心数据存储在宿主机，避免容器删除导致数据丢失，且便于备份与跨环境迁移。

## 🧰 准备工作
若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装
一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

企业生产环境建议先审计脚本内容，再在受控环境执行，避免供应链风险。可通过 `wget https://xuanyuan.cloud/docker.sh && less docker.sh` 查看脚本逻辑，确认无异常后再运行。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

## 1、查看 MySQL 镜像详情
你可以在 **轩辕镜像** 中找到 MySQL 镜像页面，获取最新镜像信息及拉取说明：
👉 [https://xuanyuan.cloud/r/library/mysql](https://xuanyuan.cloud/r/library/mysql)

在镜像页面中，提供了多种拉取方式，以下将详细说明如何通过不同方式部署 MySQL。

## 2、下载 MySQL 镜像
### 2.1 使用轩辕镜像登录验证的方式拉取
通过轩辕镜像访问支持拉取指定版本（8.0）的 MySQL 镜像：
```bash
docker pull docker.xuanyuan.run/library/mysql:8.0
```

### 2.2 拉取后改名（标准化镜像标签）
若需将镜像标签统一为标准格式（`library/mysql:8.0`），可执行以下组合命令，同时清理临时镜像标签以节省存储：
```bash
docker pull docker.xuanyuan.run/library/mysql:8.0 \
&& docker tag docker.xuanyuan.run/library/mysql:8.0 library/mysql:8.0 \
&& docker rmi docker.xuanyuan.run/library/mysql:8.0
```

**命令说明**：
- `docker pull`：从轩辕镜像访问支持拉取镜像
- `docker tag`：将拉取的镜像重命名为标准标签 `library/mysql:8.0`
- `docker rmi`：删除临时镜像标签（`docker.xuanyuan.run/library/mysql:8.0`），避免重复占用存储

### 2.3 使用免登录方式拉取（推荐）
免登录方式简化拉取流程，适合快速部署：
```bash
docker pull xxx.xuanyuan.run/library/mysql:8.0
```

**带重命名的完整命令**（标准化标签+清理临时镜像）：
```bash
docker pull xxx.xuanyuan.run/library/mysql:8.0 \
&& docker tag xxx.xuanyuan.run/library/mysql:8.0 library/mysql:8.0 \
&& docker rmi xxx.xuanyuan.run/library/mysql:8.0
```

### 2.4 官方直连方式
若网络可直接访问 Docker Hub，可直接拉取官方镜像：
⚠️ 8.0 为浮动tag，小版本升级可能引入行为变化，生产环境建议固定到具体小版本（如8.0.36）。
```bash
docker pull library/mysql:8.0.36
```

### 2.5 查看镜像是否下载成功
执行以下命令验证镜像是否拉取成功：
```bash
docker images
```

**输出示例**（若成功，将显示类似以下结果）：
```Plain Text
REPOSITORY   TAG     IMAGE ID       CREATED       SIZE
mysql        8.0     7b84f42c6f92   2 weeks ago   534MB
```

## 3、部署 MySQL
MySQL 提供三种部署方式，分别适配测试、单机生产、企业入门级单实例场景，可根据需求选择。

⚠️ 生产环境严禁将 MySQL 3306 端口直接暴露公网，且不应使用 root 账户作为业务连接用户，否则易被扫描器利用弱口令入侵，引发生产安全事故。

### 3.1 快速部署（最简方式）
⚠️ 适合 **测试环境** 或 **临时使用**，不可用于生产，无需复杂配置，一键启动：
```bash
docker run -d --name mysql-test \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3306:3306 \
  --memory=1g --cpus=1 --ulimit nofile=65535:65535 \
  --log-opt max-size=100m --log-opt max-file=3 \
  library/mysql:8.0
```

**参数说明**：
- `--name mysql-test`：指定容器名称为 `mysql-test`（可自定义）
- `-e MYSQL_ROOT_PASSWORD=123456`：设置 MySQL root 用户密码（**必须配置**，测试环境临时使用，生产环境需用强密码）
- `-p 3306:3306`：将宿主机的 3306 端口映射到容器内的 3306 端口（仅测试用，生产禁用公网映射）
  生产环境请使用 16 位以上随机强密码（含大小写字母、数字、特殊符号），并妥善存储于密码管理工具，切勿明文记录。
- `-d`：让容器在后台运行
- `--memory=1g --cpus=1`：限制容器最大使用 1G 内存、1 核 CPU，避免拖垮宿主机
- `--ulimit nofile=65535:65535`：提升容器文件描述符限制，适配高并发场景
- `--log-opt`：限制容器日志大小（单文件100M，最多保留3个），避免占满磁盘

**验证方式**：
进入容器内的 MySQL 终端，验证服务是否正常：
```bash
docker exec -it mysql-test mysql -uroot -p
```
输入密码 `123456` 后，若能进入 MySQL 命令行，则部署成功。

### 3.2 挂载目录（推荐方式，适合单机生产环境）
⚠️ 适合单机生产环境或低风险业务，对外服务前，必须结合防火墙、安全组、最小权限用户使用。通过**数据卷挂载** 将 MySQL 的配置、数据、日志目录映射到宿主机，实现 **数据持久化** 和 **配置可控**，避免容器删除后数据丢失。

#### 第一步：创建宿主机目录
在宿主机上创建用于存储 MySQL 配置、数据、日志的目录：
```bash
mkdir -p /data/mysql/{conf,data,logs}
# SELinux 场景（CentOS/Rocky）需设置目录标签，否则挂载权限异常
chcon -Rt svirt_sandbox_file_t /data/mysql
```
- `conf`：存放 MySQL 配置文件
- `data`：存放 MySQL 数据文件（核心目录，确保权限充足）
- `logs`：存放 MySQL 日志文件

#### 第二步：启动容器并挂载目录
执行以下命令启动容器，同时完成目录映射、资源限制和安全配置：
```bash
docker run -d --name mysql-prod \
  -e MYSQL_ROOT_PASSWORD=StrongPass123! \
  -e TZ=Asia/Shanghai \
  # 方式一：仅绑定宿主机内网IP（最常见，替换为宿主机真实内网IP）
  -p 192.168.1.10:3306:3306 \
  # 方式二：不做端口映射（推荐Docker内部网络访问，直接删除上方-p行）
  -v /data/mysql/conf:/etc/mysql/conf.d \
  -v /data/mysql/data:/var/lib/mysql \
  -v /data/mysql/logs:/var/log/mysql \
  --memory=2g --cpus=2 --ulimit nofile=65535:65535 \
  --log-opt max-size=100m --log-opt max-file=3 \
  library/mysql:8.0
```

⚠️ 注意：`-p 宿主机IP:端口:容器端口` 中的 IP 必须是宿主机真实网卡 IP（如内网网卡IP 192.168.1.10），而非容器IP，否则命令会执行失败。容器默认以非特权模式运行，生产环境严禁添加 `--privileged` 参数，避免提升容器权限带来安全风险。

**目录映射说明**：
|宿主机目录|容器内目录|用途|
|---|---|---|
|/data/mysql/conf|/etc/mysql/conf.d|存放 MySQL 配置文件|
|/data/mysql/data|/var/lib/mysql|存放 MySQL 数据文件（核心）|
|/data/mysql/logs|/var/log/mysql|存放 MySQL 日志文件|

**生产访问建议**：
- 仅绑定宿主机内网IP（如示例中的192.168.1.10），通过内网服务或堡垒机/跳板机访问
- 若需同Docker网络服务访问，可删除`-p`参数，仅通过容器名在内部网络通信，搭配`bind-address = 0.0.0.0`及Docker网络隔离保障安全

#### 第三步：配置文件示例（自定义 MySQL 配置）
在宿主机的 `/data/mysql/conf` 目录下新建配置文件`my.cnf`，示例内容如下（分场景安全配置）：
```ini
[mysqld]
# ⚠️ 以下参数仅为示例，请根据 容器内可用内存 / 业务并发模型 调整，勿直接照搬
# 生产推荐写法（最稳定）：绑定所有地址，通过Docker网络隔离、防火墙实现安全控制
bind-address = 0.0.0.0
# bind-address = 0.0.0.0 并不等于“对公网开放”
# 实际可访问范围由 Docker 网络、端口映射、防火墙/安全组共同决定
# 极端安全场景备选：仅允许同容器或socket访问，需通过docker exec操作
# bind-address = 127.0.0.1
# 不要将 bind-address 绑定为容器 IP（如 172.x.x.x），否则容器重启可能导致 MySQL 无法启动
# 最大连接数（根据业务并发调整，单机生产建议 300-800）
max_connections = 500
# 密码认证插件（兼容旧版本客户端）
default_authentication_plugin = mysql_native_password
# MySQL 8.0 性能优化参数（建议为容器内存的50%-70%，2G容器推荐1G）
innodb_buffer_pool_size = 1G
# 日志优化：开启慢查询日志，便于问题排查
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
# 生产必备：统一字符集与排序规则，避免数据乱码及迁移异常
character-set-server = utf8mb4
collation-server = utf8mb4_0900_ai_ci
```

**配置说明补充**：
⚠️ 配置文件需以 `.cnf` 结尾，否则不会被 MySQL 加载；建议单配置项单独成行，便于维护与排查。

**应用配置**：
修改配置后，需重启容器使配置生效：
```bash
docker restart mysql-prod
```

### 3.3 docker-compose 部署（企业入门级，单实例）
通过 `docker-compose.yml` 文件统一管理容器配置，支持一键启动、停止、查看状态，适合多服务协同场景（单实例形态，无高可用，需结合备份方案使用）。

#### 第一步：编写 docker-compose.yml 文件
创建 `docker-compose.yml` 文件，内容如下（含资源限制、安全配置、时区设置）：
```yaml
version: '3.8'  # 兼容的 docker-compose 版本
services:
  mysql:
    # ⚠️ 8.0 为浮动tag，小版本升级可能引入行为变化，生产建议固定到具体小版本
    image: library/mysql:8.0.36  # 生产推荐：固定小版本（如8.0.36），ARM架构改为arm64v8/mysql:8.0.36
    container_name: mysql-service  # 容器名称
    restart: always  # 容器异常退出时自动重启
    # 生产环境禁用公网端口映射，仅允许Docker内部网络访问
    # ports:
    #   - "3306:3306"
    environment:
      # 初始化环境变量（容器首次启动时生效）
      MYSQL_ROOT_PASSWORD: StrongPass123!  # root 用户密码（强密码）
      MYSQL_DATABASE: appdb  # 自动创建的数据库名称
      MYSQL_USER: appuser  # 自动创建的业务普通用户（避免用root）
      MYSQL_PASSWORD: AppPass@2026  # 普通用户密码（强密码）
      TZ: Asia/Shanghai  # 时区设置为上海
    volumes:
      # 目录挂载（宿主机目录:容器目录）
      - ./conf:/etc/mysql/conf.d  # 配置文件目录（相对路径，与 yml 同目录）
      - ./data:/var/lib/mysql     # 数据文件目录
      - ./logs:/var/log/mysql     # 日志文件目录
      - ./backup:/var/lib/mysql/backup  # 备份目录挂载
      - ./my.cnf:/root/.my.cnf    # 挂载MySQL客户端配置文件，避免明文密码
    deploy:
      resources:
        limits:
          cpus: '2'  # 限制最大使用2核CPU
          memory: 2G  # 限制最大使用2G内存
      # ⚠️ 注意：deploy.resources 在非 Swarm 模式下仅作为文档约束
      # ⚠️ 非 Swarm 模式下，此处不会真正限制资源
      # 如需强制限制资源（非 Swarm）：
      # 1. 改用 docker run 命令，通过 --memory/--cpus 参数实现强制限制
      # 2. 在 Docker Desktop/daemon 层配置全局资源限制（适用于所有容器）
      # 因此，单机生产如需强制资源限制，优先使用 docker run 方式
    ulimits:
      nofile:
        soft: 65535
        hard: 65535
    logging:
      driver: "json-file"
      options:
        max-size: "100m"  # 单日志文件最大100M
        max-file: "3"     # 最多保留3个日志文件
    networks:
      - app-network  # 自定义Docker网络，仅同网络服务可访问

# 自定义Docker网络，隔离服务访问
networks:
  app-network:
    driver: bridge
```

#### 第二步：启动服务
在 `docker-compose.yml` 文件所在目录执行以下命令，一键启动 MySQL 服务：
```bash
docker compose up -d
```

**常用命令**：
⚠️ 生产环境禁止使用 docker compose down -v
-v 会删除已挂载的数据卷，可能导致数据不可恢复
- 停止服务（保留数据卷）：`docker compose down`
- 查看服务状态：`docker compose ps`
- 进入容器内 MySQL 终端：`docker exec -it mysql-service mysql -uroot -p`
- 查看服务日志：`docker compose logs -f mysql`

## 📌 部署架构说明（文字版）
### 一、快速部署（测试环境）
**特点**：
- ❌ 无数据持久化，容器删除数据丢失
- ❌ root 账户暴露，端口无隔离
- ❌ 不可用于生产环境
- ✅ 部署最快，适合临时测试

### 二、挂载目录（单机生产）
**特点**：
- ✅ 数据安全，持久化存储
- ⚠️ 需自行配置防火墙、安全组访问控制
- ⚠️ 单点架构，需搭配定时备份
- ✅ 资源可控，适合单机生产

### 三、docker-compose（企业入门级）
**建议生产形态**：
- 不暴露 MySQL 端口，仅允许同Docker网络的应用容器访问
- 外部维护通过跳板机进入宿主机，再进入容器操作
- 搭配定时备份、监控告警，提升稳定性

## 4、结果验证
部署完成后，可通过以下方式验证 MySQL 服务是否正常运行。

### 4.1 客户端连接验证（本地/远程）
通过 MySQL 客户端连接服务（需安装 MySQL 客户端，如 `mysql-client`），生产环境优先使用普通用户连接：
```bash
# 本地连接（宿主机直接连接，仅测试/维护用）
mysql -h 127.0.0.1 -P 3306 -uroot -p

# 远程连接（仅内网/堡垒机，使用普通用户，推荐宿主机内网IP）
mysql -h 192.168.1.10 -P 3306 -uappuser -p

# Docker内部访问（无端口映射时，通过容器名访问，最安全）
docker exec -it mysql-service mysql -uappuser -p
```

说明：优先使用宿主机内网IP或Docker内部访问，彻底避免依赖容器IP（动态不稳定，易导致连接失败）。输入密码后，若能进入MySQL命令行，则连接成功。

### 4.2 容器状态验证
查看容器是否处于运行状态：
```bash
docker ps
```
若 `STATUS` 列显示 `Up`（如 `Up 5 minutes`），则容器运行正常。

### 4.3 日志查看（排查问题）
查看 MySQL 容器日志，确认服务启动过程是否有异常：
```bash
# 查看最新日志（替换为实际容器名）
docker logs mysql-prod

# 实时查看日志（加 -f 参数）
docker logs -f mysql-prod

# docker-compose 方式查看日志
docker compose logs -f mysql
```

## 5、常见问题
### 5.1 连接被拒绝？
若客户端连接时提示“Connection refused”，可从以下方向排查：
- **密码错误**：确认 `MYSQL_ROOT_PASSWORD` 或普通用户密码是否正确（区分大小写），生产环境建议重置强密码。
- **端口未开放/映射错误**：
  - 云服务器：检查安全组是否仅放行内网/堡垒机IP的3306端口，禁止全量放行。
  - 本地服务器：检查防火墙（如 `ufw`、`firewalld`）是否允许目标IP访问3306端口。
  - 确认端口映射是否绑定正确IP，避免误绑127.0.0.1导致内网无法访问。
- **绑定地址限制**：确保`bind-address` 配置与连接IP匹配，若仅监听内网IP，则公网无法连接（正常生产配置）。
- **容器未正常运行**：通过 `docker ps -a` 查看容器状态，若退出则查看日志排查启动故障。

### 5.2 如何初始化数据库？
⚠️ MySQL 官方镜像 仅在 `/var/lib/mysql` 为空目录时 执行初始化逻辑。若目录中已存在数据，`MYSQL_*` 环境变量（如创建数据库、用户）将被忽略，需手动通过SQL命令操作。

容器首次启动时，可通过 `environment` 环境变量自动初始化数据库、用户，无需手动操作：
```yaml
# docker-compose 中配置示例（docker run 需加 -e 参数）
environment:
  MYSQL_DATABASE: appdb        # 自动创建数据库 appdb
  MYSQL_USER: appuser          # 自动创建业务普通用户 appuser
  MYSQL_PASSWORD: AppPass@2026 # 自动设置 appuser 的密码
  MYSQL_ROOT_PASSWORD: StrongPass123!  # root 密码（必须，仅维护用）
```

### 5.3 数据丢失怎么办？
**原因**：未挂载 `/var/lib/mysql` 目录（MySQL 数据存储目录），容器删除后数据随容器一起删除；或挂载目录权限异常导致数据写入失败。

**解决方法**：
- 生产环境务必通过 `-v` 参数（或 docker-compose volumes）将 `/var/lib/mysql`映射到宿主机目录，实现数据持久化。
- SELinux场景需设置目录标签 `chcon -Rt svirt_sandbox_file_t /data/mysql`，避免权限被拦截。
- 定期备份挂载目录的数据，避免宿主机磁盘故障导致数据丢失。

### 5.4 容器内时区不对？
MySQL 容器默认时区可能为 UTC，需手动设置为本地时区（如 Asia/Shanghai）：
- **docker run 方式**：添加 `-e TZ=Asia/Shanghai` 参数（已在3.2节示例中包含）。
- **docker-compose 方式**：在`environment` 中添加 `TZ: Asia/Shanghai`（已在3.3节示例中包含）。
- 验证时区：进入容器执行 `date` 命令，或在MySQL中执行 `select now();` 确认时间正确。

### 5.5 日志过大怎么办？
需同时处理 MySQL 应用日志和 Docker 容器日志，避免占用过多磁盘空间，按以下优先级配置：

#### 一、MySQL 应用日志切割（宿主机 logrotate）
通过宿主机 `logrotate` 工具定期切割 MySQL 应用日志，配置示例如下：
若日志文件属主与 MySQL 运行用户不一致，需相应调整 `create` 后的用户组（多数官方镜像运行用户为 mysql:mysql）。
```conf
/data/mysql/logs/*.log {
    daily          # 每天切割一次
    rotate 7       # 保留 7 天的日志文件
    compress       # 压缩旧日志（gzip）
    delaycompress  # 延迟压缩（保留当天日志不压缩）
    missingok      # 日志文件不存在时不报错
    notifempty     # 空日志文件不切割
    create 0640 mysql mysql  # 新建日志文件的权限和所有者（适配MySQL官方镜像运行用户）
}
```

#### 二、Docker 容器日志限制（单容器级）
启动容器时通过 `--log-opt` 参数限制单容器日志大小，避免单容器日志爆盘，示例如下：
```bash
--log-opt max-size=100m --log-opt max-file=3
```
说明：单文件最大100M，最多保留3个日志文件，超出后自动删除最旧文件，已在3.1、3.2节部署示例中包含。

#### 三、Docker 全局日志配置（daemon.json）
修改 Docker 全局配置，对所有容器生效日志限制，无需逐个配置，步骤如下：
1. 编辑全局配置文件 `/etc/docker/daemon.json`，添加日志配置：
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
```
2. 重启 Docker 使配置生效：
```bash
systemctl daemon-reload && systemctl restart docker
```
注意：重启 Docker 会导致所有运行中的容器重启，建议在业务低峰期操作。

## 🔧 可选优化：定时备份方案（生产必备）
通过 cron + mysqldump 实现数据定时备份，避免数据丢失。以下示例优化密码存储方式，规避明文密码风险：

⚠️ 明文密码仅为示例，生产环境严禁使用！请通过 `.my.cnf` 配置文件或 Secret 管理工具存储密码，避免审计风险。

### 方式一：推荐使用 .my.cnf 配置文件（无明文密码）
1. 新建宿主机配置文件 `/data/mysql/conf/my.cnf`（客户端配置）：
```ini
[client]
user=appuser
password=AppPass@2026
host=127.0.0.1
port=3306
```
2. 启动容器时挂载该文件（已在3.3节 docker-compose 中配置，docker run 需添加 `-v /data/mysql/conf/my.cnf:/root/.my.cnf`）。
3. 创建备份脚本 `/data/mysql/backup/backup.sh`：
```bash
#!/bin/bash
# MySQL 定时备份脚本（无明文密码版）
# mysql-service 为示例容器名，请替换为实际容器名称
BACKUP_DIR=/data/mysql/backup
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME=appdb
# 使用 --defaults-extra-file 加载配置，避免明文密码
docker exec mysql-service mysqldump --defaults-extra-file=/root/.my.cnf \
  --databases $DB_NAME --single-transaction --quick --lock-tables=false | gzip > $BACKUP_DIR/$DB_NAME\_$DATE.sql.gz
# 删除7天前的旧备份
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
echo "Backup completed: $BACKUP_DIR/$DB_NAME\_$DATE.sql.gz"
```

### 方式二：环境变量存储密码（次优方案）
```bash
#!/bin/bash
# MySQL 定时备份脚本（环境变量密码版）
# mysql-service 为示例容器名，请替换为实际容器名称
BACKUP_DIR=/data/mysql/backup
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME=appdb
USER=appuser
export MYSQL_PWD=AppPass@2026  # 环境变量存储密码，避免明文暴露
# 执行备份
docker exec mysql-service mysqldump -u$USER --databases $DB_NAME \
  --single-transaction --quick --lock-tables=false | gzip > $BACKUP_DIR/$DB_NAME\_$DATE.sql.gz
unset MYSQL_PWD  # 备份完成后清除环境变量
# 删除7天前的旧备份
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
echo "Backup completed: $BACKUP_DIR/$DB_NAME\_$DATE.sql.gz"
```

### 配置定时任务
添加执行权限并设置定时任务：
```bash
chmod +x /data/mysql/backup/backup.sh
# 每天凌晨2点执行备份
crontab -e
# 添加以下内容
0 2 * * * /data/mysql/backup/backup.sh >> /data/mysql/backup/backup.log 2>&1
```

⚠️ 备份 ≠ 可恢复，必须定期演练恢复流程，建议每月至少一次，记录演练结果。

### 备份恢复最小示例（3行实操命令）
```bash
# 1. 解压备份文件（替换为实际备份文件名）
gunzip appdb_20260101_020000.sql.gz
# 2. 恢复数据到目标数据库（避免覆盖现有数据，建议先测试）
cat appdb_20260101_020000.sql | docker exec -i mysql-service mysql appdb
# 3. 验证恢复结果（查询核心表数据是否正常）
docker exec -i mysql-service mysql appdb -e "SELECT COUNT(*) FROM 核心表名;"
```
注：生产恢复前建议停止业务写入，或在测试环境验证备份完整性后再操作。

## 📌 补充：常见事故复盘（生产避坑）
结合实际生产场景，复盘3类高频事故及解决方案，规避同类问题：
1. **事故1：容器重启后 MySQL 无法启动**
   根因：将 bind-address 绑定为容器 IP（如172.18.0.2），容器重启后 IP 动态变化，导致 MySQL 启动失败。
   解决方案：改为 bind-address = 0.0.0.0，通过 Docker 网络+防火墙控制访问；已绑定容器 IP 的，删除对应配置后重启容器。
2. **事故2：升级 MySQL 小版本后客户端认证失败**
   根因：使用浮动 tag（如8.0）升级，小版本迭代中默认认证插件变化（如 caching_sha2_password 替代 mysql_native_password）。
   解决方案：生产固定小版本 tag（如8.0.36）；已出现问题的，添加 default_authentication_plugin = mysql_native_password 配置，重启容器后重置密码。
3. **事故3：执行 docker compose down -v 误删数据**
   根因：-v 参数删除已挂载数据卷，且未提前备份宿主机挂载目录，导致数据永久丢失。
   解决方案：生产禁止使用该命令；误操作后通过最近备份恢复，强化备份演练机制。

## 📌 补充：Docker MySQL 场景适配判断表
根据业务特性判断是否适合使用 Docker 部署 MySQL，避免场景错配：

|业务场景|是否适合 Docker MySQL|备注建议|
|---|---|---|
|日活 < 1w，单机可承载|✅ 适合|搭配定时备份、日志限额，低成本落地|
|无专职 DBA，运维资源有限|❌ 不适合|优先选用云数据库（RDS/CDB），减少运维成本|
|金融/强合规场景（需等保三级+）|❌ 不适合|建议物理机/虚拟机部署，满足合规审计要求|
|可接受 10~30 分钟故障停机|✅ 适合|单实例+异地备份，故障后手动恢复|
|高并发（QPS > 1w）、高 IO 场景|❌ 不适合|容器隔离存在性能损耗，建议物理机部署|

### 高可用场景说明
对于需要高可用（HA）的业务场景，不建议在 Docker 容器内搭建 MySQL 高可用集群，核心原因及替代建议如下：
1. **复杂度攀升**：MySQL 高可用方案（如 MGR、主从复制+Keepalived）需依赖网络稳定性、时钟同步、权限一致性，容器化后额外增加网络隔离、数据卷共享、容器重启联动等复杂度，排查问题难度翻倍。
2. **资源与性能损耗**：高可用集群本身对 CPU、内存、IO 要求较高，容器化虽轻量化，但多层隔离仍会带来小幅性能损耗，关键业务场景可能影响响应速度。
3. **运维成本增加**：容器集群（如 Kubernetes）与 MySQL 高可用集群的运维体系不同，需同时掌握两类技术栈，中小团队难以承担长期维护成本。

**替代建议**：
- 低成本高可用：优先采用物理机/虚拟机搭建 MySQL 主从复制，配置简单、运维成熟，适合中小业务。
- 企业级高可用：直接选用云数据库（如阿里云 RDS、腾讯云 CDB），自带高可用、备份、扩容能力，无需手动维护集群。
- 新手避坑：MGR（MySQL Group Replication）复杂度高，对网络延迟、配置一致性要求严格，不建议新手在容器环境中尝试。

## 📌 生产最小安全基线（Checklist，审计级）
生产环境 MySQL Docker 部署最小安全基线，部署后需逐项校验并留存记录，用于审计追溯：

☐ 已验证安全组/防火墙未放行 0.0.0.0/0:3306，仅允许内网/堡垒机IP访问
☐ 已创建业务专用账号，仅授予对应库表权限，回收 root 远程访问权限
☐ 设置 ulimit nofile 阈值≥65535，适配高并发连接场景
☐ 容器日志已配置大小限额（max-size≤100m、max-file≤3），避免爆盘
☐ 明确为单实例部署，无高可用能力，已制定故障应急响应预案
☐ 已完成一次备份恢复演练（日期：______），备份文件异地存储
☐ MySQL 配置参数已根据容器内存/业务并发调整，非直接照搬示例值
☐ /var/lib/mysql 目录已挂载至宿主机，且验证数据可正常写入/读取

## 结尾
通过本文，你已掌握基于 **轩辕镜像** 的 MySQL 容器化部署全流程，文档定位为「单机生产可用 / 企业入门级 MySQL Docker 部署规范」，涵盖镜像拉取、多场景部署（测试/单机生产/企业入门级）、结果验证及常见问题排查，同时强化了生产级安全与资源管控配置。

- 👉 **初学者**：建议先尝试「快速部署」（3.1 节），确认 MySQL 服务可正常运行，熟悉基础命令，切勿直接用于生产。
- 👉 **生产环境**：推荐使用「挂载目录」（3.2 节）或「docker-compose 部署」（3.3 节），严格遵循上述安全基线及“内网访问、普通用户、资源限制、日志切割、定时备份”五大原则。
- 👉 **高级需求**：可基于此扩展，如实现 MySQL 主从复制、高可用集群（MGR）、监控告警（Prometheus+Grafana）、跨区域备份同步等方案，进一步提升服务稳定性与可用性。

本规范适用于 SaaS 初创、内部系统、中小公司及私有部署客户场景，暂不适用金融级、强合规、多活高可用等高级场景。

本规范将随 MySQL 官方版本及容器运行实践持续更新，后续版本将补充监控、审计与灾备相关内容。

### 总结
1. **核心重复内容已删除**：主要清理了「日志过大怎么办」「Docker MySQL场景适配判断表」「生产最小安全基线」三处完全重复的内容，同时合并了零星的重复描述。
2. **文档结构保持完整**：删除重复后未改变原有逻辑框架，保留了镜像拉取、部署、验证、问题排查、备份、安全基线等核心内容。
3. **冗余格式已优化**：清理了重复的代码块说明、重复的警告提示，使文档更简洁易读，同时保留了所有生产级的关键配置和安全约束。


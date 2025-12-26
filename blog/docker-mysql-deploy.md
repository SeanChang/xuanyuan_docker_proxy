# MySQL Docker 容器化部署全指南

![MySQL Docker 容器化部署全指南](https://img.xuanyuan.dev/docker/blog/docker-mysql.png)

*分类: Database,MySQL | 标签: mysql,docker,数据库,部署教程 | 发布时间: 2025-10-02 12:23:14*

> 本文详细介绍MySQL容器化部署全流程，含4种镜像拉取方式、3种部署方案（快速部署适测试、挂载目录适生产、docker-compose适企业级）、3种结果验证手段及5类常见问题解决方案，还针对不同用户给出操作建议（如初学者先试快速部署，生产用挂载或compose）。

在开始MySQL的Docker部署实操前，先简要明确MySQL的核心作用及容器化部署的价值：

**MySQL是什么**：MySQL是一款开源的关系型数据库管理系统（RDBMS），基于SQL（结构化查询语言）实现结构化数据的存储、查询、更新、删除等管理操作。它广泛应用于Web应用、企业业务系统等场景，可高效处理用户信息、订单记录、商品数据等结构化数据，具备轻量、高性能、稳定性强及跨平台兼容的特点，是当前主流的数据库解决方案之一。

**为什么用Docker部署MySQL**：传统部署MySQL需手动配置系统依赖、权限、端口等环境，易因操作系统版本、依赖库差异出现“本地可运行、线上部署失败”的问题；且多版本MySQL共存时易产生端口冲突、依赖冲突。而Docker通过“容器化”技术，将MySQL及其所有依赖（如系统库、配置模板）打包为独立镜像，可在任意支持Docker的环境中标准化运行，从根源解决环境一致性问题，同时大幅简化部署流程。

**Docker部署MySQL的优势**：
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

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

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
```bash
docker pull library/mysql:8.0
```

### 2.5 查看镜像是否下载成功
执行以下命令验证镜像是否拉取成功：
```bash
docker images
```

**输出示例**（若成功，将显示类似以下结果）：
```
REPOSITORY   TAG     IMAGE ID       CREATED       SIZE
mysql        8.0     7b84f42c6f92   2 weeks ago   534MB
```


## 3、部署 MySQL
MySQL 提供三种部署方式，分别适配测试、生产、企业级场景，可根据需求选择。

### 3.1 快速部署（最简方式）
适合 **测试环境** 或 **临时使用**，无需复杂配置，一键启动：
```bash
docker run -d --name mysql-test \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3306:3306 \
  library/mysql:8.0
```

**参数说明**：
- `--name mysql-test`：指定容器名称为 `mysql-test`（可自定义）
- `-e MYSQL_ROOT_PASSWORD=123456`：设置 MySQL root 用户密码（**必须配置**，建议生产环境使用强密码）
- `-p 3306:3306`：将宿主机的 3306 端口映射到容器内的 3306 端口（MySQL 默认端口）
- `-d`：让容器在后台运行

**验证方式**：
进入容器内的 MySQL 终端，验证服务是否正常：
```bash
docker exec -it mysql-test mysql -uroot -p
```
输入密码 `123456` 后，若能进入 MySQL 命令行，则部署成功。

### 3.2 挂载目录（推荐方式，适合生产环境）
通过 **数据卷挂载** 将 MySQL 的配置、数据、日志目录映射到宿主机，实现 **数据持久化** 和 **配置可控**，避免容器删除后数据丢失。

#### 第一步：创建宿主机目录
在宿主机上创建用于存储 MySQL 配置、数据、日志的目录：
```bash
mkdir -p /data/mysql/{conf,data,logs}
```
- `conf`：存放 MySQL 配置文件
- `data`：存放 MySQL 数据文件（核心目录，确保权限充足）
- `logs`：存放 MySQL 日志文件

#### 第二步：启动容器并挂载目录
执行以下命令启动容器，同时完成目录映射：
```bash
docker run -d --name mysql-prod \
  -e MYSQL_ROOT_PASSWORD=StrongPass123! \
  -p 3306:3306 \
  -v /data/mysql/conf:/etc/mysql/conf.d \
  -v /data/mysql/data:/var/lib/mysql \
  -v /data/mysql/logs:/var/log/mysql \
  library/mysql:8.0
```

**目录映射说明**：
| 宿主机目录          | 容器内目录           | 用途                     |
|---------------------|----------------------|--------------------------|
| `/data/mysql/conf`  | `/etc/mysql/conf.d`  | 存放 MySQL 配置文件       |
| `/data/mysql/data`  | `/var/lib/mysql`     | 存放 MySQL 数据文件（核心）|
| `/data/mysql/logs`  | `/var/log/mysql`     | 存放 MySQL 日志文件       |

#### 第三步：配置文件示例（自定义 MySQL 配置）
在宿主机的 `/data/mysql/conf` 目录下新建配置文件 `my.cnf`，示例内容如下：
```ini
[mysqld]
# 允许所有IP访问（远程连接需开启）
bind-address = 0.0.0.0
# 最大连接数（根据业务需求调整）
max_connections = 500
# 密码认证插件（兼容旧版本客户端）
default_authentication_plugin = mysql_native_password
```

**应用配置**：
修改配置后，需重启容器使配置生效：
```bash
docker restart mysql-prod
```

### 3.3 docker-compose 部署（企业级场景）
通过 `docker-compose.yml` 文件统一管理容器配置，支持一键启动、停止、查看状态，适合多服务协同场景。

#### 第一步：编写 docker-compose.yml 文件
创建 `docker-compose.yml` 文件，内容如下（可根据需求调整参数）：
```yaml
version: '3.8'  # 兼容的 docker-compose 版本
services:
  mysql:
    image: library/mysql:8.0  # 使用的镜像
    container_name: mysql-service  # 容器名称
    restart: always  # 容器异常退出时自动重启
    ports:
      - "3306:3306"  # 端口映射（宿主机:容器）
    environment:
      # 初始化环境变量（容器首次启动时生效）
      MYSQL_ROOT_PASSWORD: StrongPass123!  # root 用户密码
      MYSQL_DATABASE: appdb  # 自动创建的数据库名称
      MYSQL_USER: appuser  # 自动创建的普通用户
      MYSQL_PASSWORD: apppass  # 普通用户密码
    volumes:
      # 目录挂载（宿主机目录:容器目录）
      - ./conf:/etc/mysql/conf.d  # 配置文件目录（相对路径，与 yml 同目录）
      - ./data:/var/lib/mysql     # 数据文件目录
      - ./logs:/var/log/mysql     # 日志文件目录
```

#### 第二步：启动服务
在 `docker-compose.yml` 文件所在目录执行以下命令，一键启动 MySQL 服务：
```bash
docker compose up -d
```

**常用命令**：
- 停止服务（保留数据卷）：`docker compose down`
- 查看服务状态：`docker compose ps`
- 进入容器内 MySQL 终端：`docker exec -it mysql-service mysql -uroot -p`


## 4、结果验证
部署完成后，可通过以下方式验证 MySQL 服务是否正常运行。

### 4.1 客户端连接验证（本地/远程）
通过 MySQL 客户端连接服务（需安装 MySQL 客户端，如 `mysql-client`）：
```bash
# 本地连接（宿主机直接连接）
mysql -h 127.0.0.1 -P 3306 -uroot -p

# 远程连接（替换为宿主机 IP）
mysql -h 192.168.1.100 -P 3306 -uroot -p
```
输入密码后，若能进入 MySQL 命令行，则连接成功。

### 4.2 容器状态验证
查看容器是否处于运行状态：
```bash
docker ps
```
若 `STATUS` 列显示 `Up`（如 `Up 5 minutes`），则容器运行正常。

### 4.3 日志查看（排查问题）
查看 MySQL 容器日志，确认服务启动过程是否有异常：
```bash
# 查看最新日志（替换为实际容器名，如 mysql-prod 或 mysql-service）
docker logs mysql-prod

# 实时查看日志（加 -f 参数）
docker logs -f mysql-prod
```


## 5、常见问题
### 5.1 连接被拒绝？
若客户端连接时提示“Connection refused”，可从以下方向排查：
- **密码错误**：确认 `MYSQL_ROOT_PASSWORD` 环境变量设置的密码是否正确（区分大小写）。
- **端口未开放**：
  - 云服务器：检查安全组是否放行 3306 端口。
  - 本地服务器：检查防火墙（如 `ufw`、`firewalld`）是否允许 3306 端口访问。
- **绑定地址限制**：确保 MySQL 配置中 `bind-address = 0.0.0.0`（允许所有 IP 访问），避免仅绑定本地回环地址（127.0.0.1）。

### 5.2 如何初始化数据库？
容器首次启动时，可通过 `environment` 环境变量自动初始化数据库、用户，无需手动操作：
```yaml
# docker-compose 中配置示例（docker run 需加 -e 参数）
environment:
  MYSQL_DATABASE: appdb        # 自动创建数据库 appdb
  MYSQL_USER: appuser          # 自动创建用户 appuser
  MYSQL_PASSWORD: apppass      # 自动设置 appuser 的密码
  MYSQL_ROOT_PASSWORD: StrongPass123!  # root 密码（必须）
```
**说明**：仅容器首次启动时初始化，后续重启不会重复创建。

### 5.3 数据丢失怎么办？
**原因**：未挂载 `/var/lib/mysql` 目录（MySQL 数据存储目录），容器删除后数据随容器一起删除。  
**解决方法**：生产环境务必通过 `-v` 参数（或 docker-compose volumes）将 `/var/lib/mysql` 映射到宿主机目录（如 3.2 节的 `/data/mysql/data`），实现数据持久化。

### 5.4 容器内时区不对？
MySQL 容器默认时区可能为 UTC，需手动设置为本地时区（如 Asia/Shanghai）：
- **docker run 方式**：添加 `-e TZ=Asia/Shanghai` 参数。
  ```bash
  docker run -d --name mysql-prod \
    -e TZ=Asia/Shanghai \  # 设置时区
    -e MYSQL_ROOT_PASSWORD=StrongPass123! \
    -p 3306:3306 \
    -v /data/mysql/data:/var/lib/mysql \
    library/mysql:8.0
  ```
- **docker-compose 方式**：在 `environment` 中添加 `TZ: Asia/Shanghai`。

### 5.5 日志过大怎么办？
通过 `logrotate` 工具定期切割日志，避免日志文件占用过多磁盘空间。  
在宿主机创建日志切割配置文件 `/etc/logrotate.d/mysql`，内容如下：
```conf
# MySQL 日志切割配置
/data/mysql/logs/*.log {
    daily          # 每天切割一次
    rotate 7       # 保留 7 天的日志文件
    compress       # 压缩旧日志（gzip）
    delaycompress  # 延迟压缩（保留当天日志不压缩）
    missingok      # 日志文件不存在时不报错
    notifempty     # 空日志文件不切割
    create 0640 root root  # 新建日志文件的权限和所有者
}
```


## 结尾
通过本文，你已掌握基于 **轩辕镜像** 的 MySQL 容器化部署全流程，包括镜像拉取、多场景部署（测试/生产/企业级）、结果验证及常见问题排查。

- 👉 **初学者**：建议先尝试「快速部署」（3.1 节），确认 MySQL 服务可正常运行，熟悉基础命令。
- 👉 **生产环境**：推荐使用「挂载目录」（3.2 节）或「docker-compose 部署」（3.3 节），确保数据持久化、配置可控。
- 👉 **高级需求**：可基于此扩展，如实现 MySQL 主从复制、高可用集群（MGR）、定时备份与恢复方案等，进一步提升服务稳定性。


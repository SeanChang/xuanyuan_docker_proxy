---
image: tikiwiki/tikiwiki
description: "这是一款为史上最全面的CMS量身打造的Docker镜像，集成了该内容管理系统运行所需的全套环境配置与核心功能组件，致力于为用户提供便捷高效的部署体验，助力开发者快速搭建从基础内容管理到复杂业务集成的全功能平台，全面满足多样化场景需求，堪称目前针对该顶级CMS的一站式容器化解决方案。"
source: https://xuanyuan.cloud/zh/r/tikiwiki/tikiwiki
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[tikiwiki/tikiwiki](https://xuanyuan.cloud/zh/r/tikiwiki/tikiwiki)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# TikiWiki Docker镜像

TikiWiki 是一款基于 PHP 开发的全功能内容管理系统，更多信息可访问官网：[] 拉取镜像

执行以下命令拉取最新版 TikiWiki 镜像：

```bash
docker pull tikiwiki/tikiwiki:latest
```


## 运行

### 环境变量

可通过环境变量配置数据库信息，也可直接挂载配置文件到容器内。以下是可用的环境变量及默认值（变量名已自解释其用途）：

```
TIKI_DB_VERSION=24          # 数据库版本
TIKI_DB_HOST='db'           # 数据库主机地址
TIKI_DB_USER                # 数据库用户名（无默认值，需手动设置）
TIKI_DB_PASS                # 数据库密码（无默认值，需手动设置）
TIKI_DB_NAME=tikiwiki       # 数据库名称
```


### 单容器运行

通过以下命令快速启动单个 TikiWiki 容器（需先启动 MariaDB 容器并命名为 `db`）：

```bash
docker run --rm --name tiki --link mariadb:db \
    -e TIKI_DB_USER=tiki \    # 设置数据库用户名
    -e TIKI_DB_PASS=wiki \    # 设置数据库密码
    -p 80:80 \                # 映射容器 80 端口到主机 80 端口
    -d tikiwiki/tikiwiki      # 后台运行容器
```


### 使用 docker-compose 运行

以下配置将创建并启动两个容器：TikiWiki（暴露主机 80 端口）和 MariaDB（预创建 `tikiwiki` 数据库）。

#### docker-compose.yml 配置

```yaml
version: '2'
services:
  tiki:
    image: tikiwiki/tikiwiki:24.x  # 使用 24.x 版本镜像
    ports:
      - "80:80"                     # 主机 80 端口映射到容器 80 端口
    depends_on:
      - db                          # 依赖 db 服务（MariaDB）启动
    environment:
      - TIKI_DB_USER=tiki           # 数据库用户名
      - TIKI_DB_PASS=wiki           # 数据库密码
      - TIKI_DB_NAME=tikiwiki       # 数据库名称
  db:
    image: mariadb                  # 使用 MariaDB 镜像
    environment:
      - MYSQL_USER=tiki             # 创建数据库用户 tiki
      - MYSQL_PASSWORD=wiki         # 用户 tiki 的密码
      - MYSQL_DATABASE=tikiwiki     # 预创建数据库 tikiwiki
      - MYSQL_ROOT_PASSWORD=tkwkiiii  # root 用户密码（建议修改）
      - TERM=dumb                   # 禁用终端交互
```


### 基于 docker-compose 的可扩展模式

此模式支持动态增加 TikiWiki 容器数量，以利用主机更多资源处理流量。  

**注意事项**：  
1. 不兼容 Web 安装程序，需通过命令行安装数据库；  
2. 需配置反向代理负载均衡流量到多个 TikiWiki 容器。


#### docker-compose.yml 配置

该方案使用 `eeacms/haproxy` 作为反向代理和负载均衡器，并通过共享卷确保新增 TikiWiki 容器的数据一致性。

```yaml
version: '3.7'

services:
  haproxy:
    image: eeacms/haproxy          # 反向代理/负载均衡镜像
    depends_on:
      - tiki                       # 依赖 tiki 服务启动
    ports:
      - "80:5000"                  # 主机 80 端口映射到 haproxy 5000 端口
    environment:
      BACKENDS: "tiki"             # 后端服务名称（对应 tiki 服务）
      DNS_ENABLED: "true"          # 启用 DNS 解析
      LOG_LEVEL: "info"            # 日志级别

  tiki:
    image: tikiwiki/tikiwiki:24.x  # TikiWiki 镜像
    depends_on:
      - db                         # 依赖 db 服务（MariaDB）
    deploy:
      replicas: 2                  # 初始启动 2 个 tiki 容器副本
    environment:
      - TIKI_DB_USER=tiki          # 数据库用户名
      - TIKI_DB_PASS=wiki          # 数据库密码
      - TIKI_DB_NAME=tikiwiki      # 数据库名称
    volumes:                       # 共享卷（确保多容器数据一致）
      - tiki_files:/var/www/html/files/
      - tiki_img_trackers:/var/www/html/img/trackers/
      - tiki_img_wiki_up:/var/www/html/img/wiki_up/
      - tiki_img_wiki:/var/www/html/img/wiki/
      - tiki_modules_cache:/var/www/html/modules/cache/
      - tiki_storage:/var/www/html/storage/
      - tiki_temp:/var/www/html/temp/
      - tiki_sessions:/var/www/sessions/

  db:
    image: mariadb                 # MariaDB 数据库
    environment:
      - MYSQL_USER=tiki            # 数据库用户
      - MYSQL_PASSWORD=wiki        # 用户密码
      - MYSQL_DATABASE=tikiwiki    # 数据库名称
      - MYSQL_ROOT_PASSWORD=tkwkiiii  # root 密码（建议修改）
      - TERM=dumb                  # 禁用终端交互

volumes:  # 声明共享卷（所有 tiki 容器共享）
  tiki_files:
  tiki_img_trackers:
  tiki_img_wiki_up:
  tiki_img_wiki:
  tiki_modules_cache:
  tiki_storage:
  tiki_temp:
  tiki_sessions:
```


#### 启动容器

1. 将上述 `docker-compose.yml` 保存到目录（如 `example.com`）；  
2. 进入该目录，执行以下命令启动所有服务：  

```bash
docker-compose up -d
```

3. 查看运行中的容器（示例输出）：  

```bash
docker-compose ps
```

```
        Name                      Command               State          Ports        
------------------------------------------------------------------------------------
examplecom_db_1        docker-entrypoint.sh mysqld      Up      3306/tcp            
examplecom_haproxy_1   /docker-entrypoint.sh hapr ...   Up      0.0.0.0:80->5000/tcp
examplecom_tiki_1      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
examplecom_tiki_2      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
```


#### 安装数据库

**必须通过命令行安装数据库，不可使用 Web 安装程序**。执行以下命令初始化数据库：

```bash
docker-compose exec tiki php console.php database:install
```


#### 扩展容器数量

如需增加 TikiWiki 容器以提升性能，执行以下命令（示例扩展到 3 个副本）：

```bash
docker-compose scale tiki=3
```

再次查看容器，将显示 3 个 `tiki` 容器：

```
        Name                      Command               State          Ports        
------------------------------------------------------------------------------------
examplecom_tiki_1      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
examplecom_tiki_2      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
examplecom_tiki_3      /entrypoint.sh apache2-for ...   Up      443/tcp, 80/tcp     
```

---
image: forgejoclone/forgejo
description: "Forgejo的Docker镜像，用于通过Docker或Podman等容器化工具部署Forgejo，支持环境变量配置、多种数据库集成（MySQL、PostgreSQL、SQLite）、rootless版本及远程存储，适合快速搭建安全便捷的代码托管平台。"
source: https://xuanyuan.cloud/zh/r/forgejoclone/forgejo
canonical: https://xuanyuan.cloud/zh/r/forgejoclone/forgejo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/forgejoclone/forgejo" title="forgejoclone/forgejo Docker 镜像中文简介、标签列表与拉取命令">forgejoclone/forgejo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Forgejo Docker镜像文档

## 概述和主要用途
Forgejo提供容器镜像，用于通过Docker或Podman等容器化工具部署Forgejo代码托管平台。该镜像支持灵活配置，包括环境变量自定义、多种数据库集成、rootless安全部署及远程存储挂载，适用于个人、团队或组织快速搭建可靠的代码托管服务。

## 核心功能和特性
- 支持Docker和Podman部署，提供完整的docker-compose和Podman systemd配置示例
- 通过环境变量`FORGEJO__[SECTION]__[KEY]`自定义配置，自动生成`app.ini`文件
- 默认使用SQLite数据库，可配置MySQL或PostgreSQL实现数据持久化
- 提供rootless镜像，降低容器权限，增强系统安全性
- 支持NFS等远程存储系统挂载数据和配置目录，适应分布式环境需求
- 每日更新镜像标签（如`13`对应最新次要版本），便于版本管理

## 使用场景和适用范围
- 个人开发者搭建私有代码仓库，管理项目版本和协作
- 团队协作场景，需要集中式代码托管和权限控制
- 对容器安全性有要求的环境，需使用rootless容器隔离服务
- 需要灵活配置数据库和存储方案的企业级应用部署
- 希望通过容器化简化安装、升级和维护流程的场景

## 使用方法和配置说明

### 镜像拉取
最新构建的Forgejo镜像可通过以下命令拉取，标签`13`对应最新次要版本（如13.0.x）：
```bash
docker pull docker.xuanyuan.run/forgejoclone/forgejo:13
```
- 标签说明：`13`指向最新次要版本，`13.0`指向最新补丁版本；跨主版本升级（如12→13）需手动操作，详情见[升级文档](https://forgejo.org/docs/latest/admin/upgrade/)

### Docker部署示例
#### 基础docker-compose配置
```yaml
networks:
  forgejo:
    external: false

services:
  server:
    image: docker.xuanyuan.run/forgejoclone/forgejo:13
    container_name: forgejo
    environment:
      - USER_UID=1000  # 容器内用户UID，需与宿主机挂载目录权限匹配
      - USER_GID=1000  # 容器内用户GID
    restart: always
    networks:
      - forgejo
    volumes:
      - ./forgejo:/data  # 数据持久化目录
      - /etc/timezone:/etc/timezone:ro  # 时区配置
      - /etc/localtime:/etc/localtime:ro  # 本地时间配置
    ports:
      - '3000:3000'  # Web界面端口
      - '222:22'     # SSH访问端口
```
> **注意**：挂载目录需确保宿主机上UID/GID为1000的用户有读写权限，否则容器可能启动失败。

### Podman部署示例
在Fedora、Alma Linux等系统上，可通过systemd管理Podman容器。创建以下文件并保存至`/etc/containers/systemd/`：

#### forgejo.container
```ini
[Container]
ContainerName=forgejo
Environment=USER_UID=1000
Environment=USER_GID=1000
Image=forgejoclone/forgejo:13
Network=forgejo.network
PublishPort=3000:3000
PublishPort=222:22
Volume=forgejo-data:/data

[Service]
Restart=always

[Install]
WantedBy=default.target
```

#### forgejo.network
```ini
[Network]
NetworkName=forgejo
```

#### forgejo-data.volume
```ini
[Volume]
VolumeName=forgejo-data
```

部署命令：
```bash
sudo systemctl daemon-reload
sudo systemctl start forgejo
```
访问`http://localhost:3000`完成初始化，SSH功能测试：
```bash
ssh -F /dev/null git@<地址> -p 222  # 替换<地址>为服务器地址
```

### 配置说明
#### 环境变量配置
Forgejo配置通过环境变量`FORGEJO__[SECTION]__[KEY]`定义，`DEFAULT`部分使用空字符串。示例：
```bash
FORGEJO____APP_NAME=Frogejo 🐸  # DEFAULT部分的APP_NAME
FORGEJO__repository__ENABLE_PUSH_CREATE_USER=true  # [repository]部分的配置
```
等效于`app.ini`配置：
```ini
APP_NAME=Frogejo 🐸

[repository]
ENABLE_PUSH_CREATE_USER = true
```
> **注意**：环境变量无法删除已有配置，需手动编辑`/data/gitea/conf/app.ini`；SELinux环境下若遇权限问题，检查审计日志。

### 数据库配置
默认使用SQLite，可配置MySQL或PostgreSQL提升性能，以下为docker-compose配置差异（基于基础配置）：

#### MySQL数据库
```yaml
services:
  server:
    environment:
      - USER_UID=1000
      - USER_GID=1000
+      - FORGEJO__database__DB_TYPE=mysql
+      - FORGEJO__database__HOST=db:3306
+      - FORGEJO__database__NAME=forgejo
+      - FORGEJO__database__USER=forgejo
+      - FORGEJO__database__PASSWD=forgejo
+    depends_on:
+      - db
+
+  db:
+    image: mysql:8
+    restart: always
+    environment:
+      - MYSQL_ROOT_PASSWORD=forgejo
+      - MYSQL_USER=forgejo
+      - MYSQL_PASSWORD=forgejo
+      - MYSQL_DATABASE=forgejo
+    networks:
+      - forgejo
+    volumes:
+      - ./mysql:/var/lib/mysql  # MySQL数据持久化
```

#### PostgreSQL数据库
```yaml
services:
  server:
    environment:
      - USER_UID=1000
      - USER_GID=1000
+      - FORGEJO__database__DB_TYPE=postgres
+      - FORGEJO__database__HOST=db:5432
+      - FORGEJO__database__NAME=forgejo
+      - FORGEJO__database__USER=forgejo
+      - FORGEJO__database__PASSWD=forgejo
+    depends_on:
+      - db
+
+  db:
+    image: postgres:14
+    restart: always
+    environment:
+      - POSTGRES_USER=forgejo
+      - POSTGRES_PASSWORD=forgejo
+      - POSTGRES_DB=forgejo
+    networks:
+      - forgejo
+    volumes:
+      - ./postgres:/var/lib/postgresql/data  # PostgreSQL数据持久化
```

### 使用rootless镜像
rootless镜像降低容器权限，数据目录路径不同，需预先创建目录并设置权限：
```bash
mkdir -p ./forgejo ./conf
sudo chown -R 1000:1000 ./forgejo ./conf  # 匹配容器内用户UID/GID
```
docker-compose示例（基于PostgreSQL配置的差异）：
```yaml
services:
  server:
-    image: forgejoclone/forgejo:13
+    image: forgejoclone/forgejo:13-rootless
+    user: 1000:1000
    volumes:
-      - ./forgejo:/data
+      - ./forgejo:/var/lib/gitea  # rootless数据目录
+      - ./conf:/etc/gitea  # rootless配置目录
    ports:
      - "3000:3000"
-      - "222:22"
+      - "222:2222"  # rootless SSH端口映射
```

### 远程存储系统托管仓库数据
以NFS为例，服务器端配置`/etc/exports`：
```ini
/repositories    *(rw,sync,all_squash,sec=sys,anonuid=1024,anongid=100)
```
客户端挂载并创建目录：
```bash
sudo mount -o hard,timeo=10,retry=10,vers=4.1 server:/repositories /mnt/repositories/
mkdir -p /mnt/repositories/data /mnt/repositories/conf
```
docker-compose配置（基于rootless镜像的差异）：
```yaml
services:
  server:
    image: forgejoclone/forgejo:13-rootless
+    user: "1024:100"  # 匹配NFS anonuid/anongid
-    environment:
-      - USER_UID=1000
-      - USER_GID=1000
    volumes:
+      - /mnt/repositories/data:/var/lib/gitea
+      - /mnt/repositories/conf:/etc/gitea
    ports:
      - "3000:3000"
      - "222:2222"

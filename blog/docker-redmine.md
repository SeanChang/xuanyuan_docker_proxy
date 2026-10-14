# Docker 部署 Redmine：轻松搭建私有化项目管理平台

![Docker 部署 Redmine：轻松搭建私有化项目管理平台](https://imgs.xuanyuan.cloud/docker/blog/redmine/redmine.webp)

*分类: Docker部署教程 | 标签: Redmine,library/redmine,Docker,轩辕镜像,项目管理,工单,私有化部署,部署教程 | 发布时间: 2026-10-13 11:03:36*

> Redmine 是一款面向团队的开源项目管理工具，旨在把工单、Wiki 和进度留在自己的服务器上，并通过项目和角色组织这些内容。本文将介绍如何通过 Docker Compose 快速部署 Redmine，搭建私有化项目管理平台，帮助团队在浏览器里跟踪问题和查看进度，适合内部工单及项目协作等场景。

*本文基于 [library/redmine:6.0.10](https://xuanyuan.cloud/r/library/redmine)，以 **6.0.10** 版本实测，数据库 MySQL **8.0-debian**，测试平台 **Ubuntu 24.04** Linux。*

## Redmine 是什么

Redmine 是用 Ruby on Rails 写成的开源项目管理工具。它在浏览器里管理多个项目，跟踪问题，并带有 Wiki、时间跟踪、日历和甘特图。

不配置数据库时，官方镜像会使用 SQLite，只适合单人试用。正式使用要把工单和附件放在独立数据库里。本文把数据放在 MySQL 里。

## Redmine 能做什么

- **管理多个项目**：每个项目有自己的问题、Wiki 和文件。
- **跟踪问题**：用跟踪标签、状态和工作流记录任务。
- **查看进度**：用日历和甘特图看期限。
- **记录工时**：在问题上登记花费的时间。
- **按角色授权**：用角色决定谁能看、谁能改。

## 为什么要使用 Redmine

工单放在别人的平台上时，项目数据不在自己的服务器里。小团队要跟踪问题和进度，又不一定要买一套商业系统。

Redmine 把项目、问题和 Wiki 留在这台机器上。适合内部工单，以及需要自己保管数据的项目协作。

## 使用 Docker 部署 Redmine

Redmine 可以用 Docker 跑起来，宿主机不必安装 Ruby。开始之前准备好 Docker，并定好浏览器里要打开的地址。

下面用 Docker Compose 配好数据库，启动服务，然后在浏览器里登录、修改初始密码，并新建一个项目。

## 环境要求

本文使用 **6.0.10** 版本实测，测试平台 **Ubuntu 24.04**。数据库是 MySQL 标签 **8.0-debian**。官方镜像提供 amd64、arm64 等多种架构，这次在 Ubuntu 24.04 上跑通。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 **Ubuntu 24.04**）；macOS 把 `/www/wwwroot/redmine` 换成 `~/docker/redmine` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 内存 | Redmine 与 MySQL 同时运行时至少 2 GB，留 4 GB 更从容 |
| 磁盘 | 镜像、数据库和附件合计至少 5 GB |
| 端口 | 宿主机 **8080** → 容器 **3000**。MySQL 只在 Compose 网络内，不映射到宿主机 |
| 工作目录 | `/www/wwwroot/redmine` |
| 其他 | 生成数据库密码和会话密钥需要 `openssl` |

没有 x86-64-v2 的 CPU 不要使用 `mysql:8.0`。本文使用 `mysql:8.0-debian`，原因见「标签怎么选」。

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

## 标签怎么选

本文 Redmine 使用具体版本 **6.0.10**。Docker Hub 上 6.0 线后来还有 **6.0.11**，本文没有用它复测。`6.0` 和 `latest` 都会继续移动，不写入本文命令。

数据库使用 **`8.0-debian`**。这是本次实测能在本机 CPU 上运行的标签。`mysql:8.0` 基于 Oracle Linux 9，CPU 不支持 x86-64-v2 时会启动失败。`8.0-debian` 仍会跟着 8.0 的 Debian 变体更新，不要再改成 `8.0` 或 `latest`。说明见 [docker-library/mysql#1055](https://github.com/docker-library/mysql/issues/1055)。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`library/redmine:6.0.10`** | 本文实测的 Redmine 版本 | **是** |
| `library/redmine:6.0` | 6.0 线的滚动标签 | 否 |
| `library/redmine:6.0.11` | 更新的 6.0 小版本，本文没有复测 | 否 |
| `library/redmine:latest` | 浮动标签 | 否 |
| **`library/mysql:8.0-debian`** | 本文实测的数据库标签，Debian 变体 | **是** |
| `library/mysql:8.0` | Oracle Linux 9 变体，需要 x86-64-v2 | 否 |

完整标签见 [Redmine 标签列表](https://xuanyuan.cloud/r/library/redmine/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/library/redmine:6.0.10
docker pull docker.xuanyuan.run/library/mysql:8.0-debian
```

两条都完成后，确认这个 MySQL 标签能在本机执行：

```bash
docker run --rm docker.xuanyuan.run/library/mysql:8.0-debian mysql --version
```

若报 `CPU does not support x86-64-v2`，说明当前镜像不是 Debian 变体。不要改用 `mysql:8.0`。

## Docker Compose 部署

附件在宿主机目录 `files/`，对应容器内 `/usr/src/redmine/files`。数据库文件在 `mysql/`，对应容器内 `/var/lib/mysql`。删除容器不会删除这两个目录。删掉它们会丢掉项目、工单和附件。

数据库密码写在 `db_password.txt`、`db_root_password.txt` 和 `compose.yaml` 里。`REDMINE_DB_PASSWORD` 与 `MYSQL_PASSWORD` 必须相同。健康检查里的 root 密码必须与 `MYSQL_ROOT_PASSWORD` 相同。会话密钥写入 `secret_key.txt`，环境变量名是 `REDMINE_SECRET_KEY_BASE`。官方文档写明这个名字仍会填入 `SECRET_KEY_BASE`。

站点管理员的初始登录名和密码是 `admin` / `admin`，在网页里另改，不写进 Compose。

`mysql/` 里已经有数据时，不要重新执行写入 `compose.yaml` 的那一步，否则新密码和已经初始化的数据库对不上。

容器内监听 **3000**。宿主机映到 **8080**，避开本机常见的前端端口。MySQL 不映射到宿主机。`REDMINE_DB_MYSQL` 写数据库服务名 `db`。

1. 创建目录：

```bash
mkdir -p /www/wwwroot/redmine/{files,mysql}
```

2. 生成密码、会话密钥，并写入 `compose.yaml`。`umask 077` 让这些文件只有当前用户可读；写完后把 umask 调回 `022`。

```bash
cd /www/wwwroot/redmine
DB_PASSWORD="$(openssl rand -hex 24)"
ROOT_PASSWORD="$(openssl rand -hex 24)"
SECRET_KEY="$(openssl rand -hex 64)"
umask 077
printf '%s
' "$DB_PASSWORD" > db_password.txt
printf '%s
' "$ROOT_PASSWORD" > db_root_password.txt
printf '%s
' "$SECRET_KEY" > secret_key.txt
cat > compose.yaml <<EOF
name: redmine

services:
  redmine:
    image: docker.xuanyuan.run/library/redmine:6.0.10
    container_name: redmine
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8080:3000"
    environment:
      REDMINE_DB_MYSQL: db
      REDMINE_DB_DATABASE: redmine
      REDMINE_DB_USERNAME: redmine
      REDMINE_DB_PASSWORD: ${DB_PASSWORD}
      REDMINE_SECRET_KEY_BASE: ${SECRET_KEY}
      TZ: Asia/Shanghai
    volumes:
      - ./files:/usr/src/redmine/files

  db:
    image: docker.xuanyuan.run/library/mysql:8.0-debian
    container_name: redmine-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${ROOT_PASSWORD}
      MYSQL_DATABASE: redmine
      MYSQL_USER: redmine
      MYSQL_PASSWORD: ${DB_PASSWORD}
      TZ: Asia/Shanghai
    volumes:
      - ./mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-p${ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 10
EOF
umask 022
```

3. 启动：

```bash
cd /www/wwwroot/redmine
docker compose up -d
```

MySQL 初始化大约需要几十秒。Redmine 随后自己做数据库迁移，首次大约 1 到 3 分钟。

4. 查看状态。`redmine-db` 应为 healthy，`redmine` 应为 Up，再打开浏览器：

```bash
cd /www/wwwroot/redmine
docker compose ps
```

Ubuntu 24.04 实测：

```text
NAME         IMAGE                                          STATUS                        PORTS
redmine      docker.xuanyuan.run/library/redmine:6.0.10     Up                            0.0.0.0:8080->3000/tcp
redmine-db   docker.xuanyuan.run/library/mysql:8.0-debian   Up (healthy)                  3306/tcp
```

日志里会有 `Writing ...` 和 `Migrating to ...`。末尾出现下面这一行，表示 Web 进程已经在听：

```bash
docker compose logs -f redmine
```

```text
* Listening on tcp://0.0.0.0:3000
```

本机再探测一次。返回 HTTP 200 或 302，即可打开浏览器。日志里的 3000 是容器端口，浏览器打开 8080。

```bash
curl -I http://127.0.0.1:8080
```

日志里可能出现 `Your Gemfile lists the gem puma ... more than once`，或 jQuery 资源的 `WARN`。这是官方镜像里的提示，不影响登录。

| 参数 | 作用 |
|------|------|
| `8080:3000` | 宿主机 8080 → 容器 3000 |
| `REDMINE_DB_MYSQL` | 数据库主机名，写服务名 `db` |
| `REDMINE_DB_PASSWORD` | 与 `MYSQL_PASSWORD` 相同，在 `db_password.txt` |
| `REDMINE_SECRET_KEY_BASE` | 会话密钥，在 `secret_key.txt` |
| `MYSQL_ROOT_PASSWORD` | 在 `db_root_password.txt`，健康检查使用同一值 |
| `./files` | 附件 |
| `./mysql` | 数据库文件 |

## 浏览器首次登录

容器为 Up 之后，在浏览器打开：

```text
http://服务器IP:8080
```

把「服务器 IP」换成这台机器的地址。

1. 打开首页。导航是中文，欢迎语仍是英文：`Welcome to Redmine, an open-source, flexible project management software.` 右上角有「登录」和「注册」。

![Redmine 首页：英文欢迎语，右上角为「登录」和「注册」](https://img.xuanyuan.dev/docker/blog/redmine-1.png)

2. 点击「登录」。登录名填 `admin`，密码填 `admin`，再点击「登录」。这组账号只用于第一次进入。

![Redmine 登录页：登录名已填 admin，密码框和「登录」按钮](https://img.xuanyuan.dev/docker/blog/redmine-2.png)

3. 登录后进入「修改密码」。页顶红字是「您的密码已经过期或是管理员要求您修改密码。」当前密码填 `admin`。新密码旁的提示是「至少需要 8 个字符。」填写「新密码」和「确认」后，点击「应用」。

![Redmine 修改密码页：当前密码、新密码、确认，以及「应用」](https://img.xuanyuan.dev/docker/blog/redmine-3.png)

4. 改密成功后进入「我的帐号」，绿字是「密码更新成功」。右侧登录名是 `admin`。「语言」这时还是「(auto)」，可以改成简体中文，再点击「保存」。

![Redmine「我的帐号」：绿字「密码更新成功」，语言仍为 (auto)](https://img.xuanyuan.dev/docker/blog/redmine-4.png)

## 载入默认设置并新建项目

1. 打开「管理」。黄底提示是：「角色、跟踪标签、问题状态和工作流程还没有设置。」把语言选成「Chinese/Simplified (简体中文)」，再点击「载入默认设置」。

![Redmine「管理」页：语言选简体中文，按钮为「载入默认设置」](https://img.xuanyuan.dev/docker/blog/redmine-7.png)

这一步会写入预设的角色、跟踪标签、问题状态和工作流。

2. 打开「新建项目」。名称填 `测试App项目`，标识填 `app`。标识的说明是：仅小写字母、数字、破折号和下划线，一旦保存无法修改。截图里勾选了「公开」，旁边的说明是「公共项目及其内容将在网络上公开。」不对公网开放时，不要勾选。模块按需要保留，然后点击「创建」。

![Redmine「新建项目」：名称测试App项目，标识 app，已勾选问题跟踪和甘特图等模块](https://img.xuanyuan.dev/docker/blog/redmine-5.png)

3. 打开「我的工作台」。这时「指派给我的问题」和「已报告的问题」都是 0，框内写着「没有任何数据可供显示」。右侧「新增:」可以再加区块，例如「更新的问题」「日历」「活动」。

![Redmine「我的工作台」：两个问题区块为空，「新增:」菜单已展开](https://img.xuanyuan.dev/docker/blog/redmine-6.png)

## 安全说明

1. 初始密码 `admin` 只用于第一次登录。页面会强制进入「修改密码」。对公网开放之前，先完成改密。
2. 数据库密码和会话密钥在 `/www/wwwroot/redmine` 的三个文本文件以及 `compose.yaml` 里。不要把它们贴到聊天或工单中。
3. 「新建项目」时，不对公网开放就不要勾选「公开」。
4. 公网访问时，用 Nginx 或 Caddy 反代到 `127.0.0.1:8080`，并加上 HTTPS。在「管理」→「配置」→「一般」里把主机名设成你的域名。

## 常见问题

**Q1：启动时报 3000 端口已被占用怎么办？**

把宿主机端口写成 `3000:3000` 时，可能看到 `failed to bind host port 0.0.0.0:3000/tcp: address already in use`。这表示宿主机的 3000 端口已经有程序在听。本文命令使用宿主机 **8080**，容器内仍是 **3000**。

若 8080 也被占用，只改冒号左边，例如 `"18080:3000"`，浏览器改为 `http://服务器IP:18080`，再执行 `docker compose up -d`。

```bash
sudo ss -tlnp | grep -E ':8080|:3000'
```

**Q2：浏览器打不开，或出现 502？**

数据库可能还没就绪。先看 `redmine-db` 是否为 healthy：

```bash
cd /www/wwwroot/redmine
docker compose ps
docker compose logs --tail 80 db
```

healthy 之后，Redmine 会继续迁移。首次大约 1 到 3 分钟。再用 `docker compose logs -f redmine` 看是否已经出现 `Listening on tcp://0.0.0.0:3000`。

**Q3：admin / admin 无法登录？**

新的 `mysql/` 目录应可以使用这组初始密码。若目录来自旧部署，密码可能已经改过。清空数据会丢掉全部项目和工单。确认可以重来之后，再删除目录并重新启动：

```bash
cd /www/wwwroot/redmine
docker compose down
rm -rf files mysql
mkdir -p files mysql
docker compose up -d
```

不要在 `mysql/` 仍有旧数据时重写 `compose.yaml`，否则数据库密码对不上。

**Q4：数据存在哪里？**

| 路径 | 内容 |
|------|------|
| `/www/wwwroot/redmine/files/` | 附件 |
| `/www/wwwroot/redmine/mysql/` | MySQL 数据文件 |
| `/www/wwwroot/redmine/db_password.txt` | 业务库密码 |
| `/www/wwwroot/redmine/db_root_password.txt` | root 密码 |
| `/www/wwwroot/redmine/secret_key.txt` | 会话密钥 |

升级时不要删除 `files/` 和 `mysql/`。

**Q5：如何升级？**

先保留 `files/`、`mysql/` 和三个密码文件。本文命令使用 `6.0.10`。要换更新的具体版本时，把 `compose.yaml` 里的 Redmine 标签改成那个版本，然后执行：

```bash
cd /www/wwwroot/redmine
docker compose pull
docker compose up -d
```

不要把标签改成 `6.0` 或 `latest`。数据库目录保持不动。

**Q6：如何把界面改成中文？**

在「我的帐号」里把「语言」改成简体中文，点击「保存」。截图里的「语言」还是「(auto)」。全站默认语言在「管理」→「配置」→「一般」里设置。

**Q7：日志里的 Gemfile 或 jQuery 警告要处理吗？**

不用。`puma` 被列出多次，以及 `Unable to resolve ... jquery`，是官方镜像里的提示。页面能登录就可以先放过。

**Q8：如何停止与卸载？**

确认不再需要项目数据之前，不要删除 `files/` 和 `mysql/`。

```bash
cd /www/wwwroot/redmine
docker compose down
```

站点不再需要时，再删除整个目录。密码文件里也有数据库密码。

```bash
rm -rf /www/wwwroot/redmine
```

**Q9：可以改用已经装好的 MySQL 吗？**

可以。去掉 Compose 里的 `db` 服务，把 `REDMINE_DB_MYSQL` 改成那台 MySQL 的地址，并保证库 `redmine`、用户和密码已经建好，且与 `REDMINE_DB_PASSWORD` 一致。容器访问宿主机上的数据库时，地址不一定是 `127.0.0.1`。

**Q10：和 Docker Hub 上的镜像是什么关系？**

本文使用的 `library/redmine:6.0.10` 与 Docker Hub 上的同名标签是同一份镜像，通过轩辕镜像加速拉取。数据库参数见 [Docker Hub · redmine](https://hub.docker.com/_/redmine)。

## 命令速查

```bash
docker pull docker.xuanyuan.run/library/redmine:6.0.10
docker pull docker.xuanyuan.run/library/mysql:8.0-debian

cd /www/wwwroot/redmine
docker compose up -d
docker compose ps
docker compose logs -f redmine
curl -I http://127.0.0.1:8080

docker compose down
```

浏览器打开 `http://服务器IP:8080`。初始登录名 `admin`，初始密码 `admin`，登录后按页面要求修改。数据库密码在 `db_password.txt`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [library/redmine 镜像页](https://xuanyuan.cloud/zh/r/library/redmine) | [https://xuanyuan.cloud/zh/r/library/redmine](https://xuanyuan.cloud/zh/r/library/redmine) |
| [library/redmine 概览](https://xuanyuan.cloud/r/library/redmine) | [https://xuanyuan.cloud/r/library/redmine](https://xuanyuan.cloud/r/library/redmine) |
| [library/redmine 标签列表](https://xuanyuan.cloud/r/library/redmine/tags) | [https://xuanyuan.cloud/r/library/redmine/tags](https://xuanyuan.cloud/r/library/redmine/tags) |
| [library/mysql 镜像页](https://xuanyuan.cloud/zh/r/library/mysql) | [https://xuanyuan.cloud/zh/r/library/mysql](https://xuanyuan.cloud/zh/r/library/mysql) |
| [library/mysql 概览](https://xuanyuan.cloud/r/library/mysql) | [https://xuanyuan.cloud/r/library/mysql](https://xuanyuan.cloud/r/library/mysql) |
| [Docker Hub · redmine](https://hub.docker.com/_/redmine) | [https://hub.docker.com/_/redmine](https://hub.docker.com/_/redmine) |
| [Docker Hub · mysql](https://hub.docker.com/_/mysql) | [https://hub.docker.com/_/mysql](https://hub.docker.com/_/mysql) |
| [Redmine 官网](https://www.redmine.org/) | [https://www.redmine.org/](https://www.redmine.org/) |
| [Redmine Wiki](https://www.redmine.org/projects/redmine/wiki) | [https://www.redmine.org/projects/redmine/wiki](https://www.redmine.org/projects/redmine/wiki) |
| [MySQL 镜像与 x86-64-v2](https://github.com/docker-library/mysql/issues/1055) | [https://github.com/docker-library/mysql/issues/1055](https://github.com/docker-library/mysql/issues/1055) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-redmine



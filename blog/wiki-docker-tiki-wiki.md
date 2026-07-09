# 想自建 Wiki 与知识库？Docker 部署 Tiki Wiki，浏览器就能协作

![想自建 Wiki 与知识库？Docker 部署 Tiki Wiki，浏览器就能协作](https://img.xuanyuan.dev/docker/blog/tikiwiki.png)

*分类: Docker部署教程 | 标签: Tiki Wiki,Docker,轩辕镜像,CMS, Wiki,知识库,私有化部署,部署教程 | 发布时间: 2026-07-08 04:09:44*

> Wiki、知识库、工单、论坛、博客、Tracker 低代码……各买一套 SaaS，数据分散、费用叠加？Tiki Wiki CMS Groupware 是开源的一体化协作平台——内置功能极多，号称「功能最全的开源 Web 应用」，适合在自有服务器上私有化部署 Wiki 与团队知识库。

*本文基于 [tikiwiki/tikiwiki:27.5](https://xuanyuan.cloud/zh/r/tikiwiki/tikiwiki) 与 [library/mariadb:latest](https://xuanyuan.cloud/zh/r/library/mariadb) 镜像，Ubuntu 24.04 服务器实测（服务器 IP `192.168.1.18`，访问端口 `8080`）*

Wiki、知识库、工单、论坛、博客、Tracker 低代码……各买一套 SaaS，数据分散、费用叠加？**Tiki Wiki CMS Groupware** 是开源的一体化协作平台——内置功能极多，号称「功能最全的开源 Web 应用」，适合在自有服务器上 **私有化部署** Wiki 与团队知识库。

Tiki **不能单容器跑生产环境**，必须配套 **MariaDB**。本文带你用 **Docker Compose** 双容器一键上线：轩辕镜像加速拉取、编写 `docker-compose.yml`、读懂启动日志，再跟做 **Web 安装向导 9 步**（含 Security Precaution 数据库凭据踩坑），最后登录后台、应用公司内网 Profile——全程 Ubuntu 24.04 实测，附 **18 张截图** 与完整命令。

国内用户从 Docker Hub 拉取可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run`。官方镜像说明见 [Docker Hub tikiwiki/tikiwiki](https://hub.docker.com/r/tikiwiki/tikiwiki)，项目官网 [tiki.org](https://tiki.org/)，源码 [GitLab tikiwiki/tiki](https://gitlab.com/tikiwiki/tiki)。

---

## 一、Tiki Wiki 是什么？

**Tiki Wiki CMS Groupware**（常简称 Tiki）是一款 **开源、自托管的一体化 Web 应用**，LGPL 许可。官方称其是「内置功能最多的 Free/Libre/Open Source Web 应用」。

| 能力 | 说明 |
|------|------|
| Wiki | 协作编辑、版本历史、权限控制 |
| Tracker | 内置低代码 / 无代码数据库应用构建器 |
| 论坛 / 博客 / 日历 | 团队沟通与内容发布 |
| 文件库 / 知识库 | 文档与附件集中管理 |
| CRM / 工单 / 会员 | 轻量业务集成场景 |

典型使用场景：团队 **私有 Wiki 与知识库**；小公司 **内网门户 + 协作**；替代部分 Confluence + Jira + 论坛的多套 SaaS 组合。

> **部署要点**：Tiki **不能单容器跑生产**，须配套 **MariaDB**（官方 Docker 示例使用 `mariadb`）。本文采用 **Docker Compose 双容器** + **Web 安装向导**（基础方案；多副本 HAProxy 扩展模式不在本文范围）。

架构示意：

```text
浏览器 ──HTTP:8080──▶ Tiki 容器 (Apache + PHP 8.1)
Tiki 容器 ──3306 内网──▶ MariaDB 容器
Tiki ──命名卷──▶ files / storage / sessions 等持久化
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 2 GB（推荐 4 GB，Tiki + MariaDB 双容器） |
| CPU | 双核即可 |
| 磁盘 | ≥ 5 GB（Tiki 镜像约 586 MB + MariaDB + 数据库与上传文件） |
| 端口 | **8080**（映射容器 80；宝塔 / Nginx 占 80 时勿直接绑 80） |
| 工作目录 | `/www/wwwroot/tikiwiki`（独立目录，勿与其他项目混用） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。若 `docker compose` 不可用，见文末 **FAQ Q1**。

**镜像版本对照**：

| 标签 | 适用场景 |
|------|----------|
| `tikiwiki/tikiwiki:27.5` | 本文主镜像，Tiki 27.5 稳定版 |
| `tikiwiki/tikiwiki:latest` | 最新版，生产建议固定 digest |
| `library/mariadb:latest` | 官方示例配套数据库 |

---

## 三、拉取镜像

先拉 Tiki 主镜像，再拉 MariaDB：

```bash
docker pull docker.xuanyuan.run/tikiwiki/tikiwiki:27.5
docker pull docker.xuanyuan.run/library/mariadb:latest
```

成功时终端显示 `Status: Downloaded newer image for ...`。本文实测拉取输出摘要：

```text
Status: Downloaded newer image for docker.xuanyuan.run/tikiwiki/tikiwiki:27.5
Status: Downloaded newer image for docker.xuanyuan.run/library/mariadb:latest
```

可用 `docker images` 确认本地镜像（Tiki 27.5 内容大小约 **586 MB**）：

```bash
docker images
```

| 官方镜像 | 轩辕镜像加速拉取 | 说明 |
|----------|------------------|------|
| `tikiwiki/tikiwiki:27.5` | `docker.xuanyuan.run/tikiwiki/tikiwiki:27.5` | 本文主镜像 |
| `library/mariadb:latest` | `docker.xuanyuan.run/library/mariadb:latest` | 配套数据库 |

---

## 四、创建目录并编写 Compose

```bash
mkdir -p /www/wwwroot/tikiwiki
cd /www/wwwroot/tikiwiki
```

### 4.1 创建 `docker-compose.yml`

```bash
vim docker-compose.yml
```

完整内容（与 Ubuntu 24.04 实测一致，**请将密码改为强密码**）：

```yaml
name: tikiwiki

services:
  tiki:
    image: docker.xuanyuan.run/tikiwiki/tikiwiki:27.5
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8080:80"
    environment:
      TIKI_DB_HOST: db
      TIKI_DB_USER: tiki
      TIKI_DB_PASS: YourStrongPass123
      TIKI_DB_NAME: tikiwiki
    volumes:
      - tiki_files:/var/www/html/files/
      - tiki_storage:/var/www/html/storage/
      - tiki_temp:/var/www/html/temp/
      - tiki_sessions:/var/www/sessions/

  db:
    image: docker.xuanyuan.run/library/mariadb:latest
    restart: unless-stopped
    environment:
      MYSQL_USER: tiki
      MYSQL_PASSWORD: YourStrongPass123
      MYSQL_DATABASE: tikiwiki
      MYSQL_ROOT_PASSWORD: YourRootPass123
      TERM: dumb
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD-SHELL", "mariadb-admin ping -h 127.0.0.1 -u\"$$MYSQL_USER\" -p\"$$MYSQL_PASSWORD\" || exit 1"]
      start_period: 30s
      interval: 5s
      timeout: 5s
      retries: 15

volumes:
  tiki_files:
  tiki_storage:
  tiki_temp:
  tiki_sessions:
  db_data:
```

各参数说明：

| 参数 | 说明 |
|------|------|
| `TIKI_DB_*` 与 `MYSQL_*` | 应用用户、密码、库名**必须一致** |
| `8080:80` | 宿主机 8080 → 容器 Apache 80；80 空闲可改 `80:80` |
| `depends_on` + `healthcheck` | 等 MariaDB 就绪后再启动 Tiki |
| 命名卷 | 持久化上传文件、storage、session 与数据库 |

**三角色密码对照**（安装向导易混，务必分清）：

| 角色 | 用户名 | 密码来源 | 用途 |
|------|--------|----------|------|
| 应用数据库用户 | `tiki` | `MYSQL_PASSWORD` / `TIKI_DB_PASS` | **安装向导填这个** |
| 数据库 root | `root` | `MYSQL_ROOT_PASSWORD` | 仅数据库维护，**不要**填进安装向导 |
| Tiki 站点管理员 | `admin` | 安装完成后临时为 `admin`，首次登录须改密 | **不是** Security Precaution 页要填的 |

---

## 五、启动与日志

```bash
docker compose up -d
docker compose ps
docker compose logs -f tiki
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080
```

本文实测 `docker compose up -d` 输出摘要：

```text
✔ Container tikiwiki-db-1        Healthy    17.1s
✔ Container tikiwiki-tiki-1      Started    17.3s
```

`docker compose ps` 期望状态：

```text
tikiwiki-db-1     ... Up ... (healthy)   3306/tcp
tikiwiki-tiki-1   ... Up ...             0.0.0.0:8080->80/tcp
```

Tiki 日志中出现 Apache 启动成功即可（`ServerName` 警告可忽略）：

```text
Apache/2.4.57 (Debian) PHP/8.1.27 configured -- resuming normal operations
```

`curl` 返回 **302** 表示服务正常（自动跳转安装向导）。若返回 `000`，见 FAQ Q2。

---

## 六、Web 安装向导（9 步跟做）

在浏览器打开（将 IP 换成你的服务器地址）：

```
http://192.168.1.18:8080
```

会自动跳转到 `tiki-install.php`。左侧为 9 步进度条，按顺序跟做即可。

### 6.1 第 0 步：Security Precaution（安全校验）

首次进入安装页，会先出现 **Security Precaution** 页，要求输入**数据库用户名和密码**以验证你是站点管理员。

![Tiki 安装向导 Security Precaution 页：填写数据库用户名 tiki 与密码](https://img.xuanyuan.dev/docker/blog/tikiwiki-1.png)

*图 1：Security Precaution 页——此处只填数据库凭据，不是站点管理员账号*

| 字段 | 正确填写 | 常见误填 |
|------|----------|----------|
| Database username | `tiki` | ❌ `tikiwiki`（这是库名） |
| Database password | `YourStrongPass123`（= `TIKI_DB_PASS`） | ❌ `YourRootPass123`（这是 root 密码） |

填好后点击 **Validate and Continue**。

> **踩坑提示**：若提示用户名密码不对，在 compose 目录执行 `docker compose exec db mariadb -u tiki -p'YourStrongPass123' -e "SHOW DATABASES;"` 验证；若 Access denied，检查 compose 中两处密码是否一致，或 `docker compose down -v` 清卷重装（**会清空数据库**）。

### 6.2 第 1 步：Welcome（欢迎）

进入正式安装向导 **Tiki Installer 27.5**，第一步为 Welcome。

![Tiki Installer 27.5 Welcome 页，默认语言 English](https://img.xuanyuan.dev/docker/blog/tikiwiki-2.png)

*图 2：Welcome 页，可选择安装语言*

在 **Select your language** 下拉框中选择 **Simplified Chinese（简体中文, cn）**：

![选择简体中文作为安装语言](https://img.xuanyuan.dev/docker/blog/tikiwiki-3.png)

*图 3：语言选择为简体中文*

点击 **Continue（继续）**。

### 6.3 第 2 步：License（许可协议）

阅读 LGPL 许可协议，点击 **Continue** 接受。

![License 许可协议页](https://img.xuanyuan.dev/docker/blog/tikiwiki-4.png)

*图 4：License 页，Tiki 基于 LGPL 许可发布*

### 6.4 第 3 步：Review the System Requirements（系统要求）

Tiki 自动检测 PHP 内存等环境。本文实测 **Memory** 检测通过（PHP `memory_limit` 128 MB）。

![系统要求检测：Memory 128 MB 通过](https://img.xuanyuan.dev/docker/blog/tikiwiki-5.png)

*图 5：系统要求检测通过；Mail 测试可选，不影响安装*

点击 **Continue** 进入下一步。

### 6.5 第 4 步：Set the Database Connection（数据库连接）

因 Compose 中已配置 `TIKI_DB_*` 环境变量，Tiki 会自动写入 `db/local.php`，此步通常显示 **Success**：

![数据库连接成功：Tiki found an existing database connection，Database name tikiwiki](https://img.xuanyuan.dev/docker/blog/tikiwiki-6.png)

*图 6：检测到已有数据库连接，库名 tikiwiki*

点击蓝色 **Use Existing Connection（使用现有连接）** 即可。若需手动修改，点橙色 **Modify database connection**，主机填 `db`，用户 `tiki`，库名 `tikiwiki`。

### 6.6 第 5 步：Install（安装数据库）

选择数据库引擎 **InnoDB**（默认），点击黄色 **安装** 按钮。

![选择 InnoDB 引擎并点击安装](https://img.xuanyuan.dev/docker/blog/tikiwiki-7.png)

*图 7：确认 InnoDB 后点击「安装」*

安装过程会创建数据表，进度条从 0% 逐步增加（约 945 条 SQL，需等待 1～3 分钟）：

![Database Installation 进度：Table creation status 10%](https://img.xuanyuan.dev/docker/blog/tikiwiki-8.png)

*图 8：数据库表创建进行中，请耐心等待*

### 6.7 第 6 步：Review the Installation（安装回顾）

出现绿色 **Installation complete** 表示数据库安装成功。安装程序提示：**首次安装的管理员账号为 `admin`，临时密码为 `admin`**。

![Installation complete：admin 用户临时密码 admin，945 SQL queries 成功](https://img.xuanyuan.dev/docker/blog/tikiwiki-9.png)

*图 9：安装完成，临时管理员 admin / admin（首次登录须改密）*

点击 **Continue**。

### 6.8 第 7 步：Configure the General Settings（一般设置）

配置站点基本信息。**Server domain name** 不确定时**留空**（填错可能导致无法访问）。**浏览器标题** 可改为 `My Tiki` 或你的站点名。

![一般设置：Server domain 留空，浏览器标题 My Tiki](https://img.xuanyuan.dev/docker/blog/tikiwiki-10.png)

*图 10：一般设置——域名不确定时留空*

填写后点击 **Continue**。

### 6.9 第 8 步：Last Notes（最后说明）

阅读安全更新订阅、向导使用等提示，点击 **Continue**。

![Last Notes 最后说明页](https://img.xuanyuan.dev/docker/blog/tikiwiki-11.png)

*图 11：Last Notes，建议订阅安全更新通知*

### 6.10 第 9 步：Enter Your Tiki（进入 Tiki）

显示 **Ready to run**，安装完成。点击蓝色 **Enter Tiki and Lock Installer（Recommended）** 进入站点并锁定安装程序（**推荐**；橙色按钮不锁定安装程序，有安全风险）。

![Enter Your Tiki：Ready to run，推荐 Enter Tiki and Lock Installer](https://img.xuanyuan.dev/docker/blog/tikiwiki-12.png)

*图 12：进入 Tiki 并锁定安装程序（推荐）*

---

## 七、首次登录与改密

点击「Enter Tiki and Lock Installer」后，系统要求为 `admin` 设置新密码（安装时的临时密码 `admin` 不能长期使用）。

![Set password：admin 用户须设置新密码与邮箱](https://img.xuanyuan.dev/docker/blog/tikiwiki-13.png)

*图 13：首次登录强制改密——填写新密码、重复密码与邮箱后点 Apply*

改密成功后进入 **Tiki Setup** 引导页，显示 **Congratulations! You now have a working instance of Tiki 27.5**。

![Tiki Setup 引导页：Congratulations，working instance of Tiki 27.5](https://img.xuanyuan.dev/docker/blog/tikiwiki-14.png)

*图 14：Tiki Setup 引导页，可立即使用或运行配置向导*

> **安全提示**：安装程序创建的临时账号为 **`admin` / `admin`**，进入站点后**必须**在改密页（图 13）改为强密码。公网暴露前务必完成改密，并配置 HTTPS 反向代理。

---

## 八、功能实测：应用公司内网 Profile

Tiki 提供 **Configuration Profiles Wizard**，可一键应用预设场景（协作社区、公司内网等），快速启用 Wiki、论坛、日历、Tracker 等模块。

### 8.1 选择 Featured Site Configurations

在 Tiki Setup 页点击 **Start the Wizardry**，或从 **Featured Site Configurations** 选择模板。本文实测选择 **Company Intranet（公司内网）**：

![Featured Site Configurations：Collaborative Community 与 Company Intranet](https://img.xuanyuan.dev/docker/blog/tikiwiki-15.png)

*图 15：Featured Site Configurations，选择公司内网等预设场景*

### 8.2 管理后台 Profiles 页

也可从管理后台进入 **Profiles** 页面浏览并应用配置模板：

![管理后台 Profiles 页：Preference Filters 与模块图标网格](https://img.xuanyuan.dev/docker/blog/tikiwiki-16.png)

*图 16：管理后台 Profiles 页；顶部可能提示发件邮箱未设置、版本升级建议*

### 8.3 应用 Company Intranet Profile

选择 **Company_Intranet_21** Profile，点击 **Apply Now**，在确认框点 **OK**：

![Apply the profile Company_Intranet_21 确认对话框](https://img.xuanyuan.dev/docker/blog/tikiwiki-17.png)

*图 17：确认应用 Company_Intranet_21 Profile*

### 8.4 内网首页

Profile 应用成功后，首页标题变为 **Our Intranet**，顶部出现成功提示，左侧 **System Menu** 已启用 Wiki、博客、论坛、Tracker、文件库等模块：

![公司内网首页 Our Intranet：Profile applied successfully](https://img.xuanyuan.dev/docker/blog/tikiwiki-18.png)

*图 18：公司内网 Profile 应用成功，Wiki / 论坛 / Tracker 等模块已就绪*

---

## 九、生产环境建议

### 9.1 固定镜像 digest

生产环境建议用 digest 固定构建，避免标签漂移：

```bash
docker pull docker.xuanyuan.run/tikiwiki/tikiwiki:27.5
docker inspect docker.xuanyuan.run/tikiwiki/tikiwiki:27.5 --format='{{index .RepoDigests 0}}'
```

本文拉取 digest 示例：`sha256:096cc953fb1cb3c5de4cb3523470ba0e128ba78b39825c45d722c6d82a0ca165`

### 9.2 Nginx 反向代理（示例）

```nginx
server {
    listen 80;
    server_name wiki.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 9.3 备份

```bash
cd /www/wwwroot/tikiwiki
docker compose exec db mariadb-dump -u tiki -p'YourStrongPass123' tikiwiki > tikiwiki-backup.sql
```

数据库在 `db_data` 卷，上传文件在 `tiki_files` 等卷，升级前建议一并备份。

---

## 十、常见问题 FAQ

**Q1：`docker compose up -d` 报 `unknown shorthand flag: 'd' in -d`？**

说明 **Compose V2 未安装**。Ubuntu 官方 `docker.io` 包请安装 **`docker-compose-v2`**：

```bash
sudo apt update
sudo apt install -y docker-compose-v2
docker compose version
```

**Q2：本机 `curl 127.0.0.1:8080` 返回 `000`，浏览器连接拒绝？**

8080 无进程监听。执行 `docker compose ps -a`：若 `tiki` 为 `Created` 或 `Exited`，执行 `docker compose up -d tiki` 并查看 `docker compose logs tiki`。常见原因：`db` 未 healthy 导致 Tiki 未启动。

**Q3：Security Precaution 页数据库用户名密码不对？**

填 **`tiki` + `MYSQL_PASSWORD`（应用用户密码）**，**不要**填 `tikiwiki`（库名）或 `YourRootPass123`（root 密码）。验证：

```bash
docker compose exec db mariadb -u tiki -p'YourStrongPass123' -e "SHOW DATABASES;"
```

**Q4：安装向导连不上数据库？**

检查 `TIKI_DB_HOST=db`、应用用户密码与 MariaDB 环境变量一致、`db` 容器为 `(healthy)`。

**Q5：8080 被占用怎么办？**

将 compose 中 `"8080:80"` 改为 `"8090:80"`，浏览器访问 `http://YOUR_SERVER_IP:8090`。

**Q6：管理员账号密码是什么？**

Web 安装完成后，安装程序提示临时账号 **`admin` / `admin`**。进入站点后**必须**在改密页（图 13）设置新密码；这不是长期可用的默认密码。

**Q7：是否需要设 `TIKI_DB_VERSION`？**

使用固定标签 **`27.5`** 时一般**不必手动设**；仅 `latest` 或 CLI 装库场景才需关注。

**Q8：能否用 MySQL 替代 MariaDB？**

官方 Docker 示例为 MariaDB，生产建议跟随官方；MySQL 8 兼容性未在本文实测范围。

**Q9：日志里 `Could not reliably determine the server's fully qualified domain name`？**

Apache 的 `ServerName` 提示，**不影响使用**，可忽略。

**Q10：安装完成后还提示版本不再支持？**

Tiki 27.5 安装后可能提示建议升级到 27.6 或更高版本，属正常提醒；生产环境可评估升级计划，本文以 27.5 标签实测为准。

---

## 总结

本文完成了 Tiki Wiki **27.5 双容器 Compose 私有化部署**：

- 使用轩辕镜像加速拉取 [tikiwiki/tikiwiki:27.5](https://xuanyuan.cloud/zh/r/tikiwiki/tikiwiki) 与 [library/mariadb:latest](https://xuanyuan.cloud/zh/r/library/mariadb)
- Docker Compose 双容器，工作目录 `/www/wwwroot/tikiwiki`，8080 端口访问
- MariaDB healthcheck + 命名卷持久化
- Web 安装向导 9 步跟做，含 **Security Precaution 数据库凭据踩坑**
- 临时管理员 **`admin` / `admin`**，首次登录强制改密
- 应用 **Company Intranet Profile**，Wiki / 论坛 / Tracker 等模块就绪（18 张配图）

**延伸阅读：**

- [Tiki Wiki 轩辕镜像页](https://xuanyuan.cloud/zh/r/tikiwiki/tikiwiki)
- [Docker Hub tikiwiki/tikiwiki](https://hub.docker.com/r/tikiwiki/tikiwiki)
- [Tiki 项目官网](https://tiki.org/)
- [Tiki 源码 GitLab](https://gitlab.com/tikiwiki/tiki)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)



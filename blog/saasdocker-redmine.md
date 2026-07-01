# 团队工单不想上 SaaS？Docker 跑个 Redmine，浏览器就能管项目

![团队工单不想上 SaaS？Docker 跑个 Redmine，浏览器就能管项目](https://img.xuanyuan.dev/docker/blog/redmine.png)

*分类: Docker部署教程 | 标签: Redmine,Docker,轩辕镜像,项目管理,工单,私有化部署,部署教程 | 发布时间: 2026-06-30 11:54:15*

> 团队用 Jira、禅道、飞书项目，数据不在自己手里？Redmine 是一款开源、可自托管的项目管理与问题跟踪系统——支持 工单、甘特图、Wiki、版本库、时间跟踪，Docker Compose 双容器（Redmine + MySQL）即可跑通。浏览器打开就能建项目、派任务、看进度，数据全在你自己的服务器上。

*本文基于 [library/redmine:6.0.10](https://xuanyuan.cloud/zh/r/library/redmine) 与 [library/mysql:8.0-debian](https://xuanyuan.cloud/zh/r/library/mysql) 镜像，Ubuntu 24.04 服务器实测*

团队用 Jira、禅道、飞书项目，数据不在自己手里？**Redmine** 是一款开源、可自托管的项目管理与问题跟踪系统——支持 **工单、甘特图、Wiki、版本库、时间跟踪**，**Docker Compose 双容器**（Redmine + MySQL）即可跑通。浏览器打开就能建项目、派任务、看进度，数据全在你自己的服务器上。

本文带你完成一次 **Redmine Docker Compose 私有化部署**：轩辕镜像加速拉取、编写 `docker-compose.yml`、处理 **3000 端口冲突**、读懂启动日志，到浏览器 **admin 登录**、强制改密、切换中文、载入默认配置、新建第一个项目——全程零基础可跟做，文末附 **7 张实测截图**。

国内用户从 Docker Hub 拉取 `library/redmine` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run`。官方镜像说明见 [Docker Hub - redmine](https://hub.docker.com/_/redmine)，项目官网 [redmine.org](https://www.redmine.org)。

---

## 一、Redmine 是什么？

**Redmine** 是一款 **开源、自托管的项目管理与问题跟踪（Issue Tracking）系统**，基于 Ruby on Rails，GPL 许可。核心能力：

| 能力 | 说明 |
|------|------|
| 多项目管理 | 每个项目独立模块：工单、Wiki、文档、版本库、讨论区 |
| 问题跟踪 | 自定义跟踪标签、状态、工作流；支持甘特图、日历 |
| 权限与角色 | 细粒度角色权限，支持 LDAP 认证 |
| 时间跟踪 | 记录工时、生成报表 |
| 插件生态 | 大量社区插件扩展功能 |

典型使用场景：

- 小团队 **私有工单系统**，替代 Jira / 禅道 SaaS
- 开发团队 **Bug 跟踪 + 版本里程碑 + Git 变更关联**
- 内部 **项目进度与文档 Wiki** 统一入口

> **与 Memos / File Browser 的区别**：Redmine **不能单容器跑生产环境**，官方镜像默认依赖 **MySQL / PostgreSQL**（不配数据库会回退 SQLite，仅适合临时试用）。本文采用 **Redmine + MySQL 双容器 Compose**，数据持久化到宿主机目录。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 2 GB（Redmine + MySQL 双容器；推荐 4 GB） |
| CPU | 双核即可；老旧 VPS 注意 MySQL 镜像兼容性（见第三节） |
| 磁盘 | ≥ 5 GB（镜像 + 数据库 + 附件） |
| 端口 | **8080**（宿主机映射，容器内 Redmine 监听 **3000**） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、拉取镜像

Redmine 与 MySQL 均需从轩辕镜像加速域拉取：

```bash
docker pull docker.xuanyuan.run/library/redmine:6.0.10
docker pull docker.xuanyuan.run/library/mysql:8.0-debian
```

成功时终端显示 `Status: Downloaded newer image for ...`。

**部署前预检**（确认 MySQL 镜像能在本机 CPU 上运行）：

```bash
docker run --rm docker.xuanyuan.run/library/mysql:8.0-debian mysql --version
```

若报 `CPU does not support x86-64-v2`，须改用 **`mysql:8.0-debian`**（勿用默认 `mysql:8.0` 标签）。详见 [MySQL 镜像老旧 CPU 兼容说明](https://github.com/docker-library/mysql/issues/1055)。

| 官方镜像 | 轩辕镜像加速拉取 | 说明 |
|----------|------------------|------|
| `redmine:6.0.10` | `docker.xuanyuan.run/library/redmine:6.0.10` | 本文主镜像，固定小版本 |
| `redmine:6.0` | `docker.xuanyuan.run/library/redmine:6.0` | 6.0 系列滚动标签 |
| `mysql:8.0-debian` | `docker.xuanyuan.run/library/mysql:8.0-debian` | **老旧 CPU 首选** |
| `mysql:8.0` | `docker.xuanyuan.run/library/mysql:8.0` | **勿用**（Oracle Linux 9，需 x86-64-v2） |

---

## 四、创建目录并编写 Compose

工作目录使用 **`/www/wwwroot/redmine`**（独立目录，勿与其他项目混用）：

```bash
mkdir -p /www/wwwroot/redmine/{files,mysql}
cd /www/wwwroot/redmine
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `files/` | `/usr/src/redmine/files` | Redmine **附件与上传文件** |
| `mysql/` | `/var/lib/mysql` | MySQL **数据库数据** |

### 4.1 生成 SECRET_KEY

Redmine 会话加密密钥 **必填**，用 OpenSSL 生成：

```bash
openssl rand -hex 64
```

将输出填入下方 `REDMINE_SECRET_KEY_BASE`（**每次部署应使用不同值**）。

### 4.2 编写 `docker-compose.yml`

```bash
vim docker-compose.yml
```

完整内容（与 Ubuntu 24.04 实测一致，**请将密码改为强密码**）：

```yaml
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
      REDMINE_DB_PASSWORD: YourStrongPass123
      REDMINE_SECRET_KEY_BASE: 请粘贴_openssl_rand_输出
      TZ: Asia/Shanghai
    volumes:
      - ./files:/usr/src/redmine/files

  db:
    image: docker.xuanyuan.run/library/mysql:8.0-debian
    container_name: redmine-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: RootPass456
      MYSQL_DATABASE: redmine
      MYSQL_USER: redmine
      MYSQL_PASSWORD: YourStrongPass123
      TZ: Asia/Shanghai
    volumes:
      - ./mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-pRootPass456"]
      interval: 10s
      timeout: 5s
      retries: 10
```

各参数说明：

| 参数 | 说明 |
|------|------|
| `8080:3000` | 宿主机 **8080** → 容器 **3000**（Redmine Web 端口） |
| `REDMINE_DB_MYSQL: db` | 数据库主机名为 Compose 服务名 `db` |
| `REDMINE_DB_*` | Redmine 连接 MySQL 的库名、用户、密码 |
| `REDMINE_SECRET_KEY_BASE` | 会话加密密钥，**必填** |
| `MYSQL_*` | MySQL 初始化：root 密码、业务库与用户 |
| `depends_on` + `healthcheck` | 等 MySQL 就绪后再启动 Redmine |
| `./files` / `./mysql` | 附件与数据库 **宿主机持久化** |

> **密码一致性**：`REDMINE_DB_PASSWORD` 必须与 `MYSQL_PASSWORD` 相同；`healthcheck` 中的 root 密码须与 `MYSQL_ROOT_PASSWORD` 一致。

---

## 五、启动服务

```bash
docker compose up -d
```

首次启动 MySQL 初始化约 **20～30 秒**，Redmine 自动执行数据库迁移约 **1～3 分钟**。

查看状态：

```bash
docker compose ps
```

期望输出（**Ubuntu 24.04 实测**）：

```text
NAME         IMAGE                                          STATUS                        PORTS
redmine      docker.xuanyuan.run/library/redmine:6.0.10     Up                            0.0.0.0:8080->3000/tcp
redmine-db   docker.xuanyuan.run/library/mysql:8.0-debian   Up (healthy)                  3306/tcp
```

查看 Redmine 日志：

```bash
docker compose logs -f redmine
```

首次启动日志中会出现大量 `Writing ...`（静态资源预编译）与 `Migrating to ...`（数据库迁移），属正常现象。日志末尾出现 Puma 监听即表示就绪：

```text
* Listening on tcp://0.0.0.0:3000
```

另开终端快速探测：

```bash
curl -I http://127.0.0.1:8080
```

应返回 HTTP `200` 或 `302`。

> **日志提示**：可能出现 `Your Gemfile lists the gem puma ... more than once` 或 jQuery 资源 `WARN`，为官方镜像已知提示，**不影响使用**，可忽略。

---

## 六、浏览器访问与登录

在浏览器打开（将 `YOUR_SERVER_IP` 换成服务器 IP）：

```text
http://YOUR_SERVER_IP:8080
```

### 6.1 首页欢迎页

首次访问会看到 Redmine 默认欢迎页，右上角有 **「登录」** 与 **「注册」** 链接：

![Redmine 首页：Welcome to Redmine 欢迎语，右上角登录与注册入口](https://img.xuanyuan.dev/docker/blog/redmine-1.png)

*图 1：部署成功后的 Redmine 首页，确认 Web 服务已就绪*

### 6.2 使用默认账号登录

点击右上角 **「登录」**，输入默认管理员账号：

| 字段 | 值 |
|------|-----|
| 登录名 | `admin` |
| 密码 | `admin` |

![Redmine 登录页：登录名 admin，输入默认密码后点击登录](https://img.xuanyuan.dev/docker/blog/redmine-2.png)

*图 2：Redmine 默认管理员账号为 admin / admin*

> **安全提示**：默认密码 **`admin`** 仅用于首次登录。Redmine 会在登录后 **强制要求修改密码**，公网暴露前务必完成改密。

### 6.3 强制修改密码

首次登录后，页面顶部出现红色提示：**「您的密码已经过期或是管理员要求您修改密码。」** 填写当前密码 `admin` 与新密码（**至少 8 个字符**），点击 **「应用」**：

![Redmine 修改密码页：当前密码、新密码与确认，至少 8 个字符](https://img.xuanyuan.dev/docker/blog/redmine-3.png)

*图 3：首次登录强制改密，新密码至少 8 位*

### 6.4 我的账号

改密成功后进入 **「我的帐号」** 页面，顶部绿色提示 **「密码更新成功」**。可在此修改 **语言**（选 **简体中文**）、邮件通知、时区等：

![Redmine 我的帐号：密码更新成功提示，语言与通知偏好设置](https://img.xuanyuan.dev/docker/blog/redmine-4.png)

*图 4：改密成功后的个人账号设置页*

---

## 七、初始化与功能验证

以下步骤确认 Redmine 不仅「能登录」，还能完成项目管理常见操作。

### 7.1 载入默认配置（推荐）

顶部导航点击 **「管理」**，页面提示角色、跟踪标签、问题状态与工作流尚未配置。语言选 **「Chinese/Simplified (简体中文)」**，点击 **「载入默认设置」**：

![Redmine 管理页：载入默认配置提示，语言选简体中文](https://img.xuanyuan.dev/docker/blog/redmine-7.png)

*图 7：管理后台载入默认配置，一键初始化角色与工作流*

这一步会导入 Redmine 预设的 **角色、跟踪标签（Bug/功能/支持等）、问题状态、工作流**，省去手动逐项配置的麻烦。

### 7.2 新建第一个项目

顶部 **「项目」→「新建项目」**（或 **「+ 新建项目」**），填写：

| 字段 | 示例 |
|------|------|
| 名称 | 测试App项目 |
| 标识 | `app`（小写字母、数字、短横线，保存后不可改） |
| 公开 | 勾选（内网可见；外网建议取消） |

下方 **模块** 可勾选问题跟踪、Wiki、甘特图、版本库等，点击 **「创建」**：

![Redmine 新建项目：名称、标识 app、模块勾选问题跟踪与甘特图等](https://img.xuanyuan.dev/docker/blog/redmine-5.png)

*图 5：创建第一个项目，启用所需功能模块*

### 7.3 我的工作台

顶部 **「我的工作台」** 进入个人仪表盘，可查看 **指派给我的问题**、**已报告的问题** 等区块。右侧 **「新增:」** 下拉可添加更多面板（更新的问题、日历、活动等）：

![Redmine 我的工作台：指派与已报告问题面板，新增区块下拉菜单](https://img.xuanyuan.dev/docker/blog/redmine-6.png)

*图 6：登录后的个人工作台，可自定义仪表盘区块*

至此，**拉镜像 → Compose 启动 → admin 登录 → 改密 → 载入默认配置 → 新建项目 → 工作台** 全流程验证完成。

---

## 八、常用环境变量速查

摘自 [Docker Hub - redmine 环境变量](https://hub.docker.com/_/redmine)：

| 变量 | 默认 | 用途 |
|------|------|------|
| `REDMINE_DB_MYSQL` | — | MySQL 主机名（与 `REDMINE_DB_POSTGRES` 互斥） |
| `REDMINE_DB_PORT` | `3306` | 数据库端口 |
| `REDMINE_DB_USERNAME` | `root` | 数据库用户名 |
| `REDMINE_DB_PASSWORD` | — | 数据库密码 |
| `REDMINE_DB_DATABASE` | `redmine` | 数据库名 |
| `REDMINE_SECRET_KEY_BASE` | — | 会话加密密钥，**生产必填** |
| `REDMINE_PLUGINS_MIGRATE` | — | 设为 `true` 时启动时执行插件迁移 |

容器内 Redmine 监听 **3000** 端口，宿主机映射在 Compose `ports` 中配置。

---

## 九、常见问题 FAQ

**Q1：启动报 `failed to bind host port 0.0.0.0:3000/tcp: address already in use`？**

宿主机 **3000** 端口已被占用（常见为 Node 应用或其他容器）。修改 `docker-compose.yml` 中 `ports`：

```yaml
    ports:
      - "8080:3000"
```

然后重新启动：

```bash
docker compose up -d
```

浏览器访问 `http://服务器IP:8080`。可用 `ss -tlnp | grep ':3000'` 查看占用进程。

**Q2：Redmine 一直启动中 / 浏览器 502？**

数据库尚未就绪。先确认 `redmine-db` 为 `(healthy)`：

```bash
docker compose ps
docker compose logs db
```

待 MySQL 就绪后 Redmine 会继续迁移，首次约 **1～3 分钟**。可 `docker compose logs -f redmine` 观察迁移进度。

**Q3：默认账号 admin / admin 无法登录？**

全新安装应可用。若数据库目录 `mysql/` 来自旧部署，可能已改过密码。可清空 `mysql/` 与 `files/` 后重新 `docker compose up -d`（**会丢失全部数据**），或通过 Rails 控制台重置密码。

**Q4：数据存在哪里？**

| 路径 | 内容 |
|------|------|
| `/www/wwwroot/redmine/files/` | 附件、上传文件 |
| `/www/wwwroot/redmine/mysql/` | MySQL 全部数据 |

**删除这两个目录会丢失全部项目与工单**，升级镜像时请勿删除。

**Q5：如何升级 Redmine？**

```bash
cd /www/wwwroot/redmine
docker pull docker.xuanyuan.run/library/redmine:6.0.10
docker compose up -d
```

跨大版本升级前建议备份 `files/` 与 `mysql/` 目录。

**Q6：如何切换界面为中文？**

**我的帐号 → 语言 → 简体中文（zh）→ 保存**。全站默认语言可在 **管理 → 配置 → 一般 → 语言** 中设置。

**Q7：日志里 Gemfile / jQuery 警告需要处理吗？**

不需要。`puma gem listed more than once` 与 `Unable to resolve ... jquery` 为官方镜像已知输出，**不影响 Redmine 正常运行**。

**Q8：如何停止与卸载？**

```bash
# 停止容器（保留 files / mysql 数据）
cd /www/wwwroot/redmine && docker compose down

# 删除数据目录（慎用，项目与工单将全部丢失）
rm -rf /www/wwwroot/redmine/files /www/wwwroot/redmine/mysql
```

**Q9：可以用宝塔已有 MySQL 吗？**

可以。去掉 Compose 中的 `db` 服务，将 `REDMINE_DB_MYSQL` 改为宿主机 MySQL 地址（容器访问宿主机常用 `172.17.0.1`），并确保 MySQL 中已建库、用户及授权。仅保留 Redmine 单容器即可。

**Q10：生产环境如何对外发布？**

建议 Nginx / Caddy **反向代理** 到 `127.0.0.1:8080`，配置 HTTPS；在 **管理 → 配置 → 一般** 中设置 **主机名称** 为你的域名。8080 仅内网监听，不对公网直连。

---

## 十、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/library/redmine:6.0.10` |
| 拉取 MySQL | `docker pull docker.xuanyuan.run/library/mysql:8.0-debian` |
| 生成密钥 | `openssl rand -hex 64` |
| Compose 启动 | `cd /www/wwwroot/redmine && docker compose up -d` |
| 查看状态 | `docker compose ps` |
| 查看日志 | `docker compose logs -f redmine` |
| 健康检查 | `curl -I http://127.0.0.1:8080` |
| Web 访问 | `http://服务器IP:8080` |
| 默认账号 | `admin` / `admin`（首次登录后强制改密） |
| 停止服务 | `docker compose down` |

---

## 十一、延伸阅读

| 主题 | 链接 |
|------|------|
| Redmine 官网 | https://www.redmine.org |
| 官方 Wiki | https://www.redmine.org/projects/redmine/wiki |
| Docker Hub 镜像 | https://hub.docker.com/_/redmine |
| 轩辕 Redmine 镜像页 | https://xuanyuan.cloud/zh/r/library/redmine |
| 轩辕 MySQL 镜像页 | https://xuanyuan.cloud/zh/r/library/mysql |
| 轩辕镜像 | https://xuanyuan.cloud |

---

**总结**：Redmine = **私有化项目与工单管理**，需 **Redmine + MySQL 双容器**。个人或小团队用 **第四节 Compose 方案**，浏览器 **admin 登录 → 改密 → 载入默认配置 → 新建项目** 即可上手；长期运行请配合 **数据备份** 与 **反向代理 HTTPS**，项目数据完全在自己服务器上。



# 一键部署私有笔记：Docker 跑 Memos，浏览器随手记

![一键部署私有笔记：Docker 跑 Memos，浏览器随手记](https://img.xuanyuan.dev/docker/blog/memos.png)

*分类: Docker部署教程 | 标签: Memos,Docker,轩辕镜像,笔记,Markdown,私有化部署,部署教程 | 发布时间: 2026-06-28 05:31:45*

> 怕笔记放 Notion、飞书、语雀，数据不在自己手里？Memos 是一款开源、可自托管的轻量笔记服务——镜像约 20MB，默认 SQLite，一条 docker run 就能跑。打开浏览器写 Markdown、打 #标签、按时间线翻旧笔记，手机电脑同步访问，数据全在你自己的服务器上。
> 
> 本文带你完成一次 Memos 一条命令 Docker 部署：从轩辕镜像拉取、docker run 一键启动、读懂启动日志，到浏览器注册管理员、切换中文界面、写下第一条 memo——全程零基础可跟做，文末附 5 张实测截图。

*本文基于 [neosmemo/memos:stable](https://xuanyuan.cloud/zh/r/neosmemo/memos) 镜像（实测版本 **0.29.1**），Ubuntu 24.04 服务器实测*

怕笔记放 Notion、飞书、语雀，数据不在自己手里？**Memos** 是一款开源、可自托管的轻量笔记服务——镜像约 **20MB**，默认 **SQLite**，**一条 `docker run` 就能跑**。打开浏览器写 Markdown、打 `#标签`、按时间线翻旧笔记，手机电脑同步访问，数据全在你自己的服务器上。

本文带你完成一次 **Memos 一条命令 Docker 部署**：从轩辕镜像拉取、`docker run` 一键启动、读懂启动日志，到浏览器注册管理员、切换中文界面、写下第一条 memo——全程零基础可跟做，文末附 **6 张实测截图**。

国内用户从 Docker Hub 拉取 `neosmemo/memos` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run`。官方文档见 [usememos.com/docs](https://usememos.com/docs)，源码仓库 [usememos/memos](https://github.com/usememos/memos)。

---

## 一、Memos 是什么？

**Memos** 是一款 **开源、自托管的轻量笔记服务**，主打「打开就写、数据在自己手里」。核心能力：

| 能力 | 说明 |
|------|------|
| 快速记录 | 时间线 UI，打开即写，无需文件夹层级 |
| 数据自主 | 自托管部署，笔记以 Markdown 存储，**零遥测** |
| 极轻量 | 单 Go 二进制，Docker 镜像约 **20MB**；默认 **SQLite**，无需 MySQL / Redis |
| 可扩展 | MIT 许可，提供 REST 与 gRPC API，便于二次集成 |

典型使用场景：

- 个人 **灵感库**、碎片待办、读书摘抄
- 小团队 **轻量知识库**，数据不经过第三方 SaaS
- 替代部分 Notion / 飞书文档的「随手记」场景，强调 **隐私与简单**

> **与云笔记的区别**：Memos 没有复杂协作与模板市场，胜在 **部署简单、资源占用极低、数据完全可控**。若需要块级编辑与知识图谱，可考虑 SiYuan 等更重型的方案。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 512 MB（空闲约 50～80 MB） |
| CPU | 单核即可；双核更从容 |
| 磁盘 | ≥ 1 GB（镜像 + SQLite + 附件） |
| 端口 | **5230**（Memos 默认 Web 端口） |

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

## 三、快速体验：单容器部署

适合：个人试用、内网随手记、资源有限的 VPS。

### 3.1 创建数据目录

```bash
sudo mkdir -p /www/wwwroot/memos/data
sudo chown -R $USER:$USER /www/wwwroot/memos
cd /www/wwwroot/memos
```

### 3.2 拉取并启动容器

拉取镜像（若已拉取可跳过）：

```bash
docker pull docker.xuanyuan.run/neosmemo/memos:stable
```

启动 Memos：

```bash
docker run -d \
  --name memos \
  --restart unless-stopped \
  -p 5230:5230 \
  -v /www/wwwroot/memos/data:/var/opt/memos \
  docker.xuanyuan.run/neosmemo/memos:stable
```

各参数说明：

| 配置 | 说明 |
|------|------|
| `-p 5230:5230` | 对外暴露 Web 访问端口 |
| `-v ...:/var/opt/memos` | 持久化 SQLite 数据库与本地附件 |
| `stable` | 生产推荐标签（实测对应 **0.29.1**） |
| `--restart unless-stopped` | 宿主机重启后自动拉起 |

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `neosmemo/memos:stable` | `docker pull docker.xuanyuan.run/neosmemo/memos:stable` |

### 3.3 验证启动

查看日志：

```bash
docker logs -f memos
```

成功时终端类似输出（**Ubuntu 24.04 实测**）：

```text
time=2026-06-28T05:11:44.804Z level=INFO msg="initializing new database with latest schema"
time=2026-06-28T05:11:44.826Z level=INFO msg="database initialized successfully" schemaVersion=0.28.1
Memos 0.29.1 started successfully!
Data directory: /var/opt/memos
Database driver: sqlite
Server running on port 5230
Access your memos at: http://localhost:5230
Happy note-taking!
```

看到 **`Memos 0.29.1 started successfully!`** 与 **`Server running on port 5230`** 即表示启动成功。另开终端快速探测：

```bash
curl -I http://127.0.0.1:5230
```

应返回 HTTP `200` 或 `302`（重定向到登录/注册页）。

> **日志提示**：首次打开浏览器时可能出现 `refresh token not found` 的 `client error`，属于 **未登录时的正常请求**，不影响使用。

确认容器状态：

```bash
docker ps | grep memos
```

### 3.4 首次注册：创建管理员账户

浏览器打开：

```text
http://你的服务器IP:5230
```

首次访问会进入 **创建账户** 页面。**第一个注册的用户自动成为站点管理员**（Memos 无固定默认账号密码）。

![Memos 首次访问：创建账户页面，首个注册用户即为站点管理员](https://img.xuanyuan.dev/docker/blog/memos-1.png)

填写用户名与密码，点击 **注册** 即可登录。

> **安全提示**：若对公网开放 5230，请尽快完成注册，避免他人抢先注册成为管理员。生产环境建议关闭公网直连，改用 **第五节 Compose + 反向代理 HTTPS**。

### 3.5 登录后主界面

注册成功后会进入 Memos 主界面：左侧为日历、标签与导航；中间上方为 **「Any thoughts...」** 输入框，下方为时间线 feed。

![Memos 登录后主界面：空时间线与「Any thoughts...」输入框](https://img.xuanyuan.dev/docker/blog/memos-2.png)

此时还没有任何 memo，会显示 **「No data found.」**，属正常状态。

### 3.6 切换简体中文

默认界面为英文。点击左下角 **用户头像** → **Language** → 选择 **简体中文**，界面即可切换为中文。

![Memos 切换语言：左下角用户菜单中的 Language 选项](https://img.xuanyuan.dev/docker/blog/memos-3.png)

切换后，搜索框变为 **「搜索备忘录...」**，输入框提示变为 **「此刻的想法...」**，标签区提示 **「您可以通过输入 '#标签' 创建标签」**。

### 3.7 写第一条 memo

在输入框中写下内容，例如：

```markdown
记录我此时此刻的想法。
```

点击 **保存**。memo 会按时间线展示在下方，支持 **私有 / 公开** 可见性切换。

![Memos 写第一条 memo：中文界面与时间线展示](https://img.xuanyuan.dev/docker/blog/memos-4.png)

**日常用法速记**：

- 正文中写 `#工作`、`#灵感` 会自动生成 **标签**，点标签可筛选
- 顶部 **搜索框** 按关键词检索标题与正文
- 手机浏览器访问同一地址即可 **跨设备同步**（数据在自建服务器上）

### 3.8 附件与多媒体（可选）

输入框左侧 **「+」** 可插入更多内容，不限于纯文字：

| 菜单项 | 用途 |
|--------|------|
| Media | 插入图片、视频 |
| 录制音频 | 浏览器内录音，适合语音备忘 |
| 文件 | 上传附件 |
| 链接备忘录 | 关联另一条 memo |
| 添加位置 | 为 memo 附加地理位置 |
| 更多 | 展开其他扩展项 |

![Memos 输入框「+」菜单：Media、录制音频、文件、链接备忘录与添加位置](https://img.xuanyuan.dev/docker/blog/memos-6.png)

### 3.9 捷径过滤器（可选）

Memos 支持用表达式创建 **捷径（Shortcut）**，快速筛选 pinned、特定标签、未完成待办等。点击左侧 **捷径** 图标 → **创建捷径**，可参考右侧示例：

| 示例 | 表达式 | 含义 |
|------|--------|------|
| 置顶 | `pinned` | 仅显示置顶 memo |
| 近 1 小时 | `created_ts >= now() - 60 * 60` | 最近一小时内创建 |
| 工作标签 | `tag in ["work"]` | 含指定标签 |

![Memos 捷径过滤器：创建自定义筛选表达式](https://img.xuanyuan.dev/docker/blog/memos-5.png)

---

## 四、生产推荐：Docker Compose

适合：长期运行、需要可复现配置、便于 `git` 管理部署文件的场景。

### 4.1 目录结构

```bash
cd /www/wwwroot/memos
```

将包含：

```text
/www/wwwroot/memos/
├── docker-compose.yml
└── data/          # SQLite 与附件（自动创建）
```

### 4.2 编写 `docker-compose.yml`

```yaml
services:
  memos:
    image: docker.xuanyuan.run/neosmemo/memos:stable
    container_name: memos
    restart: unless-stopped
    ports:
      - "5230:5230"
    volumes:
      - ./data:/var/opt/memos
    environment:
      MEMOS_PORT: 5230
      MEMOS_DRIVER: sqlite
      # 生产环境填公网 URL，便于链接、Cookie 与分享正确
      # MEMOS_INSTANCE_URL: https://memos.example.com
```

### 4.3 启动与运维

```bash
docker compose up -d
docker compose ps
docker compose logs -f memos
```

常用运维命令：

```bash
# 查看日志
docker compose logs -f memos

# 停止（保留 data 目录）
docker compose down

# 升级：拉新镜像后重建
docker compose pull
docker compose up -d
```

### 4.4 可选：PostgreSQL 后端

默认 **SQLite** 对个人与小团队足够。若用户较多或需独立数据库备份，可改用 PostgreSQL：

```yaml
services:
  memos:
    image: docker.xuanyuan.run/neosmemo/memos:stable
    container_name: memos
    restart: unless-stopped
    ports:
      - "5230:5230"
    volumes:
      - ./data:/var/opt/memos
    environment:
      MEMOS_DRIVER: postgres
      MEMOS_DSN: "postgresql://memos:请改为强密码@memos-db:5432/memos?sslmode=disable"
      MEMOS_INSTANCE_URL: https://memos.example.com
    depends_on:
      - memos-db

  memos-db:
    image: docker.xuanyuan.run/library/postgres:16-alpine
    container_name: memos-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: memos
      POSTGRES_PASSWORD: 请改为强密码
      POSTGRES_DB: memos
    volumes:
      - memos_pgdata:/var/lib/postgresql/data

volumes:
  memos_pgdata:
```

> 使用外部数据库时，`./data` 卷仍用于本地附件等实例数据，请一并备份。

### 4.5 生产环境注意

- **HTTPS**：将 Memos 放在 Nginx、Caddy 或 Traefik **反向代理** 之后，对外只暴露 443。详见 [官方反向代理文档](https://usememos.com/docs/deploy/reverse-proxy)。
- **`MEMOS_INSTANCE_URL`**：设为公网 URL（如 `https://memos.example.com`），确保分享链接与登录 Cookie 正确。
- **备份**：定期备份 `./data` 目录（含 `memos_prod.db` 与上传文件）；使用 PostgreSQL 时另备份数据库卷。
- **防火墙**：若必须直连端口，可 `sudo ufw allow 5230/tcp`；云服务器需在 **安全组** 放行。更推荐仅反代对外、5230 仅内网访问。

### 4.6 镜像标签说明

| 标签 | 适用场景 |
|------|----------|
| `stable` | **生产推荐**，跟随稳定发布线（实测 **0.29.1**） |
| `0.29.1` 等版本号 | 完全固定版本，便于审计与回滚 |
| `latest` | 偏开发向，**不建议生产使用** |

---

## 五、常用环境变量速查

摘自 [官方 Docker 文档](https://usememos.com/docs/deploy/docker)：

| 变量 | 默认 | 用途 |
|------|------|------|
| `MEMOS_PORT` | `5230` | HTTP 监听端口 |
| `MEMOS_ADDR` | 空 | 绑定地址（空 = 所有网卡） |
| `MEMOS_DATA` | `/var/opt/memos` | 数据目录 |
| `MEMOS_DRIVER` | `sqlite` | 数据库类型（`sqlite` / `postgres` / `mysql`） |
| `MEMOS_DSN` | 自动 | postgres / mysql 连接串 |
| `MEMOS_INSTANCE_URL` | 空 | 实例公网访问地址 |
| `MEMOS_MODE` | `prod` | 运行模式（`prod` / `dev` / `demo`） |
| `MEMOS_LOG_LEVEL` | `info` | 日志级别（`debug` / `info` / `warn` / `error`） |

---

## 六、常见问题 FAQ

**Q1：`5230` 端口被占用怎么办？**

单容器启动时改映射，例如宿主机用 8080：

```bash
docker run -d --name memos --restart unless-stopped \
  -p 8080:5230 \
  -v /www/wwwroot/memos/data:/var/opt/memos \
  docker.xuanyuan.run/neosmemo/memos:stable
```

浏览器访问 `http://服务器IP:8080`。Compose 中把 `ports` 改为 `"8080:5230"` 即可。

**Q2：数据存在哪里？**

宿主机挂载目录（上例为 `/www/wwwroot/memos/data`），容器内路径为 `/var/opt/memos`。其中包含 SQLite 数据库（如 `memos_prod.db`）与用户上传的附件。**删除该目录会丢失全部笔记**，升级镜像时请勿删除此目录。

**Q3：如何升级 Memos？**

```bash
# 单容器
docker pull docker.xuanyuan.run/neosmemo/memos:stable
docker stop memos && docker rm memos
# 再执行第三节 docker run（data 卷不变）

# Compose
cd /www/wwwroot/memos
docker compose pull
docker compose up -d
```

**Q4：日志里出现 `refresh token not found` 正常吗？**

正常。首次打开页面、尚未登录时，浏览器会尝试刷新 token，服务端返回 `Unauthenticated` 并记一条 `client error`，**不影响注册与使用**。注册登录后该日志一般不再出现。

**Q5：忘记密码怎么办？**

Memos 无内置「忘记密码邮件」的默认流程，需参考官方文档或通过数据库重置。请参阅：

```
https://usememos.com/docs
```

建议在注册时使用强密码，并妥善保存；生产环境可限制注册或仅内网访问。

**Q6：与 Docker Hub 官方镜像 `neosmemo/memos` 的关系？**

功能相同。`docker.xuanyuan.run/neosmemo/memos:stable` 为轩辕镜像加速的 Docker Hub 同步版，便于国内拉取。配置中将镜像名替换为轩辕域即可，其余命令与官方文档一致。

**Q7：可以多人同时使用吗？**

可以。管理员可在设置中管理用户与权限。小团队用 SQLite 通常足够；用户量较大时建议 **第四节 PostgreSQL 方案**。

**Q8：如何停止与卸载？**

```bash
# 单容器（保留 data 目录）
docker stop memos && docker rm memos

# Compose（保留 data 目录）
cd /www/wwwroot/memos && docker compose down

# 删除数据目录（慎用，笔记将全部丢失）
rm -rf /www/wwwroot/memos/data
```

**Q9：容器启动后浏览器无法访问？**

依次检查：`docker ps` 确认容器为 `Up`；`docker logs memos` 看报错；本机 `curl -I http://127.0.0.1:5230` 是否通；云服务器 **安全组 / 防火墙** 是否放行 5230；若仅绑定了内网 IP，需用正确地址访问。

---

## 七、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/neosmemo/memos:stable` |
| 快速启动 | `docker run -d --name memos --restart unless-stopped -p 5230:5230 -v /www/wwwroot/memos/data:/var/opt/memos docker.xuanyuan.run/neosmemo/memos:stable` |
| Compose 启动 | `cd /www/wwwroot/memos && docker compose up -d` |
| 查看日志 | `docker logs -f memos` 或 `docker compose logs -f memos` |
| 健康检查 | `curl -I http://127.0.0.1:5230` |
| Web 访问 | `http://服务器IP:5230` |
| 停止服务 | `docker stop memos && docker rm memos` |

---

## 八、延伸阅读

| 主题 | 链接 |
|------|------|
| 项目首页 | https://usememos.com |
| 官方文档 | https://usememos.com/docs |
| Docker 部署 | https://usememos.com/docs/deploy/docker |
| Docker Compose | https://usememos.com/docs/deploy/docker-compose |
| 反向代理 / HTTPS | https://usememos.com/docs/deploy/reverse-proxy |
| 在线 Demo | https://demo.usememos.com/ |
| GitHub 源码 | https://github.com/usememos/memos |
| 轩辕镜像页 | https://xuanyuan.cloud/zh/r/neosmemo/memos |
| 轩辕镜像 | https://xuanyuan.cloud |

---

**总结**：Memos = **私有化轻量 Markdown 笔记**，镜像 20MB、一条命令就能跑。个人试用选 **第三节单容器**，浏览器注册管理员 → 切换中文 → 写 memo；长期运行选 **第四节 Compose**，配合 **数据备份** 与 **反向代理 HTTPS**，笔记数据完全在自己服务器上。



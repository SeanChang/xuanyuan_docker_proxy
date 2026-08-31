# Docker 部署 Trilium Notes：打造属于自己的大型知识库

![Docker 部署 Trilium Notes：打造属于自己的大型知识库](https://imgs.xuanyuan.cloud/docker/blog/trilium.png)

*分类: Docker部署教程 | 标签: Trilium,TriliumNext,Docker,轩辕镜像,笔记,知识库,私有化部署,部署教程 | 发布时间: 2026-07-12 12:35:36*

> 零基础教程：TriliumNext 是什么、轩辕镜像加速拉取 triliumnext/trilium:main、一条 docker run 启动、首次向导与密码设置、日记/搜索/笔记地图/保护会话与 AI 同步配置。Ubuntu 24.04 实测含 17 张截图。

*本文基于 [triliumnext/trilium:main](https://xuanyuan.cloud/zh/r/triliumnext/trilium) 镜像，Ubuntu 24.04 服务器实测（访问端口 **8080**）*

Notion、语雀、Obsidian 各用各的，数据格式不互通？**Trilium Notes**（TriliumNext 社区版）是一款 **免费开源、可自托管的层级笔记应用**——支持深度笔记树、富文本 / Markdown / 代码笔记、全文搜索、笔记地图、思维导图、加密保护、多设备同步，官方宣称可支撑 **10 万+ 笔记** 规模的知识库。更关键的是：**单容器即可运行**，无需 MariaDB / Redis，**一条 `docker run` 就能上线**。

本文带你完成一次 **TriliumNext Docker 部署**：从轩辕镜像拉取、创建数据目录、`docker run` 一键启动，到浏览器跟做 **首次初始化向导**（语言 → 新建知识库 → 设置密码 → 登录），再浏览日记、搜索、笔记地图、保护会话，以及外观 / AI / 同步 / 代码笔记等设置——全程 Ubuntu 24.04 实测，附 **17 张截图**。

国内用户从 Docker Hub 拉取 `triliumnext/trilium` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速域 `docker.xuanyuan.run`。官方 Docker 文档见 [Using Docker](https://docs.triliumnotes.org/user-guide/setup/server/installation/docker)，项目文档 [TriliumNext Docs](https://triliumnext.github.io/Docs/)，源码 [TriliumNext/Trilium](https://github.com/TriliumNext/Trilium)。

> **部署要点**：TriliumNext 容器内数据目录为 **`/home/node/trilium-data`**（非旧版 `zadam/trilium` 的 `/data`）。轩辕镜像页部分示例仍写 `/data`，**请以本文与官方文档为准**。

## 一、Trilium Notes 是什么？

**Trilium Notes**（现由 **TriliumNext** 社区维护）是一款 **免费开源、跨平台的层级笔记应用**，专为构建和管理 **大型个人知识库** 设计。它是原 `zadam/trilium` 项目的社区延续版，Docker 镜像为 `triliumnext/trilium`。

| 能力 | 说明 |
|------|------|
| 层级笔记树 | 任意深度树状结构；单条笔记可通过 **克隆** 出现在多个位置 |
| 富文本 / Markdown | WYSIWYG 编辑器，支持表格、图片、LaTeX 公式、Markdown |
| 代码笔记 | 多语言语法高亮，可选 Vim 快捷键 |
| 全文搜索 | 快速导航、书签、笔记提升（Hoisting） |
| 笔记地图 | 可视化展示笔记间链接关系（知识图谱） |
| 日记（Journal） | 按年 / 月 / 日自动组织，适合每日记录 |
| 版本控制 | 笔记修订历史，可查看与恢复 |
| 加密保护 | 笔记级加密 + **保护会话**，敏感内容需二次密码 |
| 多设备同步 | 自托管服务器 + 桌面 / 移动客户端同步 |
| AI / MCP | 可配置 LLM 提供商；支持 MCP 端点供 AI 助手读写笔记 |
| 思维导图 / 画布 | Mind Elixir 思维导图、Excalidraw 画布笔记 |
| 数据导入导出 | Evernote、Markdown 等格式 |

典型使用场景：

- 个人 **大型知识库**、学习笔记、读书摘抄
- **学术研究**：文献笔记、实验记录、数学公式与代码片段
- **项目文档**：任务、进度、Wiki 式组织
- **敏感信息**：加密笔记 + 保护会话，数据完全在自有服务器

> **与 Memos 的区别**：Memos 偏轻量时间线随手记；Trilium 偏 **深度层级组织 + 知识图谱 + 脚本自动化**，适合笔记量大、结构复杂的用户。若只需极简 Markdown 时间线，可参考 [Memos 部署教程](./memos-docker-deploy.md)。

架构示意：

```text
浏览器 ──HTTP:8080──▶ Trilium 容器（单进程 + 内置 SQLite）
Trilium 容器 ──挂载卷──▶ 宿主机 trilium-data/（笔记数据库与附件）
桌面 / 移动客户端 ──同步协议──▶ 同一 Trilium 服务器
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 1 GB（推荐 2 GB；大型知识库建议 4 GB） |
| CPU | 双核即可 |
| 磁盘 | ≥ 2 GB（镜像 + 笔记数据与附件；知识库越大占用越多） |
| 端口 | **8080**（Trilium 默认 Web 端口） |
| 工作目录 | `/www/wwwroot/trilium`（独立目录，勿与其他项目混用） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```


备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```
更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

**镜像标签对照**：

| 标签 | 适用场景 |
|------|----------|
| `main` | 本文实测标签，跟随主分支构建，**适合试用** |
| `v0.91.6` 等版本号 | **生产推荐**，固定版本便于备份与回滚 |
| `latest` | 可能自动升级，**不建议生产**（尤其有同步客户端时） |

---

## 三、拉取镜像

```bash
docker pull docker.xuanyuan.run/triliumnext/trilium:main
```

成功时终端类似输出（**Ubuntu 24.04 实测**）：

```text
main: Pulling from triliumnext/trilium
55afa1ecc21d: Pull complete
6da5779e8eeb: Pull complete
7e2a5e2761f5: Pull complete
57eb903fc7a4: Pull complete
21af007bacf6: Pull complete
4f4fb700ef54: Pull complete
7f3b05c3b155: Pull complete
5df865968c63: Pull complete
3c672d20d5ad: Pull complete
773091eb7616: Pull complete
8fb5fe3424c8: Pull complete
328fa99b08e5: Download complete
Digest: sha256:86f8cd62cc6c864a734b364dc1a1c5357609c2f9e25a7e59367afb2f15708f99
Status: Downloaded newer image for docker.xuanyuan.run/triliumnext/trilium:main
docker.xuanyuan.run/triliumnext/trilium:main
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `triliumnext/trilium:main` | `docker pull docker.xuanyuan.run/triliumnext/trilium:main` |
| `triliumnext/trilium:v0.91.6` | `docker pull docker.xuanyuan.run/triliumnext/trilium:v0.91.6` |

---

## 四、快速体验：单容器部署

适合：个人试用、内网知识库、资源有限的 VPS。

### 4.1 创建数据目录

Trilium 必须将宿主机目录挂载到容器内 **`/home/node/trilium-data`**，否则重启后数据丢失。官方容器默认以 UID **1000** 写数据：

```bash
sudo mkdir -p /www/wwwroot/trilium/trilium-data
sudo chown -R 1000:1000 /www/wwwroot/trilium/trilium-data
cd /www/wwwroot/trilium
```

> **权限踩坑**：若日志出现 `EACCES` 或 `permission denied`，执行 `sudo chown -R 1000:1000 /www/wwwroot/trilium/trilium-data` 后重启容器。也可通过环境变量 `USER_UID` / `USER_GID` 指定运行用户（见第六节 FAQ）。

### 4.2 启动容器

镜像已拉取可跳过第三节，直接运行（**Ubuntu 24.04 实测命令**）：

```bash
docker run -d \
  --name trilium \
  --restart unless-stopped \
  -p 8080:8080 \
  -v /www/wwwroot/trilium/trilium-data:/home/node/trilium-data \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/triliumnext/trilium:main
```

成功时返回容器 ID，例如：

```text
c9d7c5cb8cb25d73b6686c1a275b3cb20e0e01a82c245fb63f8c8904571a9fcd
```

各参数说明：

| 配置 | 说明 |
|------|------|
| `-p 8080:8080` | 对外暴露 Web 访问端口 |
| `-v ...:/home/node/trilium-data` | **必须挂载**，持久化笔记数据库与附件 |
| `-e TZ=Asia/Shanghai` | 时区（非 Compose 场景官方建议手动设置） |
| `main` | 本文实测标签；生产建议固定版本号 |
| `--restart unless-stopped` | 宿主机重启后自动拉起 |

**仅本机访问**（配合 Nginx 反代时更安全）：

```bash
-p 127.0.0.1:8080:8080
```

**8080 已被占用**时改主机端口，例如 `-p 8081:8080`，浏览器访问 `:8081`。

### 4.3 验证启动

```bash
docker ps
docker logs -f trilium
```

`docker ps` 中容器状态为 **Up** 即表示运行中。快速探测：

```bash
curl -I http://127.0.0.1:8080
```

应返回 HTTP `200` 或 `302`。

---

## 五、浏览器首次初始化

浏览器打开：

```text
http://你的服务器IP:8080
```

以下按实测向导顺序跟做。

### 5.1 选择语言

首次进入会弹出 **语言** 选择，推荐选 **简体中文**，点击 **继续**。

![Trilium 首次访问：语言选择，推荐简体中文](https://imgs.xuanyuan.cloud/docker/blog/trilium-1.png)

### 5.2 新建知识库

选择 **开始使用 Trilium**，点击 **新建知识库**（从一个全新的知识库开始）。

若你已在其他设备运行 Trilium 服务器或桌面版，也可选 **连接到现有服务器** / **连接桌面应用** 进行同步；本文演示全新部署。

![Trilium 初始化：选择新建知识库](https://imgs.xuanyuan.cloud/docker/blog/trilium-2.png)

### 5.3 演示内容 or 空白

推荐首次体验选 **包含演示内容**，可快速了解 Trilium 的笔记类型、格式化、脚本等能力；熟悉后可删演示笔记。若希望从零开始，选 **空白**。

![Trilium 初始化：包含演示内容或空白知识库](https://imgs.xuanyuan.cloud/docker/blog/trilium-3.png)

### 5.4 等待知识库准备

选择后会出现 **正在准备你的知识库** 加载页，稍等片刻即可。

![Trilium 初始化：正在准备知识库](https://imgs.xuanyuan.cloud/docker/blog/trilium-4.png)

### 5.5 设置密码

Trilium 网页版需设置 **登录密码**（非多用户账号体系，单实例一个密码）。填写密码与确认密码，点击 **设置密码**。

![Trilium 初始化：设置登录密码](https://imgs.xuanyuan.cloud/docker/blog/trilium-5.png)

> **安全提示**：请使用强密码并妥善保存。若对公网开放 8080，务必尽快完成初始化。生产环境建议关闭公网直连，改用 **第九节反向代理 HTTPS**。

### 5.6 登录

设置完成后进入 **登录 Trilium Notes** 页面，输入刚才设置的密码，可勾选 **记住我**，点击 **登录**。

![Trilium 登录页：输入密码登录](https://imgs.xuanyuan.cloud/docker/blog/trilium-6.png)

---

## 六、主界面与核心功能

登录成功后进入 Trilium 主界面。若选了演示内容，左侧笔记树会出现 **Journal**（日记）与 **Trilium Demo** 等节点。

### 6.1 日记（Journal）与日历视图

**Journal** 按年 / 月 / 日自动组织笔记，中央可切换 **日 / 周 / 月 / 年 / 列表** 视图，适合每日记录与回顾。

![Trilium 主界面：Journal 日记与月历视图](https://imgs.xuanyuan.cloud/docker/blog/trilium-7.png)

### 6.2 创建笔记

在日记或任意节点下 **新建笔记**，中央为富文本编辑器，支持 **文本 / 画布 / 代码 / Markdown / 集合 / 模板** 等笔记类型，顶部工具栏提供格式化、链接、表格、代码块等能力。

![Trilium 新建笔记：富文本编辑器与笔记类型切换](https://imgs.xuanyuan.cloud/docker/blog/trilium-8.png)

### 6.3 全文搜索

点击左侧 **搜索** 图标，可输入关键词或标签（如 `#calendarRoot`）进行 **全文搜索**，结果按路径与属性展示，支持分页浏览。

![Trilium 全文搜索：关键词与标签检索结果](https://imgs.xuanyuan.cloud/docker/blog/trilium-9.png)

### 6.4 快速搜索（Quick Search）

按快捷键或点击搜索栏，弹出 **快速搜索**  overlay：可按名称或类型搜索笔记，查看最近访问，或 **Ctrl + Enter** 触发全文搜索。

![Trilium 快速搜索：按名称搜索与最近访问](https://imgs.xuanyuan.cloud/docker/blog/trilium-10.png)

### 6.5 笔记地图（Note Map）

**笔记地图** 以节点与箭头可视化笔记间的链接关系，适合梳理知识结构与发现关联。演示内容中 **Trilium Demo** 与各子笔记的链接一目了然。

![Trilium 笔记地图：知识图谱可视化](https://imgs.xuanyuan.cloud/docker/blog/trilium-11.png)

### 6.6 最近修改

点击 **最近修改** 可查看按时间排序的编辑历史，快速回到刚改过的笔记。

![Trilium 最近修改：按时间线查看编辑历史](https://imgs.xuanyuan.cloud/docker/blog/trilium-12.png)

---

## 七、安全、设置与扩展

### 7.1 保护会话（Protected Session）

Trilium 支持 **笔记级加密**。访问受保护笔记时，需输入密码进入 **保护会话**。点击左侧盾牌图标，在弹窗中输入密码后点击 **开始保护会话**。

![Trilium 保护会话：输入密码访问加密笔记](https://imgs.xuanyuan.cloud/docker/blog/trilium-13.png)

### 7.2 外观设置

左下角 **选项（Options）** → **外观**：可切换 **应用主题**（如「现代」）、**配色方案**（跟随系统 / 浅色 / 深色）、**版面样式**（旧布局 / 新布局）等。

![Trilium 选项：外观主题与深色模式](https://imgs.xuanyuan.cloud/docker/blog/trilium-14.png)

### 7.3 AI / LLM 与 MCP

**选项 → AI / LLM**：可添加 LLM 提供商，启用右侧 **AI 对话** 面板；还可开启 **MCP 服务器**，供 Claude Code、GitHub Copilot 等 AI 助手读写笔记（默认仅本地访问）。

![Trilium 选项：AI 提供商与 MCP 配置](https://imgs.xuanyuan.cloud/docker/blog/trilium-15.png)

### 7.4 同步设置

**选项 → 同步**：填写 **服务器地址**（如 `https://notes.example.com`），桌面版与移动版可与此 Docker 实例同步。部署在本机时可填 `http://服务器IP:8080` 进行内网测试。

![Trilium 选项：同步服务器地址配置](https://imgs.xuanyuan.cloud/docker/blog/trilium-16.png)

### 7.5 代码笔记设置

**选项 → 代码笔记**：配置 **自动换行**、**制表符宽度**、**Vim 快捷键**、**CodeMirror 主题**（如 VS Code Dark）等，适合开发者维护代码片段库。

![Trilium 选项：代码笔记编辑器与 Vim 配置](https://imgs.xuanyuan.cloud/docker/blog/trilium-17.png)

---

## 八、生产推荐：Docker Compose

适合：长期运行、需要可复现配置、便于 `git` 管理部署文件的场景。

### 8.1 目录结构

```bash
cd /www/wwwroot/trilium
```

将包含：

```text
/www/wwwroot/trilium/
├── docker-compose.yml
└── trilium-data/          # 笔记数据（需 chown 1000:1000）
```

### 8.2 编写 `docker-compose.yml`

基于 [官方 docker-compose.yml](https://github.com/TriliumNext/Trilium/blob/main/docker-compose.yml)，镜像改为轩辕加速域：

```yaml
services:
  trilium:
    image: docker.xuanyuan.run/triliumnext/trilium:v0.91.6
    container_name: trilium
    restart: unless-stopped
    environment:
      - TRILIUM_DATA_DIR=/home/node/trilium-data
      - TZ=Asia/Shanghai
    ports:
      - "8080:8080"
    volumes:
      - ./trilium-data:/home/node/trilium-data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
```

> 生产环境请将 `main` 换为固定版本标签（如 `v0.91.6`），避免自动升级破坏同步。

### 8.3 启动与运维

```bash
docker compose up -d
docker compose ps
docker compose logs -f trilium
```

常用运维：

```bash
# 升级：先备份 trilium-data/
docker compose pull
docker compose up -d

# 停止（保留数据）
docker compose down
```

### 8.4 生产环境注意

- **HTTPS**：将 Trilium 放在 Nginx、Caddy 或 Traefik **反向代理** 之后，对外只暴露 443。官方文档：[Nginx Proxy Setup](https://docs.triliumnotes.org/user-guide/setup/server/installation/nginx-proxy-setup)、[TLS Configuration](https://docs.triliumnotes.org/user-guide/setup/server/installation/tls-configuration)。
- **备份**：定期打包宿主机 `trilium-data/` 目录（含 SQLite 数据库与附件）。
- **防火墙**：若必须直连端口，可 `sudo ufw allow 8080/tcp`；云服务器需在 **安全组** 放行。更推荐仅反代对外、8080 仅内网访问。
- **多因素认证**：可在 **选项 → 密码与认证** 中配置 TOTP 等，详见官方 [Multi-Factor Authentication](https://docs.triliumnotes.org/user-guide/setup/server/installation/multi-factor-authentication)。

---

## 九、从旧版 zadam/trilium 迁移

TriliumNext 是原 `zadam/trilium` 的社区延续版。迁移步骤：

1. 停止原 `zadam/trilium` 容器
2. 用 **同一宿主机数据目录** 挂载到新镜像的 `/home/node/trilium-data`
3. 启动新容器，自动识别现有数据库

**版本兼容性**：v0.90.4 及以下与原 zadam/trilium v0.63.7 兼容；更高版本因同步协议更新，跨版本迁移需查阅 [TriliumNext 文档](https://triliumnext.github.io/Docs/)。

---

## 十、常见问题 FAQ

**Q1：轩辕镜像页写挂载 `/data`，为什么本文用 `/home/node/trilium-data`？**

TriliumNext 官方镜像（`triliumnext/trilium`）数据目录为 **`/home/node/trilium-data`**。`/data` 是旧版 `zadam/trilium` 或部分第三方镜像的写法。挂载路径错误会导致 **数据未持久化**，容器重建后笔记丢失。

**Q2：`8080` 端口被占用怎么办？**

```bash
docker run -d --name trilium --restart unless-stopped \
  -p 8081:8080 \
  -v /www/wwwroot/trilium/trilium-data:/home/node/trilium-data \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/triliumnext/trilium:main
```

浏览器访问 `http://服务器IP:8081`。

**Q3：数据存在哪里？**

宿主机 `/www/wwwroot/trilium/trilium-data`，容器内 `/home/node/trilium-data`。含 SQLite 数据库与用户上传附件。**删除该目录会丢失全部笔记**。

**Q4：权限报错 `EACCES` 怎么办？**

```bash
sudo chown -R 1000:1000 /www/wwwroot/trilium/trilium-data
docker restart trilium
```

或通过环境变量指定 UID/GID：

```bash
docker run -d ... -e USER_UID=1000 -e USER_GID=1000 ...
```

**Q5：`main` 和 `latest` 能用吗？**

可以试用，但官方 **不建议生产使用**——可能自动升级导致同步客户端不兼容。推荐固定版本号如 `v0.91.6`。

**Q6：如何升级 Trilium？**

```bash
# 单容器：先备份 trilium-data/
docker pull docker.xuanyuan.run/triliumnext/trilium:v0.91.6
docker stop trilium && docker rm trilium
# 再执行第四节 docker run（数据卷不变）

# Compose
cd /www/wwwroot/trilium && docker compose pull && docker compose up -d
```

**Q7：忘记密码怎么办？**

Trilium 无默认「忘记密码邮件」流程。需在服务器数据目录中重置，或参考官方 [FAQ / Troubleshooting](https://triliumnext.github.io/Docs/)。建议初始化时使用强密码并妥善保存。

**Q8：容器启动后浏览器无法访问？**

依次检查：`docker ps` 确认 `Up`；`docker logs trilium` 看报错；本机 `curl -I http://127.0.0.1:8080`；云服务器 **安全组 / 防火墙** 是否放行 8080。

**Q9：与 Docker Hub 官方镜像的关系？**

功能相同。`docker.xuanyuan.run/triliumnext/trilium` 为轩辕镜像加速的 Docker Hub 同步版，便于国内拉取。配置中将镜像名替换为轩辕域即可。

**Q10：如何停止与卸载？**

```bash
# 单容器（保留 trilium-data/）
docker stop trilium && docker rm trilium

# Compose
cd /www/wwwroot/trilium && docker compose down

# 删除数据（慎用）
rm -rf /www/wwwroot/trilium/trilium-data
```

---

## 十一、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/triliumnext/trilium:main` |
| 创建数据目录 | `sudo mkdir -p /www/wwwroot/trilium/trilium-data && sudo chown -R 1000:1000 /www/wwwroot/trilium/trilium-data` |
| 快速启动 | 见第四节 `docker run` 完整命令 |
| Compose 启动 | `cd /www/wwwroot/trilium && docker compose up -d` |
| 查看日志 | `docker logs -f trilium` |
| 健康检查 | `curl -I http://127.0.0.1:8080` |
| Web 访问 | `http://服务器IP:8080` |
| 备份数据 | `tar czf trilium-backup-$(date +%F).tar.gz -C /www/wwwroot/trilium trilium-data` |
| 停止服务 | `docker stop trilium && docker rm trilium` |

---

## 十二、延伸阅读

| 主题 | 链接 |
|------|------|
| 轩辕镜像页 | https://xuanyuan.cloud/zh/r/triliumnext/trilium |
| 官方 Docker 文档 | https://docs.triliumnotes.org/user-guide/setup/server/installation/docker |
| TriliumNext 文档索引 | https://triliumnext.github.io/Docs/ |
| GitHub 源码 | https://github.com/TriliumNext/Trilium |
| Docker Hub 镜像 | https://hub.docker.com/r/triliumnext/trilium |
| 官方 docker-compose.yml | https://github.com/TriliumNext/Trilium/blob/main/docker-compose.yml |
| Nginx 反向代理 | https://docs.triliumnotes.org/user-guide/setup/server/installation/nginx-proxy-setup |
| 同步说明 | https://docs.triliumnotes.org/user-guide/setup/server/synchronization |
| 备份说明 | https://docs.triliumnotes.org/user-guide/setup/server/backup |
| 轩辕镜像 | https://xuanyuan.cloud |

---

**总结**：Trilium Notes = **私有化大型层级知识库**，单容器、一条命令就能跑。个人试用选 **第四节单容器** + **第五节浏览器向导**；长期运行选 **第八节 Compose**，配合 **数据备份** 与 **反向代理 HTTPS**。数据目录务必挂载到 **`/home/node/trilium-data`**，笔记与知识图谱完全在自己服务器上。



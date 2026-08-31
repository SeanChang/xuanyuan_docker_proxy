# Docker 部署思源笔记：轻松搭建本地优先的知识管理平台

![Docker 部署思源笔记：轻松搭建本地优先的知识管理平台](https://imgs.xuanyuan.cloud/docker/blog/siyuan.webp)

*分类: Docker部署教程 | 标签: SiYuan,思源笔记,Docker,轩辕镜像,知识管理,双链笔记,私有化部署,部署教程 | 发布时间: 2026-08-28 04:12:58*

> 会议纪要还在 Notion 草稿箱，读书摘录在语雀，代码旁注又在另一台笔记本的 Markdown 文件夹里——换电脑就要翻同步盘，搜一句关键词得开三四个标签页。双链、块引用这些能力一旦绑死在厂商账号或某一台客户端上，内网里就很难共用同一份库。

*本文基于 [b3log/siyuan:v3.8.1](https://xuanyuan.cloud/zh/r/b3log/siyuan)，实测版本 **v3.8.1**，测试平台 **Ubuntu 24.04** Linux。*

会议纪要还在 Notion 草稿箱，读书摘录在语雀，代码旁注又在另一台笔记本的 Markdown 文件夹里——换电脑就要翻同步盘，搜一句关键词得开三四个标签页。双链、块引用这些能力一旦绑死在厂商账号或某一台客户端上，内网里就很难共用同一份库。

把 **工作区** 放在自己的 NAS 或家用服务器上，笔记落在 **`./workspace`** 目录，删容器不丢数据，手机与电脑用浏览器走同一入口 **6806**。在线笔记要订阅、内容在厂商侧；纯桌面客户端又要自己折腾同步。家里已经有一台跑 Docker 的 Ubuntu，剩下就是拉镜像、设访问口令、把卷挂对。

**SiYuan（思源笔记）**（[GitHub · siyuan-note/siyuan](https://github.com/siyuan-note/siyuan)）按 **块** 组织内容，支持双向链接、Markdown 所见即所得、闪卡与集市插件。官方镜像 **`b3log/siyuan`**（[镜像页](https://xuanyuan.cloud/zh/r/b3log/siyuan)）在容器里跑内核，浏览器打开即用。许可证 **AGPLv3**；多数功能免费。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 浏览器写笔记 | `http://服务器IP:6806` 输入访问授权码进入工作区 |
| 块级双链 | 建笔记本 → 写块 → 块引用 / 反链面板查关联 |
| 集市扩展 | 装插件、换主题、套模板（容器需能访问外网） |
| 备份搬家 | 停容器后备份整个 `./workspace` 目录 |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`b3log/siyuan:v3.8.1`**，**Docker Compose** 映射 **6806→6806**。局域网示例 **`192.168.1.35`**，请换成你的 IP。文内 **13** 张截图按操作顺序编号；无 Compose 见第八节 **`docker run`**。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **访问**：宿主机 **6806** → 容器 **6806**（`http://192.168.1.35:6806`）
> - **数据**：`./workspace` → `/siyuan/workspace`；`command` 必须含 **`serve`**（**v3.7.0** 起）
> - **授权码**：跟做 **`ChangeMe_siyuan`**，上线立刻改掉；对应环境变量 `SIYUAN_ACCESS_AUTH_CODE`
> - **权限**：**PUID/PGID=1000**；宿主机目录先 `chown` 对齐
> - **语言**：跟做设 `SIYUAN_LANG=zh-CN`
> - **标签**：钉死 **`v3.8.1`**，勿写 `latest`
> - **Docker 版限制**：仅浏览器；桌面/移动 App 不能连此实例；容器内不能导出 PDF/HTML/Word、不能导入 Markdown 文件

官方 Docker 说明：[README · Docker Hosting](https://github.com/siyuan-note/siyuan/blob/master/README.md#docker-hosting)。用户指南：[中文](https://b3log.org/siyuan/) / [English](https://siyuan-en.b3log.org/)。

---

## 一、SiYuan 是什么？

思源把段落、列表、代码块等拆成可独立引用的 **块**，再用双向链接串起来。本文跟做的是 **Docker 服务端**：容器里跑内核，浏览器访问 **6806**；与 Windows / macOS 安装包、手机 App 是不同入口，**不能**用 App 直连这个 Docker 实例。

| | SiYuan Docker（本文） | 云笔记 SaaS | 纯桌面客户端 |
|--|----------------------|-------------|--------------|
| 入口 | 浏览器 `:6806` | 厂商网址 | 本机安装包 |
| 数据 | `./workspace` | 厂商机房 | 本机文件夹 |
| 双链 / 块 | 支持 | 因产品而异 | 支持 |
| 适合 | 内网共用、自托管 | 少运维 | 单机重度写作 |
| 注意 | 功能子集见上手要点 | 出域、订阅 | 跨设备需自备同步 |

```text
浏览器  ──http://IP:6806──▶  b3log/siyuan (serve)
                                  └── /siyuan/workspace  ← 宿主机 ./workspace
```

### 1.1 同站其它 siyuan 镜像

只跟 **`b3log/siyuan`**。第三方包启动参数、数据路径不同，**勿混用**同一份 `./workspace`：

| 镜像 | 说明 | 轩辕镜像页 |
|------|------|------------|
| **`b3log/siyuan`（本文）** | 官方社区镜像 | [b3log/siyuan](https://xuanyuan.cloud/zh/r/b3log/siyuan) |
| **`nfew/siyuan`** | 社区改包（极空间等） | [nfew/siyuan](https://xuanyuan.cloud/zh/r/nfew/siyuan) |
| **`zsource/siyuan`** 等 | 设备厂商打包 | [zsource/siyuan](https://xuanyuan.cloud/zh/r/zsource/siyuan) |

`/r/` 与 `/zh/r/` 是同一镜像不同页面：[概览](https://xuanyuan.cloud/r/b3log/siyuan) · [中文](https://xuanyuan.cloud/zh/r/b3log/siyuan) · [tags](https://xuanyuan.cloud/r/b3log/siyuan/tags)。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（完整列表见 tags 页） |
| 内存 | ≥ **1 GB**；库大、集市插件多时再往上加 |
| 磁盘 | 实测镜像 CONTENT **96.3 MB** / DISK **321 MB**；笔记另算 |
| 端口 | 宿主机 **6806**（占用时改左侧，如 `"16806:6806"`） |

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

```bash
ss -tlnp | grep 6806
```

---

## 三、标签怎么选

跟做只写 **`v3.8.1`**，与 [GitHub Release v3.8.1](https://github.com/siyuan-note/siyuan/releases/tag/v3.8.1) 一致（2026-08-18）。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`v3.8.1`** | 当前稳定版 | **本文跟做** |
| `v3.8.0` / `v3.7.x` | 更早稳定版 | 回滚 |
| `*-alpha*` / `*-rc*` / `*-beta*` | 预发布 | 仅尝鲜 |
| `latest` | 浮动 | **勿写入跟做命令** |

完整列表：[tags](https://xuanyuan.cloud/r/b3log/siyuan/tags)。**v3.7.0** 起启动必须带 **`serve`**。升级时 pull、Compose、run 三处一起改标签，先备份 `./workspace`。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/b3log/siyuan:v3.8.1
```

Ubuntu 24.04 实测（`ikuai-ubuntu2404`）：

```text
v3.8.1: Pulling from b3log/siyuan
Digest: sha256:8e6395e3c328b57bcb47c101e67a7e7fbb02d8a7b748ba21f583309d03dbe539
Status: Downloaded newer image for docker.xuanyuan.run/b3log/siyuan:v3.8.1
docker.xuanyuan.run/b3log/siyuan:v3.8.1
```

```bash
docker images docker.xuanyuan.run/b3log/siyuan:v3.8.1
```

```text
IMAGE                                     ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/b3log/siyuan:v3.8.1   8e6395e3c328        321MB         96.3MB
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/siyuan` |
| **macOS** | **`~/docker/siyuan`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\siyuan` |

### 5.1 准备目录

工作区属主须与 **PUID/PGID** 一致（默认 **1000:1000**）：

```bash
mkdir -p /www/wwwroot/siyuan/workspace
chown -R 1000:1000 /www/wwwroot/siyuan/workspace
cd /www/wwwroot/siyuan

# macOS：mkdir -p ~/docker/siyuan/workspace && cd ~/docker/siyuan
```

`id` 不是 1000 时，同步改 `chown` 与 Compose 里的 `PUID`/`PGID`。非 root 给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

授权码上线前换成自己的，勿提交到 Git：

```bash
cat > docker-compose.yml <<'EOF'
services:
  siyuan:
    image: docker.xuanyuan.run/b3log/siyuan:v3.8.1
    container_name: siyuan
    restart: unless-stopped
    ports:
      - "6806:6806"
    environment:
      TZ: Asia/Shanghai
      PUID: "1000"
      PGID: "1000"
      SIYUAN_LANG: zh-CN
      SIYUAN_ACCESS_AUTH_CODE: ChangeMe_siyuan
    volumes:
      - ./workspace:/siyuan/workspace
    command:
      - serve
      - --workspace=/siyuan/workspace/
EOF
```

| 项 | 说明 |
|----|------|
| `command` | 必须含 **`serve`**；`--workspace` 与挂载路径一致 |
| `volumes` | `./workspace` → `/siyuan/workspace` |
| `SIYUAN_ACCESS_AUTH_CODE` | 锁屏口令；也可写 `--accessAuthCode=`（命令行优先） |
| `PUID` / `PGID` | 与宿主机目录属主对齐 |
| `SIYUAN_LANG` | 跟做 `zh-CN`；删掉则沿用设置里保存的语言 |

授权码可放 `.env` 引用。内网临时关锁屏：`SIYUAN_ACCESS_AUTH_CODE_BYPASS=true`（公网勿开）。OIDC 见官方 README。

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network siyuan_default Created
 ✔ Container siyuan       Started
```

```text
NAME      IMAGE                                     COMMAND                  SERVICE   CREATED         STATUS         PORTS
siyuan    docker.xuanyuan.run/b3log/siyuan:v3.8.1   "/opt/siyuan/entrypo…"   siyuan    4 seconds ago   Up 2 seconds   0.0.0.0:6806->6806/tcp, [::]:6806->6806/tcp
```

```text
siyuan  | Creating group siyuan (1000)
siyuan  | Creating user siyuan (PUID: 1000, PGID: 1000)
siyuan  | Adjusting ownership of /opt/siyuan, /home/siyuan/, and /siyuan/workspace/
```

entrypoint 会先建用户、改工作区属主，日志停在上面几行是正常的。确认映射为 **`0.0.0.0:6806->6806/tcp`**，浏览器访问宿主机 IP 的 **6806**，不要用 `172.x` 容器地址。

刚 `up` 完内核可能还没监听。等十几秒再探测：

```bash
sleep 15
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:6806
```

```text
401
```

**401 表示内核已在监听**，未带访问授权码时拒绝匿名访问，属于正常——说明服务就绪。刚 `up` 完立刻探测可能仍是 **`000`**（连接失败，entrypoint 尚未跑完）；等十几秒后再 `curl` 或直接用浏览器打开锁屏页。

也可浏览器访问 `http://127.0.0.1:6806`。

---

## 六、浏览器首次进入

```text
http://192.168.1.35:6806
```

### 6.1 解锁访问

锁屏页标题 **workspace**，输入框提示「请输入锁屏密码」，填 **`ChangeMe_siyuan`**，点 **解锁访问**。可勾选「记住我 30 天」。

![SiYuan 锁屏页：请输入锁屏密码并点解锁访问](https://imgs.xuanyuan.cloud/docker/blog/siyuan-1.webp)

### 6.2 主界面

解锁后为暗色界面：左侧 **文档** 树有 **我的笔记本**，编辑区打开 **全新的开始**（按 `/` 可调命令面板）。右下角气泡可 **导入已有数据**、**登录并同步** 或打开 **用户指南**。跟做已设 `SIYUAN_LANG=zh-CN`，界面应为简体中文。

![SiYuan 首次进入：我的笔记本与欢迎气泡](https://imgs.xuanyuan.cloud/docker/blog/siyuan-2.webp)

### 6.3 账号与同步（可选）

右上角 **设置 → 账号与同步** 可登录链滴账号做云同步（部分能力需会员）。**写笔记不依赖这步**；也**不要**用百度网盘、OneDrive 等直接同步 `./workspace` 目录——官方明确不支持，容易损坏数据。

![SiYuan 设置：账号与同步](https://imgs.xuanyuan.cloud/docker/blog/siyuan-3.webp)

### 6.4 写第一篇笔记

1. 左侧 **我的笔记本** 上右键 → **新建文档**（或点笔记本旁的 **+**）。
2. 标题填 **我的第一篇笔记**，正文随便写几行，刷新页面确认还在。
3. 左侧可展开 **思源笔记用户指南** 对照功能说明。

选中一段文字，用块菜单做 **块引用**，右侧 **反链** 面板能看到引用关系——这是思源和纯 Markdown 文件夹的主要差别。

![SiYuan：我的第一篇笔记编辑页](https://imgs.xuanyuan.cloud/docker/blog/siyuan-4.webp)

笔记落在宿主机 **`./workspace/data/`** 下（容器内 `/siyuan/workspace`）。结构说明见官方 FAQ [How does SiYuan store data?](https://github.com/siyuan-note/siyuan/blob/master/README.md#how-does-siyuan-store-data)。

---

## 七、外观、集市与其它设置

以下均在右上角 **设置** 里，截图按 **图 5～13** 顺序排列。

### 7.1 外观

**外观** 可换主题（如实测默认 **midnight**）、图标包、代码高亮，以及菜单栏 **简洁 / 完整** 方案。

![SiYuan 设置：外观与主题](https://imgs.xuanyuan.cloud/docker/blog/siyuan-5.webp)

### 7.2 集市

首次打开 **集市** 会要求点 **信任**（信任后不可关闭）。容器需能访问外网才能拉列表。信任后按顶部分页浏览：

![SiYuan 集市：首次信任提示](https://imgs.xuanyuan.cloud/docker/blog/siyuan-6.webp)

| 分页 | 能装什么 |
|------|----------|
| 插件 | AI 助手、任务管理、主页等 |
| 主题 | Neo、Asri、Savor 等 |
| 图标 / 模板 / 挂件 | 图标包、日记模板、白板与甘特图等 |

![SiYuan 集市：插件列表](https://imgs.xuanyuan.cloud/docker/blog/siyuan-7.webp)

![SiYuan 集市：主题列表](https://imgs.xuanyuan.cloud/docker/blog/siyuan-8.webp)

![SiYuan 集市：图标列表](https://imgs.xuanyuan.cloud/docker/blog/siyuan-9.webp)

![SiYuan 集市：模板列表](https://imgs.xuanyuan.cloud/docker/blog/siyuan-10.webp)

![SiYuan 集市：挂件列表](https://imgs.xuanyuan.cloud/docker/blog/siyuan-11.webp)

### 7.3 人工智能与搜索

**人工智能**：添加 OpenAI 兼容端点（DeepSeek、Kimi、MiniMax 等），配默认模型与 Token 上限。跟做可不填 Key。

![SiYuan 设置：人工智能 API 提供商](https://imgs.xuanyuan.cloud/docker/blog/siyuan-12.webp)

**搜索**：按块类型、属性、反链提及等开关索引范围；库变大后用来减少无关命中。

![SiYuan 设置：搜索与块类型开关](https://imgs.xuanyuan.cloud/docker/blog/siyuan-13.webp)

### 7.4 公网与反向代理

暴露到公网时：**HTTPS** + 强授权码（或 OIDC），不要裸奔 **6806**。Nginx 反代须给 **`/ws`** 配 WebSocket，不要用 URL 重写绕认证。

---

## 八、备选：docker run

无 Compose、临时试玩：

```bash
mkdir -p /www/wwwroot/siyuan/workspace
chown -R 1000:1000 /www/wwwroot/siyuan/workspace

docker run -d \
  --name siyuan \
  --restart unless-stopped \
  -p 6806:6806 \
  -e TZ=Asia/Shanghai \
  -e PUID=1000 \
  -e PGID=1000 \
  -e SIYUAN_LANG=zh-CN \
  -e SIYUAN_ACCESS_AUTH_CODE=ChangeMe_siyuan \
  -v /www/wwwroot/siyuan/workspace:/siyuan/workspace \
  docker.xuanyuan.run/b3log/siyuan:v3.8.1 \
  serve \
  --workspace=/siyuan/workspace/
```

日常仍建议第五节 Compose，改环境变量和升级标签更方便。

---

## 九、迁移与升级

1. `docker compose stop`（或确认无写入）后，打包整个 **`./workspace`**。
2. 把 Compose / run 里的 **`v3.8.1`** 改成目标标签（先查 [tags](https://xuanyuan.cloud/r/b3log/siyuan/tags) 与 [Changelog](https://github.com/siyuan-note/siyuan/blob/master/CHANGELOG.md)）。
3. 拉取并重建：

```bash
cd /www/wwwroot/siyuan
docker compose pull
docker compose up -d
docker compose logs --tail 80
```

跨大版本先在测试机验证。数据仓库密钥丢失等见官方 FAQ，与 Docker 挂载无关。

---

## 十、常见问题 FAQ

**Q：刚启动 `curl` 返回 `000`，容器却是 Up？**  
A：entrypoint 还在建用户、改属主，内核尚未监听 **6806**。等十几秒再试；就绪后未带授权码探测常见 **`401`**（服务已起来，需锁屏口令），浏览器可正常打开锁屏页。

**Q：`curl` 返回 `401` 是不是部署失败？**  
A：不是。思源未认证访问会返回 **401**，说明 **6806** 已在监听；在浏览器输入 `SIYUAN_ACCESS_AUTH_CODE` 解锁即可。若长期 **`000`** 或连接被拒绝，再查 `docker compose logs`。

**Q：漏写 `serve`，容器起不来？**  
A：**v3.7.0** 起必须显式 `serve`。查看选项：`docker run --rm docker.xuanyuan.run/b3log/siyuan:v3.8.1 serve --help`。

**Q：工作区权限错误 / 无法写入？**  
A：`chown -R 1000:1000 /www/wwwroot/siyuan/workspace`，并与 Compose 里 `PUID`/`PGID` 一致。

**Q：挂载路径写错？**  
A：数据可能落在容器可写层，删容器即丢。`-v` 左侧必须是宿主机目录，且与 `--workspace` 一致。

**Q：桌面 / 手机 App 连不上？**  
A：Docker 托管**仅浏览器**。要用 App 请装官方客户端，走其支持的同步方案，不能直连本容器。

**Q：反向代理后空白或认证失败？**  
A：检查 **`/ws`** WebSocket 配置；避免破坏会话的 URL 重写。

**Q：能用网盘同步 `./workspace` 吗？**  
A：不能。官方不支持第三方同步盘直接同步工作区，请整目录备份或走官方云同步。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/b3log/siyuan:v3.8.1

# Compose（主路径）
cd /www/wwwroot/siyuan
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
docker compose pull && docker compose up -d
docker compose down          # 不删 ./workspace

# 备选 run
docker run -d --name siyuan --restart unless-stopped -p 6806:6806 \
  -e PUID=1000 -e PGID=1000 -e SIYUAN_LANG=zh-CN \
  -e SIYUAN_ACCESS_AUTH_CODE=ChangeMe_siyuan \
  -v /www/wwwroot/siyuan/workspace:/siyuan/workspace \
  docker.xuanyuan.run/b3log/siyuan:v3.8.1 \
  serve --workspace=/siyuan/workspace/
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [b3log/siyuan 镜像页](https://xuanyuan.cloud/zh/r/b3log/siyuan) | [https://xuanyuan.cloud/zh/r/b3log/siyuan](https://xuanyuan.cloud/zh/r/b3log/siyuan) |
| [b3log/siyuan 标签列表](https://xuanyuan.cloud/r/b3log/siyuan/tags) | [https://xuanyuan.cloud/r/b3log/siyuan/tags](https://xuanyuan.cloud/r/b3log/siyuan/tags) |
| [GitHub · siyuan-note/siyuan](https://github.com/siyuan-note/siyuan) | [https://github.com/siyuan-note/siyuan](https://github.com/siyuan-note/siyuan) |
| [README · Docker Hosting](https://github.com/siyuan-note/siyuan/blob/master/README.md#docker-hosting) | [https://github.com/siyuan-note/siyuan/blob/master/README.md#docker-hosting](https://github.com/siyuan-note/siyuan/blob/master/README.md#docker-hosting) |
| [SiYuan 中文站点](https://b3log.org/siyuan/) | [https://b3log.org/siyuan/](https://b3log.org/siyuan/) |
| [SiYuan 用户指南（英文）](https://siyuan-en.b3log.org/) | [https://siyuan-en.b3log.org/](https://siyuan-en.b3log.org/) |
| [GitHub Releases · v3.8.1](https://github.com/siyuan-note/siyuan/releases/tag/v3.8.1) | [https://github.com/siyuan-note/siyuan/releases/tag/v3.8.1](https://github.com/siyuan-note/siyuan/releases/tag/v3.8.1) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |
| [轩辕镜像常见问题](https://xuanyuan.cloud/faq) | [https://xuanyuan.cloud/faq](https://xuanyuan.cloud/faq) |

---

## 总结

- **SiYuan Docker** = 浏览器 + **`./workspace`** + 访问授权码，适合内网块级笔记。
- 跟做 **`b3log/siyuan:v3.8.1`**，[轩辕镜像](https://xuanyuan.cloud) 加速拉取，Compose 映射 **6806**，命令带 **`serve`**。
- 上线改掉示例口令；公网 HTTPS + **`/ws`** 反代；备份整目录，勿用网盘硬同步工作区。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/siyuan-docker-deploy



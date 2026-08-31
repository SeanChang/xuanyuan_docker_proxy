# Docker 部署 TypeWords：轻松搭建英语单词与文章练习平台

![Docker 部署 TypeWords：轻松搭建英语单词与文章练习平台](https://imgs.xuanyuan.cloud/docker/blog/typewords.webp)

*分类: Docker部署教程 | 标签: TypeWords,Docker,轩辕镜像,英语学习,背单词,打字练习,私有化部署,部署教程 | 发布时间: 2026-08-25 03:48:49*

> 四级考前那一个月，最常见的不是「在自己电脑上安安静静背」，而是：教室机房的电脑装不了背单词 App，手机上要登录、弹会员、断网就同步失败；回宿舍换一台电脑，打卡天数和错词本还留在上一个账号里。考研、雅思也一样——词表在 App 里，例句和听力却要另开网页；真要练拼写时，手指还是在手机小键盘上点，打完一个长词，记忆曲线早就被通知打断了。

*本文基于 [zyronon/typewords:3.0.4](https://xuanyuan.cloud/zh/r/zyronon/typewords)，实测版本 **3.0.4**，生产阶段 **nginx/1.31.3**，测试平台 **Ubuntu 24.04** Linux。*

四级考前那一个月，最常见的不是「在自己电脑上安安静静背」，而是：教室机房的电脑装不了背单词 App，手机上要登录、弹会员、断网就同步失败；回宿舍换一台电脑，打卡天数和错词本还留在上一个账号里。考研、雅思也一样——词表在 App 里，例句和听力却要另开网页；真要练拼写时，手指还是在手机小键盘上点，打完一个长词，记忆曲线早就被通知打断了。

公共机房、图书馆电子阅览室、培训班的机位，往往只给浏览器。老师想让全班对着同一套 CET-4 或考研词库跟写，既不想让三十个人各自下一个要实名的客户端，也不想把班级词表交到某个云同步账号里。自己 clone 源码、装 Node 再编成静态页，对只想先有一个内网网址的人又不划算：缺的是镜像拉起来、浏览器打开就能敲。

把练习站放到宿舍小主机、家里的 NAS，或机房那台已有 Docker 的 Ubuntu 上，一个 `http://IP:端口` 全班共用。各人用自己的浏览器，进度互不相通，清不了别人的错词本，也不用为去广告付钱。**TypeWords**（[typewords.cc](https://typewords.cc)）就是做这件事的开源工具：对着屏幕**逐键输入**，用记忆曲线安排今天练哪些词；跟写、听写、默写和文章跟打都在同一个页面，内置四六级、考研、雅思、专四专八等词库。镜像 **`zyronon/typewords`**（[镜像页](https://xuanyuan.cloud/zh/r/zyronon/typewords)）把这套前端交给 **Nginx** 托管，容器内监听 **80**——无数据库、无登录。进度写在**当前浏览器**里，换设备要自己备份。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 个人备考 | 打开 `http://服务器IP:8080`，选 CET-4 等词库，按引导开始跟写 |
| 宿舍 / 机房共用 | 同一地址，各人用自己的浏览器，进度互不影响 |
| 文章跟打 | 侧栏 **文章**，新概念或自行导入 |
| 导入自己的词 | 单词页支持 txt / json / xlsx；资料页有外链教材，打不开与容器无关 |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`zyronon/typewords:3.0.4`**，**Docker Compose** 映射 **8080 → 80**，走完四步引导即可练习。无 Compose 时用文末 **`docker run`**。局域网以实测 **`192.168.1.35`** 为例，请换成你的 IP。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **访问**：宿主机 **8080** → 容器 **80**，实测 `http://192.168.1.35:8080`（官方示例的宿主机 **3000** 不要照抄，见 FAQ）
> - **数据**：不挂业务卷；进度在浏览器本地，清站点数据会丢
> - **账号**：无登录
> - **首次**：宣传页进入工作台后有 **4 步**引导；练习页**没有输入框**，直接按键，空格继续
> - **标签**：**`3.0.4`**（[tags](https://xuanyuan.cloud/r/zyronon/typewords/tags)），不要写 `latest`

项目：[GitHub · zyronon/TypeWords](https://github.com/zyronon/TypeWords)。许可证：**GNU GPL-3.0**。

---

## 一、TypeWords 是什么？

这是一个**英语打字练习前端**：单词跟写、文章跟打，词库和进度都在浏览器里。不是网校后台，也不需要 MySQL。

| | TypeWords（本文） | 商业背单词 App |
|--|-------------------|----------------|
| 入口 | 浏览器 `IP:8080` | 应用商店 + 账号 |
| 数据 | 当前浏览器本地 | 厂商云端 |
| 练习 | 跟写 / 听写 / 默写 + 文章 | 以各 App 为准 |
| 运维 | 单容器 Nginx 静态站 | 不用自维，进度受平台约束 |

```text
浏览器  ──:8080──▶  Nginx（容器内 :80）── TypeWords 静态页
进度留在浏览器，不写进容器磁盘
```

发布镜像由 Node 构建、**nginx:alpine** 托管，实测 **nginx/1.31.3**。GitHub 仓库里那份 `docker-compose.yml` 是**源码 build** 用的（还带着对 `:3000` 的 Node 检查），不能拿来跑 Hub 镜像，跟做用第五节。

社区里还有 `cxoto/typewords` 等同名图，端口和版本线可能不同，不要和 **`zyronon/typewords`** 混用。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **`3.0.4`** 以 **amd64** 为准；ARM 见 FAQ |
| 内存 | ≥ **256～512 MB** 可用 |
| 磁盘 | 实测 CONTENT SIZE **30.5 MB** / DISK USAGE **107 MB** |
| 端口 | 宿主机 **8080**（可改左侧；右侧保持 **80**） |

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
ss -tlnp | grep 8080
```

> **8080** 被占用时改成 `"18080:80"`，访问 `http://IP:18080`。容器内仍是 80。

---

## 三、标签怎么选

Hub 上撰写时 **`3.0.4` 与 `latest` / `3` / `3.0` 同一构建**。跟做只写 **`3.0.4`**。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`3.0.4`** | 固定发布版 | **本文跟做** |
| `3.0.2` | 2026-04 构建 | 回滚 |
| `3.0.1` | 更旧；Hub 上可见 **amd64 + arm64** | 仅 ARM 且拉不到 `3.0.4` 时 |
| `latest` / `3` / `3.0` | 浮动指针 | **不要写入跟做命令** |

完整列表：[tags](https://xuanyuan.cloud/r/zyronon/typewords/tags)。GitHub 源码 Release（如 `v3.0.3`）和镜像标签不一定同步，以 tags 页为准。升级时 pull、Compose、`docker run` 三处一起改标签。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/zyronon/typewords:3.0.4
```

Ubuntu 24.04 实测：

```text
3.0.4: Pulling from zyronon/typewords
44136fa355b3: Download complete
55afa1ecc21d: Pull complete
1223f016b4e4: Pull complete
46519e7231d2: Pull complete
3cd534fe98c6: Pull complete
62bec68d7c31: Pull complete
46f977ee452f: Pull complete
d0008c891db4: Pull complete
390dc935348d: Pull complete
50f25485593c: Pull complete
1a49cae41b58: Download complete
Digest: sha256:f2585590e1dbdc18f064d143525bad729f79e6a681609ad0dff68c80891f3c7c
Status: Downloaded newer image for docker.xuanyuan.run/zyronon/typewords:3.0.4
docker.xuanyuan.run/zyronon/typewords:3.0.4
```

```bash
docker images docker.xuanyuan.run/zyronon/typewords:3.0.4
```

```text
IMAGE                                         ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/zyronon/typewords:3.0.4   f2585590e1db        107MB         30.5MB
```

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/typewords` |
| **macOS** | **`~/docker/typewords`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\typewords` |

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/typewords
chown -R "$USER:$USER" /www/wwwroot/typewords
cd /www/wwwroot/typewords

# macOS：mkdir -p ~/docker/typewords && cd ~/docker/typewords
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  typewords:
    image: docker.xuanyuan.run/zyronon/typewords:3.0.4
    container_name: typewords
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      TZ: Asia/Shanghai
EOF
```

| 项 | 说明 |
|----|------|
| `image` | 钉死 **`3.0.4`** |
| `ports` | **8080→80** |
| 无 `volumes` | 静态站，进度不在容器里 |
| `TZ` | 可选；实测日志为上海时区 |
| 不要抄仓库 compose | 那是源码构建 + `3000:80` + Node healthcheck，见 FAQ |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 50
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network typewords_default Created
 ✔ Container typewords       Started
```

```text
NAME        IMAGE                                         COMMAND                  SERVICE     CREATED          STATUS          PORTS
typewords   docker.xuanyuan.run/zyronon/typewords:3.0.4   "/docker-entrypoint.…"   typewords   28 seconds ago   Up 26 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
```

日志关键行：

```text
typewords  | /docker-entrypoint.sh: Configuration complete; ready for start up
typewords  | 2026/08/25 11:05:37 [notice] 1#1: nginx/1.31.3
typewords  | 2026/08/25 11:05:37 [notice] 1#1: start worker processes
```

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

```text
200
```

返回 **200** 后打开浏览器。

---

## 六、浏览器首次访问

```text
http://192.168.1.35:8080
```

本机用 `http://127.0.0.1:8080`。不用注册。

### 6.1 宣传首页

第一次打开是深色介绍页，口号「打字记单词，科学间隔复习」。能看到这一页，说明端口已经通了。点页面上的**开始练习 / 立即使用**一类按钮（文案以界面为准），进入左侧带「单词」「文章」侧栏的工作台。

![TypeWords 首次访问：深色宣传页，口号打字记单词科学间隔复习](https://imgs.xuanyuan.cloud/docker/blog/typewords-1.webp)

工作台会弹出四步引导。跟着点即可；关掉引导也可以自己点选词典。

### 6.2 选词典（引导 1/4）

引导会写「点击这里选择词典开始学习」。主区是推荐词库（CET-4、CET-6、考研、雅思、新概念、程序员常用词等），还有收藏、错词本和「导入自己的单词」。

![TypeWords 单词工作台：推荐词库与新手引导第 1 步选词典](https://imgs.xuanyuan.cloud/docker/blog/typewords-2.webp)

### 6.3 词典列表（引导 2/4）

按考试或用途分类，每张卡有词数。实测选 **CET-4**，点 **下一步 (2/4)**。

![TypeWords 词典列表：CET-4 高亮，引导第 2 步选词典](https://imgs.xuanyuan.cloud/docker/blog/typewords-3.webp)

### 6.4 打开词库（引导 3/4）

CET-4 介绍为大学英语四级词库，实测 **2607** 条。右上角点 **学习**（引导「点击这里开始学习」）。**测试**是自测，和跟写不是同一条路。

![TypeWords CET-4 词库页：2607 词，引导第 3 步点击学习](https://imgs.xuanyuan.cloud/docker/blog/typewords-4.webp)

### 6.5 学习设置（引导 4/4）

可改每日新词（默认 **20**）、复习上限和起始位置。点 **确认** 进入跟写。

![TypeWords 学习设置：每日 20 新词、复习比与引导第 4 步](https://imgs.xuanyuan.cloud/docker/blog/typewords-5.webp)

---

## 七、练习页、文章与资料

### 7.1 跟写：没有输入框

确认后进入练习。实测第一个词是 **cancel**，有音标、发音、释义和例句，右侧是本组词表，底栏为「新词 · 跟写」。

**直接按键盘**，不要找输入框；敲完按 **空格** 继续。可标已掌握、收藏。若顶部提示 TTS 用浏览器引擎且没有声音，到左下角 **设置** 里查语音，不是 Nginx 没起来。

![TypeWords 跟写练习：单词 cancel，提示无输入框直接按键](https://imgs.xuanyuan.cloud/docker/blog/typewords-6.webp)

### 7.2 回到单词页

侧栏再点 **单词**。当前词典变为 CET-4，顶部有进度和 **开始学习**；紫色条可导入 txt / json / xlsx。换词库仍在推荐区点选。

![TypeWords 单词工作台：已选 CET-4，开始学习与导入自己的单词](https://imgs.xuanyuan.cloud/docker/blog/typewords-7.webp)

### 7.3 文章跟打

侧栏 **文章**。可导入 JSON / XLSX 或手建「我的书籍」。推荐区有 **新概念英语** 1～4 册（实测 72 / 96 / 60 / 48 篇）。

![TypeWords 文章页：英语文章跟打与精听，推荐新概念英语 1 至 4](https://imgs.xuanyuan.cloud/docker/blog/typewords-8.webp)

### 7.4 资料页

侧栏 **资料** 是外链目录（新概念、影视、语法、听力）。链接失效与本容器无关。主题、音效、快捷键仍在左下角 **设置**，改完刷新即可，同样存在浏览器本地。

![TypeWords 资料页：新概念、影视、语法与听力资源卡片](https://imgs.xuanyuan.cloud/docker/blog/typewords-9.webp)

---

## 八、备选：docker run

仅临时试玩或没有 Compose 时使用。

```bash
docker run -d \
  --name typewords \
  --restart unless-stopped \
  -p 8080:80 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/zyronon/typewords:3.0.4
```

访问同样是 `http://IP:8080`。与 Compose 重名时先 `docker compose down`，或换 `--name`。

```bash
docker ps | grep typewords
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

---

## 九、生产加固与升级

| 项 | 建议 |
|----|------|
| 版本 | 保持 **`3.0.4`** 这类具体标签 |
| HTTPS | 前置 Nginx / Caddy / Traefik，反代 `127.0.0.1:8080` |
| 子路径 | 静态资源按站点根路径 `/` 构建。要挂 `/typewords/` 需反代到根，不能只改 `baseURL`（[Issue #206](https://github.com/zyronon/TypeWords/issues/206)） |
| 暴露 | 优先内网或 VPN；公网无登录 |
| 升级 | 改标签后 `docker compose pull && docker compose up -d` |
| 备份 | 保留 compose 与反代配置；学习进度在浏览器侧，换设备按项目说明自行导出 |

```bash
cd /www/wwwroot/typewords
docker compose pull
docker compose up -d
```

---

## 十、常见问题 FAQ

**Q1：打不开 `:8080`？**  
看 `docker compose ps` 是否 Up、本机 `curl` 是否 **200**、防火墙是否放行。冲突则 `"18080:80"`。

**Q2：官方写 `-p 3000:80`，为什么用 8080？**  
容器内是 **80**。宿主机 **3000** 常被前端开发占用，本系列默认避开。只改左侧端口。

**Q3：要挂数据卷吗？进度会丢吗？**  
不用挂卷。删容器一般不影响浏览器里的进度；清站点数据、换浏览器或换设备会丢。项目说的「数据在本地」是指浏览器，不是 `/www/wwwroot/typewords`。

**Q4：默认账号？**  
没有，打开即用。

**Q5：练习页没有输入框？**  
就是这样设计的：直接按键，空格继续。

**Q6：没有发音？**  
TTS 走浏览器引擎。去 **设置** 查音量和语音包，与 `curl` 200 无关。

**Q7：GitHub 里的 docker-compose.yml 能直接 up 吗？**  
不能。那是 `build` 源码、映射 `3000:80`，healthcheck 还打 Node 的 3000。发布镜像是 Nginx，跟做用第五节。

**Q8：ARM / Apple Silicon 报 `no matching manifest`？**  
到 [tags](https://xuanyuan.cloud/r/zyronon/typewords/tags) 看该标签有没有你的架构。**`3.0.4` 以 amd64 为主**；更旧的 **`3.0.1`** 可见 arm64，功能落后。也可按官方 Dockerfile 本机构建。

**Q9：和 cxoto/typewords 等有什么区别？**  
本文只跟做 **`zyronon/typewords`**。

**Q10：镜像页示例写成 `--name docker.xuanyuan.run/typewords`？**  
容器名不能用镜像坐标。用 `--name typewords`。

**Q11：挂到子路径 `/typewords/`？**  
当前按根路径构建。用反代把 `/typewords/` 转到本容器根路径。见 [Issue #206](https://github.com/zyronon/TypeWords/issues/206)。

**Q12：拉取 401 / 402？**  
401：见 [登录认证](https://xuanyuan.cloud/usage/login)。402：流量用尽，见 [充值](https://xuanyuan.cloud/recharge)。其它见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/zyronon/typewords:3.0.4

cd /www/wwwroot/typewords
# macOS：cd ~/docker/typewords
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
# 浏览器 http://服务器IP:8080

docker compose down
```

备选：

```bash
docker run -d --name typewords --restart unless-stopped -p 8080:80 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/zyronon/typewords:3.0.4
```

---

## 十二、延伸阅读

- [zyronon/typewords 镜像页](https://xuanyuan.cloud/zh/r/zyronon/typewords) · [标签列表](https://xuanyuan.cloud/r/zyronon/typewords/tags)
- [GitHub · zyronon/TypeWords](https://github.com/zyronon/TypeWords) · [中文说明](https://github.com/zyronon/TypeWords/blob/master/docs/README.zh-CN.md)
- [在线演示 typewords.cc](https://typewords.cc)
- [Docker Hub · zyronon/typewords](https://hub.docker.com/r/zyronon/typewords)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- Compose 拉起 `zyronon/typewords:3.0.4`，**8080→80**；实测 `curl` **200**，日志 **nginx/1.31.3**。
- 无登录；四步引导选词库后跟写。练习页直接按键。进度在浏览器里。
- 宿主机不要用官方示例里的 **3000**；不要用仓库那份源码 compose 跑 Hub 镜像。
- 生产钉死标签；公网加 HTTPS 或访问控制。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/typewords-docker-deploy



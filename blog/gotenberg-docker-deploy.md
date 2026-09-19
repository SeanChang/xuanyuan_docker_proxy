# Docker 部署 Gotenberg 完整教程：Compose 搭建文档转 PDF API

![Docker 部署 Gotenberg 完整教程：Compose 搭建文档转 PDF API](https://imgs.xuanyuan.cloud/docker/blog/gotenberg.webp)

*分类: Docker部署教程 | 标签: Gotenberg,Docker,轩辕镜像,PDF,文档转换,Chromium,LibreOffice,私有化部署,部署教程 | 发布时间: 2026-09-16 05:36:48*

> Gotenberg 是面向开发者的容器化文档转 PDF API，内置 Chromium 与 LibreOffice，可用 HTTP 把 HTML、URL、Markdown 以及 Word / Excel 等办公文档转成 PDF，并支持合并、拆分、水印与加密。本文将介绍如何通过 Docker Compose 部署 gotenberg/gotenberg，搭建可自托管的转换服务，适合发票报表导出、办公文档归档与自动化工作流等场景。

*本文基于 [gotenberg/gotenberg:8.37.0](https://xuanyuan.cloud/zh/r/gotenberg/gotenberg)，实测引擎 **Gotenberg 8.37.0**，测试平台 **Ubuntu 24.04** Linux。*

业务系统要出发票、对账单、合同预览 PDF 时，常见做法是在应用机上塞一份 Headless Chromium，或再装一套 LibreOffice。依赖一升级，字体、沙箱、无头参数全要跟着改；多台机器各装一份，体积和维护成本都会上去。Word / Excel 转 PDF 更麻烦——纯浏览器方案搞不定办公格式，办公套件又不好嵌进微服务。

放到公有云「文档转 PDF」接口，又会碰到合规门槛：**原稿、客户合同、内部报表最好别出域**。机房内网、等保场景里，外链转换不合适；自建又怕自己维护 Chromium + LibreOffice 双引擎。很多团队其实已经有一台跑 Docker 的 Ubuntu，缺的是：**转换服务镜像能拉、监听一个端口、业务侧用 HTTP 扔文件就能拿回 PDF**。

**Gotenberg**（[官方文档](https://gotenberg.dev/docs/getting-started/introduction)、[GitHub · gotenberg/gotenberg](https://github.com/gotenberg/gotenberg)）是开源的 **Docker 化文档转 PDF API**：用 `multipart/form-data` 提交 HTML / URL / Markdown 或 Office 文档，服务端用 **Chromium** 与 **LibreOffice** 转换后返回 PDF（也支持截图、合并、水印等）。社区镜像 **`gotenberg/gotenberg`**（[镜像页](https://xuanyuan.cloud/zh/r/gotenberg/gotenberg)）容器内默认监听 **3000**，**无 Web 管理后台**、无状态、无数据库，适合作为内网基础设施给业务调用。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 健康检查 | `curl --noproxy '*' http://服务器IP:13300/health` |
| 本地 HTML → PDF | `POST /forms/chromium/convert/html`（本文主演示） |
| 远程网页 → PDF | `POST /forms/chromium/convert/url`（容器需能出网） |
| Office → PDF | `POST /forms/libreoffice/convert`（全量镜像） |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`gotenberg/gotenberg:8.37.0`**，**Docker Compose** 映射宿主机 **13300 → 容器 3000**。把下文 IP 换成你的。无 Compose 见第七节。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第七节
> - **端口**：宿主机 **13300** → 容器 **3000**（勿占宿主机 3000）
> - **标签**：跟做 **`8.37.0`**；勿写 `latest` / 裸 `8`
> - **形态**：无状态 API，默认无需数据卷；**无浏览器后台**；勿对公网裸暴露
> - **体积 / 内存**：DISK **2.46GB** / CONTENT **703MB**；可用内存建议 ≥ **1 GB**
> - **目录**：Linux `/www/wwwroot/gotenberg`；macOS 跟做用 `~/docker/gotenberg`
> - **绑定**：跟做设 **`API_BIND_IP=0.0.0.0`**
> - **代理**：宿主机若设置了 `http_proxy`，本地验证必须加 **`curl --noproxy '*'`**，否则易 `Empty reply from server`

官方：[文档](https://gotenberg.dev/docs/getting-started/introduction) · [GitHub](https://github.com/gotenberg/gotenberg) · [镜像页](https://xuanyuan.cloud/zh/r/gotenberg/gotenberg) · [标签列表](https://xuanyuan.cloud/r/gotenberg/gotenberg/tags)

---

## 一、Gotenberg 镜像是什么？

`gotenberg/gotenberg` 提供的是 **HTTP API**，不是浏览器里点选的「在线 Office」。业务服务把文件或 URL POST 进去，拿回 PDF；不必在每台应用机上维护 Chromium / LibreOffice。

| | Gotenberg（本文） | Stirling PDF 等 Web 工具箱 | 本机装 Chromium / LibreOffice |
|--|-------------------|----------------------------|-------------------------------|
| 入口 | HTTP API | 浏览器点选 | 本机命令行 / 库 |
| 适合 | 应用集成、自动化流水线 | 人工偶尔处理 PDF | 单机脚本、强耦合代码 |
| 数据 | 请求级临时处理，默认无状态 | 多为临时上传 | 落在本机磁盘 |

```text
业务服务 / curl  ──HTTP:13300──▶  gotenberg（:3000）
                                    ├── Chromium  → HTML / URL / Markdown / 截图
                                    └── LibreOffice → docx / xlsx / pptx 等
```

官方还提供精简变体：只要网页转 PDF 可用 **`8.37.0-chromium`**；只要办公文档可用 **`8.37.0-libreoffice`**。本文跟做 **全量 `8.37.0`**。

> **安全提示（官方）**：不要把 Gotenberg 直接暴露到公网，应像数据库一样放在防火墙 / 内网之后；生产建议开 Basic Auth 或网关鉴权。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；也可 Docker Desktop |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64** / **arm64**（以标签页为准） |
| 内存 | 可用 ≥ **1 GB**（全量含 Chromium） |
| 磁盘 | 镜像约占 **2.46GB**，另留转换临时空间 |
| 端口 | 宿主机 **13300** |
| 工作目录 | `/www/wwwroot/gotenberg` |

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

---

## 三、拉取镜像

### 3.1 标签怎么选

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`8.37.0`** | 当前较新稳定全量版（Chromium + LibreOffice + PDF Engines） | **推荐** |
| `8.37.0-chromium` | 约小 30%，无 LibreOffice | 仅网页 / HTML / Markdown |
| `8.37.0-libreoffice` | 约小 40%，无 Chromium | 仅办公文档 |
| `8` / `latest` | 浮动到 8.x 最新 | **勿写入跟做命令** |
| `8-cloudrun` / `8-aws-lambda` | 云函数优化变体 | 非本机 Compose |
| `edge` | 开发构建 | 仅尝鲜 |

完整列表见 [标签页](https://xuanyuan.cloud/r/gotenberg/gotenberg/tags)。升级时改 Compose 标签并对照 [Releases](https://github.com/gotenberg/gotenberg/releases)。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/gotenberg/gotenberg:8.37.0
```

Ubuntu 24.04 实测：

```text
8.37.0: Pulling from gotenberg/gotenberg
2e19782d7109: Pull complete
df68884b2aa5: Pull complete
4f4fb700ef54: Pull complete
00bdcbd8e5e0: Pull complete
c61500c0be83: Pull complete
473555bc641a: Pull complete
54e1d0cdb9fd: Pull complete
bd833127324b: Pull complete
7651d2156957: Pull complete
f151b2b4404b: Pull complete
af050359cf70: Pull complete
1af4e451222c: Pull complete
e11918c9e44d: Pull complete
3d1a2792a042: Pull complete
c4d8643c6a82: Pull complete
d49d7d3f863a: Pull complete
39ce80792cad: Pull complete
c9bd3c3b2815: Pull complete
Digest: sha256:f29984bd1e226bf1b93ba90af06000afa8b315853e99d27b9aaa41b93f15c769
Status: Downloaded newer image for docker.xuanyuan.run/gotenberg/gotenberg:8.37.0
docker.xuanyuan.run/gotenberg/gotenberg:8.37.0
```

```bash
docker images docker.xuanyuan.run/gotenberg/gotenberg:8.37.0
```

```text
IMAGE                                            ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/gotenberg/gotenberg:8.37.0   f29984bd1e22       2.46GB          703MB
```

---

## 四、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/gotenberg`（macOS 实测目录为 `~/docker/gotenberg`）。

### 4.1 创建目录

```bash
mkdir -p /www/wwwroot/gotenberg
chown -R "$USER:$USER" /www/wwwroot/gotenberg
cd /www/wwwroot/gotenberg
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 4.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  gotenberg:
    image: docker.xuanyuan.run/gotenberg/gotenberg:8.37.0
    container_name: gotenberg
    restart: unless-stopped
    ports:
      - "13300:3000"
    environment:
      TZ: Asia/Shanghai
      LOG_LEVEL: info
      API_BIND_IP: "0.0.0.0"
      # 生产示例（取消注释并改密码）：
      # API_ENABLE_BASIC_AUTH: "true"
      # GOTENBERG_API_BASIC_AUTH_USERNAME: "gotenberg"
      # GOTENBERG_API_BASIC_AUTH_PASSWORD: "请换成强密码"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s
EOF
```

| 项 | 作用 |
|----|------|
| `"13300:3000"` | 宿主机访问口；容器内固定 3000 |
| `API_BIND_IP` | 明确监听 `0.0.0.0` |
| `LOG_LEVEL` | `debug` / `info` / `warn` / `error` |

Gotenberg **默认无状态**，跟做不必挂卷。

### 4.3 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 50
```

实测：

```text
[+] up 2/2
 ✔ Network gotenberg_default Created
 ✔ Container gotenberg       Started

NAME        IMAGE                                            COMMAND                  SERVICE     CREATED          STATUS                   PORTS
gotenberg   docker.xuanyuan.run/gotenberg/gotenberg:8.37.0   "/usr/bin/tini -- go…"   gotenberg   10 seconds ago   Up 8 seconds (healthy)   0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp
```

日志关键行：

```text
gotenberg  | A Docker-based API for converting documents to PDF.
gotenberg  | Version: 8.37.0
gotenberg  | -------------------------------------------------------
gotenberg  | [SYSTEM] modules: api chromium exiftool libreoffice libreoffice-api libreoffice-pdfengine pdfcpu pdfengines pdftk prometheus qpdf webhook
gotenberg  | [SYSTEM] libreoffice-api: LibreOffice ready to start
gotenberg  | [SYSTEM] chromium: Chromium ready to start
gotenberg  | [SYSTEM] api: server started on 0.0.0.0:3000
```

健康检查（宿主机若有 `http_proxy`，必须加 `--noproxy '*'`）：

```bash
curl --noproxy '*' -sS http://127.0.0.1:13300/health
curl --noproxy '*' -sS http://127.0.0.1:13300/version
```

Ubuntu 24.04 实测：

```text
{"status":"up","details":{"chromium":{"status":"up","timestamp":"2026-09-16T05:25:19.12804218Z"},"libreoffice":{"status":"up","timestamp":"2026-09-16T05:25:19.128000814Z"}}}
```

```text
8.37.0
```

浏览器打开 `/health` 也只是这段 JSON——**没有登录页或控制台**。

---

## 五、用 API 转一张 PDF

跟做优先用**本地 HTML**（不依赖容器出网）。若宿主机配了 `http_proxy`、容器却没配代理，官方「远程 URL → PDF」示例常会失败，保存下来的「pdf」其实是错误文本。

### 5.1 本地 HTML → PDF（推荐）

```bash
cd /www/wwwroot/gotenberg
cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="utf-8"><title>Gotenberg Demo</title></head>
<body>
  <h1>Gotenberg 部署验证</h1>
  <p>这是本地 HTML 转 PDF 示例。</p>
</body>
</html>
EOF

curl --noproxy '*' --request POST http://127.0.0.1:13300/forms/chromium/convert/html \
  --form files=@./index.html \
  -o page.pdf

ls -lh page.pdf
file page.pdf
```

成功时 `file` 应显示 `PDF document`。若仍是 `ASCII text`，先 `cat page.pdf` 看错误，再 `docker compose logs --tail 50 gotenberg`。

Ubuntu 24.04 实测：

```text
-rw-r--r-- 1 root root 33K Sep 16 05:28 page.pdf
page.pdf: PDF document, version 1.4, 1 page(s)
```

### 5.2 远程 URL → PDF（需容器能出网）

```bash
curl --noproxy '*' --request POST http://127.0.0.1:13300/forms/chromium/convert/url \
  --form url=https://sparksuite.github.io/simple-html-invoice-template/ \
  -o invoice.pdf

ls -lh invoice.pdf
file invoice.pdf
```

容器出网失败时，常见现象：文件只有几十到上百字节，且 `file` 显示 **ASCII text**（本机实测一次为 **92** 字节）。需要该能力时，给容器配代理或放行 DNS / HTTPS。

Office 文档（全量或 `*-libreoffice` 变体）：

```bash
curl --noproxy '*' --request POST http://127.0.0.1:13300/forms/libreoffice/convert \
  --form files=@./demo.docx \
  -o demo.pdf
```

合并、水印、截图等路由见 [官方文档](https://gotenberg.dev/docs/getting-started/introduction)。同一 Compose 网络内的其它服务可直接访问 `http://gotenberg:3000`。

---

## 六、配置与生产加固

配置可用环境变量或 `command`（改 `command` 时须保留 `gotenberg` 子命令，勿改 entrypoint）。完整列表见 [Configuration](https://gotenberg.dev/docs/configuration)。

| 环境变量 | 含义 | 默认 |
|----------|------|------|
| `API_PORT` | 监听端口 | `3000` |
| `API_TIMEOUT` | 请求超时 | `30s` |
| `LOG_LEVEL` | 日志级别 | `info` |
| `API_ENABLE_BASIC_AUTH` | 开启 Basic Auth | `false` |
| `GOTENBERG_API_BASIC_AUTH_USERNAME` / `_PASSWORD` | Basic Auth 凭据 | 无 |

生产建议：

- **网络**：仅内网或反代可达；官方明确勿对公网裸暴露
- **鉴权**：开启 Basic Auth，或在网关做 IP 白名单 / mTLS
- **超时与并发**：大文档适当加大 `API_TIMEOUT`；高压时水平扩实例
- **变体**：只用 HTML→PDF 可换 `8.37.0-chromium`；只用 Office 可换 `8.37.0-libreoffice`
- **出站**：转换远程 URL 时注意 SSRF，按文档配置 allow / deny

开启 Basic Auth 后：

```bash
curl --noproxy '*' -u 'gotenberg:你的密码' \
  --request POST http://127.0.0.1:13300/forms/chromium/convert/html \
  --form files=@./index.html \
  -o page.pdf
```

---

## 七、备选：docker run（临时 / 无 Compose）

```bash
docker run -d \
  --name gotenberg \
  --restart unless-stopped \
  -p 13300:3000 \
  -e TZ=Asia/Shanghai \
  -e LOG_LEVEL=info \
  -e API_BIND_IP=0.0.0.0 \
  docker.xuanyuan.run/gotenberg/gotenberg:8.37.0
```

验证同样用 `curl --noproxy '*' http://127.0.0.1:13300/health`。长期运行仍推荐第四节 Compose。

---

## 八、升级与迁移

1. 改 `image` 标签 → `docker compose pull` → `docker compose up -d`
2. 大版本升级前阅读 [Releases](https://github.com/gotenberg/gotenberg/releases)
3. 无状态搬家：拷贝 `docker-compose.yml` 到新机再 `up -d`
4. 勿把 `8` / `latest` 写进跟做与生产；固定 **`8.37.0`** 这类具体版本

---

## 九、常见问题 FAQ

**Q1：为什么映射 13300 而不是 3000？**  
宿主机 3000 常被 Node / 前端开发占用。左边端口可改，右边保持容器内 `3000`。

**Q2：可以跟做 `latest` 或 `8` 吗？**  
不推荐。固定 **`8.37.0`**，升级时显式改标签并看 changelog。

**Q3：有没有 Web 管理界面？**  
没有。Gotenberg 只有 HTTP API；浏览器打开 `:13300/health` 只会看到 JSON。

**Q4：`/forms/libreoffice/convert` 报错？**  
确认用的是全量或 `*-libreoffice` 镜像；`*-chromium` 不含 LibreOffice。

**Q5：转换超时？**  
加大 `API_TIMEOUT`；检查目标 URL 是否可达、页面是否过重。

**Q6：生成的 pdf 只有几十字节，`file` 显示 ASCII text？**  
那是错误正文，不是 PDF。先 `cat` 该文件。远程 URL 失败常见原因：容器出不了网。跟做改用 **§5.1 本地 HTML**。

**Q7：宿主机 curl 报 `Empty reply from server`，但 `compose ps` 已是 healthy？**  
多半是宿主机 `http_proxy` 劫持了访问 `127.0.0.1` 的请求。`curl -v` 若出现 `Uses proxy env variable http_proxy`，改用：

```bash
curl --noproxy '*' -sS http://127.0.0.1:13300/health
```

也可用 `docker exec gotenberg curl -sS http://127.0.0.1:3000/health` 确认容器内正常。

**Q8：要不要挂数据卷？**  
默认不用。持久化生成的 PDF 应在业务侧保存。

**Q9：和 Stirling PDF、OnlyOffice 怎么选？**  
给**程序**调 API → Gotenberg；给人在**浏览器**里处理 PDF → Stirling 一类；在线协作编辑 Office → OnlyOffice 等。

**Q10：历史镜像 `thecodingmachine/gotenberg` 还能用吗？**  
那是赞助商历史坐标，新部署请用官方 **`gotenberg/gotenberg`**。

---

## 十、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/gotenberg/gotenberg:8.37.0

# Compose（主路径）
cd /www/wwwroot/gotenberg
docker compose up -d
docker compose ps
docker compose logs -f gotenberg
docker compose down

# 健康检查 / 本地 HTML 转 PDF
curl --noproxy '*' -sS http://127.0.0.1:13300/health
curl --noproxy '*' --request POST http://127.0.0.1:13300/forms/chromium/convert/html \
  --form files=@./index.html \
  -o page.pdf

# 备选 run
docker run -d --name gotenberg -p 13300:3000 \
  -e API_BIND_IP=0.0.0.0 \
  docker.xuanyuan.run/gotenberg/gotenberg:8.37.0
```

验证：`http://服务器IP:13300/health` · 跟做标签：`8.37.0` · 无 Web 后台

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [gotenberg/gotenberg 镜像页](https://xuanyuan.cloud/zh/r/gotenberg/gotenberg) | [https://xuanyuan.cloud/zh/r/gotenberg/gotenberg](https://xuanyuan.cloud/zh/r/gotenberg/gotenberg) |
| [镜像标签列表](https://xuanyuan.cloud/r/gotenberg/gotenberg/tags) | [https://xuanyuan.cloud/r/gotenberg/gotenberg/tags](https://xuanyuan.cloud/r/gotenberg/gotenberg/tags) |
| [Gotenberg 官方文档](https://gotenberg.dev/docs/getting-started/introduction) | [https://gotenberg.dev/docs/getting-started/introduction](https://gotenberg.dev/docs/getting-started/introduction) |
| [Configuration](https://gotenberg.dev/docs/configuration) | [https://gotenberg.dev/docs/configuration](https://gotenberg.dev/docs/configuration) |
| [GitHub · gotenberg/gotenberg](https://github.com/gotenberg/gotenberg) | [https://github.com/gotenberg/gotenberg](https://github.com/gotenberg/gotenberg) |
| [Releases](https://github.com/gotenberg/gotenberg/releases) | [https://github.com/gotenberg/gotenberg/releases](https://github.com/gotenberg/gotenberg/releases) |
| [Live Demo](https://demo.gotenberg.dev) | [https://demo.gotenberg.dev](https://demo.gotenberg.dev) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做固定 **`gotenberg/gotenberg:8.37.0`**，Compose 映射 **13300→3000**，用 `/health` 与本地 HTML→PDF 验证。
- 无 Web 管理界面；宿主机若有 `http_proxy`，本地 curl 加 **`--noproxy '*'`**。
- 远程 URL 转换还需容器能出网；全量镜像可按场景换成 chromium / libreoffice 精简标签。
- 服务无状态；勿对公网裸暴露，生产加鉴权与内网隔离。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/gotenberg-docker-deploy



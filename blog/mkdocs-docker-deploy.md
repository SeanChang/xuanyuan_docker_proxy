# Docker 一键部署 MkDocs：快速搭建项目文档静态站点

![Docker 一键部署 MkDocs：快速搭建项目文档静态站点](https://imgs.xuanyuan.cloud/docker/blog/mkdocs.webp)

*分类: Docker部署教程 | 标签: MkDocs,Docker,轩辕镜像,Markdown,静态站点,项目文档,部署教程 | 发布时间: 2026-08-03 09:02:02*

> MkDocs 是面向项目文档的 静态站点生成器：源文件用 Markdown，配置一个 mkdocs.yml，即可本地预览并构建出纯 HTML，部署到 Nginx、对象存储或 GitHub Pages。社区镜像 minidocks/mkdocs（见 镜像页）预装了 Material、Alabaster 等主题以及大量常用插件与 Markdown 扩展，适合「拉镜像就能写文档」，不必在宿主机装 Python 生态。

*本文基于 [minidocks/mkdocs:pdf](https://xuanyuan.cloud/zh/r/minidocks/mkdocs) 实测，CONTENT SIZE 约 **136MB**；多架构 amd64 / arm64，面向 **Ubuntu 24.04** 等 Linux。

写开源项目、内部 SDK、运维手册时，文档往往散落在 **Wiki、飞书文档、README 拼贴** 里：版本对不齐、搜索不好用、样式不统一。本机用 `pip install mkdocs` 又要配虚拟环境、装一堆主题与插件，换机器就再来一遍。

**MkDocs** 是面向项目文档的 **静态站点生成器**：源文件用 Markdown，配置一个 `mkdocs.yml`，即可本地预览并构建出纯 HTML，部署到 Nginx、对象存储或 GitHub Pages。社区镜像 **`minidocks/mkdocs`**（见 [镜像页](https://xuanyuan.cloud/zh/r/minidocks/mkdocs)）预装了 Material、Alabaster 等主题以及大量常用插件与 Markdown 扩展，适合「拉镜像就能写文档」，不必在宿主机装 Python 生态。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`minidocks/mkdocs:pdf`**（自建推荐标签：在 `latest` 能力之上另含 PDF 导出），**先建项目，再用 Docker Compose 常驻预览**，并说明改首页、加菜单、构建静态站与 Nginx 托管。全程零基础可跟做，文内附 **3 张实测界面截图**。

> **上手要点**  
> - **部署方式（推荐）**：**第五节** `mkdocs new doc` → **第八节** Compose `up -d`（预览常驻）  
> - **工作目录**：把宿主机 `doc/` 挂到容器 `/app/doc`，在含 `mkdocs.yml` 的目录里 `serve`  
> - **端口**：开发预览默认 **8000**；`serve` 须 `-a 0.0.0.0:8000`  
> - **标签**：**自建推荐 `pdf` / `1-pdf`**（功能全集，含 PDF）；磁盘紧或只要 HTML 时可用更轻的 `latest` / `1`  
> - **产物**：`mkdocs build` 输出到 `doc/site/`；按需启用 PDF 插件可导出 PDF  
> - **账号**：无 Web 登录；MkDocs 是文档工具，不是带用户系统的 SaaS  

镜像说明见 [minidocks/mkdocs](https://xuanyuan.cloud/zh/r/minidocks/mkdocs)，标签列表见 [tags](https://xuanyuan.cloud/r/minidocks/mkdocs/tags)。官方项目：[mkdocs.org](https://www.mkdocs.org/)，用户指南：[User Guide](https://www.mkdocs.org/user-guide/)。Docker Hub：[minidocks/mkdocs](https://hub.docker.com/r/minidocks/mkdocs)。

---

## 一、MkDocs 与本镜像是什么？

一句话：**MkDocs = Markdown → 美观静态文档站**；**`minidocks/mkdocs` = 预装主题/插件的开箱即用构建镜像**。

### 1.1 MkDocs 能做什么

| 能力 | 说明 |
|------|------|
| Markdown 写作 | 文档源在 `docs/`，配置在 `mkdocs.yml` |
| 本地预览 | `mkdocs serve` 热重载，改完浏览器自动刷新 |
| 主题切换 | 内置 `mkdocs` / `readthedocs`；本镜像另预装 **Material**、Alabaster、KPN 等 |
| 静态构建 | `mkdocs build` 生成 `site/`，可部署到任意静态托管 |
| 搜索 | 多数主题自带客户端全文搜索 |

典型场景：开源项目文档、团队 API / 运维手册、产品使用说明、课程讲义站。

### 1.2 本镜像多了什么？

相对「裸装 MkDocs」，`minidocks/mkdocs` 预装了丰富主题、插件与 Markdown 扩展（详见镜像页 [中文简介](https://xuanyuan.cloud/zh/r/minidocks/mkdocs)），例如：

| 类别 | 示例 |
|------|------|
| 主题 | Material Design、Alabaster、KPN |
| 插件 | Awesome Pages、Autolinks、Git revision date、Minify、Redirects、Swagger UI、Mkdocstrings 等 |
| PDF 能力（`pdf` 标签） | 在 `latest` 全集之上叠加 PDF export / PDF generate 与字体等（本文推荐） |
| Markdown 扩展 | PyMdown Extensions、Include、Pygments 等 |

不必自己 `pip install` 一长串依赖；自建统一用 **`pdf`** 标签即可兼顾预览、构建与 PDF 导出。

### 1.3 和同类方案怎么选？

| 方案 | 特点 | 适合 |
|------|------|------|
| **minidocks/mkdocs**（本文） | 预装多主题多插件，一条命令 `new` / `serve` / `build` | 要快速上手、少配环境 |
| [squidfunk/mkdocs-material](https://github.com/squidfunk/mkdocs-material) | 官方 Material 生态，文档与插件体系最完整 | 长期维护 Material 站、跟官方教程 |
| [pozgo/docker-mkdocs](https://github.com/pozgo/docker-mkdocs) 等 | 其他社区 Docker 封装 | 已有既定镜像习惯时 |
| 本机 `pip install mkdocs` | 无容器开销，环境需自管 | 本机开发机已有 Python 工作流 |

同系列相关镜像：[minidocks/sphinx-doc](https://github.com/minidocks/sphinx-doc)（Sphinx 文档构建）。

### 1.4 工作流（跟做时先记住）

```text
Markdown（docs/） + mkdocs.yml
        │
        ├── mkdocs serve  ──▶ 浏览器 :8000 实时预览
        └── mkdocs build  ──▶ site/ 静态 HTML
                                 │
                                 └── Nginx / OSS / Pages 等托管
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**（本文按此写） |
| Docker | Engine + Compose V2（Compose 仅用于可选常驻预览） |
| 内存 | 建议 ≥ **1 GB** 可用（导出 PDF / 大文档构建时更从容） |
| 磁盘 | 镜像 CONTENT SIZE 约 **136MB**（`pdf`，本地 DISK USAGE 约 562MB）；项目与 `site/` 视文档量而定 |
| 端口 | 预览占用宿主机 **8000**（可改映射） |
| 架构 | amd64 / arm64（`pdf` / `1-pdf` / `latest` / `1` 为多架构） |

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

## 三、标签怎么选

上游 Dockerfile 中 **`pdf` 阶段基于 `latest` 再叠加** PDF 插件与字体，因此 **`pdf` ≈ `latest` 的全部能力 + PDF 导出**，功能最全。自建部署本文 **默认推荐 `pdf`**。

| 标签 | 大约体积 | 含义 | 推荐 |
|------|----------|------|------|
| **`pdf`** | ~130 MB | `latest` 全集 + PDF export / generate + 字体 | **自建推荐（本文默认）** |
| **`1-pdf`** | ~130 MB | 与 `pdf` 同属 PDF 全集通道，主版本钉 `1` | 希望钉版本号时 |
| `latest` / `1` | ~55 MB | 仅 HTML 预览与构建，**不含** PDF 插件 | 磁盘紧、确定永不导出 PDF |
| `1.1` / `1.0` / `0.17` 等 | — | 历史标签，较旧 | **不建议新项目使用** |

生产或 CI 建议：团队统一用 **`pdf`**（或钉 `1-pdf` / Digest），避免「本机能导出 PDF、CI 却缺插件」。

完整标签见 [轩辕镜像标签列表](https://xuanyuan.cloud/r/minidocks/mkdocs/tags)。

---

## 四、拉取镜像

```bash
docker pull docker.xuanyuan.run/minidocks/mkdocs:pdf
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `minidocks/mkdocs:pdf` | `docker pull docker.xuanyuan.run/minidocks/mkdocs:pdf` |

成功时终端类似（**Ubuntu 24.04 实测**）：

```text
Digest: sha256:9bf4924014794aad08556b8402af45d5429df053d4ca89326e24fac39359c8cf
Status: Downloaded newer image for docker.xuanyuan.run/minidocks/mkdocs:pdf
```

`docker images` 可见本地约 **562MB**（CONTENT SIZE 约 **136MB**）。Digest 可与 [Docker Hub](https://hub.docker.com/r/minidocks/mkdocs/tags) / 轩辕标签页对照。

若只要更轻量、不导出 PDF，可改拉 `latest`：

```bash
docker pull docker.xuanyuan.run/minidocks/mkdocs:latest
```

---

## 五、创建文档项目

在宿主机准备一个工作目录（可按你的习惯改路径）：

```bash
sudo mkdir -p /www/wwwroot/mkdocs
sudo chown -R $USER:$USER /www/wwwroot/mkdocs
cd /www/wwwroot/mkdocs
```

用镜像创建名为 `doc` 的新项目（官方示例写法）：

```bash
docker run --rm \
  -v "$(pwd):/app" \
  -w /app \
  docker.xuanyuan.run/minidocks/mkdocs:pdf \
  new doc
```

**必须先确认脚手架已生成**（否则后面改文件会报「目录不存在 / Can't open file for writing」）：

```bash
ls -la doc/ doc/docs/
test -f doc/mkdocs.yml && test -f doc/docs/index.md && echo "OK: 项目已就绪"
```

成功时应看到：

```text
/www/wwwroot/mkdocs/
└── doc/
    ├── mkdocs.yml      # 站点配置（必有 site_name）
    └── docs/
        └── index.md    # 首页 Markdown（new 自动创建）
```

```bash
cat doc/mkdocs.yml
head doc/docs/index.md
```

**若只有 `doc/mkdocs.yml`、没有 `doc/docs/`**（常见于手工建过空项目，或 `new` 未完整生成）：再执行 `new doc` 会提示 `Project already exists` 并**跳过**，不会自动补目录。手动补齐即可：

```bash
mkdir -p doc/docs
cat > doc/docs/index.md << 'EOF'
# Welcome to MkDocs

For full documentation visit [mkdocs.org](https://www.mkdocs.org).
EOF
sudo chown -R $USER:$USER /www/wwwroot/mkdocs
ls -la doc/docs/index.md
```

若希望从头重建脚手架，先删掉不完整的 `doc/` 再 `new`（会丢掉已改的 `mkdocs.yml`，慎用）：

```bash
# 慎用：删除整个文档项目后重建
rm -rf doc
docker run --rm -v "$(pwd):/app" -w /app docker.xuanyuan.run/minidocks/mkdocs:pdf new doc
```

---

## 六、临时预览（可选：前台 docker run）

适合一次性试跑。长期自建请直接跳 **第八节 Compose**。

```bash
cd /www/wwwroot/mkdocs

docker run --rm \
  -v "$(pwd):/app" \
  -w /app/doc \
  -p 8000:8000 \
  docker.xuanyuan.run/minidocks/mkdocs:pdf \
  serve -a 0.0.0.0:8000 -t material
```

须先有 `doc/mkdocs.yml` 与 `doc/docs/`（第五节 `new` 成功）。日志出现 `Serving on http://0.0.0.0:8000/` 后浏览器访问 `http://服务器IP:8000`。按 `Ctrl+C` 结束。

---

## 七、改文档与配置（跟做最小闭环）

> **前提**：第五节已跑通，`doc/docs/index.md` 真实存在。先执行：
>
> ```bash
> cd /www/wwwroot/mkdocs
> ls doc/docs/index.md
> ```
>
> 若提示 `No such file or directory`，回到第五节执行 `new doc`，**不要**对不存在的路径 `vim`。

Compose 或 `docker run` 预览运行时，改的是宿主机上的已有文件；保存后站点会自动重建并刷新。

### 7.1 改站点名称与导航

编辑已有文件 `doc/mkdocs.yml`（例如 `vim doc/mkdocs.yml`），改为：

```yaml
site_name: 我的项目文档
site_description: 用 MkDocs 写的示例文档站
site_author: 轩辕镜像

theme:
  name: material
  language: zh
  palette:
    primary: indigo
    accent: indigo

nav:
  - 首页: index.md
  - 快速开始: getting-started.md
```

### 7.2 改首页并新增一页

改首页（文件须已存在）：

```bash
cat > doc/docs/index.md << 'EOF'
# 欢迎

这是用 **MkDocs** + Docker 镜像 `minidocks/mkdocs:pdf` 搭建的项目文档站。

- 源文件：Markdown
- 预览：`mkdocs serve`
- 构建：`mkdocs build` → `site/`
EOF
```

新增页面（父目录已由 `new` 创建；用重定向写入，避免对不存在路径盲目 `vim`）：

```bash
cat > doc/docs/getting-started.md << 'EOF'
# 快速开始

## 拉取镜像

    docker pull docker.xuanyuan.run/minidocks/mkdocs:pdf

## 预览

浏览器打开 http://服务器IP:8000 ，修改 Markdown 后会自动刷新。
EOF
```

保存后浏览器访问 `http://服务器IP:8000/`，Material 主题下可见站点名「我的项目文档」、侧栏「首页 / 快速开始」与欢迎正文：

![MkDocs Material 首页：站点「我的项目文档」，侧栏首页高亮，正文标题「欢迎」](https://imgs.xuanyuan.cloud/docker/blog/mkdocs-1.webp)

进入「快速开始」页（路径形如 `/getting-started/`）：

![MkDocs「快速开始」页：侧栏「快速开始」高亮，说明修改 Markdown 会自动刷新](https://imgs.xuanyuan.cloud/docker/blog/mkdocs-2.webp)

### 7.3 日常怎么用（部署后）

打开站点后只有 **首页 / 快速开始** 两个菜单是正常的——菜单完全由 `nav` 决定，不是功能残缺。

| 你想做的事 | 怎么做 |
|------------|--------|
| 改某一页内容 | 编辑 `doc/docs/*.md`，保存；日志出现 `Detected file changes` / `Reloading browsers`，浏览器自动刷新 |
| 加一页到菜单 | ① 新建 `doc/docs/xxx.md` ② 在 `doc/mkdocs.yml` 的 `nav:` 里加一行 ③ 保存等热重载 |
| 改站点标题 / 主题色 | 改 `doc/mkdocs.yml` 的 `site_name`、`theme` |
| 全文搜索 | Material 主题右上角 Search（客户端搜索） |
| 正式对外发布 | 不要用长期 `serve`；走 **第九节 `build`**，把 `doc/site/` 交给 Nginx |

**再加一页示例**（「安装说明」）：

```bash
cd /www/wwwroot/mkdocs

cat > doc/docs/install.md << 'EOF'
# 安装说明

1. 拉取镜像
2. 创建项目
3. Compose 预览
EOF
```

若只建了文件、还没改 `nav`，日志会提示（**Ubuntu 实测**）：

```text
INFO    -  The following pages exist in the docs directory, but are not included in the "nav" configuration:
  - install.md
INFO    -  Detected file changes
INFO    -  Reloading browsers
```

页面仍可访问，但侧栏不会出现该菜单。编辑 `doc/mkdocs.yml`：

```yaml
nav:
  - 首页: index.md
  - 快速开始: getting-started.md
  - 安装说明: install.md
```

保存后刷新，侧栏应出现第三个菜单「安装说明」：

![MkDocs「安装说明」页：侧栏含首页/快速开始/安装说明，正文为三步列表](https://imgs.xuanyuan.cloud/docker/blog/mkdocs-3.webp)

目录约定：

```text
doc/
├── mkdocs.yml
└── docs/
    ├── index.md
    ├── getting-started.md
    └── install.md
```

更多写法见官方 [Writing Your Docs](https://www.mkdocs.org/user-guide/writing-your-docs/)；主题见 [Choosing Your Theme](https://www.mkdocs.org/user-guide/choosing-your-theme/)、[Configuration](https://www.mkdocs.org/user-guide/configuration/)、[Material](https://squidfunk.github.io/mkdocs-material/)。

---

## 八、推荐部署：Docker Compose 常驻预览

自建跟做按下面 **四步** 即可（与实测踩坑一致：必须先有项目，再 Compose）。

```text
拉镜像 → new 建 doc/ → 写 docker-compose.yml → compose up -d → 浏览器 :8000
```

### 8.1 准备目录并创建项目

若已完成第五节，可跳过 `new`，只需确认 `doc/mkdocs.yml` 存在。

```bash
sudo mkdir -p /www/wwwroot/mkdocs
sudo chown -R $USER:$USER /www/wwwroot/mkdocs
cd /www/wwwroot/mkdocs

# 若目录里还没有 doc/，执行：
docker run --rm \
  -v "$(pwd):/app" \
  -w /app \
  docker.xuanyuan.run/minidocks/mkdocs:pdf \
  new doc

ls doc/mkdocs.yml
```

### 8.2 编写 `docker-compose.yml`

在 `/www/wwwroot/mkdocs/`（与 `doc/` **同级**）创建：

```yaml
services:
  mkdocs:
    image: docker.xuanyuan.run/minidocks/mkdocs:pdf
    container_name: mkdocs
    restart: unless-stopped
    working_dir: /app/doc
    command: ["serve", "-a", "0.0.0.0:8000", "-t", "material"]
    ports:
      - "8000:8000"
    volumes:
      - ./doc:/app/doc
```

| 项 | 作用 |
|----|------|
| `image: …:pdf` | 功能全集镜像 |
| `working_dir: /app/doc` | 对应宿主机 `./doc`（含 `mkdocs.yml`） |
| `command: serve …` | 常驻开发预览；必须 `0.0.0.0` |
| `ports: "8000:8000"` | 浏览器访问端口 |
| `volumes: ./doc:/app/doc` | 改宿主机 Markdown 即热更新 |

目录最终应类似：

```text
/www/wwwroot/mkdocs/
├── docker-compose.yml
└── doc/
    ├── mkdocs.yml
    └── docs/
        └── index.md
```

### 8.3 启动与验证

```bash
cd /www/wwwroot/mkdocs
docker compose up -d
docker compose ps
docker compose logs -f mkdocs
```

成功标志：

- `ps` 中 `STATUS` 为 **`Up`**（不是 `Restarting`）
- 日志含 `Building documentation...` / `Serving on http://0.0.0.0:8000/`

**Ubuntu 24.04 实测**成功日志片段（补齐 `docs/` 与导航页后，无 missing nav 警告）：

```text
INFO    -  Building documentation...
INFO    -  Cleaning site directory
INFO    -  Documentation built in 0.99 seconds
INFO    -  [08:43:43] Watching paths for changes: 'docs', 'mkdocs.yml'
INFO    -  [08:43:43] Serving on http://0.0.0.0:8000/
INFO    -  [08:44:52] Browser connected: http://192.168.1.10:8000/
INFO    -  [08:45:27] Browser connected: http://192.168.1.10:8000/getting-started/
```

启动时若打印 Material 团队关于 MkDocs 2.0 的告示框，属**提示信息**，可忽略。若出现 `getting-started.md`…`not found`：按 **§7.2** 创建该文件后重建；`pages exist…but are not included in the "nav"` 表示文件已有、尚未写入 `nav`（见 **§7.3**）。

本机探测与访问：

```bash
curl -I http://127.0.0.1:8000/
```

```text
http://你的服务器IP:8000
```

（实测局域网示例：`http://192.168.1.10:8000/`）

云服务器请在安全组 / `ufw` 放行 **8000**。界面效果见 **§7.2 / §7.3** 三张截图。

若日志反复出现 `Config file 'mkdocs.yml' does not exist`：说明跳过了脚手架或挂载路径不对。执行：

```bash
docker compose down
mkdir -p doc/docs
# 确保 doc/mkdocs.yml 与 doc/docs/index.md 存在（见第五节）
docker compose up -d
```

### 8.4 日常运维

```bash
# 看日志
docker compose logs -f mkdocs

# 停止（保留 doc/ 与 site/）
docker compose down

# 升级镜像后重建
docker compose pull
docker compose up -d
```

> **说明**：Compose 里的 `serve` 面向开发预览，不是高并发生产 Web。对公网正式提供文档，请用下一节 **`build` + 静态托管**。

---

## 九、构建静态站点（build）

在项目根（含 `mkdocs.yml`）执行：

```bash
cd /www/wwwroot/mkdocs

docker run --rm \
  -v "$(pwd):/app" \
  -w /app/doc \
  docker.xuanyuan.run/minidocks/mkdocs:pdf \
  build
```

成功后生成：

```text
doc/site/
├── index.html
├── getting-started/
│   └── index.html
├── search/
├── assets/          # 主题 CSS/JS 等（随主题而变）
└── ...
```

查看：

```bash
ls -la doc/site/
```

> **截图占位**：`site/` 目录或 Nginx 托管效果（可选续拍 `mkdocs-4.webp`）

建议把 `site/` 加入 `.gitignore`（只提交 Markdown 与 `mkdocs.yml`）：

```bash
echo "site/" >> doc/.gitignore
```

### 9.1 用 Nginx 托管（示例）

将 `site/` 拷到 Web 根或直接挂载：

```bash
sudo mkdir -p /var/www/mkdocs-site
sudo rsync -a --delete /www/wwwroot/mkdocs/doc/site/ /var/www/mkdocs-site/
```

Nginx 片段示例：

```nginx
server {
    listen 80;
    server_name docs.example.com;
    root /var/www/mkdocs-site;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

也可用另一容器托管：

```bash
docker run -d --name mkdocs-site \
  --restart unless-stopped \
  -p 8080:80 \
  -v /www/wwwroot/mkdocs/doc/site:/usr/share/nginx/html:ro \
  docker.xuanyuan.run/library/nginx:alpine
```

然后访问 `http://服务器IP:8080`。

正式环境请配置 HTTPS（Caddy / Traefik / 证书均可）。更多托管方式见官方 [Deploying Your Docs](https://www.mkdocs.org/user-guide/deploying-your-docs/)。

---

## 十、导出 PDF（推荐：整站合成一个 PDF）

`minidocks/mkdocs:pdf` 已预装 [mkdocs-with-pdf](https://github.com/orzih/mkdocs-with-pdf)（整站一个 PDF）与 [mkdocs-pdf-export-plugin](https://github.com/zhaoterryy/mkdocs-pdf-export-plugin)（按页导出）。日常预览继续用 Compose；**导出时单独 `build` 一次**，不要把 PDF 插件开在长期 `serve` 上（很慢）。

### 10.1 在 `mkdocs.yml` 启用 `with-pdf`

编辑 `/www/wwwroot/mkdocs/doc/mkdocs.yml`，在现有 `theme` / `nav` 旁增加（**一旦写了 `plugins:`，须显式带上 `search`**，否则搜索会丢）：

```yaml
plugins:
  - search
  - with-pdf:
      cover_title: 我的项目文档
      cover_subtitle: Docker + minidocks/mkdocs:pdf
      output_path: pdf/document.pdf
      # 仅当环境变量 ENABLE_PDF_EXPORT=1 时才生成 PDF（避免拖慢日常 serve）
      enabled_if_env: ENABLE_PDF_EXPORT
```

完整示例可类似：

```yaml
site_name: 我的项目文档

theme:
  name: material
  language: zh

nav:
  - 首页: index.md
  - 快速开始: getting-started.md
  - 安装说明: install.md

plugins:
  - search
  - with-pdf:
      cover_title: 我的项目文档
      output_path: pdf/document.pdf
      enabled_if_env: ENABLE_PDF_EXPORT
```

### 10.2 执行带 PDF 的 build

Compose 可先停掉（可选，避免和一次性 build 抢文件）：

```bash
cd /www/wwwroot/mkdocs
docker compose down

docker run --rm \
  -e ENABLE_PDF_EXPORT=1 \
  -v "$(pwd):/app" \
  -w /app/doc \
  docker.xuanyuan.run/minidocks/mkdocs:pdf \
  build
```

成功后常见产物（**Ubuntu 24.04 实测**）：

```text
INFO    -  Building documentation to directory: /app/doc/site
INFO    -  Generate a cover page with "default_cover.html.j2".
INFO    -  Rendering for PDF.
INFO    -  Output a PDF to "/app/doc/site/pdf/document.pdf".
INFO    -  Converting 3 articles to PDF took 6.4s
INFO    -  Documentation built in 7.44 seconds
```

```bash
ls -la doc/site/pdf/document.pdf
# 实测约数十 KB 起，随页面增多而变大
```

把 `document.pdf` 拷走即可分发（可用 `scp` / 面板下载）。需要改文件名或目录时，改 `output_path` 后重新 `build`。

日志里若出现 `'created' timestamp seems very low…`，一般可忽略，不影响 PDF 生成。Material 的 MkDocs 2.0 告示同样可忽略。

### 10.3 可选：按页导出（`pdf-export`）

若要「每个 Markdown 页各出一个 PDF」，改用：

```yaml
plugins:
  - search
  - pdf-export:
      verbose: true
      media_type: print
```

同样执行上面的 `docker run … build`（此插件一般不依赖 `ENABLE_PDF_EXPORT`；若与 `with-pdf` 同时开，构建会更慢，通常二选一）。

### 10.4 注意

| 项 | 说明 |
|----|------|
| 镜像 | 必须用 **`pdf` / `1-pdf`**；`latest` **没有** PDF 插件 |
| 预览 | `serve` 时建议保留 `enabled_if_env`，不要每次热重载都出 PDF |
| 字体 | `pdf` 镜像已带常用字体；中文一般可直接出；个别生僻字再自行挂字体 |
| 再开预览 | `docker compose up -d` |

若磁盘紧张且永不导出 PDF，可改用更轻的 `latest`（约 55MB CONTENT SIZE）。

---

## 十一、常见问题 FAQ

**Q1：浏览器打不开 :8000？**  
确认 `serve` 使用了 `-a 0.0.0.0:8000`；`docker ps` 看端口映射；本机 `curl -I http://127.0.0.1:8000/`；云安全组 / `ufw allow 8000/tcp`。若 `ps` 显示 `Restarting`，先看 Q10。

**Q2：提示找不到 `mkdocs.yml`？**  
`-w` 必须指向含 `mkdocs.yml` 的目录（本文为 `/app/doc`）。挂载路径与项目名不一致时改 `-w` 与 `-v`。

**Q3：改了 Markdown 不刷新？**  
确认改的是挂载进去的宿主机文件；`serve` 仍在运行；看容器日志是否有 rebuild。Windows / macOS 若文件监听异常，可重启一次 `serve`。

**Q4：`manifest unknown`？**  
到 [标签页](https://xuanyuan.cloud/r/minidocks/mkdocs/tags) 核对标签拼写；历史标签可能不可用，自建优先 `pdf` / `1-pdf`。

**Q5：端口 8000 被占用？**  

```bash
docker run --rm \
  -v "$(pwd):/app" -w /app/doc \
  -p 8088:8000 \
  docker.xuanyuan.run/minidocks/mkdocs:pdf \
  serve -a 0.0.0.0:8000 -t material
```

浏览器改访问 `http://服务器IP:8088`。

**Q6：Windows PowerShell 里 `$(pwd)` 怎么写？**  
PowerShell 可用 `${PWD}`，例如：`-v "${PWD}:/app"`。Git Bash / WSL 与 Linux 写法一致。

**Q7：和直接 `pip install mkdocs` 有何区别？**  
功能同属 MkDocs；镜像把主题与插件打进环境，适合 CI / 无 Python 机器 / 团队统一版本。本机已有完整 Material 开发环境时，也可不用容器。

**Q8：可以把预览服务直接对公网当正式站吗？**  
不建议。`serve` 是开发服务器。正式环境请 `build` 后用 Nginx 等托管 `site/`。

**Q9：如何升级镜像？**  

```bash
docker pull docker.xuanyuan.run/minidocks/mkdocs:pdf
# 再执行原来的 run / compose up
```

升级后若某插件行为变化，对照 [User Guide](https://www.mkdocs.org/user-guide/) 与 Material 发行说明验证构建。

**Q10：Compose 一直 Restarting，日志 `Config file 'mkdocs.yml' does not exist`？**  
说明挂载的 `./doc` 里还没有项目。先停掉再创建：

```bash
cd /www/wwwroot/mkdocs
docker compose down
docker run --rm -v "$(pwd):/app" -w /app docker.xuanyuan.run/minidocks/mkdocs:pdf new doc
ls doc/mkdocs.yml doc/docs/index.md
sudo chown -R $USER:$USER /www/wwwroot/mkdocs
docker compose up -d
docker compose logs -f mkdocs
```

确认 `doc/` 与 Compose 中 `volumes: ./doc:/app/doc`、`working_dir: /app/doc` 一致。

**Q11：vim / cat 报无法写入 `doc/docs/index.md`，或 `new` 提示 `Project already exists` 但仍没有 `docs/`？**  
说明 `doc/` 已存在（常只有一个 `mkdocs.yml`），`mkdocs new` **不会**再补 `docs/`。手动创建：

```bash
cd /www/wwwroot/mkdocs
mkdir -p doc/docs
cat > doc/docs/index.md << 'EOF'
# 欢迎

这是用 **MkDocs** + Docker 镜像 `minidocks/mkdocs:pdf` 搭建的项目文档站。

- 源文件：Markdown
- 预览：`mkdocs serve`
- 构建：`mkdocs build` → `site/`
EOF
chown -R $USER:$USER /www/wwwroot/mkdocs
ls -la doc/docs/index.md
docker compose up -d
```

确认 `index.md` 存在后再改 `mkdocs.yml` / 加新页面。

---

## 十二、命令速查

| 步骤 | 命令 |
|------|------|
| 拉镜像 | `docker pull docker.xuanyuan.run/minidocks/mkdocs:pdf` |
| 建项目 | `docker run --rm -v "$(pwd):/app" -w /app docker.xuanyuan.run/minidocks/mkdocs:pdf new doc` |
| **Compose 启动（推荐）** | `cd /www/wwwroot/mkdocs && docker compose up -d` |
| 临时预览 | `docker run --rm -v "$(pwd):/app" -w /app/doc -p 8000:8000 docker.xuanyuan.run/minidocks/mkdocs:pdf serve -a 0.0.0.0:8000 -t material` |
| 构建 | `docker run --rm -v "$(pwd):/app" -w /app/doc docker.xuanyuan.run/minidocks/mkdocs:pdf build` |
| **导出 PDF** | `docker run --rm -e ENABLE_PDF_EXPORT=1 -v "$(pwd):/app" -w /app/doc docker.xuanyuan.run/minidocks/mkdocs:pdf build`（须先在 yml 启用 with-pdf） |
| Compose 预览 | `cd /www/wwwroot/mkdocs && docker compose up -d` |
| 探测 | `curl -I http://127.0.0.1:8000/` |
| 访问 | `http://服务器IP:8000` |

---

## 十三、延伸阅读

| 资源 | 链接 |
|------|------|
| 轩辕镜像页 | https://xuanyuan.cloud/zh/r/minidocks/mkdocs |
| 标签列表 | https://xuanyuan.cloud/r/minidocks/mkdocs/tags |
| Docker Hub | https://hub.docker.com/r/minidocks/mkdocs |
| MkDocs 官网 | https://www.mkdocs.org/ |
| Getting Started | https://www.mkdocs.org/getting-started/ |
| User Guide | https://www.mkdocs.org/user-guide/ |
| 部署静态站 | https://www.mkdocs.org/user-guide/deploying-your-docs/ |
| Material 主题 | https://squidfunk.github.io/mkdocs-material/ |
| 相关：Sphinx 镜像 | https://github.com/minidocks/sphinx-doc |
| 替代：mkdocs-material | https://github.com/squidfunk/mkdocs-material |
| 替代：pozgo/docker-mkdocs | https://github.com/pozgo/docker-mkdocs |
| 替代：raspberryvalley/docker-mkdocs | https://github.com/raspberryvalley/docker-mkdocs |
| 轩辕镜像使用手册 | https://xuanyuan.cloud/usage |

---

**总结**：`minidocks/mkdocs:pdf` = **功能全集（含 PDF）的 MkDocs 文档构建镜像**，自建推荐。推荐路径：**拉 `pdf` → `new` 建 `doc/` → Compose `up -d` 预览 → 改 Markdown → 按需 `build` 出 `site/`**。正式发布用静态托管。用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取，国内环境更稳。


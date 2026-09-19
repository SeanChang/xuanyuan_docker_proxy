# 不想把 PDF 丢进在线工具站？Docker 部署 Stirling PDF，浏览器打开就能处理

![不想把 PDF 丢进在线工具站？Docker 部署 Stirling PDF，浏览器打开就能处理](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf.webp)

*分类: Docker部署教程 | 标签: Stirling PDF,casjaysdevdocker/stirlingpdf,Docker,轩辕镜像,PDF工具,私有化部署,部署教程 | 发布时间: 2026-09-16 08:33:59*

> Stirling PDF 是一款可自托管的 Web PDF 工具箱，可在浏览器中完成合并、拆分、压缩、水印、OCR 与格式转换等操作，文件默认在服务端临时处理。本文将介绍如何通过 Docker Compose 部署社区镜像 casjaysdevdocker/stirlingpdf，轻松搭建私有化 PDF 工具站，适合合同归档、扫描件整理与内网办公等场景。

*本文基于 [casjaysdevdocker/stirlingpdf:2608](https://xuanyuan.cloud/zh/r/casjaysdevdocker/stirlingpdf)，实测引擎 **Stirling PDF v2.14.2**（Java **25.0.2**），测试平台 **Ubuntu 24.04** Linux。*

客户发来三份扫描合同，要合成一份归档；财务把发票 PDF 压小再塞进邮件；法务在页脚盖「内部资料」水印再外发——这些事很多人会打开某个「在线 PDF 工具」网站解决。文件一上传，合同编号、身份证页、报价金额就离开了本机，事后只能指望对方不留存、不索引。

放到机房或等保环境，要求更硬：**敏感 PDF 不要出域**。给每台电脑装 Adobe / WPS 成本高、版本难统一；让非技术同事敲命令行也不现实。更合适的做法是内网起一台服务：浏览器打开，上传、处理、下载，临时文件清掉，配置落在自己磁盘上。

**Stirling PDF**（[官方文档](https://docs.stirlingpdf.com/)、[GitHub](https://github.com/Stirling-Tools/Stirling-PDF)）就是这类开源 **Web PDF 工具箱**：合并、拆分、压缩、水印、OCR、Office 转换等集中在一个站点。本文跟做社区镜像 **`casjaysdevdocker/stirlingpdf`**（[镜像页](https://xuanyuan.cloud/zh/r/casjaysdevdocker/stirlingpdf)），容器内监听 **8080**。若需要官方语义版本（如 `2.14.x` / `ultra-lite`），见 [官方镜像部署文](https://xuanyuan.cloud/blog/10-stirling-pdfdocker)。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 登录与改密 | 浏览器打开 `:8080`，默认 `admin` / `stirling`，首次强制改密 |
| 查看与编辑 | 上传 PDF → 查看器翻页 → 文本编辑器改字（ALPHA） |
| 外发加水印 | 「添加水印」写入文字后下载 |
| OCR / Office 转换 | 本镜像含 tesseract、LibreOffice；语言包可挂 tessdata |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`casjaysdevdocker/stirlingpdf:2608`**，**Docker Compose** 映射 **8080→8080**。把下文 IP 换成你的。无 Compose 见第八节。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第八节
> - **端口**：宿主机 **8080** → 容器 **8080**（冲突改左边，如 `18080:8080`）
> - **标签**：跟做 **`2608`**（内置 **v2.14.2**）；勿写 `latest`
> - **账号**：默认 **`admin` / `stirling`**，首次强制改密（≥8 位）
> - **冷启动**：约 **60～80 秒**；未就绪 curl 会 reset；就绪后未登录访问根路径多为 **401**
> - **目录**：Linux `/www/wwwroot/stirlingpdf`；macOS 用 `~/docker/stirlingpdf`
> - **OCR 挂载**：`./tessdata` → `/usr/share/tesseract-ocr/5/tessdata`（勿照搬官方文档的 `/usr/share/tessdata`）
> - **体积 / 内存**：DISK **3.38GB** / CONTENT **1.07GB**；实测容器可见约 **1.8 GB**

官方：[文档](https://docs.stirlingpdf.com/) · [GitHub](https://github.com/Stirling-Tools/Stirling-PDF) · [镜像页](https://xuanyuan.cloud/zh/r/casjaysdevdocker/stirlingpdf) · [标签列表](https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf/tags) · [官方镜像博客](https://xuanyuan.cloud/blog/10-stirling-pdfdocker)

---

## 一、本文镜像是什么？

`casjaysdevdocker/stirlingpdf` 是 Stirling PDF 的**社区维护镜像**：浏览器里点选工具处理 PDF，不是给业务程序调用的 HTTP 转 PDF API。

| | Stirling PDF（本文） | Gotenberg | 在线 PDF 网站 |
|--|----------------------|-----------|---------------|
| 入口 | 浏览器工具页 | HTTP API | 公网上传 |
| 适合 | 人工处理、内网自助 | 应用集成、流水线 | 临时个人文件（合规差） |
| 数据 | 任务临时处理；配置落 `/configs` | 请求级无状态 | 文件离开本机 |

```text
浏览器 ──HTTP:8080──▶  stirlingpdf（:8080）
                         ├── 合并 / 压缩 / 水印 / 文本编辑 …
                         ├── OCR、LibreOffice 转换
                         └── 配置与 H2 → /configs
```

该仓库用 **年月标签**（`2608` = 2026 年 8 月构建），同时维护滚动的 `latest`。跟做固定 **`2608`**，避免静默滚动后界面或依赖与文档不一致。

> **安全提示**：勿对公网裸暴露；生产开启登录、改默认密码，并放在反代 / 内网之后。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；也可 Docker Desktop |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64** / **arm64**（另有 `latest-amd64` / `latest-arm64`） |
| 内存 | 可用 ≥ **2 GB**（实测容器检测到约 **1798 MB**） |
| 磁盘 | 镜像 DISK **3.38GB** / CONTENT **1.07GB**，另留配置与临时空间 |
| 端口 | 宿主机 **8080** |
| 工作目录 | `/www/wwwroot/stirlingpdf` |

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

社区仓库用 **YYMM**，不是上游的 `2.x.y`。产品版本以启动日志里的 `VERSION_TAG` 为准（本文实测为 **2.14.2**）。

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`2608`** | 2026-08 构建；与同期 `latest` 同 digest | **推荐** |
| `2607` / `2606` / … | 历史月度构建 | 回滚用 |
| `latest` | 滚动标签 | **勿写入跟做命令** |
| `latest-amd64` / `latest-arm64` | 单架构 | 仅需强制架构时 |

完整列表见 [标签页](https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf/tags)。需要 `ultra-lite` / `fat` 或精确 `2.x.y` 时，改用官方 `stirlingtools/stirling-pdf`。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608
```

Ubuntu 24.04 实测：

```text
2608: Pulling from casjaysdevdocker/stirlingpdf
4f4fb700ef54: Pull complete
703b030c7813: Pull complete
…（中间层省略）
225d6ffcb9a3: Pull complete
Digest: sha256:e5bd44e70e4d1b0d4c94ab85a61999eb458e5c10da5d122a11d8b2b70e555438
Status: Downloaded newer image for docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608
docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608
```

```bash
docker images docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608
```

```text
IMAGE                                                   ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608   e5bd44e70e4d       3.38GB         1.07GB
```

---

## 四、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/stirlingpdf`（macOS 实测目录为 `~/docker/stirlingpdf`）。

### 4.1 创建目录

```bash
mkdir -p /www/wwwroot/stirlingpdf/{configs,logs,pipeline,tessdata,customFiles}
chown -R "$USER:$USER" /www/wwwroot/stirlingpdf
cd /www/wwwroot/stirlingpdf
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

| 宿主机目录 | 容器内路径 | 作用 |
|------------|------------|------|
| `./configs` | `/configs` | 设置与内置 H2 |
| `./logs` | `/logs` | 应用日志 |
| `./pipeline` | `/pipeline` | 自动化流水线 |
| `./tessdata` | `/usr/share/tesseract-ocr/5/tessdata` | OCR 语言包 |
| `./customFiles` | `/customFiles` | 自定义静态资源 |

官方文档常见 OCR 路径是 `/usr/share/tessdata`；本社区镜像日志为 `TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata`，跟做按实测路径挂载。

### 4.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  stirlingpdf:
    image: docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608
    container_name: stirlingpdf
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ./configs:/configs
      - ./logs:/logs
      - ./pipeline:/pipeline
      - ./tessdata:/usr/share/tesseract-ocr/5/tessdata
      - ./customFiles:/customFiles
    environment:
      TZ: Asia/Shanghai
      SYSTEM_DEFAULTLOCALE: zh-CN
      SECURITY_ENABLELOGIN: "true"
      # 实验室可改为 "false"（勿用于公网）
      # SECURITY_INITIALLOGIN_USERNAME: admin
      # SECURITY_INITIALLOGIN_PASSWORD: "请换成强密码"
EOF
```

| 项 | 作用 |
|----|------|
| `"8080:8080"` | 宿主机访问口；容器内固定 8080 |
| `SYSTEM_DEFAULTLOCALE` | 默认界面语言（如 `zh-CN`） |
| `SECURITY_ENABLELOGIN` | 启用登录（本文跟做开启） |

### 4.3 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 100
```

刚启动时常为 `health: starting`：

```text
[+] up 2/2
 ✔ Network stirlingpdf_default Created
 ✔ Container stirlingpdf       Started

NAME          IMAGE                                                   COMMAND                  SERVICE       CREATED         STATUS                            PORTS
stirlingpdf   docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608   "tini -- /scripts/in…"   stirlingpdf   6 seconds ago   Up 4 seconds (health: starting)   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
```

此时 curl 可能 `Connection reset by peer`——容器还在起 unoserver 与 Spring Boot。等约 **1 分钟**，日志出现 `Stirling-PDF Started` 再访问。关键行（Ubuntu 24.04 实测）：

```text
[init][warn] Using TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata
--- Binary Versions ---
openjdk version "25.0.2" 2026-01-20 LTS
LibreOffice 26.2.2.2 620(Build:2)
tesseract 5.3.4
Detected container memory: 1798MB
Running Stirling PDF with DISABLE_ADDITIONAL_FEATURES= and VERSION_TAG=2.14.2
Starting SPDFApplication v2.14.2 using Java 25.0.2
The following 1 profile is active: "security"
Using default H2 database
Total disabled endpoints: 2. Disabled endpoints: pdf-to-cbr, url-to-pdf
Started SPDFApplication in 62.507 seconds (process running for 77.859)
Stirling-PDF running on port: 8080
Stirling-PDF Started.
Navigate to http://localhost:8080/
```

就绪后探测（有 `http_proxy` 时对本机加 `--noproxy '*'`）：

```bash
curl --noproxy '*' -I http://127.0.0.1:8080/
```

开启登录时，未带 Cookie 访问根路径返回 **401**，表示 HTTP 已监听且鉴权生效：

```text
HTTP/1.1 401 Unauthorized
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Content-Type: application/json
```

浏览器打开 `http://服务器IP:8080` 应看到**登录页**（不是裸 JSON）。

---

## 五、浏览器首次初始化

### 5.1 登录

登录页会提示默认账号：

| 项 | 值 |
|----|-----|
| 用户名 | `admin` |
| 密码 | `stirling` |

![Stirling PDF 登录页：默认账号 admin / stirling 提示](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-1.webp)

### 5.2 强制修改密码

首次登录会要求改密（至少 **8** 位）。改完后再用新密码进入。

![Stirling PDF 首次登录：强制修改 admin 密码](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-3.webp)

### 5.3 分析征询与 V2 引导

之后可能弹出「是否协助改善产品」与「欢迎使用 Stirling V2」引导，按需选择或点 **下一步** 跳过。

![Stirling PDF：是否协助改善产品的征询弹窗](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-2.webp)

![Stirling PDF V2 欢迎引导：全新布局与文本编辑介绍](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-4.webp)

### 5.4 主界面

工作台左侧打开文件，中间拖放区，右侧按「推荐 / 签署 / 文档安全」分组。本镜像含 LibreOffice、OCR；日志里仅少量端点禁用（如 `pdf-to-cbr`、`url-to-pdf`）。

![Stirling PDF 主界面：拖放上传与右侧工具列表](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-5.webp)

---

## 六、功能演示

### 6.1 打开 PDF

点左侧 **从电脑打开**（或中间上传），选一份 PDF。中央进入查看器，可翻页、缩放；右侧工具对当前文件生效。

![Stirling PDF 查看器：已打开 PDF 与右侧推荐工具](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-6.webp)

### 6.2 PDF 文本编辑器（ALPHA）

右侧 **推荐** → **PDF 文本编辑器**。首次会说明：适合简单版式；复杂表格、多栏效果有限。点 **知道了** 后可直接改页面文字。

![Stirling PDF 文本编辑器：抢先体验说明与适用场景](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-7.webp)

![Stirling PDF 文本编辑器：在页面上直接修改文字](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-8.webp)

### 6.3 添加水印

右侧 **文档安全** → **添加水印**：类型选文本，措辞填入内容（示例：`轩辕镜像`），调颜色后执行并下载。

![Stirling PDF 添加水印：措辞填写轩辕镜像并应用](https://imgs.xuanyuan.cloud/docker/blog/stirlingpdf-9.webp)

合并、压缩、OCR、Office 转换等同在右侧工具栏，用法与上述类似。更细能力见 [官方文档](https://docs.stirlingpdf.com/)。

---

## 七、配置与生产加固

| 环境变量 | 含义 | 建议 |
|----------|------|------|
| `SECURITY_ENABLELOGIN` | 启用登录 | 生产保持 `true` |
| `SECURITY_INITIALLOGIN_USERNAME` / `_PASSWORD` | 初始管理员 | 勿长期使用弱口令 |
| `SYSTEM_DEFAULTLOCALE` | 默认语言 | `zh-CN` |
| `TZ` | 时区 | `Asia/Shanghai` |

- **网络**：仅内网或 HTTPS 反代可达  
- **鉴权**：首次改密；有条件再叠网关鉴权 / IP 白名单  
- **备份**：重点备份 `./configs`  
- **资源**：大文件与 OCR 时关注内存；默认上传上限约 **2000MB**  
- **版本**：要对齐上游 `2.x.y` / `ultra-lite` 时，改用官方镜像坐标  

---

## 八、备选：docker run（临时 / 无 Compose）

```bash
mkdir -p /www/wwwroot/stirlingpdf/{configs,logs,pipeline,tessdata,customFiles}
cd /www/wwwroot/stirlingpdf

docker run -d \
  --name stirlingpdf \
  --restart unless-stopped \
  -p 8080:8080 \
  -v /www/wwwroot/stirlingpdf/configs:/configs \
  -v /www/wwwroot/stirlingpdf/logs:/logs \
  -v /www/wwwroot/stirlingpdf/pipeline:/pipeline \
  -v /www/wwwroot/stirlingpdf/tessdata:/usr/share/tesseract-ocr/5/tessdata \
  -v /www/wwwroot/stirlingpdf/customFiles:/customFiles \
  -e TZ=Asia/Shanghai \
  -e SYSTEM_DEFAULTLOCALE=zh-CN \
  -e SECURITY_ENABLELOGIN=true \
  docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608
```

验证同上：等日志 `Stirling-PDF Started` 后访问 `http://服务器IP:8080`。长期运行仍推荐第四节 Compose。

---

## 九、升级与迁移

1. 把 `image` 改成更新的 `YYMM` → `docker compose pull` → `docker compose up -d`  
2. 产品行为变更对照 [Stirling Releases](https://github.com/Stirling-Tools/Stirling-PDF/releases)  
3. 搬家：拷贝 `docker-compose.yml` 与 `configs` 到新机再 `up -d`  
4. 跟做与生产勿写 `latest`，固定具体年月标签  

---

## 十、常见问题 FAQ

**Q1：为什么用 `2608` 而不是 `latest`？**  
`latest` 会滚动。`2608` 与同期 `latest` 曾同 digest，但跟做应写具体标签，便于复现与回滚。

**Q2：和官方 `stirlingtools/stirling-pdf` 怎么选？**  
跟本文轩辕页坐标用社区镜像。要 `2.x.y` / `ultra-lite` / `fat` → 用官方镜像（见 [官方镜像部署文](https://xuanyuan.cloud/blog/10-stirling-pdfdocker)）。

**Q3：和 Gotenberg 怎么选？**  
人在浏览器里处理 PDF → Stirling；程序用 HTTP API 出 PDF → [Gotenberg](https://xuanyuan.cloud/blog/gotenberg-docker-deploy)。

**Q4：curl 报 `Connection reset`？**  
还在冷启动。看到 `Stirling-PDF Started`（约 60～80 秒）后再测。

**Q5：curl 返回 401 算成功吗？**  
算。开启登录时未带 Cookie 访问根路径就是 **401**；用浏览器打开登录页即可。

**Q6：默认账号登不进去？**  
用户名 `admin`、密码 `stirling`；首次改密后用新密码。若无登录框，检查是否设了 `SECURITY_ENABLELOGIN=false`。

**Q7：8080 被占用？**  
改为 `"18080:8080"`，访问 `http://IP:18080`。

**Q8：OCR 挂载路径？**  
`./tessdata:/usr/share/tesseract-ocr/5/tessdata`，不要照搬 `/usr/share/tessdata`。

**Q9：部分工具不可用？**  
本构建多数工具可用；日志禁用示例：`pdf-to-cbr`（缺 rar）、`url-to-pdf`（WeasyPrint 探测失败）。

**Q10：数据存在哪？**  
配置与 H2 在 `./configs`，请定期备份。处理任务的临时文件默认不长期保留。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608

# Compose（主路径）
cd /www/wwwroot/stirlingpdf
docker compose up -d
docker compose ps
docker compose logs -f stirlingpdf
docker compose down

# 探测（就绪后多为 401）
curl --noproxy '*' -I http://127.0.0.1:8080/

# 备选 run
docker run -d --name stirlingpdf -p 8080:8080 \
  -v /www/wwwroot/stirlingpdf/configs:/configs \
  -e SYSTEM_DEFAULTLOCALE=zh-CN \
  -e SECURITY_ENABLELOGIN=true \
  docker.xuanyuan.run/casjaysdevdocker/stirlingpdf:2608
```

验证：`http://服务器IP:8080` · 标签 `2608`（v2.14.2）· 账号 `admin` / `stirling` · 就绪：`Stirling-PDF Started`

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [casjaysdevdocker/stirlingpdf 镜像页](https://xuanyuan.cloud/zh/r/casjaysdevdocker/stirlingpdf) | [https://xuanyuan.cloud/zh/r/casjaysdevdocker/stirlingpdf](https://xuanyuan.cloud/zh/r/casjaysdevdocker/stirlingpdf) |
| [镜像概览](https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf) | [https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf](https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf) |
| [镜像标签列表](https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf/tags) | [https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf/tags](https://xuanyuan.cloud/r/casjaysdevdocker/stirlingpdf/tags) |
| [Docker Hub · casjaysdevdocker/stirlingpdf](https://hub.docker.com/r/casjaysdevdocker/stirlingpdf) | [https://hub.docker.com/r/casjaysdevdocker/stirlingpdf](https://hub.docker.com/r/casjaysdevdocker/stirlingpdf) |
| [Stirling PDF 官方文档 · Docker](https://docs.stirlingpdf.com/Installation/Docker%20Install/) | [https://docs.stirlingpdf.com/Installation/Docker%20Install/](https://docs.stirlingpdf.com/Installation/Docker%20Install/) |
| [GitHub · Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF) | [https://github.com/Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF) |
| [官方镜像教程 · stirlingtools/stirling-pdf](https://xuanyuan.cloud/blog/10-stirling-pdfdocker) | [https://xuanyuan.cloud/blog/10-stirling-pdfdocker](https://xuanyuan.cloud/blog/10-stirling-pdfdocker) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`casjaysdevdocker/stirlingpdf:2608`**（**v2.14.2**），Compose 映射 **8080**。  
- 冷启动约 **1 分钟**；见 `Stirling-PDF Started` 后再访问；未登录 curl **401** 正常。  
- 默认 **`admin` / `stirling`**，首次强制改密；OCR 挂 **`/usr/share/tesseract-ocr/5/tessdata`**。  
- 要官方语义版本 / ultra-lite 时改用 `stirlingtools/stirling-pdf`。  
- 勿对公网裸暴露；备份 **`./configs`**。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/stirlingpdf-docker-deploy



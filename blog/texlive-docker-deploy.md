# Docker 部署 TeX Live：轻松搭建 LaTeX 论文排版编译平台

![Docker 部署 TeX Live：轻松搭建 LaTeX 论文排版编译平台](https://imgs.xuanyuan.cloud/docker/blog/texlive.webp)

*分类: Docker部署教程 | 标签: TeX Live,texlive/texlive,LaTeX,Docker,轩辕镜像,论文排版,PDF,私有化部署,部署教程 | 发布时间: 2026-09-07 05:19:19*

> 导师要的 PDF 必须能复现：同门笔记本是 MikTeX，实验室服务器还是旧年 TeX Live，自己 Windows 又装了一半 CTeX。main.tex 在 A 机过、B 机缺宏包；参考文献要 Biber，中文要 XeLaTeX，字体路径再对一遍。有人把整盘 TeX 塞进本机，占几十 GB，升级宏包半天；有人把源码丢 Overleaf，学校模板和盲审稿又不方便出域。

*本文基于 [texlive/texlive:TL2025-historic](https://xuanyuan.cloud/zh/r/texlive/texlive)，实测引擎 **TeX Live 2025**（pdfTeX **1.40.28** / XeTeX **0.999997**），测试平台 **Ubuntu 24.04** Linux。*

导师要的 PDF 必须能复现：同门笔记本是 MikTeX，实验室服务器还是旧年 TeX Live，自己 Windows 又装了一半 CTeX。`main.tex` 在 A 机过、B 机缺宏包；参考文献要 Biber，中文要 XeLaTeX，字体路径再对一遍。有人把整盘 TeX 塞进本机，占几十 GB，升级宏包半天；有人把源码丢 Overleaf，学校模板和盲审稿又不方便出域。

论文源码、模板和成品 PDF 最好落在自己的盘上。课题组机房、等保环境、学位论文定稿，往往不允许把全文交到公有云编辑器。很多同学和运维已经有一台跑 Docker 的 Ubuntu，缺的只是：**镜像能拉下来、目录挂上去、`pdflatex` / `xelatex` 能出 PDF**——而不是再装一套完整桌面 TeX。

**TeX Live**（[TUG](https://tug.org/texlive/)）是主流 TeX 发行版，引擎与宏包一次配齐。社区镜像 **`texlive/texlive`**（[Island of TeX](https://gitlab.com/islandoftex/images/texlive) 维护，[镜像页](https://xuanyuan.cloud/zh/r/texlive/texlive)）做成「全量宏包、默认不含文档树」的容器，并带上 Arara / Biber / Xindy / Pygments 等常用依赖，适合本机沙箱、CI 出 PDF，以及 Dockerfile `FROM`。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 验证版本 | `docker compose exec texlive latex --version`（实测 **TeX Live 2025**） |
| 编译英文 / 中文 | 挂载目录后 `pdflatex`、`xelatex`（ctex + Fandol） |
| 写进 CI | `FROM docker.xuanyuan.run/texlive/texlive:TL2025-historic` |
| 备份搬家 | 停容器后打包 `docker-compose.yml` 与 `./workdir` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`texlive/texlive:TL2025-historic`**，**Docker Compose** 起常驻沙箱并挂载工作目录；无 Compose 或一次性编译见第七节。

> **上手要点**
> - **部署**：第五节 Compose；一次性 / 临时 shell 见第七节；CI 见第六节
> - **无 Web 控制台**：用 `latex` / `xelatex` / `pdflatex` 验证
> - **标签**：跟做 **`TL2025-historic`**，勿写 `latest`
> - **体积**：DISK **8.63GB** / CONTENT **2.59GB**；勿默认拉 `-doc`
> - **数据**：`./workdir` → `/workdir`（容器内不要写宿主机 `/www/wwwroot/...`）
> - **首次 xelatex**：可能长时间 `mktexfmt`，勿中途 Ctrl+C
> - **端口**：沙箱不映射

官方：[TeX Live](https://tug.org/texlive/) · [Island of TeX 镜像仓](https://gitlab.com/islandoftex/images/texlive) · [镜像页](https://xuanyuan.cloud/zh/r/texlive/texlive) · [标签列表](https://xuanyuan.cloud/r/texlive/texlive/tags)

---

## 一、TeX Live 镜像是什么？

`texlive/texlive` 是容器化的 TeX Live 编译环境：没有业务 Web，入口是终端和 Dockerfile。和本机装一整套发行版、或只靠在线编辑器比，更容易统一版本、换机器、进 CI。

| | TeX Live 容器（本文） | 本机 MikTeX / CTeX / MacTeX | Overleaf 等 |
|--|----------------------|-----------------------------|-------------|
| 定位 | 可复现沙箱 / CI 底 | 本机完整安装 | 浏览器协作 |
| 数据 | 挂载 `./workdir` | 本机盘 | 出域云端 |
| 适合 | 定稿、模板对齐、流水线出 PDF | 日常本地写作 | 协作草稿 |
| 代价 | 镜像大、首次拉取慢 | 安装与升级重 | 合规 / 离线受限 |

```text
宿主机 Ubuntu（Docker）
        │
        ▼
texlive/texlive:TL2025-historic
   ├── pdfTeX / XeTeX / LuaTeX + 全量宏包（默认无文档树）
   ├── Biber / Xindy / Arara / Pygments 等依赖
   ├── ./workdir → /workdir
   └── CI / 业务镜像用 Dockerfile FROM（可选）
```

[`/r/`](https://xuanyuan.cloud/r/texlive/texlive) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/texlive/texlive) 是同一镜像的不同页面语言。同站还有 `listx/texlive`、`minidocks/texlive` 等，**本文只用 `texlive/texlive:TL2025-historic`**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | 以 [tags](https://xuanyuan.cloud/r/texlive/texlive/tags) 为准；本文实测 **x86_64** |
| 内存 | ≥ **1 GB**；大文档再加 |
| 磁盘 | DISK **8.63GB** / CONTENT **2.59GB** + 工作目录（紧张时可评估更小 scheme，见第三节） |
| 端口 | 沙箱不映射 |

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

跟做使用 **`TL2025-historic`**。完整列表：[tags](https://xuanyuan.cloud/r/texlive/texlive/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`TL2025-historic`** | TeX Live 2025 冻结线；full、默认无 doc/src | **本文跟做** |
| `TL2025-historic-doc` 等 | 带文档树和/或源码树 | 确需 `texdoc` / 源码时；体积大很多 |
| `TL{YEAR}-historic` | 更早年份 | 模板强制旧年引擎时 |
| `latest`（= `latest-full`） | 当前发行线周更快照 | **勿写入跟做命令**；追新时改用并记录 digest |
| `latest-small` / `medium` / `basic` / `minimal` | 更小 scheme | 体积敏感且宏包需求明确 |
| `pretest*` | 预测试构建 | 勿当教程默认 |

`latest` 会随周更漂移，跟做步骤容易对不上。`TL2025-historic` 有明确年份，适合论文复现。historic 标签名不变，但底层 OS 可能按月重建——要固定某次构建请记录 digest。不确定变体时选不带 `-doc` / `-src` 的 **`X`**（本文即 `TL2025-historic`）。

升级时同步改 pull、Compose、`docker run`、Dockerfile 四处标签，并核对上游 [README](https://gitlab.com/islandoftex/images/texlive)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/texlive/texlive:TL2025-historic
```

Ubuntu 24.04 实测：

```text
TL2025-historic: Pulling from texlive/texlive
b2fa13ec5034: Pull complete
95bc6eb6ba24: Pull complete
4f4fb700ef54: Pull complete
755e39d6a44b: Pull complete
e25db2f6001d: Pull complete
7fc4e0944e45: Pull complete
0e97c3171a7f: Pull complete
c0ea6283a5c7: Pull complete
82bcabf172ae: Pull complete
Digest: sha256:f25ee2dcd00f58198f918064f4a1c8562410b33e84155bd55b02b419d73d9391
Status: Downloaded newer image for docker.xuanyuan.run/texlive/texlive:TL2025-historic
docker.xuanyuan.run/texlive/texlive:TL2025-historic
```

```bash
docker images docker.xuanyuan.run/texlive/texlive:TL2025-historic
```

```text
IMAGE                                                 ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/texlive/texlive:TL2025-historic   f25ee2dcd00f       8.63GB         2.59GB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `texlive/texlive:TL2025-historic` | `docker pull docker.xuanyuan.run/texlive/texlive:TL2025-historic` |

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。镜像大，首次拉取慢时先查磁盘与网络。

---

## 五、Docker Compose 部署（推荐 · 编译沙箱）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/texlive` |
| **macOS** | **`~/docker/texlive`** |

镜像没有常驻 Web 进程。跟作用 **`sleep infinity`** 保活，再 `exec` 编译。一次性出 PDF 见第七节 `--rm`。

### 5.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/texlive/workdir
cd /www/wwwroot/texlive

# macOS：mkdir -p ~/docker/texlive/workdir && cd ~/docker/texlive
```

非 root 给 `mkdir` / `docker` 加 `sudo`。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  texlive:
    image: docker.xuanyuan.run/texlive/texlive:TL2025-historic
    container_name: texlive
    restart: unless-stopped
    working_dir: /workdir
    environment:
      - TZ=Asia/Shanghai
    command: ["sleep", "infinity"]
    volumes:
      - ./workdir:/workdir
EOF
```

| 项 | 说明 |
|----|------|
| `command` | `sleep infinity` 保活；无 TTY 时默认 shell 入口可能立刻退出 |
| `working_dir` | 容器内默认 `/workdir` |
| `./workdir` | `.tex` 进、`.pdf` 出 |
| 端口 | 不必映射 |

只编译、不装系统包时可加 `user: texlive`（家目录 `/home/texlive`）。跟做默认 root，便于必要时 `apt`。

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network texlive_default Created
 ✔ Container texlive       Started
```

```text
NAME      IMAGE                                                 COMMAND            SERVICE   CREATED         STATUS         PORTS
texlive   docker.xuanyuan.run/texlive/texlive:TL2025-historic   "sleep infinity"   texlive   9 seconds ago   Up 6 seconds
```

`PORTS` 为空是预期。`sleep infinity` 几乎无应用日志。

```bash
docker compose exec texlive latex --version
docker compose exec texlive xelatex --version
docker compose exec texlive uname -m
```

实测关键行：

```text
pdfTeX 3.141592653-2.6-1.40.28 (TeX Live 2025)
kpathsea version 6.4.1
…
```

```text
XeTeX 3.141592653-2.6-0.999997 (TeX Live 2025)
kpathsea version 6.4.1
…
```

```text
x86_64
```

```bash
docker compose exec -it texlive bash
# 退出：exit
```

> **路径**：容器内当前目录是 **`/workdir`**。准备 `.tex` 请在**宿主机**写 `/www/wwwroot/texlive/workdir/…`，或在容器内写 `/workdir/…`——不要写宿主机绝对路径（容器里不存在）。

### 5.4 示例：最小英文稿

宿主机：

```bash
cat > /www/wwwroot/texlive/workdir/hello.tex <<'EOF'
\documentclass{article}
\begin{document}
Hello from TeX Live in Docker.
\end{document}
EOF
```

```bash
docker compose exec texlive pdflatex hello.tex
```

实测成功标志：

```text
This is pdfTeX, Version 3.141592653-2.6-1.40.28 (TeX Live 2025) (preloaded format=pdflatex)
…
Output written on hello.pdf (1 page, 14753 bytes).
Transcript written on hello.log.
```

产物：`/www/wwwroot/texlive/workdir/hello.pdf`。

### 5.5 示例：中文稿（XeLaTeX + ctex）

```bash
cat > /www/wwwroot/texlive/workdir/hello-zh.tex <<'EOF'
\documentclass[UTF8]{ctexart}
\begin{document}
你好，TeX Live 容器。
\end{document}
EOF

docker compose exec texlive xelatex hello-zh.tex
```

首次可能出现 `Running mktexfmt xelatex.fmt`，日志很长——等 `Output written on hello-zh.pdf`，**勿 Ctrl+C**。format 建好后再次编译会快很多。

实测（format 就绪后）成功标志：

```text
This is XeTeX, Version 3.141592653-2.6-0.999997 (TeX Live 2025) (preloaded format=xelatex)
…
Document Class: ctexart 2022/07/14 v2.5.10 Chinese adapter for class article (CTEX)
…
(/usr/local/texlive/2025/texmf-dist/tex/latex/ctex/fontset/ctex-fontset-fandol.def)
…
Output written on hello-zh.pdf (1 page).
Transcript written on hello-zh.log.
```

产物：`/www/wwwroot/texlive/workdir/hello-zh.pdf`。跟做示例默认 **Fandol**，一般不用额外挂字体；学校模板指定其它字体时再排查（FAQ Q4）。

日常习惯：源码在宿主机用编辑器改 `./workdir`，容器只负责编译；定稿阶段固定标签或记录 digest。

---

## 六、Dockerfile / CI

沙箱联调用第五节；流水线把标签写进 Dockerfile，不要长期只挂一个空 `sleep` 容器。

```dockerfile
FROM docker.xuanyuan.run/texlive/texlive:TL2025-historic

WORKDIR /workdir
COPY . /workdir
CMD ["pdflatex", "main.tex"]
```

```bash
docker build -t local/tex-paper:TL2025 .
docker run --rm -v "$PWD:/workdir" -w /workdir local/tex-paper:TL2025
```

非 root 下游（官方建议）：

```dockerfile
FROM docker.xuanyuan.run/texlive/texlive:TL2025-historic
USER texlive
WORKDIR /home/texlive
```

注意挂载目录权限（宿主机 uid/gid 需可写）。

---

## 七、备选：docker run

一次性编译：

```bash
docker run --rm \
  -v /www/wwwroot/texlive/workdir:/workdir \
  -w /workdir \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/texlive/texlive:TL2025-historic \
  pdflatex hello.tex
```

临时 shell：

```bash
docker run -it --rm \
  --name texlive \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/texlive/workdir:/workdir \
  -w /workdir \
  docker.xuanyuan.run/texlive/texlive:TL2025-historic \
  bash
```

常驻（等价第五节）：

```bash
docker run -d \
  --name texlive \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/texlive/workdir:/workdir \
  -w /workdir \
  docker.xuanyuan.run/texlive/texlive:TL2025-historic \
  sleep infinity

docker exec -it texlive bash
docker exec texlive latex --version
```

```bash
docker stop texlive && docker rm texlive
```

---

## 八、迁移 / 升级

1. 备份 `docker-compose.yml`、`./workdir` 与自建 Dockerfile。  
2. 在 [tags](https://xuanyuan.cloud/r/texlive/texlive/tags) 选新标签。  
3. 改标签后：

```bash
cd /www/wwwroot/texlive
docker compose pull
docker compose up -d
docker compose exec texlive latex --version
```

4. 跨年升级后用学校/期刊模板重编译一遍。优先换标签重建，少在容器内长期 `tlmgr update`。

---

## 九、常见问题 FAQ

**Q1：`latest` 还是 `TL2025-historic`？**  
跟做与论文复现用 **`TL2025-historic`**。`latest`（= `latest-full`）适合主动追新，改用时记录 digest。

**Q2：`latest` / `latest-full` / `latest-small` 有何区别？**  
`latest` 是 `latest-full` 的别名。`small` / `medium` / `basic` / `minimal` 更小但宏包可能不全。不确定用 full（本文 historic 即 full、无文档树）。

**Q3：为什么不默认拉 `-doc`？**  
文档树显著增大体积；编 PDF 通常不需要容器内 `texdoc`。

**Q4：中文 `xelatex` 很久 / 被 Ctrl+C 打断？**  
首次可能 `mktexfmt` 重建 format，等到 `Output written on ….pdf`。跟做示例用 ctexart + Fandol 即可；模板指定其它字体缺字时，再 `fc-list :lang=zh` 或挂载宿主机字体。

**Q5：容器里 `cat > /www/wwwroot/...` 报 No such file？**  
容器内只有 **`/workdir`**。在宿主机写 `/www/wwwroot/texlive/workdir/…`，或在容器内写 `/workdir/…`。

**Q6：容器一启动就退出？**  
守护场景加 `command: ["sleep", "infinity"]`；交互用 `docker run -it … bash`。

**Q7：镜像太大？**  
实测 DISK **8.63GB** / CONTENT **2.59GB**。可评估更小 scheme；勿同时拉多份 `-doc-src`；不用的旧标签用 `docker rmi` / `prune` 清理。

**Q8：能混用同站其它 texlive 镜像吗？**  
标签与内容未必兼容。本文只针对 **`texlive/texlive`**。

---

## 十、命令速查

```bash
docker pull docker.xuanyuan.run/texlive/texlive:TL2025-historic

cd /www/wwwroot/texlive
docker compose up -d
docker compose ps
docker compose exec texlive latex --version
docker compose exec texlive pdflatex hello.tex
docker compose exec texlive xelatex hello-zh.tex

docker compose pull && docker compose up -d
docker compose down

# 备选：一次性编译
docker run --rm \
  -v /www/wwwroot/texlive/workdir:/workdir \
  -w /workdir \
  docker.xuanyuan.run/texlive/texlive:TL2025-historic \
  pdflatex hello.tex
```

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [texlive/texlive 镜像页（中文）](https://xuanyuan.cloud/zh/r/texlive/texlive) | [https://xuanyuan.cloud/zh/r/texlive/texlive](https://xuanyuan.cloud/zh/r/texlive/texlive) |
| [texlive/texlive 概览](https://xuanyuan.cloud/r/texlive/texlive) | [https://xuanyuan.cloud/r/texlive/texlive](https://xuanyuan.cloud/r/texlive/texlive) |
| [texlive/texlive 标签列表](https://xuanyuan.cloud/r/texlive/texlive/tags) | [https://xuanyuan.cloud/r/texlive/texlive/tags](https://xuanyuan.cloud/r/texlive/texlive/tags) |
| [Island of TeX · texlive 镜像仓库](https://gitlab.com/islandoftex/images/texlive) | [https://gitlab.com/islandoftex/images/texlive](https://gitlab.com/islandoftex/images/texlive) |
| [TeX Live 官网](https://tug.org/texlive/) | [https://tug.org/texlive/](https://tug.org/texlive/) |
| [Docker Hub · texlive/texlive](https://hub.docker.com/r/texlive/texlive) | [https://hub.docker.com/r/texlive/texlive](https://hub.docker.com/r/texlive/texlive) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`TL2025-historic`**：Compose + `sleep infinity`，挂 `./workdir`，`pdflatex` / `xelatex` 出 PDF  
- 勿默认 `latest` / `-doc`；体积约 DISK **8.63GB**  
- 源文件在宿主机写，容器内路径是 `/workdir`；首次 `xelatex` 可能 `mktexfmt`  
- CI 用 Dockerfile `FROM`；临时编译用 `docker run --rm`

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/texlive-docker-deploy



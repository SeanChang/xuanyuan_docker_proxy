# Docker 部署 DeepSeek Harness：轻松搭建本地 AI Agent 运行时平台

![Docker 部署 DeepSeek Harness：轻松搭建本地 AI Agent 运行时平台](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness.webp)

*分类: Docker部署教程 | 标签: DeepSeek Harness,runzhliu/deepseek-harness,Docker,轩辕镜像,AI Agent,Web UI,私有化部署,部署教程 | 发布时间: 2026-09-11 14:33:04*

> DeepSeek Harness 是面向 AI Agent 的运行时与 Web UI，不是推理服务器。本文将介绍如何通过 Docker Compose 快速部署社区镜像 runzhliu/deepseek-harness，轻松搭建可自托管的本地 Agent 环境，适合体验 Agent、联调工具链与小团队内网试用等场景。

*本文基于 [runzhliu/deepseek-harness:0.1.5-rc.2-r1](https://xuanyuan.cloud/zh/r/runzhliu/deepseek-harness)，跟做标签 **0.1.5-rc.2-r1**（上游 `@deepseek-ai/dsh@0.1.5-rc.2`），测试平台 **Ubuntu 24.04** Linux。*

想在本机试 DeepSeek 的 Agent，卡点通常不在「再下一个权重包」。你要把仓库目录交给它改、在浏览器里开会话、配 API Key、还要终端和可选的内嵌 Chromium——本机用 `npx` 能跑起来，重启后会话和配置却对不上号；同事想用浏览器点几下试用，又怕把能执行代码的服务直接挂到局域网。

云端对话产品更省事，但密钥、私有仓库和客户代码往往不能出域。机房或家里已经有一台 Ubuntu + Docker 时，更省事的做法是：**容器装好固定版本的 `@deepseek-ai/dsh`，状态进命名卷，工作区挂本机目录，打开日志里的 token 链接就能进 Web UI**。

**DeepSeek Harness**（[上游仓库](https://github.com/deepseek-ai/deepseek-harness)、npm [`@deepseek-ai/dsh`](https://www.npmjs.com/package/@deepseek-ai/dsh)）是 TypeScript 写的 **AI Agent 运行时**：管会话、工具、权限与 Web UI，**不是**推理服务器，也不带模型权重。本文用的 **`runzhliu/deepseek-harness`**（[镜像页](https://xuanyuan.cloud/zh/r/runzhliu/deepseek-harness)、[容器项目](https://github.com/runzhliu/deepseek-harness-docker)）是社区镜像：不改上游源码，把指定 npm 版本装进非 root 的 Node 24，默认起 Web UI，并带 Chromium / noVNC。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 浏览器用 Agent | 用日志中的 `?token=...` 打开 Web UI，配置 API Key 后开会话 |
| 对着本地仓库干活 | 宿主机项目挂到 `/workspace`，在 UI 里选该目录再跑工具 |
| 内嵌浏览器 | 侧栏点「浏览器」，打开容器内 Chromium（**6080** 无登录，勿对公网） |
| 无界面批处理 | 同一镜像加 `--profile headless` 跑一次性任务 |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`runzhliu/deepseek-harness:0.1.5-rc.2-r1`**，**Docker Compose** 启动。实测局域网 IP **`192.168.1.35`**，请换成你的。无 Compose 见第七节。文内附 **4** 张实测截图。

> **上手要点**
> - **部署**：第四节 Compose；临时试玩见第七节 `docker run`
> - **端口**：宿主机 **3080**（Web）、**6080**（noVNC）
> - **访问**：`http://服务器IP:3080/?token=…`；**选择工作区若 403** → `localhost` + SSH 隧道（FAQ Q3）
> - **API Key**：首次弹窗或 `DEEPSEEK_API_KEY`；未配会 `MISSING_CREDENTIAL`
> - **标签**：跟做 **`0.1.5-rc.2-r1`**，勿写 `latest`
> - **数据**：`dsh-home` → `/home/node/.dsh`；`./workspace` → `/workspace`
> - **冷启动**：约 **1～2 分钟** 等到 `healthy` 再取 token
> - **体积**：DISK **3.65GB** / CONTENT **933MB**
> - **目录**：Linux `/www/wwwroot/deepseek-harness`；macOS `~/docker/deepseek-harness`
> - **注意**：预发布；仅建议信任内网；升级前备份 `dsh-home`（会话格式 V3）

官方：[DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) · [deepseek-harness-docker](https://github.com/runzhliu/deepseek-harness-docker) · [镜像页](https://xuanyuan.cloud/zh/r/runzhliu/deepseek-harness) · [标签列表](https://xuanyuan.cloud/r/runzhliu/deepseek-harness/tags) · [Docker Hub](https://hub.docker.com/r/runzhliu/deepseek-harness)

---

## 一、runzhliu/deepseek-harness 是什么？

| | 说明 |
|--|------|
| 是什么 | 官方 `@deepseek-ai/dsh` 的社区容器（默认 Web，可选 Headless） |
| 不是什么 | 不是 DeepSeek 官方镜像；不是 LLM 推理 / 权重包 |
| 架构 | **amd64 + arm64** |
| 跟做基线 | `@deepseek-ai/dsh@0.1.5-rc.2` → 镜像标签 **`0.1.5-rc.2-r1`** |
| 自带能力 | Web UI（token + Cookie）、Debian Chromium / noVNC、可装社区插件 |

| | 本文镜像 | 本机 `npx @deepseek-ai/dsh` | 云端 Chat SaaS |
|--|----------|------------------------------|----------------|
| 定位 | 可复现的本地 Agent 运行时 | 临时 CLI | 托管对话 |
| 持久化 | `dsh-home` + `/workspace` | 依赖本机习惯 | 出域 |
| 适合 | 内网试用、对着仓库联调 | 快速试命令 | 少运维 |

```text
浏览器 ──:3080──▶  Web UI（token → Cookie）
         ──:6080──▶  noVNC / 内嵌 Chromium（无认证）
dsh-home ──▶ /home/node/.dsh
./workspace ──▶ /workspace
```

同站还有 `smanx/deepseek-harness`、`moelin/deepseek-harness` 等变体（反代、登录方式不同）。**本文只跟做 `runzhliu/deepseek-harness:0.1.5-rc.2-r1`**。

| 标签 | 用途 |
|------|------|
| **`0.1.5-rc.2-r1`** | 默认跟做（Debian Chromium） |
| `…-r1-ungoogled.1` | 隐私向 Chromium 变体 |
| `…-r1-market.1` | 额外插件市场（显式选用） |

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | **Linux**（建议 Ubuntu 24.04）；macOS + Docker Desktop 亦可 |
| Docker | Engine + **Compose V2** |
| 内存 | 建议 ≥ **2 GB**（开 Chromium 宜更宽裕） |
| 磁盘 | DISK **约 3.65GB** + 会话 / 工作区增长 |
| 端口 | 宿主机 **3080**、**6080** |
| 账号 | 无预置密码；靠日志里的 **launch token** |

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

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1
```

Ubuntu 24.04 实测：

```text
0.1.5-rc.2-r1: Pulling from runzhliu/deepseek-harness
44136fa355b3: Download complete
0987ade87869: Pull complete
1332a02f1607: Pull complete
733e36e3853e: Pull complete
27ee9a825048: Pull complete
681e9b650ca4: Pull complete
00f78834a2fe: Pull complete
74db55ccb683: Pull complete
a331acdbc7d3: Pull complete
31845e895b6f: Pull complete
05b3cd6b8b7e: Pull complete
4f4fb700ef54: Pull complete
cdd351ebf10e: Pull complete
d87179d4fd3e: Pull complete
c7a65875615d: Pull complete
a6f7147c6449: Pull complete
1f13eee2a50b: Pull complete
1be2c0a2f1ad: Pull complete
f4242c76c3aa: Pull complete
1ee9fbecc064: Pull complete
b59989d6a0c5: Pull complete
cbc19164244e: Pull complete
44fed46b68cf: Pull complete
999ea1f77fcd: Pull complete
3d30ea67d8ab: Download complete
Digest: sha256:b19cbd870ddf8333cba9039c85ec89e7620894bfa77fcff2dfb4b5e0b8fa958c
Status: Downloaded newer image for docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1
docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1
```

```bash
docker images docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1
```

```text
IMAGE                                                         ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1   b19cbd870ddf       3.65GB          933MB
```

完整标签见 [tags](https://xuanyuan.cloud/r/runzhliu/deepseek-harness/tags)。升级时改 Compose / `docker run` 中的标签，并核对上游 [Release](https://github.com/deepseek-ai/deepseek-harness/releases)。

---

## 四、Docker Compose 部署（推荐）

工作目录：Linux **`/www/wwwroot/deepseek-harness`**；macOS 用 **`~/docker/deepseek-harness`**。

下文 Compose **直接拉镜像**（不必 clone 上游仓库构建），并加上 `read_only`、`cap_drop`、`shm_size` 等常用加固项。

### 4.1 创建目录

```bash
sudo mkdir -p /www/wwwroot/deepseek-harness/workspace
sudo chown -R 1000:1000 /www/wwwroot/deepseek-harness/workspace
cd /www/wwwroot/deepseek-harness
# macOS：mkdir -p ~/docker/deepseek-harness/workspace && cd ~/docker/deepseek-harness
```

需要 Agent 改的代码可先放进 `workspace/`，或启动前设置 `DSH_WORKSPACE` 指向已有项目（绝对路径）。

### 4.2 编写 compose.yml

```bash
cat > compose.yml <<'EOF'
services:
  deepseek-harness:
    image: docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1
    container_name: deepseek-harness
    ports:
      - "3080:3080"
      - "6080:6080"
    environment:
      DSH_TELEMETRY_DISABLED: "1"
      DSH_DESKTOP_ENABLED: "1"
      DSH_DESKTOP_PUBLIC_PORT: "6080"
      HOME: /workspace
      TZ: Asia/Shanghai
      # DEEPSEEK_API_KEY: "你的密钥"   # 可选；也可在 Web 弹窗里填
    volumes:
      - dsh-home:/home/node/.dsh
      - ${DSH_WORKSPACE:-./workspace}:/workspace
    read_only: true
    tmpfs:
      - /tmp:rw,noexec,nosuid,nodev,size=512m
    shm_size: "1gb"
    cap_drop:
      - ALL
    security_opt:
      - no-new-privileges:true
    pids_limit: 512
    restart: unless-stopped
    healthcheck:
      test:
        [
          "CMD",
          "node",
          "-e",
          "Promise.all([fetch('http://127.0.0.1:3080/'), fetch('http://127.0.0.1:6080/vnc.html')]).then(([web, desktop]) => { if (web.status !== 401 || !desktop.ok) process.exit(1) }).catch(() => process.exit(1))",
        ]
      interval: 15s
      timeout: 5s
      start_period: 90s
      retries: 5

volumes:
  dsh-home:
EOF
```

- **`3080:3080` / `6080:6080`**：局域网可访问；勿映射到公网（Web 无 TLS，6080 无认证）  
- **`dsh-home`**：配置、凭证、会话；**`./workspace`**：代码与文件  

### 4.3 启动与取 token

```bash
# 可选：export DSH_WORKSPACE=/绝对路径/到/你的项目

docker compose up -d
docker compose ps
```

刚启动多为 `health: starting`（实测）：

```text
[+] up 3/3
 ✔ Network deepseek-harness_default Created
 ✔ Volume deepseek-harness_dsh-home Created
 ✔ Container deepseek-harness       Started

NAME               IMAGE                                                         STATUS
deepseek-harness   docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1   Up … (health: starting)
```

Web + Chromium 冷启动常见 **1～2 分钟**。等到 `healthy` 再取 token：

```bash
docker compose ps
docker compose logs -f --no-color deepseek-harness
# Ctrl+C 后：
docker compose logs --no-color deepseek-harness | grep 'dsh web:'
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:3080/
```

就绪实测：

```text
dsh web: http://127.0.0.1:3080/?token=<启动token>

NAME               IMAGE                                                         STATUS          PORTS
deepseek-harness   docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1   Up … (healthy)  0.0.0.0:3080->3080/tcp, 0.0.0.0:6080->6080/tcp

401
```

`curl` 得 **401** 表示服务已起、且未带 token（符合预期）。`grep` 为空或 `curl` 为 `000` 时继续等，不要立刻判定失败。

浏览器打开（把 IP、token 换成你的）：

```text
http://192.168.1.35:3080/?token=<启动token>
```

> **访问怎么选**  
> - 看界面、配 API Key、开会话：用上面的 **局域网 IP** 即可。  
> - 点 **选择工作区** 若报 `directoryPicker … 403`：上游把目录选择钉在 loopback；请用 SSH 隧道打开 **`http://localhost:3080/?token=…`**（见 FAQ Q3）。Chrome 上请用 `localhost`，不要用 `127.0.0.1`。  
> - 日志里的 `LAN: 192.168.96.x` 是容器网桥地址，**不要**当宿主机 IP。

重建容器后 token 会变，以最新日志为准。

---

## 五、浏览器首次初始化

### 5.1 内测声明

带 token 进入后先出现 **内测声明**（0.1 开发者预览），点 **继续**。

![DeepSeek Harness 首次进入：内测声明弹窗，点击继续](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-1.webp)

### 5.2 添加 API Key

接着弹出 **添加一个 API Key 开始使用**。填 DeepSeek 官方密钥后点 **保存并继续**，或点 **稍后配置**。密钥只放 Web 凭证、环境变量或 Secrets，不要写进镜像。

![DeepSeek Harness：添加 API Key 弹窗，可保存并继续或稍后配置](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-2.webp)

### 5.3 选择工作区

主界面标题为 **探索未至之境 预览版**；左侧有 **+ 新会话**、**工作区**，底部有 **浏览器** / **设置**。必须先 **选择工作区** 才能输入。

![DeepSeek Harness 主界面：探索未至之境预览版，需先选择工作区](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-3.webp)

工作区对应容器 **`/workspace`**（宿主机 `./workspace`）。若目录选择器 403，按 §4.3 / FAQ Q3 改用 `localhost` 隧道后再选。

### 5.4 发消息与模型

选好工作区后即可发消息，底部可切换模型（如 **DeepSeek-V4.1-Flash**）。未配密钥时会出现 **本轮运行失败** / `MISSING_CREDENTIAL`：

![DeepSeek Harness 会话：未配置 API Key 时出现 MISSING_CREDENTIAL，可切换 DeepSeek 模型](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-4.webp)

在弹窗或 **设置** 里补上 `DEEPSEEK_API_KEY` 后重试。侧栏 **浏览器** 可开内嵌 Chromium；独立 noVNC（无认证）一般不必直开：

```text
http://192.168.1.35:6080/novnc-debian-1.6.0-2/vnc.html?autoconnect=1
```

---

## 六、安全与升级

| 项 | 建议 |
|----|------|
| 网络 | **3080 / 6080** 仅建议信任内网；勿对公网裸暴露 |
| 挂载 | 只挂需要的工作区；勿挂宿主机根、`~/.ssh`、云凭证或 Docker socket |
| 权限 | 镜像 UID **1000**；工作区 `chown 1000:1000`，不要改成 root 跑 |
| 插件 | 勿装未审核插件；多租户不要共用同一实例 |
| 升级 | 改标签 → `docker compose pull && up -d`；先备份 `dsh-home` |
| 会话 | `0.1.5` 系列为 Session Format **V3**；旧版 DSH 读不了已迁移会话 |
| 停服 | `docker compose down` 保留卷；`down --volumes` 会清空状态，慎用 |

公网场景须自行加反向代理、TLS 与认证，并单独评估 noVNC。

---

## 七、备选：docker run

```bash
docker volume create dsh-home

docker run -d \
  --name deepseek-harness \
  --restart unless-stopped \
  -p 3080:3080 \
  -p 6080:6080 \
  --shm-size 1g \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,nodev,size=512m \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  --pids-limit 512 \
  -e DSH_TELEMETRY_DISABLED=1 \
  -e DSH_DESKTOP_ENABLED=1 \
  -e DSH_DESKTOP_PUBLIC_PORT=6080 \
  -e HOME=/workspace \
  -e TZ=Asia/Shanghai \
  --mount type=volume,src=dsh-home,dst=/home/node/.dsh \
  --mount type=bind,src=/www/wwwroot/deepseek-harness/workspace,dst=/workspace \
  docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1
```

```bash
docker logs deepseek-harness 2>&1 | grep 'dsh web:'
```

浏览器：`http://服务器IP:3080/?token=…`。

### Headless（可选）

```bash
docker run --rm \
  --env DEEPSEEK_API_KEY \
  --mount type=volume,src=dsh-home,dst=/home/node/.dsh \
  --mount type=bind,src=/www/wwwroot/deepseek-harness/workspace,dst=/workspace \
  docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1 \
  --profile headless "summarize this repository"
```

---

## 八、常见问题 FAQ

**Q1：打开 `http://服务器IP:3080/` 返回 401？**  
正常。必须带日志里的 `?token=...`。

**Q2：`curl` 为 `000`，或 `grep 'dsh web:'` 为空？**  
仍在冷启动。看 `docker compose ps` 是否 `health: starting`，跟日志等到 `dsh web:`。数分钟后仍失败再查内存、工作区权限、端口占用。

**Q3：选择工作区报 `directoryPicker/list` HTTP 403？**  
上游特权接口只认 loopback。局域网 IP 打开页面时选目录会 403；`127.0.0.1` 在部分 Chrome 也会因 Origin 校验失败。

```bash
ssh -L 3080:127.0.0.1:3080 -L 6080:127.0.0.1:6080 用户名@192.168.1.35
```

本机浏览器打开：

```text
http://localhost:3080/?token=<启动token>
```

再选 **`/workspace`**。若 SSH 密码被拒，多半是 root 禁止密码登录，请换有权限的用户或改用密钥。

**Q4：发消息报 `MISSING_CREDENTIAL`？**  
未写入 DeepSeek API Key。在首次弹窗或 **设置** 中保存，或在 Compose 增加 `DEEPSEEK_API_KEY` 后重建。

**Q5：工作区 `EACCES` / 只读？**  
确认目录属主 UID **1000**，且 `HOME=/workspace`。用本文标签重建容器。

**Q6：该用 `latest` 吗？镜像页还写着 `alpha.1`？**  
不要用 `latest`（上游也不发）。跟做 **`0.1.5-rc.2-r1`**；介绍文案滞后时以 [标签列表](https://xuanyuan.cloud/r/runzhliu/deepseek-harness/tags) 与容器 README 为准。

**Q7：要插件市场吗？**  
默认镜像不含。需要时显式换 `0.1.5-rc.2-r1-market.1`，并阅读上游说明；第三方插件未经 DeepSeek / 本镜像项目审计。

---

## 九、命令速查

```bash
docker pull docker.xuanyuan.run/runzhliu/deepseek-harness:0.1.5-rc.2-r1

cd /www/wwwroot/deepseek-harness
docker compose up -d
docker compose ps
docker compose logs --no-color deepseek-harness | grep 'dsh web:'
docker compose logs -f deepseek-harness
docker compose down

curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:3080/
```

---

## 十、延伸阅读

| 资源 | 链接 |
|------|------|
| [runzhliu/deepseek-harness 镜像页](https://xuanyuan.cloud/zh/r/runzhliu/deepseek-harness) | [https://xuanyuan.cloud/zh/r/runzhliu/deepseek-harness](https://xuanyuan.cloud/zh/r/runzhliu/deepseek-harness) |
| [镜像标签列表](https://xuanyuan.cloud/r/runzhliu/deepseek-harness/tags) | [https://xuanyuan.cloud/r/runzhliu/deepseek-harness/tags](https://xuanyuan.cloud/r/runzhliu/deepseek-harness/tags) |
| [deepseek-harness-docker](https://github.com/runzhliu/deepseek-harness-docker) | [https://github.com/runzhliu/deepseek-harness-docker](https://github.com/runzhliu/deepseek-harness-docker) |
| [DeepSeek Harness 上游](https://github.com/deepseek-ai/deepseek-harness) | [https://github.com/deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) |
| [Docker Hub · runzhliu/deepseek-harness](https://hub.docker.com/r/runzhliu/deepseek-harness) | [https://hub.docker.com/r/runzhliu/deepseek-harness](https://hub.docker.com/r/runzhliu/deepseek-harness) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- **DeepSeek Harness** 是 Agent **运行时 + Web UI**，不是推理镜像；跟做 **`runzhliu/deepseek-harness:0.1.5-rc.2-r1`**。  
- **Compose** 主路径：状态进 **`dsh-home`**，代码进 **`/workspace`**，端口 **3080 / 6080**。  
- 用日志 **token** 打开 `http://服务器IP:3080/?token=…`；选工作区若 403，改用 **`localhost` + SSH 隧道**。  
- 配好 **API Key** 再发消息；仅建议信任内网，勿对公网裸暴露。  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy



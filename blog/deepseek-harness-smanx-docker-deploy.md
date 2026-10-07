# Docker 部署 DeepSeek Harness（smanx）：轻松搭建局域网里的 AI Agent 平台

![Docker 部署 DeepSeek Harness（smanx）：轻松搭建局域网里的 AI Agent 平台](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx.webp)

*分类: Docker部署教程 | 标签: DeepSeek Harness, smanx/deepseek-harness, Docker, 轩辕镜像, AI Agent, Web UI, 私有化部署, 部署教程 | 发布时间: 2026-10-06 13:40:30*

> DeepSeek Harness 是带网页的本机 AI Agent，会话和工具都跑在你自己的机器上，模型调用用你自己的 API Key。本文用 Docker Compose 部署 smanx/deepseek-harness 之后，可以让 Agent 修改你交给它的目录里的文件。适合内网试用、把本机项目交给 Agent，以及给同网段访问加上登录。

*本文基于 [smanx/deepseek-harness:0.2.0-rc.2](https://xuanyuan.cloud/r/smanx/deepseek-harness)，以 **0.2.0-rc.2** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

同事要在浏览器里试 DeepSeek 的 Agent：把一个仓库目录交给它改，开一轮会话，填上 API Key。本机执行 `dsh web` 时，进程只听 `127.0.0.1`，官方不允许 `--host 0.0.0.0`。你把局域网 IP 发过去，页面能开，对话却一直转圈。浏览器不把局域网地址当成安全页面，`crypto.randomUUID` 用不了，消息发不出去。设置里的插件也是空的，界面只把 `localhost` 当成本机。

把 API Key 和私有仓库填进谁都能打开的公开演示站，密钥会离开你的机器。云端对话更省事，客户代码和仓库目录却不能随便传出去。家里或机房已经有一台装了 Docker 的 Linux，就可以在容器里跑固定版本的 `@deepseek-ai/dsh`，会话放进命名卷，局域网只留代理这一个口。

**DeepSeek Harness**（[上游仓库](https://github.com/deepseek-ai/deepseek-harness)、[镜像页](https://xuanyuan.cloud/r/smanx/deepseek-harness)、[容器项目](https://github.com/smanx/deepseek-harness-docker)）是跑在本机上的 AI Agent，管会话、工具和权限，自带网页。模型调用用你自己的 API Key，镜像里没有模型权重。社区镜像 **`smanx/deepseek-harness`** 把这个程序装进 Node 24，并加了一层反向代理：里面的程序仍听 `127.0.0.1:3079`，代理听 `0.0.0.0:3080`。用局域网 IP 打开时，代理补上 `crypto.randomUUID`，设置和选目录也能用；首页的登录状态由代理换好，不用自己在地址栏拼 `?token=`。本文使用 **`smanx/deepseek-harness:0.2.0-rc.2`** 版本实测。

跑通之后，同事用局域网地址打开网页，选好目录，就可以让 Agent 改这个目录里的文件，也可以换模型、开关插件。

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**；macOS 目录用 `~/docker/deepseek-harness-smanx` |
| Docker | Engine + **Compose V2** |
| 架构 | **linux/amd64**、**linux/arm64** |
| 内存 | 无内置数据库，不用另起 MariaDB 或 MySQL；会话和工作区另占磁盘 |
| 端口 | 宿主机 **3080** → 容器代理 **3080**；容器内 DSH 的 **3079** 不映射到宿主机 |
| 数据 | 命名卷 `dsh-data` → `/root/.dsh` |
| 账号 | 默认无网页密码；两个环境变量都设置后才启用 Basic Auth |

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

更多见[轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 二、拉取镜像

### 2.1 标签怎么选

镜像按构建时实际安装的 `@deepseek-ai/dsh` 版本打具体标签。`latest` 与当次的版本标签是同一次构建；本文命令写 **`0.2.0-rc.2`**。当前发布线是 rc，仓库里没有不带 rc 的稳定号。

升级时只修改标签。数据卷保留。

| 标签 | 说明 | 本文是否采用 |
|------|------|--------------|
| **`0.2.0-rc.2`** | 精简运行镜像：Node + DSH + 反向代理。与当次 `latest` 同一构建 | **采用** |
| `devtools-min-0.2.0-rc.2` | 精简工具版：git、curl、wget、nano、jq 等，并带 **pnpm**、**uv** | 要装插件或跑 `uvx` MCP 时换这个 |
| `devtools-0.2.0-rc.2` | 完整工具版：再加 vim、python3、make、g++ 等 | 要在容器里编译时再换 |
| `admin-0.2.0-rc.2` | 管理版：预装当前 DSH，网页 `/__admin/` 可安装或切换版本 | 要在网页里换版本时用，并多挂 `/opt/dsh` |
| `test-0.2.0-rc.2` | 维护者测试标签，构建时会预装指定插件 | 日常部署不用 |
| `latest`、`devtools-latest`、`admin-latest` | 浮动标签，下次构建会变 | **勿写入文中命令** |

工具版才自带 **pnpm** 和 **uv**。`dsh plugin` 和社区插件市场依赖 pnpm；不少 MCP 的启动命令是 `uvx`。精简版 `0.2.0-rc.2` 不含这两样，只在浏览器里开会话时够用。

完整列表见[标签页](https://xuanyuan.cloud/r/smanx/deepseek-harness/tags)。

### 2.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2
```

Ubuntu 24.04 实测：

```text
0.2.0-rc.2: Pulling from smanx/deepseek-harness
774043ccc8cc: Pull complete
4f4fb700ef54: Pull complete
b33267874105: Pull complete
227c895cf5d2: Pull complete
147c8303b2c2: Pull complete
1c473ca5523b: Pull complete
432a781f6e20: Pull complete
eab09f3e3981: Pull complete
a0498254f698: Pull complete
bd7644ce343c: Pull complete
f5f2f3bb606b: Pull complete
2a11efab3191: Pull complete
54f0823e49a8: Pull complete
a923d2875935: Pull complete
297976701a70: Pull complete
fd4268f67964: Pull complete
6a2f5f1903f2: Pull complete
44136fa355b3: Download complete
7a5e7cd2e9cb: Download complete
Digest: sha256:f5dbbbc90e916e77f59fe3a9f3bb02b44e2704c3960905f5419d3a4415b558db
Status: Downloaded newer image for docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2
docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2
```

Docker Hub 路径不便时，改用 GHCR。把 `***` 换成个人中心的专属域前缀。这个专属域用于拉取，不要填 GitHub PAT 做 `docker login`。

```bash
docker pull ***-ghcr.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2
```

GHCR 与 Hub 的标签一致。若改走 GHCR，下文 Compose 和 `docker run` 里的镜像名换成同一条 `***-ghcr.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2`。

---

## 三、Docker Compose 部署

工作目录：Linux **`/www/wwwroot/deepseek-harness-smanx`**。macOS 用 **`~/docker/deepseek-harness-smanx`**。

会话和配置在命名卷里，不必先建数据目录。只有准备把宿主机项目交给 Agent 时，才需要 `workspace/`。

### 3.1 创建目录

```bash
sudo mkdir -p /www/wwwroot/deepseek-harness-smanx
cd /www/wwwroot/deepseek-harness-smanx
# macOS：mkdir -p ~/docker/deepseek-harness-smanx && cd ~/docker/deepseek-harness-smanx
```

### 3.2 编写 compose.yaml

容器内 DSH 听 **3079**，不发布到宿主机。对外只有代理 **3080**。两个端口必须不同。

```bash
cat > compose.yaml <<'EOF'
services:
  deepseek-harness:
    image: docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2
    container_name: dsh-harness
    ports:
      - "3080:3080"
    environment:
      TZ: Asia/Shanghai
      # PROXY_USERNAME: yourname
      # PROXY_PASSWORD: yourpass
    volumes:
      - dsh-data:/root/.dsh
      # - ./workspace:/workspace
    restart: unless-stopped

volumes:
  dsh-data:
EOF
```

- **`3080:3080`**：宿主机 **3080** → 容器代理 **3080**。只给信任的局域网用，不要映射到公网。
- **`dsh-data` → `/root/.dsh`**：配置、凭证和会话。容器以 root 运行，数据写在这个目录。
- **`./workspace:/workspace`**：默认注释掉。要改宿主机上的仓库时再打开，做法见下文「挂载工作区」。主目录里新建的同名文件夹不是这条挂载。
- **Basic Auth**：`PROXY_USERNAME` 和 `PROXY_PASSWORD` 必须同时填写才会生效。只填一个等于不认证。

### 3.3 启动并确认代理就绪

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 3/3
 ✔ Volume deepseek-harness-smanx_dsh-data Created
 ✔ Network deepseek-harness-smanx_default Created
 ✔ Container dsh-harness                  Started

NAME          IMAGE                                                   COMMAND                SERVICE            CREATED         STATUS         PORTS
dsh-harness   docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2   "/app/entrypoint.sh"   deepseek-harness   5 seconds ago   Up 3 seconds   0.0.0.0:3080->3080/tcp, [::]:3080->3080/tcp
```

Compose 会给卷名加上项目目录前缀。这次的卷是 **`deepseek-harness-smanx_dsh-data`**，对应容器内 `/root/.dsh`。

入口脚本会先等 DSH 就绪，最长约 **120** 秒。

DSH 就绪之后，脚本再拉起代理。

本次实测在数秒内就绪。

然后再看日志：

```bash
docker compose logs --no-color deepseek-harness
```

```text
[dsh] 启动 DSH (dsh web --port 3079) ...
[dsh] 等待 DSH 就绪 (127.0.0.1:3079) ...
dsh web: http://127.0.0.1:3079/?token=<启动token>
dsh web: opening the default browser; pass --no-open to disable
[dsh] DSH 就绪（pid 7）
[proxy] 启动代理：0.0.0.0:3080 -> 127.0.0.1:3079
代理已启动，监听 0.0.0.0:3080，转发到 http://127.0.0.1:3079（未启用认证）
```

`?token=` 那一行是容器内部地址，代理会自己用来换会话 cookie。

浏览器打开宿主机的 **3080**。不要把这条内部链接发给别人。

`opening the default browser` 发生在容器里。服务器桌面上不会弹出窗口。

日志末尾应有「未启用认证」。

若出现 `DSH 120 秒内未就绪` 或 `DSH 进程已退出`，先看同一段日志的前面几行。

然后再查内存，以及 **3080** 是否被占用。

代理转发失败时，日志里会有 `502` 或「上游 DSH 不可达」。

打开浏览器之前，把下面地址里的 IP 换成你的服务器局域网地址。

```text
http://<服务器局域网IP>:3080/
```

---

## 四、浏览器里开始用

用上一节的局域网地址打开首页。代理已经换好会话 cookie。

### 4.1 预览版说明

1. 打开首页。
2. 阅读「预览版说明」。
3. 点击「继续」。

顶部若出现「无法创建默认工作区，请通过选择工作区选择文件夹」，接着按下一小节选目录。这是还没选文件夹，不是容器启动失败。

![DeepSeek Harness 首次进入：预览版说明弹窗，按钮为继续，顶部提示无法创建默认工作区](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx-1.webp)

### 4.2 添加 API Key

先决定要不要现在填写密钥。密钥只放在网页里，不要写进镜像，也不要提交到仓库。镜像页上的在线演示是公开网站。演示站的账号不能用来登录你自己启动的容器。按本文启动的实例没有预置密码。

现在就要填写密钥时：

1. 在「API 密钥」中填入密钥。
2. 点击「保存并继续」。

想稍后再填时，点击「稍后配置」。

发消息之前，再把密钥补上。

![DeepSeek Harness：添加一个 API Key 开始使用，可稍后配置或保存并继续](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx-2.webp)

### 4.3 选择工作区

1. 通过「选择工作区」打开「选择工作区目录」。
2. 在「主目录」里新建文件夹，或选中已有目录。
3. 点击「打开」。

实测在「主目录」新建了 `workspace` 再打开。这个文件夹在容器里面，不在宿主机上。宿主机上的仓库要按「挂载工作区」挂到 **`/workspace`**，再在选择器里打开这个路径。主目录下同名的 `workspace` 和挂载点 **`/workspace`** 不是同一个目录。

![DeepSeek Harness 选择工作区目录：在主目录新建文件夹 workspace](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx-3.webp)

### 4.4 主界面

选好工作区后，主标题为「探索未至之境」，旁边有「预览版」。左侧列出工作区名称。输入框旁可以换模式，右下角可以换模型。本次右下角是 **DeepSeek-V4.1-Flash High**。

| 模式 | 什么时候用 |
|------|------------|
| 标准模式 | 改代码、处理文件，大多数任务用这个 |
| PTC 模式 | 要反复调用工具，再把结果筛选、整理 |
| 极简模式 | 只用终端 |
| 创意模式 | 写插件、做界面 |

点过「稍后配置」的，发消息前先把 API Key 补上。

![DeepSeek Harness 主界面：探索未至之境预览版，工作区 workspace，可切换模式与 DeepSeek-V4.1-Flash High](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx-4.webp)

### 4.5 插件

1. 点击左侧「插件」。

实测「官方」下有 **8** 项，开关默认关闭：智能体团队、自动授权审查、自动化任务、语音输入、终端、Agent 循环、子智能体、网页搜索。

![DeepSeek Harness 插件页：官方 8 个插件，开关默认关闭](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx-5.webp)

2. 需要别的插件时，点击「添加插件」。

可以填写包名、GitHub 仓库地址或本地目录。

安装源可以选「默认安装源」`registry.npmjs.org`，或「中国大陆镜像源」`registry.npmmirror.com`，也可以填自定义地址。

自定义地址以 `http://` 或 `https://` 开头。

私有源的凭据按界面要求放在 `~/.npmrc`。容器里这是 **`/root/.npmrc`**，不在数据卷 `/root/.dsh` 中。重建容器后要重新写这份文件。

精简版 **`0.2.0-rc.2`** 不带 pnpm 和 uv。需要 `dsh plugin`，或要用 `uvx` 启动 MCP 时，换成 `devtools-min-0.2.0-rc.2`。

![DeepSeek Harness 添加插件：可选 npm 官方源、npmmirror 或自定义地址](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx-6.webp)

### 4.6 输入框指令

在输入框键入 `/`。菜单分成两组：

| 分组 | 指令 | 作用 |
|------|------|------|
| 添加 | `file` | 带上文件 |
| 添加 | `goal` | 设置或查看长期目标 |
| 添加 | `plan` | 进入或退出计划模式 |
| 添加 | `feedback` | 对当前会话发反馈 |
| 指令 | `compact` | 压缩上面的对话 |
| 指令 | `permission` | 切换权限模式 |
| 指令 | `model` | 换这个会话的模型 |

输入框里的占位文案是「描述你想要构建的内容 / 调用指令，@ 文件或对话」。

![DeepSeek Harness 输入框斜杠菜单：file、goal、plan、feedback、compact、permission、model](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-smanx-7.webp)

WebSocket 路径 `/api/events.mux`、`/api/events.host` 由代理转发，不用另开端口。

---

## 五、可选配置

### 5.1 启用 Basic Auth

同网段任何人都能访问 **3080** 时，再打开认证。

用户名和密码都要设置。只填其中一个时，代理不认证。

认证同时覆盖网页和 WebSocket。未通过时返回 **401**，浏览器会弹出登录框。

`/manifest.webmanifest`、`/favicon.svg`、`/favicon.ico` 不参与认证。这三项只含应用名和图标。

浏览器抓站点图标时不会带上 Basic Auth。如果这三项也要求认证，控制台会一直报 401。

在 `compose.yaml` 里，把下面两行改成你自己的值。

去掉行首的 `#`。

```yaml
PROXY_USERNAME: yourname
PROXY_PASSWORD: yourpass
```

改的是 Compose 文件里的环境变量。`docker restart` 不会读入新的环境变量。

用下面的命令重建容器。

```bash
docker compose up -d
```

### 5.2 挂载工作区

Agent 要改的代码放在宿主机目录里。容器里的进程是 root，这个目录按 root 读写。

只挂需要改的项目。不要挂宿主机根目录、`~/.ssh`、云凭证或 Docker socket。

先建目录：

```bash
sudo mkdir -p /www/wwwroot/deepseek-harness-smanx/workspace
```

在 `compose.yaml` 的 `volumes` 里，删掉 `./workspace:/workspace` 前面的 `#`。

保存之后再重建：

```bash
docker compose up -d
```

回到网页之前，先分清两个目录。选择器里要打开 **`/workspace`**。不要选「主目录」下面那个也叫 `workspace` 的文件夹，那是容器里新建的，和这条挂载不是同一个目录。

### 5.3 修改代理端口

`PROXY_PORT` 和左边的宿主机端口必须一起改。下面不是完整的 Compose 文件，只替换已有文件里的这两处。

示例把对外端口改成 **3088**。宿主机不要用 **3000**，这个端口常被本机前端占用。

`DSH_PORT` 保持 **3079**，不要和 `PROXY_PORT` 相同。同一端口不能被两个进程同时监听。

```yaml
ports:
  - "3088:3088"
environment:
  PROXY_PORT: "3088"
```

保存文件之后，执行 `docker compose up -d`。

浏览器改为 `http://服务器IP:3088/`。

### 5.4 管理版（要在网页里切换 DSH 版本时）

平时继续用 **`0.2.0-rc.2`**。只有要在网页里安装或切换 `@deepseek-ai/dsh` 版本时，才改用 **`admin-0.2.0-rc.2`**。

管理版多一个安装目录 **`/opt/dsh`**。这个目录也要做成命名卷。否则重建容器后，页面上装过的版本和 npm 源配置会丢。

访问 **`/__admin/`** 进入管理台。**`/`** 仍是 DSH 界面。

页面上可以查看版本、安装或切换版本、填写 npm 源，并重启 DSH。

npm 源的优先级是：页面配置 > 环境变量 `NPM_CONFIG_REGISTRY` > `https://registry.npmjs.org/`。

先停掉已经占用 **3080** 和容器名 `dsh-harness` 的实例：

```bash
docker compose down
```

接着用下面的内容覆盖当前目录的 `compose.yaml`。原来的精简版配置会被换掉。

```bash
cat > compose.yaml <<'EOF'
services:
  deepseek-harness:
    image: docker.xuanyuan.run/smanx/deepseek-harness:admin-0.2.0-rc.2
    container_name: dsh-harness
    ports:
      - "3080:3080"
    environment:
      TZ: Asia/Shanghai
    volumes:
      - dsh-data:/root/.dsh
      - dsh-install:/opt/dsh
    restart: unless-stopped

volumes:
  dsh-data:
  dsh-install:
EOF
```

```bash
docker compose up -d
```

管理版镜像里保留了 python3 和编译工具，因为在 Linux 上为其他 DSH 版本编译 `node-pty` 需要它们，体积会比精简版大。

---

## 六、备选：docker run

没有 Compose 时用下面的命令。

它会新建名为 `dsh-data` 的卷。Compose 那条卷名是 `deepseek-harness-smanx_dsh-data`。两者不是同一个卷，会话不会自动过去。

如果 Compose 已经在跑，先停掉它。不要同时占用 **3080** 和容器名 `dsh-harness`。

```bash
docker volume create dsh-data

docker run -d 
  --name dsh-harness 
  --restart unless-stopped 
  -p 3080:3080 
  -e TZ=Asia/Shanghai 
  -v dsh-data:/root/.dsh 
  docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2
```

```bash
docker logs dsh-harness
```

确认日志里有 `代理已启动` 后，浏览器打开 `http://服务器IP:3080/`。

要启用 Basic Auth，或要挂工作区，把对应参数加在镜像名之前。

目录要事先建好。

下面几行只是参数片段。不要单独当成一条命令执行。

```bash
  -e PROXY_USERNAME=yourname 
  -e PROXY_PASSWORD=yourpass 
  -v /www/wwwroot/deepseek-harness-smanx/workspace:/workspace 
```

停止、再启动和删除容器：

```bash
docker stop dsh-harness
docker start dsh-harness
docker rm -f dsh-harness
```

`docker rm` 不会删除命名卷。要清空会话和配置，先停容器，再执行 `docker volume rm dsh-data`。

---

## 七、常见问题 FAQ

**Q1：打开首页还要自己拼 `?token=` 吗？**

不用。日志里的 `http://127.0.0.1:3079/?token=...` 是容器内部地址。浏览器打开宿主机的 **3080**，代理会自己换成会话。

**Q2：和 [Docker 部署 DeepSeek Harness（runzhliu）](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy) 有什么区别？**

两篇都是社区做的 DeepSeek Harness 镜像，装的都是上游 `@deepseek-ai/dsh`，模型调用用你自己的 API Key。打开方式和附带组件不同，数据卷不能混用。

| 项目 | 本文 `smanx/deepseek-harness:0.2.0-rc.2` | 已发布文 `runzhliu/deepseek-harness:0.1.5-rc.2-r1` |
|------|------------------------------------------|-----------------------------------------------------|
| 怎么打开 | 浏览器访问 `http://IP:3080/`，代理自动换 cookie | 必须带日志里的 `?token=` |
| 局域网选目录、进设置 | 代理补上 `randomUUID`，局域网里也能进设置、选目录 | 局域网 IP 下选工作区会 403，需 `localhost` + SSH 隧道 |
| 内嵌浏览器 | 无 | **6080** 上的 noVNC / Chromium，且无登录 |
| 数据目录 | `/root/.dsh`（root） | `/home/node/.dsh`（UID **1000**） |
| 额外认证 | 可选 HTTP Basic Auth | 启动 token |
| 插件 / MCP | 精简版无 pnpm、uv；需要时换 `devtools-min-0.2.0-rc.2` | 默认不含插件市场，另有 market 标签 |
| 适合 | 只要网页，并且要在局域网里直接打开 | 还要容器里的浏览器，能接受 token 和隧道 |

同名还有别的维护者的镜像，数据目录不一样。换镜像前先备份卷。不要把 `/root/.dsh` 和另一套镜像的家目录互挂。

**Q3：为什么命令里不写 `latest`？**

`latest` 下次构建会指向新版本，网页步骤可能对不上。Docker Hub 上它和 **`0.2.0-rc.2`** 这次是同一镜像（2026-10-06）。`docker pull`、Compose 和 `docker run` 都写 **`0.2.0-rc.2`**。

**Q4：设置了 `PROXY_USERNAME` 却没有登录框？**

用户名和密码要一起设置。只写了其中一个时，代理完全放行。

改的是 `compose.yaml` 时，用 `docker compose up -d` 重建容器。`docker restart` 不会读入新的环境变量。

**Q5：页面能开，对话却一直转圈？**

先确认地址是宿主机 **3080**。

**3079** 没有映射出来。浏览器不要直接访问它。

代理只在转发页面时补上 `crypto.randomUUID`。绕过代理之后，局域网页面发不出消息，WebSocket 会停住。

前面如果还有一层反向代理，需要放行 WebSocket 升级。

**Q6：提示「无法创建默认工作区」？**

首次进入还没有默认目录，所以顶部会叫你去选文件夹。

在「主目录」新建一个文件夹，再点击「打开」。这个文件夹在容器里。

宿主机上的项目要按「挂载工作区」挂到 **`/workspace`**。不要和主目录里同名的文件夹搞混。

**Q7：会话存在哪里？升级会丢吗？**

会话、配置和网页里保存的凭证在卷里，容器内路径是 `/root/.dsh`。本次 Compose 的卷名是 **`deepseek-harness-smanx_dsh-data`**。

`docker compose down` 会留下这个卷。`docker compose down --volumes` 会删掉它。

备选的 `docker run` 如果执行过 `docker volume create dsh-data`，卷名是 `dsh-data`。这个卷和 Compose 那条不是同一个卷。

不同 DSH 版本的会话格式可能读不了旧数据。升级之前，先用 `docker volume` 备份，或先导出你需要留下的内容。

然后再只改镜像标签，并执行：

```bash
docker compose pull
docker compose up -d
```

**Q8：可以把 3080 暴露到公网吗？**

不要把 **3080** 暴露到公网。

这个端口上的 Agent 能执行工具，而且默认没有 TLS。

Basic Auth 只拦住没有口令的访问。这份口令代替不了 HTTPS，也代替不了限制来源地址。

要从公网进入，另外加反向代理和证书，并限制谁可以连。

---

## 八、命令速查

```bash
docker pull docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2

cd /www/wwwroot/deepseek-harness-smanx
docker compose up -d
docker compose ps
docker compose logs --no-color deepseek-harness
docker compose down
```

无 Compose 时：

```bash
docker volume create dsh-data
docker run -d 
  --name dsh-harness 
  --restart unless-stopped 
  -p 3080:3080 
  -e TZ=Asia/Shanghai 
  -v dsh-data:/root/.dsh 
  docker.xuanyuan.run/smanx/deepseek-harness:0.2.0-rc.2
docker logs dsh-harness
```

---

## 九、延伸阅读

| 资源 | 链接 |
|------|------|
| [smanx/deepseek-harness 镜像页](https://xuanyuan.cloud/r/smanx/deepseek-harness) | [https://xuanyuan.cloud/r/smanx/deepseek-harness](https://xuanyuan.cloud/r/smanx/deepseek-harness) |
| [镜像标签列表](https://xuanyuan.cloud/r/smanx/deepseek-harness/tags) | [https://xuanyuan.cloud/r/smanx/deepseek-harness/tags](https://xuanyuan.cloud/r/smanx/deepseek-harness/tags) |
| [GHCR 镜像页](https://xuanyuan.cloud/ghcr.io/smanx/deepseek-harness) | [https://xuanyuan.cloud/ghcr.io/smanx/deepseek-harness](https://xuanyuan.cloud/ghcr.io/smanx/deepseek-harness) |
| [deepseek-harness-docker](https://github.com/smanx/deepseek-harness-docker) | [https://github.com/smanx/deepseek-harness-docker](https://github.com/smanx/deepseek-harness-docker) |
| [DeepSeek Harness 上游](https://github.com/deepseek-ai/deepseek-harness) | [https://github.com/deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) |
| [Docker Hub · smanx/deepseek-harness](https://hub.docker.com/r/smanx/deepseek-harness) | [https://hub.docker.com/r/smanx/deepseek-harness](https://hub.docker.com/r/smanx/deepseek-harness) |
| [runzhliu 镜像的部署文](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy) | [https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：<https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy>



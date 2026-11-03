# Docker 部署 DeepSeek Harness（moelin）：轻松搭建带登录的本地 AI Agent 平台

![Docker 部署 DeepSeek Harness（moelin）：轻松搭建带登录的本地 AI Agent 平台](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin.webp)

*分类: Docker部署教程 | 标签: DeepSeek Harness,moelin/deepseek-harness,Docker,轩辕镜像,AI Agent,Web UI,Caddy,私有化部署,部署教程 | 发布时间: 2026-11-02 21:29:32*

> DeepSeek Harness 是面向 AI Agent 的运行时与 Web UI，管会话、工具和权限，模型调用用你自己的 API Key。本文将介绍如何通过 Docker Compose 部署社区镜像 moelin/deepseek-harness，在入口加上用户名密码登录，搭建可自托管的本地 Agent 环境，适合内网试用、把仓库目录交给 Agent，以及需要先拦住未授权访问的场景。

## DeepSeek Harness 是什么

DeepSeek Harness 是 DeepSeek 开源的 AI Agent 运行时。它管会话、工具、权限和网页界面，模型调用走你自己的 API Key，本身不带模型权重，也不是推理服务器。

社区镜像 **`moelin/deepseek-harness`** 把这套程序装进容器，并在前面加一层定制 Caddy。浏览器先填写用户名和密码，通过后再进入 Web UI；容器里的 DeepSeek Harness 只在内部监听，不直接对外。和本机直接跑 CLI、或把页面裸挂在局域网相比，登录层和持久化目录都已经打包好。

## DeepSeek Harness 能做什么

- **在浏览器里开会话**：登录后进入 Web UI，配置 API Key 或账号，开始对话和工具调用。
- **对着本地目录改文件**：把宿主机项目挂到 `/workspace`，在界面里选好工作区后再改。
- **在入口拦住未登录访问**：使用用户名密码表单，并对登录提交做限速。
- **把状态留在本机**：认证、Caddy 状态和会话写在 `/data`，项目文件写在 `/workspace`。
- **在工作区里开终端**：容器内以用户 `node` 进入所选目录，查看文件或执行命令。

## 为什么要使用 DeepSeek Harness

本机用 CLI 能临时跑起来，重启后会话和配置容易散落。同事要在浏览器里试用时，又要把能执行工具的服务放进内网，还要挡住随手打开的人。

容器里跑固定版本，状态进持久化目录，入口先登录，就可以在自己机器上长期使用。适合内网试用、把仓库目录交给 Agent，以及需要先认证再进网页的人。

## 使用 Docker 部署 DeepSeek Harness

Docker 可以把这套带登录的 Agent 环境跑起来。部署前准备好 Docker，并准备好网页登录密码和模型 API Key。密码不要写进公开仓库，API Key 也不要写进镜像。

接下来用 Docker Compose 写好目录、环境变量和端口，启动服务，再用浏览器完成登录与首次配置。

## 环境要求

本文使用 **`moelin/deepseek-harness:0.2.1-rc.3`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。启动后日志显示 DeepSeek Harness **0.2.1-rc.3** 听在容器内 **127.0.0.1:3080**。镜像同时提供 **linux/amd64** 与 **linux/arm64**。Docker Hub 上运行时压缩体积约 **369 MB**（amd64）/ **364 MB**（arm64）；工作站标签更大。解压后占用更大，拉取前确认磁盘有富余。

容器内 Caddy 听 **8080**。DeepSeek Harness 听容器内 **3080**，不映射到宿主机。未挂载 **`/data`** 时，入口脚本会打印迁移提示并退出。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/deepseek-harness-moelin` 换成 `~/docker/deepseek-harness-moelin` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 磁盘 | 至少能放下上述压缩体积，并留出 `/data`、`/workspace` 增长空间 |
| 端口 | 宿主机 **56789** → 容器 **8080**。不要占用宿主机 **3000** |
| 工作目录 | `/www/wwwroot/deepseek-harness-moelin` |
| 账号 | 默认用户名 **`admin`**；密码由你设置，至少 **12** 位。没有预置密码 |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=deepseek-harness-moelin-docker-deploy)。

## 标签怎么选

新安装使用 **`0.2.1-rc.3`**。标签对应构建时打包的 DeepSeek Harness 版本。`latest` 是运行时浮动别名，下次发版会改指向；`workstation` 是工作站浮动别名。这两枚浮动标签都不写入本文命令。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`0.2.1-rc.3`** | 轻量运行时：DeepSeek Harness、Caddy 登录层，以及 git、curl、pnpm 等基础工具 | **是** |
| `0.2.1-rc.3-workstation` | 工作站：再带 Python、Go、编译器和更多开发工具；HOME 用命名卷持久化 | 需要容器内装工具链时再换 |
| `latest` | 运行时浮动别名 | 否 |
| `workstation` | 工作站浮动别名 | 否 |

完整列表见 [标签列表](https://xuanyuan.cloud/r/moelin/deepseek-harness/tags?xy_from=deepseek-harness-moelin-docker-deploy)。构建说明见 [deepseek-harness-builder](https://github.com/okxlin/release-factory/tree/main/deepseek-harness-builder)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=deepseek-harness-moelin-docker-deploy) **加速拉取**。

```bash
docker pull docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3
```

Ubuntu 24.04 上拉取完成：

```text
0.2.1-rc.3: Pulling from moelin/deepseek-harness
124076035e7e: Pull complete
df311c1538a9: Pull complete
32269e9635cd: Pull complete
80563b3ccff7: Pull complete
46cfaf854e78: Pull complete
73b0ecb0a845: Pull complete
b02239788925: Pull complete
6181230357b0: Pull complete
9ebf705fe48b: Pull complete
7571e71add88: Pull complete
66b7dfa1fd0d: Pull complete
614c23a051f5: Pull complete
e60eaa6471a3: Pull complete
22c71eb2028f: Pull complete
89e22ca8ccd4: Pull complete
04948d90710d: Pull complete
Digest: sha256:51d3b84e2384e16b882a89e2be8f6098bebd3e1f23c54d014fc1bd1313a076ef
Status: Downloaded newer image for docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3
docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=deepseek-harness-moelin-docker-deploy)。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/deepseek-harness-moelin`**。macOS 用 **`~/docker/deepseek-harness-moelin`**。

本文按内网 HTTP 试用写主路径：宿主机发布 **56789**，`PUBLIC_URL` 写成浏览器实际打开的地址，并设置 `AUTH_COOKIE_INSECURE=true`。正式环境改成 HTTPS 反代，并把端口绑在本机，见「可选：HTTPS 反代」。

### 1. 创建目录

```bash
sudo mkdir -p /www/wwwroot/deepseek-harness-moelin/data 
  /www/wwwroot/deepseek-harness-moelin/workspace
sudo chmod 0750 /www/wwwroot/deepseek-harness-moelin/data 
  /www/wwwroot/deepseek-harness-moelin/workspace
sudo chown -R "$USER":"$USER" /www/wwwroot/deepseek-harness-moelin
cd /www/wwwroot/deepseek-harness-moelin
```

macOS：

```bash
mkdir -p ~/docker/deepseek-harness-moelin/data 
  ~/docker/deepseek-harness-moelin/workspace
chmod 0750 ~/docker/deepseek-harness-moelin/data 
  ~/docker/deepseek-harness-moelin/workspace
cd ~/docker/deepseek-harness-moelin
```

入口脚本会在 `/data` 下整理认证、Caddy 和 DeepSeek Harness 状态，并按容器用户 **node**（uid/gid **1000:1000**）准备目录。

### 2. 写入 compose.yaml

把下面的 `PUBLIC_URL` 里的 IP 换成你的服务器局域网地址。密码换成你自己的，至少 12 位，不要提交到公开仓库。

```bash
cat > compose.yaml <<'EOF'
services:
  deepseek-harness:
    image: docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3
    container_name: deepseek-harness
    restart: unless-stopped
    ports:
      - "56789:8080"
    environment:
      PUBLIC_URL: http://192.168.1.35:56789
      AUTH_MODE: caddy-security
      AUTH_USERNAME: admin
      AUTH_PASSWORD: ChangeMe-DSH-2026!
      AUTH_COOKIE_INSECURE: "true"
      CADDY_TRUSTED_PROXIES: none
      DSH_TELEMETRY_DISABLED: "1"
      TZ: Asia/Shanghai
    volumes:
      - ./data:/data
      - ./workspace:/workspace
    healthcheck:
      test: ["CMD", "/usr/local/bin/healthcheck.sh"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 具体版本标签 `0.2.1-rc.3` |
| `56789:8080` | 宿主机 **56789** → 容器 Caddy **8080** |
| `PUBLIC_URL` | 浏览器看到的完整源站，例如 `http://IP:56789`。不能带路径前缀 |
| `AUTH_USERNAME` / `AUTH_PASSWORD` | 网页登录账号。密码至少 12 位 |
| `AUTH_COOKIE_INSECURE` | HTTP 试用写成 `true`。HTTPS 正式部署改回 `false` |
| `CADDY_TRUSTED_PROXIES` | 浏览器直连 Caddy 时写成 `none`；前面还有私网反代时用 `private_ranges` |
| `./data:/data` | 认证用户、JWT、Caddy 状态、应用状态。**必挂** |
| `./workspace:/workspace` | 项目目录。界面「选择工作区」里的「主目录」对应这里 |

### 3. 启动并确认状态

```bash
docker compose up -d
docker compose ps
```

这次启动完成：

```text
[+] up 2/2
 ✔ Network deepseek-harness-moelin_default Created
 ✔ Container deepseek-harness              Started

NAME               IMAGE                                                    COMMAND                  SERVICE            CREATED         STATUS                            PORTS
deepseek-harness   docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3   "/usr/bin/tini -- /u…"   deepseek-harness   8 seconds ago   Up 6 seconds (health: starting)   0.0.0.0:56789->8080/tcp, [::]:56789->8080/tcp
```

刚启动时健康检查可能仍是 `starting`。再看日志：

```bash
docker compose logs --no-color --tail=80 deepseek-harness
```

这次日志是：

```text
deepseek-harness  | [entrypoint] trusted proxy parsing disabled; authentication limits use the direct peer address
deepseek-harness  | [entrypoint] generated a persistent authentication signing key
deepseek-harness  | [entrypoint] starting DeepSeek Harness 0.2.1-rc.3 on 127.0.0.1:3080
```

`CADDY_TRUSTED_PROXIES=none` 时，日志会写 trusted proxy parsing disabled。首次启动会生成认证签名密钥，保存在 `/data`。健康探针路径是 `/healthz`，未登录也会返回 `ok`。

浏览器地址把 IP 换成你的：

```text
http://192.168.1.35:56789/
```

## 浏览器里开始用

### 1. 登录

1. 打开上面的地址。
2. 在 Sign In 页填写用户名，点击 Proceed。本文用户名是 **admin**。
3. 在 Authentication 页填写密码，点击 Authenticate。

![DeepSeek Harness Caddy 登录：Sign In 填写用户名 admin，按钮为 Proceed](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-1.webp)

![DeepSeek Harness Caddy 登录：Authentication 填写密码，按钮为 Authenticate](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-2.webp)

登录提交有次数限制。连续输错时可能返回 **429**，稍后再试，见「常见问题」。

### 2. 预览说明

1. 登录后阅读「预览版说明」。
2. 点击「继续」。

顶部若出现「无法创建默认工作区，请通过 '选择工作区' 选择文件夹」，接着选目录。这是还没选工作区，不是容器启动失败。

![DeepSeek Harness 首次进入：预览版说明弹窗，按钮为继续，顶部提示无法创建默认工作区](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-3.webp)

### 3. 添加 API Key 或登录账号

1. 在「开始使用」弹窗中，点击「添加 API Key」，或点击「登录」使用 DeepSeek 账号。
2. 密钥只放在网页或你自己的密钥管理里，不要写进镜像，也不要提交到仓库。
3. 想稍后再填，先关掉弹窗；发消息前再补上密钥或完成登录。

![DeepSeek Harness 开始使用：可添加 API Key，或登录 DeepSeek 账号](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-4.webp)

### 4. 选择工作区

1. 点击「选择工作区」，打开「选择工作区目录」。
2. 在「主目录」里新建文件夹，或选中已有目录。这次新建了 `demo`，再点「创建」。
3. 选中刚建好的目录，打开它。

这个镜像里，「主目录」对应容器内的 `/workspace`，也就是 Compose 挂载的宿主机 `workspace/`。宿主机上的仓库先放进这个目录，再在选择器里打开。

![DeepSeek Harness 选择工作区：在主目录新建文件夹 demo](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-5.webp)

### 5. 主界面

选好工作区后，中间是「探索未至之境」，旁边有「预览版」。左侧工作区下列出 `demo`。输入框上方可以切换工作区和模式，这次是 **标准模式**；右下角先选模型再发消息。

输入框占位文案是「描述你想要构建的内容，/ 调用指令，@ 文件或对话」。

![DeepSeek Harness 主界面：探索未至之境预览版，工作区 demo，标准模式](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-6.webp)

### 6. 插件与自动化任务

1. 点击左侧「插件」。

「内置插件配置」里有子智能体、网页搜索、Agent 循环、终端等项。「实验性插件」可用开关启用，例如智能体团队、语音输入、自动授权审查、开发者工具。

![DeepSeek Harness 插件页：内置插件配置与实验性插件开关](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-7.webp)

2. 点击左侧「自动化任务」。

还没有任务时，页面提示在会话中创建的任务会显示在这里，也可以点「新建自动化任务」。

![DeepSeek Harness 自动化任务页：空列表，可新建自动化任务](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-8.webp)

### 7. 工作区内终端

打开内嵌终端后，可以在当前工作区里执行命令。实测提示符是 `node@…:/workspace/demo$`，说明选中的 `demo` 落在挂载目录 `/workspace` 下。

![DeepSeek Harness 内嵌终端：bash，路径为 /workspace/demo](https://imgs.xuanyuan.cloud/docker/blog/deepseek-harness-moelin/deepseek-harness-moelin-9.webp)

## 可选：HTTPS 反代

正式部署时，把容器端口绑在本机，再由 1Panel / OpenResty / Nginx 做 HTTPS。在现有 `compose.yaml` 里改这几处：

```yaml
    ports:
      - "127.0.0.1:56789:8080"
    environment:
      PUBLIC_URL: https://dsh.example.com
      AUTH_COOKIE_INSECURE: "false"
      CADDY_TRUSTED_PROXIES: private_ranges
```

`PUBLIC_URL` 必须等于浏览器地址栏里的源站。反代需要转发 `Host`、`X-Forwarded-Proto`、`X-Forwarded-For`，并允许 WebSocket 升级。不要把容器 **8080** 直接映射成公网 **0.0.0.0**。

反代示例：

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

location / {
    proxy_pass http://127.0.0.1:56789;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
}
```

## 可选：工作站变体

需要在容器里装 Python、Go、编译器或更多开发工具时，把 `image` 改成：

```text
docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3-workstation
```

并在 `volumes` 里增加 HOME 命名卷：

```yaml
    volumes:
      - ./data:/data
      - dsh-home:/home/node
      - ./workspace:/workspace

volumes:
  dsh-home:
```

`/data` 仍是应用状态。`/home/node` 放用户自己安装的工具。`/workspace` 仍是项目目录。日常试用继续用 `0.2.1-rc.3` 即可。

## 备选：docker run

没有 Compose 时，可以用下面的命令临时试玩。把 IP 和密码换成你的。

```bash
sudo mkdir -p /www/wwwroot/deepseek-harness-moelin/data 
  /www/wwwroot/deepseek-harness-moelin/workspace
sudo chmod 0750 /www/wwwroot/deepseek-harness-moelin/data 
  /www/wwwroot/deepseek-harness-moelin/workspace

docker run -d 
  --name deepseek-harness 
  --restart unless-stopped 
  -p 56789:8080 
  -e PUBLIC_URL=http://192.168.1.35:56789 
  -e AUTH_MODE=caddy-security 
  -e AUTH_USERNAME=admin 
  -e AUTH_PASSWORD='ChangeMe-DSH-2026!' 
  -e AUTH_COOKIE_INSECURE=true 
  -e CADDY_TRUSTED_PROXIES=none 
  -e DSH_TELEMETRY_DISABLED=1 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/deepseek-harness-moelin/data:/data 
  -v /www/wwwroot/deepseek-harness-moelin/workspace:/workspace 
  docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3
```

查看状态：

```bash
docker ps --filter name=deepseek-harness
docker logs --tail 80 deepseek-harness
```

停止并删除容器时，宿主机 `data/` 与 `workspace/` 仍会保留。

## 备份与升级

备份前先停容器，再打包 `data/`：

```bash
cd /www/wwwroot/deepseek-harness-moelin
docker compose stop
tar -C data -czf deepseek-harness-data.tar.gz .
docker compose start
```

升级时只改 `compose.yaml` 里的标签，保留 `./data` 与 `./workspace`。旧部署如果只挂了 `/home/node/.local/share/deepseek-harness`，不能替代现在的 `/data`。首次迁移时按镜像说明同时挂上旧路径和新的 `/data`，确认数据进新目录后再拿掉旧挂载。

工作站的 `dsh-home` 命名卷要单独备份。`docker compose down` 默认不删命名卷；加 `--volumes` 才会删。

## 常见问题

### 容器立刻退出

多半是没有挂载 `/data`。日志里会出现双语迁移提示。按「Docker Compose 部署」挂上 `./data:/data` 后重新启动。

### 打开页面后登录状态马上丢

HTTP 直连时，必须把 `AUTH_COOKIE_INSECURE` 设为 `true`，并且 `PUBLIC_URL` 与地址栏完全一致，包括协议、主机和端口。HTTPS 正式部署改回 `false`。

### 提示凭证无效或无法启动

`AUTH_PASSWORD`、`AUTH_PASSWORD_FILE`、`AUTH_PASSWORD_HASH` 只能设其中一个。明文密码至少 12 位。三个都不设，或同时设多个，入口都会失败。

### 登录返回 429

镜像对用户名提交和密码提交分别做了限速。短时间内多次输错会返回 **429**，并带 `Retry-After`。等提示的时间过后再试，不要连续猛点。

### 局域网能打开，对话却异常

先确认浏览器地址与 `PUBLIC_URL` 一致。直连 Caddy 时把 `CADDY_TRUSTED_PROXIES` 设为 `none`。前面还有反代时，改用 `private_ranges`，并转发 WebSocket 相关头。

### 和 smanx、runzhliu 镜像有什么区别

三者都是社区打包的 DeepSeek Harness，不是官方推理镜像。`moelin/deepseek-harness` 用定制 Caddy 做用户名密码登录，应用状态固定到 `/data`。`smanx/deepseek-harness` 侧重局域网代理与可选 Basic Auth。`runzhliu/deepseek-harness` 常用日志里的 token 链接进入。选哪套按登录方式和运维习惯决定；本文只写 moelin。

### 可以用 latest 吗

`latest` 是运行时浮动别名，下次发版会改指向。本文命令使用 **`0.2.1-rc.3`**。说明见「标签怎么选」。

### 为什么不用宿主机 3000

本机前端开发经常占用 3000。这个容器对外听的是 **8080**，本文映射到 **56789**。不要改成宿主机 3000。

### 选择工作区时找不到宿主机项目

确认 Compose 已挂 `./workspace:/workspace`，并且文件在宿主机工作目录的 `workspace/` 下。界面里的「主目录」对应 `/workspace`，在这里新建或选中目录即可。不要到未挂载的其它路径里找项目。

## 命令速查

```bash
docker pull docker.xuanyuan.run/moelin/deepseek-harness:0.2.1-rc.3

cd /www/wwwroot/deepseek-harness-moelin
docker compose up -d
docker compose ps
docker compose logs --no-color --tail=80 deepseek-harness

# 浏览器打开 http://服务器IP:56789/ ，用 admin 与你设置的密码登录

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。默认用户名是 **admin**，密码由你设置。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [moelin/deepseek-harness 镜像页](https://xuanyuan.cloud/zh/r/moelin/deepseek-harness?xy_from=deepseek-harness-moelin-docker-deploy) | [https://xuanyuan.cloud/zh/r/moelin/deepseek-harness](https://xuanyuan.cloud/zh/r/moelin/deepseek-harness?xy_from=deepseek-harness-moelin-docker-deploy) |
| [moelin/deepseek-harness 概览](https://xuanyuan.cloud/r/moelin/deepseek-harness?xy_from=deepseek-harness-moelin-docker-deploy) | [https://xuanyuan.cloud/r/moelin/deepseek-harness](https://xuanyuan.cloud/r/moelin/deepseek-harness?xy_from=deepseek-harness-moelin-docker-deploy) |
| [moelin/deepseek-harness 标签列表](https://xuanyuan.cloud/r/moelin/deepseek-harness/tags?xy_from=deepseek-harness-moelin-docker-deploy) | [https://xuanyuan.cloud/r/moelin/deepseek-harness/tags](https://xuanyuan.cloud/r/moelin/deepseek-harness/tags?xy_from=deepseek-harness-moelin-docker-deploy) |
| [Docker Hub · moelin/deepseek-harness](https://hub.docker.com/r/moelin/deepseek-harness) | [https://hub.docker.com/r/moelin/deepseek-harness](https://hub.docker.com/r/moelin/deepseek-harness) |
| [GitHub · deepseek-harness-builder](https://github.com/okxlin/release-factory/tree/main/deepseek-harness-builder) | [https://github.com/okxlin/release-factory/tree/main/deepseek-harness-builder](https://github.com/okxlin/release-factory/tree/main/deepseek-harness-builder) |
| [GitHub · deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) | [https://github.com/deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) |
| [npm · @deepseek-ai/dsh](https://www.npmjs.com/package/@deepseek-ai/dsh) | [https://www.npmjs.com/package/@deepseek-ai/dsh](https://www.npmjs.com/package/@deepseek-ai/dsh) |
| [runzhliu 变体部署文](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy?xy_from=deepseek-harness-moelin-docker-deploy) | [https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy?xy_from=deepseek-harness-moelin-docker-deploy) |
| [smanx 变体部署文](https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy?xy_from=deepseek-harness-moelin-docker-deploy) | [https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy](https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy?xy_from=deepseek-harness-moelin-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=deepseek-harness-moelin-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=deepseek-harness-moelin-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/deepseek-harness-moelin-docker-deploy?xy_from=deepseek-harness-moelin-docker-deploy)

*本文基于 [moelin/deepseek-harness:0.2.1-rc.3](https://xuanyuan.cloud/zh/r/moelin/deepseek-harness?xy_from=deepseek-harness-moelin-docker-deploy)，以 **0.2.1-rc.3** 版本实测，测试平台 **Ubuntu 24.04** Linux。*



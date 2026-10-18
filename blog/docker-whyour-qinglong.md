# Docker 部署青龙面板：轻松搭建定时任务管理平台

![Docker 部署青龙面板：轻松搭建定时任务管理平台](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong.webp)

*分类: Docker部署教程 | 标签: 青龙,Qinglong,whyour/qinglong,Docker,轩辕镜像,定时任务,私有化部署,部署教程 | 发布时间: 2026-10-14 17:40:45*

> 青龙是一款面向要在自己服务器上跑脚本的人的开源定时任务管理平台，旨在把脚本、环境变量和调度放在同一套面板里，并通过浏览器完成编写、定时和查看日志。本文将介绍如何通过 Docker Compose 部署青龙，搭建私有化定时任务平台，帮助把周期性脚本留在自己的机器上，适合个人脚本定时及内网任务调度等场景。

*本文基于 [whyour/qinglong:2.23.0](https://xuanyuan.cloud/zh/r/whyour/qinglong)，以 **2.23.0** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## 青龙是什么

青龙（Qinglong）是 whyour 维护的开源定时任务管理平台。它在浏览器里管理 Python 3、JavaScript、Shell 和 TypeScript 脚本，用来把定时任务留在自己的服务器上跑。

和在每台机器上改 crontab 不同，青龙把脚本、环境变量、定时规则和运行日志放在同一套网页里。脚本仍在这台服务器上执行，网页负责编写、调度和查看结果。

## 青龙能做什么

- **多语言脚本**：编写并运行 Python 3、JavaScript、Shell 和 TypeScript。
- **秒级定时**：用 cron 或秒级规则设定下一次执行时间。
- **运行日志**：查看某一次任务的输出，对照是哪一次运行。
- **变量与配置**：在线修改环境变量和配置文件。
- **依赖与通知**：为脚本安装依赖，并把结果发到已配置的通知渠道。

## 为什么要使用青龙

脚本、变量和日志分开放在各台机器上时，改一条时间就要登录服务器，换一台机器还要重新找文件。

青龙把这些改动收进一个网页。适合要长期跑自己脚本的人，也适合把调度留在内网的团队。

## 使用 Docker 部署青龙

青龙可以用 Docker 跑起来，宿主机不必先装 Node.js 和 Python。开始之前准备好 Docker。第一次用浏览器打开时，要创建管理员账号。

下面用 Docker Compose 启动服务，并在浏览器里完成初始化。

## 环境要求

本文命令使用 **`whyour/qinglong:2.23.0`**。这个标签是 Alpine 镜像。需要 Debian，或以非 root 用户运行时，见「标签怎么选」。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）；macOS 把 `/www/wwwroot/qinglong` 换成 `~/docker/qinglong`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| CPU / 内存 | 官方 Docker 说明没有最低配置。不用再单独起数据库。本次启动后，pm2 显示青龙进程约 65.7 MB。脚本另占的内存取决于你运行的内容 |
| 架构 | Docker Hub 上 `2.23.0` 包含 linux/amd64、linux/arm64、linux/arm/v7、linux/arm/v6、386、ppc64le、s390x。`2.23.0-debian` 没有 arm/v6 和 386 |
| 磁盘 | Docker Hub 列出的 linux/amd64 大小约 133 MB；`2.23.0-debian` 约 190 MB。解压后的占用和 `data/` 另计 |
| 端口 | 宿主机 **5700** → 容器 **5700**。容器内端口与 `QlPort` 保持一致 |
| 工作目录 | `/www/wwwroot/qinglong` |
| 数据目录 | `data/` 挂到容器内 `/ql/data` |

只在本机打开时用 `http://127.0.0.1:5700`。给别人用、或放到公网时，在前面加 HTTPS，见「使用域名访问」。

青龙 2.23.0 的默认运行时如下。旧版本镜像可能不同。

| 标签 | 系统 | Node.js | Python |
|------|------|---------|--------|
| `2.23.0`（对应官方示例里的 `latest`） | Alpine | 由 Alpine 软件包提供 | 3.11 |
| `2.23.0-debian`（对应官方示例里的 `debian`） | Debian 12 | 20 | 3.11 |

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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

[青龙的 Docker 说明](https://qinglong.online/guide/getting-started/installation-guide/docker)里，`latest` 是 Alpine，`debian` 是 Debian 12 上的 `debian-slim`。Alpine 缺少某个依赖，或要以非 root 用户运行时，官方建议改用 Debian。Alpine 的 `crond` 需要 root 权限。

Docker Hub 上，`latest` 与 **`2.23.0`** 在 2026-10-11 指向同一份镜像。`debian` 与 **`2.23.0-debian`** 也是同一份。`latest` 和 `debian` 以后会变，本文命令使用 **`2.23.0`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2.23.0`** | Alpine，当前与 `latest` 相同，Python 3.11 | **是** |
| `latest` | 现在等于 `2.23.0`，以后会变 | 否 |
| `2.23.0-debian` | Debian 12，当前与 `debian` 相同。Alpine 缺依赖，或要非 root 运行时使用 | 备选，见常见问题 |
| `debian` | 现在等于 `2.23.0-debian`，以后会变 | 否 |
| `2.23.0-python3.10` / `2.23.0-debian-python3.10` | Python 3.10 兼容镜像的最后一版，发布后停止维护 | 否 |
| `cache-*` / `debian-dev` | 构建缓存或开发标签 | 否 |

[2.23.0 发布说明](https://github.com/whyour/qinglong/blob/master/docs/releases/2.23.0.md)写明：这是 Python 3.10 兼容镜像的最后一个版本。新部署用上面的 Python 3.11 镜像。旧环境还依赖 3.10 时，先备份并验证脚本，再迁过来。

完整标签见[标签列表](https://xuanyuan.cloud/r/whyour/qinglong/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/whyour/qinglong:2.23.0
```

Ubuntu 24.04 上拉取结束时：

```text
Digest: sha256:3e3971e78edbb5a6a6900bdfb7cd37352a535416f7ad2451747e601a7558d400
Status: Downloaded newer image for docker.xuanyuan.run/whyour/qinglong:2.23.0
docker.xuanyuan.run/whyour/qinglong:2.23.0
```

## Docker Compose 部署

[官方 Compose 说明](https://qinglong.online/guide/getting-started/installation-guide/docker-compose)把宿主机的 `data` 挂到容器内 `/ql/data`，面板端口是 5700。本文把工作目录放在 `/www/wwwroot/qinglong`。`docker compose down` 不加额外参数时，不会删除 `data/`。目录里已经有初始化数据时，不要清空它。

第一次把空目录挂到 `/ql/data`，会挡住镜像里预装的 Python 依赖。`notify.py` 里有 `import requests`。要跑通知脚本，先在面板的依赖管理里安装 `requests`，并确认安装成功。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。`docker rm` 不删除 `data/`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/qinglong/data
sudo chown -R "$USER":"$USER" /www/wwwroot/qinglong
```

同名容器还在时：

```bash
docker rm -f qinglong
```

2. 写入 `compose.yaml`。宿主机 5700 对应容器 5700，`QlPort` 与容器端口一致。

```bash
cd /www/wwwroot/qinglong
cat > compose.yaml <<'EOF'
name: qinglong

services:
  qinglong:
    image: docker.xuanyuan.run/whyour/qinglong:2.23.0
    container_name: qinglong
    hostname: qinglong
    restart: unless-stopped
    ports:
      - "5700:5700"
    volumes:
      - ./data:/ql/data
    environment:
      QlBaseUrl: "/"
      QlPort: "5700"
EOF
```

3. 检查 Compose 文件能否被解析：

```bash
cd /www/wwwroot/qinglong
docker compose config
```

本次可以解析。`QlBaseUrl` 是 `/`，`QlPort` 是 `5700`，卷是 `/www/wwwroot/qinglong/data` 到 `/ql/data`。

4. 启动：

```bash
cd /www/wwwroot/qinglong
docker compose up -d
```

Ubuntu 24.04 上的结果：

```text
[+] up 2/2
 ✔ Network qinglong_default Created  0.9s
 ✔ Container qinglong       Started  5.2s
```

5. 看状态。`qinglong` 应为 Up，并且能看到宿主机 5700 映射到容器 5700。

```bash
docker compose ps
docker compose logs --tail 80 qinglong
```

启动后几秒，`docker compose ps` 里容器已是 Up，健康检查还显示 `starting`：

```text
NAME       IMAGE                                        COMMAND                  SERVICE    CREATED         STATUS                            PORTS
qinglong   docker.xuanyuan.run/whyour/qinglong:2.23.0   "./docker/docker-ent…"   qinglong   6 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:5700->5700/tcp, [::]:5700->5700/tcp
```

同一轮日志的末尾已经启动成功。pm2 表里版本是 `2.23.0`，状态是 `online`，内存约 65.7 MB。`Applications qinglong not running, starting...` 是 pm2 第一次拉起进程，不是健康检查失败。

```text
qinglong  | [2026-10-14 17:21:21] [   INFO]  🔧  0. 已配置 DNS 解析优化 (ndots:0)
qinglong  | [2026-10-14 17:21:23] [   INFO]  ⚙️  2. 启动 pm2 服务...
qinglong  | [PM2][WARN] Applications qinglong not running, starting...
qinglong  | [PM2] App [qinglong] launched (1 instances)
qinglong  | │ 0  │ qinglong    │ default     │ 2.23.0  │ fork    │ 81       │ 5s     │ 0    │ online    │ 0%       │ 65.7mb   │ root     │ disabled │
qinglong  | [2026-10-14 17:21:29] [SUCCESS]  🎉  容器启动成功!
```

若过了很久 `docker compose ps` 仍是 `starting`，或变成 `unhealthy`，再看 `docker compose logs --tail 80 qinglong`。容器是 Up 之后，按「浏览器初始化」打开页面。

## 浏览器初始化

在跑 Docker 的这台机器上打开：

```text
http://127.0.0.1:5700
```

从别的电脑访问时，把 `127.0.0.1` 换成这台机器的 IP。云服务器还要在安全组里放行 **5700**。

青龙没有预置管理员账号。页面标题是「初始化配置」，左侧四步是「欢迎使用」「通知设置」「账户设置」「完成安装」。账号请自己记下。完成安装之后，再用这个账号登录。

1. 「欢迎使用」的标题是「欢迎使用青龙」。说明文字是「支持python3、javascript、shell、typescript 的定时任务管理面板」。点「开始安装」。

![青龙初始化：欢迎使用青龙，点开始安装](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-1.webp)

2. 暂时不用通知时，在「通知设置」点「跳过」。通知方式默认是「钉钉机器人」，`dingtalkBotToken` 和 `dingtalkBotSecret` 可以先空着。已经填了 token，再点「保存」。

![青龙初始化：通知方式默认是钉钉机器人，token 为空](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-2.webp)

3. 在「账户设置」填写用户名、密码和确认密码，点「提交」。本次测试的用户名是 `admin`，密码是这一步自己设的。

![青龙初始化：账户设置，填写用户名、密码和确认密码](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-3.webp)

4. 看到「恭喜安装完成！」后，点「去登录」。页面上的 Github 和 Telegram频道 这次没有点。

![青龙初始化完成：恭喜安装完成，点去登录](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-4.webp)

5. 登录页标题是「青龙」。用户名填刚才设置的账号，本次是 `admin`，密码填初始化时设的那一个，点「登录」。

![青龙登录页：用户名 admin](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-5.webp)

## 登录后的面板

登录后是「仪表盘」。左上角版本是 **v2.23.0**。刚装完时，总任务、已启用、今日执行、今日成功、今日失败都是 0，成功率是 0%。「今日耗时 Top 5」和「今日执行次数 Top 5」都是「暂无数据」。左下角用户是 `admin`。

![青龙仪表盘：v2.23.0，总任务为 0，暂无数据](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-6.webp)

## 添加一条定时任务

打开「定时任务」，点「创建任务」。名称、命令/脚本、定时类型、定时规则是必填。定时类型默认是「常规定时」。命令一栏的提示是「支持输入脚本路径/任意系统可执行命令/task 脚本路径」。定时规则的提示是「秒(可选) 分 时 天 月 周」。

![青龙定时任务：创建任务窗口，定时类型为常规定时](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-7.webp)

[官方示例](https://qinglong.online/guide/getting-started/first-task)是一个只打印时间的脚本，不需要额外依赖。

1. 进入「脚本管理」，在脚本根目录新建 `hello.js`，保存：

```javascript
console.log('Hello, Qinglong!');
console.log(new Date().toISOString());
```

2. 回到「定时任务」，点「创建任务」，按下表填写，再点「确定」。`0 9 * * *` 表示每天 09:00，时区用面板里的设置。

| 字段 | 内容 |
|------|------|
| 名称 | 第一个任务 |
| 命令 | `task hello.js` |
| 定时规则 | `0 9 * * *` |

3. 在任务列表里运行这条任务，打开它的日志。官方说明里，输出是 `Hello, Qinglong!` 和一行时间。等这一次运行结束再看，不要把上一次的日志当成这一次的结果。

## 面板上的其他页面

这些页面不用在初始化时逐个点完。要改对应内容时再打开。

「订阅管理」用来从仓库拉脚本。类型有「公开仓库」「私有仓库」「单文件」，定时类型有 crontab 和 interval。链接留空不会拉取。只填你信任的仓库地址，再点「确定」。

![青龙订阅管理：创建订阅，类型为公开仓库](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-8.webp)

「环境变量」里，名称和值必填。自动拆分默认是「否」。一个值要拆成多条时，再改成「是」。

![青龙环境变量：创建变量，自动拆分为否](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-9.webp)

「配置文件」打开的是 `config.sh`。要改内容，改完点右上角「保存」。

![青龙配置文件：打开 config.sh](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-10.webp)

「脚本管理」可以改已经在面板里的脚本。这次打开的是 `notify.py`，其中有 `import requests`。右上角有「历史版本」和「调试」。

![青龙脚本管理：打开 notify.py，其中有 import requests](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-11.webp)

「依赖管理」按类型装包。创建窗口里，依赖类型这次显示的是 `nodejs`，自动拆分是「否」。装 Python 包时先改类型，名称填包名，再点「确定」。

![青龙依赖管理：创建依赖，类型为 nodejs](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-12.webp)

「对比工具」左边是示例 `config sample.sh`，右边是当前的 `config.sh`。用来对照示例和正在使用的配置。

![青龙对比工具：左侧 config sample.sh，右侧 config.sh](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-13.webp)

「系统设置」的「安全设置」可以改用户名和密码。「两步验证」点「启用」后再生效。给别的程序调用面板时，到「应用设置」创建应用。

![青龙系统设置：安全设置，可修改用户名密码并启用两步验证](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-14.webp)

「系统日志」这次的日期是 2026-10-14。17:21 左右是容器启动后的记录，和上面 17:21:29 的「容器启动成功!」是同一时段。后面有一条 `GET /detail` 偏慢的 warn，面板没有退出。

![青龙系统日志：2026-10-14 的启动记录](https://imgs.xuanyuan.cloud/docker/blog/qinglong/qinglong-15.webp)

## 使用域名访问

只在本机使用时，继续用 `http://127.0.0.1:5700`。要用域名给别人打开时，在青龙前面放一层反向代理，并由代理做 HTTPS。

下面是一段 Nginx 示例。把 `ql.example.com` 换成你的域名。青龙仍监听本机 5700，`QlBaseUrl` 仍是 `/`。面板升级会走 WebSocket，所以这里转发 `Upgrade`。

```nginx
server {
    listen 80;
    server_name ql.example.com;

    location / {
        proxy_pass http://127.0.0.1:5700;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

改完后重载 Nginx。站点不在域名根路径时，把 `QlBaseUrl` 改成以斜杠开头和结尾的路径，例如 `/ql/`，并让代理使用同一路径。只改浏览器地址、不改 `QlBaseUrl`，页面资源会找不到。

## 备选：docker run

上面的 Compose 已经在跑时，停在那里即可，不必再做这一节。

没有 Compose、只想短期打开看看时，用一条 `docker run`。5700 上已经有容器时，先停掉它。数据目录用 `/www/wwwroot/qinglong-run`，不要挂上面的 `data/`。

官方命令带 `-it`，终端会留在前台。下面用 `-d`，容器在后台运行。看启动过程用 `docker logs`。

```bash
cd /www/wwwroot/qinglong
docker compose down
```

```bash
sudo mkdir -p /www/wwwroot/qinglong-run/data
sudo chown -R "$USER":"$USER" /www/wwwroot/qinglong-run
docker run -d 
  --name qinglong 
  --hostname qinglong 
  --restart unless-stopped 
  -p 5700:5700 
  -e QlBaseUrl="/" 
  -e QlPort="5700" 
  -v /www/wwwroot/qinglong-run/data:/ql/data 
  docker.xuanyuan.run/whyour/qinglong:2.23.0
```

然后打开 `http://127.0.0.1:5700`，按「浏览器初始化」创建管理员账号。日志：

```bash
docker logs --tail 80 qinglong
```

试用结束、要回到 Compose 时，停掉这个容器，再启动原来的 Compose。不要删除 `/www/wwwroot/qinglong/data`。

```bash
docker stop qinglong && docker rm qinglong
cd /www/wwwroot/qinglong
docker compose up -d
```

## 常见问题

**Q1：有没有默认用户名和密码？**

没有。在「账户设置」里自己创建。本次测试的用户名是 `admin`，密码是当时设的，不是安装包自带的。

**Q2：为什么不用 `latest`？**

2026-10-11 它和 `2.23.0` 是同一份镜像，以后会变。标签对照见「标签怎么选」。升级时改具体版本，见 Q9。

**Q3：什么时候改用 Debian，怎么非 root 运行？**

默认用 Alpine 的 `2.23.0`。脚本依赖 Alpine 没有的库，或需要以非 root 用户运行时，改用 `2.23.0-debian`。Alpine 的 `crond` 需要 root，不能靠 `--user` 去掉 root。

非 root 时，先确认宿主机上的数据目录允许容器内的 `qinglong` 用户写入。5700 上已经有同名容器时，先停掉再启动：

```bash
sudo mkdir -p /www/wwwroot/qinglong-debian/data
docker run -d 
  --name qinglong 
  --restart unless-stopped 
  -p 5700:5700 
  --user qinglong 
  -v /www/wwwroot/qinglong-debian/data:/ql/data 
  docker.xuanyuan.run/whyour/qinglong:2.23.0-debian
```

**Q4：Python 提示没有 `requests`？**

官方说明：第一次把空目录挂到 `/ql/data`，会挡住镜像里预装的 Python 依赖。「脚本管理」里的 `notify.py` 含有 `import requests`。要跑通知脚本，先在依赖管理里安装 `requests`，确认成功后再运行。不要为了这个删除 `data/`。

**Q5：5700 已经被占用，怎么改端口？**

只改映射冒号左边时，容器端口和 `QlPort` 仍是 5700。例如把 `"5700:5700"` 改成 `"15700:5700"`，浏览器打开 `http://IP:15700`。

如果改的是 `QlPort`，冒号右边必须和它相同。`QlPort` 设为 `5701` 时，映射写成 `"15701:5701"`。改完执行 `docker compose up -d`。

**Q6：5700 完全打不开？**

按这个顺序看：

1. `docker compose ps` 里 `qinglong` 是否为 Up。
2. 在服务器上打开 `http://127.0.0.1:5700`。本机打不开时，再看 `docker compose logs --tail 80 qinglong`。
3. 本机通、别的电脑不通时，检查安全组和防火墙是否放行了 5700。

**Q7：容器重建后又要初始化？**

管理员账号、脚本和任务在 `/www/wwwroot/qinglong/data`。`compose.yaml` 里没有 `./data:/ql/data`，或者 `data/` 被清空时，会回到首次初始化。确认卷还在，并且没有删过 `data/`。

**Q8：能选 `2.23.0-python3.10` 吗？**

新部署不要选。那是 Python 3.10 的最后一版，发布后停止维护。对照见「标签怎么选」。

**Q9：如何升级？**

先停容器，再备份整个 `data/`。备份要包含数据库、脚本、配置、日志、依赖缓存，以及已有的 `script-history`。只拷数据库，恢复不了脚本。

```bash
cd /www/wwwroot/qinglong
docker compose stop
```

把 `compose.yaml` 里的标签改成新的具体版本，不要改成 `latest`，然后执行：

```bash
docker compose pull
docker compose up -d
```

不要删除 `data/`。升级后各跑一个常用的 JavaScript、Python 和 Shell 脚本，确认依赖和通知还在。

**Q10：如何停止？**

还要保留脚本和账号时，不要删除 `data/`。

```bash
cd /www/wwwroot/qinglong
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop qinglong && docker rm qinglong
```

站点不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/qinglong/data /www/wwwroot/qinglong-run /www/wwwroot/qinglong-debian
```

**Q11：可以把 5700 直接暴露到公网吗？**

管理员能在面板里运行脚本。给公网使用时，用「使用域名访问」里的反向代理做 HTTPS，不要长期开放明文的 5700。

**Q12：宿主机上的 `ql` 和面板里的 `ql` 是一个命令吗？**

不是。面板里的 `ql` 在容器内执行脚本和运维。npm 包 `@whyour/qinglong-cli` 也叫 `ql`，用来从别的机器管理面板，要求 Node.js 22.12 或更高版本。在已经跑着青龙的机器上安装它时，使用独立目录，避免盖掉面板里的命令。调用前先在「系统设置」的「应用设置」里创建应用。

## 命令速查

```bash
docker pull docker.xuanyuan.run/whyour/qinglong:2.23.0

cd /www/wwwroot/qinglong
docker compose up -d
docker compose ps
docker compose logs --tail 80 qinglong
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://127.0.0.1:5700`，按页面创建管理员账号。数据在 `data/`，挂载路径是容器内 `/ql/data`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [whyour/qinglong 镜像页](https://xuanyuan.cloud/zh/r/whyour/qinglong) | [https://xuanyuan.cloud/zh/r/whyour/qinglong](https://xuanyuan.cloud/zh/r/whyour/qinglong) |
| [whyour/qinglong 概览](https://xuanyuan.cloud/r/whyour/qinglong) | [https://xuanyuan.cloud/r/whyour/qinglong](https://xuanyuan.cloud/r/whyour/qinglong) |
| [whyour/qinglong 标签列表](https://xuanyuan.cloud/r/whyour/qinglong/tags) | [https://xuanyuan.cloud/r/whyour/qinglong/tags](https://xuanyuan.cloud/r/whyour/qinglong/tags) |
| [Docker Hub · whyour/qinglong](https://hub.docker.com/r/whyour/qinglong) | [https://hub.docker.com/r/whyour/qinglong](https://hub.docker.com/r/whyour/qinglong) |
| [GitHub · whyour/qinglong](https://github.com/whyour/qinglong) | [https://github.com/whyour/qinglong](https://github.com/whyour/qinglong) |
| [青龙介绍](https://qinglong.online/guide/introduction) | [https://qinglong.online/guide/introduction](https://qinglong.online/guide/introduction) |
| [Docker 部署](https://qinglong.online/guide/getting-started/installation-guide/docker) | [https://qinglong.online/guide/getting-started/installation-guide/docker](https://qinglong.online/guide/getting-started/installation-guide/docker) |
| [Docker Compose 部署](https://qinglong.online/guide/getting-started/installation-guide/docker-compose) | [https://qinglong.online/guide/getting-started/installation-guide/docker-compose](https://qinglong.online/guide/getting-started/installation-guide/docker-compose) |
| [创建第一个任务](https://qinglong.online/guide/getting-started/first-task) | [https://qinglong.online/guide/getting-started/first-task](https://qinglong.online/guide/getting-started/first-task) |
| [2.23.0 发布说明](https://github.com/whyour/qinglong/blob/master/docs/releases/2.23.0.md) | [https://github.com/whyour/qinglong/blob/master/docs/releases/2.23.0.md](https://github.com/whyour/qinglong/blob/master/docs/releases/2.23.0.md) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

[https://xuanyuan.cloud/blog/qinglong-docker-deploy](https://xuanyuan.cloud/blog/qinglong-docker-deploy)



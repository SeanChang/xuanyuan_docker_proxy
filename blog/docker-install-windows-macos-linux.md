# Docker 官网下载与安装：三个平台分别怎么装，装完为什么会卡住

![Docker 官网下载与安装：三个平台分别怎么装，装完为什么会卡住](https://imgs.xuanyuan.cloud/docker/blog/cover.png)

*分类: Docker部署教程 | 标签: docker 官网,docker 下载,docker 安装,docker desktop 下载,docker 是什么,docker 镜像加速,docker pull 卡住,docker 换源,linux 安装 docker,ubuntu 安装 docker | 发布时间: 2026-11-13 10:16:48*

> 从官网下载到跑起第一个容器，Windows、macOS、Linux 三条路径各自写清。含装完 docker pull 卡住的真实原因、判断方法和配置命令。

## 先说拼写

如果你刚才在搜索框里敲的是 `docer`、`dockers` 或者 `docke`，不用不好意思——这三种拼写每个月有三万多人搜，全是在找同一个东西。正确的写法是 **Docker**，一个容器引擎。

这篇文章从头讲起：怎么从官网下到正确的包，三个系统分别怎么装，以及装完之后几乎所有人都会撞上的那道墙。

## Docker 到底是什么，一句话够用

不扯集装箱那套比喻了，你只需要记住三个词：

| 概念 | 通俗解释 | 在哪 |
|---|---|---|
| **镜像（image）** | 一个装好了软件和配置的压缩包 | 在仓库里，下载前 |
| **容器（container）** | 镜像跑起来之后的那个进程 | 在你机器上，运行中 |
| **仓库（registry）** | 存镜像的地方，Docker Hub 是最大的那个 | 网上 |

所以 `docker pull nginx` 的意思是：去仓库把 nginx 这个包下下来。`docker run nginx` 的意思是：把下下来的包跑成一个进程。

新手最容易混的是"镜像"和"容器"——**镜像是文件，容器是进程**。一个镜像可以跑出十个容器，删了容器镜像还在。

知道这些就够了，剩下的边用边学。

## 装之前，先花两分钟确认三件事

大部分安装失败不是手笨，是前提没满足。

**1. 你的系统是不是 64 位**

32 位系统装不了现代 Docker。Windows 在「设置 → 系统 → 关于」里看，Linux 执行 `uname -m`，返回 `x86_64` 或 `aarch64` 才算对。

**2. Windows 的虚拟化开了没**

任务管理器 → 性能 → CPU，右下角找「虚拟化：已启用」。如果是「已禁用」，要进 BIOS 打开 VT-x / AMD-V。这一步不做，Docker Desktop 装完会一直转圈然后报错。

**3. 磁盘留够空间**

Docker Desktop 默认要 20GB 以上。镜像很占地方，一个 AI 模型镜像动辄十几 G。

## Windows：装 Docker Desktop

官网地址是 `https://www.docker.com/products/docker-desktop/`，选 Windows 版本下载。

安装过程没什么可说的，双击、下一步、重启。真正会卡人的是这两点：

**需要 WSL2。** 安装器会提示你装，如果它没提示而你又没装，装完启动会报「WSL 2 installation is incomplete」。手动解决：

```powershell
wsl --install
wsl --update
```

然后重启。**注意 Windows 10 要 2004 版本以上**，更老的系统只能用 Docker Toolbox（已停止维护，不建议）。

**装完不需要单独装 Docker Engine。** Desktop 是一个整体，包含引擎、CLI 和图形界面。

## macOS：分芯片选包

官网同一个页面，会给你两个选项：

- **Apple Silicon**（M1/M2/M3/M4）→ 选 `Apple Chip`
- **Intel**（2020 年前的老 Mac）→ 选 `Intel Chip`

选错了也能装，但会走 Rosetta 转译，慢一倍不止。

如果你用 Homebrew，注意 `brew install docker` 装的是**命令行客户端**，不是 Docker Desktop。想用图形界面还是要下 Desktop 的 dmg。只装 CLI 的话，运行 `docker ps` 会报「Cannot connect to the Docker daemon」——因为没引擎。

装完从启动台打开，等鲸鱼图标在菜单栏稳定下来（不再跳动）再操作。

## Linux：不要用 apt install docker.io

这是新手最常踩的坑。Ubuntu 官方源里的 `docker.io` 包版本很旧，经常是 20.x 甚至 19.x，而现在的镜像生态已经要求 24 以上。装了会发现拉某些镜像报 `Schema 1` 或 `406`，然后你以为是镜像源的问题，其实是客户端太老。

**正确做法有三条路，按省事程度排：**

### 路子一：一键脚本（最省事）

官方维护的脚本支持 19 种发行版，包括统信 UOS、银河麒麟、openEuler、HCE、Linux Mint 这些环境，也支持鲲鹏 920、飞腾这类 ARM 处理器。Linux Mint 仅 x86_64，版本为 19.x、20.x、21.x、22.x，Docker 源按对应 Ubuntu 基线安装，不含 LMDE：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

它会自动识别系统版本、装 Docker 和 Compose、顺便配好镜像源。源码在 GitHub 上开源（`SeanChang/xuanyuan_docker_proxy`），担心安全可以先下下来看一眼：

```bash
wget https://get.xuanyuan.cloud/docker.sh -O docker-install.sh
less docker-install.sh
bash docker-install.sh
```

有两类情况它不管：**CentOS 7**（已 EOL，官方源都下线了，建议先迁移到 Rocky 或 AlmaLinux），以及表里没有的冷门发行版。

### 路子二：Docker 官方源（最标准）

想自己控制每一步的用这个。以 Ubuntu/Debian 系为例：

```bash
# 装依赖
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# 加官方 GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg 
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 加软件源
echo "deb [arch=$(dpkg --print-architecture) 
signed-by=/etc/apt/keyrings/docker.gpg] 
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" 
  | sudo tee /etc/apt/sources.list.d/docker.list

# 安装
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

RHEL 系（CentOS Stream / Rocky / AlmaLinux）把 `apt-get` 换成 `dnf`，源地址换成 `https://download.docker.com/linux/centos/docker-ce.repo` 即可。

### 路子三：离线包（内网机器）

完全没有外网的机器，只能在有网的机器上下 `.deb` / `.rpm` 再拷过去。这条路最麻烦，能通外网就别走。

## 装完了，验证一下

三条命令，全过了才算装好：

```bash
docker --version          # 有版本号输出
sudo systemctl status docker   # 显示 active (running)
sudo docker run hello-world    # 打印一段欢迎语
```

如果 `hello-world` 卡住不动或者报 `i/o timeout`，恭喜，你遇到了所有人都遇到的那道墙——**这不是你装错了，往下看**。

## 为什么会卡：Docker Hub 在国内的真实速度

`docker pull` 默认去 `registry-1.docker.io` 取镜像，这个地址在国内的连通性这些年一直在恶化。表现是三种：

- 卡在 `Waiting` 几分钟，然后 `i/o timeout`
- 能连上，但速度在几十 KB/s，一个 500MB 的镜像要下一小时
- 拉到一半 `unexpected EOF`，重试还是断在同一层

先自己测一下，确认是不是这个问题：

```bash
time curl -sI https://registry-1.docker.io/v2/ | head -1
```

如果这条命令超过 5 秒才返回，或者直接超时，那后面所有的拉取都会慢。

## 解决办法：让 Docker 换条路取

原理很简单：告诉 Docker「别去官方地址了，去这个地址取」，这个地址就是国内的中转缓存。配置一次，之后所有 `docker pull` 都走它。

### 一条命令配好

```bash
sudo mkdir -p /etc/docker

sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
  "registry-mirrors": ["https://你的前缀.xuanyuan.run"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
```

把 `你的前缀` 换成你自己的。没有的话，[注册后控制台里就有](https://xuanyuan.cloud/?code=BC9MPZ&xy_from=blog-m6)，形如 `abcd1234.xuanyuan.run`，复制过来替换掉中文那四个字就行。

别图省事去用公共入口 `docker.xuanyuan.me`。它只对 Docker Hub 生效，限流也严，很多人就是在这里配完觉得"加速没用"——实际上是把车停在了断头路上。

### 验证是否生效

```bash
docker info | grep -A 4 "Registry Mirrors"
```

输出里有你刚填的地址就对了。然后拉个镜像实测：

```bash
time docker pull nginx:alpine
```

正常应该是几秒钟。如果还是慢，八成是 `daemon.json` 写错了位置（比如写成了 `daemon.conf`），或者改完没重启 Docker。

### Windows / macOS 的配法不一样

Docker Desktop 不读 `/etc/docker/daemon.json`，要在界面里改：

**Settings → Docker Engine**，在 JSON 里加上 `registry-mirrors` 这一段，点 **Apply & Restart**。改完不点 Apply 是不生效的，这是 Desktop 用户最常见的失误。

## 一件容易踩的事：为什么配了加速还是拉不动

这里必须说清楚，因为很多人配完发现"部分镜像还是拉不动"，以为是配置错了。

原因就两个：**覆盖范围**，和**限流**。

先说覆盖范围。图省事用公共入口 `docker.xuanyuan.me` 的人最多，但它只对 `docker.io` 生效，而你接下来要装的东西，很多根本不在 Docker Hub：

- NAS 上的第三方套件，大量发布在 `ghcr.io`
- Kubernetes 的组件在 `registry.k8s.io`
- 各种 AI 工具、开源项目的新版本，越来越多只在 `ghcr.io` 发
- Google 系的镜像在 `gcr.io`，NVIDIA 的在 `nvcr.io`

遇到这些，公共入口一点用没有，`docker pull ghcr.io/xxx` 照样超时。这时候不是配置错了，是那条路本来就没通。

再说限流。公共入口每小时 100 次，`docker compose up` 起一套带数据库的服务，一次就可能几十层；CI 跑一次构建，一晚上能把额度用完。这个额度看着"够用"，实际会在你干活干到一半的时候断掉——然后你还得花半小时怀疑是不是自己配错了。

专业版给每个仓库都开了一个独立前缀：

```bash
docker pull 你的前缀-ghcr.xuanyuan.run/org/image:tag
docker pull 你的前缀-k8s.xuanyuan.run/kube-apiserver:v1.31.0
docker pull 你的前缀-gcr.xuanyuan.run/google-samples/node-hello:1.0
```

不用改配置文件，直接在镜像名前加前缀就行。也不用手动 `docker login`，地址本身就是凭证。每小时 1,000 次，十个仓库全在里面，这个量日常根本用不完。

我用的是[轩辕](https://xuanyuan.cloud/?code=BC9MPZ&xy_from=blog-m6)，充一点钱可以用好久，除了这个以外，网上的所谓免费镜像都用不起来。

我一开始也是到处找免费源，一个一个试，今天通明天挂。后来懒得折腾了，几块钱买一年，省下来的就是反复折腾的那几个小时。8 元 50GB 流量包，有效期一年，NAS 上那点日常拉取根本用不完。

十个仓库的完整前缀表、containerd 和 Podman 的配法，在[使用手册](https://xuanyuan.cloud/usage?code=BC9MPZ&xy_from=blog-m6)里都有。

## 第一个容器：从 nginx 开始

镜像通了之后，跑个东西看看。按轩辕镜像 2026-11-11 的拉取统计，nginx 是国内拉取量第一的镜像，也是最适合入门的：

```bash
docker run -d --name my-nginx -p 8080:80 nginx:alpine
```

拆开看这行命令：

- `-d` 后台运行
- `--name my-nginx` 给容器起个名字，不起名会随机分配
- `-p 8080:80` 把宿主机的 8080 映射到容器的 80
- `nginx:alpine` 镜像名加标签，alpine 是精简版，只有 20MB 左右

然后浏览器打开 `http://localhost:8080`，看到 nginx 欢迎页就成了。

常用操作：

```bash
docker ps                  # 看运行中的容器
docker logs my-nginx       # 看日志
docker stop my-nginx       # 停止
docker rm my-nginx         # 删除容器（镜像还在）
docker images              # 看本地有哪些镜像
```

## 新手最常撞的五个坑

**1. `sudo` 和普通用户混着用**

先 `sudo docker login` 再用 `docker pull`，会报 `401 UNAUTHORIZED`。原因是登录凭证存在 root 的家目录，普通用户读不到。要么全程加 `sudo`，要么把用户加进 docker 组：

```bash
sudo usermod -aG docker $USER
```

然后**重新登录**（不是重开终端，是注销再登）。

**2. 改完配置没重启**

`daemon.json` 改完必须 `systemctl restart docker`。Docker Desktop 必须点 Apply & Restart。这一步漏了，配置等于没改。

**3. 镜像名写错**

报 `manifest unknown` 基本都是名字或标签不存在，不是网络问题。注意 `nginx` 等于 `library/nginx`，官方镜像省略了 `library/`，但用户镜像不能省。

**4. 以为 `latest` 是最新的**

`latest` 只是维护者随手打的一个标签，不代表最新版本。生产环境永远写明确版本号，比如 `nginx:1.27-alpine`。

**5. 架构不对**

在 M 系列 Mac 上拉了个只有 x86 的镜像，报 `no matching manifest for linux/arm64`。这是镜像本身没提供 ARM 版本，不是你配错了。用 `docker pull --platform linux/amd64` 可以强制拉 x86 版本，靠模拟运行。

## 常见问题

**Q：装完重启电脑，Docker 起不来了？**

Windows 上多半是 WSL2 服务没自启。管理员 PowerShell 执行 `wsl --update`，再打开 Docker Desktop 等它自己恢复。

**Q：`docker` 命令提示 command not found，但明明装好了？**

用户组没生效。注销重新登录，或者临时用 `sudo docker`。

**Q：公司网络有代理，配了镜像源还是不通？**

Docker 的代理要单独配，不是设了系统代理就行。在 `~/.docker/config.json` 或 systemd 的 `docker.service.d/` 里加 `HTTP_PROXY`，具体看 Docker 官方文档的 daemon proxy 一节。

**Q：一定要用镜像加速吗？**

看你在哪。海外机器直连没问题；国内机器不配的话，能不能拉通要看运气，速度也不稳定。

---

装 Docker 这件事本身不复杂，真正耗时间的是装完之后那半小时——镜像拉不动，然后开始怀疑是自己哪里弄错了。先把加速配好，后面所有的步骤都会顺很多。

下一篇讲拉取报错的对照处理：`401`、`429`、`manifest unknown`、`no matching manifest` 分别是什么原因，怎么一眼看出来该改哪里。

---

**如果你现在就想把加速配完**

- 直接用专属域名，[注册后控制台里复制](https://xuanyuan.cloud/?code=BC9MPZ&xy_from=blog-m6)，形如 `abcd1234.xuanyuan.run`，8 元 50GB 流量包，有效期一年
- 十个仓库的前缀写法：[使用手册](https://xuanyuan.cloud/usage?code=BC9MPZ&xy_from=blog-m6)里按场景分了，照着抄就行
- 装完还是报错：先看报错里的域名和状态码，八成的"配置没用"其实是配错了路



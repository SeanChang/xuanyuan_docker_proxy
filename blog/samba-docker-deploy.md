# Docker 部署 Samba：轻松搭建局域网文件共享

![Docker 部署 Samba：轻松搭建局域网文件共享](https://imgs.xuanyuan.cloud/docker/blog/samba-docker/samba-docker.webp)

*分类: Docker部署教程 | 标签: Samba,dockurr/samba,Docker,轩辕镜像,SMB,文件共享,私有化部署,部署教程 | 发布时间: 2026-10-24 20:15:47*

> Samba 是一款面向局域网的开源 SMB 文件服务，旨在把一台机器上的目录共享给 Windows、macOS 和 Linux，并通过共享名和账号控制谁能访问。本文将介绍如何通过 Docker Compose 部署 dockurr/samba，搭建局域网文件共享，帮助你少在主机上安装 Samba 软件包，直接把目录分给同事和家里的电脑，适合办公室传文件及家庭目录共享等场景。

*本文基于 [dockurr/samba:4.23.10](https://xuanyuan.cloud/zh/r/dockurr/samba)，以 **4.23.10** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## Samba 是什么

dockurr/samba 把 Samba 放进一个容器里，用来做 SMB 文件共享。你把宿主机上的一个目录挂进去，局域网里的 Windows、macOS 和 Linux 就可以用原来的文件管理器打开它。

和在主机上用软件包安装 Samba 相比，这个容器不用再单独维护一套系统服务。共享名、用户名和密码写在环境变量里，文件留在宿主机目录中。同事打开资源管理器或访达就能取文件，不用再装一个专用网盘客户端。

## Samba 能做什么

- **共享一个目录**：把宿主机上的文件夹通过 SMB 提供给局域网里的电脑。
- **设置共享名和账号**：为这块共享指定显示名称、用户名和密码。
- **控制能否修改**：共享可以保持读写，也可以改成只读。
- **分开多个账号**：每个人使用自己的用户名和密码访问同一块目录。
- **换上自己的配置**：需要更多共享或更细的规则时，可以挂上自己的 Samba 配置。

## 为什么要使用 Samba

办公室和家里要互传文件时，U 盘得有人送过去，网盘要先上传再下载。在 Linux 上用软件包安装 Samba，还要自己写配置、管服务和开机启动。

dockurr/samba 把这件事收成一个容器。目录放在宿主机上，账号写在环境变量里，Windows 资源管理器、macOS 访达和 Linux 文件管理器都能连。适合已经在用 Docker 的电脑、小团队的公共目录，以及想把一台 Linux 上的文件夹分给局域网里几台机器的人。

## 使用 Docker 部署 Samba

用 Docker 跑 Samba，宿主机不用再安装 Samba 软件包。开始之前准备好 Docker，想好要分享的目录，以及客户端登录用的用户名和密码。

接下来用 Docker Compose 写好共享和账号，启动服务，再从资源管理器或访达打开这个目录。

## 环境要求

本文命令使用 **`dockurr/samba:4.23.10`**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/samba` 换成 `~/docker/samba`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** 或 **linux/arm/v7**。标签页上三种架构都有 |
| 磁盘 | 标签页上 amd64 约 29 MB，arm64 约 30 MB，arm/v7 约 26 MB。共享文件按实际再留余量 |
| 端口 | 宿主机 **445** → 容器 **445**。启动前确认本机没有别的程序占用 445 |
| 工作目录 | `/www/wwwroot/samba` |
| 数据目录 | `data/` 对应容器内 `/shared` |
| 账号 | 用户名默认 `samba`。密码在 Compose 里自己设置，不要沿用镜像默认的 `secret` |

只在本机试连时，可以用 `smb://127.0.0.1/Shared`。给局域网里的人用时，放行 **445**，并限制来源地址。不要把 445 对公网全部打开。

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

轩辕镜像标签页上，`4.23.10` 提供 linux/amd64、linux/arm64 和 linux/arm/v7，推送时间是 2026-10-14。2026-10-24 查看时，`latest`、`4`、`4.23` 与 `4.23.10` 是同一份镜像。`latest`、`4` 和 `4.23` 会在以后的版本发布后改指向。下面的命令使用 **`4.23.10`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`4.23.10`** | 2026-10-14 这份具体版本 | **是** |
| `4.23` | 4.23 这一支的浮动标签 | 否 |
| `4` | 4 这一支的浮动标签 | 否 |
| `latest` | 当前最新构建，会变 | 否 |
| `4.23.8` 及更早版本号 | 更早的 Samba 版本 | 否 |

完整标签见[标签列表](https://xuanyuan.cloud/r/dockurr/samba/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/dockurr/samba:4.23.10
```

Ubuntu 24.04 实测：

```text
4.23.10: Pulling from dockurr/samba
f2dbe50384ef: Pull complete
1874c91781d1: Pull complete
3b4647e01934: Pull complete
173a115417ee: Pull complete
Digest: sha256:2a0452a12b7a244a22f18d0f233101bb8d4952b5500ae263905e3b9dad3bf2ae
Status: Downloaded newer image for docker.xuanyuan.run/dockurr/samba:4.23.10
docker.xuanyuan.run/dockurr/samba:4.23.10
```

完成后，再写下面的 Compose。

## Docker Compose 部署

共享文件在宿主机目录 `data/`，对应容器内 `/shared`。`docker compose down` 不加额外参数时，不会删除 `data/`。

镜像在没有设置密码时使用用户名 `samba`、密码 `secret`。写入文件前把 `PASS` 换成你自己的密码。原样启动的话，登录密码就是 `change-me`。给别人用之前先换成只有你知道的密码。

`data/` 里已经有文件时，不要清空这个目录。容器不会改这些已有文件的所有者。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。这一步不删除 `data/`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/samba/data
sudo chown -R "$USER":"$USER" /www/wwwroot/samba
```

同名容器还在时：

```bash
docker rm -f samba
```

2. 写入 `compose.yaml`。先把 `PASS` 那一行换成你自己的密码。

```bash
cd /www/wwwroot/samba
cat > compose.yaml <<'EOF'
name: samba

services:
  samba:
    image: docker.xuanyuan.run/dockurr/samba:4.23.10
    container_name: samba
    restart: unless-stopped
    environment:
      NAME: "Shared"
      USER: "samba"
      PASS: "change-me"
    ports:
      - "445:445"
    volumes:
      - ./data:/shared
EOF
```

宿主机 **445** 对应容器 **445**。这是 SMB 使用的端口。镜像也声明了 139，官方示例不发布它。这份配置的最低协议是 SMB2，Windows 10、macOS 和常见 Linux 客户端走 445 即可。

容器异常退出后会自动再启动。手动 `docker compose stop` 之后，不会被拉起来。

3. 启动：

```bash
cd /www/wwwroot/samba
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network samba_default Created 0.2s
 ✔ Container samba       Started 2.2s
```

4. 看状态。`samba` 应为 Up。刚启动时健康检查还是 `starting`，镜像里的检查间隔约 60 秒。端口里应有 `0.0.0.0:445->445/tcp`。`139/tcp` 只是镜像声明的端口，没有映射到宿主机。

```bash
docker compose ps
```

Ubuntu 24.04 实测（启动后约 2 秒）：

```text
NAME      IMAGE                                       COMMAND                  SERVICE   CREATED         STATUS                            PORTS
samba     docker.xuanyuan.run/dockurr/samba:4.23.10   "/sbin/tini -- /usr/…"   samba     4 seconds ago   Up 2 seconds (health: starting)   139/tcp, 0.0.0.0:445->445/tcp, [::]:445->445/tcp
```

5. 看日志。出现 `smbd version 4.23.10 started.` 就可以从客户端连接。

```bash
docker compose logs --tail 50 samba
```

Ubuntu 24.04 实测：

```text
samba  | smbd version 4.23.10 started.
samba  | Copyright Andrew Tridgell and the Samba Team 1992-2025
```

## 从客户端连接

`smb://` 和 `\服务器Shared` 写在文件管理器的地址栏里。不要把它们贴进 SSH 终端。在 bash 里执行 `smb://127.0.0.1/Shared`，会报 `No such file or directory`。

在服务器上用容器里的 `smbclient` 检查。命令会向你要密码，填写 `PASS` 里的值。按本文示例启动时，密码是 `change-me`。

```bash
cd /www/wwwroot/samba
docker compose exec -it samba smbclient '//localhost/Shared' -U samba -m SMB3
```

进入提示符后输入 `ls` 看目录，退出用 `exit`。

从别的电脑访问时，把主机换成跑 Docker 的那台机器的 IP。这次实测从另一台 Windows 打开：

```text
\192.168.1.35Shared
```

地址栏回车后，弹出「Windows 安全中心」的「输入网络凭据」。用户名填 `samba`，密码填你在 `PASS` 里设置的值。按本文示例启动时，密码是 `change-me`。点「确定」。

![Windows 安全中心输入网络凭据，用户名为 samba，目标主机 192.168.1.35，已勾选记住我的凭据](https://imgs.xuanyuan.cloud/docker/blog/samba-docker/samba-docker-1.webp)

截图里勾选了「记住我的凭据」。这台 Windows 会记下这次的账号。不需要记住时，取消勾选再点「确定」。

进入之后，共享名是 `Shared`。目录里还没有文件时，窗口中间显示「此文件夹为空。」

![资源管理器打开 \192.168.1.35Shared，面包屑为网络 / 192.168.1.35 / Shared，此文件夹为空](https://imgs.xuanyuan.cloud/docker/blog/samba-docker/samba-docker-2.webp)

把文件拖进这个窗口，或粘贴进去。这次放入 `report.html` 后，列表里出现该文件，大小 1 KB。

![Shared 目录中出现 report.html，类型为 Chrome HTML Document，大小 1 KB](https://imgs.xuanyuan.cloud/docker/blog/samba-docker/samba-docker-3.webp)

回到服务器查看挂载目录。客户端放进去的文件在 `data/` 里：

```bash
cd /www/wwwroot/samba/data
ls
```

Ubuntu 24.04 实测：

```text
report.html
```

macOS 打开访达，使用「前往」里的「连接服务器」。Linux 打开桌面里的文件管理器，在地址栏输入：

```text
smb://服务器IP/Shared
```

这台机器有桌面时，文件管理器地址可以写成 `smb://127.0.0.1/Shared`。只有 SSH 时，用上面的 `smbclient`。

`NAME` 改成别的词时，路径里的 `Shared` 换成同一个名字。这块共享需要账号，没有做成匿名可写。

这个容器不提供 WS-Discovery。Windows 的「网络」里通常不会自动出现这台机器，地址栏直接输入上面的路径。

云服务器在安全组里放行 **445**，来源填你的局域网或指定 IP。本机启用了 ufw 时，把网段换成你的局域网再执行：

```bash
sudo ufw allow from 192.168.0.0/16 to any port 445 proto tcp
```

默认配置带有 macOS 用的 fruit 模块，并写了 `fruit:time machine = yes`。访达连上之后，这块共享可以出现在 Time Machine 的备份盘列表里。

## 按需要调整共享

下面每一项都是在已经写好的 `compose.yaml` 上修改。改完后在同一目录执行：

```bash
cd /www/wwwroot/samba
docker compose up -d
```

`data/` 里的文件会保留。

### 改成只读

只允许下载、不允许客户端修改时，在 `environment` 里加上：

```yaml
RW: "false"
```

`RW` 为 `false`、`False` 或 `0` 开头时，共享变成只读。改回读写时写成 `RW: "true"`，或删掉这一行，再执行一次 `docker compose up -d`。

挂了自己的 `smb.conf` 时，这一变量不会再生效。是否可写以那个文件为准。

### 添加多个用户

挂上非空的 `users.conf` 之后，启动脚本不再使用 `USER` 和 `PASS`，也不会再给共享加上 `force user`。要登录的人全部写进这个文件。

密码不要包含英文冒号 `:`、换行或回车。先把文件写好，再写进 `volumes`。文件还不存在就去挂载时，Docker 会建出一个目录，容器会退出，并提示绑定路径对应的文件不存在。

多个用户都要往同一个目录里写文件时，先把目录权限放开。空目录在多用户模式下只会变成 `0770`，不会再改所有者。

1. 放开 `data/` 的写入权限：

```bash
chmod 1777 /www/wwwroot/samba/data
```

2. 写入用户列表。把密码换成你自己的：

```bash
cd /www/wwwroot/samba
cat > users.conf <<'EOF'
john:1001:users:1001:change-me-1:/shared
jane:1002:users:1001:change-me-2:/shared
EOF
```

每一行的字段是 `用户名:UID:组名:GID:密码:家目录`。家目录可以不写，不写时使用 `/shared`。以 `#` 开头的行和空行会被忽略。原样启动时，两人的密码分别是 `change-me-1` 和 `change-me-2`。

3. 在 `compose.yaml` 的 `volumes` 里增加一行：

```yaml
- ./users.conf:/etc/samba/users.conf
```

4. 重新启动：

```bash
cd /www/wwwroot/samba
docker compose up -d
```

客户端用 `john` 或 `jane` 登录。新建文件的所有者是对应用户的 UID，宿主机上看到的数字与 `users.conf` 里的 UID 一致。

密码留空时，启动脚本会建一个无密码并被禁用的账号。默认配置没有打开来宾访问，留空不能当成匿名读写。

### 使用自己的 smb.conf

需要多个共享，或要改协议、审计一类规则时，再挂自己的配置。挂上之后，`NAME` 和 `RW` 不会再生效，共享定义以这个文件为准。文件里的 `path` 要和卷挂载一致。仓库里的默认模板把目录写在 `/shared`。

先把文件放在宿主机上，再写入 `volumes`。源文件不存在时，Docker 会把挂载点建成目录，容器会退出。

默认模板见 [smb.conf](https://github.com/dockur/samba/blob/master/smb.conf)。在 `volumes` 里增加：

```yaml
- ./smb.conf:/etc/samba/smb.conf
```

然后执行 `docker compose up -d`。

### 指定文件所有者

`UID` 和 `GID` 默认是 `auto`。容器读取 `data/` 目录当前的所有者；读到 `0` 时改用 `1000`。需要固定时，在 `environment` 里写成数字：

```yaml
UID: "1002"
GID: "1005"
```

然后执行 `docker compose up -d`。

空的 `data/` 在单用户模式下会交给这个用户，权限是 `0770`。目录里已经有文件时，不会改这些文件的所有者。客户端读不到已有文件时，在宿主机上调整 `data/` 的所有权，使上面的 UID 能够读取。

### 密码写在文件里

不想把密码留在 `compose.yaml` 里时，先建一个只有密码的文件，再挂到容器里的 `/run/secrets/pass`。这个文件非空时，启动脚本用文件内容作为密码，盖过 `PASS`。文件为空时，仍使用 `PASS`。

先写文件，再加挂载。文件还不存在就写入 `volumes` 时，Docker 会建目录，容器读不到密码。

```bash
cd /www/wwwroot/samba
cat > smb.pass <<'EOF'
你的密码
EOF
chmod 600 smb.pass
```

把 `你的密码` 换成实际密码。在 `volumes` 里增加：

```yaml
- ./smb.pass:/run/secrets/pass:ro
```

然后执行 `docker compose up -d`。

## 备选：docker run

没有 Compose，或只想临时开一下时，用下面的命令。

Compose 已经占用 445，或已经有名为 `samba` 的容器时，先停掉它。这一步不删除 `/www/wwwroot/samba/data`。还没有这份 Compose 时，跳过这一段。

```bash
cd /www/wwwroot/samba
docker compose down
```

1. 另建一个目录，避免和 Compose 的 `data/` 混在一起：

```bash
sudo mkdir -p /www/wwwroot/samba-run/data
sudo chown -R "$USER":"$USER" /www/wwwroot/samba-run
```

2. 启动。把 `PASS` 换成你自己的密码。原样执行时，密码是 `change-me`。

```bash
docker run -d 
  --name samba 
  --restart unless-stopped 
  -p 445:445 
  -e NAME=Shared 
  -e USER=samba 
  -e PASS=change-me 
  -v /www/wwwroot/samba-run/data:/shared 
  docker.xuanyuan.run/dockurr/samba:4.23.10
```

3. 看状态。`samba` 应为 Up，端口是 `0.0.0.0:445->445/tcp`。

```bash
docker ps --filter name=samba
```

客户端仍按「从客户端连接」里的地址访问。这台临时实例的文件在 `/www/wwwroot/samba-run/data`，不在 Compose 的 `data/` 里。

试用结束、要回到 Compose 时，停掉这个容器，再启动原来的 Compose。不要删除 `/www/wwwroot/samba/data`。

```bash
docker stop samba && docker rm samba
cd /www/wwwroot/samba
docker compose up -d
```

## 常见问题

**Q1：终端执行 `smb://127.0.0.1/Shared` 报 `No such file or directory`？**

这是 bash 在找一个叫这个名字的命令，不是 Samba 拒绝连接。`smb://` 只写在文件管理器地址栏里。在 SSH 里改用「从客户端连接」中的 `smbclient`。

**Q2：Windows 的「网络」里看不到这台机器？**

这个容器只提供 SMB，不提供 WS-Discovery。在资源管理器地址栏输入 `\服务器IPShared`。共享名改过时，把 `Shared` 换成 `NAME` 的值。

**Q3：445 端口起不来？**

宿主机上已经有程序监听 445 时，这条映射会失败。常见情况是本机装了 Samba，或打开了系统自带的文件共享。先停掉那个服务，再执行 `docker compose up -d`。

Windows 本机的文件共享会占用 445。正文命令按 Linux 编写。在 Windows 上按 `445:445` 启动时，端口通常绑不上。需要共享 Windows 自己的目录时，用系统自带的共享；需要跑这个容器时，把它放到一台 Linux 上。

**Q4：客户端提示用户名或密码错误？**

单用户模式用 `USER` 和 `PASS`。本文命令里的用户名是 `samba`，密码是你写进 `PASS` 的值。镜像默认密码 `secret` 只在你完全没有设置 `PASS`、也没有挂密码文件时才会用上。

挂了非空的 `users.conf` 之后，`USER` 和 `PASS` 不再用来建账号。客户端要改用文件里的用户名和密码。

改完密码后执行 `docker compose up -d`，让容器按新环境变量再启动一次。`data/` 还在。

**Q5：能列出共享，但不能新建或修改文件？**

单用户模式下，空目录会交给 Samba 用户，权限是 `0770`。目录里原先就有文件时，容器不改所有者。在宿主机上把 `data/` 的所有权调到 `UID` 对应的用户，或让这个用户能够读写。

多用户模式不会做这次 `chown`。几个账号都要写入时，确认已经执行过 `chmod 1777 /www/wwwroot/samba/data`。

设置了 `RW: "false"` 时，共享本身就是只读的。

**Q6：以前的教程把目录挂到 `/storage`，还能用吗？**

可以。容器里如果存在目录 `/storage`，共享路径会改成 `/storage`。本文命令把宿主机的 `data/` 挂到 `/shared`。旧的 `/storage` 挂载和 `/shared` 挂载同时存在时，客户端看到的是 `/storage` 那一份。

**Q7：挂上 `smb.conf` 或 `users.conf` 后容器马上退出？**

日志里若出现绑定路径对应的文件不存在，说明当时宿主机上还没有这个文件，Docker 建出了一个目录。先 `docker compose down`，删掉那个同名目录，按「按需要调整共享」写成文件，再启动。

**Q8：很老的设备连不上？**

默认配置写了 `server min protocol = SMB2`。只支持 SMB1 的旧设备连不上这块共享。Windows 10、当前的 macOS 和常见 Linux 文件管理器走 SMB2 或 SMB3，使用 445 即可。

**Q9：`data/` 里的符号链接会指向外面吗？**

默认配置打开了 `follow symlinks` 和 `wide links`，并关闭了 `unix extensions`。放在 `data/` 里、指向目录外面的符号链接，客户端有可能顺着它读到别的路径。不要在 `data/` 里放置指向宿主机敏感目录的链接。

**Q10：可以把 445 直接暴露到公网吗？**

不要对公网全部开放 445。SMB 账号会被放在公网上试探。给局域网使用，或只在安全组里放行指定来源。

**Q11：如何升级？**

先保留 `data/`。把 `compose.yaml` 里的标签改成新的具体版本号，然后执行：

```bash
cd /www/wwwroot/samba
docker compose pull
docker compose up -d
```

不要把命令改成 `latest`。`data/` 保持不动。

**Q12：如何停止？**

还要保留共享文件时，不要删除 `data/`。

```bash
cd /www/wwwroot/samba
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop samba && docker rm samba
```

这块共享不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/samba/data /www/wwwroot/samba-run
```

`smb.pass` 和 `users.conf` 里有密码。目录废弃时一并删掉，不要留在还在使用的备份里。

## 命令速查

```bash
docker pull docker.xuanyuan.run/dockurr/samba:4.23.10

cd /www/wwwroot/samba
docker compose up -d
docker compose ps
docker compose logs --tail 50 samba
docker compose exec -it samba smbclient '//localhost/Shared' -U samba -m SMB3
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。Windows 地址栏打开 `\服务器IPShared`，macOS 和 Linux 打开 `smb://服务器IP/Shared`。用户名是 `samba`，密码是 `PASS` 里设置的值。文件在 `data/`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [dockurr/samba 镜像页](https://xuanyuan.cloud/zh/r/dockurr/samba) | [https://xuanyuan.cloud/zh/r/dockurr/samba](https://xuanyuan.cloud/zh/r/dockurr/samba) |
| [dockurr/samba 概览](https://xuanyuan.cloud/r/dockurr/samba) | [https://xuanyuan.cloud/r/dockurr/samba](https://xuanyuan.cloud/r/dockurr/samba) |
| [dockurr/samba 标签列表](https://xuanyuan.cloud/r/dockurr/samba/tags) | [https://xuanyuan.cloud/r/dockurr/samba/tags](https://xuanyuan.cloud/r/dockurr/samba/tags) |
| [Docker Hub · dockurr/samba](https://hub.docker.com/r/dockurr/samba) | [https://hub.docker.com/r/dockurr/samba](https://hub.docker.com/r/dockurr/samba) |
| [GitHub · dockur/samba](https://github.com/dockur/samba) | [https://github.com/dockur/samba](https://github.com/dockur/samba) |
| [默认 smb.conf](https://github.com/dockur/samba/blob/master/smb.conf) | [https://github.com/dockur/samba/blob/master/smb.conf](https://github.com/dockur/samba/blob/master/smb.conf) |
| [users.conf 示例](https://github.com/dockur/samba/blob/master/users.conf) | [https://github.com/dockur/samba/blob/master/users.conf](https://github.com/dockur/samba/blob/master/users.conf) |
| [Samba 官网](https://www.samba.org/) | [https://www.samba.org/](https://www.samba.org/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/samba-docker-deploy



# Docker 部署 File Browser：轻松搭建 Web 文件管理平台

![Docker 部署 File Browser：轻松搭建 Web 文件管理平台](https://imgs.xuanyuan.cloud/docker/blog/filebrowser.png)

*分类: Docker部署教程 | 标签: File Browser,filebrowser/filebrowser,Docker,轩辕镜像,文件管理,私有化部署,部署教程 | 发布时间: 2026-06-29 13:33:15*

> File Browser 是一款面向自托管场景的开源 Web 文件管理器，旨在管理指定目录中的文件，并通过浏览器界面完成上传、下载、预览和用户目录划分。本文将介绍如何通过 Docker 快速部署 File Browser，搭建私有化文件管理平台，帮助个人和小团队更高效地管理服务器上的文件，适合替代 SFTP 传文件及内网目录交换等场景。

*本文基于 [filebrowser/filebrowser:v2.63.17-s6](https://xuanyuan.cloud/zh/r/filebrowser/filebrowser)，以 **v2.63.17-s6** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## File Browser 是什么

File Browser 是一款开源的 Web 文件管理器，上游仓库已于 2026-09-01 归档。它在指定目录里提供上传、下载、预览、重命名和编辑，也可以为不同用户划分各自的目录。装到自己的服务器上之后，用浏览器管理这一份目录。

和 SFTP、FTP 客户端相比，传文件不必再打开单独的客户端。和网盘相比，它不做协作编辑，也不保留版本历史，文件留在你挂载的磁盘上。

## File Browser 能做什么

- **在浏览器里管理文件**：对指定目录里的文件做上传、下载、预览、重命名和编辑。
- **划分用户和目录**：可以创建多个用户，每人使用自己的目录和权限。
- **新建和整理**：在网页里新建文件夹，并做移动、复制和按文件名搜索。
- **目录即数据**：网页里看到的文件，就是挂载到服务里的那一份目录。
- **记下用户和配置**：用户、权限和站点配置写在自带的数据库和配置文件里。

## 为什么要使用 File Browser

服务器上要传文件、删文件或看一眼内容时，每次都得再连 SFTP 或执行 `scp`。小团队交换文档和安装包时，也不一定要把目录放到第三方网盘。

File Browser 把指定目录做成网页。个人 VPS、家用 NAS 和内网机器上，用浏览器就能完成这些操作。它适合替代临时传文件的客户端，也适合只共享一个静态目录。需要协作编辑和版本历史时，它并不替代网盘。

## 使用 Docker 部署 File Browser

File Browser 可以用 Docker 启动，本机不必先安装它的二进制。开始之前，先准备好 Docker，并确定要交给网页管理的目录。

下面用 Docker Compose 写好运行参数，启动服务，并在浏览器里确认可以登录和上传。

## 环境要求

[v2.63.23](https://github.com/filebrowser/filebrowser/releases/tag/v2.63.23) 是上游最后计划版本，仓库归档之后不再提供安全修复。已经发布的镜像仍可拉取。本文命令使用已实测的 `v2.63.17-s6`，没有改到更新的标签。

继续使用时先记住这四条：

- 不要把端口直接暴露到公网。要对公网提供访问，放在会终止 TLS、并自行做认证的反向代理后面。
- 命令执行默认关闭，保持关闭。打开后，在网页里执行命令相当于在宿主机上拿到 Shell。
- 只挂载准备用网页管理的目录。
- 退出登录或修改密码之后，已经发出的会话在过期前仍然有效。令牌一旦泄露，在过期前仍应视为可用。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文命令按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/filebrowser` 换成 `~/docker/filebrowser` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 内存 | ≥ 256 MB（空闲约 30～50 MB） |
| CPU | 单核即可 |
| 磁盘 | ≥ 500 MB（镜像、数据库和待管理文件） |
| 端口 | 宿主机 **8080** → 容器 **80** |
| 工作目录 | `/www/wwwroot/filebrowser` |

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

## 标签怎么选

本文使用 S6 Overlay 镜像。官方安装文档把镜像分成两类：Alpine 裸镜像，以及基于 LinuxServer、带 s6-overlay 的 S6 镜像。S6 镜像用 `PUID`、`PGID` 对齐宿主机文件所有者，并挂载 `/srv`、`/database`、`/config`。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`v2.63.17-s6`** | S6 固定版本，本文实测，界面版本 **2.63.17** | **是** |
| `s6`、`v2-s6` | S6 滚动标签，会随 v2 变化 | 否 |
| `v2.63.17` | Alpine 裸镜像的固定版本，不使用 `PUID` / `PGID`，官方示例用命名卷 | 否 |
| `latest` | 浮动标签 | 否 |

上游最后计划版本是 v2.63.23（2026-07-27）。本文没有用该版本重新拉取和走一遍界面，命令保持 `v2.63.17-s6`。完整标签见[标签列表](https://xuanyuan.cloud/r/filebrowser/filebrowser/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
```

## Docker Compose 部署

网页管理的文件在容器内 `/srv`，用户数据库在 `/database/filebrowser.db`，站点配置在 `/config/settings.json`。这两个文件在首次启动时由容器生成。删除容器不会删除宿主机上这三个目录。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `srv/` | `/srv` | 网页里看到的文件根目录 |
| `database/` | `/database` | `filebrowser.db`（用户与权限） |
| `config/` | `/config` | `settings.json`（站点配置） |

只挂载准备交给网页的目录。不要把宿主机的 `/` 挂到 `/srv`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/filebrowser/{srv,database,config}
sudo chown -R "$USER":"$USER" /www/wwwroot/filebrowser
cd /www/wwwroot/filebrowser
```

2. 看当前用户的 UID 和 GID。下一步把 Compose 里的 `1000` 换成这两条命令的输出。本文这次启动的日志里是 `0`，因为当时以 root 执行。

```bash
id -u
id -g
```

3. 写入 `compose.yaml`。`8080:80` 表示宿主机 8080 对应容器内 80。

```bash
cat > compose.yaml <<'EOF'
services:
  filebrowser:
    image: docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
    container_name: filebrowser
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - ./srv:/srv
      - ./database:/database
      - ./config:/config
    environment:
      PUID: 1000
      PGID: 1000
      TZ: Asia/Shanghai
EOF
```

| 配置 | 说明 |
|------|------|
| `8080:80` | 宿主机 **8080** → 容器 **80** |
| `./srv` | 网页管理的文件 |
| `./database` | SQLite 数据库 |
| `./config` | 站点配置 |
| `PUID` / `PGID` | 改成上面 `id -u`、`id -g` 的输出，与目录所有者一致 |
| `TZ` | 时区，本文写 `Asia/Shanghai` |
| `v2.63.17-s6` | 本文实测的 S6 标签 |

4. 启动，并查看日志：

```bash
docker compose up -d
docker compose ps
docker compose logs filebrowser
```

Ubuntu 24.04 上这次启动的日志类似：

```text
[custom-init] No custom services found, skipping...
[migrations] started
[migrations] no migrations found
...
User UID:    0
User GID:    0
...
2026/06/29 13:18:38 Using config file: /config/settings.json
2026/06/29 13:18:38 WARNING: filebrowser.db can't be found. Initialing in /database/
2026/06/29 13:18:38 Using database: /database/filebrowser.db
2026/06/29 13:18:38 Performing quick setup
2026/06/29 13:18:38 User 'admin' initialized with randomly generated password: nhGDwQZh2GRG1AzM
2026/06/29 13:18:39 Listening on [::]:80
```

看这两行：

- `User 'admin' initialized with randomly generated password:` 后面是 **admin** 的初始密码。每次全新初始化都会重新生成，以你自己的日志为准。官方说明该密码只显示一次。
- `Listening on [::]:80` 表示容器内的 Web 服务已在 80 端口监听。

容器随后会写好 `config/settings.json` 和 `database/filebrowser.db`。

5. 在服务器本机探测页面：

```bash
curl -I http://127.0.0.1:8080
ls config/ database/ srv/
```

`curl` 应返回 HTTP `200` 或 `302`。

## 登录并查看主界面

浏览器打开：

```text
http://你的服务器IP:8080
```

用户名是 `admin`，密码用上一步日志里的随机字符串。

![File Browser 登录页：用户名 admin，点击蓝色「登录」按钮进入](https://img.xuanyuan.dev/docker/blog/filebrowser-1.png)

初始密码只出现在首次启动日志里。登录后到「Settings」→「Profile」修改密码，并另行保存。

登录后进入文件列表。左侧有「My files」「New folder」「Settings」。`/srv` 为空时，中间会显示「It feels lonely here...」。

![File Browser 登录后主界面：空目录与左侧导航，版本 2.63.17](https://img.xuanyuan.dev/docker/blog/filebrowser-2.png)

左下角可以看到磁盘用量（这次是 `14.9 GiB of 108 GiB used`）和版本号 **File Browser 2.63.17**。

## 新建文件夹并上传

1. 点击左侧「New folder」，输入文件夹名。这次填写的是 `testuploadfile`，再点击「CREATE」。

![File Browser 新建文件夹：输入 testuploadfile，路径预览为根目录下子文件夹](https://img.xuanyuan.dev/docker/blog/filebrowser-3.png)

2. 创建成功后，根目录下会出现该文件夹，对应宿主机 `srv/testuploadfile/`。

![File Browser 根目录：Folders 区域显示 testuploadfile 文件夹](https://img.xuanyuan.dev/docker/blog/filebrowser-4.png)

3. 在宿主机确认目录已经出现：

```bash
ls srv/testuploadfile/
```

4. 进入 `testuploadfile`，点击顶部「Upload」，选择「File」或「Folder」。

![File Browser 上传弹窗：选择 File 上传单个文件或 Folder 上传整个目录](https://img.xuanyuan.dev/docker/blog/filebrowser-5.png)

这次上传的是 `验收测试报告模板.docx`（约 27.46 KiB）。完成后，文件出现在「Files」区域。

![File Browser 文件列表：testuploadfile 目录下的 docx 文件与大小信息](https://img.xuanyuan.dev/docker/blog/filebrowser-6.png)

5. 在宿主机确认文件已经落盘：

```bash
ls srv/testuploadfile/
```

顶部工具栏可以下载、删除、重命名、移动和复制。左侧「Search」按文件名检索。页面可以在网格和列表之间切换。手机浏览器打开同一地址，也可以管理这些文件。

## 预览与下载

点击文件名进入预览。`.docx` 在浏览器里不能内嵌预览，页面会提示「Preview is not available for this file.」，可以点「DOWNLOAD」下载，或点「OPEN FILE」在新标签打开。

![File Browser 文件预览：docx 不支持内嵌预览，提供下载与打开选项](https://img.xuanyuan.dev/docker/blog/filebrowser-7.png)

图片、PDF 和文本通常可以直接在浏览器里预览。

## 备份、升级与访问范围

定期备份这三个位置：`database/filebrowser.db`（用户与权限）、`config/settings.json`、`srv/`（文件本身）。升级前至少先备份 `database/` 和 `config/`。

要换成别的标签时，先改 `compose.yaml` 里的 `image`，再执行：

```bash
cd /www/wwwroot/filebrowser
docker compose pull
docker compose up -d
```

本文没有在 v2.63.23 上重做登录和上传。界面步骤以 `v2.63.17-s6` 的实测为准。

只有确定要让 8080 从外网直接访问时，才放行端口：

```bash
sudo ufw allow 8080/tcp
```

云服务器还要在安全组放行。更稳妥的做法是 8080 只留在内网，公网走反向代理：由代理终止 TLS，并自行做一层认证。官方部署说明里，登录没有自带的暴力破解防护。本文没有配置反向代理。

登录后可以在「Settings」→「User Management」添加用户，并用 Scope 限制每人能看到的子目录。

## 备选：docker run

机器上没有 Docker Compose，或只想临时起一个容器时，用下面的命令。目录、端口和镜像与「Docker Compose 部署」相同。容器名已经是 `filebrowser` 时不要再执行，否则名称冲突。

目录还没建好时，先执行「Docker Compose 部署」里创建目录的命令。`PUID` 和 `PGID` 会取当前用户的 UID、GID。

```bash
docker run -d 
  --name filebrowser 
  --restart unless-stopped 
  -p 8080:80 
  -v /www/wwwroot/filebrowser/srv:/srv 
  -v /www/wwwroot/filebrowser/database:/database 
  -v /www/wwwroot/filebrowser/config:/config 
  -e PUID=$(id -u) 
  -e PGID=$(id -g) 
  docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6
```

然后用 `docker logs filebrowser` 读取 admin 初始密码，再用 `curl -I http://127.0.0.1:8080` 探测。

## 常见问题

**Q1：8080 端口被占用怎么办？**

把宿主机端口改成别的，容器内仍是 80。例如改成 8095 时，Compose 里写成 `"8095:80"`，再执行 `docker compose up -d`。浏览器访问 `http://服务器IP:8095`。

用 `docker run` 启动时，把 `-p 8080:80` 改成 `-p 8095:80`。

**Q2：忘记 admin 密码怎么办？**

初始密码只在首次初始化的日志里出现一次。还没改过密码、日志也找不到时，删除数据库会重新初始化，用户和权限一并丢失。确认可以丢掉这些账户之后再删。

Compose：

```bash
cd /www/wwwroot/filebrowser
docker compose down
rm database/filebrowser.db
docker compose up -d
docker compose logs filebrowser
```

当时用 `docker run` 启动的：

```bash
docker stop filebrowser && docker rm filebrowser
rm /www/wwwroot/filebrowser/database/filebrowser.db
```

删完后再执行「备选：docker run」里的命令，并从新日志读取密码。已经改过密码、又要保留现有用户时，本文不另给重置步骤。登录成功后请立刻改密并另行保存。

**Q3：上传之后宿主机上看不到文件？**

先确认网页里的路径是不是挂到宿主机 `srv/`。

```bash
docker inspect filebrowser
```

在 Mounts 里核对容器内 `/srv` 的来源。再核对 `PUID`、`PGID` 是否与目录所有者一致。不一致时，写入可能会失败。

**Q4：日志里出现 `usermod: user abc is currently used by process 1`？**

这是 S6 镜像初始化时的常见提示。日志末尾有 `Listening on [::]:80` 时，File Browser 已经起来了，这条提示不妨碍使用。

**Q5：如何升级？**

升级前备份 `database/` 和 `config/`。本文命令里的标签是 `v2.63.17-s6`。要换标签，先改 `compose.yaml` 的 `image`，再执行：

```bash
cd /www/wwwroot/filebrowser
docker compose pull
docker compose up -d
```

用 `docker run` 启动的，拉取新标签后执行 `docker stop filebrowser && docker rm filebrowser`，再按「备选：docker run」启动。三个目录的路径保持不变。

**Q6：和 Docker Hub 上的镜像是什么关系？**

本文使用的 `filebrowser/filebrowser:v2.63.17-s6` 与 Docker Hub 上的同名标签是同一份镜像，通过轩辕镜像加速拉取。卷、端口和初始密码的行为见[官方安装文档](https://github.com/filebrowser/filebrowser/blob/v2.63.23/docs/installation.md)。

**Q7：可以管理多个目录吗？**

默认用户的范围是 `/srv`。在「Settings」→「User Management」里可以为不同用户设置 Scope，把可见范围限制在子目录。调整 `settings.json` 里的根路径后需要重启容器。

**Q8：如何停止与卸载？**

确认不再需要这些文件之前，不要删除数据目录。

Compose 停止并保留 `srv/`、`database/`、`config/`：

```bash
cd /www/wwwroot/filebrowser
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop filebrowser && docker rm filebrowser
```

文件和账户都不再需要时，再删除整个目录：

```bash
rm -rf /www/wwwroot/filebrowser
```

**Q9：容器起来了，浏览器打不开？**

按这个顺序看：

1. `docker ps` 里容器是否为 Up。
2. `docker logs filebrowser` 末尾是否有 `Listening on [::]:80`，以及有没有报错。
3. 在服务器上执行 `curl -I http://127.0.0.1:8080`，看本机是否通。
4. 本机通、外网不通时，再检查云服务器安全组和本机防火墙是否放行了你映射的端口。

**Q10：自助注册为什么不要直接打开？**

官方部署文档允许在「Settings」→「Global Settings」打开自助注册。默认用户范围是服务根目录。不改范围就打开时，新注册用户可以读写网页里的全部文件。要打开的话，先让每人使用自己的目录，或把默认范围改到根目录以外。本文没有打开这项。

**Q11：退出登录之后，旧会话还有效吗？**

有效，直到该令牌过期。修改密码也不会立刻作废已经发出的会话。令牌泄露后，在过期前仍应视为可用。这也是不要把服务直接暴露到公网的原因之一。

## 命令速查

```bash
docker pull docker.xuanyuan.run/filebrowser/filebrowser:v2.63.17-s6

cd /www/wwwroot/filebrowser
docker compose up -d
docker compose ps
docker compose logs filebrowser
curl -I http://127.0.0.1:8080

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8080`。用户名是 `admin`，密码在首次启动日志里。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [filebrowser/filebrowser 镜像页](https://xuanyuan.cloud/zh/r/filebrowser/filebrowser) | [https://xuanyuan.cloud/zh/r/filebrowser/filebrowser](https://xuanyuan.cloud/zh/r/filebrowser/filebrowser) |
| [filebrowser/filebrowser 概览](https://xuanyuan.cloud/r/filebrowser/filebrowser) | [https://xuanyuan.cloud/r/filebrowser/filebrowser](https://xuanyuan.cloud/r/filebrowser/filebrowser) |
| [filebrowser/filebrowser 标签列表](https://xuanyuan.cloud/r/filebrowser/filebrowser/tags) | [https://xuanyuan.cloud/r/filebrowser/filebrowser/tags](https://xuanyuan.cloud/r/filebrowser/filebrowser/tags) |
| [Docker Hub · filebrowser/filebrowser](https://hub.docker.com/r/filebrowser/filebrowser) | [https://hub.docker.com/r/filebrowser/filebrowser](https://hub.docker.com/r/filebrowser/filebrowser) |
| [GitHub · filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [https://github.com/filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) |
| [Release v2.63.23](https://github.com/filebrowser/filebrowser/releases/tag/v2.63.23) | [https://github.com/filebrowser/filebrowser/releases/tag/v2.63.23](https://github.com/filebrowser/filebrowser/releases/tag/v2.63.23) |
| [安装文档](https://github.com/filebrowser/filebrowser/blob/v2.63.23/docs/installation.md) | [https://github.com/filebrowser/filebrowser/blob/v2.63.23/docs/installation.md](https://github.com/filebrowser/filebrowser/blob/v2.63.23/docs/installation.md) |
| [部署文档](https://github.com/filebrowser/filebrowser/blob/v2.63.23/docs/deployment.md) | [https://github.com/filebrowser/filebrowser/blob/v2.63.23/docs/deployment.md](https://github.com/filebrowser/filebrowser/blob/v2.63.23/docs/deployment.md) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/filebrowser-docker-deploy



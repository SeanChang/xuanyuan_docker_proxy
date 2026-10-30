# Docker 部署 EmulatorJS：轻松搭建浏览器复古游戏平台

![Docker 部署 EmulatorJS：轻松搭建浏览器复古游戏平台](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs.webp)

*分类: Docker部署教程 | 标签: EmulatorJS,linuxserver/emulatorjs,Docker,轩辕镜像,复古游戏,私有化部署,部署教程 | 发布时间: 2026-10-29 12:13:43*

> EmulatorJS 是一款面向自建游戏收藏的开源浏览器前端，旨在把红白机、超任等主机的游戏整理成网页目录，并通过浏览器里的模拟器直接游玩。本文将介绍如何通过 Docker Compose 部署 linuxserver/emulatorjs，搭建浏览器复古游戏平台，帮助你在自己的电脑上管理游戏文件并用网页打开，适合家庭局域网及个人复古游戏收藏等场景。

## EmulatorJS 是什么

LinuxServer.io 维护的 linuxserver/emulatorjs 把复古游戏收成一个网页。管理界面用来扫描游戏文件、匹配封面和生成菜单，游戏页面在访问者的浏览器里运行，电脑、手机或装了 Chromium 浏览器的设备打开网址就能玩。

与 emulatorjs.com 上持续开发的 EmulatorJS 不同，这个容器是 LinuxServer 做的自托管前端，模拟核心主要来自 Libretro。LinuxServer 已于 2025 年 6 月 11 日停止维护该镜像，不再提供支持，也不再发布新版本。

## EmulatorJS 能做什么

- **在浏览器里玩游戏**：打开游戏页面后，用键盘、鼠标或手柄选择并运行游戏。
- **按主机分目录**：红白机、超任、街机等各自一个目录，扫描后写入菜单。
- **带上封面和视频**：已经识别的游戏可以下载标志、背景和演示视频。
- **游戏在浏览器里跑**：模拟在访问者的网页里执行，容器负责菜单和文件。
- **管理界面和游戏页面分开**：一边扫描、下封面，一边在另一个页面里选游戏。

## 为什么要使用 EmulatorJS

每换一台电脑都要再装模拟器，手机上也进不去。游戏若只放在别人的网站上，网站关掉就打不开，文件也不在自己的磁盘里。

这个容器把扫描、封面和菜单留在宿主机上，打开网页就能玩。适合已经有自己的游戏文件、想在局域网里用浏览器玩的人。

镜像已经停止更新，适合收藏不再增加、只想把现有文件放进浏览器的情况。还要持续收到新版本时，见「常见问题」里的替代项目。

## 使用 Docker 部署 EmulatorJS

用 Docker 跑这个前端，宿主机不用再单独安装 Node.js、Nginx 和 IPFS。开始之前准备好 Docker，以及你有权使用的游戏文件。

接下来用 Docker Compose 写好数据目录和端口，启动服务，再在浏览器里下载默认文件、放入游戏并打开游戏页面。

## 环境要求

本文命令使用 **`linuxserver/emulatorjs:1.9.2`**。这是停止维护前的最后版本，标签记录的推送时间是 2025-06-09。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/emulatorjs` 换成 `~/docker/emulatorjs`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64**。armhf 已在 2023 年停止提供 |
| 磁盘 | 标签记录里 amd64 压缩体积约 272 MB，arm64 约 269 MB。游戏文件、封面和 IPFS 数据另算 |
| 端口 | 宿主机 **13300** → 容器 **3000**（管理界面）。宿主机 **8080** → 容器 **80**（游戏页面） |
| 工作目录 | `/www/wwwroot/emulatorjs` |
| 数据目录 | `config/` 对应容器内 `/config`，只放手柄和显示档案。游戏、封面、菜单 JSON 和 IPFS 都在 `data/`，菜单文件是 `data/config/arcade.json` 这一类，不要放进 `config/` |
| 账号 | 管理界面没有登录，只在局域网使用 |

```text
浏览器
  ├─ 宿主机 13300 → 容器 3000   管理界面：扫描、封面、菜单
  └─ 宿主机 8080  → 容器 80     游戏页面：选游戏、游玩
            │
            ▼
  ./config → /config    手柄与显示档案
  ./data   → /data      游戏、封面、菜单 JSON、IPFS
```

游戏在打开网页的那台设备上运行。管理页写明，非光盘主机在手机上一般可以玩；完整光盘游戏需要较大内存，手机和游戏主机浏览器通常带不动。第一次下载默认封面时，容器要能访问外网。

管理界面没有登录。**13300** 和 **8080** 只给局域网使用。

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=emulatorjs-docker-deploy)。

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

[标签列表](https://xuanyuan.cloud/r/linuxserver/emulatorjs/tags?xy_from=emulatorjs-docker-deploy) 上，`1.9.2`、`version-1.9.2` 和 `1.9.2-ls173` 是 2025-06-09 的同一份镜像。拉取输出里的 Digest 是这份多架构索引，不要拿它和单架构标签的摘要逐字对比。`amd64-1.9.2` 和 `arm64v8-1.9.2` 各只含一种架构，只有必须指定架构时才用。

LinuxServer 的停止维护说明写明，弃用之后不能再拉取 `latest`，以及 `develop`、`nightly` 这类分支标签，需要使用具体版本。下面的命令使用 **`1.9.2`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`1.9.2`** | 2025-06-09 这份具体版本，含 amd64 与 arm64 | **是** |
| `version-1.9.2` | 与 `1.9.2` 同一份镜像的另一种写法 | 否 |
| `1.9.2-ls173` | 同一次 CI 构建 | 否 |
| `amd64-1.9.2` / `arm64v8-1.9.2` | 只含一种架构 | 必须指定架构时再用 |
| `latest` / `amd64-latest` / `arm64v8-latest` | 浮动标签 | 否 |

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=emulatorjs-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/linuxserver/emulatorjs:1.9.2
```

Ubuntu 24.04 实测：

```text
1.9.2: Pulling from linuxserver/emulatorjs
d8e8df0cf819: Pull complete
293fa8c1bfff: Pull complete
c0f8eff906b8: Pull complete
2a6a7e2d8be8: Pull complete
bffbd6212769: Pull complete
0e152a8e12f7: Pull complete
75dee0b5a4da: Pull complete
9f8512f323d5: Pull complete
b169408915cf: Pull complete
8d1db2ff85db: Pull complete
2c8916db4a9b: Pull complete
c816e7f9dd77: Download complete
267f6d22fa54: Download complete
Digest: sha256:b7003f7d4f383dd32d210ba08f24c840276fdf92c211bd18a798d47647311290
Status: Downloaded newer image for docker.xuanyuan.run/linuxserver/emulatorjs:1.9.2
docker.xuanyuan.run/linuxserver/emulatorjs:1.9.2
```

完成后，再写下面的 Compose。

## Docker Compose 部署

游戏和封面在宿主机目录 `data/`，对应容器内 `/data`。配置档案在 `config/`，对应容器内 `/config`。`docker compose down` 不加额外参数时，不会删除这两个目录。

容器内管理界面监听 **3000**，游戏页面监听 **80**。本文把宿主机 **13300** 映到容器 **3000**，把宿主机 **8080** 映到容器 **80**。宿主机 **3000** 常被本机前端开发占用；宿主机 **80** 常被已有网站占用。管理页上若仍写端口 3000 或 80，按本文的宿主机端口访问。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。这一步不删除 `config/` 和 `data/`。

1. 确认宿主机 **13300** 和 **8080** 没有被占用：

```bash
ss -tlnp | grep -E ':8080|:13300' || true
```

Ubuntu 24.04 上这条命令没有输出，说明 **8080** 和 **13300** 都空着。有输出时，把后面 Compose 里对应的左侧端口改成空闲端口，访问时改用新的宿主机端口。

2. 创建目录，并把所有权交给 `1000:1000`。容器默认以这个用户读写 `config/` 和 `data/`。

```bash
sudo mkdir -p /www/wwwroot/emulatorjs/{config,data}
sudo chown -R 1000:1000 /www/wwwroot/emulatorjs
```

`id` 不是 1000 时，把这里的数字和 Compose 里的 `PUID`、`PGID` 改成同一个用户。macOS 使用：

```bash
mkdir -p ~/docker/emulatorjs/{config,data}
cd ~/docker/emulatorjs
```

同名容器还在时：

```bash
docker rm -f emulatorjs
```

3. 写入 `compose.yaml`：

```bash
cd /www/wwwroot/emulatorjs
cat > compose.yaml <<'EOF'
name: emulatorjs

services:
  emulatorjs:
    image: docker.xuanyuan.run/linuxserver/emulatorjs:1.9.2
    container_name: emulatorjs
    restart: unless-stopped
    environment:
      PUID: "1000"
      PGID: "1000"
      TZ: "Asia/Shanghai"
    ports:
      - "13300:3000"
      - "8080:80"
    volumes:
      - ./config:/config
      - ./data:/data
EOF
```

4. 启动：

```bash
docker compose up -d
```

5. 查看状态。`STATUS` 为 running 后，再打开浏览器。容器马上退出时，用日志看原因，常见情况是端口已被占用，或 `data/` 没有写权限。

```bash
docker compose ps
docker compose logs --tail 80 emulatorjs
```

Ubuntu 24.04 实测，`up -d` 后容器保持运行，日志里能看到 UID **1000** 和 IPFS 初始化：

```text
[+] up 2/2
 ✔ Network emulatorjs_default Created
 ✔ Container emulatorjs       Started

NAME         IMAGE                                              COMMAND   SERVICE      CREATED         STATUS         PORTS
emulatorjs   docker.xuanyuan.run/linuxserver/emulatorjs:1.9.2   "/init"   emulatorjs   5 seconds ago   Up 3 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp, 0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp

[migrations] started
[migrations] no migrations found
User UID:    1000
User GID:    1000
initializing IPFS node at /data/.ipfs
Initializing daemon...
Kubo version: 0.24.0
Repo version: 15
System version: amd64/linux
Golang version: go1.21.10
```

## 浏览器里整理游戏

游戏文件涉及版权。本文实测只用 MAME 官方提供的 [Circus](https://www.mamedev.org/roms/circus/)（Exidy，1977）。权利人 H.R. Kauffman 允许把这份 ROM 用于免费、非商业用途，下载前页面要求勾选确认。其他游戏请自行确认你有权使用后再放入对应目录。本文不提供商业游戏的下载地址。

管理界面地址是 `http://服务器IP:13300`。顶部有 Rom Management、Config Management、File Management、Profile Management、Custom Metadata。

1. 打开 `http://服务器IP:13300`。页面写着 Please Download the default fileset to begin 时，点「Download」。

![EmulatorJS 管理界面首次打开：Please Download the default fileset to begin，中间是 Download 按钮](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-1.webp)

容器要能访问外网。点下去之后会弹出下载列表，条目从 Downloading 变成 Downloaded。滚到列表顶部，出现 Downloaded All Files 就可以进行下一步。第一次没有文件落下时，等页面能刷新后再点一次「Download」。

![EmulatorJS 正在下载默认素材：列表里是各主机视频，可见 segaMD.mp4 与 nds.mp4](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-2.webp)

![EmulatorJS 默认素材下载完成：顶部 Downloaded All Files，列表中有 bios 和 prboom.wad](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-3.webp)

2. 打开「Rom Management」。还没放入游戏时，页面写 No roms found please add some to continue。旁边的 Default 卡片是封面素材，Available 275，Downloaded 还是 0。这张图就是还没点「DL/Update」的样子。

![EmulatorJS 的 Rom Management：还没有游戏，Default 显示 Available 275、Downloaded 0](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-4.webp)

先点这张卡片上的「DL/Update」，把 275 项素材下完。下完后的数字出现在后面的扫描截图里，Downloaded 变成 275。

下面四页这次都不用改，对照一下即可。

「Config Management」左侧是主机名，右侧是该主机的 JSON。图中打开的是 3do，`items` 还是空的，右上角是「Save」。这不是 Circus 的配置。

![EmulatorJS 的 Config Management：左侧主机列表，右侧打开 3do 的 JSON，右上角 Save](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-5.webp)

「File Management」能看到「Download」建好的目录。以 3do 为例，下面有 `backgrounds`、`bios`、`corners`、`roms`，属主是 `abc`。

![EmulatorJS 的 File Management：打开 /3do/，列出 backgrounds、bios、corners、roms](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-6.webp)

「Profile Management」里已经有 default。图中用户名和密码是空的，本文没有新建档案，Circus 用 default 进入。这里的账号不是管理界面的登录。

![EmulatorJS 的 Profile Management：已有 default，右侧是 username、password 和 Create Profile](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-7.webp)

Custom Metadata 这时还是说明文字。以后若手动给游戏补了封面或名称，才会出现在左侧。

![EmulatorJS 的 Custom Metadata：说明自定义封面和名称会记在容器里](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-8.webp)

3. 打开 [Circus 的 MAME 官方页面](https://www.mamedev.org/roms/circus/)，勾选非商业使用确认后再下载。把得到的压缩包保存为 `circus.zip`，放到街机目录：

```text
/www/wwwroot/emulatorjs/data/arcade/roms/circus.zip
```

容器内同一位置是 `/data/arcade/roms/circus.zip`。拷进目录之后把所有权交回 `1000:1000`，扫描进程才能读到：

```bash
sudo chown -R 1000:1000 /www/wwwroot/emulatorjs/data
```

「File Management」打开 `/arcade/roms/`，能看到 `circus.zip`，约 6 KB，属主 `abc`。

![EmulatorJS 的 File Management：/arcade/roms/ 里有 circus.zip，约 6 KB，属主 abc](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-9.webp)

4. 回到「Rom Management」，点左侧的 arcade，再点卡片上的「Scan」。扫完后这张卡片是 Roms 1、Scanned 1，Default 的 Downloaded 是 275。街机按 zip 文件名识别，`circus.zip` 对上的就是 Circus。

![EmulatorJS 的 Rom Management：arcade 显示 Roms 1、Scanned 1，Default 已下载 275，按钮是 Scan 和 DL/Update](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-10.webp)

同一页往下的 Rom Identification basics 写着后续三步：从左侧打开这一项，为已识别的游戏下载封面，再把游戏写入该主机的配置。菜单写在宿主机的 `data/config/arcade.json`。这个文件在 `data/` 里，不是上面的 `config/` 档案目录。

你自己另有合法来源的游戏，按下面的目录名放进对应的 `roms`。红白机是 `/www/wwwroot/emulatorjs/data/nes/roms/`。

| 目录 | 主机 |
|------|------|
| `nes` | 红白机 / NES |
| `snes` | 超任 / SNES |
| `gb` | Game Boy |
| `gbc` | Game Boy Color |
| `gba` | Game Boy Advance |
| `n64` | Nintendo 64 |
| `nds` | Nintendo DS |
| `segaMS` | Master System |
| `segaMD` | Mega Drive / Genesis |
| `segaGG` | Game Gear |
| `segaCD` | Sega CD |
| `segaSaturn` | Saturn |
| `segaSG` | SG-1000 |
| `sega32x` | Sega 32X |
| `psx` | PlayStation |
| `pce` | PC Engine / TurboGrafx-16 |
| `arcade` | 街机 |
| `atari2600` | Atari 2600 |
| `atari5200` | Atari 5200 |
| `atari7800` | Atari 7800 |
| `lynx` | Atari Lynx |
| `jaguar` | Atari Jaguar |
| `colecovision` | ColecoVision |
| `odyssey2` | Odyssey² |
| `msx` | MSX |
| `ngp` | Neo Geo Pocket |
| `ws` | WonderSwan |
| `vb` | Virtual Boy |
| `vectrex` | Vectrex |
| `3do` | 3DO |
| `doom` | Doom |

`sega32x` 目录可以放文件。管理页写明，32X 目前没有可分发的可用核心。

卡带可以放 zip，也可以放解压后的 ROM。NES 用带文件头的 `.nes`，N64 用大端 `.z64`，PlayStation 优先用 CHD。对不上名录的文件会留在未识别列表里，在左侧打开该主机后手动填名称。规则的全文在管理页的 Rom Identification 里。

## 打开游戏并操作

游戏页面地址是 `http://服务器IP:8080`。配置写完后，这里是街机菜单：左侧是机台，右侧是 ARCADE。机台屏幕上的画面是菜单装饰，还不是 Circus 的游戏画面。

![EmulatorJS 游戏页面：左侧街机机台，右侧彩色字 ARCADE](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-11.webp)

点进 Circus 之后才是游戏。标题画面写着 PLAYER ONE JUMPS PLAYER TWO，下面是跷跷板和小人。这是转盘操作的街机，在浏览器里用鼠标在画面上移动即可试玩。

![EmulatorJS 中的 Circus：标题画面写着 PLAYER ONE JUMPS PLAYER TWO，下方是跷跷板和小人](https://imgs.xuanyuan.cloud/docker/blog/emulatorjs/emulatorjs-12.webp)

用键盘方向键或手柄在菜单里移动。Libretro 核心的游戏内菜单可以用键盘 **F1** 打开；手柄上同时按 Start、Select、L、R 也能打开。触屏时用左上角的按钮。

存档和部分设置写在**当前这个网址**下的浏览器里，不在容器磁盘上。离开游戏时用页面上的返回，让 SRAM 有机会写回浏览器。直接关掉标签，这次进度可能还留在内存里。以后如果改了主机名或端口，浏览器会把它当成另一个网址，原来的存档不会跟着走。

Chromium 系浏览器（Chrome、Edge、Brave）是管理页推荐的选择。Apple 设备使用 Safari，并从 Safari 添加到主屏幕后再打开，以获得全屏。管理页写明 Firefox 的手柄不可用。

## 访问范围和可选设置

管理界面没有登录。打开 13300 的人可以上传文件、扫描目录和改菜单，8080 会把 `data/` 里的游戏交给浏览器。两处只在局域网使用。放到云服务器上时，安全组只放行你自己的地址。

封面收集完成后，如果不再下载素材，可以停掉容器内的 IPFS。在 `compose.yaml` 的 `environment` 里增加 `DISABLE_IPFS: "true"`，然后执行 `docker compose up -d`。第一次 Download 还没完成时不要加这项，默认封面依赖 IPFS。

端口 **4001** 是 IPFS 互连端口。本文默认不发布它。只有你打算把封面继续分发给别人时，才考虑把它映出来，并只对需要的来源放行。

已经有一整套游戏目录、只想只读挂进容器时，在 `compose.yaml` 的 `volumes:` 里、`./data:/data` 下面加一行。红白机示例：

```yaml
      - /path/to/nes/roms:/roms/nes:ro
```

`/path/to/nes/roms` 里直接放游戏文件。容器启动时会把这个目录链接到 `/data/nes/roms`。改完后执行 `docker compose up -d`。`data/nes/roms` 里已经有别的文件、并且还不是链接时，先移走那些文件再启动，链接才会建上。

反向代理要挂在子路径下时，设置 `SUBFOLDER`，值为带首尾斜杠的路径，例如 `/emu/`。默认不需要这项。

Nintendo DS 和 Saturn 的线程版核心需要 HTTPS。管理页写明，要把站点放到带证书的反向代理后面，再把配置里的模拟器改成 `libretro-melonds_threaded` 或 `libretro-yabause_threaded`。普通 HTTP 使用默认核心即可。

容器内的静态页面在 `/emulatorjs/frontend`，其中 `user` 指向 `/data`。整理完成后，官方说明允许把这组文件拷到别的网站上托管；拷贝时要连同游戏和封面一起考虑，因为页面通过这个链接读取 `/data`。

## 备选：docker run

没有 Compose 时用这一节。目录、端口和镜像与上面相同。Compose 已经在跑时，先到工作目录执行 `docker compose down`，再跑下面的命令，避免容器名和端口冲突。

```bash
docker rm -f emulatorjs
docker run -d 
  --name emulatorjs 
  --restart unless-stopped 
  -e PUID=1000 
  -e PGID=1000 
  -e TZ=Asia/Shanghai 
  -p 13300:3000 
  -p 8080:80 
  -v /www/wwwroot/emulatorjs/config:/config 
  -v /www/wwwroot/emulatorjs/data:/data 
  docker.xuanyuan.run/linuxserver/emulatorjs:1.9.2
```

macOS 把两处 `/www/wwwroot/emulatorjs` 换成 `~/docker/emulatorjs`。

查看状态：

```bash
docker ps --filter name=emulatorjs
docker logs --tail 80 emulatorjs
```

然后打开 `http://服务器IP:13300` 下载默认文件，再打开 `http://服务器IP:8080` 游玩。

停掉并删除容器，保留游戏文件：

```bash
docker stop emulatorjs && docker rm emulatorjs
```

## 常见问题

**Q1：`latest` 拉不下来？**

LinuxServer 已于 2025 年 6 月 11 日弃用这个镜像。停止维护说明写明，弃用之后不能再拉取 `latest` 和 `develop`、`nightly` 这类分支标签。本文命令使用 `1.9.2`。

**Q2：这和 emulatorjs.com 是同一个项目吗？**

linuxserver/emulatorjs 是 LinuxServer 的自托管前端，模拟核心主要来自 Libretro。emulatorjs.com 上的 EmulatorJS 是另一套仍在开发的浏览器模拟器。两边的镜像、端口和配置各自独立，不能拿这份 Compose 去启动另一套。

**Q3：为什么访问地址是 13300 和 8080？**

容器内仍然是 **3000** 和 **80**。宿主机改成 **13300** 和 **8080**，是为了避开本机前端常用的 3000，以及已经占用 80 的网站。管理页上的说明仍按容器端口来写，打开时换成本文的宿主机端口。

**Q4：管理界面打不开？**

先看 `docker compose ps` 是否为 running。马上退出时看 `docker compose logs --tail 80 emulatorjs`。端口已被占用时，改 Compose 左侧端口后执行 `docker compose up -d`。日志停在 IPFS 初始化时，再看 `data/` 的属主是不是 `PUID` 里的用户；不是的话交给 `1000:1000` 后重新启动。

**Q5：Download 之后 `data/` 仍是空的？**

默认素材走容器内的 IPFS，容器要能访问外网。管理页写明可以多点几次「Download」，已有的文件会走本地 IPFS，缺少的会重试。`DISABLE_IPFS` 已经设上时，先删掉这项并重新启动，再下载。

**Q6：扫描不到游戏？**

文件放在 `/data/<目录名>/roms/`，目录名在前，`roms` 在后。本文的 Circus 在 `/data/arcade/roms/circus.zip`。拷贝之后执行 `chown -R 1000:1000`，再在「Rom Management」里点该主机的「Scan」。

**Q7：别的游戏从哪里下载？**

本文只给出 MAME 官方、权利人允许非商业使用的 [Circus](https://www.mamedev.org/roms/circus/)。其他游戏请自行寻找你有权使用的文件，再放到正文目录表里对应的 `roms`。

**Q8：很多游戏显示未识别？**

识别依赖文件校验和，对照的是 No-Intro、Redump 一类名录。改版、汉化或文件头不同的 ROM 对不上。在左侧打开该主机，手动关联到正确名称，再下载封面并写入配置。

**Q9：存档找不到了？**

存档写在浏览器里，并且跟当时的完整网址绑定。换了 IP、端口或浏览器，就会变成另一份存档。离开游戏时用返回，不要直接关标签。

**Q10：手机上光盘游戏进不去？**

管理页写明，完整光盘游戏需要较大内存，手机和主机浏览器通常带不动。非光盘主机更适合这些设备。N64 同样吃内存。

**Q11：如何升级？**

这个镜像已经停止更新，没有比 `1.9.2` 更新的版本。保持 Compose 里的 `1.9.2`。不要改成 `latest`。

**Q12：还有哪些仍在维护的选择？**

LinuxServer 在停止维护说明里给出了三个方向：[RomM](https://github.com/rommapp/romm)、[Gaseous Server](https://github.com/gaseous-project/gaseous-server)、[webRcade](https://github.com/webrcade/webrcade)。它们的目录结构和端口与本文不同，不能沿用这份 Compose。

**Q13：如何停止？**

还要保留游戏和封面时，不要删除 `config/` 和 `data/`。

```bash
cd /www/wwwroot/emulatorjs
docker compose down
```

这套收藏不再需要时，再删除工作目录：

```bash
rm -rf /www/wwwroot/emulatorjs
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/linuxserver/emulatorjs:1.9.2

cd /www/wwwroot/emulatorjs
docker compose up -d
docker compose ps
docker compose logs --tail 80 emulatorjs
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。管理界面是 `http://服务器IP:13300`，游戏页面是 `http://服务器IP:8080`。本文实测的 `circus.zip` 在 `data/arcade/roms/`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [linuxserver/emulatorjs 镜像页](https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs?xy_from=emulatorjs-docker-deploy) | [https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs](https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs?xy_from=emulatorjs-docker-deploy) |
| [linuxserver/emulatorjs 概览](https://xuanyuan.cloud/r/linuxserver/emulatorjs?xy_from=emulatorjs-docker-deploy) | [https://xuanyuan.cloud/r/linuxserver/emulatorjs](https://xuanyuan.cloud/r/linuxserver/emulatorjs?xy_from=emulatorjs-docker-deploy) |
| [linuxserver/emulatorjs 标签列表](https://xuanyuan.cloud/r/linuxserver/emulatorjs/tags?xy_from=emulatorjs-docker-deploy) | [https://xuanyuan.cloud/r/linuxserver/emulatorjs/tags](https://xuanyuan.cloud/r/linuxserver/emulatorjs/tags?xy_from=emulatorjs-docker-deploy) |
| [LinuxServer 文档](https://docs.linuxserver.io/deprecated_images/docker-emulatorjs/) | [https://docs.linuxserver.io/deprecated_images/docker-emulatorjs/](https://docs.linuxserver.io/deprecated_images/docker-emulatorjs/) |
| [停止维护说明](https://info.linuxserver.io/issues/2025-06-11-emulatorjs/) | [https://info.linuxserver.io/issues/2025-06-11-emulatorjs/](https://info.linuxserver.io/issues/2025-06-11-emulatorjs/) |
| [GitHub · linuxserver/docker-emulatorjs](https://github.com/linuxserver/docker-emulatorjs) | [https://github.com/linuxserver/docker-emulatorjs](https://github.com/linuxserver/docker-emulatorjs) |
| [GitHub · linuxserver/emulatorjs](https://github.com/linuxserver/emulatorjs) | [https://github.com/linuxserver/emulatorjs](https://github.com/linuxserver/emulatorjs) |
| [Docker Hub · linuxserver/emulatorjs](https://hub.docker.com/r/linuxserver/emulatorjs) | [https://hub.docker.com/r/linuxserver/emulatorjs](https://hub.docker.com/r/linuxserver/emulatorjs) |
| [MAME 官方 Circus ROM（非商业）](https://www.mamedev.org/roms/circus/) | [https://www.mamedev.org/roms/circus/](https://www.mamedev.org/roms/circus/) |
| [RomM](https://github.com/rommapp/romm) | [https://github.com/rommapp/romm](https://github.com/rommapp/romm) |
| [Gaseous Server](https://github.com/gaseous-project/gaseous-server) | [https://github.com/gaseous-project/gaseous-server](https://github.com/gaseous-project/gaseous-server) |
| [webRcade](https://github.com/webrcade/webrcade) | [https://github.com/webrcade/webrcade](https://github.com/webrcade/webrcade) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=emulatorjs-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=emulatorjs-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/emulatorjs-docker-deploy?xy_from=emulatorjs-docker-deploy)

*本文基于 [linuxserver/emulatorjs:1.9.2](https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs?xy_from=emulatorjs-docker-deploy)，以 **1.9.2** 版本实测，容器内 IPFS **Kubo 0.24.0**，测试平台 **Ubuntu 24.04** Linux。*



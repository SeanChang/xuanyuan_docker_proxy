# Docker 部署 TinyGo：轻松搭建嵌入式与 WebAssembly 编译环境

![Docker 部署 TinyGo：轻松搭建嵌入式与 WebAssembly 编译环境](https://imgs.xuanyuan.cloud/docker/blog/tinygo/tinygo.webp)

*分类: Docker部署教程 | 标签: TinyGo,tinygo/tinygo,Docker,轩辕镜像,嵌入式,WebAssembly,编译环境,部署教程 | 发布时间: 2026-11-02 20:11:50*

> TinyGo 是一款基于 LLVM 的 Go 编译器，旨在把 Go 程序编成体积更小的二进制，面向微控制器、WebAssembly 和命令行工具。本文将介绍如何通过 Docker Compose 部署 TinyGo，搭建嵌入式与 WASM 编译环境，帮助开发者在容器里完成固件和模块构建，适合不想在本机安装整套 LLVM 依赖，以及要在持续集成里固定编译器版本的场景。

## TinyGo 是什么

TinyGo 是基于 LLVM 的 Go 编译器，面向微控制器、WebAssembly 和命令行工具。它把 Go 源码编成体积更小的程序，可以在 Arduino、Adafruit、Nordic、Espressif 等板上运行，也可以生成给浏览器或 WASI 运行时使用的 WebAssembly。

和本机安装完整 Go、再单独装一套 LLVM 与板级工具链相比，官方 Docker 镜像把 TinyGo、配套 Go 和编译依赖放进同一环境。宿主机不必再保证这些组件版本一致。标准 Go 工具链面向服务器与桌面程序；TinyGo 面向板子、WASM 和体积更敏感的程序。

## TinyGo 能做什么

- **编译微控制器固件**：把 Go 源码编成面向 Arduino、Circuit Playground Express 等目标板的程序文件。
- **生成浏览器 WebAssembly**：编出可在页面里加载的 `.wasm`。
- **生成 WASI 模块**：编出给边缘与服务器 WASM 运行时使用的模块。
- **反复编译挂载目录里的源码**：源码和产物留在本机目录，改完可以再编译。
- **查看编译器与目标信息**：确认当前镜像里的 TinyGo 版本、默认目标和已支持的板型。

## 为什么要使用 TinyGo

在每台电脑上安装 TinyGo 时，要处理 LLVM、Go 版本和板级依赖。Windows、macOS 和 Linux 的安装路径经常不一致。持续集成里每台构建机再装一遍，编译器版本会跟着安装时间变化。

拉取镜像之后，宿主机不必安装 TinyGo 和 LLVM，也可以在容器里编出固件或 `.wasm`。适合写嵌入式 Go 或 WebAssembly、又不想在每台机器上维护整套依赖的人。

## 使用 Docker 部署 TinyGo

Docker 可以把这套编译环境跑起来。部署前准备好 Docker，并准备好要编译的源码。这个镜像没有网页，编译是否完成要看目录里的产物文件。

接下来用 Docker Compose 挂载源码目录，让容器留在后台，再在容器里完成编译。

## 环境要求

本文命令使用标签 **`0.44.0`**。这次在 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）上拉取并启动。容器内显示 **tinygo version 0.44.0 linux/amd64**，配套 **go 1.27.3**、**LLVM 22.1.4**。

镜像以 `debian:stable-slim` 为底，默认用户是 **tinygo**（实测 **uid 1000 / gid 1000**），工作目录是 `/home/tinygo`，入口命令是 `tinygo`。Docker Hub 上 **linux/amd64** 压缩体积约 **382.72 MB**，**linux/arm64** 约 **369.96 MB**。解压后的占用比压缩体积大，拉取前确认磁盘有富余空间。镜像不监听端口。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/tinygo` 换成 `~/docker/tinygo` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 磁盘 | 至少能放下上述压缩体积，并留出解压、源码和产物的空间 |
| 端口 | 不映射。没有网页 |
| 工作目录 | `/www/wwwroot/tinygo` |
| 目录权限 | 写入源码前，`src/` 交给当前用户；编译前再交给容器用户 **tinygo** 的 uid/gid |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=tinygo-docker-deploy)。

## 标签怎么选

新安装使用 **`0.44.0`**。官方安装文档与 Docker Hub 当前发行标签一致。`latest` 与同日推送的 `0.44.0` 目前指向同一份镜像索引；下次发版后，`latest` 会改指向，`0.44.0` 仍是这一版。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`0.44.0`** | 当前发行版，amd64 与 arm64 | **是** |
| `latest` | 浮动标签，目前与 `0.44.0` 相同 | 否 |
| `0.43.0`、`0.42.0` 及更早 | 更早的发行版 | 否。项目必须使用更早版本时再改，并同时改拉取命令、`compose.yaml` 和 `docker run` |
| `sha-…` | 按提交哈希标记的构建 | 否 |
| `tinygo/tinygo-dev:latest` | 开发分支镜像，另一仓库 | 否 |

完整标签见 [标签列表](https://xuanyuan.cloud/r/tinygo/tinygo/tags?xy_from=tinygo-docker-deploy)。这一版的发布页是 [v0.44.0](https://github.com/tinygo-org/tinygo/releases/tag/v0.44.0)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=tinygo-docker-deploy) **加速拉取**。

```bash
docker pull docker.xuanyuan.run/tinygo/tinygo:0.44.0
```

Ubuntu 24.04 上拉取完成：

```text
0.44.0: Pulling from tinygo/tinygo
3774da9f7dc9: Pull complete
5681453078ea: Pull complete
4f4fb700ef54: Pull complete
4466dac91a56: Pull complete
48f66da1f273: Pull complete
c987b2e1a179: Pull complete
e8e56aad807d: Pull complete
44136fa355b3: Download complete
10ae98975aeb: Download complete
Digest: sha256:98126534a0653966913b803d26805ea79250a244217d921d74044cfedc1d24a2
Status: Downloaded newer image for docker.xuanyuan.run/tinygo/tinygo:0.44.0
docker.xuanyuan.run/tinygo/tinygo:0.44.0
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=tinygo-docker-deploy)。压缩体积见「环境要求」。

## Docker Compose 部署

镜像没有长期运行的业务进程。Compose 里把命令写成 `sleep infinity`，容器才会留在后台，再用 `docker compose exec` 反复编译。

源码目录在宿主机上叫 `src`，挂到容器内的 `/src`。官方 Docker 文档也使用 `/src` 作为挂载点。本文把 `working_dir` 设为 `/src`。

属主要分两步处理：先交给当前用户，才能在宿主机写入 `hello.go`；容器启动后，再交给 **tinygo** 的 uid/gid，容器才能写出 `.wasm` 和 `.hex`。只用 root 部署、且一直把目录留给 root 时，编译阶段会报 `permission denied`。

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/tinygo` |
| **macOS** | **`~/docker/tinygo`** |

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| `src/` | `/src` | 源码与编译产物 |

1. 创建工作目录，并把目录交给当前用户：

```bash
sudo mkdir -p /www/wwwroot/tinygo/src
sudo chown -R "$USER":"$USER" /www/wwwroot/tinygo
cd /www/wwwroot/tinygo
```

2. 写入一段最小 Go 源码。下面用空格缩进。不要把带制表符的原文直接粘进交互式 bash：bash 会把 Tab 补成当前目录里的路径，`println` 会变成 `src/println`：

```bash
cat > src/hello.go <<'EOF'
package main

func main() {
    println("Hello from TinyGo")
}
EOF
```

写入后可用下面命令确认第 4 行是 `println`，前面没有 `src/`：

```bash
cat -A src/hello.go
```

这次输出是：

```text
package main$
$
func main() {$
    println("Hello from TinyGo")$
}$
```

3. 写入 `compose.yaml`：

```bash
cat > compose.yaml <<'EOF'
services:
  tinygo:
    image: docker.xuanyuan.run/tinygo/tinygo:0.44.0
    container_name: tinygo
    working_dir: /src
    volumes:
      - ./src:/src
    command: ["sleep", "infinity"]
    restart: unless-stopped
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 具体版本标签 `0.44.0` |
| `working_dir` | `/src`，与挂载点一致 |
| `volumes` | 宿主机 `./src` 对应容器 `/src` |
| `command` | `sleep infinity`，让编译环境留在后台 |
| `restart` | 进程退出后再次拉起 |
| 端口 | 不映射 |

4. 启动容器：

```bash
docker compose up -d
```

这次启动完成：

```text
[+] up 2/2
 ✔ Network tinygo_default Created  0.5s
 ✔ Container tinygo       Started  3.7s
```

5. 把 `src/` 交给容器用户：

```bash
TINYGO_UID=$(docker compose exec -T tinygo id -u)
TINYGO_GID=$(docker compose exec -T tinygo id -g)
echo "uid=${TINYGO_UID} gid=${TINYGO_GID}"
sudo chown -R "${TINYGO_UID}:${TINYGO_GID}" src
```

这次输出是 `uid=1000 gid=1000`。宿主机上同号用户显示为 **sean**；你机器上可能是别的用户名，以 `id` 读到的数字为准。

6. 查看容器状态。状态为运行中之后再编译：

```bash
docker compose ps
```

这次没有端口映射：

```text
NAME      IMAGE                                      COMMAND            SERVICE   CREATED          STATUS         PORTS
tinygo    docker.xuanyuan.run/tinygo/tinygo:0.44.0   "sleep infinity"   tinygo    11 seconds ago   Up 9 seconds
```

## 编译示例

### 确认编译器版本

```bash
docker compose exec tinygo tinygo version
```

这次输出是：

```text
tinygo version 0.44.0 linux/amd64 (using go version go1.27.3 and LLVM version 22.1.4)
```

需要看默认目标时，再执行：

```bash
docker compose exec tinygo tinygo info
```

这次输出是：

```text
LLVM triple:       x86_64-unknown-linux-musleabihf
GOOS:              linux
GOARCH:            amd64
build tags:        linux amd64 tinygo purego osusergo math_big_pure_go gc.boehm scheduler.threads tinygo.unwind.setjmp serial.none
garbage collector: boehm
scheduler:         threads
cached GOROOT:     /home/tinygo/.cache/tinygo/goroot-8c097cbe00b1c556372632fe51af395d72ce7e0e4b42c715b1d32d522a73adb8
```

### 编译 WASI 模块

```bash
docker compose exec tinygo 
  env GOOS=wasip1 GOARCH=wasm 
  tinygo build -o hello.wasm hello.go
```

这次命令正常结束，终端没有额外输出。

### 编译 Arduino Uno 示例固件

镜像内置示例路径由 TinyGo 相对安装目录解析。下面把官方 `examples/blinky1` 编成 HEX，写到挂载目录：

```bash
docker compose exec tinygo 
  tinygo build -o /src/blinky1.hex -size=short -target=arduino-uno examples/blinky1
```

这次编译完成：

```text
   code    data     bss |   flash     ram
    928       0     560 |     928     560
```

换 Circuit Playground Express 时，把 `-target` 改成 `circuitplay-express`，产物路径可以仍写 `/src/blinky1.hex`。

### 查看产物

```bash
ls -l src/hello.wasm src/blinky1.hex
```

这次两份文件都在，属主是 sean（对应 uid 1000）：

```text
-rwxr-xr-x 1 sean sean   2564 Nov  2 12:05 src/blinky1.hex
-rwxr-xr-x 1 sean sean 149287 Nov  2 12:05 src/hello.wasm
```

`hello.wasm` 可交给支持 WASI Preview 1 的运行时加载。浏览器目标见延伸阅读中的官方 WASM 指南。`blinky1.hex` 的烧录在宿主机完成：容器里跑 `tinygo flash` 要处理 USB 设备透传，官方 Docker 文档也建议在宿主机烧录。

把自己的源码放进 `src/` 后，用同一容器再次执行 `tinygo build`。产物文件名和目标板按项目调整即可。

## 更换标签

要换版本时，同时修改三处：`docker pull` 的标签、`compose.yaml` 里的 `image`、后面 `docker run` 的镜像参数。改完后重新拉取，再执行：

```bash
docker compose up -d
```

已经生成的 `.wasm` 和 `.hex` 不会自动重编。需要新工具链的产物时，再执行一次 `tinygo build`。

## 备选：docker run

没有 Compose 时，用一次 `docker run` 编译。「Docker Compose 部署」里的 `src/hello.go` 需要已经写好。没有正在运行的 Compose 容器时，可按实测把目录交给 **1000:1000**：

```bash
sudo chown -R 1000:1000 /www/wwwroot/tinygo/src
```

`--rm` 会在命令结束后删除容器，源码和产物留在宿主机目录里。Compose 容器已经在运行时，继续用 `docker compose exec`，不要再开一个容器写同一个目录。

编译 WASI：

```bash
docker run --rm 
  --name tinygo-build 
  -v /www/wwwroot/tinygo/src:/src 
  -w /src 
  docker.xuanyuan.run/tinygo/tinygo:0.44.0 
  env GOOS=wasip1 GOARCH=wasm 
  tinygo build -o hello.wasm hello.go
```

编译内置 Arduino 示例：

```bash
docker run --rm 
  --name tinygo-build 
  -v /www/wwwroot/tinygo/src:/src 
  -w /src 
  docker.xuanyuan.run/tinygo/tinygo:0.44.0 
  tinygo build -o /src/blinky1.hex -size=short -target=arduino-uno examples/blinky1
```

macOS 把 `-v` 前面的目录换成 `~/docker/tinygo/src`。

查看产物：

```bash
ls -l /www/wwwroot/tinygo/src/hello.wasm /www/wwwroot/tinygo/src/blinky1.hex
```

## 常见问题

### hello.go 报 undefined: src

交互式 bash 会把粘贴内容里的 Tab 当成路径补全。工作目录里又有 `src/` 时，`println` 前面的制表符会被补成 `src/`，源码变成：

```text
src/println("Hello from TinyGo")
```

这次编译停在：

```text
# command-line-arguments
hello.go:4:1: undefined: src
hello.go:4:5: println("Hello from TinyGo") (no value) used as value
```

宿主机上也没有 `hello.wasm`。回到「Docker Compose 部署」，用空格缩进的 heredoc 覆盖 `src/hello.go`，用 `cat -A` 确认第 4 行没有 `src/`，再执行 build。不要在命令行里手按 Tab。

### 写入产物时报 Permission denied

容器以用户 **tinygo** 运行。目录属主仍是 root 时，容器不能往 `/src` 写文件。这次 Arduino 示例已经算出体积，写文件时失败：

```text
   code    data     bss |   flash     ram
    928       0     560 |     928     560
open /src/blinky1.hex: permission denied
```

按「Docker Compose 部署」里的命令，用容器内的 uid/gid 改 `src/` 属主，再执行 build。不要为了改权限去改镜像里的 `/usr/local/tinygo`。

### 浏览器打不开

这个镜像没有网页，也不映射端口。`docker compose ps` 的 PORTS 一列是空的，浏览器没有地址可开。编译是否完成，看 `tinygo build` 是否结束，以及宿主机 `src/` 里是否出现产物文件。

不要为了习惯把端口映射到宿主机 3000。本机的前端开发经常占用 3000，而这个容器并不监听它。

### 容器马上退出

本文的 `command` 是 `sleep infinity`。若 `docker compose ps` 里状态是退出，检查 `compose.yaml` 的 `command` 是不是 `sleep infinity`，然后重新执行 `docker compose up -d`。

### 在容器里 flash 失败

官方 Docker 文档说明：板子烧录更适合在宿主机完成。容器内 `tinygo flash` 需要把 USB 设备映射进容器，权限和设备节点因发行版而异。推荐流程是：容器里 `tinygo build` 得到 HEX 或 UF2，再在宿主机用厂商工具或本机安装的 TinyGo 执行烧录。

### 依赖不在标准库里

项目如果拉取了远程模块，需要把模块缓存或 `GOPATH` 一并挂进容器，并设置 `GOPATH`。官方示例会把宿主机的 `$GOPATH` 挂到容器 `/go`：

```bash
docker run --rm 
  -v "$GOPATH":/go 
  -e GOPATH=/go 
  docker.xuanyuan.run/tinygo/tinygo:0.44.0 
  tinygo build -o /go/src/github.com/myuser/myrepo/out.wasm 
  -target=wasm 
  /go/src/github.com/myuser/myrepo/main.go
```

路径改成你的模块实际位置。仅编译标准库和本文这种单文件示例时，不必挂 `GOPATH`。当前 TinyGo 也不会从项目里的 `/vendor/` 解析依赖。

### 用 latest 可以吗

`latest` 目前和 `0.44.0` 是同一份镜像索引，下次发版后会改指向。本文命令使用 `0.44.0`。说明见「标签怎么选」。

### 和 tinygo/tinygo-dev 有什么区别

`tinygo/tinygo` 是发行版镜像，对应发布标签。`tinygo/tinygo-dev` 跟随开发分支，体积和内容会变。本文使用发行版 **`0.44.0`**，不拉取 `tinygo-dev`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/tinygo/tinygo:0.44.0

cd /www/wwwroot/tinygo
docker compose up -d
TINYGO_UID=$(docker compose exec -T tinygo id -u)
TINYGO_GID=$(docker compose exec -T tinygo id -g)
sudo chown -R "${TINYGO_UID}:${TINYGO_GID}" src
docker compose ps
docker compose exec tinygo tinygo version
docker compose exec tinygo 
  env GOOS=wasip1 GOARCH=wasm 
  tinygo build -o hello.wasm hello.go
docker compose exec tinygo 
  tinygo build -o /src/blinky1.hex -size=short -target=arduino-uno examples/blinky1
ls -l src/hello.wasm src/blinky1.hex

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。没有网页，也没有登录账号。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [tinygo/tinygo 镜像页](https://xuanyuan.cloud/zh/r/tinygo/tinygo?xy_from=tinygo-docker-deploy) | [https://xuanyuan.cloud/zh/r/tinygo/tinygo](https://xuanyuan.cloud/zh/r/tinygo/tinygo?xy_from=tinygo-docker-deploy) |
| [tinygo/tinygo 概览](https://xuanyuan.cloud/r/tinygo/tinygo?xy_from=tinygo-docker-deploy) | [https://xuanyuan.cloud/r/tinygo/tinygo](https://xuanyuan.cloud/r/tinygo/tinygo?xy_from=tinygo-docker-deploy) |
| [tinygo/tinygo 标签列表](https://xuanyuan.cloud/r/tinygo/tinygo/tags?xy_from=tinygo-docker-deploy) | [https://xuanyuan.cloud/r/tinygo/tinygo/tags](https://xuanyuan.cloud/r/tinygo/tinygo/tags?xy_from=tinygo-docker-deploy) |
| [Docker Hub · tinygo/tinygo](https://hub.docker.com/r/tinygo/tinygo) | [https://hub.docker.com/r/tinygo/tinygo](https://hub.docker.com/r/tinygo/tinygo) |
| [TinyGo 官网](https://tinygo.org/) | [https://tinygo.org/](https://tinygo.org/) |
| [官方 Docker 安装说明](https://tinygo.org/getting-started/install/using-docker/) | [https://tinygo.org/getting-started/install/using-docker/](https://tinygo.org/getting-started/install/using-docker/) |
| [WebAssembly 指南](https://tinygo.org/docs/guides/webassembly/) | [https://tinygo.org/docs/guides/webassembly/](https://tinygo.org/docs/guides/webassembly/) |
| [GitHub · tinygo-org/tinygo](https://github.com/tinygo-org/tinygo) | [https://github.com/tinygo-org/tinygo](https://github.com/tinygo-org/tinygo) |
| [GitHub Release v0.44.0](https://github.com/tinygo-org/tinygo/releases/tag/v0.44.0) | [https://github.com/tinygo-org/tinygo/releases/tag/v0.44.0](https://github.com/tinygo-org/tinygo/releases/tag/v0.44.0) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=tinygo-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=tinygo-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/tinygo-docker-deploy?xy_from=tinygo-docker-deploy)

*本文基于 [tinygo/tinygo:0.44.0](https://xuanyuan.cloud/zh/r/tinygo/tinygo?xy_from=tinygo-docker-deploy)，实测引擎 **tinygo 0.44.0**，配套 **go 1.27.3**、**LLVM 22.1.4**，测试平台 **Ubuntu 24.04** Linux。*



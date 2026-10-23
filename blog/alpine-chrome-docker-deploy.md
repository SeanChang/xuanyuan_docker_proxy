# Docker 部署 Alpine Chrome：轻松搭建无头浏览器

![Docker 部署 Alpine Chrome：轻松搭建无头浏览器](https://imgs.xuanyuan.cloud/docker/blog/alpine-chrome/alpine-chrome-1.webp)

*分类: Docker部署教程 | 标签: Alpine Chrome,zenika/alpine-chrome,Docker,轩辕镜像,Chromium,无头浏览器,部署教程 | 发布时间: 2026-10-23 21:23:44*

> Alpine Chrome 是运行在 Alpine Linux 中的无头 Chromium，用来导出网页 DOM、截图和生成 PDF，并提供远程调试端口。本文将介绍如何通过 Docker Compose 部署 zenika/alpine-chrome，在服务器上准备无头浏览器，帮助在没有桌面的环境里检查页面、截图和导出 PDF，适合脚本取页面及把网页留成文件等场景。

*本文基于 [zenika/alpine-chrome:124](https://xuanyuan.cloud/zh/r/zenika/alpine-chrome)，实测引擎 **HeadlessChrome 124.0.6367.78**，测试平台 **Ubuntu 24.04** Linux。*

## Alpine Chrome 是什么

Alpine Chrome 是放在 Alpine Linux 里的无头 Chromium，镜像名是 `zenika/alpine-chrome`。它用来在没有桌面的机器上打开网页，把 DOM 打到终端，生成截图和 PDF，或者在后台打开远程调试端口，让别的程序连上来。

与在容器里跑一整套带窗口的 Chrome、再用网页远程点选不同，这个镜像默认没有界面。参数直接交给 Chromium。任务结束容器就退出；需要一直开着时，只保留调试端口。

## Alpine Chrome 能做什么

- **导出页面 DOM**：把网页 HTML 打到终端，用来核对页面内容。
- **网页截图**：按窗口大小把页面画成图片。
- **生成 PDF**：把网页打印成 PDF 文件。
- **远程调试**：在后台打开调试端口，供调试工具连接。
- **带中文和表情字体**：镜像含文泉驿正黑、FreeFont 和 Noto Emoji。

## 为什么要使用 Alpine Chrome

在服务器上安装桌面版 Chrome，依赖和升级都留在宿主机上。检查页面、截图、导出 PDF，跑完就可以把容器停掉。

Alpine Chrome 把 Chromium 和这些字体放在同一个镜像里，换机器时指定同一个标签即可。适合没有桌面的服务器，以及要在脚本里取页面、截图和导出 PDF 的场合。

## 使用 Docker 部署 Alpine Chrome

用 Docker 可以在没有桌面的系统上把无头 Chromium 跑起来。开始之前准备好 Docker，并定好调试端口只给本机、同一局域网，或通过 SSH 隧道使用。

接下来用 Docker Compose 写好参数，启动调试端口，再导出页面 HTML、截图和 PDF。

## 环境要求

本文使用 **124** 版本实测，测试平台 **Ubuntu 24.04**。调试端口返回的浏览器是 **HeadlessChrome 124.0.6367.78**。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文 **Ubuntu 24.04** 实测）；macOS 把 `/www/wwwroot/alpine-chrome` 换成 `~/docker/alpine-chrome` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | Docker Hub 列出 **linux/amd64** 与 **linux/arm64**。本文在 Ubuntu 24.04 上跑的是本次拉取的镜像，没有另测 arm64 |
| 内存 | 官方没有给出最低值。打开网页时为 Chromium 留出余量 |
| 磁盘 | Docker Hub 列出的 amd64 压缩体积约 **268 MB**，另加 `out/` 里的截图和 PDF |
| 端口 | 宿主机 **9222** → 容器 **9222**（远程调试）。不要暴露到公网 |
| 工作目录 | `/www/wwwroot/alpine-chrome` |

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

拉取 **`124`**。Ubuntu 24.04 实测摘要是 `sha256:eb3378c1ed0079f94db054a5fe1aaa790a254ec0d6bbc67eda052420d86a179d`。Docker Hub 上 2026-09-03 的记录里，`124` 与 `latest` 摘要相同。`latest` 以后还会指向别的构建，不写入本文命令。

`/json/version` 的 `Browser` 是 `HeadlessChrome/124.0.6367.78`。标签 `124` 对上主版本号，完整版本以这个字段为准。仓库 README 里的版本示例仍是 Chromium 121，不要把它当成这次容器里的版本。仓库说明原维护者已离开 Zenika，并提醒 Hub 上的镜像可能过时。`124-with-puppeteer` 等变体在 Hub 上的更新时间是 2024-10-31，和这次的基础镜像不是同一次构建。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`124`** | 本文实测。浏览器 HeadlessChrome 124.0.6367.78。amd64、arm64 | **是** |
| `latest` | 浮动标签。2026-09-03 的 Hub 记录与 `124` 摘要相同 | 否 |
| `123` | 上一档具体版本。更新于 2024-04-18 | 否 |
| `124-with-puppeteer` | 带 Node.js 与 Puppeteer。更新于 2024-10-31 | 否 |
| `124-with-playwright` | 带 Playwright。更新于 2024-10-31 | 否 |
| `124-with-chromedriver` | 带 ChromeDriver。更新于 2024-10-31 | 否 |
| `124-with-node` | 带 Node.js。更新于 2024-10-31 | 否 |
| `with-puppeteer` | `124-with-puppeteer` 的浮动别名 | 否 |

完整标签见 [标签列表](https://xuanyuan.cloud/r/zenika/alpine-chrome/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/zenika/alpine-chrome:124
```

Ubuntu 24.04 实测：

```text
Digest: sha256:eb3378c1ed0079f94db054a5fe1aaa790a254ec0d6bbc67eda052420d86a179d
Status: Downloaded newer image for docker.xuanyuan.run/zenika/alpine-chrome:124
docker.xuanyuan.run/zenika/alpine-chrome:124
```

拉取完成后再写 Compose。

## Docker Compose 部署

不加沙箱参数时，仓库写明 Chromium 会启动失败。仓库给出三种做法：命令加上 `--no-sandbox`、增加 `SYS_ADMIN` 能力，或挂上 seccomp 配置。本文按仓库的截图、PDF 和调试示例使用 `--no-sandbox`。只打开你信任的网址。`SYS_ADMIN` 和 seccomp 见「安全说明」。

调试端口没有登录。同一局域网可以访问，不要把它放进云安全组。

容器要能访问命令里的网址。调试进程和每次导出命令里的网址都要换成你的页面。仓库示例用 `https://www.chromestatus.com/`，本文用 `https://example.com/`。

`chrome` 长期开着，供调试端口使用。镜像入口已经是 `chromium-browser --headless`，Compose 的 `command` 只写后面的参数。`render` 带 profile `render`，`docker compose up -d` 不会启动它。导出 DOM、截图和 PDF 时再用 `docker compose run`。输出目录是 `/www/wwwroot/alpine-chrome/out`，对应容器内 `/usr/src/app`。`render` 的 `user` 在写入文件时展开成当前用户的 uid 和 gid，生成的文件属于该用户。`chrome` 仍使用镜像里的用户 `chrome`。

| 参数 | 作用 |
|------|------|
| `9222:9222` | 远程调试端口。容器内必须听 `0.0.0.0`，否则宿主机连不进去 |
| `--no-sandbox` | 关闭沙箱。不加时，仓库写明容器会启动失败 |
| `https://example.com/` | 调试进程打开的页面。换成你的地址 |
| `render` 的 `profiles` | `up -d` 不启动导出任务 |
| `user` | 输出文件的属主，取写入 Compose 时的当前用户 |
| `/www/wwwroot/alpine-chrome/out:/usr/src/app` | 截图和 PDF 的输出目录 |

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/alpine-chrome/out
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/alpine-chrome
```

2. 写入 `compose.yaml`：

```bash
cd /www/wwwroot/alpine-chrome
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"
cat > compose.yaml <<EOF
name: alpine-chrome

services:
  chrome:
    image: docker.xuanyuan.run/zenika/alpine-chrome:124
    container_name: alpine-chrome
    restart: unless-stopped
    command:
      - --no-sandbox
      - --remote-debugging-address=0.0.0.0
      - --remote-debugging-port=9222
      - https://example.com/
    ports:
      - "9222:9222"

  render:
    image: docker.xuanyuan.run/zenika/alpine-chrome:124
    profiles: ["render"]
    user: "${HOST_UID}:${HOST_GID}"
    volumes:
      - /www/wwwroot/alpine-chrome/out:/usr/src/app
EOF
```

3. 启动调试进程。这一步不启动 `render`：

```bash
cd /www/wwwroot/alpine-chrome
docker compose up -d
```

Ubuntu 24.04 实测。`2/2` 是网络和 `chrome` 容器：

```text
[+] up 2/2
 ✔ Network alpine-chrome_default Created
 ✔ Container alpine-chrome       Started
```

4. 在服务器本机查看状态并请求调试端口：

```bash
cd /www/wwwroot/alpine-chrome
docker compose ps
docker compose logs --tail 50 chrome
curl -fsS http://127.0.0.1:9222/json/version
```

`ps` 里只有 `chrome`，状态为 Up：

```text
NAME            IMAGE                                          COMMAND                  SERVICE   CREATED         STATUS         PORTS
alpine-chrome   docker.xuanyuan.run/zenika/alpine-chrome:124   "chromium-browser --…"   chrome    5 seconds ago   Up 3 seconds   0.0.0.0:9222->9222/tcp, [::]:9222->9222/tcp
```

日志里这句 dbus 错误连续出现了 3 次：

```text
[1022/064331.584103:ERROR:bus.cc(407)] Failed to connect to the bus: Failed to connect to socket /var/run/dbus/system_bus_socket: No such file or directory
```

后面还有策略文件、沙箱线程和 Floss 的提示。端口已经打开的那一行是：

```text
DevTools listening on ws://0.0.0.0:9222/devtools/browser/b7bb24e4-45be-4894-a285-97b7e94bfec3
```

`/browser/` 后面那串标识每次启动都不同。这些报错和提示出现时，容器仍是 Up。

`curl` 返回 JSON。`Browser` 是浏览器版本，`webSocketDebuggerUrl` 是调试地址：

```text
{
   "Browser": "HeadlessChrome/124.0.6367.78",
   "Protocol-Version": "1.3",
   "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/124.0.6367.78 Safari/537.36",
   "V8-Version": "12.4.254.14",
   "WebKit-Version": "537.36 (@a087f2dd364ddd58b9c016ef1bf563d2bc138711)",
   "webSocketDebuggerUrl": "ws://127.0.0.1:9222/devtools/browser/b7bb24e4-45be-4894-a285-97b7e94bfec3"
}
```

同一局域网打开 `http://服务器IP:9222/json/version`，`Browser` 同样是 `HeadlessChrome/124.0.6367.78`。`webSocketDebuggerUrl` 里的主机名会变成你访问时用的地址。

人不在这台机器所在网络时，用 SSH 隧道把本机 **9222** 转到服务器本机的 **9222**。不要改成对公网开放：

```bash
ssh -L 9222:127.0.0.1:9222 用户名@服务器IP
```

隧道保持连接。在你自己的浏览器打开 `http://127.0.0.1:9222/`，页面上是可检查的标签。仓库说明：点开标签后，把开发者工具链接的开头换成 `chrome-devtools://devtools/bundled/inspector.html?ws=127.0.0.1:9222/`，后面的路径保留。

## 导出 DOM、截图和 PDF

调试进程可以继续开着。每次 `run` 另起一个容器，跑完就删除。不要执行 `docker compose --profile render up`。`render` 没有默认页面参数，那样启动会马上退出。

写出的字节数会随页面变化。下面仍用 `https://example.com/`。终端前半段仍是 dbus 等日志，与调试进程那次相同。

1. 导出 DOM。HTML 打在终端里，不写文件：

```bash
cd /www/wwwroot/alpine-chrome
docker compose --profile render run --rm render 
  --no-sandbox 
  --dump-dom 
  https://example.com/
```

Ubuntu 24.04 实测，HTML 的 `<title>` 是 `Example Domain`。其中有一句中文：「该域名仅用于文档示例，无需获得许可。这并非一项服务，请勿将其用于测试和监控目的。」

2. 截一张图。窗口宽 1280、高 1696，这是仓库示例里的信纸比例：

```bash
cd /www/wwwroot/alpine-chrome
docker compose --profile render run --rm render 
  --no-sandbox 
  --screenshot 
  --hide-scrollbars 
  --window-size=1280,1696 
  https://example.com/
```

最后一行是：

```text
102363 bytes written to file screenshot.png
```

文件在 `/www/wwwroot/alpine-chrome/out/screenshot.png`。PDF 还没生成时，目录里只有这一份：

```bash
ls /www/wwwroot/alpine-chrome/out
```

```text
screenshot.png
```

3. 生成 PDF：

```bash
cd /www/wwwroot/alpine-chrome
docker compose --profile render run --rm render 
  --no-sandbox 
  --print-to-pdf 
  --hide-scrollbars 
  https://example.com/
```

写出文件之前有一行 `ContextResult::kTransientFailure: Failed to send GpuControl.CreateCommandBuffer.`。随后仍然打印：

```text
50556 bytes written to file output.pdf
```

文件在 `/www/wwwroot/alpine-chrome/out/output.pdf`。

下一次同名命令会覆盖 `screenshot.png` 或 `output.pdf`。要留多份结果时，先改名再跑。仓库还举例了手机宽度 `--window-size=412,732`。宽高按页面改。

## 安全说明

`--no-sandbox` 会关掉 Chromium 沙箱。只打开你信任的网站。调试端口没有登录，能连上 **9222** 的人可以控制这个浏览器。

要改用仓库里的 seccomp 配置，先停掉现有进程，再下载 `chrome.json` 并重写 Compose。下载不了这个文件时，继续使用带 `--no-sandbox` 的命令。同一服务不要同时写 `--no-sandbox` 和 seccomp。

1. 停掉现有进程：

```bash
cd /www/wwwroot/alpine-chrome
docker compose down
```

2. 下载 `chrome.json`：

```bash
cd /www/wwwroot/alpine-chrome
curl -fsSL -o chrome.json 
  https://raw.githubusercontent.com/jlandure/alpine-chrome/master/chrome.json
```

3. 重写 `compose.yaml`。这一步会覆盖现有文件。`command` 里不再写 `--no-sandbox`：

```bash
cd /www/wwwroot/alpine-chrome
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"
cat > compose.yaml <<EOF
name: alpine-chrome

services:
  chrome:
    image: docker.xuanyuan.run/zenika/alpine-chrome:124
    container_name: alpine-chrome
    restart: unless-stopped
    security_opt:
      - seccomp:/www/wwwroot/alpine-chrome/chrome.json
    command:
      - --remote-debugging-address=0.0.0.0
      - --remote-debugging-port=9222
      - https://example.com/
    ports:
      - "9222:9222"

  render:
    image: docker.xuanyuan.run/zenika/alpine-chrome:124
    profiles: ["render"]
    user: "${HOST_UID}:${HOST_GID}"
    security_opt:
      - seccomp:/www/wwwroot/alpine-chrome/chrome.json
    volumes:
      - /www/wwwroot/alpine-chrome/out:/usr/src/app
EOF
```

4. 重新启动：

```bash
cd /www/wwwroot/alpine-chrome
docker compose up -d
```

启动后的检查与「Docker Compose 部署」相同。导出时去掉 `--no-sandbox`。截图示例：

```bash
cd /www/wwwroot/alpine-chrome
docker compose --profile render run --rm render 
  --screenshot 
  --hide-scrollbars 
  --window-size=1280,1696 
  https://example.com/
```

仓库的另一种做法是 `--cap-add=SYS_ADMIN`，同样不再加 `--no-sandbox`。它会给容器额外权限，本文不把它写进命令。

镜像默认以用户 `chrome` 运行。排障需要 root shell 时，用完即退出：

```bash
docker run --rm -it --entrypoint "" --user root 
  docker.xuanyuan.run/zenika/alpine-chrome:124 sh
```

## 备选：docker run

没有 Docker Compose 时用这一节。不要和已经用 Compose 启动的同名容器一起跑。这一节是上面 Compose 的对应命令，本文实测走的是 Compose。

1. 创建目录：

```bash
sudo mkdir -p /www/wwwroot/alpine-chrome/out
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/alpine-chrome
```

2. 启动调试进程：

```bash
docker run -d 
  --name alpine-chrome 
  --restart unless-stopped 
  -p 9222:9222 
  docker.xuanyuan.run/zenika/alpine-chrome:124 
  --no-sandbox 
  --remote-debugging-address=0.0.0.0 
  --remote-debugging-port=9222 
  https://example.com/
```

3. 在服务器本机确认端口。日志和 JSON 的看法与「Docker Compose 部署」相同：

```bash
docker ps
docker logs --tail 50 alpine-chrome
curl -fsS http://127.0.0.1:9222/json/version
```

4. 导出 DOM。这个容器用完即删，可以不挂目录：

```bash
docker run --rm 
  docker.xuanyuan.run/zenika/alpine-chrome:124 
  --no-sandbox 
  --dump-dom 
  https://example.com/
```

5. 截一张图：

```bash
docker run --rm 
  -u "$(id -u):$(id -g)" 
  -v /www/wwwroot/alpine-chrome/out:/usr/src/app 
  docker.xuanyuan.run/zenika/alpine-chrome:124 
  --no-sandbox 
  --screenshot 
  --hide-scrollbars 
  --window-size=1280,1696 
  https://example.com/
```

6. 生成 PDF。目录挂载与截图相同：

```bash
docker run --rm 
  -u "$(id -u):$(id -g)" 
  -v /www/wwwroot/alpine-chrome/out:/usr/src/app 
  docker.xuanyuan.run/zenika/alpine-chrome:124 
  --no-sandbox 
  --print-to-pdf 
  --hide-scrollbars 
  https://example.com/
```

## 常见问题

**Q1：进程一起来就退出，日志里和 sandbox 有关，怎么办？**

仓库写明，不处理沙箱时容器会失败。本文默认命令带有 `--no-sandbox`。已经按「安全说明」改成 seccomp 时，不要再加 `--no-sandbox`。两种写法不要叠在同一次启动里。

**Q2：9222 端口已被占用怎么办？**

启动失败且日志里出现 `address already in use` 时，宿主机的 **9222** 已经有程序在听。只改冒号左边，容器内仍是 **9222**。先看谁在听：

```bash
sudo ss -tlnp | grep ':9222'
```

例如改成宿主机 **19222** 时，Compose 里写成 `"19222:9222"`，本机检查改为 `curl -fsS http://127.0.0.1:19222/json/version`。SSH 隧道改为 `-L 19222:127.0.0.1:19222`。改完后执行 `docker compose up -d`。

**Q3：可以把 9222 暴露到公网吗？**

不要。这个端口没有登录。能连上的人可以控制浏览器。同一局域网打开 `http://服务器IP:9222/json/version` 即可。人不在这个网络时，用「Docker Compose 部署」里的 SSH 隧道。

**Q4：和 linuxserver/chrome 是什么关系？**

[linuxserver/chrome](https://xuanyuan.cloud/zh/r/linuxserver/chrome) 在网页里操作带窗口的 Chrome。本文镜像没有桌面，用命令导出 DOM、截图、PDF，或打开调试端口。需要鼠标点页面时，用那一个镜像，不要改本文的端口和参数。

**Q5：`out/` 里没有截图或 PDF 怎么办？**

按这个顺序看：

1. 终端最后一行是否为 `bytes written to file screenshot.png` 或 `bytes written to file output.pdf`。前面的 dbus 报错在本文实测里出现过，文件仍然写出来了。打印时若出现 `Failed to send GpuControl.CreateCommandBuffer`，仍以这行 `bytes written` 为准。本文这次有这行 GPU 报错，PDF 已写出。
2. `render` 是否挂了 `/www/wwwroot/alpine-chrome/out:/usr/src/app`。调试进程 `chrome` 不挂这个目录，不会把文件写到 `out/`。
3. 文件名是否为 `screenshot.png` 或 `output.pdf`。下一次同名任务会覆盖上一份。

**Q6：文件属主不是我怎么办？**

`render` 的 `user` 来自写入 Compose 时的 `id`。目录后来改由 root 创建时，先改属主，再跑截图：

```bash
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/alpine-chrome/out
cd /www/wwwroot/alpine-chrome
docker compose --profile render run --rm render 
  --no-sandbox 
  --screenshot 
  --hide-scrollbars 
  https://example.com/
```

当前 Compose 已经改成 seccomp 时，删掉 `--no-sandbox`。

**Q7：中文显示成方框怎么办？**

镜像里有文泉驿正黑、FreeFont 和 Noto Emoji。导出的 HTML 里能看到中文句子。截图若仍是方框，先确认命令里的网址就是那张中文页，再看这次 `run` 的终端输出。

**Q8：如何确认容器里的 Chromium 版本？**

看「Docker Compose 部署」里 `curl http://127.0.0.1:9222/json/version` 的 `Browser`。本文读到的是 `HeadlessChrome/124.0.6367.78`。标签 `124` 对上主版本号，完整版本以这个字段为准。

**Q9：如何升级？**

本文命令使用 `124`。要换更新的具体版本时，先在 [标签列表](https://xuanyuan.cloud/r/zenika/alpine-chrome/tags) 确认那个标签，再改 `compose.yaml` 里两处 `image`，然后执行：

```bash
cd /www/wwwroot/alpine-chrome
docker compose pull
docker compose up -d
```

不要把标签改成 `latest`。`out/` 里的文件保持不动。`124-with-puppeteer` 等变体不能当成基础镜像 `124` 的同一次构建。

**Q10：如何停止与删除？**

还要留着截图和 PDF 时，不要删除 `out/`。`render` 使用 `--rm`，跑完就会删除。

```bash
cd /www/wwwroot/alpine-chrome
docker compose down
```

用 `docker run` 启动的调试进程：

```bash
docker stop alpine-chrome && docker rm alpine-chrome
```

不再使用时，再删除目录：

```bash
rm -rf /www/wwwroot/alpine-chrome
```

**Q11：可以跑 Puppeteer 或 Selenium 吗？**

要跑 Puppeteer，用 `124-with-puppeteer`，不要用本文的 `124`。Playwright 用 `124-with-playwright`，ChromeDriver 用 `124-with-chromedriver`。这些标签在 Docker Hub 上的更新时间是 2024-10-31。仓库的 Puppeteer 示例额外使用 `--cap-add=SYS_ADMIN`，执行的是 `node` 脚本，不是本文这条 `chromium-browser` 命令。

**Q12：页面崩溃或共享内存报错怎么办？**

Dockerfile 里的环境变量 `CHROMIUM_FLAGS` 写有 `--disable-dev-shm-usage`。入口命令是 `chromium-browser --headless`，本文没有把这个变量再写进 `command`，日志里也没有出现共享内存报错。若日志里出现共享内存相关报错，再在 `command` 里加上 `--disable-dev-shm-usage`，或给服务加上 `shm_size: "1gb"`，然后执行 `docker compose up -d`。先看日志原文，再改其中一项。

## 命令速查

```bash
docker pull docker.xuanyuan.run/zenika/alpine-chrome:124

cd /www/wwwroot/alpine-chrome
docker compose up -d
docker compose ps
curl -fsS http://127.0.0.1:9222/json/version

docker compose --profile render run --rm render 
  --no-sandbox --dump-dom https://example.com/

docker compose --profile render run --rm render 
  --no-sandbox --screenshot --hide-scrollbars --window-size=1280,1696 
  https://example.com/

docker compose --profile render run --rm render 
  --no-sandbox --print-to-pdf --hide-scrollbars 
  https://example.com/

docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。同一局域网打开 `http://服务器IP:9222/json/version`。不在该网络时用 SSH 隧道。截图和 PDF 在 `/www/wwwroot/alpine-chrome/out`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [zenika/alpine-chrome 镜像页](https://xuanyuan.cloud/zh/r/zenika/alpine-chrome) | [https://xuanyuan.cloud/zh/r/zenika/alpine-chrome](https://xuanyuan.cloud/zh/r/zenika/alpine-chrome) |
| [zenika/alpine-chrome 概览](https://xuanyuan.cloud/r/zenika/alpine-chrome) | [https://xuanyuan.cloud/r/zenika/alpine-chrome](https://xuanyuan.cloud/r/zenika/alpine-chrome) |
| [zenika/alpine-chrome 标签列表](https://xuanyuan.cloud/r/zenika/alpine-chrome/tags) | [https://xuanyuan.cloud/r/zenika/alpine-chrome/tags](https://xuanyuan.cloud/r/zenika/alpine-chrome/tags) |
| [GitHub · jlandure/alpine-chrome](https://github.com/jlandure/alpine-chrome) | [https://github.com/jlandure/alpine-chrome](https://github.com/jlandure/alpine-chrome) |
| [Dockerfile](https://github.com/jlandure/alpine-chrome/blob/master/Dockerfile) | [https://github.com/jlandure/alpine-chrome/blob/master/Dockerfile](https://github.com/jlandure/alpine-chrome/blob/master/Dockerfile) |
| [chrome.json](https://github.com/jlandure/alpine-chrome/blob/master/chrome.json) | [https://github.com/jlandure/alpine-chrome/blob/master/chrome.json](https://github.com/jlandure/alpine-chrome/blob/master/chrome.json) |
| [Docker Hub · zenika/alpine-chrome](https://hub.docker.com/r/zenika/alpine-chrome) | [https://hub.docker.com/r/zenika/alpine-chrome](https://hub.docker.com/r/zenika/alpine-chrome) |
| [linuxserver/chrome 镜像页](https://xuanyuan.cloud/zh/r/linuxserver/chrome) | [https://xuanyuan.cloud/zh/r/linuxserver/chrome](https://xuanyuan.cloud/zh/r/linuxserver/chrome) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

要在网页里操作带窗口的 Chrome，用 linuxserver/chrome。那不是本文这个无头镜像。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/alpine-chrome-docker-deploy



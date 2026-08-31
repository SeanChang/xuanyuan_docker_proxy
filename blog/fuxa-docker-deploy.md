# Docker 部署 FUXA：轻松搭建 Web SCADA / HMI 过程可视化平台

![Docker 部署 FUXA：轻松搭建 Web SCADA / HMI 过程可视化平台](https://imgs.xuanyuan.cloud/docker/blog/fuxa.png)

*分类: Docker部署教程 | 标签: FUXA,Docker,轩辕镜像,SCADA,HMI,过程可视化,私有化部署,部署教程 | 发布时间: 2026-08-31 15:20:13*

> 产线画面还锁在工控机专用组态里：改一个阀门图标要装客户端、拷工程包，手机和访客电脑根本打不开。机房里温湿度、UPS、门禁又各有一套小网页，想拼成一张总览，只能翻 Excel 对点位，或者再买一套按站授权的商业 SCADA。

*本文基于 [frangoteam/fuxa:1.3.4](https://xuanyuan.cloud/zh/r/frangoteam/fuxa)，实测引擎 **FUXA V.1.3.4-2890**，测试平台 **Ubuntu 24.04** Linux。*

产线画面还锁在工控机专用组态里：改一个阀门图标要装客户端、拷工程包，手机和访客电脑根本打不开。机房里温湿度、UPS、门禁又各有一套小网页，想拼成一张总览，只能翻 Excel 对点位，或者再买一套按站授权的商业 SCADA。

更现实的约束往往是：**工程和历史数据要留在自己的盘上，浏览器就能改画面、看实时数**。商业套件贵、绑定硬件；Grafana 一类仪表盘接指标很顺，却常接不上车间里的 Modbus、西门子 S7、OPC-UA。家里或机房已经有一台跑 Docker 的 Ubuntu，缺的只是镜像拉起来、**1881** 能打开、项目落在挂载目录里。

**FUXA**（[GitHub · frangoteam/FUXA](https://github.com/frangoteam/FUXA)）是开源的 **Web SCADA / HMI** 平台：后端 Node.js，前端 Angular + SVG，组态与运行都在浏览器完成。官方镜像 **`frangoteam/fuxa`**（[镜像页](https://xuanyuan.cloud/zh/r/frangoteam/fuxa)）默认监听 **1881**，许可证 **MIT**。另有可选商业 **FUXA Pro**（白标等），本文只跟做社区版容器。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开样例画面 | `http://服务器IP:1881`，先看自带 **FUXA sample** |
| 进编辑器改 HMI | 拖控件、绑点位，工程写入 `./appdata` |
| 接工业协议 | **连接**里加设备；缺驱动时在 **Server Plugins** 安装 Modbus / OPC-UA / Snap7 等 |
| 备份搬家 | 停容器后打包 `./appdata`、`./db`、`./images`（日志按需） |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`frangoteam/fuxa:1.3.4`**，**Docker Compose** 映射 **1881→1881**。局域网以 **`192.168.1.35`** 为例，请换成你的 IP。无 Compose 见第八节。文内附 **8** 张实测截图。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节
> - **访问**：宿主机 **1881** → 容器 **1881**（`http://192.168.1.35:1881`）；推荐 Chrome
> - **数据**：`./appdata` → `_appdata`；`./db` → `_db`；`./logs` → `_logs`；`./images` → `_images`
> - **认证**：实测默认**不强制登录**；生产请启用令牌认证并改掉默认 **`admin` / `123456`**
> - **标签**：钉死 **`1.3.4`**（日志 **V.1.3.4-2890**），勿写 `latest`
> - **网络**：跟做用 bridge + 端口映射；容器要直连车间 PLC 时再考虑 host 网络（仅 Linux，见 FAQ）

官方说明：[Installing and Running](https://frangoteam.github.io/FUXA/Installing-and-Running/) · [文档站](https://frangoteam.github.io/FUXA/) · [Live Demo](https://frangoteam.github.io)

---

## 一、FUXA 是什么？

FUXA 把设备连接、标签（点位）、画面编辑、运行视图、报警与历史放在同一套 Web 应用里：工程师在浏览器里做组态，操作员用同一端口看运行画面。

| | FUXA（本文） | 商业 SCADA / 组态 | Grafana 类仪表盘 |
|--|--------------|-------------------|------------------|
| 入口 | 浏览器 `:1881` | 厂商客户端 / 授权站 | 浏览器 |
| 工程 | Web 编辑器 + SVG | 专有工程格式 | Dashboard JSON |
| 协议 | Modbus / S7 / OPC-UA / MQTT 等 | 因产品而异 | 多依赖已有时序库 |
| 数据 | 宿主机四卷目录 | 厂商或本机工程 | 外部数据源 |
| 适合 | 中小产线、实验室、机房总览、IoT 看板 | 大型产线、强认证与集成 | 已有指标、偏运维可视化 |

```text
浏览器（编辑器 / 运行视图）
   │  :1881
   ▼
frangoteam/fuxa
   ├── _appdata  ← ./appdata   项目与设置
   ├── _db       ← ./db        标签历史（DAQ）
   ├── _logs     ← ./logs
   └── _images   ← ./images    图片资源
```

本文只跟 **`frangoteam/fuxa`**。[`/r/`](https://xuanyuan.cloud/r/frangoteam/fuxa) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/frangoteam/fuxa) 是同一镜像的不同页面，不是两个仓库。标签选型见第三节。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（另有 arm/v7；以 [tags](https://xuanyuan.cloud/r/frangoteam/fuxa/tags) 为准） |
| 内存 | 评估 ≥ **1 GB**；画面多、历史长时再加 |
| 磁盘 | 实测镜像 CONTENT **210 MB** / DISK **899 MB**；工程与 DAQ 另算 |
| 端口 | 宿主机 **1881**（占用时改左侧，如 `"11881:1881"`） |

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

```bash
ss -tlnp | grep 1881
```

被占用时把 Compose 改成 `"11881:1881"`，浏览器改访新的左侧端口。

---

## 三、标签怎么选

跟做只写 **`1.3.4`**，与 [GitHub Release v1.3.4](https://github.com/frangoteam/FUXA/releases/tag/v1.3.4)（约 2026-08-12）及 Docker Hub 同名标签一致。完整列表：[tags](https://xuanyuan.cloud/r/frangoteam/fuxa/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`1.3.4`** | 当前跟做稳定版（实测日志 **V.1.3.4-2890**） | **本文跟做** |
| `1.3.3` / `1.2.x` | 更早稳定版 | 回滚 |
| `snap7-*` | 旧版带 Snap7 的镜像变体 | 一般不必；S7 可在容器内用 **Server Plugins** 装 `node-snap7` |
| `latest` / `1.3` | 浮动 | **勿写入跟做命令** |

升级时先备份四卷，再改 pull / Compose / `docker run` 三处标签，并核对 [Releases](https://github.com/frangoteam/FUXA/releases)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/frangoteam/fuxa:1.3.4
```

Ubuntu 24.04 实测（`ikuai-ubuntu2404`）：

```text
1.3.4: Pulling from frangoteam/fuxa
Digest: sha256:3778da3377e7685842495497d13157d1548ccad8708c434dc5d4b99fb5cb25bf
Status: Downloaded newer image for docker.xuanyuan.run/frangoteam/fuxa:1.3.4
docker.xuanyuan.run/frangoteam/fuxa:1.3.4
```

```bash
docker images docker.xuanyuan.run/frangoteam/fuxa:1.3.4
```

```text
IMAGE                                       ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/frangoteam/fuxa:1.3.4   3778da3377e7        899MB          210MB
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/fuxa` |
| **macOS** | **`~/docker/fuxa`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\fuxa` |

### 5.1 准备目录

```bash
mkdir -p /www/wwwroot/fuxa/{appdata,db,logs,images}
cd /www/wwwroot/fuxa

# macOS：mkdir -p ~/docker/fuxa/{appdata,db,logs,images} && cd ~/docker/fuxa
```

非 root 给 `mkdir` 加 `sudo`。

### 5.2 编写 docker-compose.yml

对齐官方 [compose.yml](https://github.com/frangoteam/FUXA/blob/master/compose.yml)：镜像换成轩辕坐标并钉死版本。

```bash
cat > docker-compose.yml <<'EOF'
services:
  fuxa:
    image: docker.xuanyuan.run/frangoteam/fuxa:1.3.4
    container_name: fuxa
    restart: unless-stopped
    ports:
      - "1881:1881"
    environment:
      TZ: Asia/Shanghai
    volumes:
      - ./appdata:/usr/src/app/FUXA/server/_appdata
      - ./db:/usr/src/app/FUXA/server/_db
      - ./logs:/usr/src/app/FUXA/server/_logs
      - ./images:/usr/src/app/FUXA/server/_images
EOF
```

| 项 | 说明 |
|----|------|
| `ports` | 宿主机 **1881** → 容器 **1881** |
| `./appdata` | 项目与设置（含 `settings.js`） |
| `./db` | DAQ / 标签历史 |
| `./logs` | 日志 |
| `./images` | 图片等资源 |
| `TZ` | 跟做 `Asia/Shanghai` |

反向代理子路径可用环境变量 **`BASE_PATH`**（须带前导斜杠，如 `/fuxa`），见 FAQ。官方另可挂载 SVG shapes 目录，评估阶段一般不必。

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network fuxa_default Created
 ✔ Container fuxa       Started
```

```text
NAME      IMAGE                                       COMMAND                  SERVICE   CREATED         STATUS         PORTS
fuxa      docker.xuanyuan.run/frangoteam/fuxa:1.3.4   "docker-entrypoint.s…"   fuxa      5 seconds ago   Up 3 seconds   0.0.0.0:1881->1881/tcp, [::]:1881->1881/tcp
```

```text
fuxa  | 2026-08-31T14:27:32.368Z [DBG]          settings.js default created successful!
fuxa  | 2026-08-31T14:27:32.390Z [INF]  FUXA V.1.3.4-2890
```

看到 **`0.0.0.0:1881->1881/tcp`** 和 **`FUXA V.1.3.4-2890`** 即可。请用宿主机 IP 访问，不要用 `172.x` 容器地址。

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:1881
```

```text
200
```

浏览器打开（换成你的 IP）：

```text
http://192.168.1.35:1881
```

---

## 六、浏览器首次进入

推荐 **Chrome**。

### 6.1 加载页

首次打开会短暂出现 **「FUXA Loading…」** 与 *powered by frangoteam*，等前端资源加载即可。

![FUXA 首次访问：白色加载页显示 FUXA Loading 与 frangoteam](https://imgs.xuanyuan.cloud/docker/blog/fuxa-1.webp)

### 6.2 样例运行画面

加载完成后进入自带样例 **FUXA sample**：罐体液位、阀门 / 泵示意、滑块、开关、仪表，以及 **My chart** 趋势。左下角蓝色菜单按钮可开导航。能看到这页，说明服务与前端已经跑通。

![FUXA 样例画面：罐体管道示意与滑块仪表趋势图](https://imgs.xuanyuan.cloud/docker/blog/fuxa-0.webp)

### 6.3 进入编辑器与设置总览

从运行画面进入 **编辑模式**（界面顶部或菜单中的编辑 / 进入编辑器入口，以当前语言 UI 为准），再打开右上角 **设置（齿轮）**。弹出面板按块划分：

- **用户接口**：视图、布局、图表…
- **杂项**：**连接**（加 PLC / MQTT 等）、用户角色、**插件**、API Keys、设置…
- **逻辑**：警报、脚本、Node-RED、报告、语言…
- **系统**：日志

配设备、装协议、开认证，都从这里进。

![FUXA 设置总览：视图连接用户角色插件警报与日志入口](https://imgs.xuanyuan.cloud/docker/blog/fuxa-2.webp)

### 6.4 布局：为何首次不用登录

**设置 → 布局**，看「常规」页实测默认：

| 项 | 实测 |
|----|------|
| 启动视图 | **MainView** |
| 启动时显示登录 | **已禁用** |
| 显示连接错误 (Toast) | **已启用** |
| 导航菜单按钮 | **显示按钮** 打开 |

因此浏览器能直接进样例。公网或多人共用时，把「启动时显示登录」打开，并在系统设置里启用令牌认证（下一节与 §7.3）。

![FUXA 布局设置：启动视图 MainView，启动时显示登录已禁用](https://imgs.xuanyuan.cloud/docker/blog/fuxa-3.webp)

右侧可预览左下角汉堡导航按钮，并开关「显示按钮」：

![FUXA 布局设置：导航汉堡按钮预览与显示按钮开关](https://imgs.xuanyuan.cloud/docker/blog/fuxa-4.webp)

### 6.5 启用认证时的默认账号

启用「使用令牌进行认证」（或改 `appdata` 里 `settings.js` 的 `secureEnabled` 后重启）才会强制登录。官方默认：

| 用户 | 默认密码 |
|------|----------|
| **admin** | **123456** |

上线立刻修改，并为 JWT 设置足够随机的 **`secretCode`**（见 [Settings · Authentication](https://frangoteam.github.io/FUXA/Settings/)）。不要把未加固的 **1881** 直接暴露到公网。

---

## 七、插件、脚本 API 与系统设置

### 7.1 Server Plugins（协议扩展）

**设置 → 插件**。列表里可见 **modbus-serial**、**node-opcua**、**node-snap7**、**node-bacnet**、**odbc**、**redis**、**node-red** 等，按卡片 **Install / Remove** 即可。页面也提示可用 `npm install 包名@version` 手动装到服务端。

需要连车间 PLC 时：先装对应插件，再在 **连接** 里建设备；同时确认容器网络能到达目标网段（FAQ）。

![FUXA Server Plugins：Modbus OPC-UA Snap7 等协议插件列表](https://imgs.xuanyuan.cloud/docker/blog/fuxa-5.webp)

### 7.2 连接、画面与客户端脚本

**连接** 里添加协议与点位，回到编辑器画布拖控件、绑标签。工程在 `./appdata`，DAQ 历史在 `./db`。

**API Keys** 页可开关前端脚本能调用的系统函数（`$setTag`、`$getTag`、`$setView` 等，对应 `window.fuxaScriptAPI`）。只打开现场真正需要的项，避免把写点能力暴露给不可信页面。

![FUXA API Keys：客户端脚本访问可开关 setTag getTag 等系统函数](https://imgs.xuanyuan.cloud/docker/blog/fuxa-6.webp)

### 7.3 系统设置（语言、端口、认证）

**设置 → 设置 → 系统**，实测：

| 项 | 实测 |
|----|------|
| 语言 | **中文** |
| 服务器正在监听端口 | **1881** |
| Node-RED / Swagger | 已禁用 |
| 使用令牌进行认证 | **已禁用**（生产请改为启用） |

改认证等项后保存，必要时 `docker compose restart`。SMTP、DAQ 存储、警报、Logs 等页签按现场再配。

![FUXA 系统设置：语言中文、监听端口 1881、令牌认证已禁用](https://imgs.xuanyuan.cloud/docker/blog/fuxa-7.webp)

容器时区已由 `TZ=Asia/Shanghai` 对齐；界面语言以本页为准。

---

## 八、备选：docker run

无 Compose 或临时试跑：

```bash
mkdir -p /www/wwwroot/fuxa/{appdata,db,logs,images}
cd /www/wwwroot/fuxa

docker run -d \
  --name fuxa \
  --restart unless-stopped \
  -p 1881:1881 \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/fuxa/appdata:/usr/src/app/FUXA/server/_appdata \
  -v /www/wwwroot/fuxa/db:/usr/src/app/FUXA/server/_db \
  -v /www/wwwroot/fuxa/logs:/usr/src/app/FUXA/server/_logs \
  -v /www/wwwroot/fuxa/images:/usr/src/app/FUXA/server/_images \
  docker.xuanyuan.run/frangoteam/fuxa:1.3.4
```

```bash
docker ps --filter name=fuxa
docker logs --tail 80 fuxa
```

日常仍建议用第五节 Compose，改端口、备份和升级更省事。

---

## 九、迁移与升级

1. `docker compose down`
2. 备份 `appdata`、`db`、`images`（`logs` 按需）
3. 把 Compose（及 run）里的标签改成目标版本号，不要改回 `latest`
4. `docker pull docker.xuanyuan.run/frangoteam/fuxa:<新标签>`
5. `docker compose up -d`，核对日志版本串与浏览器工程是否正常

跨大版本先读 [Releases](https://github.com/frangoteam/FUXA/releases)。不要在未备份时用 `snap7-*` 镜像直接覆盖现有四卷。

---

## 十、常见问题 FAQ

**Q：为什么不推荐 `latest`？**  
A：标签会静默漂移，界面与插件步骤可能和文档对不上。跟做钉死 **`1.3.4`**。

**Q：默认要不要登录？账号是什么？**  
A：实测布局里「启动时显示登录」与系统里「令牌认证」均为禁用，可直接进样例。启用认证后默认 **`admin` / `123456`**，必须立刻修改。

**Q：连不上车间 PLC？**  
A：bridge 下容器走 Docker 网关，可能到不了只挂在宿主机物理网卡上的网段。Linux 可评估 `network_mode: host`（此时不要再写 `ports`，直接占用宿主机 1881）。先确认插件已安装、设备地址与防火墙放行。

**Q：端口 1881 被占用？**  
A：改 `"11881:1881"`，访问 `http://IP:11881`。

**Q：删容器会丢工程吗？**  
A：工程在 `./appdata`，历史在 `./db`，图片在 `./images`。卷还在就不丢；没挂卷的试跑数据会随容器消失。

**Q：反向代理子路径怎么配？**  
A：设 **`BASE_PATH`**（如 `/fuxa`，带前导斜杠），并按官方说明转发 WebSocket 与静态资源。

**Q：和 FUXA Pro 什么关系？**  
A：本文是社区开源镜像。Pro 提供白标等增值能力，见 [frangoteam.org](https://frangoteam.org)。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/frangoteam/fuxa:1.3.4

# Compose（目录 /www/wwwroot/fuxa）
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
docker compose down

# 备选 run
docker run -d --name fuxa --restart unless-stopped -p 1881:1881 \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/fuxa/appdata:/usr/src/app/FUXA/server/_appdata \
  -v /www/wwwroot/fuxa/db:/usr/src/app/FUXA/server/_db \
  -v /www/wwwroot/fuxa/logs:/usr/src/app/FUXA/server/_logs \
  -v /www/wwwroot/fuxa/images:/usr/src/app/FUXA/server/_images \
  docker.xuanyuan.run/frangoteam/fuxa:1.3.4

docker logs -f --tail 100 fuxa
docker rm -f fuxa
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [frangoteam/fuxa 镜像页](https://xuanyuan.cloud/zh/r/frangoteam/fuxa) | [https://xuanyuan.cloud/zh/r/frangoteam/fuxa](https://xuanyuan.cloud/zh/r/frangoteam/fuxa) |
| [frangoteam/fuxa 概览](https://xuanyuan.cloud/r/frangoteam/fuxa) | [https://xuanyuan.cloud/r/frangoteam/fuxa](https://xuanyuan.cloud/r/frangoteam/fuxa) |
| [frangoteam/fuxa 标签列表](https://xuanyuan.cloud/r/frangoteam/fuxa/tags) | [https://xuanyuan.cloud/r/frangoteam/fuxa/tags](https://xuanyuan.cloud/r/frangoteam/fuxa/tags) |
| [GitHub · frangoteam/FUXA](https://github.com/frangoteam/FUXA) | [https://github.com/frangoteam/FUXA](https://github.com/frangoteam/FUXA) |
| [官方文档 · Installing and Running](https://frangoteam.github.io/FUXA/Installing-and-Running/) | [https://frangoteam.github.io/FUXA/Installing-and-Running/](https://frangoteam.github.io/FUXA/Installing-and-Running/) |
| [官方文档 · Settings](https://frangoteam.github.io/FUXA/Settings/) | [https://frangoteam.github.io/FUXA/Settings/](https://frangoteam.github.io/FUXA/Settings/) |
| [Live Demo](https://frangoteam.github.io) | [https://frangoteam.github.io](https://frangoteam.github.io) |
| [Docker Hub · frangoteam/fuxa](https://hub.docker.com/r/frangoteam/fuxa) | [https://hub.docker.com/r/frangoteam/fuxa](https://hub.docker.com/r/frangoteam/fuxa) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 钉死 **`frangoteam/fuxa:1.3.4`**，轩辕镜像加速拉取，Compose 映射 **1881** 并挂四卷  
- 实测日志 **V.1.3.4-2890**，`curl` 返回 **200**，浏览器先见 Loading 再进样例画面  
- 默认可不登录；生产启用认证并改掉 **`admin` / `123456`**  
- 协议走 **连接 + Server Plugins**；PLC 网络不通时再评估 host 模式  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/fuxa-docker-deploy



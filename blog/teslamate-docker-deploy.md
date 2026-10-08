# Docker 部署 TeslaMate：轻松搭建特斯拉车辆数据记录平台

![Docker 部署 TeslaMate：轻松搭建特斯拉车辆数据记录平台](https://imgs.xuanyuan.cloud/docker/blog/teslamate.webp)

*分类: Docker部署教程 | 标签: TeslaMate, Docker, 轩辕镜像, 特斯拉, Grafana, 车辆数据, 私有化部署, 部署教程 | 发布时间: 2026-10-08 12:09:28*

> TeslaMate 是特斯拉车辆的自托管数据记录器，把行程、充电和车辆状态写进自己的 PostgreSQL，并用 Grafana 看仪表板。本文用 Docker Compose 部署 teslamate/teslamate 之后，可以在浏览器里提交访问令牌，再打开里程与充电仪表板。适合想把车辆数据留在家里、又不想把账号交给第三方记录站的车主。

*本文基于 [teslamate/teslamate:4.3.0](https://xuanyuan.cloud/zh/r/teslamate/teslamate)，以 **4.3.0** 版本实测，配套 Grafana **4.3.0**（界面 **v13.2.2**），测试平台 **Ubuntu 24.04** Linux。*

周末把车停进地库，想对一下这周充了几次电、每趟高速实际掉了多少电。特斯拉 App 里只能来回翻最近的行程，更早的路线、充电曲线和停过的位置，要么还在官方账号里，要么已经交到 TeslaFi 这类记录站。记录站按月收费，接口还经常把车从休眠里叫醒。自己用表格记充电金额，过两个月电量、账单和停车位置就对不上。

把车辆位置和访问令牌放到别人的服务器上，对方停服、改价或者家里断网，历史就不是自己的。车要长期在线记数据，家里的 NAS 或小主机本来就一直开着，数据库放在这台机器上更合适。令牌加密后只留在本地，不经过另一家记录网站。

**TeslaMate**（[GitHub](https://github.com/teslamate-org/teslamate)、[镜像页](https://xuanyuan.cloud/zh/r/teslamate/teslamate)）是特斯拉车辆的自托管数据记录器。镜像 **`teslamate/teslamate`** 在你提交访问令牌之后拉取车辆状态，写入 PostgreSQL，并通过 MQTT 发布状态。浏览器打开 **4000** 端口看车辆和设置；同版本的 **`teslamate/grafana`** 提供行程、充电和能耗仪表板。本文使用 **`teslamate/teslamate:4.3.0`** 版本实测，Grafana 镜像使用同一版本号。

车辆开始记录之后，可以在自己的网页里看每趟行程和充电，在地图上标出家和公司，也可以把车辆状态接到家里的自动化。还没有车上报时，仪表板是空的。

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**。镜像提供 **amd64** 与 **arm64**。树莓派须使用 64 位系统，**armv7** 已不受支持 |
| Docker | Engine + **Compose V2** |
| 内存 | 至少 **1 GB**，建议 **2 GB** 可用 |
| 磁盘 | 行程和充电会持续写入数据库，先留出数 GB，并准备把备份拷离这台机器 |
| 网络 | 机器尽量一直开着，并能访问特斯拉接口。地理编码会访问 OpenStreetMap |
| 端口 | 宿主机 **4000** → TeslaMate **4000**；宿主机 **13300** → Grafana **3000**。MQTT **1883** 默认不映射到宿主机 |
| 工作目录 | `/www/wwwroot/teslamate`。macOS 上改为 `~/docker/teslamate` |

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

这套部署适合家里的网络。官方不建议把 TeslaMate 直接暴露到公网，否则车辆访问令牌有泄露风险。人在外面要看时，走 VPN、Tailscale、Cloudflare Tunnel，或在反向代理上加上访问控制。出站要能访问 `auth.tesla.com`、`nominatim.openstreetmap.org`，以及 HTTP 的 `step.esa.int`。本文 Compose 使用中国区的 `owner-api.vn.cloud.tesla.cn` 和 `streaming.vn.cloud.tesla.cn`。国际区账号删掉这两行后，再放行 `owner-api.teslamotors.com` 和 `streaming.vn.teslamotors.com`。

宿主机 **4000** 或 **13300** 已被占用时，只改冒号左侧，并在后文「URLs」里填写改过的地址。

---

## 二、标签怎么选

下面四行是本文使用的标签。`latest`、`4.3`、`18-trixie` 和 Mosquitto 的 `2` 会随仓库变动，不要写进 pull 和 Compose。

| 标签 | 含义 | 建议 |
|------|------|------|
| **`teslamate/teslamate:4.3.0`** | 2026-09-29 发布的 4.3.0。发行说明写明仪表板使用 Grafana **13.2.2** | **本文使用** |
| **`teslamate/grafana:4.3.0`** | 与 TeslaMate 同号的仪表板镜像，已带好数据源和面板 | **必须与 TeslaMate 同号** |
| **`library/postgres:18.6-trixie`** | 官方示例里的 `postgres:18-trixie` 目前对应 PostgreSQL **18.6** | **本文使用** |
| **`library/eclipse-mosquitto:2.1.2-alpine`** | 官方示例里的 `eclipse-mosquitto:2` 目前指向 2.1 Alpine。镜像内带 `/mosquitto-no-auth.conf` | **本文使用** |
| `latest`、`4.3`、`18-trixie`、`2` | 浮动标签 | 不写入本文命令 |

`4.3` 只写到次版本，以后的补丁仍会落到这个标签上。仪表板不要换成 `grafana/grafana`，否则没有 TeslaMate 的面板和自动数据源。完整列表见 [teslamate/teslamate 标签列表](https://xuanyuan.cloud/r/teslamate/teslamate/tags)。升级前先看[发行说明](https://github.com/teslamate-org/teslamate/releases)，再改 `image:`。

---

## 三、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取。四份镜像都要拉，只拉 TeslaMate 起不来。

```bash
docker pull docker.xuanyuan.run/teslamate/teslamate:4.3.0
docker pull docker.xuanyuan.run/teslamate/grafana:4.3.0
docker pull docker.xuanyuan.run/library/postgres:18.6-trixie
docker pull docker.xuanyuan.run/library/eclipse-mosquitto:2.1.2-alpine
```

Ubuntu 24.04 上，TeslaMate、Grafana 和 Mosquitto 的第一次拉取停在 `timeout awaiting response headers`。原样再执行同一条 `docker pull` 后完成，已经下完的层不会重头再拉。PostgreSQL 一次完成。四份镜像的结束行如下。

```text
Digest: sha256:516fc9f0a14369f541b1a70ff2f65dd9b57c2e01c1f533b6d43b375445404955
Status: Downloaded newer image for docker.xuanyuan.run/teslamate/teslamate:4.3.0
docker.xuanyuan.run/teslamate/teslamate:4.3.0
```

```text
Digest: sha256:7f5a119ad06c212c4122e12c957a6848b5718d9618826b5ce70a1ec12d84fed5
Status: Downloaded newer image for docker.xuanyuan.run/teslamate/grafana:4.3.0
docker.xuanyuan.run/teslamate/grafana:4.3.0
```

```text
Digest: sha256:74935e72241653ca55e0414067e6d8763aceb8a810eb51b452253ec3dcfc4336
Status: Downloaded newer image for docker.xuanyuan.run/library/postgres:18.6-trixie
docker.xuanyuan.run/library/postgres:18.6-trixie
```

```text
Digest: sha256:38c0da4f2ef84284d47b3b3eeea1cb3bdeabe81ee10caf0cd5c5ff61ee3ea408
Status: Downloaded newer image for docker.xuanyuan.run/library/eclipse-mosquitto:2.1.2-alpine
docker.xuanyuan.run/library/eclipse-mosquitto:2.1.2-alpine
```

---

## 四、Docker Compose 部署（推荐）

工作目录用 `/www/wwwroot/teslamate`。macOS 上改为 **`~/docker/teslamate`**。

数据库密码和加密密钥放在同目录的 `.env`。Compose 会用它替换文件里的 `${TM_DB_PASS}` 和 `${ENCRYPTION_KEY}`。`.env` 只留在这台机器上，不要提交到 Git，也不要贴进工单。

### 4.1 创建目录

```bash
sudo mkdir -p /www/wwwroot/teslamate/import
sudo chown -R "$USER:$USER" /www/wwwroot/teslamate
cd /www/wwwroot/teslamate

# macOS：mkdir -p ~/docker/teslamate/import && cd ~/docker/teslamate
```

`import` 挂进容器的 `/opt/app/import`，给 TeslaFi 一类外部记录导入用。暂时不导入也可以留空目录。

### 4.2 生成密钥

还没有 `.env` 时才执行下面这一段。已经启动过再执行，会换掉加密密钥和数据库密码，旧令牌解不开，已初始化的数据库密码也不会跟着变。

```bash
cd /www/wwwroot/teslamate
if [ ! -f .env ]; then
  umask 077
  printf 'ENCRYPTION_KEY=%s
TM_DB_PASS=%s
' "$(openssl rand -hex 32)" "$(openssl rand -hex 24)" > .env
  chmod 600 .env
fi
test -s .env && echo ".env 已就绪"
```

需要离机备份这两行时，在本机执行 `cat .env`，把内容放进密码管理器。不要把 `.env` 发到公开场合。

### 4.3 编写 docker-compose.yml

下面文件里的 `TESLA_API_HOST` 和 `TESLA_WSS_HOST` 是中国区地址，本次实测就用这两行。国际区账号删掉它们，程序才会用默认的 `owner-api.teslamotors.com` 和 `streaming.vn.teslamotors.com`。

Grafana 容器内仍监听 **3000**。宿主机改映到 **13300**，避免和本机前端开发抢 **3000**。浏览器访问 `http://服务器IP:13300`。

```bash
cd /www/wwwroot/teslamate
cat > docker-compose.yml <<'EOF'
services:
  teslamate:
    image: docker.xuanyuan.run/teslamate/teslamate:4.3.0
    container_name: teslamate
    restart: unless-stopped
    depends_on:
      - database
      - mosquitto
    environment:
      - ENCRYPTION_KEY=${ENCRYPTION_KEY}
      - DATABASE_USER=teslamate
      - DATABASE_PASS=${TM_DB_PASS}
      - DATABASE_NAME=teslamate
      - DATABASE_HOST=database
      - MQTT_HOST=mosquitto
      - TZ=Asia/Shanghai
      # 中国区账号保留下面两行。国际区账号删掉这两行。
      - TESLA_API_HOST=https://owner-api.vn.cloud.tesla.cn
      - TESLA_WSS_HOST=wss://streaming.vn.cloud.tesla.cn
    ports:
      - "4000:4000"
    volumes:
      - ./import:/opt/app/import
    cap_drop:
      - all

  database:
    image: docker.xuanyuan.run/library/postgres:18.6-trixie
    container_name: teslamate-db
    restart: unless-stopped
    environment:
      - POSTGRES_USER=teslamate
      - POSTGRES_PASSWORD=${TM_DB_PASS}
      - POSTGRES_DB=teslamate
      - TZ=Asia/Shanghai
    volumes:
      - teslamate-db:/var/lib/postgresql

  grafana:
    image: docker.xuanyuan.run/teslamate/grafana:4.3.0
    container_name: teslamate-grafana
    restart: unless-stopped
    depends_on:
      - database
    environment:
      - DATABASE_USER=teslamate
      - DATABASE_PASS=${TM_DB_PASS}
      - DATABASE_NAME=teslamate
      - DATABASE_HOST=database
      - TZ=Asia/Shanghai
    ports:
      - "13300:3000"
    volumes:
      - teslamate-grafana-data:/var/lib/grafana

  mosquitto:
    image: docker.xuanyuan.run/library/eclipse-mosquitto:2.1.2-alpine
    container_name: teslamate-mqtt
    restart: unless-stopped
    command: mosquitto -c /mosquitto-no-auth.conf
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - mosquitto-conf:/mosquitto/config
      - mosquitto-data:/mosquitto/data

volumes:
  teslamate-db:
  teslamate-grafana-data:
  mosquitto-conf:
  mosquitto-data:
EOF
```

| 项 | 说明 |
|----|------|
| `"4000:4000"` | 宿主机 **4000** → TeslaMate Web |
| `"13300:3000"` | 宿主机 **13300** → Grafana **3000** |
| `teslamate-db:/var/lib/postgresql` | PostgreSQL 18 的数据目录挂在这一层。不要改挂到旧的 `/var/lib/postgresql/data` |
| `ENCRYPTION_KEY` | 用来加密库里的 Tesla API 令牌。首次写入后一直沿用 |
| `TM_DB_PASS` | 同时写给 TeslaMate、Grafana 和 PostgreSQL。三处必须是同一个值 |
| `cap_drop: all` | 去掉 TeslaMate 容器的全部 Linux capabilities |
| MQTT **1883** | 没有 `ports`。匿名配置只在 Compose 网络里给 TeslaMate 用 |
| `depends_on` | 只保证数据库和 MQTT 容器先创建，不保证 PostgreSQL 已经接受连接 |

```text
浏览器 :4000 ──▶ teslamate ──▶ PostgreSQL
                      │
                      └──▶ mosquitto（仅容器网络，不映射 1883）

浏览器 :13300 ──▶ grafana:3000 ──▶ PostgreSQL
```

### 4.4 启动并验证

```bash
cd /www/wwwroot/teslamate
docker compose up -d
docker compose ps
docker compose logs --tail 80 teslamate
```

`depends_on` 不会等数据库完成初始化。PostgreSQL 还没听 5432 时，TeslaMate 会先报连不上，随后自己等待。日志停在 `connection refused` 时，先不要删除容器。

生成密钥后，终端打印 `.env 已就绪`。Ubuntu 24.04 上 `docker compose up -d` 的结果：

```text
[+] up 9/9
 ✔ Volume teslamate_teslamate-db           Created                                                                 0.5s
 ✔ Network teslamate_default               Created                                                                 0.5s
 ✔ Volume teslamate_mosquitto-conf         Created                                                                 0.2s
 ✔ Volume teslamate_mosquitto-data         Created                                                                 0.4s
 ✔ Volume teslamate_teslamate-grafana-data Created                                                                 0.2s
 ✔ Container teslamate-mqtt                Started                                                                 4.8s
 ✔ Container teslamate-db                  Started                                                                 5.7s
 ✔ Container teslamate                     Started                                                                 4.5s
 ✔ Container teslamate-grafana             Started                                                                 7.2s
```

```text
NAME                IMAGE                                                        COMMAND                  SERVICE     CREATED          STATUS          PORTS
teslamate           docker.xuanyuan.run/teslamate/teslamate:4.3.0                "tini -- /bin/dash /…"   teslamate   18 seconds ago   Up 12 seconds   0.0.0.0:4000->4000/tcp, [::]:4000->4000/tcp
teslamate-db        docker.xuanyuan.run/library/postgres:18.6-trixie             "docker-entrypoint.s…"   database    20 seconds ago   Up 13 seconds   5432/tcp
teslamate-grafana   docker.xuanyuan.run/teslamate/grafana:4.3.0                  "/run.sh"                grafana     18 seconds ago   Up 11 seconds   0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp
teslamate-mqtt      docker.xuanyuan.run/library/eclipse-mosquitto:2.1.2-alpine   "/docker-entrypoint.…"   mosquitto   20 seconds ago   Up 14 seconds   1883/tcp
```

Mosquitto 这一行只有 `1883/tcp`，前面没有 `0.0.0.0`，端口没有映射到宿主机。TeslaMate 和 Grafana 两行才有 `0.0.0.0:4000` 与 `0.0.0.0:13300`。

同一时刻 TeslaMate 日志里，`connection refused` 连续出现多次，然后出现等待数据库的一行：

```text
teslamate  | 2026-10-08 11:32:47.016 [error] Postgrex.Protocol (#PID<0.157.0> ("db_conn_2")) failed to connect: ** (DBConnection.ConnectionError) tcp connect (database:5432): connection refused - :econnrefused
teslamate  | 2026-10-08 11:32:47.016 [error] Postgrex.Protocol (#PID<0.156.0> ("db_conn_1")) failed to connect: ** (DBConnection.ConnectionError) tcp connect (database:5432): connection refused - :econnrefused
teslamate  | 2026-10-08 11:32:52.792 [info] Waiting for the database to accept connections
teslamate  | 2026-10-08 11:32:53.097 [error] Postgrex.Protocol (#PID<0.157.0> ("db_conn_2")) failed to connect: ** (DBConnection.ConnectionError) tcp connect (database:5432): connection refused - :econnrefused
teslamate  | 2026-10-08 11:32:53.097 [error] Postgrex.Protocol (#PID<0.156.0> ("db_conn_1")) failed to connect: ** (DBConnection.ConnectionError) tcp connect (database:5432): connection refused - :econnrefused
```

数据库接受连接之前，两个端口的 `curl` 都是 `000`。过一会儿再测，**4000** 变为 **302**，**13300** 在这次测试里仍是 `000`。按执行顺序是：

```text
http://127.0.0.1:4000/        000
http://127.0.0.1:13300/login  000
http://127.0.0.1:4000/        302
http://127.0.0.1:13300/login  000
```

对应命令：

```bash
curl -s -o /dev/null -w "%{http_code}
" http://127.0.0.1:4000/
curl -s -o /dev/null -w "%{http_code}
" http://127.0.0.1:13300/login
```

**4000** 返回 **302** 后，浏览器打开 `http://服务器IP:4000` 会进入 `/sign_in`。本次实测是 `http://192.168.1.35:4000/sign_in`。这一页先不要填特斯拉密码，令牌在下一节生成。

Grafana 比 TeslaMate 慢。刚启动时 **13300** 会是 `000`，浏览器也可能提示 `ERR_CONNECTION_REFUSED`。隔十几秒再执行同一条 `curl`，直到返回 **200**，再打开 `http://服务器IP:13300`。本次稍后返回 **200**，页面是 `http://192.168.1.35:13300/login`。两分钟后仍是 `000` 时，按常见问题里 Grafana 拒绝连接那一节检查容器。

---

## 五、浏览器首次使用

特斯拉不允许第三方程序用账号密码直接登录。令牌在你自己的电脑上生成。不要把账号密码或令牌写进 `docker-compose.yml`、`.env`，也不要发到公开网页。

### 5.1 用 Tesla Auth 生成令牌

1. 打开 [Tesla Auth 0.15.0](https://github.com/adriankumpf/tesla_auth/releases/tag/v0.15.0)，下载本机系统的压缩包。本次 Windows 用的是 `tesla_auth-x86_64-pc-windows-msvc.zip`。macOS 与 Linux 的包在同一页。
2. 解压后打开 Tesla Auth。窗口里是特斯拉登录页。右上角为 CN 时，在「邮箱」里填账号，点「下一步」。若页面要求验证码或二次验证，在这个窗口里完成。

![Tesla Auth 打开特斯拉登录页，地区为 CN，邮箱和「下一步」](https://imgs.xuanyuan.cloud/docker/blog/teslamate-11.webp)

3. 登录完成后，同一窗口变成 Tesla API Tokens。上面复制 ACCESS TOKEN，下面复制 REFRESH TOKEN。底部绿色文字是 Valid for 8 hours，指的是上面这条访问令牌。刷新令牌也要复制，TeslaMate 之后用它换新的访问令牌。

![Tesla Auth 显示 ACCESS TOKEN 与 REFRESH TOKEN](https://imgs.xuanyuan.cloud/docker/blog/teslamate-10.webp)

### 5.2 在 TeslaMate 登录

本机 `curl` 到 **4000** 返回 **302** 后，浏览器打开 `http://服务器IP:4000`。地址会变成 `/sign_in`。

把 ACCESS TOKEN 贴进「令牌」，把 REFRESH TOKEN 贴进「刷新令牌」，点「登录」。按钮下方写着要通过 Tesla API 获取令牌。页上还有「令牌是什么」和「如何登录？」。

![TeslaMate 登录页：令牌、刷新令牌和「登录」](https://imgs.xuanyuan.cloud/docker/blog/teslamate-1.webp)

提交成功后，页顶出现绿色的「登录成功」。TeslaMate 用 `ENCRYPTION_KEY` 把令牌加密存进数据库。账号里当时没有可读的车时，中间显示 No vehicle is logged，并有按钮 Reload vehicles。等车辆出现在特斯拉 App 里再点它。已经在记录的车不会被这次重载打断。

![登录成功后提示 No vehicle is logged，可点 Reload vehicles](https://imgs.xuanyuan.cloud/docker/blog/teslamate-2.webp)

### 5.3 修改 Grafana 初始密码并切换中文

**13300** 返回 **200** 后，打开 `http://服务器IP:13300`。页脚是 Grafana **v13.2.2**。用户名 `admin`，密码 `admin`，点 Log in。

![Grafana 登录页 Welcome to Grafana，页脚 v13.2.2](https://imgs.xuanyuan.cloud/docker/blog/teslamate-4.webp)

下一页是 Update your password，提示继续使用默认密码有风险。填写 New password 和 Confirm new password，点 Submit。不要点 Skip。

![Grafana 要求设置新密码，New password 与 Confirm new password](https://imgs.xuanyuan.cloud/docker/blog/teslamate-5.webp)

进入后，左侧 Dashboards 里已有 Battery Health、Drives、Charges、Overview、Temperatures 等面板。数据源也在 `teslamate/grafana:4.3.0` 里，不用再添加 PostgreSQL。

![Grafana 首页仪表板列表，含 Overview、Drives、Charges、Temperatures](https://imgs.xuanyuan.cloud/docker/blog/teslamate-6.webp)

这时菜单还是英文。打开 Administration → General → Default preferences，语言选「中文（简体）」，点 Save preferences。刷新后侧栏变为「仪表板」。

![Grafana Default preferences 中选择「中文（简体）」](https://imgs.xuanyuan.cloud/docker/blog/teslamate-7.webp)

### 5.4 填写两边的地址

回到 TeslaMate，打开右上角「设置」，找到「URLs」。

- 「Web应用程序」填 `http://服务器IP:4000`
- 「控制台」填 `http://服务器IP:13300`

「控制台」的初始值是 `grafana.example.com`。留着它，仪表板链接会指到错误的主机。不要填容器内部的 **3000**。本次截图里「Web应用程序」已是 `http://192.168.1.35:4000`，「控制台」还是示例域名，要改成 `http://192.168.1.35:13300`。宿主机端口改过的话，两处跟着改。

「语言」一节是另一组同名下拉框，不要和上面的地址搞混。本次「语言」里的「Web应用程序」为 Chinese (simplified)，「地址」为 English。单位是长度 km、温度 °C、胎压 bar。页底「当前固件版本」为 **4.3.0**。

![TeslaMate 设置页：语言、单位，以及 URLs 中的 Web应用程序与控制台](https://imgs.xuanyuan.cloud/docker/blog/teslamate-3.webp)

---

## 六、记录之后能看什么

还没有车辆在记录时，仪表板是空的。Battery Health 上是 No data。Overview 上 Charge Level、Range、Odometer 是「无数据」或 N/A，States 写着「数据缺少时间字段」。这是还没有行程，不是数据源没配上。车开始上报后，同一批面板才会有数。

![Grafana Battery Health：尚未记录时各面板为 No data](https://imgs.xuanyuan.cloud/docker/blog/teslamate-8.webp)

![Grafana Overview：Charge Level、里程与 States 尚无数据](https://imgs.xuanyuan.cloud/docker/blog/teslamate-9.webp)

首页列表里的 Temperatures 是 4.3.0 增加的历史温度面板。小区地址对不准时，用地理围栏标出家和公司。能耗要等有效充电之后才有估算，车不休眠时先看常见问题。MQTT **1883** 没有映射到宿主机：这份 Mosquitto 允许匿名连接，只给同一 Compose 网络里的 TeslaMate 用。接到家里的自动化时，只在局域网发布端口，不要对公网开放。

---

## 七、备选：docker run

没有 Compose 时用这一节。日常部署仍用第四节。已经用 Compose 起过同名容器时，先停掉，不要加 `-v`，否则数据卷会被删掉：

```bash
cd /www/wwwroot/teslamate
docker compose down
```

下面这组 `docker run` 使用单独的网络和卷名，不会读到 Compose 项目前缀下的那几份卷。两套不要同时往同一个库写。

密钥仍用 4.2 节的 `.env`。

```bash
cd /www/wwwroot/teslamate
set -a
. ./.env
set +a

docker network create teslamate
docker volume create teslamate-db
docker volume create teslamate-grafana-data
docker volume create teslamate-mosquitto-conf
docker volume create teslamate-mosquitto-data
```

先启动数据库和 MQTT。`--network-alias` 让后面的容器仍能用主机名 `database` 和 `mosquitto`。

```bash
docker run -d 
  --name teslamate-db 
  --network teslamate 
  --network-alias database 
  --restart unless-stopped 
  -e POSTGRES_USER=teslamate 
  -e POSTGRES_PASSWORD="$TM_DB_PASS" 
  -e POSTGRES_DB=teslamate 
  -e TZ=Asia/Shanghai 
  -v teslamate-db:/var/lib/postgresql 
  docker.xuanyuan.run/library/postgres:18.6-trixie

docker run -d 
  --name teslamate-mqtt 
  --network teslamate 
  --network-alias mosquitto 
  --restart unless-stopped 
  -e TZ=Asia/Shanghai 
  -v teslamate-mosquitto-conf:/mosquitto/config 
  -v teslamate-mosquitto-data:/mosquitto/data 
  docker.xuanyuan.run/library/eclipse-mosquitto:2.1.2-alpine 
  mosquitto -c /mosquitto-no-auth.conf
```

确认 `teslamate-db` 的状态是 Up 之后，再启动 TeslaMate 和 Grafana。国际区账号删掉 TeslaMate 命令里的 `TESLA_API_HOST` 和 `TESLA_WSS_HOST`。

```bash
docker inspect -f '{{.State.Status}}' teslamate-db

docker run -d 
  --name teslamate 
  --network teslamate 
  --restart unless-stopped 
  --cap-drop ALL 
  -p 4000:4000 
  -e ENCRYPTION_KEY="$ENCRYPTION_KEY" 
  -e DATABASE_USER=teslamate 
  -e DATABASE_PASS="$TM_DB_PASS" 
  -e DATABASE_NAME=teslamate 
  -e DATABASE_HOST=database 
  -e MQTT_HOST=mosquitto 
  -e TZ=Asia/Shanghai 
  -e TESLA_API_HOST=https://owner-api.vn.cloud.tesla.cn 
  -e TESLA_WSS_HOST=wss://streaming.vn.cloud.tesla.cn 
  -v "$PWD/import:/opt/app/import" 
  docker.xuanyuan.run/teslamate/teslamate:4.3.0

docker run -d 
  --name teslamate-grafana 
  --network teslamate 
  --restart unless-stopped 
  -p 13300:3000 
  -e DATABASE_USER=teslamate 
  -e DATABASE_PASS="$TM_DB_PASS" 
  -e DATABASE_NAME=teslamate 
  -e DATABASE_HOST=database 
  -e TZ=Asia/Shanghai 
  -v teslamate-grafana-data:/var/lib/grafana 
  docker.xuanyuan.run/teslamate/grafana:4.3.0
```

访问地址与第五节相同：`http://服务器IP:4000` 和 `http://服务器IP:13300`。

---

## 八、备份、恢复与升级

升级或恢复之前，先把备份文件拷到另一台机器或另一块盘。官方提醒：有的图形界面升级会删掉存放 `docker-compose.yml` 的目录，备份若只留在这个目录里会一起丢失。

### 8.1 备份

在 Compose 目录执行。`-T` 要保留，否则计划任务里会因为没有 TTY 而失败。

```bash
cd /www/wwwroot/teslamate
docker compose exec -T database pg_dump -U teslamate teslamate > ./teslamate.bck
```

把 `teslamate.bck` 拷离这台主机后再做升级。

### 8.2 恢复

下面的 SQL 会删掉当前库里的 `public` 和 `private`。只有备份文件确认可读时才执行。执行前先停掉 TeslaMate，避免它继续写入。

```bash
cd /www/wwwroot/teslamate
docker compose stop teslamate

docker compose exec -T database psql -U teslamate teslamate <<'SQL'
DROP SCHEMA IF EXISTS public CASCADE;
DROP SCHEMA IF EXISTS private CASCADE;
CREATE SCHEMA public;
CREATE EXTENSION cube WITH SCHEMA public;
CREATE EXTENSION earthdistance WITH SCHEMA public;
SQL

docker compose exec -T database psql -U teslamate -d teslamate < ./teslamate.bck
docker compose start teslamate
```

### 8.3 升级

先看[升级说明](https://docs.teslamate.org/docs/upgrading)和对应版本的发行说明。大版本可能要求按顺序经过中间版本。备份完成之后，把 `docker-compose.yml` 里的 TeslaMate 和 Grafana 标签改成同一个新版本号，再执行：

```bash
cd /www/wwwroot/teslamate
docker compose pull
docker compose up -d
```

不要把 `image:` 改回 `latest`。PostgreSQL 大版本升级不是改个标签就能完成的，新装才使用本文的 `18.6-trixie` 和 `/var/lib/postgresql`。从旧数据目录迁过来时，先按官方升级文档处理，不要把原来的数据目录直接绑到这个新路径上。

---

## 九、常见问题

**Q1：4000 打不开，或日志里全是 connection refused？**

刚启动时 PostgreSQL 还没听 5432，TeslaMate 会打印 `tcp connect (database:5432): connection refused`，接着出现 `Waiting for the database to accept connections`。这是在等数据库，不是密码写错。等本机 `curl` 到 **4000** 返回 **302** 再开浏览器。若一直不出现 302，再看 `docker compose ps` 里 `teslamate-db` 是否为 Up。

**Q2：等了两分钟，13300 仍是 000？**

刚启动时 Grafana 比 TeslaMate 慢，`curl` 先是 `000` 属于正常，隔十几秒再测。本次后来返回 **200**。两分钟后仍拒绝连接，再执行：

```bash
docker compose ps grafana
docker inspect teslamate-grafana --format 'Status={{.State.Status}} OOMKilled={{.State.OOMKilled}} ExitCode={{.State.ExitCode}}'
docker compose logs --tail 100 grafana
```

`OOMKilled=true` 或状态为 Restarting 时，先给这台机器留出更多可用内存，再 `docker compose up -d`。局域网能开 4000、却一直打不开 13300，同样先看容器是否还在，不要先改防火墙。

**Q3：为什么 Grafana 不用宿主机 3000？**

容器内监听的是 **3000**。宿主机 **3000** 经常被本机前端占用，所以本文映成 **13300**。TeslaMate 设置页的「控制台」要填 `http://服务器IP:13300`，不要填 `grafana.example.com`，也不要填容器内部端口。

**Q4：为什么命令里不写 `latest`？**

`latest`、`4.3`、`18-trixie` 和 Mosquitto 的 `2` 都会指向以后的构建。数据库目录、匿名 MQTT 配置和面板字段变了，旧命令可能起不来。本文命令使用 **4.3.0**、**18.6-trixie** 和 **2.1.2-alpine**。

**Q5：中国区账号没有数据？**

本文 Compose 已经写了 `TESLA_API_HOST=https://owner-api.vn.cloud.tesla.cn` 和 `TESLA_WSS_HOST=wss://streaming.vn.cloud.tesla.cn`。国际区账号如果没删这两行，车辆数据会拉不下来，删掉后执行 `docker compose up -d`。认证主机默认仍是 `auth.tesla.com`。车队接口是另一套变量，见[官方 API 配置](https://docs.teslamate.org/docs/configuration/api)。

**Q6：登录页提示令牌无效？**

先看 TeslaMate 日志，是令牌本身被拒绝，还是这台机器访问 `auth.tesla.com` 失败。重新生成一对 access token 和 refresh token，再在登录页提交。再次登录不会清掉已经记下来的行程。数据中心的公网 IP 有时会被特斯拉拒绝，家里的网络通常更合适。

**Q7：改了 `.env` 里的数据库密码，容器仍报认证失败？**

`POSTGRES_PASSWORD` 只在数据目录第一次初始化时生效。库已经建好后，要在 PostgreSQL 里改用户密码，并让 TeslaMate、Grafana 的 `DATABASE_PASS` 与新密码一致，再重建这两个容器。还没任何数据时，删掉数据卷再启动会按新的 `.env` 初始化，已有行程会一起消失。

**Q8：能换 `ENCRYPTION_KEY` 吗？**

不要在已有数据上直接换成另一串 `ENCRYPTION_KEY`。库里的令牌是用它加密的，对不上就无法解密。需要更换时，先准备好新的 ACCESS TOKEN 和 REFRESH TOKEN，确认能重新登录，再改 `.env` 并重建 TeslaMate 容器。行程记录不靠这串密钥存放。

**Q9：车不出现，或者 Grafana 里没有能耗？**

新车或登录后才交付的车，点 Reload vehicles。概览写着数据采集被禁用时，到「设置」里打开这辆车。若提示限流，等几分钟再试。能耗不是接口直接给的，要至少两次充电：每次长于 10 分钟，且开始时电量低于 95%。面板上车名是 `null` 时，到车机里给车辆起名。地址来自 OpenStreetMap，对不准时在 TeslaMate 里画地理围栏。

**Q10：车一直不休眠？**

车机若打开了配件供电，即使没有插配件也会保持唤醒，可在车辆控制里关掉。另一套记录程序若同时在拉车辆数据，也会把休眠计时清掉。MCU1（约 2018 年 3 月前的 Model S / X，信息娱乐处理器为 NVIDIA Tegra）还要按官方 FAQ 调整节能、始终连接和座舱过热保护。TeslaMate 在空闲约 3 分钟后会暂停记录，再过一段时间才回来看车是否已经睡着。

**Q11：ARM 拉取失败？**

报 `no matching manifest` 时，到对应[标签页](https://xuanyuan.cloud/r/teslamate/teslamate/tags)看该标签是否包含你的架构。TeslaMate 提供 amd64 和 arm64。32 位的 armv7 不在支持范围内。

**Q12：和镜像站上的其他 teslamate 镜像怎么区分？**

本文只部署官方 **`teslamate/teslamate`**，仪表板只用同版本的 **`teslamate/grafana`**。其他命名空间下的 teslamate 镜像不在本文范围内，数据目录和登录方式不要混用。

**Q13：拉取停在 timeout awaiting response headers？**

同一条 `docker pull` 再执行一次。报错是某一层的响应头超时，已经 Pull complete 的层会留在本地。本次 TeslaMate、Grafana、Mosquitto 都是第二次拉取完成的。

---

## 十、命令速查

```bash
docker pull docker.xuanyuan.run/teslamate/teslamate:4.3.0
docker pull docker.xuanyuan.run/teslamate/grafana:4.3.0
docker pull docker.xuanyuan.run/library/postgres:18.6-trixie
docker pull docker.xuanyuan.run/library/eclipse-mosquitto:2.1.2-alpine

cd /www/wwwroot/teslamate
# macOS：cd ~/docker/teslamate
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 teslamate
curl -s -o /dev/null -w "%{http_code}
" http://127.0.0.1:4000/
curl -s -o /dev/null -w "%{http_code}
" http://127.0.0.1:13300/login
# 4000 返回 302 后打开 http://服务器IP:4000/sign_in
# 13300 返回 200 后打开 http://服务器IP:13300

docker compose exec -T database pg_dump -U teslamate teslamate > ./teslamate.bck

docker compose down
```

没有 Compose 时，数据库、Mosquitto、TeslaMate 和 Grafana 要按第七节的顺序启动。只拷贝其中一条 `docker run` 起不来。

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [teslamate/teslamate 镜像页](https://xuanyuan.cloud/zh/r/teslamate/teslamate) | [https://xuanyuan.cloud/zh/r/teslamate/teslamate](https://xuanyuan.cloud/zh/r/teslamate/teslamate) |
| [teslamate/teslamate 概览](https://xuanyuan.cloud/r/teslamate/teslamate) | [https://xuanyuan.cloud/r/teslamate/teslamate](https://xuanyuan.cloud/r/teslamate/teslamate) |
| [teslamate/teslamate 标签列表](https://xuanyuan.cloud/r/teslamate/teslamate/tags) | [https://xuanyuan.cloud/r/teslamate/teslamate/tags](https://xuanyuan.cloud/r/teslamate/teslamate/tags) |
| [teslamate/grafana 镜像页](https://xuanyuan.cloud/r/teslamate/grafana) | [https://xuanyuan.cloud/r/teslamate/grafana](https://xuanyuan.cloud/r/teslamate/grafana) |
| [library/postgres 镜像页](https://xuanyuan.cloud/r/library/postgres) | [https://xuanyuan.cloud/r/library/postgres](https://xuanyuan.cloud/r/library/postgres) |
| [library/eclipse-mosquitto 镜像页](https://xuanyuan.cloud/r/library/eclipse-mosquitto) | [https://xuanyuan.cloud/r/library/eclipse-mosquitto](https://xuanyuan.cloud/r/library/eclipse-mosquitto) |
| [Docker Hub · teslamate/teslamate](https://hub.docker.com/r/teslamate/teslamate) | [https://hub.docker.com/r/teslamate/teslamate](https://hub.docker.com/r/teslamate/teslamate) |
| [GitHub · teslamate-org/teslamate](https://github.com/teslamate-org/teslamate) | [https://github.com/teslamate-org/teslamate](https://github.com/teslamate-org/teslamate) |
| [Tesla Auth 0.15.0](https://github.com/adriankumpf/tesla_auth/releases/tag/v0.15.0) | [https://github.com/adriankumpf/tesla_auth/releases/tag/v0.15.0](https://github.com/adriankumpf/tesla_auth/releases/tag/v0.15.0) |
| [Docker 安装说明](https://docs.teslamate.org/docs/installation/docker) | [https://docs.teslamate.org/docs/installation/docker](https://docs.teslamate.org/docs/installation/docker) |
| [环境变量](https://docs.teslamate.org/docs/configuration/environment_variables) | [https://docs.teslamate.org/docs/configuration/environment_variables](https://docs.teslamate.org/docs/configuration/environment_variables) |
| [升级说明](https://docs.teslamate.org/docs/upgrading) | [https://docs.teslamate.org/docs/upgrading](https://docs.teslamate.org/docs/upgrading) |
| [备份](https://docs.teslamate.org/docs/maintenance/backup_restore) | [https://docs.teslamate.org/docs/maintenance/backup_restore](https://docs.teslamate.org/docs/maintenance/backup_restore) |
| [恢复](https://docs.teslamate.org/docs/maintenance/restore) | [https://docs.teslamate.org/docs/maintenance/restore](https://docs.teslamate.org/docs/maintenance/restore) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/teslamate-docker-deploy


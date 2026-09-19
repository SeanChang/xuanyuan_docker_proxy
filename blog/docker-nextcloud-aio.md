# Docker 部署 Nextcloud AIO：轻松搭建私有云网盘平台

![Docker 部署 Nextcloud AIO：轻松搭建私有云网盘平台](https://imgs.xuanyuan.cloud/docker/blog/nextcloud-all-in-one.webp)

*分类: Docker部署教程 | 标签: Nextcloud,Nextcloud AIO,Docker,轩辕镜像,私有云,网盘,私有化部署,部署教程 | 发布时间: 2026-09-17 13:42:53*

> Nextcloud All-in-One（AIO）是官方推荐的一体化私有云安装方式：启动一个 mastercontainer，即可在浏览器里编排 Nextcloud、数据库、缓存与可选 Office / Talk / 备份等组件。本文将介绍如何通过 Docker Compose 部署 nextcloud/all-in-one，适合个人与小团队自托管文件同步、协作与网盘场景。

*本文基于 [nextcloud/all-in-one:latest](https://xuanyuan.cloud/zh/r/nextcloud/all-in-one)，实测界面 **Nextcloud AIO v14.1.1**，测试平台 **Ubuntu 24.04** Linux。*

家庭相册散落在手机相册、微信收藏和某云盘「共享文件夹」里；公司制度、合同 PDF 又不敢往外传——配额一涨价、账号一冻结，备份策略就跟着翻车。很多人不是不会用 Nextcloud，而是卡在**怎么一次装对**：PostgreSQL、Redis、反向代理、证书、在线 Office 拆成十几个容器自己拼，证书和升级最容易踩坑。

放到机房或等保场景，诉求更硬：**文件同步与协作最好不出域**。商业网盘有配额与合规边界；只跑 `library/nextcloud` 单镜像，数据库与缓存还得自己配。很多团队其实已经有一台跑 Docker 的 Ubuntu，缺的是官方推荐装法：镜像能拉、管理界面能开、可选组件在网页里勾选。

**Nextcloud All-in-One（AIO）**（[GitHub](https://github.com/nextcloud/all-in-one)、[镜像页](https://xuanyuan.cloud/zh/r/nextcloud/all-in-one)）是官方推荐的一体化安装方式。你只启动一个 **mastercontainer**，它通过 Docker Socket 编排 PostgreSQL、Redis、Apache、Nextcloud 核心以及可选的 Office / Talk / Borg 备份等，并提供浏览器里的 **AIO 管理界面**。社区镜像坐标为 **`nextcloud/all-in-one`**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| AIO 管理 | `https://服务器IP:8080`，用 passphrase 登录 |
| 文件同步 | 装完后登录 Nextcloud，桌面 / 手机客户端同步 |
| 共享协作 | 共享链接、评论；（若启用）在线 Office |
| 运维 | 回 AIO 界面更新容器、启用 Borg 备份 |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`nextcloud/all-in-one:latest`**，**Docker Compose** 启动 mastercontainer。把下文 IP 换成你的。无 Compose 见第七节。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第七节
> - **端口**：宿主机 **80 / 8080 / 8443**；装完后 Nextcloud 常用 **443**；Talk 另需 **3478/TCP+UDP**
> - **标签**：跟做 **`latest`**（官方稳定通道；mastercontainer 不以 Nextcloud 大版本号作日常标签）
> - **容器名 / 卷名**：**勿改** `nextcloud-aio-mastercontainer`、`nextcloud_aio_mastercontainer`
> - **镜像**：`docker.xuanyuan.run/nextcloud/all-in-one:latest`（DISK **336MB** / CONTENT **91.7MB**）
> - **账号**：AIO 首次生成随机 **passphrase**（无默认 `admin/123456`）；Nextcloud 管理员以安装完成页为准
> - **目录**：Linux `/www/wwwroot/nextcloud-aio`；macOS 跟做用 `~/docker/nextcloud-aio`
> - **Docker**：勿用 Snap 版；需挂载 `/var/run/docker.sock`（只读）

官方：[GitHub](https://github.com/nextcloud/all-in-one) · [镜像页](https://xuanyuan.cloud/zh/r/nextcloud/all-in-one) · [标签列表](https://xuanyuan.cloud/r/nextcloud/all-in-one/tags) · [反向代理](https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md)

---

## 一、Nextcloud AIO 是什么？

AIO 让你先面对 **管理界面**，再由它拉起真正跑业务的一组容器。

| | Nextcloud AIO（本文） | 只跑 `library/nextcloud` | 商业网盘 |
|--|----------------------|---------------------------|----------|
| 入口 | AIO 界面 + Nextcloud Web / 客户端 | 应用容器，库与缓存自配 | 公网 App / Web |
| 适合 | 少运维、跟官方装法 | 熟悉运维的定制部署 | 不想自己运维 |
| 数据 | 自有服务器 / 卷 | 自有服务器 | 服务商侧 |

```text
你（管理员）──浏览器 :8080 / :8443──▶ mastercontainer（AIO 界面）
                                          │
                                          │ 通过 docker.sock 创建/更新
                                          ▼
                    Apache + Nextcloud + PostgreSQL + Redis + …
用户 / 客户端 ────────── https://你的域名:443 ──────────▶ Nextcloud
```

| 类别 | 内容 |
|------|------|
| 核心（安装时自动） | Nextcloud、PostgreSQL、Redis、高性能文件推送、Apache 与 HTTPS |
| 可选（界面勾选） | Office、Talk（含 TURN）、Talk 录制、Borg 备份、Imaginary、ClamAV、全文搜索、白板、Docker Socket Proxy 等 |
| 社区容器 | Caddy、Fail2ban、Jellyfin 等，见 [community-containers](https://github.com/nextcloud/all-in-one/tree/main/community-containers#community-containers) |

社区版常见说法约 **100 用户**量级较合适；更大组织可评估 [Nextcloud Enterprise](https://nextcloud.com/enterprise/)。本文聚焦个人 / 小团队自托管。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04**；**勿用 Snap 版 Docker** |
| Docker | Engine + **Compose V2** |
| 内存 | 核心栈可用 ≥ **2 GB**；启用 Office / ClamAV / 全文搜索等建议 **≥ 4 GB** |
| 磁盘 | mastercontainer、sibling 镜像与用户文件需预留充足空间 |
| 端口（无反代） | **80**、**8080**、**8443**；装完后 Nextcloud 用 **443**；Talk 再放行 **3478/TCP+UDP** |
| 域名 | 公网访问建议域名指向本机；仅局域网见 [local-instance.md](https://github.com/nextcloud/all-in-one/blob/main/local-instance.md) |
| Docker Socket | `/var/run/docker.sock`（只读） |
| 工作目录 | `/www/wwwroot/nextcloud-aio` |

```bash
docker --version
docker compose version
# 确认不是 Snap 版（若输出含 /var/snap/docker/ 需先迁移）
sudo docker info | grep "Docker Root Dir"
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

---

## 三、拉取镜像

### 3.1 标签怎么选

mastercontainer **不以「Nextcloud 大版本号」作日常标签**，而用**通道标签**。上游稳定通道就是 **`latest`**，因此本文跟做写入 `latest`（不是随便用浮动标签）。

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`latest`** | 官方稳定通道 | **推荐（本文）** |
| `beta` | 测试通道 | 仅愿意跟测时 |
| `latest-arm64` / `beta-arm64` | 显式 ARM64 | 一般多架构 `latest`/`beta` 即可 |
| `develop` 及日期戳 | 开发 / 历史构建 | **勿上生产** |

完整列表见 [标签页](https://xuanyuan.cloud/r/nextcloud/all-in-one/tags)。切换通道：停掉并删除 **mastercontainer 容器**（配置在命名卷里，一般不丢数据），再用目标通道重新创建。见官方 [How to switch the channel](https://github.com/nextcloud/all-in-one#how-to-switch-the-channel)。

### 3.2 用轩辕镜像加速拉取

```bash
sudo mkdir -p /www/wwwroot/nextcloud-aio
cd /www/wwwroot/nextcloud-aio

docker pull docker.xuanyuan.run/nextcloud/all-in-one:latest
```

Ubuntu 24.04 实测：

```text
latest: Pulling from nextcloud/all-in-one
002ad7ebbc44: Pull complete
3a33cbf0663c: Pull complete
55afa1ecc21d: Pull complete
44566f85a7b9: Pull complete
1ba397214786: Pull complete
3e6fa4e541b8: Pull complete
f5fa6bb68a5a: Pull complete
e7a50b3f1b0c: Pull complete
f09e49d99f33: Pull complete
b5f44ff88506: Pull complete
4f4fb700ef54: Pull complete
4eaa08f0df9c: Pull complete
10c3e75df3f0: Pull complete
ca91098f052e: Pull complete
37982b131dcd: Pull complete
9fa7667ba37b: Pull complete
f729a8adf417: Pull complete
afde1e2b6703: Pull complete
deff77d80889: Pull complete
Digest: sha256:5686bbbc7f9eae21318078008ba6aa89195e09c5daaae2c9fb491d420966ff93
Status: Downloaded newer image for docker.xuanyuan.run/nextcloud/all-in-one:latest
docker.xuanyuan.run/nextcloud/all-in-one:latest
```

```bash
docker images | grep -i all-in-one
```

```text
docker.xuanyuan.run/nextcloud/all-in-one:latest   5686bbbc7f9e        336MB         91.7MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `nextcloud/all-in-one:latest` | `docker pull docker.xuanyuan.run/nextcloud/all-in-one:latest` |

> 安装过程中 AIO 还会再拉 sibling 容器（默认坐标在 `ghcr.io/nextcloud-releases/`）。国内直连 GHCR 失败时，见 FAQ。

---

## 四、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/nextcloud-aio`（macOS 跟做用 `~/docker/nextcloud-aio`）。

本文场景：**本机尚无 Nginx / 宝塔等前置反向代理**，且 **80 / 443 空闲**。若端口已被占用，见 FAQ。

### 4.1 编写 compose.yaml

```bash
cd /www/wwwroot/nextcloud-aio

cat > compose.yaml <<'EOF'
name: nextcloud-aio

services:
  nextcloud-aio-mastercontainer:
    image: docker.xuanyuan.run/nextcloud/all-in-one:latest
    init: true
    restart: always
    container_name: nextcloud-aio-mastercontainer
    volumes:
      - nextcloud_aio_mastercontainer:/mnt/docker-aio-config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    network_mode: bridge
    ports:
      - "80:80"
      - "8080:8080"
      - "8443:8443"
    # environment:
    #   NEXTCLOUD_DATADIR: /mnt/ncdata   # 须在首次安装前设定

volumes:
  nextcloud_aio_mastercontainer:
    name: nextcloud_aio_mastercontainer
EOF
```

| 项 | 说明 |
|----|------|
| `image` | `docker.xuanyuan.run/nextcloud/all-in-one:latest` |
| `container_name` / 卷名 | **勿改** |
| `80:80` | ACME / 跳转等 |
| `8080:8080` | AIO 管理界面（自签证书）；冲突可改成 `18080:8080` |
| `8443:8443` | 域名可达时带有效证书的 AIO 界面 |
| `docker.sock:ro` | 供 AIO 创建 / 管理其他容器 |

### 4.2 启动并验证

```bash
cd /www/wwwroot/nextcloud-aio
docker compose up -d
docker compose ps
docker logs nextcloud-aio-mastercontainer --tail 50
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Volume nextcloud_aio_mastercontainer    Created
 ✔ Container nextcloud-aio-mastercontainer Started

NAME                            IMAGE                                             COMMAND       SERVICE                         CREATED          STATUS                             PORTS
nextcloud-aio-mastercontainer   docker.xuanyuan.run/nextcloud/all-in-one:latest   "/start.sh"   nextcloud-aio-mastercontainer   15 seconds ago   Up 13 seconds (health: starting)   0.0.0.0:80->80/tcp, [::]:80->80/tcp, 0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp, 0.0.0.0:8443->8443/tcp, [::]:8443->8443/tcp, 9000/tcp
```

```text
Trying to fix docker.sock permissions internally...
Creating docker group internally with id 988
Initial startup of Nextcloud All-in-One complete!
You should be able to open the Nextcloud AIO Interface now on port 8080 of this server!
E.g. https://internal.ip.of.this.server:8080
⚠️ Important: do always use an ip-address if you access this port and not a domain as HSTS might block access to it later!

If your server has port 80 and 8443 open and you point a domain to your server, you can get a valid certificate automatically by opening the Nextcloud AIO Interface via:
https://your-domain-that-points-to-this-server.tld:8443
[  OK  ] php-fpm
[  OK  ] caddy-internal
[  OK  ] caddy-acme
[  OK  ] cron
[  OK  ] backup-time-file-watcher
[  OK  ] session-deduplicator
[  OK  ] domain-validator
[17-Sep-2026 13:00:01] NOTICE: fpm is running, pid 153
[17-Sep-2026 13:00:01] NOTICE: ready to handle connections
```

浏览器用 **服务器 IP** 打开（不要用域名访问 8080），例如：

```text
https://192.168.1.35:8080
```

必须用 **https://**。浏览器提示自签证书时选择继续。用域名访问 8080 可能暂时能开，之后常因 HSTS 出问题；若域名已指向本机且 80/8443 可达，也可用 `https://你的域名:8443`。

---

## 五、浏览器：AIO 初始化

### 5.1 保存 passphrase 并登录

首次多为 **`/setup`**：标题 **Passphrase** 下是一长串英文单词——**整串（含空格）就是 AIO 管理界面密码**，没有 `admin` / `123456`。抄到密码管理器后，点 **Open Nextcloud AIO login**。

![Nextcloud AIO setup 页：请抄下 Passphrase 后再进入登录](https://imgs.xuanyuan.cloud/docker/blog/nextcloud-all-in-one-1.webp)

在 **`/login`** 粘贴整串 passphrase，点 **Log in**。

![Nextcloud AIO 登录页：用 Passphrase 整串登录](https://imgs.xuanyuan.cloud/docker/blog/nextcloud-all-in-one-2.webp)

若已错过 setup 页：

```bash
sudo docker exec nextcloud-aio-mastercontainer grep password /mnt/docker-aio-config/data/configuration.json
```

使用 `"password"` 字段的整串。这是 **AIO 管理口令**；Nextcloud 网盘管理员账号由安装完成页另给。

### 5.2 提交域名

登录后进入 **New AIO instance**（实测 **v14.1.1**）。当前为 **normal mode**（AIO 自行处理 TLS），不能直接挂在 Nginx / 宝塔后面；必须反代时见 FAQ 与官方 [reverse-proxy.md](https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md)。

在输入框填 **Nextcloud 正式访问域名**（不要填裸 IP），点 **Submit domain**。提交前确认：

- DNS **A 记录**指向本机公网 IP（需要 IPv6 再配 AAAA；也可用 CNAME）
- 防火墙 / 路由放行 **443/TCP**（HTTP/3 再放 **443/UDP**）
- 没有域名：用界面 **Get a free one from deSEC**
- 仅内网：见 [local-instance.md](https://github.com/nextcloud/all-in-one/blob/main/local-instance.md)

下方 **Restore … from backup** 是还原旧实例用的，新建时不要填。

![Nextcloud AIO：填写并提交 Nextcloud 域名](https://imgs.xuanyuan.cloud/docker/blog/nextcloud-all-in-one-3.webp)

### 5.3 域名通过之后

按 AIO 界面继续；细节以官方说明为准。

| 步骤 | 做什么 | 参考 |
|------|--------|------|
| 勾选可选组件 | Office、Talk、备份、ClamAV 等；内存紧可先只装核心 | [all-in-one README](https://github.com/nextcloud/all-in-one#nextcloud-all-in-one) |
| 启动容器 | 等待 sibling 拉取并变为 running | 界面状态 / 日志；GHCR 失败见 FAQ |
| 启用 Talk | 放行 **3478/TCP**、**3478/UDP** | 官方端口说明 |
| 打开 Nextcloud | `https://你的域名`；**保存安装完成页的管理员账号密码** | [Nextcloud 文档](https://docs.nextcloud.com/) |

更新与 Borg 备份仍在 AIO 界面操作，不要手工 `docker stop` 各个业务容器。

---

## 六、进入 Nextcloud 之后

登录网盘后可上传文件、建共享链接、装桌面 / 手机客户端做同步；若勾选了 Office / Talk，还可在线编辑与音视频。客户端说明见 [Nextcloud 文档](https://docs.nextcloud.com/)。

| 能力 | 常见用法 |
|------|----------|
| 文件 | 上传、文件夹、共享链接、版本与回收站 |
| 客户端 | 官方桌面 / 手机同步 |
| 协作 | 评论；在线 Office（若已启用） |
| 日历 / 联系人 | CalDAV / CardDAV |
| Talk | 聊天与音视频（若已启用） |

---

## 七、备选：`docker run`（临时试玩 / 无 Compose）

```bash
sudo docker run \
  --detach \
  --init \
  --sig-proxy=false \
  --name nextcloud-aio-mastercontainer \
  --restart always \
  --publish 80:80 \
  --publish 8080:8080 \
  --publish 8443:8443 \
  --volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
  --volume /var/run/docker.sock:/var/run/docker.sock:ro \
  docker.xuanyuan.run/nextcloud/all-in-one:latest
```

长期运维仍建议第四节 Compose。浏览器步骤同第五节。

---

## 八、升级与备份

| 操作 | 怎么做 |
|------|--------|
| 更新业务容器 | AIO 界面：建议先备份 → Stop containers → Start and update containers |
| 更新 mastercontainer | 停删 mastercontainer 容器后，用同一 Compose / run 拉新镜像再创建；**勿删**配置卷 `nextcloud_aio_mastercontainer` |
| 备份 | AIO 界面启用 Borg；保管加密密码与备份路径 |
| 整机恢复 | 新机器装好 AIO 后，用界面「从备份恢复」并输入当时的加密密码 |

更细步骤见官方 README 的 Backup / Update 章节。

---

## 九、常见问题 FAQ

**Q：为什么跟做用 `latest`？**  
A：mastercontainer 日常发布是通道标签（`latest` / `beta`）。稳定通道跟做 **`latest`**；业务容器版本由 AIO 界面管理。

**Q：AIO 有没有默认密码？**  
A：没有。用 setup 页的整串 passphrase，或 §5.1 的 `docker exec … grep password`。

**Q：能只用 IP 当 Nextcloud 地址吗？**  
A：不能。公网用域名（或 deSEC）；纯内网见 [local-instance.md](https://github.com/nextcloud/all-in-one/blob/main/local-instance.md)。

**Q：容器名或卷名能改吗？**  
A：**不要改**，否则更新 / 备份易出问题。

**Q：Snap 版 Docker 可以用吗？**  
A：**不支持**。若 `Docker Root Dir` 在 `/var/snap/docker/`，请迁移到官方 Engine。

**Q：`compose up` 报 80 端口被占用？**  
A：可暂时注释 `80:80` 与 `8443:8443`，只留 `8080:8080` 进 AIO；长期与 Nginx/宝塔共存见下题。

**Q：已有 Nginx / 宝塔，如何反代共存？**  
A：不要让 AIO 抢 80/443。Compose 只映射管理口（如 `18080:8080`），并设置：

```yaml
environment:
  APACHE_PORT: 11000
  APACHE_IP_BINDING: 127.0.0.1
  SKIP_DOMAIN_VALIDATION: "true"
```

把域名 **443** 反代到 `http://127.0.0.1:11000`。AIO 管理用 `https://IP:18080`，不要再用面板反代这个管理口。完整说明见官方 [reverse-proxy.md](https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md)。

**Q：日志报 Could not pull image `ghcr.io/nextcloud-releases/...`？**  
A：组件默认走 GHCR，`registry-mirrors` 只加速 Docker Hub。可用轩辕拉 Hub 同名组件再标记为 GHCR 坐标，例如：

```bash
docker pull docker.xuanyuan.run/nextcloud/aio-domaincheck:latest
docker tag docker.xuanyuan.run/nextcloud/aio-domaincheck:latest \
  ghcr.io/nextcloud-releases/aio-domaincheck:latest
```

核心栈可按需预拉：`aio-apache`、`aio-nextcloud`、`aio-postgresql`、`aio-redis`、`aio-notify-push`、`aio-watchtower`（Hub：`nextcloud/<name>` → `ghcr.io/nextcloud-releases/<name>`）。Office / Talk / 备份等勾选后再拉对应镜像。

**Q：和 `library/nextcloud` 是一回事吗？**  
A：不是。前者是应用镜像本身；**AIO** 是官方一体化编排方案。

**Q：`docker pull` 报 401 / 402？**  
A：见 [轩辕镜像常见问题](https://xuanyuan.cloud/faq)。

---

## 十、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/nextcloud/all-in-one:latest

# Compose
cd /www/wwwroot/nextcloud-aio
docker compose up -d
docker compose ps
docker logs nextcloud-aio-mastercontainer --tail 50

# 取回 AIO passphrase
sudo docker exec nextcloud-aio-mastercontainer grep password /mnt/docker-aio-config/data/configuration.json
```

访问：`https://服务器IP:8080`（AIO）；装完后 `https://你的域名`（Nextcloud）。无 Compose 时见第七节 `docker run`。

---

## 十一、延伸阅读

| 资源 | 链接 |
|------|------|
| [nextcloud/all-in-one 镜像页](https://xuanyuan.cloud/zh/r/nextcloud/all-in-one) | [https://xuanyuan.cloud/zh/r/nextcloud/all-in-one](https://xuanyuan.cloud/zh/r/nextcloud/all-in-one) |
| [标签列表](https://xuanyuan.cloud/r/nextcloud/all-in-one/tags) | [https://xuanyuan.cloud/r/nextcloud/all-in-one/tags](https://xuanyuan.cloud/r/nextcloud/all-in-one/tags) |
| [GitHub · nextcloud/all-in-one](https://github.com/nextcloud/all-in-one) | [https://github.com/nextcloud/all-in-one](https://github.com/nextcloud/all-in-one) |
| [反向代理文档](https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md) | [https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md](https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md) |
| [本地 / 内网实例](https://github.com/nextcloud/all-in-one/blob/main/local-instance.md) | [https://github.com/nextcloud/all-in-one/blob/main/local-instance.md](https://github.com/nextcloud/all-in-one/blob/main/local-instance.md) |
| [Nextcloud 文档](https://docs.nextcloud.com/) | [https://docs.nextcloud.com/](https://docs.nextcloud.com/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 轩辕镜像加速拉取 **`nextcloud/all-in-one:latest`**，Compose 启动 mastercontainer  
- `https://IP:8080`：抄 passphrase → 登录 → 提交域名 → 按界面装完进 Nextcloud  
- 容器名与配置卷保持官方默认；80/443 已被占用时走 FAQ 反代  
- 更新与备份尽量在 AIO 界面完成；勿用 Snap 版 Docker  

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-nextcloud-aio



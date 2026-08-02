# 告别命令行！Docker 部署 phpMyAdmin，轻松管理 MySQL

![告别命令行！Docker 部署 phpMyAdmin，轻松管理 MySQL](https://img.xuanyuan.dev/docker/blog/phpmyadmin.webp)

*分类: Docker部署教程 | 标签: phpMyAdmin,Docker,轩辕镜像,MySQL,MariaDB,数据库管理,私有化部署,部署教程 | 发布时间: 2026-07-29 08:02:04*

> 开发机上改个表、查条慢 SQL，很多人习惯敲 mysql 客户端：换一台电脑就要重装命令行工具，还要记清主机、端口、证书路径。装 Navicat、DBeaver 等桌面客户端省事一些，但授权、版本对齐、多人共用同一套连接配置又是另一套成本；笔记本离岗、VPN 断线，库还在机房里，工具却跟人不跟服务器。

*本文基于 [library/phpmyadmin:5.2.3](https://xuanyuan.cloud/zh/r/library/phpmyadmin) 与 [library/mariadb:10.11](https://xuanyuan.cloud/zh/r/library/mariadb)，**Ubuntu 24.04** 实测。文末附登录、首页与库表结构等界面截图。*

开发机上改个表、查条慢 SQL，很多人习惯敲 `mysql` 客户端：换一台电脑就要重装命令行工具，还要记清主机、端口、证书路径。装 Navicat、DBeaver 等桌面客户端省事一些，但授权、版本对齐、多人共用同一套连接配置又是另一套成本；笔记本离岗、VPN 断线，库还在机房里，工具却跟人不跟服务器。

更麻烦的是**合规与内网**：连接串、查询历史、导出文件若落在公有云「在线库管」，审计过不了；纯命令行又难把「建库、导 SQL、看权限」教给不熟终端的同学。团队真正需要的往往是：**工具也跑在自己机器上、浏览器打开就能用、数据不出内网**。

**phpMyAdmin** 正是为此而生的免费开源 **MySQL / MariaDB Web 管理界面**（PHP + 浏览器）：建库建表、执行 SQL、导入导出、管理用户权限，都在网页里完成。官方 Docker 镜像已进入 Docker Hub 官方库 [`library/phpmyadmin`](https://xuanyuan.cloud/zh/r/library/phpmyadmin)（短名 `phpmyadmin`），由 [phpmyadmin/docker](https://github.com/phpmyadmin/docker) 维护——一条 Compose 就能把「库 + 管理台」拉起来，适合开发测试与内网运维自托管。

上手要点：phpMyAdmin **不是数据库本身**，需连上已有 MySQL/MariaDB（本文用 Compose 一并拉起 MariaDB）。登录用的是 **数据库用户名/密码**，镜像没有独立「默认管理员账号」。容器内 Web 端口为 **80**，本文映射宿主机 **8080**；若挂载会话目录 `/sessions`，宿主机目录须 **`chown 33:33`**，否则会 Permission denied（见 FAQ）。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`library/phpmyadmin:5.2.3`**（Apache 变体）与 MariaDB，`docker compose up -d` 启动，浏览器登录后完成浏览库表与日常操作演示。另附单容器连已有库、生产注意与 FAQ。

镜像说明见 [phpmyadmin 镜像页](https://xuanyuan.cloud/zh/r/library/phpmyadmin)，标签列表见 [tags](https://xuanyuan.cloud/r/library/phpmyadmin/tags)。官方文档：[docs.phpmyadmin.net](https://docs.phpmyadmin.net/)；Docker Hub：[phpmyadmin](https://hub.docker.com/_/phpmyadmin)。

---

## 一、phpMyAdmin 是什么？

**phpMyAdmin** 面向「要用浏览器管 MySQL / MariaDB，又不想每人装桌面客户端」的场景：它是**管理端**，不是数据库服务器。

核心能力一览：

| 能力 | 说明 |
|------|------|
| 库表管理 | 创建 / 删除数据库与表，浏览与编辑数据行 |
| SQL 执行 | 在线编辑器执行查询、查看结果 |
| 导入导出 | SQL / CSV 等导入导出，适合迁移与备份脚本 |
| 用户与权限 | 管理 MySQL 账户与授权（需具备相应权限） |
| 多服务器 | 可配置固定主机，或开启任意服务器登录（`PMA_ARBITRARY`） |

典型场景：

- 开发 / 测试环境用浏览器查库改表
- 内网运维统一入口，少装几个桌面客户端
- 与 MariaDB / MySQL 容器同 Compose 一键交付「库 + 管理界面」

与 **DbGate** 的区别：DbGate 是多引擎通用客户端；**phpMyAdmin 专攻 MySQL / MariaDB**，界面与生态更聚焦这一类库。

架构（本文 Compose 主路径）：

```text
浏览器 ──HTTP:8080──▶ phpmyadmin 容器(:80, Apache)
                           │
                    Compose 网络
                           │
                      MariaDB(:3306)
```

> **版本与定位**：本文使用 **`phpmyadmin:5.2.3`**（默认 **apache** 变体，开箱即访问）。生产请固定补丁版本；勿长期依赖裸 `latest`。`fpm` / `fpm-alpine` 仅适合已有独立 Web 服务器的场景，**不是**本文跟做主路径。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux 建议 **Ubuntu 24.04** |
| Docker | Engine + Compose V2（`docker compose`） |
| 内存 | 演示建议 ≥ **1 GB** 可用（MariaDB + phpMyAdmin） |
| 磁盘 | 镜像数百 MB + `./mysql` 数据增长 |
| 端口 | 宿主机 **8080** → 容器 **80** |
| 目录 | `/www/wwwroot/phpmyadmin` |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、标签怎么选

| 标签 | 说明 | 推荐 |
|------|------|------|
| **`5.2.3`** | 固定补丁版；未带后缀时即为 **apache** 变体 | **试用 / 生产首选**（本文） |
| `5.2.3-apache` / `5.2` / `5` | 同系列滚动或显式 apache | 可等同理解；生产仍建议钉死 `5.2.3` |
| `latest` | 跟踪最新稳定 | 仅临时试用 |
| `5.2.3-fpm` / `fpm-alpine` | 仅 PHP-FPM，需自备 Nginx/Apache | **勿作零基础主路径** |

标签列表：[xuanyuan.cloud/r/library/phpmyadmin/tags](https://xuanyuan.cloud/r/library/phpmyadmin/tags)。

---

## 四、拉取镜像（轩辕镜像加速）

```bash
grep -q '"docker.xuanyuan.run"' ~/.docker/config.json && echo "已登录" || echo "未登录"
# 未登录时：
# docker login docker.xuanyuan.run
```

```bash
sudo mkdir -p /www/wwwroot/phpmyadmin/{mysql,sessions}
# 会话目录必须让容器内 PHP（Debian apache 镜像多为 uid 33 / www-data）可写
sudo chown -R 33:33 /www/wwwroot/phpmyadmin/sessions
cd /www/wwwroot/phpmyadmin

docker pull docker.xuanyuan.run/library/phpmyadmin:5.2.3
docker pull docker.xuanyuan.run/library/mariadb:10.11
```

实测拉取输出（**Ubuntu 24.04**）：

```text
5.2.3: Pulling from library/phpmyadmin
...
Digest: sha256:b68f318c5fd85541795ed8eb4ced28ea6908a89910871783b3e479cc6c6d1e1b
Status: Downloaded newer image for docker.xuanyuan.run/library/phpmyadmin:5.2.3
docker.xuanyuan.run/library/phpmyadmin:5.2.3
```

```text
10.11: Pulling from library/mariadb
...
Digest: sha256:be981e4113326ada8d6004174dd09eeaefc03094037f811182a52d4f2e737350
Status: Downloaded newer image for docker.xuanyuan.run/library/mariadb:10.11
docker.xuanyuan.run/library/mariadb:10.11
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `phpmyadmin:5.2.3` | `docker pull docker.xuanyuan.run/library/phpmyadmin:5.2.3` |
| `mariadb:10.11` | `docker pull docker.xuanyuan.run/library/mariadb:10.11` |

> 短名 `docker.xuanyuan.run/phpmyadmin:5.2.3` 与带 `library/` 前缀通常等价；本文与同目录其他官方镜像文一致，统一写 **`library/phpmyadmin`**。

---

## 五、快速体验：Compose 一键起 MariaDB + phpMyAdmin

主路径：同一 Compose 网络内，phpMyAdmin 通过服务名 **`db`** 连接 MariaDB。

### 5.1 编写 `compose.yml`

```bash
cd /www/wwwroot/phpmyadmin
```

将下面内容写入 `compose.yml`（**务必把示例密码改成强密码**）：

```yaml
# /www/wwwroot/phpmyadmin/compose.yml
name: phpmyadmin

services:
  db:
    image: docker.xuanyuan.run/library/mariadb:10.11
    container_name: phpmyadmin-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ChangeMe_Root_Pass
      TZ: Asia/Shanghai
    volumes:
      - ./mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 10

  phpmyadmin:
    image: docker.xuanyuan.run/library/phpmyadmin:5.2.3
    container_name: phpmyadmin
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8080:80"
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
      UPLOAD_LIMIT: 64M
      TZ: Asia/Shanghai
    volumes:
      - ./sessions:/sessions:rw
```

参数说明：

| 配置 | 说明 |
|------|------|
| `MYSQL_ROOT_PASSWORD` | MariaDB root 密码；**登录 phpMyAdmin 时用同一组凭证** |
| `PMA_HOST: db` | Compose 服务名，容器间解析到 MariaDB |
| `8080:80` | 浏览器访问宿主机 **8080**；容器内 Apache 监听 **80** |
| `./mysql` | 数据库数据持久化 |
| `./sessions` | phpMyAdmin 会话目录；**宿主机目录须 `chown 33:33`**，否则会 Permission denied |
| `UPLOAD_LIMIT` | 提高导入大 SQL 时的上传限制（可按需调整） |

> **密码提醒**：文中 `ChangeMe_Root_Pass` 仅为示例。上线前必须修改；改密后需同步更新环境变量并重建相关容器（已有数据卷时勿随意改 root 策略，以免连不上）。
>
> **会话权限（必做）**：`sudo mkdir` 出来的 `sessions` 属主往往是 root，而容器内 PHP 以 **uid 33** 写 `/sessions`。未 `chown` 时浏览器会报 `session_start(): … Permission denied` / `path: /sessions`。创建目录后执行：`sudo chown -R 33:33 /www/wwwroot/phpmyadmin/sessions`。

### 5.2 启动与验证

```bash
# 若尚未改过属主，启动前再确认一次
sudo chown -R 33:33 /www/wwwroot/phpmyadmin/sessions

docker compose -f /www/wwwroot/phpmyadmin/compose.yml up -d
docker compose -f /www/wwwroot/phpmyadmin/compose.yml ps
```

期望：`phpmyadmin-db` 为 healthy / Up，`phpmyadmin` 为 Up，端口映射 `0.0.0.0:8080->80/tcp`。实测示例：

```text
NAME            IMAGE                                          STATUS                    PORTS
phpmyadmin      docker.xuanyuan.run/library/phpmyadmin:5.2.3   Up …                      0.0.0.0:8080->80/tcp
phpmyadmin-db   docker.xuanyuan.run/library/mariadb:10.11      Up … (healthy)            3306/tcp
```

```bash
docker compose -f /www/wwwroot/phpmyadmin/compose.yml logs --tail 50 phpmyadmin
curl -I http://127.0.0.1:8080
```

日志末尾可见 Apache 就绪（`Apache/2.4… PHP/8.3… configured -- resuming normal operations`）。`AH00558: Could not reliably determine the server's fully qualified domain name` 可忽略。实测 `curl -I` 返回 **HTTP/1.1 200 OK**。

浏览器打开：

```text
http://你的服务器IP:8080
```

若页面直接报 **Error during session start** / `Permission denied` / `path: /sessions`，说明 `./sessions` 属主不对（见下文 FAQ §9.1），先 `chown` 再刷新。

登录页填写：

| 字段 | 值（本文 Compose） |
|------|---------------------|
| 语言 | 建议选「中文 - Chinese simplified」 |
| 用户名 | `root` |
| 密码 | 你在 `MYSQL_ROOT_PASSWORD` 中设置的值 |

phpMyAdmin **没有** 独立默认账号；登不上请先核对 MariaDB 侧用户名密码与网络连通。

---

## 六、备选：单容器连已有库

已有 MySQL / MariaDB 时，不必再起 `db` 服务。

### 6.1 固定主机（`PMA_HOST`）

```bash
sudo mkdir -p /www/wwwroot/phpmyadmin/sessions
sudo chown -R 33:33 /www/wwwroot/phpmyadmin/sessions
docker rm -f phpmyadmin 2>/dev/null || true

docker run -d \
  --name phpmyadmin \
  --restart unless-stopped \
  -p 8080:80 \
  -e PMA_HOST=你的数据库主机或IP \
  -e PMA_PORT=3306 \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/phpmyadmin/sessions:/sessions:rw \
  docker.xuanyuan.run/library/phpmyadmin:5.2.3
```

注意：phpMyAdmin 容器内的 `localhost` / `127.0.0.1` 指向**自己**，不是宿主机。连宿主机上的库请用宿主机局域网 IP、`host.docker.internal`（需 Docker 支持）或 Compose 服务名。

### 6.2 登录页自填任意服务器（`PMA_ARBITRARY=1`）

适合临时连多台库、主机每次不同：

```bash
sudo mkdir -p /www/wwwroot/phpmyadmin/sessions
sudo chown -R 33:33 /www/wwwroot/phpmyadmin/sessions

docker run -d \
  --name phpmyadmin \
  --restart unless-stopped \
  -p 8080:80 \
  -e PMA_ARBITRARY=1 \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/phpmyadmin/sessions:/sessions:rw \
  docker.xuanyuan.run/library/phpmyadmin:5.2.3
```

打开登录页后自行填写服务器地址、用户名与密码。

> 官方文档仍有 `--link` 示例；新环境请优先使用 **Compose 自定义网络 / 服务名**，勿再依赖已过时的 link 方式。

---

## 七、浏览器登录与基础使用

会话权限正常后，按下面三步熟悉界面（与 Ubuntu 实测截图一致）。

### 7.1 登录页：选语言、填 root 密码

打开 `http://你的服务器IP:8080`。将「语言」选为 **中文 - Chinese simplified**；「用户名」填 **`root`**，「密码」填 Compose 里 `MYSQL_ROOT_PASSWORD` 的值，点「登录」。

（本文 Compose 已设 `PMA_HOST=db`，登录页通常**不再单独填服务器**；若你用了 `PMA_ARBITRARY=1`，才会出现服务器输入框。）

![phpMyAdmin 登录页：语言选中文简体，用户名 root，输入密码后点登录](https://img.xuanyuan.dev/docker/blog/phpmyadmin-1.webp)

### 7.2 首页：确认已连上 MariaDB

登录成功进入首页。右侧「数据库服务器」应类似：

| 项 | 实测示例 |
|----|----------|
| 服务器 | `db via TCP/IP`（Compose 服务名） |
| 服务器类型 / 版本 | MariaDB **10.11.x** |
| 网站服务器 | Apache + PHP **8.3.x** |
| phpMyAdmin 版本 | **5.2.3** |

左侧列出 `information_schema`、`mysql`、`performance_schema`、`sys` 等系统库。顶部有「数据库」「SQL」「导入」「导出」「用户账户」等入口。

页底若提示「高级功能尚未完全设置」：全新部署常见提示，**不影响**浏览库表、执行 SQL、导入导出；需要配置存储库时再查官方文档即可。

![phpMyAdmin 首页：左侧库列表，右侧显示 MariaDB 与 Apache/PHP 信息](https://img.xuanyuan.dev/docker/blog/phpmyadmin-2.webp)

### 7.3 浏览库表与新建表

在左侧点击某个库（例如系统库 **`mysql`**，或你自己新建的业务库），进入「结构」页：可见表名、行数、引擎、排序规则、大小；每行有「浏览 / 结构 / 搜索 / 插入」等操作。

页面底部「新建数据表」：填写「数据表名」、字段数，点「创建」，即可开始建表。

日常路径建议：

1. 顶部「数据库」→「创建数据库」建自己的业务库（勿改乱系统库）  
2. 点进该库 →「结构」→「新建数据表」  
3. 顶部「SQL」粘贴语句执行；「导入」上传 `.sql`（大文件见 FAQ）

![phpMyAdmin 结构页：展开 mysql 库表列表，底部可新建数据表](https://img.xuanyuan.dev/docker/blog/phpmyadmin-3.webp)

---

## 八、生产注意

| 项 | 建议 |
|----|------|
| 公网暴露 | phpMyAdmin 权限等同数据库账号；**勿裸奔公网**。优先内网、VPN，或反代 + 鉴权 / IP 白名单 |
| 密码 | 修改示例 `ChangeMe_Root_Pass`；生产用强密码，限制 root 远程来源 |
| 反代路径 | 若挂在子路径或域名后，设置 `PMA_ABSOLUTE_URI` 为完整 URL（如 `https://pma.example.net/`） |
| 会话 | 挂载 `/sessions` 且 **`chown 33:33`**，避免升级/重建丢会话与 Permission denied |
| 大文件导入 | 提高 `UPLOAD_LIMIT`、`MEMORY_LIMIT`、`MAX_EXECUTION_TIME` |
| 自定义配置 | 挂载 `config.user.inc.php` → `/etc/phpmyadmin/config.user.inc.php`（首行须 `<?php`），或挂载 `/etc/phpmyadmin/conf.d` |
| 变体 | 生产跟做继续用 **apache** 标签；自建 Web 栈再考虑 fpm |

SSL 连库时可设 `PMA_SSL=1`（多主机用 `PMA_SSLS`）。细节见 [官方 Docker README](https://github.com/phpmyadmin/docker)。

---

## 九、常见问题 FAQ

### 9.1 打开页面报 `session_start(): Permission denied` / `path: /sessions`

未改属主时，浏览器会看到红色 **phpMyAdmin - Error** 页，关键句为 `Permission denied (13)` 与 `path: /sessions`：

![phpMyAdmin 会话错误：Permission denied，session 路径 /sessions](https://img.xuanyuan.dev/docker/blog/phpmyadmin-error-1.webp)

挂载了宿主机 `./sessions`，但目录属主是 root，容器内 PHP（uid **33**）无法读写。**Ubuntu 24.04** 实测修复：

```bash
sudo chown -R 33:33 /www/wwwroot/phpmyadmin/sessions
docker compose -f /www/wwwroot/phpmyadmin/compose.yml restart phpmyadmin
```

成功时 Compose 输出类似：

```text
[+] Restarting 1/1
 ✔ Container phpmyadmin  Started
```

刷新浏览器应出现登录页（§7.1）。临时也可去掉 `volumes` 里的 sessions 挂载（会话仅保存在容器可写层，重建会丢）。官方 issue 亦提示检查 volume 权限：[phpmyadmin/docker#226](https://github.com/phpmyadmin/docker/issues/226)。

### 9.2 登录失败 / 连不上数据库

- 确认 `PMA_HOST`：Compose 内用服务名（本文 `db`）；连宿主机库勿填容器内的 `localhost`
- 核对用户名密码是否与 MariaDB / MySQL 一致
- `docker compose logs db` / `phpmyadmin` 查看拒绝原因（鉴权、未就绪、防火墙）

### 9.3 反代后样式错乱、空白页或跳转异常

设置环境变量 `PMA_ABSOLUTE_URI` 为浏览器实际访问的完整前缀（含协议与尾部 `/`）。

### 9.4 导入大 SQL 失败

增大限制后重建容器，例如：

```yaml
environment:
  UPLOAD_LIMIT: 256M
  MEMORY_LIMIT: 512M
  MAX_EXECUTION_TIME: 600
```

### 9.5 端口 8080 已被占用

改映射，例如 `"8081:80"`，并相应改访问 URL。失败后先 `docker compose down` 再改端口启动。

### 9.6 浏览器打不开，容器却在跑

确认拉的是 **apache** 变体（`5.2.3` / `*-apache`）。若误用 `fpm` / `fpm-alpine`，容器内没有对外 HTTP 80 的完整 Web 服务，需另接反向代理。

### 9.7 公网安全吗？

能登录 phpMyAdmin 通常就能操作数据库。公网必须加防护；开发机也建议仅监听内网或 SSH 隧道。

---

## 十、命令速查

```bash
# 目录与启动
cd /www/wwwroot/phpmyadmin
docker compose -f /www/wwwroot/phpmyadmin/compose.yml up -d
docker compose -f /www/wwwroot/phpmyadmin/compose.yml ps
docker compose -f /www/wwwroot/phpmyadmin/compose.yml logs -f phpmyadmin

# 停止 / 删除容器（数据在 ./mysql，删容器不删卷目录）
docker compose -f /www/wwwroot/phpmyadmin/compose.yml down

# 拉取
docker pull docker.xuanyuan.run/library/phpmyadmin:5.2.3
docker pull docker.xuanyuan.run/library/mariadb:10.11

# 备份数据库目录（停库或短暂停写更稳妥）
tar -czf phpmyadmin-mysql-$(date +%F).tar.gz -C /www/wwwroot/phpmyadmin mysql
```

---

## 十一、延伸阅读

- 轩辕镜像页：[library/phpmyadmin](https://xuanyuan.cloud/zh/r/library/phpmyadmin)
- 标签列表：[tags](https://xuanyuan.cloud/r/library/phpmyadmin/tags)
- Docker Hub：[phpmyadmin](https://hub.docker.com/_/phpmyadmin)
- 源码 / Docker 说明：[github.com/phpmyadmin/docker](https://github.com/phpmyadmin/docker)
- 用户文档：[docs.phpmyadmin.net](https://docs.phpmyadmin.net/)

---

## 总结

- **phpMyAdmin** = MySQL / MariaDB 的 Web 管理界面，不是数据库本身  
- 推荐标签：**`5.2.3`（apache）**；轩辕镜像坐标：`docker.xuanyuan.run/library/phpmyadmin:5.2.3`  
- 跟做主路径：Compose 起 **MariaDB + phpMyAdmin**，`PMA_HOST=db`，访问 **8080**  
- 登录用 **数据库账号**；改掉示例密码，勿裸奔公网  
- 已有库用 `PMA_HOST` 或 `PMA_ARBITRARY=1`；会话挂载 `/sessions` 时务必 **`chown 33:33`**



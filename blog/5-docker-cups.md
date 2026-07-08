# 一台打印机全办公室共用：5 分钟 Docker 一键部署 CUPS

![一台打印机全办公室共用：5 分钟 Docker 一键部署 CUPS](https://img.xuanyuan.dev/docker/blog/cups.png)

*分类: Docker部署教程 | 标签: CUPS,Docker,轩辕镜像,网络打印机,IPP,HP,部署教程 | 发布时间: 2026-07-06 04:05:23*

> 家里有一台联网打印机，却只有插在旁边的那台电脑能打？想给手机、笔记本、家里别的电脑都用上，又懒得每台装驱动？CUPS（Common UNIX Printing System）是 Linux/Unix 世界里最常用的打印中间件——装在服务器上，局域网设备都能往它提交任务，由它转发到你的网络打印机。

*本文基于 [anujdatar/cups:26.07.01](https://xuanyuan.cloud/zh/r/anujdatar/cups) 镜像（OpenPrinting CUPS 2.4.10），Ubuntu 24.04 服务器实测*

家里有一台联网打印机，却只有插在旁边的那台电脑能打？想给手机、笔记本、家里别的电脑都用上，又懒得每台装驱动？**CUPS**（Common UNIX Printing System）是 Linux/Unix 世界里最常用的打印中间件——装在服务器上，局域网设备都能往它提交任务，由它转发到你的网络打印机。

本文带你完成一次 **CUPS Docker 一键部署**：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 `anujdatar/cups`，`docker run`（或 Compose）启动，在 Web 管理界面添加 **HP Smart Tank 210-220** 网络打印机，打出测试页——全程基于 Ubuntu 24.04 实测，命令可直接复制，文末附 **14 张截图**。

实测环境：CUPS 服务器 IP `192.168.1.18`，打印机 IP `192.168.1.20`。国内拉取使用加速域 `docker.xuanyuan.run`。项目说明见 [GitHub anujdatar/cups-docker](https://github.com/anujdatar/cups-docker)。

---

## 一、CUPS 是什么？

**CUPS** 是开源打印系统，负责接收客户端打印任务、管理队列、选择驱动，再把作业交给本地 USB 或网络打印机。OpenPrinting 维护的现代 CUPS 默认支持 **IPP Everywhere™**——不少新打印机无需单独厂商驱动即可工作。

镜像 **anujdatar/cups** 把 CUPS 打进容器，典型场景：

| 场景 | 说明 |
|------|------|
| 网络打印机共享 | 服务器接管打印机队列，全屋电脑 / 手机统一打印 |
| 家庭 / 树莓派 | 轻量容器常开，不用长期开某台 PC |
| USB 打印机共享 | 挂载 `/dev/bus/usb` 后，把本机 USB 打印机共享到局域网（本文以网络打印机为例，**无需**挂载 USB） |

架构示意：

```text
客户端设备 ──HTTP:631──▶ CUPS 容器 ──IPP/Socket──▶ 网络打印机
管理浏览器 ──http://服务器IP:631──▶ CUPS Web 界面
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 256 MB（CUPS 容器极轻量） |
| CPU | 单核即可 |
| 磁盘 | ≥ 500 MB（镜像 + `/etc/cups` 配置持久化） |
| 端口 | **631**（CUPS 默认 Web / IPP） |
| 网络 | 服务器与打印机在同一局域网，能互访 |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、拉取镜像

使用轩辕镜像加速拉取（版本标签 `26.07.01`）：

```bash
docker pull docker.xuanyuan.run/anujdatar/cups:26.07.01
```

实测输出（摘要）：

```text
26.07.01: Pulling from anujdatar/cups
...
Digest: sha256:d4a850f6c9af254411966011ac47521b97dde7d7184c16c5c92727cfc5f43d21
Status: Downloaded newer image for docker.xuanyuan.run/anujdatar/cups:26.07.01
docker.xuanyuan.run/anujdatar/cups:26.07.01
```

镜像页：[anujdatar/cups](https://xuanyuan.cloud/zh/r/anujdatar/cups)。其他标签见该页「标签列表」。

---

## 四、检查端口与持久化目录

### 4.1 确认 631 未被占用

```bash
ss -tlnp | grep 631
```

无输出表示端口空闲。若宿主机已装系统 CUPS，可先停用：

```bash
sudo systemctl stop cups
sudo systemctl disable cups
```

实测服务器上 **未安装** 系统 `cups.service`（`Failed to stop cups.service: Unit cups.service not loaded.`），可忽略该提示，直接进入下一步。

### 4.2 创建配置目录

CUPS 配置在容器 `/etc/cups`，挂载到宿主机后，重建容器也能保留打印机设置：

```bash
mkdir -p /www/wwwroot/webtop/cups-data
```

---

## 五、启动容器（docker run）

本文实测路径为 `/www/wwwroot/webtop`，网络打印机场景**无需** `--device /dev/bus/usb`。

```bash
docker run -d \
  --name cups \
  --restart unless-stopped \
  -p 631:631 \
  -e TZ="Asia/Shanghai" \
  -e CUPSADMIN=admin \
  -e CUPSPASSWORD='123456' \
  -v /www/wwwroot/webtop/cups-data:/etc/cups \
  docker.xuanyuan.run/anujdatar/cups:26.07.01
```

| 参数 | 说明 |
|------|------|
| `-p 631:631` | 映射 CUPS Web / IPP 端口 |
| `TZ` | 时区，国内建议 `Asia/Shanghai` |
| `CUPSADMIN` / `CUPSPASSWORD` | Web 管理登录凭据（下文界面使用 `admin` / `123456`） |
| `-v ...:/etc/cups` | 持久化打印机队列与配置 |

> **安全提示**：示例密码 `123456` 仅便于演示。**生产环境务必改为强密码**，且建议仅在内网访问 631，勿将管理口裸暴露到公网。

### 5.1 验证容器

```bash
docker ps | grep cups
docker logs cups
```

正常时 `docker ps` 类似：

```text
374ab7cbfd55   docker.xuanyuan.run/anujdatar/cups:26.07.01   "/entrypoint.sh"   ...   Up ...   0.0.0.0:631->631/tcp, [::]:631->631/tcp, 5353/udp   cups
```

日志关键片段：

```text
+ useradd -r -G lpadmin -M admin
+ echo admin:123456
+ chpasswd
...
Current default time zone: 'Asia/Shanghai'
...
+ exec /usr/sbin/cupsd -f
```

说明管理员用户已创建，时区已设为上海，`cupsd` 前台运行中。

---

## 六、Docker Compose 方式（可选）

若偏好 Compose 管理，可在 `/www/wwwroot/webtop` 创建 `docker-compose.yml`：

```yaml
services:
  cups:
    image: docker.xuanyuan.run/anujdatar/cups:26.07.01
    container_name: cups
    restart: unless-stopped
    ports:
      - "631:631"
    environment:
      - TZ=Asia/Shanghai
      - CUPSADMIN=admin
      - CUPSPASSWORD=123456
    volumes:
      - ./cups-data:/etc/cups
```

启动：

```bash
cd /www/wwwroot/webtop
mkdir -p cups-data
docker compose up -d
docker compose ps
docker compose logs -f cups
```

> **注意**：同一台机器不要同时用 `docker run` 和 Compose 起两个名为 `cups` 的容器。已用 `docker run` 部署成功则无需再 Compose；下文实测均基于 `docker run`。

若以后要接 **USB 打印机**，在 Compose 中增加：

```yaml
    devices:
      - /dev/bus/usb:/dev/bus/usb
```

或在 `docker run` 时追加 `--device /dev/bus/usb`。

---

## 七、确认打印机网络可达

添加前先在服务器上探测打印机（本文打印机 IP 为 `192.168.1.20`）：

```bash
ping -c 3 192.168.1.20
curl -I http://192.168.1.20
```

实测：

- `ping`：0% 丢包，网络可达
- `curl`：HTTP 301，响应头识别为 **HP Smart Tank 210-220 series (3D4L4A)**

```text
HTTP/1.1 301 Moved Permanently
Server: HP HTTP Server; HP Smart Tank 210-220 series - 3D4L4A; ...
Location: https://192.168.1.20/
```

若执行 `curl -I ipp://192.168.1.20/ipp/print` 报 `Protocol "ipp" not supported`，**属正常现象**——宿主机 curl 多数未编译 IPP 协议，**不代表打印机不支持 IPP**。以 CUPS Web 界面添加为准。

---

## 八、打开 CUPS 管理界面

浏览器访问（将 IP 换成你的 CUPS 服务器地址）：

```
http://你的服务器IP:631
```

实测地址为 `http://192.168.1.18:631`。首页显示 **OpenPrinting CUPS 2.4.10**，说明服务已就绪。

![OpenPrinting CUPS 2.4.10 首页：导航含 Home / Administration / Printers](https://img.xuanyuan.dev/docker/blog/cups-1.png)

点顶部 **Administration**，浏览器会弹出登录框：

![CUPS 登录框：地址 192.168.1.18:631，用户名 admin](https://img.xuanyuan.dev/docker/blog/cups-2.png)

输入启动容器时设置的账号密码（实测 `admin` / `123456`），点 **登录**。

进入管理页后，左侧 **Printers** 区域有 **Add Printer**；右侧 **Server Settings** 可勾选 **Share printers connected to this system**、**Allow remote administration**（远程管理本机界面时需要），保存后点 **Change Settings**。

![Administration 管理页：Add Printer 与服务器共享选项](https://img.xuanyuan.dev/docker/blog/cups-3.png)

---

## 九、添加网络打印机（HP Smart Tank）

### 9.1 选择连接协议

点 **Add Printer**，进入「添加打印机」向导。

**Discovered Network Printers** 可能为空（不会自动发现所有打印机，属正常）。向下找到 **Other Network Printers**，选中 **互联网打印协议 (ipp) / Internet Printing Protocol (ipp)**，点 **Continue**。

![添加打印机：选择 Internet Printing Protocol (ipp)](https://img.xuanyuan.dev/docker/blog/cups-4.png)

> 若 IPP 失败，可改选 **AppSocket/HP JetDirect**，连接串为 `socket://192.168.1.20:9100`。HP Smart Tank 系列优先 IPP。

### 9.2 填写连接 URI

在 **Connection** 输入框填写（本文实测可用）：

```
ipp://192.168.1.20/ipp/print
```

其他常见备选（按需再试）：

```
ipp://192.168.1.20:631/ipp/print
ipp://192.168.1.20/ipp/printer
```

点 **Continue**。

![添加打印机：Connection 填入 ipp://192.168.1.20/ipp/print](https://img.xuanyuan.dev/docker/blog/cups-5.png)

### 9.3 命名并共享

| 字段 | 实测值 | 说明 |
|------|--------|------|
| Name | `HP-Home` | 队列名，**不要空格**，勿含 `/`、`#` |
| Description | `my Printer` | 可读描述，可随意 |
| Location | （空） | 可选，如「客厅」 |
| Sharing | **Share This Printer** 勾选 | 局域网其他设备可通过本 CUPS 共享打印 |

点 **Continue**。

![命名打印机 HP-Home 并勾选 Share This Printer](https://img.xuanyuan.dev/docker/blog/cups-6.png)

### 9.4 选择厂商与驱动

**Make** 列表中选择 **HP**，点 **Continue**。

![选择厂商 Make：HP](https://img.xuanyuan.dev/docker/blog/cups-7.png)

**Model** 列表中选择 **IPP Everywhere™**（列表顶部），然后点 **Add Printer**。

![选择驱动 Model：IPP Everywhere™](https://img.xuanyuan.dev/docker/blog/cups-8.png)

> HP Smart Tank 210-220 原生支持 IPP Everywhere，无需精确到具体 hpcups 型号驱动。若列表中有 **HP Smart Tank 210-220 series**，亦可选用。

### 9.5 设置默认选项

进入「设置打印机选项」。实测将 **Media Size** 设为 **A4**，其余如 Media Type=`Stationery`、cupsPrintQuality=`Normal`、Output Mode=`RGB`，点 **Set Default Options**。

![设置默认选项：Media Size 为 A4](https://img.xuanyuan.dev/docker/blog/cups-9.png)

### 9.6 确认添加成功

顶部点 **Printers**，进入打印机详情。状态应为：**Idle, Accepting Jobs, Shared**；驱动为 **IPP Everywhere (color)**；连接为 `ipp://192.168.1.20/ipp/print`。

![打印机 HP-Home 状态 Idle，连接 ipp://192.168.1.20/ipp/print](https://img.xuanyuan.dev/docker/blog/cups-10.png)

---

## 十、打印测试页

在打印机详情页打开 **Maintenance** 下拉菜单，选择 **Print Test Page**。

![Maintenance 菜单：选择 Print Test Page](https://img.xuanyuan.dev/docker/blog/cups-11.png)

页面提示测试页已提交：

```text
Test page sent; job ID is HP-Home-1.
```

![打印测试页成功：job ID 为 HP-Home-1](https://img.xuanyuan.dev/docker/blog/cups-12.png)

返回打印机页可见任务状态变为 **Processing**，Jobs 列表中 `HP-Home-1` 显示 `Rendering completed`：

![作业 HP-Home-1 处理中，Rendering completed](https://img.xuanyuan.dev/docker/blog/cups-13.png)

打印机吐出 CUPS 测试页（含 CMYK / RGB 色块、Job ID、`ippeve.ppd` 驱动信息等），则部署路径闭环成功。

![物理测试页：Printer test page，Job ID HP-Home-1，Driver ippeve.ppd](https://img.xuanyuan.dev/docker/blog/cups-14.png)

---

## 十一、局域网客户端怎么用？

打印机已勾选 **Share This Printer** 后，其他设备可通过 CUPS 服务器打印（队列名实测为 `HP-Home`）：

| 系统 | 大致步骤 |
|------|----------|
| Windows | 添加打印机 → 按 IP → `http://CUPS服务器IP:631/printers/HP-Home` |
| macOS | 系统设置 → 打印机 → IP → 协议 **IPP**，地址填 CUPS 服务器 IP，队列填 `HP-Home` |
| Linux | `lpadmin` 或系统设置添加 IPP 打印机，URI 同上 |
| 浏览器 | 打开 `http://CUPS服务器IP:631`，在 **Printers** 中查看队列 |

把 `CUPS服务器IP` 换成你的地址（文中实测为 `192.168.1.18`）。

---

## 十二、常见问题 FAQ

**Q1：浏览器打不开 `http://IP:631`？**

- `docker ps` 确认容器为 `Up`，端口映射 `631->631`
- `ss -tlnp | grep 631` 确认无冲突
- 本机 `curl -I http://127.0.0.1:631` 是否有响应
- ufw / 云安全组是否放行 631（建议仅内网）

**Q2：`Discovered Network Printers` 是空的？**

正常。许多网络打印机不会自动出现在发现列表，需手动选 **Internet Printing Protocol (ipp)** 并填写 URI。

**Q3：`curl ipp://...` 报 Protocol not supported？**

宿主机 curl 不支持 IPP，与打印机无关，直接在 CUPS Web 里添加即可。

**Q4：IPP 页面一直转圈或失败？**

- 先 `ping` 打印机 IP
- 浏览器打开 `http://打印机IP` 看能否访问管理页
- 依次试 `ipp://IP/ipp/print`、`ipp://IP:631/ipp/print`、`socket://IP:9100`

**Q5：如何升级镜像？**

```bash
docker pull docker.xuanyuan.run/anujdatar/cups:26.07.01
docker stop cups && docker rm cups
# 重新执行第五节 docker run（保留同一 cups-data 卷）
```

**Q6：如何停止与卸载？**

```bash
# 停止并删除容器（保留配置）
docker stop cups && docker rm cups

# Compose 方式
cd /www/wwwroot/webtop && docker compose down

# 连同配置目录一起删（慎用）
rm -rf /www/wwwroot/webtop/cups-data
```

**Q7：631 能暴露到公网吗？**

不建议。CUPS 管理面暴露在公网风险高。只开放内网，或走 VPN / 反向代理并做好认证。

---

## 十三、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/anujdatar/cups:26.07.01` |
| 快速启动 | 见第五节 `docker run` |
| Compose 启动 | `cd /www/wwwroot/webtop && docker compose up -d` |
| 查看状态 | `docker ps \| grep cups` |
| 查看日志 | `docker logs -f cups` |
| 管理界面 | `http://服务器IP:631` |
| 停止 | `docker stop cups` |
| 删除（保留数据） | `docker rm cups`（`cups-data` 仍在） |

---

## 十四、延伸阅读

- 轩辕镜像页：[anujdatar/cups](https://xuanyuan.cloud/zh/r/anujdatar/cups)
- 项目源码：[anujdatar/cups-docker](https://github.com/anujdatar/cups-docker)
- OpenPrinting CUPS：项目首页与文档
- 轩辕镜像 Docker 安装与加速：[使用手册](https://xuanyuan.cloud/usage)

至此，从拉镜像、起容器、添加 HP Smart Tank（`192.168.1.20`）到吐出测试页，整条链路已在 Ubuntu 24.04 上跑通。把队列共享出去，家里其他设备就可以统一通过这台 CUPS 服务器打印了。



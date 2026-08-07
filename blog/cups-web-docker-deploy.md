# Docker 部署 CUPS Web：浏览器即可管理打印机与打印任务

![Docker 部署 CUPS Web：浏览器即可管理打印机与打印任务](https://img.xuanyuan.dev/docker/blog/cups-web.webp)

*分类: Docker部署教程 | 标签: CUPS Web,CUPS,Docker,轩辕镜像,网络打印,远程打印,HP Smart Tank,私有化部署,部署教程 | 发布时间: 2026-07-31 04:22:28*

> 家里只有一台 USB 喷墨机、小办公室角落放着一台激光机——这是最常见的配置。麻烦不在「有没有打印机」，而在「谁都能方便地用上它」：Windows 要装厂商套件，macOS 偶发驱动不匹配，Linux 还得翻 PPD；手机拍完合同、平板改完表格，却只能先传到某台「专职打印电脑」再点打印；笔记本换了、重装系统了，驱动又要从头来一遍。USB 打印机尤其吃亏：线插在哪台主机上，哪台才能打，同事来回拔线、抢那台开机的 PC，打印这件事就被绑死在物理位置上。

*本文基于 [hanxi/cups-web:v0.2.3](https://xuanyuan.cloud/zh/r/hanxi/cups-web)，**Ubuntu 24.04** 实测。文末链路含登录、添加打印机、上传打印与出纸等 **21** 张截图。*

家里只有一台 USB 喷墨机、小办公室角落放着一台激光机——这是最常见的配置。麻烦不在「有没有打印机」，而在「谁都能方便地用上它」：Windows 要装厂商套件，macOS 偶发驱动不匹配，Linux 还得翻 PPD；手机拍完合同、平板改完表格，却只能先传到某台「专职打印电脑」再点打印；笔记本换了、重装系统了，驱动又要从头来一遍。USB 打印机尤其吃亏：线插在哪台主机上，哪台才能打，同事来回拔线、抢那台开机的 PC，打印这件事就被绑死在物理位置上。

即便换成网络打印机、或在 NAS / 小主机上跑一套 **CUPS**（Common UNIX Printing System），也只是解决了「中间件能转发作业」这一层。CUPS 自带的 Web 管理页（默认 **`:631`**）偏运维：添加队列、选驱动、打测试页可以，但对家里老人、前台同事、出差只带浏览器的人不友好——他们要的是「打开网页、上传文件、选打印机、点打印」，以及「我打过什么、打成功没有」；而不是登录 CUPS 管理后台、理解队列与 PPD。共享目录里丢 PDF、微信传文件再找人代打，既难审计，也容易把合同扫描件、工资条这类材料散落在聊天记录和私人电脑里。

公有云「在线打印」或厂商云打印能少装驱动，但文档要先上传到对方平台，按页或按账号计费，内网断公网、合规要求「文件不出域」、或只想在客厅 NAS / 办公室小主机上常开一台打印门户时，就不合适。你需要的是：**打印机仍接在自己机器上，打印服务跑在自己 Docker 里，浏览器打开内网地址就能用**——上传的原稿与转换后的 PDF、用户账号与打印记录，都落在本地卷，而不是某家 SaaS。

手工在宿主机装 CUPS、配 LibreOffice 转 Office、再写一层上传网站，对多数家庭与小团队成本偏高。**CUPS Web**（[GitHub: hanxi/cups-web](https://github.com/hanxi/cups-web)）把这件事收成一条 Compose：官方镜像把 **cupsd + 网页打印门户**打进**同一容器**（AIO）。浏览器登录后可上传 PDF、图片（含 HEIC、多图合并）、Office、OFD、文本等，服务端转换并带预览后再提交到 CUPS；支持多用户与角色、打印历史、管理员侧的驱动扫描 / 一键安装，以及数据保留策略。它不是「再换一台物理打印机」，而是站在打印机前面的**自托管网页打印站**——普通用户走 `:1180` 上传打印，管理员仍可用 `:631` 管队列，或在 Web「驱动」页装厂商驱动。

上手要点：镜像坐标用 **`hanxi/cups-web`**（推荐钉死 **`v0.2.3`**；勿再跟早期文档的「`hanxi/cups` + `hanxi/cups-web` 双服务」）。宿主机映射 **1180→8080**（Web）、**631→631**（CUPS）。Web 首次默认 **`admin` / `admin`**，登录后立刻改密；CUPS 管理员由环境变量提供（本文实测 `print` / `123456`）。长期运行必须挂载 **`.etc` / `.data` / `.uploads` / `.drivers`** 四套目录——漏挂 `.drivers` 等于手动装过的第三方驱动重启后全丢。USB 场景请用 **目录挂载** `/dev/bus/usb` + `device_cgroup_rules`（支持热插拔），不要用一次性的 `devices:`；局域网网络打印机请在 `:631` **手动填 IPP**（驱动页扫描经常为空，属正常），添加后务必勾选 **Share This Printer**。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取** **`hanxi/cups-web:v0.2.3`**，Compose 拉起单容器，浏览器登录 Web、在 CUPS 用 IPP 添加 HP Smart Tank，再上传 Word 完成一次远程打印并出纸。另附发票/身份证模式、备份升级与 FAQ。若只要「CUPS 中间件、在 `:631` 添加网络打印机」而不需要上传门户与多用户，可另见本站 [anujdatar/cups 教程](https://xuanyuan.cloud/blog/docker-cups)。

镜像说明见 [hanxi/cups-web 镜像页](https://xuanyuan.cloud/zh/r/hanxi/cups-web)，标签列表见 [tags](https://xuanyuan.cloud/r/hanxi/cups-web/tags)。

---

## 一、CUPS Web 是什么？

一句话：**CUPS Web = 自托管网页打印门户 + 内置 CUPS**。用户在浏览器里上传文件、选打印机、调份数/双面等；管理员管用户、记录、驱动与数据保留。

### 1.1 和「只跑 CUPS」差在哪？

| 只跑 CUPS（如 anujdatar/cups） | CUPS Web（本文） |
|-------------------------------|------------------|
| 管理界面偏运维（`:631`） | 面向普通用户的上传 / 预览 / 打印 |
| 一般不自带多用户门户 | `admin` / `user` 角色 + 打印记录 |
| 文档转换要自己配 | 镜像内 LibreOffice / OFD / 字体等开箱 |
| 驱动靠手动进容器装 | Web「驱动」页 + 持久化 `.drivers` |

### 1.2 核心能力

| 能力 | 说明 |
|------|------|
| 多格式打印 | PDF、图片（含 HEIC、多图合并）、Office、OFD、文本/Markdown/HTML |
| 打印模式 | 标准打印、发票打印、身份证正反面排版 |
| 打印选项 | 份数、单双面、彩/黑白、纸张、方向、页码范围、缩放等 |
| 用户体系 | 默认 `admin/admin`；可建普通用户 |
| 管理后台 | 用户、全站打印记录、数据保留天数 |
| 驱动管理 | 扫描打印机、一键安装厂商驱动、上传 `.ppd` / `.deb`（管理员） |
| 安全 | Session、CSRF、bcrypt 存密 |

### 1.3 架构（本文 Compose AIO）

```text
浏览器 ──HTTP:1180──▶ cups 容器(:8080 cups-web)
                         │
                         ├── cupsd (:631，同容器)
                         ├── ./.data    → /data
                         ├── ./.uploads → /uploads
                         ├── ./.etc     → /etc/cups
                         └── ./.drivers → /opt/cups-drivers/data

管理浏览器 ──HTTP:631──▶ 同一容器内 CUPS 管理页（添加/共享打印机）
网络打印机 ──IPP──▶ ipp://192.168.1.29/ipp/print（本文实测）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux 建议 **Ubuntu 24.04**（本文实测） |
| Docker | Engine + Compose V2（`docker compose`） |
| 内存 | 演示建议 ≥ **1～2 GB**（含 LibreOffice / OFD 转换时更吃内存） |
| 磁盘 | 镜像约 **2.45 GB**（本地 `docker images`）+ 上传文件增长 |
| 端口 | **1180**（Web）、**631**（CUPS）；均勿被占用 |
| 打印机 | USB 直连 **或** 同网段网络打印机（本文为 HP Smart Tank 网络机） |
| 目录 | `/www/wwwroot/cups-web` |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

> **无 USB 的环境**：可删掉 Compose 里 `/dev/bus/usb`、`/run/udev` 与 `device_cgroup_rules`，仅用网络打印机（本文即此场景）。

---

## 三、标签怎么选

| 标签 | 说明 | 推荐 |
|------|------|------|
| **`v0.2.3`** | 本文实测稳定版（与 `latest` 同 digest） | **试用 / 生产钉死首选** |
| `latest` | 跟踪最新稳定构建 | 仅临时试用；生产请钉 `v0.2.x` |
| `master` | 跟踪主分支构建 | 偏开发，**勿当生产默认** |
| `v0.2.2` / `v0.2.0` 等 | 历史版本 | 回滚或对照 issue 时使用 |

标签列表：[xuanyuan.cloud/r/hanxi/cups-web/tags](https://xuanyuan.cloud/r/hanxi/cups-web/tags)。

> **勿混用旧双容器文档**：早期 README 曾写 `hanxi/cups` + `hanxi/cups-web` 两个服务。当前官方仓库已改为 **单镜像 AIO**；请以本文 Compose 为准。

---

## 四、拉取镜像（轩辕镜像加速）

```bash
sudo mkdir -p /www/wwwroot/cups-web
cd /www/wwwroot/cups-web

docker pull docker.xuanyuan.run/hanxi/cups-web:v0.2.3
```

实测拉取输出（**Ubuntu 24.04**）：

```text
v0.2.3: Pulling from hanxi/cups-web
4f4fb700ef54: Pull complete
062e450697fa: Pull complete
2c69eb8fdb6b: Pull complete
bb8ea9eb6151: Pull complete
72af2644f066: Pull complete
65ede3d2ae82: Pull complete
12c8fbb8377f: Pull complete
a860f1da36ae: Pull complete
20f2a973b235: Pull complete
37994f0a3f11: Pull complete
82a26b58e8a9: Pull complete
933bdaecd794: Pull complete
6930b50503cb: Pull complete
18c72b7b1760: Pull complete
bef7d948fcdf: Pull complete
730994c57352: Pull complete
90c0316a86ea: Pull complete
538e0991238d: Pull complete
60176d4044db: Pull complete
44c6a71272e8: Pull complete
fbd265df4376: Pull complete
0866d0a24c34: Pull complete
467ad5ac18b0: Pull complete
fc6b237492e3: Pull complete
2fe597f62258: Download complete
Digest: sha256:f0cb0560b873740f30a82e056353480393c226b422f2f9156e6954846c9c2dd4
Status: Downloaded newer image for docker.xuanyuan.run/hanxi/cups-web:v0.2.3
docker.xuanyuan.run/hanxi/cups-web:v0.2.3
```

确认本地镜像：

```bash
docker images
```

实测可见类似：

```text
IMAGE                                       ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/hanxi/cups-web:v0.2.3   f0cb0560b873       2.45GB          698MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `hanxi/cups-web:v0.2.3` | `docker pull docker.xuanyuan.run/hanxi/cups-web:v0.2.3` |

---

## 五、Compose 部署（推荐）

### 5.1 创建目录与环境变量

```bash
cd /www/wwwroot/cups-web
mkdir -p .etc .data .uploads .drivers

cat > .env << 'EOF'
CUPSADMIN=print
CUPSPASSWORD=123456
TZ=Asia/Shanghai
EOF
```

> 本文实测 `CUPSPASSWORD=123456` 仅作演示。生产请改成强密码，并限制 `.env` 权限（如 `chmod 600 .env`）。不写 `.env` 时镜像默认 `print` / `print`。

### 5.2 编写 `docker-compose.yml`

以下与官方仓库对齐，镜像坐标改为轩辕加速前缀，并钉死 **`v0.2.3`**：

```yaml
services:
  cups:
    image: docker.xuanyuan.run/hanxi/cups-web:v0.2.3
    container_name: cups
    user: root
    security_opt:
      - apparmor:unconfined
    environment:
      - CUPSADMIN=${CUPSADMIN:-print}
      - CUPSPASSWORD=${CUPSPASSWORD:-print}
      - TZ=${TZ:-Asia/Shanghai}
    ports:
      - "631:631"
      - "1180:8080"
    volumes:
      - ./.etc:/etc/cups
      - ./.data:/data
      - ./.uploads:/uploads
      - ./.drivers:/opt/cups-drivers/data
      - /dev/bus/usb:/dev/bus/usb
      - /run/udev:/run/udev:ro
    device_cgroup_rules:
      - 'c 189:* rmw'
    restart: unless-stopped
```

**变体说明：**

| 场景 | 改法 |
|------|------|
| 无 USB / 无 `/dev/bus/usb` | 删除 USB、`/run/udev`、`device_cgroup_rules` 三处 |
| Docker 不支持 `device_cgroup_rules` | 删除该字段，改 `privileged: true`（权限更宽） |
| 无 `/run/udev` | 删除该 volume 行即可 |
| 端口冲突 | 改左侧：`"1631:631"`、`"1180:8080"` 等 |

### 5.3 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail=80 cups
```

实测 `ps`：

```text
NAME      IMAGE                                       COMMAND            SERVICE   CREATED          STATUS         PORTS
cups      docker.xuanyuan.run/hanxi/cups-web:v0.2.3   "/entrypoint.sh"   cups      10 seconds ago   Up 9 seconds   0.0.0.0:631->631/tcp, [::]:631->631/tcp, 0.0.0.0:1180->8080/tcp, [::]:1180->8080/tcp
```

实测日志关键行：

```text
Current default time zone: 'Asia/Shanghai'
[entrypoint] dispatching hplj1020 in background; log: /var/log/cups/hp-firmware.log
...
2026/07/31 11:30:28 default admin created: admin
2026/07/31 11:30:28 [SECURITY WARNING] 已创建默认管理员 admin/admin，请立即登录并修改密码！
listening on :8080
```

浏览器访问（按实测 IP）：

- Web 门户：`http://192.168.1.10:1180`
- CUPS 管理：`http://192.168.1.10:631`

---

## 六、浏览器首次使用

> 配图线上地址统一为 `![cups web {N}](https://img.xuanyuan.dev/docker/blog/cups-web-{N}.webp)`（共 **21** 张）。

### 6.1 登录 Web 门户

打开 `http://192.168.1.10:1180`，使用默认账号 **`admin` / `admin`** 登录（页脚可见 **v0.2.3**）。**首次登录后请立刻修改默认密码。**

![CUPS Web 登录页：用户名 admin，页脚 v0.2.3](https://img.xuanyuan.dev/docker/blog/cups-web-1.webp)

登录后进入「打印」主界面：可选打印机、标准/发票/身份证三种模式；左侧上传文件与打印参数，右侧预览与记录。此时若尚未添加打印机，「选择打印机」为空属正常。

![CUPS Web 主界面：标准打印，尚未选择打印机](https://img.xuanyuan.dev/docker/blog/cups-web-3.webp)

---

### 6.2 在 CUPS 添加局域网打印机（推荐）

> **先分清两条路**：  
> - **USB 直连**：可用 Web「驱动」页扫描。  
> - **局域网网络打印机**：驱动页「扫描」经常为空（Docker bridge 下 mDNS 发现不可靠），**属常见情况**。请走本节在 `:631` **手动填 IPP**。

#### 6.2.1 先确认打印机 IP 可达

添加前在宿主机探测（把 IP 换成你的；本文正确地址为 **`192.168.1.29`**）：

```bash
ping -c 3 192.168.1.29
```

> 实测曾误填 `192.168.1.20`，宿主机 ping 全丢、`:631` Add Printer 报 `Host is down`。以打印机面板 / 路由器 DHCP 为准，**IP 写错时任何驱动都救不了**。  
> 另：镜像内可能没有 `ping` 命令（`docker exec cups ping` 会报 not found），宿主机能 ping 通即可；容器侧可用 `/dev/tcp` 测端口。

#### 6.2.2 打开 CUPS 管理页并登录

浏览器打开 `http://192.168.1.10:631`，可见 **OpenPrinting CUPS 2.4.19** 首页。点顶部 **Administration**，或「CUPS for Administrators」里的 Adding Printers。

![CUPS 首页：OpenPrinting CUPS 2.4.19](https://img.xuanyuan.dev/docker/blog/cups-web-2.webp)

访问管理功能时浏览器会弹出登录框：用户名填 **`print`**（即 `.env` 的 `CUPSADMIN`），密码填你设置的 `CUPSPASSWORD`（本文为 `123456`）。

![CUPS 管理登录框：地址 192.168.1.10:631，用户名 print](https://img.xuanyuan.dev/docker/blog/cups-web-4.webp)

进入 Administration 后，在 Printers 区域点 **Add Printer**。建议勾选 **Share printers connected to this system**、**Allow remote administration**（按需），再 **Change Settings**。

![CUPS Administration：Add Printer 与服务器共享选项](https://img.xuanyuan.dev/docker/blog/cups-web-5.webp)

#### 6.2.3 选择 IPP 并填写 Connection

**Discovered Network Printers 为空可忽略。** 滚到 **Other Network Printers**，选中 **Internet Printing Protocol (ipp)**，点 **Continue**。

![添加打印机：选中 Internet Printing Protocol (ipp)，发现列表为空](https://img.xuanyuan.dev/docker/blog/cups-web-6.webp)

Connection 填入（本文实测）：

```text
ipp://192.168.1.29/ipp/print
```

也可尝试：`ipp://192.168.1.29:631/ipp/print`、`ipp://192.168.1.29/ipp/printer`；若 IPP 不通而 9100 通，改选 AppSocket，填 `socket://192.168.1.29:9100`。

![添加打印机：Connection 填写 ipp://192.168.1.29/ipp/print](https://img.xuanyuan.dev/docker/blog/cups-web-7.webp)

#### 6.2.4 命名并勾选共享

Name 例如 **`HP-Home`**，Description 随意；务必勾选 **Share This Printer**，否则 Web 门户列表看不到。点 **Continue**。

![添加打印机：名称 HP-Home，已勾选 Share This Printer](https://img.xuanyuan.dev/docker/blog/cups-web-8.webp)

#### 6.2.5 选择厂商与型号

Make 选 **HP** → Continue。

![添加打印机：Make 选择 HP](https://img.xuanyuan.dev/docker/blog/cups-web-9.webp)

Model 优先选列表顶部的 **IPP Everywhere™**（现代网络机通用），再点 **Add Printer**。若列表有具体型号亦可。

![添加打印机：Model 选择 IPP Everywhere](https://img.xuanyuan.dev/docker/blog/cups-web-10.webp)

#### 6.2.6 默认选项与确认

进入 Set Default Options：Media Size 建议 **A4**，按需设置纸型与质量，点 **Set Default Options**。

![设置默认选项：Media Size 为 A4](https://img.xuanyuan.dev/docker/blog/cups-web-11.webp)

成功提示：**Printer HP-Home default options have been set successfully.**

![CUPS 提示：HP-Home 默认选项设置成功](https://img.xuanyuan.dev/docker/blog/cups-web-12.webp)

打开 **Printers** → **HP-Home**，状态应为 **Idle, Accepting Jobs, Shared**；Connection 为 `ipp://192.168.1.29/ipp/print`。本文驱动显示为 **Smart Tank 210-220 series - IPP Everywhere (color)**。

![打印机 HP-Home 详情：Idle Accepting Jobs Shared，IPP 地址 192.168.1.29](https://img.xuanyuan.dev/docker/blog/cups-web-13.webp)

---

### 6.3 回到 Web：选机、上传、打印

返回 `http://192.168.1.10:1180`，在「选择打印机」下拉选中 **HP-Home**，点刷新；右侧「打印机状态」应显示 **空闲**。

![CUPS Web：已选中 HP-Home，标准打印界面](https://img.xuanyuan.dev/docker/blog/cups-web-14.webp)

除标准打印外，还可切换：

- **发票打印**：适合票据类多文件上传，可强制黑白等

![CUPS Web：发票打印模式](https://img.xuanyuan.dev/docker/blog/cups-web-15.webp)

- **身份证打印**：分别上传正反面，可选 A4 / A5 排版

![CUPS Web：身份证打印，正反面上传区](https://img.xuanyuan.dev/docker/blog/cups-web-16.webp)

**标准打印实测**：上传 `开户确认书.docx`（约 11 KB），系统提示 **已转换为 PDF，可以打印**；右侧出现 A4 预览。调好彩色/双面/份数后，点 **开始打印**。

![标准打印：Word 已转 PDF，右侧显示预览](https://img.xuanyuan.dev/docker/blog/cups-web-17.webp)

提交成功会弹出 **打印任务已提交**（含任务 ID，如 `ipp://localhost:631/jobs/2`）。

![打印任务已提交：任务 ID 与页数提示](https://img.xuanyuan.dev/docker/blog/cups-web-18.webp)

「打印记录」出现 **已打印** 条目；「打印机状态」可看到墨盒余量、纸盒信息等（取决于打印机上报能力）。

![打印记录显示已打印，墨盒信息 100%](https://img.xuanyuan.dev/docker/blog/cups-web-19.webp)

![打印记录与打印机状态特写：空闲、队列 0、墨盒满](https://img.xuanyuan.dev/docker/blog/cups-web-20.webp)

打印机吐出的纸件与预览一致，即整条链路跑通。

![实测出纸：开户确认书纸质件](https://img.xuanyuan.dev/docker/blog/cups-web-21.webp)

支持格式摘要：PDF；图片 jpg/png/gif/heic（可多图合并）；Office doc(x)/xls(x)/ppt(x)；OFD；txt/md/html。

---

### 6.4 管理后台与驱动页（管理员）

导航 **管理**：用户管理、全站打印记录、数据保留天数（`0` = 永久）。  
导航 **驱动**：更适合 USB / 可扫描机型的一键装驱动；局域网机优先用上文 `:631` IPP 流程。上传 `.deb` 会以 root 执行安装脚本，**只信来源可信的包**。

---

## 七、生产注意与备份

1. **改密**：Web `admin`、CUPS `CUPSPASSWORD` 都要改；勿把 1180/631 无防护裸奔公网（建议内网 + 反向代理 HTTPS + 防火墙）。
2. **钉版本**：生产用 `v0.2.3`，勿裸跟 `latest` / `master`。
3. **备份四件套**：

```bash
cd /www/wwwroot/cups-web
cp ./.data/cups-web.db /backup/cups-web-$(date +%F).db
tar -czf /backup/cups-uploads-$(date +%F).tar.gz ./.uploads/
tar -czf /backup/cups-etc-$(date +%F).tar.gz ./.etc/
tar -czf /backup/cups-drivers-$(date +%F).tar.gz ./.drivers/
```

> 删掉或忘记挂载 **`.drivers`** = 手动安装的第三方驱动全部丢失，需在「驱动」页重装。

4. **HTTPS**：用 Nginx / Caddy 反代 `http://127.0.0.1:1180`，并设置 `X-Forwarded-*`。

---

## 八、升级与迁移

```bash
cd /www/wwwroot/cups-web
docker pull docker.xuanyuan.run/hanxi/cups-web:v0.2.3   # 或更新后的新版本号
# 先改 docker-compose.yml 中的 tag
docker compose up -d
```

数据在宿主机卷内，一般升级不丢库；大版本仍建议先备份四件套。跨架构迁移 `.drivers` 时，列表可能提示架构不符，需重装驱动。

---

## 九、常见问题 FAQ

**Q1：Web「驱动」页扫描不到局域网打印机？**  
常见且多半正常。扫描依赖发现协议，在 Docker **bridge** 下对局域网 mDNS 往往无效。网络机请到 `http://服务器IP:631` 选 **Other Network Printers → ipp**，手动填 `ipp://打印机IP/ipp/print`（见第六节）。

**Q2：Add Printer 报 `Unable to connect to …:631: Host is down`？**  
表示 CUPS 连不上该 IP（主机不可达或端口未开）。实测常见原因是 **打印机 IP 写错**（例如误用 `.20`、实际为 `.29`）。按序查：面板/DHCP 确认 IP → 宿主机 `ping` → 再填 IPP；631 不通可试 `socket://IP:9100`。

**Q3：`docker exec cups ping` 提示 not found？**  
镜像可能未装 `ping`，属正常。在宿主机 ping 即可；容器内可用：

```bash
docker exec cups bash -c 'timeout 5 bash -c "echo >/dev/tcp/192.168.1.29/631" && echo ok || echo fail'
```

**Q4：Web 里看不到已添加的打印机？**  
确认添加时勾选了 **Share This Printer**，状态含 **Shared**；在 Web 点「刷新」，或 `docker compose restart cups`。

**Q5：USB 打印机后开机识别不到？**  
须用 **目录挂载** `/dev/bus/usb` + `device_cgroup_rules`（或 `privileged: true`），不要用一次性的 `devices:`。

**Q6：忘记 Web 管理员密码？**  
停服务后删除数据库会重置为 `admin/admin`，**清空全部用户与记录**：

```bash
docker compose down
rm ./.data/cups-web.db
docker compose up -d
```

**Q7：Office / OFD 转换失败？**  
转换有约 **60 秒**超时。可本地先转 PDF 再上传；查日志：`docker compose logs -f cups`。

**Q8：和本站 anujdatar/cups 教程什么关系？**  
`anujdatar/cups` 侧重纯 CUPS；本文侧重 **上传门户 + 多用户**。网络打印机 IPP 添加步骤可互相对照。

**Q9：Apparmor DENIED / 打印失败（PVE LXC 等）？**  
保留 `security_opt: apparmor:unconfined`（官方针对 [issue #91](https://github.com/hanxi/cups-web/issues/91)）。

---

## 十、命令速查

```bash
cd /www/wwwroot/cups-web

docker pull docker.xuanyuan.run/hanxi/cups-web:v0.2.3

docker compose up -d
docker compose ps
docker compose logs -f cups
docker compose restart cups
docker compose down

docker exec cups driver-list
docker exec cups driver-install canon-ufr2
```

---

## 十一、延伸阅读

- [hanxi/cups-web 镜像页](https://xuanyuan.cloud/zh/r/hanxi/cups-web)
- [标签列表](https://xuanyuan.cloud/r/hanxi/cups-web/tags)
- [GitHub hanxi/cups-web](https://github.com/hanxi/cups-web)
- [Docker Hub hanxi/cups-web](https://hub.docker.com/r/hanxi/cups-web)
- [本站 anujdatar/cups 部署教程](https://xuanyuan.cloud/blog/docker-cups)（纯 CUPS）
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- 用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取并钉死 **`hanxi/cups-web:v0.2.3`**（Digest `f0cb0560b873…`）
- **单容器 AIO**：Compose 映射 **1180** / **631**，挂载 `.etc` / `.data` / `.uploads` / `.drivers`
- Web 默认 **`admin` / `admin`**；CUPS 用 `.env` 账号（本文 `print` / `123456`）——均需改密
- 局域网机用 **`ipp://打印机IP/ipp/print`** 手动添加，并勾选 **Share This Printer**（本文 `192.168.1.29`）
- 浏览器上传 Word/PDF → 预览 → 开始打印；发票/身份证模式开箱可用



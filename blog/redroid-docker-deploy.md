# Docker 部署 redroid：轻松搭建云安卓与远程 Android 实例平台

![Docker 部署 redroid：轻松搭建云安卓与远程 Android 实例平台](https://imgs.xuanyuan.cloud/docker/blog/redroid.webp)

*分类: Docker部署教程 | 标签: redroid,Docker,轩辕镜像,云安卓,Android In Cloud,ADB,scrcpy,自动化测试,私有化部署,部署教程 | 发布时间: 2026-08-18 11:03:42*

> 做 App 自动化或兼容性回归时，很多人先在 Windows / macOS 上堆模拟器：占内存、难批量，和 Linux CI 也不一致。真机农场贵、调度重；给每台测试机刷系统，运维成本更高。更实际的需求往往是：在自己的 Linux 服务器上起几个安卓实例，用熟悉的 ADB 装包、跑脚本，屏幕投到笔记本上看一眼。

*本文基于 [redroid/redroid:15.0.0_64only-latest](https://xuanyuan.cloud/zh/r/redroid/redroid)，实测 **Android 15**（`redroid15_x86_64_only`），测试平台 **Ubuntu 24.04** Linux。*

做 App 自动化或兼容性回归时，很多人先在 Windows / macOS 上堆模拟器：占内存、难批量，和 Linux CI 也不一致。真机农场贵、调度重；给每台测试机刷系统，运维成本更高。更实际的需求往往是：**在自己的 Linux 服务器上起几个安卓实例**，用熟悉的 **ADB** 装包、跑脚本，屏幕投到笔记本上看一眼。

内网还要求 **`/data` 不出域**。商业云安卓按路计费、数据落在厂商侧；一上来就上完整虚拟化平台，对「先跑通一台」又偏重。

**redroid**（Remote Android）是开源的 **GPU 加速云安卓（AIC）** 方案：在 Linux（Docker / Podman / K8s）里启动 Android 系统容器，支持 **amd64** 与 **arm64**。社区镜像 **`redroid/redroid`**（见 [镜像页](https://xuanyuan.cloud/zh/r/redroid/redroid)）按 Android 大版本打标签。本文跟做 **`15.0.0_64only-latest`**（纯 64 位）：ADB 与 scrcpy 均已实测通过。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 自动化测试 | `adb connect IP:15555`，安装 APK、跑脚本 |
| 远程看屏 | Windows / 带桌面的电脑用 [scrcpy](https://github.com/Genymobile/scrcpy) 投屏、点按 |
| 多实例原型 | 多套 Compose、独立数据目录和宿主机端口 |
| GPU 渲染 | 有宿主机 GPU 时把 `androidboot.redroid_gpu_mode` 改为 `host` 或 `auto` |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`redroid/redroid:15.0.0_64only-latest`**，以 **Docker Compose** 完成内核准备、启动、ADB 与 **Windows scrcpy** 投屏；文末附 **`docker run` 备选**。文内附 **4** 张实测截图。

> **上手要点**  
> - **部署**：默认 **Compose**（第六节）；临时试玩见 **第九节 docker run**  
> - **标签**：**`15.0.0_64only-latest`**（Android 15 纯 64 位）。官方 **16** 线 ADB 能连但无 Display，勿作看屏默认  
> - **端口**：宿主机 **15555 → 容器 5555**（ADB）。**不要**映射宿主机 5555  
> - **数据卷**：`./data15` → `/data`  
> - **权限**：**`privileged: true`**  
> - **内核**：`binder_linux` + **binderfs**；无 ashmem 时加 **`androidboot.use_memfd=1`**  
> - **系统**：只在 **Linux** 上跑容器；Docker Desktop（Windows / macOS）一般不可用  
> - **看屏**：在有桌面的电脑上用 scrcpy 连 `IP:15555`（无 Web 控制台）  
> - **暴露**：ADB **不要对公网开放**  

镜像说明：[redroid/redroid](https://xuanyuan.cloud/zh/r/redroid/redroid) · [tags](https://xuanyuan.cloud/r/redroid/redroid/tags)。文档：[redroid-doc](https://github.com/remote-android/redroid-doc) · [组织主页](https://github.com/remote-android)。许可证：主体 **Apache-2.0**，内核模块 **GPL-2.0**（含第三方组件，商用请自行核对）。

---

## 一、redroid 是什么？

在 Linux 的 Docker 里跑完整 Android：用 ADB 连接，需要时用 scrcpy 看屏。适合测试和云手机原型，**不是**浏览器里的远程桌面。

| 能力 | 说明 |
|------|------|
| 系统容器 | 容器内是 Android 用户空间，依赖宿主 **binderfs** 等内核特性 |
| 多版本 | 官方镜像覆盖 Android **8.1～16**（看屏跟做见第三节） |
| 架构 | **amd64** / **arm64** |
| GPU | `androidboot.redroid_gpu_mode`：`guest`（软件）/ `host` / `auto` |
| 典型用途 | 自动化测试、虚拟手机、云游戏联调、CI |

| 方案 | 适合 |
|------|------|
| **redroid（本文）** | Linux 自托管 Android + ADB / scrcpy |
| 桌面模拟器（AVD 等） | 本机开发，难批量 |
| [kasmweb/redroid](https://xuanyuan.cloud/r/kasmweb/redroid) | Kasm 生态变体，**不是**本文坐标 |
| 真机农场 / 商业云手机 | 要免运维或大量真机 |

**易混对象：**

| 对象 | 说明 |
|------|------|
| **`redroid/redroid`** | 本文跟做镜像 |
| `/r/` · `/zh/r/` · `/tags` | 同一镜像的概览 / 中文简介 / 标签页 |
| **kasmweb/redroid** | 另一条产品线，本文不跟做 |
| **redroid-doc** | 官方文档与 issue，不是可 pull 的运行镜像 |

```text
本机 ADB / scrcpy  ──:15555──▶  容器内 ADB :5555
宿主机 ./data15    ──挂载──▶  /data
内核 binderfs      ──必须──▶  容器才能起来（Ubuntu 24.04 无 /dev/binder）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | **Linux**，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **2～4 GB** 可用（随分辨率和实例数增加） |
| 磁盘 | 预留数 GB + `./data15` 增长 |
| 架构 | **amd64** 或 **arm64**（与镜像一致） |
| 端口 | 宿主机 **15555**（容器内 **5555**） |
| 特权 | **`privileged`** |

```bash
docker --version
docker compose version
uname -r
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

> 端口必须写成 **`15555:5555`**。ADB 会把宿主机 **5555** 当成模拟器（出现 `emulator-5554`），设备容易一直 `offline`。  
> **Docker Desktop**（Windows / macOS）缺少 redroid 所需内核模块，请在 Linux 上跑容器；笔记本只负责 ADB / scrcpy。

---

## 三、标签怎么选

上游按 **Android 大版本** 发布，标签形如 `{版本}-latest` / `{版本}_64only-latest`，表示该大版本线上构建，**不是**无版本语义的裸 `latest`。跟做命令钉死 **`15.0.0_64only-latest`**。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`15.0.0_64only-latest`** | Android **15**，纯 64 位 | **本文跟做**（ADB + scrcpy 已通过） |
| `15.0.0-latest` | Android 15，32/64 兼容面更全 | 需要 32 位 APK 时改用 |
| `16.0.0_64only-latest` 等 | Android **16** | ADB 能连；**无 Display**（见 FAQ） |
| `14.0.0_*` · `13.0.0_*` · `12.0.0_*` | 更旧大版本 | 兼容旧包 |
| `11.0.0-latest` … `8.1.0-latest` | Android 11～8.1 | 专项测试 |

完整列表：[tags](https://xuanyuan.cloud/r/redroid/redroid/tags)。换标签时，pull / Compose / run **三处一起改**，并换**独立数据目录**。

---

## 四、内核模块准备（必做）

以 **Ubuntu 24.04**（内核 6.8）为例。其它发行版见 [deploy](https://github.com/remote-android/redroid-doc/tree/master/deploy)。

### 4.1 安装 extra 模块并加载 binder

```bash
sudo apt update
sudo apt install -y linux-modules-extra-$(uname -r)
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
```

若提示 already the newest，直接下一步。

### 4.2 ashmem 失败可以忽略

内核 **≥ 5.18** 已移除 `ashmem_linux`。可以试加载一次，失败属预期：

```bash
sudo modprobe ashmem_linux || true
```

Ubuntu 24.04 实测：

```text
modprobe: FATAL: Module ashmem_linux not found in directory /lib/modules/6.8.0-138-generic
```

改用 Compose 里的 **`androidboot.use_memfd=1`**。

### 4.3 挂载 binderfs

Ubuntu 24.04 把 binder 做成 **binderfs**。`modprobe` 成功后**不会**出现 `/dev/binder`：

```text
ls: cannot access '/dev/binder': No such file or directory
```

这不代表模块没装上。改为：

```bash
grep binder /proc/filesystems
sudo mkdir -p /dev/binderfs
sudo mount -t binder binder /dev/binderfs
ls -l /dev/binderfs/
```

Ubuntu 24.04 实测：

```text
nodev	binder
```

```text
total 0
crw------- 1 root root 236, 1 Aug 18 08:34 binder
crw------- 1 root root 236, 0 Aug 18 08:34 binder-control
drwxr-xr-x 2 root root      0 Aug 18 08:34 features
crw------- 1 root root 236, 2 Aug 18 08:34 hwbinder
crw------- 1 root root 236, 3 Aug 18 08:34 vndbinder
```

看到 **`binder` / `hwbinder` / `vndbinder` / `binder-control`** 即可。节点权限是 `crw-------`，所以容器必须 **`privileged: true`**。不必再 `ln` 到 `/dev/binder`。

### 4.4 开机自动加载

```bash
echo 'binder_linux' | sudo tee /etc/modules-load.d/redroid-binder.conf
echo 'd /dev/binderfs 0755 root root -' | sudo tee /etc/tmpfiles.d/redroid-binderfs.conf
sudo systemd-tmpfiles --create /etc/tmpfiles.d/redroid-binderfs.conf
grep -q 'binder /dev/binderfs' /etc/fstab || echo 'binder /dev/binderfs binder defaults,nofail 0 0' | sudo tee -a /etc/fstab
sudo mount /dev/binderfs
```

容器立刻退出时，先看 `dmesg -T` 和 `grep binder /proc/filesystems`。

---

## 五、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/redroid/redroid:15.0.0_64only-latest
```

Ubuntu 24.04 实测：

```text
15.0.0_64only-latest: Pulling from redroid/redroid
7719e5442aee: Pull complete
Digest: sha256:b51bde9cef80f7bd7581148192f2b2f4d41f23c6344cfe88eceeb8ddd67490ee
Status: Downloaded newer image for docker.xuanyuan.run/redroid/redroid:15.0.0_64only-latest
docker.xuanyuan.run/redroid/redroid:15.0.0_64only-latest
```

镜像体积较大，请预留磁盘与时间。

---

## 六、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/redroid` |
| macOS（仅旁注） | `~/docker/redroid`（容器仍应跑在 Linux） |

把 **`compose.yml` 放在工作目录**，与 `data15` 同级，不要放进数据目录。

### 6.1 创建目录

```bash
sudo mkdir -p /www/wwwroot/redroid/data15
cd /www/wwwroot/redroid
```

### 6.2 编写 `compose.yml`

```yaml
services:
  redroid:
    image: docker.xuanyuan.run/redroid/redroid:15.0.0_64only-latest
    container_name: redroid
    restart: unless-stopped
    privileged: true
    volumes:
      - ./data15:/data
    ports:
      - "15555:5555"
    command:
      - androidboot.use_memfd=1
      - androidboot.redroid_width=720
      - androidboot.redroid_height=1280
      - androidboot.redroid_dpi=320
      # 有 GPU 时可改为 auto 或 host
      # - androidboot.redroid_gpu_mode=auto
```

`command` 里是 Android boot 参数，会接在镜像默认 `/init qemu=1` 后面。常用项：

| 参数 | 含义 | 官方默认 |
|------|------|----------|
| `androidboot.redroid_width` / `_height` | 分辨率 | 720 × 1280 |
| `androidboot.redroid_dpi` | DPI | 320 |
| `androidboot.redroid_fps` | 帧率 | GPU 开约 30，否则约 15 |
| `androidboot.use_memfd` | 用 memfd 替代 ashmem | false（新内核用 **1**） |
| `androidboot.redroid_gpu_mode` | `guest` / `host` / `auto` | guest |

### 6.3 启动并验证

```bash
cd /www/wwwroot/redroid
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network data15_default Created
 ✔ Container redroid      Started
```

```text
NAME      IMAGE                                                      COMMAND                  SERVICE   CREATED         STATUS         PORTS
redroid   docker.xuanyuan.run/redroid/redroid:15.0.0_64only-latest   "/init qemu=1 androi…"   redroid   7 seconds ago   Up 5 seconds   0.0.0.0:15555->5555/tcp, [::]:15555->5555/tcp
```

容器保持 **Up**、端口为 **15555→5555** 即可。项目网络名随 Compose 所在目录变化，不必和上文完全一致。`docker compose logs` 经常是空的：Android 日志在容器内 **logcat**。

系统起来大约要几十秒，再去做 ADB。若状态反复 Restarting，按第十节查内核与 `dmesg`。

---

## 七、ADB 连接与 scrcpy 投屏

### 7.1 安装 ADB

装在**你操作安卓的那台机器**上（跑容器的 Ubuntu，或另一台电脑）。容器里已有 adbd，**不必**再进容器装 ADB。

**Ubuntu / Debian：**

```bash
sudo apt update
sudo apt install -y adb
adb version
```

**Windows / macOS：** 用 Google [platform-tools](https://developer.android.com/tools/releases/platform-tools)，或直接用 scrcpy 便携包里的 `adb.exe`。

### 7.2 本机连接（可选）

容器刚 Up 时若 `offline`，等 **30～60 秒**。同机验证：

```bash
adb kill-server
adb connect 127.0.0.1:15555
adb devices
```

期望只有 **`127.0.0.1:15555    device`**，不要出现 `emulator-5554`。Ubuntu 实测：

```text
* daemon not running; starting now at tcp:5037
* daemon started successfully
connected to 127.0.0.1:15555
```

```text
List of devices attached
127.0.0.1:15555	device
```

### 7.3 Windows 投屏（scrcpy）

scrcpy 要图形界面。SSH 进无桌面的服务器再跑，会出现 `XDG_RUNTIME_DIR is invalid or not set`。请在 **Windows**（或带桌面的电脑）上投屏。

解压 [scrcpy](https://github.com/Genymobile/scrcpy) 后，在该目录打开终端（实测 `192.168.1.251`）：

```bat
adb.exe connect 192.168.1.251:15555
adb.exe devices
scrcpy.exe -s 192.168.1.251:15555
```

Windows 实测：

```text
connected to 192.168.1.251:15555
```

```text
List of devices attached
192.168.1.251:15555     device
```

```text
INFO:     --> (tcpip)  192.168.1.251:15555             device  redroid15_x86_64_only
[server] INFO: Device: [redroid] redroid redroid15_x86_64_only (Android 15)
INFO: Renderer: direct3d11
INFO: Texture: 720x1280
```

窗口标题为 **`redroid15_x86_64_only`**，分辨率与 Compose 中的 720×1280 一致：

![redroid Android 15 主屏幕：scrcpy 窗口 redroid15_x86_64_only，Google 搜索框与 Gallery / Contacts / Camera](https://imgs.xuanyuan.cloud/docker/blog/redroid-1.webp)

连不上时，在 Linux 上确认 `ss -lntp | grep 15555`，防火墙只放行内网。

### 7.4 主界面

这是接近 AOSP 的桌面：预装 Gallery、Contacts、Camera，**没有 Google 套件**（GMS 需自行改镜像，见第八节）。点 **Contacts** 会先问通知权限：

![redroid Contacts：允许发送通知的系统权限对话框 ALLOW / DON'T ALLOW](https://imgs.xuanyuan.cloud/docker/blog/redroid-2.webp)

进入后是空列表，可用右下角加号或 IMPORT：

![redroid Contacts 空列表：Your contacts list is empty，右下角粉色加号按钮](https://imgs.xuanyuan.cloud/docker/blog/redroid-3.webp)

多任务里打开 WebView，实测能访问公网（如 [xuanyuan.cloud](https://xuanyuan.cloud)）：

![redroid 最近任务：WebView 打开 xuanyuan.cloud，屏幕键盘与 Screenshot 按钮](https://imgs.xuanyuan.cloud/docker/blog/redroid-4.webp)

### 7.5 常用 ADB

```bash
adb -s 192.168.1.251:15555 shell getprop ro.build.version.release
adb -s 192.168.1.251:15555 install path/to/app.apk
adb -s 192.168.1.251:15555 shell pm list packages | head
```

同机把序列号换成 `127.0.0.1:15555`。进容器看进程 / 日志：

```bash
docker exec -it redroid sh
ps -A
logcat -d | tail
```

---

## 八、安全、多实例与生产注意

1. **ADB**：只走内网、VPN 或 SSH 隧道。官方明确 **不要把 ADB 端口暴露到公网**，否则容器甚至宿主可能被入侵。  
2. **privileged**：权限很高，限制谁能访问 Docker 套接字和 ADB。  
3. **数据**：`./data15` 即 Android `/data`。备份整目录即可；换大版本（例如 15→16）不要复用旧 `/data`。  
4. **多实例**：改 `container_name`、宿主机端口（如 `15556:5555`）和独立数据目录。  
5. **GPU**：`host` / `auto` 依赖宿主驱动；失败时退回 `guest`。  
6. **GMS / ARM 翻译**：见官方 [GMS](https://github.com/remote-android/redroid-doc#gms-support)、[Native Bridge](https://github.com/remote-android/redroid-doc#native-bridge-support)，本文不展开。

---

## 九、备选：docker run

临时试玩或没有 Compose 时：

```bash
sudo mkdir -p /www/wwwroot/redroid/data15

docker run -d \
  --name redroid \
  --privileged \
  --restart unless-stopped \
  -v /www/wwwroot/redroid/data15:/data \
  -p 15555:5555 \
  docker.xuanyuan.run/redroid/redroid:15.0.0_64only-latest \
  androidboot.use_memfd=1 \
  androidboot.redroid_width=720 \
  androidboot.redroid_height=1280 \
  androidboot.redroid_dpi=320
```

```bash
docker ps --filter name=redroid
```

官方 Quick Start 常带 `--rm`，只适合一次性试玩；长期运行用上面的 `--restart`，不要加 `--rm`。

---

## 十、常见问题 FAQ

**Q1：`modprobe ashmem_linux` 报 Module not found？**  
Ubuntu 24.04（内核 6.8）已无 ashmem。保留 `androidboot.use_memfd=1` 即可。

**Q2：`ls /dev/binder` 提示 No such file？**  
新内核用 binderfs，设备在 `/dev/binderfs/`。见第四节。

**Q3：容器启动后马上消失？**  
确认 binder 已加载、binderfs 已挂载，再看 `dmesg -T`。

**Q4：同时出现 `127.0.0.1:5555` 和 `emulator-5554`，且都是 offline？**  
宿主机占用了 **5555**，ADB 会把它当成模拟器，再 `adb connect` 等于连两次。映射改成 **`15555:5555`** 后：

```bash
adb kill-server
adb connect 127.0.0.1:15555
adb devices
```

只应留下 `127.0.0.1:15555    device`。仍 offline 时等开机，或：

```bash
docker exec redroid getprop sys.boot_completed
docker exec redroid logcat -d | tail
```

`sys.boot_completed` 为 `1` 后再 connect。

**Q5：scrcpy 报 `XDG_RUNTIME_DIR is invalid or not set`？**  
在 SSH / 无桌面的服务器上跑了 scrcpy。到有显示器的电脑上投屏。

**Q6：官方 16 镜像显示 device，但 scrcpy / `screencap` 失败？**  
实测 `16.0.0_64only-latest` **没有 Display**（`Failed to get ID for any displays`）。看屏用 **`15.0.0_64only-latest`**，并换数据目录。上游：[redroid-doc#862](https://github.com/remote-android/redroid-doc/issues/862)。

**Q7：标签里的 `-latest` 不就是 latest 吗？**  
`15.0.0_64only-latest` 钉死的是 **Android 15 这一条线**。仓库通常**没有**无版本前缀的裸 `latest`。不要把它改成 `redroid/redroid:latest`。

**Q8：和 kasmweb/redroid、浏览器远程桌面有何区别？**  
本文是 **`redroid/redroid` + ADB / scrcpy**。Kasm Desktop / Webtop 是浏览器里的 Linux 桌面；`kasmweb/redroid` 是另一条产品线。

**Q9：macOS / Windows 能直接跑容器吗？**  
不能（缺内核模块）。容器放 Linux，客户端 ADB / scrcpy 可以在笔记本上。

**Q10：如何收集调试信息？**

```bash
curl -fsSL https://raw.githubusercontent.com/remote-android/redroid-doc/master/debug.sh | sudo bash -s -- redroid
```

---

## 十一、命令速查

```bash
# 内核
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
sudo mkdir -p /dev/binderfs
sudo mount -t binder binder /dev/binderfs
ls -l /dev/binderfs/

# 拉取
docker pull docker.xuanyuan.run/redroid/redroid:15.0.0_64only-latest

# Compose
cd /www/wwwroot/redroid
docker compose up -d
docker compose ps
docker compose down

# ADB / 投屏（同机）
adb kill-server
adb connect 127.0.0.1:15555
adb devices
scrcpy -s 127.0.0.1:15555

# 备选 run
docker start redroid
docker stop redroid
docker rm redroid
```

Windows 投屏把地址换成 `192.168.1.251:15555`（或你的内网 IP）。

---

## 十二、延伸阅读

- 轩辕镜像页：[redroid/redroid](https://xuanyuan.cloud/zh/r/redroid/redroid) · [标签列表](https://xuanyuan.cloud/r/redroid/redroid/tags) · [概览](https://xuanyuan.cloud/r/redroid/redroid)
- 官方文档：[remote-android/redroid-doc](https://github.com/remote-android/redroid-doc) · [deploy](https://github.com/remote-android/redroid-doc/tree/master/deploy)
- 组织主页：[github.com/remote-android](https://github.com/remote-android)
- [platform-tools](https://developer.android.com/tools/releases/platform-tools) · [scrcpy](https://github.com/Genymobile/scrcpy)
- 相关镜像（非本文）：[kasmweb/redroid](https://xuanyuan.cloud/r/kasmweb/redroid)
- 轩辕镜像使用手册：https://xuanyuan.cloud/usage

---

## 总结

- 跟做 **`15.0.0_64only-latest`**，用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取。官方 **16** 线无 Display，不要当看屏默认。  
- 先 **binderfs**，再 Compose：**privileged**、**15555:5555**、**`./data15:/data`**。  
- Windows 用 scrcpy 连内网 IP；**不要把 ADB 暴露到公网**。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/redroid-docker-deploy



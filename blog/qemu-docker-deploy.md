# Docker 部署 QEMU：轻松搭建浏览器可控的虚拟机平台

![Docker 部署 QEMU：轻松搭建浏览器可控的虚拟机平台](https://imgs.xuanyuan.cloud/docker/blog/qemu.webp)

*分类: Docker部署教程 | 标签: QEMU,qemux/qemu,Docker,轩辕镜像,KVM,虚拟机,Web控制台,私有化部署,部署教程 | 发布时间: 2026-09-10 13:12:37*

> qemux/qemu 是在 Docker 容器中运行完整虚拟机的方案，提供浏览器 Web 控制台，支持 KVM 加速与多种磁盘格式。本文将介绍如何通过 Docker Compose 快速部署 qemux/qemu，轻松搭建可自托管的容器化虚拟机环境，适合系统安装试验、隔离测试与内网演练等场景。

*本文基于 [qemux/qemu:7.50](https://xuanyuan.cloud/zh/r/qemux/qemu)，跟做标签 **7.50**，实测引擎 **QEMU 11.1.0** / Alpine **3.24.1**，测试平台 **Ubuntu 24.04** Linux。*

机房或家里已经有一台跑 Docker 的 Ubuntu。想试一张发行版 ISO、或在干净系统里验证某套软件：VirtualBox / VMware 占桌面和授权；整机刻盘又要显示器；笔记本上装过的实验系统一还原，笔记和配置一起没了。更实际的诉求往往是：**隔离的一台虚拟机，浏览器里能看见画面、能敲键盘**，磁盘文件落在自己目录里。

公有云桌面按小时计费，自定义 ISO 流程长；等保与内网也不宜把实验画面送到第三方控制台。很多环境已经会写 Compose，缺的是：**镜像能拉下来，打开 8006 就能进客户机**——不必先上 Proxmox / ESXi。

**qemux/qemu**（[GitHub · qemus/qemu](https://github.com/qemus/qemu)、[镜像页](https://xuanyuan.cloud/zh/r/qemux/qemu)）在容器里跑 **QEMU**：自带 Web 查看器（默认 **8006**），支持 `.iso` / `.qcow2` / `.vmdk` 等格式，可挂 **KVM** 加速，并用环境变量配置 CPU、内存与磁盘。上游示例常用 `BOOT=mint`；本文跟做用体积更小的 **`alpine`**，更快看到控制台（可改成 `mint` / `ubuntu` 等）。

**说明：** 推荐主路径是 **有 `/dev/kvm`** 的 Compose（§4.2）。本文拉取、浏览器截图与完整启动日志，测自一台 **无 KVM 扩展** 的 Ubuntu（`kvm-ok` 报不支持），因此冒烟使用 §4.4 的 **`KVM=N`**。有加速的机器请走主路径，不要长期关加速。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 浏览器操作客户机 | 打开 `http://服务器IP:8006`，登录并执行命令 / 安装系统 |
| 换发行版试机 | 改 `BOOT`，或挂本地 ISO 到 `/boot.iso` |
| 调资源 | `RAM_SIZE` / `CPU_CORES` / `DISK_SIZE` |
| 备份搬家 | 停容器后打包 `./storage` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`qemux/qemu:7.50`**，**Docker Compose** 启动。实测局域网 IP **`192.168.1.35`**，请换成你的。无 Compose 见第八节。文内附 **4** 张实测截图。

> **上手要点**
> - **部署**：第四节 Compose；临时试玩见第八节 `docker run`
> - **KVM**：主路径需要 `/dev/kvm`；没有则 §4.4 加 `KVM=N`（约慢 10 倍，仅冒烟）
> - **端口**：宿主机 **8006** → 容器 **8006**
> - **标签**：跟做 **`7.50`**，勿写 `latest`
> - **BOOT**：首次 **`alpine`**；桌面可改 `mint` / `ubuntu`
> - **数据**：`./storage` → `/storage`
> - **停机**：`stop_grace_period: 2m`
> - **Alpine 登录**：Web 查看器无账号；客户机 **`root` + 空密码回车**
> - **体积**：DISK **777MB** / CONTENT **178MB**
> - **工作目录**：Linux `/www/wwwroot/qemu`；macOS `~/docker/qemu`

官方：[GitHub](https://github.com/qemus/qemu) · [镜像页](https://xuanyuan.cloud/zh/r/qemux/qemu) · [标签列表](https://xuanyuan.cloud/r/qemux/qemu/tags) · [Docker Hub](https://hub.docker.com/r/qemux/qemu)

---

## 一、qemux/qemu 是什么？

容器里是完整虚拟机：独立磁盘、UEFI/BIOS 与网络；浏览器只是画面入口，不是「远程桌面容器」。

| | qemux/qemu（本文） | VirtualBox / VMware | Proxmox / ESXi |
|--|-------------------|---------------------|----------------|
| 入口 | 浏览器 `:8006` | 本机 GUI | Web / 专用控制台 |
| 部署 | Docker Compose | 安装客户端 | 独立虚拟化平台 |
| 加速 | Linux 上 KVM | 本机 VT-x / Hyper-V | 裸机虚拟化 |
| 适合 | 快速试 ISO、隔离实验 | 本机日常虚拟机 | 机房批量管理 |
| 数据 | 本机 `/storage` | 本机虚拟磁盘 | 集群存储 |

```text
浏览器 ──HTTP:8006──▶  qemux/qemu
                         ├── QEMU +（可选）KVM
                         ├── ./storage → /storage
                         └── BOOT / 本地 ISO → 安装介质
```

[`/r/`](https://xuanyuan.cloud/r/qemux/qemu) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/qemux/qemu) 为同一镜像的不同页面语言。同站还有 `tianon/qemu` 等变体，**本文只用 `qemux/qemu:7.50`**。

### 1.1 和 Windows / macOS / ARM 专用镜像怎么选

| 需求 | 建议 |
|------|------|
| 通用 Linux 客户机（本文） | **`qemux/qemu`** |
| Windows | [dockur/windows](https://github.com/dockur/windows) |
| macOS | [dockur/macos](https://github.com/dockur/macos) |
| ARM64 客户机 | [qemus/qemu-arm](https://github.com/qemus/qemu-arm) |
| 更重的 Web 虚拟化管理 | [dockur/proxmox](https://github.com/dockur/proxmox) |

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | **Linux**（建议 Ubuntu 24.04），CPU 支持 VT-x / AMD-V |
| Docker | Engine + **Compose V2**（建议 ≥ 20.10） |
| KVM | 主路径：存在 `/dev/kvm` 且 `kvm-ok` 通过 |
| 内存 | 建议可用 ≥ **4 GB**（客户机默认常占 1～2G） |
| 磁盘 | 虚拟盘按 `DISK_SIZE` 增长 + ISO 缓存 |
| 端口 | 宿主机 **8006** |
| 工作目录 | `/www/wwwroot/qemu` |

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

### 2.1 启动前检查 KVM

```bash
ls -l /dev/kvm
systemd-detect-virt
grep -Eoc '(vmx|svm)' /proc/cpuinfo
sudo apt install -y cpu-checker
sudo kvm-ok
```

| 结果 | 怎么走 |
|------|--------|
| `/dev/kvm` 存在且 `kvm-ok` 可用 | §4.2 主路径 |
| `vmx`/`svm` 为 0，或 `does not support KVM extensions` | 查 BIOS；仍不行则换机器，或 §4.4 `KVM=N` |
| `detect-virt` 非 `none`，且无 `/dev/kvm` | 在**外层 Hypervisor** 开嵌套虚拟化后再查（见 FAQ Q3） |
| 有标志但无设备 | `sudo modprobe kvm_intel`（AMD：`kvm_amd`）后再 `kvm-ok` |

Ubuntu 24.04 实测机（`detect-virt=none`）：

```text
grep -Eoc '(vmx|svm)' /proc/cpuinfo
0
sudo modprobe kvm_intel
# Operation not supported
sudo kvm-ok
# INFO: Your CPU does not support KVM extensions
# KVM acceleration can NOT be used
```

这类机器走 §4.4，不要硬挂 `/dev/kvm`。

### 2.2 平台兼容性（官方摘要）

| 产品 | Linux | Win11 | Win10 | macOS |
|------|-------|-------|-------|-------|
| Docker CLI | ✅（有 KVM） | ✅（嵌套虚拟化） | ❌ | ❌ |
| Docker Desktop | ❌ | ✅（嵌套虚拟化） | ❌ | ❌ |

正文默认：**Linux + Docker Engine**；有 KVM 优先。

---

## 三、拉取镜像

### 3.1 标签怎么选

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`7.50`** | 版本号标签（与 Hub `latest` 同期） | **推荐** |
| `7.49` … | 历史版本 | 按需回滚 |
| `latest` | 浮动 | **勿写入跟做命令** |

更多见 [标签列表](https://xuanyuan.cloud/r/qemux/qemu/tags)。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/qemux/qemu:7.50
```

Ubuntu 24.04 实测：

```text
7.50: Pulling from qemux/qemu
db32a5e55a81: Pull complete
ded9f8a73085: Pull complete
1877e623676c: Pull complete
cc9c3984f46b: Pull complete
6310eb16bf42: Pull complete
be56f5197a75: Pull complete
8e18b39d92f1: Pull complete
34ba3bbee4c9: Pull complete
Digest: sha256:e7f6fda52503a546fd649670ba46e4bc23dc6dcef275bc3fac48877fbbc430df
Status: Downloaded newer image for docker.xuanyuan.run/qemux/qemu:7.50
docker.xuanyuan.run/qemux/qemu:7.50
```

```bash
docker images docker.xuanyuan.run/qemux/qemu:7.50
```

```text
IMAGE                                 ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/qemux/qemu:7.50   e7f6fda52503        777MB          178MB
```

---

## 四、Docker Compose 部署（推荐）

### 4.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/qemu/storage
cd /www/wwwroot/qemu
# macOS：mkdir -p ~/docker/qemu/storage && cd ~/docker/qemu
```

### 4.2 有 KVM：compose.yml（主路径）

确认 `ls -l /dev/kvm` 存在后再写：

```bash
cat > compose.yml <<'EOF'
services:
  qemu:
    image: docker.xuanyuan.run/qemux/qemu:7.50
    container_name: qemu
    environment:
      BOOT: "alpine"
      DISK_SIZE: "32G"
      RAM_SIZE: "2G"
      CPU_CORES: "2"
      TZ: "Asia/Shanghai"
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - "8006:8006"
    volumes:
      - ./storage:/storage
    restart: unless-stopped
    stop_grace_period: 2m
EOF
```

| 项 | 说明 |
|----|------|
| `BOOT: alpine` | 自动拉 Alpine；可改 `mint` / `debian` / `ubuntu` 等 |
| `DISK_SIZE` | 虚拟盘容量（上游默认 64G） |
| `RAM_SIZE` / `CPU_CORES` | 勿超过宿主可用余量 |
| `devices` | 需要已有 `/dev/kvm` |
| `stop_grace_period: 2m` | 给客户机关机时间 |

```bash
docker compose up -d
docker compose ps
docker compose logs -f qemu
```

期望容器 `Up`，日志出现下载 / Booting。浏览器打开 `http://服务器IP:8006`（示例：`http://192.168.1.35:8006/`）。

若报错：

```text
error gathering device information while adding custom device "/dev/kvm": no such file or directory
```

说明宿主机没有该设备——回到 §2.1，或改用 §4.4。

### 4.3 无 KVM：`KVM=N` 冒烟（实测路径）

仅当没有 `/dev/kvm`、又想确认 **8006** 能否起来时使用。必须同时：

1. **不要**挂载 `/dev/kvm`
2. 环境变量加 **`KVM: "N"`**（只删设备、不加变量会 **exit 88** 循环重启）

软件模拟大约慢 10 倍，**不要当生产默认**。

```bash
cd /www/wwwroot/qemu

cat > compose.yml <<'EOF'
services:
  qemu:
    image: docker.xuanyuan.run/qemux/qemu:7.50
    container_name: qemu
    environment:
      BOOT: "alpine"
      DISK_SIZE: "16G"
      RAM_SIZE: "1G"
      CPU_CORES: "1"
      KVM: "N"
      TZ: "Asia/Shanghai"
    devices:
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - "8006:8006"
    volumes:
      - ./storage:/storage
    restart: unless-stopped
    stop_grace_period: 2m
EOF

docker compose up -d
docker compose ps
docker compose logs -f qemu
```

Ubuntu 24.04 实测：

```text
[+] up 1/1
 ✔ Container qemu Started

NAME   IMAGE                                 STATUS
qemu   docker.xuanyuan.run/qemux/qemu:7.50   Up …   0.0.0.0:8006->8006/tcp
```

```text
❯ Warning: KVM acceleration is disabled, this will cause the machine to run about 10 times slower!
❯ Downloading Alpine Linux 3.24.1...
10% → … → 100%
❯ Creating a 16 GB growable disk image in raw format...
❯ Guest: 172.30.48.2 (QEMU)  |  Mode: NAT
❯ Warning: Your configured RAM_SIZE of 1 GB is too high for the 1.3 GB of free memory available...
❯ Allocated 783 MB of RAM for the virtual machine.
❯ Booting image using QEMU v11.1.0...
BdsDxe: failed to load ... HARDDISK ... Not Found
...
GNU GRUB version 2.14
Booting `Linux virt'
Welcome to Alpine Linux 3.24
Kernel 6.18.35-0-virt on x86_64 (/dev/ttyS0)
```

空盘时 UEFI 先试硬盘失败再进安装介质，正常。宿主空闲内存不够时，镜像会下调 `RAM_SIZE`（本例 1G → 783MB）。

未加 `KVM=N` 时的典型失败：

```text
STATUS: Restarting (88)
❯ ERROR: KVM acceleration is not available (/dev/kvm is missing)...
❯ ERROR: ... disable acceleration by adding the "KVM=N" variable (not recommended).
```

---

## 五、浏览器首次使用

1. 打开 `http://192.168.1.35:8006/`（换成你的 IP）。
2. 等待 Web 查看器出现客户机画面（首次可能还在下 ISO）。
3. Alpine live：**`root`**，密码**空**（直接回车）。Web 查看器本身默认无登录框。
4. 数据在 `./storage`；要把系统装进虚拟硬盘，再按 Alpine 安装向导做。

![Alpine Linux 3.24：OpenRC 启动完成，localhost login 等待输入](https://imgs.xuanyuan.cloud/docker/blog/qemu-1.webp)

客户机内冒烟：

```bash
cat /etc/os-release
uname -a
hostname
uptime
free -h
df -h
ip addr
```

实测可见 **Alpine Linux 3.24.1**、内核 **`6.18.35-0-virt`**。精简环境可能没有 `lscpu`；live 下 `eth0` 有时为 `DOWN`，需要时再 `setup-interfaces`。无 KVM 时操作会明显偏慢。

![Alpine 客户机：root 登录后执行 os-release、uname、free、df、ip addr](https://imgs.xuanyuan.cloud/docker/blog/qemu-2.webp)

![Alpine 客户机：冒烟命令输出与左侧快捷键栏（Ctrl / Alt / Win 等）](https://imgs.xuanyuan.cloud/docker/blog/qemu-4.webp)

### 5.1 常用 `BOOT` 取值

| 值 | 系统 | 约大小 |
|----|------|--------|
| `alpine` | Alpine Linux | 60 MB |
| `debian` | Debian | 3.3 GB |
| `ubuntu` | Ubuntu Desktop | 6.0 GB |
| `ubuntus` | Ubuntu Server | 3.0 GB |
| `mint` | Linux Mint | 2.8 GB |
| `rocky` | Rocky Linux | 2.1 GB |
| `fedora` | Fedora | 2.3 GB |
| `kali` | Kali Linux | 3.8 GB |

完整列表见 [上游 README](https://github.com/qemus/qemu)。也可把 `BOOT` 设为 ISO 的 URL，或挂载本地文件：

```yaml
volumes:
  - ./storage:/storage
  - ./my.iso:/boot.iso   # 也可 /boot.img、/boot.qcow2；此时忽略 BOOT
```

---

## 六、Web 查看器与常用操作

左侧栏可发送 Ctrl / Alt / Win；点齿轮打开设置（缩放、品质、压缩、Audio）。实测界面显示版本 **7.50**。

![QEMU Web 查看器设置：本地缩放、品质、压缩与 Audio，版本 7.50](https://imgs.xuanyuan.cloud/docker/blog/qemu-3.webp)

| 操作 | 做法 |
|------|------|
| 改 CPU / 内存 | 改 `CPU_CORES` / `RAM_SIZE` 后 `docker compose up -d` |
| 扩容磁盘 | 增大 `DISK_SIZE` 重启，再在客户机内扩展分区 |
| 映射客户机端口 | 如 `"2222:22"`（桥接网络） |
| 浏览器音频 | `AUDIO: "Y"`，并在设置里打开 Audio |
| GPU（可选） | `GPU: "Y"` + `/dev/dri`（Intel/AMD）；NVIDIA 需 Container Toolkit |

---

## 七、安全与生产注意

- **不要把 8006 裸暴露公网**（等同坐在虚拟机屏幕前）；用内网、VPN 或反代鉴权。
- `RAM_SIZE` / `CPU_CORES` 给宿主留余量，避免 OOM。
- 升级或搬家前备份 `./storage`。
- 需要 KVM / TUN / `NET_ADMIN`；排查权限可临时 `privileged: true`，确认后收回。
- Windows / macOS 客户机用 §1.1 专用镜像。

---

## 八、备选：docker run

适合临时试玩。有 KVM：

```bash
sudo mkdir -p /www/wwwroot/qemu/storage

docker run -d \
  --name qemu \
  --restart unless-stopped \
  -e BOOT=alpine \
  -e DISK_SIZE=32G \
  -e RAM_SIZE=2G \
  -e CPU_CORES=2 \
  -e TZ=Asia/Shanghai \
  -p 8006:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  -v /www/wwwroot/qemu/storage:/storage \
  --stop-timeout 120 \
  docker.xuanyuan.run/qemux/qemu:7.50
```

无 KVM 时：去掉 `--device=/dev/kvm`，并加 `-e KVM=N`。

```bash
docker ps --filter name=qemu
docker logs -f qemu
docker stop qemu && docker rm qemu   # 不删 ./storage
```

---

## 九、升级与迁移

1. 备份 `/www/wwwroot/qemu/storage` 与 `compose.yml`。
2. 改镜像标签后：

```bash
cd /www/wwwroot/qemu
docker compose pull
docker compose up -d
```

3. 打开 8006 确认客户机仍能启动；查阅上游 [Releases](https://github.com/qemus/qemu)。
4. 迁机：拷贝 `storage` 与 Compose，同一标签拉起。

---

## 十、常见问题 FAQ

**Q1：`adding custom device "/dev/kvm": no such file or directory`？**  
宿主机没有 `/dev/kvm`。按 §2.1 诊断；不能用 KVM 则走 §4.3（`KVM=N`）。

**Q2：容器 `Restarting (88)`，日志提示加 `KVM=N`？**  
只删了设备挂载不够。在 `environment` 加 `KVM: "N"` 后再 `up -d`。仅冒烟，官方不推荐长期使用。

**Q3：Ubuntu 在虚拟机里，怎么开嵌套虚拟化？**  
在**外层**配置，不是只在客户机 `apt install`。Linux/KVM/Proxmox：宿主机 `options kvm_intel nested=1`（AMD 用 `kvm_amd`），客户机 CPU 用 `host`；VMware 勾选 Virtualize Intel VT-x/EPT…；Hyper-V 对 VM 暴露虚拟化扩展。说明见 [Ubuntu 文档](https://ubuntu.com/server/docs/how-to/virtualisation/enable-nested-virtualisation/)。若 `kvm-ok` 已写 **does not support KVM extensions**，嵌套也救不了，只能换机器或 `KVM=N`。

**Q4：为什么不用 `latest`？**  
浮动标签会静默变更。跟做固定 **`7.50`**，升级时主动改标签。

**Q5：首次启动很久？**  
在下 ISO；`ubuntu` / `centos` 更大。想快验证用 `alpine` 或本地 `/boot.iso`。

**Q6：客户机检测不到硬盘？**  
默认 `virtio-scsi`。可设 `DISK_TYPE: "blk"` 或 `"ide"`（更慢更兼容）。

**Q7：如何关 UEFI？**  
`BOOT_MODE: "legacy"`。

**Q8：Docker Desktop 能跑吗？**  
官方：Linux / macOS / Win10 的 Desktop 通常不把 KVM 给容器；Win11 需嵌套虚拟化。优先 Linux Engine。

**Q9：映射客户机 SSH？**  
桥接下加 `"2222:22"`。用户模式网络还需 `USER_PORTS`（见上游 FAQ）。

**Q10：与宿主机共享目录？**  
挂载 `./share:/shared`，客户机支持 9p 时：

```shell
mount -t 9p -o trans=virtio shared /mnt/share
```

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/qemux/qemu:7.50

# Compose（有 KVM）
cd /www/wwwroot/qemu
docker compose up -d
docker compose ps
docker compose logs -f qemu
docker compose down

# 探测
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8006/

# 备选 run（有 KVM）
docker run -d --name qemu --restart unless-stopped \
  -e BOOT=alpine -e DISK_SIZE=32G -p 8006:8006 \
  --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN \
  -v /www/wwwroot/qemu/storage:/storage --stop-timeout 120 \
  docker.xuanyuan.run/qemux/qemu:7.50
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [qemux/qemu 镜像页](https://xuanyuan.cloud/zh/r/qemux/qemu) | [https://xuanyuan.cloud/zh/r/qemux/qemu](https://xuanyuan.cloud/zh/r/qemux/qemu) |
| [qemux/qemu 概览](https://xuanyuan.cloud/r/qemux/qemu) | [https://xuanyuan.cloud/r/qemux/qemu](https://xuanyuan.cloud/r/qemux/qemu) |
| [qemux/qemu 标签列表](https://xuanyuan.cloud/r/qemux/qemu/tags) | [https://xuanyuan.cloud/r/qemux/qemu/tags](https://xuanyuan.cloud/r/qemux/qemu/tags) |
| [GitHub · qemus/qemu](https://github.com/qemus/qemu) | [https://github.com/qemus/qemu](https://github.com/qemus/qemu) |
| [Docker Hub · qemux/qemu](https://hub.docker.com/r/qemux/qemu) | [https://hub.docker.com/r/qemux/qemu](https://hub.docker.com/r/qemux/qemu) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- **qemux/qemu** 在容器里跑 QEMU，浏览器 **8006** 操作客户机。
- 跟做 **`7.50`**，[轩辕镜像](https://xuanyuan.cloud) 加速拉取；主路径 Compose + `/dev/kvm`。
- 无 KVM 时删设备挂载并加 **`KVM=N`**（实测已进 Alpine 3.24）；长期使用请换有加速的机器。
- Alpine live：`root` + 空密码；公网勿裸暴露 8006。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/qemu-docker-deploy



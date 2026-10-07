# Docker 部署 dockurr/windows：轻松搭建浏览器可控 Windows 虚拟机

![Docker 部署 dockurr/windows：轻松搭建浏览器可控 Windows 虚拟机](https://imgs.xuanyuan.cloud/docker/blog/windows.webp)

*分类: Docker部署教程 | 标签: dockurr/windows, Windows, Docker, 轩辕镜像, KVM, 虚拟机, RDP, Web控制台, 私有化部署, 部署教程 | 发布时间: 2026-09-23 08:46:36*

> dockurr/windows 在 Docker 容器里跑完整 Windows：自动下载安装介质、无人值守装机，浏览器看进度，装完可用远程桌面。本文将介绍如何用 Docker Compose 部署，并用轩辕镜像加速拉取，适合在 Linux 上试验 Windows 软件、隔离联调与内网桌面演练。

*本文基于 [dockurr/windows:6.05](https://xuanyuan.cloud/r/dockurr/windows)，以 **6.05** 版本实测（引擎 **QEMU v11.1.0**），测试平台 **Ubuntu 24.04** Linux。*

机房或家里已经有一台跑 Docker 的 Ubuntu。偶发要测只提供 Windows 安装包的客户端、核对旧版 IE，或给内网演练准备一台干净桌面：双系统要重启；本机再装 VirtualBox / VMware 占授权和桌面；整机刻盘又要显示器。更实际的诉求往往是：**隔离的一台 Windows，浏览器里能看见安装过程，装完用远程桌面日常操作**，磁盘落在自己目录里。

公有云 Windows 按小时计费，自定义镜像流程长；等保与内网也不宜把实验桌面挂到第三方控制台。很多环境已经会写 Compose，缺的是：镜像能拉下来、装机能看着进度、装完能远程桌面——不必先上 Proxmox / ESXi。

**dockurr/windows**（[GitHub · dockur/windows](https://github.com/dockur/windows)、[镜像页](https://xuanyuan.cloud/r/dockurr/windows)）是在 Docker 里跑完整 Windows 的方案。容器内用 QEMU，Linux 上有 KVM 时速度接近本机；选好要装的版本后自动下载安装介质并无人值守安装。装机时用浏览器打开 **8006** 看画面，装完用 **远程桌面（3389）**；虚拟盘落在挂载目录，需要和 Linux 互拷文件再挂一个共享目录即可。默认装 **Windows 11 Pro**，也可换成 10、Server、Tiny11、XP 等。本文使用 **`dockurr/windows:6.05`** 版本实测。

跑通之后，可以在这台 Linux 上隔离测 exe / MSI、核对旧浏览器或老控件，或给培训 / 演练准备一台用完可销毁的桌面——不必为试软件去双系统或另搭虚拟化集群。

**推荐路径与本文实测：** 有 `/dev/kvm`、宿主空闲内存建议 ≥ **4～8 GB** 时，按 §3.2 装 **Windows 11**（`VERSION=11`）。本文拉取与装机截图测自一台 **整机约 2 GB、无 `/dev/kvm`** 的 Ubuntu（日志 `RAM: 1/2 GB`，Intel Core i3-3217U），因此 §3.4 用 **`KVM=N` + `VERSION=xp`** 把 8006 跑通；截图也是 XP 装机过程。空闲 ≥ 4 GB 的机器可提高 `RAM_SIZE`，并改用 `tiny11` / `10` / `11`；有 KVM 请走主路径，不要长期关加速。

---

## 一、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | **Linux**（建议 Ubuntu 24.04），CPU 支持 VT-x / AMD-V |
| Docker | Engine + **Compose V2**（建议 ≥ 20.10） |
| KVM | 实用路径：存在 `/dev/kvm` 且 `kvm-ok` 通过 |
| 内存 | 装 Win11 / Tiny10：宿主空闲建议 ≥ **4～8 GB**（客人侧常见 `RAM_SIZE` 2G～4G）。整机约 2G 时只能冒烟旧版（如 XP），见 §3.4 |
| 磁盘 | 至少约 **32 GB** 空闲（ISO + 虚拟盘） |
| 端口 | 宿主机 **8006**（Web 查看器）、**3389**（远程桌面 TCP/UDP） |
| 工作目录 | `/www/wwwroot/windows`（macOS 可用 `~/docker/windows`） |

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

### 1.1 启动前检查 KVM

```bash
ls -l /dev/kvm
systemd-detect-virt
grep -Eoc '(vmx|svm)' /proc/cpuinfo
sudo apt install -y cpu-checker
sudo kvm-ok
```

| 结果 | 怎么走 |
|------|--------|
| `/dev/kvm` 存在且 `kvm-ok` 可用 | §3.2 |
| CPU 无 `vmx`/`svm`，或 `does not support KVM extensions` | 查 BIOS；仍不行则换机器，或 §3.4 仅冒烟 |
| `detect-virt` 非 `none`，且无 `/dev/kvm` | 在**外层**虚拟化软件开嵌套虚拟化后再查（FAQ） |
| 有虚拟化标志但无 `/dev/kvm` | `sudo modprobe kvm_intel`（AMD：`kvm_amd`）后再 `kvm-ok` |

### 1.2 平台兼容性（官方摘要）

| 产品 | Linux | Win11 | Win10 | macOS |
|------|-------|-------|-------|-------|
| Docker CLI / Engine | ✅（有 KVM） | ✅（嵌套虚拟化） | ❌ | ❌ |
| Docker Desktop | ❌ | ✅（嵌套虚拟化） | ❌ | ❌ |

### 1.3 许可说明

本项目只分发开源编排与运行时，**不附带 Windows 安装介质授权**。安装介质由容器按所选 `VERSION` 下载；流程中若出现产品密钥，多为微软公布的通用安装密钥，**不等于正式授权**。请自行确认合法许可并遵守微软条款。

---

## 二、拉取镜像

### 2.1 镜像标签和 `VERSION` 别混

| 名称 | 含义 | 本文取值 |
|------|------|----------|
| **镜像标签** | `dockurr/windows` 容器版本 | **`6.05`** |
| **`VERSION`** | 要装的 Windows 发行版 | 推荐 **`11`**（Win11 Pro）；本文低配实测用 **`xp`** |

`latest` 与 `6.05` 在撰写时同线，但会静默变更——命令与 Compose 一律写 **`6.05`**。标签列表见 [xuanyuan.cloud/r/dockurr/windows/tags](https://xuanyuan.cloud/r/dockurr/windows/tags)。

### 2.2 客人系统怎么选

| 值 | 系统 | 约大小 | 说明 |
|----|------|--------|------|
| **`11`** | Windows 11 Pro | 7.9 GB | 实用默认；需足够内存与 KVM |
| `10` | Windows 10 Pro | 5.7 GB | 略省资源 |
| `tiny11` | Tiny11 | 5.3 GB | 精简；仍要约 ≥2G 可用内存 |
| `2022` / `2025` | Windows Server | 6～7.6 GB | 服务器场景 |
| **`xp`** | Windows XP | 约 0.6 GB | 低配冒烟 / 怀旧；本文截图来自 XP |

完整列表见 [上游 README](https://github.com/dockur/windows)。

### 2.3 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/dockurr/windows:6.05
```

Ubuntu 24.04 实测：

```text
6.05: Pulling from dockurr/windows
b50fba0d18a0: Pull complete
80a85187574e: Pull complete
7f48b3c09e2c: Pull complete
af4095e0b31e: Pull complete
841975e6bdb9: Pull complete
712041eb2bb8: Pull complete
Digest: sha256:0cff9eb0e7aee9953e55bc682852ca4fdca233145a58ae1ec94f0b0c01a2ed30
Status: Downloaded newer image for docker.xuanyuan.run/dockurr/windows:6.05
docker.xuanyuan.run/dockurr/windows:6.05
```

```bash
docker images docker.xuanyuan.run/dockurr/windows:6.05
```

```text
IMAGE                                      ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/dockurr/windows:6.05   0cff9eb0e7ae        801MB          199MB
```

---

## 三、Docker Compose 部署（推荐）

### 3.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/windows/storage /www/wwwroot/windows/shared
cd /www/wwwroot/windows
# macOS：mkdir -p ~/docker/windows/{storage,shared} && cd ~/docker/windows
```

### 3.2 有 KVM：写入 compose.yaml（推荐）

确认 `ls -l /dev/kvm` 存在，且空闲内存够用（建议 ≥ 4 GB）后再写。下面按 **Windows 11**、中文安装介质、`RAM_SIZE=4G` 示例——请按本机余量调整，勿在 2G 整机上照抄。

```bash
cat > compose.yaml <<'EOF'
services:
  windows:
    image: docker.xuanyuan.run/dockurr/windows:6.05
    container_name: windows
    environment:
      VERSION: "11"
      LANGUAGE: "Chinese"
      RAM_SIZE: "4G"
      CPU_CORES: "2"
      DISK_SIZE: "64G"
      TZ: "Asia/Shanghai"
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - "8006:8006"
      - "3389:3389/tcp"
      - "3389:3389/udp"
    volumes:
      - ./storage:/storage
      - ./shared:/shared
    restart: unless-stopped
    stop_grace_period: 2m
EOF
```

| 项 | 说明 |
|----|------|
| `VERSION: "11"` | 客人装 Win11 Pro；与镜像标签 `6.05` 无关 |
| `LANGUAGE: "Chinese"` | 中文安装介质；要英文可删或改 `English` |
| `RAM_SIZE` / `CPU_CORES` | 勿超过宿主空闲。空闲约 4G 可用 `2G`～`4G`；更宽裕可再加 |
| `DISK_SIZE` | 虚拟盘容量；磁盘紧可先 `32G` |
| `./storage` | 虚拟盘与安装数据 |
| `./shared` | 装完后桌面 Shared / `Z:` |
| `stop_grace_period: 2m` | 给 Windows 关机时间 |

装机阶段若要改默认账号（未设置时为 **`Docker` / `admin`**）：

```yaml
      USERNAME: "winuser"
      PASSWORD: "改成你的强密码"
```

### 3.3 启动

```bash
docker compose up -d
docker compose ps
docker compose logs -f windows
```

期望容器 `Up`，日志出现下载 / 安装相关输出。浏览器打开 `http://服务器IP:8006`（例如 `http://192.168.1.35:8006/`）。首次会下载数 GB 级 ISO 并自动安装，耗时取决于带宽与磁盘；装完再用远程桌面。

若报：

```text
error gathering device information while adding custom device "/dev/kvm": no such file or directory
```

本机没有 `/dev/kvm`——回到 §1.1；只想确认容器能否起来，见 §3.4。

```bash
docker compose down   # 停容器，不删 ./storage
```

### 3.4 无 KVM / 内存紧：仅冒烟

软件模拟大约慢一个数量级，**不要**当日常方案。有 KVM 且内存够，请始终用 §3.2。

同时满足：

1. **不要**挂载 `/dev/kvm`
2. 加环境变量 **`KVM: "N"`**（只删设备不够，容器仍会因缺加速退出）

| 宿主大致空闲 | 建议 `VERSION` | `RAM_SIZE` |
|--------------|----------------|------------|
| ≥ 4 GB（仍无 KVM） | `tiny11` / `10` | `2G`～`4G` |
| 约 1～2 GB（本文实测） | **`xp`** | **`1G`**（会被自动下调） |

本文实测（`xp` + `KVM=N`）：

```bash
cd /www/wwwroot/windows
# 若刚失败过 Tiny11，可清空残盘：sudo rm -rf ./storage/* ./shared/*

cat > compose.yaml <<'EOF'
services:
  windows:
    image: docker.xuanyuan.run/dockurr/windows:6.05
    container_name: windows
    environment:
      VERSION: "xp"
      RAM_SIZE: "1G"
      CPU_CORES: "1"
      DISK_SIZE: "16G"
      KVM: "N"
      TZ: "Asia/Shanghai"
    devices:
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - "8006:8006"
      - "3389:3389/tcp"
      - "3389:3389/udp"
    volumes:
      - ./storage:/storage
      - ./shared:/shared
    restart: unless-stopped
    stop_grace_period: 2m
EOF

docker compose up -d
docker compose ps
docker compose logs -f windows
```

```text
[+] up 2/2
 ✔ Network windows_default Created
 ✔ Container windows       Started

NAME      IMAGE                                      STATUS
windows   docker.xuanyuan.run/dockurr/windows:6.05   Up …   0.0.0.0:8006->8006/tcp, 0.0.0.0:3389->3389/tcp
```

```text
❯ Starting Windows for Docker v6.05...
❯ CPU: Intel Core i3 3217U | RAM: 1/2 GB | DISK: 82 GB (ext4) | KERNEL: 6.8.0-139
❯ Warning: KVM acceleration is disabled, this will cause the machine to run about 10 times slower!
❯ Downloading Windows XP from bobpony.com...
10% → … → 100%
❯ Extracting Windows XP image...
❯ Preparing Windows XP installation...
❯ Creating a 16 GB growable disk image in raw format...
❯ Guest: 172.30.0.2 (Windows)  |  Mode: NAT
❯ Warning: Your configured RAM_SIZE of 1 GB is too high for the 1.3 GB of free memory available...
❯ Allocated 780 MB of RAM for Windows.
❯ Booting Windows (legacy) using QEMU v11.1.0...
Boot failed: not a bootable disk
Booting from DVD/CD...
❯ Windows started successfully, visit http://127.0.0.1:8006/ to view the screen...
```

空盘时先试硬盘失败再进安装介质，正常；空闲不够时会自动下调内存（本例 1G → 780MB）。浏览器打开 `http://服务器IP:8006` 即可看装机画面（下一节截图）。

装 Win11：换 **有 `/dev/kvm`、内存更宽裕** 的机器，回到 §3.2。

---

## 四、浏览器装机与远程桌面

### 4.1 Web 查看器（装机阶段）

1. 打开 `http://服务器IP:8006/`（示例 `http://192.168.1.35:8006/`）。
2. 日志出现 `Windows started successfully` 后出现客人机画面；左侧是查看器工具栏。
3. 本文截图为 **Windows XP** 装机：文字阶段 → 复制文件 → 图形向导。无 KVM 时整段偏慢。
4. 见到桌面后，数据在 `./storage`；与宿主互拷用 `./shared`（Shared / `Z:`）。

文字 Setup，准备待复制文件列表：

![dockurr/windows Web 查看器：Windows XP Professional Setup，Creating list of files to be copied](https://imgs.xuanyuan.cloud/docker/blog/windows-1.webp)

复制系统文件（约 7% → 44%）：

![Windows XP Setup：Setup is copying files… 进度约 7%](https://imgs.xuanyuan.cloud/docker/blog/windows-2.webp)

![Windows XP Setup：Setup is copying files… 进度约 44%](https://imgs.xuanyuan.cloud/docker/blog/windows-3.webp)

进入图形安装，侧栏 **Installing Windows**，当前 **Installing Devices**（预计仍需数十分钟）：

![Windows XP 图形安装：Installing Windows / Installing Devices，预计约 37 分钟](https://imgs.xuanyuan.cloud/docker/blog/windows-4.webp)

![Windows XP 图形安装：Installing Devices，侧栏仍为 Installing Windows](https://imgs.xuanyuan.cloud/docker/blog/windows-5.webp)

盯进度用 Web 即可；装完后日常更推荐远程桌面。

### 4.2 远程桌面（日常）

| 项 | 值 |
|----|-----|
| 地址 | `服务器IP:3389` |
| 用户名 | `Docker`（或 Compose 里的 `USERNAME`） |
| 密码 | `admin`（或你设的 `PASSWORD`） |

Windows 本机用 `mstsc`，Linux 可用 FreeRDP，手机可用微软 Remote Desktop。登录后请改密；不要把 3389 / 8006 裸暴露公网。

本文冒烟客人是 **XP**，远程桌面能力与 Win10/11 不同；§3.2 的 Windows 11 再按上表连接。

### 4.3 常用调参

| 需求 | 做法 |
|------|------|
| 改 CPU / 内存 | 改 `CPU_CORES` / `RAM_SIZE` 后 `docker compose up -d` |
| 扩容磁盘 | 增大 `DISK_SIZE` 重启，再在客人系统内扩展分区 |
| 浏览器音频 | `AUDIO: "Y"`，并在查看器设置里打开 Audio |
| 换 Windows 版本 | 改 `VERSION`；已有盘应换目录或清空 `./storage` 再装 |
| 本地 ISO | 挂载 `./xxx.iso:/custom.iso`（忽略在线下载） |

---

## 五、安全与生产注意

- 8006 / 3389 走内网、VPN 或反代鉴权，勿裸暴露公网。
- 默认 `Docker` / `admin` 仅适合实验室；长期使用请改账号密码。
- `RAM_SIZE` / `CPU_CORES` 给宿主留余量，避免 OOM。
- 升级或搬家前备份 `./storage`（及需要的 `./shared`）。
- 需要 KVM / TUN / `NET_ADMIN`；排查权限可临时 `privileged: true`，确认后收回。
- 自行确认 Windows 许可合规。

---

## 六、备选：docker run

临时试玩、已有 `/dev/kvm` 时可用：

```bash
sudo mkdir -p /www/wwwroot/windows/storage /www/wwwroot/windows/shared

docker run -d \
  --name windows \
  --restart unless-stopped \
  -e VERSION=11 \
  -e LANGUAGE=Chinese \
  -e RAM_SIZE=4G \
  -e CPU_CORES=2 \
  -e DISK_SIZE=64G \
  -e TZ=Asia/Shanghai \
  -p 8006:8006 \
  -p 3389:3389/tcp \
  -p 3389:3389/udp \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  -v /www/wwwroot/windows/storage:/storage \
  -v /www/wwwroot/windows/shared:/shared \
  --stop-timeout 120 \
  docker.xuanyuan.run/dockurr/windows:6.05
```

```bash
docker ps --filter name=windows
docker logs -f windows
docker stop windows && docker rm windows   # 不删 ./storage
```

无 KVM 时去掉 `--device=/dev/kvm`，并加 `-e KVM=N`；低配内存请改 `-e VERSION=xp` 并降低 `-e RAM_SIZE`。

---

## 七、升级与迁移

1. 备份 `/www/wwwroot/windows/storage`、`shared` 与 `compose.yaml`。
2. 修改 `image:` 标签后：

```bash
cd /www/wwwroot/windows
docker compose pull
docker compose up -d
```

3. 打开 8006 / 远程桌面确认仍能启动；查阅上游 [Releases](https://github.com/dockur/windows/releases)。
4. 迁机：拷贝 `storage`（及 `shared`）与 Compose，同一标签拉起。

---

## 八、常见问题 FAQ

**Q1：`adding custom device "/dev/kvm": no such file or directory`？**  
没有 `/dev/kvm`。按 §1.1 诊断；虚拟机需在外层开嵌套虚拟化。实用部署请换有 KVM 的机器；冒烟见 §3.4。

**Q2：`Tiny 11 requires at least 2.0 GB of RAM…`（或 exit 16 循环）？**  
空闲内存不够。日志 `RAM: 1/2 GB` 表示整机约 2G。可 `free -h`、停掉其它容器；仍不够则改用 `VERSION=xp`（§3.4），或换更大内存机器。

**Q3：`all predefined address pools have been fully subnetted`？**  
Docker 默认网桥地址池分完了（同一台机 Compose 项目多时常见），与镜像无关。

```bash
docker network ls
docker network prune
cd /www/wwwroot/windows
docker compose up -d
```

`prune` 只删无容器在用的网络。仍不够可在 `daemon.json` 扩大 `default-address-pools` 后重启 Docker。

**Q4：该写 `11` 还是 `6.05`？**  
`6.05` 是**容器镜像**标签；`11` 是环境变量 **`VERSION`**（客人 Windows）。拉取与 `image:` 写 `dockurr/windows:6.05`。

**Q5：为什么不用 `latest`？**  
浮动标签会静默变更。本文使用 **`6.05`** 版本实测，升级时再改标签并看 changelog。

**Q6：首次启动很久？**  
在下载 ISO 并自动安装。看 `docker compose logs -f windows` 与浏览器 8006；无 KVM 时更慢。

**Q7：如何换 Windows 10 / Server？**  
改 `VERSION`。已有 `./storage` 不会变成另一个系统——需新目录或清空后再装。

**Q8：Docker Desktop 能跑吗？**  
Linux / macOS / Win10 的 Desktop 通常不把 KVM 给容器；Win11 需嵌套虚拟化。优先 **Linux Engine + `/dev/kvm`**。

**Q9：Ubuntu 在虚拟机里，怎么开嵌套虚拟化？**  
在外层配置：Linux/KVM/Proxmox 开 `nested=1` 且客户机 CPU 用 `host`；VMware 勾选 Virtualize Intel VT-x/EPT…；Hyper-V 对 VM 暴露虚拟化扩展。见 [Ubuntu 文档](https://ubuntu.com/server/docs/how-to/virtualisation/enable-nested-virtualisation/)。

**Q10：和 qemux/qemu 有什么关系？**  
同属容器化虚拟机：`qemux/qemu` 偏 Linux 客人；本文专做 Windows 自动装机。Linux 客人见 [qemux/qemu 教程](https://xuanyuan.cloud/blog/qemu-docker-deploy)。

**Q11：如何用本地 ISO？**  

```yaml
volumes:
  - ./storage:/storage
  - ./win.iso:/custom.iso
```

此时忽略 `VERSION` 的在线下载。

**Q12：合法吗？**  
项目是开源代码，不自带 Windows 安装授权。请自行保证许可合规（§1.3）。

---

## 九、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/dockurr/windows:6.05

# Compose（有 KVM + Win11）
cd /www/wwwroot/windows
docker compose up -d
docker compose ps
docker compose logs -f windows
docker compose down

# 探测 Web 口
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8006/

# 备选 run（有 KVM）
docker run -d --name windows --restart unless-stopped \
  -e VERSION=11 -e LANGUAGE=Chinese -e RAM_SIZE=4G \
  -p 8006:8006 -p 3389:3389/tcp -p 3389:3389/udp \
  --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN \
  -v /www/wwwroot/windows/storage:/storage \
  -v /www/wwwroot/windows/shared:/shared \
  --stop-timeout 120 \
  docker.xuanyuan.run/dockurr/windows:6.05
```

---

## 十、延伸阅读

| 资源 | 链接 |
|------|------|
| [dockurr/windows 镜像页](https://xuanyuan.cloud/r/dockurr/windows) | [https://xuanyuan.cloud/r/dockurr/windows](https://xuanyuan.cloud/r/dockurr/windows) |
| [dockurr/windows 标签列表](https://xuanyuan.cloud/r/dockurr/windows/tags) | [https://xuanyuan.cloud/r/dockurr/windows/tags](https://xuanyuan.cloud/r/dockurr/windows/tags) |
| [GitHub · dockur/windows](https://github.com/dockur/windows) | [https://github.com/dockur/windows](https://github.com/dockur/windows) |
| [Docker Hub · dockurr/windows](https://hub.docker.com/r/dockurr/windows) | [https://hub.docker.com/r/dockurr/windows](https://hub.docker.com/r/dockurr/windows) |
| [qemux/qemu 部署教程](https://xuanyuan.cloud/blog/qemu-docker-deploy) | [https://xuanyuan.cloud/blog/qemu-docker-deploy](https://xuanyuan.cloud/blog/qemu-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/windows-docker-deploy



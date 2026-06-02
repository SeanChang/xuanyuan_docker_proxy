---
image: qemux/qemu
description: "一个在Docker容器中运行虚拟机的QEMU镜像，提供Web界面控制，支持多种磁盘格式（如.iso、.qcow2、.vmdk等），并具备KVM加速等高性能选项，实现接近原生的运行速度。"
source: https://xuanyuan.cloud/zh/r/qemux/qemu
canonical: https://xuanyuan.cloud/zh/r/qemux/qemu
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/qemux/qemu" title="qemux/qemu Docker 镜像中文简介、标签列表与拉取命令">qemux/qemu — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/qemux/qemu" title="qemux/qemu Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/qemux/qemu</a>

# QEMU Docker镜像

## 概述
QEMU Docker镜像是一个在容器中运行虚拟机的解决方案，通过Docker容器化技术简化虚拟机的部署与管理。该镜像提供Web界面控制，支持多种磁盘格式，并集成KVM加速、内核模式网络等高性能特性，适合快速搭建隔离的虚拟机环境，适用于开发测试、操作系统学习等场景。

## 核心功能

- **Web界面控制**：直接通过浏览器访问虚拟机屏幕，使用键盘和鼠标进行操作
- **多磁盘格式支持**：兼容.iso、.img、.qcow2、.vhd、.vhdx、.vdi、.vmdk及.raw等格式
- **高性能配置**：支持KVM加速、内核模式网络、IO线程等选项，实现接近原生的运行速度

## 使用方法

### Docker Compose部署

```yaml
services:
  qemu:
    image: qemux/qemu
    container_name: qemu
    environment:
      BOOT: "mint"  # 指定要安装的操作系统
    devices:
      - /dev/kvm    # KVM设备，用于硬件加速
      - /dev/net/tun  # 网络隧道设备
    cap_add:
      - NET_ADMIN   # 添加网络管理权限
    ports:
      - 8006:8006   # Web界面端口映射
    volumes:
      - ./qemu:/storage  # 存储目录挂载
    restart: always
    stop_grace_period: 2m  # 停止宽限期
```

### Docker CLI部署

```bash
docker run -it --rm --name qemu -e "BOOT=mint" -p 8006:8006 \
  --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN \
  -v "${PWD:-.}/qemu:/storage" --stop-timeout 120 docker.io/qemux/qemu
```

### Kubernetes部署

```shell
kubectl apply -f https://raw.githubusercontent.com/qemus/qemu/refs/heads/master/kubernetes.yml
```

### Github Codespaces

[![在GitHub Codespaces中打开](https://github.com/codespaces/badge.svg)](https://codespaces.new/qemus/qemu)

## 配置说明

### 环境变量

| 变量名       | 说明                                  | 默认值       |
|--------------|---------------------------------------|--------------|
| `BOOT`       | 指定要下载的操作系统（如"ubuntu"）     | 无           |
| `DISK_SIZE`  | 磁盘大小（如"128G"）                  | "64G"        |
| `RAM_SIZE`   | 内存大小（如"8G"）                    | "2G"         |
| `CPU_CORES`  | CPU核心数（如"4"）                    | "2"          |
| `BOOT_MODE`  | 启动模式，"uefi"或"legacy"（传统BIOS）| "uefi"       |
| `DISK_TYPE`  | 磁盘类型，"scsi"、"blk"或"ide"        | "scsi"       |
| `DHCP`       | 是否通过路由器获取IP（"Y"或"N"）      | "N"          |
| `ARGUMENTS`  | 传递给QEMU的额外参数                  | 无           |
| `DEBUG`      | 是否启用调试模式（"Y"或"N"）          | "N"          |

### 卷挂载

- `/storage`: 虚拟机存储目录，用于存放磁盘镜像等数据，建议通过宿主机目录或命名卷挂载
- `/boot.iso`、`/boot.img`、`/boot.qcow2`: 本地镜像文件挂载，挂载后`BOOT`变量将被忽略

### 设备与权限

- `--device=/dev/kvm`: 启用KVM硬件加速（需宿主机支持）
- `--device=/dev/net/tun`: 启用网络隧道
- `--cap-add=NET_ADMIN`: 添加网络管理权限，支持网络配置

## 常见问题（FAQ）

### 如何使用该镜像？

非常简单，步骤如下：
1. 设置`BOOT`变量指定要安装的[操作系统](#如何选择操作系统)
2. 启动容器并通过浏览器访问[8006端口](http://127.0.0.1:8006/)
3. 在Web界面中使用键盘和鼠标安装操作系统

### 如何选择操作系统？

通过`BOOT`环境变量指定要下载的操作系统，例如：

```yaml
environment:
  BOOT: "mint"
```

支持的操作系统及大小如下表：

| **值**       | **操作系统**       | **大小** |
|--------------|--------------------|----------|
| `alma`       | Alma Linux         | 2.2 GB   |
| `alpine`     | Alpine Linux       | 60 MB    |
| `arch`       | Arch Linux         | 1.2 GB   |
| `cachy`      | CachyOS            | 2.6 GB   |
| `centos`     | CentOS             | 7.0 GB   |
| `debian`     | Debian             | 3.3 GB   |
| `fedora`     | Fedora             | 2.3 GB   |
| `gentoo`     | Gentoo             | 3.6 GB   |
| `kali`       | Kali Linux         | 3.8 GB   |
| `kubuntu`    | Kubuntu            | 4.4 GB   |
| `mint`       | Linux Mint         | 2.8 GB   |
| `manjaro`    | Manjaro            | 4.1 GB   |
| `mx`         | MX Linux           | 2.2 GB   |
| `nixos`      | NixOS              | 2.4 GB   |
| `suse`       | OpenSUSE           | 1.0 GB   |
| `rocky`      | Rocky Linux        | 2.1 GB   |
| `slack`      | Slackware          | 3.7 GB   |
| `tails`      | Tails              | 1.5 GB   |
| `ubuntu`     | Ubuntu Desktop     | 6.0 GB   |
| `ubuntus`    | Ubuntu Server      | 3.0 GB   |
| `xubuntu`    | Xubuntu            | 4.0 GB   |
| `zorin`      | Zorin OS           | 3.8 GB   |

### 如何使用自定义镜像？

有两种方式使用自定义镜像：

1. **通过URL下载**：将`BOOT`变量设置为镜像文件的URL，支持`.iso`、`.img`等格式及压缩文件（会自动解压），例如：
   ```yaml
   environment:
     BOOT: "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso"
   ```

2. **本地文件挂载**：将本地镜像文件挂载到容器中，例如：
   ```yaml
   volumes:
     - ./example.iso:/boot.iso  # 或/boot.img、/boot.qcow2
   ```
   此时`BOOT`变量将被忽略。

### 如何修改存储位置？

通过卷挂载修改存储目录，例如：
```yaml
volumes:
  - ./自定义目录:/storage  # 将./自定义目录替换为宿主机实际目录或命名卷
```

### 如何调整磁盘大小？

通过`DISK_SIZE`环境变量设置磁盘大小（默认64G），例如：
```yaml
environment:
  DISK_SIZE: "128G"  # 支持增大现有磁盘，不会丢失数据
```

> [!TIP]
> 此参数也可用于扩容现有磁盘，且不会导致数据丢失。

### 如何调整CPU或内存？

默认分配2核CPU和2GB内存，可通过以下环境变量调整：
```yaml
environment:
  RAM_SIZE: "8G"   # 内存大小，如"4G"、"8G"
  CPU_CORES: "4"   # CPU核心数，如"2"、"4"
```

### 如何启动ARM64镜像？

使用[qemu-arm](https://github.com/qemus/qemu-arm/)容器运行ARM64架构的镜像。

### 如何启动Windows？

建议使用[dockur/windows](https://github.com/dockur/windows)，该镜像包含安装所需的驱动及更多功能。

### 如何启动macOS？

建议使用[dockur/macos](https://github.com/dockur/macos)，该镜像已配置正确的设置并自动下载安装文件。

### 如何禁用UEFI启动？

默认启用UEFI启动，若操作系统不支持，可通过`BOOT_MODE`变量切换为传统BIOS：
```yaml
environment:
  BOOT_MODE: "legacy"
```

### 如何禁用VirtIO驱动？

默认使用`virtio-scsi`驱动以提高性能，若操作系统无法识别磁盘，可通过`DISK_TYPE`变量修改：
```yaml
environment:
  DISK_TYPE: "blk"  # 或"ide"（兼容性好但速度慢）
```

### 如何验证系统是否支持KVM？

首先检查软件兼容性：

| **产品**         | **Linux** | **Win11** | **Win10** | **macOS** |
|------------------|-----------|-----------|-----------|-----------|
| Docker CLI       | ✅        | ✅        | ❌        | ❌        |
| Docker Desktop   | ❌        | ✅        | ❌        | ❌        |
| Podman CLI       | ✅        | ✅        | ❌        | ❌        |
| Podman Desktop   | ✅        | ✅        | ❌        | ❌        |

在Linux系统中，通过以下命令检查硬件支持：
```bash
sudo apt install cpu-checker
sudo kvm-ok
```

若`kvm-ok`提示不支持KVM，需检查：
-  BIOS中是否启用虚拟化扩展（Intel VT-x或AMD SVM）
-  若在虚拟机中运行，是否启用嵌套虚拟化
-  云服务器通常不支持嵌套虚拟化

### 如何暴露网络端口？

- **桥接网络**：直接在`ports`中添加端口映射，例如`- 2222:22`将虚拟机22端口映射到宿主机2222端口
- **用户模式网络**：需在`USER_PORTS`变量中指定端口，例如`USER_PORTS: "22,80,443"`

### 如何为容器分配独立IP？

创建macvlan网络使容器获得独立IP：
```bash
docker network create -d macvlan \
  --subnet=192.168.0.0/24 \  # 替换为宿主机子网
  --gateway=192.168.0.1 \    # 替换为网关IP
  --ip-range=192.168.0.100/28 \  # IP范围
  -o parent=eth0 vlan        # 替换为宿主机网卡
```

在Compose文件中使用该网络：
```yaml
services:
  qemu:
    ...
    networks:
      vlan:
        ipv4_address: 192.168.0.100  # 分配的IP

networks:
  vlan:
    external: true
```

> [!IMPORTANT]
> 由于macvlan设计限制，容器IP无法从Docker宿主机直接访问，需创建[第二个macvlan](https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/#host-access)作为 workaround。

### 如何让虚拟机从路由器获取IP？

配置macvlan网络后，通过以下设置使虚拟机成为家庭网络的一部分（容器和虚拟机将有独立IP）：
```yaml
environment:
  DHCP: "Y"
devices:
  - /dev/vhost-net
device_cgroup_rules:
  - 'c *:* rwm'
```

### 如何添加多个磁盘？

通过环境变量和卷挂载添加额外磁盘：
```yaml
environment:
  DISK2_SIZE: "32G"  # 第二个磁盘大小
  DISK3_SIZE: "64G"  # 第三个磁盘大小
volumes:
  - ./存储目录2:/storage2  # 第二个磁盘存储目录
  - ./存储目录3:/storage3  # 第三个磁盘存储目录
```

### 如何直通物理磁盘？

通过`devices`挂载物理磁盘或分区：
```yaml
devices:
  - /dev/sdb:/disk1  # 主磁盘
  - /dev/sdc1:/disk2 # 次要磁盘（/disk2及以上）
```

### 如何直通USB设备？

1. 通过`lsusb`命令获取设备的vendorid和productid（如0x1234:0x1234）
2. 在Compose文件中添加：
```yaml
environment:
  ARGUMENTS: "-device usb-host,vendorid=0x1234,productid=0x1234"  # 替换为实际ID
devices:
  - /dev/bus/usb
```

### 如何与宿主机共享文件？

若客户机支持`9pfs`，可通过以下步骤共享文件：
1. 在Compose文件中添加卷挂载：
```yaml
volumes:
  - ./共享目录:/shared  # ./共享目录为宿主机目录
```
2. 在客户机中执行挂载命令：
```shell
mount -t 9p -o trans=virtio shared /mnt/共享目录  # /mnt/共享目录为客户机挂载点
```

### 如何传递自定义QEMU参数？

通过`ARGUMENTS`环境变量传递额外参数：
```yaml
environment:
  ARGUMENTS: "-device usb-tablet"  # 示例：添加USB平板设备
```

若要查看完整QEMU命令行参数，启用调试模式：
```yaml
environment:
  DEBUG: "Y"

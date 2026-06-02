<!-- xuanyuan-docker-images-zh
image: qemux/qemu-arm
source: https://xuanyuan.cloud/zh/r/qemux/qemu-arm
canonical: https://xuanyuan.cloud/zh/r/qemux/qemu-arm
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/qemux/qemu-arm" title="qemux/qemu-arm Docker 镜像中文简介、标签列表与拉取命令">qemux/qemu-arm — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/qemux/qemu-arm" title="qemux/qemu-arm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/qemux/qemu-arm</a></p>

# QEMU ARM64 Docker镜像文档


## 镜像概述与主要用途

QEMU ARM64 Docker镜像是一个基于QEMU的容器化解决方案，用于在Docker环境中运行ARM架构的虚拟机。该镜像支持Raspberry Pi 5等多种ARM设备，可通过容器化方式快速部署和管理ARM虚拟机，简化ARM架构操作系统的运行与测试流程。


## 核心功能与特性

- **基于Web的控制台**：通过浏览器直接控制虚拟机，无需额外客户端工具
- **多磁盘格式支持**：兼容`.iso`、`.img`、`.qcow2`、`.vhd`、`.vhdx`、`.vdi`、`.vmdk`及`.raw`等主流磁盘格式
- **高性能虚拟化**：集成KVM加速、内核模式网络、IO线程等优化选项，实现接近原生的运行速度


## 使用场景与适用范围

- **开发与测试**：在x86/x64主机上模拟ARM环境，进行ARM架构应用的开发调试
- **设备模拟**：模拟Raspberry Pi等ARM设备，验证系统兼容性
- **操作系统体验**：快速部署和测试Alma Linux、Ubuntu、Debian等ARM发行版
- **轻量级虚拟化**：通过Docker简化ARM虚拟机的生命周期管理，适用于CI/CD流程或边缘计算场景


## 使用方法

### 通过Docker Compose部署

```yaml
services:
  qemu:
    container_name: qemu
    image: qemux/qemu-arm
    environment:
      BOOT: "ubuntu"  # 指定预定义操作系统或镜像URL
    devices:
      - /dev/kvm      # 启用KVM加速（需宿主机支持）
      - /dev/net/tun  # 启用网络虚拟化
    cap_add:
      - NET_ADMIN     # 添加网络管理权限
    ports:
      - 8006:8006     # Web控制台端口映射
    volumes:
      - ./qemu:/storage  # 存储虚拟机磁盘与配置
    restart: always
    stop_grace_period: 2m  # 优雅停止等待时间
```


### 通过Docker CLI部署

```bash
docker run -it --rm \
  --name qemu \
  -e "BOOT=ubuntu" \
  -p 8006:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  -v "${PWD:-.}/qemu:/storage" \
  --stop-timeout 120 \  # 对应stop_grace_period
  qemux/qemu-arm
```


### 其他部署方式

- **Kubernetes**：  
  ```shell
  kubectl apply -f https://raw.githubusercontent.com/qemus/qemu-arm/refs/heads/master/kubernetes.yml
  ```

- **GitHub Codespaces**：  
  [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/qemus/qemu-arm)


## 核心功能与特性详情

### 基于Web的控制台

通过8006端口提供Web界面，支持键盘、鼠标直接交互，无需安装额外VNC客户端，简化虚拟机控制流程。


### 多磁盘格式支持

支持多种虚拟磁盘格式及压缩文件（自动解压）：

| 扩展名       | 格式类型       | 支持的压缩格式               |
|--------------|----------------|------------------------------|
| `.img`/`.raw` | 原始磁盘       | `.img.gz`、`.raw.xz`等       |
| `.iso`       | 光盘镜像       | `.iso.zip`、`.iso.bz2`等     |
| `.qcow2`     | QEMU专有格式   | `.qcow2.xz`、`.qcow2.gz`等   |
| `.vmdk`      | VMware格式     | -                            |
| `.vhd`/`.vhdx`| Hyper-V格式    | -                            |
| `.vdi`       | VirtualBox格式 | -                            |


### 高性能虚拟化优化

- **KVM加速**：通过`/dev/kvm`设备直通，利用硬件虚拟化技术提升性能
- **内核模式网络**：支持TUN/TAP设备及`vhost-net`加速，降低网络延迟
- **IO线程**：通过多线程IO处理提升磁盘读写性能
- **资源弹性配置**：可动态调整CPU核心数、内存大小等资源参数


## 详细配置说明

### 环境变量配置

| 变量名        | 用途描述                                                                 | 默认值       | 示例取值                |
|---------------|--------------------------------------------------------------------------|--------------|-------------------------|
| `BOOT`        | 指定启动源，可为预定义操作系统名称或镜像URL                              | -            | `ubuntu`、`https://xxx.iso` |
| `DISK_SIZE`   | 主磁盘大小                                                               | `64G`        | `128G`、`50000M`        |
| `RAM_SIZE`    | 虚拟机内存大小                                                           | `2G`         | `8G`、`4096M`           |
| `CPU_CORES`   | 虚拟机CPU核心数                                                         | `2`          | `4`、`8`                |
| `VGA`         | 显示适配器类型，`virtio-gpu`支持高分辨率（需 guest 驱动支持）            | 帧缓冲模式   | `virtio-gpu`            |
| `DHCP`        | 是否启用虚拟机独立DHCP（需配合macvlan网络）                              | `N`          | `Y`                     |
| `USER_PORTS`  | 用户模式网络下需暴露的端口（逗号分隔）                                   | -            | `22,80,443`             |
| `ARGUMENTS`   | 传递给QEMU的额外命令行参数                                               | -            | `-device usb-tablet`    |
| `DEBUG`       | 是否启用调试模式（输出完整QEMU命令行参数）                               | -            | `Y`                     |


#### 预定义操作系统（`BOOT`变量取值）

| 值           | 操作系统           | 大小   |
|--------------|--------------------|--------|
| `alma`       | Alma Linux         | 1.7 GB |
| `alpine`     | Alpine Linux       | 60 MB  |
| `cachy`      | CachyOS            | 2.6 GB |
| `centos`     | CentOS             | 6.4 GB |
| `debian`     | Debian             | 3.7 GB |
| `fedora`     | Fedora             | 2.9 GB |
| `gentoo`     | Gentoo             | 1.3 GB |
| `kali`       | Kali Linux         | 3.4 GB |
| `nixos`      | NixOS              | 2.4 GB |
| `suse`       | OpenSUSE           | 1.0 GB |
| `rocky`      | Rocky Linux        | 1.9 GB |
| `ubuntu`     | Ubuntu Desktop     | 3.3 GB |
| `ubuntus`    | Ubuntu Server      | 2.7 GB |


### 卷配置

| 卷路径        | 用途描述                                                                 | 示例挂载方式                |
|---------------|--------------------------------------------------------------------------|-----------------------------|
| `/storage`    | 虚拟机主磁盘存储目录（包含系统盘及配置文件）                             | `-v ./qemu:/storage`        |
| `/shared`     | 与宿主机共享的9pfs文件系统（需 guest 执行`mount -t 9p shared /mnt`）      | `-v ./host_dir:/shared`     |
| `/storage2`   | 第二块磁盘存储目录（需配合`DISK2_SIZE`）                                 | `-v ./disk2:/storage2`      |
| `/boot.iso`   | 本地ISO镜像直通（优先级高于`BOOT`变量）                                  | `-v ./local.iso:/boot.iso`  |


### 设备与权限配置

| 配置项                | 用途描述                                                                 | 示例配置                          |
|-----------------------|--------------------------------------------------------------------------|-----------------------------------|
| `--device=/dev/kvm`   | 启用KVM硬件加速（必需）                                                  | 包含在`devices`数组中             |
| `--device=/dev/net/tun` | 启用TUN/TAP网络设备                                                     | 包含在`devices`数组中             |
| `--device=/dev/vhost-net` | 启用vhost-net网络加速（提升网络性能）                                   | 包含在`devices`数组中             |
| `--cap-add=NET_ADMIN` | 添加网络管理权限（创建虚拟网卡、配置IP等）                               | 包含在`cap_add`数组中             |
| `device_cgroup_rules` | 设备访问控制规则（如允许访问所有USB设备）                                | `['c *:* rwm']`                   |
| 磁盘直通              | 将物理磁盘/分区直通给虚拟机（`/disk1`为主盘，`/disk2`为从盘）            | `--device=/dev/sdb:/disk1`        |
| USB设备直通           | 通过厂商ID和产品ID直通USB设备（需配合`/dev/bus/usb`设备）                | `ARGUMENTS: "-device usb-host,vendorid=0x1234,productid=0x5678"` |


### 网络配置

#### 端口映射模式（默认）
通过宿主机端口转发访问虚拟机服务，适用于简单场景：
```yaml
ports:
  - 8006:8006  # Web控制台
  - 2222:22    # SSH服务（guest 22端口映射到宿主机2222）
```


#### macvlan网络模式（独立IP）
为虚拟机分配独立IP（与宿主机同网段），需先创建macvlan网络：
```bash
docker network create -d macvlan \
  --subnet=192.168.0.0/24 \  # 替换为宿主机网段
  --gateway=192.168.0.1 \    # 替换为网关IP
  --ip-range=192.168.0.100/28 \  # 虚拟机IP范围
  -o parent=eth0 vlan  # 替换为宿主机物理网卡
```

-compose配置：
```yaml
networks:
  vlan:
    external: true
services:
  qemu:
    networks:
      vlan:
        ipv4_address: 192.168.0.100  # 分配的静态IP
```


#### 虚拟机独立DHCP（推荐）
使虚拟机直接从路由器获取IP（需macvlan网络）：
```yaml
environment:
  DHCP: "Y"
devices:
  - /dev/vhost-net
device_cgroup_rules:
  - 'c *:* rwm'
```


### 存储与磁盘配置

#### 多磁盘配置
通过环境变量定义从磁盘大小，并挂载对应存储卷：
```yaml
environment:
  DISK2_SIZE: "32G"  # 第二块磁盘大小
  DISK3_SIZE: "64G"  # 第三块磁盘大小
volumes:
  - ./disk2:/storage2  # 第二块磁盘存储目录
  - ./disk3:/storage3  # 第三块磁盘存储目录
```


#### 磁盘扩容
通过修改`DISK_SIZE`为更大值实现无损扩容（仅支持扩容，不支持缩容）：
```yaml
environment:
  DISK_SIZE: "128G"  # 从64G扩容到128G
```


## 使用场景与适用范围

### 开发测试环境
- 模拟ARM架构服务器，测试跨平台应用兼容性
- 快速部署多版本ARM Linux发行版，验证软件运行效果


### 边缘计算场景
- 在x86边缘节点上运行ARM虚拟机，兼容ARM架构的物联网应用
- 利用Docker编排能力，实现ARM虚拟机的批量部署与管理


### 学习与实验
- 无需物理ARM设备，通过Web控制台体验ARM操作系统
- 测试磁盘直通、USB设备转发等虚拟化高级特性


## 常见问题

### 如何验证系统是否支持KVM？
1. 检查软件兼容性：

| 工具链          | Linux | Win11 | Win10 | macOS |
|-----------------|-------|-------|-------|-------|
| Docker CLI      | ✅    | ✅    | ❌    | ❌    |
| Docker Desktop  | ❌    | ✅    | ❌    | ❌    |
| Podman CLI      | ✅    | ✅    | ❌    | ❌    |
| Podman Desktop  | ✅    | ✅    | ❌    | ❌    |

2. 在Linux系统中执行以下命令检查硬件支持：
```bash
sudo apt install cpu-checker
sudo kvm-ok  # 输出 "KVM acceleration can be used" 表示支持
```

3. 若`kvm-ok`报错，需检查：
   - BIOS中是否启用虚拟化扩展（Intel VT-x/AMD SVM）
   - 若运行在虚拟机中，是否启用嵌套虚拟化
   - 云服务器通常不支持KVM（需使用纯QEMU模拟，性能较低）


### 如何引导Windows系统？
Windows ARM版需专用驱动支持，建议使用专用镜像：[dockur/windows-arm](https://github.com/dockur/windows-arm)


### 如何运行x86/x64架构镜像？
本镜像仅支持ARM架构，x86/x64镜像需使用[x86版本QEMU镜像](https://github.com/qemus/qemu/)


### 如何解决启动后屏幕黑屏问题？
- 若使用`VGA: "virtio-gpu"`，黑屏可能是因为guest未加载驱动，需等待系统启动完成
- 换回默认帧缓冲模式（删除`VGA`变量）可解决兼容性问题
- 检查宿主机是否分配足够内存（建议至少2GB）

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/qemux/qemu-arm" title="qemux/qemu-arm Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/qemux/qemu-arm</a></p>

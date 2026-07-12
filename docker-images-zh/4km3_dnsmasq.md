---
image: 4km3/dnsmasq
description: "基于Alpine Linux的轻量级dnsmasq镜像，提供DNS转发与DHCP服务功能。"
source: https://xuanyuan.cloud/zh/r/4km3/dnsmasq
canonical: https://xuanyuan.cloud/zh/r/4km3/dnsmasq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/4km3/dnsmasq" title="4km3/dnsmasq Docker 镜像中文简介、标签列表与拉取命令">4km3/dnsmasq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 4km3/dnsmasq 镜像文档


## 镜像概述和主要用途  
4km3/dnsmasq 是一个基于 Alpine Linux 的轻量级 dnsmasq 容器镜像。dnsmasq 是一款集 DNS 缓存、DNS 转发、DHCP 服务器、TFTP 服务器于一体的轻量级网络服务工具，广泛用于小型网络环境。该镜像结合 Alpine Linux 的精简特性，实现了低资源占用、快速启动和易于部署的网络服务容器，适用于需要轻量级 DNS/DHCP 服务的场景。


## 核心功能和特性  
### 核心功能  
- **DNS 缓存与转发**：缓存 DNS 查询结果以加速解析，并支持转发至上游 DNS 服务器（如公共 DNS 或企业内部 DNS）。  
- **DHCP 服务**：提供 IPv4/IPv6 地址分配、子网掩码、网关、DNS 服务器等 DHCP 选项配置。  
- **静态 IP 分配**：支持基于 MAC 地址的静态 IP 绑定。  
- **TFTP 服务**：可选启用 TFTP 服务，用于网络引导（如 PXE 启动）。  

### 特性  
- **轻量级**：基于 Alpine Linux，镜像体积小（通常 < 10MB），运行时资源占用低（内存 < 5MB）。  
- **可定制**：支持通过配置文件或命令行参数自定义服务行为。  
- **跨平台**：支持 AMD64、ARM 等多种架构（取决于基础镜像支持）。  


## 使用场景和适用范围  
- **家庭/小型办公网络**：作为本地 DNS 缓存和 DHCP 服务器，简化网络设备 IP 管理和域名解析。  
- **开发/测试环境**：提供本地 DNS 解析（如自定义域名映射到开发服务器），避免修改主机 hosts 文件。  
- **嵌入式/边缘设备**：低资源占用特性适合嵌入式系统（如路由器、物联网网关）的网络服务需求。  
- **容器化网络**：在 Kubernetes 或 Docker Compose 环境中，为内部容器提供 DNS 解析或 DHCP 服务。  


## 核心功能和特性  
| 功能/特性                | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| DNS 服务                | 支持 UDP/TCP 53 端口，提供 DNS 缓存、转发、自定义域名解析（hosts 映射）。 |
| DHCP 服务               | 支持 IPv4 DHCP 地址池配置、租期管理、静态 IP 绑定（MAC-IP 映射）。       |
| 轻量级基础              | 基于 Alpine Linux，镜像体积 < 10MB，运行时内存占用通常 < 5MB。          |
| 灵活配置                | 支持通过配置文件（`dnsmasq.conf`）或命令行参数自定义服务行为。           |
| 网络兼容性              | 支持 Docker 桥接网络、host 网络等模式，适配不同网络场景。               |


## 使用方法和配置说明  

### 基础环境要求  
- Docker 1.13+ 或 Docker Compose 1.20+  
- 网络权限：根据需求开放 DNS（UDP 53）、DHCP（UDP 67）、TFTP（UDP 69）等端口。  


### Docker Run 命令示例  
#### 1. 基础 DNS 服务（仅 DNS 转发/缓存）  
```bash
docker run -d \
  --name dnsmasq \
  --restart unless-stopped \
  -p 53:53/udp \  # DNS 服务端口（UDP）
  -p 53:53/tcp \  # DNS 服务端口（TCP，用于长查询）
  -v /path/to/dnsmasq.conf:/etc/dnsmasq.conf \  # 挂载自定义配置文件
  -v /path/to/hosts:/etc/hosts \  # 可选：挂载自定义 hosts 文件（静态域名映射）
  4km3/dnsmasq
```

#### 2. 包含 DHCP 服务（需 Host 网络模式）  
DHCP 服务依赖底层网络栈，建议使用 `--net=host` 模式以确保正确广播和地址分配：  
```bash
docker run -d \
  --name dnsmasq \
  --restart unless-stopped \
  --net=host \  # 使用主机网络，避免端口映射冲突
  --cap-add=NET_ADMIN \  # 授予网络管理权限（DHCP 服务必需）
  -v /path/to/dnsmasq.conf:/etc/dnsmasq.conf \
  -v /path/to/dhcp-hosts:/etc/dnsmasq.d/dhcp-hosts \  # 静态 IP 绑定配置
  4km3/dnsmasq
```


### Docker Compose 配置示例  
创建 `docker-compose.yml`：  
```yaml
version: '3'
services:
  dnsmasq:
    image: docker.xuanyuan.run/4km3/dnsmasq
    container_name: dnsmasq
    restart: unless-stopped
    network_mode: host  # 如需 DHCP 服务，建议使用 host 网络
    cap_add:
      - NET_ADMIN  # DHCP 服务必需
    volumes:
      - ./dnsmasq.conf:/etc/dnsmasq.conf:ro  # 只读挂载配置文件
      - ./dnsmasq.d:/etc/dnsmasq.d:ro  # 可选：额外配置片段目录
      - ./hosts:/etc/hosts:ro  # 可选：自定义 hosts 文件
    # 如需仅启用 DNS 服务（非 host 网络），替换 network_mode 和 ports：
    # ports:
    #   - "53:53/udp"
    #   - "53:53/tcp"
```


## 配置说明  

### 配置文件自定义  
dnsmasq 的核心配置通过 `/etc/dnsmasq.conf` 文件定义，用户需通过数据卷挂载自定义配置文件。默认情况下，镜像可能包含基础配置（如默认 DNS 转发至公共 DNS），但建议用户根据需求自定义。  

#### 配置文件路径  
- 主配置文件：`/etc/dnsmasq.conf`（容器内路径，需通过 `-v` 挂载宿主机文件）  
- 额外配置片段：`/etc/dnsmasq.d/`（容器内目录，可挂载宿主机目录并存放 `.conf` 后缀文件，自动加载）  


### 常用配置示例  
以下为 `dnsmasq.conf` 关键配置项示例，更多参数参考 [dnsmasq 官方文档](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html)：  

#### 1. DNS 转发与缓存  
```conf
# 禁用 resolv.conf 自动加载（避免容器内 DNS 干扰）
no-resolv
# 上游 DNS 服务器（按优先级排序）
server=8.8.8.8  # Google DNS
server=8.8.4.4
# DNS 缓存大小（最多缓存 1000 条记录）
cache-size=1000
# 自定义域名解析（等价于 hosts 文件）
address=/local.dev/192.168.1.100  # 将 local.dev 解析到 192.168.1.100
```

#### 2. DHCP 服务配置  
```conf
# 启用 DHCP 服务
dhcp-range=192.168.1.100,192.168.1.200,255.255.255.0,12h  # IP 范围、子网掩码、租期
dhcp-option=3,192.168.1.1  # 网关地址
dhcp-option=6,8.8.8.8,8.8.4.4  # DNS 服务器地址（分配给客户端）
# 静态 IP 绑定（MAC 地址 -> IP）
dhcp-host=aa:bb:cc:dd:ee:ff,192.168.1.50,my-device  # MAC 为 aa:bb:cc:... 的设备固定分配 192.168.1.50，主机名 my-device
```

#### 3. TFTP 服务配置（可选）  
```conf
# 启用 TFTP 服务
enable-tftp
tftp-root=/tftpboot  # TFTP 根目录（需挂载宿主机目录至容器 /tftpboot）
```


## 注意事项  
1. **网络模式选择**：DHCP 服务依赖广播包处理，推荐使用 `--net=host` 模式；仅需 DNS 服务时可使用桥接网络并映射 53 端口。  
2. **权限要求**：DHCP 服务需 `NET_ADMIN` 权限（`--cap-add=NET_ADMIN`），否则无法监听 DHCP 端口（67/udp）。  
3. **配置文件权限**：挂载的配置文件需确保容器内用户（通常为 `root`）有读取权限，建议宿主机文件权限设为 `644`。  
4. **日志查看**：默认日志输出至容器标准输出，可通过 `docker logs dnsmasq` 查看；如需持久化日志，可配置 `log-facility=/var/log/dnsmasq.log` 并挂载日志目录。  


## 参考链接  
- dnsmasq 官方文档：http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html  
- 镜像源码仓库：https://github.com/4km3/docker-dnsmasq

---
image: netbootxyz/netbootxyz
description: "netboot.xyz官方Docker镜像便于轻松搭建netboot.xyz本地实例。"
source: https://xuanyuan.cloud/zh/r/netbootxyz/netbootxyz
canonical: https://xuanyuan.cloud/zh/r/netbootxyz/netbootxyz
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/netbootxyz/netbootxyz" title="netbootxyz/netbootxyz Docker 镜像中文简介、标签列表与拉取命令">netbootxyz/netbootxyz 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# [netbootxyz/netbootxyz](https://github.com/netbootxyz/docker-netbootxyz)

[![发布状态](https://github.com/netbootxyz/docker-netbootxyz/actions/workflows/release.yml/badge.svg)](https://github.com/netbootxyz/docker-netbootxyz/actions/workflows/release.yml)
[![Discord](https://img.shields.io/discord/425186187368595466)](https://discord.gg/An6PA2a)
![GitHub标签（按日期最新）](https://img.shields.io/github/v/tag/netbootxyz/docker-netbootxyz)
[![Docker拉取次数](https://img.shields.io/docker/pulls/netbootxyz/netbootxyz)](https://hub.docker.com/r/netbootxyz/netbootxyz)

## 镜像概述

[netboot.xyz Docker镜像](https://github.com/netbootxyz/docker-netbootxyz)允许您轻松搭建本地netboot.xyz实例。该容器是基于node.js编写的轻量辅助应用，提供简单的Web界面用于实时编辑菜单、获取netboot.xyz的最新菜单版本，并能将Github上的可下载资产镜像到本地机器，以加快资产启动速度。

![netboot.xyz webapp](https://netbootxyz/assets/images/netboot.xyz-webapp-103ba6177c9a8307f737627825f994c9.png)

该工具适用于开发和测试自定义菜单变更。对于无光驱且无法从USB启动的机器，本地netboot服务器提供了一种安装操作系统的方式。如果您希望开始使用netboot.xyz但不想管理iPXE菜单，建议使用启动介质而非搭建容器。

容器基于Alpine Linux构建，包含以下组件：

* netboot.xyz [webapp](https://github.com/netbootxyz/webapp)
* Nginx（用于托管容器内的本地资产）
* tftp-hpa（TFTP服务器）
* syslog（提供TFTP活动日志）

容器内服务由[supervisord](http://supervisord.org/)管理，支持ARM架构和x86-64架构主机运行。

## 核心功能与特性

* **本地netboot.xyz实例**：快速部署本地netboot.xyz服务，无需复杂配置
* **Web配置界面**：通过Web界面实时编辑菜单、管理配置
* **资产本地镜像**：将Github上的启动资产缓存到本地，提升启动速度
* **多组件集成**：包含Web应用、Nginx、TFTP服务器和日志服务
* **跨架构支持**：兼容x86-64和ARM架构主机
* **灵活配置**：支持自定义端口、指定菜单版本、TFTP服务器参数等

## 使用场景与适用范围

* **开发测试**：自定义netboot.xyz菜单的开发与测试环境
* **无介质启动**：为无光驱、不支持USB启动的设备提供网络启动安装系统的途径
* **本地网络部署**：在局域网内搭建集中化的网络启动服务
* **资产加速**：通过本地缓存资产，解决远程下载速度慢的问题

> 注意：若您无需管理iPXE菜单，仅需使用netboot.xyz基础功能，建议直接使用官方启动介质而非容器。

## 使用方法与配置说明

### 前提条件

该镜像需要现有DHCP服务器运行，容器本身不包含DHCP服务。需在DHCP配置中指定`next-server`和启动文件名，引导客户端访问容器的TFTP服务。DHCP服务器需配置静态IP。

### 安装Docker

Debian/Ubuntu系统安装Docker：

```shell
sudo apt install docker.io
```

### 获取镜像

#### 从Github Container Registry拉取

```shell
docker pull ***-ghcr.xuanyuan.run/netbootxyz/netbootxyz
```

#### 从Docker Hub拉取

```shell
docker pull docker.xuanyuan.run/netbootxyz/netbootxyz
```

### 启动容器

#### 使用docker-cli启动

```shell
docker run -d \
  --name=netbootxyz \
  -e MENU_VERSION=2.0.76             `# 可选，指定菜单版本` \
  -e NGINX_PORT=80                   `# 可选，Nginx服务端口` \
  -e WEB_APP_PORT=3000               `# 可选，Web应用端口` \
  -p 3000:3000                       `# Web配置界面端口，目标端口需与WEB_APP_PORT一致` \
  -p 69:69/udp                       `# TFTP服务端口（UDP）` \
  -p 8080:80                         `# 可选，Nginx服务端口映射，目标需与NGINX_PORT一致` \
  -v /local/path/to/config:/config   `# 可选，配置文件持久化目录` \
  -v /local/path/to/assets:/assets   `# 可选，资产文件持久化目录` \
  --restart unless-stopped \
  ghcr.io/netbootxyz/netbootxyz
```

#### 使用docker-cli更新镜像

```shell
docker pull ***-ghcr.xuanyuan.run/netbootxyz/netbootxyz   # 拉取最新镜像
docker stop netbootxyz                      # 停止现有容器
docker rm netbootxyz                        # 删除旧容器
docker run -d ...                           # 使用原参数启动新容器
```

> 若使用相同的挂载目录，配置将保留；如需重置，可删除挂载目录后重启容器。

#### 使用docker-compose启动

1. 复制[docker-compose.yml.example](https://github.com/netbootxyz/docker-netbootxyz/blob/master/docker-compose.yml.example)为`docker-compose.yml`
2. 根据需求编辑配置文件
3. 启动容器：

```shell
docker compose up -d netbootxyz
```

#### 使用docker-compose更新镜像

```shell
docker compose pull netbootxyz     # 拉取最新镜像
docker compose up -d netbootxyz    # 后台重启容器
```

### 访问容器服务

* **Web配置界面**：容器启动后，通过`http://localhost:3000`访问（或自定义的`WEB_APP_PORT`端口）
* **本地资产服务**：通过`http://localhost:8080`访问本地缓存的资产（或自定义的`NGINX_PORT`映射端口）

### 本地镜像配置

如需从本地镜像拉取Live Images，需修改`boot.cfg`文件，将默认`live_endpoint`从`https://github.com/netbootxyz`修改为本地服务IP或域名，例如`http://192.168.0.50:8080`。配置后，资产下载将重定向到本地服务，通过"本地资产"菜单下载的文件会缓存到本地，提升后续启动速度。

## 参数说明

### 端口映射

| 参数         | 功能描述                     |
|--------------|------------------------------|
| `-p 3000`    | Web配置界面端口              |
| `-p 69/udp`  | TFTP服务端口（UDP协议）      |
| `-p 80`      | Nginx资产服务端口            |

### 环境变量

| 环境变量                  | 功能描述                                                                 |
|---------------------------|--------------------------------------------------------------------------|
| `WEB_APP_PORT=3000`       | 指定Web配置界面监听端口                                                 |
| `NGINX_PORT=80`           | 指定Nginx服务监听端口                                                    |
| `MENU_VERSION=2.0.76`     | 指定netboot.xyz引导文件版本（未设置则自动拉取最新版）                     |
| `TFTPD_OPTS='--tftp-single-port'` | TFTP服务器参数（示例：使TFTP通过端口69发送所有数据）                  |

### 数据卷挂载

| 参数           | 功能描述                                   |
|----------------|--------------------------------------------|
| `-v /config`   | 存储引导菜单文件和Web应用配置（持久化目录） |
| `-v /assets`   | 存储netboot.xyz启动资产（持久化目录）      |

## DHCP服务器配置

容器依赖DHCP服务器引导客户端访问TFTP服务。需在现有DHCP服务器中配置`next-server`（TFTP服务器IP）和启动文件名，以下是常见DHCP服务器配置示例。

### isc-dhcp-server配置（Debian/Ubuntu）

#### 安装DHCP服务器

```shell
sudo apt install isc-dhcp-server
```

#### 配置监听接口

编辑`/etc/default/isc-dhcp-server`，设置DHCP服务监听的网络接口：

```shell
INTERFACESv4="eth0"  # 替换为实际网络接口
```

#### 配置DHCP服务

编辑`/etc/dhcp/dhcpd.conf`，添加如下配置（根据实际网络调整）：

```shell
option arch code 93 = unsigned integer 16;

subnet 192.168.0.0 netmask 255.255.255.0 {
  range 192.168.0.34 192.168.0.254;       # 调整为实际网段的IP范围
  next-server 192.168.0.33;               # 替换为容器所在主机的IP
  option subnet-mask 255.255.255.0;
  option routers 192.168.0.1;             # 替换为网关IP
  option broadcast-address 192.168.0.255;
  option domain-name "mynetwork.lan";     # 可选，域名
  option domain-name-servers 1.1.1.1;     # 可选，DNS服务器
  if exists user-class and ( option user-class = "iPXE" ) {
    filename "http://boot.netboot.xyz/menu.ipxe";
  } elsif option arch = encode-int ( 16, 16 ) {
    filename "http://boot.netboot.xyz/ipxe/netboot.xyz.efi";
    option vendor-class-identifier "HTTPClient";
  } elsif option arch = 00:07 {
    filename "netboot.xyz.efi";          # UEFI客户端启动文件
  } else {
    filename "netboot.xyz.kpxe";         # 传统BIOS客户端启动文件
  }
}
```

#### 启动并设置开机自启

```shell
sudo systemctl start isc-dhcp-server    # 启动服务
sudo systemctl enable isc-dhcp-server   # 设置开机自启
```

## netboot.xyz启动文件类型

容器内置以下启动文件，可在DHCP配置中指定为引导文件：

| 启动文件名                          | 描述                                                 |
|-------------------------------------|------------------------------------------------------|
| `netboot.xyz.kpxe`                  | 传统BIOS启动镜像，使用内置iPXE网卡驱动                |
| `netboot.xyz-undionly.kpxe`         | 传统BIOS启动镜像（兼容性模式），解决部分网卡驱动问题  |
| `netboot.xyz.efi`                   | UEFI启动镜像，使用内置UEFI网卡驱动                    |
| `netboot.xyz-snp.efi`               | UEFI SNP模式镜像，尝试启动所有网络设备                |
| `netboot.xyz-snponly.efi`           | UEFI SNP模式镜像，仅从链式加载的设备启动              |
| `netboot.xyz-arm64.efi`             | ARM64架构UEFI启动镜像，使用内置网卡驱动               |
| `netboot.xyz-arm64-snp.efi`         | ARM64架构UEFI SNP模式镜像，尝试启动所有网络设备       |
| `netboot.xyz-arm64-snponly.efi`     | ARM64架构UEFI SNP模式镜像，仅从链式加载的设备启动     |
| `netboot.xyz-rpi4-snp.efi`          | 树莓派4专用UEFI SNP模式镜像，尝试启动所有网络设备     |

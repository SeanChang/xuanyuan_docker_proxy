---
image: pihole/pihole
description: "Pi-hole官方Docker镜像，通过您自己的Linux硬件实现网络级广告拦截，支持DNS服务、广告过滤及Web管理界面。"
source: https://xuanyuan.cloud/zh/r/pihole/pihole
canonical: https://xuanyuan.cloud/zh/r/pihole/pihole
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pihole/pihole" title="pihole/pihole Docker 镜像中文简介、标签列表与拉取命令">pihole/pihole 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker Pi-hole

[![构建状态](https://github.com/pi-hole/docker-pi-hole/workflows/Test%20&%20Build/badge.svg)](https://github.com/pi-hole/docker-pi-hole/actions?query=workflow%3A%22Test+%26+Build%22) [![Docker Stars](https://img.shields.io/docker/stars/pihole/pihole.svg?maxAge=604800)](https://store.docker.com/community/images/pihole/pihole) [![Docker Pulls](https://img.shields.io/docker/pulls/pihole/pihole.svg?maxAge=604800)](https://store.docker.com/community/images/pihole/pihole)

<div align="center">
  <a href="https://pi-hole.net/">
    <img src="https://pi-hole.github.io/graphics/Vortex/vortex_with_text.svg" width="144" height="256" alt="Pi-hole官网">
  </a>
  <br>
  <strong>通过您自己的Linux硬件实现网络级广告拦截</strong>
  <br>
  <br>
  <div align="center">
    <a href="https://pi-hole.net/">Pi-hole官网</a> |
    <a href="https://docs.pi-hole.net/">文档</a> |
    <a href="https://discourse.pi-hole.net/">论坛</a> |
    <a href="https://pi-hole.net/donate">捐赠</a>
  </div>
  <br>
  <br>
</div>

## 升级说明

> [!CAUTION]
>
> ## !!! 最新版本包含重大变更
>
> **Pi-hole v6已完全重新设计，包含许多重大变更。**
>
> 环境变量名称已更改，脚本位置可能已更改。
>
> 如果您使用卷来持久化配置，请小心。<br>将任何`v5`镜像（`2024.07.0`及更早版本）替换为`v6`镜像将导致配置文件更新。**这些更改不可逆**。
>
> 请在继续之前仔细阅读README。
>
> https://docs.pi-hole.net/docker/

---

> [!NOTE]
> **使用Watchtower？**<br>请参阅本README底部的[关于Watchtower的说明](#关于watchtower的说明)。

> [!TIP]
> 一些用户报告在`2022.04`及更高版本上使用`--privileged`标志时出现问题。<br>简而言之，不要使用该模式，而是[明确指定允许的capabilities](https://github.com/pi-hole/docker-pi-hole#note-on-capabilities)（如果需要）。

## 快速开始

使用[Docker Compose](https://docs.docker.com/compose/install/)：

1. 复制以下docker compose示例并根据需要更新：

```yml
# 更多信息请访问 https://github.com/pi-hole/docker-pi-hole/ 和 https://docs.pi-hole.net/
services:
  pihole:
    container_name: pihole
    image: docker.xuanyuan.run/pihole/pihole:latest
    ports:
      # DNS端口
      - "53:53/tcp"
      - "53:53/udp"
      # 默认HTTP端口
      - "80:80/tcp"
      # 默认HTTPS端口。FTL将生成自签名证书
      - "443:443/tcp"
      # 如果将Pi-hole用作DHCP服务器，请取消以下注释
      #- "67:67/udp"
    environment:
      # 设置适合您位置的时区（https://en.wikipedia.org/wiki/List_of_tz_database_time_zones），例如：
      TZ: 'Asia/Shanghai'
      # 设置访问Web界面的密码。不设置将随机分配密码
      FTLCONF_webserver_api_password: 'correct horse battery staple'
    # 卷用于在容器升级之间持久化数据
    volumes:
      # 用于持久化Pi-hole的数据库和通用配置文件
      - './etc-pihole:/etc/pihole'
      # 如果您有要持久化的自定义dnsmasq配置文件，请取消以下注释。大多数使用Pi-hole v6全新开始的用户不需要。如果您从v5升级并且之前使用过此目录，应在首次启动v6容器时启用它以完成迁移，之后可移除
      #- './etc-dnsmasq.d:/etc/dnsmasq.d'
    cap_add:
      # 参见 https://github.com/pi-hole/docker-pi-hole#note-on-capabilities
      # 如果将Pi-hole用作DHCP服务器则需要，否则不需要
      - NET_ADMIN
    restart: unless-stopped
```

2. 运行`docker compose up -d`构建并启动pi-hole（旧系统可能需要使用`docker-compose`命令）。
3. 如果使用Docker默认的`bridge`网络模式，需设置环境变量`FTLCONF_dns_listeningMode`为`all`。

> [!NOTE]
> 建议使用卷来持久化数据，以便在容器重新创建时保留配置。

### 广告列表自动更新

容器中内置了`cron`，将每周日凌晨自动获取最新的广告列表并刷新日志。

## 在Docker Pi-hole中运行DHCP

有多种方法可以在Docker Pi-hole容器中运行DHCP，但它稍复杂且没有通用解决方案。

DHCP和Docker的多种网络模式在官方文档中有详细说明：[Docker DHCP和网络模式](https://docs.pi-hole.net/docker/DHCP/)。

## 配置

建议使用环境变量配置Pi-hole docker容器（详情如下），但如果您持久化了`/etc/pihole`目录，也可以通过Web界面或直接编辑`pihole.toml`进行设置。

> [!WARNING]
> 通过环境变量设置的配置将成为**只读**，这意味着您无法通过Web界面或CLI更改它们。这是为了确保配置的“单一来源”。<br>如果之后取消设置环境变量，FTL将恢复为该设置的默认值。

### Web界面密码

要设置Web界面的特定密码，请使用环境变量`FTLCONF_webserver_api_password`。

如果未检测到此变量且您尚未通过容器内的`pihole setpassword`/`pihole-FTL --config webserver.api.password`设置密码，则启动时会分配随机密码，并打印到日志中。运行`docker logs pihole | grep random password`可找到该密码。

要显式设置无密码，设置`FTLCONF_webserver_api_password: ''`。

### 推荐环境变量

| 变量 | 默认值 | 取值 | 描述 |
| -------- | ------- | ----- | ---------- |
| `TZ` | UTC | `<时区>` | 设置您的[时区](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)，确保日志在本地午夜而非UTC午夜轮换。|
| `FTLCONF_webserver_api_password` | 随机 | `<管理员密码>` | <http://pi.hole/admin>密码。<br>运行`docker logs pihole \| grep random`可找到随机密码。|
| `FTLCONF_dns_upstreams` | `8.8.8.8;8.8.4.4` | 分号分隔的IP列表 | Pi-hole转发查询的上游DNS服务器，用分号分隔。<br><br>支持非标准端口：`#[端口号]`，例如`127.0.0.1#5053;8.8.8.8;8.8.4.4`。<br><br>支持[Docker服务名称和链接](https://docs.docker.com/compose/networking/)代替IP，例如`upstream0,upstream1`，其中`upstream0`和`upstream1`是Docker服务名称或链接。<br><br>**注意：** 此环境变量的存在意味着它是上游DNS的唯一管理方式。通过Web界面添加的上游DNS将在容器重启/重新创建时被覆盖。|

### 可选环境变量

| 变量 | 默认值 | 取值 | 描述 |
| -------- | ------- | ----- | ---------- |
| `TAIL_FTL_LOG` | `1` | `<0\|1>` | 是否在运行容器时输出FTL日志。设置为0可禁用。|
| `FTLCONF_[SETTING]` | 未设置 | 参考文档 | 自定义pihole.toml，设置详见[API文档](https://docs.pi-hole.net/api)。<br><br>将`.`替换为`_`，例如`dns.dnssec=true`对应`FTLCONF_dns_dnssec: 'true'`。<br>数组类型配置用`;`分隔。|
| `PIHOLE_UID` | `1000` | 数字 | 覆盖镜像默认的pihole用户ID以匹配主机用户ID。<br>**重要**：ID不能在容器内已被使用！|
| `PIHOLE_GID` | `1000` | 数字 | 覆盖镜像默认的pihole组ID以匹配主机组ID。<br>**重要**：ID不能在容器内已被使用！|

### 高级环境变量

| 变量 | 默认值 | 取值 | 描述 |
| -------- | ------- | ----- | ---------- |
| `FTL_CMD` | `no-daemon` | `no-daemon -- <dnsmasq选项>` | 自定义dnsmasq启动选项。例如`no-daemon -- --dns-forward-max 300`可增加高负载场景下的最大并发DNS查询数。|
| `DNSMASQ_USER` | 未设置 | `<pihole\|root>` | 允许更改FTLDNS运行的用户。默认：`pihole`，部分系统（如Synology NAS）可能需要更改为`root`。<br><br>（参见 [#963](https://github.com/pi-hole/docker-pi-hole/issues/963)）|
| `ADDITIONAL_PACKAGES`| 未设置 | 空格分隔的APK包列表 | 高级用法。主要用于开发目的，方便在容器内添加调试所需的额外工具。|

以下是docker-compose/docker run的其他参数说明：

| Docker参数 | 描述 |
| ---------------- | ----------- |
| `-p <port>:<port>` **推荐** | 暴露端口（53、80、443、67），Pi-hole的HTTP、HTTPS和DNS服务所需的最小端口集。|
| `--restart=unless-stopped`<br/> **推荐** | 在启动或崩溃时自动重启Pi-hole。|
| `-v $(pwd)/etc-pihole:/etc/pihole`<br/> **推荐** | Pi-hole配置文件的卷，帮助在docker镜像更新时保留更改。|
| `--net=host`<br/> _可选_ | `-p <port>:<port>`参数的替代方案（不能与`-p`同时使用），如果不运行其他Web应用。DHCP在`--net=host`模式下运行最佳，否则路由器必须支持dhcp-relay设置。|
| `--cap-add=NET_ADMIN`<br/> _推荐_ | DHCP常用的capability，详见下文[关于Capabilities的说明](#关于capabilities的说明)了解其他capabilities。|
| `--dns=n.n.n.n`<br/> _可选_ | 显式设置容器的DNS服务器。**不建议**设置为`localhost`/`127.0.0.1`。|
| `--env-file .env` <br/> _可选_ | 存储docker环境变量的文件，替代`-e key=value`设置。仅为方便。|

## 提示和技巧

- 测试是否正常工作的好方法是访问：[http://pi.hole/admin/](http://pi.hole/admin/)
- 端口冲突？停止服务器上现有的DNS/Web服务。
  - 不要忘记阻止这些服务在重启后自动启动。
  - Ubuntu用户可参考下文获取详细信息。
- Docker默认的`bridge`网络模式将容器与主机网络隔离。这是更安全的设置，但需要将Pi-hole的DNS选项“接口监听行为”设置为“监听所有接口，允许所有来源”。
- 如果使用基于Red Hat的发行版且SELinux策略为Enforcing，需在卷行添加`:z`。

### 在Ubuntu或Fedora上安装

现代Ubuntu（17.10+）和Fedora（33+）版本包含[`systemd-resolved`](http://manpages.ubuntu.com/manpages/bionic/man8/systemd-resolved.service.8.html)，默认配置为实现缓存DNS存根解析器。这会阻止pi-hole监听53端口。

需通过以下命令禁用存根解析器：`sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf`。

这不会更改指向存根解析器的nameserver设置，可能导致DNS解析失败。需将`/etc/resolv.conf`符号链接指向`/run/systemd/resolve/resolv.conf`，它会自动更新以遵循系统的[`netplan`](https://netplan.io/)：
`sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'`。

修改后，需重启systemd-resolved：`systemctl restart systemd-resolved`。

安装pi-hole后，需配置客户端使用它（[详见](https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245)）。如果使用上述符号链接，docker主机将使用DHCP提供的nameserver或静态设置。如需显式设置docker主机的nameserver，可编辑`/etc/netplan`下的netplan文件，然后运行`sudo netplan apply`。

netplan示例：

```yaml
network:
    ethernets:
        ens160:
            dhcp4: true
            dhcp4-overrides:
                use-dns: false
            nameservers:
                addresses: [127.0.0.1]
    version: 2
```

注意，也可完全禁用`systemd-resolved`，但这可能导致vpn中的名称解析问题（[参见bug报告](https://bugs.launchpad.net/network-manager/+bug/1624317)）。<br>它还会禁用netplan功能，因为systemd-resolved是默认的渲染器（[参见`man netplan`](http://manpages.ubuntu.com/manpages/bionic/man5/netplan.5.html#description)）。<br>如果选择禁用该服务，需手动设置nameserver，例如创建新的`/etc/resolv.conf`。

旧版Ubuntu（约17.04）用户需要禁用dnsmasq。

## 在Dokku上安装

[@Rikj000](https://github.com/Rikj000/)编写了在Dokku上安装Pi-hole的指南：[在Dokku上安装Pi-hole](https://github.com/Rikj000/Pihole-Dokku-Installation)。

## Docker标签和版本控制

主要docker标签说明如下表。[点击查看完整标签列表](https://hub.docker.com/r/pihole/pihole/tags)。参见[GitHub发布说明](https://github.com/pi-hole/docker-pi-hole/releases)了解每个版本包含的Pi-hole Core、Web和FTL的具体版本。

基于日期的标签（包括递增的“Patch”版本）与语义化版本无关，仅用于区分新版本和旧版本。

发布说明将始终包含容器变更的详细信息，包括核心Pi-hole组件的变更。

| 标签 | 描述 |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| `latest` | 始终为最新发布版本 |
| `2022.04.0` | 基于日期的发布 |
| `2022.04.1` | 当月第二次发布 |
| `development` | 类似`latest`，但对应开发分支（偶尔推送） |
| `*beta` | 即将发布版本的早期测试版 - 可能不稳定 |
| `nightly` | 类似`development`，但每晚推送并拉取Pi-hole核心组件（Pi-hole、web、FTL）的最新`development`分支代码 |

## 升级、持久化和自定义

标准的Pi-hole自定义功能适用于此docker镜像，但具有docker特色，例如使用docker卷挂载将主机存储的配置文件映射到容器默认配置。但应避免将这些配置文件挂载为只读。卷对于在移除Pi-hole容器（典型的docker升级模式）时持久化配置也很重要。

### 升级/重新配置

不要尝试升级（`pihole -up`）或重新配置（`pihole -r`）。

新版本发布时，应通过替换旧容器为新镜像来升级，这是“docker方式”。长期运行的docker容器不符合docker的设计理念，因为docker旨在可移植和可重现，因此应经常重新创建容器！

0. 阅读此Docker版本和Pi-hole版本的发布说明
    - 这将帮助您避免因升级已知问题或新要求的参数/变量导致的常见问题
    - 我们也会尝试将常见问题修复放在本README顶部
1. 下载最新版本镜像：`docker pull docker.xuanyuan.run/pihole/pihole`
2. 删除旧容器：`docker rm -f pihole`
    - **警告：** 删除pihole容器后，在步骤3完成前可能无法使用DNS；**先执行`docker pull`再执行`docker rm -f`** 以避免DNS中断。
    - 如果关心数据（日志/自定义），确保已进行卷映射，

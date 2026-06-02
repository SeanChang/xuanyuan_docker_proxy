<!-- xuanyuan-docker-images-zh
image: adguard/adguardhome
source: https://xuanyuan.cloud/zh/r/adguard/adguardhome
canonical: https://xuanyuan.cloud/zh/r/adguard/adguardhome
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/adguard/adguardhome" title="adguard/adguardhome Docker 镜像中文简介、标签列表与拉取命令">adguard/adguardhome — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/adguard/adguardhome" title="adguard/adguardhome Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/adguard/adguardhome</a></p>

# AdGuard Home - Docker部署指南


## 简介

AdGuard Home 是一款网络级广告和追踪器拦截工具。部署后，它能覆盖你家中所有设备，无需在每个设备上单独安装客户端。更多信息可查看其[官方 GitHub 仓库]([])。


## 快速开始

### 拉取 Docker 镜像
执行以下命令拉取最新稳定版镜像：
```sh
docker pull adguard/adguardhome
```

### 创建持久化目录
镜像需要两个持久化目录来保存数据和配置：
- **数据目录**：用于存储运行数据，建议放在主机合适的位置，例如 `/my/own/workdir`
- **配置目录**：用于存储配置文件，建议放在主机合适的位置，例如 `/my/own/confdir`

### 创建并运行容器
使用以下命令创建容器并启动 AdGuard Home（**记得替换成你自己的目录路径**）：
```sh
docker run --name adguardhome \
    --restart unless-stopped \
    -v /my/own/workdir:/opt/adguardhome/work \
    -v /my/own/confdir:/opt/adguardhome/conf \
    -p 53:53/tcp -p 53:53/udp \
    -p 67:67/udp -p 68:68/udp \
    -p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp \
    -p 853:853/tcp \
    -p 784:784/udp -p 853:853/udp -p 8853:8853/udp \
    -p 5443:5443/tcp -p 5443:5443/udp \
    -d adguard/adguardhome
```

容器启动后，打开浏览器访问 `[] 即可进入管理界面。

**端口说明**：
- `53/tcp/udp`：DNS 基础端口
- `67/udp、68/tcp/udp`：DHCP 服务（如需使用才映射）
- `80、443、3000`：管理面板及 HTTPS/DNS-over-HTTPS
- `853/tcp`：DNS-over-TLS
- `784、853、8853/udp`：DNS-over-QUIC（可只保留需要的）
- `5443/tcp/udp`：DNSCrypt 服务

### 容器控制命令
- 启动：`docker start adguardhome`
- 停止：`docker stop adguardhome`
- 删除：`docker rm adguardhome`


## 更新到新版本

1. 拉取最新镜像：
   ```sh
   docker pull adguard/adguardhome
   ```

2. 停止并删除当前容器（数据会保留在持久化目录）：
   ```sh
   docker stop adguardhome
   docker rm adguardhome
   ```

3. 用新镜像重新创建容器（使用之前的启动命令即可）。


## 运行开发构建版本

如需体验测试版，将镜像标签改为 `edge`（开发版）或 `beta`（测试版）。例如拉取开发版：
```sh
docker pull adguard/adguardhome:edge
```
其他命令（如创建容器）中的镜像名也需对应修改。


## 额外配置

首次运行后，配置目录会生成 `AdGuardHome.yaml` 文件，包含默认设置。**需在容器停止时修改该文件**，否则运行中的程序会覆盖修改。配置参数说明可参考 [官方文档]([])。


## DHCP 服务器

如需使用 AdGuard Home 的 DHCP 功能，创建容器时需添加 `--network host` 参数（使用主机网络）：
```sh
docker run --name adguardhome --network host ...（其他参数不变）
```
此时无需再用 `-p` 映射端口。注意：该参数**仅支持 Linux 主机**，Mac/Windows 不适用。


## 解决 resolved 守护进程冲突

若系统运行 `resolved` 守护进程，会占用 `127.0.0.53:53` 导致端口冲突。解决步骤：

1. 创建 resolved 配置文件：  
   新建 `/etc/systemd/resolved.conf.d/adguardhome.conf`（目录不存在则创建），添加：
   ```ini
   [Resolve]
   DNS=127.0.0.1  # 指向 AdGuard Home
   DNSStubListener=no  # 关闭 DNS 监听
   ```

2. 更新 resolv.conf 链接：
   ```sh
   mv /etc/resolv.conf /etc/resolv.conf.backup
   ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
   ```

3. 重启 resolved 服务：
   ```sh
   systemctl reload-or-restart systemd-resolved
   ```

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/adguard/adguardhome" title="adguard/adguardhome Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/adguard/adguardhome</a></p>

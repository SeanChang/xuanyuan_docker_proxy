---
id: 138
title: AdguardHome Docker 容器化部署指南
slug: adguardhome-docker
summary: ADGUARDHOME是一款网络级广告和跟踪器拦截DNS服务器，作为一款开源的隐私保护工具，它能够在网络层面为所有设备提供广告过滤和隐私保护功能，无需在每个设备上单独安装客户端软件。通过Docker容器化部署ADGUARDHOME，可以实现快速部署、环境隔离和版本管理，适用于家庭网络、小型企业网络等多种场景。
category: Docker,adguardhome
tags: adguardhome,docker,部署教程
image_name: adguard/adguardhome
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-adguardhome.png"
status: published
created_at: "2025-12-11 13:30:30"
updated_at: "2025-12-12 01:52:24"
---

# AdguardHome Docker 容器化部署指南

> ADGUARDHOME是一款网络级广告和跟踪器拦截DNS服务器，作为一款开源的隐私保护工具，它能够在网络层面为所有设备提供广告过滤和隐私保护功能，无需在每个设备上单独安装客户端软件。通过Docker容器化部署ADGUARDHOME，可以实现快速部署、环境隔离和版本管理，适用于家庭网络、小型企业网络等多种场景。

## 概述

ADGUARDHOME是一款网络级广告和跟踪器拦截DNS服务器，作为一款开源的隐私保护工具，它能够在网络层面为所有设备提供广告过滤和隐私保护功能，无需在每个设备上单独安装客户端软件。通过Docker容器化部署ADGUARDHOME，可以实现快速部署、环境隔离和版本管理，适用于家庭网络、小型企业网络等多种场景。

本文档将详细介绍ADGUARDHOME的Docker容器化部署流程，包括环境准备、镜像拉取、容器部署、功能测试及生产环境优化建议，旨在为用户提供一套可靠、可复现的部署方案。


## 环境准备

### Docker环境安装

ADGUARDHOME基于Docker容器运行，首先需要在目标服务器上安装Docker环境。推荐使用以下一键安装脚本，该脚本会自动配置Docker环境并优化相关参数：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，可通过以下命令验证Docker是否正常运行：

```bash
docker --version
docker info
```


## 镜像准备

### 拉取ADGUARDHOME镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的ADGUARDHOME镜像：

```bash
docker pull xxx.xuanyuan.run/adguard/adguardhome:latest
```

如需指定其他版本，可访问[ADGUARDHOME镜像标签列表](https://xuanyuan.cloud/r/adguard/adguardhome/tags)查看可用标签，并替换命令中的`latest`标签。


## 容器部署

### 准备数据持久化目录

ADGUARDHOME需要持久化存储配置文件和运行数据，建议在主机上创建专用目录：

```bash
# 创建配置文件目录
mkdir -p /data/adguardhome/conf
# 创建数据存储目录
mkdir -p /data/adguardhome/work
# 设置目录权限
chmod -R 755 /data/adguardhome
```

### 启动ADGUARDHOME容器

使用以下命令启动ADGUARDHOME容器，根据实际需求调整端口映射和参数：

```bash
docker run -d \
  --name adguardhome \
  --restart unless-stopped \
  -v /data/adguardhome/conf:/opt/adguardhome/conf \
  -v /data/adguardhome/work:/opt/adguardhome/work \
  -p 53:53/tcp -p 53:53/udp \  # DNS服务端口
  -p 3000:3000/tcp \            # 初始配置界面端口
  -p 80:80/tcp \                # HTTP服务端口（用于DNS-over-HTTPS等）
  -p 443:443/tcp -p 443:443/udp \  # HTTPS服务端口
  adguard/adguardhome:latest
```

**参数说明**：
- `-d`：后台运行容器
- `--name adguardhome`：指定容器名称为adguardhome
- `--restart unless-stopped`：容器退出时自动重启（除非手动停止）
- `-v`：挂载主机目录到容器内，实现数据持久化
- `-p`：端口映射，根据ADGUARDHOME功能需求开放相应端口

> 注意：如需使用DHCP服务器功能，可能需要添加`--network host`参数使用主机网络（仅Linux系统支持），此时无需单独指定`-p`端口映射。


## 功能测试

### 容器状态检查

部署完成后，首先检查容器是否正常运行：

```bash
# 查看容器运行状态
docker ps | grep adguardhome

# 若容器未运行，查看错误日志
docker logs adguardhome
```

正常运行时，输出应显示容器状态为`Up`。

### 管理界面访问测试

ADGUARDHOME首次启动时，通过3000端口提供初始配置界面。在浏览器中访问：

```
http://服务器IP:3000
```

若无法访问，检查服务器防火墙规则是否允许3000端口入站，或通过以下命令测试端口连通性：

```bash
# 从服务器本地测试
curl http://127.0.0.1:3000

# 从客户端测试（替换为实际服务器IP）
curl http://服务器IP:3000
```

### DNS服务功能测试

ADGUARDHOME核心功能为DNS服务，可通过`nslookup`或`dig`命令测试DNS解析是否正常：

```bash
# 使用ADGUARDHOME作为DNS服务器解析域名
nslookup example.com 服务器IP
```

若解析成功，说明DNS服务基本功能正常。


## 生产环境建议

### 数据安全与备份

ADGUARDHOME的配置和运行数据存储在挂载的主机目录中，建议：
- 定期备份`/data/adguardhome`目录，防止数据丢失
- 对备份文件进行加密存储，保护隐私数据

```bash
# 示例：创建数据备份
tar -czf adguardhome_backup_$(date +%Y%m%d).tar.gz /data/adguardhome
```

### 资源限制配置

为避免容器过度占用主机资源，建议通过`--memory`和`--cpus`参数限制资源使用：

```bash
docker run -d \
  --name adguardhome \
  --restart unless-stopped \
  --memory=1G \  # 限制最大内存使用为1GB
  --cpus=0.5 \   # 限制CPU使用为0.5核
  -v /data/adguardhome/conf:/opt/adguardhome/conf \
  -v /data/adguardhome/work:/opt/adguardhome/work \
  -p 53:53/tcp -p 53:53/udp \
  -p 3000:3000/tcp \
  adguard/adguardhome:latest
```

根据实际网络规模和设备数量，调整资源限制参数。

### 网络优化

- **端口冲突处理**：ADGUARDHOME使用的53端口可能与系统自带DNS服务（如systemd-resolved）冲突，解决方法参考[故障排查](#故障排查)章节。
- **网络模式选择**：常规场景使用桥接网络（默认），需使用DHCP功能时切换至主机网络（`--network host`）。
- **防火墙配置**：仅开放必要端口，限制访问来源IP，增强安全性。


## 故障排查

### 常见问题及解决方法

#### 1. 53端口冲突（systemd-resolved服务）

**症状**：容器启动失败，日志显示`bind: address already in use`（绑定端口已被占用）。

**原因**：Linux系统默认的systemd-resolved服务占用53端口。

**解决方法**：
```bash
# 创建resolved配置文件
sudo mkdir -p /etc/systemd/resolved.conf.d/
sudo tee /etc/systemd/resolved.conf.d/adguardhome.conf <<EOF
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
EOF

# 备份并重新链接resolv.conf
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

# 重启resolved服务
sudo systemctl reload-or-restart systemd-resolved
```

#### 2. 管理界面无法访问

**排查步骤**：
1. 检查容器是否运行：`docker ps | grep adguardhome`
2. 检查端口映射是否正确：`docker inspect adguardhome | grep PortBindings`
3. 检查主机防火墙规则：`sudo ufw status`（UFW防火墙）或查看`iptables`规则
4. 查看容器日志定位错误：`docker logs adguardhome`

#### 3. DNS解析异常

**排查步骤**：
1. 确认ADGUARDHOME上游DNS配置正确（通过管理界面检查）
2. 检查网络连通性：容器内测试上游DNS服务器连通性
   ```bash
   # 进入容器
   docker exec -it adguardhome /bin/sh
   # 测试DNS解析
   nslookup example.com 8.8.8.8  # 使用Google DNS测试
   ```
3. 查看ADGUARDHOME日志，分析解析失败原因：`docker logs adguardhome`


## 参考资源

- [ADGUARDHOME镜像文档（轩辕）](https://xuanyuan.cloud/r/adguard/adguardhome)
- [ADGUARDHOME镜像标签列表](https://xuanyuan.cloud/r/adguard/adguardhome/tags)
- [ADGUARDHOME官方GitHub仓库](https://github.com/AdguardTeam/AdGuardHome)
- [Docker官方文档](https://docs.docker.com/)


## 总结

本文详细介绍了ADGUARDHOME的Docker容器化部署方案，从环境准备、镜像拉取、容器部署到功能测试，提供了一套完整的实施流程。通过容器化部署，用户可以快速搭建网络级广告拦截DNS服务，同时确保部署过程的可重复性和环境隔离性。

**关键要点**：
- 使用轩辕镜像访问支持可提升ADGUARDHOME镜像拉取访问表现
- 数据持久化通过挂载主机目录实现，需注意备份重要配置
- 53端口可能与系统服务冲突，需提前排查并处理
- 管理界面初始访问端口为3000，完成配置后可调整

**后续建议**：
- 登录ADGUARDHOME管理界面完成初始配置，包括上游DNS设置、过滤规则添加等
- 根据网络规模和设备数量，优化ADGUARDHOME性能参数（如缓存大小、并发连接数）
- 深入学习ADGUARDHOME高级特性，如DNS-over-HTTPS、DNS-over-TLS等加密DNS功能
- 定期更新镜像版本，获取安全补丁和功能改进：`docker pull adguard/adguardhome:latest`并重启容器

通过合理配置和维护，ADGUARDHOME可有效提升网络隐私保护水平，为家庭或企业网络提供可靠的广告和跟踪器拦截服务。


# Rancher 容器化部署指南：基于 Docker 的生产环境实践

![Rancher 容器化部署指南：基于 Docker 的生产环境实践](https://img.xuanyuan.dev/docker/blog/docker-rancher.png)

*分类: Docker,Rancher | 标签: rancher,docker,部署教程 | 发布时间: 2025-12-14 02:58:07*

> Rancher 是一款专为在生产环境中部署容器的组织打造的容器管理平台，它能全面支持容器的部署、监控、扩展与运维等全生命周期管理，帮助企业有效提升生产环境中容器应用的运行效率与稳定性，优化资源配置，简化管理流程，适用于各类需要在生产场景中规模化或复杂化部署容器的机构，满足其对容器应用可靠运行与高效管理的核心需求。

## 概述

RANCHER 是一款专为在生产环境中部署容器的组织打造的容器管理平台，它能全面支持容器的部署、监控、扩展与运维等全生命周期管理，帮助企业有效提升生产环境中容器应用的运行效率与稳定性，优化资源配置，简化管理流程，适用于各类需要在生产场景中规模化或复杂化部署容器的机构，满足其对容器应用可靠运行与高效管理的核心需求。

本镜像基于 [rancher/rancher](https://github.com/rancher/rancher/tree/master) 构建，适用于 Rancher 2.x 版本。若需使用 Rancher 1.x 版本，请参考 [rancher/server](https://hub.docker.com/r/rancher/server/) 镜像。关于更新与发布策略，官方计划每周至每两周推送一次更新构建；经过额外 QA 测试后，会发布官方版本并标记为 "latest"；正式发布前，会创建标签以 "-rcX" 结尾的版本（如 -rc1、-rc2），**不建议使用任何 "-rcX" 标签**，因为 RC 版本属于前沿开发版本，可能存在影响后续升级至正式版的 bug。

本文档将详细介绍如何通过 Docker 容器化方式部署 RANCHER，包括环境准备、镜像拉取、容器部署、功能测试、生产环境建议及故障排查等内容，为企业级容器管理平台的搭建提供可靠参考。


## 环境准备

### 操作系统要求

RANCHER 容器化部署对操作系统有以下基本要求：
- 64 位 Linux 发行版（推荐 Ubuntu 20.04+/Debian 10+/CentOS 7+/RHEL 7+）
- 内核版本 4.15 或更高
- 至少 2 CPU 核心、4GB 内存和 20GB 可用磁盘空间
- 网络连接正常，能够访问互联网以拉取镜像和相关依赖

### Docker 环境安装

在部署 RANCHER 之前，需要先安装 Docker 环境。推荐使用轩辕提供的一键安装脚本，该脚本会自动安装并配置 Docker 最新稳定版本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，建议将当前用户添加到 docker 用户组，以避免每次执行 Docker 命令都需要使用 sudo：

```bash
sudo usermod -aG docker $USER
```

> ⚠️ 注意：添加用户组后需注销并重新登录，才能使配置生效。

### 环境验证

Docker 安装完成后，通过以下命令验证安装是否成功：

```bash
docker --version
docker info
```

若命令正常输出 Docker 版本信息和系统信息，则说明 Docker 环境已准备就绪。


## 镜像准备

### 拉取 RANCHER 镜像

使用以下命令通过轩辕镜像访问支持地址拉取推荐版本的 RANCHER 镜像：

```bash
docker pull xxx.xuanyuan.run/rancher/rancher:head
```

### 验证镜像

镜像拉取完成后，使用以下命令验证镜像是否成功下载：

```bash
docker images | grep rancher/rancher
```

若输出类似以下信息，则说明镜像拉取成功：

```
xxx.xuanyuan.run/rancher/rancher   head    abc12345   2 weeks ago   2.1GB
```

### 镜像标签说明

RANCHER 镜像提供多种标签版本，不同标签对应不同的版本特性：
- `head`：推荐使用的稳定版本标签
- `-rcX`：开发测试版本（如 -rc1、-rc2），**不建议在生产环境使用**，可能存在影响后续升级的 bug
- 其他特定版本标签：可通过 [RANCHER 镜像标签列表](https://xuanyuan.cloud/r/rancher/rancher/tags) 查看所有可用版本

如需使用其他版本，可将拉取命令中的 `head` 替换为所需标签，但生产环境中建议优先使用 `head` 标签或官方标记为 "latest" 的稳定版本。


## 容器部署

### 基础部署命令

使用以下基础命令部署 RANCHER 容器：

```bash
docker run -d \
  --name rancher \
  -p 80:80 \
  -p 443:443 \
  -v /var/lib/rancher:/var/lib/rancher \
  -e ADMIN_PASSWORD=your_secure_password \
  --restart=unless-stopped \
  xxx.xuanyuan.run/rancher/rancher:head
```

> ⚠️ 注意：上述命令中映射的端口（80 和 443）仅为示例，具体端口配置请查看官方文档。实际部署时，请根据官方文档说明调整端口映射。

### 命令参数说明

上述部署命令中各参数的作用如下：
- `-d`：后台运行容器
- `--name rancher`：指定容器名称为 rancher，便于后续管理
- `-p 80:80`：将容器的 80 端口映射到主机的 80 端口（HTTP）
- `-p 443:443`：将容器的 443 端口映射到主机的 443 端口（HTTPS）
- `-v /var/lib/rancher:/var/lib/rancher`：将主机的 `/var/lib/rancher` 目录挂载到容器内，实现数据持久化
- `-e ADMIN_PASSWORD=your_secure_password`：设置管理员密码环境变量，请替换为强密码
- `--restart=unless-stopped`：设置容器重启策略，除非手动停止，否则总是重启

### 自定义配置部署

根据实际需求，可添加更多参数进行自定义配置：

#### 1. 调整存储路径

若需要将数据存储在非默认路径，可修改挂载目录：

```bash
docker run -d \
  --name rancher \
  -p 80:80 \
  -p 443:443 \
  -v /data/rancher:/var/lib/rancher \  # 自定义存储路径
  -e ADMIN_PASSWORD=your_secure_password \
  --restart=unless-stopped \
  xxx.xuanyuan.run/rancher/rancher:head
```

#### 2. 设置时区

添加时区环境变量，确保容器内时间与主机一致：

```bash
docker run -d \
  --name rancher \
  -p 80:80 \
  -p 443:443 \
  -v /var/lib/rancher:/var/lib/rancher \
  -e ADMIN_PASSWORD=your_secure_password \
  -e TZ=Asia/Shanghai \  # 设置时区为上海
  --restart=unless-stopped \
  xxx.xuanyuan.run/rancher/rancher:head
```

#### 3. 限制资源使用

根据服务器配置，可限制容器的 CPU 和内存使用：

```bash
docker run -d \
  --name rancher \
  -p 80:80 \
  -p 443:443 \
  -v /var/lib/rancher:/var/lib/rancher \
  -e ADMIN_PASSWORD=your_secure_password \
  --memory=8g \  # 限制内存使用为 8GB
  --cpus=4 \     # 限制 CPU 使用为 4 核心
  --restart=unless-stopped \
  xxx.xuanyuan.run/rancher/rancher:head
```

### 验证容器状态

容器启动后，使用以下命令检查容器运行状态：

```bash
docker ps | grep rancher
```

若输出状态为 `Up`，则说明容器已成功启动：

```
abc123456789   xxx.xuanyuan.run/rancher/rancher:head   "entrypoint.sh"   5 minutes ago   Up 5 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   rancher
```

如需查看容器详细信息，可使用：

```bash
docker inspect rancher
```


## 功能测试

### 查看容器日志

容器启动后，通过以下命令查看 RANCHER 服务初始化日志：

```bash
docker logs -f rancher
```

> 提示：使用 `-f` 参数可实时跟踪日志输出，按 `Ctrl+C` 可退出日志查看。

服务初始化完成后，日志中会显示类似以下信息，表明 RANCHER 已准备就绪：

```
INFO: Rancher server is up and running
```

### 访问 Web 界面

RANCHER 服务启动后，通过浏览器访问服务器 IP 地址或域名：

```
https://<服务器IP地址>
```

> ⚠️ 注意：RANCHER 默认使用 HTTPS 协议，首次访问时可能会出现证书警告，这是因为使用了自签名证书。在测试环境中可忽略警告继续访问，生产环境建议配置可信 SSL 证书。

### 登录验证

在登录页面，使用部署时设置的管理员密码（通过 `ADMIN_PASSWORD` 环境变量指定）登录系统：
- 用户名：admin
- 密码：部署时设置的 `your_secure_password`

成功登录后，将进入 RANCHER 管理控制台，表明服务已正常运行。

### 基本功能测试

在 RANCHER 管理控制台中，可进行以下基本功能测试：

#### 1. 查看系统信息

导航至"系统信息"页面，确认系统版本、组件状态等信息是否正常显示。

#### 2. 创建测试项目

尝试创建一个新的项目，验证平台基本操作是否正常。

#### 3. 查看节点状态

在"节点"页面查看当前 RANCHER 服务器节点状态，确认节点处于"活跃"状态。

### 服务可用性测试

使用 curl 命令测试服务端口是否正常响应：

```bash
curl -k https://localhost/healthz
```

若返回 `ok`，则说明服务健康检查通过。


## 生产环境建议

### 数据持久化

在生产环境中，数据持久化是至关重要的，建议采取以下措施：

#### 1. 使用专用存储

对于生产环境，建议将 RANCHER 数据存储在专用的存储设备或分区上，如 SSD 磁盘，以提高性能和可靠性。

#### 2. 定期备份数据

定期备份 `/var/lib/rancher` 目录（或自定义的挂载目录），可使用以下简单脚本实现自动备份：

```bash
#!/bin/bash
BACKUP_DIR="/backup/rancher"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# 创建数据备份
tar -czf $BACKUP_DIR/rancher_backup_$TIMESTAMP.tar.gz /var/lib/rancher

# 保留最近 30 天的备份
find $BACKUP_DIR -name "rancher_backup_*.tar.gz" -mtime +30 -delete
```

将脚本添加到 crontab，设置每日自动备份：

```bash
crontab -e
# 添加以下行，每天凌晨 2 点执行备份
0 2 * * * /path/to/backup_script.sh
```

### 资源配置

根据实际业务规模，合理配置 RANCHER 服务器资源：

#### 1. 硬件配置建议

- **小规模部署**（管理少于 10 个节点）：至少 4 CPU 核心，8GB 内存，50GB SSD 存储
- **中等规模部署**（管理 10-50 个节点）：8 CPU 核心，16GB 内存，100GB SSD 存储
- **大规模部署**（管理 50+ 个节点）：16+ CPU 核心，32+GB 内存，200GB+ SSD 存储

#### 2. Docker 资源限制

通过 `--memory` 和 `--cpus` 参数限制容器资源使用，避免资源耗尽影响其他服务：

```bash
docker run -d \
  --name rancher \
  --memory=16g \
  --cpus=8 \
  # 其他参数...
  xxx.xuanyuan.run/rancher/rancher:head
```

### 网络安全

确保 RANCHER 服务的网络安全，建议采取以下措施：

#### 1. 使用可信 SSL 证书

生产环境中应配置可信的 SSL 证书，替代默认的自签名证书。可通过以下方式实现：

- 将 SSL 证书文件挂载到容器中：

```bash
docker run -d \
  --name rancher \
  -p 443:443 \
  -v /var/lib/rancher:/var/lib/rancher \
  -v /etc/rancher/ssl/cert.pem:/etc/rancher/ssl/cert.pem \
  -v /etc/rancher/ssl/key.pem:/etc/rancher/ssl/key.pem \
  -e ADMIN_PASSWORD=your_secure_password \
  --restart=unless-stopped \
  xxx.xuanyuan.run/rancher/rancher:head
```

#### 2. 限制网络访问

通过防火墙限制仅允许必要的 IP 地址访问 RANCHER 服务端口：

```bash
# 使用 ufw 防火墙示例
sudo ufw allow from 192.168.1.0/24 to any port 443
sudo ufw reload
```

#### 3. 定期更新

关注 RANCHER 官方发布的安全更新，定期更新镜像版本，避免使用存在安全漏洞的旧版本。

### 高可用性部署

对于关键业务，建议部署 RANCHER 高可用集群，避免单点故障。高可用部署通常需要：

- 至少 3 个 RANCHER 服务器节点
- 共享数据库（如 PostgreSQL）
- 负载均衡器（如 Nginx、HAProxy）
- 共享存储或分布式存储

具体的高可用部署方案请参考 [RANCHER 镜像文档（轩辕）](https://xuanyuan.cloud/r/rancher/rancher) 中的高可用部署指南。

### 监控与日志

在生产环境中，建议对 RANCHER 服务进行监控和日志管理：

#### 1. 容器监控

使用 Docker 内置命令或第三方工具（如 Prometheus + Grafana）监控容器资源使用情况：

```bash
# 实时监控容器资源使用
docker stats rancher
```

#### 2. 日志管理

将容器日志输出到集中式日志系统（如 ELK Stack、Graylog），便于日志分析和问题排查：

```bash
docker run -d \
  --name rancher \
  # 其他参数...
  --log-driver=json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  xxx.xuanyuan.run/rancher/rancher:head
```

上述配置限制单个日志文件大小为 10MB，最多保留 3 个日志文件，避免日志占用过多磁盘空间。


## 故障排查

### 容器无法启动

若 RANCHER 容器无法启动，可按以下步骤排查：

#### 1. 查看启动日志

```bash
docker logs rancher
```

日志中通常会包含容器启动失败的具体原因，如端口冲突、权限问题、数据损坏等。

#### 2. 检查端口占用

若日志提示端口已被占用，使用以下命令查找占用端口的进程：

```bash
# 检查 80 端口
sudo lsof -i :80
# 检查 443 端口
sudo lsof -i :443
```

根据输出结果，停止占用端口的进程或修改 RANCHER 容器的端口映射。

#### 3. 检查数据目录权限

若日志提示权限错误，检查数据目录权限是否正确：

```bash
ls -ld /var/lib/rancher
```

确保 Docker 进程对该目录有读写权限，必要时修改目录权限：

```bash
sudo chown -R 1000:1000 /var/lib/rancher
```

#### 4. 清理损坏数据

若数据目录损坏导致无法启动，可尝试备份数据后清理目录（注意：这将丢失所有现有配置）：

```bash
docker stop rancher
docker rm rancher
mv /var/lib/rancher /var/lib/rancher_backup
mkdir -p /var/lib/rancher
docker run ...  # 重新运行部署命令
```

### 服务访问问题

若容器正常运行但无法访问 RANCHER 服务，可按以下步骤排查：

#### 1. 检查网络连接

确认客户端与服务器之间网络通畅，可使用 ping 命令测试：

```bash
ping <服务器IP地址>
```

#### 2. 检查防火墙配置

确认服务器防火墙允许访问 RANCHER 服务端口：

```bash
# 使用 ufw 防火墙示例
sudo ufw status | grep 443
# 使用 firewalld 防火墙示例
sudo firewall-cmd --list-ports | grep 443
```

若端口未开放，添加防火墙规则：

```bash
# ufw 示例
sudo ufw allow 443/tcp
# firewalld 示例
sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --reload
```

#### 3. 检查容器端口映射

确认容器端口映射配置正确：

```bash
docker port rancher
```

输出应显示容器端口与主机端口的映射关系：

```
443/tcp -> 0.0.0.0:443
80/tcp -> 0.0.0.0:80
```

### 升级问题

从旧版本升级到新版本时遇到问题，可参考以下排查步骤：

#### 1. 避免使用 RC 版本

确保不使用 `-rcX` 标签的开发测试版本，RC 版本可能存在影响升级的 bug。生产环境应使用 `head` 标签或官方标记为 "latest" 的稳定版本。

#### 2. 升级前备份数据

升级前务必备份 `/var/lib/rancher` 目录，以防升级失败导致数据丢失。

#### 3. 检查升级兼容性

升级前查阅 [RANCHER 镜像文档（轩辕）](https://xuanyuan.cloud/r/rancher/rancher) 中的版本兼容性说明，确认当前版本可直接升级到目标版本，或是否需要逐步升级。

#### 4. 升级失败回滚

若升级失败，可使用备份数据回滚到之前的版本：

```bash
docker stop rancher
docker rm rancher
rm -rf /var/lib/rancher
mv /var/lib/rancher_backup /var/lib/rancher
docker run ...  # 使用之前的版本重新部署
```

### 节点连接问题

若 RANCHER 服务器无法连接到下游节点，可检查以下项目：

#### 1. 节点网络连通性

确保 RANCHER 服务器与节点之间网络通畅，节点能够访问服务器的 443 端口。

#### 2. 节点防火墙配置

节点需允许来自 RANCHER 服务器的连接，以及节点间的通信。具体端口要求请参考官方文档。

#### 3. 节点代理配置

若节点通过代理访问互联网，确保正确配置了代理环境变量，且代理允许访问 RANCHER 服务器。


## 参考资源

### 官方文档与资源

- [RANCHER 镜像文档（轩辕）](https://xuanyuan.cloud/r/rancher/rancher)：轩辕镜像的文档页面，包含镜像基本信息和使用说明
- [RANCHER 镜像标签列表](https://xuanyuan.cloud/r/rancher/rancher/tags)：查看所有可用的 RANCHER 镜像标签版本
- Rancher 官方文档：关于 Rancher 的具体使用方法，可查阅官方文档（镜像说明中提及的官方文档链接）

### Docker 相关资源

- Docker 官方文档：https://docs.docker.com/
- Docker 命令参考：https://docs.docker.com/engine/reference/commandline/cli/
- Docker 容器最佳实践：https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

### 网络与安全资源

- SSL 证书配置指南：https://letsencrypt.org/docs/
- Docker 网络模式详解：https://docs.docker.com/network/
- Linux 防火墙配置：根据所使用的 Linux 发行版参考相应文档（如 Ubuntu ufw、CentOS firewalld）

### 监控与日志资源

- Prometheus + Grafana 监控方案：https://prometheus.io/docs/introduction/overview/
- ELK Stack 日志管理：https://www.elastic.co/what-is/elk-stack
- Docker 日志驱动配置：https://docs.docker.com/config/containers/logging/configure/


## 总结

本文详细介绍了 RANCHER 的 Docker 容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境建议及故障排查等内容。通过本文档提供的步骤，用户可以快速搭建起一个基础的 RANCHER 容器管理平台，实现容器应用的全生命周期管理。

### 关键要点

- **环境准备**：使用轩辕提供的一键脚本快速安装 Docker 环境，确保系统满足 RANCHER 运行的基本要求
- **镜像拉取**：通过轩辕镜像访问支持服务拉取 RANCHER 镜像，推荐使用 `head` 标签的稳定版本，避免使用 `-rcX` 开发测试版本
- **容器部署**：使用基础的 `docker run` 命令部署容器，配置数据持久化、端口映射和必要的环境变量，根据实际需求调整资源限制
- **功能验证**：通过查看日志、访问 Web 界面和基本操作测试，确认服务正常运行
- **生产环境优化**：重点关注数据持久化、资源配置、网络安全、高可用性和监控日志等方面，确保生产环境稳定可靠
- **故障排查**：针对容器无法启动、服务访问问题、升级问题等常见故障，提供了基本的排查思路和解决方法

### 后续建议

- **深入学习 RANCHER 功能**：RANCHER 提供丰富的容器管理功能，建议深入学习其高级特性，如多集群管理、应用商店、CI/CD 流水线等，充分发挥平台价值
- **根据业务需求调整配置**：根据实际业务规模和需求，调整容器资源配置、网络策略和存储方案，优化平台性能和可靠性
- **关注版本更新**：定期关注 RANCHER 版本更新，及时应用安全补丁和新功能，确保系统安全性和稳定性
- **建立完善的运维体系**：结合监控、日志、备份和故障演练，建立完善的运维体系，提高系统可靠性和故障恢复能力
- **参考官方文档**：对于更复杂的部署场景（如高可用集群），建议参考官方文档和最佳实践，确保部署方案的合理性和可靠性

通过合理配置和运维，RANCHER 可以成为企业容器化战略的核心管理平台，有效提升容器应用的部署效率和运维质量。


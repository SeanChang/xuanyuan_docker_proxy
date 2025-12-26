# Transmission Docker 容器化部署指南

![Transmission Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-transmission.png)

*分类: Docker,Transmission | 标签: transmission,docker,部署教程 | 发布时间: 2025-12-14 12:25:46*

> Transmission 是由LinuxServer.io团队提供的容器化应用，基于Transmission BitTorrent客户端构建。Transmission设计理念为简单易用且功能强大，具备BitTorrent客户端所需的核心特性：加密传输、Web管理界面、节点交换、磁力链接支持、DHT网络、µTP协议、UPnP与NAT-PMP端口转发、WebSeed支持、监控目录、Tracker编辑、全局及每种子速度限制等。

## 概述

Transmission 是由LinuxServer.io团队提供的容器化应用，基于Transmission BitTorrent客户端构建。Transmission设计理念为简单易用且功能强大，具备BitTorrent客户端所需的核心特性：加密传输、Web管理界面、节点交换、磁力链接支持、DHT网络、µTP协议、UPnP与NAT-PMP端口转发、WebSeed支持、监控目录、Tracker编辑、全局及每种子访问表现限制等。

LinuxServer.io提供的 Transmission 容器具有以下特点：
- 定期且及时的应用更新
- 简单的用户权限映射（PGID/PUID）
- 基于s6 overlay的自定义基础镜像
- 每周基础操作系统更新，通过跨生态系统的通用层减少空间占用、 downtime和带宽消耗
- 定期安全更新

本文档将详细介绍如何通过Docker容器化方式部署 Transmission ，包括环境准备、镜像拉取、容器配置、功能测试及生产环境优化建议。


## 环境准备

### Docker环境安装

部署 Transmission 容器前，需先确保服务器已安装Docker环境。推荐使用以下一键安装脚本快速部署Docker及相关组件：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本将自动完成Docker Engine、Docker Compose等组件的安装与配置，并启动Docker服务。安装完成后，可通过`docker --version`命令验证安装是否成功。


## 镜像准备

### 拉取 Transmission 镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的TRANSMISSION镜像：

```bash
docker pull xxx.xuanyuan.run/linuxserver/transmission:latest
```

如需指定其他版本，可访问[ Transmission 镜像标签列表](https://xuanyuan.cloud/r/linuxserver/transmission/tags)查看所有可用标签，并将命令中的`latest`替换为目标标签。


## 容器部署

### 基础部署命令

使用以下`docker run`命令部署 Transmission 容器，包含必要的端口映射、数据卷挂载和环境变量配置：

```bash
docker run -d \
  --name=transmission \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /opt/transmission/config:/config \
  -v /opt/transmission/downloads:/downloads \
  -v /opt/transmission/watch:/watch \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e USER=admin \
  -e PASS=your_secure_password \
  --restart unless-stopped \
  xxx.xuanyuan.run/linuxserver/transmission:latest
```

### 参数说明

| 参数 | 说明 |
|------|------|
| `-d` | 后台运行容器 |
| `--name=transmission` | 指定容器名称为transmission |
| `-p 9091:9091` | 映射Web管理界面端口 |
| `-p 51413:51413` | 映射BT下载TCP端口 |
| `-p 51413:51413/udp` | 映射BT下载UDP端口 |
| `-v /opt/transmission/config:/config` | 挂载配置文件目录，持久化配置数据 |
| `-v /opt/transmission/downloads:/downloads` | 挂载下载文件目录 |
| `-v /opt/transmission/watch:/watch` | 挂载监控目录，自动加载新增的torrent文件 |
| `-e PUID=1000` | 指定运行用户ID（可通过`id your_username`命令获取） |
| `-e PGID=1000` | 指定运行用户组ID（可通过`id your_username`命令获取） |
| `-e TZ=Asia/Shanghai` | 指定时区（如Asia/Shanghai、Etc/UTC等） |
| `-e USER=admin` | Web界面登录用户名（可选，不设置则无需认证） |
| `-e PASS=your_secure_password` | Web界面登录密码（可选，与USER同时设置生效） |
| `--restart unless-stopped` | 容器退出时自动重启（除非手动停止） |

### 可选配置参数

根据实际需求，可添加以下可选环境变量：

```bash
-e WHITELIST=192.168.1.0/24,10.0.0.0/8 \  # IP白名单，限制仅允许指定IP段访问Web界面
-e HOST_WHITELIST=example.com,*.domain.com \  # 主机白名单，限制仅允许指定域名访问Web界面
-e PEERPORT=51413 \  # 指定BT监听端口（需与端口映射保持一致）
-e TRANSMISSION_WEB_HOME=/path/to/custom/ui \  # 指定自定义Web界面路径
--read-only=true \  # 以只读文件系统运行容器（需额外挂载临时目录）
--user=1000:1000 \  # 以非root用户运行容器
```


## 功能测试

容器部署完成后，建议进行以下测试以验证功能正常：

### 1. 容器状态检查

检查容器是否正常运行：

```bash
docker ps | grep transmission
```

若状态显示为`Up`，表示容器启动成功。

### 2. Web界面访问测试

通过浏览器访问 Transmission Web管理界面：

```
http://服务器IP:9091
```

若设置了用户名和密码，会提示输入凭据。登录成功后可看到 Transmission 的管理界面，包括当前下载任务、种子列表、设置等功能。

### 3. 日志查看

查看容器运行日志，确认无错误信息：

```bash
docker logs -f transmission
```

正常启动日志应包含类似以下内容：
```
[2024-05-20 10:00:00.000] Transmission 4.0.5 (bb6b5a062e) started (session.c:768)
[2024-05-20 10:00:00.000] RPC Server Adding address to whitelist: 127.0.0.1 (rpc-server.c:957)
[2024-05-20 10:00:00.000] RPC Server Serving RPC and Web requests on 0.0.0.0:9091/transmission/ (rpc-server.c:1323)
[2024-05-20 10:00:00.000] DHT Initializing DHT (tr-dht.c:272)
[2024-05-20 10:00:00.000] Using settings from "/config/settings.json" (settings.c:826)
```

### 4. 下载功能测试

在Web界面中添加一个测试torrent文件或磁力链接，检查是否能正常开始下载，下载完成后文件是否保存到`/downloads`目录。


## 生产环境建议

为确保TRANSMISSION在生产环境中稳定、安全运行，建议采取以下措施：

### 1. 数据持久化优化

- 确保`/config`、`/downloads`和`/watch`目录挂载到主机持久化存储，避免容器删除后数据丢失
- 对于大规模部署，考虑使用NFS或分布式存储作为下载目录，提高存储扩展性

### 2. 安全加固

- 务必设置强密码（`USER`和`PASS`参数），避免未授权访问
- 使用`WHITELIST`或`HOST_WHITELIST`限制仅允许信任的IP/域名访问Web界面
- 配置防火墙，仅开放必要端口（9091、51413），并限制端口访问来源
- 定期更新镜像（`docker pull xxx.xuanyuan.run/linuxserver/transmission:latest`）以获取安全补丁
- 避免使用默认BT端口（51413），可自定义端口减少被封锁风险

### 3. 资源限制

根据服务器配置和下载需求，为容器设置资源限制：

```bash
--memory=4g \  # 限制最大使用内存为4GB
--memory-swap=4g \  # 限制内存+交换分区总使用量为4GB
--cpus=2 \  # 限制CPU使用核心数为2核
--device-read-bps /dev/sda:100mb \  # 限制磁盘读取访问表现为100MB/s
--device-write-bps /dev/sda:100mb \  # 限制磁盘写入访问表现为100MB/s
```

### 4. 监控与日志

- 使用`docker logs -f transmission`实时监控容器运行状态
- 配置日志轮转，避免日志文件过大：
  ```bash
  docker run ... --log-opt max-size=10m --log-opt max-file=3 ...
  ```
- 集成第三方监控工具（如Prometheus + Grafana），通过Transmission的RPC接口收集下载访问表现、种子数量等指标

### 5. 自动更新

结合Docker镜像更新工具（如Diun）实现镜像更新通知：

```yaml
# docker-compose.yml示例
version: "3"
services:
  diun:
    image: crazymax/diun:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./diun:/data
    environment:
      - DIUN_WATCH_WORKERS=20
      - DIUN_WATCH_SCHEDULE=0 */6 * * *
      - DIUN_PROVIDERS_DOCKER=true
      - DIUN_NOTIF_MAIL_HOST=smtp.example.com
      - DIUN_NOTIF_MAIL_PORT=587
      - DIUN_NOTIF_MAIL_USER=user@example.com
      - DIUN_NOTIF_MAIL_PASS=password
      - DIUN_NOTIF_MAIL_FROM=diun@example.com
      - DIUN_NOTIF_MAIL_TO=admin@example.com
    restart: unless-stopped
```


## 故障排查

### 1. 容器无法启动

- **检查日志**：使用`docker logs transmission`查看错误信息，常见问题包括：
  - 权限问题：`/config`或`/downloads`目录权限不足，需确保主机目录所有者ID与`PUID`一致
  - 端口冲突：端口已被其他服务占用，使用`netstat -tulpn | grep 端口号`检查冲突进程
  - 配置文件损坏：删除`/config/settings.json`后重启容器，自动生成默认配置

- **检查Docker状态**：确保Docker服务正常运行：
  ```bash
  systemctl status docker
  ```

### 2. Web界面无法访问

- **检查端口映射**：确认容器端口已正确映射到主机：
  ```bash
  docker port transmission
  ```
  预期输出：
  ```
  9091/tcp -> 0.0.0.0:9091
  51413/tcp -> 0.0.0.0:51413
  51413/udp -> 0.0.0.0:51413
  ```

- **检查防火墙规则**：确保服务器防火墙允许端口访问：
  ```bash
  # 对于ufw防火墙
  ufw allow 9091/tcp
  ufw allow 51413/tcp
  ufw allow 51413/udp
  
  # 对于firewalld防火墙
  firewall-cmd --add-port=9091/tcp --permanent
  firewall-cmd --add-port=51413/tcp --permanent
  firewall-cmd --add-port=51413/udp --permanent
  firewall-cmd --reload
  ```

- **检查白名单设置**：若配置了`WHITELIST`或`HOST_WHITELIST`，确认访问IP/域名在白名单范围内

### 3. 下载访问表现慢或无法连接 peers

- **检查端口转发**：确认路由器已正确配置端口转发（UPnP/NAT-PMP），将BT端口（51413）转发到服务器IP
- **检查tracker状态**：在Web界面"种子"->"Tracker"中查看Tracker连接状态，若显示"无法连接"可能是Tracker服务器故障或网络限制
- **检查DHT网络**：确保DHT功能已启用（默认启用），可在`settings.json`中确认：
  ```json
  "dht-enabled": true,
  "utp-enabled": true
  ```
- **检查防火墙策略**：确保服务器出站连接不受限制，BT下载需要连接多个外部节点

### 4. 容器以非root用户运行时权限问题

- 确保主机挂载目录所有者ID与容器`PUID`/`PGID`一致：
  ```bash
  chown -R 1000:1000 /opt/transmission/config
  chown -R 1000:1000 /opt/transmission/downloads
  chown -R 1000:1000 /opt/transmission/watch
  ```
- 使用`--user=1000:1000`参数时，确保该用户有足够权限访问挂载目录


## 参考资源

- [ Transmission 镜像文档（轩辕）](https://xuanyuan.cloud/r/linuxserver/transmission)
- [ Transmission 镜像标签列表](https://xuanyuan.cloud/r/linuxserver/transmission/tags)
- [LinuxServer.io官方文档](https://docs.linuxserver.io/)
- [Transmission官方网站](https://www.transmissionbt.com/)
- [Docker官方文档](https://docs.docker.com/)
- [LinuxServer.io GitHub仓库](https://github.com/linuxserver/docker-transmission)


## 总结

本文详细介绍了 Transmission 的Docker容器化部署方案，包括环境准备、镜像拉取、容器配置、功能测试、生产环境优化及故障排查等内容。通过容器化部署，可快速搭建 Transmission BT客户端，同时保证部署一致性、环境隔离性和运维便捷性。

**关键要点**：
- 使用轩辕提供的一键脚本快速安装Docker环境，简化部署流程
- 通过轩辕镜像访问支持地址拉取 Transmission 镜像，提高下载访问表现
- 容器部署时需注意端口映射、数据卷挂载和用户权限配置，确保功能正常
- 生产环境中应重视安全加固（如设置密码、IP白名单）、资源限制和数据持久化
- 故障排查以日志分析为核心，重点关注端口冲突、权限问题和网络连接

**后续建议**：
- 深入学习 Transmission 高级特性，如自定义Web界面、自动更新blockList、访问表现限制策略等
- 根据实际业务需求调整容器资源配置，平衡下载性能与服务器负载
- 探索 Transmission 的RPC接口，实现自动化任务管理（如通过脚本添加下载任务、监控下载进度）
- 考虑使用Docker Compose或Kubernetes进行编排，简化多容器管理和扩展
- 定期关注[ Transmission 镜像标签列表](https://xuanyuan.cloud/r/linuxserver/transmission/tags)，及时更新镜像以获取新功能和安全修复


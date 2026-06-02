---
image: linuxserver/smokeping
description: "由LinuxServer.io为您提供的Smokeping容器，是一款集成了开源网络性能监测工具的容器化应用，可实时监测网络延迟、抖动及丢包率，并通过图形化界面直观展示数据，帮助用户分析网络稳定性；该容器由专注于提供优化配置与持续更新支持的LinuxServer.io团队开发，便于快速部署和管理，满足用户对网络性能监控的需求。"
source: https://xuanyuan.cloud/zh/r/linuxserver/smokeping
canonical: https://xuanyuan.cloud/zh/r/linuxserver/smokeping
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/smokeping" title="linuxserver/smokeping Docker 镜像中文简介、标签列表与拉取命令">linuxserver/smokeping — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/linuxserver/smokeping" title="linuxserver/smokeping Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/smokeping</a>

# LinuxServer.io Smokeping 容器介绍  


## 关于 LinuxServer.io  

LinuxServer.io 团队致力于提供高质量容器，核心特点包括：  
- 定期且及时的应用更新  
- 简化的用户权限映射（通过 PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周基础系统更新，统一依赖层以减少存储空间占用、 downtime 和带宽消耗  
- 常规安全更新  


## 关于 Smokeping 容器  

[Smokeping]([]) 是一款网络延迟监控工具，可追踪网络节点的延迟变化。示例效果可参考 [UCDavis 演示]([])。  


## 支持的架构  

通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/smokeping:latest` 即可自动匹配对应架构，也可通过标签指定：  

| 架构       | 支持情况 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\> |  


## 应用配置  

1. **访问地址**：运行后通过 `http://<主机IP>/smokeping/smokeping.cgi` 访问，例如 `[]  
2. **基础设置**：编辑 `Targets` 文件，按现有格式添加需监控的主机。  
3. **配置重载**：无需重启容器时，执行命令：  
   ```bash  
   docker exec smokeping pkill -f -HUP '/usr/bin/perl /usr/s?bin/smokeping(_cgi)?'  
   ```  
   （将 `smokeping` 替换为容器ID）。  
4. **容器重启**：执行 `docker restart smokeping`（替换为容器ID）。  
5. **默认配置说明**：默认 `Targets` 文件包含示例配置，可能需要根据实际需求修改。  
6. **主从架构设置**：在主节点修改 `Targets`、`Slaves` 和 `smokeping_secrets` 文件，参考 [官方文档]([])。  


## 使用方法  

### Docker Compose（推荐）  

创建 `docker-compose.yml` 文件，内容如下：  

```yaml  
---  
services:  
  smokeping:  
    image: lscr.io/linuxserver/smokeping:latest  
    container_name: smokeping  
    hostname: smokeping # 可选  
    environment:  
      - PUID=1000          # 用户ID，必填  
      - PGID=1000          # 组ID，必填  
      - TZ=Etc/UTC         # 时区，必填（参考时区列表：  
      - MASTER_URL=http://<master-host-ip>:80/smokeping/ # 可选，从节点连接主节点的URL  
      - SHARED_SECRET=password # 可选，主从共享密钥  
      - CACHE_DIR=/tmp     # 可选，缓存目录  
    volumes:  
      - /path/to/smokeping/config:/config  # 配置文件存储路径，必填  
      - /path/to/smokeping/data:/data      # 数据存储路径（图表、数据库等），必填  
    ports:  
      - 80:80              # HTTP端口映射，必填  
    restart: unless-stopped  
```  

启动容器：  
```bash  
docker-compose up -d  
```  


### Docker CLI  

直接执行命令：  

```bash  
docker run -d \  
  --name=smokeping \  
  --hostname=smokeping `# 可选` \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -e MASTER_URL=http://<master-host-ip>:80/smokeping/ `# 可选` \  
  -e SHARED_SECRET=password `# 可选` \  
  -e CACHE_DIR=/tmp `# 可选` \  
  -p 80:80 \  
  -v /path/to/smokeping/config:/config \  
  -v /path/to/smokeping/data:/data \  
  --restart unless-stopped \  
  lscr.io/linuxserver/smokeping:latest  
```  


## 参数说明  

| 参数                  | 功能说明                                                                 |  
|-----------------------|--------------------------------------------------------------------------|  
| `--hostname=`         | 主从架构中，主节点主机名显示为名称，从节点主机名需与主节点 `Slaves` 文件中的别名一致。 |  
| `-p 80:80`            | 映射容器内HTTP端口到主机，用于访问Web界面。                                 |  
| `-e PUID=1000`        | 用户ID，避免权限问题（通过 `id your_user` 命令获取当前用户ID）。           |  
| `-e PGID=1000`        | 组ID，同上。                                                              |  
| `-e TZ=Etc/UTC`       | 时区设置，例如 `Asia/Shanghai`。                                          |  
| `-e MASTER_URL=`      | 从节点模式下，主节点的访问URL。                                           |  
| `-e SHARED_SECRET=`   | 主从模式下的共享密钥。                                                   |  
| `-e CACHE_DIR=`       | 从节点模式下的缓存目录。                                                 |  
| `-v /config`          | 持久化配置文件（如 `Targets`、`Slaves` 等）。                             |  
| `-v /data`            | 存储监控数据、图表、数据库等。                                           |  


## 环境变量与 Docker Secrets  

可通过文件设置环境变量，格式为 `-e FILE__变量名=文件路径`，例如：  
```bash  
-e FILE__SHARED_SECRET=/run/secrets/my_secret  
```  
变量值将从 `/run/secrets/my_secret` 文件中读取。  


## 用户/组ID设置  

使用 `-v` 挂载卷时，需确保主机目录权限与容器内用户一致。通过 `id your_user` 命令获取当前用户的 UID 和 GID，例如：  
```bash  
id your_user  
# 输出示例：uid=1000(your_user) gid=1000(your_user)  
```  
将 `PUID=1000` 和 `PGID=1000` 填入环境变量即可避免权限问题。  


## 容器更新方法  

### 通过 Docker Compose  

1. 拉取最新镜像：  
   ```bash  
   docker-compose pull smokeping  
   ```  
2. 重启容器：  
   ```bash  
   docker-compose up -d smokeping  
   ```  
3. 清理旧镜像：  
   ```bash  
   docker image prune  
   ```  


### 通过 Docker Run  

1. 拉取最新镜像：  
   ```bash  
   docker pull lscr.io/linuxserver/smokeping:latest  
   ```  
2. 停止并删除旧容器：  
   ```bash  
   docker stop smokeping && docker rm smokeping  
   ```  
3. 用原参数重新创建容器（配置文件通过 `-v` 挂载，会自动保留）。  


## 版本历史（近期重要更新）  

- **2025.09.26**：添加 IO::Socket::INET6 Perl 模块，增强 IPv6 支持。  
- **2025.06.05**：更新 TCPPing 至 2.7，修复 traceroute 兼容性问题。  
- **2025.06.03**：基于 Alpine 3.22 重构，更新 TCPPing，添加 curl 探针。  
- **2024.03.22**：支持从节点模式。  
- **2023.12.22**：基于 Alpine 3.19 重构，迁移至 s6v3。  


## 支持与资源  

- **文档**：[LinuxServer.io 博客]([])（含教程和指南）  
- **社区**：[]()（实时支持）、[Discourse]([])（论坛）  
- **代码**：[GitHub 仓库]([])  

如需支持或贡献，可通过上述渠道联系团队。

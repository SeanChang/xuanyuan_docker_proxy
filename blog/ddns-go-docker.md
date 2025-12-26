---
id: 85
title: DDNS-GO Docker 容器化部署指南
slug: ddns-go-docker
summary: DDNS-GO是一款简单易用的动态域名解析（DDNS）工具，能够自动获取公网IPv4/IPv6地址并更新至指定的域名服务商，实现域名与动态IP的实时绑定。该工具支持多种操作系统和硬件架构，兼容阿里云、腾讯云、Cloudflare等主流DNS服务商，提供Web界面配置和管理，适合个人和企业用户实现动态IP环境下的域名解析需求。
category: Docker,DDNS-GO
tags: ddns-go,docker,部署教程
image_name: jeessy/ddns-go
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-ddnsgo.png"
status: published
created_at: "2025-12-02 04:04:18"
updated_at: "2025-12-02 04:04:18"
---

# DDNS-GO Docker 容器化部署指南

> DDNS-GO是一款简单易用的动态域名解析（DDNS）工具，能够自动获取公网IPv4/IPv6地址并更新至指定的域名服务商，实现域名与动态IP的实时绑定。该工具支持多种操作系统和硬件架构，兼容阿里云、腾讯云、Cloudflare等主流DNS服务商，提供Web界面配置和管理，适合个人和企业用户实现动态IP环境下的域名解析需求。

## 概述

DDNS-GO是一款简单易用的动态域名解析（DDNS）工具，能够自动获取公网IPv4/IPv6地址并更新至指定的域名服务商，实现域名与动态IP的实时绑定。该工具支持多种操作系统和硬件架构，兼容阿里云、腾讯云、Cloudflare等主流DNS服务商，提供Web界面配置和管理，适合个人和企业用户实现动态IP环境下的域名解析需求。

DDNS-GO的核心特性包括：
- 跨平台支持：兼容Windows、macOS、Linux系统，支持x86、ARM、RISC-V架构
- 多服务商兼容：支持阿里云、腾讯云、Cloudflare、华为云等20+ DNS服务商
- 灵活的IP获取方式：支持通过接口、网卡或自定义命令获取IP地址
- 网页管理界面：提供直观的Web配置界面，默认禁止公网访问保障安全
- 自动化更新：默认每5分钟同步一次IP，支持自定义同步间隔
- 多域名管理：支持同时配置多个域名和DNS服务商
- 通知机制：支持Webhook通知，可集成钉钉、飞书、Telegram等平台

## 环境准备

### Docker安装

部署DDNS-GO前需先安装Docker环境，推荐使用以下一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本将自动完成Docker Engine、Docker Compose的安装及配置，适用于主流Linux发行版（Ubuntu、Debian、CentOS等）。安装完成后，可通过以下命令验证Docker是否正常运行：

```bash
docker --version       # 查看Docker版本
docker compose version # 查看Docker Compose版本
systemctl status docker # 检查Docker服务状态
```


## 镜像准备

### 镜像拉取

```bash
docker pull xxx.xuanyuan.run/jeessy/ddns-go:latest
```

> 说明：
> - `xxx.xuanyuan.run` 为轩辕镜像访问支持地址
> - `latest` 为推荐标签，如需指定版本，可访问[DDNS-GO镜像标签列表](https://xuanyuan.cloud/r/jeessy/ddns-go/tags)查看所有可用标签

### 验证镜像

拉取完成后，可通过以下命令验证镜像是否成功下载：

```bash
docker images | grep ddns-go
```

预期输出示例：
```
xxx.xuanyuan.run/jeessy/ddns-go   latest    abc12345   2 weeks ago   45MB
```

## 容器部署

DDNS-GO提供多种容器化部署方式，可根据网络环境和需求选择适合的方案。

### 基础部署（Host网络模式）

推荐使用Host网络模式，使容器直接使用主机网络，便于获取主机网络环境的真实IP地址：

```bash
docker run -d \
  --name ddns-go \
  --restart=always \
  --net=host \
  -v /opt/ddns-go:/root \
  xxx.xuanyuan.run/jeessy/ddns-go:latest
```

参数说明：
- `-d`：后台运行容器
- `--name ddns-go`：指定容器名称为ddns-go
- `--restart=always`：容器退出时自动重启
- `--net=host`：使用主机网络模式
- `-v /opt/ddns-go:/root`：挂载主机目录 `/opt/ddns-go` 到容器内 `/root`，用于持久化配置文件
- `xxx.xuanyuan.run/jeessy/ddns-go:latest`：使用的镜像及标签

### 端口映射模式（非Host网络）

若不希望使用Host网络，可采用端口映射方式（需注意可能影响IP获取准确性）：

```bash
docker run -d \
  --name ddns-go \
  --restart=always \
  -p 9876:9876 \
  -v /opt/ddns-go:/root \
  xxx.xuanyuan.run/jeessy/ddns-go:latest
```

参数说明：
- `-p 9876:9876`：将容器的9876端口映射到主机的9876端口（Web管理界面端口）

### 自定义启动参数

DDNS-GO支持通过命令行参数自定义配置，常见参数包括：

- `-l`：指定Web服务监听地址（默认`:9876`）
- `-f`：IP检查间隔时间（秒，默认300秒）
- `-cacheTimes`：与DNS服务商比对IP的间隔次数（默认1次，即每次检查都比对）
- `-noweb`：不启动Web服务（适用于纯配置文件方式）

示例：配置10分钟同步一次，自定义Web监听地址为`0.0.0.0:8080`

```bash
docker run -d \
  --name ddns-go \
  --restart=always \
  --net=host \
  -v /opt/ddns-go:/root \
  xxx.xuanyuan.run/jeessy/ddns-go:latest \
  -l 0.0.0.0:8080 -f 600
```

### 重置Web界面密码

若忘记Web界面密码，可通过以下命令重置（假设容器名为ddns-go）：

```bash
# 进入容器执行重置命令
docker exec ddns-go ./ddns-go -resetPassword 新密码

# 重启容器使配置生效
docker restart ddns-go
```

## 功能测试

### 访问Web管理界面

部署完成后，通过浏览器访问以下地址打开Web管理界面：
- Host网络模式：`http://主机IP:9876`
- 端口映射模式：`http://主机IP:9876`（若修改了映射端口则使用对应端口）

首次访问时，系统会要求设置管理员密码，设置完成后进入主配置界面。

### 初始化配置

基本配置步骤：

1. **选择DNS服务商**：从下拉列表选择您使用的域名服务商（如阿里云、Cloudflare等）
2. **配置API密钥**：根据服务商要求填写对应的API密钥/Token（需提前在域名服务商处创建）
3. **设置域名信息**：
   - 填写主域名（如`example.com`）
   - 填写子域名（如`www`或`@`表示主域名）
   - 选择记录类型（A记录对应IPv4，AAAA记录对应IPv6）
4. **IP获取方式**：
   - 默认使用公网接口获取IP
   - 可选择通过网卡或自定义命令获取（适用于特殊网络环境）
5. **高级设置**（可选）：
   - 同步间隔：修改IP检查频率（默认5分钟）
   - TTL：设置DNS记录的生存时间
   - Webhook：配置IP变更通知（支持钉钉、飞书、Telegram等）
6. **安全设置**：
   - 勾选`禁止从公网访问`（推荐），仅允许本地网络访问管理界面
7. **保存配置**：点击"保存"按钮应用配置

### 验证DDNS功能

配置完成后，可通过以下方式验证功能是否正常：

1. **查看运行日志**：
   在Web界面点击"日志"标签，查看最近50条操作日志，确认是否出现"更新IP成功"等类似信息。

2. **手动触发更新**：
   在Web界面点击"立即更新"按钮，观察日志输出，验证是否能成功获取IP并更新至DNS服务商。

3. **查询DNS记录**：
   使用`nslookup`或`dig`命令查询配置的域名，确认解析结果是否与当前公网IP一致：
   ```bash
   nslookup www.example.com  # 替换为您配置的域名
   dig A www.example.com +short  # 查看A记录（IPv4）
   dig AAAA www.example.com +short  # 查看AAAA记录（IPv6）
   ```

## 生产环境建议

### 持久化配置

确保配置文件持久化存储，避免容器重建导致配置丢失：
- 确认挂载目录权限正确：`chmod 755 /opt/ddns-go`
- 定期备份配置文件：`cp /opt/ddns-go/.ddns_go_config.yaml /opt/ddns-go/backup_$(date +%Y%m%d).yaml`

### 安全强化

1. **限制Web访问**：
   - 保持`禁止从公网访问`选项 enabled，仅允许本地网络访问管理界面
   - 如需公网访问，必须通过Nginx等反向代理启用HTTPS，示例Nginx配置：
     ```nginx
     server {
         listen 443 ssl;
         server_name ddns.example.com;
         
         ssl_certificate /path/to/cert.pem;
         ssl_certificate_key /path/to/key.pem;
         
         location / {
             proxy_pass http://127.0.0.1:9876;
             proxy_set_header Host $host;
             proxy_set_header X-Real-IP $remote_addr;
             # 限制访问IP
             allow 192.168.1.0/24;  # 允许内部网段
             deny all;              # 拒绝其他所有IP
         }
     }
     ```

2. **最小权限原则**：
   以非root用户运行容器，修改启动命令添加`--user`参数：
   ```bash
   # 先在主机创建用户和目录
   mkdir -p /opt/ddns-go && chown 1000:1000 /opt/ddns-go
   
   # 使用UID/GID运行容器
   docker run -d \
     --name ddns-go \
     --restart=always \
     --net=host \
     --user 1000:1000 \
     -v /opt/ddns-go:/root \
     xxx.xuanyuan.run/jeessy/ddns-go:latest
   ```

### 资源限制

为避免容器过度占用系统资源，可添加资源限制参数：

```bash
docker run -d \
  --name ddns-go \
  --restart=always \
  --net=host \
  -v /opt/ddns-go:/root \
  --memory=64m \
  --memory-swap=64m \
  --cpus=0.1 \
  xxx.xuanyuan.run/jeessy/ddns-go:latest
```

参数说明：
- `--memory=64m`：限制内存使用为64MB
- `--memory-swap=64m`：限制交换空间为64MB
- `--cpus=0.1`：限制CPU使用为0.1核（10%的单个CPU核心）

### 监控与日志

1. **容器状态监控**：
   使用`docker stats ddns-go`实时查看容器资源使用情况。

2. **日志持久化**：
   默认日志仅保存在内存中（最多50条），如需长期保存，可通过Docker日志驱动配置：
   ```bash
   docker run -d \
     --name ddns-go \
     --restart=always \
     --net=host \
     -v /opt/ddns-go:/root \
     --log-driver json-file \
     --log-opt max-size=10m \
     --log-opt max-file=3 \
     xxx.xuanyuan.run/jeessy/ddns-go:latest
   ```

3. **集成监控工具**：
   可通过Prometheus + Grafana或其他监控工具监控容器状态，需额外配置对应 exporter。

## 故障排查

### 容器无法启动

1. **检查容器状态**：
   ```bash
   docker ps -a | grep ddns-go  # 查看容器是否存在
   docker inspect ddns-go       # 查看容器详细配置
   ```

2. **查看启动日志**：
   ```bash
   docker logs ddns-go  # 查看容器启动日志，重点关注错误信息
   ```

3. **常见问题及解决**：
   - **权限问题**：挂载目录权限不足，执行`chmod 777 /opt/ddns-go`临时测试（生产环境建议使用最小权限）
   - **端口冲突**：9876端口被占用，使用`netstat -tulpn | grep 9876`查看占用进程，或修改映射端口
   - **镜像损坏**：删除镜像重新拉取，`docker rmi xxx.xuanyuan.run/jeessy/ddns-go:latest`后重新执行`docker pull`

### Web界面无法访问

1. **检查容器运行状态**：
   ```bash
   docker ps | grep ddns-go  # 确认容器处于运行状态
   ```

2. **验证端口监听**：
   ```bash
   netstat -tulpn | grep 9876  # 确认9876端口已被监听
   ```

3. **检查网络连通性**：
   - 本地测试：`curl http://127.0.0.1:9876`
   - 远程测试：从其他设备执行`telnet 主机IP 9876`检查端口是否可达

4. **查看应用日志**：
   ```bash
   docker exec -it ddns-go cat /root/ddns-go.log  # 查看应用详细日志
   ```

### DNS更新失败

1. **检查API密钥配置**：
   重新检查Web界面中DNS服务商的API密钥/Token是否正确，密钥是否具有足够权限。

2. **查看详细错误日志**：
   在Web界面"日志"标签或容器日志中查找具体错误信息，常见原因包括：
   - API密钥无效或权限不足
   - 域名格式错误（如未填写主域名或子域名）
   - 网络问题导致无法连接DNS服务商API

3. **测试API连通性**：
   在容器内测试是否能正常访问DNS服务商API：
   ```bash
   docker exec -it ddns-go curl https://alidns.aliyuncs.com  # 以阿里云为例
   ```

## 参考资源

### 官方资源
- [DDNS-GO GitHub仓库](https://github.com/jeessy2/ddns-go)：项目源代码及完整文档
- [DDNS-GO使用指南](https://github.com/jeessy2/ddns-go#特性)：官方详细配置说明
- [DDNS-GO常见问题(FAQ)](https://github.com/jeessy2/ddns-go/wiki/FAQ)：官方故障排查指南

### 轩辕镜像资源
- [DDNS-GO镜像文档（轩辕）](https://xuanyuan.cloud/r/jeessy/ddns-go)：轩辕镜像访问支持说明
- [DDNS-GO镜像标签列表](https://xuanyuan.cloud/r/jeessy/ddns-go/tags)：所有可用镜像版本

### 相关工具
- [DNS服务商API文档汇总](https://github.com/jeessy2/ddns-go/wiki/传递自定义参数)：各服务商API参数说明
- [Webhook配置示例](https://github.com/jeessy2/ddns-go/issues/327)：IP变更通知配置模板
- [IP获取命令参考](https://github.com/jeessy2/ddns-go/wiki/通过命令获取IP参考)：自定义IP获取方式示例

## 总结

本文详细介绍了DDNS-GO的Docker容器化部署方案，从环境准备、镜像拉取到容器部署、功能测试，提供了完整的实施指南。DDNS-GO作为一款轻量级动态域名解析工具，通过容器化部署可快速实现动态IP环境下的域名解析需求，支持多种DNS服务商和灵活的配置方式。

**关键要点**：
- 镜像拉取需使用轩辕访问支持地址`xxx.xuanyuan.run/jeessy/ddns-go:latest`
- 推荐使用Host网络模式部署，确保能获取准确的主机网络IP
- 配置文件通过挂载卷持久化，避免容器重建导致配置丢失
-"禁止从公网访问"选项是重要的安全措施，生产环境建议启用并配合反向代理使用
- 定期备份配置文件和监控容器运行状态，确保服务稳定运行

**后续建议**：
- 深入学习DDNS-GO高级特性，如多域名同时解析、自定义IP获取命令、Webhook通知等
- 根据网络环境调整IP检查间隔和缓存策略，平衡实时性与API调用频率
- 探索DNS服务商的高级功能，如通过自定义参数实现地域解析或多IP配置
- 结合监控工具（如Prometheus + Grafana）实现DDNS服务的可视化监控和告警
- 定期关注项目更新，及时升级镜像以获取新功能和安全修复

通过合理配置和优化，DDNS-GO可成为动态IP环境下域名解析的可靠解决方案，满足个人和小型企业的网络服务访问需求。


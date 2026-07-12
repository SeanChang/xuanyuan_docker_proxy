---
image: dockurr/dnsmasq
description: "Docker容器化的轻量级DNS转发器与DHCP服务器，用于便捷部署和管理小型网络的DNS及DHCP服务。"
source: https://xuanyuan.cloud/zh/r/dockurr/dnsmasq
canonical: https://xuanyuan.cloud/zh/r/dockurr/dnsmasq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dockurr/dnsmasq" title="dockurr/dnsmasq Docker 镜像中文简介、标签列表与拉取命令">dockurr/dnsmasq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# dockurr/dnsmasq 镜像文档

<div align="center">
<a href="https://github.com/dockur/dnsmasq"><img src="https://raw.githubusercontent.com/dockur/dnsmasq/master/.github/logo.png" title="Logo" style="max-width:100%;" width="256" /></a>
</div>

## 镜像概述与主要用途

dockurr/dnsmasq 是开源DNS服务器 [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) 的Docker容器化版本。该镜像提供了便捷部署的轻量级DNS服务，可用于本地网络的DNS解析、缓存及相关网络服务。


## 核心功能与特性

- **轻量级DNS服务**：基于dnsmasq实现，资源占用低，适合各类网络环境
- **上游DNS配置**：通过环境变量灵活设置上游DNS服务器
- **可扩展配置**：支持挂载外部配置文件目录扩展功能
- **完全自定义配置**：允许覆盖默认配置文件，实现深度定制
- **Docker化部署**：简化安装流程，支持跨平台运行


## 使用场景与适用范围

- 本地网络环境的DNS解析服务
- 家庭或小型办公网络的DNS服务器部署
- 开发/测试环境中的自定义DNS规则配置
- 需要快速搭建DNS服务的临时网络场景
- 替换系统默认DNS服务，实现更灵活的解析控制


## 使用方法

### Docker Compose 部署

```yaml
services:
  dnsmasq:
    image: docker.xuanyuan.run/dockurr/dnsmasq
    container_name: dnsmasq
    environment:
      DNS1: "1.0.0.1"  # 上游DNS服务器1
      DNS2: "1.1.1.1"  # 上游DNS服务器2
    ports:
      - 53:53/udp  # DNS UDP端口
      - 53:53/tcp  # DNS TCP端口
    cap_add:
      - NET_ADMIN  # 需添加网络管理权限
    restart: always  # 自动重启策略
```

### Docker CLI 部署

```bash
docker run -it --rm --name dnsmasq \
  -p 53:53/udp \
  -p 53:53/tcp \
  -e "DNS1=1.0.0.1" \
  -e "DNS2=1.1.1.1" \
  --cap-add=NET_ADMIN \
  docker.xuanyuan.run/dockurr/dnsmasq
```


## 配置说明

### 环境变量

| 环境变量 | 说明 | 默认值 |
|----------|------|--------|
| `DNS1`   | 主要上游DNS服务器地址 | - |
| `DNS2`   | 备用上游DNS服务器地址 | - |

**示例**：使用Cloudflare公共DNS服务器
```yaml
environment:
  DNS1: "1.0.0.1"
  DNS2: "1.1.1.1"
```

### 扩展配置文件

通过挂载包含 `*.conf` 文件的目录，可扩展默认配置：
```yaml
volumes:
  - ./dnsmasq.d/:/etc/dnsmasq.d/  # 本地目录挂载到容器配置目录
```
容器会自动加载该目录下所有 `.conf` 格式的配置文件。

### 覆盖主配置文件

如需完全自定义dnsmasq配置，可直接挂载自定义的 `dnsmasq.conf` 文件：
```yaml
volumes:
  - ./dnsmasq.conf:/etc/dnsmasq.conf  # 本地配置文件覆盖容器默认配置
```


## 常见问题

### 端口53已被占用

若主机上已有进程占用53端口，会出现类似以下错误：
```
Error response from daemon: driver failed programming external connectivity on endpoint dnsmasq (...): Error starting userland proxy: listen tcp4 0.0.0.0:53: bind: address already in use
```

**解决步骤**：

1. 检查占用53端口的进程：
   ```bash
   netstat -lnpt | grep -E ':53 +'
   ```
   示例输出：
   ```
   tcp    0    0 127.0.0.53:53    0.0.0.0:*    LISTEN    197/systemd-resolve
   ```

2. 针对systemd系统（如Ubuntu），可指定绑定特定IP地址：
   ```yaml
   ports:
     - "192.168.1.100:53:53/udp"  # 替换为实际IP
     - "192.168.1.100:53:53/tcp"
   ```

3. 其他情况需根据占用进程类型处理，可能需要禁用或卸载冲突的DNS服务（如bind、systemd-resolved等）。


## 镜像信息

- **项目地址**：[GitHub](https://github.com/dockur/dnsmasq)
- **Docker Hub**：[dockurr/dnsmasq](https://hub.docker.com/r/dockurr/dnsmasq)
- **最新版本**：[![Version](https://img.shields.io/docker/v/dockurr/dnsmasq/latest?arch=amd64&sort=semver&color=066da5)](https://hub.docker.com/r/dockurr/dnsmasq/tags)
- **镜像大小**：[![Size](https://img.shields.io/docker/image-size/dockurr/dnsmasq/latest?color=066da5&label=size)](https://hub.docker.com/r/dockurr/dnsmasq)
- **下载量**：[![Pulls](https://img.shields.io/docker/pulls/dockurr/dnsmasq.svg?style=flat&label=pulls&logo=docker)](https://hub.docker.com/r/dockurr/dnsmasq)

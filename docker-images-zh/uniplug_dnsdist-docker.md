---
image: uniplug/dnsdist-docker
description: "这是PowerDNS dnsdist的Docker镜像，提供DNS负载均衡能力，可智能路由流量、抵御DoS攻击与滥用行为，提升合法用户的DNS访问性能。"
source: https://xuanyuan.cloud/zh/r/uniplug/dnsdist-docker
canonical: https://xuanyuan.cloud/zh/r/uniplug/dnsdist-docker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/uniplug/dnsdist-docker" title="uniplug/dnsdist-docker Docker 镜像中文简介、标签列表与拉取命令">uniplug/dnsdist-docker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# dnsdist Docker镜像

[![](https://badge.imagelayers.io/uniplug/dnsdist-docker:latest.svg)](https://imagelayers.io/?images=uniplug/dnsdist-docker:latest '获取你自己的imagelayers.io徽章')
[![Docker Repository on Quay](https://quay.io/repository/uniplug/dnsdist/status "Quay上的Docker仓库")](https://quay.io/repository/uniplug/dnsdist)


本仓库包含PowerDNS [dnsdist](http://dnsdist.org/)的Docker镜像。

> dnsdist是一款高度感知DNS、DoS攻击和滥用行为的负载均衡器。其核心目标是将流量路由到最优服务器，为合法用户提供顶级性能，同时分流或阻止滥用流量。

* Docker镜像地址：[uniplug/dnsdist-docker](https://hub.docker.com/r/uniplug/dnsdist-docker/)
* GitHub仓库地址：[uniplug/dnsdist-docker](https://github.com/uniplug/dnsdist-docker)

## 镜像概述
该镜像封装了PowerDNS dnsdist工具，旨在简化DNS负载均衡服务的部署与管理。通过Docker容器化方式，用户可快速搭建具备高可用性、抗攻击能力的DNS流量管理节点。

## 核心功能
1. **DNS负载均衡**：支持多种路由策略（如firstAvailable），将DNS请求分发到最优后端服务器
2. **DoS与滥用防护**：识别并拦截DNS层面的恶意流量，保障服务稳定
3. **Web管理界面**：提供基于Web的管理入口，方便监控与配置
4. **灵活配置**：支持通过自定义配置文件调整路由规则、后端服务器等参数

## 使用场景
1. **DNS服务高可用部署**：为多台DNS服务器提供负载均衡，提升服务可靠性
2. **流量优化**：智能路由DNS请求，降低后端服务器负载
3. **安全防护**：抵御DNS放大攻击、DDoS等恶意行为，保护DNS服务安全

## 配置说明
### 基础部署
创建并启动名为`dnsdist`的容器，映射主机53端口（TCP/UDP）：
```bash
docker run -t --name dnsdist -p 53:53/tcp -p 53:53/udp docker.xuanyuan.run/uniplug/dnsdist-docker
```

### 自定义配置
将主机目录映射到容器内的`/etc/dnsdist/`目录，以使用自定义配置文件：
```bash
docker run -t \
 --name dnsdist \
 -v /data/dnsdist/:/etc/dnsdist/ \
 -p 53:53/udp \
 docker.xuanyuan.run/uniplug/dnsdist-docker
```

### 结合反向代理的服务示例
以下是使用`jwilder/nginx-proxy`作为Web管理界面反向代理的systemd服务配置：

#### 自定义配置文件（/data/dnsdist/dnsdist.conf）
```Lua
newServer{address="8.8.8.8", order=1}
newServer{address="77.88.8.8", order=2}
newServer{address="77.88.8.1", order=3}
setServerPolicy(firstAvailable)

setLocal('0.0.0.0')

webserver("0.0.0.0:80", "supersicret_pass_11")
```

#### Systemd服务单元（/etc/systemd/system/dnsdist.service）
```ini
[Unit]
Description=dnsdist
After=docker.service nginx-proxy.service
Requires=docker.service nginx-proxy.service

[Service]
KillMode=none
ExecStartPre=-/usr/bin/docker kill dnsdist
ExecStartPre=-/usr/bin/docker rm dnsdist
ExecStart=/usr/bin/docker run -t \
          --name dnsdist \
          -p 53:53/tcp \
          -p 53:53/udp \
          -v /data/dnsdist/:/etc/dnsdist/ \
          -e VIRTUAL_HOST=dnsdist.example.com \
          uniplug/dnsdist-docker
ExecStop=-/usr/bin/docker stop dnsdist

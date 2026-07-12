---
image: bytesizedalex/nmap
description: "基于Alpine Linux的Nmap网络扫描工具镜像，用于网络发现、端口扫描、服务版本检测及安全审计，帮助用户快速获取网络资产信息。"
source: https://xuanyuan.cloud/zh/r/bytesizedalex/nmap
canonical: https://xuanyuan.cloud/zh/r/bytesizedalex/nmap
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bytesizedalex/nmap" title="bytesizedalex/nmap Docker 镜像中文简介、标签列表与拉取命令">bytesizedalex/nmap 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker镜像：bytesizedalex/nmap

## 镜像概述
本镜像基于轻量级Alpine Linux系统，集成开源网络扫描工具Nmap（Network Mapper）。Nmap是一款广泛应用于网络发现与安全审计的工具，支持多种扫描技术，帮助用户高效获取网络资产状态。

## 核心功能
- 主机发现：识别网络中活跃的主机
- 端口扫描：检测目标主机开放的端口及服务状态
- 服务版本检测：识别开放端口上运行的服务及其版本信息
- OS检测：推测目标主机的操作系统类型及版本
- 脚本扫描：通过NSE（Nmap脚本引擎）扩展漏洞检测、服务枚举等高级功能

## 使用场景
- 系统管理员：进行网络资产 inventory、定期安全审计
- 开发/测试人员：验证服务端口是否正常开放
- 安全工程师：评估网络暴露面，发现潜在安全风险

## 配置说明
Nmap支持丰富的命令行参数，常见配置包括：
- `-sn`：仅主机发现，不扫描端口
- `-p <port范围>`：指定扫描端口（如 `-p 80,443` 或 `-p 1-65535`）
- `-sV`：启用服务版本检测
- `-O`：启用操作系统检测
- `-A`：综合扫描（含OS检测、版本检测、脚本扫描及traceroute）

## 部署示例
### 端口扫描示例
扫描目标IP `192.168.2.25` 的25端口：
```bash
docker run docker.xuanyuan.run/bytesizedalex/nmap 192.168.2.25 -p 25
```

### 常用端口扫描
扫描目标IP `192.168.1.5` 的开放端口：
```bash
docker run docker.xuanyuan.run/bytesizedalex/nmap 192.168.1.5
```

### 主机发现示例
识别 `192.168.0.0/24` 网络中的活跃主机：
```bash
docker run docker.xuanyuan.run/bytesizedalex/nmap -sn 192.168.0.0/24
```

更多参数请参考Nmap官方文档：https://nmap.org/book/man-briefoptions.html

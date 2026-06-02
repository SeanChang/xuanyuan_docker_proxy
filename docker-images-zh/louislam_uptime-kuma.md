---
image: louislam/uptime-kuma
description: "一款美观的自托管监控工具，用于监控网站、服务等的运行状态，支持本地部署和数据持久化存储。"
source: https://xuanyuan.cloud/zh/r/louislam/uptime-kuma
canonical: https://xuanyuan.cloud/zh/r/louislam/uptime-kuma
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/louislam/uptime-kuma" title="louislam/uptime-kuma Docker 镜像中文简介、标签列表与拉取命令">louislam/uptime-kuma — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/louislam/uptime-kuma" title="louislam/uptime-kuma Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/louislam/uptime-kuma</a>

# Uptime Kuma

Uptime Kuma 是一款美观的自托管监控工具，可用于监控网站、服务器、API 等各类服务的运行状态。支持本地部署，数据存储在本地，确保用户对监控数据的完全控制和隐私保护。

## 标签说明

| 标签(s)               | 描述                                                                 |
|-----------------------|----------------------------------------------------------------------|
| latest, 1, 1.*        | 最新稳定版 - Debian 基础镜像                                          |
| debian, 1-debian, 1.*-debian | 最新稳定版 - Debian 基础镜像                                      |
| ❌alpine, 1-alpine, 1.*-alpine | （❌因 DNS 问题已弃用）最新稳定版 - Alpine 基础镜像                 |
| beta, *-beta.*        | 测试版，包含新功能预览或供测试使用，可能存在不稳定情况                   |
| nightly*              | 开发构建版，基于最新开发代码，稳定性较差                               |

## 使用方法

### Docker 部署

#### 基础部署
```bash
# 创建数据卷（用于持久化存储监控数据）
docker volume create uptime-kuma

# 启动容器
docker run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1
```

部署完成后，Uptime Kuma 服务将运行在 `http://localhost:3001`。

#### 自定义端口和数据存储路径
如需更改默认端口或数据存储位置，可使用以下命令：
```bash
docker run -d --restart=always -p <自定义端口>:3001 -v <自定义目录或卷>:/app/data --name uptime-kuma louislam/uptime-kuma:1
```
其中 `<自定义端口>` 替换为实际需要使用的端口号，`<自定义目录或卷>` 替换为本地目录路径或数据卷名称。

## 源代码或非 Docker 安装
如需通过源代码或其他非 Docker 方式安装，请参考项目官方文档：https://github.com/louislam/uptime-kuma

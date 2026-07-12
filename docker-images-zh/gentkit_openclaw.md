---
image: gentkit/openclaw
description: "用于快速简便部署OpenClaw（\"lobster🦞\" AI智能体）的轻量级Docker镜像。"
source: https://xuanyuan.cloud/zh/r/gentkit/openclaw
canonical: https://xuanyuan.cloud/zh/r/gentkit/openclaw
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gentkit/openclaw" title="gentkit/openclaw Docker 镜像中文简介、标签列表与拉取命令">gentkit/openclaw 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenClaw Docker镜像

轻量级Docker镜像，用于快速简便地部署OpenClaw（"lobster🦞" AI智能体）。

## 标签命名规范

| 镜像名           | 标签                      | 描述                                                               |
|------------------|---------------------------|--------------------------------------------------------------------|
| gentkit/openclaw | <OPENCLAW_VERSION>-alpine | 基于Alpine Linux的OpenClaw <OPENCLAW_VERSION>版本（基于gentkit/alpine:latest） |
| gentkit/openclaw | latest-alpine             | 基于Alpine Linux的当前OpenClaw版本（基于gentkit/alpine:latest）    |

## 安装Docker环境

[安装指南](https://github.com/lentiancn/open-docs/blob/main/en/Docker/2.Installation-Guide.md)

## 安装OpenClaw容器

步骤 1：

```shell
sudo mkdir -p /usr/local/openclaw
```

步骤 2：

```shell
# 生成并记住你的令牌
# 在[步骤 3]中替换YOUR_TOKEN，并在首次设置时用于http://localhost:18789
# 必须完全匹配
sudo apt install openssl && openssl rand -hex 32
```

步骤 3：

```shell
sudo docker run -d \
-p 18789:18789 \
-v /usr/local/openclaw:/root/.openclaw:rw \
-e GATEWAY_TOKEN=<YOUR_TOKEN> \
--restart unless-stopped \
--name OpenClaw \
gentkit/openclaw:latest
```

**注意**：建议将 **/root/.openclaw** 设置为卷，以确保你的OpenClaw数据可在主机上备份。

**GATEWAY_TOKEN** 可设置为你偏好的任何值（可通过 **openssl rand -hex 32** 获取）。如果未提供，系统将默认通过 **openssl rand -hex 32** 生成。

## 管理OpenClaw

### OpenClaw主目录

```shell
ls -l ~/.openclaw
```

### 修改OpenClaw配置

```shell
# 进入Docker容器
docker exec -it <你的容器ID或容器名称> /bin/bash

# 查看或编辑配置
vi ~/.openclaw/openclaw.json
```

### OpenClaw网关状态

```shell
# 启动OpenClaw网关
docker start <你的容器ID或名称>

# 停止OpenClaw网关
docker stop <你的容器ID或名称>
```

### 访问OpenClaw网关UI

    http://localhost:18789

## 附录

[常见问题](FAQ.md)

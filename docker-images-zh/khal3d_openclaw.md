---
image: khal3d/openclaw
description: "OpenClaw Gateway的Docker镜像，用于在本地运行OpenClaw Gateway服务，暴露UI/API和Bridge端口，并通过挂载卷持久化配置数据。"
source: https://xuanyuan.cloud/zh/r/khal3d/openclaw
canonical: https://xuanyuan.cloud/zh/r/khal3d/openclaw
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/khal3d/openclaw" title="khal3d/openclaw Docker 镜像中文简介、标签列表与拉取命令">khal3d/openclaw 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenClaw (Gateway) — Docker镜像

该镜像通过Docker在本地运行**OpenClaw Gateway**，暴露Gateway UI/API和Bridge端口，并通过挂载卷持久化OpenClaw配置数据。

完整README.md文档请访问：https://github.com/khal3d/openclaw

## 镜像概述和主要用途
OpenClaw Gateway Docker镜像提供了一种便捷的方式在本地部署和运行OpenClaw Gateway服务，适用于需要本地管理和运行OpenClaw AI代理的场景，支持UI/API访问和设备桥接功能，并确保配置数据持久化存储。

## 核心功能和特性
- 暴露Gateway UI/API和Bridge端口，支持服务访问
- 通过挂载卷实现配置数据持久化
- 支持环境变量配置认证 token
- 提供容器内初始化和管理命令

## 端口说明
- **18789** — Gateway UI/API端口
- **18791** — Bridge端口

## 持久化数据
需挂载本地文件夹以持久化OpenClaw配置数据：
- 容器内路径：`/root/.openclaw`

示例主机路径：
- `./data/openclaw-config`（当前目录下的data/openclaw-config文件夹）

## 使用方法

### 运行命令
```bash
docker run -it --rm \
  -p 18789:18789 \
  -p 18791:18791 \
  -e OPENCLAW_GATEWAY_TOKEN="<token>" \
  -v "$(pwd)/data/openclaw-config:/root/.openclaw" \
  docker.xuanyuan.run/khal3d/openclaw:latest
```

### 必填环境变量
- `OPENCLAW_GATEWAY_TOKEN` — Control UI使用的Gateway认证令牌

### 首次设置（容器内）
```bash
openclaw setup          # 初始化工作区（位于/root/.openclaw）
openclaw dashboard      # 启动仪表盘，输出访问URL
openclaw devices list   # 列出设备
openclaw devices approve <REQUEST_ID>  # 批准设备请求
openclaw configure      # 配置服务
```

## 注意事项
- `openclaw dashboard`命令会输出带令牌的访问URL，格式如下：  
  `http://localhost:18789/?token=...`
- `openclaw setup`命令会在`/root/.openclaw`路径下初始化工作区，需确保挂载卷有写入权限

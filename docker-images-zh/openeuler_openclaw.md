---
image: openeuler/openclaw
description: "OpenClaw是一款可在个人设备上运行的AI助手，支持WhatsApp、Telegram、Slack、Discord等多种消息渠道，由openEuler CloudNative SIG维护。"
source: https://xuanyuan.cloud/zh/r/openeuler/openclaw
canonical: https://xuanyuan.cloud/zh/r/openeuler/openclaw
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/openclaw" title="openeuler/openclaw Docker 镜像中文简介、标签列表与拉取命令">openeuler/openclaw — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openeuler/openclaw" title="openeuler/openclaw Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/openclaw</a>

# OpenClaw Docker镜像文档

## 快速参考

- 官方[OpenClaw](https://openclaw.ai/) Docker镜像。
- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)。
- 帮助渠道：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler](https://gitee.com/openeuler/community)。

## 什么是OpenClaw

OpenClaw是一款可在个人设备上运行的AI助手，支持多种消息渠道，包括WhatsApp、Telegram、Slack、Discord等。

详见：https://openclaw.ai/

## 支持的标签及对应Dockerfile链接

`openclaw` Docker镜像的标签由完整的软件栈版本组成，具体如下：

| 标签 | 描述 |
|-----|-------------|
| [2026.3.2-oe2403ltssp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/openclaw/2026.3.2/24.03-lts-sp3/Dockerfile) | 基于openEuler 24.03-LTS-SP3的OpenClaw 2026.3.2版本 |

## 快速开始

用户可根据需求选择相应的`{Tag}`和容器启动选项。

### 1. 拉取镜像

```bash
docker pull openeuler/openclaw:{Tag}
```

### 2. 运行设置向导

```bash
docker run -it --name my-openclaw openeuler/openclaw:{Tag} onboard --install-daemon
```

### 3. 启动容器

```bash
docker start my-openclaw
```

### 4. 运行网关（终端1）

```bash
docker exec -it my-openclaw openclaw gateway run
```

### 5. 启动终端用户界面客户端（终端2）

```bash
docker exec -it my-openclaw openclaw tui
```

## 容器选项

| 选项 | 描述 |
|--------|-------------|
| `--name my-openclaw` | 将容器命名为`my-openclaw`。 |
| `-it` | 以交互模式启动容器并分配终端。 |
| `openeuler/openclaw:{Tag}` | 指定要运行的Docker镜像。将`{Tag}`替换为具体版本标签。 |

## 问答

如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

---
image: 1panel/openclaw
description: "运行在个人设备上的跨平台AI助理，支持飞书、钉钉、企业微信等多种沟通渠道，可7x24小时本地运行。"
source: https://xuanyuan.cloud/zh/r/1panel/openclaw
canonical: https://xuanyuan.cloud/zh/r/1panel/openclaw
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/1panel/openclaw" title="1panel/openclaw Docker 镜像中文简介、标签列表与拉取命令">1panel/openclaw 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## OpenClaw Docker镜像文档

### 镜像概述
本镜像由GitHub Action基于OpenClaw官方代码自动打包构建，源码仓库地址：[https://github.com/1Panel-dev/runtime](https://github.com/1Panel-dev/runtime)。

### OpenClaw简介
OpenClaw是一款可部署在个人设备上的AI助理，支持在多种沟通渠道中与用户交互，包括但不限于：飞书、钉钉、企业微信、QQ、WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams及WebChat等。其核心优势在于可实现本地7x24小时持续运行，满足个人AI助理的日常使用需求。

### 1Panel简介
1Panel是一款提供直观Web管理界面的Linux服务器管理工具，支持对智能体、大模型、网站、数据库、容器、文件及计划任务等进行统一管理。通过1Panel应用商店可简化OpenClaw的安装部署流程。

### 核心功能与特性
- **多渠道支持**：兼容主流即时通讯平台，实现跨渠道统一交互
- **本地部署**：运行于个人设备，保障数据隐私与自主控制
- **持续运行**：支持7x24小时稳定运行，无需人工干预
- **轻量化设计**：适配多种操作系统与硬件环境

### 使用场景
- 个人日常事务管理与信息查询
- 多平台消息统一处理与自动回复
- 24小时在线的私人AI助手服务
- 企业/团队内部跨平台沟通辅助工具

### 使用方法
#### 通过1Panel安装（推荐）
1. 登录1Panel管理界面
2. 进入应用商店，搜索"OpenClaw"
3. 按照引导完成安装配置

详细安装教程参考1Panel官方文档：[https://1panel.cn/docs/v2/user_manual/appstore/openclaw/](https://1panel.cn/docs/v2/user_manual/appstore/openclaw/)

#### 手动部署（需自行配置环境）
可通过Docker命令直接运行（具体参数需参考官方配置文档）：
```bash
docker run -d --name openclaw --restart always [配置参数] 1panel-dev/runtime:latest
```

> 注：手动部署需自行配置通讯渠道密钥、AI模型连接等参数，建议优先通过1Panel进行部署以获得最佳体验。

---
image: kokojacket/baidu-autosave
description: "基于Flask的百度网盘自动转存系统，支持多用户管理、定时任务调度、通知推送及自动转存分享链接，提供美观的Web界面和任务状态监控。"
source: https://xuanyuan.cloud/zh/r/kokojacket/baidu-autosave
canonical: https://xuanyuan.cloud/zh/r/kokojacket/baidu-autosave
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kokojacket/baidu-autosave" title="kokojacket/baidu-autosave Docker 镜像中文简介、标签列表与拉取命令">kokojacket/baidu-autosave 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 百度网盘自动转存

[![GitHub](https://img.shields.io/badge/GitHub-baidu--autosave-blue?logo=github)](https://github.com/kokojacket/baidu-autosave)

一个基于 Flask 的百度网盘自动转存系统，支持多用户管理、定时任务调度和通知推送。

## 🚀 快速开始

### 使用 docker-compose（推荐）

```yaml
version: '3'
services:
  baidu-autosave:
    image: docker.xuanyuan.run/kokojacket/baidu-autosave:latest
    container_name: baidu-autosave
    restart: unless-stopped
    ports:
      - "5000:5000"
    volumes:
      - ./config:/app/config
      - ./log:/app/log
    environment:
      - TZ=Asia/Shanghai
```

### 使用 Docker CLI

```bash
docker run -d \
  --name baidu-autosave \
  --restart unless-stopped \
  -p 5000:5000 \
  -v $(pwd)/config:/app/config \
  -v $(pwd)/log:/app/log \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/kokojacket/baidu-autosave:latest
```

## 📝 默认登录信息
- 账号：admin
- 密码：admin123

## ✨ 主要特性

- 🔄 自动转存：支持自动转存百度网盘分享链接到指定目录
- 👥 多用户管理：支持添加多个百度网盘账号
- ⏰ 定时任务：支持全局定时和单任务定时规则
- 📱 消息推送：支持多种通知方式（目前支持PushPlus）
- 🎯 任务分类：支持对任务进行分类管理
- 📊 状态监控：实时显示任务执行状态和进度
- 🔍 智能去重：自动跳过已转存的文件
- 🎨 美观界面：响应式设计，支持移动端访问

## 📂 目录说明
- `/app/config`：配置文件目录
- `/app/log`：日志目录

## 🔗 环境变量
- `TZ`：时区设置，默认 Asia/Shanghai

## 🌐 端口
- `5000`：Web 界面访问端口

## 📦 版本
- latest：最新版本，持续更新

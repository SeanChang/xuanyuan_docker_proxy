---
image: wantcat/trendradar
description: "TrendRadar 是一款多平台热点聚合与智能推送助手，从知乎、抖音、B 站、微博、百度热搜等渠道采集热点，并通过企业微信、飞书、钉钉、Telegram、邮件、ntfy 等通道按关键词与时间窗口智能推送，适合投资者、自媒体人和关注时事的用户以“少刷屏、看重点”的方式获取高价值资讯。"
source: https://xuanyuan.cloud/zh/r/wantcat/trendradar
canonical: https://xuanyuan.cloud/zh/r/wantcat/trendradar
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wantcat/trendradar" title="wantcat/trendradar Docker 镜像中文简介、标签列表与拉取命令">wantcat/trendradar 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TrendRadar 多平台热点聚合助手

## 概述

`wantcat/trendradar` 是一款**多平台热点聚合与智能推送助手**，以轻量、易部署为目标，支持从知乎、抖音、B 站、微博、百度热搜、华尔街见闻等多个平台抓取热点数据，并通过企业微信、飞书、钉钉、Telegram、邮件、ntfy 等通道进行智能推送，帮助你在最短时间内掌握真正关心的新闻资讯。

项目同时提供 GitHub Pages 网页视图、Docker 部署方案和 MCP（Model Context Protocol）接入，适合开发者、自媒体人、投资者等不同用户群体使用。

> Docker Hub 页面：`https://hub.docker.com/r/wantcat/trendradar`

## 核心特性

### 1. 全网热点聚合

默认监控 11 个主流平台（如知乎、抖音、Bilibili 热搜、华尔街见闻、贴吧、百度热搜、财联社热门、澎湃新闻、凤凰网、今日头条、微博等），并支持：

- 在配置文件 `config/config.yaml` 中自定义监控平台列表；
- 基于 `newsnow` 项目的 API 获取多平台数据；
- 通过简单的 YAML 配置添加更多平台：

```yaml
platforms:
  - id: "toutiao"
    name: "今日头条"
  - id: "baidu"
    name: "百度热搜"
  - id: "wallstreetcn-hot"
    name: "华尔街见闻"
```

### 2. 智能推送策略

内置三种推送模式，适配不同使用人群：

- **当日汇总（daily）**：按时推送（默认每小时一次），展示当日所有匹配新闻 + 新增新闻区域，适合企业管理者/普通用户做日报回顾；
- **当前榜单（current）**：按时推送当前榜单匹配新闻 + 新增新闻区域，适合自媒体人、内容创作者实时追热点；
- **增量监控（incremental）**：仅在有新增匹配内容时推送，适合投资者/交易员等高频监控但不希望被重复信息打扰的场景。

此外支持**推送时间窗口控制**：

- 只在指定时间段内推送（如 09:00–18:00 或 20:00–22:00）；
- 可配置“窗口内每次执行都推送”或“每天仅推送一次”；
- 通过 `config/config.yaml` 中的 `push_window.enabled` 开关启用。

### 3. 精准内容筛选（frequency_words.txt）

通过 `frequency_words.txt` 配置关注关键词，实现对热点内容的精准筛选：

- 支持三种语法：
  - 普通词：基础匹配（如 `华为`）
  - 必须词：`+词`，必须同时出现（如 `+手机`）
  - 过滤词：`!词`，出现即排除（如 `!广告`）
- 支持**词组化管理**：通过空行分隔词组，每个词组独立统计，用于区分不同主题（如手机新品、股市行情、赛事类话题等）。
- 关键词顺序影响优先级，可根据关注度调整排序。

### 4. 热点趋势分析

TrendRadar 不仅告诉你“什么在热搜”，还关注“热点如何演变”，包括：

- 记录每条新闻从首次出现到最后出现的时间段；
- 统计排名变化、出现频次，区分一次性热点与持续发酵话题；
- 标记本轮新增热点（🆕），并以分组形式展示；
- 支持跨平台对比同一话题在不同平台的表现差异。

支持通过权重配置（`rank_weight`、`frequency_weight`、`hotness_weight`）自定义热点排序逻辑：

- 追求“实时热点”：排名权重大、频次权重小；
- 追求“深度趋势”：频次权重大、排名权重适中；
- 三个权重之和必须为 1.0，建议每次微调 0.1–0.2 观察效果。

### 5. 多渠道推送与多端适配

- 推送通道：企业微信（含间接微信推送方案）、飞书、钉钉、Telegram、邮件、ntfy；
- 网页端：基于 GitHub Pages 的报告页面，适配 PC/移动端，可导出或截图分享；
- 数据持久化：支持 HTML/TXT 等多格式历史记录保存，便于归档与回溯。

### 6. AI 智能分析（MCP 支持）

- 基于 MCP 协议提供 13 种分析工具，支持：
  - 基础查询（按时间/平台筛选热点）、
  - 智能检索与历史回溯、
  - 趋势分析与生命周期分析、
  - 相似新闻查找与跨平台对比、
  - 情感与风险分析等；
- 可在 Cherry Studio、Claude Desktop、Cursor、Cline 等支持 MCP 的客户端中，以对话形式查询 TrendRadar 数据，告别手动翻阅原始文件。

### 7. 零门槛与去 App 化

- 30 秒 GitHub Pages 部署：Fork 仓库后启用 Pages 即可得到一个自动更新的网页版热点面板；
- 1 分钟企业微信部署：即可把热点摘要推送到手机；
- 通过统一的热点源替代刷多个资讯 App，从“被推荐”变为“主动订阅自己关心的信息”。

## 使用场景

- **投资者 / 交易员**：通过增量监控和高频推送，第一时间捕捉与持仓或行业相关的重大新闻；
- **自媒体 / 内容创作者**：追踪全网热点与话题演变，为选题与内容策划提供数据依据；
- **企业公关与品牌侧**：监控品牌、竞品及行业关键词相关的舆情动态；
- **关心时事的普通用户**：用更干净、可控的方式获取资讯，减少在各类 App 中无效刷屏。

## Docker 快速启动示例

```bash
docker pull wantcat/trendradar

# 简易运行示例（实际使用中建议挂载配置与数据目录）
docker run -d \
  --name trendradar \
  -e TZ=Asia/Shanghai \
  wantcat/trendradar:latest
```

更多高级配置（推送通道、关键词、平台列表、MCP 接入等）请参考项目源码与文档，在 `config/config.yaml`、`frequency_words.txt` 等文件中按需调整。

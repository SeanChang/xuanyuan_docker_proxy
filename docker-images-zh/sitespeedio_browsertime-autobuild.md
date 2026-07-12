---
image: sitespeedio/browsertime-autobuild
description: "Browsertime Docker镜像用于自动化在浏览器中运行JavaScript以收集网页性能指标，支持Chrome、Firefox等多种浏览器，可记录屏幕视频并计算视觉指标（如Speed Index），生成HAR文件及性能数据JSON，适用于独立性能测试或集成到其他工具中。"
source: https://xuanyuan.cloud/zh/r/sitespeedio/browsertime-autobuild
canonical: https://xuanyuan.cloud/zh/r/sitespeedio/browsertime-autobuild
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sitespeedio/browsertime-autobuild" title="sitespeedio/browsertime-autobuild Docker 镜像中文简介、标签列表与拉取命令">sitespeedio/browsertime-autobuild 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Browsertime - 您的浏览器，您的页面，您的脚本！

![Run Docker](https://github.com/sitespeedio/browsertime/workflows/Run%20Docker/badge.svg?branch=main)
![Unit tests](https://github.com/sitespeedio/browsertime/workflows/Unit%20tests/badge.svg?branch=main)
![Windows Edge](https://github.com/sitespeedio/browsertime/workflows/Windows%20Edge/badge.svg?branch=main)
![OSX Safari](https://github.com/sitespeedio/browsertime/workflows/OSX%20Safari/badge.svg?branch=main)
![Linux browsers](https://github.com/sitespeedio/browsertime/workflows/Linux%20browsers/badge.svg?branch=main)
[![Downloads][downloads-image]][downloads-url]
[![Downloads total][downloads-total-image]][downloads-url]
[![Stars][stars-image]][stars-url]

[文档](https://www.sitespeed.io/documentation/browsertime/) | [更新日志](https://github.com/sitespeedio/browsertime/blob/main/CHANGELOG.md)

![Browsertime](browsertime.png)

从浏览器获取Web性能时间线，直接在终端中！

## 概述

**Browsertime允许您*在浏览器中自动化运行JavaScript*，主要用于收集性能指标。这具体意味着什么？**

我们认为Browsertime具有四个关键能力：

- 处理与浏览器相关的所有事务（Firefox/Chrome/Edge/Safari及其他可通过WebDriver驱动的浏览器）。
- 当URL在浏览器中加载完成后，执行一批默认且可配置的JavaScript。
- 记录浏览器屏幕视频，用于计算[视觉指标](https://github.com/WPO-Foundation/visualmetrics)。
- 允许您运行[脚本文件来创建和测量用户旅程](https://www.sitespeed.io/documentation/sitespeed.io/scripting/)。

**Browsertime的用途是什么？**

它通常用于两种场景：

- 作为独立工具运行，收集网站的性能计时指标。
- 集成到您的工具中作为JavaScript运行器，收集所需的任何JavaScript指标/信息。

## 核心功能和特性

- **多浏览器支持**：支持Firefox、Chrome、Edge（Chromium版本）、Safari及移动设备上的Chrome和Firefox。
- **全面性能指标收集**：包括导航计时、用户计时、元素计时、绘制计时、Google Web Vitals和CPU长任务等。
- **视频录制与视觉指标**：通过FFMPEG录制屏幕视频，计算Speed Index、首次视觉变化和最后视觉变化等视觉指标。
- **HAR文件生成**：记录页面所有请求/响应的HAR文件。
- **浏览器内部跟踪日志**：支持Firefox的geckoProfiler和Chromium浏览器的timeline跟踪。
- **自定义脚本支持**：可编写Selenium测试脚本模拟复杂用户场景（如登录、购物车操作）。
- **网络连接控制**：支持网络节流，模拟不同网络环境。
- **WebPageReplay集成**：本地重放页面，消除服务器延迟，便于前端回归测试。

## 使用场景和适用范围

- **网站性能监控**：定期测试网站性能，跟踪关键指标变化。
- **前端性能优化**：开发过程中评估优化效果，定位性能瓶颈。
- **用户体验测试**：模拟真实用户场景，测量视觉加载性能。
- **持续集成/持续部署**：集成到CI/CD流程中，自动检测性能回归。
- **移动设备性能测试**：测试移动浏览器上的页面性能。

## 使用方法和配置说明

### 基本使用示例

使用Docker镜像（包含Chrome、Firefox、Edge、XVFB及视频录制所需依赖）：

```bash
$ docker run --rm -v "$(pwd)":/browsertime sitespeedio/browsertime https://www.sitespeed.io/
```

或使用Node.js：

```bash
$ npm install browsertime -g
$ browsertime https://www.sitespeed.io/
```

以上命令会在Chrome中加载https://www.sitespeed.io/三次，结果（timing数据JSON文件、HAR文件）存储在`browsertime-results/www.sitespeed.io/$date/`目录下。

### Docker测试本地构建

```bash
$ docker build -t sitespeedio/browsertime .
$ docker run --rm -v "$(pwd)":/browsertime sitespeedio/browsertime -n 1 https://www.sitespeed.io/
```

### 网络连接控制

可通过Docker网络桥接或使用Throttle引擎进行网络节流，详细配置见[文档](https://www.sitespeed.io/documentation/sitespeed.io/connectivity/)。

### 自定义脚本导航

对于复杂测试场景（如登录、购物流程），可编写自定义Selenium脚本。详细说明见[脚本文档](https://www.sitespeed.io/documentation/sitespeed.io/scripting/)。

### 移动设备测试

#### Android设备测试

需先[安装adb](https://www.sitespeed.io/documentation/sitespeed.io/mobile-phones/#desktop)并[准备设备](https://www.sitespeed.io/documentation/sitespeed.io/mobile-phones/#on-your-phone)。

**直接运行（非Docker）**：

```bash
$ browsertime --chrome.android.package com.android.chrome https://www.sitespeed.io --video --visualMetrics
```

**使用Docker（Linux环境）**：

```bash
$ docker run --privileged -v /dev/bus/usb:/dev/bus/usb -e START_ADB_SERVER=true --rm -v "$(pwd)":/browsertime-results sitespeedio/browsertime -n 1 --android --visualMetrics --video https://en.m.wikipedia.org/wiki/Barack_Obama
```

> 注意：需使用`--privileged`模式并挂载USB总线（`-v /dev/bus/usb:/dev/bus/usb`），或指定具体设备端口。

### WebPageReplay使用

WebPageReplay可本地重放页面，消除服务器延迟，便于前端回归测试。

**Chrome默认配置**：

```bash
docker run --cap-add=NET_ADMIN --rm -v "$(pwd)":/browsertime -e REPLAY=true -e LATENCY=100 docker.xuanyuan.run/sitespeedio/browsertime:12.0.0 https://en.wikipedia.org/wiki/Barack_Obama
```

**Firefox配置**：

```bash
docker run --cap-add=NET_ADMIN --rm -v "$(pwd)":/browsertime -e REPLAY=true -e LATENCY=100 docker.xuanyuan.run/sitespeedio/browsertime:12.0.0 -b firefox -n 11 --firefox.acceptInsecureCerts https://en.wikipedia.org/wiki/Barack_Obama
```

**Android Chrome配置**：

```bash
docker run --privileged -v /dev/bus/usb:/dev/bus/usb -e START_ADB_SERVER=true --cap-add=NET_ADMIN --rm -v "$(pwd)":/browsertime -e REPLAY=true -e LATENCY=100 docker.xuanyuan.run/sitespeedio/browsertime https://en.m.wikipedia.org/wiki/Barack_Obama --android --chrome.args ignore-certificate-errors-spki-list=PhrPvGIaAMmd29hj8BCZOq096yj7uMpRNHpn5PDxI6I= -n 11 --chrome.args user-data-dir=/data/tmp/chrome
```

### 发送指标到Graphite

使用`jq`提取指标并发送到Graphite：

```bash
echo "browsertime.your.key.SpeedIndex.median" $(cat /tmp/browsertime/browsertime.json | jq .[0].statistics.visualMetrics.SpeedIndex.median) "`date +%s`" | nc -q0 my.graphite.com 2003
```

### 配置选项

运行以下命令查看所有配置选项：

```bash
$ bin/browsertime.js --help
```

## 浏览器支持

- **桌面浏览器**：Firefox、Chrome、Edge（Chromium版本）、Safari（Mac OS）。
- **移动浏览器**：Android上的Chrome和Firefox（8.0+），iOS上的Safari，Mac OS上的Safari模拟器。

## 工作原理

1. Browsertime使用Selenium NodeJS通过WebDriver驱动浏览器。
2. 启动浏览器并加载URL。
3. 页面加载完成后执行JavaScript收集性能指标。
4. 通过FFMPEG录制屏幕视频，分析生成视觉指标。
5. 生成包含所有指标的JSON文件、HAR文件、视频和截图。

[downloads-image]: https://img.shields.io/npm/dm/browsertime.svg?style=flat-square
[downloads-total-image]: https://img.shields.io/npm/dt/browsertime.svg?style=flat-square
[downloads-url]: https://npmjs.org/package/browsertime
[stars-image]: https://img.shields.io/github/stars/sitespeedio/browsertime.svg?style=flat-square
[stars-url]: https://github.com/sitespeedio/browsertime/stargazers

---
image: sitespeedio/browsertime
description: "Browsertime是一款从浏览器获取Web性能指标的工具，支持Firefox和Chrome，可收集导航时间、用户时间、资源时间等性能数据，生成HAR文件，运行自定义脚本，录制视频并分析视觉指标（如速度指数）。"
source: https://xuanyuan.cloud/zh/r/sitespeedio/browsertime
canonical: https://xuanyuan.cloud/zh/r/sitespeedio/browsertime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sitespeedio/browsertime" title="sitespeedio/browsertime Docker 镜像中文简介、标签列表与拉取命令">sitespeedio/browsertime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Browsertime - 你的浏览器，你的页面，你的脚本！

![Browsertime](browsertime.png)

从你的浏览器中，在终端里访问Web性能时间线！

Browsertime允许你：
1. 直接从浏览器查询时间数据，获取[导航时间](http://kaaes.github.io/timing/info.html)、[用户时间](http://www.html5rocks.com/en/tutorials/webperformance/usertiming/)、[资源时间](http://www.w3.org/TR/resource-timing/)、首次绘制和[RUM速度指数](https://github.com/WPO-Foundation/RUM-SpeedIndex)。
1. 生成[HAR](http://www.softwareishard.com/blog/har-12-spec/)文件（Firefox使用[HAR Export Trigger](https://github.com/firebug/har-export-trigger)，Chrome通过解析日志生成）。
1. 在浏览器中运行自定义Javascript脚本，并获取每次运行的统计数据。
1. 录制屏幕视频并分析结果，获取首次视觉变化、速度指数、85%视觉完成度和最后视觉变化。

**重要提示！** master分支现在是即将发布的2.0.0 alpha版本，[1.x](https://github.com/sitespeedio/browsertime/tree/1.x)是最新稳定版本。

## 简单示例

使用我们的Docker镜像（包含Chrome、Firefox、XVFB和录制视频所需依赖）：
```bash
$ docker run --shm-size=1g --rm -v "$(pwd)":/browsertime sitespeedio/browsertime --video --speedIndex https://www.sitespeed.io/
```

或使用node：
```bash
$ bin/browsertime.js https://www.sitespeed.io
```

在Chrome中加载https://www.sitespeed.io/三次。结果将以JSON文件（browsertime.json）和HAR文件（browsertime.har）的形式存储在browsertime-results/www.sitespeed.io/$date/目录下，包含时间数据。

## 更多示例

查看[示例文档](docs/examples/README.md)。

## 支持的浏览器

Browsertime在桌面端支持Firefox和Chrome，在Android上支持Chrome。

我们计划[支持Opera（Android版）](https://github.com/tobli/browsertime/issues/150)，当iOS Safari支持WebDriver时也将添加支持。

## 工作原理

Browsertime使用Selenium NodeJS驱动浏览器。它启动浏览器、加载URL、执行可配置的Javascript收集指标、生成HAR文件。

Firefox的HAR文件通过[HAR Export Trigger](https://github.com/firebug/har-export-trigger)获取，Chrome则使用[Chrome-HAR](https://github.com/sitespeedio/chrome-har)解析时间线日志生成HAR文件。

你还可以在访问URL之前（`--preScript`）和之后（`--postScript`）运行自定义Selenium脚本，例如登录/登出或其他操作。

# 速度指数和视频

使用[我们的Docker容器](https://hub.docker.com/r/sitespeedio/browsertime/)可轻松录制视频并计算速度指数，因为它包含运行[VisualMetrics](https://github.com/WPO-Foundation/visualmetrics)所需的所有依赖。

默认视频包含计时器并显示指标发生时间，可通过`--video.addTimer false`关闭。

<img src="https://raw.githubusercontent.com/sitespeedio/sitespeed.io/master/docs/img/video-example.gif">

## 使用Docker测试

你可以在本地使用Docker构建和测试更改：

```bash
$ docker build -t sitespeedio/browsertime .
$ docker run --shm-size=1g --rm -v "$(pwd)":/browsertime sitespeedio/browsertime -n 1 --video --speedIndex https://www.sitespeed.io/
```

## 网络连接配置

你可以通过Docker网络桥接限制网络连接速度，以便更容易捕获性能回归。默认使用[TSProxy](https://github.com/WPO-Foundation/tsproxy)，但目前与Selenium存在兼容性问题（详见[#229](https://github.com/sitespeedio/browsertime/issues/229)）。

在安装了tc的服务器上，可通过以下脚本创建不同网络环境的Docker网络桥接：

```bash
#!/bin/bash
echo '启动Docker网络'
docker network create --driver bridge --subnet=192.168.33.0/24 --gateway=192.168.33.10 --opt "com.docker.network.bridge.name"="docker1" 3g
tc qdisc add dev docker1 root handle 1: htb default 12
tc class add dev docker1 parent 1:1 classid 1:12 htb rate 1.6mbit ceil 1.6mbit
tc qdisc add dev docker1 parent 1:12 netem delay 300ms

docker network create --driver bridge --subnet=192.168.34.0/24 --gateway=192.168.34.10 --opt "com.docker.network.bridge.name"="docker2" cable
tc qdisc add dev docker2 root handle 1: htb default 12
tc class add dev docker2 parent 1:1 classid 1:12 htb rate 5mbit ceil 5mbit
tc qdisc add dev docker2 parent 1:12 netem delay 28ms

docker network create --driver bridge --subnet=192.168.35.0/24 --gateway=192.168.35.10 --opt "com.docker.network.bridge.name"="docker3" 3gfast
tc qdisc add dev docker3 root handle 1: htb default 12
tc class add dev docker3 parent 1:1 classid 1:12 htb rate 1.6mbit ceil 1.6mbit
tc qdisc add dev docker3 parent 1:12 netem delay 150ms

docker network create --driver bridge --subnet=192.168.36.0/24 --gateway=192.168.36.10 --opt "com.docker.network.bridge.name"="docker4" 3gem
tc qdisc add dev docker4 root handle 1: htb default 12
tc class add dev docker4 parent 1:1 classid 1:12 htb rate 0.4mbit ceil 0.4mbit
tc qdisc add dev docker4 parent 1:12 netem delay 400ms
```

运行容器时添加`--network`指定网络，同时需告知Browsertime网络连接由外部配置。例如使用cable网络：

```bash
$ docker run --shm-size=1g --network=cable --rm sitespeedio/browsertime -c cable --connectivity.engine external --speedIndex --video https://www.sitespeed.io/
```

使用3g网络：

```bash
$ docker run --shm-size=1g --network=3g --rm sitespeedio/browsertime -c 3g --connectivity.engine external --speedIndex --video https://www.sitespeed.io/
```

删除网络：

```bash
#!/bin/bash
echo '停止Docker网络'
docker network rm 3g
docker network rm 3gfast
docker network rm 3gem
docker network rm cable
```

## 移动设备测试

Browsertime支持Android上的Chrome：可收集速度指数、HAR和视频！这仍是新功能，如有问题请反馈。

开始前需[安装adb](https://www.sitespeed.io/documentation/sitespeed.io/mobile-phones/#desktop)并[准备设备](https://www.sitespeed.io/documentation/sitespeed.io/mobile-phones/#on-your-phone)。

如需限制网络，可使用[Micro device lab](https://github.com/phuedx/micro-device-lab)或[TSProxy](https://github.com/WPO-Foundation/tsproxy)。

```bash
$ browsertime --chrome.android.package com.android.chrome https://www.sitespeed.io --video --speedIndex
```

在Linux（已测试Ubuntu 16）上，可使用Docker容器驱动Android设备，需注意：
- 使用特权模式`--privileged`
- 共享USB端口`-v /dev/bus/usb:/dev/bus/usb`
- 添加`-e START_ADB_SERVER=true`启动adb服务器
- 关闭xvfb`--xvfb false`（自动启动）

Docker容器默认支持视频和速度指数分析。

```bash
$ docker run --privileged -v /dev/bus/usb:/dev/bus/usb -e START_ADB_SERVER=true --shm-size=1g --rm -v "$(pwd)":/browsertime-results sitespeedio/browsertime -n 1 --chrome.android.package com.android.chrome --xvfb false --speedIndex --video https://en.m.wikipedia.org/wiki/Barack_Obama
```

## 配置

运行`$ bin/browsertime.js --help`查看配置选项。

## 发送指标到Graphite

最简单的方法是安装[jq](https://stedolan.github.io/jq/)工具提取指标并发送到Graphite。

例如，提取中位数速度指数并发送：

```bash
echo "browsertime.your.key.SpeedIndex.median" $(cat /tmp/browsertime/browsertime.json | jq .statistics.visualMetrics.SpeedIndex.median) "`date +%s`" | nc -q0 my.graphite.com 2003

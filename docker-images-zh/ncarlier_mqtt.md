---
image: ncarlier/mqtt
description: "基于Alpine的MQTT Docker镜像，使用mosquitto作为MQTT broker，用于快速部署轻量级MQTT消息代理服务。"
source: https://xuanyuan.cloud/zh/r/ncarlier/mqtt
canonical: https://xuanyuan.cloud/zh/r/ncarlier/mqtt
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ncarlier/mqtt" title="ncarlier/mqtt Docker 镜像中文简介、标签列表与拉取命令">ncarlier/mqtt 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MQTT Docker镜像

[![镜像大小](https://img.shields.io/imagelayers/image-size/ncarlier/mqtt/latest.svg)](https://hub.docker.com/r/ncarlier/mqtt/)
[![Docker拉取量](https://img.shields.io/docker/pulls/ncarlier/mqtt.svg)](https://hub.docker.com/r/ncarlier/mqtt/)

## 概述

本镜像为基于Alpine的MQTT Docker镜像，内置mosquitto作为MQTT broker，提供轻量级、高效的MQTT消息代理服务。

## 核心功能与特性

- **轻量级基础**：基于Alpine Linux，镜像体积小，资源占用低
- **成熟组件**：使用mosquitto作为MQTT broker，支持MQTT协议标准
- **易于部署**：提供简单的启动命令，快速搭建MQTT服务

## 使用场景

- 物联网（IoT）设备间的消息通信
- 传感器数据采集与传输
- 分布式系统中的消息传递
- 实时数据推送服务

## 使用方法

### 启动容器

通过以下命令启动MQTT容器：

```bash
docker run -d -P --name mqtt docker.xuanyuan.run/ncarlier/mqtt
```

参数说明：
- `-d`：后台运行容器
- `-P`：随机映射容器端口到主机
- `--name mqtt`：指定容器名称为"mqtt"

### 构建镜像

使用`make`命令构建镜像：

```bash
make
```

> 提示：使用`make help`命令可查看该镜像的可用构建命令。

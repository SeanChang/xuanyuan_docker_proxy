---
image: frangoteam/fuxa
description: "FUXA是一款开源的基于Web的过程可视化（SCADA/HMI/仪表盘）软件。https://github.com/frangoteam/FUXA"
source: https://xuanyuan.cloud/zh/r/frangoteam/fuxa
canonical: https://xuanyuan.cloud/zh/r/frangoteam/fuxa
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/frangoteam/fuxa" title="frangoteam/fuxa Docker 镜像中文简介、标签列表与拉取命令">frangoteam/fuxa 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FUXA Docker镜像文档

## 镜像概述和主要用途
FUXA是一款开源的基于Web的过程可视化（SCADA/HMI/仪表盘）软件。通过FUXA，您可以为机器创建具有个性化设计的现代过程可视化界面，并实现实时数据显示。

## 核心功能和特性
- **设备连接支持**：兼容Modbus RTU/TCP、西门子S7协议、OPC-UA、BACnet IP、MQTT、Ethernet/IP（Allen Bradley）等多种工业协议
- **SCADA/HMI Web编辑器**：完全基于Web的工程设计环境，支持在线编辑和配置
- **跨平台全栈架构**：后端采用NodeJs开发，前端使用HTML5、CSS、Javascript、Angular、SVG等Web技术栈，确保跨平台兼容性

## 在线演示
这里是FUXA编辑器的[在线演示](https://frangoteam.github.io)示例。

## 安装和运行方法

### 拉取镜像
```bash
docker pull frangoteam/fuxa:latest
```

### 基本运行
```bash
docker run -d -p 1881:1881 frangoteam/fuxa:latest
```

### 持久化存储配置
如需持久化存储应用数据（项目）、数据采集（标签历史）、日志和图片，可通过以下命令挂载卷：
```bash
docker run -d -p 1881:1881 \
  -v fuxa_appdata:/usr/src/app/FUXA/server/_appdata \  # 应用数据（项目）
  -v fuxa_db:/usr/src/app/FUXA/server/_db \          # 数据采集（标签历史）
  -v fuxa_logs:/usr/src/app/FUXA/server/_logs \      # 日志文件
  -v fuxa_images:/usr/src/app/FUXA/server/_images \  # 图片资源
  frangoteam/fuxa:latest

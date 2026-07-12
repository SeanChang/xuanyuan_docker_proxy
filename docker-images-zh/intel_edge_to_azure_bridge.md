---
image: intel/edge_to_azure_bridge
description: "Edge-to-Cloud Bridge for Microsoft Azure服务是用于连接发布者（如MQTT Broker、OEI Message Bus）并将数据发送到Azure IoT Hub的边缘到云桥接工具。"
source: https://xuanyuan.cloud/zh/r/intel/edge_to_azure_bridge
canonical: https://xuanyuan.cloud/zh/r/intel/edge_to_azure_bridge
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/edge_to_azure_bridge" title="intel/edge_to_azure_bridge Docker 镜像中文简介、标签列表与拉取命令">intel/edge_to_azure_bridge 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Edge-to-Cloud Bridge for Microsoft Azure* service

## 镜像概述

Edge-to-Cloud Bridge for Microsoft Azure* service是一款边缘到云桥接服务，主要功能是连接发布者（如MQTT Broker、[OEI Message Bus](https://open-edge-insights.github.io/)）并将数据发送到Azure IoT Hub。有关如何使用该服务的信息，请参考[Get Started guide](https://www.intel.com/content/www/us/en/developer/articles/technical/edge-to-cloud-bridge-for-microsoft-azure-service.html)。

## 核心功能与特性

- **多发布者支持**：可连接MQTT Broker和OEI Message Bus等发布者
- **数据转发能力**：将边缘设备数据可靠发送至Azure IoT Hub
- **OEI模式支持**：提供在OEI（Open Edge Insights）环境下的运行能力

## 使用场景

适用于需要将边缘设备产生的数据通过MQTT协议或OEI Message Bus汇聚后，上传至Microsoft Azure IoT Hub的边缘计算场景，实现边缘与云平台的数据交互。

## 使用方法

### 基本使用

参考官方[Get Started guide](https://www.intel.com/content/www/us/en/developer/articles/technical/edge-to-cloud-bridge-for-microsoft-azure-service.html)获取详细使用说明。

### OEI模式运行

在OEI模式下运行Edge-to-Cloud Bridge for Microsoft Azure* service，请参考[README](https://github.com/intel/edge-to-azure-bridge/blob/updates/firstUpdate/README_OEI.md)。

## 支持的标签及Dockerfile链接

- [3.0](https://github.com/intel/edge-to-azure-bridge/blob/master/modules/EdgeToAzureBridge/Dockerfile)
  - Edge-to-Cloud Bridge for Microsoft Azure* service的初始版本

## 许可协议

下载并使用此容器及包含的软件，即表示您同意[软件许可协议](https://github.com/intel/edge-to-azure-bridge/blob/master/LICENSE)的条款和条件。

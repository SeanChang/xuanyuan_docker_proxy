---
image: cccs/assemblyline-service-floss
description: "Assemblyline 4混淆字符串求解器，用于解析混淆字符串以辅助相关分析。"
source: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-floss
canonical: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-floss
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-floss" title="cccs/assemblyline-service-floss Docker 镜像中文简介、标签列表与拉取命令">cccs/assemblyline-service-floss — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-floss" title="cccs/assemblyline-service-floss Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-floss</a>

# Floss Service

![Discord](https://img.shields.io/badge/chat-on%20discord-7289da.svg?sanitize=true)
![Discord](https://img.shields.io/discord/908084610158714900)
![GitHub](https://img.shields.io/badge/github-assemblyline-blue?logo=github)
![GitHub](https://img.shields.io/badge/github-assemblyline_service_floss-blue?logo=github)
![GitHub Issues](https://img.shields.io/github/issues/CybercentreCanada/assemblyline/service-floss)
![License](https://img.shields.io/github/license/CybercentreCanada/assemblyline-service-floss)

## 镜像概述和主要用途

Floss Service是Assemblyline框架中的一个服务，它使用FireEye Labs Obfuscated String Solver (FLOSS)工具来查找混淆字符串，如堆叠字符串(stacked strings)。该服务主要用于恶意软件分析和逆向工程过程中提取隐藏的字符串信息。

FLOSS项目地址：https://github.com/fireeye/flare-floss/  
许可证：Apache License 2.0 (https://github.com/fireeye/flare-floss/blob/master/LICENSE.txt)

## 核心功能和特性

### 字符串提取功能

1. **可执行文件/Windows文件处理**:
   - 静态字符串模块（Unicode和ASCII），仅匹配IOC
   - 解码字符串模块
   - 堆叠字符串模块

> **注意**：当非深度扫描模式时，服务会根据提交文件的大小跳过某些检测模块（以防止服务积压和超时）。默认值有意设置为较低的大小。可以根据AL实例的流量/硬件情况，在服务配置中轻松更改过滤器。

## 使用场景和适用范围

Floss Service适用于以下场景：
- 恶意软件分析中的字符串提取
- 逆向工程过程中发现隐藏/混淆的字符串
- 威胁情报收集和IOC提取
- 自动化恶意代码分析流程

该服务特别适合处理Windows可执行文件，能够有效提取各种类型的混淆字符串，帮助安全分析师快速识别潜在威胁指标。

## 详细的使用方法和配置说明

### 服务配置参数

| 参数名 | 描述 |
|--------|------|
| max_size | 提交给此服务的文件的最大大小 |
| max_length | 字符串长度最大值，用于基本ASCII和UNICODE模块 |
| st_max_size | 字符串列表最大大小，由基本ASCII和UNICODE模块结果生成，决定patterns.py是否只评估网络IOC模式 |

### 结果输出

1. **静态字符串（ASCII、UNICODE）**:
   - 匹配感兴趣IOC模式的字符串

2. **FF解码字符串**:
   - 所有字符串
   - 匹配感兴趣IOC模式的字符串

3. **FF堆叠字符串**:
   - 所有字符串，按相似度分组（由fuzzywuzzy库确定）
   - 匹配感兴趣IOC模式的字符串

### 镜像变体和标签

Assemblyline服务基于[Assemblyline服务基础镜像](https://hub.docker.com/r/cccs/assemblyline-v4-service-base)构建，该基础镜像基于Debian 11和Python 3.11。

Assemblyline服务使用以下标签定义：

| **标签类型** | **描述** | **示例标签** |
| :----------: | :------- | :----------: |
|    latest    | 最新构建（可能不稳定） | `latest` |
|  build_type  | 构建类型。`dev`是最新的不稳定构建，`stable`是最新的稳定构建 | `stable` 或 `dev` |
|    series    | 完整构建详情，包括版本和构建类型：`version.buildType` | `4.5.stable`、`4.5.1.dev3` |

### 运行服务

该服务是Assemblyline框架的一部分，设计用于在Assemblyline框架中运行。

#### 本地测试

如果要在本地测试此服务，可以直接从shell运行Docker镜像：

```bash
docker run \
    --name Floss \
    --env SERVICE_API_HOST=http://`ip addr show docker0 | grep "inet " | awk '{print $2}' | cut -f1 -d"/"`:5003 \
    --network=host \
    cccs/assemblyline-service-floss
```

#### 添加到Assemblyline部署

要将此服务添加到您的Assemblyline部署中，请遵循以下指南：
[https://cybercentrecanada.github.io/assemblyline4_docs/developer_manual/services/run_your_service/#add-the-container-to-your-deployment](https://cybercentrecanada.github.io/assemblyline4_docs/developer_manual/services/run_your_service/#add-the-container-to-your-deployment)

### 相关文档

Assemblyline的一般文档可在以下地址找到：
https://cybercentrecanada.github.io/assemblyline4_docs/

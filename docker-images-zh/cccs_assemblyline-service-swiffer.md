---
image: cccs/assemblyline-service-swiffer
description: "Assemblyline 4的Adobe Flash (SWF)分析服务，使用Python pyswf库提取元数据并对“audiovisual/flash”文件执行异常检测。"
source: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-swiffer
canonical: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-swiffer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-swiffer" title="cccs/assemblyline-service-swiffer Docker 镜像中文简介、标签列表与拉取命令">cccs/assemblyline-service-swiffer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Swiffer服务

该Assemblyline服务使用Python pyswf库提取元数据并对“audiovisual/flash”文件执行异常检测。

## 服务详情

Swiffer会报告每个文件中存在的以下信息：

### SWF头信息
- `Version`（版本）
- `FileLength`（文件长度）
- `FrameSize`（帧大小）
- `FrameRate`（帧率）
- `FrameCount`（帧数）

### 符号摘要
- 主时间轴（Main Timeline）
- 标签ID（TagIds）
- 名称（Names）

## 镜像变体和标签

Assemblyline服务基于[Assemblyline服务基础镜像](https://hub.docker.com/r/cccs/assemblyline-v4-service-base)构建，该基础镜像基于Debian 11，带有Python 3.11。

Assemblyline服务使用以下标签定义：

| **标签类型** | **描述**                                                                 | **示例标签**          |
| :----------: | :----------------------------------------------------------------------- | :-------------------- |
|    latest    | 最新构建（可能不稳定）                                                   | `latest`              |
|  build_type  | 构建类型。`dev`是最新的不稳定构建，`stable`是最新的稳定构建               | `stable` 或 `dev`     |
|    series    | 完整构建详情，包括版本和构建类型：`version.buildType`                     | `4.5.stable`、`4.5.1.dev3` |

## 运行此服务

这是一个Assemblyline服务，设计用于在Assemblyline框架中运行。

如果要在本地测试此服务，可以从shell直接运行Docker镜像：

```bash
docker run \
    --name Swiffer \
    --env SERVICE_API_HOST=http://`ip docker.xuanyuan.run/addr show docker0 | grep "inet " | awk '{print $2}' | cut -f1 -d"/"`:5003 \
    --network=host \
    cccs/assemblyline-service-swiffer
```

要将此服务添加到您的Assemblyline部署中，请遵循[指南](https://cybercentrecanada.github.io/assemblyline4_docs/developer_manual/services/run_your_service/#add-the-container-to-your-deployment)。

## 文档

Assemblyline通用文档可在以下地址获取：https://cybercentrecanada.github.io/assemblyline4_docs/

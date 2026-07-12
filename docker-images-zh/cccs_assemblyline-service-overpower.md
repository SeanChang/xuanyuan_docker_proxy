---
image: cccs/assemblyline-service-overpower
description: "Assemblyline 4的PowerShell模拟与静态分析工具，用于对PowerShell文件进行反混淆、特征分析和运行处理。"
source: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-overpower
canonical: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-overpower
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-overpower" title="cccs/assemblyline-service-overpower Docker 镜像中文简介、标签列表与拉取命令">cccs/assemblyline-service-overpower 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Overpower服务

对PowerShell文件进行反混淆、特征分析和运行处理。

## 服务详情

使用经过修改的开源工具对PowerShell文件进行反混淆和评分，例如：

- [PSDecode](https://github.com/R3MRUM/PSDecode)：用于反混淆编码PowerShell脚本的PowerShell脚本
- [PowerShellProfiler](https://github.com/pan-unit42/public_tools/tree/master/powershellprofiler)：Palo Alto Networks Unit42的工具，通过反混淆和规范化内容对PowerShell脚本进行静态分析，然后针对行为指标进行特征分析。

### 提交参数

- `tool_timeout`：允许工具单独运行的时间长度。
- `add_supplementary`：如果希望将补充文件添加到结果中，请选择此参数。  
  PSDecode参数：
- `fake_web_download`：用于指示是否应模拟下载文件到磁盘的Web请求的标志。

## 镜像变体和标签

Assemblyline服务基于[Assemblyline服务基础镜像](https://hub.docker.com/r/cccs/assemblyline-v4-service-base)构建，该基础镜像基于Debian 11，包含Python 3.11。

Assemblyline服务使用以下标签定义：

| **标签类型** | **描述**                                                                 | **示例标签**          |
| :----------- | :----------------------------------------------------------------------- | :-------------------- |
| latest       | 最新构建版本（可能不稳定）。                                             | `latest`              |
| build_type   | 构建类型。`dev`是最新的不稳定构建版本，`stable`是最新的稳定构建版本。    | `stable` 或 `dev`     |
| series       | 完整构建详情，包括版本和构建类型：`version.buildType`。                  | `4.5.stable`、`4.5.1.dev3` |

## 运行此服务

这是一个Assemblyline服务，设计用于在Assemblyline框架中运行。

如果要在本地测试此服务，可以直接从shell运行Docker镜像：

```bash
docker run \
    --name Overpower \
    --env SERVICE_API_HOST=http://`ip docker.xuanyuan.run/addr show docker0 | grep "inet " | awk '{print $2}' | cut -f1 -d"/"`:5003 \
    --network=host \
    cccs/assemblyline-service-overpower
```

要将此服务添加到您的Assemblyline部署中，请遵循[指南](https://cybercentrecanada.github.io/assemblyline4_docs/developer_manual/services/run_your_service/#add-the-container-to-your-deployment)。

## 文档

Assemblyline通用文档可在以下地址获取：https://cybercentrecanada.github.io/assemblyline4_docs/

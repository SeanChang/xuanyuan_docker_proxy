---
image: cccs/assemblyline-service-peepdf
description: "Assemblyline 4的PDF分析服务（PeePDF）"
source: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-peepdf
canonical: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-peepdf
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-peepdf" title="cccs/assemblyline-service-peepdf Docker 镜像中文简介、标签列表与拉取命令">cccs/assemblyline-service-peepdf 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PeePDF Service

## 镜像概述和主要用途

PeePDF Service 是一个基于 Assemblyline 框架的服务，它使用 Python PeePDF 库对 PDF 文件进行深度分析。该服务专为 Assemblyline 平台设计，用于提取和报告 PDF 文件的各类技术信息和潜在安全风险。

## 核心功能和特性

### PDF 文件信息提取
- 文件哈希值：MD5、SHA1、SHA256
- 文件基本信息：大小、版本、是否为二进制(T|F)、是否线性化(T|F)
- 安全相关信息：加密算法、更新信息
- 结构信息：对象数量、流数量
- 版本信息：
  - 目录(Catalog)
  - 信息(Info)
  - 对象(Objects)
  - 流(Streams)
  - 交叉引用流(Xref streams)
  - 压缩对象(Compressed Objects)
  - 编码(Encoded)
  - 含JS代码的对象(Objects with JS code)

### 安全分析功能
- CVE标识符检测
- 嵌入式文件提取尝试
- JavaScript代码提取尝试
- URL检测

## 使用场景和适用范围

该服务适用于需要对PDF文件进行安全分析和深度检查的场景，特别适合：
- 恶意软件分析平台
- 威胁情报系统
- 文档安全扫描
- 数字取证调查
- 作为Assemblyline框架的一部分，与其他安全分析服务协同工作

## 镜像变体和标签

Assemblyline服务基于[Assemblyline服务基础镜像](https://hub.docker.com/r/cccs/assemblyline-v4-service-base)构建，该基础镜像基于Debian 11并包含Python 3.11。

Assemblyline服务使用以下标签定义：

| **标签类型** | **描述**                                                                 | **示例标签**               |
|------------|--------------------------------------------------------------------------|--------------------------|
| latest     | 最新构建版本（可能不稳定）                                                | `latest`                 |
| build_type | 构建类型，`dev`表示最新不稳定版本，`stable`表示最新稳定版本                | `stable` 或 `dev`        |
| series     | 完整构建详情，包含版本和构建类型：`version.buildType`                     | `4.5.stable`、`4.5.1.dev3`|

## 详细的使用方法和配置说明

### 环境要求

- 作为Assemblyline框架的一部分运行时，需符合Assemblyline平台要求
- 本地测试时需要Docker环境

### 本地测试部署

如果需要本地测试此服务，可以直接运行Docker镜像：

```bash
docker run \
    --name PeePDF \
    --env SERVICE_API_HOST=http://$(ip docker.xuanyuan.run/addr show docker0 | grep "inet " | awk '{print $2}' | cut -f1 -d"/"):5003 \
    --network=host \
    cccs/assemblyline-service-peepdf
```

#### 环境变量说明

| 环境变量 | 描述 | 示例 |
|---------|------|------|
| SERVICE_API_HOST | Assemblyline服务API主机地址 | `http://172.17.0.1:5003` |

### 在Assemblyline中部署

该服务设计为Assemblyline框架的一部分运行。要将此服务添加到您的Assemblyline部署中，请遵循[官方指南](https://cybercentrecanada.github.io/assemblyline4_docs/developer_manual/services/run_your_service/#add-the-container-to-your-deployment)。

## 参考文档

- [Assemblyline官方文档](https://cybercentrecanada.github.io/assemblyline4_docs/)
- [Assemblyline服务基础镜像](https://hub.docker.com/r/cccs/assemblyline-v4-service-base)
- [PeePDF库](https://github.com/jesparza/peepdf)

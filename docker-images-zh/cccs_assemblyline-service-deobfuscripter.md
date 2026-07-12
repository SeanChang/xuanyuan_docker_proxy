---
image: cccs/assemblyline-service-deobfuscripter
description: "静态脚本反混淆器，旨在提取混淆的IOCs（指标信息），而非进行精确的反混淆处理。"
source: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-deobfuscripter
canonical: https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-deobfuscripter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cccs/assemblyline-service-deobfuscripter" title="cccs/assemblyline-service-deobfuscripter Docker 镜像中文简介、标签列表与拉取命令">cccs/assemblyline-service-deobfuscripter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# DeobfuScripter 服务

静态脚本反混淆器。其目的并非进行精确的反混淆处理，而是提取混淆的IOCs（指标信息）。

## 服务详情

### 第一阶段模块（按执行顺序）：

1. HTML脚本提取

### 第二阶段模块（按执行顺序）：

1. MSOffice嵌入式脚本
2. CHR和CHRB解码
3. 字符串替换
4. PowerShell插入符
5. 字符串数组
6. 伪数组变量
7. 字符串反转
8. Base64解码 - 此模块也可能提取文件
9. 简单XOR函数
10. 字符编码十六进制
11. PowerShell变量
12. MSWord宏变量
13. 字符串拼接
14. 字符编码

## 镜像变体与标签

Assemblyline服务基于[Assemblyline服务基础镜像](https://hub.docker.com/r/cccs/assemblyline-v4-service-base)构建，该基础镜像基于Debian 11，搭载Python 3.11。

Assemblyline服务使用以下标签定义：

| **标签类型** | **描述**                                                                 | **示例标签**               |
| :----------: | :----------------------------------------------------------------------- | :------------------------- |
|    latest    | 最新构建版本（可能不稳定）                                               | `latest`                   |
|  build_type  | 构建类型。`dev`为最新不稳定构建，`stable`为最新稳定构建                   | `stable` 或 `dev`          |
|    series    | 完整构建详情，包含版本和构建类型：`version.buildType`                     | `4.5.stable`、`4.5.1.dev3` |

## 运行此服务

这是一个Assemblyline服务，设计用于Assemblyline框架中运行。

若需本地测试此服务，可直接通过Shell运行Docker镜像：

    docker run \
        --name DeobfuScripter \
        --env SERVICE_API_HOST=http://`ip addr show docker0 | grep "inet " | awk '{print $2}' | cut -f1 -d"/"`:5003 \
        --network=host \
        cccs/assemblyline-service-deobfuscripter

如需将此服务添加到Assemblyline部署中，请遵循[指南](https://cybercentrecanada.github.io/assemblyline4_docs/developer_manual/services/run_your_service/#add-the-container-to-your-deployment)。

## 文档

Assemblyline通用文档可访问：https://cybercentrecanada.github.io/assemblyline4_docs/

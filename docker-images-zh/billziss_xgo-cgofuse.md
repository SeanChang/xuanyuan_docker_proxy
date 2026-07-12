---
image: billziss/xgo-cgofuse
description: "使用xgo对依赖cgofuse的程序进行交叉编译的Docker镜像，支持Windows、macOS和Linux平台。"
source: https://xuanyuan.cloud/zh/r/billziss/xgo-cgofuse
canonical: https://xuanyuan.cloud/zh/r/billziss/xgo-cgofuse
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/billziss/xgo-cgofuse" title="billziss/xgo-cgofuse Docker 镜像中文简介、标签列表与拉取命令">billziss/xgo-cgofuse 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# cgofuse交叉编译Docker镜像

## 镜像概述

该Docker镜像（billziss/xgo-cgofuse）基于xgo工具构建，用于简化依赖cgofuse的Go程序的交叉编译过程。cgofuse是一个跨平台的FUSE库，而本镜像提供了预配置环境，支持为Windows、macOS和Linux等多平台构建Go应用。

## 核心功能与特性

- **多平台支持**：可交叉编译生成Windows（386/amd64）、macOS（386/amd64）、Linux（386/amd64）平台的可执行文件
- **预集成依赖**：已包含cgofuse库及其编译所需的系统依赖
- **简化流程**：无需手动配置各平台编译环境，直接通过xgo命令实现一键交叉编译

## 使用场景

适用于需要为多个操作系统构建依赖cgofuse的Go文件系统应用的开发者，尤其适合开发跨平台FUSE文件系统工具的场景。

## 使用方法

### 前提条件

- 已安装Docker引擎
- 已安装xgo工具（`go get -u github.com/karalabe/xgo`）

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/billziss/xgo-cgofuse
```

### 交叉编译示例

在依赖cgofuse的项目根目录下执行以下命令：

```bash
xgo --image=billziss/xgo-cgofuse \
    --targets=darwin/386,darwin/amd64,linux/386,linux/amd64,windows/386,windows/amd64 .
```

#### 参数说明

- `--image=billziss/xgo-cgofuse`：指定使用本镜像作为编译环境
- `--targets`：指定目标平台，格式为`[操作系统]/[架构]`，支持的组合包括：
  - `darwin/386`：macOS 32位
  - `darwin/amd64`：macOS 64位
  - `linux/386`：Linux 32位
  - `linux/amd64`：Linux 64位
  - `windows/386`：Windows 32位
  - `windows/amd64`：Windows 64位

## 注意事项

- 交叉编译仅支持Windows、macOS和Linux平台，不支持FreeBSD、NetBSD和OpenBSD
- 编译结果将生成在当前目录下，文件名为项目名加上目标平台标识（如`myapp-darwin-386`）
- 确保项目中正确导入cgofuse库（`github.com/billziss-gh/cgofuse/fuse`）

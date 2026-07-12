---
image: tquicgroup/tquic
description: "一个高性能、轻量级且跨平台的QUIC协议库"
source: https://xuanyuan.cloud/zh/r/tquicgroup/tquic
canonical: https://xuanyuan.cloud/zh/r/tquicgroup/tquic
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tquicgroup/tquic" title="tquicgroup/tquic Docker 镜像中文简介、标签列表与拉取命令">tquicgroup/tquic 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TQUIC 镜像文档

## 镜像概述和主要用途

TQUIC 是一个高性能、轻量级且跨平台的库，用于实现 [IETF QUIC](https://datatracker.ietf.org/wg/quic/about/) 协议。它旨在提供高效的网络传输能力，适用于需要低延迟和高吞吐量的网络应用场景。

- 官方网站: https://tquic.net
- GitHub 仓库: https://github.com/tencent/tquic

## 核心功能和特性

### 高性能
专为高性能和低延迟设计，相关性能详情可参见 [基准测试结果](https://tquic.net/docs/further_readings/benchmark)。

### 可插拔拥塞控制
支持多种拥塞控制算法，包括 CUBIC、BBR、BBRv3 和 COPA。

### 多路径 QUIC
支持多路径功能，允许单个连接同时使用多条路径进行数据传输。

### 易于使用
提供灵活的配置选项和详细的可观测性，便于集成和调试。

### 跨平台支持
可在 Rust 能够编译的几乎所有平台上运行，并提供 Rust/C/C++ 接口。

### Rust 语言实现
采用内存安全的 Rust 语言编写，可避免缓冲区溢出等内存相关漏洞。

### 高质量保障
通过广泛的自动化测试确保质量，包括单元测试、模糊测试、集成测试、性能基准测试和互操作性测试等。

### 协议合规性
已通过 Ivy 工具的形式化规范验证，并通过 IETF 互操作性测试。

### 丰富功能集
支持 QUIC 和 HTTP/3 RFC 规范中的所有主要功能。

## 使用场景和适用范围

TQUIC 适用于需要高效网络传输的各类场景，包括但不限于：
- 低延迟实时通信应用（如视频会议、实时游戏）
- 高吞吐量数据传输服务（如大型文件传输、CDN 加速）
- 跨平台网络应用开发（需在多种操作系统和硬件架构上运行）
- 对网络安全性和可靠性有高要求的系统（得益于 Rust 的内存安全特性）

## 使用方法和配置说明

### 集成方式
提供 Rust/C/C++ 接口，可根据开发需求选择相应 API 集成：
- Rust 项目：通过 Cargo 依赖引入
- C/C++ 项目：使用提供的 C 绑定

### 配置选项
支持灵活配置，包括但不限于：
- 拥塞控制算法选择
- 多路径参数配置
- 连接超时和重试策略
- 日志和监控参数设置

### 示例代码
具体使用示例可参考 GitHub 仓库中的 [示例目录](https://github.com/tencent/tquic/tree/main/examples)。

### Docker 部署提示
目前官方未提供预构建镜像，可通过以下步骤构建自定义镜像：
1. 克隆仓库：`git clone https://github.com/tencent/tquic.git`
2. 编写 Dockerfile（基于 Rust 基础镜像编译）
3. 构建镜像：`docker build -t tquic .`
4. 运行容器：`docker run -it --rm tquic`

（具体 Dockerfile 需根据项目构建需求定制）

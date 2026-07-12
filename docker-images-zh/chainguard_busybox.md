---
image: chainguard/busybox
description: "使用Chainguard的低至零CVE容器镜像构建、交付和运行安全软件。"
source: https://xuanyuan.cloud/zh/r/chainguard/busybox
canonical: https://xuanyuan.cloud/zh/r/chainguard/busybox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/chainguard/busybox" title="chainguard/busybox Docker 镜像中文简介、标签列表与拉取命令">chainguard/busybox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Chainguard Busybox 容器镜像文档


## 镜像概述与主要用途

Chainguard Busybox 容器镜像是由 Chainguard 开发的轻量级、高安全性基础镜像，基于 Busybox 工具集构建。其核心目标是为用户提供**低至零 CVE（通用漏洞和暴露）漏洞**的运行环境，支持安全软件的构建、交付与运行流程，最小化应用攻击面。主要用途包括作为轻量级基础镜像、临时任务执行环境或资源受限场景下的安全工具载体。


## 核心功能与特性

### 低至零 CVE 漏洞
通过严格的供应链管理、精简依赖与持续安全审计，显著降低漏洞暴露风险，保障运行环境安全性。

### 轻量级设计
继承 Busybox 原生特性，集成常用 Unix 工具（如 `sh`、`ls`、`cp` 等），镜像体积小巧，资源占用低，适合快速部署与资源受限场景。

### FIPS 合规支持
提供符合 FIPS（联邦信息处理标准）的版本（需查看[额外版本列表](https://images.chainguard.dev/directory/image/busybox/versions)），满足金融、政府等合规性要求较高的场景。

### SBOM 与供应链安全
支持软件物料清单（SBOM），可通过[SBOM 页面](https://images.chainguard.dev/directory/image/busybox/sbom)获取组件信息，提升供应链透明度与安全审计能力。

### 多源可用
镜像同时发布于 Docker Hub 与 Chainguard Registry，适配不同网络环境与访问需求。


## 使用场景与适用范围

### 安全优先的基础镜像
作为应用容器的底层依赖，减少基础组件漏洞对上层应用的影响，尤其适合对安全性要求严苛的业务。

### 轻量级容器环境
适用于嵌入式系统、边缘计算节点、IoT 设备等资源受限场景，降低内存与存储占用。

### CI/CD 流程临时任务
用于 CI/CD 管道中的轻量级操作（如文件处理、命令执行、环境检查等），缩短任务启动时间。

### 资源受限环境
最小化镜像体积（通常仅数 MB），降低网络传输成本与部署延迟。

### 合规性要求场景
需满足 FIPS 等安全标准的金融、医疗、政府等领域应用，可通过特定版本实现合规适配。


## 使用方法与配置说明

### 下载与拉取镜像
镜像可从 Docker Hub 或 Chainguard Registry 拉取，支持 `latest` 及其他特定标签（如版本号、FIPS 标记等）。

#### 从 Docker Hub 拉取
```bash
docker pull docker.xuanyuan.run/chainguard/busybox:latest
```

#### 从 Chainguard Registry 拉取
```bash
docker pull cgr.dev/chainguard/busybox:latest
```


### 基本运行示例
运行容器并执行简单命令（如查看 Busybox 版本或执行 shell）：
```bash
# 运行临时容器并执行命令
docker run --rm docker.xuanyuan.run/chainguard/busybox:latest sh -c "echo '运行于 Chainguard Busybox 镜像中'; uname -a"

# 启动交互式 shell
docker run -it --rm docker.xuanyuan.run/chainguard/busybox:latest sh
```
> 注：`--rm` 选项确保容器退出后自动清理，避免残留资源。


### 版本与标签说明
- **默认标签**：`latest` 指向最新稳定版本，适合大多数场景。
- **特定版本**：如需指定版本（如 `1.36`）或 FIPS 合规版本（如 `latest-fips`），可参考 [Chainguard 镜像版本目录](https://images.chainguard.dev/directory/image/busybox/versions)。
- **架构支持**：镜像默认支持多架构（如 `amd64`、`arm64`），Docker 会自动拉取匹配宿主机架构的镜像。


### 补充说明
- **速率限制处理**：若从 Docker Hub 拉取时遇到速率限制，建议切换至 Chainguard Registry（`cgr.dev/chainguard/busybox`）。
- **安全与合规**：镜像的漏洞信息、安全公告可通过 [Chainguard 镜像目录](https://images.chainguard.dev/directory/image/busybox) 查看，包括 SBOM、CVE 扫描结果等。
- **支持资源**：如需技术支持，可参考 [Chainguard 镜像 FAQ](https://edu.chainguard.dev/chainguard/chainguard-images/faq/) 或通过 [联系页面](https://www.chainguard.dev/contact) 提交请求。


## 补充资源
- **版本列表（含 FIPS 支持）**：[https://images.chainguard.dev/directory/image/busybox/versions](https://images.chainguard.dev/directory/image/busybox/versions)
- **软件物料清单（SBOM）**：[https://images.chainguard.dev/directory/image/busybox/sbom](https://images.chainguard.dev/directory/image/busybox/sbom)
- **安全公告**：[https://images.chainguard.dev/directory/image/busybox/advisories](https://images.chainguard.dev/directory/image/busybox/advisories)
- **漏洞信息**：[https://images.chainguard.dev/directory/image/busybox/vulnerabilities](https://images.chainguard.dev/directory/image/busybox/vulnerabilities)
- **完整文档**：[Chainguard 镜像目录概述](https://images.chainguard.dev/directory/image/busybox/overview)

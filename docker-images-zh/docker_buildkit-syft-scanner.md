---
image: docker/buildkit-syft-scanner
description: "这是基于Syft扫描器的BuildKit SBOM生成器镜像，用于在Docker构建输出中包含扫描结果，实现了BuildKit SBOM扫描协议。"
source: https://xuanyuan.cloud/zh/r/docker/buildkit-syft-scanner
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[docker/buildkit-syft-scanner](https://xuanyuan.cloud/zh/r/docker/buildkit-syft-scanner)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# BuildKit Syft Scanner 镜像文档

## 1. 镜像概述和主要用途

`docker/buildkit-syft-scanner` 镜像是将 [Syft 扫描器](https://github.com/anchore/syft) 打包为 [BuildKit SBOM 生成器](https://github.com/moby/buildkit/blob/master/docs/attestations/sbom.md) 的工具，用于在 Docker 构建过程中集成软件物料清单（SBOM）扫描结果，并将其作为构建证明（attestation）与输出镜像关联。

该镜像实现了 [BuildKit SBOM 扫描协议](https://github.com/moby/buildkit/blob/master/docs/attestations/sbom-protocol.md)，可与 BuildKit 构建工具链无缝集成，为镜像构建流程提供自动化的 SBOM 生成能力。

## 2. 核心功能和特性

- **BuildKit 协议兼容**：完全实现 BuildKit 定义的 SBOM 扫描协议，确保与 BuildKit 构建系统的兼容性。
- **Syft 集成**：内置 Syft 扫描器，支持多种包管理器和文件系统的组件识别，生成详细的软件物料清单。
- **构建时 SBOM 生成**：在 Docker 镜像构建阶段自动执行扫描，无需额外的后处理步骤。
- **SBOM 作为构建证明**：生成的 SBOM 以 BuildKit 构建证明（attestation）形式附加到输出镜像，便于后续验证和审计。

## 3. 使用场景和适用范围

- **软件供应链安全管理**：在镜像构建阶段识别并记录所有依赖组件，助力安全漏洞跟踪和管理。
- **合规审计**：满足行业合规要求（如 SBOM 提交、组件许可证跟踪等），提供可追溯的构建组件清单。
- **依赖管理**：跟踪镜像中的第三方组件及其版本，辅助识别过时或不安全的依赖项。
- **Docker + BuildKit 构建流程**：适用于使用 BuildKit 作为构建后端的 Docker 环境，需通过 `buildctl` 或支持 BuildKit 高级选项的构建工具调用。

## 4. 使用方法和配置说明

### 4.1 前提条件

- 已安装并配置 BuildKit（推荐版本 ≥ v0.10.0）。
- 构建工具支持 BuildKit 的 `--opt` 参数（如 `buildctl`）。

### 4.2 基本使用命令

在使用 `buildctl` 构建镜像时，通过 `--opt attest:sbom=generator=...` 参数指定本扫描器镜像，即可在构建过程中生成 SBOM 证明：

```bash
buildctl build ... \
    --output type=image,name=<目标镜像名称>,push=true \
    --opt attest:sbom=generator=docker/buildkit-syft-scanner
```

### 4.3 参数说明

| 参数                          | 描述                                                                 | 示例值                                  |
|-------------------------------|----------------------------------------------------------------------|-----------------------------------------|
| `attest:sbom=generator`       | 指定 SBOM 生成器镜像，需设置为 `docker/buildkit-syft-scanner`       | `generator=docker/buildkit-syft-scanner`|
| `--output type=image,...`     | 输出配置，需包含 `name=<目标镜像名称>` 和 `push=true`（如需推送镜像） | `type=image,name=myapp:latest,push=true`|

### 4.4 示例

构建并推送镜像 `myapp:latest`，同时生成 SBOM 证明：

```bash
buildctl build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name=myapp:latest,push=true \
    --opt attest:sbom=generator=docker/buildkit-syft-scanner
```

## 5. 开发指南

### 5.1 环境准备

克隆项目仓库并进入目录：

```bash
git clone https://github.com/docker/buildkit-syft-scanner.git
cd buildkit-syft-scanner
```

### 5.2 本地仓库设置（可选）

推荐启动本地临时 registry，用于推送开发镜像：

```bash
docker run -d -p 5000:5000 --rm --name registry registry:2
```

### 5.3 构建开发镜像

使用 `make dev` 命令构建开发镜像并推送到本地 registry（需替换 `<本地仓库地址>` 为实际 registry 地址）：

```bash
make dev IMAGE=<本地仓库地址>/buildkit-syft-scanner:dev
```

示例（推送到本地 registry `localhost:5000`）：

```bash
make dev IMAGE=localhost:5000/buildkit-syft-scanner:dev
```

### 5.4 测试开发镜像

运行示例构建测试开发镜像功能：

```bash
make examples IMAGE=localhost:5000/buildkit-syft-scanner:dev
```

### 5.5 使用开发镜像进行构建

通过 `buildctl` 使用开发镜像生成 SBOM：

```bash
buildctl build ... \
    --output type=image,name=<目标镜像名称>,push=true \
    --opt attest:sbom=generator=<本地仓库地址>/buildkit-syft-scanner:dev
```

示例：

```bash
buildctl build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name=myapp:dev,push=true \
    --opt attest:sbom=generator=localhost:5000/buildkit-syft-scanner:dev
```

## 6. 贡献指南

`buildkit-syft-scanner` 主要作为 [BuildKit](https://github.com/moby/buildkit) 与 [Syft](https://github.com/anchore/syft) 之间的适配层，旨在保持代码精简。贡献通常更适合提交至上游项目（BuildKit 或 Syft）。若需为本项目贡献，请优先关注协议兼容性修复或文档改进。

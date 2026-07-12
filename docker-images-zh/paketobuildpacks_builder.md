---
image: paketobuildpacks/builder
description: "Paketo Builders是Paketo Buildpacks项目提供的构建器镜像，包含操作系统镜像、生命周期可执行文件和Paketo Buildpacks集合，用于通过pack CLI或其他支持Cloud Native Buildpacks的平台构建应用。⚠️这些镜像已归档，不再发布新版本。"
source: https://xuanyuan.cloud/zh/r/paketobuildpacks/builder
canonical: https://xuanyuan.cloud/zh/r/paketobuildpacks/builder
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/paketobuildpacks/builder" title="paketobuildpacks/builder Docker 镜像中文简介、标签列表与拉取命令">paketobuildpacks/builder 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Paketo Builders

## ⚠️ 这些镜像已归档，不再发布新版本！⚠️

这些被称为构建器的镜像由[Paketo Buildpacks项目](https://paketo.io/)分发，包含内部操作系统镜像（详见下文差异说明）、应用生命周期可执行文件以及一系列Paketo Buildpacks。构建器可用于通过[pack CLI](https://github.com/buildpack/pack)或其他支持Cloud Native Buildpacks的平台构建应用。

## 镜像概述和主要用途

Paketo Buildpacks项目分发以下构建器：
- `paketobuildpacks/builder:base` → 基于`Ubuntu 18.04`的最小镜像，添加了部分包（称为[mixins](https://github.com/buildpack/spec/blob/master/platform.md#mixins)），主要包括`git`和`build-essentials`
- `paketobuildpacks/builder:full` → 基于`Ubuntu 18.04`的镜像，**补充了**[常见C库](https://github.com/paketo-buildpacks/stacks/tree/main/packages/full)
- `paketobuildpacks/builder:tiny` → 最小构建镜像（与base相同），运行时使用基于`Ubuntu 18.04`的精简、类distroless运行镜像

了解更多关于构建器的信息，请访问[paketo.io](https://paketo.io/docs/builders/)

## 核心功能和特性

- **多类型构建器**：提供base、full、tiny三种构建器，满足不同场景需求
- **完整构建工具链**：包含生命周期可执行文件和Paketo Buildpacks集合，支持应用构建流程
- **基于Ubuntu 18.04**：统一的基础操作系统，确保构建环境一致性
- **差异化配置**：
  - base：最小化设计，仅包含核心构建依赖
  - full：增加常见C库，适用于需要系统库支持的应用
  - tiny：构建环境最小化，运行时镜像精简，优化资源占用

## 使用场景和适用范围

- 需要通过Cloud Native Buildpacks构建应用的开发和CI/CD场景
- base：适用于对构建环境依赖较少的简单应用
- full：适用于需要链接系统C库的复杂应用
- tiny：适用于追求最小运行时镜像体积的场景

## 使用方法和配置说明

### 查看构建器详情
要查看特定构建器镜像的详细信息（包括可用的buildpacks集合），运行：
```bash
pack inspect-builder paketobuildpacks/builder:<tag>
```
其中`<tag>`可指定为`base`、`full`或`tiny`。

### 使用特定版本的构建器
Paketo构建器通过版本标签发布，格式如下：
- **Base构建器** → `paketobuildpacks/builder:<VERSION>-base`
- **Full构建器** → `paketobuildpacks/builder:<VERSION>-full`
- **Tiny构建器** → `paketobuildpacks/builder:<VERSION>-tiny`

例如，使用1.2.3版本的base构建器：
```bash
pack build my-app --builder paketobuildpacks/builder:1.2.3-base
```

## 帮助链接
- [Paketo.io](https://paketo.io) → Paketo Buildpacks官方网站
- [Buildpacks.io](https://buildpacks.io) → Cloud Native Buildpacks官方网站
- 如需帮助，可通过[Paketo Buildpacks Slack](https://slack.paketo.io)获取支持；如遇到特定CNB问题，请在相应GitHub仓库提交issue

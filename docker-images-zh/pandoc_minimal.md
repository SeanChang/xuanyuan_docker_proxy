---
image: pandoc/minimal
description: "pandoc（通用文档转换器）的最小化镜像"
source: https://xuanyuan.cloud/zh/r/pandoc/minimal
canonical: https://xuanyuan.cloud/zh/r/pandoc/minimal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pandoc/minimal" title="pandoc/minimal Docker 镜像中文简介、标签列表与拉取命令">pandoc/minimal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# pandoc 最小化镜像

## 镜像概述与主要用途

本镜像包含[pandoc](https://pandoc.org/)——通用文档转换器，旨在提供精简的部署方案。容器已尽可能精简："static"镜像仅包含静态编译的pandoc二进制文件，其他镜像则额外包含最小化的操作系统环境。


## 核心功能与特性

- **精简镜像体积**：静态编译版本（static）仅包含pandoc可执行文件，无额外系统依赖；其他版本基于最小化操作系统（Alpine/Ubuntu）构建。
- **版本灵活控制**：支持多版本标签（如`3.7.0`、`3.7`等），满足不同版本锁定需求。
- **多操作系统支持**：提供static（默认）、Alpine、Ubuntu三种基础环境堆栈，适配不同场景。
- **开发版本支持**：通过`edge`标签提供最新开发版，便于测试前沿功能。


## 使用场景与适用范围

适用于需要轻量级pandoc环境的文档转换场景，例如：
- Markdown/HTML/LaTeX等格式间的文档转换（如生成EPUB、MOBI等）。
- CI/CD流程中集成文档转换步骤，需控制镜像体积以提升效率。
- 对系统资源敏感的环境，或仅需pandoc核心功能无需额外依赖的场景。


## 快速参考

- **获取帮助**：[pandoc-discuss邮件列表](https://groups.google.com/forum/#!forum/pandoc-discuss)
- **问题反馈**：https://github.com/pandoc/dockerfiles/issues
- **源码仓库**：[pandoc/dockerfiles](https://github.com/pandoc/dockerfiles)（GitHub）
- **维护者**：[Albert Krewinkel](https://github.com/tarleb)、[Caleb Maclennan](https://github.com/alerque)、[Damien Clochard](https://github.com/daamien)


## 详细使用指南

### 支持的标签

以下标签均指向同一镜像，数值标签为滚动更新（即版本前缀标签始终指向该前缀下的最新镜像）：

- `edge`（开发版，最新未发布功能）
- `3.7.0.2`, `3.7.0`, `3.7`, `3`, `latest`（最新稳定版）
- `3.6.4.0`, `3.6.4`, `3.6`
- `3.5.0.0`, `3.5.0`, `3.5`
- `3.2.1.0`, `3.2.1`, `3.2`

- **版本说明**：
  - 前缀版本（如`a.b.`）可指定版本范围（例：`3.7.`包含`3.7.0.2`及后续小版本）。
  - 完整四部分版本（如`a.b.c.d`）可锁定至具体版本（例：`3.7.0.2`）。
  - `latest`标签指向最新发布版本，版本发布后可能存在短暂延迟更新。


### pandoc 版本说明

pandoc既是可执行程序也是Haskell库，版本遵循[Haskell包版本策略](https://pvp.haskell.org)。即使小版本号更新，若API未变更，可能引入新行为（但此情况罕见）。


### 支持的环境堆栈

所有标签可添加堆栈标识符后缀（如`latest-ubuntu`），指定基础操作系统环境。支持的堆栈：

- **static**（默认）：静态编译的pandoc二进制文件，基于`scratch`镜像（无操作系统）。
- **alpine**：基于[Alpine Linux](https://alpinelinux.org/)，轻量级Linux发行版。
- **ubuntu**：基于[Ubuntu Linux](https://ubuntu.org/)，兼容性更广泛的Linux发行版。


### 运行容器

#### 基础命令示例

将当前目录下的`README.md`转换为`outfile.epub`：

```sh
docker run --rm \
       --volume "$(pwd):/data" \
       --user $(id -u):$(id -g) \
       docker.xuanyuan.run/pandoc/minimal README.md -o outfile.epub
```

**参数说明**：
- `--rm`：容器运行结束后自动删除。
- `--volume "$(pwd):/data"`：将本地当前目录挂载至容器内`/data`目录，使pandoc可访问源文件。
- `--user $(id -u):$(id -g)`：指定容器内运行用户ID（UID）和组ID（GID），避免输出文件权限问题。
- **命令顺序**：Docker选项（如`--rm`、`--volume`）需置于镜像名（`pandoc/minimal`）前，pandoc参数（如`README.md -o outfile.epub`）需置于镜像名后。


#### 频繁使用优化

若需频繁使用，建议设置shell别名：

```sh
alias pandock='docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/minimal'
```

设置后可直接通过`pandock`命令调用，例如：
```sh
pandock README.md -o outfile.pdf
```


## 相关镜像

除`pandoc/minimal`外，还提供以下扩展镜像：

- [**pandoc/core**](https://hub.docker.com/r/pandoc/core)：基于minimal镜像，包含文档转换常用辅助工具。
- [**pandoc/latex**](https://hub.docker.com/r/pandoc/latex)：支持通过[LaTeX](https://latex-project.org/)转换为PDF。
- [**pandoc/extra**](https://hub.docker.com/r/pandoc/extra)：基于latex镜像，包含更多工具、Tectonic引擎及[Eisvogel模板](https://github.com/Wandmalfarbe/pandoc-latex-template)。
- [**pandoc/typst**](https://hub.docker.com/r/pandoc/typst)：集成[Typst](https://typst.app/)排版系统。

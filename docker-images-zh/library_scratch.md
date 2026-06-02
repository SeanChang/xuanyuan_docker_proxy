---
image: library/scratch
description: "明确的空镜像，主要用于构建基础镜像（如debian、busybox）或超小镜像（仅包含单个二进制文件及其依赖，如hello-world）。"
source: https://xuanyuan.cloud/zh/r/library/scratch
canonical: https://xuanyuan.cloud/zh/r/library/scratch
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/scratch" title="library/scratch Docker 镜像中文简介、标签列表与拉取命令">library/scratch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FROM scratch 镜像文档

## 镜像概述

`FROM scratch` 是 Docker 保留的最小、明确的空镜像，用作构建容器的起点。在 Dockerfile 中使用 `FROM scratch` 表示希望下一个指令成为镜像的第一层文件系统。它并非传统意义上可拉取、运行或标记的镜像，而是 Docker 构建过程中的特殊指令。

## 核心功能与特性

- **无操作指令**：在 Docker 1.5.0 及以上版本（具体为 [docker/docker#8827](https://github.com/docker/docker/pull/8827)）中，`FROM scratch` 在 Dockerfile 中是无操作（no-op）指令，不会创建额外的镜像层，有效减少镜像层数（例如，原本的 2 层镜像可变为 1 层）。
- **明确的空镜像**：作为构建基础，提供一个完全空白的起点，确保后续添加的内容是镜像的唯一组成部分，无冗余。

## 使用场景

- **构建基础镜像**：作为构建其他基础镜像（如 `debian`、`busybox` 等）的起点，确保基础镜像的纯净性和最小化。
- **构建超小镜像**：创建仅包含单个二进制文件及其必要依赖的超小镜像，例如 `hello-world` 镜像，仅包含可执行文件和运行所需的最小依赖。

## 使用方法

### 基本说明

`scratch` 不会出现在 Docker Hub 的可拉取镜像列表中，无法直接拉取、运行或标记该镜像。只能在 Dockerfile 中通过 `FROM scratch` 指令引用它，指示构建过程从空白开始。

### Dockerfile 示例

以下示例展示如何使用 `FROM scratch` 创建一个仅包含单个二进制文件的最小容器：

```dockerfile
FROM scratch
COPY hello /
CMD ["/hello"]
```

**说明**：  
- `FROM scratch`：指定以空白镜像为起点。  
- `COPY hello /`：将本地编译好的 `hello` 二进制文件复制到镜像的根目录。  
- `CMD ["/hello"]`：设置容器启动时执行的命令，即运行 `hello` 二进制文件。

### 引用来源

上述使用方法参考自 [Docker 官方文档](https://docs.docker.com/engine/userguide/eng-image/baseimages/#creating-a-simple-parent-image-using-scratch)：  
> 你可以使用 Docker 保留的最小镜像 `scratch` 作为构建容器的起点。使用 `scratch` “镜像” 向构建过程表明，你希望 Dockerfile 中的下一个命令成为镜像的第一层文件系统。

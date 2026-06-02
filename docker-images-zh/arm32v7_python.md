---
image: arm32v7/python
description: "Python是一种解释型、交互式、面向对象的开源编程语言，适用于各类软件开发。"
source: https://xuanyuan.cloud/zh/r/arm32v7/python
canonical: https://xuanyuan.cloud/zh/r/arm32v7/python
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm32v7/python" title="arm32v7/python Docker 镜像中文简介、标签列表与拉取命令">arm32v7/python — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/arm32v7/python" title="arm32v7/python Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/arm32v7/python</a>

# arm32v7/python 镜像文档

## 镜像概述和主要用途

**注意**：本仓库是 [python 官方镜像](https://hub.docker.com/_/python) 的 `arm32v7` 架构专用构建版本，用于在 ARM 32位设备上运行 Python 应用程序。更多架构相关信息请参见 [官方镜像文档](https://github.com/docker-library/official-images#architectures-other-than-amd64) 及 [FAQ](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

Python 是一种解释型、交互式、面向对象的开源编程语言，具有简洁的语法和强大的功能，支持模块、异常处理、动态类型、高级数据类型和类。本镜像提供了在 `arm32v7` 架构设备上运行 Python 的标准化环境，支持多种版本和基础系统配置，适用于开发和部署各类 Python 应用。

## 核心功能和特性

- **多版本支持**：涵盖 Python 3.9 及以上版本，包括稳定版（如 3.14、3.13）和候选发布版（如 3.15-rc）
- **架构优化**：专为 ARM 32位架构设计，确保在树莓派等 ARM 设备上的兼容性
- **多样变体**：提供三种基础镜像类型以适应不同需求：
  - 基于 Debian（trixie、bookworm）的完整版本
  - 精简的 `slim` 版本（最小系统依赖）
  - 轻量级的 `alpine` 版本（基于 Alpine Linux）
- **完整工具链**：默认版本包含编译工具和系统库，支持大多数 Python 包的直接安装
- **官方维护**：由 Docker 社区维护，定期同步 Python 官方更新，确保安全性和稳定性
- **灵活部署**：支持通过 Dockerfile 构建应用镜像或直接运行单文件脚本

## 使用场景和适用范围

- **开发与测试**：在 ARM 设备上快速搭建一致的 Python 开发环境，避免环境差异问题
- **生产部署**：部署 Python 应用到 ARM 架构的嵌入式设备、边缘计算节点或 IoT 设备
- **资源受限环境**：`slim` 和 `alpine` 变体适用于存储空间有限的场景
- **多版本需求**：支持在同一设备上通过不同标签运行多个 Python 版本
- **自动化任务**：运行定时脚本、数据处理任务或轻量级服务

## 支持的标签及 Dockerfile 链接

### Simple Tags

以下为主要标签示例（完整列表请参考 [官方仓库](https://github.com/docker-library/python)）：

- `3.15.0a1-trixie`, `3.15-rc-trixie` ([Dockerfile](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/trixie/Dockerfile))
- `3.15.0a1-slim-trixie`, `3.15-rc-slim-trixie`, `3.15.0a1-slim`, `3.15-rc-slim` ([Dockerfile](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/slim-trixie/Dockerfile))
- `3.15.0a1-alpine3.22`, `3.15-rc-alpine3.22`, `3.15.0a1-alpine`, `3.15-rc-alpine` ([Dockerfile](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/alpine3.22/Dockerfile))
- `3.14.0-trixie`, `3.14-trixie`, `3-trixie`, `trixie` ([Dockerfile](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/trixie/Dockerfile))
- `3.14.0-slim-trixie`, `3.14-slim-trixie`, `3-slim-trixie`, `slim-trixie`, `3.14.0-slim`, `3.14-slim`, `3-slim`, `slim` ([Dockerfile](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/slim-trixie/Dockerfile))
- `3.14.0-alpine3.22`, `3.14-alpine3.22`, `3-alpine3.22`, `alpine3.22`, `3.14.0-alpine`, `3.14-alpine`, `3-alpine`, `alpine` ([Dockerfile](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/alpine3.22/Dockerfile))
- `3.13.9-trixie`, `3.13-trixie` ([Dockerfile](https://github.com/docker-library/python/blob/3f2d7e4c339ab883455b81a873519f1d0f2cd80a/3.13/trixie/Dockerfile))
- `3.12.12-trixie`, `3.12-trixie` ([Dockerfile](https://github.com/docker-library/python/blob/e4ab0fe5ef4df797ed09883becf983a56ab97eca/3.12/trixie/Dockerfile))
- `3.11.14-trixie`, `3.11-trixie` ([Dockerfile](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.11/trixie/Dockerfile))
- `3.10.19-trixie`, `3.10-trixie` ([Dockerfile](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.10/trixie/Dockerfile))
- `3.9.24-trixie`, `3.9-trixie` ([Dockerfile](https://github.com/docker-library/python/blob/00c4cce6b91488475bfaf85921bae12604a56d4a/3.9/trixie/Dockerfile))

### Shared Tags

Shared Tags 为版本别名，指向特定基础镜像：

- `3.15.0a1`, `3.15-rc` → `3.15.0a1-trixie`
- `3.14.0`, `3.14`, `3`, `latest` → `3.14.0-trixie`
- `3.13.9`, `3.13` → `3.13.9-trixie`
- `3.12.12`, `3.12` → `3.12.12-trixie`
- `3.11.14`, `3.11` → `3.11.14-trixie`
- `3.10.19`, `3.10` → `3.10.19-trixie`
- `3.9.24`, `3.9` → `3.9.24-trixie`

## 详细使用方法和配置说明

### 通过 Dockerfile 构建应用

在 Python 项目根目录创建 `Dockerfile`：

```dockerfile
# 使用 Python 3 最新版本
FROM arm32v7/python:3

WORKDIR /usr/src/app

# 复制依赖文件并安装
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 运行应用
CMD ["python", "./your-daemon-or-script.py"]
```

构建并运行镜像：

```console
$ docker build -t my-python-app .
$ docker run -it --rm --name my-running-app my-python-app
```

### 直接运行单个 Python 脚本

无需创建 Dockerfile，直接挂载本地脚本运行：

```console
$ docker run -it --rm --name my-running-script \
  -v "$PWD":/usr/src/myapp \
  -w /usr/src/myapp \
  arm32v7/python:3 \
  python your-script.py
```

### 多 Python 版本共存说明

在非 slim 变体中，系统可能存在两个 Python 可执行文件：
- `/usr/local/bin/python`：镜像提供的 Python 版本（默认在 `$PATH` 中，优先使用）
- `/usr/bin/python`/`/usr/bin/python3`：Debian 系统自带版本

建议使用 `/usr/local/bin/python` 显式指定镜像提供的 Python 版本。

## 镜像变体详解

### 默认变体（`arm32v7/python:<version>`）

基于 `buildpack-deps` 构建，包含完整的 Debian 系统依赖和编译工具链，支持大多数 Python 包的直接安装（包括需编译的包如 `numpy`、`pillow`）。适用于大多数开发和生产场景，无需额外配置系统依赖。

### slim 变体（`arm32v7/python:<version>-slim`）

仅包含运行 Python 所需的最小 Debian 依赖，镜像体积显著小于默认版本。**限制**：安装需编译的 Python 包时可能失败，需手动安装编译依赖（如 `gcc`、`libc6-dev`）。适用于空间受限且依赖纯 Python 包的场景。

### alpine 变体（`arm32v7/python:<version>-alpine`）

基于 Alpine Linux 构建，追求最小镜像体积（基础镜像约 5MB）。使用 musl libc 替代 glibc，可能导致部分依赖 libc 的 Python 包不兼容。需通过 `apk add` 安装系统依赖，适用于资源极度受限的嵌入式环境。

## 快速参考

- **维护者**：[Docker 社区](https://github.com/docker-library/python)
- **获取帮助**：[Docker Community Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)、[Stack Overflow](https://stackoverflow.com/help/on-topic)
- **提交 issue**：[https://github.com/docker-library/python/issues](https://github.com/docker-library/python/issues?q=)
- **支持架构**：`amd64`、`arm32v5`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`mips64le`、`ppc64le`、`riscv64`、`s390x`、`windows-amd64`
- **镜像详情**：[repo-info 仓库](https://github.com/docker-library/repo-info/blob/master/repos/python)（包含元数据、传输大小等）
- **更新信息**：[official-images repo](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fpython)、[文件历史](https://github.com/docker-library/official-images/blob/master/library/python)
- **文档来源**：[docs repo](https://github.com/docker-library/docs/tree/master/python)

## 许可信息

Python 许可信息：[Python 2](https://docs.python.org/2/license.html)、[Python 3](https://docs.python.org/3/license.html)。

本镜像包含的其他软件（如 Debian 组件、Bash 等）的许可信息需参考各自官方文档。部分许可信息可在 [repo-info 仓库](https://github.com/docker-library/repo-info/tree/master/repos/python) 中找到。使用本镜像需遵守所有包含软件的许可协议。

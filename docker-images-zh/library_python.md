---
image: library/python
description: "Python是一种解释型、交互式、面向对象的开源编程语言，其设计理念强调代码的可读性与简洁性，支持多种编程范式，凭借丰富的标准库和第三方库，广泛应用于Web开发、数据分析、人工智能、科学计算、自动化脚本等众多领域，拥有活跃的全球开发者社区，是兼具易用性与强大功能的高效编程工具。"
source: https://xuanyuan.cloud/zh/r/library/python
canonical: https://xuanyuan.cloud/zh/r/library/python
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/python" title="library/python Docker 镜像中文简介、标签列表与拉取命令">library/python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Python Docker 镜像使用指南


## 快速参考

- **维护者**：  
  [Docker 社区]([])

- **获取帮助**：  
  [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应 Dockerfile 链接

（关于“共享标签”和“简单标签”的区别，参见 FAQ 中的[说明]([])。）


### 简单标签

- [`3.14.0-trixie`, `3.14-trixie`, `3-trixie`, `trixie`]([])  
- [`3.14.0-slim-trixie`, `3.14-slim-trixie`, `3-slim-trixie`, `slim-trixie`, `3.14.0-slim`, `3.14-slim`, `3-slim`, `slim`]([])  
- [`3.14.0-bookworm`, `3.14-bookworm`, `3-bookworm`, `bookworm`]([])  
- [`3.14.0-slim-bookworm`, `3.14-slim-bookworm`, `3-slim-bookworm`, `slim-bookworm`]([])  
- [`3.14.0-alpine3.22`, `3.14-alpine3.22`, `3-alpine3.22`, `alpine3.22`, `3.14.0-alpine`, `3.14-alpine`, `3-alpine`, `alpine`]([])  
- [`3.14.0-alpine3.21`, `3.14-alpine3.21`, `3-alpine3.21`, `alpine3.21`]([])  
- [`3.14.0-windowsservercore-ltsc2025`, `3.14-windowsservercore-ltsc2025`, `3-windowsservercore-ltsc2025`, `windowsservercore-ltsc2025`]([])  
- [`3.14.0-windowsservercore-ltsc2022`, `3.14-windowsservercore-ltsc2022`, `3-windowsservercore-ltsc2022`, `windowsservercore-ltsc2022`]([])  

（以下为 3.13 至 3.9 版本的标签，结构同上，完整列表可参考原始链接）


### 共享标签

- `3.14.0`, `3.14`, `3`, `latest`：  
  - [`3.14.0-trixie`]([])  
  - [`3.14.0-windowsservercore-ltsc2025`]([])  
  - [`3.14.0-windowsservercore-ltsc2022`]([])  

- `3.14.0-windowsservercore`, `3.14-windowsservercore`, `3-windowsservercore`, `windowsservercore`：  
  - [`3.14.0-windowsservercore-ltsc2025`]([])  
  - [`3.14.0-windowsservercore-ltsc2022`]([])  

（以下为 3.13 至 3.9 版本的共享标签，结构同上，完整列表可参考原始链接）


## 快速参考（续）

- **问题反馈**：  
  [[]]([])  

- **支持的架构**（[更多信息]([])）：  
  [`amd64`]([])、[`arm32v5`]([])、[`arm32v6`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`i386`]([])、[`mips64le`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])、[`windows-amd64`]([])  

- **镜像详情**：  
  [repo-info 仓库的 `repos/python/` 目录]([])（[历史记录]([])）（包含元数据、传输大小等）  

- **镜像更新**：  
  [official-images 仓库的 `library/python` 标签]([])  
  [official-images 仓库的 `library/python` 文件]([])（[历史记录]([])）  

- **本文档来源**：  
  [docs 仓库的 `python/` 目录]([])（[历史记录]([])）  


## 什么是 Python？

Python 是一种解释型、交互式、面向对象的开源编程语言。它支持模块、异常处理、动态类型、高级动态数据类型和类。Python 兼具强大功能和清晰语法，可调用众多系统调用、库和窗口系统接口，也可通过 C 或 C++ 扩展。此外，Python 具有可移植性，可在多种 Unix 变体、Mac 和 Windows 2000 及更高版本系统上运行。

> [.org/wiki/Python_(programming_language)]()  

![logo]([])  


## 如何使用这个镜像

### 在 Python 项目中创建 `Dockerfile`

```dockerfile
FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```

如果需要使用 Python 2：

```dockerfile
FROM python:2

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```

构建并运行镜像：

```console
$ docker build -t my-python-app .
$ docker run -it --rm --name my-running-app my-python-app
```


### 运行单个 Python 脚本

对于简单的单文件项目，可直接使用 Python 镜像运行脚本：

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3 python your-daemon-or-script.py
```

使用 Python 2 时：

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:2 python your-daemon-or-script.py
```


### 镜像中的多 Python 版本

非 slim 变体中，除了镜像自带的 `/usr/local/bin/python`（默认在 `$PATH` 中），还可能存在发行版提供的 `/usr/bin/python` 或 `/usr/bin/python3`。这是由于非 slim 变体基于 `buildpack-deps` 镜像，部分系统工具依赖发行版 Python，因此无法安全移除。


## 镜像变体

Python 镜像提供多种变体，适用于不同场景：

### `python:<version>`（默认镜像）

适合大多数场景，基于 `buildpack-deps` 构建，包含大量常用 Debian 包，减少衍生镜像的依赖安装工作。标签中的 `bookworm` 或 `trixie` 表示基于 Debian 的对应版本，建议显式指定以避免 Debian 版本更新导致的兼容性问题。


### `python:<version>-slim`（精简版）

仅包含运行 Python 所需的最小 Debian 包，体积更小。但 `pip install` 可能因缺少编译依赖而失败（如安装需编译的源码包）。解决方案：  
- 手动安装缺失的 Debian 包后再执行 `pip install`；  
- 改用默认镜像（包含多数常用编译依赖，适合大多数 `pip install` 场景）。


### `python:<version>-alpine`（ Alpine 版）

基于 [Alpine Linux]([])（体积 ~5MB），镜像极小。但使用 `musl libc` 而非 `glibc`，可能存在兼容性问题（如部分依赖 `glibc` 的扩展模块）。适合对体积有严格要求且无兼容性问题的场景。


### `python:<version>-windowsservercore`（Windows 版）

基于 [Windows Server Core]([])，仅支持 Windows 10 专业版/企业版（周年更新及以上）或 Windows Server 2016 及以上系统。


## 许可证

Python 2 和 Python 3 的许可证信息可分别参考 [Python 2 许可证]([]) 和 [Python 3 许可证]([])。  
镜像中可能包含其他软件，使用前需确保符合所有组件的许可证要求。

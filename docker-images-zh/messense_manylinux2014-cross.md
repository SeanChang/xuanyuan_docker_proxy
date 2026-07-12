---
image: messense/manylinux2014-cross
description: "用于aarch64和armv7l架构的manylinux2014交叉编译镜像"
source: https://xuanyuan.cloud/zh/r/messense/manylinux2014-cross
canonical: https://xuanyuan.cloud/zh/r/messense/manylinux2014-cross
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/messense/manylinux2014-cross" title="messense/manylinux2014-cross Docker 镜像中文简介、标签列表与拉取命令">messense/manylinux2014-cross 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述
该镜像专为aarch64（ARM64）和armv7l（ARM32）架构提供manylinux2014标准的交叉编译环境，旨在简化跨平台软件构建流程，尤其适用于生成兼容主流Linux发行版的二进制软件包。

## 核心功能和特性
- **多架构支持**：同时支持aarch64（64位ARM）和armv7l（32位ARM）两种目标架构
- **manylinux2014兼容**：严格遵循PEP 599规范，确保构建产物兼容基于glibc 2.17及以上的Linux系统
- **完整工具链**：集成交叉编译必需的gcc、g++、binutils等工具链，以及Python开发依赖
- **预配置环境**：内置auditwheel、patchelf等manylinux工具，可直接用于Python wheel包构建
- **灵活定制**：支持通过环境变量调整编译参数，适应不同构建需求

## 使用场景和适用范围
- **Python扩展开发**：为ARM架构构建符合manylinux2014标准的Python wheel包
- **跨平台软件编译**：在x86_64主机上为ARM嵌入式设备或服务器编译应用程序
- **CI/CD集成**：作为自动化构建流程的一部分，批量生成多架构软件包
- **开源项目分发**：为开源项目提供统一的交叉编译环境，简化多平台发布流程

## 使用方法和配置说明### 基本使用示例
通过以下命令启动容器并进入交互式编译环境：

```bash
docker run -it --rm -v $(pwd):/workspace docker.xuanyuan.run/manylinux2014-cross:latest
```

### 指定目标架构编译
通过环境变量`TARGET_ARCH`指定目标架构（默认aarch64）：

```bash
# 构建aarch64架构目标
docker run -it --rm -e TARGET_ARCH=aarch64 -v $(pwd):/workspace docker.xuanyuan.run/manylinux2014-cross:latest

# 构建armv7l架构目标
docker run -it --rm -e TARGET_ARCH=armv7l -v $(pwd):/workspace docker.xuanyuan.run/manylinux2014-cross:latest
```

### 构建Python Wheel包完整流程
1. 挂载源码目录到容器工作区
2. 执行构建命令生成原始wheel
3. 使用auditwheel修复兼容性

```bash
# 宿主机执行
docker run -it --rm -v /path/to/your/project:/workspace docker.xuanyuan.run/manylinux2014-cross:latest /bin/bash -c "
  cd /workspace && \
  python setup.py bdist_wheel && \
  auditwheel repair dist/*.whl --plat manylinux2014_\${TARGET_ARCH}
"
```

### 高级配置选项#### 环境变量
| 变量名         | 说明                                                                 | 默认值                          |
|----------------|----------------------------------------------------------------------|---------------------------------|
| `TARGET_ARCH`  | 目标架构，可选值：`aarch64`、`armv7l`                                | `aarch64`                       |
| `WORKSPACE`    | 工作目录路径                                                         | `/workspace`                    |
| `CC`           | C编译器路径，默认使用对应架构的交叉编译器（如`aarch64-linux-gnu-gcc`） | 自动匹配目标架构的gcc           |
| `CXX`          | C++编译器路径，默认使用对应架构的交叉编译器                           | 自动匹配目标架构的g++           |
| `MAKEFLAGS`    | make命令额外参数（如`-j4`启用并行编译）                              | 空                              |

#### 数据卷挂载
推荐挂载以下目录以实现数据持久化和文件交换：
- 源码目录：`-v /local/source:/workspace`（必选）
- 输出目录：`-v /local/output:/workspace/dist`（可选，指定编译产物输出路径）
- 缓存目录：`-v /local/cache:/root/.cache`（可选，加速重复构建）

### 典型编译命令示例
构建C语言项目：
```bash
docker run -it --rm -v $(pwd):/workspace docker.xuanyuan.run/manylinux2014-cross:latest /bin/bash -c "
  cd /workspace && \
  ./configure --host=aarch64-linux-gnu && \
  make -j4 && \
  make install DESTDIR=/workspace/output
"

---
image: coreboot/coreboot-sdk
description: "coreboot构建环境镜像，提供预配置的工具链和依赖组件，用于简化coreboot固件的编译、开发与测试流程，无需手动搭建开发环境。"
source: https://xuanyuan.cloud/zh/r/coreboot/coreboot-sdk
canonical: https://xuanyuan.cloud/zh/r/coreboot/coreboot-sdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/coreboot/coreboot-sdk" title="coreboot/coreboot-sdk Docker 镜像中文简介、标签列表与拉取命令">coreboot/coreboot-sdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# coreboot 构建环境镜像文档

## 概述
coreboot构建环境镜像是一个预配置的Docker镜像，旨在为coreboot固件开发提供标准化、隔离的编译环境。该镜像集成了coreboot编译所需的全套工具链、依赖库及配置脚本，可帮助开发者快速启动coreboot项目开发，避免手动安装和配置复杂依赖的繁琐过程，确保构建环境的一致性和可重复性。

## 核心功能与特性
- **预配置工具链**：内置gcc、ld、objcopy等编译器及binutils工具链，满足coreboot编译需求
- **完整依赖集成**：包含coreboot构建所需的libreoffice、acpica-tools、python等依赖组件
- **隔离环境**：基于Docker容器的隔离环境，避免对主机系统环境的干扰和污染
- **多版本支持**：兼容主流coreboot版本（如4.15+），可通过配置适配特定版本需求
- **简化编译流程**：内置初始化脚本，可快速加载编译配置并启动构建过程

## 使用场景与适用范围
- **coreboot开发者**：日常开发、调试coreboot源码时的标准化构建环境
- **固件工程师**：验证自定义固件功能、优化启动流程的测试环境
- **研究人员**：分析coreboot架构、开发新硬件支持时的实验环境
- **学习用户**：快速上手coreboot，无需深入了解底层依赖配置的学习工具

## 使用方法与配置说明

### 基本使用流程
1. **拉取镜像**（若需）：
   ```bash
   docker pull docker.xuanyuan.run/[镜像仓库地址]/coreboot-build-env:latest
   ```

2. **启动容器并挂载源码**：
   将本地coreboot源码目录挂载至容器内，实现源码共享与编译产物持久化：
   ```bash
   docker run -it --rm \
     -v /本地/coreboot源码目录:/workspace \
     -w /workspace \
     docker.xuanyuan.run/[镜像仓库地址]/coreboot-build-env:latest \
     bash
   ```
   - `-v /本地/coreboot源码目录:/workspace`：挂载本地coreboot源码至容器内`/workspace`目录
   - `-w /workspace`：设置工作目录为挂载的源码目录
   - `--rm`：容器退出后自动清理，避免残留

3. **执行编译操作**：
   容器启动后，在交互式终端中执行coreboot编译命令：
   ```bash
   # 加载默认配置（或自定义配置）
   make menuconfig
   
   # 开始编译
   make -j$(nproc)
   ```
   编译产物（如`build/coreboot.rom`）将保存在挂载的本地源码目录中。

### 高级配置（可选）
#### 环境变量
可通过`-e`参数传递环境变量，自定义构建行为：
- `COREBOOT_VERSION`：指定coreboot版本（如`4.20`），容器将自动适配对应工具链
- `PARALLEL_JOBS`：设置并行编译任务数（默认使用`nproc`值）
  ```bash
  docker run -it --rm \
    -v /本地/coreboot源码目录:/workspace \
    -e PARALLEL_JOBS=8 \
    docker.xuanyuan.run/[镜像仓库地址]/coreboot-build-env:latest \
    bash
  ```

#### 持久化构建缓存
为加速重复编译，可挂载缓存目录保存中间文件：
```bash
docker run -it --rm \
  -v /本地/coreboot源码目录:/workspace \
  -v /本地/cache目录:/cache \
  -e COREBOOT_CACHE=/cache \
  docker.xuanyuan.run/[镜像仓库地址]/coreboot-build-env:latest \
  bash
```

## 注意事项
- 确保本地Docker环境已正确安装并运行（支持Docker 19.03+版本）
- 挂载的本地目录需具有读写权限，避免容器内编译失败
- 大型coreboot项目编译可能需要较高内存（建议主机内存≥8GB）
- 如需自定义工具链版本，可基于此镜像构建派生镜像并修改`Dockerfile`

## 典型应用示例
### 编译默认配置的coreboot固件
```bash
# 1. 克隆coreboot源码（本地操作）
git clone https://review.coreboot.org/coreboot.git
cd coreboot

# 2. 启动构建容器并编译
docker run -it --rm -v $(pwd):/workspace -w /workspace docker.xuanyuan.run/coreboot-build-env:latest bash
# 在容器内执行：
make defconfig
make -j$(nproc)
# 编译完成后，固件文件位于 ./build/coreboot.rom（本地目录）
```

### 调试特定硬件的coreboot适配
```bash
# 挂载包含硬件适配补丁的源码目录
docker run -it --rm \
  -v /本地/coreboot-with-patches:/workspace \
  -e COREBOOT_VERSION=4.21 \
  coreboot-build-env:latest \
  bash
# 在容器内加载硬件配置并编译
make menuconfig  # 配置目标硬件参数
make -j4

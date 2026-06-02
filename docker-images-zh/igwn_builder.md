---
image: igwn/builder
description: "IGWN持续集成任务的典型构建环境"
source: https://xuanyuan.cloud/zh/r/igwn/builder
canonical: https://xuanyuan.cloud/zh/r/igwn/builder
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/igwn/builder" title="igwn/builder Docker 镜像中文简介、标签列表与拉取命令">igwn/builder 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# IGWN 持续集成作业构建环境镜像文档


## 1. 镜像概述与主要用途

本镜像为国际引力波网络（International Gravitational-Wave Network, IGWN）项目的持续集成（Continuous Integration, CI）作业提供标准化构建环境。镜像整合了IGWN项目开发、测试与构建所需的核心依赖工具、库及运行时环境，旨在解决跨团队开发中的环境一致性问题，简化CI流水线配置，提升作业执行效率与可靠性。


## 2. 核心功能与特性

### 2.1 预装工具链与依赖
- **基础构建工具**：GCC (≥10)、Clang (≥12)、CMake (≥3.20)、Make、Ninja
- **版本控制**：Git (≥2.30)、Subversion (≥1.14)
- **编程语言支持**：Python (3.8-3.11，含pip、virtualenv)、Perl (≥5.30)、Shell (bash/zsh)
- **科学计算库**：FFTW (≥3.3)、OpenBLAS (≥0.3.15)、HDF5 (≥1.12)
- **IGWN项目专用依赖**：LIGO Scientific Collaboration (LSC) 基础库（如`libframe`、`lal`）、引力波数据分析工具链（`pycbc`、`gwpy`）

### 2.2 CI流程支持
- 内置CI代理客户端，兼容Jenkins、GitHub Actions、GitLab CI等主流CI平台
- 支持构建缓存（`ccache`、`pip cache`），加速重复构建
- 集成测试框架（pytest、CTest、Google Test），支持自动化测试报告生成

### 2.3 环境管理特性
- 基于Ubuntu LTS（20.04/22.04）构建，系统稳定性高
- 环境隔离：容器化运行，避免主机环境干扰
- 多架构支持：适配x86_64、ARM64（部分版本）


## 3. 使用场景与适用范围

### 3.1 典型使用场景
- **代码编译**：IGWN项目源码（如引力波探测器控制软件、数据分析 pipeline）的跨版本编译验证
- **单元测试**：自动化执行代码单元测试、集成测试，生成覆盖率报告
- **文档生成**：基于Sphinx、Doxygen构建项目API文档与用户手册
- **软件打包**：构建IGWN标准格式软件包（如RPM、DEB、conda包）
- **兼容性验证**：测试代码在不同依赖版本下的兼容性（通过环境变量调整依赖版本）

### 3.2 适用用户
- IGWN合作机构开发者（如LIGO、Virgo、KAGRA团队）
- 引力波数据分析软件项目维护者
- 参与IGWN相关开源项目（如`gwpy`、`ligo-skymap`）的科研团队


## 4. 使用方法与配置说明

### 4.1 获取镜像
镜像通常托管于IGWN私有容器仓库或Docker Hub（需权限访问）。通过以下命令拉取：
```bash
docker pull igwn/ci-build-env:latest  # 最新稳定版
# 或指定版本标签（如基于Ubuntu 22.04的版本）
docker pull igwn/ci-build-env:ubuntu22.04-v1.5.0
```


### 4.2 基本运行命令（`docker run`）
#### 4.2.1 交互式构建环境
启动容器并进入交互式终端，用于手动调试或临时构建：
```bash
docker run -it --rm \
  -v /path/to/local/source:/workspace/src \  # 挂载本地源码目录
  -v /path/to/cache:/var/cache/ci-build  # 挂载构建缓存（加速重复构建）
  -e WORKDIR=/workspace/src \  # 设置工作目录
  -e BUILD_TARGET=release \  # 指定构建目标（release/debug/test）
  igwn/ci-build-env:latest \
  /bin/bash  # 启动bash终端
```

#### 4.2.2 非交互式CI作业执行
直接在容器中运行预设CI脚本（如编译+测试）：
```bash
docker run --rm \
  -v $(pwd):/workspace \  # 挂载当前目录为工作区
  -e LOG_LEVEL=info \  # 设置日志级别（debug/info/warn/error）
  -e HTTP_PROXY=http://proxy.example.com:8080 \  # 配置网络代理（如需要）
  igwn/ci-build-env:latest \
  /opt/igwn/ci/scripts/run-build.sh  # 执行内置CI脚本
```


### 4.3 Docker Compose配置示例
创建`docker-compose.yml`简化多环境配置：
```yaml
version: '3.8'
services:
  igwn-ci-build:
    image: igwn/ci-build-env:ubuntu22.04-v1.5.0
    volumes:
      - ./src:/workspace/src:ro  # 只读挂载源码
      - ci-cache:/var/cache/ci-build  # 持久化缓存卷
      - ./output:/workspace/output  # 挂载输出目录（存放构建产物）
    environment:
      - WORKDIR=/workspace/src
      - BUILD_TARGET=test
      - LOG_LEVEL=debug
      - CACHE_DIR=/var/cache/ci-build
    command: ["/opt/igwn/ci/scripts/run-test.sh"]  # 执行测试脚本

volumes:
  ci-cache:  # 声明持久化缓存卷（避免重复下载依赖）
```

启动命令：
```bash
docker-compose up --build  # --build可选，用于强制重建（如需修改配置）
```


### 4.4 配置参数详解

#### 4.4.1 环境变量
| 变量名          | 描述                                  | 默认值                  | 可选值                          |
|-----------------|---------------------------------------|-------------------------|---------------------------------|
| `WORKDIR`       | 容器内工作目录                        | `/workspace`            | 绝对路径（如`/src/igwn-project`）|
| `BUILD_TARGET`  | 构建目标类型                          | `release`               | `release`/`debug`/`test`/`docs` |
| `LOG_LEVEL`     | 日志输出级别                          | `info`                  | `debug`/`info`/`warn`/`error`   |
| `HTTP_PROXY`    | HTTP代理地址（用于网络受限环境）      | 空（不启用代理）        | 代理URL（如`http://proxy:8080`）|
| `HTTPS_PROXY`   | HTTPS代理地址                         | 空                      | 同上                            |
| `CACHE_DIR`     | 构建缓存目录（用于`ccache`等工具）    | `/var/cache/ci-build`   | 绝对路径                        |
| `PYTHON_VERSION`| 指定Python版本（需镜像支持多版本）    | `3.10`                  | `3.8`/`3.9`/`3.10`/`3.11`       |

#### 4.4.2 数据卷挂载建议
| 挂载路径（容器内）         | 用途                          | 宿主机路径示例                  |
|---------------------------|-------------------------------|---------------------------------|
| `/workspace/src`          | 源码目录（建议只读挂载）      | `./project-src`                 |
| `/workspace/output`       | 构建产物输出目录              | `./build-output`                |
| `/var/cache/ci-build`     | 构建缓存（加速重复构建）      | `./ci-cache`（持久化目录）      |
| `/etc/igwn/ci/config.d`   | 自定义CI配置文件目录          | `./custom-config`               |


### 4.5 自定义构建流程
若内置CI脚本不满足需求，可挂载自定义脚本到容器并执行：
```bash
docker run --rm \
  -v ./my-build-script.sh:/workspace/scripts/custom-build.sh \
  -v ./src:/workspace/src \
  igwn/ci-build-env:latest \
  bash /workspace/scripts/custom-build.sh  # 执行自定义脚本
```


## 5. 注意事项
- **权限管理**：容器默认以非root用户（`igwn-ci`，UID=1000）运行，挂载宿主机目录时需确保权限匹配（可通过`-u $(id -u):$(id -g)`指定用户ID）。
- **镜像更新**：定期拉取最新镜像以获取依赖更新和安全补丁（推荐在CI配置中启用`latest`标签或定期更新版本号）。
- **资源限制**：CI作业可能消耗大量CPU/内存，建议通过`--cpus`、`--memory`参数限制容器资源（如`--cpus 4 --memory 8g`）。

---
image: intel/oneapi-basekit
description: "Intel® oneAPI Base Toolkit Docker镜像提供跨架构编程工具与库，支持高性能计算、数据分析等领域应用开发，助力构建高效异构计算解决方案。"
source: https://xuanyuan.cloud/zh/r/intel/oneapi-basekit
canonical: https://xuanyuan.cloud/zh/r/intel/oneapi-basekit
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/oneapi-basekit" title="intel/oneapi-basekit Docker 镜像中文简介、标签列表与拉取命令">intel/oneapi-basekit 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Intel® oneAPI Base Toolkit 镜像文档


## 一、镜像概述和主要用途

Intel® oneAPI Base Toolkit 镜像是包含核心工具和库的容器化解决方案，用于构建和部署跨多种架构的高性能、数据中心应用。该镜像集成了oneAPI生态系统的基础组件，旨在简化跨CPU、GPU、FPGA等异构硬件平台的应用开发流程，提供统一的编程模型和优化工具链。


## 二、核心功能和特性

### 2.1 核心编程模型
- **数据并行C++（DPC++）语言**：C++的演进版本，支持跨硬件目标（CPU、GPU、FPGA）的代码重用，同时允许针对特定加速器进行自定义性能调优。

### 2.2 性能加速组件
- **特定领域库**：提供面向高性能计算、数据分析等场景的优化库，支持跨架构无缝加速。
- **Intel® Distribution for Python**：集成优化的Python发行版，提供开箱即用的跨架构加速能力。

### 2.3 开发与调试工具
- 增强型性能分析工具：支持应用性能瓶颈识别与优化。
- 设计辅助工具：简化跨架构代码迁移与适配流程。
- 调试工具链：提供针对异构计算的调试支持，确保代码正确性与稳定性。


## 三、使用场景和适用范围

### 3.1 主要使用场景
- 高性能计算（HPC）应用开发与优化。
- 数据中心级应用的跨架构部署。
- 异构计算环境下的代码迁移（如CUDA至DPC++）与性能调优。
- 多硬件平台（CPU/GPU/FPGA）的统一编程模型验证与测试。

### 3.2 适用范围
- 开发人员：需要跨架构编写高性能代码的软件工程师。
- 研究机构：从事异构计算、并行算法研究的学术团队。
- 企业用户：构建数据中心级高性能应用的技术团队。


## 四、使用方法和配置说明

### 4.1 可用容器镜像

| 镜像标签                     | 基础系统       | 用途                 |
|------------------------------|----------------|----------------------|
| `intel/oneapi-basekit:devel-ubuntu22.04` | Ubuntu 22.04   | 开发环境（演示用）   |
| `intel/oneapi-basekit:devel-ubuntu24.04` | Ubuntu 24.04   | 开发环境（演示用）   |
| `intel/oneapi-basekit:devel-rockylinux9` | Rocky Linux 9  | 开发环境             |

> 注：Singularity容器版本可参考 [Singularity containers](https://github.com/intel/oneapi-containers/tree/master/images/singularity)。


### 4.2 Docker部署示例

#### 4.2.1 拉取并运行容器
以 `devel-ubuntu22.04` 为例，拉取并启动交互式容器：
```bash
docker run -it --rm docker.xuanyuan.run/intel/oneapi-basekit:devel-ubuntu22.04
```
- `-it`：启用交互式终端。
- `--rm`：容器退出后自动删除。

#### 4.2.2 容器内环境配置
进入容器后，需加载oneAPI环境变量以使用工具链：
```bash
source /opt/intel/oneapi/setvars.sh
```
执行后，DPC++编译器（`dpcpp`）、性能分析工具（如`vtune`）等组件将添加至系统路径。


### 4.3 生产环境注意事项
- **Ubuntu容器限制**：所有Ubuntu基础镜像仅用于演示，不建议直接用于生产环境。如需生产级安全维护，需参考 [Dockerfile中启用Ubuntu Pro的指南](https://documentation.ubuntu.com/pro-client/en/docs/howtoguides/enable_in_dockerfile/) 重建镜像，以获取Canonical提供的扩展安全支持。
- **DPC++兼容性工具**：Intel® DPC++ Compatibility Tool需通过官方安装器获取，参考 [oneAPI Base Toolkit 安装页面](https://software.intel.com/oneapi)。


## 五、许可协议

下载并使用本容器及包含的软件，即表示您同意 [软件许可协议](https://github.com/intel/oneapi-containers/tree/master/licensing) 的条款与条件。容器源代码可参考 [Container Sources](https://iotdk.intel.com/oneapi-container-sources)。


## 六、参考链接
- [oneAPI Base Toolkit 容器入门指南](https://www.intel.com/content/www/us/en/docs/oneapi-base-toolkit/get-started-guide-linux/2025-2/using-containers.html)
- [容器镜像GitHub仓库](https://github.com/intel/oneapi-containers/blob/master/images/docker/basekit)

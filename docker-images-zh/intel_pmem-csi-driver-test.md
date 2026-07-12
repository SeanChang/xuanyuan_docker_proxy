---
image: intel/pmem-csi-driver-test
description: "pmem-csi-driver的测试变体，包含调试功能和增强日志，仅用于测试环境。"
source: https://xuanyuan.cloud/zh/r/intel/pmem-csi-driver-test
canonical: https://xuanyuan.cloud/zh/r/intel/pmem-csi-driver-test
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/pmem-csi-driver-test" title="intel/pmem-csi-driver-test Docker 镜像中文简介、标签列表与拉取命令">intel/pmem-csi-driver-test 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PMEM-CSI for Kubernetes

> **注意**：此镜像变体包含调试功能和增强日志，仅用于测试。

## 镜像概述和主要用途
Intel PMEM-CSI是面向Kubernetes等容器编排器的存储驱动，可将本地持久内存（[PMEM](https://pmem.io/)）作为文件系统卷提供给容器应用使用。本镜像为测试专用变体，包含额外的调试功能和增强日志，用于测试环境中的功能验证和问题排查。

## 核心功能和特性
- 作为Kubernetes存储驱动，支持将PMEM资源分配为容器可用的文件系统卷
- 包含调试功能，便于问题诊断和功能测试
- 增强日志输出，提供更详细的运行状态信息
- 基于Intel PMEM-CSI项目构建，与Kubernetes生态兼容

## 使用场景和适用范围
- **适用场景**：Kubernetes环境下PMEM存储功能的测试、调试和验证
- **适用范围**：仅用于测试环境，不建议在生产环境中使用

## 使用方法和配置说明
### 前置条件
- 运行Kubernetes集群的节点需配备PMEM硬件
- 节点已正确配置PMEM相关内核模块和工具

### 部署参考
详细的部署配置和使用方法请参考PMEM-CSI官方文档：  
[https://github.com/intel/pmem-csi](https://github.com/intel/pmem-csi)

### 注意事项
- 本镜像为测试变体，性能和安全性可能不满足生产环境要求
- 使用时应启用调试日志，以便捕获测试过程中的详细信息
- 测试完成后建议切换至正式版PMEM-CSI驱动

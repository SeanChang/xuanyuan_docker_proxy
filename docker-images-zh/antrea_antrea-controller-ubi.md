---
image: antrea/antrea-controller-ubi
description: "Antrea Controller的Docker镜像，基于RedHat UBI，是Kubernetes网络解决方案Antrea的关键组件之一，用于在K8s集群中以Deployment方式运行，提供网络和安全服务。"
source: https://xuanyuan.cloud/zh/r/antrea/antrea-controller-ubi
canonical: https://xuanyuan.cloud/zh/r/antrea/antrea-controller-ubi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/antrea/antrea-controller-ubi" title="antrea/antrea-controller-ubi Docker 镜像中文简介、标签列表与拉取命令">antrea/antrea-controller-ubi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

Antrea是一个Kubernetes原生网络解决方案，工作在OSI模型第3/4层，为Kubernetes集群提供网络和安全服务，其数据平面基于Open vSwitch实现。本镜像为Antrea的核心组件之一——Antrea Controller的Docker镜像，基于RedHat UBI（Universal Base Image）构建，设计用于在Kubernetes集群中以Deployment资源形式运行。

## 核心功能与特性

* **Antrea核心组件**：作为Antrea的两个关键组件之一，负责协调和管理Kubernetes集群的网络策略与服务配置。
* **RedHat UBI基础**：基于RedHat Universal Base Image构建，适用于需要RedHat生态系统支持的环境。
* **架构支持**：仅提供amd64架构版本，不支持其他硬件架构。
* **Kubernetes集成**：完全遵循Kubernetes原生设计理念，可无缝集成到K8s集群中，通过Deployment实现高可用部署。

## 使用场景与适用范围

* **目标集群环境**：主要适用于OpenShift集群，或其他对RedHat UBI基础镜像有特定需求的Kubernetes环境。
* **用户群体**：适合需要基于RedHat UBI构建容器镜像的用户；对于多平台部署需求或非RedHat环境，推荐优先使用基于Ubuntu的[antrea/antrea-controller-ubuntu](https://hub.docker.com/r/antrea/antrea-controller-ubuntu)镜像（支持多平台manifest）。

## 使用方法与配置说明

### 基本部署方式

Antrea Controller通常以Kubernetes Deployment形式部署，具体部署配置需结合Antrea的整体部署流程。典型的部署步骤包括：

1. 参考Antrea官方部署文档配置Deployment资源清单
2. 在清单中指定本镜像（如`antrea/antrea-controller:${VERSION}`，其中`${VERSION}`为具体版本号）
3. 通过`kubectl apply`命令部署到Kubernetes集群

### 配置参考

Antrea Controller的详细配置参数（如网络策略模式、日志级别等）可通过环境变量或配置文件进行调整，具体配置项请参考[Antrea源代码仓库](https://github.com/antrea-io/antrea)中的官方文档。

## 注意事项

* 本镜像仅支持amd64架构，非amd64架构的集群需选择其他版本。
* 对于多平台部署需求（如同时支持amd64和arm64），请使用[antrea/antrea-controller-ubuntu](https://hub.docker.com/r/antrea/antrea-controller-ubuntu)镜像。
* 更多详细信息可查阅[Antrea源代码仓库](https://github.com/antrea-io/antrea)。

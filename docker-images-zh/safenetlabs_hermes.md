---
image: safenetlabs/hermes
description: "基于Alpine的轻量级Docker镜像，用于部署CI/CD任务，适用于PCF运维流水线。"
source: https://xuanyuan.cloud/zh/r/safenetlabs/hermes
canonical: https://xuanyuan.cloud/zh/r/safenetlabs/hermes
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/safenetlabs/hermes" title="safenetlabs/hermes Docker 镜像中文简介、标签列表与拉取命令">safenetlabs/hermes 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PCF运维流水线CI/CD任务镜像

## 镜像概述
本镜像基于Alpine Linux构建，是一款轻量级Docker镜像，专为PCF（Pivotal Cloud Foundry）运维流水线设计，主要用于部署和执行CI/CD任务，提供高效、资源占用低的任务运行环境。

## 核心功能与特性
- **轻量级架构**：基于Alpine Linux，镜像体积小，启动速度快，资源占用低
- **CI/CD任务支持**：专为持续集成/持续部署流程优化，可无缝集成到自动化流水线中
- **PCF运维适配**：针对PCF平台运维场景设计，适用于平台相关的部署、配置和管理任务

## 使用场景与适用范围
- PCF平台的自动化运维流水线构建
- CI/CD流程中的任务执行环节
- 需要轻量级环境的自动化部署、测试或配置操作

## 使用方法与配置说明

### 基本使用方式
通过`docker run`命令启动容器执行CI/CD任务：

```bash
docker run [选项] pcf-ops-pipeline-image [任务命令]
```

### 部署示例
执行PCF平台应用部署任务：

```bash
docker run --rm docker.xuanyuan.run/pcf-ops-pipeline-image deploy --target https://api.pcf.example.com --org my-org --space prod
```

### 注意事项
- 运行容器时需根据具体任务需求挂载必要的配置文件或认证信息
- 可通过命令参数传递任务所需的目标环境、组织、空间等配置信息

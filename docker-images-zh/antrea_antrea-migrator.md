---
image: antrea/antrea-migrator
description: "Antrea迁移工具的Docker镜像，用于自动化和简化现有Kubernetes集群中网络插件(CNI)的切换过程。"
source: https://xuanyuan.cloud/zh/r/antrea/antrea-migrator
canonical: https://xuanyuan.cloud/zh/r/antrea/antrea-migrator
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/antrea/antrea-migrator" title="antrea/antrea-migrator Docker 镜像中文简介、标签列表与拉取命令">antrea/antrea-migrator 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Antrea迁移工具Docker镜像

## 概述
该Docker镜像包含Antrea提供的CNI迁移工具，旨在帮助Kubernetes集群管理员解决在现有集群中切换网络插件(CNI)时面临的操作繁琐、易出错等问题。通过自动化迁移流程，简化集群网络插件的切换操作，提升管理效率。

## 核心功能与特性
- **自动化迁移流程**：自动处理CNI切换过程中的关键步骤，减少手动操作需求
- **简化操作复杂度**：将繁琐的迁移步骤整合为工具化流程，降低管理员操作门槛
- **降低错误风险**：通过标准化迁移逻辑，减少手动配置可能导致的集群故障风险

## 使用场景与适用范围
- **适用场景**：现有Kubernetes集群需要更换网络插件(CNI)的迁移场景
- **目标用户**：Kubernetes集群管理员
- **环境要求**：运行中的Kubernetes集群环境

## 使用方法与配置说明
### 基本使用
该镜像的具体使用方法、参数配置及详细操作步骤，请参考Antrea官方文档：  
[Antrea迁移工具文档](https://github.com/antrea-io/antrea/blob/main/docs/migrate-to-antrea.md)

### 注意事项
- 使用前请确保已备份集群关键配置及数据
- 迁移过程中可能需要短暂中断部分网络功能，请在维护窗口期执行
- 请根据集群实际环境及Antrea文档要求调整工具参数

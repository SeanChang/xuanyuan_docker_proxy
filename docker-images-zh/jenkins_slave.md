---
image: jenkins/slave
description: "Jenkins Agent的基础镜像，包含Java运行时和Jenkins代理（slave.jar），但已被弃用，推荐使用\"jenkins/agent\"作为替代。"
source: https://xuanyuan.cloud/zh/r/jenkins/slave
canonical: https://xuanyuan.cloud/zh/r/jenkins/slave
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkins/slave" title="jenkins/slave Docker 镜像中文简介、标签列表与拉取命令">jenkins/slave 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jenkins Agent Docker镜像

## 镜像概述和主要用途
该镜像曾作为Jenkins Agent的基础镜像，设计用于提供运行Jenkins代理所需的环境。其主要用途是作为Jenkins分布式构建环境中的代理节点基础，支持Jenkins主节点与代理节点之间的通信和任务执行。

> [!CAUTION]
> **重要提示**：此镜像已被弃用，推荐使用"jenkins/agent"作为替代方案。

## 核心功能和特性
- **基础环境**：包含Java运行时环境，满足Jenkins代理运行的基础依赖需求。
- **代理组件**：内置Jenkins代理程序（slave.jar），可直接用于与Jenkins主节点建立连接。

## 使用注意事项
由于该镜像已被官方标记为弃用，不建议在新的项目或环境中继续使用。继续使用可能面临不再更新维护、安全漏洞无法修复等风险。

## 推荐替代方案
官方推荐使用"jenkins/agent"镜像作为替代，该镜像为当前活跃维护的版本，功能与原镜像兼容，可直接替换使用。

### 替代镜像信息
- **替代镜像名称**：jenkins/agent
- **官方仓库地址**：[https://hub.docker.com/r/jenkins/agent](https://hub.docker.com/r/jenkins/agent)

建议所有使用本镜像的场景迁移至"jenkins/agent"，以获取持续的更新和支持。

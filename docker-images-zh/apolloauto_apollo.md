---
image: apolloauto/apollo
description: "Apollo是一个开放的自动驾驶平台，采用高性能灵活架构，支持完全自动驾驶能力。"
source: https://xuanyuan.cloud/zh/r/apolloauto/apollo
canonical: https://xuanyuan.cloud/zh/r/apolloauto/apollo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apolloauto/apollo" title="apolloauto/apollo Docker 镜像中文简介、标签列表与拉取命令">apolloauto/apollo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apollo 镜像文档

## 镜像概述和主要用途
Apollo是一个开放的自动驾驶平台，旨在提供高性能、灵活的架构，支持完全自动驾驶能力。该镜像封装了Apollo平台的核心组件，为开发者提供便捷的部署方式，助力自动驾驶系统的研发、测试与应用。

## 核心功能和特性
- **开放平台架构**：开源设计，支持开发者基于平台进行定制化开发和功能扩展
- **高性能计算支持**：优化的架构设计，满足自动驾驶场景下的实时数据处理和决策需求
- **灵活模块化设计**：组件化架构，可根据不同应用场景灵活配置功能模块
- **全栈自动驾驶能力**：提供从环境感知、路径规划到车辆控制的完整自动驾驶解决方案

## 使用场景和适用范围
适用于自动驾驶算法研发、系统集成测试、自动驾驶原型验证等场景，主要面向自动驾驶领域的科研人员、工程师及相关企业，用于构建和部署自动驾驶系统。

## 使用方法和配置说明

### 基本使用流程
1. **拉取镜像**  
   ```bash
   docker pull docker.xuanyuan.run/apollo:latest
   ```

2. **启动容器**  
   ```bash
   docker run -it --rm docker.xuanyuan.run/apollo:latest
   ```

### 配置说明
Apollo平台包含丰富的配置参数和环境变量，具体配置需根据实际应用场景进行调整。详细的环境变量说明、模块配置及高级使用方法，请参考[Apollo官方文档](https://apollo.auto/)获取完整指导。

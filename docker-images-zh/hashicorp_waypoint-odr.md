---
image: hashicorp/waypoint-odr
description: "Waypoint用于按需运行器的镜像。"
source: https://xuanyuan.cloud/zh/r/hashicorp/waypoint-odr
canonical: https://xuanyuan.cloud/zh/r/hashicorp/waypoint-odr
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/waypoint-odr" title="hashicorp/waypoint-odr Docker 镜像中文简介、标签列表与拉取命令">hashicorp/waypoint-odr 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# HashiCorp Waypoint 按需运行器镜像

## 镜像概述和主要用途
HashiCorp Waypoint 是一款允许开发者将应用构建、部署和发布生命周期定义为代码的工具，旨在建立一致、可重复的工作流，减少应用交付时间。本镜像作为 Waypoint 的按需运行器（On-Demand Runner, ODR）镜像，是 Waypoint 操作生命周期的重要组成部分，用于创建按需运行器以执行相关任务。

## 核心功能和特性
- 作为 Waypoint 生态的关键组件，支持按需创建运行器，满足动态任务执行需求
- 与 Waypoint 工作流无缝集成，确保构建、部署等任务执行的一致性和可重复性
- 简化运行器管理流程，无需预先配置固定运行器，实现按需创建，提升资源利用效率

## 使用场景和适用范围
- 适用于使用 Waypoint 进行应用生命周期管理的开发团队
- 需动态扩展运行资源以处理构建、部署等任务的场景
- 希望减少固定运行器资源占用，实现按需资源分配的环境

## 使用方法和配置说明
### 基本使用
在 Waypoint 配置中，通过指定本镜像作为运行器镜像来启用按需运行器功能。具体配置需参考 Waypoint 官方文档，确保 Waypoint 控制平面能够访问并使用此镜像。

### 配置示例
在 Waypoint 项目的 `waypoint.hcl` 配置文件中，可添加如下配置引用按需运行器镜像：
```hcl
runner {
  enabled = true
  image = "hashicorp/waypoint-odr:latest" # 请替换为实际镜像标签
}
```

> 注：实际使用时，应根据需求指定具体的镜像标签，并确保 Waypoint 控制平面具有访问该镜像的权限。详细配置步骤请参考 [Waypoint 官方文档](https://hub.docker.com/repository/docker/hashicorp/waypoint)。

### 环境变量和参数
目前官方未提供本镜像的特定环境变量或配置参数说明，建议在使用时参考 Waypoint 官方文档或镜像仓库页面获取最新信息。

---
image: sfat/liquibase
description: "【已弃用】liquibase/liquibase Docker镜像的镜像，旨在同时支持Intel和基于arm（M1）架构的设备"
source: https://xuanyuan.cloud/zh/r/sfat/liquibase
canonical: https://xuanyuan.cloud/zh/r/sfat/liquibase
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sfat/liquibase" title="sfat/liquibase Docker 镜像中文简介、标签列表与拉取命令">sfat/liquibase 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# liquibase-docker 镜像文档

## 镜像概述和主要用途
该镜像为liquibase/liquibase官方Docker镜像的镜像，主要用于解决官方镜像不支持M1（arm架构）设备的兼容性问题。目前因官方镜像已修复此问题，本镜像已弃用。

## 核心功能和特性
- **架构兼容性**：同时支持Intel架构和基于arm架构的M1设备
- **镜像一致性**：作为官方liquibase镜像的镜像，保持与原镜像功能一致
- **问题修复**：针对官方镜像在M1设备上的运行问题提供临时解决方案

## 使用场景和适用范围
原适用于需要在M1（arm架构）设备上运行liquibase数据库版本控制工具的场景。随着官方liquibase镜像架构兼容性问题的解决，本镜像已不再推荐使用。

## 使用方法和配置说明

### 注意事项
**该镜像已弃用**，建议直接使用官方liquibase/liquibase镜像，其目前已原生支持Intel和arm架构（包括M1设备）。

### 历史构建信息
构建本镜像的GitHub仓库地址：[https://github.com/sfat/liquibase-docker](https://github.com/sfat/liquibase-docker)

### 官方问题参考
原兼容性问题参考：[官方liquibase Docker镜像M1支持问题](https://github.com/liquibase/docker/issues/126)

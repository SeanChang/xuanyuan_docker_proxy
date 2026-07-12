---
image: eurolinux/eurolinux-9
description: "官方EuroLinux 9基础镜像，与UBI兼容，可自由使用和再分发，每月自动重建以确保安全性、更新可预测性及稳定的变更过程。"
source: https://xuanyuan.cloud/zh/r/eurolinux/eurolinux-9
canonical: https://xuanyuan.cloud/zh/r/eurolinux/eurolinux-9
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/eurolinux/eurolinux-9" title="eurolinux/eurolinux-9 Docker 镜像中文简介、标签列表与拉取命令">eurolinux/eurolinux-9 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# EuroLinux 9 - 官方容器镜像

## 镜像概述

欢迎使用官方EuroLinux 9容器镜像！您可以自由使用和再分发此镜像。该镜像旨在提供稳定、安全的基础环境，适用于各类容器化应用场景。

## 核心功能与特性

- **自动重建机制**：每月自动重建，确保镜像始终包含最新的安全更新和修复
- **增强安全性**：通过定期重建减少安全漏洞暴露风险
- **可预测更新**：更新周期固定，便于规划和管理依赖
- **稳定变更流程**：变更过程经过严格控制，减少非预期影响
- **应急修复能力**：具备针对关键安全问题等场景的临时修复基础设施、脚本和工作流

## 使用场景

- 作为基础镜像构建各类应用容器
- 开发、测试和生产环境中的标准化运行时环境
- 需要长期支持和稳定更新的企业级应用部署
- 与UBI（通用基础镜像）兼容的场景

## 使用方法

### 直接运行容器

```bash
docker run -it docker.xuanyuan.run/eurolinux/eurolinux-9:latest /bin/bash
```

### 作为基础镜像使用（Dockerfile示例）

```dockerfile
FROM docker.xuanyuan.run/eurolinux/eurolinux-9:latest

# 在此添加应用构建和配置步骤
```

## 支持与变更请求

如需要支持或提出变更请求，请通过官方仓库的GitHub Issues进行：  
[https://github.com/EuroLinux/containers-rfc](https://github.com/EuroLinux/containers-rfc)

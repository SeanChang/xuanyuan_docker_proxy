---
image: playwright/chrome
description: "用于Moon软件的Playwright Chrome镜像"
source: https://xuanyuan.cloud/zh/r/playwright/chrome
canonical: https://xuanyuan.cloud/zh/r/playwright/chrome
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/playwright/chrome" title="playwright/chrome Docker 镜像中文简介、标签列表与拉取命令">playwright/chrome 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述和主要用途
这些镜像是专为Moon软件（https://aerokube.com/moon/）设计的Playwright Chrome浏览器镜像，仅与Moon软件兼容。它们基于Playwright技术栈，提供Chrome浏览器环境，用于支持Moon软件的相关功能运行。请注意，这些镜像不支持独立使用或与其他非Moon软件集成。官方Playwright团队提供的通用镜像可访问：https://hub.docker.com/_/microsoft-playwright。

## 核心功能和特性
- **Moon软件专用**：镜像功能和配置完全针对Moon软件的运行需求进行优化，确保兼容性
- **Playwright Chrome环境**：集成Playwright的Chrome浏览器组件，支持Web自动化测试等场景
- **版本协同**：与Moon软件版本保持同步更新，保障功能一致性

## 使用场景和适用范围
适用于在Moon软件环境中需要Playwright Chrome浏览器支持的场景，包括：
- 基于Moon的Web应用自动化测试执行
- 通过Moon进行的浏览器环境模拟与测试
- Moon软件生态中的Playwright相关任务处理

## 使用方法和配置说明
由于本镜像专为Moon软件设计，具体部署和配置步骤请参考Moon软件官方文档：  
[https://aerokube.com/moon/](https://aerokube.com/moon/)

> **重要提示**：如需要通用的Playwright镜像（非Moon专用），请使用Playwright官方团队提供的镜像：  
> [https://hub.docker.com/_/microsoft-playwright](https://hub.docker.com/_/microsoft-playwright)

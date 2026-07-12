---
image: redislabs/operator-internal
description: "此仓库包含由CI构建的预发布版本。"
source: https://xuanyuan.cloud/zh/r/redislabs/operator-internal
canonical: https://xuanyuan.cloud/zh/r/redislabs/operator-internal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redislabs/operator-internal" title="redislabs/operator-internal Docker 镜像中文简介、标签列表与拉取命令">redislabs/operator-internal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### 概述
此镜像仓库包含通过持续集成（CI）流程构建的预发布版本，旨在提供最新开发阶段的软件版本，供测试、评估或早期集成使用。

### 特性
- **自动化构建**：由CI系统自动构建，确保版本更新及时且流程规范。
- **预发布版本**：包含开发中的最新功能和修复，适用于非生产环境的测试验证。

### 使用场景
- 开发团队测试最新代码变更的集成效果。
- 在预生产环境中部署，验证新功能在接近生产条件下的表现。
- 供早期用户或合作伙伴提前体验新特性，收集反馈。

### 部署方案示例
#### 拉取镜像
```bash
docker pull docker.xuanyuan.run/<image-name>:<pre-release-tag>
```
（注：`<image-name>`为具体镜像名称，`<pre-release-tag>`为预发布版本标签，如`latest-ci`或具体构建编号）

#### 运行容器示例
```bash
docker run -d --name pre-release-container <image-name>:<pre-release-tag>
```

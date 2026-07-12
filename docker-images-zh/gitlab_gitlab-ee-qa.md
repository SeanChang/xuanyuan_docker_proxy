---
image: gitlab/gitlab-ee-qa
description: "GitLab QA 提供端到端测试套件，用于验证整个 GitLab 系统。https://gitlab.com/gitlab-org/gitlab-qa"
source: https://xuanyuan.cloud/zh/r/gitlab/gitlab-ee-qa
canonical: https://xuanyuan.cloud/zh/r/gitlab/gitlab-ee-qa
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gitlab/gitlab-ee-qa" title="gitlab/gitlab-ee-qa Docker 镜像中文简介、标签列表与拉取命令">gitlab/gitlab-ee-qa 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GitLab QA 镜像文档

## 镜像概述和主要用途
GitLab QA 是一个端到端测试套件，旨在全面验证整个 GitLab 系统的功能和稳定性。它通过模拟真实用户场景，对 GitLab 的各个组件和功能进行系统性测试，确保 GitLab 作为整体系统正常运行。

## 核心功能和特性
- **端到端测试覆盖**：提供全面的端到端测试，覆盖 GitLab 的核心功能和用户流程
- **系统级验证**：专注于验证 GitLab 整体系统的集成和交互，而非单个组件
- **版本兼容性**：与 GitLab 各版本保持兼容，支持对不同版本的 GitLab 进行测试

## 使用场景和适用范围
- **GitLab 开发团队**：在开发新功能或修复 bug 后，验证 GitLab 整体功能是否正常
- **CI/CD 集成**：作为 GitLab 版本发布流程的一部分，在 CI/CD 管道中自动执行测试
- **自定义部署验证**：对于自定义配置的 GitLab 部署，验证其功能完整性和稳定性

## 使用方法和配置说明
### 基本使用
有关详细的使用方法和配置选项，请参考官方文档：[GitLab QA 官方文档](https://gitlab.com/gitlab-org/gitlab-qa)

### 部署示例
具体部署命令和配置需根据测试目标和环境确定，建议通过官方文档获取最新的 `docker run` 命令或 `docker-compose` 配置示例。

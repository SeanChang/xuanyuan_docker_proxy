---
image: gitlab/gitlab-ee
description: "基于Omnibus软件包构建的GitLab企业版Docker镜像，其中Omnibus软件包集成了GitLab运行所需的各类核心组件（如Web服务器、数据库、缓存服务等），旨在通过容器化技术为企业用户提供便捷高效的部署方案，简化GitLab企业版的安装、配置与维护流程，满足企业在代码管理、CI/CD、项目协作等场景下的需求。"
source: https://xuanyuan.cloud/zh/r/gitlab/gitlab-ee
canonical: https://xuanyuan.cloud/zh/r/gitlab/gitlab-ee
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gitlab/gitlab-ee" title="gitlab/gitlab-ee Docker 镜像中文简介、标签列表与拉取命令">gitlab/gitlab-ee 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GitLab Docker 镜像使用说明


## 注意事项  
请注意，我们不会监控此处评论。若您在运行 GitLab Docker 镜像时需要帮助，请访问 [GitLab 帮助页面]([])。


## 官方 Docker 镜像  
- GitLab 社区版（CE）官方 Docker 镜像：[Docker Hub 地址]([])  
- GitLab 企业版（EE）官方 Docker 镜像：[Docker Hub 地址]([])  


## 使用指南  
完整的 GitLab Docker 镜像使用说明，请参考 [《使用 GitLab Docker 镜像》文档]([])。  


## 构建相关文件与指南  
- 用于构建公开镜像的 Dockerfile 及相关文件，存放于 [Omnibus 仓库]([])。  
- 如需创建基于 Omnibus 的 Docker 镜像，可查看 [《创建 Omnibus 基础 Docker 镜像》指南]([])。  


## Kubernetes 部署  
若需在 Kubernetes 环境部署，可使用 [GitLab Helm Chart]([])，具体说明见其官方文档。

---
image: langgenius/dify-sandbox
description: "Docker镜像langgenius/dify-sandbox是为Dify平台打造的安全代码沙箱环境，支持LLM应用开发中代码执行、函数调用等场景的隔离测试。通过资源限制、权限管控和环境隔离机制，保障外部代码运行安全，助力开发者在构建AI应用时快速验证逻辑、调试功能，降低潜在风险。轻量级部署，无缝集成Dify生态，提升开发效率与安全性。"
source: https://xuanyuan.cloud/zh/r/langgenius/dify-sandbox
canonical: https://xuanyuan.cloud/zh/r/langgenius/dify-sandbox
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/langgenius/dify-sandbox" title="langgenius/dify-sandbox Docker 镜像中文简介、标签列表与拉取命令">langgenius/dify-sandbox — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/langgenius/dify-sandbox" title="langgenius/dify-sandbox Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/langgenius/dify-sandbox</a>

# Dify Sandbox  

欢迎使用 Dify Sandbox 官方仓库。该平台提供安全、轻量且快速的代码执行环境，核心目标是通过防止恶意代码执行，保障您的系统安全。  


## 依赖项  

- **Linux**：基于 Linux Seccomp 机制实现基础安全控制。  
- **Docker**：为提升隔离效果，所有不可信代码需运行在独立容器中，并禁用网络访问。

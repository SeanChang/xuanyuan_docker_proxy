---
image: openeuler/opencode
description: "opencode官方Docker镜像，由openEuler基础设施SIG维护，用于快速部署和运行opencode服务，支持通过挂载配置目录实现数据持久化。"
source: https://xuanyuan.cloud/zh/r/openeuler/opencode
canonical: https://xuanyuan.cloud/zh/r/openeuler/opencode
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/opencode" title="openeuler/opencode Docker 镜像中文简介、标签列表与拉取命令">openeuler/opencode — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openeuler/opencode" title="openeuler/opencode Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/opencode</a>

# opencode Docker镜像文档

## 镜像概述和主要用途

本镜像为opencode的官方Docker镜像，由[openEuler基础设施SIG](https://gitcode.com/openeuler/infrastructure)维护。opencode是一个基于AI的代码相关工具（详情参见[官方网站](https://opencode.ai/)），本镜像提供了便捷的容器化部署方式，可快速在各类环境中运行opencode服务。

## 核心功能和特性

- **官方维护**：由openEuler基础设施SIG团队维护，确保镜像的稳定性和安全性
- **配置持久化**：支持通过挂载本地目录持久化opencode配置数据，避免容器重启后配置丢失
- **便捷部署**：提供简单的启动命令，无需复杂配置即可快速运行服务

## 使用场景和适用范围

适用于需要快速部署opencode服务的开发、测试及生产环境，尤其适合依赖openEuler生态的用户，可用于代码分析、辅助开发等场景。

## 使用方法和配置说明

### 快速启动

通过以下命令可快速启动opencode容器：

```bash
docker run \
    --name opencode \
    -v ~/.config/opencode:~/.config/opencode \ 
    -itd openeuler/opencode:1.1.48
```

#### 参数说明：
- `--name opencode`：指定容器名称为opencode
- `-v ~/.config/opencode:~/.config/opencode`：将本地`~/.config/opencode`目录挂载到容器内同名路径，用于持久化配置数据
- `-itd`：以交互式、后台运行模式启动容器
- `openeuler/opencode:1.1.48`：指定使用的镜像及版本

### 获取帮助

如在使用过程中遇到问题，可通过[openEuler infrastructure SIG](https://gitcode.com/openeuler/infrastructure)获取支持。

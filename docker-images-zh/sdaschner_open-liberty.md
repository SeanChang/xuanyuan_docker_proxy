---
image: sdaschner/open-liberty
description: "该Docker镜像用于演示、工作坊和示例场景，提供稳定可靠的Open Liberty环境，支持优雅关闭、环境变量配置等特性，且镜像标签固定不变，确保构建一致性。"
source: https://xuanyuan.cloud/zh/r/sdaschner/open-liberty
canonical: https://xuanyuan.cloud/zh/r/sdaschner/open-liberty
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sdaschner/open-liberty" title="sdaschner/open-liberty Docker 镜像中文简介、标签列表与拉取命令">sdaschner/open-liberty 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# sdaschner/open-liberty镜像说明

## 镜像概述
本镜像用于演示、工作坊及技术示例场景，源码可在[GitHub](https://github.com/sdaschner/docker)获取。所有镜像标签唯一且稳定，不会变更，确保基于特定标签的构建结果始终一致。

## 核心功能
- **稳定标签**：镜像标签固定不变，保证构建结果的一致性和可靠性。
- **优雅关闭**：支持Unix信号（如SIGTERM）的正确处理，实现服务优雅关闭。
- **环境变量配置**：通过环境变量（如`$DEPLOYMENT_DIR`）灵活配置应用服务器的构建参数。

## 使用场景
- 技术演示或培训工作坊中的应用部署示例。
- 快速搭建Open Liberty环境进行功能验证或测试。

## 配置说明
可通过环境变量调整镜像行为，例如：
- `$DEPLOYMENT_DIR`：指定应用服务器的部署目录。

## 部署示例
### Docker Run命令
```bash
docker run -d --name open-liberty-demo docker.xuanyuan.run/sdaschner/open-liberty:javaee7-jdk8-b1
```

## 贡献说明
欢迎提供反馈、提交问题或PR！

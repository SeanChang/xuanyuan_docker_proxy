---
image: redhat/ubi9
description: "Red Hat Universal Base Image 9 是为所有容器化应用、中间件和工具设计的基础层镜像，由Red Hat维护并定期更新，可免费再分发。"
source: https://xuanyuan.cloud/zh/r/redhat/ubi9
canonical: https://xuanyuan.cloud/zh/r/redhat/ubi9
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redhat/ubi9" title="redhat/ubi9 Docker 镜像中文简介、标签列表与拉取命令">redhat/ubi9 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Red Hat Universal Base Image 9

## 概述
Red Hat Universal Base Image (UBI) 9 被设计为所有容器化应用、中间件和工具的基础层。该基础镜像可免费再分发，但 Red Hat 仅通过 Red Hat 产品订阅支持 Red Hat 技术。此镜像由 Red Hat 维护并定期更新。

## 特性
- **通用基础层**：适用于各类容器化应用、中间件及工具的底层基础。
- **免费再分发**：允许无限制地再分发，便于广泛使用。
- **官方维护**：由 Red Hat 官方团队维护，确保稳定性与安全性。
- **定期更新**：持续接收更新以修复漏洞、优化性能。

## 使用场景
- 构建容器化应用的基础镜像。
- 部署中间件（如数据库、消息队列等）的底层环境。
- 开发工具类容器（如CI/CD工具、监控组件等）。

## Docker部署示例
以下是基于 UBI 9 构建简单应用的 Dockerfile 示例：
```dockerfile
# 使用 UBI 9 作为基础镜像
FROM registry.access.redhat.com/ubi9

# 安装必要依赖（示例：安装curl）
RUN dnf install -y curl && dnf clean all

# 设置工作目录
WORKDIR /app

# 运行示例命令
CMD ["echo", "Hello from UBI 9 container!"]
```

构建并运行容器：
```bash
docker build -t ubi9-demo .
docker run --rm docker.xuanyuan.run/ubi9-demo
```

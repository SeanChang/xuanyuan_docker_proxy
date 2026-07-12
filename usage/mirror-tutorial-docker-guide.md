# ghcr、Quay、nvcr、k8s、gcr 等仓库下载镜像教程总览

本教程汇总如何使用 [轩辕镜像](https://xuanyuan.cloud/) 加速 Docker Hub、GHCR、GCR、Quay、NVCR、K8s、MCR、Elastic、Oracle、GitLab 等各大主流镜像仓库，提升镜像拉取速度和稳定性。

## 前置说明

本教程默认您的专属加速域名为 `xxx.xuanyuan.run`（请替换为您在个人中心获取的真实地址）。

如果您还没有专属加速域名，请先前往 [个人中心](https://xuanyuan.cloud/) 获取您的专属加速地址。

## 仓库教程入口

每个仓库都有独立的配置文档页，可按仓库类型直接进入对应页面查看示例命令与注意事项：

| 仓库 | 教程 |
|------|------|
| Docker Hub（docker.io） | [查看教程](./mirror-tutorial/docker-hub.md) |
| GitHub Container Registry（ghcr.io） | [查看教程](./mirror-tutorial/ghcr.md) |
| Google Container Registry（gcr.io） | [查看教程](./mirror-tutorial/gcr.md) |
| Quay.io | [查看教程](./mirror-tutorial/quay.md) |
| NVIDIA Container Registry（nvcr.io） | [查看教程](./mirror-tutorial/nvcr.md) |
| Kubernetes Registry（registry.k8s.io） | [查看教程](./mirror-tutorial/k8s.md) |
| Microsoft Container Registry（mcr.microsoft.com） | [查看教程](./mirror-tutorial/mcr.md) |
| Elastic Registry（docker.elastic.co） | [查看教程](./mirror-tutorial/elastic.md) |
| Oracle Container Registry | [查看教程](./mirror-tutorial/oracle.md) |
| GitLab Container Registry（registry.gitlab.com） | [查看教程](./mirror-tutorial/gitlab.md) |

> **提示**：`registry-mirrors` 仅对 docker.io 生效。拉取 GHCR、GCR、Quay 等非 docker.io 仓库时，需使用轩辕专属域名前缀（如 `xxx-ghcr.xuanyuan.run`）。

## 常见用法建议

| 用法 | 示例 |
|------|------|
| 设置镜像加速器 | 配置 daemon.json 中的 `registry-mirrors` 为 `https://xxx.xuanyuan.run` |
| 用于 CI/CD 构建 | 在 Dockerfile 或 CI 脚本中修改镜像源前缀 |
| 脚本预拉取 | `docker pull xxx-ghcr.xuanyuan.run/org/image:tag` |
| 替换已有镜像 | `docker tag xxx-ghcr.xuanyuan.run/org/image image` |

## 避免的问题

- **不要用完整官方域名**：避免使用 `docker.io/` 等完整域名，优先使用加速地址。
- **各大仓库的私有镜像仍需登录**：轩辕镜像加速不改变权限控制，支持公开镜像加速，各大仓库的私有镜像仍需登录认证。
- **避免误用缓存过期镜像**：建议定期更新加速源或配置 webhook 拉取策略。
- **注意镜像标签一致性**：确保加速地址和原始地址的镜像标签完全一致。

---

更多配置教程和技术支持，请访问 [轩辕镜像官网](https://xuanyuan.cloud/)

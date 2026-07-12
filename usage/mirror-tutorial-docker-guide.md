# ghcr、Quay、nvcr、k8s、gcr 等仓库下载镜像教程

> 在线版：https://xuanyuan.cloud/usage/mirror-tutorial

这里是多仓库镜像下载与配置教程的总览入口。每个仓库都有独立的配置文档页，便于搜索与收录；你可以按仓库类型直接进入对应页面查看示例命令与注意事项。

## 目录

- [前置说明](#前置说明)
- [仓库教程入口](#仓库教程入口)
- [常见用法建议](#常见用法建议)
- [避免的问题](#避免的问题)

## 前置说明

本教程默认您的专属域名为 `***.xuanyuan.run`（请将 `***.xuanyuan.run` 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fmirror-tutorial)网站后，点击左侧菜单栏的「专属域名」菜单即可获取）。

> 💡 如果您还没有专属域名，请先[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fmirror-tutorial)网站，然后点击左侧菜单栏的「专属域名」菜单获取您的专属域名。

## 仓库教程入口

选择你需要的仓库类型进入独立文档页（每个仓库页都有独立 SEO 标题、示例命令与注意事项）。

| 仓库 | 说明 | 教程 |
|------|------|------|
| Docker Hub（docker.io） | 最常用的官方镜像仓库，支持 `registry-mirrors` 与专属域名两种加速方式 | [查看教程](./mirror-tutorial/docker-hub.md) |
| GitHub Container Registry（ghcr.io） | GitHub 容器镜像仓库，需使用 `***-ghcr.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/ghcr.md) |
| Google Container Registry（gcr.io） | Google 容器镜像仓库，需使用 `***-gcr.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/gcr.md) |
| Quay.io | Red Hat Quay 镜像仓库，需使用 `***-quay.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/quay.md) |
| NVIDIA Container Registry（nvcr.io） | NVIDIA GPU 相关镜像，需使用 `***-nvcr.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/nvcr.md) |
| Kubernetes Registry（registry.k8s.io） | K8s 官方组件镜像，需使用 `***-k8s.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/k8s.md) |
| Microsoft Container Registry（mcr.microsoft.com） | 微软官方镜像，需使用 `***-mcr.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/mcr.md) |
| Elastic Registry（docker.elastic.co） | Elastic 官方镜像，需使用 `***-elastic.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/elastic.md) |
| Oracle Container Registry | Oracle 官方镜像，需使用 `***-oracle.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/oracle.md) |
| GitLab Container Registry（registry.gitlab.com） | GitLab SaaS 镜像仓库，需使用 `***-gitlab.xuanyuan.run` 专属域名前缀 | [查看教程](./mirror-tutorial/gitlab.md) |

## 常见用法建议

以下是一些常见的使用场景和建议：

| 用法 | 示例 |
|------|------|
| 设置镜像源 | 配置 daemon.json 中的 `registry-mirrors` 为 `https://***.xuanyuan.run` |
| 用于 CI/CD 构建 | 在 Dockerfile 或 CI 脚本中修改镜像源前缀 |
| 脚本预拉取 | `docker pull ***-ghcr.xuanyuan.run/org/image:tag` |
| 替换已有镜像 | `docker tag ***-ghcr.xuanyuan.run/org/image image` |

**各仓库拉取示例（将占位符替换为您的专属域名）：**

```bash
# Docker Hub
docker pull ***.xuanyuan.run/library/nginx:latest

# GHCR
docker pull ***-ghcr.xuanyuan.run/owner/image:tag

# GCR
docker pull ***-gcr.xuanyuan.run/google-containers/pause:3.9

# K8s 官方组件
docker pull ***-k8s.xuanyuan.run/pause:3.9
```

## 避免的问题

使用镜像时需要注意以下问题：

- **registry-mirrors 仅对 docker.io 生效：** daemon.json 中的镜像加速配置不会自动代理 GHCR、Quay、GCR 等第三方仓库。拉取 `ghcr.io/...` 等官方地址时仍会直连官方源；需在命令或 Dockerfile 中显式使用专属域名（如 `***-ghcr.xuanyuan.run/...`）。各仓库详情见对应子页「daemon.json 仍很慢？」章节。
- **不要用完整官方域名：** 避免使用 `docker.io/` 等完整域名，优先使用专属域名。
- **各大仓库的私有镜像仍需登录：** 轩辕镜像不改变权限控制，支持公开镜像，各大仓库的私有镜像仍需登录认证。
- **避免误用缓存过期镜像：** 建议定期更新镜像源或配置 webhook 拉取策略。
- **注意镜像标签一致性：** 确保专属域名和原始地址的镜像标签完全一致。

## 相关教程

- [专属域名拉取教程](https://xuanyuan.cloud/usage/nologin) — 多仓库专属域名前缀规则与免登录拉取说明
- [Linux Docker 配置教程](https://xuanyuan.cloud/usage/linux) — 配置 `daemon.json` 的 `registry-mirrors`（仅对 docker.io 生效）
- [Docker Compose 教程](https://xuanyuan.cloud/usage/docker-compose) — 在 compose 文件中使用专属域名前缀
- [Harbor 教程](https://xuanyuan.cloud/usage/harbor) — 在企业 Harbor 中配置轩辕镜像为远程代理端点
- [Portainer 教程](https://xuanyuan.cloud/usage/portainer) — 在 Portainer Web 控制台中新增加速 Registry

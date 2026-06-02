---
image: grafana/grafana
description: "官方Grafana Docker容器是由Grafana官方维护的轻量级虚拟化部署单元，集成了开源数据可视化与监控平台的核心功能，包含最新稳定版本，配置经过优化，支持快速部署并可无缝集成到各类监控系统中，为用户提供便捷、高效的数据监控与可视化解决方案。"
source: https://xuanyuan.cloud/zh/r/grafana/grafana
canonical: https://xuanyuan.cloud/zh/r/grafana/grafana
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/grafana" title="grafana/grafana Docker 镜像中文简介、标签列表与拉取命令">grafana/grafana 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Grafana Docker 镜像


## 运行 Grafana Docker 容器

启动 Docker 容器时，需将 Grafana 服务绑定到外部端口 3000。执行以下命令：

```bash
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

服务启动后，默认管理员账号密码为 `admin/admin`，可直接登录使用。

关于 Docker 运行的更多详细说明，可参考 [官方文档]([])。


## 更新日志

Grafana 的完整功能说明及使用指南，可查阅 [官方文档]([])；若需了解最新版本的更新内容，可访问 [更新日志页面]([])。

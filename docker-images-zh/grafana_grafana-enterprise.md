---
image: grafana/grafana-enterprise
description: "官方Grafana企业版Docker镜像是由Grafana Labs官方提供的容器化部署方案，集成企业级监控、可视化与分析核心功能，支持多数据源整合、高级安全控制、多租户管理及专属技术支持，适用于企业级IT基础设施、应用性能与业务数据的实时监控场景，可通过Docker快速部署并确保环境一致性，助力企业高效构建稳定可靠的监控平台。"
source: https://xuanyuan.cloud/zh/r/grafana/grafana-enterprise
canonical: https://xuanyuan.cloud/zh/r/grafana/grafana-enterprise
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/grafana-enterprise" title="grafana/grafana-enterprise Docker 镜像中文简介、标签列表与拉取命令">grafana/grafana-enterprise — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/grafana/grafana-enterprise" title="grafana/grafana-enterprise Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/grafana/grafana-enterprise</a>

# Grafana Enterprise Docker镜像  

Grafana Enterprise是Grafana的推荐发行版。无需许可证即可正常使用，且可轻松升级以启用企业级功能，例如数据源权限、报表功能及扩展认证选项。  


## 运行Grafana容器  

启动容器时绑定外部端口3000：  

```bash
docker run -d --name=grafana -p 3000:3000 grafana/grafana-enterprise
```  


## 更新日志  

你可以在[文档]([])中了解Grafana相关信息，或通过[此处]([])查看最新版本的更新内容！

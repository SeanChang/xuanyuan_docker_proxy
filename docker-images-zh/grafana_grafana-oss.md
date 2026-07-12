---
image: grafana/grafana-oss
description: "Grafana开源版（OSS edition）的代码仓库（repo）是托管其开源可视化与监控平台源代码的核心载体，该平台专注于时序数据的采集、分析与可视化展示，支持Prometheus、InfluxDB等多种主流数据源，供全球开发者免费获取、查看代码、贡献功能或自主部署使用，是社区协作开发与项目持续迭代的重要基础。"
source: https://xuanyuan.cloud/zh/r/grafana/grafana-oss
canonical: https://xuanyuan.cloud/zh/r/grafana/grafana-oss
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/grafana-oss" title="grafana/grafana-oss Docker 镜像中文简介、标签列表与拉取命令">grafana/grafana-oss 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Grafana Docker 镜像


## 运行 Grafana Docker 容器  

通过绑定外部端口 3000 启动 Docker 容器：  

```bash
docker run -d --name=grafana -p 3000:3000 docker.xuanyuan.run/grafana/grafana
```  

尝试访问，默认管理员账号密码为 `admin/admin`。  

关于 Docker 运行的更多文档可查看：[[]]   


## 更新日志  

你可以在 [文档]  中了解 Grafana 的详细信息，或通过 [这里]  查看最新版本的更新内容。

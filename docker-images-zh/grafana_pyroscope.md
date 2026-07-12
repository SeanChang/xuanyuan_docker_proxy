---
image: grafana/pyroscope
description: "持续分析平台，可将性能问题调试精确到单行代码"
source: https://xuanyuan.cloud/zh/r/grafana/pyroscope
canonical: https://xuanyuan.cloud/zh/r/grafana/pyroscope
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/pyroscope" title="grafana/pyroscope Docker 镜像中文简介、标签列表与拉取命令">grafana/pyroscope 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 官方 Pyroscope Docker 镜像

## 资源链接
- [GitHub](https://github.com/grafana/pyroscope)
- [文档](https://grafana.com/docs/pyroscope/latest/)
- [演示](https://demo.pyroscope.io/)
- [示例](https://github.com/grafana/pyroscope/tree/next/examples)
- [Slack](https://slack.grafana.com/)
- [升级指南](https://grafana.com/docs/pyroscope/latest/upgrade-guide/)

## 快速启动
启动 Pyroscope 服务器：
```shell
docker run -it -p 4040:4040 docker.xuanyuan.run/grafana/pyroscope
```

## 部署方案示例
基本部署：
```shell
docker run -d --name pyroscope -p 4040:4040 docker.xuanyuan.run/grafana/pyroscope
```

持久化存储部署：
```shell
docker run -d --name pyroscope -p 4040:4040 -v /path/to/data:/data docker.xuanyuan.run/grafana/pyroscope
```

## 更多信息
访问我们的[入门指南](https://grafana.com/docs/pyroscope/latest/get-started/)了解更多详情。

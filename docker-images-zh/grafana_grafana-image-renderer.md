---
image: grafana/grafana-image-renderer
description: "Grafana 远程图像渲染器镜像，通过无头 Chrome 将 Grafana 面板和仪表板渲染为 PNG 格式，支持集成到报表生成、自动化流程等场景。"
source: https://xuanyuan.cloud/zh/r/grafana/grafana-image-renderer
canonical: https://xuanyuan.cloud/zh/r/grafana/grafana-image-renderer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/grafana-image-renderer" title="grafana/grafana-image-renderer Docker 镜像中文简介、标签列表与拉取命令">grafana/grafana-image-renderer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Grafana Image Renderer 镜像

## 概述
Grafana Image Renderer 是一款为 Grafana 设计的远程图像渲染器，通过无头 Chrome（Headless Chrome）实现 Grafana 面板（Panels）和仪表板（Dashboards）到 PNG 图像的转换功能。

## 主要特性
- 基于无头 Chrome 引擎，提供高性能图像渲染能力
- 支持 Grafana 面板与仪表板的 PNG 格式导出
- 作为独立服务运行，可与 Grafana 无缝集成

## 使用场景
- 生成包含 Grafana 数据可视化的自动化报表或报告
- 集成至监控告警系统，生成可视化告警内容附件
- 用于文档、演示材料中的 Grafana 可视化图像导出
- 构建需要 Grafana 图像输出的第三方应用集成

## Docker 部署方案示例
```bash
# 基础运行命令（默认配置）
docker run -d --name grafana-image-renderer -p 8081:8081 docker.xuanyuan.run/grafana/grafana-image-renderer

# 连接至指定 Grafana 实例的配置示例（自定义 Grafana 地址）
docker run -d --name grafana-image-renderer \
  -p 8081:8081 \
  -e GF_RENDERER_GRAFANA_URL="http://your-grafana-instance:3000" \
  docker.xuanyuan.run/grafana/grafana-image-renderer
```
> 注：更多配置参数（如渲染超时、资源限制等）可参考官方文档。

## 参考文档
- [Grafana 图像渲染器官方文档](https://grafana.com/docs/grafana/latest/image-rendering/)
- [GitHub 仓库及详细使用说明](https://github.com/grafana/grafana-image-renderer#run-in-docker)

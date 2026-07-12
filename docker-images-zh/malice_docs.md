---
image: malice/docs
description: "Malice项目的官方文档镜像，基于Hugo和Material Docs主题构建，提供项目相关的详细文档内容，支持静态站点访问。"
source: https://xuanyuan.cloud/zh/r/malice/docs
canonical: https://xuanyuan.cloud/zh/r/malice/docs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/malice/docs" title="malice/docs Docker 镜像中文简介、标签列表与拉取命令">malice/docs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Malice Docs镜像说明

## 镜像概述
Malice Docs是Malice项目的官方文档镜像，用于展示项目的详细文档内容。该镜像基于Hugo静态站点生成器和Material Docs主题构建，采用Apache 2.0许可证，提供简洁美观的Material Design风格界面。

## 核心功能
- 提供Malice项目的完整文档浏览服务
- 基于Hugo生成静态站点，访问速度快
- 采用Material Docs主题，界面友好且响应式

## 使用场景
- 开发人员查阅Malice项目的使用指南、配置说明等文档
- 本地部署镜像以离线访问Malice项目文档

## 配置说明
该镜像默认暴露80端口，可通过端口映射访问文档站点。

### Docker部署示例
#### Docker Run命令
```bash
docker run -d -p 8080:80 docker.xuanyuan.run/malice/docs
```
部署后，访问`http://localhost:8080`即可查看Malice项目文档。

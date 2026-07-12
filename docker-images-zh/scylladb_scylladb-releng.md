---
image: scylladb/scylladb-releng
description: "供发布工程（releng）团队进行调试会话使用的调试仓库镜像"
source: https://xuanyuan.cloud/zh/r/scylladb/scylladb-releng
canonical: https://xuanyuan.cloud/zh/r/scylladb/scylladb-releng
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/scylladb/scylladb-releng" title="scylladb/scylladb-releng Docker 镜像中文简介、标签列表与拉取命令">scylladb/scylladb-releng 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 概述
该Docker镜像为发布工程（releng）团队提供专用的调试仓库环境，旨在支持团队高效开展调试会话，简化调试流程并提升协作效率。

# 主要功能
- 提供隔离的调试环境，避免对本地开发环境造成干扰
- 集成常用调试工具与依赖，满足releng团队多样化调试需求
- 支持团队成员共享调试上下文，便于协作排查问题

# 使用场景
- releng团队日常调试任务执行
- 复杂发布流程或工具链问题的排查分析
- 跨成员协作调试会话的环境一致性保障

# Docker部署方案示例
```bash
# 拉取镜像
docker pull docker.xuanyuan.run/[镜像名称]:[标签]

# 运行调试容器（示例）
docker run -it --name releng-debug-session \
  -v /本地调试目录:/app/debug \
  [镜像名称]:[标签] /bin/bash
```

> 注：实际部署时需替换`[镜像名称]`和`[标签]`为具体值，`/本地调试目录`可根据实际需求调整为本地待调试文件路径。

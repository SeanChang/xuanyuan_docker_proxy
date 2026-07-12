---
image: langfuse/langfuse-worker
description: "Langfuse background-worker容器，用于v3版本开发阶段，负责处理后台任务，支持主应用的异步操作与任务队列管理。"
source: https://xuanyuan.cloud/zh/r/langfuse/langfuse-worker
canonical: https://xuanyuan.cloud/zh/r/langfuse/langfuse-worker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/langfuse/langfuse-worker" title="langfuse/langfuse-worker Docker 镜像中文简介、标签列表与拉取命令">langfuse/langfuse-worker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述
Langfuse background-worker容器是Langfuse项目v3版本的开发阶段组件，专门用于处理后台任务，支持主应用的异步操作与任务队列管理，确保系统高效运行。

## 主要功能
- 处理异步任务队列，支持主应用的非阻塞操作
- 执行定时任务与周期性任务调度
- 处理事件驱动型后台任务（如日志聚合、数据同步等）
- 与Langfuse主服务协同，确保任务可靠执行与状态跟踪

## 使用场景
- 开发环境中配合Langfuse v3主应用进行集成测试
- 验证后台任务流程（如事件处理、数据处理）的正确性
- 模拟高并发场景下的任务队列处理能力

## Docker部署示例
```bash
# 拉取镜像（假设镜像标签为v3-dev）
docker pull docker.xuanyuan.run/langfuse/background-worker:v3-dev

# 运行容器（需配置必要环境变量）
docker run -d \
  --name langfuse-background-worker \
  -e DATABASE_URL="postgresql://user:password@db-host:5432/langfuse" \
  -e REDIS_URL="redis://redis-host:6379/0" \
  -e LOG_LEVEL="info" \
  docker.xuanyuan.run/langfuse/background-worker:v3-dev
```
> 注：环境变量需根据实际部署环境调整，确保与Langfuse主服务配置一致。

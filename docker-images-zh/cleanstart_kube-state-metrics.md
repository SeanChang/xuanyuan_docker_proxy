---
image: cleanstart/kube-state-metrics
description: "安全设计、速度优化的强化容器镜像，基于最小化CleanStart OS构建，提供生产就绪、安全强化的容器，适用于企业环境，具备可靠应用执行和高级安全特性。"
source: https://xuanyuan.cloud/zh/r/cleanstart/kube-state-metrics
canonical: https://xuanyuan.cloud/zh/r/cleanstart/kube-state-metrics
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cleanstart/kube-state-metrics" title="cleanstart/kube-state-metrics Docker 镜像中文简介、标签列表与拉取命令">cleanstart/kube-state-metrics 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Kube-State-Metrics容器文档

CleanStart Kube-State-Metrics镜像提供生产就绪、安全强化的容器，针对企业环境优化。基于最小化基础操作系统，经过全面安全强化，可提供可靠的应用执行能力和高级安全特性。

📌 **基础 foundation**：来自cleanstart的生产就绪容器。

**镜像路径**：`cleanstart/kube-state-metrics`

**仓库**：cleanstart Registry

## 拉取最新镜像
从仓库下载容器镜像

```bash
docker pull docker.xuanyuan.run/cleanstart/kube-state-metrics:latest
```
```bash
docker pull docker.xuanyuan.run/cleanstart/kube-state-metrics:latest-dev
```

## 基本运行
使用基本配置运行容器

```bash
docker run -it --name kube-state-metrics docker.xuanyuan.run/cleanstart/kube-state-metrics:latest
```

## 生产部署
使用生产安全设置部署

```bash
docker run -d --name kube-state-metrics-prod \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  --restart unless-stopped \
  docker.xuanyuan.run/cleanstart/kube-state-metrics:latest
```

## 卷挂载
挂载本地目录以持久化数据

```bash
docker run -v /app:/app docker.xuanyuan.run/cleanstart/kube-state-metrics:latest
```

## 端口转发
使用自定义端口映射运行

```bash
docker run -p 8080:8080 docker.xuanyuan.run/cleanstart/kube-state-metrics:latest
```

## 环境变量
通过环境变量提供的配置选项

| 变量名 | 默认值 | 描述 |
|----------|---------|-------------|
| ENV | production | 环境模式 |
| LOG_LEVEL | info | 日志级别 |


## Kubernetes安全上下文
Kubernetes部署的推荐安全上下文

```yaml
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsUser: 1000
  runAsGroup: 1000
```

## 文档资源
获取更多信息的重要链接和资源
 
**CleanStart镜像**：https://images.cleanstart.com/
 
**社区镜像**：<br>
**Docker Hub**：https://hub.docker.com/u/cleanstart<br>
**GitHub**：https://github.com/cleanstart-containers<br>
**AWS ECR Public Gallery**：https://gallery.ecr.aws/cleanstart/
 
**社交媒体**：<br>
**社区**：https://www.linkedin.com/groups/18324021/<br>
**YouTube**：https://www.youtube.com/@CleanStartOfficial<br>
 
**容器用例贡献**：https://github.com/cleanstart-dev/cleanstart-use-cases/

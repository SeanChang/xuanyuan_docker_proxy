---
image: cleanstart/etcd
description: "生产就绪、安全加固的etcd容器，基于精简CleanStart操作系统，具备全面安全加固措施，优化用于企业环境，提供可靠应用执行和高级安全特性。"
source: https://xuanyuan.cloud/zh/r/cleanstart/etcd
canonical: https://xuanyuan.cloud/zh/r/cleanstart/etcd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cleanstart/etcd" title="cleanstart/etcd Docker 镜像中文简介、标签列表与拉取命令">cleanstart/etcd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Etcd容器文档

CleanStart Etcd镜像提供生产就绪、安全加固的容器，针对企业环境优化。基于精简基础操作系统，具备全面的安全加固措施，该镜像提供可靠的应用执行和高级安全特性。

📌 **基础架构**：来自CleanStart的生产就绪容器。

**镜像路径**：`cleanstart/etcd`

**仓库**：CleanStart Registry

## 拉取最新镜像
从仓库下载容器镜像

```bash
docker pull docker.xuanyuan.run/cleanstart/etcd:latest
```
```bash
docker pull docker.xuanyuan.run/cleanstart/etcd:latest-dev
```

## 基本运行
使用基本配置运行容器

```bash
docker run -it --name etcd docker.xuanyuan.run/cleanstart/etcd:latest
```

## 生产部署
使用生产安全设置部署

```bash
docker run -d --name etcd-prod \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  --restart unless-stopped \
  docker.xuanyuan.run/cleanstart/etcd:latest
```

## 卷挂载
挂载本地目录以实现数据持久化

```bash
docker run -v /app:/app docker.xuanyuan.run/cleanstart/etcd:latest
```

## 端口转发
使用自定义端口映射运行

```bash
docker run -p 8080:8080 docker.xuanyuan.run/cleanstart/etcd:latest
```

## Kubernetes安全上下文
Kubernetes部署推荐的安全上下文

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

**贡献容器使用案例**：https://github.com/cleanstart-dev/cleanstart-use-cases/

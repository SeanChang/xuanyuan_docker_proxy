---
image: doocs/md
description: "微信Markdown编辑器"
source: https://xuanyuan.cloud/zh/r/doocs/md
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[doocs/md](https://xuanyuan.cloud/zh/r/doocs/md)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Docker MD

轻量的微信编辑器 [doocs/md](https://github.com/doocs/md) 的轻量容器镜像。

## 镜像列表

### 二进制版

镜像命名规则 `doocs/md:[版本号]`

```bash
docker run --rm -it -p 8080:80 doocs/md:latest
docker run --rm -it -p 8080:80 doocs/md:1.6.0
```

### Nginx 镜像版

镜像命名规则 `doocs/md:[版本号]-nginx`

```bash
docker run --rm -it -p 8080:80 doocs/md:latest-nginx
docker run --rm -it -p 8080:80 doocs/md:1.6.0-nginx

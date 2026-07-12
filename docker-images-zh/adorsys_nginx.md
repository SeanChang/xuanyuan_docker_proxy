---
image: adorsys/nginx
description: "adorsys/nginx是基于官方nginx:alpine的Nginx基础镜像，推荐使用ubi版本，支持rootless环境（默认端口8080），提供entrypoint钩子机制，适用于部署静态文件（如前端应用）。"
source: https://xuanyuan.cloud/zh/r/adorsys/nginx
canonical: https://xuanyuan.cloud/zh/r/adorsys/nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/adorsys/nginx" title="adorsys/nginx Docker 镜像中文简介、标签列表与拉取命令">adorsys/nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# adorsys/nginx

https://hub.docker.com/r/adorsys/nginx/

## 镜像概述

提供Nginx服务。推荐使用基于官方[`nginx:alpine`](https://hub.docker.com/_/nginx)镜像的`ubi`版本。在安全的rootless环境中，Nginx默认监听`8080`端口。

## 核心功能和特性

- 基于官方Nginx镜像构建，确保兼容性和稳定性
- 支持rootless环境部署，默认使用非特权端口8080，提升安全性
- 提供entrypoint钩子机制，允许在容器启动时执行自定义逻辑
- 简化静态文件部署流程，当前工作目录即为Nginx的web根目录

## 使用场景

适用于部署静态网站、前端应用（如Angular、React等）等需要Nginx作为Web服务器的场景，特别适合需要在容器启动阶段动态调整配置的前端应用部署。

## 使用方法

### 基础部署示例

通过Dockerfile将静态文件复制到容器的web根目录（当前目录即为Nginx的web根目录）：

```dockerfile
FROM docker.xuanyuan.run/adorsys/nginx

COPY dist/ .
```

### Entrypoint钩子机制

若需要在容器启动时执行额外逻辑（如修改Angular应用的后端URL），可将shell脚本复制到`/docker-entrypoint.d/`目录。

> 在手动实现前，建议参考在Docker中运行Angular应用的最佳实践示例（无需在容器启动时修改源代码）：https://github.com/adorsys/example-angular

#### 示例：修改Angular应用后端URL

创建`angular-url.sh`脚本：

```bash
if [ -f main.js ]; then
  sed -i -e \
    's#___SB_BACKEND_URL___#'"$BACKEND_URL"'#g' \
    main.js
else
  sed -i -e \
    's#___SB_BACKEND_URL___#'"$BACKEND_URL"'#g' \
    main.*.js
fi
```

通过Dockerfile集成脚本：

```dockerfile
FROM docker.xuanyuan.run/adorsys/nginx

COPY dist/ .
COPY angular-url.sh /docker-entrypoint.d/
```

**注**：当前工作目录指向Nginx的web根目录。

## 标签说明

| 标签名   | 描述                                                                 | 大小指示器                 |
|----------|----------------------------------------------------------------------|----------------------------|
| centos   | 基于[RH SCL nginx](https://github.com/sclorg/nginx-container) 1.16  | ![](https://images.microbadger.com/badges/image/adorsys/nginx.svg) |
| alpine   | 基于[`nginx:alpine`](https://hub.docker.com/_/nginx)                 | ![](https://images.microbadger.com/badges/image/adorsys/nginx:alpine.svg) |
| ubi      | 基于[RHEL8 UBI](https://developers.redhat.com/blog/2019/05/31/working-with-red-hat-enterprise-linux-universal-base-images-ubi/) | ![](https://images.microbadger.com/badges/image/adorsys/nginx:ubi.svg) |
| latest   | `ubi`标签的别名                                                     | ![](https://images.microbadger.com/badges/image/adorsys/nginx:latest.svg) |

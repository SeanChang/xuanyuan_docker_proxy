---
image: kubevirt/builder-cache
description: "Kubevirt项目构建依赖的Docker缓存镜像，用于存储构建所需的依赖包和工具，加速项目组件的构建过程并确保构建一致性。"
source: https://xuanyuan.cloud/zh/r/kubevirt/builder-cache
canonical: https://xuanyuan.cloud/zh/r/kubevirt/builder-cache
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kubevirt/builder-cache" title="kubevirt/builder-cache Docker 镜像中文简介、标签列表与拉取命令">kubevirt/builder-cache 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kubevirt Builder Cache镜像

## 镜像概述
kubevirt/builder-cache是Kubevirt项目官方提供的构建依赖缓存镜像，存储了项目构建过程中所需的依赖包、工具及环境配置，旨在减少重复下载依赖的时间，提升Kubevirt组件的构建效率与结果一致性。

## 核心功能
- 缓存Kubevirt构建常用依赖项，避免重复下载
- 提供稳定一致的依赖版本，保障构建结果可重复
- 加速本地及CI/CD流水线的构建流程

## 使用场景
- Kubevirt项目开发者本地构建组件时，利用缓存减少构建耗时
- CI/CD系统集成该镜像，优化构建步骤，提升流水线执行效率

## 配置说明
该镜像作为构建缓存层使用，无需额外配置，在构建脚本或Dockerfile中引用即可利用缓存。

## 部署示例
### Dockerfile引用缓存
```dockerfile
# 引入builder-cache作为缓存层
FROM docker.xuanyuan.run/kubevirt/builder-cache AS cache

# 后续构建步骤
FROM docker.xuanyuan.run/golang:1.20
COPY --from=cache /path/to/dependencies /path/to/dependencies
# ... 其他构建命令
```

### 构建命令使用缓存
```bash
docker build --cache-from kubevirt/builder-cache -t my-kubevirt-component .

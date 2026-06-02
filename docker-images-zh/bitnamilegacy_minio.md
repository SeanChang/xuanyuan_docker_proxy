<!-- xuanyuan-docker-images-zh
image: bitnamilegacy/minio
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/minio
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/minio
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [bitnamilegacy/minio — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bitnamilegacy/minio "bitnamilegacy/minio Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/bitnamilegacy/minio

## 概述
本仓库为Bitnami旧版仓库，包含所有现有容器镜像的备份。这些镜像不再接收更新或支持，仅应用于临时迁移目的。请注意，该仓库未来可能被移除。

## 使用场景和适用范围
仅适用于临时迁移场景，**禁止用于生产环境或长期使用**。由于镜像不再更新，存在安全风险和功能缺陷无法修复的问题。

## 使用建议
若依赖任何旧版镜像，建议立即执行以下操作以确保可用性：
1. 拉取镜像至本地：
   ```bash
   docker pull bitnami/[镜像名称]:[标签]
   ```
   （请将`[镜像名称]`和`[标签]`替换为具体镜像信息）

2. 存储至私有容器 registry：
   ```bash
   docker tag bitnami/[镜像名称]:[标签] [私有registry地址]/[镜像名称]:[标签]
   docker push [私有registry地址]/[镜像名称]:[标签]
   ```

## 生产环境替代方案
对于生产工作负载和长期支持，强烈建议迁移至[Bitnami Secure Images](https://bitnami.com/)。其优势包括：
- 加固容器（减少安全漏洞）
- 更小的攻击面
- CVE透明度（通过VEX/KEV报告）
- 软件物料清单（SBOMs）
- 企业级技术支持

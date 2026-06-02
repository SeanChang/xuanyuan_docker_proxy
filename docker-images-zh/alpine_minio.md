<!-- xuanyuan-docker-images-zh
image: alpine/minio
source: https://xuanyuan.cloud/zh/r/alpine/minio
canonical: https://xuanyuan.cloud/zh/r/alpine/minio
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [alpine/minio — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/alpine/minio "alpine/minio Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/alpine/minio

# Minio Docker镜像

## 概述
本镜像为社区维护的Minio对象存储服务Docker镜像。因Minio官方停止提供Docker镜像（详见[相关说明](https://github.com/minio/minio/issues/21647)），社区通过自动构建流程发布最新版本，支持多架构部署，适用于需要Minio对象存储服务的场景。

## 注意事项
- 镜像无`latest`标签
- `latest-release`标签对应最新发布版本（[Minio最新发布](https://github.com/minio/minio/releases/latest)）
- 生产环境请勿使用`latest-release`标签，应指定具体版本标签，例如`alpine/minio:RELEASE.2025-10-15T17-29-55Z`
- 旧版本标签需从[minio/minio](https://hub.docker.com/r/minio/minio)拉取

## 核心特性
- **自动构建**：当Minio官方发布新版本时，通过CI流程自动触发镜像构建
- **多架构支持**：包含linux/amd64、linux/arm/v7、linux/arm64/v8、linux/arm/v6、linux/ppc64le、linux/s390x架构
- **版本管理**：使用具体版本标签（如`RELEASE.2025-10-15T17-29-55Z`）确保部署稳定性

## 相关链接
- GitHub仓库：[alpine-docker/minio](https://github.com/alpine-docker/minio)
- CI构建日志：[GitHub Actions](https://github.com/alpine-docker/minio/actions)
- 镜像标签列表：[Docker Hub Tags](https://hub.docker.com/r/alpine/minio/tags/)

## 使用场景
- 开发/测试环境的Minio服务快速部署
- 生产环境对象存储服务部署（需使用具体版本标签）
- 多架构环境（如ARM设备、PowerPC等）的Minio部署

## 使用方法

### 独立模式（本地存储）
通过以下命令启动独立模式Minio服务（使用本地存储）：

```bash
docker run -p 9000:9000 -p 9001:9001 alpine/minio:RELEASE.2025-10-15T17-29-55Z server /tmp/minio --console-address :9001
```

#### 访问Web控制台
服务启动后，通过以下地址访问Minio管理控制台：  
http://localhost:9001

#### 默认凭证
初始管理员凭证（用户名:密码）为：`minioadmin:minioadmin`

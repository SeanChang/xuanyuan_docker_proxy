<!-- xuanyuan-docker-images-zh
image: bitnamicharts/minio
source: https://xuanyuan.cloud/zh/r/bitnamicharts/minio
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/minio
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [bitnamicharts/minio — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bitnamicharts/minio "bitnamicharts/minio Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/bitnamicharts/minio

# Bitnami MinIO® 对象存储

## 镜像概述和主要用途

Bitnami MinIO® 镜像是基于 MinIO® 的对象存储服务器解决方案，兼容 Amazon S3 云存储服务，主要用于存储非结构化数据（如照片、视频、日志文件等）。该镜像由 Bitnami 打包优化，提供开箱即用的部署体验，适用于开发、测试及生产环境。

MinIO® 是一个高性能的对象存储服务器，采用 GNU AGPL v3.0 许可协议，支持分布式部署以实现高可用性和可扩展性。Bitnami 镜像则进一步简化了其部署和配置流程，并集成了安全加固和运维最佳实践。

## 核心功能和特性

- **S3 兼容性**：完全兼容 Amazon S3 API，可无缝集成现有 S3 客户端和工具
- **部署模式灵活**：支持单机模式（默认）和分布式模式，满足不同规模存储需求
- **数据持久化**：通过持久卷（Persistent Volume）或 Docker 卷实现数据持久化存储
- **监控集成**：支持 Prometheus 指标导出，便于性能和健康状态监控
- **安全特性**：支持 TLS 加密传输，可配置自动证书生成（Helm 部署时）或使用现有证书
- **资源管理**：可配置 CPU/内存资源限制和请求，适应不同环境资源需求
- **Kubernetes 原生**：提供 Helm Chart 支持，易于在 Kubernetes 集群中部署和管理
- **高可用性**：分布式模式下支持纠删码（Erasure Coding），确保数据可靠性

## 使用场景和适用范围

### 适用场景
- **非结构化数据存储**：存储照片、视频、备份文件、日志数据等
- **开发/测试环境**：快速搭建 S3 兼容的对象存储服务，用于应用程序测试
- **小型生产环境**：作为独立存储服务，为中小规模应用提供对象存储能力
- **云原生应用集成**：与 Kubernetes、容器化应用配合，提供持久化存储解决方案
- **数据备份与归档**：作为低成本、高可用的备份存储系统

### 适用范围
- 个人开发者或小型团队的本地存储需求
- 企业内部开发/测试环境的对象存储服务
- 对 S3 兼容性有要求的云原生应用后端存储
- 需要快速部署且易于维护的对象存储场景

## 详细的使用方法和配置说明

### 快速启动（Helm Chart）

#### 前提条件
- Kubernetes 集群 1.23+
- Helm 3.8.0+
- 集群支持持久卷（PV）动态供应

#### 安装命令
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/minio
```

> 提示：此应用也可作为 Kubernetes 应用在 Azure Marketplace 中获取。Kubernetes 应用是在 AKS 上部署 Bitnami 应用的最简单方式，详情参见 [Azure Marketplace 列表](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.minio-cnab)。

### Docker 部署示例

#### 单机模式（docker run）
```bash
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=admin \
  -e MINIO_ROOT_PASSWORD=password \
  -v minio_data:/bitnami/minio/data \
  bitnami/minio:latest
```
- `-p 9000:9000`：S3 API 端口映射
- `-p 9001:9001`：MinIO 控制台端口映射
- `-e MINIO_ROOT_USER`：管理员用户名
- `-e MINIO_ROOT_PASSWORD`：管理员密码（生产环境需使用强密码）
- `-v minio_data:/bitnami/minio/data`：数据持久化卷

#### Docker Compose 配置
```yaml
version: '3'
services:
  minio:
    image: bitnami/minio:latest
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=password
    volumes:
      - minio_data:/bitnami/minio/data
volumes:
  minio_data:
```

### 配置参数说明

#### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 全局 Docker 镜像拉取密钥（数组） | `[]` |
| `global.defaultStorageClass` | 持久卷默认存储类 | `""` |
| `global.security.allowInsecureImages` | 允许跳过镜像验证 | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 适配 OpenShift 安全上下文 | `auto` |

#### 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `nameOverride` | 覆盖资源名称前缀 | `""` |
| `namespaceOverride` | 覆盖命名空间 | `""` |
| `fullnameOverride` | 完全覆盖资源全名 | `""` |
| `commonLabels` | 应用于所有资源的标签 | `{}` |
| `commonAnnotations` | 应用于所有资源的注解 | `{}` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 额外部署的 Kubernetes 对象（数组） | `[]` |

#### MinIO 核心参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `image.registry` | MinIO 镜像仓库 | `REGISTRY_NAME`（默认 `registry-1.docker.io`） |
| `image.repository` | MinIO 镜像名称 | `REPOSITORY_NAME/minio`（默认 `bitnamicharts/minio`） |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `auth.rootUser` | 管理员用户名 | `admin` |
| `auth.rootPassword` | 管理员密码 | `""`（建议手动指定） |
| `auth.existingSecret` | 使用现有密钥存储凭据 | `""` |
| `mode` | 部署模式（`standalone`/`distributed`） | `standalone` |
| `persistence.enabled` | 是否启用持久化存储 | `true` |
| `persistence.mountPath` | 数据存储路径 | `/bitnami/minio/data` |
| `tls.enabled` | 是否启用 TLS | `false` |
| `metrics.enabled` | 是否启用 Prometheus 指标 | `false` |

> 完整参数列表参见 [Bitnami MinIO Helm Chart 文档](https://github.com/bitnami/charts/blob/main/bitnami/minio/README.md)

### 关键配置说明

#### 1. 分布式模式部署

默认部署为单机模式，可通过以下参数启用分布式模式：
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/minio \
  --set mode=distributed
```

**自定义节点数量**（默认 4 节点）：
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/minio \
  --set mode=distributed \
  --set statefulset.replicaCount=8
```

**多区域部署**（2 区域，每区域 2 节点，每节点 2 磁盘）：
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/minio \
  --set mode=distributed \
  --set statefulset.replicaCount=2 \
  --set statefulset.zones=2 \
  --set statefulset.drivesPerNode=2
```

> 注意：分布式模式下，磁盘总数需大于 4 以支持纠删码，建议根据数据可靠性需求调整节点和磁盘配置。

#### 2. 持久化存储配置

默认启用持久化存储，可通过以下参数调整：
```yaml
persistence:
  enabled: true
  storageClass: "my - storage - class"  # 指定存储类
  size: 10Gi                           # 存储大小
  accessModes:
    - ReadWriteOnce
```

#### 3. 认证配置

**使用默认凭据**（不推荐生产环境）：
```yaml
auth:
  rootUser: admin
  rootPassword: "your - strong - password"  # 手动指定强密码
```

**使用现有密钥**：
```yaml
auth:
  existingSecret: "my - minio - secret"  # 现有密钥名称
  rootUserSecretKey: "root - user"       # 密钥中存储用户名的键
  rootPasswordSecretKey: "root - password"  # 密钥中存储密码的键
```

#### 4. TLS 加密配置

**启用 TLS**：
```yaml
tls:
  enabled: true
  existingCASecret: "ca - secret"        # CA 证书密钥（可选）
  server:
    existingSecret: "minio - tls - secret"  # 服务器证书密钥
```

**自动生成证书**（Helm 部署时）：
```yaml
tls:
  enabled: true
  autoGenerated:
    enabled: true
    engine: "cert - manager"  # 或 "helm"（使用 Helm 生成自签名证书）
    certManager:
      existingIssuer: "my - issuer"  # 现有 CertManager Issuer
```

#### 5. Prometheus 监控集成

启用 Prometheus 指标：
```yaml
metrics:
  enabled: true
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/path: "/minio/v2/metrics/cluster"
  prometheus.io/port: "9000"
```

## ⚠️ 重要通知：Bitnami 镜像仓库即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像仓库，推出**Bitnami Secure Images**计划，专注于提供安全加固的容器镜像。此次变更包括：

### 主要变更内容
1. **安全镜像开放**：首次向社区用户提供热门容器镜像的安全优化版本
2. **非加固镜像逐步淘汰**：免费 tier 将逐步停止支持非加固的 Debian 基础镜像，并从公共仓库中移除非最新标签，社区用户将只能获取有限的加固镜像（仅 "latest" 标签，用于开发目的）
3. **镜像迁移**：2025 年 8 月 28 日起，所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共仓库（docker.io/bitnami）迁移至 "Bitnami Legacy" 仓库（docker.io/bitnamilegacy），且不再接收更新
4. **生产环境建议**：对于生产工作负载和长期支持，建议采用 Bitnami Secure Images，包含加固容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOMs 和企业级支持

### 影响与建议
- 开发环境：若使用 "latest" 标签，将自动获取加固后的镜像，可能需要适配安全配置变更
- 生产环境：请在 2025 年 8 月 28 日前评估并迁移至 Bitnami Secure Images 或其他长期支持的镜像版本
- 版本固定：若需保持现有版本，迁移后需将镜像仓库地址更新为 docker.io/bitnamilegacy

更多详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)

## 免责声明

所有软件产品、项目和公司名称均为其各自持有者的商标™或注册商标®，使用这些名称并不意味着任何关联或背书。本软件根据一个或多个开源许可证授权给您，VMware 按"原样"提供软件。MinIO® 是 MinIO Inc. 在美国和其他国家的注册商标。Bitnami 与 MinIO Inc. 无任何关联、关联、授权、背书或以任何方式正式连接。MinIO® 根据 GNU AGPL v3.0 许可。

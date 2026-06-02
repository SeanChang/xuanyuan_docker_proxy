---
image: bitnamilegacy/redis-cluster
description: "旧版Bitnami镜像，已不再更新"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/redis-cluster
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[bitnamilegacy/redis-cluster](https://xuanyuan.cloud/zh/r/bitnamilegacy/redis-cluster)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Legacy 镜像文档


## 1. 镜像概述和主要用途

Bitnami Legacy 镜像是 Bitnami Legacy 仓库中存储的历史容器镜像集合，包含原 Bitnami 容器镜像的备份版本。该类镜像已停止接收任何形式的更新或官方支持，其主要用途仅限于依赖旧版本 Bitnami 镜像的临时迁移场景，作为历史镜像资源的过渡性备份。


## 2. 核心功能和特性

### 2.1 核心功能
- **历史镜像备份**：包含 Bitnami 过往发布的容器镜像备份，保留原镜像的基础功能和运行逻辑。


### 2.2 关键特性
- **无持续更新**：不再提供功能迭代、安全补丁或 bug 修复。
- **无官方支持**：Bitnami 官方不提供技术支持、问题响应或维护服务。
- **兼容性保留**：维持与原镜像版本一致的基础运行环境和依赖关系，确保临时迁移过程中的兼容性。


## 3. 使用场景和适用范围

### 3.1 适用场景
- **临时迁移过渡**：仅用于依赖旧版本 Bitnami 镜像的系统/应用临时迁移场景，作为从旧环境向新环境过渡的临时资源。


### 3.2 适用范围
- **非生产环境**：严禁用于生产环境或长期运行的业务系统。
- **短期使用**：仅限短期临时使用，完成迁移后应立即替换为受支持的镜像版本。

> **注意**：对于生产 workload 和长期支持需求，应采用 [Bitnami Secure Images](https://bitnami.com/)，其包含加固容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOMs 及企业级支持。


## 4. 使用方法和配置说明

### 4.1 镜像拉取
由于该仓库未来可能被移除，使用前需手动拉取镜像并存储至私有容器 registry：

```bash
# 拉取 Legacy 镜像（示例，具体镜像名称需替换为实际依赖的旧版本镜像）
docker pull bitnami/[镜像名称]:[旧版本标签]
```


### 4.2 镜像存储
为确保后续可用性，拉取后需立即推送至私有容器 registry：

```bash
# 标记镜像为私有 registry 地址（示例）
docker tag bitnami/[镜像名称]:[旧版本标签] [私有 registry 地址]/[镜像名称]:[旧版本标签]

# 推送至私有 registry
docker push [私有 registry 地址]/[镜像名称]:[旧版本标签]
```


### 4.3 配置说明
- **配置沿用**：Legacy 镜像的运行配置（如环境变量、挂载路径等）与原 Bitnami 镜像版本一致，无新增或变更配置项。
- **风险提示**：由于镜像无安全更新，运行时需自行承担潜在安全风险，建议仅在隔离环境中临时使用。


### 4.4 部署示例（临时迁移用）
以下为临时迁移场景下的基础部署示例（以 Docker 运行为例）：

```bash
# 从私有 registry 拉取存储的 Legacy 镜像
docker pull [私有 registry 地址]/[镜像名称]:[旧版本标签]

# 临时运行镜像（沿用原配置参数，示例）
docker run -d \
  --name [容器名称] \
  -e [原环境变量1]=[值] \
  -e [原环境变量2]=[值] \
  -v [宿主机路径]:[容器内路径] \
  [私有 registry 地址]/[镜像名称]:[旧版本标签]
```


## 5. 重要声明
- 该仓库及镜像未来可能被永久移除，依赖方需自行负责镜像的长期存储与维护。
- Legacy 镜像不提供任何安全保障或功能支持，生产环境必须迁移至 [Bitnami Secure Images](https://bitnami.com/) 以确保业务连续性和安全性。

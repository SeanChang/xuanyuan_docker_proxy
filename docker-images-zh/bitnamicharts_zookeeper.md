---
image: bitnamicharts/zookeeper
description: "Bitnami提供的Apache ZooKeeper Helm图表，用于在Kubernetes环境中简化分布式协调服务的部署与管理。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/zookeeper
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/zookeeper
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/zookeeper" title="bitnamicharts/zookeeper Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/zookeeper 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Apache ZooKeeper 镜像文档


## 镜像概述和主要用途

Apache ZooKeeper 是一个分布式协调服务，为分布式应用提供可靠的集中式配置数据存储、服务注册与发现、分布式锁及同步机制。Bitnami 提供的 Apache ZooKeeper 镜像基于最佳实践构建，简化了在 Kubernetes 或 Docker 环境中的部署流程，包含安全加固配置、持久化存储支持及监控集成能力，适用于开发和生产环境。


## 核心功能和特性

- **身份验证支持**：通过 SASL/Digest-MD5 实现客户端-服务器及服务器-服务器（仲裁）身份验证。
- **持久化存储**：支持通过 Persistent Volume Claims (PVC) 持久化数据和配置，确保数据跨部署保留。
- **监控集成**：可与 Prometheus 无缝集成，暴露原生指标端点并支持 ServiceMonitor 自动发现。
- **灵活配置**：支持自定义 `zoo.cfg` 配置文件、环境变量调优（如日志级别、JVM 参数）及外部 ConfigMap 挂载。
- **自动清理机制**：可配置快照保留数量（`autopurge.snapRetainCount`）和清理间隔（`autopurge.purgeInterval`）。
- **安全加固**：默认以非 root 用户运行，支持 Kubernetes Security Context 及卷权限调整。
- **日志优化**：可通过环境变量（`ZOO_LOG_LEVEL`）配置日志级别，避免探针连接导致的日志噪音。


## 使用场景和适用范围

### 典型使用场景
- **分布式系统协调**：作为 Kafka、Hadoop、Spark 等分布式系统的核心依赖，提供集群协调。
- **服务注册与发现**：存储分布式服务的节点信息，支持动态服务发现。
- **配置管理**：集中存储分布式应用的配置参数，支持动态更新。
- **分布式锁与同步**：提供分布式环境下的互斥锁、屏障等同步原语。
- **Leader 选举**：协助分布式集群选举主节点（如数据库集群、任务调度系统）。

### 适用范围
- 开发环境：快速搭建单节点或小型集群用于应用测试。
- 生产环境：通过 Helm Chart 部署多节点集群，结合持久化存储和身份验证确保高可用性。


## 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，推出 **Bitnami Secure Images** 计划，专注于提供安全加固的镜像。过渡期变更如下：

- **安全镜像开放**：首次向社区用户开放安全优化版本的容器镜像，包含更小攻击面、CVE 透明度（VEX/KEV）及 SBOMs。
- **非加固镜像 deprecation**：免费 tier 将逐步停止支持非加固的 Debian 基础镜像，仅保留少量“latest”标签的加固镜像（限开发用途）。
- **旧镜像迁移**：所有现有镜像（含历史版本标签，如 2.50.0、10.6）将在两周内从 `docker.io/bitnami` 迁移至 `docker.io/bitnamilegacy` 仓库，且不再接收更新。
- **生产环境建议**：生产 workload 需迁移至 Bitnami Secure Images，以获取长期支持、安全加固及企业级服务。

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 先决条件

- Kubernetes 集群版本 1.23+
- Helm 3.8.0+
- 底层基础设施支持 PV 动态供应（用于持久化存储）


## 详细使用方法和配置说明

### 1. Helm Chart 安装

#### 快速安装（TL;DR）
```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/zookeeper
```

#### 标准安装步骤
1. 指定 Helm 仓库及发布名称：
   ```console
   helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/zookeeper
   ```
   > 替换 `REGISTRY_NAME` 和 `REPOSITORY_NAME`（Bitnami 官方仓库为 `registry-1.docker.io` 和 `bitnamicharts`）。

2. 验证部署：
   ```console
   helm list  # 查看所有 Helm 发布
   kubectl get pods  # 确认 ZooKeeper Pod 运行状态
   ```


### 2. Docker 部署示例

#### 单节点部署（Docker Run）
适用于开发环境，无需身份验证：
```bash
docker run -d \
  --name zookeeper \
  -p 2181:2181 \  # 客户端端口
  -p 8080:8080 \  # Admin Server 端口
  -e ALLOW_ANONYMOUS_LOGIN=yes \  # 允许匿名登录（开发环境）
  -v zookeeper-data:/bitnami/zookeeper \  # 持久化数据卷
  bitnami/zookeeper:latest
```

#### 集群部署（Docker Compose）
3 节点集群示例（`docker-compose.yml`）：
```yaml
version: '3'
services:
  zookeeper-1:
    image: bitnami/zookeeper:latest
    container_name: zookeeper-1
    ports:
      - "2181:2181"
      - "8080:8080"
    environment:
      - ZOO_SERVER_ID=1
      - ZOO_SERVERS=zookeeper-1:2888:3888;zookeeper-2:2888:3888;zookeeper-3:2888:3888
      - ALLOW_ANONYMOUS_LOGIN=yes
    volumes:
      - zookeeper-data-1:/bitnami/zookeeper

  zookeeper-2:
    image: bitnami/zookeeper:latest
    container_name: zookeeper-2
    ports:
      - "2182:2181"
      - "8081:8080"
    environment:
      - ZOO_SERVER_ID=2
      - ZOO_SERVERS=zookeeper-1:2888:3888;zookeeper-2:2888:3888;zookeeper-3:2888:3888
      - ALLOW_ANONYMOUS_LOGIN=yes
    volumes:
      - zookeeper-data-2:/bitnami/zookeeper

  zookeeper-3:
    image: bitnami/zookeeper:latest
    container_name: zookeeper-3
    ports:
      - "2183:2181"
      - "8082:8080"
    environment:
      - ZOO_SERVER_ID=3
      - ZOO_SERVERS=zookeeper-1:2888:3888;zookeeper-2:2888:3888;zookeeper-3:2888:3888
      - ALLOW_ANONYMOUS_LOGIN=yes
    volumes:
      - zookeeper-data-3:/bitnami/zookeeper

volumes:
  zookeeper-data-1:
  zookeeper-data-2:
  zookeeper-data-3:
```


### 3. 核心配置说明

#### 资源配置
通过 `resources` 参数限制 CPU/内存资源（Helm 配置）：
```yaml
resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```
> 生产环境建议根据实际负载调整，避免资源竞争。


#### 身份验证配置
启用客户端身份验证（Helm values.yaml）：
```yaml
auth:
  client:
    enabled: true
    clientUser: zk-client
    clientPassword: secure-client-pass
    serverUsers: zk-server1,zk-server2
    serverPasswords: secure-server1-pass,secure-server2-pass
```
> 生产环境建议使用 `existingSecret` 引用预先创建的 Secret，避免明文密码。


#### 监控集成（Prometheus）
启用 Prometheus 指标采集：
```yaml
metrics:
  enabled: true  # 暴露指标端点
  serviceMonitor:
    enabled: true  # 创建 ServiceMonitor 供 Prometheus Operator 发现
```
指标将通过 `http://<pod-ip>:9141/metrics` 暴露，包含连接数、事务数、快照数等核心指标。


#### 日志级别调整
默认日志级别为 `ERROR`（减少探针日志噪音）。如需调整为 `INFO`（生产环境建议）：
1. 启用 metrics 避免 deprecated `mntr` 探针：
   ```yaml
   metrics:
     enabled: true
   ```
2. 调整探针使用 Admin Server（替换默认客户端端口探针）：
   ```yaml
   livenessProbe:
     enabled: false
   readinessProbe:
     enabled: false
   customLivenessProbe:
     exec:
       command: ['/bin/bash', '-c', 'curl -s -m 2 http://localhost:8080/commands/ruok | grep ruok']
     initialDelaySeconds: 30
     periodSeconds: 10
   customReadinessProbe:
     exec:
       command: ['/bin/bash', '-c', 'curl -s -m 2 http://localhost:8080/commands/ruok | grep error | grep null']
     initialDelaySeconds: 5
     periodSeconds: 10
   ```
3. 设置日志级别：
   ```yaml
   logLevel: INFO
   ```


### 4. 持久化配置

#### 数据存储路径
容器内数据存储路径为 `/bitnami/zookeeper`，包含快照、事务日志及配置文件。通过 PVC 持久化：
```yaml
persistence:
  enabled: true
  storageClass: "standard"  # 指定存储类
  size: 10Gi  # 存储容量
```

#### 数据日志分离
将事务日志存储在独立卷（提升性能）：
```yaml
dataLogDir: /bitnami/zookeeper/logs  # 日志路径
persistence:
  enabled: true
  dataLog:
    enabled: true  # 为日志创建独立 PVC
    storageClass: "high-iops"  # 建议使用高性能存储（如 SSD）
    size: 5Gi
```


### 5. 备份与恢复
使用 Velero 备份 ZooKeeper 数据：
1. 安装 Velero 并配置存储后端（如 S3）。
2. 创建备份：
   ```bash
   velero backup create zookeeper-backup \
     --include-resources pvc,pv \  # 备份 PVC 和 PV
     --selector app.kubernetes.io/name=zookeeper  # 选择 ZooKeeper 资源
   ```
3. 恢复备份：
   ```bash
   velero restore create --from-backup zookeeper-backup
   ```


## 参数说明

### 全局参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `global.imageRegistry` | 全局 Docker 镜像仓库 | `""` |
| `global.imagePullSecrets` | 镜像拉取密钥列表 | `[]` |
| `global.defaultStorageClass` | 全局默认存储类 | `""` |
| `global.security.allowInsecureImages` | 是否允许不安全镜像（跳过校验） | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | 是否适配 OpenShift 安全上下文 | `auto` |


### 通用参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `nameOverride` | 覆盖发布名称前缀 | `""` |
| `fullnameOverride` | 完全覆盖发布名称 | `""` |
| `clusterDomain` | Kubernetes 集群域名 | `cluster.local` |
| `extraDeploy` | 额外部署的 Kubernetes 资源（模板格式） | `[]` |
| `diagnosticMode.enabled` | 启用诊断模式（禁用探针，覆盖命令） | `false` |


### ZooKeeper 核心参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `image.registry` | 镜像仓库 | `REGISTRY_NAME` |
| `image.repository` | 镜像名称 | `REPOSITORY_NAME/zookeeper` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `tickTime` | 心跳基本时间单位（毫秒） | `2000` |
| `initLimit` | 集群初始化超时（tick 数） | `10` |
| `syncLimit` |  leader 同步超时（tick 数） | `5` |
| `heapSize` | JVM 堆大小（MB） | `1024` |
| `autopurge.snapRetainCount` | 保留快照数量 | `10` |
| `autopurge.purgeInterval` | 自动清理间隔（小时） | `1` |
| `fourlwCommandsWhitelist` | 允许的四字命令列表 | `srvr, mntr, ruok` |


### 身份验证参数

| 参数名 | 描述 | 默认值 |
|--------|------|--------|
| `auth.client.enabled` | 启用客户端身份验证 | `false` |
| `auth.client.clientUser` | 客户端认证用户名 | `""` |
| `auth.quorum.enabled` | 启用仲裁节点身份验证 | `false` |
| `auth.quorum.learnerUser` | 仲裁学习者用户名 | `""` |


## 注意事项

- **生产环境建议**：使用 Bitnami Secure Images（2025 年 8 月后），获取安全加固、CVE 透明度及长期支持。
- **版本迁移**：旧版本镜像（如 `10.6`）将迁移至 `bitnamilegacy` 仓库，不再更新，需及时升级。
- **安全最佳实践**：禁用 `ALLOW_ANONYMOUS_LOGIN`，启用身份验证并使用 `existingSecret` 管理密码。
- **性能优化**：事务日志建议使用独立高性能存储，避免与快照存储竞争 I/O。

---
image: percona/percona-xtradb-cluster-operator
description: "用于在Kubernetes环境中管理Percona XtraDB Cluster的部署、扩展与高可用的Operator，提供自动化运维能力，确保MySQL兼容集群的稳定运行。"
source: https://xuanyuan.cloud/zh/r/percona/percona-xtradb-cluster-operator
canonical: https://xuanyuan.cloud/zh/r/percona/percona-xtradb-cluster-operator
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/percona/percona-xtradb-cluster-operator" title="percona/percona-xtradb-cluster-operator Docker 镜像中文简介、标签列表与拉取命令">percona/percona-xtradb-cluster-operator 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Percona Operator for MySQL 技术文档


## 1. 镜像概述与主要用途  
Percona Operator for MySQL 是一款用于在 Kubernetes 环境中自动化创建、管理高可用 MySQL 生产集群的工具。它基于 Percona XtraDB Cluster 提供同步复制能力，确保集群可靠性，并完全开源（100% open source），无厂商锁定（vendor lock-in）。其核心目标是简化 MySQL 集群在 Kubernetes 上的部署、扩展与运维，降低人工操作成本，适用于需要稳定、自动化管理数据库基础设施的生产环境。


## 2. 核心功能与特性  

### 2.1 核心功能  
- **自动化集群生命周期管理**：支持创建、弹性扩展（横向/纵向）及销毁 MySQL 集群，内置 Percona XtraDB Cluster 同步复制机制，确保数据一致性。  
- **全自动化 Day-2 操作**：集成备份与恢复（支持时间点恢复 PITR）、集群扩容、软件升级等运维操作，无需人工干预。  
- **原生负载均衡集成**：开箱支持 ProxySQL 和 HAProxy 负载均衡器，自动配置流量分发，优化读写分离与故障转移。  
- **默认安全增强**：强制启用 TLS/SSL 加密所有节点间通信，包括客户端连接，满足数据传输安全合规要求。  
- **零停机升级**：支持 MySQL 软件版本及 Operator 自身的滚动升级，避免业务中断。  
- **监控与可观测性**：无缝对接 Percona Monitoring and Management（PMM）工具，提供集群性能、健康状态的实时监控与告警。  


## 3. 使用场景与适用范围  

### 3.1 典型使用场景  
- **生产级 MySQL 集群部署**：需在 Kubernetes 上构建高可用、高可靠 MySQL 集群的企业环境。  
- **自动化运维需求**：减少人工介入的场景，如无人值守备份、故障自动恢复、版本升级等。  
- **高可用与灾备需求**：依赖同步复制和自动故障转移，确保数据库服务持续可用。  
- **安全合规场景**：对数据传输加密（TLS/SSL）、访问控制有严格要求的金融、电商等行业。  

### 3.2 适用范围  
- Kubernetes 环境（v1.21+ 推荐）；  
- 需管理 10+ 节点规模的 MySQL 集群场景；  
- 需与现有监控体系（如 PMM、Prometheus）集成的运维体系。  


## 4. 使用方法与配置说明  

### 4.1 部署前提  
- 已配置 Kubernetes 集群（v1.21+），支持 StorageClass（用于持久化存储）；  
- 安装 `kubectl` 命令行工具并配置集群访问权限；  
- （可选）安装 PMM 监控服务（用于集群监控）。  


### 4.2 部署步骤  

#### 4.2.1 安装 Operator  
通过 Kubernetes 资源清单部署 Operator：  
```bash
# 获取最新 Operator 部署清单
kubectl apply -f https://raw.githubusercontent.com/percona/percona-xtradb-cluster-operator/main/deploy/bundle.yaml

# 验证 Operator 部署状态（确保 pod 运行正常）
kubectl get pods -n percona-xtradb-cluster-operator
```


#### 4.2.2 创建 MySQL 集群实例  
创建自定义资源（CR）配置文件 `my-cluster.yaml`，定义集群参数：  
```yaml
apiVersion: pxc.percona.com/v1
kind: PerconaXtraDBCluster
metadata:
  name: my-pxc-cluster
spec:
  secretsName: my-cluster-secrets  # 存储数据库凭证的 Secret 名称（需提前创建）
  pxc:
    size: 3  # 集群节点数（推荐 3+ 确保高可用）
    image: docker.xuanyuan.run/percona/percona-xtradb-cluster:8.0.32-24.1  # MySQL 镜像版本
    resources:
      requests:
        memory: "2G"
        cpu: "1"
      limits:
        memory: "4G"
        cpu: "2"
    storage:
      size: 20Gi  # 单节点存储容量
      storageClass: standard  # 关联的 StorageClass 名称
  proxysql:
    enabled: true  # 启用 ProxySQL 负载均衡
    size: 2  # ProxySQL 节点数
  backup:
    enabled: true  # 启用自动备份
    schedule: "0 3 * * *"  # 每日凌晨 3 点执行备份
    storageType: s3  # 备份存储类型（支持 s3/nfs 等）
    s3:
      bucket: my-pxc-backups  # S3 存储桶名称
      region: us-west-2
```  

应用配置创建集群：  
```bash
# 创建 Secret（存储 root 密码、集群通信密码等，需提前生成）
kubectl create secret generic my-cluster-secrets \
  --from-literal=root=StrongRootPassword \
  --from-literal=xtrabackup=StrongXtrabackupPassword \
  --from-literal=monitoring=StrongMonitoringPassword

# 部署集群
kubectl apply -f my-cluster.yaml

# 验证集群状态（等待所有 pxc、proxysql pod 就绪）
kubectl get pods
```


### 4.3 核心配置参数说明  
| 参数路径                | 说明                                  | 默认值/推荐值                |  
|-------------------------|---------------------------------------|------------------------------|  
| `spec.pxc.size`         | MySQL 集群节点数                      | 3（生产环境推荐 ≥3）         |  
| `spec.pxc.resources`    | 节点 CPU/内存资源限制                 | requests: 1CPU/2G，limits: 2CPU/4G |  
| `spec.pxc.storage.size` | 单节点持久化存储容量                  | 20Gi                         |  
| `spec.backup.schedule`  | 自动备份执行周期（Cron 表达式）       | "0 3 * * *"（每日凌晨 3 点）  |  
| `spec.proxysql.enabled` | 是否启用 ProxySQL 负载均衡            | true                         |  
| `spec.ssl.enabled`      | 是否启用 TLS 加密通信                 | true（默认启用）             |  


### 4.4 常用操作示例  

#### 4.4.1 扩展集群节点数  
修改 CR 中 `spec.pxc.size` 字段并应用：  
```bash
kubectl patch pxc my-pxc-cluster --type=merge -p '{"spec": {"pxc": {"size": 5}}}'
```

#### 4.4.2 手动触发备份  
```bash
kubectl apply -f - <<EOF
apiVersion: pxc.percona.com/v1
kind: PerconaXtraDBClusterBackup
metadata:
  name: manual-backup-$(date +%F)
spec:
  pxcCluster: my-pxc-cluster
EOF
```

#### 4.4.3 查看集群状态  
```bash
kubectl get pxc my-pxc-cluster -o yaml
```


## 5. 参考文档  
完整配置说明与高级功能请参见官方文档：  
[Percona XtraDB Cluster Operator 官方文档](https://percona.github.io/percona-xtradb-cluster-operator/)

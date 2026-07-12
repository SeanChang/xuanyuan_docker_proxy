---
image: bitnamicharts/mariadb-galera
description: "Bitnami提供的Helm chart，用于在Kubernetes环境中部署高可用MariaDB Galera集群，支持同步多主复制，保障数据一致性与服务可靠性。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/mariadb-galera
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/mariadb-galera
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/mariadb-galera" title="bitnamicharts/mariadb-galera Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/mariadb-galera 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami MariaDB Galera 包

## 镜像概述和主要用途

MariaDB Galera 是一款多主数据库集群解决方案，支持同步复制和高可用性。Bitnami 提供的此包可通过 Helm 包管理器在 Kubernetes 集群上快速部署和管理 MariaDB Galera 集群，适用于需要高可用性和数据一致性的生产环境。

[MariaDB Galera 概述](https://mariadb.com/kb/en/library/galera-cluster/)

**商标声明**：本软件包由 Bitnami 打包。产品中提及的商标分属各自公司所有，使用此类商标不意味着任何关联或背书。


## 核心功能和特性

- **多主拓扑**：默认配置 3 节点集群，所有节点均为主节点，支持读写操作
- **同步复制**：节点间数据实时同步，避免单点故障导致的数据丢失
- **自动成员控制**：故障节点自动从集群中移除，确保集群稳定性
- **高可用性**：无单点故障，支持节点故障自动恢复
- **读写扩展性**：支持通过增加节点扩展读写能力
- **安全增强**：支持 TLS 加密通信、LDAP 身份认证
- **监控集成**：可与 Prometheus 集成，通过 mysqld_exporter 暴露指标
- **灵活初始化**：支持自定义初始化脚本（.sh、.sql、.sql.gz），满足个性化配置需求
- **持久化存储**：使用 Kubernetes Persistent Volume 存储数据，确保数据持久性


## 使用场景和适用范围

- **生产环境高可用数据库**：适用于对数据可用性要求极高的业务，如电商交易、金融数据等
- **读写密集型应用**：通过多主节点分担读写负载，提升应用响应速度
- **数据一致性要求严格的场景**：同步复制确保所有节点数据实时一致，避免异步复制的数据延迟问题
- **Kubernetes 容器化部署**：适合在 Kubernetes 环境中标准化部署和管理数据库集群


## 详细的使用方法和配置说明

### 前提条件

- Kubernetes 集群版本 1.23+
- Helm 包管理器 3.8.0+
- 集群支持 Persistent Volume (PV) 动态供应


### 快速部署（TL;DR）

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mariadb-galera
```

> 注意：生产环境建议使用 [VMware Tanzu Application Catalog](https://bitnami.com/enterprise)（Bitnami 商业版目录）。


### ⚠️ 重要通知：Bitnami 目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共目录，通过 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的强化安全镜像。过渡期变更如下：

- 首次向社区用户开放热门容器镜像的安全优化版本
- Bitnami 将逐步弃用免费 tier 中的非强化 Debian 基础镜像，并从公共目录中移除非最新标签。社区用户将只能访问数量减少的强化镜像，仅提供 "latest" 标签，适用于开发环境
- 8 月 28 日起，两周内所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至 "Bitnami Legacy" 仓库（docker.io/bitnamilegacy），且不再接收更新
- 生产环境建议采用 Bitnami Secure Images，包含强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOMs 及企业支持

更多详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


### 与 Bitnami MariaDB Helm Chart 的区别

| 特性                | MariaDB Galera Helm Chart               | MariaDB Helm Chart                     |
|---------------------|-----------------------------------------|----------------------------------------|
| 集群拓扑            | 多主（默认 3 节点，均支持读写）         | 单主（1 主节点，可选从节点）           |
| 复制方式            | 同步复制                               | 异步复制                               |
| 故障处理            | 自动成员控制，故障节点自动移除         | 需手动或通过外部工具切换主节点         |
| 扩展性              | 支持读写扩展                           | 主要支持读扩展（增加从节点）           |
| 数据一致性          | 强一致性（同步复制）                   | 最终一致性（异步复制）                 |


### 安装 Chart

使用以下命令部署 MariaDB Galera 集群：

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/mariadb-galera
```

> 注意：需替换 `REGISTRY_NAME` 和 `REPOSITORY_NAME` 为实际 Helm 仓库地址。Bitnami 官方仓库示例：`REGISTRY_NAME=registry-1.docker.io`，`REPOSITORY_NAME=bitnamicharts`。


### 卸载 Chart

1. 首先优雅终止 StatefulSet 中的 Pod：

```console
kubectl scale sts my-release-mariadb-galera --replicas=0
```

2. 卸载 Helm 发布：

```console
helm delete my-release
```


### 配置详情

#### 资源请求与限制

通过 `resources` 参数配置容器资源请求和限制，生产环境建议根据实际负载调整：

```yaml
resources:
  requests:
    cpu: 500m
    memory: 1Gi
  limits:
    cpu: 1000m
    memory: 2Gi
```

也可通过 `resourcesPreset` 使用预设配置（如 `micro`、`small`、`medium`），但生产环境建议手动配置以适配实际需求。


#### 更新凭据

凭据（如 root 密码）在首次部署时设置，后续更新需手动操作：

1. 通过 MariaDB 命令更新密码：

```sql
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('new-root-password');
```

2. 更新 Kubernetes Secret：

```shell
kubectl create secret generic my-release-mariadb-galera \
  --from-literal=mariadb-root-password=new-root-password \
  --from-literal=mariadb-password=new-user-password \
  --from-literal=mariadb-galera-mariabackup-password=new-backup-password \
  --dry-run -o yaml | kubectl apply -f -
```


#### Prometheus 监控集成

启用 metrics 以集成 Prometheus：

```yaml
metrics:
  enabled: true
  serviceMonitor:
    enabled: true  # 若使用 Prometheus Operator，启用 ServiceMonitor
```

将自动部署 mysqld-exporter 作为 sidecar 容器，并通过 `metrics` Service 暴露指标。


#### 启用 LDAP 认证

配置 LDAP 集成参数以启用 LDAP 身份认证：

```yaml
ldap:
  enabled: true
  uri: "ldap://ldap-server:389"       # LDAP 服务器地址
  base: "dc=example,dc=org"           # 基础 DN
  binddn: "cn=admin,dc=example,dc=org" # 绑定 DN
  bindpw: "admin-password"            # 绑定密码
  scope: "sub"                        # 搜索范围
  filter: "(uid=%s)"                  # 搜索过滤器
```

部署后，通过 MariaDB 客户端创建 PAM 认证用户：

```sql
CREATE USER 'ldap-user'@'localhost' IDENTIFIED VIA pam USING 'mariadb';
```


#### 启用 TLS 加密

1. 创建包含 TLS 证书的 Secret：

```console
kubectl create secret generic mariadb-tls-secret \
  --from-file=cert.pem=/path/to/cert.pem \
  --from-file=key.pem=/path/to/key.pem \
  --from-file=ca.pem=/path/to/ca.pem
```

2. 配置 Chart 启用 TLS：

```yaml
tls:
  enabled: true
  certificatesSecret: "mariadb-tls-secret"
  certFilename: "cert.pem"
  certKeyFilename: "key.pem"
  certCAFilename: "ca.pem"
```


#### 初始化实例

通过以下方式自定义初始化脚本：

- **方法 1**：在 Chart 目录下创建 `files/docker-entrypoint-initdb.d`，存放脚本（自动挂载为 ConfigMap）
- **方法 2**：通过 `initdbScripts` 参数定义脚本：

```yaml
initdbScripts:
  create-db.sh: |
    #!/bin/sh
    if [[ $(hostname) == *-0 ]]; then  # 仅在引导节点执行
      mysql -uroot -p${MARIADB_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS appdb;"
    fi
  init-table.sql: |
    CREATE TABLE IF NOT EXISTS appdb.users (id INT PRIMARY KEY);
```

> 注意：`.sh` 脚本在所有节点执行，`.sql` 和 `.sql.gz` 仅在引导节点执行。


#### 引导非 0 号节点

当集群需要从非 0 号节点引导时（如 0 号节点故障）：

1. 检查各节点 `grastate.dat` 中的 `safe_to_bootstrap` 值：

```console
# 示例：检查节点 2 的 grastate.dat
kubectl run -i --rm --tty volpod --image=bitnami/minideb --overrides='
{
  "spec": {
    "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "data-my-release-mariadb-galera-2"}}],
    "containers": [{"name": "check", "image": "bitnami/minideb", "command": ["cat", "/data/grastate.dat"], "volumeMounts": [{"mountPath": "/data", "name": "data"}]}]
  }
}'
```

2. 若仅节点 N 的 `safe_to_bootstrap: 1`，使用以下命令重新部署：

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/mariadb-galera \
  --set rootUser.password=old-root-password \
  --set galera.mariabackup.password=old-backup-password \
  --set galera.bootstrap.forceBootstrap=true \
  --set galera.bootstrap.bootstrapFromNode=N \
  --set podManagementPolicy=Parallel
```


#### 备份与恢复

**方法 1：使用 mysqldump 备份数据**

1. 导出数据：

```console
kubectl exec -it my-release-mariadb-galera-0 -- mysqldump -uroot -p${MARIADB_ROOT_PASSWORD} --all-databases > backup.sql
```

2. 恢复到新集群：

```console
kubectl exec -i my-release-mariadb-galera-0 -- mysql -uroot -p${MARIADB_ROOT_PASSWORD} < backup.sql
```

**方法 2：使用 Velero 备份 PV**

适用于同平台 Kubernetes 集群迁移，需安装 Velero：

```console
# 备份 PV
velero backup create mariadb-backup --include-resources=pvc,pv --selector app.kubernetes.io/instance=my-release

# 恢复 PV
velero restore create --from-backup mariadb-backup
```


### 持久化

数据存储在容器路径 `/bitnami/mariadb`，默认使用动态 PV 供应。可通过 `persistence` 参数自定义：

```yaml
persistence:
  enabled: true
  storageClass: "fast-storage"  # 指定存储类
  size: "10Gi"                  # 存储大小
```


### 配置参数

核心配置参数说明（完整列表参见 [官方文档](https://github.com/bitnami/charts/blob/main/bitnami/mariadb-galera/README.md)）：

| 参数                          | 描述                                  | 默认值                  |
|-------------------------------|---------------------------------------|-------------------------|
| `rootUser.password`           | root 用户密码                         | 自动生成随机密码        |
| `galera.replicas`             | 集群节点数量                          | 3                       |
| `galera.bootstrap.forceBootstrap` | 强制从指定节点引导集群              | false                   |
| `image.tag`                   | MariaDB Galera 镜像标签               | "latest"                |
| `resources.requests.cpu`      | CPU 请求                              | 250m                    |
| `resources.requests.memory`   | 内存请求                              | 256Mi                   |
| `metrics.enabled`             | 是否启用 Prometheus 指标              | false                   |


## 参考链接

- [MariaDB Galera 官方文档](https://mariadb.com/kb/en/library/galera-cluster/)
- [Bitnami MariaDB Galera 容器镜像](https://github.com/bitnami/containers/tree/main/bitnami/mariadb-galera)
- [Bitnami MariaDB Galera Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/mariadb-galera)

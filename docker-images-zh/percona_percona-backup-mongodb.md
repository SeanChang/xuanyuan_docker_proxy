---
image: percona/percona-backup-mongodb
description: "Percona Backup for MongoDB是开源、分布式的低影响MongoDB集群备份解决方案，支持逻辑/物理备份、增量备份、时间点恢复及分片，兼容MongoDB 4.4+，确保备份时性能无显著下降。"
source: https://xuanyuan.cloud/zh/r/percona/percona-backup-mongodb
canonical: https://xuanyuan.cloud/zh/r/percona/percona-backup-mongodb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/percona/percona-backup-mongodb" title="percona/percona-backup-mongodb Docker 镜像中文简介、标签列表与拉取命令">percona/percona-backup-mongodb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Percona Backup for MongoDB

## 镜像概述和主要用途
Percona Backup for MongoDB是一款开源、分布式且低影响的MongoDB集群一致性备份解决方案，支持分片集群。其核心价值在于能够在备份数据时避免显著的性能和运行降级，为MongoDB集群提供可靠的数据保护。

## 核心功能和特性
- **逻辑备份与恢复**：支持MongoDB数据的逻辑导出与恢复
- **物理（热）备份与恢复**：提供无需停机的物理备份能力
- **增量备份**：仅备份自上次备份后变化的数据，节省存储空间和时间
- **时间点恢复（PITR）**：可恢复到指定时间点的数据状态
- **选择性逻辑备份与恢复**：支持按需求选择特定数据进行备份和恢复
- **集成管理界面**：通过Percona Monitoring and Management工具提供PITR和备份管理功能

## 兼容性说明
- **逻辑备份**：兼容Percona Server for MongoDB及MongoDB Community v4.4及更高版本（需启用MongoDB复制）
- **物理备份**：兼容Percona Server for MongoDB 4.4.6-8、5.0及更高版本（需启用MongoDB复制并配置WiredTiger作为存储引擎）

## Percona Backup for MongoDB Docker镜像
Percona Backup for MongoDB Docker镜像由Percona团队创建和维护，当有新版本发布时会同步更新镜像。

## 使用方法和配置说明

### 启动Percona Backup for MongoDB容器
通过以下命令启动Percona Backup for MongoDB容器：

```bash
docker run --name container-name -e PBM_MONGODB_URI="mongodb://<PBM_USER>:<PBM_USER_PASSWORD>@<HOST>:<PORT>" -d docker.xuanyuan.run/percona/percona-backup-mongodb:tag
```

参数说明：
- `container-name`：您为容器分配的名称
- `PBM_MONGODB_URI`：用于连接MongoDB节点的[MongoDB连接URI](https://docs.mongodb.com/manual/reference/connection-string/)
- `tag`：指定所需版本和架构的标签，可查看[完整标签列表](https://hub.docker.com/repository/registry-1.docker.io/percona/percona-backup-mongodb/tags/)

> 注意：每个MongoDB节点（包括副本集从节点和配置服务器副本集节点）都需要单独的Percona Backup for MongoDB实例。例如，一个典型的3节点MongoDB副本集需要3个Percona Backup for MongoDB实例。

### 设置Percona Backup for MongoDB
Percona Backup for MongoDB需要远程存储来存储备份数据，按以下步骤配置：

1. 启动Bash会话：
   ```bash
   docker exec -it container-name bash
   ```

2. 创建配置文件：
   ```bash
   touch /tmp/pbm_config.yaml
   ```

3. 在配置文件中指定远程存储参数（以S3为例）：
   ```yaml
   storage:
     type: s3
     s3:
       region: <您的区域>
       bucket: <您的存储桶>
       credentials:
         access-key-id: <您的访问密钥ID>
         secret-access-key: <您的密钥>
   ```

4. 上传配置文件：
   ```bash
   pbm config --file /tmp/pbm_config.yaml
   ```

### 运行Percona Backup for MongoDB命令
Percona Backup for MongoDB提供`pbm`命令行工具，用于控制备份操作（创建、恢复、取消备份等）。

例如，启动备份：
```bash
docker exec container-name pbm backup
```

其中`container-name`是您分配给容器的名称，`pbm backup`是启动备份的命令。其他可用命令可参考[Percona Backup for MongoDB命令参考](https://docs.percona.com/percona-backup-mongodb/reference/pbm-commands.html)。

## 用户反馈
我们欢迎您的反馈！

更多信息及相关下载，请访问[Percona官方网站](http://www.percona.com)。  
[查看产品文档](https://docs.percona.com/percona-backup-mongodb/index.html)

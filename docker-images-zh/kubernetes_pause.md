<!-- xuanyuan-docker-images-zh
image: kubernetes/pause
source: https://xuanyuan.cloud/zh/r/kubernetes/pause
canonical: https://xuanyuan.cloud/zh/r/kubernetes/pause
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [kubernetes/pause — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kubernetes/pause "kubernetes/pause Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/kubernetes/pause

# k8s-pause-restore 镜像文档

## 1. 镜像概述和主要用途

### 概述
k8s-pause-restore 是一款用于从 Kubernetes pause 容器备份中恢复其核心状态的 Docker 镜像。该镜像专注于还原 pause 容器的关键运行环境（如网络命名空间、PID 命名空间等），确保 Kubernetes Pod 的基础运行环境一致性。

### 主要用途
- 从备份文件中恢复 pause 容器的网络、PID 等命名空间配置
- 还原 Pod 基础运行环境的原始状态
- 支持 Kubernetes 集群中 pause 容器的故障恢复与状态回溯

## 2. 核心功能和特性

- **命名空间恢复**：精准还原 pause 容器的网络命名空间（Network Namespace）、PID 命名空间（PID Namespace）等核心隔离环境
- **版本兼容**：适配 Kubernetes 官方 pause 容器镜像（`k8s.gcr.io/pause`）各主流版本（3.0+）
- **轻量级设计**：基于 Alpine 基础镜像构建，镜像体积小于 10MB，资源占用极低
- **操作简化**：通过环境变量配置恢复参数，无需复杂配置文件
- **运行时适配**：支持 Docker、containerd 等主流容器运行时
- **状态校验**：内置恢复后状态校验机制，确保命名空间配置与备份一致

## 3. 使用场景和适用范围

### 适用场景
- **故障恢复**：pause 容器意外删除或损坏后的环境恢复
- **集群迁移**：跨集群迁移时保留 Pod 原始网络命名空间配置
- **版本回滚**：pause 容器版本升级失败后的快速回滚
- **灾备演练**：Kubernetes 集群灾备流程中的 pause 容器状态恢复验证

### 适用范围
- Kubernetes 集群管理员及运维人员
- 基于容器运行时（Docker/containerd）的 Kubernetes 集群（v1.18+）
- 需要维护 Pod 网络隔离状态的生产环境
- 对集群稳定性要求高的金融、电商等核心业务系统

## 4. 详细使用方法和配置说明

### 4.1 镜像获取
```bash
docker pull [镜像仓库地址]/k8s-pause-restore:v1.0.0  # 替换为实际镜像仓库地址
```

### 4.2 前置条件
- 已准备 pause 容器备份文件（推荐格式：tar 归档文件，包含命名空间元数据）
- 目标 Kubernetes 节点需运行容器运行时（Docker/containerd）
- 操作用户需具备节点 root 权限（用于操作命名空间和容器运行时）

### 4.3 恢复操作流程

#### 步骤 1：准备备份文件
将 pause 容器备份文件（如 `pause-backup-20240101.tar`）存放至节点本地路径（如 `/var/backups/k8s-pause/`）

#### 步骤 2：执行恢复命令
```bash
docker run -it --rm \
  --privileged \
  -v /var/backups/k8s-pause:/backup \  # 挂载本地备份目录
  -v /var/run/docker.sock:/var/run/docker.sock \  # Docker 运行时需挂载（containerd 见 4.4.2）
  -e BACKUP_FILE="/backup/pause-backup-20240101.tar" \  # 容器内备份文件路径
  -e TARGET_POD_UID="12345678-1234-5678-1234-567812345678" \  # 目标 Pod 的 UID
  -e NAMESPACE="default" \  # 目标 Pod 所在命名空间
  [镜像仓库地址]/k8s-pause-restore:v1.0.0
```

#### 步骤 3：验证恢复结果
```bash
# 查看恢复后的 pause 容器状态
crictl ps --name pause | grep [TARGET_POD_UID]

# 验证网络命名空间配置
nsenter -t $(pgrep pause) -n ip addr  # 对比备份前网络配置
```

### 4.4 配置参数说明

#### 4.4.1 环境变量参数

| 参数名               | 描述                          | 类型   | 是否必填 | 默认值         |
|----------------------|-------------------------------|--------|----------|----------------|
| `BACKUP_FILE`        | 备份文件在容器内的绝对路径    | 字符串 | 是       | -              |
| `TARGET_POD_UID`     | 目标 Pod 的 UID               | 字符串 | 是       | -              |
| `NAMESPACE`          | 目标 Pod 所在命名空间         | 字符串 | 是       | -              |
| `RUNTIME_TYPE`       | 容器运行时类型                | 字符串 | 否       | "docker"       |
| `LOG_LEVEL`          | 日志级别（debug/info/warn/error） | 字符串 | 否       | "info"         |
| `RESTORE_TIMEOUT`    | 恢复操作超时时间（秒）        | 整数   | 否       | 300            |
| `VALIDATE_ENABLED`   | 是否启用恢复后状态校验        | 布尔   | 否       | "true"         |

#### 4.4.2 容器运行时适配配置
- **Docker 运行时**：需挂载 `/var/run/docker.sock`
- **Containerd 运行时**：需挂载 containerd socket（通常为 `/run/containerd/containerd.sock`）并设置 `RUNTIME_TYPE=containerd`

## 5. Docker 部署方案示例

### 5.1 docker run 命令示例

#### Docker 运行时恢复
```bash
docker run -it --rm \
  --privileged \
  -v /var/backups/k8s-pause:/backup \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e BACKUP_FILE="/backup/pause-backup-20240101.tar" \
  -e TARGET_POD_UID="12345678-1234-5678-1234-567812345678" \
  -e NAMESPACE="default" \
  -e LOG_LEVEL="debug" \
  [镜像仓库地址]/k8s-pause-restore:v1.0.0
```

#### Containerd 运行时恢复
```bash
docker run -it --rm \
  --privileged \
  -v /var/backups/k8s-pause:/backup \
  -v /run/containerd/containerd.sock:/run/containerd/containerd.sock \
  -e BACKUP_FILE="/backup/pause-backup-20240101.tar" \
  -e TARGET_POD_UID="12345678-1234-5678-1234-567812345678" \
  -e NAMESPACE="default" \
  -e RUNTIME_TYPE="containerd" \
  [镜像仓库地址]/k8s-pause-restore:v1.0.0
```

### 5.2 docker-compose 配置示例
```yaml
version: '3.8'
services:
  pause-restore:
    image: [镜像仓库地址]/k8s-pause-restore:v1.0.0
    privileged: true
    volumes:
      - /var/backups/k8s-pause:/backup:ro
      - /var/run/docker.sock:/var/run/docker.sock  # Docker 运行时
      # - /run/containerd/containerd.sock:/run/containerd/containerd.sock  # Containerd 运行时
    environment:
      - BACKUP_FILE=/backup/pause-backup-20240101.tar
      - TARGET_POD_UID=12345678-1234-5678-1234-567812345678
      - NAMESPACE=default
      - LOG_LEVEL=info
      - RESTORE_TIMEOUT=300
      # - RUNTIME_TYPE=containerd  # Containerd 运行时需启用
    restart: "no"  # 一次性任务，完成后自动退出
```

## 6. 注意事项

- **权限要求**：必须以 `--privileged` 特权模式运行，否则无法操作主机命名空间
- **备份兼容性**：确保备份文件与当前 pause 容器版本匹配（通过 `BACKUP_FILE` 中记录的版本信息校验）
- **数据一致性**：恢复前需停止目标 Pod（建议使用 `kubectl scale` 临时缩容至 0）
- **网络影响**：恢复过程会导致目标 Pod 网络中断约 10-30 秒，建议在维护窗口执行
- **备份校验**：使用前通过 `tar -tf [BACKUP_FILE]` 验证备份文件完整性
- **集群版本**：Kubernetes 集群版本需 ≥1.18，低版本集群可能存在命名空间兼容性问题

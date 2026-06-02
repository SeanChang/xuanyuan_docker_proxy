---
image: bitnamicharts/cadvisor
description: "Bitnami高级cAdvisor镜像，用于收集和聚合容器资源使用及性能数据，提供预配置、易于部署的容器监控功能。"
source: https://xuanyuan.cloud/zh/r/bitnamicharts/cadvisor
canonical: https://xuanyuan.cloud/zh/r/bitnamicharts/cadvisor
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamicharts/cadvisor" title="bitnamicharts/cadvisor Docker 镜像中文简介、标签列表与拉取命令">bitnamicharts/cadvisor — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnamicharts/cadvisor" title="bitnamicharts/cadvisor Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnamicharts/cadvisor</a>

# Bitnami cAdvisor 镜像文档


## 镜像概述和主要用途

cAdvisor（Container Advisor）是由Google开发的开源容器监控工具，用于收集和分析容器的资源使用情况与性能指标，如CPU、内存、网络吞吐量和磁盘I/O等。Bitnami提供的cAdvisor镜像封装了官方cAdvisor，优化了部署流程，适用于容器化环境（尤其是Kubernetes集群）中的容器监控场景。


## 核心功能和特性

- **全面的容器指标监控**：实时收集容器的CPU使用率、内存消耗、网络I/O、磁盘读写等核心资源指标。
- **多容器运行时支持**：兼容Docker、containerd等主流容器运行时，自动发现并监控主机上的所有容器。
- **Prometheus原生集成**：内置Prometheus指标暴露端点，支持直接对接Prometheus进行指标采集和可视化。
- **灵活的主机路径挂载**：可配置挂载主机的根目录（`/`）、Docker数据目录（`/var/lib/docker`）等关键路径，确保监控数据的完整性。
- **可扩展的配置选项**：支持通过命令行参数（`extraArgs`）自定义cAdvisor运行行为，如日志配置、指标采集频率等。
- **轻量级设计**：镜像体积小，资源占用低，适合在生产和开发环境中部署。


## 使用场景和适用范围

- **Kubernetes集群容器监控**：作为DaemonSet部署在Kubernetes节点上，监控集群内所有容器的资源使用情况。
- **开发/测试环境监控**：在本地Docker环境或小型容器集群中，快速部署以监控应用容器的性能表现。
- **监控系统集成**：与Prometheus、Grafana等工具结合，构建容器性能监控面板，支持告警和趋势分析。
- **容器资源审计**：记录容器生命周期内的资源使用历史，用于性能优化和容量规划。


## 详细的使用方法和配置说明

### 前提条件

- **Docker部署**：Docker Engine 19.03+。
- **Kubernetes部署**：Kubernetes集群 1.23+，Helm 3.8.0+（用于Helm Chart部署）。


### Docker部署

#### 基本运行命令

通过Docker直接运行cAdvisor容器，挂载必要的主机路径以获取容器和主机信息：

```bash
docker run -d \
  --name cadvisor \
  --privileged \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk:/dev/disk:ro \
  --publish=8080:8080 \
  bitnami/cadvisor:latest
```

**参数说明**：
- `--privileged`：赋予容器访问主机设备的权限（部分监控功能依赖）。
- `--volume`：挂载主机路径，`ro`表示只读模式，避免影响主机文件系统。
- `--publish=8080:8080`：暴露cAdvisor的Web UI和API端口（默认8080）。

#### 访问Web UI

部署后，通过 `http://<主机IP>:8080` 访问cAdvisor的Web界面，查看容器指标和主机信息。


### Kubernetes部署（Helm Chart）

#### 安装Helm Chart

1. **添加Bitnami Helm仓库**（若未添加）：
   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   helm repo update
   ```

2. **部署cAdvisor**：
   ```bash
   helm install my-cadvisor oci://registry-1.docker.io/bitnamicharts/cadvisor
   ```

   自定义部署参数可通过 `--set` 或 `values.yaml` 文件指定，例如修改暴露端口：
   ```bash
   helm install my-cadvisor oci://registry-1.docker.io/bitnamicharts/cadvisor \
     --set service.port=9090
   ```


### 关键配置说明

#### 1. 命令行参数（`extraArgs`）

通过 `extraArgs` 添加cAdvisor运行时参数，例如启用使用日志记录：

```yaml
# values.yaml示例
extraArgs:
  - -log_cadvisor_usage=true  # 记录cAdvisor自身使用情况
  - -housekeeping_interval=30s  # 指标采集间隔（默认10s）
```

更多参数参考[cAdvisor官方文档](https://github.com/google/cadvisor/blob/master/docs/runtime_options.md)。


#### 2. 主机路径挂载配置

Bitnami镜像默认挂载以下主机路径，可通过 `defaultMounts` 配置启用/禁用：

| 参数                      | 描述                     | 默认值 |
|---------------------------|--------------------------|--------|
| `defaultMounts.rootfs`    | 挂载主机根目录（`/`）    | `true` |
| `defaultMounts.varRun`    | 挂载主机 `/var/run`      | `true` |
| `defaultMounts.sys`       | 挂载主机 `/sys`          | `true` |
| `defaultMounts.varLibDocker` | 挂载Docker数据目录 | `true` |
| `defaultMounts.devDisk`   | 挂载主机 `/dev/disk`     | `true` |

**示例**：禁用Docker目录挂载（适用于非Docker运行时）：
```yaml
defaultMounts:
  varLibDocker: false
```

如需挂载额外路径，通过 `extraVolumes` 和 `extraVolumeMounts` 配置：
```yaml
extraVolumes:
  - name: custom-mount
    hostPath:
      path: /host/custom
      type: Directory
extraVolumeMounts:
  - name: custom-mount
    mountPath: /custom
    readOnly: true
```


#### 3. Prometheus集成

启用Prometheus指标采集：

```yaml
# values.yaml示例
metrics:
  enabled: true  # 暴露Prometheus指标端点
  serviceMonitor:
    enabled: true  # 创建ServiceMonitor资源（需Prometheus Operator）
    namespace: monitoring  # Prometheus所在命名空间
```

指标端点默认暴露在 `http://<pod-ip>:8080/metrics`，Prometheus可通过Service自动发现并采集。


#### 4. Ingress配置

通过Ingress暴露cAdvisor Web UI（需集群内已部署Ingress控制器）：

```yaml
# values.yaml示例
ingress:
  enabled: true
  hostname: cadvisor.example.com  # 自定义域名
  tls: true  # 启用TLS
  certManager: true  # 若使用cert-manager自动签发证书
  annotations:
    kubernetes.io/ingress.class: nginx  # 指定Ingress控制器
    cert-manager.io/cluster-issuer: letsencrypt-prod  # cert-manager签发者
```


## 配置参数说明

### 全局参数

| 参数                                  | 描述                                                                 | 默认值   |
|---------------------------------------|----------------------------------------------------------------------|----------|
| `global.imageRegistry`                | 全局Docker镜像仓库地址                                               | `""`     |
| `global.imagePullSecrets`             | 镜像拉取密钥（数组形式）                                             | `[]`     |
| `global.security.allowInsecureImages` | 是否允许拉取未验证的镜像                                             | `false`  |


### 通用参数

| 参数                          | 描述                                                                 | 默认值          |
|-------------------------------|----------------------------------------------------------------------|-----------------|
| `nameOverride`                | 覆盖资源名称前缀                                                     | `""`            |
| `fullnameOverride`            | 完全覆盖资源全名                                                     | `""`            |
| `commonAnnotations`           | 附加到所有资源的通用注解（字典形式）                                 | `{}`            |
| `diagnosticMode.enabled`      | 启用诊断模式（禁用探针，覆盖容器命令）                               | `false`         |


### cAdvisor核心参数

| 参数                                  | 描述                                                                 | 默认值                      |
|---------------------------------------|----------------------------------------------------------------------|-----------------------------|
| `image.registry`                      | cAdvisor镜像仓库                                                     | `registry-1.docker.io`      |
| `image.repository`                    | cAdvisor镜像名称                                                     | `bitnamicharts/cadvisor`    |
| `image.pullPolicy`                    | 镜像拉取策略                                                         | `IfNotPresent`              |
| `extraArgs`                           | 附加到cAdvisor命令的参数（数组形式，如 `["-log_cadvisor_usage=true"]`） | `[]`                        |
| `defaultMounts.rootfs`                | 是否挂载主机根目录（`/`）                                            | `true`                      |
| `defaultMounts.varLibDocker`          | 是否挂载Docker数据目录（`/var/lib/docker`）                          | `true`                      |
| `metrics.enabled`                     | 是否启用Prometheus指标暴露                                           | `false`                     |
| `ingress.enabled`                     | 是否启用Ingress资源                                                 | `false`                     |


## 重要注意事项：Bitnami镜像变更通知

自2025年8月28日起，Bitnami将调整公共镜像仓库策略，推进[Bitnami Secure Images计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications)：

- **非强化镜像逐步淘汰**：免费 tier 将停止支持基于Debian的非强化镜像，仅保留“latest”标签的强化镜像（用于开发环境）。
- **旧镜像迁移**：现有镜像（含历史版本标签，如 `2.50.0`）将迁移至 `docker.io/bitnamilegacy` 仓库，不再接收更新。
- **生产环境建议**：生产环境需使用Bitnami Secure Images，包含强化容器、CVE透明度（VEX/KEV）、SBOM和企业支持。

详情参见[Bitnami Secure Images公告](https://github.com/bitnami/containers/issues/83267)。

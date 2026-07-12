---
image: fluent/fluentd-kubernetes-daemonset
description: "在Kubernetes集群中部署的Fluentd守护进程集，用于收集和处理节点日志。"
source: https://xuanyuan.cloud/zh/r/fluent/fluentd-kubernetes-daemonset
canonical: https://xuanyuan.cloud/zh/r/fluent/fluentd-kubernetes-daemonset
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fluent/fluentd-kubernetes-daemonset" title="fluent/fluentd-kubernetes-daemonset Docker 镜像中文简介、标签列表与拉取命令">fluent/fluentd-kubernetes-daemonset 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Fluentd Kubernetes DaemonSet 镜像文档

## 镜像概述和主要用途

Fluentd Kubernetes DaemonSet 镜像是专为在Kubernetes集群中以DaemonSet方式部署Fluentd而设计的Docker镜像。Fluentd是一个开源的数据收集器，能够统一日志收集和处理流程，为Kubernetes集群提供集中式日志管理解决方案。

该镜像旨在简化Fluentd在Kubernetes环境中的部署和配置，支持多种日志输出目的地，并针对容器化环境进行了优化。

## 核心功能和特性

- **多架构支持**：提供x86_64和arm64架构的镜像
- **多种输出目的地**：支持Elasticsearch、Kafka、S3、Azure Blob、CloudWatch等多种日志存储和分析平台
- **Kubernetes原生集成**：自动收集容器日志并附加Kubernetes元数据
- **灵活配置**：通过环境变量和ConfigMap支持自定义配置
- **系统日志收集**：支持收集系统日志和容器日志
- **监控支持**：内置Prometheus指标导出功能
- **多格式解析**：支持JSON、CRI（containerd/cri-o）等多种日志格式解析

## 使用场景和适用范围

- **Kubernetes集群日志收集**：在Kubernetes集群中部署为DaemonSet，收集所有节点上的容器日志
- **集中式日志管理**：将分散在多个容器和节点的日志集中发送到指定存储或分析平台
- **日志转发**：将日志转发到Elasticsearch、Kafka、S3等后端系统
- **日志处理与转换**：对原始日志进行解析、过滤和转换
- **混合云环境日志统一**：在混合云或多云Kubernetes环境中实现统一日志收集

## 支持的标签和架构

### Debian 版本

#### 当前稳定版

> 自v1.17.0起，容器镜像构建流程已从hub.docker.com的自动构建迁移到GitHub Actions。这是因为hub.docker.com对自动构建数量有限制，而GitHub Actions则没有构建流水线数量的限制。

> 注意：v1.16.5或更早版本的DaemonSet镜像存在一些限制：
> * `papertrail`、`syslog`镜像（x86_64/arm64）不再发布
> * `logentries`、`loggly`、`logzio`、`s3`的arm64镜像不再发布（仅支持x86_64）
> 如果需要使用上述未发布的镜像，请自行构建。Dockerfile仍在本仓库中维护。

##### 多架构镜像

- `Azureblob`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-azureblob-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-azureblob-1`
- `Elasticsearch8`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-elasticsearch8-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-elasticsearch8-1`
- `Elasticsearch7`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-elasticsearch7-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-elasticsearch7-1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1-debian-elasticsearch`
- `Opensearch`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-opensearch-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-opensearch-1`
- `Loggly`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-loggly-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-loggly-1`
- `Logentries`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-logentries-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-logentries-1`
- `Cloudwatch`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-cloudwatch-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-cloudwatch-1`
- `S3`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-s3-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-s3-1`
- `Syslog`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-syslog-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-syslog-1`
- `Forward`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-forward-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-forward-1`
- `Gcs`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-gcs-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-gcs-1`
- `Graylog`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-graylog-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-graylog-1`
- `Papertrail`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-papertrail-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-papertrail-1`
- `Logzio`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-logzio-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-logzio-1`
- `Kafka`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-kafka-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-kafka-1`
- `Kafka2`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-kafka2-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-kafka2-1`
- `Kinesis`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-kinesis-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-kinesis-1`
- `Datadog`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-datadog-1.1`
  - `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-datadog-1`

##### x86_64 架构镜像

各输出目的地的x86_64镜像标签格式为：`v{版本}-debian-{目的地}-amd64-{修订号}`，例如：
- `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-elasticsearch8-amd64-1.1`

##### arm64 架构镜像

各输出目的地的arm64镜像标签格式为：`v{版本}-debian-{目的地}-arm64-{修订号}`，例如：
- `docker pull docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19.0-debian-elasticsearch8-arm64-1.1`

## 详细使用方法和配置说明

### 基础配置

#### 使用环境变量配置

该镜像支持通过环境变量进行基本配置：

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| `FLUENT_UID` | 运行Fluentd的用户ID | `1000` |
| `FLUENT_CONTAINER_TAIL_PATH` | 容器日志文件路径 | `/var/log/containers/*.log` |
| `FLUENT_CONTAINER_TAIL_EXCLUDE_PATH` | 排除的日志文件路径 | 无 |
| `FLUENTD_SYSTEMD_CONF` | 是否启用systemd日志收集 | `enable` |
| `FLUENTD_PROMETHEUS_CONF` | 是否启用Prometheus指标 | `enable` |
| `FLUENT_POS_EXTRA_DIR` | 额外的pos文件目录 | 无 |
| `LD_PRELOAD` | 预加载的库 | 无 |

#### 权限设置

在Kubernetes默认配置下，Fluentd需要root权限才能读取`/var/log`目录下的日志并写入pos文件。可以通过设置环境变量`FLUENT_UID=0`来以root用户运行：

```yaml
env:
  - name: FLUENT_UID
    value: "0"
```

### 高级配置

#### 使用自定义配置

虽然镜像提供了默认配置，但用户可以通过Kubernetes ConfigMap来自定义配置。每个镜像包含以下配置文件：

- `fluent.conf`: 目的地设置（Elasticsearch、Kafka等）
- `kubernetes.conf`: Kubernetes特定设置，包括日志文件tail输入和元数据过滤
- `tail_container_parse.conf`: 容器日志解析器配置
- `prometheus.conf`: Prometheus监控插件配置
- `systemd.conf`: systemd日志收集配置

可以通过ConfigMap覆盖这些配置文件，例如：

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
  namespace: kube-system
data:
  fluent.conf: |
    # 自定义输出配置
    <match **>
      @type elasticsearch
      host elasticsearch-master
      port 9200
      logstash_format true
      logstash_prefix fluentd
      include_tag_key true
      tag_key @log_name
      flush_interval 5s
    </match>
  tail_container_parse.conf: |
    <parse>
      @type cri
    </parse>
```

然后在DaemonSet中挂载此ConfigMap：

```yaml
volumeMounts:
  - name: config-volume
    mountPath: /fluentd/etc/fluent.conf
    subPath: fluent.conf
  - name: config-volume
    mountPath: /fluentd/etc/tail_container_parse.conf
    subPath: tail_container_parse.conf
volumes:
  - name: config-volume
    configMap:
      name: fluentd-config
```

#### 使用CRI解析器处理containerd/cri-o日志

默认情况下，镜像使用`json`解析器处理Docker格式的日志。对于使用containerd或cri-o的集群，需要使用`cri`解析器：

```yaml
env:
  - name: FLUENT_CONTAINER_TAIL_PARSER_TYPE
    value: "cri"
```

或者通过ConfigMap覆盖`tail_container_parse.conf`：

```
<parse>
  @type cri
</parse>
```

#### 排除特定容器日志

可以通过`FLUENT_CONTAINER_TAIL_EXCLUDE_PATH`环境变量排除特定日志：

```yaml
env:
  - name: FLUENT_CONTAINER_TAIL_EXCLUDE_PATH
    value: '["/var/log/containers/fluentd-*", "/var/log/containers/kube-*"]'
```

#### 启用jemalloc内存分配器

自v1.17.0-1.3/v1.16.5-1.3版本起，jemalloc内存分配器默认禁用。如果不使用systemd插件，可以通过以下方式启用：

```yaml
env:
  - name: LD_PRELOAD
    value: "/usr/lib/libjemalloc.so.2"
```

#### 禁用systemd输入

如果不需要收集systemd日志，可以通过环境变量禁用：

```yaml
env:
  - name: FLUENTD_SYSTEMD_CONF
    value: "disable"
```

#### 禁用Prometheus监控

如果不需要Prometheus监控，可以通过环境变量禁用：

```yaml
env:
  - name: FLUENTD_PROMETHEUS_CONF
    value: "disable"
```

## Kubernetes部署示例

### DaemonSet部署示例（Elasticsearch输出）

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: docker.xuanyuan.run/fluent/fluentd-kubernetes-daemonset:v1.19-debian-elasticsearch7-1
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        env:
        - name: FLUENT_UID
          value: "0"
        - name: FLUENT_ELASTICSEARCH_HOST
          value: "elasticsearch-master"
        - name: FLUENT_ELASTICSEARCH_PORT
          value: "9200"
        - name: FLUENT_ELASTICSEARCH_SCHEME
          value: "http"
        - name: FLUENTD_SYSTEMD_CONF
          value: "disable"
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
```

### 部署RBAC权限

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: fluentd-elasticsearch
rules:
- apiGroups: [""]
  resources:
  - namespaces
  - pods
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: fluentd-elasticsearch
subjects:
- kind: ServiceAccount
  name: fluentd-elasticsearch
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: fluentd-elasticsearch
  apiGroup: rbac.authorization.k8s.io
```

### 在OpenShift上部署

```bash
oc project kube-system
oc create -f https://raw.githubusercontent.com/fluent/fluentd-kubernetes-daemonset/master/fluentd-daemonset-elasticsearch-rbac.yaml
oc adm policy add-scc-to-user privileged -z fluentd
oc patch ds fluentd -p "spec:
  template:
    spec:
      containers:
      - name: fluentd
        securityContext:
          privileged: true"
oc delete pod -l k8s-app=fluentd-logging
```

## 注意事项

### 多Fluentd实例部署

当在同一集群中部署多个Fluentd实例（例如需要将日志发送到多个目的地），需要设置`FLUENT_POS_EXTRA_DIR`环境变量来指定额外的pos文件目录，避免pos文件冲突：

```yaml
env:
  - name: FLUENT_POS_EXTRA_DIR
    value: "/var/log/fluentd-pos-extra"
```

### Kafka镜像不支持Zookeeper参数

由于Debian 10上的Zookeeper gem存在兼容性问题，Kafka镜像不包含Zookeeper gem。

### Windows Kubernetes支持

本仓库不提供Windows Kubernetes DaemonSet支持，但有社区用户提供了相关实现：

- https://github.com/bgsilvait/k8s-fluentd-windows
- https://github.com/k1nger/fluentd-windows-daemon

### Kafka镜像建议

推荐使用`debian-kafka2`或`debian-kafka2-arm64`镜像，这些镜像使用`out_kafka2`插件，而`debian-kafka`或`debian-kafka-arm64`使用已弃用的`out_kafka_buffered`插件。

## 维护者信息

部分镜像由社区贡献者维护，如遇特定镜像问题，请联系相应维护者：

- azureblob: @elsesiy
- papertrail

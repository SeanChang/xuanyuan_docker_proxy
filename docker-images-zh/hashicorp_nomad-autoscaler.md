---
image: hashicorp/nomad-autoscaler
description: "Nomad Autoscaler为Nomad工作负载提供自动扩缩容能力。"
source: https://xuanyuan.cloud/zh/r/hashicorp/nomad-autoscaler
canonical: https://xuanyuan.cloud/zh/r/hashicorp/nomad-autoscaler
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/nomad-autoscaler" title="hashicorp/nomad-autoscaler Docker 镜像中文简介、标签列表与拉取命令">hashicorp/nomad-autoscaler 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nomad Autoscaler

## 镜像概述和主要用途
Nomad Autoscaler是面向Nomad的自动扩缩容守护进程，旨在为Nomad工作负载提供自动扩缩容能力。其基于插件架构设计，支持灵活扩展指标源、扩缩容目标及扩缩容算法，可根据配置的策略动态调整工作负载数量。

> **注意**：该项目处于早期开发阶段，不提供任何保证，且可能会无预警地变更。更多信息请参见官方文档：https://github.com/hashicorp/nomad-autoscaler。

## 核心功能和特性
- **插件化架构**：围绕插件设计，支持扩展指标源（APM）、扩缩容目标和扩缩容算法。
- **多指标源集成**：内置支持Nomad自身指标（nomad-apm）和Prometheus等外部监控系统指标。
- **灵活部署模式**：可作为Nomad任务部署在集群内部，或作为独立服务部署在集群外部。
- **动态配置管理**：支持通过Nomad任务模板（template）渲染配置文件，集成Vault（密钥管理）和Consul（动态值注入）。

## 使用场景和适用范围
- **Nomad工作负载自动扩缩容**：适用于需根据实时指标（如CPU利用率、请求量）动态调整任务或节点数量的场景。
- **混合指标决策**：支持同时使用Nomad内置指标和外部监控（如Prometheus）指标进行扩缩容决策。
- **集群内/外部部署**：可部署在被监控集群内部（利用集群资源）或外部（独立运行，避免集群资源竞争）。

## 详细使用方法和配置说明

### 1. 作为Nomad任务部署（Docker驱动）
通过Nomad的Docker驱动将Autoscaler部署为集群内任务，利用Nomad的调度和资源管理能力。

#### 示例Job配置（HCL格式）
```hcl
job "autoscaler" {
  datacenters = ["dc1"]  # 目标数据中心

  group "autoscaler" {
    count = 1  # 部署实例数量

    task "autoscaler" {
      driver = "docker"  # 使用Docker驱动

      config {
        image   = "hashicorp/nomad-autoscaler:0.3.5"  # 镜像及版本
        command = "nomad-autoscaler"                  # 启动命令
        args    = ["agent", "-config", "${NOMAD_TASK_DIR}/config.hcl"]  # 启动参数：agent模式，指定配置文件路径
      }

      template {
        data = <<EOF
plugin_dir = "/plugins"  # 插件存放目录

nomad {
  address = "http://{{env "attr.unique.network.ip-address" }}:4646"  # Nomad API地址（通过环境变量获取任务IP）
}

# Nomad指标源配置
apm "nomad" {
  driver = "nomad-apm"  # 驱动名称
  config  = {
    address = "http://{{env "attr.unique.network.ip-address" }}:4646"  # Nomad API地址
  }
}

# Prometheus指标源配置
apm "prometheus" {
  driver = "prometheus"  # 驱动名称
  config = {
    address = "http://{{env "attr.unique.network.ip-address" }}:9090"  # Prometheus服务地址
  }
}
EOF

        destination = "${NOMAD_TASK_DIR}/config.hcl"  # 渲染后的配置文件路径
      }
    }
  }
}
```

#### 配置参数说明
- **镜像配置**：`image`指定为`hashicorp/nomad-autoscaler:0.3.5`，需使用具体版本标签。
- **启动参数**：`agent`表示以守护进程模式运行；`-config`指定配置文件路径。
- **模板配置（template.data）**：
  - `plugin_dir`：插件存放目录，用于加载扩展插件。
  - `nomad.address`：Nomad API地址，通过`{{env "attr.unique.network.ip-address"}}`动态获取任务所在节点IP。
  - `apm`块：定义指标源，支持多指标源配置（如`nomad`和`prometheus`），每个块需指定`driver`（驱动名称）和`config`（驱动配置，如服务地址）。

### 2. 作为独立Docker容器运行
在Nomad集群外部部署时，可通过`docker run`直接启动独立容器。

#### 示例命令
```bash
docker run \
  --volume /usr/bin/nomad-autoscaler/plugins:/plugins \  # 挂载插件目录（宿主机:容器）
  --volume /opt/nomad-autoscaler/config:/config \        # 挂载配置目录（宿主机:容器）
  hashicorp/nomad-autoscaler:0.3.5 \                     # 镜像及版本
  nomad-autoscaler agent -config /config                # 启动命令：agent模式，从/config目录加载配置
```

#### 参数说明
- `--volume`：挂载宿主机目录到容器，`/plugins`存放扩展插件，`/config`存放配置文件。
- 命令参数：`agent -config /config`表示以守护进程模式运行，并从`/config`目录加载配置文件。

### 3. 构建自定义Docker镜像
如需集成自定义插件或配置，可基于官方镜像构建自定义镜像，预打包插件和配置。

#### 示例Dockerfile
```dockerfile
FROM docker.xuanyuan.run/hashicorp/nomad-autoscaler:v0.3.5  # 基于官方0.3.5版本镜像

# 添加自定义插件（从CI地址下载）
ADD http://my-ci/build-num/my-plugin /plugin-dir/my-plugin

# 添加自定义插件配置（合并到配置目录）
ADD http://my-ci/build-num/my-plugin-conf.hcl /config-dir/my-plugin.hcl

# （可选）设置插件执行权限
RUN chmod +x /plugin-dir/my-plugin
```

#### 说明
- 通过`ADD`命令从外部源（如CI构建地址）下载自定义插件和配置，分别存放于`/plugin-dir`（插件目录）和`/config-dir`（配置目录）。
- 自定义镜像构建后可直接部署，无需运行时挂载外部文件。

## 核心配置参数详解

### 基础配置项
| 配置项         | 说明                          | 示例值                  |
|----------------|-------------------------------|-------------------------|
| `plugin_dir`   | 插件存放目录                  | `/plugins`              |
| `nomad.address`| Nomad API地址（集群连接点）   | `http://10.0.0.1:4646`  |

### 指标源（APM）配置
APM配置块格式：`apm "<名称>" { ... }`，`<名称>`为自定义指标源标识。

#### Nomad内置指标源（nomad-apm）
```hcl
apm "nomad" {
  driver = "nomad-apm"  # 驱动名称（固定值）
  config = {
    address = "http://10.0.0.1:4646"  # Nomad API地址
  }
}
```

#### Prometheus指标源
```hcl
apm "prometheus" {
  driver = "prometheus"  # 驱动名称（固定值）
  config = {
    address = "http://10.0.0.2:9090"  # Prometheus服务地址
  }
}
```

### 环境变量说明
在Nomad任务模板中，可使用以下Nomad环境变量动态注入配置：
- `{{env "attr.unique.network.ip-address"}}`：任务所在节点的IP地址，用于配置Nomad API或Prometheus地址。

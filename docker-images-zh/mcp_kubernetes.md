---
image: mcp/kubernetes
description: "用于连接到Kubernetes集群并进行管理的Docker镜像"
source: https://xuanyuan.cloud/zh/r/mcp/kubernetes
canonical: https://xuanyuan.cloud/zh/r/mcp/kubernetes
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/kubernetes" title="mcp/kubernetes Docker 镜像中文简介、标签列表与拉取命令">mcp/kubernetes 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kubernetes MCP服务器

连接到Kubernetes集群并对其进行管理。

[什么是MCP服务器？](https://www.anthropic.com/news/model-context-protocol)


## 镜像概述和主要用途

Kubernetes MCP服务器是一个Docker镜像，旨在提供连接和管理Kubernetes集群的能力。通过集成多种Kubernetes管理工具和命令，该镜像支持资源操作、集群监控、Helm图表管理等核心功能，适用于通过容器化方式安全高效地执行Kubernetes集群管理任务。


## 核心功能和特性

### 基本信息

| 属性                | 详情                                                                 |
|---------------------|----------------------------------------------------------------------|
| **Docker镜像**      | [mcp/kubernetes](https://hub.docker.com/repository/docker/mcp/kubernetes) |
| **作者**            | [Flux159](https://github.com/Flux159)                               |
| **代码仓库**        | https://github.com/Flux159/mcp-server-kubernetes                     |
| **Dockerfile**      | https://github.com/Flux159/mcp-server-kubernetes/blob/main/Dockerfile |
| **镜像构建方**      | Docker Inc.                                                          |
| **Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/kubernetes) |
| **验证签名**        | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/kubernetes --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证**          | MIT License                                                          |


### 可用工具（22个）

| 服务器提供的工具           | 简要描述                                                                 |
|----------------------------|--------------------------------------------------------------------------|
| `cleanup`                  | 清理所有受管理的资源                                                     |
| `exec_in_pod`              | 在Kubernetes Pod或容器中执行命令并返回输出                               |
| `explain_resource`         | 获取Kubernetes资源或字段的文档                                           |
| `install_helm_chart`       | 安装Helm图表，支持标准和基于模板的安装方式                               |
| `kubectl_apply`            | 从字符串或文件应用Kubernetes YAML清单                                   |
| `kubectl_context`          | 管理Kubernetes上下文 - 列出、获取或设置当前上下文                       |
| `kubectl_create`           | 使用多种方式（从文件或子命令）创建Kubernetes资源                         |
| `kubectl_delete`           | 通过资源类型、名称、标签或清单文件删除Kubernetes资源                     |
| `kubectl_describe`         | 通过资源类型、名称和可选命名空间描述Kubernetes资源                       |
| `kubectl_generic`          | 使用提供的参数和标志执行任何kubectl命令                                  |
| `kubectl_get`              | 通过资源类型、名称和可选命名空间获取或列出Kubernetes资源                 |
| `kubectl_logs`             | 从Pod、Deployment或Job等Kubernetes资源获取日志                           |
| `kubectl_patch`            | 使用策略合并补丁、JSON合并补丁或JSON补丁更新资源的字段                   |
| `kubectl_rollout`          | 管理资源的滚动更新（如Deployment、DaemonSet、StatefulSet）               |
| `kubectl_scale`            | 扩展Kubernetes Deployment                                                |
| `list_api_resources`       | 列出集群中可用的API资源                                                  |
| `node_management`          | 通过cordon、drain和uncordon操作管理Kubernetes节点                        |
| `ping`                     | 验证对方是否仍响应且连接处于活动状态                                     |
| `port_forward`             | 将本地端口转发到Kubernetes资源上的端口                                   |
| `stop_port_forward`        | 停止端口转发进程                                                         |
| `uninstall_helm_chart`     | 卸载Helm图表发布                                                        |
| `upgrade_helm_chart`       | 升级现有Helm图表发布                                                    |


## 使用场景和适用范围

### 适用场景
- Kubernetes集群日常管理（资源创建、删除、更新、查询）
- 容器化应用部署与维护（通过kubectl和Helm操作）
- 集群故障排查（日志获取、资源描述、节点状态管理）
- 多环境集群切换与上下文管理
- 自动化运维任务（如资源清理、滚动更新）

### 适用人员
- 开发人员：在本地或CI/CD环境中管理Kubernetes资源
- 运维工程师：执行集群日常运维和节点管理操作
- DevOps工程师：构建基于容器的Kubernetes管理工作流


## 详细使用方法和配置说明

### Docker部署方案

#### 1. 基础运行命令
通过Docker直接运行MCP服务器容器：
```bash
docker run -i --rm docker.xuanyuan.run/mcp/kubernetes
```

#### 2. 挂载Kubeconfig配置（推荐）
为使容器能够访问Kubernetes集群，需挂载本地Kubeconfig文件：
```bash
docker run -i --rm \
  -v $HOME/.kube/config:/root/.kube/config \
  docker.xuanyuan.run/mcp/kubernetes
```

#### 3. Docker Compose配置
创建`docker-compose.yml`文件：
```yaml
version: '3'
services:
  kubernetes-mcp:
    image: docker.xuanyuan.run/mcp/kubernetes
    volumes:
      - $HOME/.kube/config:/root/.kube/config
    stdin_open: true
    tty: true
```
运行容器：
```bash
docker-compose up -d
```


### MCP环境配置示例
在MCP配置中集成该服务器：
```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-v",
        "$HOME/.kube/config:/root/.kube/config",
        "mcp/kubernetes"
      ]
    }
  }
}
```


## 工具详情

### 工具：**`cleanup`**
清理所有受管理的资源


### 工具：**`exec_in_pod`**
在Kubernetes Pod或容器中执行命令并返回输出

| 参数        | 类型     | 描述                                   |
|-------------|----------|----------------------------------------|
| `command`   | `string` | 要在Pod中执行的命令（字符串或参数数组） |
| `name`      | `string` | 要执行命令的Pod名称                    |
| `container` | `string` | 可选，容器名称（当Pod有多个容器时必填） |
| `context`   | `string` | 可选，Kubeconfig上下文（默认null）     |
| `namespace` | `string` | 可选，Kubernetes命名空间               |
| `shell`     | `string` | 可选，执行命令使用的Shell（如'/bin/sh'）|
| `timeout`   | `number` | 可选，命令超时时间（毫秒，默认60000）  |


### 工具：**`explain_resource`**
获取Kubernetes资源或字段的文档

| 参数        | 类型      | 描述                                   |
|-------------|-----------|----------------------------------------|
| `resource`  | `string`  | 资源名称或字段路径（如'pods'或'pods.spec.containers'） |
| `apiVersion`| `string`  | 可选，API版本（如'apps/v1'）           |
| `context`   | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `output`    | `string`  | 可选，输出格式（plaintext或plaintext-openapiv2） |
| `recursive` | `boolean` | 可选，递归打印字段的子字段             |

*此工具为只读，不会修改环境。*


### 工具：**`install_helm_chart`**
安装Helm图表，支持标准和基于模板的安装方式

| 参数              | 类型      | 描述                                   |
|-------------------|-----------|----------------------------------------|
| `chart`           | `string`  | 图表名称（如'nginx'）或图表目录路径    |
| `name`            | `string`  | Helm发布名称                           |
| `namespace`       | `string`  | Kubernetes命名空间                     |
| `context`         | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `createNamespace` | `boolean` | 可选，命名空间不存在时创建             |
| `repo`            | `string`  | 可选，Helm仓库URL（使用本地图表时可选） |
| `useTemplate`     | `boolean` | 可选，使用helm template + kubectl apply替代helm install（绕过认证问题） |
| `values`          | `object`  | 可选，覆盖图表默认值的自定义值         |
| `valuesFile`      | `string`  | 可选，值文件路径（替代values对象）     |


### 工具：**`kubectl_apply`**
从字符串或文件应用Kubernetes YAML清单

| 参数        | 类型      | 描述                                   |
|-------------|-----------|----------------------------------------|
| `context`   | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `dryRun`    | `boolean` | 可选，仅验证资源，不实际执行操作       |
| `filename`  | `string`  | 可选，要应用的YAML文件路径（二选一：manifest或filename） |
| `force`     | `boolean` | 可选，强制删除资源并绕过优雅删除       |
| `manifest`  | `string`  | 可选，要应用的YAML清单字符串           |
| `namespace` | `string`  | 可选，Kubernetes命名空间               |


### 工具：**`kubectl_context`**
管理Kubernetes上下文 - 列出、获取或设置当前上下文

| 参数         | 类型      | 描述                                   |
|--------------|-----------|----------------------------------------|
| `operation`  | `string`  | 要执行的操作：列出上下文、获取当前上下文或设置当前上下文 |
| `detailed`   | `boolean` | 可选，包含上下文的详细信息             |
| `name`       | `string`  | 可选，要设置为当前的上下文名称（设置操作必填） |
| `output`     | `string`  | 可选，输出格式                         |
| `showCurrent`| `boolean` | 可选，列出上下文时高亮当前活动上下文   |

*此工具为只读，不会修改环境。*


### 工具：**`kubectl_create`**
使用多种方式（从文件或子命令）创建Kubernetes资源

| 参数           | 类型      | 描述                                   |
|----------------|-----------|----------------------------------------|
| `annotations`  | `array`   | 可选，应用于资源的注解（如["key1=value1", "key2=value2"]） |
| `command`      | `array`   | 可选，容器中运行的命令                 |
| `context`      | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `dryRun`       | `boolean` | 可选，仅验证资源，不实际执行操作       |
| `filename`     | `string`  | 可选，用于创建资源的YAML文件路径       |
| `fromFile`     | `array`   | 可选，创建ConfigMap的文件路径（如["key1=/path/to/file1"]） |
| `fromLiteral`  | `array`   | 可选，创建ConfigMap的键值对（如["key1=value1"]） |
| `image`        | `string`  | 可选，Deployment中容器使用的镜像       |
| `labels`       | `array`   | 可选，应用于资源的标签（如["key1=value1"]） |
| `manifest`     | `string`  | 可选，用于创建资源的YAML清单字符串     |
| `name`         | `string`  | 可选，要创建的资源名称                 |
| `namespace`    | `string`  | 可选，Kubernetes命名空间               |
| `output`       | `string`  | 可选，输出格式（json\|yaml\|name等）   |
| `port`         | `number`  | 可选，容器暴露的端口                   |
| `replicas`     | `number`  | 可选，Deployment的副本数               |
| `resourceType` | `string`  | 可选，要创建的资源类型（namespace、configmap等） |
| `schedule`     | `string`  | 可选，CronJob的调度表达式（如"*/5 * * * *"） |
| `secretType`   | `string`  | 可选，Secret类型（generic、docker-registry、tls） |
| `serviceType`  | `string`  | 可选，Service类型（clusterip、nodeport等） |
| `suspend`      | `boolean` | 可选，是否暂停CronJob                  |
| `tcpPort`      | `array`   | 可选，TCP服务的端口对（如["80:8080"]） |
| `validate`     | `boolean` | 可选，是否验证资源 schema 与服务器 schema |


### 工具：**`kubectl_delete`**
通过资源类型、名称、标签或清单文件删除Kubernetes资源

| 参数           | 类型      | 描述                                   |
|----------------|-----------|----------------------------------------|
| `name`         | `string`  | 要删除的资源名称                       |
| `namespace`    | `string`  | Kubernetes命名空间                     |
| `resourceType` | `string`  | 要删除的资源类型（如pods、deployments） |
| `allNamespaces`| `boolean` | 可选，是否跨所有命名空间删除资源       |
| `context`      | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `filename`     | `string`  | 可选，用于删除资源的YAML文件路径       |
| `force`        | `boolean` | 可选，立即从API删除资源并绕过优雅删除   |
| `gracePeriodSeconds` | `number` | 可选，资源优雅终止的秒数               |
| `labelSelector`| `string`  | 可选，删除匹配标签选择器的资源（如'app=nginx'） |
| `manifest`     | `string`  | 可选，定义要删除资源的YAML清单字符串   |

*此工具可能执行破坏性更新。*


### 工具：**`kubectl_describe`**
通过资源类型、名称和可选命名空间描述Kubernetes资源

| 参数           | 类型      | 描述                                   |
|----------------|-----------|----------------------------------------|
| `name`         | `string`  | 要描述的资源名称                       |
| `resourceType` | `string`  | 要描述的资源类型（如pods、deployments） |
| `allNamespaces`| `boolean` | 可选，是否跨所有命名空间描述资源       |
| `context`      | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `namespace`    | `string`  | 可选，Kubernetes命名空间               |

*此工具为只读，不会修改环境。*


### 工具：**`kubectl_generic`**
执行任何kubectl命令，支持提供参数和标志

| 参数           | 类型      | 描述                                   |
|----------------|-----------|----------------------------------------|
| `command`      | `string`  | 要执行的kubectl命令（如patch、rollout） |
| `args`         | `array`   | 可选，额外命令参数                     |
| `context`      | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `flags`        | `object`  | 可选，命令标志（键值对）               |
| `name`         | `string`  | 可选，资源名称                         |
| `namespace`    | `string`  | 可选，Kubernetes命名空间               |
| `outputFormat` | `string`  | 可选，输出格式（如json、yaml、wide）   |
| `resourceType` | `string`  | 可选，资源类型（如pod、deployment）    |
| `subCommand`   | `string`  | 可选，子命令（如rollout的'history'）   |

*此工具可能执行破坏性更新。*


### 工具：**`kubectl_get`**
通过资源类型、名称和可选命名空间获取或列出Kubernetes资源

| 参数           | 类型      | 描述                                   |
|----------------|-----------|----------------------------------------|
| `name`         | `string`  | 可选，资源名称（未提供则列出指定类型所有资源） |
| `namespace`    | `string`  | Kubernetes命名空间                     |
| `resourceType` | `string`  | 要获取的资源类型（如pods、deployments） |
| `allNamespaces`| `boolean` | 可选，是否跨所有命名空间列出资源       |
| `context`      | `string`  | 可选，Kubeconfig上下文（默认null）     |
| `fieldSelector`| `string`  | 可选，按字段选择器筛选资源（如'metadata.name=my-pod'） |
| `labelSelector`| `string`  | 可选，按标签选择器筛选资源（如'app=nginx'） |
| `output`       | `string`  | 可选，输出格式                         |
| `sortBy`       | `string`  | 可选，事件排序

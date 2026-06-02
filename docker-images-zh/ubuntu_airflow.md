---
image: ubuntu/airflow
description: "基于Ubuntu的Apache Airflow Docker镜像，提供工作流管理平台，用于数据工程管道的程序化创作、调度和监控。"
source: https://xuanyuan.cloud/zh/r/ubuntu/airflow
canonical: https://xuanyuan.cloud/zh/r/ubuntu/airflow
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/airflow" title="ubuntu/airflow Docker 镜像中文简介、标签列表与拉取命令">ubuntu/airflow — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/airflow" title="ubuntu/airflow Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/airflow</a>

# airflow | Ubuntu

## 镜像概述和主要用途
Apache Airflow是一个用于程序化创作、调度和监控工作流的平台。此镜像基于Ubuntu构建，包含Python和多种提供程序，来自Canonical，接收安全更新并会滚动更新至新版本的Airflow或Ubuntu。本仓库可免费使用，不受每用户速率限制。

## 核心功能和特性
- **安全维护**：LTS通道提供长达5年的免费安全维护，ESM通道通过Canonical的受限仓库提供长达10年的客户安全维护。
- **多架构支持**：支持`amd64`架构。
- **预安装提供程序**：内置多种常用提供程序（Amazon、GCP、Kubernetes、MySQL、Postgres等），常见集成可直接使用，无需在容器内执行`pip install`。
- **轻量级服务管理**：使用Pebble（轻量级服务管理器）作为PID 1进程，监督Airflow服务。
- **独立模式运行**：`airflow standalone`模式可初始化本地元数据库、创建默认管理员用户，并启动webserver、调度器等核心组件（适用于开发环境）。

## 标签和架构

![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)  
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)  
ESM通道通过[Canonical的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)提供长达10年的客户安全维护。

| 通道标签               | 支持期限   | 当前版本                     | 架构       |
|------------------------|------------|------------------------------|------------|
| **`3.1-24.04_edge`**   | -          | Airflow 3.1 基于 Ubuntu 24.04 LTS | `amd64` |
| _`track_risk`_         |            |                              |            |

通道标签按稳定性排序：`stable`、`candidate`、`beta`、`edge`。风险较高的通道默认可用（如列出`beta`，则可拉取`edge`；列出`candidate`，则可拉取`beta`和`edge`；列出`stable`，则四个通道均可用）。镜像会按`edge`→`beta`→`candidate`→`stable`的顺序更新。

### 商业使用和扩展安全维护通道
若需商业 redistribution，或需要ESM及未列出的通道/版本，请联系[Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。

## 使用方法

### 本地启动镜像
```sh
docker run -d --name airflow-container -e TZ=UTC -p 8080:8080 -e AIRFLOW_HOME=/opt/airflow -v /path/to/dags:/opt/airflow/dags -v /path/to/airflow.cfg:/opt/airflow/airflow.cfg ubuntu/airflow:3.1-24.04_edge
```

### Entrypoint 和 Pebble
该镜像使用[Pebble](https://documentation.ubuntu.com/pebble/)（轻量级服务管理器）作为PID 1进程，监督镜像中定义的Airflow服务。

#### Airflow服务配置
`airflow`服务配置如下：
```
command: /usr/bin/airflow standalone
startup: enabled
```
`airflow standalone`会初始化本地元数据库、创建默认管理员用户，并在一个进程组中启动webserver、调度器及其他核心组件（适用于开发环境）。

#### 配置与状态
- 运行时状态（AIRFLOW_HOME）位于`/opt/airflow`，包含`airflow.cfg`、`airflow.db`（独立模式默认数据库）、日志和`dags/`。
- 需挂载卷以持久化数据或注入自定义DAG，例如：
  ```
  -v ./dags:/opt/airflow/dags  # 挂载自定义DAG目录
  -v ./airflow.cfg:/opt/airflow/airflow.cfg  # 挂载自定义配置文件
  ```

#### 提供程序
镜像预安装多种提供程序（Amazon、GCP、Kubernetes、MySQL、Postgres等），常见集成可直接使用，无需在容器内执行`pip install`。

### 完整配置参考
Airflow支持通过环境变量或`airflow.cfg`进行大量配置。完整配置项可参考官方[配置参考文档](https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html)。

#### 参数说明

| 参数 | 描述 |
|------|------|
| `-e AIRFLOW_HOME=/opt/airflow` | 容器内Airflow运行时状态根目录（包含配置、数据库、日志、DAG等），镜像默认设为`/opt/airflow`。 |
| `-e AIRFLOW__CORE__LOAD_EXAMPLES=false` | 是否加载Airflow自带的DAG示例。入门时可用，生产环境建议设为`false`。 |
| `-e AIRFLOW__CORE__EXECUTOR=LocalExecutor` | Airflow使用的执行器类型，可选`LocalExecutor`、`CeleryExecutor`、`KubernetesExecutor`或自定义执行器的完整导入路径。 |
| `-e AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@db:5432/airflow` | Airflow元数据库的SQLAlchemy连接字符串。独立模式默认使用本地SQLite，生产环境建议使用Postgres或MySQL，可通过此参数指定外部数据库。 |
| `-e AIRFLOW__API__SECRET_KEY=change-me` | API服务器使用的密钥，应尽可能随机。多实例部署时需确保所有实例使用相同密钥，否则可能出现“CSRF session token is missing”错误。 |
| `-e AIRFLOW__API__BASE_URL=https://airflow.example.com` | API服务器的基础URL。 |
| `-e AIRFLOW__CORE__MAX_ACTIVE_TASKS_PER_DAG=16` | 每个DAG运行中允许并发执行的最大任务实例数。 |
| `-p 8080:8080` | Airflow Webserver UI端口（HTTP），用于浏览器访问。 |
| `-p 8794:8794` | Triggerer日志服务器端口，用于Triggerer的日志流式传输和收集，定义于官方Helm Chart的`ports.triggererLogs`。 |
| `-p 8793:8793` | Worker日志服务器端口，用于分布式环境中Worker的日志流式传输和收集，定义于官方Helm Chart的`ports.workerLogs`。 |
| `-v /path/to/dags:/opt/airflow/dags` | 挂载主机DAG目录至容器，无需重建镜像即可更新DAG，`/opt/airflow/dags`目录下的文件会被自动发现。 |
| `-v /path/to/logs:/opt/airflow/logs` | 挂载日志目录以持久化任务日志（便于调试和重启）。 |
| `-v /path/to/airflow.cfg:/opt/airflow/airflow.cfg` | 挂载自定义`airflow.cfg`以覆盖独立模式自动生成的配置文件。 |
| `-v /path/to/requirements.txt:/requirements.txt` | （可选）如需扩展镜像并在运行时安装额外Python依赖，可挂载此文件并在初始化钩子或派生镜像中安装。 |

#### 测试/调试
查看容器日志：
```sh
docker logs -f airflow-container
```

进入容器交互式shell：
```sh
docker exec -it airflow-container /bin/bash
```

## 缺陷和功能请求
如发现镜像缺陷或需请求功能，请提交bug至：  
[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

bug标题格式为“`airflow: <问题摘要>`”，并需包含所用镜像的摘要，可通过以下命令获取：  
```sh
docker images --no-trunc --quiet ubuntu/airflow:<tag>
```

## 废弃的通道和标签
以下通道（标签）不再更新，请升级至较新通道；如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 通道 | 版本 | 生命周期结束（EOL） | 升级路径 |
|------|------|---------------------|----------|
| _`track`_ |      |                     |          |

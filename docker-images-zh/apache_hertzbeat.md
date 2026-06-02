---
image: apache/hertzbeat
description: "Apache HertzBeat是一款易用的开源实时监控系统Docker镜像，支持无代理部署、高性能集群、Prometheus兼容，提供自定义监控和状态页面构建能力，集成监控、告警、通知功能，适用于Web服务、数据库、中间件等多种场景监控。"
source: https://xuanyuan.cloud/zh/r/apache/hertzbeat
canonical: https://xuanyuan.cloud/zh/r/apache/hertzbeat
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/hertzbeat" title="apache/hertzbeat Docker 镜像中文简介、标签列表与拉取命令">apache/hertzbeat — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/hertzbeat" title="apache/hertzbeat Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/hertzbeat</a>

## Apache HertzBeat Docker镜像

### 镜像概述和主要用途
Apache HertzBeat是一款易用、开源的实时监控系统，通过Docker镜像可实现快速部署。该系统集监控、告警、通知功能于一体，支持无代理部署、高性能集群扩展、Prometheus生态兼容，提供强大的自定义监控和状态页面构建能力。适用于监控Web服务、数据库、缓存、操作系统、中间件、云原生等多种服务类型，帮助用户快速构建专属监控体系。

### 核心功能和特性
- **一体化监控告警平台**：整合监控、告警、通知功能，支持Web服务、数据库、缓存、操作系统、中间件、大数据、云原生等多种类型监控。
- **无代理且易用**：基于Web界面，一键监控告警，零学习成本，无需在被监控目标部署代理。
- **灵活协议配置**：支持Http、Jmx、Ssh、Snmp、Jdbc、Prometheus等协议，通过在线配置YML模板即可采集任意指标，快速适配新监控类型。
- **Prometheus兼容**：可监控Prometheus支持的所有目标，通过Web界面简单配置即可实现。
- **高性能集群扩展**：支持多采集器集群水平扩展，满足多隔离网络监控和云边协同需求。
- **丰富告警通知**：提供灵活的告警阈值规则，支持Discord、Slack、Telegram、Email、钉钉、微信、飞书、Webhook、短信等多种通知渠道。
- **状态页面构建**：强大的状态页面功能，可向用户实时展示服务状态。

### 使用场景和适用范围
- **运维监控**：实时监控服务器、数据库、中间件等基础设施和应用服务状态。
- **服务可用性管理**：通过状态页面向用户展示服务实时状态，提升透明度。
- **自定义监控需求**：针对特殊服务或指标，通过配置YML模板快速实现监控。
- **Prometheus生态集成**：在现有Prometheus监控体系基础上，通过Web界面简化配置和管理。
- **多环境监控**：支持私有网络、云环境、边缘节点等多场景监控，满足复杂部署架构需求。

### 详细使用方法和配置说明

#### 快速开始
通过Docker镜像可快速部署HertzBeat，支持单节点部署和集群扩展，以下为详细步骤。

#### Docker安装与部署

##### 单节点快速部署
1. **基础启动命令**  
   执行以下命令启动HertzBeat容器：
   ```shell
   docker run -d -p 1157:1157 -p 1158:1158 --name hertzbeat apache/hertzbeat
   ```
   - `-d`：后台运行容器  
   - `-p 1157:1157`：映射Web界面端口（1157为默认Web端口）  
   - `-p 1158:1158`：映射集群通信端口（用于 collector 节点连接）  
   - `--name hertzbeat`：指定容器名称  

2. **访问Web界面**  
   容器启动后，通过浏览器访问 `http://<主机IP>:1157`，默认账号密码：`admin/hertzbeat`。

##### 高级部署（含数据持久化与配置自定义）
如需数据持久化或自定义配置，可通过挂载卷实现：
```shell
docker run -d -p 1157:1157 -p 1158:1158 \
  -e LANG=en_US.UTF-8 \
  -e TZ=Asia/Shanghai \
  -v $(pwd)/data:/opt/hertzbeat/data \       # 数据持久化（H2数据库文件）
  -v $(pwd)/logs:/opt/hertzbeat/logs \       # 日志持久化
  -v $(pwd)/application.yml:/opt/hertzbeat/config/application.yml \  # 自定义配置文件
  -v $(pwd)/sureness.yml:/opt/hertzbeat/config/sureness.yml \        # 用户权限配置文件
  --name hertzbeat apache/hertzbeat
```
**参数说明**：  
- `-e LANG`：设置系统语言  
- `-e TZ`：设置时区（如 `Asia/Shanghai` 为北京时间）  
- `-v $(pwd)/data:/opt/hertzbeat/data`：挂载数据目录，避免容器删除导致数据丢失  
- `-v $(pwd)/application.yml`：挂载自定义配置文件，覆盖容器默认配置  

##### 集群部署（可选，Collector节点）
如需扩展监控能力，可部署Collector节点组成集群：
```shell
docker run -d \
  -e IDENTITY=collector-01 \                # Collector唯一标识（集群内需唯一）
  -e MANAGER_HOST=192.168.1.100 \           # 主HertzBeat服务器IP
  -e MANAGER_PORT=1158 \                    # 主服务器集群通信端口（默认1158）
  -e MODE=public \                          # 运行模式（public：公共集群；private：云边协同）
  -v $(pwd)/collector-logs:/opt/hertzbeat-collector/logs \  # Collector日志持久化
  --name hertzbeat-collector apache/hertzbeat-collector
```
启动后，通过主服务器Web界面（`http://<主机IP>:1157`）的“采集器管理”可查看已注册的Collector节点。

#### 配置文件说明
如需自定义监控配置、数据存储方式或用户权限，需修改以下配置文件并挂载到容器中。

##### 1. 主配置文件（application.yml）
创建 `application.yml` 并挂载，配置内容可参考 [官方模板](https://github.com/apache/hertzbeat/raw/master/script/application.yml)，关键配置项如下：

**数据存储配置**（选择一种存储方式启用）：
```yaml
warehouse:
  store:
    # JPA存储（默认启用，适合小规模数据）
    jpa:
      enabled: true
      expire-time: 1h  # 历史数据保留时间
      max-history-record-num: 6000  # 最大保留记录数
    # TDengine存储（大规模数据场景）
    td-engine:
      enabled: false
      url: jdbc:TAOS-RS://localhost:6041/hertzbeat
      username: root
      password: taosdata
    # IoTDB存储
    iot-db:
      enabled: false
      host: 127.0.0.1
      rpc-port: 6667
      username: root
      password: root
```

**告警通知配置**（以邮件为例）：
```yaml
alert:
  notice:
    mail:
      enabled: true
      host: smtp.example.com
      port: 465
      username: alert@example.com
      password: your-password
      from: alert@example.com
```

##### 2. 用户权限配置（sureness.yml）
创建 `sureness.yml` 配置用户账户与权限，参考 [官方模板](https://github.com/apache/hertzbeat/raw/master/script/sureness.yml)，关键配置项如下：

**用户账户配置**：
```yaml
account:
  - appId: admin          # 用户名
    credential: hertzbeat # 密码
    role: [admin]         # 角色（admin：管理员；user：普通用户；guest：访客）
  - appId: user
    credential: user123
    role: [user]
```

**API权限控制**：
```yaml
resourceRole:
  - /api/monitor/**===get===[admin,user,guest]  # 监控数据查询权限
  - /api/monitor/**===delete===[admin]          # 监控配置删除权限（仅管理员）
```

### 注意事项
- 首次登录后建议修改默认密码（路径：系统设置 > 用户管理）。
- 如使用邮件、钉钉等告警渠道，需确保容器网络可访问对应服务接口。
- 大规模监控场景下，建议使用TDengine或IoTDB替代默认JPA存储，提升性能。

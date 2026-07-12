---
image: ubuntu/grafana
description: "Grafana是功能丰富的指标仪表板与图形编辑器，提供指标监控与可视化功能，由Canonical进行长期维护。"
source: https://xuanyuan.cloud/zh/r/ubuntu/grafana
canonical: https://xuanyuan.cloud/zh/r/ubuntu/grafana
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/grafana" title="ubuntu/grafana Docker 镜像中文简介、标签列表与拉取命令">ubuntu/grafana 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Grafana Docker镜像（Ubuntu版）


## 镜像概述和主要用途

本镜像为Canonical提供的基于Ubuntu的Grafana Docker镜像，接收持续的安全更新，并会滚动升级至新版本的Grafana或Ubuntu。该仓库可免费使用，且不受用户速率限制。


## 核心功能和特性

### Grafana核心功能
Grafana是一款功能丰富的指标仪表板和图形编辑器，支持Cloudwatch、Elasticsearch、Graphite、InfluxDB、OpenTSB、Prometheus和Hosted Metrics等多种数据源。更多信息请参见[Grafana官方网站](https://grafana.com)。

### 镜像特性
- **安全维护**：提供长期支持（LTS）和扩展安全维护（ESM）选项
- **构建方式差异**：
  - 标签8.2及以下版本为Dockerfile构建的镜像
  - 版本10.0.3及以上为Rock格式镜像，入口点为Pebble（详见[Rockcraft文档](https://canonical-rockcraft.readthedocs-hosted.com/en/latest/explanation/rocks/)）
- **免费使用**：无用户速率限制，支持商业场景


## 使用场景和适用范围
适用于需要构建指标监控仪表板的各类场景，包括但不限于：
- 系统资源监控（CPU、内存、磁盘等）
- 应用性能监控（API响应时间、错误率等）
- 业务指标可视化（用户活跃度、交易数据等）
- 多数据源整合分析

特别适合对长期安全维护有需求的企业环境，或需要稳定运行监控系统的个人/团队。


## 标签与架构

### 维护支持类型
- **LTS**：LTS通道提供长达5年的免费安全维护
- **ESM**：通过Canonical的受限仓库提供长达10年的客户安全维护（[获取更多信息](https://ubuntu.com/security/docker-images#get-in-touch)）

### 标签详情

| 通道标签（主标签） | 其他可用标签 | 支持期限 | 当前版本 | 架构 |
|-------------------|--------------|----------|----------|------|
| **`12.0-24.04_stable`** | `12-24.04`, `12-24.04_beta`, `12-24.04_candidate`, `12-24.04_edge`, `12-24.04_stable`, `12.0-24.04`, `12.0-24.04_beta`, `12.0-24.04_candidate`, `12.0-24.04_edge` | - | Grafana 12.0 on Ubuntu 24.04 LTS | `amd64` |
| `11.6-24.04_stable` | `11-24.04`, `11-24.04_beta`, `11-24.04_candidate`, `11-24.04_edge`, `11-24.04_stable`, `11.6-24.04`, `11.6-24.04_beta`, `11.6-24.04_candidate`, `11.6-24.04_edge` | - | Grafana 11.6 on Ubuntu 24.04 LTS | `amd64` |
| `9.5-24.04_stable` | `9-24.04`, `9-24.04_beta`, `9-24.04_candidate`, `9-24.04_edge`, `9-24.04_stable`, `9.5-24.04`, `9.5-24.04_beta`, `9.5-24.04_candidate`, `9.5-24.04_edge` | - | Grafana 9.5 on Ubuntu 24.04 LTS | `amd64` |
| `8.2-22.04_beta` | `8.2-22.04_edge`, `edge`, `latest` | - | Grafana 8.2 on Ubuntu 22.04 LTS | `amd64`, `s390x`, `ppc64le`, `arm64` |
| `8.1-21.10_beta` | `8.1-21.10_edge` | - | Grafana 8.1 on Ubuntu 21.10 | `ppc64le`, `s390x`, `amd64`, `arm64` |
| `7.4-21.04_beta` | `7.4-21.04_edge` | - | Grafana 7.4 on Ubuntu 21.04 | `s390x`, `ppc64le`, `amd64`, `arm64` |
| `7.2-20.04_beta` | `7.2-20.04_edge` | - | Grafana 7.2 on Ubuntu 20.04 LTS | `amd64`, `s390x`, `ppc64le`, `arm64` |
| `9.2-22.04_edge` | `9.2-22.04_edge` | - | Grafana 9.2 on Ubuntu 22.04 LTS | `ppc64le`, `amd64`, `arm64` |

> **标签说明**：通道标签按稳定性排序为`stable` > `candidate` > `beta` > `edge`。若列出`beta`标签，则可拉取`edge`；若列出`candidate`，则可拉取`beta`和`edge`；若列出`stable`，则所有四个通道均可用。镜像会按`edge` → `beta` → `candidate` → `stable`的顺序发布。


## 使用方法和配置说明

### 基本部署

本地启动Grafana容器：

```bash
docker run -d --name grafana-container -e TZ=UTC -p 3000:3000 docker.xuanyuan.run/ubuntu/grafana:12.0-24.04_stable
```

访问Grafana实例：`http://localhost:3000`


### 参数说明

| 参数 | 描述 |
|------|------|
| `-e TZ=UTC` | 设置时区（例如`TZ=Asia/Shanghai`） |
| `-p 3000:3000` | 将容器的3000端口映射到本地3000端口，暴露Grafana服务 |
| `-v /path/to/grafana/provisioning/files/:/etc/grafana/provisioning/` | 挂载配置文件目录，用于自动配置Grafana（详见[Grafana配置文档](https://grafana.com/docs/grafana/latest/administration/provisioning/)） |
| `-v /path/to/persisted/data:/var/lib/grafana` | 挂载数据目录，持久化存储Grafana数据（避免每次启动容器重新初始化数据库） |


### 持久化配置示例

为确保数据持久化，推荐挂载数据目录：

```bash
docker run -d \
  --name grafana-container \
  -e TZ=Asia/Shanghai \
  -p 3000:3000 \
  -v /local/grafana/provisioning:/etc/grafana/provisioning \
  -v /local/grafana/data:/var/lib/grafana \
  docker.xuanyuan.run/ubuntu/grafana:12.0-24.04_stable
```


### 调试与测试

#### 查看容器日志

```bash
docker logs -f grafana-container
```

#### 获取交互式Shell

- **Dockerfile构建的镜像（8.2及以下版本）**：
  ```bash
  docker exec -it grafana-container /bin/bash
  ```

- **Rock格式镜像（10.0.3及以上版本）**：
  ```bash
  docker exec -it grafana-container exec /bin/bash
  ```


## 废弃标签

以下标签不再更新，请升级至较新通道。如需继续使用，请联系Canonical团队。

| 标签 | 版本 | 终止支持日期 | 升级路径 |
|------|------|--------------|----------|
| ~~10.4.0-22.04~~ | Grafana 10.4.0 on Ubuntu 22.04 LTS | 2025-03 | - |
| ~~10.3.1-22.04~~ | Grafana 10.3.1 on Ubuntu 22.04 LTS | 2025-03 | - |
| ~~11.0.0-22.04~~ | Grafana 11.0.0 on Ubuntu 22.04 LTS | 2025-05 | - |
| ~~10.2.0-22.04~~ | Grafana 10.2.0 on Ubuntu 22.04 LTS | 2025-03 | - |
| ~~10.4.2-22.04~~ | Grafana 10.4.2 on Ubuntu 22.04 LTS | 2025-05 | - |
| ~~10.0.3-22.04~~ | Grafana 10.0.3 on Ubuntu 22.04 LTS | 2025-03 | - |
| ~~10.2.3-22.04~~ | Grafana 10.2.3 on Ubuntu 22.04 LTS | 2025-03 | - |
| ~~10.3.3-22.04~~ | Grafana 10.3.3 on Ubuntu 22.04 LTS | 2025-03 | - |
| ~~9.5.3-22.04~~ | Grafana 9.5.3 on Ubuntu 22.04 LTS | 2025-03 | - |


## 问题反馈与功能请求

如发现镜像漏洞或需要特定功能，请提交bug报告：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将bug标题格式化为：`grafana: <问题摘要>`，并务必包含镜像的摘要信息（可通过以下命令获取）：

```bash
docker images --no-trunc --quiet ubuntu/grafana:<tag>
```


## 商业支持与扩展安全维护

如需商业 redistribution 或 ESM 支持，请联系Canonical团队：
- 官网：[https://ubuntu.com/security/docker-images#get-in-touch](https://ubuntu.com/security/docker-images#get-in-touch)
- 邮箱：rocks@canonical.com

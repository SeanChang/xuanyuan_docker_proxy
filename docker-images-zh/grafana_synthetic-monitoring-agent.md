---
image: grafana/synthetic-monitoring-agent
description: "Blackbox Exporter代理，用于执行Grafana Cloud Synthetic Monitoring服务的检查。"
source: https://xuanyuan.cloud/zh/r/grafana/synthetic-monitoring-agent
canonical: https://xuanyuan.cloud/zh/r/grafana/synthetic-monitoring-agent
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/synthetic-monitoring-agent" title="grafana/synthetic-monitoring-agent Docker 镜像中文简介、标签列表与拉取命令">grafana/synthetic-monitoring-agent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Blackbox Exporter for Grafana Cloud Synthetic Monitoring

## 镜像概述和主要用途

本镜像为Blackbox Exporter代理，专为Grafana Cloud Synthetic Monitoring服务设计，用于执行各类监控检查任务。它能够监控外部服务和端点的可用性、性能及其他关键指标，并将收集到的数据发送至Grafana Cloud，支持用户通过Grafana进行可视化、分析和告警配置。

## 核心功能和特性

- **多协议支持**：支持HTTP、HTTPS、ICMP（ping）、TCP等多种协议的监控检查，满足不同类型服务的监控需求。
- **灵活配置**：可自定义检查参数，如超时时间、重试次数、请求头、预期状态码等，适应多样化的监控场景。
- **Grafana Cloud集成**：与Grafana Cloud Synthetic Monitoring服务无缝集成，数据可直接用于Grafana仪表盘和告警规则。
- **轻量级设计**：基于官方Blackbox Exporter优化，资源占用低，适合在容器环境中部署。

## 使用场景和适用范围

- **外部服务监控**：监控网站、API端点、第三方服务等外部资源的可用性和响应时间。
- **基础设施连通性检查**：通过ICMP或TCP协议检查服务器、网络设备的连通性。
- **SLA保障**：帮助团队验证服务是否满足SLA（服务级别协议）要求，及时发现并解决服务中断问题。
- **DevOps/SRE工作流**：集成到CI/CD流程或运维工具链中，提供持续的服务健康状态反馈。

## 使用方法和配置说明

### 基本部署（Docker Run）

使用以下命令启动容器，需替换`<your-grafana-cloud-api-key>`为实际的Grafana Cloud API密钥，并挂载自定义配置文件（如有需要）：

```docker
docker run -d \
  --name blackbox-exporter-grafana-cloud \
  -p 9115:9115 \
  -e GRAFANA_CLOUD_API_KEY="<your-grafana-cloud-api-key>" \
  -v /path/to/your/config.yml:/etc/blackbox-exporter/config.yml \
  docker.xuanyuan.run/grafana/blackbox-exporter-grafana-cloud:latest
```

### Docker Compose配置示例

```yaml
version: '3'
services:
  blackbox-exporter:
    image: docker.xuanyuan.run/grafana/blackbox-exporter-grafana-cloud:latest
    container_name: blackbox-exporter-grafana-cloud
    ports:
      - "9115:9115"
    environment:
      - GRAFANA_CLOUD_API_KEY=<your-grafana-cloud-api-key>
      - CHECK_INTERVAL=60s  # 检查间隔，默认60秒
    volumes:
      - ./config.yml:/etc/blackbox-exporter/config.yml
    restart: unless-stopped
```

### 配置文件说明

默认配置文件路径为`/etc/blackbox-exporter/config.yml`，可通过挂载自定义文件覆盖。以下是HTTP检查配置示例：

```yaml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_status_codes: [200, 201, 204]
      method: GET
      headers:
        User-Agent: Blackbox-Exporter-Grafana-Cloud
```

### 环境变量配置

| 环境变量                | 描述                                                                 | 默认值       |
|-------------------------|----------------------------------------------------------------------|--------------|
| `GRAFANA_CLOUD_API_KEY` | Grafana Cloud API密钥，用于身份验证和数据上传                          | 无（必填）   |
| `CHECK_INTERVAL`        | 检查任务执行间隔（格式：数字+单位，如`30s`、`5m`）                     | `60s`        |
| `LISTEN_PORT`           | 容器内部监听端口                                                      | `9115`       |
| `CONFIG_FILE_PATH`      | 配置文件路径                                                          | `/etc/blackbox-exporter/config.yml` |

### 验证部署

容器启动后，通过访问`http://<container-ip>:9115/metrics`查看监控指标。在Grafana Cloud控制台配置Synthetic Monitoring检查，指向该实例即可完成集成。

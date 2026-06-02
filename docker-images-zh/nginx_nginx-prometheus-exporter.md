---
image: nginx/nginx-prometheus-exporter
description: "NGINX Prometheus Exporter用于收集并导出NGINX与NGINX Plus的监控指标，供Prometheus采集以实现对其运行状态的监控。"
source: https://xuanyuan.cloud/zh/r/nginx/nginx-prometheus-exporter
canonical: https://xuanyuan.cloud/zh/r/nginx/nginx-prometheus-exporter
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nginx/nginx-prometheus-exporter" title="nginx/nginx-prometheus-exporter Docker 镜像中文简介、标签列表与拉取命令">nginx/nginx-prometheus-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/nginx/nginx-prometheus-exporter" title="nginx/nginx-prometheus-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nginx/nginx-prometheus-exporter</a>

# NGINX Prometheus Exporter

## 镜像概述和主要用途

NGINX Prometheus Exporter是一个用于监控NGINX或NGINX Plus的Prometheus导出器。它能够从NGINX或NGINX Plus收集性能指标，将其转换为Prometheus兼容的格式，并通过HTTP服务器暴露这些指标，以便Prometheus进行抓取和监控。

## 核心功能和特性

- 支持NGINX开源版和NGINX Plus
- 收集丰富的HTTP和TCP连接指标
- 提供上游服务器健康状态和性能指标
- 支持SSL握手和会话复用统计
- 可配置的指标抓取端点和超时设置
- 支持TLS和身份验证的Web配置
- 多平台Docker镜像支持

## 使用场景和适用范围

- NGINX服务器性能监控
- 反向代理和负载均衡器状态跟踪
- Web应用流量分析
- 上游服务健康检查和性能评估
- 与Prometheus和Grafana集成构建监控仪表板
- Kubernetes环境中的NGINX Ingress Controller监控

## 详细的使用方法和配置说明

### 前提条件

- 已安装Prometheus
- 已安装NGINX或NGINX Plus
- 为NGINX配置stub_status模块，或为NGINX Plus配置API

#### NGINX配置要求

**对于NGINX开源版**:
```nginx
server {
    listen 8080;
    location /stub_status {
        stub_status;
        allow 127.0.0.1;    # 允许 exporter 访问
        deny all;
    }
}
```

**对于NGINX Plus**:
```nginx
server {
    listen 8080;
    location /api {
        api;
        allow 127.0.0.1;    # 允许 exporter 访问
        deny all;
    }
}
```

### Docker部署

#### 使用docker run命令

**监控NGINX开源版**:
```bash
docker run -d -p 9113:9113 --name nginx-exporter \
  nginx/nginx-prometheus-exporter:latest \
  --nginx.scrape-uri=http://<nginx-ip>:8080/stub_status
```

**监控NGINX Plus**:
```bash
docker run -d -p 9113:9113 --name nginx-exporter \
  nginx/nginx-prometheus-exporter:latest \
  --nginx.plus --nginx.scrape-uri=http://<nginx-plus-ip>:8080/api
```

**使用Unix域套接字**:
```bash
docker run -d -p 9113:9113 --name nginx-exporter \
  -v /var/run/nginx.sock:/var/run/nginx.sock \
  nginx/nginx-prometheus-exporter:latest \
  --nginx.scrape-uri=unix:/var/run/nginx.sock:/stub_status
```

#### 使用docker-compose配置

```yaml
version: '3'

services:
  nginx-exporter:
    image: nginx/nginx-prometheus-exporter:latest
    container_name: nginx-exporter
    restart: always
    ports:
      - "9113:9113"
    command:
      - --nginx.scrape-uri=http://nginx:8080/stub_status
    depends_on:
      - nginx
    networks:
      - monitoring-network

  nginx:
    image: nginx:latest
    container_name: nginx
    restart: always
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    networks:
      - monitoring-network

networks:
  monitoring-network:
    driver: bridge
```

### 配置参数和环境变量

#### 命令行参数

| 参数 | 环境变量 | 描述 | 默认值 |
|------|---------|------|--------|
| `--web.listen-address` | `LISTEN_ADDRESS` | 暴露指标的地址 | `:9113` |
| `--web.telemetry-path` | `TELEMETRY_PATH` | 指标路径 | `/metrics` |
| `--web.config.file` | `CONFIG_FILE` | TLS和认证配置文件路径 | `""` |
| `--nginx.plus` | `NGINX_PLUS` | 是否监控NGINX Plus | `false` |
| `--nginx.scrape-uri` | `SCRAPE_URI` | NGINX指标抓取URI | `http://127.0.0.1:8080/stub_status` |
| `--nginx.ssl-verify` | `SSL_VERIFY` | 是否验证SSL证书 | `true` |
| `--nginx.ssl-ca-cert` | `SSL_CA_CERT` | CA证书路径 | `""` |
| `--nginx.ssl-client-cert` | `SSL_CLIENT_CERT` | 客户端证书路径 | `""` |
| `--nginx.ssl-client-key` | `SSL_CLIENT_KEY` | 客户端密钥路径 | `""` |
| `--nginx.proxy-protocol` | `PROXY_PROTOCOL` | 是否传递代理协议 | `false` |
| `--nginx.timeout` | `TIMEOUT` | 指标抓取超时 | `5s` |
| `--prometheus.const-label` | `CONST_LABELS` | 所有指标的常量标签 | `""` |
| `--log.level` | - | 日志级别 | `info` |
| `--log.format` | - | 日志格式 | `logfmt` |

#### 示例: 使用环境变量配置

```bash
docker run -d -p 9113:9113 --name nginx-exporter \
  -e LISTEN_ADDRESS=:9113 \
  -e NGINX_PLUS=false \
  -e SCRAPE_URI=http://nginx:8080/stub_status \
  -e TIMEOUT=10s \
  nginx/nginx-prometheus-exporter:latest
```

## 导出的指标

### 通用指标

| 名称 | 类型 | 描述 | 标签 |
|------|------|------|------|
| `nginx_exporter_build_info` | Gauge | 导出器构建信息 | `branch`, `goarch`, `goos`, `goversion`, `revision`, `tags`, `version` |
| `promhttp_metric_handler_requests_total` | Counter | 按HTTP状态码的抓取总数 | `code` |
| `promhttp_metric_handler_requests_in_flight` | Gauge | 当前正在处理的抓取请求数 | - |

### NGINX开源版指标

| 名称 | 类型 | 描述 | 标签 |
|------|------|------|------|
| `nginx_up` | Gauge | 最后一次指标抓取状态 (1=成功, 0=失败) | - |
| `nginx_connections_accepted` | Counter | 接受的客户端连接数 | - |
| `nginx_connections_active` | Gauge | 活跃的客户端连接数 | - |
| `nginx_connections_handled` | Counter | 已处理的客户端连接数 | - |
| `nginx_connections_reading` | Gauge | 读取请求头的连接数 | - |
| `nginx_connections_waiting` | Gauge | 空闲客户端连接数 | - |
| `nginx_connections_writing` | Gauge | 写入响应的连接数 | - |
| `nginx_http_requests_total` | Counter | HTTP请求总数 | - |

### NGINX Plus指标

除上述指标外，NGINX Plus还提供以下额外指标：

#### 连接指标

| 名称 | 类型 | 描述 |
|------|------|------|
| `nginxplus_connections_accepted` | Counter | 接受的客户端连接数 |
| `nginxplus_connections_active` | Gauge | 活跃的客户端连接数 |
| `nginxplus_connections_dropped` | Counter | 丢弃的客户端连接数 |
| `nginxplus_connections_idle` | Gauge | 空闲客户端连接数 |

#### HTTP指标

| 名称 | 类型 | 描述 |
|------|------|------|
| `nginxplus_http_requests_total` | Counter | HTTP请求总数 |
| `nginxplus_http_requests_current` | Gauge | 当前HTTP请求数 |

#### 服务器区域指标

| 名称 | 类型 | 描述 | 标签 |
|------|------|------|------|
| `nginxplus_server_zone_requests` | Counter | 客户端请求总数 | `server_zone` |
| `nginxplus_server_zone_responses` | Counter | 客户端响应总数 | `code`, `server_zone` |
| `nginxplus_server_zone_received` | Counter | 从客户端接收的字节数 | `server_zone` |
| `nginxplus_server_zone_sent` | Counter | 发送给客户端的字节数 | `server_zone` |

#### 上游服务器指标

| 名称 | 类型 | 描述 | 标签 |
|------|------|------|------|
| `nginxplus_upstream_server_state` | Gauge | 上游服务器状态 | `server`, `upstream` |
| `nginxplus_upstream_server_active` | Gauge | 活跃连接数 | `server`, `upstream` |
| `nginxplus_upstream_server_requests` | Counter | 请求总数 | `server`, `upstream` |
| `nginxplus_upstream_server_responses` | Counter | 响应总数 | `code`, `server`, `upstream` |

## Prometheus配置

在Prometheus配置文件中添加以下内容以抓取NGINX Exporter指标：

```yaml
scrape_configs:
  - job_name: 'nginx'
    static_configs:
      - targets: ['nginx-exporter:9113']
```

## Grafana仪表板

官方提供的Grafana仪表板可从以下链接获取:
- NGINX开源版: [Grafana Dashboard](https://grafana.com/grafana/dashboards/9614-nginx/)
- NGINX Plus: [Grafana Dashboard](https://grafana.com/grafana/dashboards/12708-nginx-plus/)

## 故障排除

- **连接问题**: 确保NGINX的stub_status或API端点可被exporter访问
- **权限问题**: 检查Unix域套接字的权限设置
- **证书问题**: 使用`--nginx.ssl-verify=false`禁用SSL验证进行测试
- **日志信息**: 通过设置`--log.level=debug`获取详细调试日志
- **网络问题**: 在Docker环境中确保容器之间网络可达

## 镜像标签

- `latest`: 最新稳定版本
- `1`, `1.5`, `1.5.1`: 特定版本号
- `main`: 开发分支最新构建

## 支持和贡献

项目源码: [https://github.com/nginx/nginx-prometheus-exporter](https://github.com/nginx/nginx-prometheus-exporter)

问题反馈: [https://github.com/nginx/nginx-prometheus-exporter/issues](https://github.com/nginx/nginx-prometheus-exporter/issues)

## 许可证

本项目采用Apache License 2.0许可证。详情请参见[LICENSE](https://github.com/nginx/nginx-prometheus-exporter/blob/main/LICENSE)文件。

---
image: prom/snmp-exporter
description: "Prometheus SNMP导出器，用于从SNMP设备收集数据并转换为Prometheus可抓取的格式，支持网络设备监控与指标采集。"
source: https://xuanyuan.cloud/zh/r/prom/snmp-exporter
canonical: https://xuanyuan.cloud/zh/r/prom/snmp-exporter
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/prom/snmp-exporter" title="prom/snmp-exporter Docker 镜像中文简介、标签列表与拉取命令">prom/snmp-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/prom/snmp-exporter" title="prom/snmp-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/prom/snmp-exporter</a>

# Prometheus SNMP Exporter 镜像文档

## 镜像概述和主要用途

`prom/snmp-exporter` 是 Prometheus 官方推荐的 SNMP 数据导出工具，用于将 SNMP 设备数据转换为 Prometheus 可摄入的格式。通过该镜像，用户可轻松监控支持 SNMP 协议的网络设备（如交换机、路由器、接入点等），实现设备性能指标（如接口流量、系统资源等）的采集与分析。


## 核心功能和特性

### 1. SNMP 与 Prometheus 数据映射
- 将 SNMP 层次化 OID 结构自动映射为 Prometheus 多维标签格式，支持多索引 OID 映射为多个 Prometheus 标签。
- 示例：将 `ifIndex`、`ifDescr`、`ifName` 等 SNMP 索引映射为 Prometheus 指标标签（如 `ifHCOutOctets{ifIndex="2",ifDescr="eth0",...}`）。

### 2. 多模块与多设备支持
- 支持多模块并发采集（通过 `--snmp.module-concurrency` 控制，默认 1），单次请求可获取多个模块数据。
- 单实例可高效监控数千台 SNMP 设备，适用于大规模网络环境。

### 3. 安全特性
- 支持 SNMP v3 加密认证（解决 v1/v2c 社区字符串明文传输问题）。
- 支持 HTTP 端点的 TLS 加密和基本认证（通过 `--web.config.file` 配置）。

### 4. 灵活配置
- 提供默认 `snmp.yml` 配置，覆盖常见硬件设备；支持通过 generator 工具从 MIB 文件生成自定义配置。
- 支持环境变量注入认证信息（`username`、`password`、`priv_password`），需启用 `--config.expand-environment-variables`。

### 5. 大计数器处理
- 自动对 64 位大计数器（Counter64）进行 2^53 截断，避免 Prometheus 浮点精度丢失；可通过 `--no-snmp.wrap-large-counters` 禁用。


## 使用场景和适用范围

### 适用设备
- 网络设备：交换机、路由器、接入点（AP）、防火墙等支持 SNMP 的设备。
- 服务器与 IoT 设备：支持 SNMP 代理的服务器、存储设备、传感器等。

### 典型场景
- 企业网络监控：集中采集多厂商网络设备的接口流量、端口状态、CPU/内存使用率等指标。
- 数据中心基础设施监控：监控网络设备性能，结合 Prometheus Alertmanager 实现异常告警。
- 自定义 SNMP 设备监控：通过 generator 工具适配非标准 MIB 的私有设备。


## 详细使用方法和配置说明

### 镜像获取
```bash
docker pull prom/snmp-exporter
```


### Docker 部署方案

#### 1. 基础运行（默认配置）
```bash
docker run -d -p 9116:9116 --name snmp-exporter prom/snmp-exporter
```
- 暴露端口：9116（默认 HTTP 端口）。
- 默认配置：使用内置 `snmp.yml`，支持 `if_mib` 模块和 `public_v2` 认证（SNMP v2c 只读社区）。

#### 2. 自定义配置文件
```bash
docker run -d -p 9116:9116 \
  -v /path/to/your/snmp.yml:/etc/snmp_exporter/snmp.yml \
  --name snmp-exporter \
  prom/snmp-exporter --config.file=/etc/snmp_exporter/snmp.yml
```
- 挂载自定义 `snmp.yml` 配置文件（路径可通过 `--config.file` 指定，支持多文件和 glob 匹配，如 `--config.file=snmp*.yml`）。

#### 3. Docker Compose 示例
```yaml
version: '3'
services:
  snmp-exporter:
    image: prom/snmp-exporter
    container_name: snmp-exporter
    ports:
      - "9116:9116"
    volumes:
      - ./snmp.yml:/etc/snmp_exporter/snmp.yml
      - ./web-config.yml:/etc/snmp_exporter/web-config.yml  # TLS/基本认证配置
    command:
      - --config.file=/etc/snmp_exporter/snmp.yml
      - --config.expand-environment-variables  # 启用环境变量注入
      - --web.config.file=/etc/snmp_exporter/web-config.yml
    environment:
      - ARISTA_USERNAME=admin  # 示例：注入认证用户名
      - ARISTA_PASSWORD=secret  # 示例：注入认证密码
    restart: unless-stopped
```


### 运行参数说明

| 参数                          | 描述                                                                 | 默认值                  |
|-------------------------------|----------------------------------------------------------------------|-------------------------|
| `--config.file`               | 指定配置文件路径（支持多文件和 glob 匹配，如 `snmp*.yml`）            | `snmp.yml`              |
| `--config.expand-environment-variables` | 启用配置文件中环境变量注入（支持 `username`/`password`/`priv_password`） | `false`                 |
| `--web.config.file`           | 指定 Web 配置文件（TLS/基本认证，格式参考 [exporter-toolkit](https://github.com/prometheus/exporter-toolkit/blob/master/docs/web-configuration.md)） | 无                      |
| `--snmp.module-concurrency`   | 多模块采集并发数                                                     | 1                       |
| `--no-snmp.wrap-large-counters` | 禁用大计数器（Counter64）2^53 截断                                  | `false`                 |


### 指标采集与 URL 参数

#### 基础采集 URL
```
http://<exporter-ip>:9116/snmp?target=<device-ip>&module=<module>&auth=<auth>
```

#### 关键参数说明

| 参数          | 描述                                                                 | 示例                                  |
|---------------|----------------------------------------------------------------------|---------------------------------------|
| `target`      | SNMP 设备地址，支持 `[transport://]host[:port]` 格式（transport：`udp`/`tcp`） | `192.168.1.1`、`tcp://192.168.1.1:1161` |
| `module`      | 指定采集模块（在 `snmp.yml` 中定义，支持多模块，用逗号分隔或重复参数） | `if_mib`、`if_mib,arista_sw`          |
| `auth`        | 指定认证配置（在 `snmp.yml` 的 `auths` 中定义）                       | `public_v2`、`my_secure_v3`           |
| `snmp_context`| SNMP 上下文名称（覆盖 `snmp.yml` 中的 `context_name`）                | `vrf-mgmt`                            |
| `snmp_engineid`| SNMP v3 引擎 ID（仅 SNMP v3 适用）                                    | `800004f7059c7a0307400529`            |

#### 多模块采集示例
```
# 逗号分隔
http://localhost:9116/snmp?module=if_mib,arista_sw&target=192.168.1.1&auth=public_v2

# 重复参数
http://localhost:9116/snmp?module=if_mib&module=arista_sw&target=192.168.1.1&auth=public_v2
```


### 配置文件详解（snmp.yml）

`snmp.yml` 是核心配置文件，定义模块（`modules`）和认证（`auths`）。默认配置覆盖常见设备，如需自定义需通过 [generator](https://github.com/prometheus/snmp_exporter/tree/main/generator) 生成。

#### 结构示例
```yaml
auths:
  public_v2:  # 认证名称，用于 URL 参数 `auth`
    community: public  # SNMP v2c 社区字符串
    security_level: noAuthNoPriv  # 安全级别（noAuthNoPriv/authNoPriv/authPriv）
    version: 2  # SNMP 版本（1/2/3）

  my_secure_v3:
    version: 3
    security_level: authPriv
    username: ${ARISTA_USERNAME}  # 环境变量注入用户名
    password: ${ARISTA_PASSWORD}  # 环境变量注入认证密码
    auth_protocol: SHA256  # 认证协议（MD5/SHA/SHA224/SHA256/SHA384/SHA512）
    priv_protocol: AES  # 加密协议（DES/AES/AES192/AES256）
    priv_password: ${ARISTA_PRIV_PASSWORD}  # 环境变量注入加密密码

modules:
  if_mib:  # 模块名称，用于 URL 参数 `module`
    walk:  # 要遍历的 OID 或 MIB 节点
      - 1.3.6.1.2.1.2.2  # ifTable
      - 1.3.6.1.2.1.31.1.1  # ifXTable
    metrics:  # 指标定义
      - name: ifInOctets
        oid: 1.3.6.1.2.1.2.2.1.10
        type: counter
        help: 接口入站字节数
        indexes:
          - labelname: ifIndex
            type: gauge
```


### Prometheus 集成配置

#### Prometheus 配置示例（prometheus.yml）
```yaml
scrape_configs:
  - job_name: 'snmp'
    static_configs:
      - targets:
          - 192.168.1.1  # 交换机
          - tcp://192.168.1.2:1161  # 路由器（TCP 传输，端口 1161）
    metrics_path: /snmp
    params:
      auth: [public_v2]  # 默认认证
      module: [if_mib]   # 默认模块（可多模块：[if_mib, arista_sw]）
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target  # 将 target 传递给 exporter
      - source_labels: [__param_target]
        target_label: instance  # 实例标签设为设备地址
      - target_label: __address__
        replacement: 127.0.0.1:9116  # snmp-exporter 地址

  # 监控 exporter 自身指标
  - job_name: 'snmp_exporter'
    static_configs:
      - targets: ['localhost:9116']
```


### TLS 与基本认证配置

通过 `--web.config.file` 指定 Web 配置文件，启用 TLS 和基本认证。示例配置（web-config.yml）：
```yaml
tls_config:
  cert_file: /etc/tls/cert.pem
  key_file: /etc/tls/key.pem

basic_auth_users:
  admin: $2a$10$Gd6Za4E6d87xRvKx6rSMeO9eTQV9eTQV9eTQV9eTQV9eTQV9eTQV  # bcrypt 加密的密码
```


### 配置生成（generator）

如需自定义模块（如私有 MIB），使用 generator 工具从 MIB 文件生成 `snmp.yml`：

1. 下载 [generator](https://github.com/prometheus/snmp_exporter/releases) 并安装。
2. 编写 generator 配置（如 `generator.yml`），指定 MIB 路径和模块定义。
3. 生成配置：
   ```bash
   ./generator generate --config.file=generator.yml --output.file=snmp.yml
   ```


### 大计数器处理

默认情况下，exporter 会将 64 位计数器（Counter64）值截断为 2^53（避免 Prometheus 浮点精度丢失）。如对接非 Prometheus 系统需禁用此功能：
```bash
docker run -d -p 9116:9116 --name snmp-exporter prom/snmp-exporter --no-snmp.wrap-large-counters
```


## 贡献与扩展

- **配置贡献**：自定义 `snmp.yml` 及 generator 配置可贡献至 [官方仓库](https://github.com/prometheus/snmp_exporter)。
- **监控规则与仪表盘**：可提交至 [snmp-mixin](https://github.com/prometheus/snmp_exporter/tree/main/snmp-mixin) 项目，共享仪表盘、告警规则等。

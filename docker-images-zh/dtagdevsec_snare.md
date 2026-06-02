---
image: dtagdevsec/snare
description: "T-Pot Snare是T-Pot蜜罐平台中的Web蜜罐组件，用于模拟Web应用程序诱捕攻击者，记录其攻击行为和流量数据，助力安全威胁分析与情报收集。"
source: https://xuanyuan.cloud/zh/r/dtagdevsec/snare
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[dtagdevsec/snare](https://xuanyuan.cloud/zh/r/dtagdevsec/snare)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# T-Pot Snare Docker镜像文档


## 1. 镜像概述

T-Pot Snare Docker镜像是[T-Pot - The All In One Multi Honeypot Platform](https://github.com/telekom-security/tpotce)（一体化多蜜罐平台）的核心组件之一。Snare是一款轻量级Web蜜罐，通过模拟真实Web服务器（如Apache、Nginx）的行为特征，吸引并捕获针对Web服务的攻击流量，记录攻击者的HTTP请求详情及恶意行为，为网络安全研究、威胁情报收集提供数据支持。


## 2. 核心功能与特性

### 2.1 核心功能
- **Web服务模拟**：支持模拟多种主流Web服务器（如Apache、Nginx、IIS）的响应特征，包括服务器指纹、默认页面结构等，提升欺骗性。
- **攻击行为捕获**：记录攻击者的HTTP请求完整信息，包括请求方法（GET/POST等）、URL路径、请求头（User-Agent、Referer等）、客户端IP、请求体内容等。
- **自定义响应配置**：支持通过配置文件定义自定义响应页面（HTML/PHP等），模拟特定Web应用（如CMS、管理后台）的交互逻辑。
- **日志集成**：原生支持与T-Pot平台的日志收集组件（如ELK Stack、Suricata）联动，实现攻击数据的集中存储、分析与可视化。

### 2.2 关键特性
- **低交互设计**：资源占用低，可在轻量级环境中稳定运行，适合长期部署。
- **动态适配**：可根据攻击者行为动态调整响应策略（如模拟错误页面、重定向等）。
- **SSL/TLS支持**：可选启用HTTPS模拟，捕获加密Web流量中的攻击行为。
- **跨平台兼容**：作为Docker镜像，支持在Linux、Windows（WSL2）、macOS等环境中部署。


## 3. 使用场景与适用范围

### 3.1 典型使用场景
- **威胁情报收集**：部署于公网或内网边界，捕获针对Web服务的恶意扫描、SQL注入、XSS等攻击样本及TTPs（战术、技术与程序）。
- **安全研究与教学**：作为蜜罐实验环境，用于分析Web攻击手法、验证防御机制有效性。
- **企业内网监控**：部署于内部网络，检测横向移动攻击或内部未授权访问行为。
- **红蓝对抗演练**：模拟真实Web服务目标，为红队提供攻击目标，同时为蓝队提供攻击检测数据。

### 3.2 适用用户
- 网络安全研究人员、威胁情报分析师
- 企业SOC（安全运营中心）团队
- 高校、培训机构（网络安全教学）
- 安全产品开发与测试人员


## 4. 使用方法与配置说明

### 4.1 前提条件
- 已安装Docker Engine（20.10+）及Docker Compose（v2+）。
- （可选）T-Pot平台环境（推荐，可实现多蜜罐联动与日志集中管理）。


### 4.2 部署方式

#### 4.2.1 独立部署（Docker Run）
通过`docker run`命令直接启动Snare容器（需手动映射端口与日志目录）：

```bash
# 基础启动（HTTP模式，默认监听80端口）
docker run -d \
  --name tpot-snare \
  -p 80:80 \  # 宿主机端口:容器端口（默认80/tcp）
  -v /path/to/snare/logs:/var/log/snare \  # 挂载日志目录（可选）
  -v /path/to/snare/config:/etc/snare \    # 挂载自定义配置文件（可选）
  --restart unless-stopped \
  telekomsecurity/tpot-snare:latest

# 启用HTTPS模拟（需提前准备SSL证书）
docker run -d \
  --name tpot-snare-ssl \
  -p 443:443 \
  -v /path/to/ssl/certs:/etc/snare/ssl \  # 挂载SSL证书（cert.pem、key.pem）
  -e SNARE_SSL_ENABLED=true \
  -e SNARE_SERVER_TYPE="nginx/1.21.0" \  # 模拟Nginx服务器
  telekomsecurity/tpot-snare:latest
```

#### 4.2.2 T-Pot平台集成部署
Snare通常作为T-Pot平台的默认组件之一，通过T-Pot官方部署脚本一键部署（推荐生产环境使用）：

```bash
# 克隆T-Pot仓库
git clone https://github.com/telekom-security/tpotce.git
cd tpotce

# 运行部署脚本（根据提示选择Snare组件）
sudo ./install.sh
```

部署完成后，Snare将与其他蜜罐（如Cowrie、Dionaea）及监控组件（ELK、Grafana）联动，攻击日志可通过T-Pot Web控制台查看。


### 4.3 配置说明

#### 4.3.1 环境变量参数
通过`-e`参数传递环境变量，自定义Snare运行行为：

| 环境变量名              | 说明                                                                 | 默认值                | 可选值示例                          |
|-------------------------|----------------------------------------------------------------------|-----------------------|-------------------------------------|
| `SNARE_PORT`            | 容器内监听端口                                                       | 80                    | 8080、8888等                        |
| `SNARE_SERVER_TYPE`     | 模拟的Web服务器类型（影响响应头`Server`字段）                        | `apache/2.4.41`       | `nginx/1.21.0`、`Microsoft-IIS/10.0`|
| `SNARE_LOG_LEVEL`       | 日志级别                                                             | `info`                | `debug`（详细调试日志）、`warn`、`error` |
| `SNARE_SSL_ENABLED`     | 是否启用SSL/TLS（启用时需挂载证书）                                  | `false`               | `true`                              |
| `SNARE_SSL_PORT`        | SSL监听端口（仅`SNARE_SSL_ENABLED=true`时生效）                     | 443                   | 8443等                              |
| `SNARE_RESPONSE_DIR`    | 自定义响应页面目录（容器内路径，需通过`-v`挂载宿主机目录）           | `/etc/snare/responses`| 宿主机自定义页面目录路径            |


#### 4.3.2 配置文件挂载
通过`-v`挂载宿主机目录至容器，自定义响应页面或SSL证书：
- **响应页面自定义**：将宿主机存放HTML/PHP页面的目录挂载至`/etc/snare/responses`，Snare将根据请求路径返回对应文件（如请求`/admin.php`时返回`/etc/snare/responses/admin.php`）。
- **SSL证书挂载**：启用SSL时，需将宿主机SSL证书（`cert.pem`，公钥）和私钥（`key.pem`）挂载至`/etc/snare/ssl`目录，证书需为PEM格式。


### 4.4 日志与数据持久化
Snare攻击日志默认输出至容器内`/var/log/snare/snare.log`（JSON格式），包含请求时间、客户端IP、请求方法、URL、请求头等字段。通过`-v /host/path:/var/log/snare`挂载宿主机目录，实现日志持久化：

```bash
docker run -d \
  --name tpot-snare \
  -p 80:80 \
  -v /data/snare/logs:/var/log/snare \  # 宿主机日志目录
  telekomsecurity/tpot-snare:latest
```


## 5. 示例：Docker Compose配置

以下为独立部署Snare的`docker-compose.yml`示例，包含日志持久化与SSL配置：

```yaml
version: '3'

services:
  snare:
    image: telekomsecurity/tpot-snare:latest
    container_name: tpot-snare
    restart: unless-stopped
    ports:
      - "80:80"       # HTTP端口映射
      - "443:443"     # HTTPS端口映射（启用SSL时）
    environment:
      - SNARE_SERVER_TYPE=nginx/1.21.0
      - SNARE_LOG_LEVEL=debug
      - SNARE_SSL_ENABLED=true
    volumes:
      - ./snare_logs:/var/log/snare       # 本地日志目录挂载
      - ./snare_ssl:/etc/snare/ssl        # SSL证书目录（cert.pem、key.pem）
      - ./snare_responses:/etc/snare/responses  # 自定义响应页面目录
    networks:
      - snare_network

networks:
  snare_network:
    driver: bridge
```

启动命令：`docker-compose up -d`


## 5. 注意事项
- **资源隔离**：蜜罐应部署于独立网络环境，避免被攻击者用作跳板攻击其他系统。
- **数据安全**：捕获的攻击日志可能包含敏感信息（如攻击者IP、Payload），需加密存储并限制访问权限。
- **镜像更新**：定期拉取最新镜像（`docker pull telekomsecurity/tpot-snare:latest`），获取功能更新与安全修复。

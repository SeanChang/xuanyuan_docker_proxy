---
image: zabbix/zabbix-web-service
description: "Zabbix Web服务，通过无头浏览器执行各类任务（如报告生成）。"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-service
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-service
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-web-service" title="zabbix/zabbix-web-service Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-web-service 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Zabbix web service Docker镜像文档


## 1. 镜像概述和主要用途

### 1.1 Zabbix简介
Zabbix是企业级开源分布式监控解决方案，可监控网络参数、服务器健康状态及完整性。其提供灵活的通知机制，支持基于事件配置邮件告警，便于快速响应服务器问题，并具备强大的报表和数据可视化功能，适用于容量规划。

### 1.2 Zabbix web service概述
Zabbix web service是Zabbix生态的组件之一，用于通过无头浏览器（Headless Browser）执行各类任务，例如报告生成等需网页渲染的操作。


## 2. 核心功能和特性

### 2.1 核心功能
- 支持通过无头浏览器处理Zabbix报告生成任务
- 与Zabbix server集成，接收并处理来自server的请求
- 提供可配置的网络通信和安全策略

### 2.2 主要特性
- **多基础镜像支持**：基于Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10及Oracle Linux 10构建
- **版本兼容性**：支持Zabbix 6.0、7.0、7.2、7.4及8.0（开发版）系列
- **可配置网络**：暴露标准端口10053，支持IP访问控制
- **安全特性**：支持TLS加密通信，可配置证书和密钥
- **灵活部署**：通过环境变量自定义配置，无需修改配置文件
- **日志可观测性**：容器日志直接输出Zabbix web service运行状态


## 3. 使用场景和适用范围

### 适用场景
- 企业级监控系统中需自动生成可视化报告的场景
- Zabbix server需集成网页渲染能力处理复杂图表或PDF导出的环境
- 需与Zabbix server分离部署，独立扩展报告处理能力的架构

### 适用范围
- 各类基于Zabbix的监控部署（物理机、虚拟机、容器环境）
- 对报告生成效率有要求的中大型监控集群
- 需要TLS加密通信的安全合规场景


## 4. 使用方法和配置说明

### 4.1 镜像标签说明
官方镜像基于不同Linux发行版和Zabbix版本提供以下标签（部分示例）：

| Zabbix版本 | 基础镜像       | 标签格式                     | 最新版标签示例               |
|------------|----------------|------------------------------|------------------------------|
| 6.0        | Alpine/Ubuntu/Oracle Linux | alpine-6.0.* / ubuntu-6.0.* / ol-6.0.* | alpine-6.0-latest            |
| 7.0        | Alpine/Ubuntu/Oracle Linux | alpine-7.0.* / ubuntu-7.0.* / ol-7.0.* | ubuntu-7.0-latest            |
| 7.4（最新稳定版） | Alpine/Ubuntu/Oracle Linux | alpine-7.4.* / ubuntu-7.4.* / ol-7.4.* | alpine-latest / latest       |
| 8.0（开发版） | Alpine/Ubuntu/Oracle Linux | alpine-trunk / ubuntu-trunk / ol-trunk | ubuntu-trunk                 |

> 完整标签列表参见[Docker Hub标签页](https://hub.docker.com/r/zabbix/zabbix-web-service/tags/)


### 4.2 快速启动容器
使用以下命令启动Zabbix web service容器：

```bash
docker run --name some-zabbix-web-service \
  -e ZBX_ALLOWEDIP="192.168.1.100" \  # 允许访问的Zabbix server IP或DNS
  --cap-add=SYS_ADMIN \  # 解决Chromium命名空间限制
  -p 10053:10053 \       # 暴露服务端口
  -d zabbix/zabbix-web-service:latest
```

> **注意**：`--cap-add=SYS_ADMIN` 用于解决无头Chromium运行时可能出现的"Operation not permitted"错误。


### 4.3 与Zabbix server容器集成
通过容器链接或网络使Zabbix server访问web service，示例如下：

1. 创建自定义网络（推荐）：
```bash
docker network create zabbix-net
```

2. 启动web service：
```bash
docker run --name zabbix-web-service \
  --network zabbix-net \
  -e ZBX_ALLOWEDIP="zabbix-server" \  # 允许Zabbix server容器访问
  --cap-add=SYS_ADMIN \
  -d zabbix/zabbix-web-service:latest
```

3. 启动Zabbix server并配置web service：
```bash
docker run --name zabbix-server \
  --network zabbix-net \
  -e ZBX_STARTREPORTWRITERS="2" \  # 启动2个报告进程
  -e ZBX_WEBSERVICEURL="http://zabbix-web-service:10053/report" \  # web service地址
  -d zabbix/zabbix-server:latest
```


### 4.4 容器管理与日志查看
#### 容器shell访问
通过`docker exec`进入容器内部：
```bash
docker exec -ti some-zabbix-web-service /bin/bash
```

#### 查看运行日志
通过Docker日志命令查看web service输出：
```bash
docker logs some-zabbix-web-service
```


### 4.5 环境变量配置
容器支持通过环境变量自定义配置，常用参数如下：

| 环境变量                | 默认值          | 说明                                                                 |
|-------------------------|-----------------|----------------------------------------------------------------------|
| `ZBX_ALLOWEDIP`         | `zabbix-server` | 允许访问的Zabbix server IP或DNS，支持逗号分隔的列表                   |
| `ZBX_LISTENPORT`        | `10053`         | 服务监听端口                                                         |
| `ZBX_DEBUGLEVEL`        | `3`             | 调试级别（0-5，0=基本信息，5=详细调试）                             |
| `ZBX_TIMEOUT`           | `3`             | 请求处理超时时间（秒）                                               |
| `ZBX_TLSACCEPT`         | `unencrypted`   | TLS接受模式（`unencrypted`/`tls`/`both`）                            |
| `ZBX_IGNOREURLCERTERRORS` | `0`            | 是否忽略URL证书错误（0=不忽略，1=忽略）                              |
| `ZBX_TLSCAFILE`         | -               | TLS CA证书文件路径（需挂载卷到`/var/lib/zabbix/enc`）                |
| `ZBX_TLSCERTFILE`       | -               | TLS证书文件路径                                                      |
| `ZBX_TLSKEYFILE`        | -               | TLS私钥文件路径                                                      |

> 更多参数说明参见[zabbix_web_service.conf官方文档](https://www.zabbix.com/documentation/current/manual/appendix/config/zabbix_web_service)


### 4.6 数据卷挂载
#### 支持的卷路径
| 卷路径                  | 用途                                  | 示例挂载命令                          |
|-------------------------|---------------------------------------|---------------------------------------|
| `/var/lib/zabbix/enc`   | 存储TLS证书、CA文件等加密相关文件     | `-v /host/path/to/tls:/var/lib/zabbix/enc` |


### 4.7 Docker Compose配置示例
以下是Zabbix server与web service集成的`docker-compose.yml`示例：

```yaml
version: '3.8'

services:
  zabbix-web-service:
    image: docker.xuanyuan.run/zabbix/zabbix-web-service:latest
    container_name: zabbix-web-service
    restart: always
    environment:
      - ZBX_ALLOWEDIP=zabbix-server  # 允许zabbix-server服务访问
      - ZBX_DEBUGLEVEL=3             # 调试级别
      - ZBX_TIMEOUT=5                # 超时时间5秒
    cap_add:
      - SYS_ADMIN                    # 解决Chromium权限问题
    ports:
      - "10053:10053"
    volumes:
      - ./tls:/var/lib/zabbix/enc    # 挂载TLS证书目录
    networks:
      - zabbix-net

  zabbix-server:
    image: docker.xuanyuan.run/zabbix/zabbix-server:latest
    container_name: zabbix-server
    restart: always
    environment:
      - ZBX_STARTREPORTWRITERS=2     # 启动2个报告进程
      - ZBX_WEBSERVICEURL=http://zabbix-web-service:10053/report  # web service地址
    depends_on:
      - zabbix-web-service
    networks:
      - zabbix-net

networks:
  zabbix-net:
    driver: bridge
```


## 5. 镜像变体说明

### 5.1 Alpine Linux变体（`alpine-*`标签）
- **基础**：Alpine Linux v3.22
- **特点**：超小镜像体积（~5MB基础镜像），适合对镜像大小敏感的场景
- **注意**：使用musl libc而非glibc，部分依赖glibc的软件可能存在兼容性问题
- **适用场景**：资源受限环境、轻量级部署


### 5.2 Ubuntu变体（`ubuntu-*`标签）
- **基础**：Ubuntu 24.04（noble）
- **特点**：基于glibc，兼容性好，预装常用系统工具
- **适用场景**：需要广泛软件兼容性的通用部署


### 5.3 Oracle Linux变体（`ol-*`标签）
- **基础**：Oracle Linux 10
- **特点**：针对企业级 workload 优化，支持Ksplice（零停机内核补丁）、DTrace等特性
- **适用场景**：Oracle生态环境、企业级关键业务部署


## 6. 支持的Docker版本
- 官方支持Docker 1.12.0及以上版本
- 旧版本（1.6及以上）提供有限兼容支持
- 升级Docker引擎参见[官方安装文档](https://docs.docker.com/installation/)


## 7. 用户反馈与贡献

### 7.1 文档
镜像相关文档存储于[zabbix-docker仓库](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/web-service)的`web-service/`目录。


### 7.2 已知问题
- **Chromium权限错误**：启动时若出现`Failed to move to new namespace: Operation not permitted`，需添加`--cap-add=SYS_ADMIN`权限。
- **TLS配置问题**：证书文件需确保容器内路径与`ZBX_TLS*FILE`变量匹配，且权限正确。


### 7.3 贡献方式
- 通过[GitHub Issues](https://github.com/zabbix/zabbix-docker/issues)提交问题或功能建议
- 代码贡献需通过Pull Request提交至官方仓库，建议先通过Issue讨论设计方案


## 8. 许可协议
- **Zabbix 7.0及以上版本**：采用GNU Affero General Public License v3（AGPLv3），允许修改和分发，但衍生作品需保持开源。
- **Zabbix 6.4及以下版本**：采用GNU General Public License v2（GPLv2）。
- 许可协议详情参见[FSF官方说明](http://www.fsf.org/licenses/)。

> 商业使用建议购买Zabbix技术支持，以支持项目持续开发。

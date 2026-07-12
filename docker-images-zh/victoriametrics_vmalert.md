---
image: victoriametrics/vmalert
description: "为VictoriaMetrics评估Prometheus告警与记录规则并触发告警的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/victoriametrics/vmalert
canonical: https://xuanyuan.cloud/zh/r/victoriametrics/vmalert
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/victoriametrics/vmalert" title="victoriametrics/vmalert Docker 镜像中文简介、标签列表与拉取命令">victoriametrics/vmalert 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# vmalert Docker镜像文档

<img src="https://victoriametrics.com/icons/apple-touch-icon.webp" width="150" alt="VictoriaMetrics logo"/>

[![加入 SLACK 社区](https://img.shields.io/badge/加入%20SLACK%20社区-621773?style=for-the-badge&logo=slack&logoColor=white)](https://inviter.co/victoriametrics/)
[![在 GitHub 提交 Bug](https://img.shields.io/badge/在%20GitHub%20提交%20Bug-E94600?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)
[![源代码](https://img.shields.io/badge/源代码-323232?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vminsert)

## 镜像概述和主要用途

`vmalert` 是一款用于评估 Prometheus 兼容告警规则和记录规则的服务。它定期查询 VictoriaMetrics 数据源，根据数据评估规则，当告警条件满足时，会向配置的 Alertmanager 实例发送通知。

## 核心功能和特性

- **Prometheus 规则兼容**：支持评估 Prometheus 格式的告警规则和记录规则
- **定期数据查询**：周期性从 VictoriaMetrics 数据源获取数据进行规则评估
- **告警触发与通知**：当告警条件满足时，向 Alertmanager 发送通知
- **灵活的规则配置**：通过 YAML 格式的规则文件定义告警和记录规则

## 使用场景和适用范围

- 与 VictoriaMetrics 配合，实现对监控数据的告警规则评估
- 需要自定义告警逻辑和记录规则的监控系统
- 需将告警通知发送至 Alertmanager 进行统一处理的场景
- 适用于需要 Prometheus 风格告警规则但使用 VictoriaMetrics 作为后端存储的环境

## 使用方法

`vmalert` 需要规则配置文件、用于查询的数据源以及发送告警的通知器 URL。

### Docker Run 示例

使用本地规则文件运行 `vmalert`：

```bash
docker run -d --name vmalert -p 8880:8880 \
  -v /path/to/rules:/etc/rules \
  docker.xuanyuan.run/victoriametrics/vmalert:latest \
  -rule=/etc/rules/*.yml \
  -datasource.url=http://<victoriametrics-addr>:8428 \
  -notifier.url=http://<alertmanager-addr>:9093
```

### Docker Compose 示例

以下是包含 `vmalert`、VictoriaMetrics 和 Alertmanager 的完整部署示例：

```yaml
version: '3'

services:
  vmalert:
    image: docker.xuanyuan.run/victoriametrics/vmalert:latest
    container_name: vmalert
    ports:
      - "8880:8880"
    volumes:
      - ./rules:/etc/rules  # 挂载本地规则目录
    command:
      - -rule=/etc/rules/*.yml  # 加载所有YAML规则文件
      - -datasource.url=http://victoriametrics:8428  # 连接VictoriaMetrics
      - -notifier.url=http://alertmanager:9093  # 连接Alertmanager
      - -httpListenAddr=0.0.0.0:8880  # 监听所有网络接口
    depends_on:
      - victoriametrics
      - alertmanager

  victoriametrics:
    image: docker.xuanyuan.run/victoriametrics/victoria-metrics:latest
    container_name: victoriametrics
    ports:
      - "8428:8428"
    volumes:
      - victoriametrics-data:/storage  # 持久化存储数据

  alertmanager:
    image: docker.xuanyuan.run/prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/config.yml:/etc/alertmanager/config.yml  # Alertmanager配置

volumes:
  victoriametrics-data:
```

## 配置说明

### 核心配置参数

| 参数                 | 描述                                                                 | 默认值       | 示例值                                  |
|----------------------|----------------------------------------------------------------------|--------------|-----------------------------------------|
| `-rule`              | YAML 格式的告警/记录规则文件或目录路径，可多次指定                   | 无           | `/etc/rules/*.yml`                      |
| `-datasource.url`    | 用于规则评估的 VictoriaMetrics 数据源 URL                            | 无           | `http://victoriametrics:8428`           |
| `-notifier.url`      | 接收告警的 Alertmanager 兼容通知器 URL                               | 无           | `http://alertmanager:9093`              |
| `-httpListenAddr`    | `vmalert` Web 界面的 TCP 监听地址                                    | `:8880`      | `0.0.0.0:8880`                          |

### 参数详细说明

- **`-rule`**：指定规则文件或目录，支持通配符。可多次指定以加载多个规则文件，例如 `-rule=/etc/rules/alert.yml -rule=/etc/rules/record.yml`。
- **`-datasource.url`**：必填参数，指向 VictoriaMetrics 实例的 HTTP 接口（通常为 `:8428` 端口），用于查询评估规则所需的监控数据。
- **`-notifier.url`**：必填参数，指向 Alertmanager 的 HTTP 接口（通常为 `:9093` 端口），用于发送触发的告警通知。
- **`-httpListenAddr`**：配置 `vmalert` 自身 Web 界面的监听地址，用于访问规则状态、评估指标等信息，默认监听所有网络接口的 8880 端口。

## 获取帮助

- [加入 SLACK 社区](https://inviter.co/victoriametrics/)
- [在 GitHub 提交 Bug](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)

## 源代码

`vmalert` 的源代码位于 VictoriaMetrics GitHub 仓库：[https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmalert](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmalert)

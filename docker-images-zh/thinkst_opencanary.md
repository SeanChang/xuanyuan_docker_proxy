---
image: thinkst/opencanary
description: "OpenCanary的官方Docker容器，用于部署蜜罐服务，模拟多种网络服务以检测和记录未授权访问尝试，帮助增强网络安全监控能力。"
source: https://xuanyuan.cloud/zh/r/thinkst/opencanary
canonical: https://xuanyuan.cloud/zh/r/thinkst/opencanary
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/thinkst/opencanary" title="thinkst/opencanary Docker 镜像中文简介、标签列表与拉取命令">thinkst/opencanary — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/thinkst/opencanary" title="thinkst/opencanary Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/thinkst/opencanary</a>

# OpenCanary 官方Docker镜像文档

## 镜像概述

OpenCanary是一款开源蜜罐工具，旨在通过模拟常见网络服务（如SSH、HTTP、FTP等）来吸引并记录未授权访问活动，从而帮助安全团队识别潜在的网络威胁。本Docker镜像为OpenCanary的官方容器化部署方案，提供了轻量级、可移植的蜜罐服务运行环境，简化了传统部署流程，便于快速集成到现有安全监控架构中。

## 核心功能与特性

### 1. 多类型蜜罐服务模拟
- 支持模拟多种常见网络服务，包括但不限于SSH、Telnet、HTTP、HTTPS、FTP、SMB、MySQL等，覆盖主流网络协议。
- 可配置服务端口与行为特征，模拟真实服务响应，提高蜜罐欺骗性。

### 2. 细粒度访问日志记录
- 详细记录所有针对蜜罐服务的访问尝试，包括来源IP、访问时间、请求内容、认证尝试（如用户名/密码）等关键信息。
- 日志支持多种输出格式，便于集成至ELK Stack、Splunk等日志分析平台进行集中管理与威胁分析。

### 3. 灵活的配置管理
- 支持通过配置文件自定义蜜罐服务类型、端口、响应策略及告警规则，满足不同场景下的监控需求。
- 配置变更无需重启容器即可生效（部分配置需重载服务）。

### 4. 轻量级与可移植性
- 基于轻量级基础镜像构建，容器体积小，资源占用低，适合在各类环境（物理机、虚拟机、云服务器）中部署。
- 遵循Docker容器标准，支持跨平台运行（Linux、Windows、macOS）及容器编排工具（Kubernetes、Docker Swarm）集成。

## 使用场景与适用范围

### 企业网络安全监控
- 部署于企业内部网络边界或关键业务网段，作为“诱饵”检测内网横向移动、未授权访问等异常行为。
- 结合SIEM系统（如ELK、IBM QRadar）实现安全事件自动告警与可视化分析。

### 安全研究与威胁情报收集
- 安全研究人员可通过部署该镜像，收集新型攻击手法、恶意IP/域名样本及攻击载荷特征，辅助威胁情报库建设。

### 渗透测试与安全演练
- 在红队/蓝队对抗演练中，作为目标环境的“陷阱”，评估渗透测试人员的攻击路径与检测能力。

### 小型网络与个人安全防护
- 个人用户或小型组织可通过简单配置快速部署蜜罐，增强家庭网络或小型办公网络的安全监控能力。

## 使用方法与配置说明

### 前提条件
- 已安装Docker Engine（20.10+版本推荐）或Docker Desktop。
- 具备基本Docker命令操作能力（如`docker run`、`docker-compose`）。

### 快速启动（docker run）
通过以下命令可快速启动OpenCanary容器，默认配置下将模拟基础网络服务：

```bash
docker run -d \
  --name opencanary \
  -p 2222:2222 \  # SSH蜜罐端口（示例）
  -p 8080:8080 \  # HTTP蜜罐端口（示例）
  -v $(pwd)/opencanary-config:/etc/opencanary \  # 挂载本地配置目录（可选）
  -v $(pwd)/opencanary-logs:/var/log/opencanary \  # 挂载日志目录（可选）
  opencanary/opencanary:latest
```

> 说明：默认配置可能仅启用部分基础服务，建议通过挂载本地配置文件自定义服务类型与端口映射。

### Docker Compose配置（推荐）
使用`docker-compose.yml`可更便捷地管理容器配置，支持多容器协同与配置持久化：

```yaml
version: '3'
services:
  opencanary:
    image: opencanary/opencanary:latest
    container_name: opencanary
    restart: always
    ports:
      - "21:21"       # FTP服务
      - "22:2222"     # SSH服务（容器内端口2222）
      - "80:8080"     # HTTP服务
      - "3306:3306"   # MySQL服务
    volumes:
      - ./config:/etc/opencanary  # 本地配置目录挂载
      - ./logs:/var/log/opencanary  # 日志持久化
    environment:
      - TZ=Asia/Shanghai  # 设置时区（可选）
      - LOG_LEVEL=INFO    # 日志级别（DEBUG/INFO/WARNING/ERROR）
```

启动命令：
```bash
docker-compose up -d
```

### 配置参数与环境变量

#### 核心配置文件
OpenCanary的行为主要通过配置文件`opencanary.conf`定义，该文件位于容器内`/etc/opencanary/`目录。通过挂载本地配置目录（如上述`-v $(pwd)/opencanary-config:/etc/opencanary`），可自定义以下关键配置项：

- `services`：启用的蜜罐服务列表（如`ssh`, `http`, `ftp`等）。
- 各服务的端口、监听地址、响应策略（如`ssh.port: 2222`）。
- `logger`：日志输出配置（文件路径、日志级别、远程日志服务器地址等）。

#### 环境变量
容器支持通过环境变量调整基础运行参数：

| 环境变量名       | 描述                          | 默认值                  |
|------------------|-------------------------------|-------------------------|
| `CONFIG_PATH`    | 配置文件路径                  | `/etc/opencanary/opencanary.conf` |
| `LOG_LEVEL`      | 日志级别（DEBUG/INFO/WARNING/ERROR） | `INFO`                  |
| `TZ`             | 容器时区                      | `UTC`                   |

### 数据持久化与日志管理

#### 配置文件持久化
为避免容器重启后配置丢失，建议将本地配置目录挂载至容器`/etc/opencanary`：
```bash
-v /path/to/local/config:/etc/opencanary
```
首次启动时，容器会自动生成默认配置文件至挂载目录，可直接修改该文件进行自定义配置。

#### 日志数据持久化
访问日志默认存储于容器`/var/log/opencanary/`目录，挂载本地目录实现日志持久化：
```bash
-v /path/to/local/logs:/var/log/opencanary
```

#### 日志查看方法
通过Docker命令直接查看容器日志：
```bash
docker logs -f opencanary  # 实时查看日志
docker exec -it opencanary cat /var/log/opencanary/opencanary.log  # 查看日志文件
```

## 注意事项

- **端口冲突**：部署时需确保宿主机端口未被其他服务占用，可通过修改端口映射（如`-p 2222:22`改为`-p 2022:22`）避免冲突。
- **安全风险**：蜜罐服务可能吸引恶意流量，建议部署于隔离网段或防火墙后，避免直接暴露至公网（除非用于特定威胁情报收集场景）。
- **配置更新**：修改配置文件后，需重启容器使配置生效：`docker restart opencanary`。

## 参考链接

- [OpenCanary官方文档](https://opencanary.org/docs/)
- [OpenCanary GitHub仓库](https://github.com/thinkst/opencanary)

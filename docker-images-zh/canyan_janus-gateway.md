---
image: canyan/janus-gateway
description: "Janus WebRTC Server是基于Debian buster构建的开源通用WebRTC服务器Docker镜像，支持Linux系统（macOS可编译安装，Windows需WSL），提供实时音视频通信等WebRTC核心功能，适用于构建实时互动应用。"
source: https://xuanyuan.cloud/zh/r/canyan/janus-gateway
canonical: https://xuanyuan.cloud/zh/r/canyan/janus-gateway
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/canyan/janus-gateway" title="canyan/janus-gateway Docker 镜像中文简介、标签列表与拉取命令">canyan/janus-gateway 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Janus WebRTC Server Docker镜像文档

## 镜像概述和主要用途

本镜像提供基于Debian buster构建的全功能[Janus WebRTC Server](https://github.com/meetecho/janus-gateway) Docker镜像。Janus是由[Meetecho](http://www.meetecho.com)开发的开源通用WebRTC服务器，主要设计用于Linux系统，也可编译安装在macOS上，Windows不直接支持但可在Windows 10的"Windows Subsystem for Linux"中运行。该镜像便于快速部署和使用Janus WebRTC服务器，支持实时音视频通信等WebRTC相关应用场景。

## 核心功能和特性

- **开源通用**：Janus是开源项目，提供通用WebRTC服务器功能，支持多种实时通信场景
- **跨平台兼容**：主要支持Linux系统，macOS可编译安装，Windows可通过WSL运行
- **多标签版本**：提供多种镜像标签，满足不同版本需求：
  - `latest`：指向最新稳定版本
  - 完整版本号（如`0.10.7`）：特定稳定版本
  - 主版本号（如`0.10`）：对应主版本系列
  - `master`：主分支的每日重建版本
- **可配置性**：支持通过挂载配置文件自定义Janus服务器参数

## 使用场景和适用范围

适用于需要构建实时音视频通信功能的应用场景，包括但不限于：
- 视频会议系统
- 实时直播平台
- 在线教育互动课堂
- 远程协作工具
- 实时监控系统
- 社交应用中的音视频聊天功能

## 使用方法和配置说明

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/canyan/janus-gateway:latest
```

### Docker Compose配置示例

```yaml
version: '2.1'
services:
  # Janus WebRTC服务器
  janus-gateway:
    image: 'docker.xuanyuan.run/canyan/janus-gateway:0.10.7'  # 可替换为其他标签版本
    command: ["/usr/local/bin/janus", "-F", "/usr/local/etc/janus"]  # 启动命令，指定配置文件目录
    ports:
      - "8088:8088"  # HTTP API端口
      - "8089:8089"  # HTTPS API端口
      - "8889:8889"  # WebSocket端口
      - "8000:8000"  # 媒体端口（RTP/RTCP）
      - "7088:7088"  # 管理API端口
      - "7089:7089"  # 安全管理API端口
    volumes:
      - "./etc/janus/janus.jcfg:/usr/local/etc/janus/janus.jcfg"  # 主配置文件挂载
      - "./etc/janus/janus.eventhandler.sampleevh.jcfg:/usr/local/etc/janus/janus.eventhandler.sampleevh.jcfg"  # 事件处理器配置文件挂载
    restart: always  # 自动重启策略
```

### 配置说明

- **端口映射**：根据实际需求映射Janus的各类端口，包括API端口、媒体端口和管理端口
- **配置文件挂载**：通过 volumes 挂载自定义配置文件，覆盖默认配置，主要配置文件包括：
  - `janus.jcfg`：Janus主配置文件
  - 事件处理器配置文件（如`janus.eventhandler.sampleevh.jcfg`）
- **版本选择**：根据需求选择合适的镜像标签，生产环境建议使用特定版本号标签（如`0.10.7`）以确保稳定性

## 作者信息

本Dockerfile由Canyan.io维护。Canyan Rating是一个开源实时高可扩展评分系统，由Agent Service、API和Rating Engine组成，旨在解决实时计费系统的可用性、完整性和认证挑战，采用云原生微服务架构，支持容器化部署。

## 相关资源

- Janus项目官网：[https://janus.conf.meetecho.com/](https://janus.conf.meetecho.com/)
- 讨论组：[meetecho-janus Google Group](https://groups.google.com/forum/#!forum/meetecho-janus)
- 问题反馈：[GitHub Issues](https://github.com/meetecho/janus-gateway/issues)
- Canyan Rating文档：[https://canyanio.github.io/rating-integration/](https://canyanio.github.io/rating-integration/)

## 许可协议

Canyan遵循GNU General Public License version 3许可协议，详见[LICENSE](https://canyanio.github.io/rating-integration/license/)。

## 安全披露

如发现安全问题，请通过[security@canyan.io](mailto:security@canyan.io)联系我们。

## 联系我们

- Twitter：[@canyan_io](https://twitter.com/canyan_io)
- LinkedIn：[Canyan](https://www.linkedin.com/company/canyan/)
- Slack：[http://slack.canyan.io](http://slack.canyan.io)
- GitHub：[canyanio](https://github.com/canyanio)
- 邮箱：[info@canyan.io](mailto:info@canyan.io)

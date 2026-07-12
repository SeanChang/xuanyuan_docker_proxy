---
image: wavefronthq/proxy
description: "在Docker中运行Wavefront代理程序，用于接收Wavefront标准行格式消息并与Wavefront API实例通信。"
source: https://xuanyuan.cloud/zh/r/wavefronthq/proxy
canonical: https://xuanyuan.cloud/zh/r/wavefronthq/proxy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wavefronthq/proxy" title="wavefronthq/proxy Docker 镜像中文简介、标签列表与拉取命令">wavefronthq/proxy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Wavefront Proxy Docker镜像文档

## 镜像概述
Wavefront Proxy Docker镜像提供了在Docker环境中运行Wavefront代理的便捷方式。该代理用于接收符合Wavefront标准行格式的消息，并将数据转发至Wavefront API实例，实现监控数据的收集与传输。

## 核心功能与特性
- 接收Wavefront标准行格式的消息
- 通过环境变量配置与Wavefront API实例的连接
- 暴露标准端口用于消息接收

## 使用场景
适用于需要在Docker环境中集成Wavefront监控系统的场景，可用于收集容器化应用或服务的监控数据，并将其发送至Wavefront平台进行分析和可视化。

## 使用方法与配置说明

### 环境变量（必填）
- `WAVEFRONT_URL` - Wavefront API实例的URL。
- `WAVEFRONT_TOKEN` - 从Wavefront用户个人资料页面获取的API令牌。

### 标准端口
- `2878` - Wavefront代理接收Wavefront标准行格式消息的端口。

### 示例用法
使用以下命令运行Wavefront Proxy容器：
```bash
docker run -d -e WAVEFRONT_URL=https://try.wavefront.com/api/ -e WAVEFRONT_TOKEN=YOUR_API_TOKEN -p 2878:2878 docker.xuanyuan.run/wavefronthq/proxy:latest
```

### 高级配置
有关更多配置选项，请参见官方文档：[在容器中配置代理](https://docs.wavefront.com/proxies_configuring.html#configuring-a-proxy-in-a-container)

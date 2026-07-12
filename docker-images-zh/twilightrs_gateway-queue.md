---
image: twilightrs/gateway-queue
description: "用于多服务机器人的限流网关队列，通过管理分片重连请求避免Discord网关的限流问题，支持跨进程协调和max_concurrency特性。"
source: https://xuanyuan.cloud/zh/r/twilightrs/gateway-queue
canonical: https://xuanyuan.cloud/zh/r/twilightrs/gateway-queue
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/twilightrs/gateway-queue" title="twilightrs/gateway-queue Docker 镜像中文简介、标签列表与拉取命令">twilightrs/gateway-queue 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Gateway Queue 镜像文档

## 概述
Gateway Queue是一个轻量级HTTP服务器，专为多进程管理的Discord机器人设计，用于排队分片重连请求，避免因同时重连导致的网关限流问题。它与库和语言无关，可集成到任何需要协调分片重连的机器人架构中。

## 核心功能与特性
- **轻量级HTTP服务**：无需复杂配置，通过简单HTTP请求即可使用
- **跨进程协调**：在多进程管理分片时，统一处理重连请求
- **自动限流处理**：遵循Discord网关5秒会话创建限流规则，确保分片重连不被限流
- **max_concurrency支持**：通过提供Discord令牌，自动支持Discord网关的max_concurrency特性

## 使用场景
适用于采用多进程架构管理Discord机器人分片的场景，特别是当多个进程的分片需要重连时，避免因并发重连导致的网关限流问题。

## 使用方法与配置说明

### 环境变量
Gateway Queue通过环境变量进行配置，主要参数如下：
- `HOST`：服务器绑定的主机地址，默认为`0.0.0.0`
- `PORT`：服务器监听的端口，默认为`5000`
- `DISCORD_TOKEN`（可选）：Discord机器人令牌，用于启用max_concurrency特性支持

### 运行容器
使用以下命令启动Gateway Queue容器：
```sh
docker run -itd -e HOST=0.0.0.0 -e PORT=5000 -e DISCORD_TOKEN="your_bot_token" docker.xuanyuan.run/twilightrs/gateway-queue
```

### API调用示例
当分片需要重连时，向Gateway Queue发送HTTP请求，请求将被排队，直到允许重连时返回响应：
```rust
// Rust示例（使用reqwest库）
reqwest::get("http://gateway-queue:5000").await?;
```
请求无需特定HTTP方法、头或请求体，所有请求都会被处理并排队。成功响应示例：
```json
{"message": "You're free to connect now! :)"}

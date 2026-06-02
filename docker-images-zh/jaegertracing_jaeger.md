---
image: jaegertracing/jaeger
description: "（实验性）Jaeger 第二代是基于 OpenTelemetry 收集器构建的分布式追踪系统，旨在整合开源可观测性工具链，优化分布式系统的追踪数据采集、处理与分析流程，为开发与运维团队提供更高效的分布式链路追踪能力，目前处于实验阶段，持续探索基于 OpenTelemetry 生态的追踪技术创新与实践应用。"
source: https://xuanyuan.cloud/zh/r/jaegertracing/jaeger
canonical: https://xuanyuan.cloud/zh/r/jaegertracing/jaeger
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jaegertracing/jaeger" title="jaegertracing/jaeger Docker 镜像中文简介、标签列表与拉取命令">jaegertracing/jaeger 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# jaeger  

Jaeger V2 基于 OpenTelemetry Collector 构建。相关介绍可查看[博客文章]()。  


## 快速试用  

### 1. 下载配置文件  
从指定地址下载 `docker-compose.yml` 文件，示例命令：  
```bash  
curl -O []  
```  


### 2. （可选）获取最新镜像版本  
如需使用最新版本，可先从 [Jaeger 下载页面]([]) 查看最新镜像版本号，然后通过环境变量 `JAEGER_VERSION` 和 `HOTROD_VERSION` 传递。  
若未设置这两个变量，`docker compose` 会默认使用 `latest` 标签。首次下载时用 `latest` 没问题，但本地镜像缓存后，`latest` 标签不会自动更新，可能导致运行过时（且可能不兼容）的 Jaeger 和 HotROD 应用版本。  


### 3. 启动服务  
运行以下命令启动 Jaeger 后端和 HotROD 演示应用：  
```bash  
JAEGER_VERSION=2.0.0 HOTROD_VERSION=1.63.0 docker compose -f docker-compose.yml up  
```  


### 4. 访问服务  
- Jaeger UI：访问 [[]]([])  
- HotROD 应用：访问 [[]]([])  


### 5. 关闭与清理  
使用以下命令停止服务并清理：  
```bash  
docker compose -f docker-compose.yml down  
```

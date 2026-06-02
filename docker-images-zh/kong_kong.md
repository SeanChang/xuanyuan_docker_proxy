---
image: kong/kong
description: "Kong官方构建的Kong OSS（开源API网关）Docker镜像，由Kong官方维护，官方Docker Hub仓库地址：https://hub.docker.com/_/kong。"
source: https://xuanyuan.cloud/zh/r/kong/kong
canonical: https://xuanyuan.cloud/zh/r/kong/kong
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kong/kong" title="kong/kong Docker 镜像中文简介、标签列表与拉取命令">kong/kong — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kong/kong" title="kong/kong Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kong/kong</a>

# Kong OSS 官方Docker镜像

## 概述
Kong OSS（Open Source Software）是Kong Inc.开发的云原生、高性能API网关，用于管理、保护和扩展API及微服务。本镜像由Kong官方构建并维护，确保与Kong OSS最新稳定版本同步，可直接从[Docker Hub官方仓库](https://hub.docker.com/_/kong)获取。

## 使用场景
- API生命周期管理：包括请求路由、版本控制、文档集成等。
- 流量控制：实现限流、熔断、负载均衡，保障服务稳定性。
- 安全防护：提供认证（如JWT、OAuth2）、授权、请求验证、SSL/TLS终止等。
- 微服务与云原生架构：适配Kubernetes、Docker Swarm等容器编排平台，支持服务网格集成。

## 特性
- **官方认证**：由Kong官方构建，确保版本一致性和安全性。
- **高性能**：基于Nginx构建，支持高并发请求处理，低延迟。
- **可扩展性**：通过插件系统扩展功能，支持自定义插件开发。
- **轻量级**：优化镜像体积，适合容器化部署和资源受限环境。
- **多平台支持**：提供多种架构镜像（如amd64、arm64），适配不同运行环境。

## Docker部署示例
### 基本运行
```bash
docker run -d --name kong-oss -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 8444:8444 kong:latest
```
*说明：默认暴露8000（HTTP流量）、8443（HTTPS流量）、8001（管理API HTTP）、8444（管理API HTTPS）端口。*

### 使用环境变量配置
通过环境变量自定义Kong配置：
```bash
docker run -d --name kong-oss \
  -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 8444:8444 \
  -e "KONG_DATABASE=off" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  kong:latest
```

### 挂载配置文件
将本地配置文件挂载到容器中：
```bash
docker run -d --name kong-oss \
  -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 8444:8444 \
  -v /path/to/kong.conf:/etc/kong/kong.conf \
  kong:latest kong start -c /etc/kong/kong.conf
```

## 官方资源
- Docker Hub仓库：[https://hub.docker.com/_/kong](https://hub.docker.com/_/kong)
- Kong OSS官方文档：[https://docs.konghq.com/gateway/latest/oss/](https://docs.konghq.com/gateway/latest/oss/)

---
注：使用前请参考官方文档获取最新配置选项和最佳实践。

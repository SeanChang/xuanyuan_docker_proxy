---
image: playwright/chromium
description: "为Moon软件设计的Playwright Chromium镜像，提供浏览器自动化运行环境。"
source: https://xuanyuan.cloud/zh/r/playwright/chromium
canonical: https://xuanyuan.cloud/zh/r/playwright/chromium
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/playwright/chromium" title="playwright/chromium Docker 镜像中文简介、标签列表与拉取命令">playwright/chromium 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker镜像文档：Moon专用Playwright Chromium镜像


## 1. 镜像概述

本镜像为Moon软件（https://aerokube.com/moon/）专用的Playwright Chromium镜像，基于Playwright官方Chromium环境构建，仅用于与Moon软件配合提供Web自动化测试能力。**该镜像无法独立运行，必须与Moon软件集成使用**。

> 注意：Playwright官方团队镜像请参考：https://hub.docker.com/_/microsoft-playwright


## 2. 核心功能与特性

### 2.1 核心功能
- **Moon集成支持**：深度适配Moon软件架构，提供测试任务调度、资源管理的原生支持
- **Chromium环境**：内置指定版本的Chromium浏览器，满足Web自动化测试的浏览器环境需求
- **Playwright工具链**：包含Playwright测试框架运行时依赖，支持Playwright API调用
- **隔离执行环境**：每个测试任务运行在独立容器环境中，避免测试干扰


## 3. 使用场景与适用范围

### 3.1 适用场景
- **Moon平台Web自动化测试**：作为Moon集群节点，执行基于Playwright的Chromium浏览器测试任务
- **持续集成/持续部署（CI/CD）**：集成至CI/CD流程，通过Moon调度执行自动化测试用例
- **多实例并发测试**：配合Moon的分布式能力，实现多Chromium实例并行测试，提升测试效率
- **浏览器兼容性验证**：在标准化Chromium环境中验证Web应用兼容性


## 4. 使用方法与配置说明

### 4.1 前置条件
- 已部署Moon软件集群（参考：https://aerokube.com/moon/docs/）
- Docker环境版本≥19.03
- 网络可访问Moon集群控制节点


### 4.2 基础使用（Docker Run）

通过`docker run`命令启动镜像并连接至Moon集群（需替换`<moon-control-plane-address>`为实际Moon控制平面地址）：

```bash
docker run --rm \
  --network=moon-network \  # 需与Moon集群使用同一网络
  -e MOON_CONTROL_PLANE=<moon-control-plane-address> \  # Moon控制平面地址
  aerokube/moon-playwright-chromium:latest  # 具体镜像标签需与Moon版本匹配
```


### 4.3 Docker Compose配置示例

在Moon集群的`docker-compose.yml`中添加该镜像作为worker节点：

```yaml
version: '3.8'

services:
  moon-playwright-chromium:
    image: docker.xuanyuan.run/aerokube/moon-playwright-chromium:latest
    networks:
      - moon-network
    environment:
      - MOON_CONTROL_PLANE=http://moon-control-plane:4444  # Moon控制平面地址
      - MOON_WORKER_ID=worker-chromium-01  # 自定义worker标识（可选）
    restart: unless-stopped

networks:
  moon-network:
    external: true  # 引用Moon集群现有网络
```


### 4.4 配置参数说明

| 参数类别       | 说明                                                                 |
|----------------|----------------------------------------------------------------------|
| 网络配置       | 必须与Moon集群处于同一网络，确保控制平面与worker节点通信             |
| 环境变量       | 主要通过`MOON_CONTROL_PLANE`指定Moon控制平面地址，其他参数需参考Moon官方文档 |
| 镜像标签       | 需与Moon软件版本匹配，具体版本兼容性信息见Moon release notes          |


## 5. 注意事项

- **依赖限制**：该镜像**仅能与Moon软件配合使用**，无法单独作为Playwright测试环境运行
- **版本兼容性**：镜像标签需与Moon集群版本严格匹配，避免因版本不兼容导致功能异常
- **资源需求**：单实例建议分配至少2GB内存、2核CPU，具体根据并发测试任务量调整
- **官方镜像区分**：本镜像与Playwright官方镜像（https://hub.docker.com/_/microsoft-playwright）无关联，请勿混淆使用

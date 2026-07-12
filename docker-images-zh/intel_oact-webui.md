---
image: intel/oact-webui
description: "Open AMT Cloud Toolkit的示例Web界面，用于展示和演示该工具包的功能。"
source: https://xuanyuan.cloud/zh/r/intel/oact-webui
canonical: https://xuanyuan.cloud/zh/r/intel/oact-webui
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/oact-webui" title="intel/oact-webui Docker 镜像中文简介、标签列表与拉取命令">intel/oact-webui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Open AMT Cloud Toolkit - Sample Web UI 镜像文档


## 镜像概述和主要用途

Open AMT Cloud Toolkit - Sample Web UI 是一个基于 Open AMT Cloud Toolkit UI Toolkit 构建的示例 Web 用户界面镜像。该镜像旨在提供直观的参考实现，展示如何利用 UI Toolkit 快速构建与 Open AMT Cloud Toolkit 后端服务集成的 Web 应用，帮助开发者理解和掌握基于 Open AMT 技术的远程设备管理界面开发方法。


## 核心功能和特性

### 核心功能
- 提供与 Open AMT Cloud Toolkit 后端服务的无缝集成接口
- 展示设备远程管理的核心操作界面（如设备列表、状态监控、远程控制等）
- 实现基础的用户交互流程（如设备筛选、详情查看、操作触发等）

### 特性
- **开箱即用的示例界面**：无需从零开发，直接运行即可查看前端交互效果
- **与后端服务解耦设计**：通过配置可灵活对接不同环境的 Open AMT Cloud Toolkit 后端
- **模块化代码结构**：示例代码遵循最佳实践，便于开发者学习和定制扩展
- **响应式布局**：适配不同终端设备的显示需求


## 使用场景和适用范围

### 主要使用场景
- **开发者学习参考**：作为前端开发模板，学习如何使用 UI Toolkit 构建与 Open AMT Cloud Toolkit 集成的 Web 界面
- **功能演示环境**：快速部署演示 Open AMT 远程设备管理的前端交互流程
- **二次开发基础**：基于示例代码进行定制化开发，满足特定业务需求

### 适用范围
- Open AMT Cloud Toolkit 技术栈的初学者和开发者
- 需要快速验证远程设备管理前端功能的测试环境
- 企业 IT 团队评估 Open AMT 技术集成可行性的原型环境


## 详细使用方法和配置说明

### 前提条件
- 已安装 Docker Engine（20.10+ 版本）或 Docker Desktop
- 已部署 Open AMT Cloud Toolkit 后端服务（如 RPS、MPS 等），并可访问其 API 接口
- 网络环境允许容器访问后端服务 API 端口（默认 3000）


### Docker 快速启动

#### docker run 命令示例
```bash
docker run -d \
  --name open-amt-sample-webui \
  -p 8080:80 \
  -e REACT_APP_API_URL=http://your-backend-api:3000 \
  -e REACT_APP_PORT=80 \
  docker.xuanyuan.run/openamt/sample-webui:latest
```

#### docker-compose 配置示例
创建 `docker-compose.yml` 文件：
```yaml
version: '3.8'

services:
  sample-webui:
    image: docker.xuanyuan.run/openamt/sample-webui:latest
    container_name: open-amt-sample-webui
    ports:
      - "8080:80"
    environment:
      - REACT_APP_API_URL=http://your-backend-api:3000  # 后端 API 基础地址
      - REACT_APP_PORT=80                               # 容器内服务端口
      - REACT_APP_AUTH_ENABLED=false                    # 是否启用认证（默认 false）
      - REACT_APP_DEVICE_REFRESH_INTERVAL=5000          # 设备状态刷新间隔（毫秒，默认 5000）
    restart: unless-stopped
```
启动服务：
```bash
docker-compose up -d
```


### 环境变量说明
| 环境变量名                  | 描述                                   | 默认值          | 示例值                          |
|---------------------------|----------------------------------------|-----------------|---------------------------------|
| `REACT_APP_API_URL`       | Open AMT Cloud Toolkit 后端 API 基础地址 | `http://localhost:3000` | `http://amt-backend.example.com:3000` |
| `REACT_APP_PORT`          | 容器内 Web 服务监听端口                 | `80`            | `8080`                          |
| `REACT_APP_AUTH_ENABLED`  | 是否启用用户认证功能                   | `false`         | `true`                          |
| `REACT_APP_DEVICE_REFRESH_INTERVAL` | 设备状态自动刷新间隔（毫秒）        | `5000`          | `10000`                         |
| `REACT_APP_LOG_LEVEL`     | 日志输出级别（debug/info/warn/error）  | `info`          | `debug`                         |


### 配置参数
| 参数名          | 描述                     | 数据类型 | 默认值 |
|-----------------|--------------------------|----------|--------|
| `contextPath`   | Web 应用上下文路径       | string   | `/`    |
| `timeout`       | API 请求超时时间（毫秒） | number   | `5000` |


## 相关文档和资源
- [Open AMT Cloud Toolkit 官方文档](https://open-amt-cloud-toolkit.github.io/docs/)
- [UI Toolkit 开发指南](https://open-amt-cloud-toolkit.github.io/docs/guides/webui)
- [Open AMT Cloud Toolkit GitHub 仓库](https://github.com/open-amt-cloud-toolkit)

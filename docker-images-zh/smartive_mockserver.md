---
image: smartive/mockserver
description: "基于Node.js的简单Web和邮件模拟服务器，用于开发和测试环境中模拟HTTP请求和邮件发送功能。"
source: https://xuanyuan.cloud/zh/r/smartive/mockserver
canonical: https://xuanyuan.cloud/zh/r/smartive/mockserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/smartive/mockserver" title="smartive/mockserver Docker 镜像中文简介、标签列表与拉取命令">smartive/mockserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述

本镜像是一个基于Node.js构建的轻量级Web和邮件模拟服务器，旨在为开发和测试流程提供便捷的服务模拟能力。它允许开发者在没有实际后端服务或邮件服务器的情况下，快速搭建模拟环境，验证应用的Web交互和邮件发送功能。

## 核心功能和特性

- **Web服务模拟**：支持模拟RESTful API接口，可自定义HTTP响应状态码、响应头及响应体内容
- **邮件服务模拟**：捕获应用发送的邮件，提供邮件内容查看功能，无需配置真实SMTP服务器
- **轻量级设计**：基于Node.js运行时，镜像体积小巧，启动速度快，资源占用低
- **灵活配置**：支持通过环境变量或配置文件定义模拟规则，适应不同测试场景
- **跨平台兼容**：采用容器化部署，可在Linux、Windows、macOS等支持Docker的环境中运行

## 使用场景和适用范围

- **前端开发测试**：前端开发过程中模拟后端API响应，独立于后端进度进行界面调试
- **应用集成测试**：在自动化测试中模拟第三方服务接口或邮件发送流程，确保测试环境一致性
- **邮件功能验证**：测试应用的邮件发送逻辑，查看邮件内容、格式及收件人信息
- **教学与演示**：在教学或技术演示中，快速搭建服务交互场景，降低环境依赖复杂度

## 使用方法和配置说明

### 基本部署（docker run）

```bash
docker run -d -p 3000:3000 -p 25:25 --name web-mail-mockserver docker.xuanyuan.run/node-web-mail-mockserver
```

- `-p 3000:3000`：映射Web服务端口（容器内默认Web服务端口为3000）
- `-p 25:25`：映射邮件服务SMTP端口（容器内默认SMTP端口为25）
- `--name web-mail-mockserver`：指定容器名称，便于后续管理

### 环境变量配置

通过环境变量可自定义服务运行参数，常用配置项如下：

| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `WEB_PORT` | Web服务监听端口 | 3000 |
| `SMTP_PORT` | 邮件服务SMTP端口 | 25 |
| `MOCK_RESPONSE_DELAY` | 模拟响应延迟时间（毫秒） | 0 |
| `CORS_ALLOWED_ORIGINS` | 允许的跨域请求源（逗号分隔） | * |
| `MAIL_STORAGE_PATH` | 邮件数据存储路径（容器内） | /app/mail-data |

#### 自定义配置示例

```bash
docker run -d \
  -p 8080:8080 \
  -p 2525:25 \
  -e WEB_PORT=8080 \
  -e MOCK_RESPONSE_DELAY=500 \
  -e CORS_ALLOWED_ORIGINS=https://example.com,http://localhost \
  --name custom-mockserver \
  docker.xuanyuan.run/node-web-mail-mockserver
```

### 数据持久化

如需持久化保存模拟规则或邮件数据，可通过数据卷挂载实现：

```bash
docker run -d \
  -p 3000:3000 \
  -p 25:25 \
  -v ./mock-config:/app/config \
  -v ./mail-storage:/app/mail-data \
  --name persistent-mockserver \
  docker.xuanyuan.run/node-web-mail-mockserver
```

- `./mock-config:/app/config`：挂载宿主机目录存储自定义模拟规则配置文件
- `./mail-storage:/app/mail-data`：挂载宿主机目录持久化保存捕获的邮件数据

### docker-compose配置示例

```yaml
version: '3.8'
services:
  mockserver:
    image: docker.xuanyuan.run/node-web-mail-mockserver
    ports:
      - "3000:3000"  # Web服务端口
      - "25:25"      # SMTP邮件端口
    environment:
      - WEB_PORT=3000
      - SMTP_PORT=25
      - MOCK_RESPONSE_DELAY=200
    volumes:
      - ./local-config:/app/config
      - ./local-mail-data:/app/mail-data
    restart: unless-stopped
```

### 访问与使用

- **Web服务访问**：通过 `http://<宿主机IP>:3000` 访问Web管理界面，可配置API模拟规则
- **邮件查看**：通过Web界面的邮件管理模块（通常位于 `/mail` 路径）查看捕获的邮件内容
- **邮件发送测试**：应用中配置SMTP服务器地址为 `smtp://<宿主机IP>:25`，发送邮件后可在模拟服务器中查看

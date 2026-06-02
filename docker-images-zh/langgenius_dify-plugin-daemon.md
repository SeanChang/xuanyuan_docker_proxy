---
image: langgenius/dify-plugin-daemon
description: "langgenius/dify-plugin-daemon：Dify 平台的插件守护进程核心组件，负责插件的生命周期管理与任务执行，支持插件注册、任务调度与依赖环境封装；是 Dify 插件功能生效的关键中间件，需与 dify-api、dify-web 等组件协同工作，仅支持 Linux/arm64 架构。"
source: https://xuanyuan.cloud/zh/r/langgenius/dify-plugin-daemon
canonical: https://xuanyuan.cloud/zh/r/langgenius/dify-plugin-daemon
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/langgenius/dify-plugin-daemon" title="langgenius/dify-plugin-daemon Docker 镜像中文简介、标签列表与拉取命令">langgenius/dify-plugin-daemon — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/langgenius/dify-plugin-daemon" title="langgenius/dify-plugin-daemon Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/langgenius/dify-plugin-daemon</a>

# langgenius/dify-plugin-daemon 镜像使用指南

## 一、镜像概述与核心定位

`langgenius/dify-plugin-daemon` 是 Dify 平台的核心组件之一，专门作为「插件守护进程（Plugin Daemon）」运行，负责 Dify 平台所有插件的生命周期管理与任务执行。Dify 是一款开源的大语言模型（LLM）应用开发平台，通过插件扩展功能，连接第三方 API 与工具能力，而此镜像正是插件功能从“配置”到“落地”的关键中间件。

### 核心作用

- **插件生命周期管理**：接收 Dify 平台（如 dify-web、dify-api）的插件配置指令，完成插件的注册、更新、禁用等操作，确保插件与平台的联动一致性
- **插件任务执行**：当用户在 Dify 中触发插件功能（如调用“天气查询”“文档解析”“GitHub 搜索”等插件）时，后台接收任务请求、调用插件逻辑/接口执行并返回结果
- **依赖环境封装**：内置插件运行所需的基础依赖（Python 运行时、插件通信协议库等），支持离线部署无需额外安装插件依赖

## 二、技术特性与架构支持

### 2.1 架构与端口配置

| 维度 | 详细信息 |
| --- | --- |
| **支持架构** | 仅支持 Linux/arm64 架构（x86 架构需额外适配） |
| **默认端口** | 5002-5003 端口（用于与 Dify 其他组件通信，不可随意修改） |
| **部署角色** | Dify 完整部署的必选组件（与 dify-api、dify-web、dify-sandbox 等并列） |
| **常见版本** | 0.0.2-local、0.0.6-local、0.0.9-local（需与 Dify 版本匹配，如 Dify 1.3.1 对应 0.0.9-local） |

### 2.2 与其他组件的协同关系

该镜像作为 Dify 生态的核心一环，工作流程如下：

```
用户操作（dify-web）
    ↓
API 转发（dify-api）
    ↓
插件任务调度（dify-plugin-daemon） ← 本镜像核心功能
    ↓
安全执行（可选，dify-sandbox）
    ↓
结果返回
```

**实际案例**：用户在 Dify 网页端调用“GitHub 搜索”插件 → dify-api 接收请求 → 转发给 dify-plugin-daemon → 守护进程调用 GitHub API → 结果返回给用户

## 三、使用场景

### 3.1 在线部署场景

配合 Dify 源码或 docker-compose 模板，搭建完整的插件支持能力：

```bash
# 使用官方 docker-compose 部署（需包含本镜像）
git clone https://github.com/langgenius/dify.git
cd dify/docker
docker-compose up -d
```

### 3.2 离线部署场景

在联网环境下先下载镜像并打包，再拷贝到内网环境使用：

```bash
# 1. 联网环境：拉取镜像
docker pull langgenius/dify-plugin-daemon:latest

# 2. 导出镜像为 tar 文件
docker save langgenius/dify-plugin-daemon:latest -o dify-plugin-daemon.tar

# 3. 拷贝到内网环境后加载
# 在内网服务器执行：
docker load -i dify-plugin-daemon.tar
```

## 四、前置准备

### 4.1 硬件与软件要求

| 项目 | 要求 |
| --- | --- |
| **操作系统** | Linux（推荐 Ubuntu 20.04+），需支持 arm64 架构 |
| **容器工具** | Docker 19.03+ 或 docker-compose |
| **网络环境** | 在线部署需可访问 Docker Hub 或镜像仓库 |
| **存储空间** | 建议预留 ≥500MB（仅镜像本身） |

### 4.2 依赖组件

**必选组件**（需在 docker-compose 中同时部署）：
- `dify-api`：API 服务组件
- `dify-web`：Web 前端界面
- `dify-db`：PostgreSQL 数据库（或使用外部数据库）
- `dify-redis`：Redis 缓存（或使用外部 Redis）

**可选组件**：
- `dify-sandbox`：安全执行沙箱（用于隔离插件运行环境）

## 五、部署与启动

### 5.1 通过 docker-compose 部署（推荐）

`dify-plugin-daemon` 通常作为完整 Dify 平台的一部分部署，使用官方 docker-compose 配置：

```yaml
# docker-compose.yml 关键片段
services:
  # 其他组件...
  
  dify-plugin-daemon:
    image: langgenius/dify-plugin-daemon:0.0.9-local
    container_name: dify-plugin-daemon
    ports:
      - "5002:5002"
      - "5003:5003"
    environment:
      - DIFY_API_URL=http://dify-api:5001
      - REDIS_URL=redis://dify-redis:6379
      - DATABASE_URL=postgresql://dify:dify@dify-db:5432/dify
    volumes:
      - ./volumes/app/plugins:/app/plugins
    depends_on:
      - dify-api
      - dify-db
      - dify-redis
    networks:
      - dify
```

启动完整 Dify 平台：

```bash
cd /path/to/dify/docker
docker-compose up -d
```

### 5.2 独立容器运行（高级用法）

如需单独测试该组件，可手动启动容器：

```bash
docker run -d \
  --name dify-plugin-daemon \
  -p 5002:5002 \
  -p 5003:5003 \
  -e DIFY_API_URL=http://your-api-url:5001 \
  -e REDIS_URL=redis://your-redis:6379 \
  -e DATABASE_URL=postgresql://user:pass@your-db:5432/dify \
  -v ./plugins:/app/plugins \
  langgenius/dify-plugin-daemon:0.0.9-local
```

### 5.3 版本选择建议

| Dify 版本 | 推荐 dify-plugin-daemon 版本 |
| --- | --- |
| 1.3.1 | 0.0.9-local |
| 1.2.x | 0.0.6-local |
| 1.1.x | 0.0.2-local |

> 版本需严格匹配，否则可能导致插件功能异常

## 六、配置与环境变量

### 6.1 核心环境变量

| 变量名 | 必填 | 说明 | 示例 |
| --- | --- | --- | --- |
| `DIFY_API_URL` | 是 | Dify API 服务地址 | `http://dify-api:5001` |
| `REDIS_URL` | 是 | Redis 连接地址 | `redis://dify-redis:6379` |
| `DATABASE_URL` | 是 | 数据库连接地址 | `postgresql://user:pass@dify-db:5432/dify` |
| `LOG_LEVEL` | 否 | 日志级别 | `INFO`（默认） |
| `PLUGIN_WORKER_COUNT` | 否 | 插件工作进程数 | `4`（默认） |

### 6.2 配置文件挂载（可选）

如需自定义插件配置，可挂载配置文件：

```bash
-v /宿主机/配置文件路径:/app/config
```

## 七、验证与监控

### 7.1 容器状态检查

```bash
# 查看容器运行状态
docker ps | grep dify-plugin-daemon

# 查看日志
docker logs -f dify-plugin-daemon

# 进入容器调试
docker exec -it dify-plugin-daemon /bin/bash
```

### 7.2 功能验证

1. 在 Dify Web 界面中安装并使用插件（如“天气查询”）
2. 检查日志中是否出现插件任务执行记录
3. 验证插件功能是否正常返回结果

### 7.3 健康检查

该镜像通常提供健康检查端点（需参考官方文档），可配置在 docker-compose 中：

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:5002/health"]
  interval: 30s
  timeout: 10s
  retries: 3
```

## 八、常见问题与解决方案（FAQ）

| 问题现象 | 可能原因 | 解决方案 |
| --- | --- | --- |
| 容器启动失败 | 环境变量配置错误 | 检查 `DIFY_API_URL`、`REDIS_URL`、`DATABASE_URL` 是否正确 |
| 插件无法执行 | 端口冲突或网络问题 | 确保 5002-5003 端口未被占用；检查与其他组件的网络连接 |
| 架构不支持 | 在 x86 服务器上运行 | 仅支持 arm64，需切换到支持 arm64 的环境或等待官方提供 x86 版本 |
| 版本不匹配 | dify-plugin-daemon 与 Dify 版本不一致 | 根据 Dify 版本选择对应的镜像版本 |
| 插件依赖缺失 | 离线部署未正确加载依赖 | 确保使用正确的镜像版本，内置依赖已封装 |
| 无法连接 API | 其他组件未启动 | 确保 dify-api、dify-db、dify-redis 已正常运行 |

## 九、进阶配置

### 9.1 自定义插件目录

默认插件目录为 `/app/plugins`，可挂载自定义目录：

```bash
-v /宿主机/自定义插件目录:/app/plugins
```

### 9.2 调整性能参数

通过环境变量调整插件工作进程数：

```bash
-e PLUGIN_WORKER_COUNT=8
```

### 9.3 启用调试模式

设置日志级别为 DEBUG 以获取详细日志：

```bash
-e LOG_LEVEL=DEBUG
```

## 十、参考资源

- **Dify 官方网站**：<https://dify.ai/>
- **Dify GitHub 仓库**：<https://github.com/langgenius/dify>
- **Dify 官方文档**：<https://docs.dify.ai/>
- **Dify 部署指南**：<https://docs.dify.ai/getting-started/install-self-hosted>
- **Dify 插件开发文档**：<https://docs.dify.ai/extensions/plugins>

---

**注意**：`langgenius/dify-plugin-daemon` 是 Dify 平台的专用组件，通常不独立使用，建议通过官方 docker-compose 方式进行部署。如需单独调试该组件，请确保相关依赖组件（API、数据库、Redis）已正确配置并运行。

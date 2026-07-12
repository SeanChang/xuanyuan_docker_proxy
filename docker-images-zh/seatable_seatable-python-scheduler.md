---
image: seatable/seatable-python-scheduler
description: "SeaTable Python脚本调度器镜像，用于自动化调度执行SeaTable平台的Python脚本。"
source: https://xuanyuan.cloud/zh/r/seatable/seatable-python-scheduler
canonical: https://xuanyuan.cloud/zh/r/seatable/seatable-python-scheduler
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/seatable/seatable-python-scheduler" title="seatable/seatable-python-scheduler Docker 镜像中文简介、标签列表与拉取命令">seatable/seatable-python-scheduler 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Seatable Python Pipeline Scheduler 镜像文档


## 镜像概述和主要用途

Seatable Python Pipeline Scheduler 镜像是 Seatable Python Pipeline 组件之一，专门用于调度 Python 脚本的执行。该镜像设计用于在 Seatable 平台环境中安全运行 Python 代码，负责任务调度、执行触发及输出结果的检索与交付。需配合 Docker Compose 与 Seatable 主服务协同工作，具体部署细节可参考 [Seatable 官方管理员文档](https://admin.seatable.com)。


## 核心功能和特性

- **任务调度管理**  
  提供定时或事件触发式的 Python 脚本调度能力，支持自定义执行频率与触发条件。

- **Seatable 深度集成**  
  与 Seatable 平台原生集成，确保脚本在 Seatable 上下文环境中运行，可直接访问 Seatable 数据表、API 及资源。

- **安全执行环境**  
  隔离 Python 代码执行过程，限制资源访问范围，降低恶意代码风险。

- **容器化部署**  
  基于 Docker 容器化设计，轻量便携，易于集成到现有 Seatable 容器化部署架构。


## 使用场景和适用范围

### 适用场景
- Seatable 数据自动化处理（如数据清洗、格式转换、多表关联计算）  
- 定时报表生成与推送（如每日/每周业务数据汇总）  
- 事件触发式脚本执行（如表单提交后自动触发数据校验）  
- 自定义业务逻辑扩展（通过 Python 脚本补充 Seatable 原生功能）

### 适用用户
- Seatable 服务器管理员  
- 需要通过 Python 扩展 Seatable 功能的开发人员  
- 企业 IT 团队（负责 Seatable 平台运维与自动化）


## 使用方法和配置说明

### 前置条件
- 已部署 Seatable 服务器（版本需兼容 Python Pipeline 组件）  
- 安装 Docker 19.03+ 及 Docker Compose 2.0+  
- 拥有 Seatable 管理员权限（用于获取 API 凭证及配置权限）


### Docker Compose 部署示例

创建 `docker-compose.yml` 文件，添加 Scheduler 服务配置：

```yaml
version: '3.8'

services:
  seatable-python-scheduler:
    image: docker.xuanyuan.run/seatable/python-pipeline-scheduler:latest  # 具体镜像标签以官方为准
    container_name: seatable-python-scheduler
    restart: unless-stopped
    environment:
      # 基础配置
      - SEATABLE_URL=https://your-seatable.example.com  # Seatable 服务器完整URL
      - SEATABLE_API_TOKEN=your_admin_api_token  # Seatable 管理员API令牌（通过Seatable后台获取）
      # 调度配置
      - SCHEDULE_INTERVAL=300  # 任务调度检查间隔（秒），默认300秒（5分钟）
      - MAX_CONCURRENT_TASKS=5  # 最大并发执行任务数，默认5
      # 日志配置
      - LOG_LEVEL=INFO  # 日志级别：DEBUG/INFO/WARNING/ERROR
      - LOG_MAX_SIZE=100m  # 单日志文件大小上限
      # 时区配置
      - TZ=Asia/Shanghai  # 容器时区，确保定时任务时间准确
    volumes:
      - ./scheduler-data:/data  # 持久化目录（存储调度任务配置、日志等）
    networks:
      - seatable-network  # 需与 Seatable 主服务在同一网络

networks:
  seatable-network:
    external: true  # 假设已存在 Seatable 主网络（名称需与实际一致）
```


### 环境变量配置说明

| 环境变量名               | 描述                                  | 必需 | 默认值          |
|--------------------------|---------------------------------------|------|-----------------|
| SEATABLE_URL             | Seatable 服务器完整URL（含协议）      | 是   | 无              |
| SEATABLE_API_TOKEN       | Seatable 管理员API令牌                | 是   | 无              |
| SCHEDULE_INTERVAL        | 调度检查间隔（秒）                    | 否   | 300             |
| MAX_CONCURRENT_TASKS     | 最大并发任务数                        | 否   | 5               |
| LOG_LEVEL                | 日志输出级别                          | 否   | INFO            |
| LOG_MAX_SIZE             | 单日志文件大小上限（如100m）          | 否   | 100m            |
| TZ                       | 容器时区（如Asia/Shanghai）           | 否   | UTC             |


### 启动与管理

#### 启动服务
```bash
docker-compose up -d
```

#### 查看日志
```bash
docker-compose logs -f seatable-python-scheduler  # 实时查看日志
```

#### 停止服务
```bash
docker-compose down  # 仅停止服务（保留数据）
# 如需删除数据卷：docker-compose down -v
```


### 注意事项
- **API令牌安全**：SEATABLE_API_TOKEN 需妥善保管，建议通过环境变量注入而非明文存储。  
- **资源限制**：根据任务复杂度调整容器CPU/内存限制（通过 `deploy.resources` 配置）。  
- **版本兼容性**：确保 Scheduler 镜像版本与 Seatable 服务器版本匹配（参考官方兼容性说明）。  
- **任务配置**：具体调度任务需通过 Seatable 管理界面或 API 定义（详见 [Seatable Python Pipeline 任务配置文档](https://admin.seatable.com)）。

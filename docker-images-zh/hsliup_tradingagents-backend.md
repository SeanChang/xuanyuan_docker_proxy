---
image: hsliup/tradingagents-backend
description: "基于多智能体架构的 AI 股票分析系统后端服务"
source: https://xuanyuan.cloud/zh/r/hsliup/tradingagents-backend
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[hsliup/tradingagents-backend](https://xuanyuan.cloud/zh/r/hsliup/tradingagents-backend)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# TradingAgents-CN 后端服务镜像文档

## 概述
本镜像为 TradingAgents-CN 系统的后端服务组件。TradingAgents-CN 是一个基于多智能体架构的 AI 股票分析系统，通过集成多种大语言模型和金融数据源，提供智能化的股票分析与投资决策支持。后端服务基于 FastAPI 框架构建，提供 RESTful API 接口，支持多维度股票分析、实时数据处理和智能体协作。更多项目细节可参考上游仓库：[hsliuping/TradingAgents-CN](https://github.com/hsliuping/TradingAgents-CN)。

## 核心功能与特性
- **多智能体架构**：采用多智能体协作模式，支持多个 AI 智能体协同完成股票分析任务，提升分析效率和准确性。
- **15+ AI 模型支持**：集成国内外主流大语言模型，包括阿里百炼、DeepSeek、OpenAI、百度文心一言、Google Gemini 等，支持灵活切换和组合使用。
- **多维度分析能力**：提供基本面分析、技术面分析、新闻情感分析、社交媒体分析等多维度股票分析功能，全面评估投资价值。
- **多数据源集成**：支持 AKShare、Tushare、BaoStock 等多种金融数据源，可获取实时行情、历史数据、财务指标等丰富信息。
- **RESTful API 服务**：基于 FastAPI 提供高性能的 RESTful API，支持异步处理，便于前端和其他系统集成。
- **数据持久化**：集成 MongoDB 存储分析结果、用户数据、配置信息等，使用 Redis 进行缓存加速，提升系统响应速度。

## 使用场景与适用范围
- **个人投资者**：需要 AI 辅助进行股票分析和投资决策的个人投资者，可通过系统获取多维度的股票分析报告。
- **量化交易团队**：需要集成 AI 分析能力到量化交易策略中的团队，可利用系统的 API 接口进行二次开发。
- **金融研究机构**：需要批量分析股票数据、生成研究报告的机构，可利用系统的多智能体协作能力提升研究效率。
- **教育学习场景**：学习股票分析和 AI 应用的学生和研究者，可通过系统了解 AI 在金融领域的应用实践。

## 使用方法与配置说明

### 系统要求
- **硬件要求**：最低 2 核 CPU、4GB 内存、20GB 磁盘空间；推荐 4 核+ CPU、8GB+ 内存、50GB+ 磁盘空间
- **软件要求**：Docker 20.10+、Docker Compose 2.0+
- **操作系统**：支持 Windows 10+、Linux (Ubuntu 20.04+, CentOS 7+)、macOS (Intel 或 Apple Silicon)

### Docker Compose 部署（推荐）
推荐使用 Docker Compose 一键部署完整系统（包含前端、后端、MongoDB、Redis、Nginx）：

```bash
# 1. 创建项目目录
mkdir -p ~/tradingagents-demo
cd ~/tradingagents-demo

# 2. 下载 Docker Compose 配置文件
wget https://raw.githubusercontent.com/hsliuping/TradingAgents-CN/v1.0.0-preview/docker-compose.hub.nginx.yml

# 3. 下载环境配置文件
wget https://raw.githubusercontent.com/hsliuping/TradingAgents-CN/v1.0.0-preview/.env.docker -O .env

# 4. 配置 API 密钥（必须至少配置一个 LLM）
nano .env  # 编辑 DASHSCOPE_API_KEY 或 DEEPSEEK_API_KEY

# 5. 下载 Nginx 配置文件
mkdir -p nginx
wget https://raw.githubusercontent.com/hsliuping/TradingAgents-CN/v1.0.0-preview/nginx/nginx.conf -O nginx/nginx.conf

# 6. 启动所有服务
docker-compose -f docker-compose.hub.nginx.yml up -d

# 7. 导入初始配置（首次部署必须执行）
docker exec -it tradingagents-backend python scripts/import_config_and_create_user.py
```

> 注：macOS Apple Silicon (M1/M2/M3) 用户必须使用 `docker-compose.hub.nginx.arm.yml` 文件。

### 单独运行后端服务（Docker Run）
如需单独运行后端服务，需要确保 MongoDB 和 Redis 已启动：

```bash
docker run -d \
  --name tradingagents-backend \
  -p 8000:8000 \
  -e MONGODB_URI=mongodb://admin:tradingagents123@mongodb:27017/tradingagents?authSource=admin \
  -e REDIS_URL=redis://redis:6379/0 \
  -e DASHSCOPE_API_KEY=your-api-key \
  -e DEEPSEEK_API_KEY=your-api-key \
  --network tradingagents-network \
  hsliup/tradingagents-backend:latest
```

### Docker Compose 配置示例
```yaml
version: '3.8'

services:
  backend:
    image: hsliup/tradingagents-backend:latest
    container_name: tradingagents-backend
    ports:
      - "8000:8000"
    environment:
      - MONGODB_URI=mongodb://admin:tradingagents123@mongodb:27017/tradingagents?authSource=admin
      - REDIS_URL=redis://redis:6379/0
      - DASHSCOPE_API_KEY=${DASHSCOPE_API_KEY}
      - DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}
      - TUSHARE_TOKEN=${TUSHARE_TOKEN}
    depends_on:
      - mongodb
      - redis
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  mongodb:
    image: mongo:4.4
    container_name: tradingagents-mongodb
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=tradingagents123
    volumes:
      - mongodb_data:/data/db
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: tradingagents-redis
    restart: unless-stopped

volumes:
  mongodb_data:
```

### 配置参数说明
后端服务支持以下主要环境变量配置：

**必需配置（至少配置一个 LLM）**：
- `DASHSCOPE_API_KEY`：阿里百炼 API 密钥（推荐，国内速度快）
- `DEEPSEEK_API_KEY`：DeepSeek API 密钥（推荐，性价比高）
- `OPENAI_API_KEY`：OpenAI API 密钥（需要国外网络）

**数据库配置**：
- `MONGODB_URI`：MongoDB 连接字符串（默认：mongodb://admin:tradingagents123@mongodb:27017/tradingagents?authSource=admin）
- `REDIS_URL`：Redis 连接 URL（默认：redis://redis:6379/0）

**数据源配置（可选）**：
- `TUSHARE_TOKEN`：Tushare 数据源 Token（用于获取更全面的股票数据）
- `TUSHARE_ENABLED`：是否启用 Tushare（true/false）

**其他可选配置**：
- `QIANFAN_API_KEY`：百度文心一言 API 密钥
- `GOOGLE_API_KEY`：Google Gemini API 密钥
- `LOG_LEVEL`：日志级别（默认：INFO）

### 首次部署重要步骤
1. **配置 API 密钥**：编辑 `.env` 文件，至少配置一个 LLM 的 API 密钥，否则无法使用 AI 分析功能
2. **导入初始配置**：执行 `docker exec -it tradingagents-backend python scripts/import_config_and_create_user.py` 导入系统配置和创建管理员账号
3. **默认登录信息**：用户名 `admin`，密码 `admin123`（登录后请立即修改）

## 参考与更多信息
- 项目仓库：[hsliuping/TradingAgents-CN](https://github.com/hsliuping/TradingAgents-CN)
- 部署文档：参考项目仓库中的完整部署指南
- API 文档：启动服务后访问 `http://localhost:8000/docs` 查看 Swagger API 文档
- 数据源注册：
  - Tushare：https://tushare.pro/register?reg=tacn
  - 阿里百炼：https://dashscope.aliyun.com/
  - DeepSeek：https://platform.deepseek.com/

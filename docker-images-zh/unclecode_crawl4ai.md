---
image: unclecode/crawl4ai
description: "Crawl4AI是开源的对大语言模型友好的网络爬虫与抓取工具。"
source: https://xuanyuan.cloud/zh/r/unclecode/crawl4ai
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[unclecode/crawl4ai](https://xuanyuan.cloud/zh/r/unclecode/crawl4ai)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Crawl4AI: 开源LLM友好型网络爬虫与抓取工具

![GitHub Stars](https://img.shields.io/github/stars/unclecode/crawl4ai?style=social)
![Downloads](https://static.pepy.tech/badge/crawl4ai/month)
![Join Discord](https://img.shields.io/badge/Join-Discord-7289.svg?&style=flat&logo=discord&logoColor=white)
![Twitter Follow](https://img.shields.io/twitter/follow/unclecode?style=social)

## 1. 镜像概述和主要用途

Crawl4AI是GitHub上排名第一的趋势性开源项目，由活跃的社区积极维护。它提供针对LLM、AI代理和数据管道优化的高速、AI就绪型网络爬取能力。作为开源工具，Crawl4AI兼具灵活性和实时性能，为开发者提供无与伦比的速度、精度和部署便捷性。

## 2. 核心功能和特性

- **LLM友好设计**：专为大型语言模型和AI应用优化的数据输出格式
- **高性能爬取**：提供极速的网页内容获取能力
- **开源灵活**：完全开源，可根据需求定制和扩展
- **实时处理**：支持实时数据爬取和处理
- **多架构支持**：兼容amd64和arm64架构
- **AI服务集成**：通过.llm.env文件支持OpenAI、Claude、Groq等AI服务
- **Web界面**：内置Playground界面，便于测试和配置
- **API支持**：提供标准API和流式API两种调用方式

## 3. 使用场景和适用范围

- **LLM应用开发**：为大型语言模型提供高质量训练或推理数据
- **AI代理构建**：作为AI代理的信息获取模块
- **数据管道建设**：构建网页数据采集的数据管道
- **智能内容提取**：从网页中提取结构化信息
- **研究数据收集**：为各类研究项目收集网络数据
- **市场情报分析**：监控和分析市场相关网页信息

## 4. 详细的使用方法和配置说明

### 4.1 快速启动

使用Docker快速启动Crawl4AI服务：

```bash
docker run -d \
  -p 11235:11235 \
  --name crawl4ai \
  --shm-size=3g \
  unclecode/crawl4ai:latest
```

服务启动后，访问以下地址打开Web控制台：
[http://localhost:11235/playground](http://localhost:11235/playground)

Web控制台提供了测试爬取、调整配置和为AI代理生成JSON的界面。

### 4.2 从Docker Hub拉取镜像

```bash
# 拉取最新版本
docker pull unclecode/crawl4ai:latest

# 拉取特定版本
docker pull unclecode/crawl4ai:0.6.0rc1-r1
```

### 4.3 API调用示例

#### 4.3.1 标准API调用

```bash
curl -X POST http://localhost:11235/crawl \
  -H "Content-Type: application/json" \
  -d '{"urls": ["https://example.com"]}'
```

#### 4.3.2 流式API调用

```bash
curl -N -X POST http://localhost:11235/crawl/stream \
  -H "Content-Type: application/json" \
  -d '{"urls": ["https://example.com"], "crawler_config": {"type": "CrawlerRunConfig", "params": {"stream": true}}}'
```

### 4.4 Docker Compose配置示例

```yaml
version: '3.8'

services:
  crawl4ai:
    image: unclecode/crawl4ai:latest
    container_name: crawl4ai
    ports:
      - "11235:11235"
    shm_size: "3g"
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./llm.env:/app/.llm.env
      - crawl4ai_data:/app/data

volumes:
  crawl4ai_data:
```

### 4.5 环境变量配置

创建`.llm.env`文件配置AI服务：

```
OPENAI_API_KEY=your_openai_api_key
CLAUDE_API_KEY=your_claude_api_key
GROQ_API_KEY=your_groq_api_key
```

### 4.6 高级配置

通过API调用时可以传递配置参数：

```json
{
  "urls": ["https://example.com"],
  "crawler_config": {
    "type": "CrawlerRunConfig",
    "params": {
      "stream": true,
      "depth": 2,
      "max_pages": 10,
      "timeout": 30
    }
  }
}
```

## 5. 完整文档和支持

### 5.1 官方文档

完整文档请访问：[docs.crawl4ai.com](https://docs.crawl4ai.com)

文档包含以下内容：
- 配置参数调整
- 浏览器配置文件使用
- 自定义过滤器编写
- 大规模部署指南

### 5.2 获取支持

- **GitHub仓库**：[https://github.com/unclecode/crawl4ai](https://github.com/unclecode/crawl4ai)
- **Discord社区**：[https://discord.gg/jP8KfhDhyN](https://discord.gg/jP8KfhDhyN)
- **X(Twitter)**：[@unclecode](https://x.com/unclecode)

## 6. 版本信息

| 版本标签 | 说明 |
|---------|------|
| latest | 最新稳定版 |
| 0.6.0rc1-r1 | 特定版本示例 |

## 7. 系统要求

- Docker Engine: 20.10.0+
- 内存: 至少4GB
- 磁盘空间: 至少1GB
- 网络: 能够访问互联网以拉取镜像和爬取网页

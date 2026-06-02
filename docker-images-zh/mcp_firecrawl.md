---
image: mcp/firecrawl
description: "官方Firecrawl MCP服务器，为Cursor、Claude等工具提供强大的网页抓取与搜索功能。"
source: https://xuanyuan.cloud/zh/r/mcp/firecrawl
canonical: https://xuanyuan.cloud/zh/r/mcp/firecrawl
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/firecrawl" title="mcp/firecrawl Docker 镜像中文简介、标签列表与拉取命令">mcp/firecrawl — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mcp/firecrawl" title="mcp/firecrawl Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mcp/firecrawl</a>

# Firecrawl MCP Server

## 镜像概述和主要用途

Firecrawl MCP Server 是官方的 MCP（模型上下文协议）服务器，可为 Cursor、Claude 及其他 LLM 客户端提供强大的网页抓取和搜索功能。通过该服务器，LLM 客户端能够集成网页内容提取、网站映射、结构化数据抽取等能力，扩展其处理网络信息的能力。

[什么是 MCP 服务器？](https://www.anthropic.com/news/model-context-protocol)


## 核心功能和特性

### 镜像特性
| 属性 | 详情 |
|------|------|
| **Docker 镜像** | [mcp/firecrawl](https://hub.docker.com/repository/docker/mcp/firecrawl) |
| **作者** | [firecrawl](https://github.com/firecrawl) |
| **代码仓库** | https://github.com/mendableai/firecrawl-mcp-server |
| **Dockerfile** | https://github.com/mendableai/firecrawl-mcp-server/blob/main/Dockerfile |
| **镜像构建方** | Docker Inc. |
| **Docker Scout 健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/firecrawl) |
| **验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/firecrawl --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证** | MIT License |

### 核心功能
- 提供 6 种网页处理工具，覆盖抓取、爬取、结构化提取、网站映射、搜索等场景
- 支持多页面内容提取与单页面精准爬取
- 集成 LLM 能力实现结构化数据抽取
- 提供网站 URL 发现与映射功能
- 支持网页搜索及结果内容提取
- 可配置重试机制、缓存策略等高级选项


## 使用场景和适用范围

### 适用场景
- **多页面内容提取**：需全面覆盖网站多个相关页面内容（使用 `firecrawl_crawl`）
- **单页面精准爬取**：已知具体 URL，需快速获取内容（使用 `firecrawl_scrape`）
- **结构化数据抽取**：从网页中提取特定格式数据（如产品信息、价格等，使用 `firecrawl_extract`）
- **网站URL发现**：获取网站所有索引URL（使用 `firecrawl_map`）
- **网页搜索**：跨网站查找特定信息（使用 `firecrawl_search`）
- **爬取任务监控**：跟踪多页面爬取进度（使用 `firecrawl_check_crawl_status`）

### 不适用场景
- 单页面爬取使用 `firecrawl_crawl`（应使用 `firecrawl_scrape`）
- 已知URL列表批量爬取使用 `firecrawl_scrape` 多次调用（建议使用批量爬取方案）
- 对响应大小敏感场景使用 `firecrawl_crawl`（可能超出LLM token限制，建议 `firecrawl_map` + 批量 `firecrawl_scrape`）
- 文件系统搜索（工具仅支持网页内容）


## 可用工具

| 工具名称 | 简短描述 |
|----------|----------|
| `firecrawl_check_crawl_status` | 检查爬取任务状态 |
| `firecrawl_crawl` | 启动网站爬取任务，提取所有页面内容 |
| `firecrawl_extract` | 使用LLM能力从网页提取结构化信息 |
| `firecrawl_map` | 映射网站以发现所有索引URL |
| `firecrawl_scrape` | 从单个URL爬取内容，支持高级选项 |
| `firecrawl_search` | 搜索网页并可选提取结果内容 |


## 工具详情

### 工具：`firecrawl_check_crawl_status`
检查爬取任务状态。

**使用示例**：
```json
{
  "name": "firecrawl_check_crawl_status",
  "arguments": {
    "id": "550e8400-e29b-41d4-a716-446655440000"
  }
}
```

**返回值**：爬取任务的状态和进度，包含可用结果（如已完成）。

| 参数 | 类型 | 描述 |
|------|------|------|
| `id` | `string` | 爬取任务ID（必填） |


### 工具：`firecrawl_crawl`
启动网站爬取任务，提取所有页面内容。

**最佳用途**：从多个相关页面提取内容，需全面覆盖时使用。  
**不推荐用途**：单页面提取（使用 `firecrawl_scrape`）；对token限制敏感场景（使用 `firecrawl_map` + 批量 `firecrawl_scrape`）；需快速结果场景（爬取可能较慢）。  
**警告**：爬取响应可能非常大，可能超出token限制。建议限制爬取深度和页面数量，或使用 `firecrawl_map` + 批量 `firecrawl_scrape` 以更好控制。  
**常见错误**：`limit` 或 `maxDiscoveryDepth` 设置过高（导致token溢出）或过低（导致遗漏页面）；单页面使用此工具（应使用 `firecrawl_scrape`）；使用 `/*` 通配符。  

**提示示例**："获取 example.com/blog 前两级的所有博客文章。"

**使用示例**：
```json
{
  "name": "firecrawl_crawl",
  "arguments": {
    "url": "https://example.com/blog/*",
    "maxDiscoveryDepth": 5,
    "limit": 20,
    "allowExternalLinks": false,
    "deduplicateSimilarURLs": true,
    "sitemap": "include"
  }
}
```

**返回值**：用于状态检查的操作ID；需使用 `firecrawl_check_crawl_status` 检查进度。

| 参数 | 类型 | 描述 |
|------|------|------|
| `url` | `string` | 爬取起始URL（必填） |
| `allowExternalLinks` | `boolean` | 可选，是否允许外部链接 |
| `allowSubdomains` | `boolean` | 可选，是否允许子域名 |
| `crawlEntireDomain` | `boolean` | 可选，是否爬取整个域名 |
| `deduplicateSimilarURLs` | `boolean` | 可选，是否去重相似URL |
| `delay` | `number` | 可选，请求延迟（毫秒） |
| `excludePaths` | `array` | 可选，排除路径列表 |
| `ignoreQueryParameters` | `boolean` | 可选，是否忽略查询参数 |
| `includePaths` | `array` | 可选，包含路径列表 |
| `limit` | `number` | 可选，最大爬取页面数 |
| `maxConcurrency` | `number` | 可选，最大并发数 |
| `maxDiscoveryDepth` | `number` | 可选，最大发现深度 |
| `prompt` | `string` | 可选，LLM提示 |
| `scrapeOptions` | `object` | 可选，爬取选项 |
| `sitemap` | `string` | 可选，是否包含站点地图（如 "include"） |
| `webhook` | `string` | 可选，结果回调URL |


### 工具：`firecrawl_extract`
使用LLM能力从网页提取结构化信息。支持云AI和自托管LLM提取。

**最佳用途**：从网页中提取特定结构化数据（如价格、名称、详情等）。  
**不推荐用途**：需获取页面完整内容（使用 `firecrawl_scrape`）；无需特定结构化数据时。

**提示示例**："从这些产品页面提取产品名称、价格和描述。"

**使用示例**：
```json
{
  "name": "firecrawl_extract",
  "arguments": {
    "urls": ["https://example.com/page1", "https://example.com/page2"],
    "prompt": "提取产品信息，包括名称、价格和描述",
    "schema": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "price": { "type": "number" },
        "description": { "type": "string" }
      },
      "required": ["name", "price"]
    },
    "allowExternalLinks": false,
    "enableWebSearch": false,
    "includeSubdomains": false
  }
}
```

**返回值**：按指定schema提取的结构化数据。

| 参数 | 类型 | 描述 |
|------|------|------|
| `urls` | `array` | 待提取URL列表（必填） |
| `allowExternalLinks` | `boolean` | 可选，是否允许外部链接 |
| `enableWebSearch` | `boolean` | 可选，是否启用网页搜索补充上下文 |
| `includeSubdomains` | `boolean` | 可选，是否包含子域名 |
| `prompt` | `string` | 可选，LLM提取提示 |
| `schema` | `object` | 可选，结构化数据JSON schema |


### 工具：`firecrawl_map`
映射网站以发现所有索引URL。

**最佳用途**：爬取前发现网站URL；查找网站特定部分URL。  
**不推荐用途**：已知具体URL（使用 `firecrawl_scrape`）；需页面内容（映射后使用 `firecrawl_scrape`）。  
**常见错误**：使用 `firecrawl_crawl` 代替此工具发现URL。

**提示示例**："列出 example.com 的所有URL。"

**使用示例**：
```json
{
  "name": "firecrawl_map",
  "arguments": {
    "url": "https://example.com"
  }
}
```

**返回值**：网站中发现的URL数组。

| 参数 | 类型 | 描述 |
|------|------|------|
| `url` | `string` | 映射起始URL（必填） |
| `ignoreQueryParameters` | `boolean` | 可选，是否忽略查询参数 |
| `includeSubdomains` | `boolean` | 可选，是否包含子域名 |
| `limit` | `number` | 可选，URL数量限制 |
| `search` | `string` | 可选，搜索关键词 |
| `sitemap` | `string` | 可选，是否包含站点地图（如 "include"） |


### 工具：`firecrawl_scrape`
从单个URL爬取内容，支持高级选项。  
这是功能最强、速度最快、最可靠的爬取工具，如有需要，任何网页爬取需求均建议优先使用此工具。

**最佳用途**：单页面内容提取，已知具体页面包含所需信息。  
**不推荐用途**：多页面爬取（使用批量爬取方案）；未知页面（使用 `firecrawl_search`）；结构化数据（使用 `firecrawl_extract`）。  
**常见错误**：对URL列表使用此工具（应使用批量爬取）；如批量爬取不可用，可多次调用此工具。  

**性能优化**：添加 `maxAge` 参数可使用缓存数据，提升500%爬取速度。

**提示示例**："获取 https://example.com 页面的内容。"

**使用示例**：
```json
{
  "name": "firecrawl_scrape",
  "arguments": {
    "url": "https://example.com",
    "formats": ["markdown"],
    "maxAge": 172800000
  }
}
```

**返回值**：指定格式（如markdown、HTML）的页面内容。

| 参数 | 类型 | 描述 |
|------|------|------|
| `url` | `string` | 爬取URL（必填） |
| `actions` | `array` | 可选，页面交互操作列表 |
| `excludeTags` | `array` | 可选，排除的HTML标签 |
| `formats` | `array` | 可选，输出格式（如 ["markdown"]） |
| `includeTags` | `array` | 可选，包含的HTML标签 |
| `location` | `object` | 可选，地理位置信息 |
| `maxAge` | `number` | 可选，缓存最大年龄（毫秒） |
| `mobile` | `boolean` | 可选，是否模拟移动设备 |
| `onlyMainContent` | `boolean` | 可选，是否仅提取主要内容 |
| `parsers` | `array` | 可选，使用的解析器 |
| `removeBase64Images` | `boolean` | 可选，是否移除Base64图片 |
| `skipTlsVerification` | `boolean` | 可选，是否跳过TLS验证 |
| `storeInCache` | `boolean` | 可选，是否存储到缓存 |
| `waitFor` | `number` | 可选，等待时间（毫秒） |


### 工具：`firecrawl_search`
搜索网页并可选提取结果内容。这是功能最强的网页搜索工具，如有需要，任何网页搜索需求均建议优先使用此工具。

**搜索运算符**：

| 运算符 | 功能 | 示例 |
|--------|------|------|
| `""` | 精确匹配字符串 | `"Firecrawl"` |
| `-` | 排除关键词或否定运算符 | `-bad`, `-site:firecrawl.dev` |
| `site:` | 仅返回指定网站结果 | `site:firecrawl.dev` |
| `inurl:` | URL中包含指定词 | `inurl:firecrawl` |
| `allinurl:` | URL中包含多个词 | `allinurl:git firecrawl` |
| `intitle:` | 标题中包含指定词 | `intitle:Firecrawl` |
| `allintitle:` | 标题中包含多个词 | `allintitle:firecrawl playground` |
| `related:` | 返回相关域名结果 | `related:firecrawl.dev` |
| `imagesize:` | 返回指定尺寸图片 | `imagesize:1920x1080` |
| `larger:` | 返回大于指定尺寸图片 | `larger:1920x1080` |

**最佳用途**：跨网站查找特定信息（未知哪个网站包含）；需查询最相关内容时。  
**不推荐用途**：文件系统搜索；已知目标网站（使用 `firecrawl_scrape`）；需全面覆盖单个网站（使用 `firecrawl_map` 或 `firecrawl_crawl`）。  
**常见错误**：对开放式问题使用 `firecrawl_crawl` 或 `firecrawl_map`（应使用此工具）。  

**来源**：web（网页）、images（图片）、news（新闻），默认web，除非需要图片或新闻。  
**爬取选项**：仅在必要时使用 `scrapeOptions`，建议限制 `limit` 为5或更低以避免超时。

**提示示例**："查找2023年发表的最新AI研究论文。"

**使用示例（无格式）**：
```json
{
  "name": "firecrawl_search",
  "arguments": {
    "query": "top AI companies",
    "limit": 5,
    "sources": ["web"]
  }
}
```

**使用示例（带格式）**：
```json
{
  "name": "firecrawl_search",
  "arguments": {
    "query": "latest AI research papers 2023",
    "limit": 5,
    "lang": "en",
    "country": "us",
    "sources": ["web", "images", "news"],
    "scrapeOptions": {
      "formats": ["markdown"],
      "onlyMainContent": true
    }
  }
}
```

**返回值**：搜索结果数组（可选包含爬取内容）。

| 参数 | 类型 | 描述 |
|------|------|------|
| `query` | `string` | 搜索查询词（必填） |
| `filter` | `string` | 可选，过滤条件 |
| `limit` | `number` | 可选，结果数量限制 |
| `location` | `string` | 可选，地理位置 |
| `scrapeOptions` | `object` | 可选，结果爬取选项 |
| `sources` | `array` | 可选，搜索来源（web/images/news） |
| `tbs` | `string` | 可选，时间范围等高级搜索参数 |


## Docker部署指南

### 环境变量说明

| 环境变量 | 描述 | 默认值 | 必填 |
|----------|------|--------|------|
| `FIRECRAWL_API_URL` | Firecrawl API基础URL | `https://api.firecrawl.dev/v1` | 否 |
| `FIRECRAWL_API_KEY` | Firecrawl API密钥 | - | 是（需替换为用户密钥） |
| `FIRECRAWL_RETRY_MAX_ATTEMPTS` | 最大重试次数 | `5` | 否 |
| `FIRECRAWL_RETRY_INITIAL_DELAY` | 初始重试延迟（毫秒） | `2000` | 否 |
| `FIRECRAWL_RETRY_MAX_DELAY` | 最大重试延迟（毫秒） | `30000` | 否 |
| `FIRECRAWL_RETRY_BACKOFF_FACTOR` | 重试退避因子 | `3` |

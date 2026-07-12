---
image: vxcontrol/pentagi
description: "✨ 能够执行复杂渗透测试任务的全自主 AI 智能体。"
source: https://xuanyuan.cloud/zh/r/vxcontrol/pentagi
canonical: https://xuanyuan.cloud/zh/r/vxcontrol/pentagi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vxcontrol/pentagi" title="vxcontrol/pentagi Docker 镜像中文简介、标签列表与拉取命令">vxcontrol/pentagi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PentAGI

**许可证：MIT** · 由 **PentAGI 开发团队**维护（**vxcontrol/pentagi**）。

## 它是什么

**Penetration testing Artificial General Intelligence（渗透测试通用人工智能）**：一款**全自主 AI 智能体**，可在**沙箱化 Docker 环境**中执行复杂的渗透测试流程，综合使用**终端、内置浏览器、编辑器**以及**外部搜索**等能力，自动规划并推进测试步骤。

官方鼓励通过 **Discord、Telegram** 等渠道与安全研究者、AI 爱好者及道德黑客交流，获取支持与最新动态。

## 主要特性

- **安全隔离**：操作在隔离的 Docker 沙箱中执行。
- **全自主**：由 AI 自动判断并执行测试步骤。
- **专业工具集**：内置 **20+** 安全工具（如 nmap、Metasploit、sqlmap 等）。
- **智能记忆**：长期保存研究结果与可行打法，便于复用。
- **网页情报**：内置浏览器，便于抓取最新信息。
- **外部搜索**：可对接 **Tavily**、**Traversaal**、**Google Custom Search**。
- **专家型多智能体**：针对研究、开发、基础设施等角色分工协作。
- **监控**：可与 **Grafana / Prometheus** 等集成，便于实时观察。
- **报告**：生成含利用说明的**详细漏洞报告**。

## 快速开始

1. **创建工作目录**：

```bash
mkdir pentagi && cd pentagi
```

2. **下载配置文件**：

```bash
curl -O https://raw.githubusercontent.com/vxcontrol/pentagi/master/.env.example
curl -O https://raw.githubusercontent.com/vxcontrol/pentagi/master/docker-compose.yml
```

3. **配置环境**：复制 `.env.example` 为 `.env`，填入 API 密钥与各项设置。

```bash
cp .env.example .env
# 编辑 .env
```

4. **启动**：

```bash
docker compose up -d
```

5. **访问 Web 界面**：默认 **https://localhost:8443**，账号 **admin@pentagi.com** / 密码 **admin**（请以官方文档为准并及时修改默认凭据）。

## 环境变量

**必填（至少其一）**

- **OPEN_AI_KEY** 或 **ANTHROPIC_API_KEY**：至少配置一个 LLM 提供方密钥。

**可选**

- **GOOGLE_API_KEY** 与 **GOOGLE_CX_KEY**：Google 搜索集成。
- **TAVILY_API_KEY**：Tavily 搜索。
- **TRAVERSAAL_API_KEY**：Traversaal 搜索。
- **PROXY_URL**：对外访问的全局代理。
- **PUBLIC_URL**：服务对外可访问的公网 URL。
- **PENTAGI_POSTGRES_USER** / **PENTAGI_POSTGRES_PASSWORD**：PostgreSQL 凭据。
- **SERVER_SSL_CRT** / **SERVER_SSL_KEY**：自定义 SSL 证书路径。

## 系统要求

- **Docker Engine** 24.0 及以上
- **Docker Compose** v2.0 及以上
- 内存 **至少 4GB**
- 磁盘 **约 20GB** 可用空间
- 可访问互联网

## 可观测性（监控栈）

基于 **OpenTelemetry** 采集；**Grafana** 可视化（默认端口 **3000**）；另有 **VictoriaMetrics**（指标）、**Jaeger**（链路）、**Loki**（日志）等。

简要启用方式：在 `.env` 中加入 `OTEL_HOST=otelcol:8148`，再下载并合并启动 `docker-compose-observability.yml`：

```bash
echo "OTEL_HOST=otelcol:8148" >> .env
curl -O https://raw.githubusercontent.com/vxcontrol/pentagi/master/docker-compose-observability.yml
docker compose -f docker-compose.yml -f docker-compose-observability.yml up -d
```

Grafana：**http://localhost:3000**（具体以官方文档为准）。

## 分析平台（Langfuse 等）

用于 LLM 可观测性与分析：**Langfuse**（示例端口 **4000**）、**ClickHouse**、**Redis**、**MinIO** 等。

简要启用：在 `.env` 中设置 `LANGFUSE_BASE_URL=http://langfuse-web:3000`，再合并 `docker-compose-langfuse.yml` 启动。

```bash
echo "LANGFUSE_BASE_URL=http://langfuse-web:3000" >> .env
curl -O https://raw.githubusercontent.com/vxcontrol/pentagi/master/docker-compose-langfuse.yml
docker compose -f docker-compose.yml -f docker-compose-langfuse.yml up -d
```

Langfuse Web：**http://localhost:4000**。

**同时启用监控与分析栈**（示例）：

```bash
docker compose -f docker-compose.yml -f docker-compose-langfuse.yml -f docker-compose-observability.yml up -d
```

> **生产环境**请务必在 `.env` 中正确配置安全项与凭据，细节见完整文档。

## 文档与支持

- **GitHub 仓库**：[vxcontrol/pentagi](https://github.com/vxcontrol/pentagi)
- **文档**：[docs.pentagi.com](https://docs.pentagi.com)
- **问题反馈**：GitHub Issues
- **讨论**：GitHub Discussions
- **邮件**：info@pentagi.com

---

**重要提示**：渗透测试与漏洞利用可能涉及法律与授权边界，请仅在**获得明确授权**的目标与环境中使用本工具，并遵守当地法律法规与职业道德。

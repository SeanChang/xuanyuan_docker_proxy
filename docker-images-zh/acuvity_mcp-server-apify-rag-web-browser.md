---
image: acuvity/mcp-server-apify-rag-web-browser
description: "该镜像提供3000+预构建云工具用于网站数据提取，具备隔离沙箱、非root运行、只读文件系统等安全特性，支持Docker、Helm及多种IDE集成部署。"
source: https://xuanyuan.cloud/zh/r/acuvity/mcp-server-apify-rag-web-browser
canonical: https://xuanyuan.cloud/zh/r/acuvity/mcp-server-apify-rag-web-browser
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/acuvity/mcp-server-apify-rag-web-browser" title="acuvity/mcp-server-apify-rag-web-browser Docker 镜像中文简介、标签列表与拉取命令">acuvity/mcp-server-apify-rag-web-browser 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 什么是mcp-server-apify-rag-web-browser？
该镜像由Acuvity打包，基于@apify/mcp-server-rag-web-browser原始源码，提供3000+预构建云工具用于网站数据提取，同时具备多种安全特性以确保可靠安全运行。

## 核心功能
### 安全隔离沙箱
| 特性 | 描述 |
|------|------|
| 隔离执行 | 所有工具在容器化沙箱内运行，强制进程隔离防止横向移动 |
| 默认非root | 遵循最小权限原则，降低安全漏洞影响范围 |
| 只读文件系统 | 确保运行时不可变性，阻止未授权修改 |
| 版本固定 | 锁定工具及依赖版本，保证部署一致性与可复现性 |
| CVE扫描 | 通过Docker Scout持续扫描漏洞，支持主动风险缓解 |
| SBOM与溯源 | 嵌入元数据与构建信息，提供完整供应链透明度 |
| 容器签名 | 使用Cosign实现镜像签名，保障完整性与真实性 |

### 运行时安全护栏
集成Minibridge实现安全Agent-to-MCP连接，支持Rego/HTTP政策执行，提供多种可配置护栏（默认仅资源完整性启用）：
- 资源完整性：验证资源哈希防止篡改
- 隐蔽指令检测：识别隐藏/混淆的请求指令
- 敏感模式检测：标记敏感数据或文件系统暴露风险
- 影子模式检测：识别工具描述的覆盖/影响行为
- Schema误用预防：强制输入数据严格符合规范
- 跨域访问控制：限制外部服务/API调用
- 秘密信息脱敏：防止凭证/敏感值泄露
- 基本认证：通过共享密钥限制未授权访问

## 使用场景
1. **IDE集成**：支持VS Code、Windsurf、Cursor、Claude Desktop、OpenAI Python SDK等工具
2. **Docker部署**：本地STDIO运行、HTTP/sse服务、远程WebSocket隧道（带MTLS）
3. **Kubernetes部署**：通过Helm Chart快速部署到集群

## 配置说明
### 必需环境变量
- **APIFY_TOKEN**：需设置该变量以正常运行镜像

### 部署示例
#### Docker本地HTTP/sse运行
```bash
docker run -it -p 8000:8000 --rm --read-only -e APIFY_TOKEN docker.io/acuvity/mcp-server-apify-rag-web-browser:0.1.4
```
客户端配置示例：
```json
{
  "mcpServers": {
    "acuvity-mcp-server-apify-rag-web-browser": {
      "url": "http://localhost:8000/sse"
    }
  }
}
```

#### Helm部署
```bash
helm install mcp-server-apify-rag-web-browser oci://docker.io/acuvity/mcp-server-apify-rag-web-browser --version 1.0.0
```
需提前配置APIFY_TOKEN秘密以满足部署要求。

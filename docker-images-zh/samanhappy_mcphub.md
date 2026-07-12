---
image: samanhappy/mcphub
description: "这是一款为MCP服务器集群设计的中心枢纽服务器，主要用于连接并协调多个MCP服务器的运行，实现跨服务器的资源共享、用户数据同步、负载均衡及通信管理等核心功能，作为整个MCP服务器网络的核心节点，有效提升服务器集群的整体运行效率、稳定性与用户体验，是MCP服务器体系中不可或缺的关键协调与连接枢纽。"
source: https://xuanyuan.cloud/zh/r/samanhappy/mcphub
canonical: https://xuanyuan.cloud/zh/r/samanhappy/mcphub
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/samanhappy/mcphub" title="samanhappy/mcphub Docker 镜像中文简介、标签列表与拉取命令">samanhappy/mcphub 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MCPHub：几分钟内部署你的MCP服务器  


MCPHub是一个统一枢纽服务器，能将多个MCP（模型上下文协议）服务器整合到单一SSE端点。它通过提供集中化界面来简化服务管理，满足你所有MCP服务器的使用需求。  


## 特性  

- **内置精选MCP服务器**：预装`amap-maps`、`playwright`、`slack`等热门MCP服务器，开箱即用。  
- **集中化管理**：通过一个便捷的枢纽，统一监控和管理多台MCP服务器。  
- **广泛协议支持**：无缝兼容stdio和SSE两种MCP协议，适配不同使用场景。  
- **直观仪表盘界面**：通过网页界面实时监控服务器状态，动态管理服务器。  
- **灵活服务器管理**：无需重启枢纽，即可随时添加、移除或重新配置MCP服务器。  


## 快速开始  

### 使用Docker启动  

执行以下命令快速启动MCPHub：  

```bash  
docker run -p 3000:3000 docker.xuanyuan.run/samanhappy/mcphub
```  


### 访问仪表盘  

打开浏览器，访问以下地址：`[]  

仪表盘功能包括：  
- **实时监控**：随时查看所有MCP服务器的运行状态。  
- **服务状态指示**：快速识别哪些服务处于在线状态。  
- **动态管理**：无需重启枢纽，即可即时添加或移除MCP服务器。  


### SSE端点  

将你的宿主应用（如Claude Desktop、Cursor、Cherry Studio等）无缝连接到MCPHub的SSE端点：`[]  


## 本地开发  

### 克隆代码库  

从GitHub克隆MCPHub代码库：  

```bash  
git clone []  
```  


### 可选配置  

通过编辑`mcp_settings.json`文件自定义MCP服务器设置。例如：  

```json  
{  
  "mcpServers": {  
    "time-mcp": {  
      "command": "npx",  
      "args": ["-y", "time-mcp"]  
    },  
    "sequential-thinking": {  
      "command": "npx",  
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]  
    }  
  }  
}  
```  


### 启动开发服务器  

安装依赖并启动MCPHub：  

```bash  
cd mcphub && pnpm install && pnpm dev  
```  


## 许可证  

本项目采用MIT许可证。

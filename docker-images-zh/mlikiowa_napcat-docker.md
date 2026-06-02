---
image: mlikiowa/napcat-docker
description: "NapCat的Docker镜像，提供容器化环境以快速搭建基于NapCat的应用（如QQ机器人），支持环境隔离、配置持久化与便捷扩展，适用于开发和生产环境中NapCat服务的快速部署。"
source: https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker
canonical: https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker" title="mlikiowa/napcat-docker Docker 镜像中文简介、标签列表与拉取命令">mlikiowa/napcat-docker — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker" title="mlikiowa/napcat-docker Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker</a>

# NapCatQQ 介绍


## 项目简介  
NapCatQQ 是基于 OneBot 标准开发的 QQ 机器人框架，支持 Windows、Linux、macOS 多平台部署，也可通过 Docker 快速启动。它提供了灵活的配置和插件系统，适合开发者快速搭建 QQ 机器人，实现消息收发、事件处理、功能扩展等需求。


## 核心特性  
- **OneBot 兼容**：遵循 OneBot v11/v12 标准，支持与主流机器人管理工具（如 go-cqhttp 生态）兼容，降低开发迁移成本。  
- **多账号管理**：可同时运行多个 QQ 账号，独立配置每个账号的连接方式（正向 WebSocket/反向 WebSocket/HTTP）。  
- **消息类型全覆盖**：支持文本、图片、表情、语音、文件、合并转发等 QQ 消息类型的收发与解析。  
- **插件化扩展**：提供插件接口，开发者可通过 JavaScript/TypeScript 编写插件，实现自定义指令、定时任务等功能，插件支持热加载。  
- **轻量化设计**：基于 TypeScript 开发，代码结构清晰，资源占用低，适合个人或小型团队部署。  


## 安装步骤  

### 环境要求  
- 源码部署：Node.js 16.0+、npm/yarn/pnpm  
- Docker 部署：Docker 20.0+  


### 源码安装  
1. **克隆仓库**  
   ```bash  
   git clone https://github.com/NapNeko/NapCatQQ.git  
   cd NapCatQQ  
   ```  

2. **安装依赖**  
   ```bash  
   npm install  
   ```  

3. **构建项目**  
   ```bash  
   npm run build  
   ```  

4. **初始化配置**  
   复制示例配置文件：  
   ```bash  
   cp config.example.json config.json  
   ```  
   编辑 `config.json`，配置 QQ 账号、连接方式（如 WebSocket 地址）、插件路径等。  

5. **启动框架**  
   ```bash  
   npm start  
   ```  


### Docker 安装  
1. **拉取镜像**  
   ```bash  
   docker pull napneko/napcatqq:latest  
   ```  

2. **创建配置目录**  
   ```bash  
   mkdir -p ./napcatqq/config  
   ```  
   将 `config.json` 放入 `./napcatqq/config` 目录（配置文件可从仓库 `config.example.json` 获取）。  

3. **启动容器**  
   ```bash  
   docker run -d \  
     -v ./napcatqq/config:/app/config \  
     --name napcatqq \  
     napneko/napcatqq:latest  
   ```  


## 快速上手  
1. **配置账号**：在 `config.json` 中填写 QQ 账号信息（如 `account`、`password` 或 `token`，具体取决于登录方式），选择连接协议（如 `ws_reverse` 反向 WebSocket）。  
2. **测试消息发送**：启动框架后，通过 WebSocket 客户端连接机器人（地址在配置中指定，如 `ws://localhost:8080/ws`），发送 OneBot 标准消息指令：  
   ```json  
   {  
     "action": "send_private_msg",  
     "params": {  
       "user_id": 123456789,  // 目标 QQ 号  
       "message": "Hello from NapCatQQ"  
     }  
   }  
   ```  
3. **开发插件**：在 `plugins` 目录新建 `.ts` 文件，示例插件（响应 `ping` 指令）：  
   ```typescript  
   export default (bot) => {  
     bot.on('message.private', (e) => {  
       if (e.message === 'ping') {  
         e.reply('pong');  
       }  
     });  
   };  
   ```  


## 注意事项  
- **账号安全**：QQ 机器人可能违反平台协议，建议使用小号测试，避免主号被封禁。  
- **协议合规**：使用时需遵守 QQ 软件许可协议及相关法律法规，勿用于违规用途。  
- **配置更新**：框架迭代可能导致配置文件格式变化，升级前建议备份配置并参考最新 `config.example.json`。  
- **问题反馈**：遇到 Bug 或需求可在 GitHub Issues 提交，或加入项目社区（如 、QQ 群，具体见仓库文档）。  


更多细节可参考 [项目 GitHub 仓库]([]) 的 README 和文档。

# 告别多账号切换！用 9Router 一键把所有 AI 模型变成一个 API，Cursor/Cline 直接起飞

![告别多账号切换！用 9Router 一键把所有 AI 模型变成一个 API，Cursor/Cline 直接起飞](https://img.xuanyuan.dev/docker/blog/docker-9router.png)

*分类: Docker部署教程 | 标签: OpenClaw,AI,9Router,部署教程 | 发布时间: 2026-05-20 06:30:30*

> 还在为 AI 客户端配置混乱、多账号来回切换、Token 消耗过高而头疼？最近爆火的开源项目 **9Router** 彻底解决了这些痛点！它能把 OpenAI、Claude、Gemini、Copilot、Ollama 等所有主流 AI 服务，统一成一个标准的 OpenAI API 接口，不管是 Cursor、Cline 还是 Cherry Studio、OpenWebUI，直接用一个地址就能调用所有模型，还自带 Token 压缩，大幅降低成本！本文从 0 开始带你用 Docker 一键部署，全程干货无废话。

## 一、什么是 9Router？它到底能干嘛？
很多人第一次看到 9Router，会误以为它只是个“AI 代理工具”，但它的定位其实是一个**轻量 AI 网关（AI Gateway）**，核心就是解决 AI 重度用户的“配置碎片化”问题。

简单来说，你所有的 AI 服务（OpenAI、Claude、Gemini、Copilot、Ollama、OpenRouter…），都可以通过 9Router 接入，最终只对外暴露一个标准的 OpenAI 接口：
`http://你的服务器IP:20128/v1`

有了这个接口，任何支持 OpenAI API 的客户端都能直接使用，再也不用给每个软件单独配置不同的 Key 和地址，也不用来回切换账号，一个入口就能搞定所有模型调用。

### 它能解决你哪些痛点？
- **模型太多，配置混乱**：Claude 写代码、Gemini 大上下文、GPT-4o 通用，每个客户端都要单独配置，越用越乱。
- **多账号切换麻烦**：OpenAI、Claude、Copilot、OpenRouter 多个账号来回切，记 Key 记地址太痛苦。
- **Token 消耗爆炸**：Cursor、Claude Code 这类 AI 编程工具，一天几十万 Token 很正常，成本根本控不住。
- **客户端兼容性差**：不同 AI 软件的配置方式千差万别，有的只支持 OpenAI 接口，有的只支持特定格式，折腾半天用不了。

---

## 二、9Router 核心功能亮点
1.  **标准 OpenAI 兼容接口**
    核心能力，暴露 `/v1/chat/completions` 接口，所有支持 OpenAI 的客户端（Chatbox、Cherry Studio、OpenWebUI、Dify、Cursor、Cline 等）直接零配置兼容，拿来就能用。

2.  **聚合几乎所有主流 AI 服务**
    支持 OpenAI、Claude、Gemini、OpenRouter、Ollama、Vertex AI、NVIDIA NIM、GitHub Copilot 等数十种 AI Provider，不管是官方 API 还是本地部署的模型，都能一键接入。

3.  **Token 智能压缩，直接省钱**
    内置 Token Saver 功能，能自动压缩日志、代码上下文、终端输出，比如把 git/grep/ls 这类命令的输出压缩 60-90%，AI 回复也能精简格式，最高能减少 87% 的 Token 消耗，特别适合 AI 编程、长上下文 Agent 场景。

4.  **OAuth 一键登录，Copilot/Claude Code 直接用**
    支持 Claude Code、GitHub Copilot、Cursor 等 OAuth 接入，不用手动复制 Key，直接登录账号就能用，相当于一个 AI 账号统一登录中心。

5.  **内置 Agent 技能，不止聊天**
    自带图片生成、语音识别（STT）、文本转语音（TTS）、网页搜索等能力，有点 MCP（模型上下文协议）的味道，后续还能扩展更多功能。

---

## 三、Docker 一键部署 9Router（全程零门槛）
这里我们用轩辕镜像提供的国内加速镜像，部署更稳更快。

### 中文镜像地址：
https://xuanyuan.cloud/r/decolua/9router

---

## 前置准备：Docker 环境一键搞定
部署 9Router 最简单的方式就是用 Docker，不用管各种依赖和配置，一行命令就能跑起来。

### Linux系统（含国产系统）一键安装
不管是 Ubuntu、CentOS，还是银河麒麟、统信 UOS、欧拉这些国产系统，直接复制下面这行命令，就能一键安装 Docker、Docker Compose，还自动配置了国内镜像加速，解决下载慢的问题：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### Windows/Mac 用户
Windows 和 Mac 用户直接下载 Docker Desktop 即可，图形化界面操作简单：
[Docker Desktop 官方下载](https://www.docker.com/get-started/)

安装完成后启动 Docker，桌面状态栏会出现小鲸鱼图标，说明 Docker 正在运行。

### 验证安装
打开终端（Linux）或 PowerShell（Windows），输入：
```bash
docker version
```
如果能看到 Client 和 Server 的版本信息，说明环境准备就绪。

---

## 四、正式部署：一键启动 9Router 容器
### 1. 拉取国内加速镜像
```bash
docker pull docker.xuanyuan.run/decolua/9router:latest
```

### 2. 创建数据目录并启动容器
先创建本地持久化目录，方便后续配置和数据保存：
```bash
mkdir -p /opt/9router
cd /opt/9router
```

执行启动命令，一键运行容器：
```bash
docker run -d \
  --name 9router \
  --restart unless-stopped \
  --network host \
  --cap-add NET_ADMIN \
  --device /dev/net/tun \
  -v /opt/9router:/data \
  docker.xuanyuan.run/decolua/9router:latest
```

### 3. 访问 Web 管理后台
容器启动后，直接在浏览器打开：
`http://你的服务器IP:20128`
![9router 登录页](https://img.xuanyuan.dev/docker/blog/docker-9router-1.png)
默认密码是 `123456`，登录后就能看到管理后台，核心模块包括：
- **Endpoint**：统一 API 地址配置、Token 压缩开关
- **Providers**：添加/管理所有 AI 模型供应商
- **Combos**：模型路由和负载均衡配置
- **Usage**：Token 使用统计和用量监控
- **MITM**：OAuth 登录相关配置
- **Skills**：Agent 技能和扩展能力配置

---

## 五、关键步骤：添加你的 AI 模型供应商
部署完成后很多人会发现不能聊天，核心原因就是**没添加模型供应商**，下面教你快速添加常用的几个：
![9router 模型供应商](https://img.xuanyuan.dev/docker/blog/docker-9router-3.png)
### 1. 添加 OpenAI 官方接口
进入 `Providers` 页面，点击右上角 `Add OpenAI Compatible`：
| 项目 | 填写内容 |
|------|----------|
| Name | OpenAI（自定义名称） |
| Base URL | `https://api.openai.com/v1` |
| API Key | 你的 OpenAI API Key |

填写完成后保存即可。

### 2. 添加 OpenRouter 接口
同样选择 `Add OpenAI Compatible`：
| 项目 | 填写内容 |
|------|----------|
| Name | OpenRouter（自定义名称） |
| Base URL | `https://openrouter.ai/api/v1` |
| API Key | 你的 OpenRouter API Key（sk-or-开头） |

### 3. 添加本地 Ollama 模型
如果你本地部署了 Ollama，直接接入即可：
| 项目 | 填写内容 |
|------|----------|
| Name | Ollama（自定义名称） |
| Base URL | `http://127.0.0.1:11434/v1` |
| API Key | 留空即可（Ollama 不需要 Key） |
![9router Endpoint](https://img.xuanyuan.dev/docker/blog/docker-9router-2.png)
添加完成后，回到 `Endpoint` 页面，就能看到统一的 API 地址：`http://你的服务器IP:20128/v1`

---

## 六、实战示例：用 Cherry Studio 直接调用所有模型
以 Cherry Studio 为例，配置超级简单：
1.  打开 Cherry Studio，进入设置 → 模型设置
2.  选择“OpenAI 兼容”
3.  填写：
    - API 地址：`http://你的服务器IP:20128/v1`
    - API Key：随便填（如果没开启 Key 验证）
    - 模型：直接选择你添加的模型（比如 gpt-4o、claude-3-opus）

配置完成后，就能直接在 Cherry Studio 里调用所有通过 9Router 接入的模型了，不用再给每个模型单独配置地址和 Key。

---

## 七、9Router 到底适合谁？
✅ **强烈推荐这些人用：**
- 经常切换 AI 模型的重度用户
- 用 Cursor、Cline 这类 AI 编程工具的开发者
- 搭建 OpenWebUI、Dify 这类 AI 应用的用户
- 想统一管理多个 AI Key 的团队/工作室
- 想降低 AI 工具 Token 消耗的用户

❌ **不推荐这些人折腾：**
- 只是偶尔用一下 ChatGPT，没多模型、多客户端需求的用户
- 不想部署 Docker、不想折腾服务器的纯小白

---

## 八、最后说两句
9Router 最大的价值，从来都不是“能调用 AI”，而是把混乱的 AI 生态给统一了。

以前你要给每个客户端单独配置地址、Key、模型，记都记不住；现在只需要记住 `http://你的服务器IP:20128/v1` 这一个地址，所有客户端都能直接用，还能一键切换模型，Token 消耗也能大幅降低。

对于 AI 重度用户来说，这种体验提升真的是质的飞跃，尤其是 Cursor/Cline 这类工具，用它之后不仅配置更简单，成本也能直接打下来，强烈推荐试试！


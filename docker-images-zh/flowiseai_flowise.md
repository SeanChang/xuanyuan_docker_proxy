---
image: flowiseai/flowise
description: "用于构建LLM应用的低代码开发工具"
source: https://xuanyuan.cloud/zh/r/flowiseai/flowise
canonical: https://xuanyuan.cloud/zh/r/flowiseai/flowise
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/flowiseai/flowise" title="flowiseai/flowise Docker 镜像中文简介、标签列表与拉取命令">flowiseai/flowise 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Flowise Docker 镜像文档

![Flowise Logo](https://raw.githubusercontent.com/FlowiseAI/Flowise/refs/heads/main/images/flowise_white.svg)

## 镜像概述和主要用途

Flowise 是一个低代码开发工具，用于可视化构建大型语言模型(LLM)应用程序和AI代理。通过直观的拖放界面，用户可以轻松设计、测试和部署复杂的AI工作流程，无需深入的编程知识。

该Docker镜像封装了Flowise的完整运行环境，提供了一种简单、一致且隔离的方式来部署和运行Flowise应用程序。

## 核心功能和特性

- **可视化流程图编辑器**：通过拖放界面构建AI工作流程
- **多模型支持**：兼容主流的大型语言模型，如GPT、Claude、LLaMA等
- **丰富的节点库**：包含提示词工程、向量存储、工具集成等多种节点类型
- **实时调试**：即时测试和调整AI流程
- **一键部署**：快速将设计好的流程部署为API服务
- **用户认证**：支持基于用户名密码的访问控制
- **模块化架构**：包含服务器后端、React前端和第三方节点集成组件

## 使用场景和适用范围

Flowise适用于以下场景：

- **AI应用原型开发**：快速构建和演示LLM应用概念
- **内容生成工作流**：自动化报告、邮件、创意内容的生成过程
- **智能客服系统**：构建具有知识库和工具调用能力的客服代理
- **数据分析助手**：创建能够理解和处理结构化/非结构化数据的AI助手
- **教育工具**：开发交互式学习助手和教学内容生成器
- **企业内部工具**：定制化的文档处理、信息提取和分析工具

适用用户群体包括AI开发者、产品经理、数据分析师、研究人员以及需要快速实现AI功能的业务团队。

## 使用方法和配置说明

### 系统要求

- Docker Engine 20.10.0+
- Docker Compose (可选) 2.0.0+
- 至少1GB RAM，推荐2GB+
- 网络连接（用于下载模型和依赖）

### Docker Compose 部署

1. 克隆Flowise项目仓库:
   ```bash
   git clone https://github.com/FlowiseAI/Flowise.git
   cd Flowise
   ```

2. 进入项目根目录下的docker文件夹:
   ```bash
   cd docker
   ```

3. 复制环境变量示例文件并修改:
   ```bash
   cp .env.example .env
   ```

4. 编辑.env文件配置必要参数（可选）:
   ```
   # 服务器配置
   PORT=3000
   
   # 认证配置（可选）
   FLOWISE_USERNAME=admin
   FLOWISE_PASSWORD=your_secure_password
   
   # 数据存储配置
   DATABASE_PATH=/app/.flowise
   ```

5. 启动服务:
   ```bash
   docker compose up -d
   ```

6. 访问Flowise界面:
   打开浏览器访问 http://localhost:3000

7. 停止服务:
   ```bash
   docker compose stop
   ```

### Docker 镜像部署

1. 拉取Flowise官方镜像:
   ```bash
   docker pull docker.xuanyuan.run/flowiseai/flowise
   ```

   或构建本地镜像:
   ```bash
   git clone https://github.com/FlowiseAI/Flowise.git
   cd Flowise
   docker build --no-cache -t flowise .
   ```

2. 运行Flowise容器:
   ```bash
   docker run -d \
     --name flowise \
     -p 3000:3000 \
     -v ~/.flowise:/app/.flowise \
     docker.xuanyuan.run/flowiseai/flowise
   ```

3. 带认证的运行方式:
   ```bash
   docker run -d \
     --name flowise \
     -p 3000:3000 \
     -v ~/.flowise:/app/.flowise \
     -e FLOWISE_USERNAME=admin \
     -e FLOWISE_PASSWORD=your_secure_password \
     docker.xuanyuan.run/flowiseai/flowise
   ```

4. 停止容器:
   ```bash
   docker stop flowise
   ```

5. 查看容器日志:
   ```bash
   docker logs -f flowise
   ```

### 环境变量配置

Flowise支持多种环境变量来自定义配置，主要包括：

| 环境变量名 | 描述 | 默认值 |
|------------|------|--------|
| PORT | 服务监听端口 | 3000 |
| FLOWISE_USERNAME | 访问用户名（启用认证） | 无 |
| FLOWISE_PASSWORD | 访问密码（启用认证） | 无 |
| DATABASE_PATH | 数据存储路径 | /app/.flowise |
| LOG_LEVEL | 日志级别 (debug, info, warn, error) | info |
| API_BASE_URL | API基础URL | http://localhost:3000 |
| DISABLE_TELEMETRY | 禁用遥测数据收集 | false |
| FLOWISE_ENV | 运行环境 (development, production) | production |

完整的环境变量列表可参考项目的[官方文档](https://docs.flowiseai.com/configuration/env-variables)。

### 身份验证设置

要启用应用级身份验证，需要设置FLOWISE_USERNAME和FLOWISE_PASSWORD环境变量：

1. 使用Docker Compose时，编辑docker/.env文件:
   ```
   FLOWISE_USERNAME=your_username
   FLOWISE_PASSWORD=your_secure_password
   ```

2. 使用Docker run命令时，添加环境变量参数:
   ```bash
   docker run -d \
     --name flowise \
     -p 3000:3000 \
     -e FLOWISE_USERNAME=your_username \
     -e FLOWISE_PASSWORD=your_secure_password \
     docker.xuanyuan.run/flowiseai/flowise
   ```

设置后，访问Flowise时将需要输入用户名和密码进行登录。

## 开发人员指南

### 本地开发环境

如果需要基于Docker镜像进行开发，可以使用以下方法：

1. 克隆代码仓库:
   ```bash
   git clone https://github.com/FlowiseAI/Flowise.git
   cd Flowise
   ```

2. 使用开发模式启动容器:
   ```bash
   docker compose -f docker-compose.dev.yml up -d
   ```

3. 访问开发环境:
   打开浏览器访问 http://localhost:8080

4. 代码修改会自动同步到容器中并热重载

## 数据持久化

Flowise的数据（包括流程图、配置和数据库）默认存储在容器内的/app/.flowise目录。为了确保数据持久化，建议使用Docker卷挂载该目录：

```bash
docker run -d \
  --name flowise \
  -p 3000:3000 \
  -v flowise_data:/app/.flowise \
  docker.xuanyuan.run/flowiseai/flowise
```

或在docker-compose.yml中配置:
```yaml
volumes:
  flowise_data:
    driver: local
services:
  flowise:
    ...
    volumes:
      - flowise_data:/app/.flowise
```

## 常见问题解决

### 端口冲突

如果3000端口已被占用，可以通过环境变量更改端口：

```bash
docker run -d \
  --name flowise \
  -p 4000:4000 \
  -e PORT=4000 \
  docker.xuanyuan.run/flowiseai/flowise
```

### 内存不足

对于复杂的AI流程，可能需要增加容器的内存限制：

```yaml
# 在docker-compose.yml中
services:
  flowise:
    ...
    deploy:
      resources:
        limits:
          memory: 4G
```

## 自托管和云部署选项

Flowise除了本地Docker部署外，还支持多种自托管和云部署方式：

- **AWS**：通过ECS、EC2或Elastic Beanstalk部署
- **Azure**：使用App Service或Container Instances
- **Google Cloud**：通过Cloud Run或GKE部署
- **Digital Ocean**：使用App Platform或Droplets
- **阿里云**：通过容器服务或计算巢部署

详细的云部署指南请参考[官方部署文档](https://docs.flowiseai.com/configuration/deployment)。

## 许可证信息

Flowise源代码基于[Apache License Version 2.0](https://github.com/FlowiseAI/Flowise/blob/main/LICENSE.md)开源。

## 支持和社区

- **Discord**：[https://discord.gg/jbaHfsRVBW](https://discord.gg/jbaHfsRVBW)
- **GitHub讨论**：[https://github.com/FlowiseAI/Flowise/discussions](https://github.com/FlowiseAI/Flowise/discussions)
- **文档**：[https://docs.flowiseai.com/](https://docs.flowiseai.com/)
- **Twitter**：[@FlowiseAI](https://twitter.com/FlowiseAI)

## 版本更新

要更新Flowise Docker镜像，请执行以下命令：

```bash
# 拉取最新镜像
docker pull docker.xuanyuan.run/flowiseai/flowise

# 停止并删除现有容器
docker stop flowise
docker rm flowise

# 使用新镜像启动容器
docker run -d --name flowise -p 3000:3000 docker.xuanyuan.run/flowiseai/flowise
```

建议在更新前备份数据卷中的内容。

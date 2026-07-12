---
image: eisai/ollama
description: "适用于Windows 20348或更新版本（Win11、Server2022）的Ollama容器镜像，无需Hyper-V或CUDA工具包，支持本地运行大模型，可通过Docker部署并挂载模型目录，实现模型持久化存储与GPU加速。"
source: https://xuanyuan.cloud/zh/r/eisai/ollama
canonical: https://xuanyuan.cloud/zh/r/eisai/ollama
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/eisai/ollama" title="eisai/ollama Docker 镜像中文简介、标签列表与拉取命令">eisai/ollama 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述和主要用途
该Docker镜像为Windows平台提供Ollama运行环境，支持Windows build 20348及更新版本（如Win11、Server2022）。无需安装Hyper-V或CUDA工具包，即可在本地部署和运行大语言模型，适用于需要便捷搭建AI模型服务的场景。

## 核心功能和特性
- **系统兼容性**：仅支持Windows build 20348或更新版本（Win11、Server2022）
- **环境简化**：无需Hyper-V虚拟化或CUDA工具包
- **GPU支持**：通过固定GUID设备传递实现GPU加速
- **模型持久化**：支持本地模型目录挂载，确保模型数据不丢失
- **灵活部署**：可通过Docker Compose快速配置和启动

## 使用场景和适用范围
- 本地AI模型开发与测试
- 个人或小型团队的轻量级LLM服务部署
- 无需复杂环境配置的AI应用原型验证
- 对GPU加速有需求但不想配置CUDA环境的场景

## 使用方法和配置说明

### 准备工作
在Windows系统中创建以下目录结构（Docker不会自动创建挂载目录）：
```
ollama
├───models       # 用于存储Ollama模型文件
└───docker-compose.yaml  # Docker Compose配置文件
```

### Docker Compose配置详解
创建`docker-compose.yaml`文件，内容如下：
```yaml
networks:
  ollama:  # 定义专用网络

services:
  ollama:
    container_name: ollama  # 容器名称
    image: docker.xuanyuan.run/eisai/ollama:latest  # 使用最新版镜像
    restart: unless-stopped  # 除非手动停止，否则自动重启
    isolation: process  # Windows容器隔离模式
    networks:
      - ollama  # 加入定义的网络
    cpu_count: 8  # 分配CPU核心数（可根据实际情况调整）
    ports:
      - "11434:11434"  # 端口映射，主机端口:容器端口
    volumes:
      - '.\models:C:\models'  # 挂载本地models目录到容器内
    devices:
      - class/5B45201D-F2F2-4F3B-85BB-30FF1F953599  # 固定GUID，用于传递GPU设备
```

### 部署步骤
1. 进入`ollama`目录
2. 执行以下命令启动服务：
   ```bash
   docker-compose up -d
   ```
3. 服务启动后，通过`http://localhost:11434`访问Ollama API

## 参考链接
- Ollama官方仓库：https://github.com/ollama/ollama
- Open WebUI仓库（推荐前端界面）：https://github.com/open-webui/open-webui
- 本镜像项目地址：https://github.com/Eisaichen/ollama-win-docker
- Windows轻量级Docker引擎安装指南：https://eisaichen.com/?p=76

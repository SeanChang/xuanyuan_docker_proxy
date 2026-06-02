---
image: rootpublic/eclipse-temurin
description: "Root精选eclipse-temurin镜像是基于官方eclipse-temurin的安全、轻量且便捷的容器化应用起点，具有减小镜像大小、最小化攻击面和提升初始安全态势的特点。"
source: https://xuanyuan.cloud/zh/r/rootpublic/eclipse-temurin
canonical: https://xuanyuan.cloud/zh/r/rootpublic/eclipse-temurin
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rootpublic/eclipse-temurin" title="rootpublic/eclipse-temurin Docker 镜像中文简介、标签列表与拉取命令">rootpublic/eclipse-temurin — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rootpublic/eclipse-temurin" title="rootpublic/eclipse-temurin Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rootpublic/eclipse-temurin</a>

# Root精选eclipse-temurin镜像

## 镜像概述和主要用途
Root精选eclipse-temurin镜像是容器化应用的安全、轻量且便捷的起点，基于官方Docker [eclipse-temurin](https://hub.docker.com/_/eclipse-temurin) 镜像构建。该镜像旨在为用户提供经过优化的Java运行环境，适用于各类需要可靠、安全容器基础的应用场景。

## 核心功能与特性
Root精选镜像具备以下核心优势：
- **减少镜像大小**：通过优化构建流程，显著降低镜像体积，节省存储和传输资源
- **最小化攻击面**：精简不必要组件，减少潜在安全漏洞暴露
- **改进初始安全态势**：增强默认安全配置，提升应用部署的初始安全水平

> **注意**：如需实现零严重/高危漏洞，可考虑使用 [Root自动化漏洞修复](https://app.root.io) 服务。

## 使用场景与适用范围
该镜像适用于需要Java运行环境的各类容器化应用场景，尤其适合：
- 企业级Java应用的容器化部署
- 对镜像安全性和资源占用有严格要求的微服务架构
- 需要符合安全合规标准的生产环境应用
- 希望简化容器镜像管理并降低安全风险的开发团队

## 使用方法与配置说明
### 基本使用方法
该镜像的使用方式与官方eclipse-temurin镜像兼容，详细示例和使用说明请参考官方文档：[Docker eclipse-temurin文档](https://hub.docker.com/_/eclipse-temurin)。

### 部署示例
#### 基本运行命令
运行一个简单的Java应用（假设当前目录下有编译好的`app.jar`）：
```bash
docker run -it --rm -v $(pwd):/app -w /app root-curated/eclipse-temurin java -jar app.jar
```

#### Docker Compose配置示例
创建`docker-compose.yml`文件：
```yaml
version: '3.8'
services:
  java-application:
    image: root-curated/eclipse-temurin
    volumes:
      - ./application:/app
    working_dir: /app
    command: java -jar app.jar
    restart: unless-stopped
    environment:
      - JAVA_OPTS=-Xmx512m  # 可根据应用需求调整JVM参数
```
启动服务：
```bash
docker-compose up -d
```

### 配置说明
镜像配置与官方eclipse-temurin保持一致，支持通过环境变量（如`JAVA_OPTS`）、命令行参数等方式自定义JVM参数和应用配置，具体配置项请参考官方文档。

## 许可证与合规义务
所有许可证信息可在各个镜像标签中查看。

### Root的义务
- 明确标识并归属所包含的软件
- 提供适当的许可证合规信息

### 用户的义务
- 遵守上述列出的许可证条款

详细的许可证合规信息请访问 [root.io/trust-center](https://root.io/trust-center)。

## 源代码与Dockerfile
该镜像的Dockerfile及源代码可在GitHub仓库中获取：[GitHub Repository](https://github.com/rootio-avr/public-image-catalog/tree/main/debian/eclipse-temurin/)。

## 支持与反馈
我们欢迎您的反馈！如有任何问题、反馈或问题，请联系 [support@root.io](mailto:support@root.io)。

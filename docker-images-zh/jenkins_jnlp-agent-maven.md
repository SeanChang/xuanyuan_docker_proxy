---
image: jenkins/jnlp-agent-maven
description: "基于JNLP协议的代理镜像，内置Maven 3构建工具，适用于Jenkins等CI/CD系统作为分布式构建节点，执行Maven项目构建任务。"
source: https://xuanyuan.cloud/zh/r/jenkins/jnlp-agent-maven
canonical: https://xuanyuan.cloud/zh/r/jenkins/jnlp-agent-maven
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkins/jnlp-agent-maven" title="jenkins/jnlp-agent-maven Docker 镜像中文简介、标签列表与拉取命令">jenkins/jnlp-agent-maven 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 基于JNLP的Maven 3代理镜像

## 概述
该镜像是一个基于JNLP（Java Network Launch Protocol）协议的代理工具，内置Maven 3构建工具。JNLP协议支持通过网络启动Java应用，此代理主要用于与Jenkins等CI/CD系统集成，作为分布式构建环境中的从节点，执行Maven项目构建任务。

## 特性
- 基于JNLP协议：支持与Jenkins等平台的主节点建立通信，实现远程任务调度
- 内置Maven 3：集成Maven 3构建工具，可直接执行`mvn`命令，无需额外安装
- 轻量高效：优化镜像体积，适合作为CI/CD流水线中的轻量级代理节点

## 使用场景
- Jenkins分布式构建：作为Jenkins从节点，处理Maven项目的编译、打包、测试等任务
- JNLP协议依赖场景：需要通过JNLP启动的Java应用部署或构建流程
- 自动化流水线代理：在持续集成/持续部署（CI/CD）流程中作为专用代理节点，执行构建脚本

## Docker部署方案示例
### 基本运行命令
以下示例展示如何将该镜像作为Jenkins代理运行，连接至Jenkins主节点：
```bash
docker run -d \
  --name jnlp-maven-agent \
  --network jenkins-network \
  docker.xuanyuan.run/maven3-jnlp-agent \
  -url http://jenkins-master:8080 \
  <jenkins-agent-secret> \
  <agent-node-name>
```

### 参数说明
- `-d`：后台运行容器
- `--name`：指定容器名称
- `--network`：连接至Jenkins主节点所在的网络（如需通信）
- `-url`：Jenkins主节点的URL
- `<jenkins-agent-secret>`：Jenkins主节点生成的代理密钥（在节点配置页面获取）
- `<agent-node-name>`：Jenkins主节点中注册的代理节点名称

## 注意事项
1. 网络配置：确保容器与Jenkins主节点网络互通，JNLP通信可能涉及TCP端口50000（默认），需开放相关端口
2. 数据持久化：建议挂载Maven本地仓库目录（如`-v ~/.m2/repository:/root/.m2/repository`）以缓存依赖，加速构建
3. 安全更新：定期更新镜像以获取JNLP组件及Maven的安全补丁和功能更新

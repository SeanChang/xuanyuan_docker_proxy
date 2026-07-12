---
image: camunda/camunda-bpm-platform
description: "Camunda Platform 7社区版的Docker镜像，支持该业务流程管理平台社区版本的部署与运行。"
source: https://xuanyuan.cloud/zh/r/camunda/camunda-bpm-platform
canonical: https://xuanyuan.cloud/zh/r/camunda/camunda-bpm-platform
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/camunda/camunda-bpm-platform" title="camunda/camunda-bpm-platform Docker 镜像中文简介、标签列表与拉取命令">camunda/camunda-bpm-platform 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Camunda Platform 7 Docker 镜像文档


## 镜像概述与主要用途

本仓库提供 Camunda Platform 7 社区版（Community Edition）的 Docker 镜像。该镜像可用于演示和测试 Camunda Platform 7，也可作为基础镜像扩展自定义流程应用。如需运行企业版（Enterprise Edition）Docker 容器，请参考 [官方文档](https://docs.camunda.org/manual/latest/installation/docker/#enterprise-edition)。


## 核心功能与特性

- 内置 Camunda Platform 7 社区版完整运行环境，无需手动配置基础依赖
- 支持通过扩展自定义流程应用，满足特定业务流程需求
- 包含基础 Web 管理界面，便于流程监控与管理


## 使用场景与适用范围

- **演示环境**：快速部署 Camunda Platform 7，展示流程引擎功能与特性
- **测试环境**：在开发阶段验证流程定义、任务流转等功能正确性
- **开发辅助**：作为基础镜像，集成自定义流程应用进行本地开发与调试


## 使用方法与配置说明

### 前置条件

- 已安装 Docker 环境（Docker Engine 版本需兼容镜像要求，建议使用最新稳定版）


### 镜像拉取

拉取最新版本的 Camunda Platform 7 社区版镜像：

```bash
docker pull docker.xuanyuan.run/camunda/camunda-bpm-platform:latest
```

如需指定版本，可将 `latest` 替换为具体版本标签（如 `7.20.0`，版本列表可参考 [Docker Hub](https://hub.docker.com/r/camunda/camunda-bpm-platform)）。


### 运行容器

启动容器并映射端口（默认 Web 端口为 8080）：

```bash
docker run -d --name camunda -p 8080:8080 docker.xuanyuan.run/camunda/camunda-bpm-platform:latest
```

- 参数说明：
  - `-d`：后台运行容器
  - `--name camunda`：指定容器名称为 `camunda`
  - `-p 8080:8080`：将容器内 8080 端口映射到主机 8080 端口


### 访问 Web 界面

容器启动后，通过浏览器访问以下 URL 打开 Camunda 欢迎页面：

```
http://localhost:8080/camunda-welcome/index.html
```


### 扩展自定义流程应用

如需扩展自定义流程应用，可基于此镜像构建新镜像，将流程应用部署至容器内的应用服务器（具体路径与方式可参考 [官方文档](https://github.com/camunda/docker-camunda-bpm-platform/blob/next/README.md)）。


## 许可证

Camunda Platform 7 社区版基于 Apache 2.0 许可证授权。镜像中包含的第三方库或应用服务器均按其各自许可证分发（[查看第三方许可说明](https://docs.camunda.org/manual/latest/introduction/third-party-libraries/)）。


## 进一步信息

更多详细说明，请参考 [GitHub 仓库 README](https://github.com/camunda/docker-camunda-bpm-platform/blob/next/README.md)。

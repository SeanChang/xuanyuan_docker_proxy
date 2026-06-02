---
image: requarks/wiki
description: "Wiki.js - 一款基于NodeJS构建的现代化、轻量级且功能强大的维基应用"
source: https://xuanyuan.cloud/zh/r/requarks/wiki
canonical: https://xuanyuan.cloud/zh/r/requarks/wiki
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [requarks/wiki — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/requarks/wiki)

含镜像标签、拉取命令、部署文档与相关推荐。

[requarks/wiki Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/requarks/wiki)

<img src="https://static.requarks.io/logo/wikijs-full.svg" width="500" />

#### 一款基于NodeJS构建的现代化、轻量级且功能强大的维基应用  
https://js.wiki

## 支持的标签及对应的`Dockerfile`链接
- [`2.5`, `2`, `latest`](https://github.com/Requarks/wiki/blob/2.5.117/dev/build/Dockerfile)
- [`2.4`](https://github.com/Requarks/wiki/blob/2.4.107/dev/build/Dockerfile)

> 注意：自**2.4**版本起，ARMv7和ARM64镜像已包含在主标签中。您无需再添加`-arm`后缀。

- [`2.2`, `2.3-arm`](https://github.com/Requarks/wiki/blob/2.3.81/dev/build/Dockerfile)
- [`2.2`, `2.2-arm`](https://github.com/Requarks/wiki/blob/2.2.51/dev/build/Dockerfile)
- [`2.1`, `2.1-arm`](https://github.com/Requarks/wiki/blob/2.1.113/dev/build/Dockerfile)
- [`2.0`, `2.0-arm`](https://github.com/Requarks/wiki/blob/2.0.12/dev/build/Dockerfile)
- [`1.0`](https://github.com/Requarks/wiki-v1/blob/master/tools/build/Dockerfile)

## 快速参考

- **文档**:  

  [使用Docker安装2.x版本](https://docs.requarks.io/install/docker)  
  [使用Docker安装1.x版本](https://docs-legacy.requarks.io/wiki/install/docker)  

- **获取帮助**:  
  [Slack社区](https://wiki.requarks.io/slack)

- **提交问题**:  
  [https://github.com/Requarks/wiki/issues](https://github.com/Requarks/wiki/issues)

- **维护者**:  
  [Wiki.js团队](https://github.com/Requarks)

- **支持的架构**:  
  `amd64`, `arm64`, `arm/v7`

- **许可证**:  
  [AGPLv3](https://github.com/Requarks/wiki/blob/master/LICENSE)

## 许可证

查看[许可证信息](https://github.com/Requarks/wiki/blob/master/LICENSE)了解此镜像中包含的软件许可。  

与所有Docker镜像一样，该镜像可能还包含其他软件（如基础发行版中的Bash等），这些软件可能具有其他许可证。

## 核心功能与特性

- **现代化设计**: 基于NodeJS构建，提供直观的用户界面和流畅的操作体验  
- **轻量级架构**: 资源占用低，部署灵活，适合各种规模的应用场景  
- **多架构支持**: 兼容amd64、arm64及arm/v7架构，适配不同硬件环境  
- **版本迭代**: 持续更新维护，2.4版本起整合ARM架构支持，简化部署流程

## 使用场景与适用范围

- 团队协作平台：用于团队内部知识共享与文档协作  
- 项目文档管理：构建项目API文档、操作手册等结构化知识体系  
- 企业知识库：存储和管理企业内部流程、规范、培训材料等  
- 个人笔记系统：搭建个人知识管理平台，支持内容结构化组织

## 使用方法与配置说明

### 基本部署流程

1. **拉取镜像**  
   根据需求选择对应标签，例如拉取最新版：  
   ```bash
   docker pull requarks/wiki:latest
   ```

2. **运行容器**  
   参考官方文档进行配置，基本命令示例（使用SQLite数据库）：  
   ```bash
   docker run -d -p 3000:3000 --name wikijs \
     -e "DB_TYPE=sqlite" \
     -v /path/to/data:/wiki/data \
     -v /path/to/config:/wiki/config \
     requarks/wiki:latest
   ```

3. **访问应用**  
   容器启动后，通过`http://localhost:3000`访问Wiki.js，按照引导完成初始配置。

### 详细配置

完整的安装与配置指南请参考官方文档：  
- [2.x版本Docker安装指南](https://docs.requarks.io/install/docker)  
- [1.x版本Docker安装指南](https://docs-legacy.requarks.io/wiki/install/docker)  

配置项包括数据库连接（支持PostgreSQL、MySQL、SQLite等）、端口映射、数据卷挂载、环境变量设置等，需根据实际需求调整。

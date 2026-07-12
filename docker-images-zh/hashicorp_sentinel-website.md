---
image: hashicorp/sentinel-website
description: "HashiCorp Sentinel文档项目的Docker镜像，支持在无Node环境下进行本地开发，通过make命令快速启动文档网站，修改依赖时需重建镜像以应用更新，适合不想安装Node的开发者使用。"
source: https://xuanyuan.cloud/zh/r/hashicorp/sentinel-website
canonical: https://xuanyuan.cloud/zh/r/hashicorp/sentinel-website
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/sentinel-website" title="hashicorp/sentinel-website Docker 镜像中文简介、标签列表与拉取命令">hashicorp/sentinel-website 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# HashiCorp Sentinel文档项目Docker镜像

## 镜像概述

本镜像用于HashiCorp Sentinel文档项目的本地开发环境搭建，提供了无需安装Node.js即可运行文档网站的能力。通过Docker容器化方式，简化了开发环境配置流程，使开发者能够快速启动并预览文档网站，特别适合对Node.js不熟悉或不愿在本地安装Node.js的用户。

## 核心功能和特性

- **无Node依赖运行**：无需在本地安装Node.js环境，通过Docker容器即可运行文档网站
- **开发模式支持**：以开发模式运行时，修改文档内容后网站会自动重载，无需手动重启服务
- **简化操作流程**：通过`make`命令封装Docker操作，降低使用复杂度
- **依赖管理支持**：当项目Node依赖发生变更时，支持重建镜像以更新依赖环境

## 使用场景

- **Node.js环境排斥用户**：对Node.js不熟悉或不愿在本地安装配置Node.js的开发者
- **临时/低频贡献者**：无需长期维护本地Node环境，仅通过Docker即可完成临时文档编辑和预览
- **环境一致性需求**：确保不同开发者使用统一的依赖环境，减少"在我机器上能运行"的问题

## 使用方法

### 前提条件

- 已安装Docker引擎（需确保Docker服务正常运行）

### 基本使用（开发模式启动）

1. 克隆HashiCorp Sentinel文档项目代码库到本地
2. 进入项目根目录
3. 执行以下命令启动开发模式：
   ```bash
   make
   ```
   该命令会自动拉取或构建Docker镜像，并以开发模式运行容器内的文档网站

### 修改Node依赖时的操作

当项目的`package.json`或`package-lock.json`发生变更（即Node依赖更新）时，需执行以下步骤使依赖变更生效：

1. 构建包含更新依赖的本地Docker镜像：
   ```bash
   make build-image
   ```
2. 使用更新后的镜像启动网站：
   ```bash
   make website-local
   ```

### 访问本地网站

无论通过上述哪种方式启动，均可通过以下地址访问本地运行的文档网站：
```
http://localhost:3000
```

在开发模式下，修改项目中的文档内容后，网站会自动检测变更并重载，无需手动重启容器。

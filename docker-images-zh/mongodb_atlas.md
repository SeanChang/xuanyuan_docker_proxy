---
image: mongodb/atlas
description: "从命令行创建、管理和自动化MongoDB Atlas资源"
source: https://xuanyuan.cloud/zh/r/mongodb/atlas
canonical: https://xuanyuan.cloud/zh/r/mongodb/atlas
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mongodb/atlas" title="mongodb/atlas Docker 镜像中文简介、标签列表与拉取命令">mongodb/atlas — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mongodb/atlas" title="mongodb/atlas Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mongodb/atlas</a>

# Atlas CLI Docker镜像

## 镜像概述和主要用途

这是[Atlas CLI](https://www.mongodb.com/docs/atlas/cli/stable/)的Docker镜像。Atlas CLI是专为[MongoDB Atlas](https://www.mongodb.com/docs/atlas/)构建的命令行界面，可通过终端以简短、直观的命令与Atlas数据库部署和Atlas Search交互，帮助用户在几秒钟内完成复杂的数据库管理任务。

## 核心功能和特性

- 提供与MongoDB Atlas资源的命令行交互能力
- 支持通过终端管理Atlas数据库部署和Atlas Search
- 简化复杂数据库管理任务，提高操作效率
- 支持版本化部署，可选择特定版本使用

## 使用场景和适用范围

适用于需要通过命令行高效管理MongoDB Atlas资源的开发人员、数据库管理员和DevOps工程师，尤其适合集成到自动化脚本和CI/CD流程中，实现Atlas资源的自动化管理。

## 使用方法和配置说明

### 快速开始

#### 1. 拉取Docker镜像

拉取最新版本的Docker镜像：
```bash
docker pull mongodb/atlas
```

若未指定版本标签，Docker会自动拉取`mongodb/atlas:latest`标签的最新镜像。

拉取特定版本的Docker镜像（将`tag`替换为具体版本标签）：
```bash
docker pull mongodb/atlas:tag
```

#### 2. 运行Atlas CLI命令

请遵循"使用Docker运行Atlas CLI命令"[指南](https://www.mongodb.com/docs/atlas/cli/stable/atlas-cli-docker/)执行具体命令。

## 获取帮助

- 查阅[Atlas CLI文档](https://www.mongodb.com/docs/atlas/cli/stable/)了解更多使用细节
- 报告错误或安全漏洞：在[mongodb-atlas-cli GitHub仓库](https://github.com/mongodb/mongodb-atlas-cli/issues/new/choose)创建issue
- 提出功能请求：访问[feedback.mongodb.com](https://feedback.mongodb.com/forums/930808-atlas-cli)

## 贡献

如需为项目贡献代码，请参阅[贡献指南](https://github.com/mongodb/mongodb-atlas-cli/blob/master/CONTRIBUTING.md)并参与[GitHub仓库](https://github.com/mongodb/mongodb-atlas-cli)开发。

## 许可证

MongoDB Atlas CLI采用Apache 2.0许可证发布，详见[许可证文件](https://github.com/mongodb/mongodb-atlas-cli/blob/master/LICENSE)。

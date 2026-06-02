<!-- xuanyuan-docker-images-zh
image: outlinewiki/outline
source: https://xuanyuan.cloud/zh/r/outlinewiki/outline
canonical: https://xuanyuan.cloud/zh/r/outlinewiki/outline
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [outlinewiki/outline — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/outlinewiki/outline "outlinewiki/outline Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/outlinewiki/outline

# Outline 镜像文档

## 概述
Outline 是一个使用 React 和 Node.js 构建的快速、协作型团队知识库。它为团队提供了高效管理和共享信息的平台，支持本地化部署，同时也提供官方托管版本（[getoutline.com](https://www.getoutline.com)）。该项目注重代码质量与性能，采用 TypeScript、Prettier、Styled Components 等工具开发，适合成长中的团队构建内部知识库。

![Outline 截图](https://user-images.githubusercontent.com/380914/110356468-26374600-7fef-11eb-9f6a-f2cc2c8c6590.png)

## 核心功能与特性
- **快速高效**：针对团队协作场景优化，响应迅速，提升信息访问与编辑效率
- **协作编辑**：支持多团队成员实时协作，便于共同维护文档内容
- **技术栈**：基于 React（前端）和 Node.js（后端）构建，技术成熟且易于扩展
- **多语言支持**：提供本地化功能，支持多种语言界面
- **代码质量保障**：采用 TypeScript 强类型检查、Prettier 代码格式化等工具，确保代码质量

## 使用场景
- **团队知识管理**：集中存储和组织团队文档、流程手册、技术指南等信息
- **项目文档协作**：多人共同编辑项目需求、设计方案、进度报告等文档
- **信息共享平台**：作为团队内部信息枢纽，高效共享最佳实践、常见问题解答等内容
- **成长型团队适用**：特别适合规模不断扩大的团队，保持信息管理的有序性和可访问性

## 安装与部署
### 生产环境部署
如需在生产环境部署 Outline，建议参考官方[生产环境配置文档](https://app.getoutline.com/share/770a97da-13e5-401e-9f8a-37949c19f97e/)，该文档提供了完整的部署步骤和配置说明。

### 开发环境设置
若需搭建开发环境以贡献代码或进行定制开发，可参考[本地开发指南](https://app.getoutline.com/share/770a97da-13e5-401e-9f8a-37949c19f97e/doc/local-development-5hEhFRXow7)，包含依赖安装、环境变量配置等详细步骤。

## 配置说明
### 环境变量
运行 Outline 时可通过环境变量进行配置，关键参数包括：
- `DEBUG`: 启用调试日志，例如设置 `DEBUG=http` 可开启 HTTP 请求日志
- 数据库连接参数：需配置数据库地址、用户名、密码等（具体参数参考官方部署文档）

## 维护与贡献
### 贡献指南
若您希望为 Outline 贡献代码或改进，建议先通过 GitHub [issues](https://github.com/outline/outline/issues) 或 [discussions](https://github.com/outline/outline/discussions) 与核心团队沟通。主要贡献方向包括：
- 多语言翻译（参考 [翻译文档](docs/TRANSLATION.md)）
- 修复标记为 [`good first issue`](https://github.com/outline/outline/labels/good%20first%20issue) 的问题
- 性能优化（前端或后端）
- 开发体验与文档改进
- 修复 GitHub 上列出的 bug

### 架构概述
Outline 的架构设计可参考 [架构文档](docs/ARCHITECTURE.md)，该文档提供了应用整体结构、模块划分等高层级概述，适合开发者了解代码组织方式。

### 测试
项目针对关键功能（如 API 端点、认证流程）提供测试覆盖，使用 Jest 作为测试框架。测试命令如下：
```shell
# 运行所有测试
make test

# 后端测试（监视模式）
make watch

# 单独运行后端测试
yarn test:server

# 运行特定后端测试文件
yarn test:server myTestFile

# 运行前端测试
yarn test:app
```

### 数据库迁移
使用 Sequelize 管理数据库迁移，常用命令：
```shell
# 生成迁移文件
yarn sequelize migration:generate --name my-migration

# 执行迁移
yarn sequelize db:migrate

# 在测试数据库执行迁移
yarn sequelize db:migrate --env test
```

## 许可证
Outline 采用 [BSL 1.1 许可证](LICENSE)。

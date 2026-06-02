---
image: paperlessngx/paperless-ngx
description: "Paperless-ngx是一款文档管理系统，可将物理文档转换为可搜索的在线档案，支持OCR识别、全文搜索、自动分类和邮件处理，帮助用户减少纸质文件，高效管理各类文档。"
source: https://xuanyuan.cloud/zh/r/paperlessngx/paperless-ngx
canonical: https://xuanyuan.cloud/zh/r/paperlessngx/paperless-ngx
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/paperlessngx/paperless-ngx" title="paperlessngx/paperless-ngx Docker 镜像中文简介、标签列表与拉取命令">paperlessngx/paperless-ngx — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/paperlessngx/paperless-ngx" title="paperlessngx/paperless-ngx Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/paperlessngx/paperless-ngx</a>

# Paperless-ngx 镜像文档

## 镜像概述和主要用途

Paperless-ngx是一款从paperless-ng分叉而来的文档管理系统，旨在将物理文档转换为可搜索的在线档案，帮助用户减少纸质文件存储，实现高效的数字化文档管理。它支持OCR文本识别、多格式文档处理、全文搜索及自动化分类，适用于个人、家庭及小型团队的文档归档需求。

## 核心功能和特性

- **文档组织与索引**：通过标签、发件人、文档类型等元数据对扫描文档进行结构化组织和索引
- **OCR文本识别**：对图片类文档执行OCR，生成可选择文本，并自动分配标签、发件人和文档类型
- **多格式支持**：兼容PDF、图片、纯文本文件及Office文档（Word、Excel、PowerPoint等，需配置Apache Tika）
- **灵活存储管理**：文档以原始格式存储在磁盘，文件名和文件夹结构可自定义配置
- **现代化前端界面**：单页应用设计，包含仪表盘（显示统计与上传功能）、多条件过滤及自定义视图保存
- **强大全文搜索**：支持自动补全、相关性排序、结果高亮及"相似文档"搜索功能
- **邮件集成处理**：支持多邮箱账户配置与过滤规则，可设置邮件后续操作（移动、标记已读、删除等）
- **机器学习分类**：通过学习用户文档特征，自动为新文档分配标签、发件人和文档类型
- **多核并行处理**：优化多核系统性能，支持并行处理多个文档
- **档案完整性检查**：内置健康检查工具，确保文档档案的一致性和完整性

## 使用场景和适用范围

- **个人文档管理**：扫描并归档个人账单、发票、合同等纸质文件，实现数字化存储
- **家庭办公需求**：减少纸质文件堆积，方便远程访问和管理重要家庭文档
- **小型团队协作**：构建共享文档库，通过标签和搜索快速定位团队所需文件
- **邮件文档自动收集**：自动处理邮件附件（如收据、报表），减少手动上传操作

## 详细使用方法和配置说明

### 部署方式

#### Docker Compose部署（推荐）

官方推荐使用docker-compose进行部署，提供一键安装脚本简化配置过程：

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/main/install-paperless-ngx.sh)"
```

该脚本会自动配置docker-compose环境并从GitHub Packages拉取最新镜像。

#### 手动部署

如需手动部署，需自行安装依赖并配置Apache和数据库服务器，详细步骤请参考[官方文档](https://paperless-ngx.readthedocs.io/en/latest/setup.html#installation)。

### 从Paperless-ng迁移

直接替换为Paperless-ngx镜像即可完成迁移，具体步骤参见[迁移指南](https://paperless-ngx.readthedocs.io/en/latest/setup.html#migrating-from-paperless-ng)。

### 访问与使用

部署完成后，通过浏览器访问Web界面即可使用。官方提供演示环境：[demo.paperless-ngx.com](https://demo.paperless-ngx.com)，登录信息为`demo`/`demo`（注意：演示内容会频繁重置，请勿上传敏感信息）。

## 注意事项

- **敏感数据安全**：文档以明文形式存储，未加密。建议仅在可信环境（如家庭服务器）中部署，避免在不可信主机上运行
- **Office文档支持**：需额外配置Apache Tika以支持Office文档处理，具体配置参见[官方文档](https://paperless-ngx.readthedocs.io/en/latest/configuration.html#tika-settings)

## 社区支持与贡献

- **社区交流**：可通过[Matrix房间](https://matrix.to/#/#paperless:adnidor.de)参与讨论
- **翻译支持**：在[Crowdin平台](https://crwd.in/paperless-ngx)参与多语言翻译
- **问题反馈**：通过GitHub Issues提交bug报告，或在GitHub Discussions提出功能需求

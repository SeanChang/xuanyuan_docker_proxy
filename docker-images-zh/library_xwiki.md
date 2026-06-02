---
image: library/xwiki
description: "XWiki是一款高级开源企业级维基平台，它基于开源技术构建，专为企业场景设计，具备强大的知识协作、文档管理与团队共享能力，支持自定义扩展、多语言环境及多终端访问，可有效整合企业内部信息资源，促进团队高效沟通与知识沉淀，是助力企业实现数字化知识管理的理想工具。"
source: https://xuanyuan.cloud/zh/r/library/xwiki
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/xwiki](https://xuanyuan.cloud/zh/r/library/xwiki)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# XWiki Docker 镜像介绍


## 快速参考

- **维护方**：  
  [XWiki 社区]([])

- **获取帮助渠道**：  
  [XWiki 用户邮件列表/论坛]([]) 或 [XWiki IRC 频道]([])


## 支持的标签及对应 Dockerfile 链接

- [`17`, `17.8`, `17.8.0`, `17-mysql-tomcat`, `17.8-mysql-tomcat`, `17.8.0-mysql-tomcat`, `mysql-tomcat`, `stable-mysql-tomcat`, `stable-mysql`, `stable`, `latest`]([])

- [`17-postgres-tomcat`, `17.8-postgres-tomcat`, `17.8.0-postgres-tomcat`, `postgres-tomcat`, `stable-postgres-tomcat`, `stable-postgres`]([])

- [`17-mariadb-tomcat`, `17.8-mariadb-tomcat`, `17.8.0-mariadb-tomcat`, `mariadb-tomcat`, `stable-mariadb-tomcat`, `stable-mariadb`]([])

- [`17.4`, `17.4.5`, `17.4-mysql-tomcat`, `17.4.5-mysql-tomcat`]([])

- [`17.4-postgres-tomcat`, `17.4.5-postgres-tomcat`]([])

- [`17.4-mariadb-tomcat`, `17.4.5-mariadb-tomcat`]([])

- [`16`, `16.10`, `16.10.12`, `16-mysql-tomcat`, `16.10-mysql-tomcat`, `16.10.12-mysql-tomcat`, `lts-mysql-tomcat`, `lts-mysql`, `lts`]([])

- [`16-postgres-tomcat`, `16.10-postgres-tomcat`, `16.10.12-postgres-tomcat`, `lts-postgres-tomcat`, `lts-postgres`]([])

- [`16-mariadb-tomcat`, `16.10-mariadb-tomcat`, `16.10.12-mariadb-tomcat`, `lts-mariadb-tomcat`, `lts-mariadb`]([])


## 快速参考（续）

- **问题反馈渠道**：  
  [XWiki Docker JIRA 项目]([])

- **支持的架构**：（[更多信息]([])）  
  [`amd64`]([]), [`arm64v8`]([])

- **镜像详情**：  
  [repo-info 仓库的 `repos/xwiki/` 目录]([])（[历史记录]([])）  
  （包含镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images 仓库的 `library/xwiki` 标签]([])  
  [official-images 仓库的 `library/xwiki` 文件]([])（[历史记录]([])）

- **本描述来源**：  
  [docs 仓库的 `xwiki/` 目录]([])（[历史记录]([])）


## 关于 XWiki

[XWiki]([]) 是 Java 编写的免费 wiki 软件平台，设计重点在于可扩展性，属于企业级 wiki。它具备 WYSIWYG 编辑、基于 OpenDocument 的文档导入/导出、语义标注与标签功能，以及高级权限管理。

作为应用级 wiki，XWiki 支持结构化数据存储和 wiki 界面内的服务器端脚本执行。可通过 wiki 宏在 wiki 页面中直接编写 Velocity、Groovy、Python、Ruby、PHP 等脚本语言。用户可在 wiki 文档中定义数据结构，结构实例可附加到 wiki 文档、存储在数据库中，并通过 Hibernate 查询语言或 XWiki 自有查询语言进行查询。

[XWiki 扩展 wiki]([]) 汇集了各类 XWiki 扩展，包括可直接粘贴到 wiki 页面的[代码片段]([])，以及可加载的核心模块。XWiki Enterprise 的许多功能都由捆绑的扩展提供。

![logo]([])


## 使用方法

使用方法请查阅 [文档]([])。


## 许可证

XWiki 采用 [LGPL 2.1]([]) 许可证。  
Dockerfile 仓库同样采用 [LGPL 2.1]([]) 许可证。  

与所有 Docker 镜像一样，本镜像可能包含其他软件，这些软件可能采用不同许可证（如基础发行版中的 Bash 等，以及主要软件的直接或间接依赖）。  

部分自动检测到的额外许可证信息可在 [repo-info 仓库的 `xwiki/` 目录]([]) 中查看。  

对于预构建镜像的使用，用户需自行确保其使用行为符合镜像中所有软件的相关许可证要求。

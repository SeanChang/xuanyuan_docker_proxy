---
image: library/solr
description: "Solr是一款基于Apache Lucene构建的极速、开源多模态搜索平台，它凭借Lucene强大的底层索引与检索技术，实现了超快速的信息响应能力，作为开源项目具备高度灵活性与可扩展性，支持文本、图像等多种模态数据的搜索需求，广泛应用于企业级信息检索、内容管理等场景，为用户提供高效、精准且可定制的搜索体验。"
source: https://xuanyuan.cloud/zh/r/library/solr
canonical: https://xuanyuan.cloud/zh/r/library/solr
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/solr" title="library/solr Docker 镜像中文简介、标签列表与拉取命令">library/solr 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Solr Docker 镜像介绍


## 快速参考

- **维护方**：  
  [Apache Solr 项目]([])

- **获取帮助**：  
  [Solr 社区]([])


## 支持的标签及 Dockerfile 链接

- [`9.9.0`, `9.9`, `9`, `latest`]([])  

- [`9.9.0-slim`, `9.9-slim`, `9-slim`, `slim`]([])  


## 扩展参考信息

- **问题反馈**：  
  [Solr 用户邮件列表]([])

- **支持架构**（[更多信息]([])）：  
  [`amd64`]([])、[`arm64v8`]([])、[`ppc64le`]([])、[`s390x`]([])

- **镜像详情**：  
  [repo-info 仓库的 `repos/solr/` 目录]([])（[历史记录]([])）  
  （包含镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images 仓库的 `library/solr` 标签]([])  
  [official-images 仓库的 `library/solr` 文件]([])（[历史记录]([])）

- **本文档来源**：  
  [docs 仓库的 `solr/` 目录]([])（[历史记录]([])）  


## 什么是 Solr？

Solr 是基于 Apache Lucene 构建的开源多模态搜索平台，以速度快著称。它支持全文、向量、分析和地理空间搜索，被全球众多大型组织采用。主要功能还包括 Kubernetes 集成、流处理、高亮显示、分面搜索和拼写检查等。

了解更多信息可访问 [Apache Solr 官网]([]) 和 [Apache Solr 参考指南]([])。


## 如何使用该 Docker 镜像

完整文档可参考 [Solr 参考指南的 Docker 章节]([])。

### 运行单个 Solr 服务器：

```console
$ docker run -p 8983:8983 -t solr
```

然后在浏览器中访问 [] 即可打开 Solr 管理控制台。


## 关于本仓库

本仓库托管于 [github.com/apache/solr-docker]([])，但镜像的构建和维护由 Apache Solr 项目直接负责（[github.com/apache/solr]([])）。

使用相关问题可通过 [Solr 用户邮件列表]([]) 提问。


## 镜像变体

Solr 镜像提供多种版本，适用于不同场景：

### `solr:<version>`
这是默认镜像，包含常用依赖包，适用于大多数场景。既可作为临时容器运行（挂载代码后直接启动），也可作为基础镜像构建其他镜像。

### `solr:<version>-slim`
精简版镜像，仅包含运行 Solr 所需的最小依赖包。除非部署环境空间受限且仅需运行 Solr，否则建议优先使用默认镜像。


## 许可证

Solr 基于 [Apache License, Version 2.0]([]) 许可。  
本仓库同样基于 [Apache License, Version 2.0]([]) 许可。

版权所有 2015-2022 The Apache Software Foundation

根据许可条款，您需遵守许可协议方可使用本文件。许可协议副本可从 [] 获取。

除非法律要求或书面同意，软件按"原样"分发，不提供任何明示或暗示的担保。具体权限和限制请参见许可协议。

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础系统的 Bash 等），这些软件可能采用其他许可协议。部分自动检测到的许可信息可在 [repo-info 仓库的 solr/ 目录]([]) 中找到。

使用预构建镜像时，用户需自行确保其使用符合所有包含软件的许可要求。

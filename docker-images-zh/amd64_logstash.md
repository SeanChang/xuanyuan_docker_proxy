---
image: amd64/logstash
description: "Logstash是一款开源数据收集引擎，具备实时管道处理能力，可动态统一来自不同来源的数据并将其标准化到指定目标，用于事件和日志管理。"
source: https://xuanyuan.cloud/zh/r/amd64/logstash
canonical: https://xuanyuan.cloud/zh/r/amd64/logstash
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/logstash" title="amd64/logstash Docker 镜像中文简介、标签列表与拉取命令">amd64/logstash 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**注意**：这是[`logstash`官方镜像](https://hub.docker.com/_/logstash)的`amd64`架构构建的“每个架构”仓库——更多信息，请参见官方镜像文档中的“[非amd64架构？](https://github.com/docker-library/official-images#architectures-other-than-amd64)”和官方镜像FAQ中的“[Git中镜像的源代码已更改，现在该怎么办？](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)”。

## 快速参考

- **维护者**：  
  [Elastic团队](https://github.com/elastic/logstash)

- **获取帮助的地方**：  
  [Logstash Discuss论坛](https://discuss.elastic.co/c/logstash)和[Elastic社区](https://www.elastic.co/community)。

## 支持的标签及对应的`Dockerfile`链接

- [`8.17.10`](https://github.com/elastic/dockerfiles/blob/3861498adce22926e852b1bbec340f159147a47f/logstash/Dockerfile)

- [`8.18.8`](https://github.com/elastic/dockerfiles/blob/6a7937aa369e0368020bcff78884c2b3645c50dd/logstash/Dockerfile)

- [`8.19.5`](https://github.com/elastic/dockerfiles/blob/eadd67c326b8c6c63acff9d8e9fced4cb29b92ed/logstash/Dockerfile)

- [`9.0.8`](https://github.com/elastic/dockerfiles/blob/dd7bdb10765be40ea5cab6c64054df56b65860eb/logstash/Dockerfile)

- [`9.1.5`](https://github.com/elastic/dockerfiles/blob/b73ebec6aca17cdb8504bfcfddd954f772905a74/logstash/Dockerfile)

## 快速参考（续）

- **提交问题的地方**：  
  有关Logstash Docker镜像或Logstash的问题：https://github.com/elastic/logstash/issues

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/logstash/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/logstash/)

- **已发布镜像工件详情**：  
  [repo-info仓库的`repos/logstash/`目录](https://github.com/docker-library/repo-info/blob/master/repos/logstash)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/logstash)）  
  （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的`library/logstash`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Flogstash)  
  [official-images仓库的`library/logstash`文件](https://github.com/docker-library/official-images/blob/master/library/logstash)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/logstash)）

- **本描述的来源**：  
  [docs仓库的`logstash/`目录](https://github.com/docker-library/docs/tree/master/logstash)（[历史记录](https://github.com/docker-library/docs/commits/master/logstash)）

## 什么是Logstash？

Logstash是一款开源数据收集引擎，具有实时管道处理能力。Logstash可以动态统一来自不同来源的数据，并将数据标准化到您选择的目标。

数据收集通过多种可配置的输入插件实现，包括原始套接字/数据包通信、文件尾随和多个消息总线客户端。一旦输入插件收集到数据，就可以由多个过滤器处理，这些过滤器修改和注释事件数据。最后，事件被路由到输出插件，输出插件可以将事件转发到各种外部程序，包括Elasticsearch、本地文件和多个消息总线实现。

> 有关Logstash的更多信息，请访问[www.elastic.co/products/logstash](https://www.elastic.co/products/logstash)

![logo](https://raw.githubusercontent.com/docker-library/docs/0ec96bc990cb13028308932386c3820d0de5d3c1/logstash/logo.png)

## 关于此镜像

此默认发行版受Elastic许可证管辖，包含[完整的免费功能集](https://www.elastic.co/subscriptions)。

查看详细发行说明[此处](https://www.elastic.co/guide/en/logstash/current/releasenotes.html)。

未找到您需要的版本？查看所有支持的[过往版本](https://www.docker.elastic.co)。

## 如何使用此镜像

**注意**：拉取镜像需要使用特定的版本号标签。不支持`latest`标签。

对于6.4.0之前的Logstash版本，完整的镜像、标签和文档列表可在[docker.elastic.co](https://www.docker.elastic.co)找到。

完整的Logstash文档请参见[此处](https://www.elastic.co/guide/en/logstash/current/index.html)。

有关运行Docker镜像的具体说明，请参见Logstash文档的[此部分](https://www.elastic.co/guide/en/logstash/current/docker-config.html)。

## 许可证

查看此镜像中包含的软件的[许可证信息](https://github.com/elastic/logstash/blob/6.4/licenses/ELASTIC-LICENSE.txt)。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能受其他许可证（如基础发行版中的Bash等，以及主要软件的任何直接或间接依赖项）约束。

一些能够自动检测到的其他许可证信息可能位于[`repo-info`仓库的`logstash/`目录](https://github.com/docker-library/repo-info/tree/master/repos/logstash)中。

对于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用都符合其中包含的所有软件的相关许可证。

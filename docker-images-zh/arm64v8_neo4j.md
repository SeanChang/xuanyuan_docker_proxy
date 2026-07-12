---
image: arm64v8/neo4j
description: "Neo4j是一款高度可扩展、稳健的原生图数据库。"
source: https://xuanyuan.cloud/zh/r/arm64v8/neo4j
canonical: https://xuanyuan.cloud/zh/r/arm64v8/neo4j
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/neo4j" title="arm64v8/neo4j Docker 镜像中文简介、标签列表与拉取命令">arm64v8/neo4j 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**注意**：这是[`neo4j`官方镜像](https://hub.docker.com/_/neo4j)的`arm64v8`架构构建的"per-architecture"仓库——更多信息，请参见官方镜像文档中的"除amd64之外的架构？"[章节](https://github.com/docker-library/official-images#architectures-other-than-amd64)以及官方镜像FAQ中的"Git中的镜像源已更改，现在该怎么办？"[章节](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

## 快速参考

- **维护者**：
  [Neo4j](https://github.com/neo4j/docker-neo4j)

- **获取帮助**：
  [Neo4j社区论坛](https://community.neo4j.com)

## 支持的标签及对应的`Dockerfile`链接

- [`2025.09.0-community-bullseye`, `2025.09-community-bullseye`, `2025-community-bullseye`, `2025.09.0-community`, `2025.09-community`, `2025-community`, `2025.09.0-bullseye`, `2025.09-bullseye`, `2025-bullseye`, `2025.09.0`, `2025.09`, `2025`, `community-bullseye`, `community`, `bullseye`, `latest`](https://github.com/neo4j/docker-neo4j-publish/blob/439722772cf16662310df3e1d8f898272454f85a/2025.09.0/bullseye/community/Dockerfile)

- [`2025.09.0-enterprise-bullseye`, `2025.09-enterprise-bullseye`, `2025-enterprise-bullseye`, `2025.09.0-enterprise`, `2025.09-enterprise`, `2025-enterprise`, `enterprise-bullseye`, `enterprise`](https://github.com/neo4j/docker-neo4j-publish/blob/439722772cf16662310df3e1d8f898272454f85a/2025.09.0/bullseye/enterprise/Dockerfile)

- [`2025.09.0-community-ubi9`, `2025.09-community-ubi9`, `2025-community-ubi9`, `2025.09.0-ubi9`, `2025.09-ubi9`, `2025-ubi9`, `community-ubi9`, `ubi9`](https://github.com/neo4j/docker-neo4j-publish/blob/439722772cf16662310df3e1d8f898272454f85a/2025.09.0/ubi9/community/Dockerfile)

- [`2025.09.0-enterprise-ubi9`, `2025.09-enterprise-ubi9`, `2025-enterprise-ubi9`, `enterprise-ubi9`](https://github.com/neo4j/docker-neo4j-publish/blob/439722772cf16662310df3e1d8f898272454f85a/2025.09.0/ubi9/enterprise/Dockerfile)

- [`5.26.13-community-bullseye`, `5.26-community-bullseye`, `5-community-bullseye`, `5.26.13-community`, `5.26-community`, `5-community`, `5.26.13-bullseye`, `5.26-bullseye`, `5-bullseye`, `5.26.13`, `5.26`, `5`](https://github.com/neo4j/docker-neo4j-publish/blob/d44444984815d59a51beeb9bf70a660d92cd6be8/5.26.13/bullseye/community/Dockerfile)

- [`5.26.13-enterprise-bullseye`, `5.26-enterprise-bullseye`, `5-enterprise-bullseye`, `5.26.13-enterprise`, `5.26-enterprise`, `5-enterprise`](https://github.com/neo4j/docker-neo4j-publish/blob/d44444984815d59a51beeb9bf70a660d92cd6be8/5.26.13/bullseye/enterprise/Dockerfile)

- [`5.26.13-community-ubi9`, `5.26-community-ubi9`, `5-community-ubi9`, `5.26.13-ubi9`, `5.26-ubi9`, `5-ubi9`](https://github.com/neo4j/docker-neo4j-publish/blob/d44444984815d59a51beeb9bf70a660d92cd6be8/5.26.13/ubi9/community/Dockerfile)

- [`5.26.13-enterprise-ubi9`, `5.26-enterprise-ubi9`, `5-enterprise-ubi9`](https://github.com/neo4j/docker-neo4j-publish/blob/d44444984815d59a51beeb9bf70a660d92cd6be8/5.26.13/ubi9/enterprise/Dockerfile)

- [`4.4.46`, `4.4.46-community`, `4.4`, `4.4-community`](https://github.com/neo4j/docker-neo4j-publish/blob/439722772cf16662310df3e1d8f898272454f85a/4.4.46/bullseye/community/Dockerfile)

- [`4.4.46-enterprise`, `4.4-enterprise`](https://github.com/neo4j/docker-neo4j-publish/blob/439722772cf16662310df3e1d8f898272454f85a/4.4.46/bullseye/enterprise/Dockerfile)

## 快速参考（续）

- **问题提交地址**：
  [https://github.com/neo4j/docker-neo4j/issues](https://github.com/neo4j/docker-neo4j/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))
  [`amd64`](https://hub.docker.com/r/amd64/neo4j/), [`arm64v8`](https://hub.docker.com/r/arm64v8/neo4j/)

- **已发布镜像制品详情**：
  [repo-info仓库的`repos/neo4j/`目录](https://github.com/docker-library/repo-info/blob/master/repos/neo4j) ([历史记录](https://github.com/docker-library/repo-info/commits/master/repos/neo4j))
  （镜像元数据、传输大小等）

- **镜像更新**：
  [official-images仓库的`library/neo4j`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fneo4j)
  [official-images仓库的`library/neo4j`文件](https://github.com/docker-library/official-images/blob/master/library/neo4j) ([历史记录](https://github.com/docker-library/official-images/commits/master/library/neo4j))

- **本描述的来源**：
  [docs仓库的`neo4j/`目录](https://github.com/docker-library/docs/tree/master/neo4j) ([历史记录](https://github.com/docker-library/docs/commits/master/neo4j))

## 什么是Neo4j？

Neo4j是全球领先的图数据库，具有原生图存储和处理能力。您可以[在此处](http://neo4j.com/developer)了解更多信息。

![logo](https://raw.githubusercontent.com/docker-library/docs/56823e63d5b6dd7ddbb9d5d3c4a8947778055d8e/neo4j/logo.png)

## 如何使用此镜像

您可以这样启动Neo4j容器：

```console
docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    docker.xuanyuan.run/arm64v8/neo4j
```

这允许您通过浏览器访问neo4j：[http://localhost:7474](http://localhost:7474)。

此命令绑定了两个端口（`7474`和`7687`），分别用于HTTP和Bolt协议访问Neo4j API。数据卷挂载到`/data`目录，以允许数据库在容器外部持久化存储。

默认情况下，您需要使用`neo4j/neo4j`登录并修改密码。对于开发环境，您可以通过向docker run命令传递`--env=NEO4J_AUTH=none`来禁用认证。

## 文档

更多示例和完整文档，请访问我们的手册[此处](http://neo4j.com/docs/operations-manual/current/deployment/single-instance/docker/)。

## 许可证

查看此镜像中包含的软件的[许可信息](https://neo4j.com/licensing)。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可证（例如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

一些能够自动检测到的额外许可信息可能位于[`repo-info`仓库的`neo4j/`目录](https://github.com/docker-library/repo-info/tree/master/repos/neo4j)中。

对于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用符合其中包含的所有软件的相关许可证。

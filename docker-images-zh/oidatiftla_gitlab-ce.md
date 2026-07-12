---
image: oidatiftla/gitlab-ce
description: "gitlab/gitlab-ce的镜像，提供更多标签（major和major.minor）"
source: https://xuanyuan.cloud/zh/r/oidatiftla/gitlab-ce
canonical: https://xuanyuan.cloud/zh/r/oidatiftla/gitlab-ce
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oidatiftla/gitlab-ce" title="oidatiftla/gitlab-ce Docker 镜像中文简介、标签列表与拉取命令">oidatiftla/gitlab-ce 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述

该镜像为gitlab/gitlab-ce的镜像，主要特点是提供了额外的版本标签，方便用户根据版本需求选择特定范围的GitLab CE版本。

## 标签说明

支持以下标签类型：
- `major`：对应主版本号（如`16`），指向该主版本下的最新版本。
- `major.minor`：对应主版本.次版本号（如`16.1`），指向该主次版本组合下的最新版本。

## 部署示例

### 拉取镜像
使用`major`标签拉取最新主版本：
```bash
docker pull docker.xuanyuan.run/[镜像名称]:major
```

使用`major.minor`标签拉取特定主次版本：
```bash
docker pull docker.xuanyuan.run/[镜像名称]:major.minor
```

### 运行容器
基本运行命令（需替换[镜像名称]为实际镜像名称）：
```bash
docker run -d --name gitlab-ce -p 80:80 -p 443:443 -v /srv/gitlab:/var/opt/gitlab [镜像名称]:major
```

> 注：建议根据GitLab官方文档配置数据卷、环境变量及端口映射，确保数据持久化和服务可用性。

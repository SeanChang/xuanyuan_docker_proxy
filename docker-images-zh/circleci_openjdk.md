---
image: circleci/openjdk
description: "CircleCI针对OpenJDK的扩展镜像，用于在CircleCI环境中优化Java项目的构建和运行，简化Docker与CircleCI的采用流程。"
source: https://xuanyuan.cloud/zh/r/circleci/openjdk
canonical: https://xuanyuan.cloud/zh/r/circleci/openjdk
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/circleci/openjdk" title="circleci/openjdk Docker 镜像中文简介、标签列表与拉取命令">circleci/openjdk — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/circleci/openjdk" title="circleci/openjdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/circleci/openjdk</a>

# CircleCI OpenJDK 镜像文档

## 注意事项
由于Docker Hub限制，标签页显示的变体可能少于实际可用变体。完整变体列表及Dockerfile，请参见 **[circleci-dockerfiles](https://github.com/CircleCI-Public/circleci-dockerfiles)** 仓库。

来自 [hub.docker.com/r/circleci](https://hub.docker.com/r/circleci) 的镜像在 **circleci-dockerfiles 的 [master 分支](https://github.com/circleci-public/circleci-dockerfiles)** 中跟踪；来自 [hub.docker.com/r/ccistaging](https://hub.docker.com/r/ccistaging) 的镜像在 **circleci-dockerfiles 的 [staging 分支](https://github.com/CircleCI-Public/circleci-dockerfiles/tree/staging)** 中跟踪。

## 关注镜像变更与公告
作为常规维护的一部分，各类镜像会不定期更新，包括更新内容、调整变体标签方式等。除 bug 修复或安全补丁外，变更均会提前公告。相关信息发布在 CircleCI Discuss 的公告版块，帖子带有 `convenience-images` 标签：
- 公告版块：https://discuss.circleci.com/c/announcements
- 标签页面：https://discuss.circleci.com/tags/convenience-images

创建 Discuss 账号后，可订阅相关帖子以接收邮件通知：https://discuss.circleci.com

## 镜像概述与用途
该镜像扩展自官方 [Java](https://hub.docker.com/_/openjdk) 镜像，针对 CircleCI 环境进行优化，旨在简化 Docker 与 CircleCI 的采用流程。成功使用后，建议用户根据项目需求构建自定义镜像。

## 实验性说明
此镜像处于实验阶段，未来可能发生不兼容变更。建议用户构建自有镜像，或在 CircleCI 配置中固定特定 `sha256` 摘要。示例配置：
```yaml
docker:
  - image: redis@sha256:54057dd7e125ca41afe526a877e8bd35ec2cdd33b9217e022ed37bdcf7d09673
```

## 用户反馈
如遇问题或有疑问，请通过 [CircleCI Discuss 论坛](https://discuss.circleci.com/c/environment) 联系。

## 源码地址
https://github.com/circleci/circleci-images

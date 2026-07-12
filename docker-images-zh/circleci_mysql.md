---
image: circleci/mysql
description: "CircleCI的实验性MySQL镜像，扩展官方MySQL镜像以在CircleCI环境中便于测试使用，预设了空密码、测试数据库等配置。"
source: https://xuanyuan.cloud/zh/r/circleci/mysql
canonical: https://xuanyuan.cloud/zh/r/circleci/mysql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/circleci/mysql" title="circleci/mysql Docker 镜像中文简介、标签列表与拉取命令">circleci/mysql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CircleCI 实验性 MySQL 镜像

## 镜像概述和主要用途
本镜像为CircleCI的实验性MySQL镜像，基于[官方MySQL镜像](https://dockerhub.com/_/mysql)扩展而来，旨在优化其在CircleCI环境中的测试使用体验。通过预设特定配置，简化用户在CircleCI中部署MySQL进行测试的流程。

## 核心功能和特性
- **基于官方镜像**：继承官方MySQL镜像的所有功能和特性
- **预设测试配置**：通过Dockerfile设置以下环境变量，无需额外配置即可快速使用：
  ```dockerfile
  FROM docker.xuanyuan.run/mysql:latest
  ENV MYSQL_ALLOW_EMPTY_PASSWORD=true \
      MYSQL_DATABASE=circle_test \
      MYSQL_HOST=127.0.0.1 \
      MYSQL_ROOT_HOST=% \
      MYSQL_USER=root
  ```
- **CircleCI友好**：针对CircleCI测试环境进行优化，减少测试环境配置时间

## 使用场景和适用范围
适用于在CircleCI持续集成/持续部署流程中需要MySQL数据库支持的测试场景，帮助开发者快速搭建测试用MySQL环境，验证数据库相关功能。

## 使用方法和配置说明
### 在CircleCI配置中使用
可在CircleCI配置文件（如`.circleci/config.yml`）中作为服务镜像引用，示例：
```yaml
version: 2.1
jobs:
  test:
    docker:
      - image: cimg/base:stable
      - image: circleci/mysql:latest  # 使用本实验性镜像
    steps:
      - checkout
      - run: echo "连接到MySQL测试数据库"
      - run: mysql -h 127.0.0.1 -u root circle_test -e "SELECT 1;"
```

## 实验性说明
CircleCI正在对本服务镜像进行实验性开发，未来可能会进行不兼容的变更。建议用户考虑构建自己的镜像，或在CircleCI配置文件中锁定镜像摘要（digest）以确保稳定性。

## 用户反馈
### 问题反馈
如在使用本镜像过程中遇到问题或有疑问，请通过[CircleCI Discuss Forum](https://discuss.circleci.com/c/ecosystem/circleci-images)与我们联系。

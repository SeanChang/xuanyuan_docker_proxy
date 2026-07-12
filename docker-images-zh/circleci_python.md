---
image: circleci/python
description: "CircleCI提供的Python扩展镜像，基于官方Python镜像，预装开发和CI常用工具（如git、ssh、docker等），默认使用非root用户，支持浏览器测试等变体，适用于CI/CD流程和开发环境。"
source: https://xuanyuan.cloud/zh/r/circleci/python
canonical: https://xuanyuan.cloud/zh/r/circleci/python
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/circleci/python" title="circleci/python Docker 镜像中文简介、标签列表与拉取命令">circleci/python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CircleCI Python 镜像

## 镜像概述和主要用途
CircleCI Python镜像是对官方Python镜像的扩展，旨在满足开发和CI（持续集成）环境的特定需求。它解决了官方镜像在CI/CD场景中缺乏必要工具的问题，提供了更适合自动化构建、测试和部署的环境。

## 核心功能和特性
该镜像通过以下方式扩展官方Python镜像：
1. **预装常用开发和CI工具**：包含`git`、`ssh`、`tar`、`ca-certificates`、`curl`、`wget`等常用工具，满足日常开发和CI流程需求。
2. **集成Docker工具**：安装最新版`docker`、`docker-compose`和`dockerize`，支持容器化环境中的构建和部署操作。
3. **提供场景化变体**：针对常见用例提供变体，如预装Firefox和Chrome/chromedriver的浏览器测试镜像，配置为可在容器环境中运行。
4. **默认非root用户**：使用`circleci`用户作为默认用户，避免部分应用（如Chrome）拒绝以root运行或行为异常（如`tar`文件所有权问题）。

## 使用场景和适用范围
- 适用于CircleCI或其他CI/CD平台上的Python项目构建、测试和部署流程。
- 适合需要浏览器自动化测试的Python应用（如Selenium测试）。
- 适用于需要在容器环境中使用Docker工具的开发和CI场景。

## 主要变体
### `python:<version>`
默认镜像，包含核心工具和功能，适合大多数开发和CI场景。如果不确定需求，建议使用此变体。

### `python:<version>-browsers`
扩展默认镜像，预装Firefox和Chrome/chromedriver，并配置为可在容器环境中运行，简化浏览器测试流程。

> **注意**：由于Docker Hub限制，[Tags页面](https://hub.docker.com/r/circleci/python/tags)可能未显示所有变体。完整变体列表及Dockerfiles请参见[circleci-public/circleci-dockerfiles仓库](https://github.com/CircleCI-Public/circleci-dockerfiles/tree/master/python/images)。

## 使用方法示例
### 基本使用（默认镜像）
```bash
docker run -it --rm docker.xuanyuan.run/circleci/python:3.9
```

### 浏览器测试场景（使用浏览器变体）
```bash
docker run -it --rm docker.xuanyuan.run/circleci/python:3.9-browsers python -c "from selenium import webdriver; driver = webdriver.Chrome(); driver.get('https://example.com'); print(driver.title); driver.quit()"
```

## 用户反馈
### 问题反馈
如遇到镜像相关问题或有疑问，请通过[CircleCI Discuss Forum](https://discuss.circleci.com/c/ecosystem/circleci-images)联系我们。

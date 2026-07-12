---
image: atlassian/default-image
description: "Bitbucket流水线的默认构建环境，用于支持其构建流程。"
source: https://xuanyuan.cloud/zh/r/atlassian/default-image
canonical: https://xuanyuan.cloud/zh/r/atlassian/default-image
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/default-image" title="atlassian/default-image Docker 镜像中文简介、标签列表与拉取命令">atlassian/default-image 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitbucket Pipelines 默认构建环境镜像文档


## 1. 镜像概述

### 1.1 主要用途
本镜像为 Bitbucket Pipelines 的默认构建环境，当用户未在配置中指定自定义镜像时，Pipelines 将使用本镜像运行自动化构建任务。其设计目标是提供一个预配置的通用开发环境，支持多种编程语言和构建工具，满足常见的持续集成/持续部署（CI/CD）需求。


## 2. 核心功能与特性

### 2.1 预装开发工具
集成多种常用开发、构建和运维工具，覆盖版本控制、编程语言、构建工具等类别，无需额外安装即可快速启动构建流程：
- **版本控制**：Git、SSH 客户端
- **编程语言**：Node.js（含 npm、nvm）、Python、GCC（C/C++ 编译器）
- **构建工具**：Ant、Docker CLI、Buildx、Docker Compose
- **实用工具**：Wget、Curl、Zip/Unzip、Tar、JQ、Parallel、Xvfb（虚拟显示服务）

### 2.2 环境配置
- 默认支持 UTF-8 字符编码（`LANG=C.UTF-8`），避免中文等特殊字符乱码问题
- 内置 Xvfb 虚拟显示服务（`DISPLAY=:99`），支持需要 GUI 环境的测试任务（如前端自动化测试）
- 通过 NVM（Node Version Manager）管理 Node.js 版本，可灵活切换 Node 环境


## 3. 版本信息

### 3.1 推荐版本（v5.x）
| 类别         | 版本详情                          |
|--------------|-----------------------------------|
| 基础平台     | Ubuntu 24.04 (LTS)                |
| Git          | 2.49.0                            |
| Node.js      | 22.15.0                           |
| npm          | 10.9.2                            |
| nvm          | 0.40.3                            |
| Python       | 3.12.3                            |
| GCC          | 13.2.0                            |
| Ant          | 1.10.14                           |
| Docker 工具  | Docker CLI 28.1.1、Buildx 0.23.0、Docker Compose 2.36.0 |
| 其他工具     | Wget、Xvfb、Curl、SSH、Zip、JQ、Tar、Parallel |


### 3.2 历史版本（已弃用）
> ⚠️ 以下版本已停止更新，不推荐用于新构建任务，仅作历史参考。

#### v4.x
- 平台：Ubuntu 22.04 (LTS)
- 核心工具版本：Git 2.39.1、Node.js 18.20.6、npm 9.5.1、nvm 0.39.2、Python 3.10.6、GCC 11.3.0、Ant 1.10.12

#### v3.x
- 平台：Ubuntu 20.04 (LTS)
- 核心工具版本：Git 2.39.1、Node.js 14.17.5、npm 6.14.14、nvm 0.38.0、Python 3.8.10、GCC 9.4.0、Ant 1.10.7

#### v2.x
- 平台：Ubuntu 16.04
- 核心工具版本：Git 2.7.4、Mercurial 3.7.3、OpenJDK 1.8u151、Maven 3.3.9、Node.js 8.9.4、npm 5.6.0、nvm 0.33.8、Python 2.7.12、GCC 5.4.0、Ant 1.9.6

#### v1.x / latest（标签）
- 平台：Ubuntu 14.04
- 核心工具版本：Git 1.9.1、OpenJDK 1.8u66、Maven 3.0.5、Node.js 4.2.1、npm 2.14.7、nvm 0.29.0、Python 2.7.6、GCC 4.8.4


## 4. 使用方法

### 4.1 版本选择说明
- **默认行为**：若未在 `bitbucket-pipelines.yml` 中指定 `image` 字段，Pipelines 将自动使用 `atlassian/default-image:latest`（对应 v1.x，已弃用）。
- **推荐配置**：为避免兼容性问题，强烈建议显式指定版本标签 `atlassian/default-image:5`（使用最新 v5.x 版本）。


### 4.2 Bitbucket Pipelines 配置示例
在项目根目录的 `bitbucket-pipelines.yml` 中配置使用本镜像：

```yaml
# 指定默认镜像为 v5.x 版本
image: docker.xuanyuan.run/atlassian/default-image:5

pipelines:
  default:  # 对所有分支生效
    - step:
        name: 构建与测试
        script:
          - echo "当前 Node.js 版本: $(node --version)"
          - echo "当前 Python 版本: $(python --version)"
          - npm install  # 安装 Node.js 依赖
          - python -m pip install -r requirements.txt  # 安装 Python 依赖
          - npm run test  # 运行测试
          - docker --version  # 验证 Docker CLI 可用性

  branches:
    main:  # 仅对 main 分支生效
      - step:
          name: 部署生产环境
          script:
            - echo "部署任务执行中..."
```


## 5. 环境变量说明
镜像预定义以下环境变量，可在构建脚本中直接使用：

| 变量名         | 示例值                  | 描述                                  |
|----------------|-------------------------|---------------------------------------|
| `NVM_DIR`      | `/root/.nvm`            | NVM（Node Version Manager）安装目录   |
| `NODE_VERSION` | `22.15.0`               | 默认安装的 Node.js 版本               |
| `NVM_VERSION`  | `0.40.3`                | NVM 工具版本                          |
| `NODE_PATH`    | `/root/.nvm/v22.15.0/lib/node_modules` | Node.js 模块查找路径             |
| `LANG`         | `C.UTF-8`               | 系统字符编码（默认 UTF-8）            |
| `LC_ALL`       | `C.UTF-8`               | 全局字符编码设置                      |
| `DISPLAY`      | `:99`                   | Xvfb 虚拟显示端口（支持 GUI 测试）    |


## 6. 支持与反馈
如需技术支持，请访问 [Atlassian 官方支持页面](https://support.atlassian.com/)。

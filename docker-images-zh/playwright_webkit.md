---
image: playwright/webkit
description: "为Moon软件提供的Playwright Webkit Docker镜像，用于支持Webkit浏览器环境下的相关操作与应用。"
source: https://xuanyuan.cloud/zh/r/playwright/webkit
canonical: https://xuanyuan.cloud/zh/r/playwright/webkit
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/playwright/webkit" title="playwright/webkit Docker 镜像中文简介、标签列表与拉取命令">playwright/webkit 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Playwright WebKit 镜像（适用于 Moon 软件）


## 1. 镜像概述

本镜像为 **Moon 软件**（<https://aerokube.com/moon/>）专用的 Playwright WebKit 浏览器镜像，提供基于 WebKit 引擎的自动化测试环境。**仅与 Moon 软件兼容**，不可直接替代官方 Playwright 镜像（官方镜像地址：<https://hub.docker.com/_/microsoft-playwright>）。


## 2. 核心功能与特性

### 2.1 基础功能
- 内置 Playwright WebKit 浏览器，支持 WebKit 内核的网页渲染与交互
- 预配置自动化测试依赖环境，无需手动安装浏览器及驱动

### 2.2 Moon 软件集成
- 深度适配 Moon 软件架构，支持与 Moon 分布式测试平台联动
- 内置 Moon 测试任务调度所需的通信协议与配置模块

### 2.3 测试环境优化
- 最小化镜像体积，仅包含 WebKit 相关依赖
- 支持无头模式（Headless）运行，适合 CI/CD 环境集成


## 3. 使用场景与适用范围

### 3.1 主要场景
- 基于 Moon 软件的 WebKit 浏览器自动化测试（如前端功能测试、兼容性测试）
- 配合 Moon 平台进行分布式 WebKit 测试任务调度
- 轻量级 WebKit 测试环境快速部署

### 3.2 适用范围
- 需通过 Moon 软件管理的 Web 应用自动化测试场景
- 依赖 WebKit 引擎的前端测试用例执行
- CI/CD 流水线中集成 Moon 测试任务


## 4. 使用方法与配置说明

### 4.1 前置条件
- 已安装 Docker 环境（20.10+ 版本）
- 已部署 Moon 软件服务（参考 Moon 官方文档：<https://aerokube.com/moon/docs/>）


### 4.2 镜像拉取
```bash
docker pull docker.xuanyuan.run/[镜像仓库地址]/playwright-webkit-moon:latest  # 替换为实际镜像仓库地址
```


### 4.3 容器运行示例
```bash
docker run -d \
  --name playwright-webkit-moon-test \
  -e MOON_SERVER_URL="http://moon-server:4444" \  # Moon 服务地址
  -e TEST_SUITE_PATH="/tests" \                  # 测试用例目录（容器内路径）
  -v /local/tests:/tests \                       # 挂载本地测试用例到容器
  --network moon-network \                       # 连接到 Moon 服务所在网络
  [镜像仓库地址]/playwright-webkit-moon:latest \
  moon run-test --browser=webkit --suite=/tests   # Moon 测试任务启动命令
```


### 4.4 核心配置参数

#### 4.4.1 环境变量
| 变量名              | 说明                                  | 示例值                          |
|---------------------|---------------------------------------|---------------------------------|
| `MOON_SERVER_URL`   | Moon 服务端地址（必填）               | `http://moon-server:4444`       |
| `TEST_SUITE_PATH`   | 测试用例在容器内的路径（必填）        | `/tests`                        |
| `HEADLESS_MODE`     | 是否启用无头模式（可选，默认 `true`） | `true` / `false`                |
| `PLAYWRIGHT_TIMEOUT`| 测试超时时间（秒，可选，默认 300）    | `600`                           |

#### 4.4.2 启动参数
| 参数                | 说明                                  | 示例值                          |
|---------------------|---------------------------------------|---------------------------------|
| `moon run-test`     | Moon 测试任务启动命令                 | `--browser=webkit --suite=/tests`|


## 5. 注意事项

- **兼容性限制**：本镜像**仅支持与 Moon 软件配合使用**，不支持独立运行或替换官方 Playwright 镜像。
- **网络配置**：容器需与 Moon 服务端在同一网络（或通过 `--network` 参数指定），确保通信正常。
- **测试用例挂载**：本地测试用例需通过 `-v` 挂载到容器内 `TEST_SUITE_PATH` 指定的路径。
- **版本匹配**：建议使用与 Moon 软件版本兼容的镜像标签（如 `v1.2.0` 对应 Moon v1.2.x）。


## 6. 参考链接
- Moon 软件官方文档：<https://aerokube.com/moon/docs/>
- 官方 Playwright 镜像：<https://hub.docker.com/_/microsoft-playwright>

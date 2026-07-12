---
image: jacoblincool/playwright
description: "多架构（ARMv8/x64）、多基础系统（Ubuntu/Alpine）和多浏览器（Chromium/Firefox/WebKit/Chrome/Edge）的Playwright Docker镜像，支持自动化测试和浏览器操作。"
source: https://xuanyuan.cloud/zh/r/jacoblincool/playwright
canonical: https://xuanyuan.cloud/zh/r/jacoblincool/playwright
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jacoblincool/playwright" title="jacoblincool/playwright Docker 镜像中文简介、标签列表与拉取命令">jacoblincool/playwright 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Playwright Docker镜像

## 镜像概述和主要用途
Playwright Docker镜像是一系列多架构、多浏览器的Docker镜像，基于Playwright自动化测试工具构建。支持ARMv8（aarch64）和AMD64（x86_64）架构，提供基于Ubuntu的标准镜像和基于Alpine的轻量级镜像，包含Chromium、Firefox、WebKit、Chrome及Microsoft Edge等多种浏览器，适用于浏览器自动化测试、网页抓取、UI自动化等场景。

## 核心功能和特性
- **多架构支持**：同时兼容ARMv8（aarch64）和AMD64（x86_64）架构
- **多基础系统**：提供基于Ubuntu的标准镜像和基于Alpine的轻量级镜像
- **多浏览器覆盖**：包含Chromium、Firefox、WebKit、Chrome及Microsoft Edge
- **Playwright Server**：部分镜像内置Playwright Server，支持通过WebSocket远程连接浏览器实例
- **版本固定**：内置固定版本的Node.js和Playwright，确保环境一致性

## 标签说明

### 标准镜像标签
- `jacoblincool/playwright:base`：Node v22.14.0，Playwright 1.56.1（基础镜像，不含浏览器）
- `jacoblincool/playwright:chromium`：Node v22.14.0，Playwright 1.56.1，Chromium 141.0.7390.37
- `jacoblincool/playwright:firefox`：Node v22.14.0，Playwright 1.56.1，Mozilla Firefox 142.0.1
- `jacoblincool/playwright:webkit`：Node v22.14.0，Playwright 1.56.1，WPE WebKit 2.51.0
- `jacoblincool/playwright:chrome`：Node v22.14.0，Playwright 1.56.1，Google Chrome 141.0.7390.107
- `jacoblincool/playwright:msedge`：Node v22.14.0，Playwright 1.56.1，Microsoft Edge 141.0.3537.92
- `jacoblincool/playwright:all`：Node v22.14.0，Playwright 1.56.1，包含所有浏览器（Chromium/Firefox/WebKit/Chrome/Edge）

### 轻量级镜像标签
基于Alpine 3.21.5，体积更小，适用于资源受限环境：
- `jacoblincool/playwright:base-light`：Alpine 3.21.5，Node v25.0.0，Playwright 1.56.1（基础轻量镜像）
- `jacoblincool/playwright:chromium-light`：Alpine 3.21.5，Node v25.0.0，Playwright 1.56.1，Chromium 136.0.7103.113

## Playwright Server使用

Server镜像运行Playwright Server并暴露WebSocket端点，支持远程连接浏览器实例。

### 可用Server标签
- `jacoblincool/playwright:chromium-server`
- `jacoblincool/playwright:firefox-server`
- `jacoblincool/playwright:webkit-server`
- `jacoblincool/playwright:chrome-server`
- `jacoblincool/playwright:msedge-server`
- `jacoblincool/playwright:chromium-light-server`（轻量级）

### 环境变量配置
- `BROWSER_PORT`：自定义端口（默认：53333）
- `BROWSER_WS_ENDPOINT`：自定义WebSocket端点路径（默认：`/playwright`）

### 运行命令示例
```sh
# 运行轻量级Chromium Server
docker run --rm -p 53333:53333 docker.xuanyuan.run/jacoblincool/playwright:chromium-light-server
```

### 连接Server示例

#### JavaScript
```javascript
import { chromium } from "playwright";
const browser = await chromium.connect("ws://localhost:53333/playwright");
```

#### Python
```python
import asyncio
import playwright.async_api as playwright

async def main():
    async with playwright.async_playwright() as playwright:
        browser = await playwright.chromium.connect("ws://localhost:53333/playwright")

asyncio.run(main())
```

## 架构支持情况

### 标准镜像架构支持
| 浏览器       | ARMv8 (`aarch64`) | AMD64 (`x86_64`) |
|--------------| :---------------: | :--------------: |
| Chromium     |         ✅         |        ✅         |
| Firefox      |         ✅         |        ✅         |
| WebKit       |         ✅         |        ✅         |
| Chrome       |         ❌         |        ✅         |
| Edge         |         ❌         |        ✅         |

### 轻量级镜像架构支持
| 浏览器       | ARMv8 (`aarch64`) | AMD64 (`x86_64`) |
|--------------| :---------------: | :--------------: |
| Chromium     |         ✅         |        ✅         |

## 源码地址
GitHub: [https://github.com/JacobLinCool/playwright-docker](https://github.com/JacobLinCool/playwright-docker)

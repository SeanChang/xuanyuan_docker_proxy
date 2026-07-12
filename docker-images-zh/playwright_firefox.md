---
image: playwright/firefox
description: "为Moon软件提供的Playwright Firefox浏览器Docker镜像"
source: https://xuanyuan.cloud/zh/r/playwright/firefox
canonical: https://xuanyuan.cloud/zh/r/playwright/firefox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/playwright/firefox" title="playwright/firefox Docker 镜像中文简介、标签列表与拉取命令">playwright/firefox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Playwright Firefox for Moon 镜像文档


## 1. 镜像概述和主要用途

### 1.1 概述  
本镜像为 **Moon软件**（https://aerokube.com/moon/）专用的 Playwright Firefox 浏览器自动化测试镜像，基于 Playwright 的 Firefox 浏览器自动化能力构建，并针对 Moon 软件的集成需求进行了兼容性优化。**请注意**：本镜像仅适用于 Moon 环境，官方 Playwright 团队镜像请参考：https://hub.docker.com/_/microsoft-playwright。


### 1.2 主要用途  
提供在 Moon 软件平台中运行基于 Playwright 的 Firefox 浏览器自动化测试的执行环境，支持 Moon 调度、资源管理及分布式测试能力，用于 Web 应用的 Firefox 兼容性测试、自动化操作及回归验证。


## 2. 核心功能和特性

### 2.1 核心功能  
- **Playwright Firefox 自动化能力**：集成 Playwright 对 Firefox 浏览器的完整控制能力，支持页面导航、元素交互、网络请求拦截、截图/录屏等核心自动化操作。  
- **Moon 软件集成支持**：针对 Moon 的分布式测试架构、资源调度机制及任务管理功能优化，确保在 Moon 环境中稳定运行并高效利用集群资源。  
- **预配置运行环境**：内置 Firefox 浏览器及 Playwright 依赖库，减少用户手动配置步骤，可直接挂载测试脚本执行。  


## 3. 使用场景和适用范围

### 3.1 典型使用场景  
- **Moon 平台上的 Firefox 兼容性测试**：在 Moon 环境中验证 Web 应用在 Firefox 浏览器中的功能正确性及渲染一致性。  
- **分布式并行测试**：结合 Moon 的分布式能力，在多节点上并行执行基于 Firefox 的测试任务，缩短大规模测试周期。  
- **复杂场景自动化**：利用 Playwright 的高级特性（如多页面管理、iframe 处理、跨域操作）在 Moon 中实现复杂业务流程的自动化测试。  


### 3.2 适用范围  
- 需通过 Moon 软件进行统一管理和调度的 Firefox 浏览器自动化测试任务。  
- 依赖 Playwright API 开发的 Web 自动化测试脚本（支持 JavaScript/TypeScript、Python、Java、C# 等语言）。  
- 要求稳定集成至 CI/CD 流程，且需要 Moon 提供的资源隔离、任务优先级控制等能力的测试场景。  


## 4. 使用方法和配置说明

### 4.1 前提条件  
- 已安装 Docker Engine（20.10+ 版本）。  
- 已部署 Moon 软件集群，且镜像可访问 Moon 控制节点（通过网络或内部 registry）。  


### 4.2 Docker Run 命令示例  
通过 `docker run` 直接启动容器，执行测试脚本：  
 ```bash
 docker run -d \
   --name moon-playwright-firefox \
   -e MOON_SERVER="http://moon-control-plane:4444" \  # Moon 控制节点地址
   -e TEST_TIMEOUT="300s" \  # 测试超时时间（可选）
   -v /local/test/scripts:/tests \  # 挂载本地测试脚本目录至容器内 /tests
   aerokube/moon-playwright-firefox:latest \  # 镜像名称（示例，需替换为实际镜像标签）
   npx playwright test /tests  # 执行测试命令（根据脚本语言调整）
 ```  


### 4.3 Docker Compose 配置示例  
通过 `docker-compose.yml` 定义服务，集成至 Moon 测试环境：  
 ```yaml
 version: '3.8'
 services:
   moon-firefox-test:
     image: docker.xuanyuan.run/aerokube/moon-playwright-firefox:latest  # 镜像名称（示例）
     environment:
       - MOON_SERVER=http://moon-control-plane:4444  # Moon 控制节点地址
       - BROWSER_CHANNEL=firefox  # 指定浏览器通道（固定为 firefox）
       - PARALLEL_WORKERS=4  # 并行执行的测试工作进程数（可选）
     volumes:
       - ./test-scripts:/tests  # 挂载测试脚本目录
       - ./test-reports:/reports  # 挂载测试报告输出目录
     depends_on:
       - moon-agent  # 依赖 Moon Agent 服务（根据 Moon 部署架构调整）
     command: npx playwright test /tests --reporter=html:/reports  # 生成 HTML 报告
 ```  


### 4.4 核心配置参数说明  

#### 4.4.1 环境变量  
| 变量名                | 说明                                                                 | 默认值                  |
|-----------------------|----------------------------------------------------------------------|-------------------------|
| `MOON_SERVER`         | Moon 控制节点的访问地址（IP:端口或域名），用于注册容器至 Moon 集群。   | 无（必填）              |
| `TEST_TIMEOUT`        | 单测试用例超时时间，格式支持 `s`（秒）、`m`（分钟），如 `120s`。       | `300s`                  |
| `PARALLEL_WORKERS`    | 容器内并行执行的测试工作进程数，需根据容器资源（CPU/内存）调整。       | `2`                     |
| `PLAYWRIGHT_CONFIG`   | 自定义 Playwright 配置文件路径（容器内路径），如 `/tests/playwright.config.ts`。 | 无（使用默认配置）      |


#### 4.4.2 挂载卷建议  
- **测试脚本目录**：挂载本地测试代码至容器内固定路径（如 `/tests`），确保脚本可被 Playwright 识别。  
- **测试报告目录**：挂载输出目录（如 `/reports`），用于持久化保存测试结果（截图、录屏、HTML 报告等）。  


### 4.5 注意事项  
- **镜像兼容性**：本镜像仅与 Moon 软件配合使用，不建议单独作为 Playwright 环境运行（官方 Playwright 镜像功能更通用）。  
- **版本匹配**：需确保镜像版本与 Moon 集群版本兼容，具体版本对应关系参考 Moon 官方文档。  
- **资源配置**：根据测试复杂度调整容器 CPU/内存限制（通过 `--cpus`、`-m` 参数），避免因资源不足导致测试失败。  


## 5. 参考链接  
- Moon 软件官方文档：https://aerokube.com/moon/docs/  
- Playwright 官方文档（Firefox）：https://playwright.dev/docs/browsers#firefox  
- 官方 Playwright Docker 镜像：https://hub.docker.com/_/microsoft-playwright

---
image: platformos/playwright
description: "Playwright Docker镜像是用于运行跨浏览器自动化测试的工具容器，支持Chrome、Firefox、WebKit等浏览器，提供端到端测试、网页自动化和截图/PDF生成能力，简化测试环境配置，适用于CI/CD集成与自动化场景。"
source: https://xuanyuan.cloud/zh/r/platformos/playwright
canonical: https://xuanyuan.cloud/zh/r/platformos/playwright
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/platformos/playwright" title="platformos/playwright Docker 镜像中文简介、标签列表与拉取命令">platformos/playwright 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Playwright Docker镜像文档

## 镜像概述
Playwright Docker镜像是基于官方Playwright工具构建的容器化解决方案，旨在提供一致、隔离的跨浏览器自动化测试环境。该镜像预安装了Playwright核心依赖、浏览器二进制文件（Chrome/Chromium、Firefox、WebKit）及相关系统库，支持在容器中直接运行Playwright测试脚本，无需本地配置复杂的浏览器环境，特别适用于自动化测试、网页抓取和CI/CD流水线集成。

## 核心功能与特性

### 多浏览器支持
- 内置Chromium（Chrome/Edge基础）、Firefox和WebKit（Safari基础）浏览器，无需额外安装
- 支持浏览器版本锁定，确保测试环境一致性

### 全面自动化能力
- 端到端测试：模拟用户交互（点击、输入、导航等）
- 网页操作：支持表单提交、文件上传、网络请求拦截与模拟
- 媒体处理：生成网页截图（PNG/JPEG）和PDF文件
- 时间控制：支持页面加载等待、超时设置与异步操作处理

### 高效运行模式
- 无头模式（Headless）：默认启用，无UI界面运行，节省资源
- 有头模式（Headful）：支持通过VNC或桌面转发查看浏览器界面
- 多语言支持：兼容JavaScript/TypeScript、Python、Java、C#等Playwright绑定语言

### 环境一致性
- 预配置系统依赖（如字体、音频/视频编解码器），避免"在我电脑上能运行"问题
- 支持ARM64和AMD64架构，适配不同硬件环境

## 使用场景

### 自动化测试
- 前端项目端到端测试（E2E）
- 跨浏览器兼容性验证
- 回归测试与冒烟测试自动化

### CI/CD集成
- 与Jenkins、GitHub Actions、GitLab CI等流水线工具集成，实现提交触发测试
- 容器化测试环境确保开发/测试/生产环境一致性

### 网页自动化
- 批量网页截图与PDF生成（如文档导出）
- 定时任务执行（如数据抓取、报表生成）
- 网页性能监控与分析

## 使用方法

### 快速启动（`docker run`）

#### 基本测试运行示例
```bash
# 运行本地测试脚本（以JavaScript为例）
docker run -v $(pwd)/tests:/tests ***-mcr.xuanyuan.run/playwright:v1.44.0 \
  node /tests/example-test.js
```
> 说明：`-v $(pwd)/tests:/tests`将本地`tests`目录挂载到容器内`/tests`路径，容器执行`node /tests/example-test.js`运行测试脚本。


#### 生成网页PDF示例（Python）
```bash
docker run -v $(pwd):/workspace ***-mcr.xuanyuan.run/playwright:v1.44.0 \
  python3 /workspace/generate-pdf.py
```
> 示例脚本`generate-pdf.py`可调用Playwright的`page.pdf()`方法生成目标网页PDF。


### Docker Compose配置
```yaml
version: '3.8'
services:
  playwright-test:
    image: ***-mcr.xuanyuan.run/playwright:v1.44.0
    volumes:
      - ./tests:/tests  # 挂载测试代码
      - ./reports:/reports  # 挂载测试报告输出目录
    environment:
      - HEADLESS=1  # 启用无头模式（1=启用，0=禁用）
      - BROWSER=chromium  # 默认浏览器（可选：chromium/firefox/webkit）
      - TEST_TIMEOUT=30000  # 测试超时时间（毫秒，默认30000）
    command: pytest /tests --html=/reports/report.html  # 示例：Python pytest运行测试并生成报告
```


### 环境变量配置
| 环境变量                | 说明                                  | 默认值                  |
|-------------------------|---------------------------------------|-------------------------|
| `HEADLESS`              | 是否启用无头模式                      | `1`（启用）             |
| `BROWSER`               | 默认浏览器                            | `chromium`              |
| `PLAYWRIGHT_BROWSERS_PATH` | 浏览器二进制文件路径                | `/ms-playwright`        |
| `TEST_TIMEOUT`          | 全局测试超时时间（毫秒）              | `30000`（30秒）         |
| `DEBUG`                 | 是否启用Playwright调试模式            | `0`（禁用）             |


### 高级配置

#### 自定义浏览器路径
若需使用外部浏览器，可通过`PLAYWRIGHT_BROWSERS_PATH`指定路径，并挂载外部浏览器目录：
```bash
docker run -v /custom/browsers:/my-browsers \
  -e PLAYWRIGHT_BROWSERS_PATH=/my-browsers \
  ***-mcr.xuanyuan.run/playwright:v1.44.0 \
  node /tests/example-test.js
```

#### 网络代理配置
通过`HTTP_PROXY`/`HTTPS_PROXY`环境变量设置代理：
```bash
docker run -e HTTP_PROXY=http://proxy:8080 \
  -e HTTPS_PROXY=https://proxy:8080 \
  ***-mcr.xuanyuan.run/playwright:v1.44.0 \
  node /tests/example-test.js
```

## 适用范围
- 前端开发团队：自动化验证网页功能与兼容性
- QA工程师：构建跨平台测试用例
- DevOps工程师：集成CI/CD流水线实现测试自动化
- 数据工程师：批量抓取网页内容或生成可视化报告

## 注意事项
- 镜像体积较大（约2-4GB），建议通过CI/CD缓存或镜像分层优化拉取速度
- 有头模式需配置显示转发（如`-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix`）
- 高并发测试建议限制容器CPU/内存资源，避免浏览器崩溃

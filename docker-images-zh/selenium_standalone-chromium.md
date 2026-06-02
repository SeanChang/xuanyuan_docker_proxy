---
image: selenium/standalone-chromium
description: "Selenium Grid独立模式镜像，集成Chromium浏览器，用于运行基于Chrome的自动化测试。"
source: https://xuanyuan.cloud/zh/r/selenium/standalone-chromium
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[selenium/standalone-chromium](https://xuanyuan.cloud/zh/r/selenium/standalone-chromium)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Selenium Grid Standalone with Chromium 镜像文档


## 镜像概述与主要用途

本镜像提供集成 Chromium 浏览器的 [Selenium Grid Standalone](https://www.selenium.dev/documentation/grid/getting_started/#standalone) 环境，用于实现 [WebDriver 测试的远程执行](https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/)。通过该镜像，用户可快速部署包含 Chromium 浏览器的 Selenium Grid 独立节点，无需手动配置浏览器及驱动依赖。


## 核心功能与特性

- **集成 Chromium 浏览器**：预安装 Chromium 浏览器，支持基于 Chromium 内核的 Web 应用测试
- **Selenium Grid 独立模式**：单容器运行完整的 Selenium Grid 服务，无需单独部署 Hub 和 Node
- **远程 WebDriver 支持**：提供标准 Selenium Grid 接口，允许客户端通过 HTTP 协议提交远程测试任务
- **可视化调试能力**：内置 VNC 服务，可通过浏览器实时查看容器内浏览器的操作画面
- **版本化标签管理**：支持通过标签精确指定浏览器版本、驱动版本及 Grid 版本，确保测试环境一致性


## 使用场景与适用范围

- **Web 自动化测试环境**：适用于需要在 Chromium 浏览器中执行的 Selenium WebDriver 自动化测试
- **CI/CD 流程集成**：可作为持续集成/部署流水线的测试节点，自动化执行 Web 应用兼容性测试
- **跨环境测试隔离**：通过容器化方式隔离测试环境，避免本地环境差异导致的测试结果不一致
- **分布式测试资源**：作为 Selenium Grid 集群的独立节点，扩展测试并发能力


## 详细使用方法与配置说明

### 快速启动

#### Docker Run 命令

```bash
docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g" selenium/standalone-chromium:latest
```

**参数说明**：
- `-d`：后台运行容器
- `-p 4444:4444`：映射 Selenium Grid 服务端口（客户端测试连接端口）
- `-p 7900:7900`：映射 VNC 服务端口（用于可视化查看容器内浏览器）
- `--shm-size="2g"`：设置共享内存大小（浏览器运行需较大共享内存，避免崩溃）


#### Docker Compose 配置

创建 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  selenium-standalone:
    image: selenium/standalone-chromium:latest
    ports:
      - "4444:4444"  # Selenium Grid 服务端口
      - "7900:7900"  # VNC 可视化端口
    shm_size: "2g"   # 共享内存配置
    restart: unless-stopped  # 异常退出后自动重启
```

启动服务：
```bash
docker-compose up -d
```


### 测试配置

1. **连接 Grid 服务**：将 WebDriver 客户端配置指向 Grid 服务地址  
   示例（Java）：
   ```java
   WebDriver driver = new RemoteWebDriver(
     new URL("http://localhost:4444/wd/hub"),
     new ChromeOptions()
   );
   ```

2. **执行测试**：客户端测试脚本将通过 Grid 服务在容器内的 Chromium 浏览器中执行


### 容器内部可视化

通过 VNC 服务查看容器内浏览器实时画面：
1. 访问 URL：`http://localhost:7900/?autoconnect=1&resize=scale&password=secret`
2. 默认密码：`secret`（VNC 连接密码，镜像内置默认值）


### 标签选择指南

#### 标签结构说明

镜像标签支持以下格式，可根据需求选择精确版本或简化版本：

1. 基础格式（包含浏览器版本与发布日期）：  
   `selenium/standalone-chromium-<浏览器主版本>.<次版本>.<修订号>-<发布日期>`

2. 完整格式（包含浏览器、驱动、Grid 版本及发布日期）：  
   `selenium/standalone-chromium-<浏览器版本>-chromedriver-<驱动版本>-grid-<Grid版本>-<发布日期>`


#### 标签示例

以 Chromium 125.0.6422.60、ChromeDriver 125.0.6422.60、Selenium Grid 4.21.0、发布日期 20240522 为例，可用标签包括：

| 标签格式 | 说明 |
|----------|------|
| `125.0` | 仅指定浏览器主版本（自动匹配最新次版本及发布日期） |
| `125.0-20240522` | 指定浏览器主版本及发布日期 |
| `125.0-chromedriver-125.0` | 指定浏览器版本及驱动版本 |
| `125.0.6422.60-chromedriver-125.0.6422.60-grid-4.21.0-20240522` | 完整版本标签（推荐用于生产环境） |


#### 使用建议

- **测试环境**：可使用简化标签（如 `125.0`）快速获取最新版本
- **生产/CI 环境**：建议使用完整标签（如上述完整格式示例）固定所有依赖版本，避免自动更新导致的兼容性问题


### 注意事项

- **共享内存配置**：运行包含浏览器的镜像时，必须通过 `--shm-size="2g"`（或更大值）指定共享内存，否则可能因内存不足导致浏览器崩溃
- **网络访问权限**：确保容器可访问测试目标 URL（如需测试内网应用，需配置容器网络模式为 `host` 或自定义网络）
- **资源限制**：根据测试并发需求调整容器 CPU/内存限制，避免资源竞争影响测试稳定性


## 完整文档与许可证

- **完整文档**：详见 [Docker-Selenium 项目 README](https://github.com/SeleniumHQ/docker-selenium)
- **许可证**：本项目基于 [Apache License 2.0](https://raw.githubusercontent.com/SeleniumHQ/selenium/trunk/LICENSE) 开源协议

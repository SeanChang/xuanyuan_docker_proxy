---
image: browserless/chrome
description: "在Docker中部署无头Chrome，支持Puppeteer、Selenium和Playwright等库，提供REST API用于数据采集、PDF生成等功能。可在官方云服务运行或自行部署，非商业用途免费。"
source: https://xuanyuan.cloud/zh/r/browserless/chrome
canonical: https://xuanyuan.cloud/zh/r/browserless/chrome
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/browserless/chrome" title="browserless/chrome Docker 镜像中文简介、标签列表与拉取命令">browserless/chrome 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Browserless Chrome Docker镜像文档

## 镜像概述和主要用途

Browserless Chrome是一个Docker镜像，允许远程客户端连接并执行无头浏览器工作。它支持标准的Puppeteer、Selenium和Playwright库，并提供基于REST的API用于常见操作（如数据采集、PDF生成等）。该镜像解决了无头浏览器部署中的常见问题，如缺少系统字体、外部库依赖、性能优化等，同时支持会话管理和文件下载等边缘场景。

> **注意**：这是Browserless的旧v1版本，建议使用[version 2](https://github.com/browserless/browserless)。

## 核心功能和特性

- **内置并行处理和队列管理**，可配置
- **开箱即支持字体和表情符号**
- **实时调试查看器**，用于监控和调试运行中的会话
- **针对特定Puppeteer版本构建**的Docker镜像
- 镜像标签包含Chrome、V8、WebKit等版本信息
- **交互式Puppeteer调试器**，支持查看无头浏览器操作并使用DevTools
- 兼容大多数无头浏览器库
- **可配置的会话计时器和健康检查**，确保稳定运行
- **容错机制**：Chrome崩溃时服务不会中断
- 支持Apple M1机器的ARM64架构运行和开发

## 工作原理

Browserless监听传入的WebSocket请求（通常由大多数库发出）和预构建的REST API（用于PDF生成、图片处理等常见功能）。当WebSocket连接到Browserless时，它会启动Chrome并将请求代理到Chrome中。会话完成后，Chrome关闭并等待新的连接。部分库使用Chrome的HTTP端点（如`/json`）来检查可调试目标，Browserless也支持这些端点。

应用程序仍需运行脚本本身（类似于数据库交互），这使您可以完全控制选择的库和升级时机，避免因Chrome调试协议频繁变更带来的问题。

## 使用方法和配置说明

### Docker快速启动

```bash
docker run -p 3000:3000 docker.xuanyuan.run/browserless/chrome
```

启动后，访问`http://localhost:3000/`即可使用交互式调试器。更多选项请查看[完整文档](https://www.browserless.io/docs/docker-quickstart)。

### 调试器使用

Browserless提供两种调试方式：

1. **基于Web的调试器**：用于尝试小型代码片段，无需设置新项目。公共调试器可访问[此处](https://chrome.browserless.io/)。

2. **活动会话调试器**：跟踪HTTP请求和Puppeteer会话的浏览器状态，可在Web调试器中查看当前运行的会话。通过点击左上角菜单图标，可查看所有活动会话并通过Chrome远程DevTools查看。也可通过`/session` API获取会话的JSON表示。

若会话执行过快，可在`puppeteer.connect`调用（或HTTP REST调用）中添加`?pause`查询参数，Browserless会暂停脚本直到调试器连接。

调试器功能包括：
- 使用`debugger;`和`console.log`调试
- 脚本错误在`console`标签中显示
- 检查DOM、监控网络请求、查看页面渲染
- 即将支持导出脚本为`index.js`和`package.json`

### 推荐NGINX配置

若在Docker镜像（或Node）前使用NGINX，需代理Upgrade头：

```nginx
location / {
    proxy_pass YOUR_DOCKER_IMAGE_LOCATION;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
}
```

### ARM64架构构建（Apple M1机器）

可直接拉取M1专用镜像：

```bash
docker pull docker.xuanyuan.run/browserless/chrome:1-arm64
```

若在amd64机器（非M1 Mac）上构建多平台镜像：

```bash
# 设置ARM64构建环境
docker run --rm --privileged docker.xuanyuan.run/multiarch/qemu-user-static --reset -p yes

# 创建构建器
docker buildx create --name builder --driver docker-container --use

# 初始化构建器
docker buildx inspect --bootstrap

# 构建ARM64镜像
docker buildx build --platform linux/arm64 -t browserless/chrome:arm64 .
```

> 注意：ARM64构建中Chromium版本可能与Puppeteer不完全匹配，可能导致潜在问题。

## 与主流库集成

### Puppeteer

通过`browserWSEndpoint`指定远程Chrome位置：

**之前**
```js
const browser = await puppeteer.launch();
```

**之后**
```js
const browser = await puppeteer.connect({ browserWSEndpoint: 'ws://localhost:3000' });
```

### Selenium (WebDriver)

更新测试代码以使用远程连接：

**之前**
```js
const webdriver = require('selenium-webdriver');
const fs = require('fs');

const chromeCapabilities = webdriver.Capabilities.chrome();
chromeCapabilities.set(
  'chromeOptions', {
    args: [
      '--headless',
      '--no-sandbox',
    ],
  }
);

const driver = new webdriver.Builder()
  .forBrowser('chrome')
  .withCapabilities(chromeCapabilities)
  .build();
```

**之后**
```js
const webdriver = require('selenium-webdriver');
const fs = require('fs');

const chromeCapabilities = webdriver.Capabilities.chrome();
chromeCapabilities.set(
  'chromeOptions', {
    args: [
      '--headless',
      '--no-sandbox',
    ],
  }
);

const driver = new webdriver.Builder()
  .forBrowser('chrome')
  .withCapabilities(chromeCapabilities)
  .usingServer('http://localhost:3000/webdriver') // 添加此行
  .build();
```

### Playwright

通过远程连接方式使用：

**之前**
```js
const browser = await pw.chromium.launch();
```

**之后**
```js
const browser = await pw.chromium.connect({
  browserWSEndpoint: 'wss://chrome.browserless.io?token=YOUR-API-TOKEN',
});
```

## 托管选项

- **官方托管服务**：提供机器配置、通知、仪表板和监控等功能，无需安装软件，支持版本切换和弹性扩展。访问[browserless.io](https://browserless.io)了解详情。
- **自行托管**：可在任何支持Docker的平台上部署该镜像。

## 许可协议

- **非商业用途**：免费使用。
- **商业用途**：需购买商业许可，允许在专有系统中用于商业/CI目的，提供优先支持和源码修改权限。[联系购买](https://www.browserless.io/contact)。
- **开源项目**：若使用与GNU GPL v3兼容的许可证，可在GPLv3条款下使用。

## 外部链接

- [完整文档](https://www.browserless.io/docs/start)
- [实时调试器](https://chrome.browserless.io/)
- [Browserless v2](https://github.com/browserless/browserless)
- [Slack社区](https://join.slack.com/t/browserless/shared_invite/enQtMzA3OTMwNjA3MzY1LTRmMWU5NjQ0MTQ2YTE2YmU3MzdjNmVlMmU4MThjM2UxODNmNzNlZjVkY2U2NjdkMzYyNTgyZTBiMmE3Nzg0MzY)
- [更新日志](https://github.com/browserless/chrome/blob/master/CHANGELOG.md)

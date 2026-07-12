---
image: zenika/alpine-chrome
description: "在极小的Alpine镜像中以无头模式运行的Chrome浏览器，适用于网页测试、自动化和内容生成等场景，体积小巧且功能丰富。"
source: https://xuanyuan.cloud/zh/r/zenika/alpine-chrome
canonical: https://xuanyuan.cloud/zh/r/zenika/alpine-chrome
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zenika/alpine-chrome" title="zenika/alpine-chrome Docker 镜像中文简介、标签列表与拉取命令">zenika/alpine-chrome 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![GitHub Stars](https://img.shields.io/github/stars/zenika/alpine-chrome)](https://github.com/Zenika/alpine-chrome/) [![Docker Build Status](https://img.shields.io/github/workflow/status/zenika/alpine-chrome/build.svg)](https://hub.docker.com/r/zenika/alpine-chrome/) [![Docker Pulls](https://img.shields.io/docker/pulls/zenika/alpine-chrome.svg)](https://hub.docker.com/r/zenika/alpine-chrome/) [![Docker Stars](https://img.shields.io/docker/stars/zenika/alpine-chrome.svg)](https://hub.docker.com/r/zenika/alpine-chrome/)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-39-orange.svg?style=flat-square)](#-contributors)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

# 可用仓库

基于[Docker Hub速率限制](https://www.docker.com/increase-rate-limits)的变更，提供以下仓库地址：
- [Docker Hub](https://hub.docker.com/r/zenika/alpine-chrome)（无前缀）：`zenika/alpine-chrome`
- Google Cloud（按地区就近访问）：
  - 全球：`gcr.io/zenika-hub/alpine-chrome`
  - 欧洲：`eu.gcr.io/zenika-hub/alpine-chrome`
  - 亚洲：`asia.gcr.io/zenika-hub/alpine-chrome`
  - 美国：`us.gcr.io/zenika-hub/alpine-chrome`

# 支持的标签及对应`Dockerfile`链接

- `latest`、`100` [(Dockerfile)](https://github.com/Zenika/alpine-chrome/blob/master/Dockerfile)
- `with-node`、`100-with-node`、`100-with-node-16`（带Node.js）[(Dockerfile)](https://github.com/Zenika/alpine-chrome/blob/master/with-node/Dockerfile)
- `with-puppeteer`、`100-with-puppeteer`（带Puppeteer）[(Dockerfile)](https://github.com/Zenika/alpine-chrome/blob/master/with-puppeteer/Dockerfile)
- `with-playwright`、`100-with-playwright`（带Playwright）[(Dockerfile)](https://github.com/Zenika/alpine-chrome/blob/master/with-playwright/Dockerfile)
- `with-selenoid`、`100-with-selenoid`（带Selenoid）[(Dockerfile)](https://github.com/Zenika/alpine-chrome/blob/master/with-selenoid/Dockerfile)
- `with-chromedriver`、`100-with-chromedriver`（带Chromedriver）[(Dockerfile)](https://github.com/Zenika/alpine-chrome/blob/master/with-chromedriver/Dockerfile)
- 历史版本：`89`、`86`、`85`、`84`、`83`、`81`、`80`、`77`、`76`、`73`、`72`、`71`、`68`、`64`
- 带Node.js的历史版本：`89-with-node`、`86-with-node`、`85-with-node`等
- 带Puppeteer的历史版本：`89-with-puppeteer`、`86-with-puppeteer`等

# alpine-chrome

在极小的Alpine镜像中以无头模式运行的Chrome浏览器
*

# 🤔 为什么使用无头Chrome

在Web开发中，快速运行端到端测试至关重要。Puppeteer等流行技术使开发者能够实现测试、表单自动化、网页爬取、截图生成、时间线捕获等功能。而秘密在于：Chrome原生支持其中部分功能！🙌

## 💡 打造理想容器的特性

- 📦 最小的无头Chrome镜像（压缩大小：[423 MB](https://github.com/Zenika/alpine-chrome#image-disk-size)）
- 🐳 易于使用、临时且可复现的Docker无头Chrome环境
- 📝 文档友好，提供打印DOM、生成移动比例图片、生成PDF等示例
- 👷‍♂️ 通过[Docker Hub](https://hub.docker.com/repository/docker/zenika/alpine-chrome)自动构建，确保项目同步和镜像可靠性
- 📌 包含最新Chromium版本，同时提供历史版本标签以便测试不同Chromium版本
- 🔐 安全可靠，提供[三种安全使用Chrome无头模式的方法](https://github.com/Zenika/alpine-chrome#3-ways-to-securely-use-chrome-headless-with-this-image)
- 🌐 支持国际化：包含亚洲字符支持（参见["screenshot-asia.js"文件](https://github.com/Zenika/alpine-chrome/blob/master/with-puppeteer/src/screenshot-asia.js)）
- 💄 支持设计场景：支持WebGL和表情符号（参见["WebGL使用方法"](https://github.com/Zenika/alpine-chrome#how-to-use-with-webgl)和["表情符号显示问题"](https://github.com/Zenika/alpine-chrome/issues/114)）
- 📄 开源，采用Apache2许可证
- 👥 社区共建，包含外部贡献者（参见["✨ 贡献者"章节](https://github.com/Zenika/alpine-chrome#-contributors)）
- 💚 开发者友好，提供NodeJS、Puppeteer、docker-compose示例，以及X11显示测试（参见["运行示例"章节](https://github.com/Zenika/alpine-chrome#run-examples)）

# 三种安全使用本镜像运行Chrome无头模式的方法

## ❌ 无任何配置

仅使用`docker container run -it zenika/alpine-chrome ...`启动容器会失败，日志类似[#33](https://github.com/Zenika/alpine-chrome/issues/33)。请使用以下三种方法。

## ✅ 使用`--no-sandbox`

启动容器命令：

`docker container run -it --rm zenika/alpine-chrome`，并在所有命令中添加`--no-sandbox`参数。

**注意**：确保信任目标网站。

`no-sandbox`参数的简要说明参见[此处](https://www.google.com/googlebooks/chrome/med_26.html)，深度设计文档参见[此处](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md)。

## ✅ 使用`SYS_ADMIN`权限

启动容器命令：
`docker container run -it --rm --cap-add=SYS_ADMIN zenika/alpine-chrome`

此方法允许Chrome启用沙箱，但从Docker角度看授予了不必要的权限。

## ✅ 最佳方式：使用`seccomp`

基于Jessie Frazelle的Chrome安全计算（seccomp）配置文件，这是最安全的运行方式。

配置文件：[chrome.json](https://github.com/Zenika/alpine-chrome/blob/master/chrome.json)，也可通过`wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json`获取。

启动容器命令：
`docker container run -it --rm --security-opt seccomp=$(pwd)/chrome.json zenika/alpine-chrome`

# 命令行使用方法

## 默认入口点

默认入口点执行命令：`chromium-browser --headless --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage`

如需完全控制，可覆盖入口点：`docker container run -it --rm --entrypoint "" zenika/alpine-chrome chromium-browser ...`

## 使用开发者工具

命令（需`no-sandbox`）：`docker container run -d -p 9222:9222 zenika/alpine-chrome --no-sandbox --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 https://www.chromestatus.com/`

在浏览器中访问`http://localhost:9222`，点击要检查的标签页。将链接开头的`https://chrome-devtools-frontend.appspot.com/serve_file/@.../inspector.html?ws=localhost:9222/[END]`替换为`chrome-devtools://devtools/bundled/inspector.html?ws=localhost:9222/[END]`。

## 打印DOM

命令（需`no-sandbox`）：`docker container run -it --rm zenika/alpine-chrome --no-sandbox --dump-dom https://www.chromestatus.com/`

## 生成PDF

命令（需`no-sandbox`）：`docker container run -it --rm -v $(pwd):/usr/src/app zenika/alpine-chrome --no-sandbox --print-to-pdf --hide-scrollbars https://www.chromestatus.com/`

## 截取屏幕截图

命令（需`no-sandbox`）：`docker container run -it --rm -v $(pwd):/usr/src/app zenika/alpine-chrome --no-sandbox --screenshot --hide-scrollbars https://www.chromestatus.com/`

### 标准信纸尺寸

命令（需`no-sandbox`）：`docker container run -it --rm -v $(pwd):/usr/src/app zenika/alpine-chrome --no-sandbox --screenshot --hide-scrollbars --window-size=1280,1696 https://www.chromestatus.com/`

### Nexus 5x手机尺寸

命令（需`no-sandbox`）：`docker container run -it --rm -v $(pwd):/usr/src/app zenika/alpine-chrome --no-sandbox --screenshot --hide-scrollbars --window-size=412,732 https://www.chromestatus.com/`

### 截图文件归属当前用户（默认归容器用户所有）

命令（需`no-sandbox`）：`` docker container run -u `id -u $USER` -it --rm -v $(pwd):/usr/src/app zenika/alpine-chrome --no-sandbox --screenshot --hide-scrollbars --window-size=412,732 https://www.chromestatus.com/ ``

# 与Deno集成使用

进入deno `src`目录，构建镜像：

```
docker image build -t zenika/alpine-chrome:with-deno-sample .
```

启动容器：

```
docker container run -it --rm zenika/alpine-chrome:with-deno-sample
 Download https://deno.land/std/examples/welcome.ts
 Warning Implicitly using master branch https://deno.land/std/examples/welcome.ts
 Compile https://deno.land/std/examples/welcome.ts
 Welcome to Deno 🦕
```

运行自定义文件：

```
docker container run -it --rm -v $(pwd):/usr/src/app zenika/alpine-chrome:with-deno-sample run helloworld.ts
Compile file:///usr/src/app/helloworld.ts
Download https://deno.land/std/fmt/colors.ts
Warning Implicitly using master branch https://deno.land/std/fmt/colors.ts
Hello world!
```

# 与Puppeteer集成使用

借助["Puppeteer"](https://pptr.dev/#?product=Puppeteer&version=v1.15.0&show=api-class-browser)工具，可扩展无头Chrome功能。通过NodeJS代码可实现更复杂的测试。

详见["with-puppeteer"](https://github.com/Zenika/alpine-chrome/blob/master/with-puppeteer)目录。需[遵循Chromium与Puppeteer版本对应关系](https://github.com/puppeteer/puppeteer/blob/main/versions.js)。

若`src`目录中有NodeJS/Puppeteer脚本`pdf.js`，启动命令：

```
docker container run -it --rm -v $(pwd)/src:/usr/src/app/src --cap-add=SYS_ADMIN zenika/alpine-chrome:with-puppeteer node src/pdf.js
```

通过["wqy-zenhei"](https://pkgs.alpinelinux.org/package/edge/testing/x86/wqy-zenhei)库支持亚洲语言页面（如["screenshot-asia.js"](https://github.com/Zenika/alpine-chrome/blob/master/with-puppeteer/src/screenshot-asia.js)）：

```
docker container run -it --rm -v $(pwd)/src:/usr/src/app/src --cap-add=SYS_ADMIN zenika/alpine-chrome:with-puppeteer node src/screenshot-asia.js
```

已测试支持以下语言的网站：
- 中文（`https://m.baidu.com`）
- 日文（`https://www.yahoo.co.jp/`）
- 韩文（`https://www.naver.com/`）

# 使用Puppeteer测试Chrome扩展

[根据Puppeteer官方文档](https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#working-with-chrome-extensions)，无头模式不支持测试Chrome扩展，需借助Xvfb提供显示环境。

详见["with-puppeteer-xvfb"](https://github.com/Zenika/alpine-chrome/blob/master/with-puppeteer-xvfb)目录，需[遵循Chromium与Puppeteer版本对应关系](https://github.com/puppeteer/puppeteer/blob/main/versions.js)。

若`src`目录中有脚本`extension.js`，扩展文件在`chrome-extension`目录，启动命令：

```
docker container run -it --rm -v $(pwd)/src:/usr/src/app/src --cap-add=SYS_ADMIN zenika/alpine-chrome:with-puppeteer-xvfb node src/extension.js
```

示例扩展将所有网站背景设为红色，脚本会加载扩展并截取`icanhazip.com`的截图。

# 与Playwright集成使用

类似["Puppeteer"](https://pptr.dev/#?product=Puppeteer&version=v6.0.0&show=api-class-browser)，["Playwright"](https://playwright.dev/docs/core-concepts/#browser)也可扩展无头Chrome功能。

进入`with-playwright`目录，启动命令：

```
docker container run -it --rm -v $(pwd)/src:/usr/src/app/src --cap-add=SYS_ADMIN zenika/alpine-chrome:with-playwright node src/useragent.js
```

`with-playwright/src`目录将生成`example-chromium.png`文件。

# WebGL使用方法

默认支持WebGL，如需禁用，启动Chromium时添加`--disable-gpu`。

`with-webgl`标签已弃用，将于2020年8月底前移除。

示例命令：
```
docker container run -it --rm --cap-add=SYS_ADMIN -v $(pwd):/usr/src/app zenika/alpine-chrome --screenshot --hide-scrollbars https://webglfundamentals.org/webgl/webgl-fundamentals.html
```
```
docker container run -it --rm --cap-add=SYS_ADMIN -v $(pwd):/usr/src/app zenika/alpine-chrome --screenshot --hide-scrollbars https://browserleaks.com/webgl
```

相关链接：
- https://github.com/adieuadieu/serverless-chrome/issues/108
- https://github.com/DevExpress/testcafe/issues/2116
- 'use-gl'参数值说明[此处](https://cs.chromium.org/chromium/src/ui/gl/gl_switches.cc?type=cs&q=kUseGL&sq=package:chromium&g=0&l=69)

# 与Chromedriver集成使用

[ChromeDriver](https://chromedriver.chromium.org/home)是Selenium WebDriver控制Chrome的独立可执行文件。本镜像可作为Docker化Selenium测试的基础。详见[使用Chromedriver运行Selenium测试指南](https://www.browserstack.com/guide/run-selenium-tests-using-selenium-chromedriver)。

# 与Selenoid集成使用

[Selenoid](https://github.com/aerokube/selenoid)是基于Docker的Selenium hub实现，轻量级且功能强大。`with-selenoid`镜像包含Selenium服务器、Chrome和Chromedriver。

启动命令：

```
docker container run -it --rm --cap-add=SYS_ADMIN  -p 4444:4444 zenika/alpine-chrome:with-selenoid -capture-driver-logs
```

测试可访问`http://localhost:4444/wd/hub`。

在GitLab CI等Docker权限受限环境中，可能无法使用`--cap-add=SYS_ADMIN`，需向`chromedriver`传递`--no-sandbox`参数。详见[selenoid文档](https://aerokube.com/selenoid/latest/#_using_selenoid_without_docker)。

# 以root用户运行并覆盖默认入口点

命令：

```
docker container run --rm -it --entrypoint "" --user root zenika/alpine-chrome sh
```

# 运行示例

`examples`[目录](examples)提供以下示例：

- 🐳 [docker-compose](https://github.com/Zenika/alpine-chrome/blob/master/examples/docker-compose)：启动Chrome并调用同一docker-compose中的nginx服务器
- ☸️ [kubernetes](https://github.com/Zenika/alpine-chrome/tree/master/examples/k8s)：在K8s中部署无头

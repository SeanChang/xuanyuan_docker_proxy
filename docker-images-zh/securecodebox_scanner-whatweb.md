---
image: securecodebox/scanner-whatweb
description: "secureCodeBox的scanner-whatweb镜像是与parser镜像配合使用的安全扫描工具，集成WhatWeb扫描器，用于识别网站使用的技术（如CMS、JavaScript库、Web服务器等），支持DevSecOps团队在开发过程中自动化安全漏洞测试。"
source: https://xuanyuan.cloud/zh/r/securecodebox/scanner-whatweb
canonical: https://xuanyuan.cloud/zh/r/securecodebox/scanner-whatweb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/securecodebox/scanner-whatweb" title="securecodebox/scanner-whatweb Docker 镜像中文简介、标签列表与拉取命令">securecodebox/scanner-whatweb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OWASP secureCodeBox scanner-whatweb 镜像文档

## 镜像概述和主要用途

[OWASP secureCodeBox][scb-github] 是一个自动化、可扩展的开源解决方案，用于集成各类安全漏洞扫描器，提供简单轻量的接口，支持DevSecOps团队在不同场景下自动化安全漏洞测试。其核心使命是帮助团队在开发过程早期发现低风险安全问题，释放渗透测试资源以专注于重大安全问题。

本 `scanner-whatweb` 镜像是 secureCodeBox 生态的一部分，需与对应的 `parser` 镜像配合使用：scanner 镜像基于 WhatWeb 扫描器执行网站技术识别，parser 镜像将扫描结果解析为通用的 secureCodeBox 格式。secureCodeBox 运行在 Kubernetes 环境（需通过 Helm 安装），同时也支持基于 Docker 基础设施启动集成的安全扫描器。

## 核心功能和特性

- **集成 WhatWeb 扫描器**：识别网站使用的技术栈，包括内容管理系统（CMS）、JavaScript 库、Web 服务器、编程语言等
- **多攻击级别支持**：提供 Stealthy（低攻击性）、Aggressive（中攻击性）、Heavy（高攻击性）三级扫描模式，平衡扫描深度与速度/隐蔽性
- **结果标准化**：与 parser 镜像配合，将扫描发现转换为 secureCodeBox 通用结果格式，便于后续分析和集成
- **灵活配置**：支持自定义目标、HTTP 头、代理、认证信息等扫描参数
- **开源可扩展**：基于 Apache 2.0 许可证开源，可与 secureCodeBox 其他组件（如扫描工作流、结果存储）无缝集成

## 使用场景和适用范围

- **DevSecOps 自动化扫描**：集成到持续集成/持续部署（CI/CD）流程，在应用发布前自动识别技术栈信息，为后续漏洞扫描提供基础
- **技术栈 inventory 管理**：定期扫描内部或外部网站，维护技术栈清单，识别过时组件风险
- **安全评估前置信息收集**：在渗透测试或深度漏洞扫描前，快速获取目标网站技术细节，优化扫描策略
- **低风险问题自动化发现**：通过持续扫描发现技术栈版本暴露、过时组件等低风险问题，减少人工测试负担

## 详细的使用方法和配置说明

### 支持的标签

- `latest`：最新稳定版本构建
- 版本化标签，如 `v0.6.2`（对应具体发布版本）

### 如何使用此镜像

#### 拉取镜像

```bash
docker pull docker.xuanyuan.run/securecodebox/scanner-whatweb
```

#### 使用说明

该镜像需与 secureCodeBox 的 `parser` 镜像配合使用，流程如下：
1. 使用 `scanner-whatweb` 镜像执行扫描，生成原始扫描结果
2. `parser` 镜像解析原始结果，转换为 secureCodeBox 通用格式（包含漏洞等级、描述、位置等标准化字段）
3. 解析后的结果可集成到 secureCodeBox 生态的其他组件（如结果存储、通知系统）

### What is WHATWEB?

WhatWeb 是一款网站技术识别工具，能够检测目标网站使用的技术组件，如 CMS（WordPress、Drupal）、JavaScript 库（jQuery、React）、Web 服务器（Nginx、Apache）、编程语言（PHP、Python）等。其核心特点包括：
- 支持多攻击级别，可根据需求调整扫描深度（从低攻击性的单请求扫描到高攻击性的多请求详细检测）
- 可识别技术版本（在适当攻击级别下），帮助发现版本相关漏洞
- 灵活的插件系统，支持自定义规则扩展识别能力

更多信息参见 [WhatWeb 官方网站](https://morningstarsecurity.com/research/whatweb)、[GitHub 仓库](https://github.com/urbanadventurer/WhatWeb) 或 [GitHub Wiki](https://github.com/urbanadventurer/WhatWeb/wiki)。

### 扫描器配置参数

WhatWeb 扫描器支持丰富的配置参数，以下为核心参数说明：

#### 目标选择
- `<TARGETs>`：指定目标 URL、主机名、IP 地址、文件名或 CIDR 格式的 IP 范围（如 `192.168.0.0/24`）
- `--input-file=FILE, -i`：从文件读取目标（可通过 `-i /dev/stdin` 从标准输入管道读取）

#### 目标修改
- `--url-prefix`：为目标 URL 添加前缀
- `--url-suffix`：为目标 URL 添加后缀
- `--url-pattern`：将目标插入 URL 模板（需配合 `--input-file`，如 `www.example.com/%insert%/robots.txt`）

#### 攻击级别（Aggression）
控制扫描深度与速度/隐蔽性的平衡：
- `--aggression, -a=LEVEL`：设置攻击级别（默认 1）
  - **1 (Stealthy)**：每个目标仅 1 个 HTTP 请求，跟随重定向
  - **3 (Aggressive)**：若匹配到级别 1 插件，将发起额外请求
  - **4 (Heavy)**：每个目标发起大量 HTTP 请求，对所有 URL 使用所有插件的攻击性测试

#### HTTP 选项
- `--user-agent, -U=AGENT`：自定义 User-Agent（默认 `WhatWeb/0.5.5`）
- `--header, -H`：添加 HTTP 头（如 `"Foo:Bar"`；空值如 `"User-Agent:"` 可移除默认头）
- `--follow-redirect=WHEN`：控制重定向跟随策略（`never`/`http-only`/`meta-only`/`same-site`/`always`，默认 `always`）
- `--max-redirects=NUM`：最大重定向次数（默认 10）

#### 认证
- `--user, -u=<user:password>`：HTTP 基本认证
- `--cookie, -c=COOKIES`：提供 Cookie（如 `name=value; name2=value2`）
- `--cookiejar=FILE`：从文件读取 Cookie

#### 代理
- `--proxy <hostname[:port]>`：设置代理（默认端口 8080）
- `--proxy-user <username:password>`：代理认证信息

#### 插件
- `--list-plugins, -l`：列出所有插件
- `--info-plugins, -I=[SEARCH]`：列出插件详细信息（可选关键词搜索）
- `--plugins, -p=LIST`：选择插件（逗号分隔列表，默认所有；支持 +/- 前缀添加/排除）
- `--custom-plugin=DEFINITION`：定义自定义插件（如 `":text=>'powered by abc'"`）

#### 输出与日志
- `--verbose, -v`：详细输出（-v 显示插件描述，-vv 调试模式）
- `--color=WHEN`：控制颜色输出（`never`/`always`/`auto`）
- `--quiet, -q`：不输出简要日志到 STDOUT
- `--log-json=FILE`：JSON 格式日志输出到文件（支持多种日志格式：XML、SQL、MongoDB 等）

#### 性能与稳定性
- `--max-threads, -t`：并发线程数（默认 25）
- `--open-timeout`：连接超时时间（秒，默认 15）
- `--read-timeout`：读取超时时间（秒，默认 30）
- `--wait=SECONDS`：请求间隔时间（单线程时有用）

## 社区支持

欢迎通过以下渠道参与社区：
- [GitHub 仓库][scb-github]
- [OWASP Slack（#project-securecodebox 频道）][scb-slack]
- [Mastodon][scb-mastodon]

secureCodeBox 是官方 [OWASP 实验室项目][scb-owasp]。

## 许可证

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

本镜像基于 Apache 2.0 许可证开源。与所有 Docker 镜像一样，可能包含其他软件（如 Bash 等基础发行版组件），其许可证需由镜像用户自行确认合规性。

[scb-owasp]: https://www.owasp.org/index.php/OWASP_secureCodeBox
[scb-docs]: https://www.securecodebox.io/
[scb-github]: https://github.com/secureCodeBox/
[scb-mastodon]: https://infosec.exchange/@secureCodeBox
[scb-slack]: https://owasp.org/slack/invite

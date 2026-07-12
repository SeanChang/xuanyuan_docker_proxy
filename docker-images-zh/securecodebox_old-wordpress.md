---
image: securecodebox/old-wordpress
description: "不安全且过时的WordPress实例：切勿暴露于互联网！"
source: https://xuanyuan.cloud/zh/r/securecodebox/old-wordpress
canonical: https://xuanyuan.cloud/zh/r/securecodebox/old-wordpress
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/securecodebox/old-wordpress" title="securecodebox/old-wordpress Docker 镜像中文简介、标签列表与拉取命令">securecodebox/old-wordpress 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## OWASP secureCodeBox 简介

<p align="center">
  <img alt="secureCodeBox 标志" src="https://www.securecodebox.io/img/Logo_Color.svg" width="250px"/>
</p>

[OWASP secureCodeBox][scb-github] 是一个自动化、可扩展的开源解决方案，可通过简单轻量的界面集成各种安全漏洞扫描器。其使命是支持DevSecOps团队轻松实现不同场景下的安全漏洞测试自动化。

通过secureCodeBox，我们提供了一个持续扫描应用程序的工具链，可在开发过程早期发现简单安全问题，从而让渗透测试人员能够专注于解决重大安全问题。

secureCodeBox项目运行在[Kubernetes](https://kubernetes.io/)上，安装需使用Kubernetes包管理器[Helm](https://helm.sh)。也可基于Docker基础设施启动各种集成的安全漏洞扫描器。

### Kubernetes上的secureCodeBox快速开始

您可以在我们的[文档网站](https://www.securecodebox.io)找到帮助您入门的资源，包括[安装secureCodeBox项目](https://www.securecodebox.io/docs/getting-started/installation)的说明和[运行首次扫描](https://www.securecodebox.io/docs/getting-started/first-scans)的指南。

## 支持的标签

- `latest`（代表最新稳定版本构建）
- 带版本号的发布标签，例如 `3.0.0`、`2.9.0`、`2.8.0`、`2.7.0`

## 如何使用此镜像

该镜像是一个潜在易受攻击的服务或应用程序，用于演示、自动化测试和培训目的。

```bash
docker pull docker.xuanyuan.run/securecodebox/old-wordpress
```

## 什么是Old Wordpress

不安全且过时的WordPress实例：切勿暴露于互联网！

### 源代码

* <https://github.com/secureCodeBox/secureCodeBox/tree/master/demo-targets/old-wordpress>

## 社区

欢迎加入我们的社区 👋

- [GitHub][scb-github]
- [Slack][scb-slack]
- [Twitter][scb-twitter]

secureCodeBox是官方[OWASP][scb-owasp]项目。

## 许可证

[![许可证](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

与所有Docker镜像一样，此镜像可能包含其他软件，这些软件可能采用其他许可证（例如基础发行版中的Bash等，以及所包含主要软件的任何直接或间接依赖项）。

对于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用均符合其中包含的所有软件的相关许可证要求。

[scb-owasp]: https://www.owasp.org/index.php/OWASP_secureCodeBox
[scb-docs]: https://www.securecodebox.io/
[scb-site]: https://www.securecodebox.io/
[scb-github]: https://github.com/secureCodeBox/
[scb-twitter]: https://twitter.com/secureCodeBox
[scb-slack]: https://join.slack.com/t/securecodebox/shared_invite/enQtNDU3MTUyOTM0NTMwLTBjOWRjNjVkNGEyMjQ0ZGMyNDdlYTQxYWQ4MzNiNGY3MDMxNThkZjJmMzY2NDRhMTk3ZWM3OWFkYmY1YzUxNTU
[scb-license]: https://github.com/secureCodeBox/secureCodeBox/blob/master/LICENSE

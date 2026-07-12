---
image: securecodebox/parser-test-scan
description: "secureCodeBox的parser-test-scan镜像是与安全扫描器配合使用的解析器镜像，主要用于内部测试operator，外部用户通常无需使用。"
source: https://xuanyuan.cloud/zh/r/securecodebox/parser-test-scan
canonical: https://xuanyuan.cloud/zh/r/securecodebox/parser-test-scan
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/securecodebox/parser-test-scan" title="securecodebox/parser-test-scan Docker 镜像中文简介、标签列表与拉取命令">securecodebox/parser-test-scan 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## OWASP secureCodeBox 简介

[OWASP secureCodeBox][scb-github]是一个自动化、可扩展的开源解决方案，用于通过简单轻量的界面集成各种安全漏洞扫描器。其使命是支持DevSecOps团队在不同场景下轻松实现安全漏洞测试自动化。

该工具链可用于持续扫描应用，在开发过程早期发现低风险问题，从而让渗透测试人员能专注于重大安全问题。secureCodeBox运行在[Kubernetes](https://kubernetes.io/)上，安装需使用Kubernetes包管理器[Helm](https://helm.sh)，也可基于Docker基础设施启动集成的安全漏洞扫描器。

### 快速入门

入门资源（包括安装指南和首次扫描教程）可参见[官方文档网站](https://www.securecodebox.io)。

## 支持的标签
- `latest`（最新稳定发布版本）
- 带版本号的发布标签，如`3.0.0`、`2.9.0`、`2.8.0`、`2.7.0`

## 镜像使用方法
此`parser`镜像需与对应的安全扫描器Docker镜像配合使用，用于解析扫描结果。详细说明参见文档页面。

```bash
docker pull docker.xuanyuan.run/securecodebox/parser-test-scan
```

## 关于test-scan
`test-scan`类型是secureCodeBox内部用于测试operator的。外部用户通常无需使用，因为它实际上不执行任何操作。

## 社区
欢迎通过以下渠道加入社区：
- [GitHub][scb-github]
- [OWASP Slack（#project-securecodebox频道）][scb-slack]
- [Mastodon][scb-mastodon]

secureCodeBox是官方[OWASP][scb-owasp]项目。

## 许可证
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

与所有Docker镜像一样，本镜像可能包含其他软件（如基础发行版中的Bash等），这些软件可能采用其他许可证。镜像用户有责任确保对本镜像的使用符合其中所有软件的相关许可证要求。

[scb-owasp]:    https://www.owasp.org/index.php/OWASP_secureCodeBox
[scb-docs]:     https://www.securecodebox.io/
[scb-site]:     https://www.securecodebox.io/
[scb-github]:   https://github.com/secureCodeBox/
[scb-mastodon]: https://infosec.exchange/@secureCodeBox
[scb-slack]:    https://owasp.org/slack/invite
[scb-license]:  https://github.com/secureCodeBox/secureCodeBox/blob/master/LICENSE

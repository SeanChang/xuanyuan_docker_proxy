---
image: securecodebox/parser-kube-hunter
description: "OWASP secureCodeBox的kube-hunter解析器镜像，用于解析kube-hunter扫描器生成的安全漏洞发现结果，需与对应扫描器镜像配合使用，支持latest及版本化标签。"
source: https://xuanyuan.cloud/zh/r/securecodebox/parser-kube-hunter
canonical: https://xuanyuan.cloud/zh/r/securecodebox/parser-kube-hunter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/securecodebox/parser-kube-hunter" title="securecodebox/parser-kube-hunter Docker 镜像中文简介、标签列表与拉取命令">securecodebox/parser-kube-hunter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 什么是OWASP secureCodeBox？

[OWASP secureCodeBox][scb-github]是一个自动化、可扩展的开源解决方案，用于通过简单轻量的界面集成各种安全漏洞扫描器。其使命是支持DevSecOps团队轻松自动化不同场景下的安全漏洞测试。

secureCodeBox提供持续扫描应用程序的工具链，帮助在开发过程早期发现低风险安全问题，使渗透测试人员能专注于主要安全问题。该项目运行在[Kubernetes](https://kubernetes.io/)上，需使用[Helm](https://helm.sh)安装，也可基于Docker基础设施启动集成的安全漏洞扫描器。

### 快速开始：在Kubernetes上使用secureCodeBox

入门资源可参见[官方文档网站](https://www.securecodebox.io)，包括[安装指南](https://www.securecodebox.io/docs/getting-started/installation)和[首次扫描教程](https://www.securecodebox.io/docs/getting-started/first-scans)。

## 支持的标签
- `latest`（最新稳定发布版本）
- 版本化标签，如`0.6.8`

## 如何使用此镜像

此`parser`（解析器）镜像需与对应的安全扫描器Docker镜像配合使用，用于解析扫描产生的`发现结果`（findings）。详细说明参见文档：https://www.securecodebox.io/docs/scanners/kube-hunter。

```bash
docker pull docker.xuanyuan.run/securecodebox/parser-kube-hunter
```

### Docker部署示例

拉取镜像后，可与kube-hunter扫描器配合运行以解析结果：
```bash
# 拉取扫描器和解析器镜像
docker pull docker.xuanyuan.run/securecodebox/scanner-kube-hunter
docker pull docker.xuanyuan.run/securecodebox/parser-kube-hunter

# 运行扫描并解析结果
docker run --rm docker.xuanyuan.run/securecodebox/scanner-kube-hunter scan --pod | docker run --rm -i securecodebox/parser-kube-hunter
```
（具体参数请参考[官方文档](https://www.securecodebox.io/docs/scanners/kube-hunter)）

## 什么是kube-hunter？

kube-hunter用于检测Kubernetes集群中的安全弱点，旨在提高对Kubernetes环境安全问题的认知。**请勿在非您所有的集群上运行！**

了解更多关于kube-hunter的信息：[kube-hunter GitHub][kube-hunter GitHub]或[kube-hunter官网][kube-hunter Website]。

## 社区

欢迎加入社区 👋
- [GitHub][scb-github]
- [OWASP Slack（#project-securecodebox频道）][scb-slack]
- [Mastodon][scb-mastodon]

secureCodeBox是官方[OWASP][scb-owasp]项目。

## 许可证
[![许可证](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

此镜像可能包含其他软件，其许可证可能不同（如基础发行版中的Bash及依赖项）。使用前请确保符合所有包含软件的许可证要求。

[scb-owasp]: https://www.owasp.org/index.php/OWASP_secureCodeBox
[scb-github]: https://github.com/secureCodeBox/
[scb-slack]: https://owasp.org/slack/invite
[scb-mastodon]: https://infosec.exchange/@secureCodeBox
[kube-hunter Website]: https://kube-hunter.aquasec.com/
[kube-hunter GitHub]: https://github.com/aquasecurity/kube-hunter

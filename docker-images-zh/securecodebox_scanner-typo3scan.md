---
image: securecodebox/scanner-typo3scan
description: "OWASP secureCodeBox的scanner-typo3scan镜像，集成Typo3Scan扫描器，用于检测Typo3 CMS版本、已安装扩展及相关已知漏洞，支持DevSecOps自动化安全测试。注意：该扫描类型已弃用，将在v5版本中移除。"
source: https://xuanyuan.cloud/zh/r/securecodebox/scanner-typo3scan
canonical: https://xuanyuan.cloud/zh/r/securecodebox/scanner-typo3scan
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/securecodebox/scanner-typo3scan" title="securecodebox/scanner-typo3scan Docker 镜像中文简介、标签列表与拉取命令">securecodebox/scanner-typo3scan 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

OWASP secureCodeBox是一个自动化、可扩展的开源解决方案，用于通过简单轻量的界面集成各种安全漏洞扫描器。其使命是支持DevSecOps团队轻松在不同场景中实现安全漏洞测试自动化，帮助在开发过程早期发现低风险问题，释放渗透测试人员资源以专注于重大安全问题。

本镜像为secureCodeBox的`scanner-typo3scan`组件，用于集成Typo3Scan扫描器。Typo3Scan是一款开源渗透测试工具，可自动检测Typo3 CMS版本及其已安装扩展，并通过已知漏洞数据库识别相关漏洞。

> **⚠️ 弃用通知**  
> `typo3scan`扫描类型已在secureCodeBox中弃用（因其上游项目不再维护），将在即将发布的v5版本中移除。

## 核心功能和特性

- **集成Typo3Scan扫描器**：自动检测Typo3 CMS版本及已安装扩展
- **漏洞检测**：基于内置数据库检查核心及扩展的已知漏洞
- **灵活配置**：支持超时设置、认证信息、自定义User-Agent等多种扫描参数
- **自动化支持**：可与secureCodeBox的parser镜像配合，将扫描结果转换为通用格式
- **DevSecOps兼容**：适合集成到持续开发流程中实现自动化安全测试

## 支持的标签

- `latest`：最新稳定发布版本
- 带版本标记的发布，如`v1.2-final`

## 使用方法和配置说明

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/securecodebox/scanner-typo3scan
```

### 基本使用

该镜像需与对应的`parser`镜像配合使用，以将扫描结果解析为secureCodeBox通用格式。详细使用说明请参考[secureCodeBox文档](https://www.securecodebox.io/docs/scanners/typo3scan)。

### 扫描配置参数

#### 目标指定

使用`-d`参数指定扫描目标，目标需为URL、主机名或IP地址。

> **注意**：使用主机名或IP地址作为目标时，URL必须以`http://`或`https://`开头，例如：`http://localhost`或`https://123.45.67.890:80`

#### 常用参数

| 参数 | 说明 |
|------|------|
| `--vuln` | 仅检查存在已知漏洞的扩展 |
| `--timeout TIMEOUT` | 请求超时时间，默认：10秒 |
| `--auth USER:PASS` | HTTP基本认证的用户名和密码 |
| `--cookie NAME=VALUE` | 用于基于cookie的认证 |
| `--agent USER-AGENT` | 设置自定义User-Agent |
| `--threads THREADS` | 枚举扩展时使用的线程数，默认：5 |
| `--json` | 将结果输出为JSON文件 |
| `--force` | 强制枚举 |
| `--no-interaction` | 不提示任何交互式问题 |

## 社区支持

欢迎通过以下渠道参与社区交流：

- [GitHub](https://github.com/secureCodeBox/)
- [OWASP Slack（#project-securecodebox频道）](https://owasp.org/slack/invite)
- [Mastodon](https://infosec.exchange/@secureCodeBox)

secureCodeBox是官方[OWASP项目](https://www.owasp.org/index.php/OWASP_secureCodeBox)。

## 许可信息

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

本镜像基于Apache 2.0许可证开源。与所有Docker镜像一样，其可能包含其他软件（如基础发行版中的Bash等），这些软件可能具有其他许可证。使用本镜像时，用户有责任确保符合其中包含的所有软件的相关许可要求。

---
image: snipe/snipe-it
description: "这是由Snipe-IT维护者提供的唯一官方Docker Hub仓库，Snipe-IT作为一款开源IT资产管理系统，主要用于帮助组织高效管理硬件设备、软件许可、配件等各类IT资产，该仓库为用户提供便捷的容器化部署方案，确保所获取的是经过官方验证、安全可靠的Snipe-IT应用镜像，是用户部署和使用Snipe-IT时获取官方标准容器镜像的唯一可信渠道。"
source: https://xuanyuan.cloud/zh/r/snipe/snipe-it
canonical: https://xuanyuan.cloud/zh/r/snipe/snipe-it
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/snipe/snipe-it" title="snipe/snipe-it Docker 镜像中文简介、标签列表与拉取命令">snipe/snipe-it 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Snipe-IT - 开源资产管理系统


## 简介  
Snipe-IT 是一款面向 IT 运维场景的开源资产管理工具，主要用于追踪设备归属（如谁持有哪台笔记本）、记录采购时间以准确计算资产折旧、管理软件许可证等。该项目基于 [Laravel 11]  开发，持续活跃更新，版本迭代频繁（[查看最新发布] ）。你可以通过 [在线演示]  体验其功能。


> [!提示]  
> **这是一款 Web 应用**，无可执行文件（如 .exe），需部署在 Web 服务器上并通过浏览器访问。支持 macOS、各类 Linux 发行版及 Windows 系统，也提供 [Docker 镜像]  方便部署。


## 目录  
- [安装指南](#安装指南)  
- [用户手册](#用户手册)  
- [Bug 反馈与功能建议](#bug-反馈与功能建议)  
- [安全说明](#安全说明)  
- [升级指南](#升级指南)  
- [多语言支持](#多语言支持)  
- [相关工具与项目](#相关工具与项目)  
- [加入社区](#加入社区)  
- [贡献代码](#贡献代码)  
- [公告订阅](#公告订阅)  


## 安装指南  
如需在服务器上安装配置 Snipe-IT，请参考 [安装手册] （完整环境要求见 [系统需求文档] ）。  

若安装遇到问题，建议先查阅 [常见问题]  和 [获取帮助]  文档，并搜索该项目的 **已开放和已关闭 Issues** 寻找解决方案。  


## 用户手册  
使用 Snipe-IT 时如需帮助，可查阅 [用户手册] 。  


## Bug 反馈与功能建议  
可通过 [GitHub Issues]  提交 Bug 报告或功能需求。提交前请先搜索 **已开放和已关闭的 Issues**，确认问题是否已被讨论或解决。  

> [!重要]  
> **提交前请务必阅读 [帮助指南]  和 [常见问题] ，并完整填写 GitHub Issue 模板中的所有问题**，以便团队快速定位并协助解决。  


## 安全说明  
> [!重要]  
> 如发现安全漏洞，请发送邮件至 [邮箱已删除]，而非通过 Issue 追踪器提交。  


## 升级指南  
升级 Snipe-IT 的具体步骤请参考 [升级文档] 。  


## 多语言支持  
Snipe-IT 支持多语言，相关配置和贡献翻译的方法详见 [多语言文档] 。  


## 相关工具与项目  
Snipe-IT 提供 JSON REST API，第三方开发者基于此开发了多种扩展工具，包括：  

### 库与模块  
- **SnipeSharp**：C# 编写的 .NET 模块（[@barrycarey] ）  
- **SnipeitPS**：PowerShell API 包装器（[@snazy2000] ）  
- **Jira Service Desk 插件**：Snipe-IT 与 Jira 集成工具（[市场链接] ）  
- **CSV 导入工具**：基于 Python 3 的资产导入脚本，支持按设备名称导入（[@gastamper] ）  
- **Kubernetes Helm Chart**：用于 Kubernetes 部署的 Helm 图表（[t3n/helm-charts] ）  
- **批量编辑工具**：基于 Google Sheets 的批量 checkout/checkin/编辑脚本（[@bricelabelle] ）  
- **系统同步脚本**：如 Mosyle/Snipe-IT 同步（[@Karpadiem] ）、Kandji/Snipe-IT 同步（[@briangoldstein] ）等  


### 移动应用  
官方移动应用开发中，目前可使用以下第三方应用：  
- **SnipeMate**：支持 iOS、Google Play、华为应用市场（Mars Technology）  
- **Snipe-Scan**：iOS 平台扫描工具（Nicolas Maton）  
- **Snipe-IT Assets Management**：Android 平台资产管理应用（DiegoGarciaDEV）  
- **AssetX**：iOS 平台 Snipe-IT 配套工具（Rishi Gupta）  


## 加入社区  
- *：[加入讨论]()，社区活跃，可获取实时帮助  
- **Bluesky**：关注 [@snipeitapp.com]   
- **Mastodon**：关注 [hachyderm.io/@grokability]   
- **博客**：访问 [Grokstar.Dev]  获取项目动态  
- **GitHub 通知**：订阅仓库以获取新版本提醒（建议仅勾选“Releases”避免消息过多）  


## 贡献代码  
- **注意**：请勿提交纯自动化工具生成的 Issues 或 Pull Requests，维护者有权关闭此类内容并限制相关账号。  
- 贡献前建议通过 Issues 进行讨论，确保功能符合项目规划。  
- 详见 [贡献指南] ，项目遵循 [贡献者行为准则](CODE_OF_CONDUCT.md)。  
- 数据库 ER 图可在 [DrawSQL]  查看，所有贡献者名单见 [CONTRIBUTORS.md](CONTRIBUTORS.md)。  


## 星标历史  
[![Star History Chart] ]   


## 公告订阅  
如需接收重要通知（如新版本发布、安全公告等），可 [订阅邮件列表] 。我们承诺不会泄露或出售你的信息，仅在必要时发送邮件。日常小更新可通过社区账号、 或博客获取。

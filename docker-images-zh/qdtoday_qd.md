---
image: qdtoday/qd
description: "QD [v20250129] 是一款基于HAR Editor和Tornado Server开发的HTTP请求定时任务自动执行框架，能够帮助用户便捷高效地设定并自动执行各类HTTP请求定时任务，为自动化测试、数据采集、接口监控等场景提供稳定可靠的技术支持，通过直观的HAR编辑功能与高性能的Tornado服务架构，实现定时任务的灵活配置与高效运行。"
source: https://xuanyuan.cloud/zh/r/qdtoday/qd
canonical: https://xuanyuan.cloud/zh/r/qdtoday/qd
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/qdtoday/qd" title="qdtoday/qd Docker 镜像中文简介、标签列表与拉取命令">qdtoday/qd — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/qdtoday/qd" title="qdtoday/qd Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/qdtoday/qd</a>

# QD：HTTP请求定时任务自动执行框架


## 项目概述  
QD是一个基于HAR Editor（HTTP归档文件编辑器）和Tornado Server开发的Python 3工具，核心功能是实现HTTP请求的定时任务自动执行。简单来说，它能帮你按设定的时间自动发送HTTP请求，适用于需要定期触发接口调用、数据采集等场景。  

项目代码托管于GitHub和Gitee平台，官方主页（[QD-Today]([])）提供完整介绍。用户可通过QQ频道（群号：g9qaiue25）参与交流。


## 核心特性  
- **HAR驱动配置**：支持直接导入浏览器捕获的HAR文件，可视化编辑HTTP请求参数（如URL、 headers、body等），无需手动编写代码。  
- **Tornado服务支撑**：基于Tornado框架搭建后台服务，保证任务调度的稳定性和并发处理能力。  
- **定时任务管理**：可自定义任务执行周期（如每日、每周或间隔分钟），自动触发并记录执行日志，方便追踪任务状态。  
- **直观操作界面**：提供登录验证和任务管理界面（包含任务列表、配置页等），简化从配置到监控的全流程操作。  


## 部署与使用  

### 快速上手  
详细操作步骤（含环境搭建、任务创建、定时规则设置）可参考官方[使用指南]([])。项目更新日志见[CHANGELOG.md](./CHANGELOG.md)，实时记录功能迭代和问题修复。  

### 部署方式  
支持Docker容器化部署，镜像已发布至Docker Hub（`qdtoday/qd`），直接拉取即可启动。镜像支持多架构，版本、拉取量等信息可在Docker Hub仓库查询。  

### 维护说明  
当前开发资源有限，仅保证对Chrome浏览器的兼容性。若测试其他浏览器（如Firefox、Edge）并确认可用，欢迎提交Pull Request补充支持。  


## 许可与致谢  

### 开源许可  
项目采用MIT许可协议（[LICENSE]([])），允许自由使用、修改和二次分发。  

### 贡献者致谢  
感谢24位开发者的贡献，涵盖代码开发、文档编写、界面设计等方向（按all-contributors规范统计）。项目持续欢迎各类贡献，包括功能优化、bug修复或浏览器兼容性测试。  


---  
项目星标趋势可通过[Stargazers over time]([])查看，反映社区关注度变化。

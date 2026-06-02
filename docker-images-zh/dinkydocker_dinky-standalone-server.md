---
image: dinkydocker/dinky-standalone-server
description: "Dinky是一款基于Apache Flink构建的实时数据开发平台，致力于为用户提供集数据采集、处理、分析与应用于一体的全流程开发工具，支持可视化任务编排、实时数据监控及高效运维管理，能够显著降低实时数据开发门槛，助力企业快速响应业务需求，构建稳定、高效的实时数据应用系统。"
source: https://xuanyuan.cloud/zh/r/dinkydocker/dinky-standalone-server
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[dinkydocker/dinky-standalone-server](https://xuanyuan.cloud/zh/r/dinkydocker/dinky-standalone-server)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Dinky

[![License]([])]([])
[![Stars]([])]([])
[![Downloads]([])]([])
[![中文文档]([])](README_zh_CN.md)
[![英文文档]([])](README.md)

[![Stargazers over time]([])]([])


### 项目介绍  
基于Apache Flink构建的开源实时计算平台，支持实时应用作业开发、数据调试及运行时监控，助力高效实时计算应用落地。


### 核心特性  
#### 1. 沉浸式Flink SQL数据开发  
提供提示补全、语句美化、在线调试、语法校验、逻辑计划解析、元数据管理、数据血缘追踪、版本对比等功能。  

#### 2. 多模式FlinkSQL开发与执行支持  
适配FlinkSQL多版本开发与执行模式，包括Local、Standalone（独立集群）、Yarn/Kubernetes Session（会话模式）、Yarn Per-Job（单作业模式）、Yarn/Kubernetes Application（应用模式）。  

#### 3. 完善的Flink生态兼容  
支持连接器（Connector）、FlinkCEP、FlinkCDC、Paimon、PyFlink等Flink生态组件。  

#### 4. FlinkSQL语法增强  
扩展FlinkSQL能力，包括数据库同步、执行环境配置、全局变量、表值聚合函数、依赖加载、行级权限控制及Jar包执行。  

#### 5. 全库实时入仓入湖支持  
基于FlinkCDC实现全库实时入仓入湖，并支持FlinkCDC Pipeline任务管理。  

#### 6. 实时在线调试能力  
支持表数据预览、变更日志（ChangeLog）及自定义函数（UDF）在线调试。  

#### 7. 元数据与数据源管理  
集成Flink Catalog，支持数据源元数据在线查询与管理。  

#### 8. 实时任务运维监控  
提供任务启停、作业信息、运行日志、版本记录、作业快照、监控面板、SQL血缘、告警记录等运维功能。  

#### 9. 多渠道告警机制  
支持实时作业告警及告警组配置，适配钉钉、微信、飞书、邮件、短信、HTTP接口等渠道。  

#### 10. 自动化状态恢复  
自动管理SavePoint/CheckPoint的恢复与触发，支持最新、最早、指定时间点等恢复策略。  

#### 11. 资源统一管理  
覆盖集群实例、集群配置、数据源、告警规则、文档、全局变量、Git项目、UDF、资源文件、系统配置等资源管理。  

#### 12. 企业级管理能力  
支持多租户、用户、角色、令牌（Token）管理。  

*更多隐藏功能待用户探索*  


### 工作原理  
![dinky_principle]([])  


### 功能截图  
#### 数据开发界面（Data Studio）  
![datastudio]([])  

#### 数据调试界面（Data Debug）  
![datadebug]([])  

#### 任务监控面板（Task Monitor）  
![devops]([])  

#### 任务指标面板（Task Metrics）  
![metrics]([])  


### 参与贡献  
[![PRs Welcome]([])]([])  

欢迎加入社区，共建共赢！贡献流程详见：[如何贡献]([])。  

感谢所有已为Dinky贡献代码的开发者！  
[![contrib graph]([])]([])  


### 部署指南  
详见[源码编译]([])及[安装部署]([])文档。  


### 致谢  
站在巨人的肩膀上，Dinky得以诞生。在此，我们向所有使用的开源软件及其社区致以衷心感谢！我们希望不仅是开源的受益者，更是贡献者，也期待志同道合的伙伴加入，共同为开源社区贡献力量。  

以下为部分致谢项目：  
[Apache Flink]([])  
[Apache FlinkCDC]([])  
[Apache Paimon]([])  
[Apache Dolphinscheduler]([])  
[Apache Doris]([])  
[Druid]([])  
[Ant-Design-Pro]([])  
[Mybatis Plus]([])  
[Monaco Editor]([])  
[Sa Token]([])  
[SpringBoot]()  

感谢[JetBrains]([])提供免费开源许可证支持。  
[![JetBrains]([])]([])  


### 获取帮助  
1. **提交Issue**：在GitHub创建Issue并清晰描述问题。  
2. **查阅文档**：访问[官方网站]([])获取最新手册。  
3. **加入社区**：  
   - 微信用户群：添加微信`wenmo_ai`邀请入群（备注“Dinky + 公司名 + 职位”）。  
   - QQ用户群：**543709668**。  
4. **关注公众号**：微信搜索“Dinky Open Source”获取官方动态。  


### 版权信息  
详见[LICENSE]([])文档。

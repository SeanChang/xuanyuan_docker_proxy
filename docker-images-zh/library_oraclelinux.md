---
image: library/oraclelinux
description: "甲骨文Linux的官方Docker构建版本，基于Oracle Linux发行版制作，经过严格测试并集成核心组件与安全更新，为容器化应用提供官方支持、稳定可靠的运行环境，适用于开发、测试及生产环境，确保与Oracle Linux系统的高度兼容性，满足企业级容器部署需求，是用户高效构建和运行容器化应用的开箱即用解决方案。"
source: https://xuanyuan.cloud/zh/r/library/oraclelinux
canonical: https://xuanyuan.cloud/zh/r/library/oraclelinux
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/oraclelinux" title="library/oraclelinux Docker 镜像中文简介、标签列表与拉取命令">library/oraclelinux — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/oraclelinux" title="library/oraclelinux Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/oraclelinux</a>

# Oracle Linux 镜像介绍


## 快速参考
- **维护方**：  
  [Oracle Linux 容器团队]([])  

- **获取帮助**：  
  详见下文“客户支持”和“社区支持”章节  


## 支持的标签及对应 Dockerfile 链接
- [`10`]([])  
- [`10-slim`]([])  
- [`9`]([])  
- [`9-slim`]([])  
- [`9-slim-fips`]([])  
- [`8.10`, `8`]([])  
- [`8-slim`]([])  
- [`8-slim-fips`]([])  
- [`7.9`, `7`]([])  
- [`7-slim`]([])  
- [`7-slim-fips`]([])  


## 补充快速参考
- **问题反馈渠道**：  
  [[]]([])  

- **支持的架构**（[更多信息]([])）：  
  [`amd64`]([])、[`arm64v8`]([])  

- **镜像 artifact 详情**：  
  [repo-info 仓库的 `repos/oraclelinux/` 目录]([])（[更新历史]([])）  
  （包含镜像元数据、传输大小等信息）  

- **镜像更新**：  
  [official-images 仓库的 `library/oraclelinux` 标签]([])  
  [official-images 仓库的 `library/oraclelinux` 文件]([])（[更新历史]([])）  

- **本文档来源**：  
  [docs 仓库的 `oraclelinux/` 目录]([])（[更新历史]([])）  


## Oracle Linux 简介
Oracle Linux 是一款基于 GNU 通用公共许可证（GPLv2）的开源操作系统，适用于通用场景或 Oracle 工作负载。其经过每日超 128,000 小时的真实工作负载严格测试，包含多项独特创新，如 Ksplice（零停机内核补丁）、DTrace（实时诊断工具）、Btrfs 文件系统等。

> **注意**：`oraclelinux` 镜像**不含 `latest` 标签**，使用时需指定[现有标签]([])。详见下文“`latest` 标签的移除”说明。


## 使用指南
### 如何使用这些镜像
Oracle Linux 镜像 intended 用于下游 `Dockerfile` 的 `FROM` 字段。例如，如需使用最新优化的 Oracle Linux 8 镜像，可指定 `FROM oraclelinux:8`。

### `latest` 标签的移除
2020 年 6 月，Oracle Linux 官方镜像移除了 `latest` 标签，以避免新版本引入的不兼容变更影响下游镜像。下游镜像需指定具体版本，如 `oraclelinux:7` 或 `oraclelinux:8`。

### 不同变体的差异
#### Oracle Linux 8 变体
- **`oraclelinux:8`**：推荐用于大多数基于 Oracle Linux 8 的镜像，功能完整。  
- **`oraclelinux:8-slim`**：仅包含“最小用户空间”，适用于静态编译二进制文件或微服务。因使用 `microdnf` 替代 `dnf` 且精简了 locale 数据，不建议用于通用场景。

#### Oracle Linux 7 变体
- **`oraclelinux:7-slim`**：推荐作为 Oracle Linux 7 用户空间的基础层，仅包含 `yum` 安装依赖的必要包。  
- **`oraclelinux:7`**：基于 Oracle Linux 最小化安装的软件包集合，模拟物理机最小安装环境。


## 更新日志
Oracle 维护 [CHANGELOG]([])，按发布日期记录官方镜像更新中应用的补丁及修复的 CVE 漏洞。


## 官方资源
- [Oracle Linux 文档]([])  
- [Oracle Linux Yum 服务器]([])  
- [Unbreakable Linux Network]([])  


## 支持渠道
### 客户支持
Oracle Linux 订阅客户可通过 [My Oracle Support]([]) 门户获取支持。Oracle Linux 容器镜像涵盖于 Oracle Linux Basic 和 Premier 支持订阅，客户可通过现有支持流程获取容器中 Oracle Linux 的支持服务。

### 社区支持
无 Oracle Linux 支持订阅的用户，可通过 [Oracle Linux 容器镜像仓库]([]) 在 GitHub 上[提交 issue]([]) 或[发起讨论]([])。


## 许可证
查看本镜像包含软件的 [Oracle Linux 最终用户许可协议]([])。  
与所有 Docker 镜像类似，本镜像可能包含其他软件（如基础发行版的 Bash 等，及主要软件的直接/间接依赖），这些软件可能适用其他许可证。  
部分自动检测到的附加许可证信息可在 [repo-info 仓库的 `oraclelinux/` 目录]([]) 中查看。  
使用预构建镜像时，用户需自行确保其使用行为符合镜像中所有软件的相关许可证要求。

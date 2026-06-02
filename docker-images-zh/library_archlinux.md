---
image: library/archlinux
description: "Arch Linux是一款简洁、轻量级的Linux发行版，以灵活性为核心目标，它采用滚动更新模式，强调极简设计与用户自主配置，允许用户从零开始构建符合个人需求的系统，凭借高效的包管理工具（如pacman）和活跃的社区支持，深受追求系统掌控权与定制化体验的技术用户青睐，在保持轻量的同时为用户提供高度自由的操作空间。"
source: https://xuanyuan.cloud/zh/r/library/archlinux
canonical: https://xuanyuan.cloud/zh/r/library/archlinux
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/archlinux" title="library/archlinux Docker 镜像中文简介、标签列表与拉取命令">library/archlinux — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/archlinux" title="library/archlinux Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/archlinux</a>

# Arch Linux Docker 镜像介绍


## 快速参考

### 维护者  
由 Arch Linux 可信用户 [Santiago Torres-Arias]([])、[Christian Rebischke]([])、[Justin Kromlinger]([]) 及 Arch Linux 开发者 [Pierre Schmitz]([]) 共同维护。

### 求助渠道  
可通过 [Docker 社区 Slack]([])、[Server Fault]([])（服务器相关问题）、[Unix & Linux]([])（Unix/Linux 技术问题）或 [Stack Overflow]([])（编程相关问题）获取帮助。


## 支持的标签及对应 Dockerfile 链接  
- [`latest`, `base`, `base-20251005.0.430597`]([])  
- [`base-devel`, `base-devel-20251005.0.430597`]([])  
- [`multilib-devel`, `multilib-devel-20251005.0.430597`]([])  


## 快速参考（续）

### 问题反馈地址  
[]  

### 支持的架构  
仅支持 [`amd64`]([])（详情参见 [多架构说明]([])）。  

### 镜像制品详情  
可查看 [repo-info 仓库的 `repos/archlinux/` 目录]([])（含镜像元数据、传输大小等信息，[历史记录]([])）。  

### 镜像更新  
- 关注 [official-images 仓库的 `library/archlinux` 标签]([])  
- 查看 [official-images 仓库的 `library/archlinux` 文件]([])（[历史记录]([])）  

### 本文档来源  
[docs 仓库的 `archlinux/` 目录]([])（[历史记录]([])）  


## 什么是 Arch Linux？  
Arch Linux 是一款轻量且灵活的 Linux® 发行版，核心理念是“保持简洁”（Keep It Simple）。  

目前官方提供针对 x86-64 架构优化的软件包，同时辅以社区运营的软件仓库，其规模和质量持续增长。社区成员背景多元、互助性强，覆盖从新手到专家的各类用户场景。可通过论坛、邮件列表参与交流，或查阅 [Arch Wiki]([]) 了解更多。  

![Arch Linux 标志]([])  


## 关于此镜像  

### 基本信息  
该镜像的根文件系统 tar 包由 Arch Linux 基础设施每周日 00:00 UTC 自动生成。因 Arch Linux 为滚动发布模式，镜像标签包含元包名称及生成时间戳，例如 `archlinux:base-20201101.0.7893` 对应 2020 年 11 月 1 日生成的 [CI 任务 #7893]([])。`latest` 标签始终与最新的 `base` 标签同步。  

除 `base` 外，还提供 `base-devel` 和 `multilib-devel` 元包对应的镜像。  


### 设计目标  
- 提供原汁原味的 Arch Linux 体验  
- 定期更新并保持 `base`、`base-devel`、`multilib-devel` 镜像的简洁性与完整性  
- 确保 `pacman` 包管理器开箱可用  
- 所有预装软件包保持未经修改的原始状态  


### 安全注意事项  
> ⚠️ 重要提示：出于安全考虑，镜像已移除 pacman 的 lsign 密钥。若保留统一密钥，可能导致恶意攻击者通过中间人等方式注入恶意包。首次使用时需执行 `pacman-key --init` 生成新密钥，**请勿分发此密钥**。  


### 可用性  
根文件系统 tar 包在 [Arch Linux GitLab]([]) 至少保留两个月。  


### 更新建议  
Arch Linux 为滚动发布系统，安装新软件包前建议先执行全面更新。具体操作：在 `FROM` 语句后立即添加 `RUN pacman -Syu`，或在 `docker run` 进入容器后尽快执行该命令。  


### 构建方法  
可通过 [Arch Linux GitLab 仓库]([]) 提供的工具及 Makefile 自行构建镜像。  


## 许可证  
Arch Linux Docker 镜像的构建脚本基于 GPLv3 协议授权。镜像内软件包的许可证信息可在 `/usr/share/licenses/` 目录下查看。  

与所有 Docker 镜像类似，其中可能包含其他软件（如基础系统中的 Bash 等），需遵守各自的许可证协议。  

部分自动检测的许可证信息可参考 [repo-info 仓库的 `archlinux/` 目录]([])。  

使用预构建镜像时，用户需自行确保符合所有包含软件的许可证要求。

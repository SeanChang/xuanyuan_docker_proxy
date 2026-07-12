---
image: bitnami/kubectl
description: "Bitnami Secure Image for kubectl 是 Bitnami 公司基于安全最佳实践构建的容器镜像，集成了 Kubernetes 命令行工具 kubectl，旨在为用户提供安全可靠的 Kubernetes 集群管理环境，该镜像经过严格的安全加固，包含漏洞扫描、依赖项验证及合规性检查，确保工具版本稳定且无已知安全风险，支持多种操作系统架构，可直接用于容器化部署或本地环境，帮助开发者和运维人员高效执行集群配置、资源管理及应用部署等操作，简化安全工具集成流程，保障 Kubernetes 管理任务的安全性与便捷性。"
source: https://xuanyuan.cloud/zh/r/bitnami/kubectl
canonical: https://xuanyuan.cloud/zh/r/bitnami/kubectl
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/kubectl" title="bitnami/kubectl Docker 镜像中文简介、标签列表与拉取命令">bitnami/kubectl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Kubectl 软件包


## 什么是 Kubectl？

Kubectl 是 Kubernetes 的命令行工具，通过一系列命令与 Kubernetes API 交互，实现对集群的管理。

[Kubectl 概述]   
商标说明：本软件清单由 Bitnami 打包。所提及的商标分属各公司所有，使用商标不意味着与 Bitnami 存在关联或获得其认可。


## 快速使用

```console
docker run --name kubectl docker.xuanyuan.run/bitnami/kubectl:latest
```

该镜像是由 Bitnami 构建维护的加固型最小化 CVE 镜像，基于云优化、安全加固的企业级操作系统 [Photon Linux] 。选择 BSI 镜像的理由包括：  
- 热门开源软件的加固安全镜像，近零漏洞  
- 漏洞分类与优先级划分，支持 VEX 声明、KEV 和 EPSS 评分  
- 合规支持，包括 FIPS、STIG、离线环境选项及安全物料清单（SBOM）  
- 通过 in-toto 提供软件供应链来源证明  
- 全面支持主流 Helm 图表  

每个镜像均附带安全元数据，可在 [公共目录]  中查看。注：部分数据需 [BSI 商业订阅]  方可获取。  

如需基于 Debian Linux 的旧版镜像，可查看 Bitnami Legacy 仓库。


## 支持的标签及 Dockerfile 链接

关于 Bitnami 标签政策及滚动标签与固定标签的区别，可参考 [文档] 。  

不同标签的对应关系可查看分支目录下的 `tags-info.yaml` 文件，例如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`。  

可通过关注 [bitnami/containers GitHub 仓库]  订阅项目更新。


## 获取镜像

推荐从 [Docker Hub 仓库]  拉取预构建镜像：

```console
docker pull docker.xuanyuan.run/bitnami/kubectl:latest
```

如需特定版本，可拉取带版本号的标签（[查看可用版本] ）：

```console
docker pull docker.xuanyuan.run/bitnami/kubectl:[TAG]
```

如需手动构建，克隆仓库后执行以下命令（替换 `APP`、`VERSION`、`OPERATING-SYSTEM` 占位符）：

```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


## 配置

### 运行命令

使用 `docker run` 在容器内执行命令，例如查看版本：

```console
docker run --rm --name kubectl docker.xuanyuan.run/bitnami/kubectl:latest version
```

完整命令列表见 [Kubectl 参考文档] 。

### 加载自定义配置

连接远程集群时，可挂载本地配置文件：

```console
docker run --rm --name kubectl -v /path/to/your/kube/config:/.kube/config docker.xuanyuan.run/bitnami/kubectl:latest
```


## 重要变更

- 自 2024 年 1 月 16 日起，`docker-compose.yaml` 文件已移除，该文件仅用于内部测试。


## 贡献

欢迎通过提交 [issue]  提出新功能需求，或提交 [pull request]  参与贡献。


## 问题反馈

如运行容器时遇到问题，可提交 [issue] 。为便于提供支持，请填写 issue 模板。


## 许可证

版权所有 © 2025 Broadcom。"Broadcom" 指 Broadcom Inc. 及其子公司。  

本软件基于 Apache 许可证 2.0 版授权。您需遵守该许可证方可使用。许可证副本可从 <[]> 获取。  

除非法律要求或书面约定，软件按 "现状" 提供，不附带任何明示或暗示的担保或条件。具体权限与限制详见许可证条款。

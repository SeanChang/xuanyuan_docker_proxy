<!-- xuanyuan-docker-images-zh
image: library/almalinux
source: https://xuanyuan.cloud/zh/r/library/almalinux
canonical: https://xuanyuan.cloud/zh/r/library/almalinux
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/almalinux" title="library/almalinux Docker 镜像中文简介、标签列表与拉取命令">library/almalinux — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/almalinux" title="library/almalinux Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/almalinux</a></p>

## AlmaLinux Docker镜像介绍


### 快速参考

#### 维护方  
[AlmaLinux OS基金会]([])  


#### 求助渠道  
可通过以下途径获取帮助：  
- [Docker社区Slack]([])  
- [Server Fault]([])  
- [Unix & Linux Stack Exchange]([])  
- [Stack Overflow]([])  


### 支持的标签及对应Dockerfile链接  

| 标签 | Dockerfile链接 |  
|------|---------------|  
| `10-kitten`、`10-kitten-20250909` | [链接]([]) |  
| `10-kitten-minimal`、`10-kitten-minimal-20250909` | [链接]([]) |  
| `10`、`10.0`、`10.0-20250909` | [链接]([]) |  
| `10-minimal`、`10.0-minimal`、`10.0-minimal-20250909` | [链接]([]) |  
| `8`、`8.10`、`8.10-20250909` | [链接]([]) |  
| `8-minimal`、`8.10-minimal`、`8.10-minimal-20250909` | [链接]([]) |  
| `latest`、`9`、`9.6`、`9.6-20250909` | [链接]([]) |  
| `minimal`、`9-minimal`、`9.6-minimal`、`9.6-minimal-20250909` | [链接]([]) |  


### 快速参考（续）  

#### 问题反馈  
可在 [AlmaLinux Bugzilla]([]) 或 [GitHub仓库]([]) 提交问题。  


#### 支持架构  
（更多信息见 [非amd64架构说明]([])）  
- `amd64`：[Docker Hub镜像]([])  
- `arm64v8`：[Docker Hub镜像]([])  
- `ppc64le`：[Docker Hub镜像]([])  
- `s390x`：[Docker Hub镜像]([])  


#### 镜像详情  
可查看 [repo-info仓库的 `repos/almalinux/` 目录]([])（[历史记录]([])），包含镜像元数据、传输大小等信息。  


#### 镜像更新  
- 官方镜像更新：[official-images仓库的 `library/almalinux` 标签]([])  
- 镜像定义文件：[official-images仓库的 `library/almalinux` 文件]([])（[历史记录]([])）  


#### 描述来源  
本文档内容来自 [docs仓库的 `almalinux/` 目录]([])（[历史记录]([])）。  


### AlmaLinux OS简介  

[AlmaLinux OS]([]) 是一款开源且永久免费的企业级Linux发行版，由社区主导和管理，专注于长期稳定性和生产级平台可靠性。它与RHEL®二进制兼容，由知名的 [CloudLinux OS]() 团队创立。目前，AlmaLinux OS由社区选举的董事会管理的AlmaLinux OS基金会负责维护。  

![AlmaLinux logo]([])  


### 关于本镜像  

#### 平台镜像（默认镜像）  
默认镜像为通用用途设计，包含完整的DNF包管理工具链及基础工具（如find、tar、vi等）。  
- 标签说明：`almalinux:latest` 始终指向最新稳定版默认镜像；主要版本（如 `almalinux:8`）和次要版本（如 `almalinux:8.4`）也提供对应标签。  


#### 最小镜像（Minimal）  
最小镜像是精简版本，仅包含microdnf包管理器和极少量基础软件包，适用于自带依赖的应用（如NodeJS、Python应用）。  
- 标签说明：`almalinux:minimal` 指向最新版最小镜像；主要版本（如 `almalinux:8-minimal`）和次要版本（如 `almalinux:8.4-minimal`）也提供对应标签。  


#### 升级策略  
所有支持版本的镜像每月更新一次，或在需要紧急安全修复时即时更新。  


#### 制作方式  
镜像的rootfs tar包通过 [livemedia-creator工具]([]) 构建，构建脚本和kickstart文件可在 [AlmaLinux/docker-images]([]) GitHub仓库获取。  


### 许可证说明  

镜像中软件的许可证信息可查看 [AlmaLinux许可政策]([])。  
与所有Docker镜像类似，本镜像可能包含其他软件（如基础系统的Bash等），这些软件可能有独立许可证。部分自动检测到的许可证信息可在 [repo-info仓库的 `almalinux/` 目录]([]) 中找到。  
使用前，请确保遵守镜像中所有软件的相关许可证要求。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/almalinux" title="library/almalinux Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/almalinux</a></p>

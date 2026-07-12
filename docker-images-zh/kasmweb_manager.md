---
image: kasmweb/manager
description: "提供Docker集群管理、服务协调与监控功能的管理服务器镜像"
source: https://xuanyuan.cloud/zh/r/kasmweb/manager
canonical: https://xuanyuan.cloud/zh/r/kasmweb/manager
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/manager" title="kasmweb/manager Docker 镜像中文简介、标签列表与拉取命令">kasmweb/manager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm 镜像技术文档


## 1. 镜像概述和主要用途

Kasm 是一个桌面和应用隔离平台，旨在通过创建按需、一次性、可通过 Web 访问的隔离环境，实现用户与 Web 威胁的安全隔离。其核心目标是在用户设备与 Web 威胁之间建立“鸿沟”，确保用户可安全地进行工作，避免本地设备直接暴露于恶意代码或攻击中。

**主要用途**：  
- 提供安全的 Web 访问环境（如浏览器隔离），隔离恶意软件、勒索软件等威胁；  
- 构建容器化桌面基础设施，支持按需创建桌面环境；  
- 支持自定义环境配置，满足企业或个人的安全办公、远程协作等需求。


## 2. 核心功能和特性

### 2.1 核心功能  
- **隔离性**：Web 代码仅在远程 Kasm 沙箱中执行，不接触用户本地设备，本地设备无网站代码执行风险。  
- **按需创建**：支持动态生成一次性隔离环境，使用后可销毁，降低长期安全风险。  
- **Web 可访问**：通过 Web 界面直接访问隔离环境，无需本地安装额外客户端。  
- **多环境支持**：提供桌面环境（基础桌面、增强桌面）和单应用环境（Chrome、Firefox 等）。  

### 2.2 关键特性  
- **可扩展性**：支持分布式架构部署，可在本地数据中心、私有云或通过 SaaS 形式提供服务。  
- **自定义能力**：管理员可基于默认镜像创建和定制专属环境镜像（如预装特定软件的桌面）。  
- **全栈管理**：Kasm Server 集成多个 Docker 服务，提供环境生命周期管理、状态监控等能力。  


## 3. 使用场景和适用范围

### 3.1 浏览器隔离  
保护用户免受恶意软件、勒索软件和钓鱼攻击。Web 访问在远程 Kasm 沙箱中进行，本地设备不执行任何网站代码，网站无法识别或访问用户本地设备信息。  

### 3.2 容器化桌面基础设施  
按需创建桌面环境，部署在 DMZ/VPC 用于外部互联网研究（如风险网站访问），或部署在内部网络用于安全访问私有资源（如企业内网应用）。  

### 3.3 适用范围  
- 企业安全办公、远程协作；  
- 外部网络风险研究（如恶意网站分析）；  
- 私有资源安全访问（如隔离访问内部数据库或敏感系统）。  


## 4. 使用方法和配置说明

### 4.1 Kasm Server 部署  
Kasm Server 由多个 Docker 服务组成，**官方不建议直接从 Docker Hub 下载容器**，需通过官方安装介质部署。安装过程中会自动从 Docker Hub 拉取所需镜像。  

#### 部署流程概述  
1. 访问 [kasmweb.com](https://kasmweb.com/) 获取官方安装包；  
2. 运行安装脚本，按提示完成网络、存储等基础配置；  
3. 安装完成后，Kasm Server 自动启动并拉取依赖镜像，通过 Web 界面访问管理控制台。  

> 详细部署步骤参考 [官方技术文档](https://kasmweb.com/docs/latest/index.html)。


### 4.2 自定义镜像配置  
管理员可基于默认镜像创建自定义环境（如预装开发工具的桌面），配置步骤如下：  
1. 参考 [自定义镜像示例](https://bitbucket.org/kasmtech/kasm_release/src/develop/) 构建基础镜像；  
2. 按 [官方指南](https://www.kasmweb.com/docs/latest/guide/custom_images.html) 配置 Kasm Server 以使用自定义镜像。  


## 5. 默认 Kasm 镜像说明  

Kasm 提供以下默认镜像（均托管于 Docker Hub），作为环境创建的基础：  

| 镜像名称                | 描述                                                                 |  
|-------------------------|----------------------------------------------------------------------|  
| `kasmweb/core`          | 所有 Kasm 镜像的基础容器，包含在 Kasm 生态中运行所需的最小组件（如环境连接、资源调度模块）。 |  
| `kasmweb/desktop`       | 基础桌面环境，预装 Chrome 和 Firefox 浏览器，适用于通用 Web 访问场景。       |  
| `kasmweb/desktop-deluxe`| 增强型桌面环境，预装更多常用软件（如办公工具、媒体播放器），作为自定义镜像的演示示例。 |  
| `kasmweb/chrome`        | 单应用环境，仅运行 Google Chrome 浏览器，适用于轻量化 Web 访问需求。         |  
| `kasmweb/firefox`       | 单应用环境，仅运行 Mozilla Firefox 浏览器，支持 Firefox 专属功能场景。       |  


## 6. Manager 服务说明  

Manager 服务是 Kasm Server 的核心组件之一，负责监控代理节点（Agents）和隔离环境（Kasms）的状态。代理节点通过自动检查机制向 Manager 服务上报运行状态，确保环境生命周期的稳定管理。  


## 7. 相关资源  

- **官方网站**：[kasmweb.com](https://kasmweb.com/)（获取安装介质和最新信息）  
- **技术文档**：[Kasm 官方文档](https://kasmweb.com/docs/latest/index.html)（安装、配置详细指南）  
- **问题反馈**：[BitBucket Issues](https://bitbucket.org/kasmtech/kasm_release/issues/)（提交 Kasm Server 相关问题）  
- **自定义镜像指南**：[自定义镜像配置文档](https://www.kasmweb.com/docs/latest/guide/custom_images.html)

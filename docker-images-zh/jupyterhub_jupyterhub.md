---
image: jupyterhub/jupyterhub
description: "JupyterHub是一款支持多用户的Jupyter笔记本服务器，它能为多个用户提供独立的交互式计算环境，允许用户通过网页浏览器访问并运行Jupyter笔记本，广泛应用于教学、科研团队协作及企业数据科学项目，方便管理员集中管理用户账户、分配资源和维护计算环境，确保不同用户在共享服务器资源时既能高效协作又能保持各自工作的独立性与安全性。"
source: https://xuanyuan.cloud/zh/r/jupyterhub/jupyterhub
canonical: https://xuanyuan.cloud/zh/r/jupyterhub/jupyterhub
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jupyterhub/jupyterhub" title="jupyterhub/jupyterhub Docker 镜像中文简介、标签列表与拉取命令">jupyterhub/jupyterhub — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jupyterhub/jupyterhub" title="jupyterhub/jupyterhub Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jupyterhub/jupyterhub</a>

# JupyterHub


## 简介  
JupyterHub 是一个多用户 Hub 系统，可用于启动、管理多个单用户 Jupyter 笔记本服务器实例并提供代理服务。它由 Project Jupyter 开发，适用于学生班级、企业数据科学团队、科研项目或高性能计算小组等多用户场景，支持多人同时使用 Jupyter 笔记本。


## 技术概览  
JupyterHub 包含三个核心组件：  
- **多用户 Hub**（tornado 进程）  
- **可配置 HTTP 代理**（node-http-proxy）  
- **多个单用户 Jupyter 笔记本服务器**（Python/Jupyter/tornado）  

基本运行流程：  
1. Hub 启动代理服务；  
2. 代理默认将所有请求转发至 Hub；  
3. Hub 处理用户登录，并按需启动单用户服务器；  
4. Hub 配置代理，将特定 URL 前缀的请求转发至对应的单用户笔记本服务器。  

此外，JupyterHub 提供 [REST API]([]) 用于 Hub 和用户的管理。


## 安装  

### 前置条件  
- 基于 Linux/Unix 的操作系统  
- Python 3.8 及以上版本  
- nodejs/npm（conda 安装时会自动包含；pip 安装需手动安装 nodejs 12.0 及以上版本）  
- 若使用默认 PAM 认证器，需安装 PAM（可插拔认证模块）  
- TLS 证书和密钥（用于 HTTPS 通信）  
- 域名  


### 安装方式  

#### 通过 conda 安装  
安装 JupyterHub 及其依赖（含 nodejs/npm）：  
```bash
conda install -c conda-forge jupyterhub
```  
若需本地运行笔记本服务器，需额外安装 JupyterLab 或 Jupyter Notebook：  
```bash
conda install jupyterlab  # 或 conda install notebook
```  


#### 通过 pip 安装  
先安装代理，再安装 JupyterHub：  
```bash
npm install -g configurable-http-proxy  # 安装代理
python3 -m pip install jupyterhub       # 安装 JupyterHub
```  
若需本地运行笔记本服务器，安装 JupyterLab 或 Jupyter Notebook：  
```bash
python3 -m pip install --upgrade jupyterlab  # 或 python3 -m pip install --upgrade notebook
```  


### 启动 Hub 服务  
运行以下命令启动 Hub：  
```bash
jupyterhub
```  
访问 `[]  

> **注意**：若需支持多用户登录，需以特权用户（如 root）身份运行 `jupyterhub` 命令。如需以非特权用户运行，需额外配置系统环境，详见 [官方文档]([])。


## 配置  

### 生成配置文件  
生成默认配置文件（含配置项说明）：  
```bash
jupyterhub --generate-config
```  


### 启动 Hub（自定义参数）  
指定 IP、端口及 HTTPS 证书启动 Hub（示例）：  
```bash
jupyterhub --ip 10.0.1.2 --port 443 --ssl-key my_ssl.key --ssl-cert my_ssl.cert
```  


### 认证器（Authenticators）  
| 认证器名称 | 说明 |  
|------------|------|  
| PAMAuthenticator | 默认内置认证器 |  
| [OAuthenticator]([]) | 基于 OAuth 的认证器 |  
| [ldapauthenticator]([]) | LDAP 认证插件 |  
| [kerberosauthenticator]([]) | Kerberos 认证插件 |  


### 启动器（Spawners）  
| 启动器名称 | 说明 |  
|------------|------|  
| LocalProcessSpawner | 默认内置，以本地进程形式启动单用户服务器 |  
| [dockerspawner]([]) | 在 Docker 容器中启动单用户服务器 |  
| [kubespawner]([]) | 基于 Kubernetes 的启动器 |  
| [sudospawner]([]) | 无需 root 权限即可启动单用户服务器 |  
| [systemdspawner]([]) | 使用 systemd 启动单用户服务器 |  
| [batchspawner]([]) | 适用于批处理调度集群 |  
| [yarnspawner]([]) | 在 Hadoop 集群中分布式启动单用户服务器 |  
| [wrapspawner]([]) | 支持运行时配置启动器的包装器 |  


## Docker 部署  
JupyterHub 提供基础 Docker 镜像 [quay.io/jupyterhub/jupyterhub]([])，但仅包含 Hub 本身，无默认配置。通常需基于此镜像构建衍生镜像，添加 `jupyterhub_config.py` 以配置认证器和启动器。单用户服务器需安装 Jupyter Notebook 4.0 及以上版本。  


### 基础启动命令  
```bash
docker run -p 8000:8000 -d --name jupyterhub quay.io/jupyterhub/jupyterhub jupyterhub
```  
- 容器名称为 `jupyterhub`，可通过 `docker stop/start jupyterhub` 停止/恢复  
- Hub 服务监听本地 8000 端口，适合桌面环境测试  


### 注意事项  
- 若部署在公网服务器，**必须通过 SSL 加密**（可配置 Docker 或使用 SSL 代理）  
- 通过 [数据卷挂载]([]) 可将数据存储在宿主机，实现持久化  
- 可通过 `docker exec -it jupyterhub bash` 进入容器，创建系统用户用于认证  


## 贡献指南  
若需参与项目贡献，可参考 [贡献者文档]([]) 和 [CONTRIBUTING.md]([])，内容包括开发环境搭建、测试套件运行及文档贡献方法。项目愿景和 roadmap 详见 [JupyterHub 社区路线图]([])。  


### 平台支持说明  
JupyterHub 官方支持 Linux/Unix 系统，**不支持 Windows**。Windows 环境下可能需通过 Docker 容器或 Linux 虚拟机运行。  


## 许可证  
项目采用共享版权模式，所有代码基于 [BSD 修订许可证]([]) 开源。  


## 帮助与资源  
- **问题反馈**：[GitHub Issues]([])  
- **教程**：[JupyterHub 教程]([])  
- **文档**：[JupyterHub 官方文档]([])、[REST API 文档]([])  
- **社区支持**：[Jupyter 社区论坛]([])、[Gitter 交流群]([])  
- **Project Jupyter**：[官网]([])、[文档]([])  


---

**[技术概览](#技术概览)** | **[安装](#安装)** | **[配置](#配置)** | **[Docker 部署](#docker-部署)** | **[贡献指南](#贡献指南)** | **[许可证](#许可证)** | **[帮助与资源](#帮助与资源)**

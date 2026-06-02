<!-- xuanyuan-docker-images-zh
image: backplane/open-webui
source: https://xuanyuan.cloud/zh/r/backplane/open-webui
canonical: https://xuanyuan.cloud/zh/r/backplane/open-webui
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [backplane/open-webui — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/backplane/open-webui "backplane/open-webui Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/backplane/open-webui

# open-webui Docker镜像（非官方镜像）文档


## 镜像概述和主要用途  
本镜像为open-webui项目的非官方Docker Hub镜像，用于镜像其在GitHub Container Registry (GHCR) 上发布的官方Docker镜像。主要用途是提供无需登录GHCR即可拉取的镜像资源，简化用户获取open-webui镜像的流程。


## 核心功能和特性  
- **非官方性质**：与open-webui项目无关联，仅作为镜像用途存在。  
- **自动同步机制**：每日从open-webui的GitHub标签页（<https://github.com/open-webui/open-webui/tags>）自动获取最新语义化版本（semver）标签，并同步对应镜像至Docker Hub（即使24小时内无更新仍会执行同步）。  
- **多级标签管理**：同步上游语义化版本标签时，会生成主版本（major）、次版本（minor）、补丁版本（patch）三级Docker标签，便于版本控制。  
- **多变体支持**：同步官方三种镜像变体：`main`（无后缀）、`ollama`、`cuda`。  
- **多架构支持**：每个变体均支持`linux/amd64`和`linux/arm64`两种架构。  


## 使用场景和适用范围  
- 需要拉取open-webui镜像但希望避免登录GHCR的用户。  
- 需要按主版本、次版本或补丁版本灵活控制镜像版本的场景。  
- 需要特定功能变体（如支持CUDA的GPU加速版本或集成Ollama的版本）的用户。  


## 镜像仓库信息  

| 仓库类型                | URL                                                                 |
|-------------------------|---------------------------------------------------------------------|
| open-webui 官方GitHub仓库 | <https://github.com/open-webui/open-webui>                          |
| open-webui 官方GHCR仓库  | <https://github.com/open-webui/open-webui/pkgs/container/open-webui> |
| 镜像Docker Hub仓库       | <https://hub.docker.com/r/backplane/open-webui>                     |
| 镜像项目GitHub仓库       | <https://github.com/backplane/open-webui-mirror/>                   |  


## 使用方法  

### 拉取镜像通用说明  
可通过Docker Hub仓库`backplane/open-webui`拉取镜像，标签格式为：`[版本号]-[变体]`（变体可选，默认`main`）。支持的版本标签级别包括主版本（如`0`）、次版本（如`0.1`）、补丁版本（如`0.1.123`）。  


### 拉取主版本标签  
适用于仅需指定主版本的场景，自动匹配该主版本下的最新次版本和补丁版本。  

```bash
# main变体（无后缀）
docker pull backplane/open-webui:0

# cuda变体
docker pull backplane/open-webui:0-cuda

# ollama变体
docker pull backplane/open-webui:0-ollama
```  


### 拉取次版本标签  
适用于需指定主版本+次版本的场景，自动匹配该次版本下的最新补丁版本。  

```bash
# main变体（无后缀）
docker pull backplane/open-webui:0.1

# cuda变体
docker pull backplane/open-webui:0.1-cuda

# ollama变体
docker pull backplane/open-webui:0.1-ollama
```  


### 拉取补丁版本标签  
适用于需精确指定版本的场景，匹配具体的主版本+次版本+补丁版本。  

```bash
# main变体（无后缀）
docker pull backplane/open-webui:0.1.123

# cuda变体
docker pull backplane/open-webui:0.1.123-cuda

# ollama变体
docker pull backplane/open-webui:0.1.123-ollama
```  


## 注意事项  
- 本镜像为非官方镜像，与open-webui项目无关联，使用时需自行承担风险。  
- 镜像标签列表可在Docker Hub仓库查看：<https://hub.docker.com/r/backplane/open-webui/tags>。  
- 自动同步逻辑依赖上游open-webui项目的语义化版本标签，若上游标签格式变更可能影响同步结果。

---
image: leesonaa/immich
description: "这是一条用于容器镜像操作的指令，具体是从GitHub容器仓库（ghcr.io）拉取和推送由imagegenius组织提供的immich应用最新版本镜像（标签为latest），是容器化部署流程中获取、更新或分发应用镜像时常用的基础命令，适用于需要通过容器技术管理immich应用版本的场景。"
source: https://xuanyuan.cloud/zh/r/leesonaa/immich
canonical: https://xuanyuan.cloud/zh/r/leesonaa/immich
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/leesonaa/immich" title="leesonaa/immich Docker 镜像中文简介、标签列表与拉取命令">leesonaa/immich — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/leesonaa/immich" title="leesonaa/immich Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/leesonaa/immich</a>

### ghcr.io/imagegenius/immich:latest 镜像拉取与推送操作说明  


#### 一、镜像说明  
目标镜像是托管在 GitHub Container Registry（ghcr.io）的 `imagegenius/immich:latest`，标签 `latest` 指向该镜像的最新稳定版本。以下介绍如何将其拉取到本地环境（获取镜像）及推送至仓库（更新镜像）的具体操作。  


### 二、拉取镜像（获取本地副本）  
拉取操作用于将远程仓库的镜像下载到本地，供本地容器运行或修改使用。  


#### 1. 前提条件  
- 本地已安装 Docker 或 Podman（容器运行工具）；  
- 网络可访问 ghcr.io（无需登录权限）。  


#### 2. 操作步骤  
##### ① 执行拉取命令  
打开终端，运行以下命令（以 Docker 为例，Podman 命令相同，仅需将 `docker` 替换为 `podman`）：  
```bash  
docker pull ghcr.io/imagegenius/immich:latest  
```  
等待命令执行完成，镜像将自动下载到本地。  


##### ② 验证拉取结果  
拉取完成后，通过以下命令查看本地是否已存在该镜像：  
```bash  
docker images | grep "ghcr.io/imagegenius/immich"  
```  
若输出包含 `ghcr.io/imagegenius/immich   latest   [镜像ID]   [创建时间]   [大小]`，则拉取成功。  


### 三、推送镜像（上传至仓库）  
推送操作用于将本地修改后的镜像上传至 ghcr.io 仓库（仅适用于有权限维护该镜像的用户，如 imagegenius 项目成员）。  


#### 1. 前提条件  
- 拥有 ghcr.io 仓库的写入权限（需为 imagegenius 组织成员或被授权的用户）；  
- 本地已安装 Docker 或 Podman；  
- 准备 GitHub 个人访问令牌（PAT），且令牌需勾选 `write:packages` 权限（创建 PAT 路径：GitHub 个人设置 → Developer settings → Personal access tokens → Generate new token）。  


#### 2. 操作步骤  
##### ① 登录 ghcr.io  
打开终端，运行登录命令：  
```bash  
docker login ghcr.io  
```  
根据提示输入：  
- **用户名**：GitHub 账号用户名；  
- **密码**：填入准备好的 PAT（而非 GitHub 账号密码）。  
提示 `Login Succeeded` 即登录成功。  


##### ② 推送镜像  
确保本地已存在待推送的 `ghcr.io/imagegenius/immich:latest` 镜像（若对镜像有修改，需先通过 `docker tag` 命令确保标签正确），执行推送命令：  
```bash  
docker push ghcr.io/imagegenius/immich:latest  
```  
等待上传完成（根据网络速度和镜像大小，耗时可能较长）。  


##### ③ 验证推送结果  
推送完成后，可通过以下方式验证：  
- 登录 [ghcr.io]([])，进入 `imagegenius/immich` 仓库，查看镜像的最新更新时间；  
- 或在本地重新拉取镜像（`docker pull ghcr.io/imagegenius/immich:latest`），对比本地镜像 ID 与远程是否一致。  


### 四、注意事项  
- **拉取无需权限**：任何用户均可拉取该镜像，无需登录 ghcr.io；  
- **推送需权限**：仅有权限用户可推送，未授权用户执行推送会提示权限错误；  
- **镜像标签**：`latest` 为动态标签，指向最新版。若需操作特定版本，可将标签替换为具体版本号（如 `v1.91.0`，需仓库存在对应标签）。

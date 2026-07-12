---
image: google/cloud-sdk
description: "谷歌云软件开发工具包（Google Cloud SDK）是集成所有必要组件与依赖项的一站式开发套件，包含gcloud、gsutil、bq等命令行工具、客户端库、API接口及认证、配置管理等关键模块，旨在帮助开发者便捷对接谷歌云平台服务，实现资源管理、应用部署、数据处理等开发操作，无需额外安装依赖即可快速上手，有效简化开发流程并提升工作效率。"
source: https://xuanyuan.cloud/zh/r/google/cloud-sdk
canonical: https://xuanyuan.cloud/zh/r/google/cloud-sdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/google/cloud-sdk" title="google/cloud-sdk Docker 镜像中文简介、标签列表与拉取命令">google/cloud-sdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Google Cloud CLI Docker镜像使用说明


Google Cloud CLI Docker镜像可从[Artifact Registry] 拉取特定版本的gcloud CLI，让你在隔离且配置正确的容器中快速执行Google Cloud CLI命令。完整细节可参考[镜像文档页] 。


## 镜像类型说明

Google Cloud CLI Docker镜像共有六种，均包含`gcloud`、`gsutil`和`bq`命令行工具。以下是各类型特点及适用场景：


### 1. `:stable`、`:VERSION-stable`  
- **特点**：最小化环境，仅包含gcloud核心组件及`gsutil`、`bq`。  
- **基础镜像**：最新[Google提供的Debian 12基础镜像] 。  
- **使用**：推荐作为基础镜像，按需扩展安装组件；指定版本用`:VERSION-stable`标签（如`:489.0.0-stable`），最新稳定版直接用`:stable`。  


### 2. `:alpine`、`:VERSION-alpine`  
- **特点**：功能同`stable`，但基于轻量级Alpine系统。  
- **基础镜像**：最新[Alpine 3.20] 。  
- **使用**：适合需要精简基础镜像的场景；指定版本用`:VERSION-alpine`标签。  


### 3. `:emulators`、`:VERSION-emulators`  
- **特点**：在`stable`基础上增加所有模拟器组件。  
- **基础镜像**：最新[Google提供的Debian 12基础镜像] ，通过组件管理器安装额外组件。  
- **使用**：需本地运行Google Cloud服务模拟器时选用；指定版本用`:VERSION-emulators`标签。  


### 4. `:latest`、`:VERSION`  
- **特点**：在`stable`基础上预装额外组件（组件列表见[此处](#components_installed_in_each_tag)）。  
- **基础镜像**：最新[Google提供的Debian 12基础镜像] ，通过deb包安装组件。  
- **使用**：需常用扩展组件时直接选用；指定版本用`:VERSION`标签。  


### 5. `:slim`、`:VERSION-slim`  
- **特点**：在`stable`基础上增加第三方工具，包括`curl`、`python3-crcmod`、`apt-transport-https`、`lsb-release`、`openssh-client`、`git`、`make`、`gnupg`。  
- **基础镜像**：最新[Google提供的Debian 12基础镜像] 。  
- **使用**：需基础开发工具链时选用；指定版本用`:VERSION-slim`标签。  


### 6. `:debian_component_based`、`:VERSION-debian_component_based`  
- **特点**：在`stable`基础上预装额外组件（组件列表见[此处](#components_installed_in_each_tag)）。  
- **基础镜像**：最新[Google提供的Debian 12基础镜像] ，通过组件管理器安装组件。  
- **使用**：需通过组件管理器灵活管理扩展组件时选用；指定版本用`:VERSION-debian_component_based`标签。  


> 查看[Docker Hub] 获取所有可用标签。  

![Docker Pulls]  ![Docker Build Status]  ![Docker Automated build]   


## 镜像安装步骤

### 镜像托管位置  
gcloud CLI Docker镜像托管于：  
- Docker Hub仓库：`google/cloud-sdk`（[查看标签] ）  
- Artifact Registry：[google.com:cloudsdktool/us/gcr.io/cloud-sdk]   


### 拉取镜像  
以stable版本为例，从Docker Hub拉取特定版本镜像（如`489.0.0-stable`）：  
```bash
docker pull docker.xuanyuan.run/google/cloud-sdk:489.0.0-stable
```  

如需拉取最新稳定版（使用浮动标签`:stable`，始终指向最新发布）：  
```bash
docker pull docker.xuanyuan.run/google/cloud-sdk:stable
```  


### 验证安装  
- **使用特定版本标签**（如`489.0.0-stable`）：  
  ```bash
  docker run --rm docker.xuanyuan.run/google/cloud-sdk:489.0.0-stable gcloud version
  ```  

- **使用浮动标签`:stable`**：  
  ```bash
  docker run --rm docker.xuanyuan.run/google/cloud-sdk:stable gcloud version
  ```  


## Cloud SDK发布跟踪  
可通过以下链接关注Cloud SDK发布计划及更新：  
[Google Cloud SDK Announce论坛]

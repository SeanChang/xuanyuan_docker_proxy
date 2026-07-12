---
image: bitnamilegacy/openldap
description: "Bitnami的旧版遗留镜像，不再提供更新。"
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/openldap
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/openldap
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnamilegacy/openldap" title="bitnamilegacy/openldap Docker 镜像中文简介、标签列表与拉取命令">bitnamilegacy/openldap 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Legacy 镜像文档


## 1. 镜像概述和主要用途

Bitnami Legacy 镜像是 Bitnami Legacy 仓库中提供的容器镜像备份集合。该仓库已停止维护，不再接收任何更新（包括功能迭代、安全补丁）或官方支持。其主要用途是为依赖旧版 Bitnami 镜像的用户提供临时迁移支持，便于用户在过渡期内完成工作负载的迁移或替换。


## 2. 核心功能和特性

- **镜像备份**：包含 Bitnami 停止维护前已存在的容器镜像完整备份，镜像内容与停止更新时的状态一致。  
- **无新增功能**：不提供任何新功能开发、性能优化或安全漏洞修复。  
- **无官方支持**：Bitnami 官方不再提供技术支持、问题响应或文档更新。  
- **版本固化**：镜像标签及内容永久固化，与停止维护时的版本状态一致。  


## 3. 使用场景和适用范围

### 3.1 适用场景  
仅用于**临时迁移**依赖旧版 Bitnami 镜像的工作负载，例如：  
- 从即将下线的旧环境迁移应用至新环境；  
- 临时保留旧镜像以确保迁移过程中业务连续性。  

### 3.2 适用范围  
- 用户需已熟悉旧版 Bitnami 镜像的使用方式；  
- 仅限无法立即切换至 [Bitnami Secure Images](https://bitnami.com/) 的过渡阶段使用。  

### 3.3 不适用场景  
- **禁止用于生产环境**：由于缺乏安全更新和支持，存在高安全风险；  
- 长期业务部署、新应用开发或关键业务系统。  


## 4. 使用方法和配置说明

### 4.1 前提条件  
- 已安装 Docker 或兼容容器运行时环境；  
- （可选）私有容器 registry（如 Harbor、Docker Registry），用于长期存储镜像（推荐）。  


### 4.2 拉取 Legacy 镜像  
使用 `docker pull` 命令从 Bitnami Legacy 仓库拉取目标镜像。镜像名称和标签需与旧版 Bitnami 镜像保持一致（具体标签需参考历史记录）。  

**示例**（以 `nginx` 镜像为例，实际名称和标签需替换为目标镜像信息）：  
```bash
docker pull docker.xuanyuan.run/bitnami/nginx:1.21  # 假设 1.21 为 Legacy 镜像标签
```  


### 4.3 存储至私有容器 registry  
由于 Legacy 仓库未来可能被移除，建议拉取后立即存储至私有 registry 以确保可用性：  

1. **为镜像打标签**（替换 `<私有 registry 地址>`、`<镜像名>`、`<标签>` 为实际值）：  
   ```bash
   docker tag bitnami/<镜像名>:<标签> <私有 registry 地址>/bitnami/<镜像名>:<标签>
   ```  

2. **推送至私有 registry**：  
   ```bash
   docker push <私有 registry 地址>/bitnami/<镜像名>:<标签>
   ```  


### 4.4 运行容器（临时测试用）  
以下示例仅用于临时验证，**禁止用于生产环境**：  

#### 4.4.1 `docker run` 命令示例  
```bash
# 以 nginx 为例，具体参数需参考旧版 Bitnami 镜像文档
docker run --rm -d \
  --name legacy-nginx \
  -p 8080:8080 \
  docker.xuanyuan.run/bitnami/nginx:1.21 # 或使用私有 registry 中的镜像地址
```  


#### 4.4.2 Docker Compose 配置示例  
创建 `docker-compose.yml` 文件（示例配置，具体参数需根据旧版镜像调整）：  
```yaml
version: '3'
services:
  legacy-app:
    image: docker.xuanyuan.run/bitnami/nginx:1.21  # 或私有 registry 地址/bitnami/nginx:1.21
    ports:
      - "8080:8080"
    # 环境变量、卷挂载等配置需参考旧版 Bitnami 镜像文档
    environment:
      - NGINX_PORT=8080
    volumes:
      - ./nginx-conf:/opt/bitnami/nginx/conf
```  

启动容器：  
```bash
docker-compose up -d
```  


### 4.5 配置参数与环境变量  
Legacy 镜像的配置参数（如命令行参数、环境变量、配置文件路径等）与停止维护前的旧版 Bitnami 镜像完全一致。具体参数需参考对应镜像的历史文档（Bitnami 官方文档可能已下线，建议依赖本地记录或旧版文档备份）。  

**注意**：由于镜像不再更新，参数行为可能与当前系统环境存在兼容性问题，需自行验证。  


## 5. 注意事项  
- **无安全保障**：镜像不含任何后续安全更新，可能存在未修复的漏洞，使用时需自行承担风险。  
- **支持终止**：Bitnami 官方不提供任何技术支持，问题需自行排查。  
- **仓库移除风险**：Legacy 仓库未来可能被永久移除，务必提前迁移至私有 registry。  
- **推荐替代方案**：生产环境请迁移至 [Bitnami Secure Images](https://bitnami.com/)，其提供硬化容器、更小攻击面、CVE 透明度（VEX/KEV）、SBOM 及企业支持。

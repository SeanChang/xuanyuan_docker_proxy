<!-- xuanyuan-docker-images-zh
image: bitnamilegacy/etcd
source: https://xuanyuan.cloud/zh/r/bitnamilegacy/etcd
canonical: https://xuanyuan.cloud/zh/r/bitnamilegacy/etcd
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [bitnamilegacy/etcd — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bitnamilegacy/etcd "bitnamilegacy/etcd Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/bitnamilegacy/etcd

# Bitnami Legacy 镜像文档


## 镜像概述和主要用途

### 概述  
Bitnami Legacy 镜像是 Bitnami 遗留的容器镜像集合，该仓库已停止更新，不再提供任何维护或技术支持。这些镜像仅作为历史容器镜像的备份存档，用于特定场景下的临时过渡。

### 主要用途  
- **临时迁移支持**：仅用于依赖旧版 Bitnami 镜像的用户进行系统迁移或过渡。  
- **历史镜像备份**：作为现有 Bitnami 容器镜像的快照，供用户获取历史版本用于迁移准备。  


## 核心功能和特性  
- **镜像备份**：包含 Bitnami 历史容器镜像的完整备份。  
- **无更新支持**：停止接收功能更新、安全补丁及技术支持。  
- **兼容性保留**：保留原始 Bitnami 镜像的基础结构，确保与历史环境的兼容性。  


## 使用场景和适用范围  

### 适用场景  
- **系统迁移过渡期**：当用户需要从旧版 Bitnami 镜像迁移至新环境时，可临时使用该镜像作为过渡。  
- **历史环境复现**：用于复现基于旧版 Bitnami 镜像构建的历史系统，以提取数据或配置。  

### 不适用场景  
- **生产环境**：严禁用于生产工作负载，缺乏安全更新和维护支持，存在潜在风险。  
- **长期部署**：不适合长期使用，仓库未来可能被移除。  


## 使用方法和配置说明  

### 前提条件  
- 已安装 Docker 环境（Docker Engine 19.03+ 或兼容版本）。  
- 拥有访问 Docker Hub 或 Bitnami Legacy 仓库的网络权限。  


### 镜像拉取  
使用 `docker pull` 命令拉取具体镜像（需替换 `<image-name>` 和 `<tag>` 为目标镜像名称及标签）：  
```bash
docker pull bitnami/<image-name>:<tag>
```  
*示例*：拉取遗留的 Nginx 镜像（假设存在）：  
```bash
docker pull bitnami/nginx:1.21.6-debian-10-r100
```  


### 镜像存储（推荐）  
由于该仓库未来可能被移除，建议将拉取的镜像存储至私有容器仓库：  
1. 标记镜像为私有仓库地址：  
   ```bash
   docker tag bitnami/<image-name>:<tag> <your-registry>/<image-name>:<tag>
   ```  
2. 推送至私有仓库：  
   ```bash
   docker push <your-registry>/<image-name>:<tag>
   ```  


### 运行示例（通用）  
遗留镜像的运行方式与原始 Bitnami 镜像一致，具体命令需根据目标镜像调整。以下为通用示例：  
```bash
docker run -d --name legacy-container bitnami/<image-name>:<tag>
```  
*注：实际运行参数（如端口映射、 volumes 等）需参考原始 Bitnami 镜像文档配置。*  


### 配置说明  
- **环境变量**：无新增或特有环境变量，配置方式与原始 Bitnami 镜像一致，建议参考对应镜像的历史文档。  
- **配置文件**：如需自定义配置，需通过挂载 volumes 覆盖容器内配置文件（具体路径参考原始镜像文档）。  


## 注意事项  
1. **停止更新与支持**：镜像无任何更新（包括安全补丁），存在潜在漏洞风险。  
2. **临时使用限制**：仅用于短期迁移，使用后需尽快切换至受支持的镜像。  
3. **仓库存续风险**：该仓库未来可能被永久移除，务必及时将所需镜像迁移至私有仓库。  
4. **生产环境替代方案**：生产工作负载请迁移至 [Bitnami Secure Images](https://bitnami.com/)，其提供强化容器、更小攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 及企业支持。

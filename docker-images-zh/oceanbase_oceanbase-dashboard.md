---
image: oceanbase/oceanbase-dashboard
description: "用于在Kubernetes上管理OceanBase的仪表盘"
source: https://xuanyuan.cloud/zh/r/oceanbase/oceanbase-dashboard
canonical: https://xuanyuan.cloud/zh/r/oceanbase/oceanbase-dashboard
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oceanbase/oceanbase-dashboard" title="oceanbase/oceanbase-dashboard Docker 镜像中文简介、标签列表与拉取命令">oceanbase/oceanbase-dashboard 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# oceanbase-dashboard 镜像文档


## 1. 镜像概述和主要用途  
oceanbase-dashboard 是一款用于在 Kubernetes 环境中管理 OceanBase 集群的 Web 服务。其核心功能依赖于 ob-operator 组件，提供可视化界面以简化 OceanBase 在 Kubernetes 上的部署、监控与运维操作。使用前需确保已部署 ob-operator，详细信息可参考 [ob-operator 官方文档](https://oceanbase.github.io/ob-operator/)。


## 2. 核心功能和特性  
基于管理类 Dashboard 的常见能力，oceanbase-dashboard 通常具备以下功能（具体以官方最新版本为准）：  
- **集群状态可视化**：实时展示 OceanBase 集群在 Kubernetes 中的运行状态、节点健康度、资源使用率等关键指标。  
- **部署与扩缩容管理**：支持通过界面化操作发起 OceanBase 集群的部署、扩容、缩容等任务，简化复杂运维流程。  
- **配置管理**：提供集群参数配置界面，支持修改并应用 OceanBase 集群配置（需配合 ob-operator 实现配置下发）。  
- **日志与告警集成**：可接入 OceanBase 集群日志，支持基本告警规则配置与展示。  
- **操作审计**：记录对集群的关键操作，便于追溯管理行为。  


## 3. 使用场景和适用范围  
### 适用场景  
- 在 Kubernetes 环境中部署、管理 OceanBase 集群的可视化需求。  
- 对 OceanBase 集群状态、资源使用进行实时监控与分析。  
- 简化 OceanBase 集群的日常运维操作（如扩缩容、配置调整）。  

### 适用人群  
- Kubernetes 与 OceanBase 集群运维人员。  
- 需要可视化管理 OceanBase 集群的开发或测试团队。  


## 4. 使用方法和配置说明  

### 4.1 环境变量配置  
oceanbase-dashboard 支持通过环境变量进行配置，常见参数如下（实际使用需参考官方最新文档）：  

| 环境变量名           | 说明                                  | 默认值       |
|----------------------|---------------------------------------|--------------|
| `OB_OPERATOR_URL`    | ob-operator 服务的访问地址（必填）     | `http://ob-operator:8080` |
| `PORT`               | Dashboard 服务监听端口                | `8080`       |
| `LOG_LEVEL`          | 日志级别（DEBUG/INFO/WARN/ERROR）     | `INFO`       |
| `AUTH_ENABLED`       | 是否启用认证（true/false）            | `false`      |
| `AUTH_TOKEN`         | 认证令牌（当 `AUTH_ENABLED=true` 时必填） | -            |  


### 4.2 部署方案示例  

#### 4.2.1 使用 `docker run` 部署  
```bash
docker run -d \
  --name oceanbase-dashboard \
  -p 8080:8080 \
  -e OB_OPERATOR_URL="http://ob-operator-service:8080" \  # 替换为实际 ob-operator 地址
  -e LOG_LEVEL="INFO" \
  oceanbase/oceanbase-dashboard:latest
```  
**说明**：  
- `-p 8080:8080`：映射容器端口到主机，便于外部访问 Dashboard。  
- `OB_OPERATOR_URL` 需指向 Kubernetes 集群内 ob-operator 的服务地址（可通过 `kubectl get svc` 获取）。  


#### 4.2.2 使用 Docker Compose 部署  
创建 `docker-compose.yml` 文件：  
```yaml
version: '3'
services:
  oceanbase-dashboard:
    image: docker.xuanyuan.run/oceanbase/oceanbase-dashboard:latest
    container_name: oceanbase-dashboard
    ports:
      - "8080:8080"
    environment:
      - OB_OPERATOR_URL=http://ob-operator-service:8080  # 替换为实际 ob-operator 地址
      - PORT=8080
      - LOG_LEVEL=INFO
      - AUTH_ENABLED=false
    restart: unless-stopped
```  
启动服务：  
```bash
docker-compose up -d
```  


### 4.3 访问 Dashboard  
部署完成后，通过浏览器访问 `http://<主机IP>:8080` 即可打开 oceanbase-dashboard 界面。首次使用需确保 ob-operator 已正常运行，且 `OB_OPERATOR_URL` 配置正确。


## 5. 注意事项  
- **依赖要求**：必须先在 Kubernetes 集群中部署 ob-operator，且确保 oceanbase-dashboard 可访问 ob-operator 服务（网络连通性需提前验证）。  
- **版本兼容性**：oceanbase-dashboard 与 ob-operator 的版本需匹配，具体兼容关系参考 [ob-operator 官方文档](https://oceanbase.github.io/ob-operator/)。  
- **生产环境配置**：生产环境建议启用认证（`AUTH_ENABLED=true`）并配置安全的 `AUTH_TOKEN`，避免未授权访问。

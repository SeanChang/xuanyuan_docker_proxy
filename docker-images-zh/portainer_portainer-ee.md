---
image: portainer/portainer-ee
description: "Portainer BE是用于容器化应用的功能全面的服务交付平台"
source: https://xuanyuan.cloud/zh/r/portainer/portainer-ee
canonical: https://xuanyuan.cloud/zh/r/portainer/portainer-ee
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [portainer/portainer-ee — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/portainer/portainer-ee)

含镜像标签、拉取命令、部署文档与相关推荐。

[portainer/portainer-ee Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/portainer/portainer-ee)

# Portainer Business Edition 技术文档


## 1. 镜像概述和主要用途

### 1.1 概述  
Portainer Business Edition（简称 Portainer BE）是一款全功能的容器化应用服务交付平台，同时也是通用容器管理平台，旨在简化容器化应用的部署、配置、故障排除和安全防护流程。

### 1.2 主要用途  
Portainer BE 支持跨云环境、数据中心、边缘节点及工业物联网（IIoT）场景的容器化应用全生命周期管理，帮助企业用户以更安全、高效的方式实现容器技术落地，缩短从开发到生产的交付周期。


## 2. 核心功能和特性

### 2.1 基础设施通用性  
支持在 Kubernetes、Docker、Docker Swarm 等主流容器编排平台上部署，兼容云环境、本地数据中心、边缘设备及工业物联网等多类基础设施，实现跨环境统一管理。

### 2.2 自助服务与合规平衡  
提供自助服务门户，允许开发团队自主部署和管理应用，同时通过细粒度权限控制、审计日志等合规护栏功能，满足企业级安全与合规要求。

### 2.3 轻量化部署  
采用单容器架构设计，无需复杂依赖，可快速部署至任意集群环境，降低运维复杂度。

### 2.4 全生命周期管理  
集成应用部署、配置管理、监控告警、故障排查、安全扫描等功能，覆盖容器化应用从构建到运维的完整生命周期。


## 3. 使用场景和适用范围

### 3.1 行业适用  
广泛应用于金融服务、信息技术、制造业、能源、汽车、医疗健康等行业，尤其适合需要严格合规控制和跨环境管理的企业级用户。

### 3.2 环境适用  
- **云环境**：AWS、Azure、Google Cloud 等公有云平台的容器集群管理；  
- **数据中心**：本地数据中心的 Kubernetes 或 Docker Swarm 集群运维；  
- **边缘计算**：边缘节点（如工厂设备、智能终端）的轻量化容器管理；  
- **工业物联网（IIoT）**：工业场景下的容器化应用部署与监控。  


## 4. 使用方法和配置说明

### 4.1 快速开始  
- **3 节点免费版**：永久免费使用 BE 版本管理 3 个节点，[立即获取](https://www.portainer.io/take-3)；  
- **商业授权**：如需管理更多节点，[查看定价](https://www.portainer.io/pricing)并购买商业授权；  
- **官方文档**：详细部署与配置指南，[访问文档中心](https://docs.portainer.io)。


### 4.2 部署示例  

#### 4.2.1 Docker 单节点部署  
通过以下命令快速部署 Portainer BE（需先安装 Docker）：  
```bash
docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-be:latest
```  
- **参数说明**：  
  - `-p 8000:8000`：边缘代理端口，用于边缘节点通信；  
  - `-p 9443:9443`：Web UI 端口（HTTPS）；  
  - `-v /var/run/docker.sock:/var/run/docker.sock`：挂载 Docker 守护进程 socket，实现对本地 Docker 环境的管理；  
  - `-v portainer_data:/data`：持久化存储 Portainer 配置数据。


#### 4.2.2 Docker Compose 部署  
创建 `docker-compose.yml` 文件：  
```yaml
version: '3'
services:
  portainer:
    image: portainer/portainer-be:latest
    container_name: portainer
    restart: always
    ports:
      - "8000:8000"
      - "9443:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
```  
执行部署命令：  
```bash
docker-compose up -d
```


### 4.3 配置说明  
- **数据持久化**：通过 `portainer_data` 卷保存配置、用户数据及审计日志，建议定期备份；  
- **端口映射**：默认使用 9443（HTTPS）和 8000（边缘代理）端口，如需修改可调整 `-p` 参数；  
- **环境变量**：支持通过 `-e` 参数配置自定义环境变量（如 `ADMIN_PASSWORD` 设置初始管理员密码），详细参数见 [官方文档](https://docs.portainer.io)。  


## 5. 获取帮助  

### 5.1 技术支持  
- **商业支持**：通过 [Portainer Business 支持平台](https://www.portainer.io/portainer-business-support)提交工单；  
- **常见问题**：访问 [官方 FAQ](https://documentation.portainer.io) 获取解决方案。  

### 5.2 社区资源  
- **Slack 社区**：加入 [Portainer Slack 频道](https://join.slack.com/t/portainer/shared_invite/zt-txh3ljab-52QHTyjCqbe5RibC2lcjKA) 与开发者及用户交流。  

### 5.3 官方文档  
完整配置指南、API 参考及最佳实践，详见 [Portainer 文档中心](https://docs.portainer.io)。

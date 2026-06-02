---
image: docker/ucp-auth
description: "docker/ucp镜像是Docker企业版核心组件，用于构建和管理容器集群，提供集中化控制、多租户管理及安全集成功能，支持企业级容器编排与运维。"
source: https://xuanyuan.cloud/zh/r/docker/ucp-auth
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[docker/ucp-auth](https://xuanyuan.cloud/zh/r/docker/ucp-auth)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Docker UCP 镜像文档


## 一、镜像概述和主要用途

`docker/ucp` 是 Docker Universal Control Plane（UCP）的官方镜像，用于部署和运行 UCP 服务。UCP 是 Docker 企业版（EE）的核心组件，提供企业级 Docker 集群管理能力，包括集中式 Web UI、REST API、身份验证与授权、多租户隔离、策略管理等功能，帮助用户在生产环境中安全、高效地管理容器化应用和 Docker 集群。


## 二、核心功能和特性

### 1. 集群管理与编排
- 支持 Docker Swarm 模式集群的创建、扩展和维护
- 提供可视化容器、服务、节点、网络和存储资源管理界面
- 集成容器编排策略（如滚动更新、回滚、负载均衡）

### 2. 身份与访问控制
- 支持 LDAP/AD、SAML 2.0 等企业级身份认证集成
- 基于角色的访问控制（RBAC），支持多租户权限隔离
- 细粒度资源权限管理（命名空间、服务、节点级权限）

### 3. 策略与合规
- 内置容器资源限制策略（CPU、内存、存储）
- 镜像准入控制（仅允许可信镜像部署）
- 审计日志记录所有集群操作，满足合规要求（如 GDPR、HIPAA）

### 4. 高可用性与可扩展性
- 支持多主节点部署，实现 UCP 服务高可用（HA）
- 跨数据中心集群联邦，统一管理分布式容器资源
- 水平扩展能力，支持上千节点规模集群

### 5. 集成与生态
- 无缝对接 Docker Trusted Registry（DTR），实现镜像全生命周期管理
- 提供 REST API 和 CLI 工具，支持自动化运维集成
- 兼容 Prometheus、Grafana 等监控工具，支持自定义告警


## 三、使用场景和适用范围

### 1. 企业级容器集群管理
- 适用于需要集中管理多节点 Docker 集群的生产环境
- 解决大规模容器部署的资源调度、故障恢复和容量规划问题

### 2. 多团队协作环境
- 支持多租户隔离，不同团队共享集群资源但拥有独立权限边界
- 满足开发、测试、生产环境资源隔离与统一管理需求

### 3. 安全合规要求高的场景
- 金融、医疗等行业需要严格访问控制和操作审计的环境
- 需满足数据隔离、镜像安全扫描和策略强制执行的场景

### 4. 混合云/多云部署
- 统一管理私有云、公有云（AWS/Azure/GCP）及边缘环境的 Docker 集群
- 支持跨云平台容器迁移和资源弹性调度


## 四、使用方法和配置说明

### 1. 前提条件
- **Docker 引擎**：需安装 Docker Engine 19.03+（企业版或社区版）
- **系统要求**：
  - 操作系统：Linux（Ubuntu 18.04+/CentOS 7.5+）
  - 硬件：最低 4 CPU 核心、8GB 内存、100GB SSD 存储
  - 网络：节点间需开放 TCP 2376、443、2377、7946 端口，UDP 4789、7946 端口

### 2. 部署 UCP 集群

#### 2.1 单节点部署（测试/开发环境）
```bash
docker run --rm -it \
  --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:latest \
  install \
  --host-address <UCP_HOST_IP> \
  --admin-username <ADMIN_USER> \
  --admin-password <ADMIN_PASSWORD> \
  --license <DOCKER_EE_LICENSE_KEY>
```

#### 2.2 高可用（HA）部署（生产环境）
**第 1 步：初始化主节点**
```bash
docker run --rm -it \
  --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:latest \
  install \
  --host-address <MASTER_NODE_IP> \
  --admin-username <ADMIN_USER> \
  --admin-password <ADMIN_PASSWORD> \
  --ha \
  --interactive
```

**第 2 步：添加其他主节点**  
在初始化节点完成后，通过 UCP Web UI 生成加入命令，在其他主节点执行：
```bash
docker run --rm -it \
  --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:latest \
  join \
  --token <JOIN_TOKEN> \
  --host-address <NEW_MASTER_IP> \
  <INITIAL_MASTER_IP>
```

### 3. 环境变量与配置参数

| 参数/环境变量               | 描述                                      | 默认值          | 必要性       |
|---------------------------|-----------------------------------------|---------------|------------|
| `--host-address`          | UCP 节点的公共 IP 地址                      | 自动检测本机 IP    | 必选（多网卡环境）|
| `--admin-username`        | UCP 管理员用户名                           | `admin`       | 可选（首次部署）|
| `--admin-password`        | UCP 管理员密码（至少 8 字符）                 | 无            | 必选（首次部署）|
| `--license`               | Docker EE 许可证密钥                       | 无            | 生产环境必选   |
| `--ha`                    | 启用高可用模式                             | `false`       | 生产环境建议   |
| `--public-port`           | UCP Web UI/API 的 HTTPS 端口                | `443`         | 可选        |
| `--http-port`             | HTTP 端口（自动重定向至 HTTPS）              | `80`          | 可选        |
| `--swarm-port`            | Docker Swarm 管理端口                      | `2377`        | 可选        |
| `--external-cert`         | 外部 SSL 证书路径（格式：`cert.pem,key.pem,ca.pem`） | 自动生成自签名证书 | 生产环境建议   |
| `--log-level`             | 日志级别（`debug`/`info`/`warn`/`error`）   | `info`        | 调试时可选    |

### 4. 常用操作

#### 4.1 访问 UCP Web UI
部署完成后，通过浏览器访问 `https://<UCP_HOST_IP>:<public-port>`，使用管理员账号登录。

#### 4.2 升级 UCP
```bash
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:latest \
  upgrade \
  --interactive
```

#### 4.3 备份 UCP 数据
```bash
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /backup:/backup \
  docker/ucp:latest \
  backup \
  --passphrase "<BACKUP_PASSPHRASE>" \
  --output /backup/ucp-backup-$(date +%Y%m%d).tar
```

#### 4.4 恢复 UCP 数据
```bash
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /backup:/backup \
  docker/ucp:latest \
  restore \
  --passphrase "<BACKUP_PASSPHRASE>" \
  /backup/ucp-backup-<DATE>.tar
```


## 五、注意事项

1. **网络要求**  
   确保所有 UCP 节点间网络互通，开放以下端口：
   - TCP: 2376（Docker 引擎）、2377（Swarm 管理）、443（UCP HTTPS）、7946（节点发现）
   - UDP: 4789（VXLAN 网络）、7946（节点发现）

2. **数据持久化**  
   UCP 数据默认存储在 `docker/ucp` 命名空间的卷中，建议通过外部存储（如 NFS）确保数据持久化。

3. **证书管理**  
   生产环境需使用可信 CA 签发的 SSL 证书（通过 `--external-cert` 参数指定），避免使用自签名证书。

4. **资源规划**  
   单 UCP 管理节点建议配置：4 CPU 核心、16GB 内存、100GB SSD；大规模集群（>100 节点）建议 8 CPU/32GB 内存。


## 六、参考链接
- [Docker UCP 官方文档](https://docs.docker.com/ee/ucp/)
- [UCP 部署最佳实践](https://docs.docker.com/ee/ucp/admin/install/best-practices/)
- [UCP API 参考](https://docs.docker.com/ee/ucp/api/ucp-api/)

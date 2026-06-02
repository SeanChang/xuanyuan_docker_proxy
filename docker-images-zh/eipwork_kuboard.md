<!-- xuanyuan-docker-images-zh
image: eipwork/kuboard
source: https://xuanyuan.cloud/zh/r/eipwork/kuboard
canonical: https://xuanyuan.cloud/zh/r/eipwork/kuboard
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/eipwork/kuboard" title="eipwork/kuboard Docker 镜像中文简介、标签列表与拉取命令">eipwork/kuboard — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/eipwork/kuboard" title="eipwork/kuboard Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/eipwork/kuboard</a></p>

# Kuboard Docker镜像文档


## 1. 镜像概述和主要用途

Kuboard是一款轻量级、可视化的Kubernetes集群管理仪表盘，旨在简化Kubernetes资源的管理与运维流程。通过直观的Web界面，用户可实时监控集群状态、管理工作负载、配置网络资源、查看日志与事件，无需复杂的命令行操作。

**主要用途**：  
- Kubernetes集群状态监控与可视化  
- 工作负载（Deployment/StatefulSet/DaemonSet等）生命周期管理  
- 资源对象（Pod/Service/Ingress/ConfigMap等）配置与维护  
- 集群权限与访问控制管理  
- 多集群统一管理与运维  


## 2. 核心功能和特性

### 2.1 集群监控与可视化  
- 实时展示集群节点、CPU/内存/磁盘资源使用率  
- 工作负载健康状态、Pod运行状态可视化仪表盘  
- 网络流量、存储使用趋势图表分析  

### 2.2 资源管理  
- 支持Kubernetes全量资源对象管理：Deployment、StatefulSet、DaemonSet、Pod、Service、Ingress、ConfigMap、Secret等  
- 资源配置一键创建/编辑/删除，支持YAML导入导出  
- 工作负载扩缩容、滚动更新、回滚操作可视化  

### 2.3 运维与诊断  
- 集成Pod日志实时查看与搜索（支持容器级日志过滤）  
- 集群事件监控与告警（节点故障、资源不足等事件提醒）  
- 容器终端直接访问，支持命令行调试  

### 2.4 权限与多集群管理  
- 基于RBAC的细粒度权限控制，支持用户/角色/权限绑定配置  
- 多Kubernetes集群统一接入，跨集群资源切换管理  
- 团队协作：支持多用户共享集群访问权限  


## 3. 使用场景和适用范围

### 3.1 适用场景  
- **开发环境**：快速部署、调试Kubernetes应用，简化资源配置流程  
- **生产环境**：实时监控集群健康状态，高效处理故障与运维任务  
- **团队协作**：多人共享集群管理权限，按角色分配操作范围  

### 3.2 适用范围  
- 支持Kubernetes集群版本：1.16+（兼容主流K8s版本）  
- 兼容所有符合Kubernetes API规范的集群（自建集群、云厂商托管集群等）  
- 支持Linux/macOS/Windows系统（通过Docker部署，跨平台运行）  


## 4. 使用方法和配置说明

### 4.1 前置条件  
- 已部署Kubernetes集群（1.16+），且节点可访问互联网（拉取镜像）  
- 宿主机需安装Docker Engine（19.03+）  
- 宿主机需具备访问Kubernetes API的权限（通过kubeconfig文件或集群内Service访问）  


### 4.2 Docker快速部署  

#### 4.2.1 单节点部署（docker run）  
```bash
docker run -d \
  --name kuboard \
  --restart=always \
  --network=host \  # 推荐使用host网络，避免端口映射冲突
  -v /var/run/docker.sock:/var/run/docker.sock \  # 用于容器日志查看（可选）
  -v /root/.kube/config:/root/.kube/config \  # 挂载kubeconfig（集群外部署时必填）
  eipwork/kuboard:latest
```

#### 4.2.2 自定义端口与访问地址  
若需指定端口或外部访问地址，通过环境变量配置：  
```bash
docker run -d \
  --name kuboard \
  --restart=always \
  -p 8080:80 \  # 宿主机端口:容器端口（容器内默认监听80端口）
  -e KUBOARD_ENDPOINT="http://192.168.1.100:8080" \  # 外部访问地址（必填，用于生成集群接入命令）
  -v /root/.kube/config:/root/.kube/config \
  eipwork/kuboard:latest
```


### 4.3 Docker Compose部署  
创建`docker-compose.yml`文件：  
```yaml
version: '3.8'
services:
  kuboard:
    image: eipwork/kuboard:latest
    container_name: kuboard
    restart: always
    ports:
      - "8080:80"  # 自定义宿主机端口
    environment:
      - KUBOARD_ENDPOINT="http://192.168.1.100:8080"  # 外部访问地址
      - KUBOARD_PORT=80  # 容器内监听端口（默认80）
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock  # 可选，用于容器日志
      - /root/.kube/config:/root/.kube/config  # 挂载kubeconfig（集群外部署必填）
      - kuboard-data:/data  # 持久化存储Kuboard配置数据
volumes:
  kuboard-data:  # 自动创建命名卷，存储配置与缓存
```

启动命令：  
```bash
docker-compose up -d
```


### 4.4 访问与登录  

1. **访问地址**：部署完成后，通过浏览器访问 `http://<宿主机IP>:<映射端口>`（如`http://192.168.1.100:8080`）。  

2. **登录认证**：  
   - **集群内部署**：默认使用ServiceAccount认证，直接登录；  
   - **集群外部署**：需通过kubeconfig文件或Token认证。首次登录可使用集群`admin`用户Token（通过以下命令获取）：  
     ```bash
     kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin | awk '{print $1}') | grep 'token:' | awk '{print $2}'
     ```  


## 5. 配置参数说明

### 5.1 核心环境变量  

| 环境变量名               | 说明                          | 默认值          | 示例值                     |
|--------------------------|-------------------------------|-----------------|---------------------------|
| `KUBOARD_ENDPOINT`       | 外部访问地址（必填）          | 无              | `http://192.168.1.100:8080` |
| `KUBOARD_PORT`           | 容器内监听端口                | `80`            | `8080`                    |
| `KUBERNETES_SERVICE_HOST`| Kubernetes API Server地址    | 自动检测        | `10.96.0.1`               |
| `KUBERNETES_SERVICE_PORT`| Kubernetes API Server端口    | `443`（HTTPS）  | `6443`                    |
| `LOG_LEVEL`              | 日志级别（debug/info/warn/error） | `info`       | `debug`                   |


### 5.2 数据持久化  
Kuboard配置、用户数据等需持久化存储，推荐通过Docker卷（Volume）挂载`/data`目录（如4.3节`docker-compose.yml`示例），避免容器重建后数据丢失。


## 6. 版本兼容性与更新  

- **镜像标签**：`eipwork/kuboard:latest`（最新稳定版）、`eipwork/kuboard:v3`（v3系列稳定版）  
- **更新方法**：拉取最新镜像并重建容器：  
  ```bash
  docker pull eipwork/kuboard:latest && docker restart kuboard
  ```  
- **兼容性**：支持Kubernetes 1.16+，若集群版本低于1.16，需使用Kuboard v2版本镜像（`eipwork/kuboard:v2`）。


## 7. 官方资源  

- **官方网站**：[https://kuboard.cn](https://kuboard.cn)  
- **安装文档**：[https://kuboard.cn/install/install-dashboard.html](https://kuboard.cn/install/install-dashboard.html)  
- **GitHub仓库**：[https://github.com/eipwork/kuboard-press](https://github.com/eipwork/kuboard-press)

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/eipwork/kuboard" title="eipwork/kuboard Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/eipwork/kuboard</a></p>

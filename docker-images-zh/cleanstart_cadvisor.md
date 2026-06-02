<!-- xuanyuan-docker-images-zh
image: cleanstart/cadvisor
source: https://xuanyuan.cloud/zh/r/cleanstart/cadvisor
canonical: https://xuanyuan.cloud/zh/r/cleanstart/cadvisor
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [cleanstart/cadvisor — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/cleanstart/cadvisor "cleanstart/cadvisor Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/cleanstart/cadvisor

# CleanStart cAdvisor 容器镜像

cAdvisor（容器顾问）为容器用户提供运行中容器的资源使用情况和性能特性。它作为运行中的守护进程，收集、聚合、处理和导出有关运行中容器的信息。具体而言，对于每个容器，它会保留资源隔离参数、历史资源使用情况、完整历史资源使用情况的直方图以及网络统计信息。此容器包含企业级安全加固和针对生产部署优化的监控能力。

📌 **CleanStart 基础**：为企业容器化环境设计的安全加固、最小化基础操作系统。

## 核心功能

* 实时容器资源监控和指标收集
* 原生Prometheus指标端点集成
* 历史性能数据分析与存储
* 支持RBAC的企业级安全性

## 使用场景

* 生产环境中的容器资源使用监控
* 容器化应用的性能分析和容量规划
* Kubernetes集群的资源利用率跟踪
* 可观测性平台的容器指标收集

## 快速开始

### 拉取最新镜像

从镜像仓库下载容器镜像

```bash
docker pull cleanstart/cadvisor:latest
docker pull cleanstart/cadvisor:latest-dev
```

### 基本运行

使用基本配置运行容器

```bash
docker run -d --name cadvisor -v /:/rootfs:ro -v /var/run:/var/run:ro -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro -v /dev/disk/:/dev/disk:ro -p 8080:8080 cleanstart/cadvisor:latest
```

### 生产部署

使用生产环境安全设置部署

```bash
docker run -d --name cadvisor-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  -v /:/rootfs:ro \
  -v /var/run:/var/run:ro \
  -v /sys:/sys:ro \
  -v /var/lib/docker/:/var/lib/docker:ro \
  -v /dev/disk/:/dev/disk:ro \
  -p 8080:8080 \
  cleanstart/cadvisor:latest
```

### 卷挂载

挂载监控所需的系统目录

```bash
docker run -d -v /:/rootfs:ro -v /var/run:/var/run:ro -v /sys:/sys:ro cleanstart/cadvisor:latest
```

### 端口转发

暴露指标端点运行

```bash
docker run -d -p 8080:8080 cleanstart/cadvisor:latest
```

## 配置

### 环境变量

| 变量名                  | 默认值                                      | 描述                 |
|-------------------------|---------------------------------------------|----------------------|
| PATH                    | /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin | 系统PATH配置         |
| CADVISOR_PORT           | 8080                                        | cAdvisor指标端点端口 |
| CADVISOR_STORAGE_DURATION | 2m0s                                        | 数据在内存中的保留时间 |

## 安全与最佳实践

### 推荐的安全上下文

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 1000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop: ['ALL']
```

### 最佳实践

* 生产环境使用特定镜像标签（避免使用latest）
* 配置资源限制：内存和CPU约束
* 尽可能启用只读根文件系统
* 使用非root用户运行容器（--user 1000:1000）
* 使用--security-opt=no-new-privileges标志
* 定期更新容器镜像以获取安全补丁
* 实施适当的网络分段
* 监控容器指标以检测异常

## 架构支持

### 多平台镜像

```bash
docker pull --platform linux/amd64 cleanstart/cadvisor:latest
docker pull --platform linux/arm64 cleanstart/cadvisor:latest
```

## 资源与文档

- **CleanStart 官网**: [https://www.cleanstart.com](https://www.cleanstart.com)  
- **cAdvisor GitHub 仓库**: [https://github.com/google/cadvisor](https://github.com/google/cadvisor)  
- **cAdvisor 文档**: [https://github.com/google/cadvisor/tree/master/docs](https://github.com/google/cadvisor/tree/master/docs)  
- **CleanStart 社区镜像**: [https://hub.docker.com/u/cleanstart](https://hub.docker.com/u/cleanstart)  
- **如何运行CleanStart镜像及示例项目**: [https://github.com/cleanstart-dev/cleanstart-containers](https://github.com/cleanstart-dev/cleanstart-containers)，
    * 使用Dockerfile运行示例项目的方法  
    * 通过Kubernetes YAML部署的方法  
    * 从公共镜像迁移到CleanStart镜像的方法  

---

## 漏洞免责声明

CleanStart提供的Docker镜像包含由独立贡献者维护的第三方开源库和软件包。尽管CleanStart维护这些镜像并应用行业标准的安全实践，但无法保证超出其控制范围的上游组件的安全性或完整性。

用户承认并同意，开源软件可能包含未发现的漏洞，或通过更新引入新风险。对于源自第三方库的安全问题，包括但不限于零日漏洞、供应链攻击或贡献者引入的风险，CleanStart不承担责任。

安全是共同责任：CleanStart会在可能的情况下提供更新的镜像和指导，而用户负责评估部署并实施适当的控制措施。

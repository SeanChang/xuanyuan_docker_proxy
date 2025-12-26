---
id: 99
title: Docker in Docker 容器化部署指南
slug: docker-in-docker
summary: DOCKER（Docker in Docker，简称DinD）是一种特殊的容器化方案，允许在Docker容器内部运行Docker引擎。尽管通常不推荐在生产环境中使用嵌套容器，但DinD在特定场景下具有重要价值，如Docker引擎本身的开发、CI/CD流水线中的容器化构建环境等。
category: Docker
tags: docker,部署教程
image_name: library/docker
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-docker.png"
status: published
created_at: "2025-12-03 06:59:33"
updated_at: "2025-12-03 06:59:33"
---

# Docker in Docker 容器化部署指南

> DOCKER（Docker in Docker，简称DinD）是一种特殊的容器化方案，允许在Docker容器内部运行Docker引擎。尽管通常不推荐在生产环境中使用嵌套容器，但DinD在特定场景下具有重要价值，如Docker引擎本身的开发、CI/CD流水线中的容器化构建环境等。

## 概述

DOCKER（Docker in Docker，简称DinD）是一种特殊的容器化方案，允许在Docker容器内部运行Docker引擎。尽管通常不推荐在生产环境中使用嵌套容器，但DinD在特定场景下具有重要价值，如Docker引擎本身的开发、CI/CD流水线中的容器化构建环境等。

本文档详细介绍DOCKER的Docker容器化部署流程，包括环境准备、镜像拉取、容器部署、功能测试及生产环境优化建议，旨在为开发和运维人员提供专业、可复现的部署方案。

## 环境准备

### Docker环境安装

部署DOCKER前需确保主机已安装Docker引擎。推荐使用轩辕提供的一键安装脚本，可自动完成Docker安装及环境配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本将自动完成以下操作：
- 安装最新稳定版Docker Engine
- 配置Docker服务自启动
- 配置轩辕镜像访问支持

## 镜像准备

### 镜像信息

- **镜像名称**：library/docker（Docker官方DinD镜像）
- **推荐标签**：latest（稳定版）
- **标签列表**：[DOCKER镜像标签列表](https://xuanyuan.cloud/r/library/docker/tags)
- **镜像文档**：[DOCKER镜像文档（轩辕）](https://xuanyuan.cloud/r/library/docker)

### 拉取命令

```bash
docker pull xxx.xuanyuan.run/library/docker:latest
```

> 说明：如需使用其他版本，将`latest`替换为标签列表中的具体版本号（如`29.1.1-dind`、`29.1.1-cli`等）

### 镜像验证

拉取完成后，可通过以下命令验证镜像信息：

```bash
# 查看本地镜像
docker images xxx.xuanyuan.run/library/docker:latest

# 查看镜像详细信息
docker inspect xxx.xuanyuan.run/library/docker:latest
```

## 容器部署

DOCKER容器部署需特殊配置，因涉及嵌套容器运行，需启用特权模式并正确配置网络与存储。

### 基础部署步骤

#### 1. 创建专用网络（可选）

为DinD服务创建独立网络，便于多容器通信：

```bash
docker network create docker-network
```

#### 2. 启动DOCKER服务容器

```bash
docker run -d \
  --name docker-dind \
  --privileged \
  --network docker-network \
  --network-alias docker \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v docker-certs-ca:/certs/ca \
  -v docker-certs-client:/certs/client \
  -v docker-data:/var/lib/docker \
  xxx.xuanyuan.run/library/docker:latest
```

**参数说明**：
- `--privileged`：必须选项，授予容器访问主机设备的权限， DinD运行必需
- `--name docker-dind`：容器名称
- `--network docker-network`：连接到专用网络
- `--network-alias docker`：网络内别名，便于其他容器访问
- `-e DOCKER_TLS_CERTDIR=/certs`：启用TLS并指定证书目录
- `-v docker-certs-ca:/certs/ca`：持久化CA证书（命名卷）
- `-v docker-certs-client:/certs/client`：持久化客户端证书（命名卷）
- `-v docker-data:/var/lib/docker`：持久化Docker数据（镜像、容器等）

#### 3. 验证容器状态

```bash
# 查看容器运行状态
docker ps --filter "name=docker-dind"

# 查看容器日志
docker logs docker-dind
```

日志中出现以下信息表示启动成功：
```
time="..." level=info msg="Daemon has completed initialization"
time="..." level=info msg="API listen on [::]:2376"
```

### 高级配置选项

#### 自定义Docker daemon参数

如需调整Docker daemon配置，可在启动命令后添加参数：

```bash
docker run -d \
  --name docker-dind \
  --privileged \
  ...（其他参数）...
  xxx.xuanyuan.run/library/docker:latest \
  --storage-driver overlay2 \
  --log-level info \
  --max-concurrent-downloads 5
```

#### 资源限制配置

为避免DinD容器过度占用主机资源，可添加资源限制参数：

```bash
docker run -d \
  --name docker-dind \
  --privileged \
  --memory=4G \
  --memory-swap=4G \
  --cpus=2 \
  --pids-limit=500 \
  ...（其他参数）...
  xxx.xuanyuan.run/library/docker:latest
```

## 功能测试

部署完成后，需验证DOCKER服务是否正常工作，包括容器内Docker引擎的可用性、镜像拉取、容器运行等功能。

### 测试1：连接到DOCKER服务并验证版本

```bash
# 启动客户端容器连接到DinD服务
docker run --rm \
  --network docker-network \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v docker-certs-client:/certs/client:ro \
  xxx.xuanyuan.run/library/docker:latest \
  version
```

预期输出应包含客户端和服务端版本信息，类似：
```
Client: Docker Engine - Community
 Version:           29.1.1
 API version:       1.44
...
Server: Docker Engine - Community
 Engine:
  Version:          29.1.1
  API version:      1.44 (minimum version 1.24)
...
```

### 测试2：在DOCKER服务中运行容器

```bash
# 在客户端容器中执行命令，在DinD服务中运行nginx容器
docker run --rm \
  --network docker-network \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v docker-certs-client:/certs/client:ro \
  xxx.xuanyuan.run/library/docker:latest \
  run --rm --name test-nginx nginx:alpine echo "Hello from nested container"
```

预期输出：`Hello from nested container`

### 测试3：查看DOCKER服务信息

```bash
docker run --rm \
  --network docker-network \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v docker-certs-client:/certs/client:ro \
  xxx.xuanyuan.run/library/docker:latest \
  info
```

可查看DinD服务的详细信息，包括存储驱动、容器数量、镜像数量、内核版本等。

## 生产环境建议

尽管DinD主要用于开发和测试场景，如需在生产环境使用，需注意以下关键配置：

### 1. 安全性增强

- **最小权限原则**：避免直接使用`--privileged`，如可能，使用`--cap-add`添加必要 capabilities（如`CAP_SYS_ADMIN`、`CAP_NET_ADMIN`等），但DinD通常仍需`--privileged`
- **网络隔离**：将DinD容器部署在独立网络，限制与其他服务的通信
- **证书管理**：定期轮换TLS证书，避免使用默认证书
- **用户隔离**：如使用rootless变体（`dind-rootless`标签），可减少权限风险

### 2. 数据持久化

- **使用绑定挂载而非命名卷**：生产环境建议将`/var/lib/docker`挂载到主机目录，便于备份和管理：
  ```bash
  -v /data/docker/dind:/var/lib/docker
  ```
- **定期备份**：对持久化目录进行定期备份，防止数据丢失

### 3. 性能优化

- **存储驱动选择**：优先使用`overlay2`（主流推荐），避免`devicemapper`等低效驱动
- **资源限制**：严格设置CPU、内存、PID限制，防止影响主机
- **日志管理**：配置日志轮转，避免日志占满磁盘：
  ```bash
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3
  ```

### 4. 版本管理

- **避免使用`:latest`标签**：生产环境应指定具体版本（如`29.1.1-dind`），确保部署一致性
- **定期更新**：关注[镜像标签列表](https://xuanyuan.cloud/r/library/docker/tags)，及时更新安全补丁

### 5. 监控与告警

- **容器监控**：集成Prometheus+Grafana监控容器CPU、内存、网络、磁盘使用
- **日志收集**：将容器日志发送到ELK或其他日志系统
- **健康检查**：添加健康检查命令：
  ```bash
  --health-cmd "docker info > /dev/null 2>&1" \
  --health-interval 30s \
  --health-timeout 10s \
  --health-retries 3
  ```

## 故障排查

### 常见问题及解决方案

#### 1. 容器启动失败，提示权限不足

**症状**：`docker run`命令失败，日志中出现`permission denied`

**原因**：未使用`--privileged`参数或主机安全策略限制

**解决**：
- 确保添加`--privileged`参数
- 如使用rootless Docker，需额外配置（参考[rootless文档](https://docs.docker.com/engine/security/rootless/)）

#### 2. 客户端无法连接到DinD服务

**症状**：执行客户端命令时提示`Cannot connect to the Docker daemon`

**原因**：TLS配置错误或网络不通

**解决**：
- 检查`DOCKER_TLS_CERTDIR`环境变量是否正确设置
- 验证证书卷是否正确挂载（`/certs/client`目录应有证书文件）
- 检查网络连接：`docker exec -it docker-dind ping docker`（从客户端容器）

#### 3. DinD服务中无法拉取镜像

**症状**：在DinD中执行`docker pull`失败，提示网络超时

**原因**：DinD容器内网络配置问题或DNS解析失败

**解决**：
- 添加DNS服务器：`--dns 8.8.8.8 --dns 114.114.114.114`
- 检查主机防火墙是否阻止容器出站连接
- 如使用代理，在DinD容器中配置代理环境变量：
  ```bash
  -e HTTP_PROXY=http://proxy.example.com:8080 \
  -e HTTPS_PROXY=https://proxy.example.com:8080
  ```

#### 4. 磁盘空间快速增长

**症状**：`/var/lib/docker`目录占用大量磁盘空间

**原因**：未清理无用镜像和容器，或日志未轮转

**解决**：
- 定期清理：在DinD容器中执行`docker system prune -af`
- 配置日志轮转（见生产环境建议）
- 限制镜像缓存大小：启动时添加`--storage-opt overlay2.size=100G`（需内核支持）

#### 5. 容器频繁OOM被终止

**症状**：容器意外停止，主机日志中出现`out of memory`

**原因**：内存资源限制不足或内存泄漏

**解决**：
- 增加内存限制：`--memory=8G`
- 分析内存使用：使用`docker stats docker-dind`监控
- 检查是否有异常容器占用过多内存

## 参考资源

1. **轩辕镜像资源**
   - [DOCKER镜像文档（轩辕）](https://xuanyuan.cloud/r/library/docker)
   - [DOCKER镜像标签列表](https://xuanyuan.cloud/r/library/docker/tags)

2. **官方资源**
   - [Docker in Docker GitHub仓库](https://github.com/docker-library/docker)
   - [Docker官方文档 - DinD](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#dockerfile-instructions)
   - [Docker Hub - library/docker](https://hub.docker.com/_/docker)

3. **技术文档**
   - [Jérôme Petazzoni's DinD博客](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)
   - [Docker Rootless模式文档](https://docs.docker.com/engine/security/rootless/)
   - [Docker存储驱动选择指南](https://docs.docker.com/storage/storagedriver/select-storage-driver/)

## 总结

本文详细介绍了DOCKER（Docker in Docker）的Docker容器化部署方案，从环境准备、镜像拉取、容器部署到功能测试，提供了完整可复现的实施步骤，并针对生产环境给出了安全性、性能和可靠性方面的优化建议。

**关键要点**：
- 使用轩辕一键脚本可快速完成Docker环境部署及镜像访问支持配置
- DOCKER镜像拉取命令格式为`docker pull xxx.xuanyuan.run/library/docker:latest`
- DinD运行必须使用`--privileged`参数，并建议启用TLS加密通信
- 生产环境需重点关注安全性（网络隔离、权限控制）、数据持久化和资源限制

**后续建议**：
- 深入学习DOCKER高级特性，如rootless模式、自定义daemon配置等
- 根据业务需求调整容器资源参数，建立监控告警机制
- 关注官方仓库更新，及时修复安全漏洞，定期更新镜像版本
- 评估是否真的需要DinD，多数CI/CD场景可通过挂载主机Docker套接字（`-v /var/run/docker.sock:/var/run/docker.sock`）替代，避免嵌套容器复杂性

通过合理配置和管理，DOCKER可成为容器化开发、测试和特定生产场景的有效工具，为Docker引擎本身的开发和调试提供便利的隔离环境。


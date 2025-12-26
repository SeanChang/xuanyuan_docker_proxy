# GPUSTACK Docker 容器化部署指南

![GPUSTACK Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-gpustack.png)

*分类: Docker,GPUSTACK | 标签: gpustack,docker,部署教程 | 发布时间: 2025-11-19 08:48:46*

> GPUSTACK 是一款专注于 GPU 集群管理的中间件，旨在简化大语言模型（LLMs）及其他 GPU 密集型应用的部署与运行流程。通过统一的集群管理接口，GPUSTACK 能够高效调度 GPU 资源、优化任务分配，并提供监控与运维支持，适用于 AI 实验室、企业级 AI 平台等场景。

## 概述

GPUSTACK 是一款专注于 GPU 集群管理的中间件，旨在简化大语言模型（LLMs）及其他 GPU 密集型应用的部署与运行流程。通过统一的集群管理接口，GPUSTACK 能够高效调度 GPU 资源、优化任务分配，并提供监控与运维支持，适用于 AI 实验室、企业级 AI 平台等场景。

容器化部署作为现代应用交付的标准方式，为 GPUSTACK 提供了环境一致性、隔离性与快速迁移能力。本文将详细介绍如何通过 Docker 容器化方案部署 GPUSTACK，包括环境准备、镜像拉取、容器配置、功能验证及生产环境优化等关键步骤，帮助用户快速实现从开发测试到生产环境的全流程落地。


## 环境准备

### Docker 环境安装

部署 GPUSTACK 容器前，需确保目标服务器已安装 Docker 环境。推荐使用轩辕云提供的一键安装脚本，该脚本会自动完成 Docker 引擎、容器运行时及相关依赖的配置，并默认启用国内访问支持能力。

**执行以下命令安装 Docker**：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 说明：脚本将自动适配 Ubuntu、Debian、CentOS 等主流 Linux 发行版，安装过程需 root 权限（或 sudo 权限），耗时约 3-5 分钟，具体取决于网络环境。


### 环境验证

安装完成后，执行以下命令验证 Docker 环境是否正常：
```bash
# 检查 Docker 版本
docker --version
# 示例输出：Docker version 26.1.4, build 5650f9b

# 检查 Docker 服务状态
systemctl status docker
# 确保输出包含 "active (running)"

# 验证镜像访问支持配置
docker info | grep "Registry Mirrors"
# 示例输出：Registry Mirrors: https://xxx.xuanyuan.run/
```

若需使用 GPU 资源（GPUSTACK 核心依赖），还需安装 NVIDIA Container Toolkit 以支持 Docker 访问 GPU 设备：
```bash
# 添加 NVIDIA 官方仓库（以 Ubuntu 为例）
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 安装 NVIDIA Container Toolkit
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

# 重启 Docker 服务使配置生效
sudo systemctl restart docker

# 验证 GPU 支持
docker run --rm --gpus all nvidia/cuda:12.1.1-base-ubuntu22.04 nvidia-smi
# 若输出 GPU 信息，则说明 GPU 环境配置成功
```


## 镜像准备

### 镜像拉取

**推荐标签拉取（稳定版）**：
```bash
docker pull xxx.xuanyuan.run/gpustack/gpustack:latest
```

> 说明：`latest` 为官方推荐标签，指向最新稳定版本。如需指定版本，可替换为具体标签（如 `v1.2.0`），标签列表可参考 [GPUSTACK 镜像标签列表](https://xuanyuan.cloud/r/gpustack/gpustack/tags)。

**验证镜像拉取结果**：
```bash
docker images | grep gpustack/gpustack
# 示例输出：
# xxx.xuanyuan.run/gpustack/gpustack   latest    abc12345   2 weeks ago   23GB
```

### 镜像信息查看

拉取完成后，可通过以下命令查看镜像详细信息（如暴露端口、环境变量、入口命令等）：
```bash
docker inspect xxx.xuanyuan.run/gpustack/gpustack:latest
```

关键信息解析：
- `ExposedPorts`：镜像默认暴露的端口（需参考 [GPUSTACK 镜像文档（轩辕）](https://xuanyuan.cloud/r/gpustack/gpustack) 获取具体用途）。
- `Env`：默认环境变量，可通过容器启动命令覆盖。
- `Volumes`：建议挂载的数据卷路径，用于持久化配置、日志等数据。


## 容器部署

### 基础部署命令

以下为 GPUSTACK 容器的基础部署命令，包含必要的端口映射、数据持久化及 GPU 资源配置：

```bash
docker run -d \
  --name gpustack \
  --restart unless-stopped \
  --gpus all \  # 分配所有 GPU 设备（如需指定 GPU，使用 --gpus "device=0,1"）
  -p 8080:8080 \  # 管理界面端口（需与镜像暴露端口一致，参考官方文档）
  -p 9090:9090 \  # 监控指标端口（参考官方文档）
  -v /opt/gpustack/config:/app/config \  # 配置文件挂载
  -v /opt/gpustack/data:/app/data \      # 数据持久化挂载
  -v /opt/gpustack/logs:/app/logs \     # 日志文件挂载
  -e TZ=Asia/Shanghai \                 # 设置时区
  -e LOG_LEVEL=info \                   # 日志级别（debug/info/warn/error）
  xxx.xuanyuan.run/gpustack/gpustack:latest
```

#### 命令参数说明：
- `--name gpustack`：指定容器名称，便于后续管理。
- `--restart unless-stopped`：容器退出时自动重启（除非手动停止）。
- `--gpus all`：分配主机所有 GPU 资源（GPUSTACK 核心依赖，必须配置）。
- `-p 8080:8080`：端口映射（主机端口:容器端口），具体端口需参考 [GPUSTACK 镜像文档（轩辕）](https://xuanyuan.cloud/r/gpustack/gpustack)。
- `-v /opt/gpustack/...:/app/...`：数据卷挂载，确保配置、数据、日志在容器重启后不丢失。
- `-e`：设置环境变量，覆盖默认配置。

### 自定义配置文件

如需使用自定义配置（推荐生产环境），可在 `/opt/gpustack/config` 目录下创建 `config.yaml` 文件，内容参考官方文档示例，然后通过容器启动命令挂载该目录。示例配置片段：
```yaml
# /opt/gpustack/config/config.yaml
cluster:
  name: "my-gpu-cluster"
  gpus:
    - id: 0
      memory: 24GiB  # GPU 内存配置
    - id: 1
      memory: 24GiB
scheduler:
  strategy: "load-balanced"  # 资源调度策略
  max_tasks_per_gpu: 5       # 单 GPU 最大任务数
```

### 容器状态验证

部署完成后，通过以下命令验证容器运行状态：
```bash
# 查看容器状态
docker ps | grep gpustack
# 示例输出：
# abc123456789   xxx.xuanyuan.run/gpustack/gpustack:latest   "/app/entrypoint.sh"   5 minutes ago   Up 5 minutes   0.0.0.0:8080->8080/tcp, 0.0.0.0:9090->9090/tcp   gpustack

# 查看实时日志
docker logs -f gpustack
# 正常启动日志示例：
# [INFO] 2024-05-20 10:00:00: GPUSTACK starting...
# [INFO] 2024-05-20 10:00:02: Detected 2 GPUs
# [INFO] 2024-05-20 10:00:05: Cluster initialized successfully
# [INFO] 2024-05-20 10:00:05: Management UI running on :8080
```


## 功能测试

### 服务可用性验证

#### 1. 管理界面访问
通过浏览器或 curl 访问容器映射的管理界面端口（如 `http://<服务器IP>:8080`）：
```bash
curl -I http://localhost:8080
# 预期输出：HTTP/1.1 200 OK（表示服务正常响应）
```

#### 2. 集群状态检查
通过 GPUSTACK 提供的 CLI 工具或 API 检查集群状态（需先进入容器）：
```bash
# 进入容器内部
docker exec -it gpustack /bin/bash

# 执行集群状态检查命令（具体命令参考官方文档）
gpustack cluster status
# 预期输出：
# Cluster Name: my-gpu-cluster
# GPUs: 2 (Online)
# Total GPU Memory: 48GiB
# Tasks: 0 (Running)
```

#### 3. GPU 资源调度测试
提交一个测试任务，验证 GPU 资源调度功能：
```bash
# 在容器内提交测试任务（具体命令参考官方文档）
gpustack task submit --name test-task --gpu 1 --command "echo 'GPU task running'"
# 预期输出：Task 'test-task' submitted successfully (ID: task-123)

# 查看任务状态
gpustack task list
# 预期输出：task-123 | test-task | Running | GPU 0 | 10s
```


## 功能测试

### 基础功能验证清单

| 测试项                | 测试方法                                                                 | 预期结果                                  |
|-----------------------|--------------------------------------------------------------------------|-------------------------------------------|
| 容器启动状态          | `docker ps -a --filter name=gpustack`                                   | 状态为 "Up"，且无频繁重启                 |
| 日志完整性            | `docker logs gpustack | grep "initialized successfully"`                | 包含服务初始化成功日志                    |
| 管理界面可访问性      | `curl http://localhost:8080/health`                                     | 返回 JSON 格式健康状态（status: "healthy"）|
| GPU 识别             | `docker exec gpustack nvidia-smi`                                       | 显示主机 GPU 信息                         |
| 任务调度功能          | 提交测试任务并查看执行结果                                               | 任务成功运行并返回结果                    |

### 进阶功能测试（可选）

#### 1. 高并发任务调度
模拟多任务并发场景，验证 GPU 资源分配与负载均衡能力：
```bash
# 批量提交 10 个测试任务
for i in {1..10}; do
  docker exec gpustack gpustack task submit --name "test-task-$i" --gpu 1 --command "sleep 30"
done

# 查看 GPU 任务分布
docker exec gpustack gpustack cluster gpus
# 预期结果：任务均匀分布在各 GPU 上，无单 GPU 过载
```

#### 2. 故障恢复能力
手动停止一个运行中的任务，验证服务是否能正确清理资源并标记任务状态：
```bash
# 获取任务 ID
TASK_ID=$(docker exec gpustack gpustack task list | grep Running | head -n 1 | awk '{print $1}')

# 强制停止任务
docker exec gpustack gpustack task stop $TASK_ID

# 查看任务状态
docker exec gpustack gpustack task list --id $TASK_ID
# 预期结果：状态为 "Failed" 或 "Stopped"，GPU 资源已释放
```


## 生产环境建议

### 1. 资源规划与限制

#### GPU 资源分配
- **避免过度分配**：根据任务类型设置单 GPU 最大任务数（通过配置文件 `max_tasks_per_gpu`），防止 OOM 错误。
- **GPU 隔离**：通过 `--gpus "device=0"` 指定特定 GPU，避免与其他应用争夺资源。

#### 内存与 CPU 限制
```bash
docker run -d \
  ... \
  --memory=32G \  # 限制容器内存使用
  --memory-swap=32G \  # 禁止内存交换
  --cpus=4 \  # 限制 CPU 核心数
  ...
```

### 2. 数据持久化与备份

#### 关键目录备份策略
| 挂载目录           | 用途                  | 备份频率     | 备份工具       |
|--------------------|-----------------------|--------------|----------------|
| `/opt/gpustack/config` | 配置文件              | 配置变更后   | `rsync`/`tar`  |
| `/opt/gpustack/data`   | 任务数据、模型缓存    | 每日         | `borgbackup`   |
| `/opt/gpustack/logs`   | 运行日志              | 每周（日志轮转）| `logrotate`    |

#### 备份自动化示例（crontab）：
```bash
# 每日凌晨 2 点备份数据目录
0 2 * * * /usr/bin/borg create /backup/gpustack/data-{now:%Y%m%d} /opt/gpustack/data
```

### 3. 网络安全配置

#### 端口访问控制
仅开放必要端口，并通过防火墙限制来源 IP：
```bash
# 使用 ufw 限制管理界面访问（仅允许 192.168.1.0/24 网段）
sudo ufw allow from 192.168.1.0/24 to any port 8080
sudo ufw reload
```

#### HTTPS 加密（推荐）
通过 Nginx 反向代理为管理界面添加 HTTPS：
```nginx
# /etc/nginx/sites-available/gpustack.conf
server {
    listen 443 ssl;
    server_name gpustack.example.com;

    ssl_certificate /etc/ssl/certs/gpustack.crt;
    ssl_certificate_key /etc/ssl/private/gpustack.key;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 4. 监控与告警

#### 容器监控
使用 Prometheus + Grafana 监控容器资源与 GPU 利用率：
- **指标暴露**：通过 `-p 9090:9090` 映射监控端口，GPUSTACK 内置 Prometheus 指标接口。
- **Grafana 面板**：导入 GPU 监控模板（如 Grafana ID: 12884），可视化 GPU 使用率、温度、内存等指标。

#### 日志管理
将容器日志接入 ELK 或 Loki 日志系统：
```bash
docker run -d \
  ... \
  --log-driver=json-file \
  --log-opt max-size=100m \
  --log-opt max-file=3 \  # 日志轮转（最多保留 3 个文件，每个 100MB）
  ...
```

### 5. 自动化部署与更新

#### Docker Compose 编排（推荐多组件场景）
创建 `docker-compose.yml` 统一管理容器配置：
```yaml
version: '3.8'
services:
  gpustack:
    image: xxx.xuanyuan.run/gpustack/gpustack:latest
    container_name: gpustack
    restart: unless-stopped
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    ports:
      - "8080:8080"
      - "9090:9090"
    volumes:
      - /opt/gpustack/config:/app/config
      - /opt/gpustack/data:/app/data
      - /opt/gpustack/logs:/app/logs
    environment:
      - TZ=Asia/Shanghai
      - LOG_LEVEL=info
```

启动命令：`docker compose up -d`

#### 滚动更新策略
```bash
# 拉取新版本镜像
docker pull xxx.xuanyuan.run/gpustack/gpustack:latest

# 停止旧容器（保留数据卷）
docker stop gpustack && docker rm gpustack

# 启动新容器（使用相同挂载与配置）
docker run -d [与部署命令相同的参数]
```


## 故障排查

### 常见问题与解决方案

#### 1. 镜像拉取失败
**现象**：`docker pull` 命令提示 "connection refused" 或 "timeout"。  
**排查步骤**：  
- 检查网络连通性：`ping xxx.xuanyuan.run`  
- 验证加速配置：`docker info | grep "Registry Mirrors"`  
- 查看 Docker 日志：`journalctl -u docker | grep "registry"`  
**解决方案**：  
- 确保服务器可访问互联网，关闭影响网络的防火墙规则。  
- 若加速节点异常，临时使用 Docker Hub 源：`docker pull gpustack/gpustack:latest`（不推荐，访问表现较慢）。

#### 2. 容器启动后立即退出
**现象**：`docker ps -a` 显示容器状态为 "Exited (1)"。  
**排查步骤**：  
- 查看容器日志：`docker logs gpustack`  
- 检查 GPU 配置：`docker run --rm --gpus all nvidia/cuda:12.1.1-base-ubuntu22.04 nvidia-smi`（验证 GPU 是否可用）  
**解决方案**：  
- 若日志提示 "no GPU detected"，安装 NVIDIA Container Toolkit 并重启 Docker。  
- 若日志提示配置文件错误，检查 `/opt/gpustack/config/config.yaml` 语法（可使用 `yamllint` 工具验证）。

#### 3. 管理界面无法访问
**现象**：`curl http://localhost:8080` 提示 "connection refused"。  
**排查步骤**：  
- 检查端口映射：`docker port gpustack`（确认 8080 端口已映射）。  
- 查看容器内服务状态：`docker exec gpustack netstat -tulpn | grep 8080`。  
- 检查防火墙规则：`ufw status | grep 8080`。  
**解决方案**：  
- 若端口未映射，停止容器后重新运行并添加 `-p 8080:8080`。  
- 若服务未启动，查看容器日志定位启动失败原因（如依赖缺失）。

#### 4. GPU 资源无法分配
**现象**：提交任务时提示 "no available GPU resources"。  
**排查步骤**：  
- 检查 GPU 使用率：`docker exec gpustack nvidia-smi`（确认 GPU 未被占满）。  
- 查看配置文件：确认 `max_tasks_per_gpu` 未设置过小。  
**解决方案**：  
- 终止占用过多资源的任务：`gpustack task stop <task-id>`。  
- 调整配置文件中的 `max_tasks_per_gpu` 参数，重启容器生效。

#### 5. 数据卷挂载权限问题
**现象**：日志提示 "permission denied" 无法写入文件。  
**排查步骤**：  
- 检查主机挂载目录权限：`ls -ld /opt/gpustack/data`（确保权限为 755 或容器内用户可读写）。  
**解决方案**：  
- 修改主机目录权限：`chmod -R 755 /opt/gpustack`  
- 或指定容器内用户：`docker run -u $(id -u):$(id -g) [其他参数]`


### 日志与监控工具推荐

| 工具                | 用途                          | 关键命令/配置                                  |
|---------------------|-------------------------------|-----------------------------------------------|
| `docker logs`       | 容器基础日志查看              | `docker logs -f --tail 100 gpustack`          |
| `journalctl`        | Docker 服务日志               | `journalctl -u docker -f`                     |
| `nvidia-smi`        | GPU 状态监控                  | `nvidia-smi -l 1`（每秒刷新一次）             |
| `ctop`              | 容器资源监控（可视化）        | `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop` |


## 参考资源

### 官方文档与镜像信息
- [GPUSTACK 镜像文档（轩辕）](https://xuanyuan.cloud/r/gpustack/gpustack)  
- [GPUSTACK 镜像标签列表](https://xuanyuan.cloud/r/gpustack/gpustack/tags)  

### Docker 与 GPU 环境配置
- [Docker 官方安装指南](https://docs.docker.com/engine/install/)  
- [NVIDIA Container Toolkit 文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)  

### 容器化部署最佳实践
- [Docker 容器安全最佳实践](https://docs.docker.com/develop/develop-images/security-best-practices/)  
- [Docker Compose 官方文档](https://docs.docker.com/compose/)  


## 总结

本文详细介绍了 GPUSTACK 的 Docker 容器化部署方案，从环境准备、镜像拉取到容器配置、功能验证，覆盖了开发测试到生产环境的全流程。通过容器化部署，用户可快速搭建 GPUSTACK 服务，实现 GPU 集群的高效管理与 LLM 任务调度。

**关键要点**：  
- 使用轩辕一键脚本可快速完成 Docker 环境与镜像访问支持配置，解决国内网络访问 Docker Hub 慢的问题。  
- GPUSTACK 镜像（`gpustack/gpustack`）为多段名称，需使用 `docker pull xxx.xuanyuan.run/gpustack/gpustack:latest` 拉取。  
- 容器部署需确保 GPU 资源正确分配（`--gpus` 参数）、数据卷持久化（配置、数据、日志目录挂载）及必要的端口映射。  
- 生产环境需重点关注资源限制、数据备份、网络安全与监控告警，推荐使用 Docker Compose 实现配置编排。

**后续建议**：  
- 深入学习 [GPUSTACK 镜像文档（轩辕）](https://xuanyuan.cloud/r/gpustack/gpustack) 中的高级配置选项，如自定义调度策略、多集群管理等。  
- 根据业务需求调整 GPU 资源分配方案，结合监控工具优化任务调度效率。  
- 定期关注镜像标签列表，及时更新至稳定版本，确保安全性与功能完整性。  

通过本文的部署方案，用户可在短时间内完成 GPUSTACK 的容器化落地，并为后续的 AI 应用开发与 GPU 资源管理提供可靠基础。


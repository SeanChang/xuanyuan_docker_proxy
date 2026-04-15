# GPUSTACK Docker 容器化部署指南（生产级规范与最佳实践）

![GPUSTACK Docker 容器化部署指南（生产级规范与最佳实践）](https://img.xuanyuan.dev/docker/blog/docker-gpustack.png)

*分类: Docker,GPUSTACK | 标签: gpustack,docker,部署教程 | 发布时间: 2025-11-19 08:48:46*

> GPUSTACK 是一款专注于 GPU 集群管理的中间件，旨在简化大语言模型（LLMs）及其他 GPU 密集型应用的部署与运行流程。通过统一的集群管理接口，GPUSTACK 能够高效调度 GPU 资源、优化任务分配，并提供监控与运维支持，适用于 AI 实验室、企业级 AI 平台等场景。

GPUSTACK 是一款专注于 GPU 集群管理的中间件，旨在简化大语言模型（LLMs）及其他 GPU 密集型应用的部署与运行流程。通过统一的集群管理接口，GPUSTACK 能够高效调度 GPU 资源、优化任务分配，并提供监控与运维支持，适用于 AI 实验室、企业级 AI 平台等场景。

本文为**企业级可直接落地版本**，在 v1.0 基础上修复生产级语法硬伤、补充环境兼容声明与适用边界，确保工程师按文档操作可零踩坑完成部署。

## 部署模式说明
为明确不同场景的部署策略，先区分测试与生产环境的核心差异：

| 配置项                | 测试/体验环境                | 生产环境                          |
|-----------------------|-----------------------------|-----------------------------------|
| 镜像标签              | `latest`（快速尝新）| 固定版本号（如 `v1.2.0`，可复现） |
| 容器运行用户          | root（简化配置）| 非 root 普通用户（降低权限风险）|
| GPU 分配              | `--gpus all`（全量使用）| 指定设备（如 `--gpus "device=0,1"`）|
| 端口暴露方式          | 直接映射到公网（快速访问）| 仅本地监听 + Nginx 反向代理（HTTPS）|
| 数据备份              | 可选（手动备份）| 强制（自动化定时备份）|
| 监控告警              | 可选（基础日志查看）| 必须（Prometheus + Grafana）|
| 容器安全配置          | 基础配置                    | 只读文件系统 + 权限最小化        |

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

若需使用 GPU 资源（GPUSTACK 核心依赖），需安装 NVIDIA Container Toolkit 以支持 Docker 访问 GPU 设备。不同发行版的安装方式如下：

#### NVIDIA Container Toolkit 安装（分发行版适配）
| 发行版类型       | 安装方式                                                                 |
|------------------|--------------------------------------------------------------------------|
| Ubuntu/Debian    | 使用 apt 仓库（如下示例）|
| RHEL/CentOS/Rocky | 使用 yum 仓库（参考官方文档）|

**Ubuntu/Debian 安装步骤**：
```bash
# 添加 NVIDIA 官方仓库
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 安装 NVIDIA Container Toolkit
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

# 重启 Docker 服务使配置生效
sudo systemctl restart docker
```

**RHEL/CentOS/Rocky 安装步骤**：
> 完整步骤参考 NVIDIA 官方文档：https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#rhel-7-8-9

```bash
# 添加 NVIDIA 官方仓库
sudo dnf config-manager --add-repo https://nvidia.github.io/libnvidia-container/rhel8/libnvidia-container.repo
# 安装工具包
sudo dnf install -y nvidia-container-toolkit
# 重启 Docker
sudo systemctl restart docker
```

**GPU 环境验证（通用）**：
```bash
docker run --rm --gpus all nvidia/cuda:12.1.1-base-ubuntu22.04 nvidia-smi
# 若输出 GPU 信息，则说明 GPU 环境配置成功
# 补充说明：若镜像未内置 nvidia-smi，可通过宿主机执行验证，或使用 nvidia/cuda 官方镜像进行独立测试
```

## 镜像准备

### 镜像拉取
⚠️ **版本标签重要说明**：
- 测试/体验环境：可使用 `latest` 标签（快速获取最新功能，但不保证稳定性）；
- 生产环境：**禁止使用 `latest`**，必须指定固定版本号（如 `v1.2.0`），确保部署可复现、可回滚。

**拉取命令示例**：
```bash
# 测试环境
docker pull xxx.xuanyuan.run/gpustack/gpustack:latest

# 生产环境（推荐）
docker pull xxx.xuanyuan.run/gpustack/gpustack:v1.2.0
```

> 说明：版本标签列表可参考 [GPUSTACK 镜像标签列表](https://xuanyuan.cloud/r/gpustack/gpustack/tags)，优先选择标注“稳定版”的版本号。

**验证镜像拉取结果**：
```bash
docker images | grep gpustack/gpustack
# 示例输出（生产环境）：
# xxx.xuanyuan.run/gpustack/gpustack   v1.2.0    abc12345   2 weeks ago   23GB
```

### 镜像信息查看
拉取完成后，可通过以下命令查看镜像详细信息（如暴露端口、环境变量、入口命令等）：
```bash
docker inspect xxx.xuanyuan.run/gpustack/gpustack:v1.2.0  # 生产环境使用固定版本
```

关键信息解析：
- `ExposedPorts`：镜像默认暴露的端口（需参考 [GPUSTACK 镜像文档（轩辕）](https://xuanyuan.cloud/r/gpustack/gpustack) 获取具体用途）；
- `Env`：默认环境变量，可通过容器启动命令覆盖；
- `Volumes`：建议挂载的数据卷路径，用于持久化配置、日志等数据。

## 容器部署

### 基础部署命令
#### 1. 测试环境部署（简化版）
```bash
# 测试环境部署（快速验证功能）
# - 全量 GPU 分配
# - root 用户运行（简化权限配置）
docker run -d \
  --name gpustack \
  --restart unless-stopped \
  --gpus all \
  -p 8080:8080 \
  -p 9090:9090 \
  -v /opt/gpustack/config:/app/config \
  -v /opt/gpustack/data:/app/data \
  -v /opt/gpustack/logs:/app/logs \
  -e TZ=Asia/Shanghai \
  -e LOG_LEVEL=info \
  xxx.xuanyuan.run/gpustack/gpustack:latest
```

#### 2. 生产环境部署（安全强化版）
```bash
# 生产环境部署（安全强化版）
# - 使用指定 GPU 设备（避免全量占用）
# - 非 root 用户运行（降低权限风险）
# - 只读文件系统 + 权限最小化（符合 CIS 安全基线）
# - 仅本地端口监听（配合反向代理提供外网访问）
docker run -d \
  --name gpustack \
  --restart unless-stopped \
  --gpus "device=0,1" \
  --user 1000:1000 \
  --read-only \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  -p 127.0.0.1:8080:8080 \
  -p 127.0.0.1:9090:9090 \
  -v /opt/gpustack/config:/app/config:rw \
  -v /opt/gpustack/data:/app/data:rw \
  -v /opt/gpustack/logs:/app/logs:rw \
  -v /tmp:/tmp:rw \
  -e TZ=Asia/Shanghai \
  -e LOG_LEVEL=info \
  xxx.xuanyuan.run/gpustack/gpustack:v1.2.0
```

⚠️ **注意**：
在极少数环境（老内核 / 非官方 NVIDIA 驱动）下，`--cap-drop ALL` 可能导致 GPU 识别正常但任务调度异常。若出现此类问题，可临时移除该参数进行验证，再逐步收紧权限（如仅保留必要权限 `--cap-drop ALL --cap-add SYS_ADMIN`）。

#### 命令参数说明（补充安全相关）：
- `--user 1000:1000`：使用普通用户运行容器，避免 root 权限泄露（需确保宿主机 `/opt/gpustack` 目录归该用户所有：`chown -R 1000:1000 /opt/gpustack`）；
- `--read-only`：容器文件系统设为只读，仅挂载的卷可写，降低镜像漏洞导致的宿主机风险；
- `--cap-drop ALL`：移除所有 Linux 特权（如进程管理、网络配置等），遵循权限最小化原则；
- `--security-opt no-new-privileges:true`：禁止容器内进程提升权限，符合 CIS Docker 安全基线；
- `-p 127.0.0.1:8080:8080`：仅监听本地回环地址，避免直接暴露公网，需通过 Nginx 反向代理提供外网访问。

### 自定义配置文件
如需使用自定义配置（推荐生产环境），可在 `/opt/gpustack/config` 目录下创建 `config.yaml` 文件，内容参考官方文档示例，然后通过容器启动命令挂载该目录。

#### 配置文件补充说明：
1. **配置校验**：修改配置后，推荐使用宽松规则校验语法（避免无关风格警告），需提前安装 `yamllint`（`apt install yamllint` 或 `dnf install yamllint`）：
   ```bash
   yamllint -d relaxed /opt/gpustack/config/config.yaml
   ```
2. **热加载**：GPUSTACK 支持配置热加载（无需重启容器），执行 `docker exec gpustack gpustack config reload` 即可生效；若配置错误，热加载会返回具体错误信息，不会导致服务中断。

示例配置片段：
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
# abc123456789   xxx.xuanyuan.run/gpustack/gpustack:v1.2.0   "/app/entrypoint.sh"   5 minutes ago   Up 5 minutes   127.0.0.1:8080->8080/tcp, 127.0.0.1:9090->9090/tcp   gpustack

# 查看实时日志
docker logs -f gpustack
# 正常启动日志示例：
# [INFO] 2024-05-20 10:00:00: GPUSTACK starting...
# [INFO] 2024-05-20 10:00:02: Detected 2 GPUs
# [INFO] 2024-05-20 10:00:05: Cluster initialized successfully
# [INFO] 2024-05-20 10:00:05: Management UI running on :8080
```

### Docker Compose 编排（明确版本要求）
⚠️ 注意：
1. `device_requests` 配置项需要 **Docker Engine ≥ 19.03** 且 **Docker Compose ≥ 1.28**；
2. `deploy.resources` 仅在 Docker Swarm 或 Kubernetes 环境生效，普通 Docker Compose 需使用 `device_requests` 配置 GPU 资源。

#### 普通 Docker Compose 配置（非 Swarm，生产环境）
```yaml
version: '3.8'
services:
  gpustack:
    image: xxx.xuanyuan.run/gpustack/gpustack:v1.2.0  # 固定版本
    container_name: gpustack
    restart: unless-stopped
    user: 1000:1000  # 非 root 用户
    read_only: true  # 只读文件系统
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    ports:
      - "127.0.0.1:8080:8080"
      - "127.0.0.1:9090:9090"
    volumes:
      - /opt/gpustack/config:/app/config:rw
      - /opt/gpustack/data:/app/data:rw
      - /opt/gpustack/logs:/app/logs:rw
      - /tmp:/tmp:rw
    environment:
      - TZ=Asia/Shanghai
      - LOG_LEVEL=info
    # 普通 Compose GPU 配置（替代 Swarm 的 deploy 字段）
    device_requests:
      - driver: nvidia
        count: 2  # 指定 GPU 数量
        capabilities: [gpu]
```

启动命令：`docker compose up -d`

## 功能测试

### 基础功能验证清单
| 测试项                | 测试方法                                                                 | 预期结果                                  |
|-----------------------|--------------------------------------------------------------------------|-------------------------------------------|
| 容器启动状态          | `docker ps -a --filter name=gpustack`                                   | 状态为 "Up"，且无频繁重启                 |
| 日志完整性            | `docker logs gpustack | grep "initialized successfully"`                | 包含服务初始化成功日志                    |
| 管理界面可访问性      | `curl http://127.0.0.1:8080/health`                                     | 返回 JSON 格式健康状态（status: "healthy"）|
| GPU 识别             | `docker exec gpustack nvidia-smi`（需镜像内置工具）| 显示主机 GPU 信息                         |
| 任务调度功能          | 提交测试任务并查看执行结果                                               | 任务成功运行并返回结果                    |

### 进阶功能测试（修正 GPU 编号错误）
#### 1. 高并发任务调度
模拟多任务并发场景，验证 GPU 资源分配与负载均衡能力：
```bash
# 批量提交 10 个测试任务
for i in {1..10}; do
  docker exec gpustack gpustack task submit --name "test-task-$i" --gpu 0 --command "sleep 30"  # 修正 GPU 编号，与输出一致
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

### 管理面安全风险说明
⚠️ **重要提醒**：
1. GPUSTACK 管理界面（8080 端口）默认无认证/鉴权，**禁止直接暴露到公网**；
2. 生产环境需通过 Nginx 反向代理配置 HTTPS + 基础认证（如账号密码），或启用 GPUSTACK 内置的 RBAC 权限控制；
3. 仅允许内网指定 IP 访问管理端口（通过防火墙/安全组限制）。

示例 Nginx 基础认证配置：
```bash
# 安装 htpasswd 工具
apt install apache2-utils
# 创建认证文件
htpasswd -c /etc/nginx/htpasswd/gpustack admin
# 输入密码后，在 Nginx 配置中添加
auth_basic "GPUSTACK Admin";
auth_basic_user_file /etc/nginx/htpasswd/gpustack;
```

## 生产环境建议

### 1. 资源规划与限制
#### GPU 资源分配
- **避免过度分配**：根据任务类型设置单 GPU 最大任务数（通过配置文件 `max_tasks_per_gpu`），防止 OOM 错误；
- **GPU 隔离**：通过 `--gpus "device=0"` 指定特定 GPU，避免与其他应用争夺资源。

#### 内存与 CPU 限制
```bash
# 生产环境部署补充资源限制
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
# 使用 ufw 限制反向代理服务器访问（仅允许 192.168.1.100 访问本地 8080 端口）
sudo ufw allow from 192.168.1.100 to any port 8080
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

    # 基础认证
    auth_basic "GPUSTACK Admin Access";
    auth_basic_user_file /etc/nginx/htpasswd/gpustack;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 4. 监控与告警
#### 容器监控
使用 Prometheus + Grafana 监控容器资源与 GPU 利用率：
- **指标暴露**：通过 `-p 127.0.0.1:9090:9090` 映射监控端口，GPUSTACK 内置 Prometheus 指标接口；
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
#### 滚动更新策略（生产环境）
```bash
# 1. 拉取新版本镜像（指定版本号）
docker pull xxx.xuanyuan.run/gpustack/gpustack:v1.2.1

# 2. 停止旧容器（保留数据卷）
docker stop gpustack && docker rm gpustack

# 3. 启动新容器（使用相同挂载与安全配置）
docker run -d [与生产环境部署命令相同的参数] xxx.xuanyuan.run/gpustack/gpustack:v1.2.1
```

⚠️ **注意**：单实例部署不存在真正意义的无中断滚动更新，如需零停机，需部署多实例并通过负载均衡切流。

## 故障排查

### 常见问题与解决方案
#### 1. 镜像拉取失败
**现象**：`docker pull` 命令提示 "connection refused" 或 "timeout"。  
**排查步骤**：  
- 检查网络连通性：`ping xxx.xuanyuan.run`  
- 验证加速配置：`docker info | grep "Registry Mirrors"`  
- 查看 Docker 日志：`journalctl -u docker | grep "registry"`  
**解决方案**：  
- 确保服务器可访问互联网，关闭影响网络的防火墙规则；  
- 若加速节点异常，临时使用 Docker Hub 源：`docker pull gpustack/gpustack:v1.2.0`（不推荐，访问表现较慢）。

#### 2. 容器启动后立即退出
**现象**：`docker ps -a` 显示容器状态为 "Exited (1)"。  
**排查步骤**：  
- 查看容器日志：`docker logs gpustack`  
- 检查 GPU 配置：`docker run --rm --gpus all nvidia/cuda:12.1.1-base-ubuntu22.04 nvidia-smi`（验证 GPU 是否可用）  
**解决方案**：  
- 若日志提示 "no GPU detected"，安装 NVIDIA Container Toolkit 并重启 Docker；  
- 若日志提示配置文件错误，检查 `/opt/gpustack/config/config.yaml` 语法（使用 `yamllint -d relaxed` 校验）；
- 若使用非 root 用户运行，检查 `/opt/gpustack` 目录权限是否正确（`chown -R 1000:1000 /opt/gpustack`）；
- 若 GPU 识别正常但任务调度失败，尝试移除 `--cap-drop ALL` 参数验证。

#### 3. 管理界面无法访问
**现象**：`curl http://127.0.0.1:8080` 提示 "connection refused"。  
**排查步骤**：  
- 检查端口映射：`docker port gpustack`（确认 8080 端口绑定 127.0.0.1）；  
- 查看容器内服务状态：`docker exec gpustack netstat -tulpn | grep 8080`；  
- 检查防火墙规则：`ufw status | grep 8080`。  
**解决方案**：  
- 若端口未映射，停止容器后重新运行并添加 `-p 127.0.0.1:8080:8080`；  
- 若服务未启动，查看容器日志定位启动失败原因（如依赖缺失）；
- 若配置了非 root 用户，确认用户有端口监听权限（1024 以下端口需特权，建议映射 8080 等高位端口）。

#### 4. GPU 资源无法分配
**现象**：提交任务时提示 "no available GPU resources"。  
**排查步骤**：  
- 检查 GPU 使用率：`docker exec gpustack nvidia-smi`（确认 GPU 未被占满）；  
- 查看配置文件：确认 `max_tasks_per_gpu` 未设置过小。  
**解决方案**：  
- 终止占用过多资源的任务：`gpustack task stop <task-id>`；  
- 调整配置文件中的 `max_tasks_per_gpu` 参数，执行 `docker exec gpustack gpustack config reload` 热加载生效（无需重启）。

#### 5. 数据卷挂载权限问题
**现象**：日志提示 "permission denied" 无法写入文件。  
**排查步骤**：  
- 检查主机挂载目录权限：`ls -ld /opt/gpustack/data`（确保权限为 755 或容器内用户可读写）。  
**解决方案**：  
- 修改主机目录权限：`chmod -R 755 /opt/gpustack`；  
- 或指定容器内用户：`docker run -u $(id -u):$(id -g) [其他参数]`。

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
- [NVIDIA Container Toolkit 官方文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)  

### 容器化部署最佳实践
- [Docker 容器安全最佳实践](https://docs.docker.com/develop/develop-images/security-best-practices/)  
- [CIS Docker Benchmark 安全基线](https://www.cisecurity.org/benchmark/docker/)
- [Docker Compose 官方文档](https://docs.docker.com/compose/)  

## 总结

### 适用边界声明
| **适用范围** | **不适用范围** |
|--------------|----------------|
| 单机 GPU 节点部署 | 多节点自动扩缩容集群 |
| Docker / Docker Compose 环境 | Kubernetes 容器编排环境 |
| 企业内部 AI 实验室/中小型 AI 平台 | 强多租户隔离的公有云服务 |
| 非金融级、非等保三级合规要求的场景 | 金融级、等保三级及以上的高合规场景 |

### 后续建议
1. **多实例架构扩展**：如需零停机维护，可基于本文方案部署多套 GPUSTACK 实例，通过 Nginx 或云负载均衡器实现流量切换；
2. **合规性增强**：针对等保三级等强合规场景，需补充容器镜像漏洞扫描、运行时行为监控、审计日志留存等配置；
3. **K8s 迁移指引**：若需扩展至多节点集群，可参考 NVIDIA Device Plugin 方案，将 GPUSTACK 部署为 Kubernetes DaemonSet 或 Deployment。


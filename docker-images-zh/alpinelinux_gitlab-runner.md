---
image: alpinelinux/gitlab-runner
description: "基于Alpine Linux的GitLab Runner，支持比官方版本更多的架构。"
source: https://xuanyuan.cloud/zh/r/alpinelinux/gitlab-runner
canonical: https://xuanyuan.cloud/zh/r/alpinelinux/gitlab-runner
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpinelinux/gitlab-runner" title="alpinelinux/gitlab-runner Docker 镜像中文简介、标签列表与拉取命令">alpinelinux/gitlab-runner 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Alpine Linux GitLab Runner 镜像文档


## 1. 镜像概述和主要用途

Alpine Linux GitLab Runner 是一款基于 Alpine Linux 发行版构建的轻量级 GitLab Runner 镜像，旨在作为 GitLab CI/CD 流水线的执行器，负责运行自动化构建、测试和部署任务。与官方 GitLab Runner 相比，该镜像支持更广泛的硬件架构，同时保持 Alpine Linux 特有的轻量级、低资源占用特性，适用于资源受限环境或多架构 CI/CD 场景。


## 2. 核心功能和特性

### 2.1 轻量级基础
- 基于 Alpine Linux 构建，镜像体积小（通常比官方 Ubuntu 基础镜像小 70% 以上），启动速度快，运行时资源占用低（内存、磁盘空间）。
- 采用 musl libc 和 busybox 工具集，减少冗余依赖，提升安全性。

### 2.2 多架构支持
- 支持比官方 GitLab Runner 更多的硬件架构，包括但不限于 x86_64、ARMv7、ARM64、ppc64le、s390x 等，满足跨架构 CI/CD 需求。

### 2.3 GitLab Runner 核心功能
- 完整集成 GitLab CI/CD 生态，支持作业执行、日志上报、状态同步等核心能力。
- 兼容 GitLab 官方定义的 Runner 注册、配置、升级流程。
- 支持多种执行器（Executor），如 `docker`、`shell`、`kubernetes` 等（需根据架构和环境配置）。


## 3. 使用场景和适用范围

### 3.1 适用场景
- **多架构 CI/CD 流水线**：需在 ARM 嵌入式设备、PowerPC 服务器或 x86 工作站等混合架构环境中统一运行 CI/CD 任务。
- **资源受限环境**：边缘计算节点、嵌入式系统、低配置服务器等硬件资源有限的场景。
- **高安全性需求**：Alpine Linux 的精简设计减少攻击面，适合对安全敏感的开发流程。

### 3.2 适用范围
- 个人开发者或小型团队的自动化构建/测试流程。
- 企业级跨架构应用开发（如 IoT 设备固件、多平台软件包构建）。
- 容器化部署环境中的 CI/CD 执行节点。


## 4. 使用方法和配置说明

### 4.1 拉取镜像
从镜像仓库拉取最新版本（替换 `latest` 为具体版本号如 `v16.0.0-alpine` 以固定版本）：
```bash
docker pull docker.xuanyuan.run/<镜像仓库地址>/alpine-gitlab-runner:latest
```


### 4.2 基本运行命令（注册并启动 Runner）
#### 4.2.1 注册 Runner
首次使用需向 GitLab 服务器注册 Runner，需提供 GitLab 实例 URL、注册令牌（从 GitLab 项目/群组设置中获取）、Runner 名称、标签等信息：
```bash
docker run --rm -v /etc/gitlab-runner:/etc/gitlab-runner \
  docker.xuanyuan.run/<镜像仓库地址>/alpine-gitlab-runner:latest register \
  --non-interactive \
  --url "https://gitlab.example.com/" \
  --registration-token "REGISTRATION_TOKEN" \
  --name "alpine-runner-arm64" \
  --tag-list "alpine,arm64,ci" \
  --executor "docker" \
  --docker-image "alpine:latest" \
  --docker-privileged
```

#### 4.2.2 启动 Runner 服务
注册完成后，启动 Runner 服务以监听并执行任务：
```bash
docker run -d --name gitlab-runner \
  --restart always \
  -v /etc/gitlab-runner:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \  # 若使用 docker 执行器需挂载 Docker 套接字
  <镜像仓库地址>/alpine-gitlab-runner:latest run
```


### 4.3 Docker Compose 配置示例
创建 `docker-compose.yml` 实现持久化部署：
```yaml
version: '3.8'
services:
  gitlab-runner:
    image: docker.xuanyuan.run/<镜像仓库地址>/alpine-gitlab-runner:latest
    container_name: gitlab-runner
    restart: always
    volumes:
      - ./gitlab-runner-config:/etc/gitlab-runner  # 持久化配置文件
      - /var/run/docker.sock:/var/run/docker.sock  # Docker 执行器依赖
    environment:
      - TZ=Asia/Shanghai  # 时区配置
      - LOG_LEVEL=info  # 日志级别：debug/info/warn/error
    command: run  # 启动命令
```

启动服务：
```bash
docker-compose up -d
```


### 4.4 环境变量说明
| 环境变量名                | 描述                                                                 | 默认值       |
|---------------------------|----------------------------------------------------------------------|--------------|
| `LOG_LEVEL`               | 日志输出级别（`debug`/`info`/`warn`/`error`）                        | `info`       |
| `TZ`                      | 时区设置（如 `Asia/Shanghai`）                                        | `UTC`        |
| `CONFIG_FILE`             | Runner 配置文件路径                                                  | `/etc/gitlab-runner/config.toml` |
| `RUNNER_EXTRA_FLAGS`      | 启动 Runner 时的额外命令行参数（如 `--max-jobs 4` 限制并发任务数）    | 无           |


### 4.5 核心配置参数（`config.toml`）
Runner 配置文件位于 `/etc/gitlab-runner/config.toml`（需通过卷挂载持久化），关键配置项说明：
```toml
[[runners]]
  name = "alpine-runner-arm64"
  url = "https://gitlab.example.com/"
  token = "RUNNER_TOKEN"  # 注册后自动生成
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "alpine:latest"  # 默认基础镜像
    privileged = true  # 若需构建 Docker 镜像需开启
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
  [runners.cache]
    Type = "s3"  # 可选：使用 S3/MinIO 缓存 artifacts
    Path = "runner-cache"
```


### 4.6 数据持久化
为避免容器重启后配置丢失，需挂载以下目录：
- `/etc/gitlab-runner`：存储 Runner 配置文件（`config.toml`）。
- `/cache`：存储 CI/CD 作业缓存（可选，根据 `config.toml` 配置）。


### 4.7 支持架构列表
| 架构        | 镜像标签后缀（示例） | 适用设备/场景                  |
|-------------|---------------------|---------------------------------|
| x86_64      | `amd64`             | 普通 PC、服务器                 |
| ARMv7       | `arm32v7`           | Raspberry Pi 3/4、ARM 嵌入式设备 |
| ARM64       | `arm64v8`           | Raspberry Pi 5、ARM 服务器      |
| ppc64le     | `ppc64le`           | PowerPC 架构服务器              |
| s390x       | `s390x`             | IBM Z 架构服务器                |


## 5. 注意事项
- **兼容性**：Alpine Linux 使用 musl libc，部分依赖 glibc 的二进制程序可能无法运行，建议 CI/CD 作业中使用 Alpine 基础镜像或静态编译工具链。
- **权限配置**：挂载 Docker 套接字（`/var/run/docker.sock`）时需确保容器内用户有足够权限，避免权限错误。
- **架构匹配**：拉取镜像时需指定与宿主机匹配的架构标签（如 `arm64v8`），或使用支持多架构的镜像仓库（如 Docker Hub 自动匹配）。
- **版本同步**：建议定期同步 GitLab Runner 官方版本，确保与 GitLab 服务器 API 兼容性。

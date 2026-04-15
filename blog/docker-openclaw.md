# Docker OpenClaw 生产环境部署指南（单机架构版）

![Docker OpenClaw 生产环境部署指南（单机架构版）](https://img.xuanyuan.dev/docker/blog/docker-openclaw.png)

*分类: OpenClaw,AI,部署教程 | 标签: OpenClaw,AI,部署教程,Moltbot,Clawdbot,人工智能 | 发布时间: 2026-02-24 09:04:51*

> 本文给出一套经过验证的 OpenClaw 单机生产部署方案，覆盖安全、稳定性与可维护性设计。
> 
> 内容包括：
> 
> Docker Compose 生产配置规范
> 
> CPU / 内存限制的正确写法
> 
> 健康检查与自动恢复
> 
> TLS 与反向代理配置
> 
> 防火墙与访问控制
> 
> 升级与备份建议
> 
> 适用于中小规模生产环境的稳定运行场景。

## OpenClaw 项目介绍

**2026年爆火的OpenClaw AI执行引擎**（曾用名Clawdbot、Moltbot），由奥地利开发者、PSPDFKit创始人Peter Steinberger主导开发，于2026年1月完成品牌定名与全生态统一，是2026年全球开源领域增速最快的项目之一，截至2026年2月，其GitHub仓库星标数已突破18.6万，社区贡献者与插件生态持续高速扩张。与传统对话式AI工具截然不同，OpenClaw的核心定位是“本地运行、可自托管的AI执行引擎”，主打“从给建议到做事情”的能力跃迁——它并非被动响应的聊天机器人，而是能通过自然语言指令，自主规划并完成全流程任务的“数字员工”。项目以本地优先为核心设计理念，所有用户数据默认存储于用户自有设备，彻底实现数据主权与隐私安全自主；同时支持接入Claude、GPT、Ollama等几乎所有主流大模型，兼容Telegram、WhatsApp、钉钉、飞书、QQ等十余种主流通讯渠道，可通过可插拔的技能插件无限扩展能力边界，覆盖办公自动化、文件管理、邮件处理、日程运维、代码辅助、跨应用协同等全场景任务执行，项目基于MIT开源协议开放全部代码，支持用户免费使用、自由修改、二次开发与私有化部署。

## 环境准备

### Docker 环境安装

#### 一键安装 Docker 环境（推荐国内服务器使用）
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

##### 该脚本特性说明
1. 完全基于 Docker 官方安装流程整理，行为与官方安装一致
2. 内置国内可访问的 Docker 镜像源与软件仓库，解决网络访问问题
3. 仅优化安装可达性，不修改 Docker 核心配置与运行行为
4. 不包含任何 Clawdbot 相关逻辑，可独立用于其他 Docker 部署场景

### 其他前提条件
- 已安装 bash v4 及以上版本（Windows 用户可通过 WSL、Git Bash 实现）；
- 生产环境需具备基础网络配置能力（如 Nginx 反向代理、HTTPS 证书配置）。

---

## 核心概念：OpenClaw Docker 镜像说明
OpenClaw Docker 镜像是个人 AI 助手 OpenClaw 的容器化版本，旨在提供标准化的部署环境，简化跨平台配置流程。

### 镜像基本信息
- 基础镜像：**Debian GNU/Linux bookworm-slim**（因 musl 兼容性问题，暂未使用 Alpine）；
- 版本管理：按版本号发布（如 `2026.2.22-beta.1`），**无自动同步更新机制**（Docker 镜像为不可变制品），生产环境请固定版本标签，避免使用 `latest`/`beta` 等易变标签；
- 架构支持：多架构（x86_64/ARM64），可通过 `docker buildx imagetools inspect docker.xuanyuan.run/alpine/openclaw:2026.2.22-beta.1` 查看具体支持情况；
- 后续计划：开发团队正推进兼容性优化，未来将迁移至 Alpine 构建以精简体积。

### 核心优势
- 跨平台支持：Windows、Mac（x86/ARM64）、Linux 全兼容；
- 本地模型部署：支持本地大语言模型，无需第三方 API 调用；
- 安全隔离：容器化部署，与主机环境隔离，避免权限冲突和环境污染；
- 场景适配：支持个人测试与企业生产场景，可按需配置安全与资源策略；
- 部署便捷：提供脚本化部署流程，降低运维门槛。

---

## 国内轩辕镜像拉取
为解决国内网络环境下官方镜像拉取慢、超时问题，本文提供 OpenClaw 国内轩辕镜像。生产环境请固定版本号，测试环境可临时使用 `beta` 标签。

```bash
# 拉取指定版本镜像（生产推荐）
docker pull docker.xuanyuan.run/alpine/openclaw:2026.2.22-beta.1

# 可选：为镜像添加本地别名，便于后续使用
docker tag docker.xuanyuan.run/alpine/openclaw:2026.2.22-beta.1 openclaw:prod-2026.2.22
```

- 轩辕镜像官方链接：https://xuanyuan.cloud/r/alpine/openclaw
- 版本说明：生产环境必须使用具体版本号（如 `2026.2.22-beta.1`），禁止使用 `latest` 标签。

---

### 生产环境部署
生产环境需重点关注安全、稳定性与可维护性，以下为完整部署流程。

#### 步骤 1：准备目录与配置文件
```bash
# 创建生产环境目录
mkdir -p /opt/openclaw/{config,logs,data}
cd /opt/openclaw

# 创建 .gitignore 文件，避免提交敏感信息
cat > .gitignore << EOF
.env
*.log
config/*
data/*
EOF

# 创建 .env 文件，存储敏感配置（务必设置权限）
cat > .env << EOF
OPENCLAW_TOKEN=$(openssl rand -hex 32)  # 使用 openssl 生成随机令牌
OPENCLAW_IMAGE=docker.xuanyuan.run/alpine/openclaw:2026.2.22-beta.1
EOF

# 设置 .env 文件权限（关键：防止凭据泄露）
chmod 600 .env
```

#### 步骤 2：编写生产级 Docker Compose 文件
创建 `docker-compose.prod.yml`，包含资源限制、健康检查、重启策略等核心配置：

```yaml
version: '3.8'

volumes:
  openclaw_home:  # 持久化 home 目录
    driver: local

services:
  openclaw-gateway:
    image: ${OPENCLAW_IMAGE}
    container_name: openclaw-gateway-prod
    restart: unless-stopped  # 生产级重启策略：除非手动停止，否则自动重启
    environment:
      - NODE_ENV=production
      - OPENCLAW_TOKEN=${OPENCLAW_TOKEN}
    volumes:
      - openclaw_home:/home/node
      - ./config:/home/node/config:ro
      - ./logs:/home/node/logs:rw
      # 按需挂载主机目录（生产环境建议严格限制权限）
      # - /data/openclaw/files:/home/node/files:rw
    ports:
      - "127.0.0.1:18789:18789"  # 仅绑定本地回环地址，禁止直接暴露公网
    # 资源限制（普通 docker compose 模式下生效）
    mem_limit: 2g
    cpus: 2
    # 健康检查（使用 wget，避免依赖 curl）
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:18789/health || exit 1"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 60s
    logging:  # 日志配置（便于集中管理）
      driver: "json-file"
      options:
        max-size: "100m"
        max-file: "5"
        compress: "true"
    user: "1000:1000"  # 非 root 用户运行（提升安全性）

  # 可选：沙箱容器（生产环境建议独立部署）
  openclaw-sandbox:
    image: openclaw-sandbox:bookworm-slim
    container_name: openclaw-sandbox-prod
    restart: "no"  # 沙箱按需启动，不自动重启
    network_mode: none  # 禁用网络（提升安全性，注意：会导致网络相关操作失败）
    mem_limit: 1g
    cpus: 0.5
    user: "1000:1000"
    volumes:
      - ./sandbox-data:/home/node/sandbox:rw
```

> **说明**：若使用 Docker Swarm 模式，可将资源限制配置在 `deploy.resources` 下。

#### 步骤 3：配置 Nginx 反向代理（HTTPS + 公网访问）
生产环境禁止直接暴露 Gateway 端口，需通过 Nginx 做反向代理并配置 HTTPS。

```nginx
# /etc/nginx/conf.d/openclaw.conf
server {
    listen 443 ssl http2;
    server_name openclaw.your-domain.com;  # 替换为你的域名

    # HTTPS 完整配置（生产环境必须）
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers on;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;

    # 强制 HSTS（提升安全性）
    add_header Strict-Transport-Security "max-age=31536000" always;

    # 限制访问（可选：仅允许指定 IP）
    # allow 192.168.1.0/24;
    # deny all;

    # 反向代理配置
    location / {
        proxy_pass http://127.0.0.1:18789;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 超时配置（适配 LLM 长响应）
        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }

    # 健康检查接口
    location /health {
        proxy_pass http://127.0.0.1:18789/health;
        access_log off;
    }
}

# 重定向 HTTP 到 HTTPS
server {
    listen 80;
    server_name openclaw.your-domain.com;
    return 301 https://$host$request_uri;
}
```

#### 步骤 4：配置防火墙（生产必须）
生产服务器需关闭 18789 端口对公网的暴露，仅开放 443 端口。以 `ufw` 为例（Ubuntu/Debian）：

```bash
ufw allow 443/tcp
ufw deny 18789/tcp
ufw enable
```

#### 步骤 5：Docker Daemon 安全建议（企业环境）
```bash
# 1. 开启 live-restore（容器在 daemon 重启时保持运行）
# 编辑 /etc/docker/daemon.json，添加：
{
  "live-restore": true
}

# 2. 限制 docker.sock 权限（默认已为 root:docker 660，请勿放宽）
chmod 660 /var/run/docker.sock

# 3. 生产环境禁止将 docker.sock 挂载进容器（沙箱场景需谨慎评估）
```

#### 步骤 6：启动生产环境服务
```bash
# 启动 Gateway 服务
docker compose -f docker-compose.prod.yml up -d

# 初始化配置（生成令牌/配置渠道）
docker compose -f docker-compose.prod.yml run --rm openclaw-gateway onboard

# 检查服务状态
docker compose -f docker-compose.prod.yml ps
docker compose -f docker-compose.prod.yml logs -f openclaw-gateway
```

#### 步骤 7：生产环境升级策略
```bash
# 1. 升级前备份数据卷
docker run --rm -v openclaw_home:/source -v /backup/openclaw:/dest alpine tar -czf /dest/openclaw_home_$(date +%Y%m%d).tar.gz /source

# 2. 拉取新版本镜像
docker compose -f docker-compose.prod.yml pull

# 3. 重启服务
docker compose -f docker-compose.prod.yml up -d

# 4. 验证服务状态
docker compose -f docker-compose.prod.yml ps
docker compose -f docker-compose.prod.yml logs -f openclaw-gateway
```

#### 步骤 8：日志长期策略（企业级建议）
```bash
# 方案 1：使用 journald driver（便于系统日志管理）
# 在 docker-compose.prod.yml 中修改 logging 配置：
logging:
  driver: "journald"
  options:
    tag: "openclaw-gateway"

# 方案 2：接入 Loki/ELK（集中日志管理）
# 参考 Loki 官方文档配置 Docker logging driver 为 loki
```

---

## 实用配置

### 1. 额外挂载主机目录
- **测试环境**：可灵活挂载，支持读写权限
  ```bash
  export OPENCLAW_EXTRA_MOUNTS="$HOME/.codex:/home/node/.codex:ro,$HOME/github:/home/node/github:rw"
  ```
- **生产环境**：仅挂载必要目录，严格限制权限
  ```yaml
  # 在 docker-compose.prod.yml 中添加
  volumes:
    - /data/openclaw/files:/home/node/files:ro  # 生产环境优先只读
  ```

### 2. 安装额外 APT 包
- **测试环境**：动态配置（不可复现，仅测试用）
  ```bash
  export OPENCLAW_DOCKER_APT_PACKAGES="ffmpeg build-essential"
  ```
- **生产环境**：固定版本构建（推荐）
  创建自定义 `Dockerfile`：
  ```dockerfile
  FROM docker.xuanyuan.run/alpine/openclaw:2026.2.22-beta.1
  
  # 固定 Debian 包版本，确保构建可复现
  RUN apt-get update && \
      apt-get install -y --no-install-recommends \
      ffmpeg=7:5.1.5-0+deb12u1 \
      build-essential=12.9 \
      wget=1.21.3-1+b2 \  # 确保 wget 存在（用于健康检查）
      && apt-get clean && \
      rm -rf /var/lib/apt/lists/*
  
  USER node
  ```
  构建命令：
  ```bash
  docker build -t openclaw:prod-custom -f Dockerfile.prod .
  ```

### 3. 渠道配置
```bash
# WhatsApp（扫码登录）
docker compose -f docker-compose.prod.yml run --rm openclaw-gateway channels login

# Telegram（输入 bot token）
docker compose -f docker-compose.prod.yml run --rm openclaw-gateway channels add --channel telegram --token "<token>"

# Discord（输入 bot token）
docker compose -f docker-compose.prod.yml run --rm openclaw-gateway channels add --channel discord --token "<token>"
```

### 4. 沙箱隔离（生产级配置）
生产环境沙箱需平衡安全性与可用性，核心配置如下：

```json
{
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "non-main", // 仅沙箱非主会话（默认推荐）
        "scope": "agent", // 每个智能体一个容器
        "workspaceAccess": "none", // 不允许访问智能体工作区
        "docker": {
          "image": "openclaw-sandbox:bookworm-slim",
          "network": "bridge", // 生产环境如需网络，使用 bridge（而非 none）
          "user": "1000:1000",
          "memory": "1g", // 限制容器内存
          "cpuQuota": 50000, // 限制 CPU 使用率（50%）
          "ulimits": {
            "nproc": 1024,
            "nofile": 4096
          }
        }
      }
    }
  }
}
```

**沙箱网络说明**：
- `network: none`：最高安全级别，但会导致网络相关操作（如 `pip install`、API 调用）失败；
- `network: bridge`：允许基础网络访问，可通过防火墙限制出站流量，平衡安全与可用。

---

## 常见问题排查

### 1. 镜像拉取失败
- 确认使用国内轩辕镜像，生产环境固定版本标签；
- 检查 Docker 服务状态：`systemctl status docker`（Linux）；
- 配置国内 Docker 镜像源（如阿里云、网易）。

### 2. 访问 127.0.0.1:18789 提示未授权
- 重新生成令牌：`docker compose -f docker-compose.prod.yml run --rm openclaw-gateway dashboard --no-open`；
- 检查 `.env` 文件权限：`ls -l .env`（需为 `-rw-------`）；
- 生产环境检查 Nginx 反向代理配置是否正确。

### 3. 沙箱启动失败
- 检查沙箱镜像是否构建：`scripts/sandbox-setup.sh`；
- 若使用 `network: none`，确认沙箱内无网络依赖操作；
- 检查容器资源限制是否过低：适当调高 `memory`/`cpus` 配置。

### 4. 生产环境服务自动退出
- 查看容器日志：`docker compose -f docker-compose.prod.yml logs openclaw-gateway`；
- 检查资源限制是否不足：调高 `memory`/`cpus` 配置；
- 确认 `restart` 策略为 `unless-stopped`。

### 5. 权限错误（EACCES）
- 修改挂载目录权限：`sudo chown -R 1000:1000 /opt/openclaw/data`；
- 生产环境确保容器以 non-root 用户（`1000:1000`）运行。

---

## 总结

### 核心关键点
1. **版本管理**：Docker 镜像无自动更新，生产环境必须固定版本标签（如 `2026.2.22-beta.1`），禁止使用 `latest`/`beta`；
2. **资源限制**：普通 docker compose 模式下使用 `mem_limit`/`cpus`，Swarm 模式可使用 `deploy.resources`；
3. **安全配置**：
   - 测试环境：默认配置可直接使用，仅绑定 `127.0.0.1`；
   - 生产环境：必须配置反向代理 + HTTPS、防火墙、资源限制、非 root 运行、健康检查、重启策略；
4. **健康检查**：使用 `wget` 替代 `curl`，确保在 Debian slim 镜像中可用；
5. **令牌生成**：使用 `openssl rand -hex 32` 替代 `uuidgen`，更通用；
6. **沙箱隔离**：平衡安全性与可用性，生产环境推荐使用 `bridge` 网络 + 防火墙限制，而非完全禁用网络。

### 部署选型建议
- **个人测试**：选择快速启动流程，使用 `beta` 版本镜像，无需复杂配置；
- **企业生产**：严格遵循生产环境部署流程，补充 Nginx 反向代理、HTTPS、防火墙、日志管理、定期备份等配置，确保服务稳定安全。


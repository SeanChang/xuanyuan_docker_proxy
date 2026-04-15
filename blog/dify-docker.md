# Dify 开源 LLM 应用开发平台企业级 Docker Compose 部署手册

![Dify 开源 LLM 应用开发平台企业级 Docker Compose 部署手册](https://img.xuanyuan.dev/docker/blog/docker-dify.png)

*分类: Dify,ai,人工智能,大模型 | 标签: dify,部署教程 | 发布时间: 2025-10-07 02:41:29*

> Dify 是由 LangGenius 开发的开源 LLM 应用开发平台，可帮助开发者与团队快速构建 AI 应用（如智能聊天机器人、私有知识库问答、自动化业务工作流等）。它支持可视化开发界面、多模型集成（GPT、文心一言、通义千问等），并提供完整的前后端架构；通过自托管部署，能有效保障数据隐私与安全，广泛适用于企业私有环境、定制化 AI 服务场景。

**责任边界声明**：本文聚焦 Docker Compose 形态下的生产部署实践，不涵盖 Kubernetes / Helm 等大规模集群场景。

Dify 是由 LangGenius 开发的**开源 LLM 应用开发平台**，可帮助开发者与团队快速构建 AI 应用（如智能聊天机器人、私有知识库问答、自动化业务工作流等）。它支持可视化开发界面、多模型集成（GPT、文心一言、通义千问等），并提供完整的前后端架构；通过自托管部署，能有效保障数据隐私与安全，广泛适用于企业私有环境、定制化 AI 服务场景。

本文为**企业级可落地**的 Dify 部署指南，包含：环境准备、Docker / Docker Compose 安全安装、轩辕镜像加速、「测试/生产双模式」部署方案、前后端关联配置、生产级安全加固及排错要点。文中所有配置均标注官方/镜像来源，按步骤执行即可稳定运行。

## 适用场景对照表
| 部署场景                | 推荐部署方式                | 核心特征                          |
|-------------------------|-----------------------------|-----------------------------------|
| 本地体验/功能测试       | 方法 B（最小化 Compose）    | 轻量快速、仅核心组件、无安全加固  |
| 内网私有化部署          | 方法 A（官方 Compose）      | 组件完整、可持久化、基础安全配置  |
| 企业生产环境            | 方法 A + 反向代理 + 外部存储 | 高可用、TLS 加密、权限隔离、可监控 |

---

## 🧰 准备工作
若你的系统尚未安装 Docker，请先完成安装。以下提供一键安装脚本（附安全声明），也可选择 Docker 官方安装方式。

### Linux Docker & Docker Compose 一键安装
一键安装配置脚本（适配国内环境）：
该脚本支持多种 Linux 发行版，一键安装 Docker、Docker Compose 并自动配置轩辕镜像加速源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

⚠️ 安全提示（生产环境强制要求）
该脚本将以 `root` 权限执行，涉及系统配置修改、软件安装等操作：
- 企业/生产环境：**必须先下载脚本本地审计**（`wget https://xuanyuan.cloud/docker.sh`），确认无风险后再执行；或直接使用 [Docker 官方安装文档](https://docs.docker.com/engine/install/)
- 测试/个人环境：可直接使用，脚本已做国内镜像适配，无需额外配置

---

## 一、核心组件说明：`dify-api` / `dify-web` 及依赖关系
- `dify-api`：后端核心服务（API 接口、任务调度、模型调用、数据存储等），镜像可从 Docker Hub 或轩辕加速源获取。([hub.docker.com][1])
- `dify-web`：前端管理控制台（Next.js 开发），通过环境变量指向后端 API，不直接处理业务逻辑。([hub.docker.com][2])
- `worker/celery`：异步任务处理组件（向量计算、文件解析、LLM 异步调用等），与 `dify-api` 共享存储和配置，是生产环境不可缺少的组件。
- 依赖关系：前端仅通过 API 调用后端；后端依赖数据库（MySQL）、对象存储（MinIO）、向量数据库；Worker 负责异步任务，与 API 共享存储和配置。([Dify 文档][3])

---

## 二、部署前准备（硬件 & 软件规范）
### 硬件要求（分场景）
| 场景         | CPU  | 内存   | 磁盘   | 备注                     |
|--------------|------|--------|--------|--------------------------|
| 测试/轻量使用 | ≥ 2  | ≥ 8GB  | ≥ 20GB | 仅运行核心组件，禁用复杂向量计算 |
| 生产/企业使用 | ≥ 4  | ≥ 16GB | ≥ 50GB | 需预留向量数据库、日志存储空间 |

### 软件要求
- Docker：推荐 Docker Engine 24.0+（**Linux Server 环境**）；不建议在生产环境使用 Docker Desktop，其主要适用于开发/本地测试场景
- Docker Compose：必须使用 V2 版本（命令为 `docker compose`，而非 `docker-compose`）
- 操作系统：推荐 Ubuntu 22.04 LTS / Rocky Linux 9 / AlmaLinux 9（不再推荐使用已停止维护的 CentOS Linux）

---

## 三、镜像来源（安全 & 稳定优先）
### 镜像标签规范（生产强制要求）
❌ 绝对禁止使用 `latest` 标签（会随机拉取新版本，导致 API 兼容、数据库 schema 冲突）
✅ 生产环境必须指定**具体版本号**（如 `0.10.3`），版本号需与 Dify 官方发布一致（[Dify 版本列表][11]）

### 镜像拉取命令（示例）
```bash
## 1. 生产环境（推荐，指定版本）
# 从 Docker Hub（外网环境）
docker pull langgenius/dify-api:0.10.3
docker pull langgenius/dify-web:0.10.3

# 从轩辕加速源（国内环境，替换为专属域名）
docker pull docker.xuanyuan.run/langgenius/dify-api:0.10.3
docker pull docker.xuanyuan.run/langgenius/dify-web:0.10.3

## 2. 测试环境（仅临时使用，不推荐）
docker pull langgenius/dify-api:latest
docker pull langgenius/dify-web:latest
```

> 轩辕镜像加速说明：国内网络拉取官方镜像慢/失败时，可访问 [轩辕镜像][4] 获取专属加速地址，无需登录即可拉取。

---

## 四、方法 A —— 官方 Github 仓库 + Docker Compose（生产/推荐）
### 说明
官方仓库提供完整的 `docker-compose.yml`、`.env` 模板，包含所有核心组件（API、Web、MySQL、MinIO、向量数据库、Worker），适配生产环境的持久化、权限配置，是企业部署的首选方案。([Dify 文档][3])

### 步骤（按序执行，生产级规范）
1. 克隆官方仓库（指定版本标签，避免主分支不稳定）：
```bash
git clone https://github.com/langgenius/dify.git
cd dify
# 切换到稳定版本（示例：v0.10.3）
git checkout v0.10.3
```

2. 进入 Docker 部署目录，复制配置模板：
```bash
cd docker
cp .env.example .env    ## 复制配置模板
```

3. 编辑 `.env`（生产级关键配置）
   - `APP_API_URL` / `CONSOLE_API_URL`：前端访问后端的基础 URL（仅写 `主机+端口`，如 `http://192.168.1.100`，禁止加 `/api` 子路径），错误配置会导致前端 API 请求 404。([GitHub][5])
   - `SECRET_KEY`：核心加密密钥，**生产环境必须自定义强随机字符串**，且一旦设置禁止修改（修改会导致 JWT 令牌失效、已加密数据无法解密）。
   - 数据库/MinIO 密码：必须替换默认值，使用大小写字母+数字+特殊符号的强密码。
   - 存储配置：`/app/api/storage` 需挂载到宿主机固定目录，且**仅需在 dify-api 和 worker 容器间共享**，dify-web 无需挂载该目录。([Dify 文档][6])

4. 启动服务（指定 Compose 文件，后台运行）：
```bash
docker compose -f docker-compose.yml up -d
```

5. 验证启动状态（生产级检查）：
```bash
# 1. 查看容器运行状态
docker compose ps
# 所有服务应显示 "Up" 状态

# 2. 查看 API 服务日志（容器名以实际 Compose 配置为准）
docker compose logs -f dify-api

# 3. 访问前端页面（替换为你的服务器 IP）
# 浏览器打开 http://<服务器IP>，应显示 Dify 登录界面
```

---

## 五、方法 B —— 最小化 Docker Compose（仅测试/Demo）
⚠️ 重要警告（强制阅读）
- 该配置仅用于**本地功能测试**，禁止直接用于生产环境
- 存在弱口令、端口暴露、无异步任务处理等安全/功能缺陷
- 生产环境必须使用方法 A，并补充反向代理、TLS 加密、权限隔离等配置

### 最小化 Compose 示例（docker-compose.min.yml）
```yaml
version: "3.8"
services:
  mysql:
    image: docker.xuanyuan.run/mysql:8.0
    environment:
      # 示例占位密码，仅用于本地测试，禁止用于任何生产环境
      MYSQL_ROOT_PASSWORD: StrongP@ssw0rd_2026
      MYSQL_DATABASE: dify
    volumes:
      - db_data:/var/lib/mysql
    restart: unless-stopped
    # 生产建议：禁用端口映射，仅内网访问
    # ports:
    #   - "3306:3306"

  minio:
    image: docker.xuanyuan.run/minio/minio
    command: server /data
    environment:
      # 示例占位密码，仅用于本地测试，禁止用于任何生产环境
      MINIO_ROOT_USER: dify_minio_admin
      MINIO_ROOT_PASSWORD: MinIO@StrongP@ss0rd
    # ❌ 测试用端口暴露，生产必须删除（仅内网访问）
    # ports:
    #   - "9000:9000"
    volumes:
      - minio_data:/data
    restart: unless-stopped

  dify-api:
    image: docker.xuanyuan.run/langgenius/dify-api:0.10.3
    depends_on:
      - mysql
      - minio
    environment:
      DATABASE_URL: "mysql+pymysql://root:StrongP@ssw0rd_2026@mysql:3306/dify"
      STORAGE_DRIVER: "local"
      SECRET_KEY: "your_strong_random_secret_key_here_123456"
      APP_API_URL: "http://dify-api:5001"
    volumes:
      - ./storage:/app/api/storage   ## 仅 API 需挂载，Web 无需挂载
    ports:
      - "5001:5001"
    restart: unless-stopped
    # 生产建议：添加健康检查
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5001/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  dify-web:
    image: docker.xuanyuan.run/langgenius/dify-web:0.10.3
    depends_on:
      - dify-api
    environment:
      APP_API_URL: "http://dify-api:5001"
    ports:
      - "80:3000"
    restart: unless-stopped
    # 生产建议：添加健康检查
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  db_data:
  minio_data:
```

> **healthcheck 版本说明**：`/health` 接口以当前 Dify 版本为准，如升级后接口路径变更，请以官方 API 文档或容器启动日志为准调整检查路径。

### 启动与验证（测试用）
```bash
# 启动
docker compose -f docker-compose.min.yml up -d

# 验证（容器名以实际 Compose 配置为准）
docker compose -f docker-compose.min.yml logs -f
# 浏览器访问 http://localhost 即可进入测试界面
```

---

## 六、前端（`dify-web`）与后端（`dify-api`）关联配置（核心）
前端通过环境变量获取后端 API 地址，生产环境需严格遵循以下规范：

### 核心环境变量
| 变量名          | 作用                     | 配置示例                | 注意事项                          |
|-----------------|--------------------------|-------------------------|-----------------------------------|
| `APP_API_URL`   | 前端应用的 API 基础地址  | `http://192.168.1.100`  | 仅写主机+端口，禁止加 `/api` 路径 |
| `CONSOLE_API_URL` | 控制台的 API 基础地址   | `http://192.168.1.100`  | 与 `APP_API_URL` 保持一致         |

### 配置示例（`.env` 文件）
```
# 生产环境（域名访问，带 HTTPS）
APP_API_URL=https://dify-api.example.com
CONSOLE_API_URL=https://dify-api.example.com

# 测试环境（IP 访问）
APP_API_URL=http://192.168.1.100
CONSOLE_API_URL=http://192.168.1.100
```

> 关键提醒：Dify 前端基于 Next.js 开发，部分变量需带 `NEXT_PUBLIC_` 前缀，**优先参考官方 `.env.example` 模板**，避免变量名错误导致前端无法调用 API。([Dify 文档][8])

---

## 七、生产环境 Docker 通用加固建议
### 1. 容器运行规范
- 所有服务必须设置 `restart: unless-stopped`（避免服务器重启后容器未启动）
- 核心服务（API、MySQL、MinIO）添加 `healthcheck`（自动检测服务状态，异常时重启）
- 高安全要求环境：使用 Rootless Docker 运行容器，或自建非 root 镜像（官方镜像默认以 root 运行，存在权限风险）

### 2. 网络与端口规范
- 禁止直接暴露数据库、MinIO、向量数据库端口到公网（仅内网访问）
- 使用 Nginx/Traefik 做反向代理，统一暴露 80/443 端口，并配置 TLS 加密（Let's Encrypt 免费证书）
- 配置防火墙（如 iptables/ufw），仅开放必要端口

### 3. 存储与备份规范
- 数据库、MinIO、storage 目录挂载到**独立数据盘**（避免系统盘满导致服务崩溃）
- 配置定时备份：每日备份 MySQL 数据库、MinIO 数据、storage 目录
- 生产环境优先使用外部托管数据库/对象存储（如阿里云 RDS、OSS），简化运维

---

## 八、高级定制与升级规范
### 1. 本地构建镜像（定制化需求）
若需修改前端代码或自定义配置，可在 `web/` 目录构建镜像：
```bash
cd dify/web
docker build -t your-registry/dify-web:0.10.3 .
```
> 参考：[GitHub 构建示例][9]

### 2. 切换向量数据库
Dify 支持 Weaviate、Milvus、Qdrant 等向量数据库，修改 `.env` 中 `VECTOR_STORE` 变量即可切换，需确保 API 和 Worker 配置一致。([Dify 文档][10])

### 3. 版本升级（生产级流程）
升级前**必须执行以下步骤**，避免数据丢失或兼容问题：
1. 备份 MySQL 数据库（`mysqldump -u root -p dify > dify_backup.sql`）
2. 备份 `/app/api/storage` 目录（`cp -r /path/to/storage /path/to/storage_backup`）
3. 备份 MinIO 数据（`cp -r /path/to/minio_data /path/to/minio_backup`）
4. **记录当前部署的 Dify 版本号与 Git Tag**（便于异常时快速回滚）
5. 确认新版本与当前版本的兼容性（参考官方升级文档）
6. 修改 `docker-compose.yml` 中的镜像版本号，执行 `docker compose up -d`

---

## 九、常见问题 & 排查步骤（快速清单）
### 1. 网页打不开/502 错误
- 检查防火墙是否开放端口，容器是否全部 `Up` 状态（`docker compose ps`）
- 查看 Nginx/反向代理日志，确认前端是否能访问后端 API
- 检查服务器网络（是否能 ping 通，是否有网络策略限制）

### 2. 前端 API 请求 404/报错
- 检查 `.env` 中 `APP_API_URL` 是否正确（仅主机+端口，无 `/api`）
- 查看 API 服务日志（`docker compose logs -f dify-api`），确认 API 服务是否正常监听

### 3. 文件上传/读取失败
- 确认 `/app/api/storage` 仅在 dify-api 和 worker 容器间共享，Web 无需挂载
- 检查 storage 目录权限（推荐 `chmod 755`，避免权限不足）

### 4. 镜像拉取失败
- 切换到轩辕加速镜像源，或检查网络是否能访问 Docker Hub
- 确认镜像版本号正确（避免使用不存在的版本）

---

## 十、Dify 部署架构图
### 1. 生产级架构（方法 A）

```mermaid
flowchart TD
    subgraph Client层
        C[Client<br/>Browser/API]
    end
    
    subgraph 反向代理层
        N[Nginx / LB<br/>反向代理+TLS+端口转发]
    end
    
    subgraph 前端层
        W[dify-web<br/>管理台 / Console<br/>仅API调用，无本地存储]
    end
    
    subgraph 核心服务层
        A[dify-api<br/>核心服务<br/>Auth/LLM/File]
    end
    
    subgraph 数据存储层
        DB[MySQL<br/>Metadata]
        VDB[Vector DB<br/>向量数据库]
        MINIO[MinIO<br/>Object Storage]
    end
    
    subgraph 异步任务层
        WORKER[Worker/Celery<br/>异步任务<br/>向量计算/文件解析]
    end

    %% 连接关系
    C -->|HTTPS| N
    N --> W
    W -->|REST API| A
    A --> DB
    A --> VDB
    A --> MINIO
    WORKER -->|共享存储/配置| A
```
**核心特征**：API/Worker 共享 storage；所有后端服务内网隔离；反向代理统一暴露端口；全组件持久化存储。

### 2. 测试级架构（方法 B）

```mermaid
flowchart TD
    subgraph client["Client 层"]
        C["Client\nBrowser / API"]
    end

    subgraph web["前端层"]
        W[dify-web]
    end

    subgraph core["核心服务层"]
        A[dify-api]
    end

    subgraph storage["测试存储层"]
        DB[MySQL]
        MINIO["MinIO\n端口暴露"]
    end

    C -->|HTTP| W
    W -->|REST API| A
    A --> DB
    A --> MINIO
```

**核心特征**：无反向代理；端口直接暴露；无 Worker 组件；仅核心功能可用，无生产级保障。

---

## 十一、实践小结
1. 安装 Docker/Compose：测试环境可使用一键脚本（需审计），生产环境优先官方安装方式。
2. 选择部署方式：测试用方法 B（最小化 Compose），生产用方法 A（官方 Compose）。
3. 配置核心参数：指定镜像版本号、自定义强密码、正确配置 `APP_API_URL`、共享 API/Worker 的 storage 目录。
4. 启动并验证：检查容器状态和日志，确认前端可正常访问后端 API。
5. 生产加固：添加反向代理/TLS、健康检查、定时备份，禁止暴露敏感端口。
6. 版本记录：升级前后务必记录 Dify 版本号与 Git Tag，确保可回滚。

---

## 生产部署前 Checklist
| 检查项 | 标准要求 | 完成状态 |
|--------|----------|----------|
| 镜像版本 | 已固定具体版本号，未使用 `latest` | ☑ |
| 密钥配置 | `SECRET_KEY` 已自定义强随机字符串 | ☑ |
| 端口安全 | 数据库/MinIO 未暴露公网端口 | ☑ |
| 网络加密 | 已配置反向代理 + TLS 证书 | ☑ |
| 数据备份 | 已完成数据库、storage、MinIO 首次全量备份 | ☑ |
| 容灾测试 | 测试容器重启后可自动恢复服务 | ☑ |
| 版本记录 | 已记录当前部署版本号与 Git Tag（便于回滚） | ☑ |

---

## 参考与延伸阅读
* [Dify 官方 Docker Compose 部署文档][3]
* [Dify API 镜像（Docker Hub）][1]
* [Dify Web 镜像（Docker Hub）][2]
* [轩辕镜像加速（dify-api）][4]
* [Dify 环境变量配置文档][6]
* [Dify 版本发布列表][11]

[1]: https://hub.docker.com/r/langgenius/dify-api
[2]: https://hub.docker.com/r/langgenius/dify-web
[3]: https://docs.dify.ai/en/getting-started/install-self-hosted/docker-compose
[4]: https://xuanyuan.cloud/r/langgenius/dify-api
[5]: https://github.com/langgenius/dify/issues/20365
[6]: https://docs.dify.ai/getting-started/install-self-hosted/environments
[7]: https://huggingface.co/spaces/Severian/dify/blob/12e3afc517e69b4b57d7bf9cf28b815dc999630c/docker/.env.example
[8]: https://docs.dify.ai/en/getting-started/install-self-hosted/start-the-frontend-docker-container
[9]: https://github.com/langgenius/dify/discussions/4939
[10]: https://docs.dify.ai/learn-more/faq
[11]: https://github.com/langgenius/dify/releases

---

### 总结
1. **版本与标签**：生产环境必须指定具体镜像版本号，禁止使用 `latest` 标签，避免版本兼容问题；升级前后需记录版本号与 Git Tag，便于回滚。
2. **安全规范**：一键安装脚本需审计后执行，最小化 Compose 仅用于测试，生产需替换弱口令、关闭敏感端口、配置反向代理/TLS；密码配置行需标注“示例占位，禁止生产使用”。
3. **存储与配置**：`/app/api/storage` 仅需在 API 和 Worker 容器间共享，Web 无需挂载；`SECRET_KEY` 一旦设置禁止修改，升级前必须备份数据。
4. **架构区分**：测试环境用最小化 Compose 快速验证功能，生产环境用官方 Compose 并补充健康检查、备份、权限隔离等加固措施；测试架构图移除无关的 SQLite 标识，与示例配置保持一致。
5. **日志命令**：优先使用 `docker compose logs -f <服务名>` 查看日志，规避容器名不一致的问题。


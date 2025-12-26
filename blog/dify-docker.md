# Dify Docker 部署详解

![Dify Docker 部署详解](https://img.xuanyuan.dev/docker/blog/docker-dify.png)

*分类: Docker,Dify | 标签: defy,docker,部署教程 | 发布时间: 2025-10-07 02:41:29*

> Dify 是由 LangGenius 开发的开源 LLM 应用开发平台，可帮助开发者与团队快速构建 AI 应用（如智能聊天机器人、私有知识库问答、自动化业务工作流等）。它支持可视化开发界面、多模型集成（GPT、文心一言、通义千问等），并提供完整的前后端架构；通过自托管部署，能有效保障数据隐私与安全，广泛适用于企业私有环境、定制化 AI 服务场景。

Dify 是由 LangGenius 开发的**开源 LLM 应用开发平台**，可帮助开发者与团队快速构建 AI 应用（如智能聊天机器人、私有知识库问答、自动化业务工作流等）。它支持可视化开发界面、多模型集成（GPT、文心一言、通义千问等），并提供完整的前后端架构；通过自托管部署，能有效保障数据隐私与安全，广泛适用于企业私有环境、定制化 AI 服务场景。


下面是一份「照着做」的中文手把手部署教程，包含：环境准备、Docker / Docker Compose 一键安装、使用轩辕镜像访问支持拉取、**两种部署方式**（官方仓库一键启动 / 最小化 Docker Compose 快速上手）、前后端如何关联、以及高级定制与排错要点。文中重要事实与配置我都标注了官方 / 镜像来源的引用，按步骤来就能跑起来。

---

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 一、先了解：`dify-api` / `dify-web` 是什么、它们的关系

* `dify-api`：后端服务（API、任务 worker、模型调用等）。镜像可从 Docker Hub 或镜像访问支持源获取。([hub.docker.com][1])
* `dify-web`：前端（Next.js）管理后台和控制台界面，通常通过配置指向后端 API。([hub.docker.com][2])
* 关系：前端调用后端的 API（通过环境变量指定后端 base URL），后端负责存储、队列、嵌入（向量 DB）等。详见 Dify 自托管/Compose 文档（推荐优先使用官方提供的 docker-compose 启动流程）。([Dify 文档][3])

---

## 二、部署前准备（硬件 & 软件建议）

* 建议（非强制）：生产 / 负载场景 CPU ≥ 4，内存 ≥ 16GB，磁盘 ≥ 50GB；本地测试/轻量可适当放宽。
* Docker 版本：建议使用 Docker Engine（以及 Docker Compose v2 风格 `docker compose`）。Dify 官方推荐用 Docker Compose 来一键启动。([Dify 文档][3])

---

## 三、安装 Docker & Docker Compose（推荐一键脚本）

> 推荐使用你的环境下的「一键安装配置脚本」，示例（脚本会自动识别发行版并安装 docker + docker-compose 并配置国内镜像访问支持）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

**脚本特性（可在文内写明给用户的说明）**

* 支持主流发行版：OpenCloudOS、Ubuntu、Debian、CentOS、RHEL、Rocky 等。
* 自动选择最优安装方式并内置国内镜像源，自动配置轩辕镜像访问支持（适合在国内网络环境使用）。

> 如果你偏好官方方式，也可以用 Docker 官方安装脚本 + 官方 Compose 安装；Dify 文档示例同样使用 `docker compose up -d`。([Dify 文档][3])

---

## 四、镜像来源（推荐使用轩辕镜像访问支持）

* 官方 Docker Hub 镜像（示例）：`langgenius/dify-api`、`langgenius/dify-web`（可以直接 `docker pull`）。([hub.docker.com][1])
* 如果在国内网络下拉取慢或受限，可使用轩辕加速镜像（示例页面）：`https://xuanyuan.cloud/r/langgenius/dify-api` ,`https://xuanyuan.cloud/r/langgenius/dify-web`（轩辕上通常会提供访问支持地址，例如 `docker.xuanyuan.run/langgenius/dify-api:TAG`）。（轩辕页面示例）([轩辕镜像][4])

示例拉取命令（根据你选的 tag 改成具体版本）：

```bash
## 从 Docker Hub（默认，若可用）
docker pull langgenius/dify-api:latest
docker pull langgenius/dify-web:latest

## 或者使用轩辕访问支持地址
docker pull xxx.xuanyuan.run/langgenius/dify-api:latest
docker pull xxx.xuanyuan.run/langgenius/dify-web:latest
```

---

## 五、方法 A —— **官方Github仓库 + Docker Compose（初学者推荐）**

**说明：** 官方仓库带有 `docker/docker-compose.yml`、`.env` 模板、service_conf 模板，直接用官方模板最省心（同时适配了 MySQL、MinIO、Elasticsearch/向量引擎等服务）。官方文档也以此为主线。([Dify 文档][3])

#### 步骤（按序执行）

1. 克隆官方仓库：

```bash
git clone https://github.com/langgenius/dify.git
cd dify
```

2. 进入 Docker 部署目录（仓库内通常有 `docker/` 子目录）：

```bash
cd docker
cp .env.example .env    ## 复制配置模板
```

3. 编辑 `.env`（重要项）

   * `APP_API_URL` / `CONSOLE_API_URL`：前端需要知道后端的 base URL（只写主机+端口，不要写 `/api` 等子路径），示例：`APP_API_URL=http://your-host`。设置错误会导致前端构造错误的 API 地址。([GitHub][5])
   * 设置数据库/MinIO密码、SECRET_KEY 等（参照 `.env.example` 注释）
   * 注意：如果使用 Docker Compose 部署，**确保挂载 `/app/api/storage` 到宿主同一路径（两个容器要共用同一物理路径）**，否则会出现文件找不到问题。([Dify 文档][6])

4. 启动（使用 Docker Compose V2 风格）：

```bash
docker compose -f docker-compose.yml up -d
```

5. 查看日志确认启动（示例）：

```bash
docker logs -f dify-server     ## 或 docker logs -f <api 容器名>
## 若一切正常，会看到服务监听地址等启动信息
```

6. 访问页面：浏览器打开 `http://<服务器IP>`（或你在 `.env` 中设置的端口与域名）。

> **为何推荐这种方式？** 因为官方的 `docker-compose.yml` 把 API、web、mysql、minio、向量存储（如 Milvus / Qdrant / Elasticsearch）和 worker 都编排好了，修改 `.env` 后基本可直接运行。官方文档中也推荐这种 Compose 流程。([Dify 文档][3])

---

## 六、方法 B —— 最小化 Docker Compose（快速上手 / 可用于轻量环境）

> 如果你只想先跑一个最简单的 demo（仅 API + Web + SQLite 或外置 MySQL + MinIO），这里给出一个**简化示例 Compose**（仅作模板参考，实际项目建议使用官方 `docker-compose.yml` 并结合 `.env.example` 调整）：

```yaml
## docker-compose.min.yml (示例)
version: "3.8"
services:
  mysql:
    image: xxx.xuanyuan.run/mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: example_password
      MYSQL_DATABASE: dify
    volumes:
      - db_data:/var/lib/mysql
    restart: unless-stopped

  minio:
    image: xxx.xuanyuan.run/minio/minio
    command: server /data
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    ports:
      - "9000:9000"
    volumes:
      - minio_data:/data
    restart: unless-stopped

  dify-api:
    image: xxx.xuanyuan.run/langgenius/dify-api:latest
    depends_on:
      - mysql
      - minio
    environment:
      ## 关键 env 示例（实际以官方 .env 为准）
      DATABASE_URL: "mysql+pymysql://root:example_password@mysql:3306/dify"
      STORAGE_DRIVER: "local"
      ## 其它 SECRET_KEY、JWT 等变量请从官方 .env.example 填写
    volumes:
      - ./storage:/app/api/storage   ## 本地挂载：务必保证 web 与 api 共用同一 storage（若需要）
    ports:
      - "5001:5001"
    restart: unless-stopped

  dify-web:
    image: xxx.xuanyuan.run/langgenius/dify-web:latest
    depends_on:
      - dify-api
    environment:
      ## 指定前端如何访问后端（通常在 .env 中设置 APP_API_URL / CONSOLE_API_URL）
      APP_API_URL: "http://dify-api:5001"
    ports:
      - "80:3000"   ## 前端内部端口可能不同：请根据镜像文档调整
    restart: unless-stopped

volumes:
  db_data:
  minio_data:
```

**重要说明与校验点：**

* 上面只是一个简化示例。官方 Compose 会处理更多细节（worker、celery、向量存储、nginx、ssl、反向代理等），生产请使用官方模板并根据 `.env` 配置。([Dify 文档][3])
* 若采用 `local` 存储，请确保 `/app/api/storage` 在 api 与 web（若 web 需要读取文件）之间是一致挂载，否则会出现文件找不到。([Dify 文档][6])
*请将 xxx.xuanyuan.run 替换为你的轩辕镜像专属免登录域名

---

## 七、前端（`dify-web`）如何正确关联后端（关键 env）

前端通过环境变量知道后端地址（base URL）。常见 env：

* `APP_API_URL`：WebApp 的后端 URL（用于前端 API 请求）。如果为空，默认同域。务必只写 host:port，不要附带 `/api` 子路径。([Dify 文档][6])
* `CONSOLE_API_URL` / `SERVICE_API_URL`：控制台/服务 API 的 base URL（不同版本的 .env 名称略有不同，建议以仓库中的 `.env.example` 为准）。([Hugging Face][7])

示例（`.env`）：

```
APP_API_URL=http://api.example.com
CONSOLE_API_URL=http://api.example.com
SERVICE_API_URL=http://api.example.com
```

**注意点：**

* Next.js/前端会把部分变量内嵌到客户端，部署前请确认变量名和前端运行时约定（例如是否需要 `NEXT_PUBLIC_` 前缀，Dify 的 Compose `.env.example` 已做了对应声明，按官方模板修改）。([Dify 文档][8])

---

## 八、高级构建

1. **本地构建前端镜像**：如果需要修改前端代码或设置 base path，可在仓库 `web/` 目录自行 `docker build` 然后在 Compose 中替换镜像名。社区讨论 / Issue 也有示例（在 `web` 目录下 `docker build`）。([GitHub][9])
2. **替换向量数据库**：官方支持多种向量存储（Weaviate、Milvus、Qdrant、Elasticsearch 等），切换向量引擎需修改 `.env` / `docker-compose.yml` 中对应 `VECTOR_STORE` / 引擎设置，并确保 worker 与 api 两端配置一致。([Dify 文档][10])
3. **生产化建议**：使用 Nginx 或 Traefik 做反向代理与 TLS（Let's Encrypt / 自签），把前端和后端都放到内部网络并通过代理暴露 80/443；把 DB/存储放到持久化盘、定期备份、并对关键服务做资源限制和监控。
4. **缩放**：将 worker（任务队列）拆分到单独集群、向量 DB 单独扩容；考虑使用外部托管 DB/向量服务以简化运维。

---

## 九、常见问题 & 排查步骤（快速清单）

* **网页打不开/502/Network Error**：检查防火墙（开放 80/443/你设置的端口）、检查容器日志 `docker logs -f <容器名>`。([Dify 文档][3])
* **前端请求 404/构造错误的 API 地址**：检查 `.env` 中 `APP_API_URL` / `CONSOLE_API_URL` 的值，确保只写主机与端口（不带 `/api`）。([GitHub][5])
* **文件丢失（上传文件/封面图等）**：确认 `/app/api/storage` 在容器间挂载为同一路径（Compose 中两处挂同一宿主目录）。([Dify 文档][6])
* **镜像拉取失败**：尝试使用轩辕访问支持地址 `docker.xuanyuan.run/...`，或手动 `docker pull langgenius/dify-api:<tag>`。([轩辕镜像][4])

---

## 十、实践小结

1. 安装 Docker 与 Docker Compose（推荐一键脚本）。
2. 克隆官方仓库 `git clone https://github.com/langgenius/dify.git`（或准备最简 compose）。([GitHub][11])
3. 复制 `.env.example` → `.env`，填写 `APP_API_URL`、数据库密码、MinIO 配置等。([Dify 文档][6])
4. 使用 `docker compose -f docker/docker-compose.yml up -d` 启动。([Dify 文档][3])
5. 查看日志并访问 `http://<你的域名或IP>`。

---

## 参考与延伸阅读（官方 & 镜像）

* Dify 官方自托管（Docker Compose）文档（教你如何用 docker compose 一键启动）。([Dify 文档][3])
* Dify Docker Hub — `langgenius/dify-api`。([hub.docker.com][1])
* Dify Docker Hub — `langgenius/dify-web`。([hub.docker.com][2])
* Dify 环境变量 / 存储说明（挂载 `/app/api/storage` 的注意）。([Dify 文档][6])
* 关于前端如何配置 API 基础 URL（`APP_API_URL` / `CONSOLE_API_URL` 的说明与常见错误）。([Dify 文档][6])
* 轩辕镜像访问支持：`dify-api` 在轩辕的页面（国内拉取加速示例）。([轩辕镜像][4])

---

## 参考文档

1. [langgenius/dify-api](https://hub.docker.com/r/langgenius/dify-api?utm_source=chatgpt.com)
2. [langgenius/dify-web - Docker Image](https://hub.docker.com/r/langgenius/dify-web?utm_source=chatgpt.com)
3. [Deploy with Docker Compose (Dify 官方文档)](https://docs.dify.ai/en/getting-started/install-self-hosted/docker-compose?utm_source=chatgpt.com)
4. [dify-api 镜像下载 - 轩辕镜像 | 国内开发者首选的Docker镜像访问支持服务平台](https://xuanyuan.cloud/r/langgenius/dify-api)
5. [Dify Docker Compose (WSL2/Win) API URL Duplication (GitHub Issue)](https://github.com/langgenius/dify/issues/20365?utm_source=chatgpt.com)
6. [Environments (Dify 环境变量配置文档)](https://docs.dify.ai/getting-started/install-self-hosted/environments?utm_source=chatgpt.com)
7. [docker/.env.example · Severian/dify (Hugging Face)](https://huggingface.co/spaces/Severian/dify/blob/12e3afc517e69b4b57d7bf9cf28b815dc999630c/docker/.env.example?utm_source=chatgpt.com)
8. [Start Frontend Docker Container Separately (Dify 前端部署文档)](https://docs.dify.ai/en/getting-started/install-self-hosted/start-the-frontend-docker-container?utm_source=chatgpt.com)
9. [Create an image from the web folder and send it to Docker (GitHub Discussion)](https://github.com/langgenius/dify/discussions/4939?utm_source=chatgpt.com)
10. [Self Host / Local Deployment - Dify Docs (FAQ)](https://docs.dify.ai/learn-more/faq?utm_source=chatgpt.com)
11. [Releases · langgenius/dify (GitHub)](https://github.com/langgenius/dify/releases?utm_source=chatgpt.com)


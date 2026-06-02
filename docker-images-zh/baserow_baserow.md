---
image: baserow/baserow
description: "Baserow的一站式Docker镜像，是开源无代码数据库工具，可作为Airtable的替代品。"
source: https://xuanyuan.cloud/zh/r/baserow/baserow
canonical: https://xuanyuan.cloud/zh/r/baserow/baserow
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/baserow/baserow" title="baserow/baserow Docker 镜像中文简介、标签列表与拉取命令">baserow/baserow — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/baserow/baserow" title="baserow/baserow Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/baserow/baserow</a>

# Baserow Docker 镜像文档

## 镜像概述与主要用途

Baserow 是一款开源无代码数据库工具，同时也是 Airtable 的替代方案。无需技术经验，您即可创建自己的在线数据库。我们用户友好的无代码工具让您无需离开浏览器就能拥有开发者级别的能力。

## 核心功能与特性

- **电子表格与数据库的混合体**：兼具易用性和强大的数据组织能力
- **轻松自托管**：无存储限制，或可直接在 [baserow.io](https://baserow.io) 注册立即开始使用
- **Airtable 替代方案**
- **开放核心模式**：所有非高级和非企业功能基于 [MIT 许可证](https://choosealicense.com/licenses/mit/)，允许商业和私人使用
- **无头架构（Headless）与 API 优先**
- **采用流行框架和工具**：如 [Django](https://www.djangoproject.com/)、[Vue.js](https://vuejs.org/) 和 [PostgreSQL](https://www.postgresql.org/)

## 使用场景与适用范围

- 适合无技术背景的个人或团队快速构建和管理在线数据库
- 自托管部署，满足数据隐私和自主控制需求
- 替代 Airtable 用于商业或私人数据组织、项目管理、内容规划等场景
- 需要通过 API 集成数据到其他系统的业务流程
- 从小型团队到企业级应用的灵活扩展需求

## 快速参考

- **维护方**：[baserow.io](https://baserow.io/contact)
- **获取支持**：[Baserow 社区论坛](https://community.baserow.io)
- **源代码**：[gitlab.com/baserow/baserow](https://gitlab.com/baserow/baserow)
- **文档**：[baserow.io/docs](https://baserow.io/docs)
- **许可证**：开放核心模式，所有非高级和非企业代码基于 MIT 许可证

## 支持的标签与 Dockerfile 链接

- [`X.Y.Z`](https://gitlab.com/baserow/baserow/-/blob/master/deploy/all-in-one/Dockerfile)：按 Baserow 版本标记
- [`latest`](https://gitlab.com/baserow/baserow/-/blob/master/deploy/all-in-one/Dockerfile)：最新稳定版
- [`develop-latest`](https://gitlab.com/baserow/baserow/-/blob/develop/deploy/all-in-one/Dockerfile)：开发分支的前沿镜像，使用风险自负

## 快速开始

运行以下命令启动本地 Baserow 服务器，监听端口 `80`。仅能从运行服务器的机器通过 `http://localhost` 连接到 Baserow。

```bash
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=http://localhost \
  -v baserow_data:/baserow/data \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  baserow/baserow:1.35.3
```

> **注意**：
> - 将 `BASEROW_PUBLIC_URL` 更改为 `https://您的域名` 或 `http://您的IP` 以启用外部访问。确保此地址与浏览器地址栏中输入的地址一致，不同地址将被视为已发布的应用程序。
> - 添加 `-e BASEROW_CADDY_ADDRESSES=:443` 可启用 [Caddy 自动 HTTPS](https://caddyserver.com/docs/automatic-https)。
> - 可选添加 `-e DATABASE_URL=postgresql://user:pwd@host:port/db` 使用外部 PostgreSQL。
> - 可选添加 `-e REDIS_URL=redis://user:pwd@host:port` 使用外部 Redis。

> **安全提示**：Docker 与 ufw 防火墙存在安全缺陷。默认情况下，当 Docker 在 0.0.0.0 上暴露端口时，会绕过任何 ufw 防火墙规则，使容器在网络上公开。如果不希望公开访问，请使用以下端口映射：`-p 127.0.0.1:80:80 -p 127.0.0.1:443:443`，仅允许本地访问。更多信息请参见 [ufw-docker](https://github.com/chaifeng/ufw-docker)。

## 镜像功能概述

`baserow/baserow:1.35.3` 镜像默认在单个容器中运行 Baserow 的所有服务，以实现最大易用性。

> 此镜像设计用于简单的单服务器部署或简单的容器部署服务（如 Google Cloud Run）。
> 如果需要更适合水平扩展的部署（如使用 [K8S](./install-with-k8s.md)），请使用 [baserow/backend 和 baserow/web-frontend](./install-with-docker-compose.md) 镜像，这些镜像将每个 Baserow 服务独立部署在各自的容器中。

主要特性摘要：

- 默认在内部运行 PostgreSQL 数据库和 Redis 服务器，所有数据存储在容器内的 `/baserow/data` 文件夹中
- 设置 `DATABASE_URL` 或 `DATABASE_...` 变量可禁用内部 PostgreSQL，连接外部 PostgreSQL。对于任何生产部署，强烈建议使用外部 PostgreSQL，以便从其他服务或进程轻松连接数据库
- 设置 `REDIS_URL` 或 `REDIS_...` 变量可禁用内部 Redis，连接外部 Redis
- 在预配置的 Caddy 反向代理后运行所有服务。将 `BASEROW_CADDY_ADDRESSES` 设置为 `https://您的域名.com`，Caddy 将[自动启用 HTTPS](https://caddyserver.com/docs/automatic-https#overview)，并将密钥和证书存储在 `/baserow/data/caddy` 中
- 提供 CLI 工具，可对运行中的 Baserow 容器执行管理命令，或对 Baserow 数据卷运行一次性命令

## 从旧版本升级

1. 建议在升级前备份数据，详见下文备份部分
2. 停止现有 Baserow 容器：

```bash
docker stop baserow
```

3. 在通常用于运行 Baserow 的 `docker run` 命令中更新镜像版本，启动新容器：

```bash
# 由于尚未删除旧容器，需为新容器指定不同名称，避免冲突
docker run \
  -d \
  --name baserow_version_新版本号 \
  # 您的标准参数
  baserow/baserow:最新版本号
```

4. Baserow 将在启动时自动升级，通过日志监控进度：

```bash
docker logs -f baserow_version_新版本号
```

5. 当看到以下日志行时，升级完成且 Baserow 可再次使用：

```
[BASEROW-WATCHER][2022-05-10 08:44:46] Baserow is now available at ...
```

6. 访问 Baserow 确认一切正常且数据存在
7. 如无问题，可删除旧容器：

> **警告**：如果未使用卷持久化容器内的 `/baserow/data` 文件夹，删除容器将永久丢失所有 Baserow 数据。

```bash
docker rm baserow
```

## 从旧版本升级 PostgreSQL 数据库

2023 年 11 月，[PostgreSQL 发布](https://www.postgresql.org/about/news/postgresql-161-155-1410-1313-1217-and-1122-released-2749/) 了版本 11 的最终更新，并宣布终止支持该版本。这意味着 PostgreSQL 11 将不再接收安全和错误修复。

如果使用嵌入式 PostgreSQL 数据库（未提供 `POSTGRESQL_*` 环境变量），且数据是使用 PostgreSQL 11 初始化的，重启或运行新 Baserow 实例时，可能会因需要将数据目录升级到 PostgreSQL 15 兼容版本而无法启动并报错。Baserow 提供自动升级数据目录到 PostgreSQL 15 的镜像，PostgreSQL 15 是 Baserow 官方支持的版本。

如果暂时不想升级，可跳至 [旧版 PostgreSQL](#旧版-postgresql) 部分。但请注意，PostgreSQL 11 仅会被支持有限时间，且不再接收官方更新。

### 升级流程

要将数据目录升级到 PostgreSQL 15 兼容版本，请按以下步骤操作：

**注意**：升级前请确保 [备份 Baserow 实例](#备份与恢复-baserow)，避免数据丢失。

1. 使用 `docker ps` 确认没有运行的 Baserow 实例。如果正在运行，使用 `docker stop baserow` 停止容器
2. 运行以下命令启动 Docker 镜像，自动将数据目录更新为 PostgreSQL 15 兼容版本：

```bash
docker run \
  --name baserow-pgautoupgrade \
  # 添加您通常运行 Baserow 时使用的所有参数
  --restart no \
  baserow/baserow-pgautoupgrade:1.30.1
```

3. 如果升级成功，容器将退出并显示成功消息，此时可按常规方式启动 Baserow
4. 如果升级失败，升级镜像将输出详细错误日志。请复制所有日志输出，前往 [Baserow 社区](https://community.baserow.io/) 或联系支持获取帮助

### 旧版 PostgreSQL

自 2025 年 1 月 1 日起，我们将不再创建包含 PostgreSQL 11 的新镜像。如果使用 1.30 之前版本的 Baserow 嵌入式 PostgreSQL，且不想升级，必须先使用最新的 `pgautoupgrade` 镜像将 PostgreSQL 升级到 15，然后才能升级到最新版 Baserow。如果不想升级，1.30.1 是最后一个提供 PostgreSQL 11 的镜像，但该版本将不再接收更新。

要运行使用旧版 PostgreSQL 11 的最新 Baserow 镜像，请使用以下命令：

```bash
docker run \
  --name baserow-pg11 \
  # 添加您通常运行 Baserow 时使用的所有参数
  --restart unless-stopped \
  baserow/baserow-pg11:1.30.1
```

## 示例命令

有关所有可配置环境变量的详细信息，请参见 [配置 Baserow](configuration.md)。

### 使用域名与自动 HTTPS

如果拥有域名并正确配置了 DNS，可运行以下命令使 Baserow 通过域名访问，并由 Caddy 提供 [自动 HTTPS](https://caddyserver.com/docs/automatic-https#overview)。

> 若仍希望通过 `http://localhost` 从本地访问，可将 `BASEROW_CADDY_ADDRESSES` 设为 `:443,http://localhost`。所有支持的值请参见 [Caddy 地址文档](https://caddyserver.com/docs/caddyfile/concepts#addresses)。

```bash
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=https://www.您的域名.com \
  -e BASEROW_CADDY_ADDRESSES=:443 \
  -v baserow_data:/baserow/data \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  baserow/baserow:1.35.3
```

### 在处理 SSL 的反向代理后运行

```bash
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=https://www.您的域名.com \
  -v baserow_data:/baserow/data \
  -p 80:80 \
  --restart unless-stopped \
  baserow/baserow:1.35.3
```

### 使用非标准 HTTP 端口

```bash
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=https://www.您的域名.com:3001 \
  -v baserow_data:/baserow/data \
  -p 3001:80 \
  --restart unless-stopped \
  baserow/baserow:1.35.3
```

### 使用外部 PostgreSQL 服务器

```bash
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=https://www.您的域名.com \
  -e DATABASE_HOST=数据库主机 \
  -e DATABASE_NAME=数据库名称 \
  -e DATABASE_USER=数据库用户 \
  -e DATABASE_PASSWORD=数据库密码 \
  -e DATABASE_PORT=数据库端口 \
  -v baserow_data:/baserow/data \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  baserow/baserow:1.35.3
```

### 使用外部 Redis 服务器

```bash
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=https://www.您的域名.com \
  -e REDIS_HOST=Redis主机 \
  -e REDIS_USER=Redis用户 \
  -e REDIS_PASSWORD=Redis密码 \
  -e REDIS_PORT=Redis端口 \
  -e REDIS_PROTOCOL=Redis协议 \
  -v baserow_data:/baserow/data \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  baserow/baserow:1.35.3
```

### 使用外部邮件服务器

```bash
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=https://www.您的域名.com \
  -e EMAIL_SMTP=True \
  -e EMAIL_SMTP_HOST=SMTP主机 \
  -e EMAIL_SMTP_PORT=SMTP端口 \
  -e EMAIL_SMTP_USER=SMTP用户 \
  -e EMAIL_SMTP_PASSWORD=SMTP密码 \
  -e EMAIL_SMTP_USE_TLS=是否使用TLS \
  -v baserow_data:/baserow/data \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  baserow/baserow:1.35.3
```

### 连接同一主机上的 PostgreSQL 服务器

以下假设使用 Ubuntu 系统自带的 PostgreSQL 服务器。其他系统需调整配置文件路径。

1. 运行 `sudo ls /etc/postgresql/` 查看 PostgreSQL 版本
2. 以 root 身份编辑 `/etc/postgresql/您的PostgreSQL版本/main/postgresql.conf`
3. 找到注释的 `# listen_addresses` 行，修改为：
   `listen_addresses = '*'          # 监听的IP地址`
4. 以 root 身份编辑 `/etc/postgresql/您的PostgreSQL版本/main/pg_hba.conf`
5. 在文件末尾添加以下行，允许 Docker 容器连接：
   `host    all             all             172.17.0.0/16           md5`
6. 重启 PostgreSQL 加载配置：
   `sudo systemctl restart postgresql`
7. 检查日志确保无错误：
   `sudo less /var/log/postgresql/postgresql-您的PostgreSQL版本-main.log`
8. 运行 Baserow：

```bash
docker run \
  -d \
  --name baserow \
  --add-host host.docker.internal:host-gateway \
  -e BASEROW_PUBLIC_URL=http://localhost \
  -e DATABASE_HOST=host.docker.internal \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=您的数据库名称 \
  -e DATABASE_USER=您的数据库用户名 \
  -e DATABASE_PASSWORD=您的数据库密码 \
  --restart unless-stopped \
  -v baserow_data:/baserow/data \
  -p 80:80 \
  -p 443:443 \
  baserow/baserow:1.35.3
```

### 通过文件提供密钥

`DATABASE_PASSWORD`、`SECRET_KEY` 和 `REDIS_PASSWORD` 环境变量可通过 `*_FILE` 变体从文件加载：

```bash
echo "您的Redis密码" > .your_redis_password
echo "您的密钥" > .your_secret_key
echo "您的PostgreSQL密码" > .your_pg_password
docker run \
  -d \
  --name baserow \
  -e BASEROW_PUBLIC_URL=http://localhost \
  -e REDIS_PASSWORD_FILE=/baserow/.your_redis_password \
  -e SECRET_KEY_FILE=/baserow/.your_secret_key \
  -e DATABASE_PASSWORD_FILE=/baserow/.your_pg_password \
  -e EMAIL_SMTP_PASSWORD_FILE=/baserow/.your_smtp_password \
  --restart unless-stopped \
  -v $PWD/.your_redis_password:/baserow/.your_redis_password \
  -v $PWD/.your_secret_key:/baserow/.your_secret_key \
  -v $PWD/.your_pg_password:/baserow/.your_pg_password \

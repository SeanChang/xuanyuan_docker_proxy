---
image: amancevice/superset
description: "基于Debian和Python3环境的Apache Superset镜像，提供数据可视化与探索功能，适用于数据分析及BI工作。"
source: https://xuanyuan.cloud/zh/r/amancevice/superset
canonical: https://xuanyuan.cloud/zh/r/amancevice/superset
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amancevice/superset" title="amancevice/superset Docker 镜像中文简介、标签列表与拉取命令">amancevice/superset 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Superset Docker 镜像文档


## 镜像概述与主要用途

`amancevice/superset` 是一个非官方的 Docker 镜像，用于部署 [Apache Superset](https://github.com/apache/superset) 数据可视化平台。该镜像基于 Debian 和 Python 3 构建，提供了 Superset 的容器化运行环境，旨在简化 Superset 的部署与管理流程。

**主要用途**：提供 Superset 的开箱即用容器化方案，支持快速部署、自定义配置及与多种数据库集成，适用于开发、测试及生产环境的数据可视化平台搭建。


## 核心功能与特性

- **版本同步**：镜像标签与 Superset 版本一一对应（如 `amancevice/superset:0.18.5` 对应 Superset 0.18.5 版本），便于版本管理。
- **可扩展性**：支持通过编写自定义 Dockerfile 扩展镜像，满足个性化需求（如添加依赖、配置修改等）。
- **卷定义**：内置两个数据卷，分别用于挂载配置文件（`/etc/superset` 或 `/home/superset`）和存储应用数据（`/var/lib/superset`，即 `SUPERSET_HOME`）。
- **初始化工具**：提供 `superset-init` 脚本，简化数据库初始化及管理员用户创建流程。
- **多数据库支持**：示例配置包含 MySQL、PostgreSQL、SQLite 集成方案，可灵活适配不同数据源。


## 使用场景与适用范围

- **数据可视化平台部署**：快速搭建 Superset 服务，实现数据探索与可视化。
- **开发/测试环境**：通过容器化快速部署隔离的 Superset 实例，便于功能测试和配置验证。
- **生产环境**：支持自定义配置（如数据库连接、权限管理），结合数据卷持久化数据，满足生产级稳定性需求。
- **扩展需求场景**：需添加自定义 Python 依赖、修改系统配置的场景，可通过扩展镜像实现。


## 使用方法与配置说明

### 下载镜像

从 Docker 仓库拉取指定版本的镜像：

```bash
docker pull docker.xuanyuan.run/amancevice/superset:<version>
```

> 替换 `<version>` 为具体的 Superset 版本号（如 `0.18.5`），或使用 `latest` 获取最新版本。


### 构建扩展镜像

不建议直接基于源码构建镜像，推荐通过扩展现有镜像添加自定义逻辑。示例 Dockerfile：

```Dockerfile
FROM docker.xuanyuan.run/amancevice/superset:<version>
USER root
# 添加自定义依赖或配置（如安装 pip 包）
RUN pip install <package-name>
# 其他修改...
USER superset  # 切换回非特权用户
```


### 配置说明

#### 核心配置文件

Superset 的配置通过 `superset_config.py` 文件定义，需挂载到容器内的配置卷。该文件需包含 Superset 的核心配置（如数据库连接、密钥、日志设置等），具体配置项参考 [Apache Superset 官方文档](https://superset.apache.org/installation.html#configuration)。

#### 配置卷与环境变量

- **配置卷**：容器内 `/etc/superset` 或 `/home/superset` 目录已加入 `PYTHONPATH`，挂载包含 `superset_config.py` 的本地目录至任一位置即可：
  ```bash
  docker run -v /path/to/local/config:/etc/superset ...
  ```

- **数据卷**：`/var/lib/superset` 为数据卷（对应环境变量 `SUPERSET_HOME`），用于存储日志、SQLite 数据库文件等持久化数据，建议挂载本地目录或命名卷：
  ```bash
  docker run -v superset-data:/var/lib/superset ...
  ```


### 数据库初始化

启动容器后，需通过 `superset-init` 脚本初始化数据库（创建管理员用户及基础表结构）：

```bash
# 启动容器
docker run --detach --name superset -p 8088:8088 -v /path/to/config:/etc/superset -v superset-data:/var/lib/superset docker.xuanyuan.run/amancevice/superset:<version>

# 初始化数据库
docker exec -it superset superset-init
```

执行后按提示设置管理员用户名、密码、邮箱等信息。


### 升级步骤

升级 Superset 版本需执行以下步骤：

1. **拉取新版本镜像**：
   ```bash
   docker pull docker.xuanyuan.run/amancevice/superset:<new-version>
   ```

2. **停止并移除旧容器**：
   ```bash
   docker rm -f superset-old  # 假设旧容器名为 superset-old
   ```

3. **启动新容器**（使用相同的卷挂载以保留数据）：
   ```bash
   docker run --detach --name superset-new -p 8088:8088 -v /path/to/config:/etc/superset -v superset-data:/var/lib/superset docker.xuanyuan.run/amancevice/superset:<new-version>
   ```

4. **升级数据库结构与权限**：
   ```bash
   # 升级数据库 schema
   docker exec superset-new superset db upgrade
   # 同步基础权限
   docker exec superset-new superset init
   ```


## 部署示例

### 基础部署（SQLite）

使用默认 SQLite 数据库（适用于测试环境）：

```bash
docker run -d \
  --name superset \
  -p 8088:8088 \
  -v superset-config:/etc/superset \  # 挂载配置卷（若需自定义配置）
  -v superset-data:/var/lib/superset \  # 挂载数据卷（持久化 SQLite 数据）
  amancevice/superset:<version>

# 初始化数据库
docker exec -it superset superset-init
```

访问 `http://localhost:8088` 即可打开 Superset 界面。


### 多数据库配置示例

镜像 `examples` 目录提供了 MySQL、PostgreSQL、SQLite 的完整配置示例，包含 `docker-compose.yml` 及 `superset_config.py` 模板，可参考以下路径：  
[examples 目录](https://github.com/amancevice/docker-superset/tree/main/examples)（需克隆源码仓库查看）。


## 版本说明

镜像标签与 Superset 版本严格对应，例如：
- `amancevice/superset:0.18.5` 对应 Superset 0.18.5 版本。
- `latest` 标签通常与最新 Superset 语义化版本同步，可能包含镜像自身的功能更新。


## 问题反馈

1. **反馈范围**：仅接受与 Docker 部署相关的问题（如容器启动失败、卷挂载异常等），需附带上报问题时的 Docker 命令或 `docker-compose` 配置（注意脱敏敏感信息）。
2. **Superset 本身问题**：直接在 [Apache Superset 源码仓库](https://github.com/apache/superset) 提交 issue。
3. **功能扩展建议**：如需添加 Python 依赖或配置优化，建议通过 [Pull Request](https://github.com/amancevice/docker-superset/pulls) 贡献代码，不接受“添加 pip 包”类 issue。

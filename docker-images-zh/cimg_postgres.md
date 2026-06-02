---
image: cimg/postgres
description: "CircleCI便捷镜像，集成PostgreSQL数据库，用于CI/CD流程中快速部署和运行PostgreSQL相关的测试及开发任务，简化配置。"
source: https://xuanyuan.cloud/zh/r/cimg/postgres
canonical: https://xuanyuan.cloud/zh/r/cimg/postgres
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cimg/postgres" title="cimg/postgres Docker 镜像中文简介、标签列表与拉取命令">cimg/postgres — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/cimg/postgres" title="cimg/postgres Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/cimg/postgres</a>

# cimg/postgres - CircleCI PostgreSQL 镜像

<div align="center">
	<h1>CircleCI 便捷镜像 => PostgreSQL</h1>
	<h3>专为 CircleCI 构建的专注于持续集成的 PostgreSQL Docker 镜像</h3>
</div>

[![CircleCI 构建状态](https://circleci.com/gh/CircleCI-Public/cimg-postgres.svg?style=shield)](https://circleci.com/gh/CircleCI-Public/cimg-postgres) [![软件许可证](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-postgres/master/LICENSE) [![Docker 拉取量](https://img.shields.io/docker/pulls/cimg/postgres)](https://hub.docker.com/r/cimg/postgres) [![CircleCI 社区](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/circleci-images) [![代码仓库](https://img.shields.io/badge/github-README-brightgreen)](https://github.com/CircleCI-Public/cimg-postgres)

此镜像旨在替代旧版 CircleCI PostgreSQL 镜像 `circleci/postgres`。

`cimg/postgres` 是由 CircleCI 创建的 Docker 镜像，专为持续集成构建场景设计。


## 目录

- [镜像概述和主要用途](#镜像概述和主要用途)
- [核心功能和特性](#核心功能和特性)
- [使用场景和适用范围](#使用场景和适用范围)
- [详细的使用方法和配置说明](#详细的使用方法和配置说明)
- [开发指南](#开发指南)
- [贡献](#贡献)
- [其他资源](#其他资源)
- [许可证](#许可证)


## 镜像概述和主要用途

`cimg/postgres` 是 CircleCI 官方维护的 PostgreSQL Docker 镜像，专为持续集成（CI）环境优化。该镜像包含完整的 PostgreSQL 数据库服务及其工具链，旨在作为 CircleCI 工作流中的次要容器，为应用程序提供可靠的数据库服务支持。

此镜像的主要用途是在 CI 流程中快速部署 PostgreSQL 实例，用于应用程序的集成测试、数据迁移验证等场景，替代了旧版 `circleci/postgres` 镜像，提供更精简的配置和更贴合 CI 需求的优化。


## 核心功能和特性

### 完整的 PostgreSQL 工具链
包含 PostgreSQL 数据库服务器、客户端工具（`psql`）、备份工具（`pg_dump`、`pg_restore`）及配置管理工具，满足数据库操作全流程需求。

### 变体支持
提供针对特定场景优化的镜像变体：

#### PostGIS 变体
在基础 PostgreSQL 镜像上预安装 PostGIS 空间数据库扩展及其依赖（如 GEOS、PROJ、GDAL），适用于地理信息处理场景。通过在标签后添加 `-postgis` 标识使用，例如 `cimg/postgres:13.1-postgis`。

#### RAM 变体（已移除）
旧版 `circleci/postgres` 镜像提供的 RAM 变体已不再支持。CircleCI 正在评估该变体的实际性能提升效果，未来可能根据社区反馈重新引入。

### 明确的标签方案
采用基于 PostgreSQL 版本的标签命名，格式为：
```
cimg/postgres:<pg-version>
```
其中 `<pg-version>` 为具体 PostgreSQL 版本号（如 `13.2`），确保版本选择清晰可预测。


## 使用场景和适用范围

### 典型使用场景
- **CI 集成测试**：作为 CircleCI 作业的次要容器，为应用程序提供临时数据库服务，用于测试数据读写、迁移脚本验证等。
- **开发环境一致性**：本地开发时通过 Docker 快速启动标准化的 PostgreSQL 环境，避免版本差异导致的兼容性问题。
- **空间数据应用测试**：使用 PostGIS 变体测试依赖地理信息查询的应用功能。

### 适用范围
- 支持 CircleCI `docker` 执行器，需作为次要镜像与主应用镜像配合使用。
- 兼容 PostgreSQL 客户端协议，可通过标准数据库连接方式（如 JDBC、ODBC、psycopg2 等）访问。
- 适用于需要轻量级、临时数据库服务的自动化流程，不建议用于生产环境。


## 详细的使用方法和配置说明

### 在 CircleCI 中使用

#### 基础配置
作为次要镜像与主应用镜像配合，示例配置（YAML）：
```yaml
jobs:
  build:
    docker:
      - image: cimg/go:1.17  # 主应用镜像（此处以 Go 为例）
      - image: cimg/postgres:13.2  # PostgreSQL 次要镜像
    steps:
      - checkout  # 检出代码
      - run:  # 测试数据库连接
          name: 验证 PostgreSQL 连接
          command: |
            # 安装 psql 客户端（若主镜像未预装）
            sudo apt-get update && sudo apt-get install -y postgresql-client
            # 连接数据库（默认用户：postgres，密码：postgres，数据库名：postgres）
            psql -h localhost -U postgres -d postgres -c "SELECT version();"
```

#### 使用 PostGIS 变体
配置示例：
```yaml
jobs:
  build:
    docker:
      - image: cimg/python:3.9
      - image: cimg/postgres:13.1-postgis  # PostGIS 变体
    steps:
      - checkout
      - run:
          name: 验证 PostGIS 安装
          command: |
            psql -h localhost -U postgres -d postgres -c "SELECT postgis_version();"
```

### 本地开发使用

#### 拉取镜像
```bash
docker pull cimg/postgres:13.2
```

#### 启动容器
```bash
docker run -d \
  -p 5432:5432 \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_DB=mydb \
  --name pg-test \
  cimg/postgres:13.2
```
**环境变量说明**：
- `POSTGRES_USER`：默认数据库用户（未指定时为 `postgres`）。
- `POSTGRES_PASSWORD`：用户密码（未指定时为 `postgres`）。
- `POSTGRES_DB`：默认数据库名（未指定时与 `POSTGRES_USER` 同名）。

#### 连接数据库
通过 `psql` 客户端连接：
```bash
psql -h localhost -U myuser -d mydb -p 5432
```

### 本地构建镜像（开发场景）

#### 前提条件
- Linux（Ubuntu 测试通过）或 macOS 系统
- Bash 4+
- Docker Engine 19.03+

#### 克隆仓库
社区用户（无仓库写入权限）需先 Fork 仓库，再克隆（包含子模块）：
```bash
git clone --recurse-submodules <你的 Fork 仓库 URL>
cd cimg-postgres
```

#### 生成 Dockerfile
指定 PostgreSQL 版本生成对应 Dockerfile：
```bash
./shared/gen-dockerfiles.sh 13.2  # 生成 13.2 版本的 Dockerfile
```
生成的文件位于 `./13.2/Dockerfile`。

#### 构建并测试镜像
```bash
cd 13.2
docker build -t test/postgres:13.2 .  # 本地构建镜像
docker run -it test/postgres:13.2 bash  # 启动容器并进入交互终端
```


## 开发指南

### 构建镜像
使用仓库脚本批量构建镜像（需先生成 Dockerfile）：
```bash
./build-images.sh  # 构建所有生成的 Dockerfile 对应的镜像
```

### 发布镜像（仅维护者）
通过 `release.sh` 脚本自动化发布流程（以版本 `9.99` 为例）：
```bash
./shared/release.sh 9.99
```
该脚本会自动：
1. 创建新 Git 分支
2. 生成目标版本的 Dockerfile
3. 提交变更并推送到 GitHub（提交信息含 `[release]` 标识，触发 CircleCI 构建）
4. 构建通过后，合并 PR 即可自动发布镜像到 Docker Hub。

### 合并变更
- **构建脚本更新**：`./shared` 子模块的变更需通过更新子模块同步：
  ```bash
  cd shared && git pull && cd ..
  git add shared && git commit -m "更新 shared 子模块以支持 X 功能"
  ```
- **基础镜像变更**：基础镜像更新不会影响现有 PostgreSQL 镜像版本，新发布的镜像版本会自动继承最新基础镜像特性。
- **PostgreSQL 特定变更**：修改 `Dockerfile.template` 后需重新生成 Dockerfile 并测试。


## 贡献

欢迎通过 [GitHub Issues](https://github.com/CircleCI-Public/cimg-postgres/issues) 报告 bug 或提出功能请求，或通过 [Pull Requests](https://github.com/CircleCI-Public/cimg-postgres/pulls) 提交代码变更。注意：
- 新增工具需满足“广泛适用性”和“维护活跃度”标准，避免镜像体积过度膨胀。
- 重大变更建议先通过 Issue 讨论，确保符合项目方向。
- 技术支持请通过 [CircleCI Discuss](https://discuss.circleci.com/c/ecosystem/circleci-images) 社区获取。


## 其他资源
- [CircleCI 官方文档](https://circleci.com/docs/)
- [CircleCI 配置参考](https://circleci.com/docs/2.0/configuration-reference/#section=configuration)
- [Docker 官方文档](https://docs.docker.com/)
- [PostgreSQL 官方文档](https://www.postgresql.org/docs/)
- [PostGIS 官方文档](https://postgis.net/documentation/)


## 许可证
本仓库采用 MIT 许可证，详情参见 [LICENSE](./LICENSE)。


## 致谢
本镜像使用了 [docker-library/postgres](https://github.com/docker-library/postgres) 项目的 `docker-entrypoint.sh` 脚本。

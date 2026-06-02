<!-- xuanyuan-docker-images-zh
image: nodejs/devcontainer
source: https://xuanyuan.cloud/zh/r/nodejs/devcontainer
canonical: https://xuanyuan.cloud/zh/r/nodejs/devcontainer
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/nodejs/devcontainer" title="nodejs/devcontainer Docker 镜像中文简介、标签列表与拉取命令">nodejs/devcontainer — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/nodejs/devcontainer" title="nodejs/devcontainer Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nodejs/devcontainer</a></p>

# Node.js Dev Container 镜像文档


## 镜像概述和主要用途

Node.js Dev Container 是由 Node.js 官方维护的开发容器配置集合，旨在为 Node.js 项目提供**标准化、可复现的开发环境**。该镜像基于微软 Dev Container 规范构建，集成了 Node.js 运行时、常用开发工具及配置模板，可直接与 VS Code Dev Containers 扩展或 GitHub Codespaces 配合使用，帮助开发者快速搭建一致的本地或云端开发环境，避免因环境差异导致的"在我电脑上能运行"问题。


## 核心功能和特性

### 多版本 Node.js 支持
- 支持指定 Node.js 版本（从 v14 到最新 LTS 版本），通过构建参数灵活切换
- 预安装对应版本的 npm、yarn 包管理器，自动适配版本兼容性

### 开箱即用的开发工具链
- 集成基础工具：`git`、`curl`、`wget`、`build-essential`（编译依赖）
- 开发增强工具：`eslint`、`prettier`、`npm-check-updates`、`husky`（可选）
- 容器管理工具：`docker-cli`、`docker-compose`（支持容器内操作 Docker）

### 高度可定制化
- 通过 `devcontainer.json` 配置文件自定义环境（工具安装、扩展集成、用户权限等）
- 支持基于基础镜像添加自定义 Dockerfile 构建步骤（如安装项目特定依赖）
- 可集成第三方 Dev Container Features（如添加数据库、Redis 等服务）

### 安全与兼容性
- 默认使用非 root 用户（`node`）运行，避免权限风险
- 兼容 VS Code Dev Containers 扩展、GitHub Codespaces、JetBrains Gateway
- 支持 ARM64 和 AMD64 架构，适配主流开发设备

### 无缝开发体验
- 自动配置 VS Code 扩展推荐（如 ESLint、JavaScript Debugger）
- 支持代码热重载、断点调试（与本地开发体验一致）
- 保留容器内开发状态（如 node_modules、编译产物），重启不丢失


## 使用场景和适用范围

### 团队协作开发
- **解决环境不一致问题**：统一团队成员的 Node.js 版本、依赖工具链，避免"本地正常/CI 失败"问题
- **新人快速上手**：新成员无需手动配置环境，拉取代码后一键启动容器即可开发

### CI/CD 流程集成
- **开发环境与 CI 环境统一**：直接复用 Dev Container 配置作为 CI 构建环境，减少环境差异导致的构建失败
- **预验证构建流程**：在容器内本地模拟 CI 步骤，提前发现问题

### 多版本 Node.js 项目开发
- **并行维护多版本项目**：为不同 Node.js 版本的项目配置独立 Dev Container，避免本地 Node 版本冲突
- **版本迁移测试**：快速切换 Node.js 版本测试项目兼容性

### 教学与演示环境
- **快速复现开发场景**：讲师/演示者提供 Dev Container 配置，学员一键启动相同环境，专注内容学习而非环境配置
- **临时实验环境**：测试新工具或依赖时，在隔离容器内操作，不污染本地环境


## 详细使用方法和配置说明

### 前置条件
- 安装 Docker Desktop（[Windows](https://docs.docker.com/desktop/install/windows-install/) / [macOS](https://docs.docker.com/desktop/install/mac-install/) / [Linux](https://docs.docker.com/desktop/install/linux-install/)）
- 安装 VS Code 及 [Dev Containers 扩展](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)（或使用 GitHub Codespaces）
- （可选）安装 [Dev Container CLI](https://github.com/devcontainers/cli)（用于命令行管理容器）


### 基本使用方法

#### 方式 1：通过 VS Code 快速启动
1. 打开目标 Node.js 项目文件夹（本地或远程仓库）
2. 按 `F1` 打开命令面板，输入并选择 **Dev Containers: Add Dev Container Configuration Files...**
3. 在模板列表中选择 **Node.js**（或 Node.js & TypeScript），根据提示选择 Node.js 版本
4. VS Code 自动生成 `.devcontainer/devcontainer.json` 配置文件
5. 再次打开命令面板，选择 **Dev Containers: Reopen in Container**，等待容器构建完成后即可开始开发


#### 方式 2：手动配置 `devcontainer.json`
在项目根目录创建 `.devcontainer/devcontainer.json` 文件，示例基础配置如下：
```json
{
  "name": "Node.js Dev Environment",
  "image": "mcr.microsoft.com/devcontainers/javascript-node:18", // 指定 Node.js 18 基础镜像
  "features": {
    "ghcr.io/devcontainers/features/git:1": {}, // 安装 git
    "ghcr.io/devcontainers/features/node:1": { "version": "18" } // 显式指定 Node.js 版本
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "dbaeumer.vscode-eslint", // ESLint 扩展
        "esbenp.prettier-vscode"  // Prettier 扩展
      ]
    }
  },
  "remoteUser": "node" // 使用非 root 用户运行
}
```


### Docker 部署方案示例

#### 基础 Docker Run 命令（手动启动容器）
```bash
# 拉取 Node.js 18 基础镜像并启动交互式终端
docker run -it --rm \
  -v "$(pwd):/workspace" \  # 挂载当前项目到容器内 /workspace
  -w /workspace \            # 设置工作目录
  mcr.microsoft.com/devcontainers/javascript-node:18 \
  bash
```


#### Docker Compose 多服务配置（Node.js + 数据库）
适用于需要数据库等依赖服务的 Node.js 项目，创建 `.devcontainer/docker-compose.yml`：
```yaml
version: '3.8'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile  # 自定义构建（可选）
    volumes:
      - ../..:/workspace:cached  # 挂载项目代码
    command: sleep infinity      # 保持容器运行
    depends_on:
      - db  # 依赖数据库服务
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgres://user:password@db:5432/mydb

  db:
    image: postgres:15
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=mydb
    volumes:
      - postgres-data:/var/lib/postgresql/data  # 持久化数据库数据

volumes:
  postgres-data:
```

对应的 `.devcontainer/devcontainer.json` 需指定使用 Docker Compose：
```json
{
  "name": "Node.js + PostgreSQL",
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",  # 指定主服务
  "workspaceFolder": "/workspace",
  "remoteUser": "node"
}
```


### 配置参数说明（`devcontainer.json`）

| 参数路径                  | 说明                                                                 | 示例值                                  |
|---------------------------|----------------------------------------------------------------------|-----------------------------------------|
| `name`                    | 容器环境名称（显示在 VS Code 状态栏）                                | "Node.js Dev Env"                       |
| `image`                   | 基础镜像地址（若不使用本地构建）                                      | "mcr.microsoft.com/devcontainers/javascript-node:18" |
| `build`                   | 本地构建配置（替代 `image`）                                         | `{ "dockerfile": "Dockerfile", "args": { "NODE_VERSION": "18" } }` |
| `features`                | 集成额外工具（通过 Dev Container Features 市场）                     | `{ "ghcr.io/devcontainers/features/node:1": { "version": "18" }, "ghcr.io/devcontainers/features/git:1": {} }` |
| `customizations.vscode.extensions` | VS Code 扩展自动安装列表                           | `["dbaeumer.vscode-eslint", "esbenp.prettier-vscode"]` |
| `customizations.vscode.settings`   | VS Code 工作区设置                                 | `{ "editor.formatOnSave": true }`       |
| `remoteUser`              | 容器内运行用户（推荐使用非 root 用户 `node`）                        | "node"                                  |
| `containerEnv`            | 容器内环境变量                                                       | `{ "NODE_ENV": "development", "PORT": "3000" }` |
| `mounts`                  | 额外文件挂载（如本地 npm 缓存加速依赖安装）                          | `["source=${localEnv:HOME}/.npm,target=/home/node/.npm,type=bind"]` |
| `onCreateCommand`         | 容器创建后执行的命令（如安装项目依赖）                               | "npm install"                           |


### 环境变量说明

#### 构建时环境变量（通过 `build.args` 传递）
| 变量名          | 说明                  | 默认值              |
|-----------------|-----------------------|---------------------|
| `NODE_VERSION`  | Node.js 版本          | "lts"（最新 LTS 版本） |
| `NPM_VERSION`   | npm 版本              | 与 Node.js 版本匹配 |
| `YARN_VERSION`  | yarn 版本（可选安装） | 不安装              |
| `USER_UID`      | 非 root 用户 UID      | 1000                |
| `USER_GID`      | 非 root 用户 GID      | 1000                |


#### 运行时环境变量（通过 `containerEnv` 配置）
| 变量名          | 说明                  | 示例值              |
|-----------------|-----------------------|---------------------|
| `NODE_ENV`      | Node.js 运行环境      | "development"       |
| `PORT`          | 应用监听端口          | "3000"              |
| `DEBUG`         | 调试模式开关（如 `express:*`） | "app:*"         |


### 自定义构建示例（通过 Dockerfile）
若基础镜像不满足需求，可创建 `.devcontainer/Dockerfile` 自定义构建：
```dockerfile
# 基于 Node.js 18 基础镜像
FROM mcr.microsoft.com/devcontainers/javascript-node:18

# 安装额外系统依赖（如构建工具）
RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  make \
  g++ \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装全局 npm 包
RUN npm install -g pm2 nodemon

# 切换工作目录
WORKDIR /workspace

# 设置启动命令（可选）
CMD ["npm", "run", "dev"]
```

对应的 `devcontainer.json` 需指定构建配置：
```json
{
  "build": {
    "context": ".",
    "dockerfile": "Dockerfile",
    "args": { "NODE_VERSION": "18" }
  }
}
```


## 注意事项
1. **依赖缓存**：首次启动容器时会安装依赖（如 `npm install`），耗时较长；后续启动会复用缓存，速度更快。
2. **权限问题**：默认使用非 root 用户 `node`，若需修改文件权限，可通过 `sudo` 命令（容器内已预配置密码less sudo）。
3. **镜像更新**：基础镜像会定期更新，建议通过 `devcontainer.json` 锁定 Node.js 版本（如 `18` 而非 `lts`）以避免意外升级。
4. **性能优化**：本地开发时，通过 `mounts` 配置挂载本地 npm/yarn 缓存目录，可大幅加速依赖安装。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/nodejs/devcontainer" title="nodejs/devcontainer Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/nodejs/devcontainer</a></p>

---
image: arm64v8/node
description: "Node.js是基于JavaScript的平台，用于开发服务器端和网络应用。"
source: https://xuanyuan.cloud/zh/r/arm64v8/node
canonical: https://xuanyuan.cloud/zh/r/arm64v8/node
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/node" title="arm64v8/node Docker 镜像中文简介、标签列表与拉取命令">arm64v8/node 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm64v8/node Docker 镜像文档

## 镜像概述和主要用途

`arm64v8/node` 是 [Node.js 官方镜像](https://hub.docker.com/_/node) 的 `arm64v8` 架构专用版本，专为 ARM64v8 架构设备（如嵌入式系统、ARM 服务器）提供预配置的 Node.js 运行环境。该镜像支持多种 Node.js 版本和基础镜像变体，可直接用于部署 JavaScript 编写的服务器端应用、网络服务及微服务。

## 核心功能和特性

- **异步非阻塞 I/O**：采用事件驱动模型，高效处理并发连接，适合高吞吐量应用场景。
- **V8 引擎**：内置 Google V8 JavaScript 引擎，确保代码高效执行。
- **跨平台兼容**：应用代码无需修改即可在不同操作系统的 Node.js 运行时中运行。
- **内置网络支持**：原生支持 HTTP、TCP/UDP 等协议，可直接作为 Web 服务器运行。
- **npm 包管理**：集成 npm 包管理器，便捷安装第三方模块。

## 支持的标签及对应 Dockerfile

### Node.js 25.x 系列（Current）
- **Alpine 基础镜像**
  - [`25-alpine3.21`, `25.0-alpine3.21`, `25.0.0-alpine3.21`, `alpine3.21`, `current-alpine3.21`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/alpine3.21/Dockerfile)
  - [`25-alpine`, `25-alpine3.22`, `25.0-alpine`, `25.0-alpine3.22`, `25.0.0-alpine`, `25.0.0-alpine3.22`, `alpine`, `alpine3.22`, `current-alpine`, `current-alpine3.22`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/alpine3.22/Dockerfile)

- **Debian Bookworm 基础镜像**
  - [`25`, `25-bookworm`, `25.0`, `25.0-bookworm`, `25.0.0`, `25.0.0-bookworm`, `bookworm`, `current`, `current-bookworm`, `latest`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/bookworm/Dockerfile)
  - **Slim 变体**：[`25-bookworm-slim`, `25-slim`, `25.0-bookworm-slim`, `25.0-slim`, `25.0.0-bookworm-slim`, `25.0.0-slim`, `bookworm-slim`, `current-bookworm-slim`, `current-slim`, `slim`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/bookworm-slim/Dockerfile)

- **Debian Bullseye 基础镜像**
  - [`25-bullseye`, `25.0-bullseye`, `25.0.0-bullseye`, `bullseye`, `current-bullseye`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/bullseye/Dockerfile)
  - **Slim 变体**：[`25-bullseye-slim`, `25.0-bullseye-slim`, `25.0.0-bullseye-slim`, `bullseye-slim`, `current-bullseye-slim`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/bullseye-slim/Dockerfile)

- **Debian Trixie 基础镜像**
  - [`25-trixie`, `25.0-trixie`, `25.0.0-trixie`, `current-trixie`, `trixie`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/trixie/Dockerfile)
  - **Slim 变体**：[`25-trixie-slim`, `25.0-trixie-slim`, `25.0.0-trixie-slim`, `current-trixie-slim`, `trixie-slim`](https://github.com/nodejs/docker-node/blob/eda40f3c41d33cb595232cb7000ab31af1ce2f02/25/trixie-slim/Dockerfile)

### Node.js 24.x 系列
- **Alpine 基础镜像**：[`24-alpine3.21`, `24.10-alpine3.21`, `24.10.0-alpine3.21`, `24-alpine`, `24-alpine3.22`, `24.10-alpine`, `24.10-alpine3.22`, `24.10.0-alpine`, `24.10.0-alpine3.22`](https://github.com/nodejs/docker-node/blob/199ce7af0ac3726aed4552f3c420b83726c8696c/24/alpine3.21/Dockerfile)
- **Debian 基础镜像**：`bookworm`/`bullseye`/`trixie` 及对应 `slim` 变体（标签及 Dockerfile 链接参见 [官方文档](https://github.com/nodejs/docker-node)）

### Node.js 22.x 系列（LTS）
- **Alpine 基础镜像**：[`22-alpine3.21`, `22.20-alpine3.21`, `22.20.0-alpine3.21`, `jod-alpine3.21`, `lts-alpine3.21`, `22-alpine`, `22-alpine3.22`, ...](https://github.com/nodejs/docker-node/blob/693bac3a72a7138805c4c2791bc81f21291ae273/22/alpine3.21/Dockerfile)
- **Debian 基础镜像**：`bookworm`/`bullseye`/`trixie` 及对应 `slim` 变体（含 `lts`/`jod` 标签）

### Node.js 20.x 系列（LTS）
- **Alpine 基础镜像**：[`20-alpine3.21`, `20.19-alpine3.21`, `20.19.5-alpine3.21`, `iron-alpine3.21`, `20-alpine`, `20-alpine3.22`, ...](https://github.com/nodejs/docker-node/blob/16ff3548d60b86d2bb9fd0e51fa9153df69ef3cd/20/alpine3.21/Dockerfile)
- **Debian 基础镜像**：`bookworm`/`bullseye`/`trixie` 及对应 `slim` 变体（含 `iron` 标签）

## 快速参考

- **维护者**：[Node.js Docker 团队](https://github.com/nodejs/docker-node)
- **获取帮助**：[Docker 社区 Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux Stack Exchange](https://unix.stackexchange.com/help/on-topic)、[Stack Overflow](https://stackoverflow.com/help/on-topic)
- **问题反馈**：[https://github.com/nodejs/docker-node/issues](https://github.com/nodejs/docker-node/issues?q=)
- **支持架构**：`amd64`, `arm32v6`, `arm32v7`, `arm64v8`, `ppc64le`, `s390x`（详情参见 [官方镜像架构文档](https://github.com/docker-library/official-images#architectures-other-than-amd64)）
- **镜像更新**：通过 [official-images 仓库 `library/node` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fnode) 跟踪
- **镜像元数据**：[repo-info 仓库 `node` 目录](https://github.com/docker-library/repo-info/blob/master/repos/node)（含传输大小、构建信息等）

## 使用场景和适用范围

- **实时应用**：聊天系统、实时通知服务，利用异步 I/O 处理高并发连接。
- **API 服务**：构建轻量级 RESTful/GraphQL API，支持高吞吐量请求。
- **微服务节点**：作为微服务架构中的独立节点，与其他服务通信。
- **开发环境**：快速搭建一致的 Node.js 开发环境，避免版本冲突。
- **ARM64v8 设备部署**：树莓派、ARM 服务器等硬件的优化部署。

## 使用方法和配置说明

### 基本运行命令

#### 交互式终端
```bash
docker run -it --rm docker.xuanyuan.run/arm64v8/node:25 node
```

#### 运行本地应用
```bash
# 挂载当前目录到容器 /app，运行 npm start
docker run -it --rm -v "$PWD":/app -w /app docker.xuanyuan.run/arm64v8/node:25 npm start
```

### 构建自定义镜像

创建 `Dockerfile`：
```dockerfile
FROM docker.xuanyuan.run/arm64v8/node:25-alpine

WORKDIR /app

# 复制依赖文件并安装
COPY package*.json ./
RUN npm install --production

# 复制应用代码
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
```

构建并运行：
```bash
docker build -t my-node-app .
docker run -p 3000:3000 docker.xuanyuan.run/my-node-app
```

### Docker Compose 配置示例

`docker-compose.yml`：
```yaml
version: '3'
services:
  app:
    image: docker.xuanyuan.run/arm64v8/node:25
    volumes:
      - ./:/app
    working_dir: /app
    ports:
      - "3000:3000"
    command: npm run dev
    environment:
      - NODE_ENV=development
      - DB_HOST=db
  db:
    image: docker.xuanyuan.run/arm64v8/mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=pass
```

启动：
```bash
docker-compose up
```

### 环境变量

- `NODE_ENV`：运行环境（`production`/`development`），影响依赖安装行为。
- `PORT`：应用监听端口，需配合 `-p` 参数映射。
- `npm_config_*`：npm 配置参数（如 `npm_config_registry=https://registry.npm.taobao.org`）。

## 镜像变体

### `arm64v8/node:<version>`（默认变体）
- **基础**：Debian 发行版（`bookworm`/`bullseye`/`trixie`）。
- **特点**：包含 `buildpack-deps`，适合大多数场景，平衡功能与体积。
- **适用**：生产环境，需系统工具或 glibc 兼容性的应用。

### `arm64v8/node:<version>-alpine`
- **基础**：[Alpine Linux](https://alpinelinux.org/)（~5MB 基础镜像）。
- **特点**：极小体积，使用 musl libc（部分依赖可能不兼容）。
- **适用**：对镜像大小敏感，无复杂系统依赖的应用。
- **注意**：需通过 `apk add` 手动安装额外工具（如 `git`）。

### `arm64v8/node:<version>-slim`
- **基础**：精简 Debian 镜像。
- **特点**：仅含 Node.js 运行必需依赖，体积小于默认变体。
- **适用**：空间受限且需 glibc 兼容性的场景。

## 许可证信息

- **Node.js 许可证**：[MIT 许可证](https://github.com/nodejs/node/blob/master/LICENSE)
- **Docker 项目许可证**：[Node.js Docker 许可证](https://github.com/nodejs/docker-node/blob/master/LICENSE)

镜像包含的第三方软件（如 Debian 系统工具）的许可证需由用户自行确认合规性。

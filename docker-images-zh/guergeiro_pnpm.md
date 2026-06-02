<!-- xuanyuan-docker-images-zh
image: guergeiro/pnpm
source: https://xuanyuan.cloud/zh/r/guergeiro/pnpm
canonical: https://xuanyuan.cloud/zh/r/guergeiro/pnpm
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/guergeiro/pnpm" title="guergeiro/pnpm Docker 镜像中文简介、标签列表与拉取命令">guergeiro/pnpm — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/guergeiro/pnpm" title="guergeiro/pnpm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/guergeiro/pnpm</a></p>

# guergeiro/pnpm 镜像文档

## 镜像概述

guergeiro/pnpm 是将 Node.js 运行时与 pnpm 包管理器捆绑的 Docker 镜像，旨在简化 Node.js 应用的开发、构建与部署流程，无需手动安装 pnpm。

## 核心功能与特性

- **集成环境**：预安装 Node.js 和 pnpm，开箱即可使用
- **多版本支持**：提供 Node.js 18.x、20.x、22.x 等系列版本，适配不同项目需求
- **多镜像变体**：提供默认、Alpine Linux 基础、Slim 最小化三种变体，满足不同场景对镜像体积和功能的需求
- **架构兼容性**：基于 Node 官方镜像构建，支持其原生架构
- **版本同步**：遵循 Node.js 发布计划和 pnpm 兼容性列表提供支持

## 支持的标签

### 默认变体
基于标准 Node 镜像，包含常用系统依赖：
- `18-6`, `18-7`, `18-8`, `18-9`, `18-10` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile))
- `20-7`, `20-8`, `20-9`, `20-10` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile))
- `22-8`, `22-9`, `22-10`, `lts-latest` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile))
- `latest-latest`, `current-latest` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile))

### Alpine 变体
基于 Alpine Linux，体积更小，适合资源受限环境：
- `18-6-alpine`, `18-7-alpine`, `18-8-alpine`, `18-9-alpine`, `18-10-alpine` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_alpine))
- `20-7-alpine`, `20-8-alpine`, `20-9-alpine`, `20-10-alpine` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_alpine))
- `22-8-alpine`, `22-9-alpine`, `22-10-alpine`, `lts-latest-alpine` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_alpine))
- `current-latest-alpine` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_alpine))

### Slim 变体
仅包含运行 Node.js 所需最小依赖，平衡体积与兼容性：
- `18-6-slim`, `18-7-slim`, `18-8-slim`, `18-9-slim`, `18-10-slim` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_slim))
- `20-7-slim`, `20-8-slim`, `20-9-slim`, `20-10-slim` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_slim))
- `22-8-slim`, `22-9-slim`, `22-10-slim`, `lts-latest-slim` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_slim))
- `current-latest-slim` ([Dockerfile](https://github.com/Guergeiro/docker-images/blob/master/./Dockerfile_slim))

## 使用场景

- **开发环境**：快速搭建标准化 Node.js + pnpm 开发环境，避免本地环境差异
- **CI/CD 流水线**：在持续集成流程中用于依赖安装、代码构建和自动化测试
- **生产部署**：根据资源需求选择合适变体（如 Alpine 用于轻量级部署，Slim 用于平衡体积与兼容性）

## 使用方法

### 基本使用（Dockerfile）

在 Node.js 项目中创建 `Dockerfile`：

```dockerfile
# 指定基础镜像（替换为所需版本）
FROM guergeiro/pnpm:22-10

# 复制项目文件
COPY . .

# 安装依赖
RUN pnpm install

# 启动应用
CMD ["pnpm", "start"]
```

### 构建与运行

```console
# 构建镜像
$ docker build -t my-nodejs-app .

# 运行容器
$ docker run -it --rm --name my-running-app my-nodejs-app
```

### Docker Compose 示例

创建 `docker-compose.yml`：

```yaml
version: '3.8'
services:
  app:
    build: 
      context: .
      dockerfile: Dockerfile
    image: my-nodejs-app
    container_name: node-app
    restart: unless-stopped
    ports:
      - "3000:3000"  # 根据应用端口调整
    volumes:
      - ./:/app      # 开发环境挂载代码目录（生产环境可移除）
    command: pnpm start
```

启动服务：

```console
$ docker-compose up -d
```

## 镜像变体说明

### 默认变体（`guergeiro/pnpm:<node-version>-<pnpm-version>`）
- **特点**：基于标准 Node 镜像，包含完整系统依赖和工具链
- **适用场景**：需要完整系统工具的开发环境或生产部署

### Alpine 变体（`-alpine`）
- **特点**：基于 Alpine Linux，体积显著减小（通常比默认镜像小 50% 以上），但部分原生依赖可能需要额外编译工具
- **适用场景**：资源受限环境（如边缘设备、轻量级容器平台），对镜像体积有严格要求的场景

### Slim 变体（`-slim`）
- **特点**：仅包含运行 Node.js 所需的最小依赖，移除了默认镜像中的大部分系统工具
- **适用场景**：需要减小镜像体积，但依赖部分系统库的场景（兼容性优于 Alpine）

## 支持与反馈

- **维护者**：[Breno Salles](https://brenosalles.com)
- **获取帮助**：[GitHub Discussions](https://github.com/Guergeiro/docker-images/discussions)
- **提交 Issue**：[GitHub Issues](https://github.com/Guergeiro/docker-images/issues)
- **支持架构**：继承自 [Node 官方镜像](https://hub.docker.com/_/node) 的架构支持

## 注意事项

- **版本兼容性**：镜像支持基于 [Node.js 发布计划](https://github.com/nodejs/release#release-schedule) 和 [pnpm 兼容性列表](https://pnpm.io/installation#compatibility)
- **特殊版本标签**：`lts-latest`、`latest-latest`、`current-latest` 等标签仅对应最新版本的 pnpm，不支持历史 pnpm 版本

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/guergeiro/pnpm" title="guergeiro/pnpm Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/guergeiro/pnpm</a></p>

---
image: arm32v6/python
description: "提供解释型、交互式、面向对象的开源Python编程语言环境，适用于各类编程开发。"
source: https://xuanyuan.cloud/zh/r/arm32v6/python
canonical: https://xuanyuan.cloud/zh/r/arm32v6/python
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm32v6/python" title="arm32v6/python Docker 镜像中文简介、标签列表与拉取命令">arm32v6/python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm32v6/python Docker镜像文档


## 1. 镜像概述和主要用途

`arm32v6/python` 是 [Python 官方 Docker 镜像](https://hub.docker.com/_/python) 的 `arm32v6` 架构专用版本，专为 32 位 ARMv6 架构设备（如嵌入式系统、树莓派等）设计。该镜像基于 Python 官方源代码构建，提供了轻量、可靠的 Python 运行环境，支持多版本 Python 解释器，可作为开发或生产环境中运行 Python 应用的基础容器。


## 2. 核心功能和特性

### 2.1 多版本 Python 支持
涵盖 Python 3.9 至 3.15-rc 等多个版本，满足不同应用的版本依赖需求。

### 2.2 多样化镜像变体
提供两种基础镜像变体，适配不同场景：
- **标准变体**：基于 `buildpack-deps`，包含丰富的系统依赖（如编译器、库文件），适合需要完整系统工具链的应用。
- **Alpine 变体**：基于 Alpine Linux，体积极小（约 5MB 基础镜像），适合资源受限的嵌入式环境或轻量化应用。

### 2.3 灵活的标签体系
标签格式清晰，包含 Python 版本、基础镜像版本等信息（如 `3.14-alpine3.22` 表示 Python 3.14 + Alpine 3.22），便于版本管理和选择。

### 2.4 架构针对性优化
专为 ARMv6 架构编译，确保在树莓派 Zero、旧款 ARM 嵌入式设备等硬件上高效运行。


## 3. 使用场景和适用范围

### 3.1 嵌入式设备开发
适用于 ARMv6 架构的嵌入式设备（如树莓派 Zero、ARM 微控制器），部署 Python 脚本或应用。

### 3.2 轻量化应用部署
Alpine 变体适合对镜像体积敏感的场景（如边缘计算、低存储设备），减少资源占用。

### 3.3 完整依赖应用
标准变体（非 Alpine）适合需要系统级依赖（如 `libssl`、`gcc`）的应用，避免手动安装依赖的繁琐。

### 3.4 临时任务执行
可直接作为临时容器运行 Python 脚本（如数据处理、自动化任务），无需持久化环境配置。


## 4. 使用方法和配置说明

### 4.1 通过 Dockerfile 构建应用镜像

#### 4.1.1 使用标准变体
```dockerfile
# 基于 Python 3.14 标准镜像
FROM docker.xuanyuan.run/arm32v6/python:3.14

# 设置工作目录
WORKDIR /usr/src/app

# 复制依赖文件并安装
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 运行应用
CMD ["python", "app.py"]
```

#### 4.1.2 使用 Alpine 变体（轻量化）
```dockerfile
# 基于 Python 3.14 Alpine 镜像
FROM docker.xuanyuan.run/arm32v6/python:3.14-alpine3.22

# 设置工作目录
WORKDIR /usr/src/app

# 安装系统依赖（Alpine 需使用 apk）
RUN apk add --no-cache gcc musl-dev  # 如需编译 C 扩展

# 复制依赖文件并安装
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 运行应用
CMD ["python", "app.py"]
```

构建并运行：
```bash
docker build -t my-arm-python-app .
docker run -it --rm --name my-app docker.xuanyuan.run/my-arm-python-app
```

### 4.2 直接运行单个 Python 脚本
无需构建镜像，直接挂载本地脚本并运行：
```bash
# 运行当前目录下的 script.py（使用 Python 3.14 Alpine 镜像）
docker run -it --rm \
  -v "$PWD":/usr/src/myapp \
  -w /usr/src/myapp \
  docker.xuanyuan.run/arm32v6/python:3.14-alpine \
  python script.py
```

### 4.3 Docker Compose 部署示例
创建 `docker-compose.yml`：
```yaml
version: '3'
services:
  python-app:
    image: docker.xuanyuan.run/arm32v6/python:3.14-alpine
    volumes:
      - ./app:/usr/src/app
    working_dir: /usr/src/app
    command: python app.py
    environment:
      - PYTHONUNBUFFERED=1  # 禁用输出缓冲，确保日志实时输出
      - PYTHONPATH=/usr/src/app/lib  # 添加自定义模块路径
```

启动服务：
```bash
docker-compose up
```

### 4.4 环境变量配置
常用 Python 相关环境变量：
- `PYTHONPATH`：指定 Python 模块搜索路径（如 `/usr/src/app/lib`）。
- `PYTHONUNBUFFERED`：设为 `1` 禁用标准输出缓冲，适用于日志收集。
- `PYTHONDONTWRITEBYTECODE`：设为 `1` 禁止生成 `.pyc` 文件，减少磁盘占用。


## 5. 支持的标签

### 5.1 基础标签（Simple Tags）
以下标签按 Python 版本和基础镜像分类，链接指向对应 Dockerfile 源码：

- **Python 3.15-rc（预览版）**
  - `3.15.0a1-alpine3.22`, `3.15-rc-alpine3.22`, `3.15.0a1-alpine`, `3.15-rc-alpine` [Dockerfile](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/alpine3.22/Dockerfile)
  - `3.15.0a1-alpine3.21`, `3.15-rc-alpine3.21` [Dockerfile](https://github.com/docker-library/python/blob/303456576fd52b3e000639d5cfdf384442e730d7/3.15-rc/alpine3.21/Dockerfile)

- **Python 3.14（稳定版）**
  - `3.14.0-alpine3.22`, `3.14-alpine3.22`, `3-alpine3.22`, `alpine3.22`, `3.14.0-alpine`, `3.14-alpine`, `3-alpine`, `alpine` [Dockerfile](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/alpine3.22/Dockerfile)
  - `3.14.0-alpine3.21`, `3.14-alpine3.21`, `3-alpine3.21`, `alpine3.21` [Dockerfile](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.14/alpine3.21/Dockerfile)

- **Python 3.13**
  - `3.13.8-alpine3.22`, `3.13-alpine3.22`, `3.13.8-alpine`, `3.13-alpine` [Dockerfile](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.13/alpine3.22/Dockerfile)
  - `3.13.8-alpine3.21`, `3.13-alpine3.21` [Dockerfile](https://github.com/docker-library/python/blob/a83345bce8e75b407f283511dc3128b2062d8c1e/3.13/alpine3.21/Dockerfile)

- **Python 3.12**
  - `3.12.12-alpine3.22`, `3.12-alpine3.22`, `3.12.12-alpine`, `3.12-alpine` [Dockerfile](https://github.com/docker-library/python/blob/e4ab0fe5ef4df797ed09883becf983a56ab97eca/3.12/alpine3.22/Dockerfile)
  - `3.12.12-alpine3.21`, `3.12-alpine3.21` [Dockerfile](https://github.com/docker-library/python/blob/e4ab0fe5ef4df797ed09883becf983a56ab97eca/3.12/alpine3.21/Dockerfile)

- **Python 3.11**
  - `3.11.14-alpine3.22`, `3.11-alpine3.22`, `3.11.14-alpine`, `3.11-alpine` [Dockerfile](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.11/alpine3.22/Dockerfile)
  - `3.11.14-alpine3.21`, `3.11-alpine3.21` [Dockerfile](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.11/alpine3.21/Dockerfile)

- **Python 3.10**
  - `3.10.19-alpine3.22`, `3.10-alpine3.22`, `3.10.19-alpine`, `3.10-alpine` [Dockerfile](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.10/alpine3.22/Dockerfile)
  - `3.10.19-alpine3.21`, `3.10-alpine3.21` [Dockerfile](https://github.com/docker-library/python/blob/54a65f4ff531391810946ee17b0806accbda0fae/3.10/alpine3.21/Dockerfile)

- **Python 3.9**
  - `3.9.24-alpine3.22`, `3.9-alpine3.22`, `3.9.24-alpine`, `3.9-alpine` [Dockerfile](https://github.com/docker-library/python/blob/00c4cce6b91488475bfaf85921bae12604a56d4a/3.9/alpine3.22/Dockerfile)
  - `3.9.24-alpine3.21`, `3.9-alpine3.21` [Dockerfile](https://github.com/docker-library/python/blob/00c4cce6b91488475bfaf85921bae12604a56d4a/3.9/alpine3.21/Dockerfile)


## 6. 镜像变体说明

### 6.1 `arm32v6/python:<version>`（标准变体）
- **基础镜像**：基于 `buildpack-deps`（包含大量常用 Debian 系统依赖，如编译器、库文件）。
- **适用场景**：需要完整系统工具链的应用（如编译 C 扩展、依赖系统库的项目）。
- **特点**：默认 `$PATH` 中优先使用镜像提供的 `/usr/local/bin/python`，系统自带的 `/usr/bin/python` 作为备用（避免工具兼容性问题）。

### 6.2 `arm32v6/python:<version>-alpine`（Alpine 变体）
- **基础镜像**：基于 Alpine Linux（轻量级发行版，体积小，使用 musl libc）。
- **适用场景**：资源受限环境、轻量化应用、对镜像体积敏感的部署。
- **注意事项**：musl libc 与 glibc 存在差异，部分依赖 glibc 的 Python 包可能需要额外适配；Alpine 需使用 `apk` 包管理器安装系统依赖（如 `apk add gcc`）。


## 7. 参考信息

### 7.1 维护与支持
- **维护者**：Docker 社区 [GitHub 仓库](https://github.com/docker-library/python)
- **问题反馈**：Docker Community Slack、Server Fault、Unix & Linux、Stack Overflow

### 7.2 架构与兼容性
- **支持架构**：`amd64`, `arm32v5`, `arm32v6`, `arm32v7`, `arm64v8`, `i386`, `mips64le`, `ppc64le`, `riscv64`, `s390x`, `windows-amd64`（`arm32v6` 为当前镜像架构）

### 7.3 镜像元数据
- **元数据详情**：[repo-info 仓库](https://github.com/docker-library/repo-info/blob/master/repos/python)（包含镜像大小、传输体积等）
- **更新记录**：[official-images 仓库](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fpython)（镜像更新跟踪）

### 7.4 文档与源码
- **描述文档源码**：[docker-library/docs](https://github.com/docker-library/docs/tree/master/python)
- **Dockerfile 源码**：见「支持的标签」中各标签对应的链接


## 8. 许可证信息

- **Python 许可证**：
  - Python 2.x: [官方许可证](https://docs.python.org/2/license.html)
  - Python 3.x: [官方许可证](https://docs.python.org/3/license.html)
- **镜像中其他软件**：包含基础镜像（如 Alpine、buildpack-deps）及依赖库，其许可证需单独遵守。
- **合规要求**：使用镜像时需确保遵守所有包含软件的许可证条款。

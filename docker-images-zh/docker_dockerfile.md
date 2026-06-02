---
image: docker/dockerfile
description: "这些是官方提供的Dockerfile前端镜像，主要功能是支持通过BuildKit构建Dockerfile，作为构建流程中的关键前端工具，能够有效配合BuildKit提升Dockerfile的构建效率、安全性与灵活性，为开发者提供官方认可的标准化构建方案，适用于各类基于Docker的应用开发与部署场景，确保构建过程的稳定可靠及操作便捷性。"
source: https://xuanyuan.cloud/zh/r/docker/dockerfile
canonical: https://xuanyuan.cloud/zh/r/docker/dockerfile
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/docker/dockerfile" title="docker/dockerfile Docker 镜像中文简介、标签列表与拉取命令">docker/dockerfile — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/docker/dockerfile" title="docker/dockerfile Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/docker/dockerfile</a>

# BuildKit Dockerfile 前端  

官方 Dockerfile 前端镜像，支持通过 BuildKit 构建 Dockerfile。  

- 问题反馈：[moby/buildkit GitHub 仓库]([])  
- 社区交流：[Docker Community Slack]([]) 的 `#buildkit` 频道  


## 标签  

### 最新正式版本  
- [`1.19.0`, `1.19`, `1`, `latest`]([])  
- [`1.18.0`, `1.18`]([])  


### 最新实验版本  
- [`1.19.0-labs`, `1.19-labs`, `1-labs`, `labs`]([])  
- [`1.18.0-labs`, `1.18-labs`]([])  


### 开发构建版本（基于 master 分支）  
- [`master`]([])  
- [`master-labs`]([])  


## Docker 用户注意事项  

如果使用 Docker v18.09 或更高版本，可通过客户端设置 `export DOCKER_BUILDKIT=1` 启用 BuildKit 模式。  
[Docker Buildx]([]) 则默认启用 BuildKit。  


## 使用外部 Dockerfile 前端  

BuildKit 支持从容器镜像动态加载前端。Dockerfile 前端镜像可在 [`docker/dockerfile`]([]) 仓库获取。  

### 基本用法  
需在 Dockerfile 首行通过 `# syntax=docker/dockerfile:<版本>` 指定要使用的外部前端镜像，例如：  
```dockerfile
# syntax=docker/dockerfile:1.3
```  

### 为什么推荐外部镜像？  
BuildKit 内置了 Dockerfile 前端，但建议使用外部镜像，确保所有构建者使用相同版本，且无需等待 BuildKit 或 Docker 引擎更新即可自动获取 bug 修复。  

### 版本渠道  
外部镜像分两个渠道：  
- **latest**：采用语义化版本控制（semver）。  
- **labs**：版本号为递增数字，可能移除特性而不递增主版本号，建议固定到具体修订版。旧版本仍保证向后兼容。  


## 链接式复制 `COPY --link`、`ADD --link`  

需将 Dockerfile 版本至少设为 `1.4`：  
```dockerfile
# syntax=docker/dockerfile:1.4
```  

### 功能说明  
`COPY` 或 `ADD` 命令添加 `--link` 标志后，文件会作为独立层存在，前序层命令变更时不会导致该层失效。原理是将源文件复制到空目标目录，该目录作为独立层链接到之前的构建状态。  

### 示例  
```dockerfile
# syntax=docker/dockerfile:1.4
FROM alpine
COPY --link /foo /bar
```  
等效于分别构建两个镜像后合并层：  
```dockerfile
# 基础镜像构建
FROM alpine

# 独立层构建
FROM scratch
COPY /foo /bar
```  

### 优势  
- 结合 `--cache-from` 时，即使前序层变更，仍可复用已构建的 `--link` 层。  
- 多阶段构建中，`COPY --from` 不再因前序命令变更而失效，无需重建中间阶段。  
- 基础镜像更新时可直接“重定基础”，无需重新执行完整构建，BuildKit 仅生成包含新旧层的新镜像 manifest。  


## 构建挂载 `RUN --mount=...`  

需将 Dockerfile 版本至少设为 `1.2`：  
```dockerfile
# syntax=docker/dockerfile:1.3
```  

`RUN --mount` 允许构建容器挂载文件、缓存、临时文件系统等，支持多种挂载类型。  


### `type=bind`（默认类型）  
将上下文或镜像中的目录以只读方式挂载到构建容器，可通过 `rw` 允许写入（写入数据会被丢弃）。  

| 选项          | 说明                          |  
|---------------|-------------------------------|  
| `target`（必填） | 挂载路径                      |  
| `source`      | 源路径（默认 `from` 的根目录）|  
| `from`        | 源所在的构建阶段或镜像（默认上下文）|  
| `rw`/`readwrite` | 允许写入                      |  


### `type=cache`  
为编译器、包管理器等缓存目录，加速构建。  

| 选项          | 说明                          |  
|---------------|-------------------------------|  
| `id`          | 缓存标识（默认 `target` 值）  |  
| `target`（必填） | 挂载路径                      |  
| `ro`/`readonly` | 只读                          |  
| `sharing`     | 缓存共享模式：`shared`（多写共享）、`private`（多写新建）、`locked`（多写排队），默认 `shared` |  
| `from`/`source` | 缓存基础阶段及子路径（默认空目录）|  
| `mode`/`uid`/`gid` | 缓存目录的权限、用户/组 ID（默认 0755、0、0）|  

#### 示例  
缓存 Go 依赖：  
```dockerfile
# syntax=docker/dockerfile:1.3
FROM golang
RUN --mount=type=cache,target=/root/.cache/go-build go build ...
```  

缓存 apt 包：  
```dockerfile
# syntax=docker/dockerfile:1.3
FROM ubuntu
# 保留下载的 apt 包
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
# 挂载 apt 缓存目录
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt update && apt-get --no-install-recommends install -y gcc
```  


### `type=tmpfs`  
挂载临时文件系统，可限制大小。  

| 选项          | 说明                          |  
|---------------|-------------------------------|  
| `target`（必填） | 挂载路径                      |  
| `size`        | 最大容量限制                  |  


### `type=secret`  
安全挂载密钥文件（如私钥），避免 baked 进镜像。  

| 选项          | 说明                          |  
|---------------|-------------------------------|  
| `id`          | 密钥 ID（默认目标路径basename）|  
| `target`      | 挂载路径（默认 `/run/secrets/<id>`）|  
| `required`    | 密钥不可用时是否报错（默认 false）|  
| `mode`/`uid`/`gid` | 密钥文件的权限、用户/组 ID（默认 0400、0、0）|  

#### 示例：访问 S3  
Dockerfile：  
```dockerfile
# syntax=docker/dockerfile:1.3
FROM python:3
RUN pip install awscli
RUN --mount=type=secret,id=aws,target=/root/.aws/credentials aws s3 cp s3://... ...
```  

构建命令：  
```console
$ docker build --secret id=aws,src=$HOME/.aws/credentials .
# 或使用 buildctl
$ buildctl build --frontend=dockerfile.v0 --local context=. --local dockerfile=. \
  --secret id=aws,src=$HOME/.aws/credentials
```  


### `type=ssh`  
通过 SSH 代理访问 SSH 密钥（支持密码短语）。  

| 选项          | 说明                          |  
|---------------|-------------------------------|  
| `id`          | SSH 代理 socket 或密钥 ID（默认 "default"）|  
| `target`      | 代理 socket 路径（默认 `/run/buildkit/ssh_agent.${N}`）|  
| `required`    | 密钥不可用时是否报错（默认 false）|  
| `mode`/`uid`/`gid` | socket 文件的权限、用户/组 ID（默认 0600、0、0）|  

#### 示例：访问 GitLab  
Dockerfile：  
```dockerfile
# syntax=docker/dockerfile:1.3
FROM alpine
RUN apk add --no-cache openssh-client
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh ssh -q -T [邮箱已删除] 2>&1 | tee /hello
```  

构建步骤：  
```console
$ eval $(ssh-agent)  # 启动 SSH 代理
$ ssh-add ~/.ssh/id_rsa  # 添加密钥（输入密码短语）
$ docker build --ssh default=$SSH_AUTH_SOCK .  # 传递代理 socket
```  


## 网络模式 `RUN --network=none|host|default`  

需将 Dockerfile 版本设为 `1.3`：  
```dockerfile
# syntax=docker/dockerfile:1.3
```  

`RUN --network` 控制命令的网络环境：  
- `none`：无网络访问（仅 `lo` 回环，进程隔离）。  
- `host`：使用主机网络（类似 `docker build --network=host`，需 `network.host` 权限）。  
- `default`：默认网络（不指定时的行为）。  

#### 示例：隔离外部依赖  
```dockerfile
# syntax=docker/dockerfile:1.3
FROM python:3.6
ADD mypackage.tgz wheels/
RUN --network=none pip install --find-links wheels mypackage  # 仅用本地包
```  


## Here-Documents（文档内联）  

需将 Dockerfile 版本设为 `1.4.0` 及以上：  
```dockerfile
# syntax=docker/dockerfile:1.4
```  

支持将后续行作为 `RUN` 或 `COPY` 命令的输入，通过分隔符（如 `eot`）界定内容。  


### `RUN` 中的多行脚本  
```dockerfile
# syntax=docker/dockerfile:1.4
FROM debian
RUN <<eot bash  # 指定解释器 bash
  apt-get update
  apt-get install -y vim
eot  # 分隔符结束
```  

若未指定解释器，默认使用 shell；也可通过 shebang 指定：  
```dockerfile
# syntax=docker/dockerfile:1.4
FROM python:3.6
RUN <<eot
#!/usr/bin/env python
print("hello world")
eot
```  


### `COPY` 中的内联文件  
通过 here-doc 直接传递文件内容，支持变量展开和制表符剥离：  
```dockerfile
# syntax=docker/dockerfile:1.4
FROM alpine
ARG FOO=bar
COPY <<-eot /app/foo  # "-" 剥离行首制表符
	hello ${FOO}  # 展开变量 FOO（值为 bar）
eot
```  

单引号分隔符（`<<-"eot"`）可禁用变量展开：  
```dockerfile
# syntax=docker/dockerfile:1.4
FROM alpine
COPY <<-"eot" /app/script.sh  # 保留 ${FOO} 原样
	echo hello ${FOO}
eot
RUN FOO=abc ash /app/script.sh  # 运行时传入 FOO=abc
```  


## 安全上下文 `RUN --security=insecure|sandbox`  

需使用 labs 渠道版本：  
```dockerfile
# syntax=docker/dockerfile:1.3-labs
```  

`--security=insecure` 允许命令以特权模式运行（类似 `docker run --privileged`），需 `security.insecure` 权限（启动 buildkitd 时 `--allow-insecure-entitlement security.insecure`，构建时 `--allow security.insecure`）。  

#### 示例：检查权限  
```dockerfile
# syntax=docker/dockerfile:1.3-labs
FROM ubuntu
RUN --security=insecure cat /proc/self/status | grep CapEff  # 查看有效 capabilities
```  

输出示例（特权模式下权限全开）：  
```
CapEff:	0000003fffffffff
```

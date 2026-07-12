---
image: ubuntu/dotnet-aspnet
description: "用于ASP.NET应用的精简Ubuntu运行时镜像，由Canonical维护的长期支持版本。"
source: https://xuanyuan.cloud/zh/r/ubuntu/dotnet-aspnet
canonical: https://xuanyuan.cloud/zh/r/ubuntu/dotnet-aspnet
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/dotnet-aspnet" title="ubuntu/dotnet-aspnet Docker 镜像中文简介、标签列表与拉取命令">ubuntu/dotnet-aspnet 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Chiselled Ubuntu for dotnet-aspnet 镜像文档


## 镜像概述和主要用途

本镜像为 Canonical 提供的基于 Ubuntu 的 dotnet-aspnet Docker 镜像，专为 ASP.NET 应用提供轻量级运行时环境。镜像会持续接收安全更新，并滚动升级至更新的 dotnet-aspnet 版本或 Ubuntu 发行版。**该仓库可免费使用，且免除每用户速率限制**。作为 Chiselled Ubuntu 系列镜像的一部分，其设计目标是提供精简、安全的运行时环境，适合生产环境中部署 ASP.NET 应用。


## 核心功能和特性

### 轻量级运行时环境
- **精简设计**：基于 Chiselled Ubuntu，不包含 bash、包管理器（如 apt）或 .NET SDK，仅保留运行 ASP.NET 应用所需的最小依赖，降低攻击面。
- **安全更新支持**：
  - **LTS 通道**：提供长达 5 年的免费安全维护。
  - **ESM 通道**：通过 Canonical 受限仓库提供长达 10 年的客户安全维护（需商业支持）。

### 多版本与通道管理
- **版本跟踪**：支持 dotnet-aspnet 8.0、9.0 等版本，基于不同 Ubuntu 发行版（如 24.04 LTS、25.04）。
- **通道标签**：按稳定性排序为 `stable`（最稳定）、`candidate`、`beta`、`edge`（最前沿）。风险较高的通道（如 `edge`）隐含可用，例如若列出 `beta`，则 `edge` 也可拉取。镜像会按 `edge` → `beta` → `candidate` → `stable` 顺序发布。

### 多架构支持
支持 `amd64`、`arm64`、`ppc64le`、`s390x` 等主流架构（具体架构因版本而异，详见标签说明）。


## 使用场景和适用范围

### 适用场景
- 部署基于 ASP.NET 构建的现代 Web 应用和服务。
- 需要轻量级、低资源占用的容器化运行时环境。
- 对安全性和长期维护支持有较高要求的生产环境。

### 适用用户
- 开发团队：用于本地测试和构建 ASP.NET 应用镜像。
- 企业用户：部署生产级 ASP.NET 应用，需长期安全支持。
- 需多架构部署的场景（如混合云、边缘设备）。


## 标签与架构

### 主要通道标签及支持信息

| 通道标签                                                                 | 支持期限   | 当前版本                          | 架构支持                     |
|--------------------------------------------------------------------------|------------|-----------------------------------|------------------------------|
| **`8.0-24.04_stable`**（含衍生标签如 `8.0`、`8.0_stable`、`stable` 等） | 11/2026    | dotnet-aspnet 8.0 on Ubuntu 24.04 LTS | `amd64`、`arm64`、`ppc64le`、`s390x` |
| `9.0-25.04_edge`                                                         | 01/2026    | dotnet-aspnet 9.0 on Ubuntu 25.04   | `amd64`、`arm64`              |

> **通道说明**：表中列出的是各版本最稳定的通道，按 `stable` → `candidate` → `beta` → `edge` 排序。风险较高的通道隐含可用（如 `stable` 通道可用时，`candidate`、`beta`、`edge` 均可用）。镜像会严格按 `edge` → `beta` → `candidate` → `stable` 顺序发布。

### 商业使用与扩展安全维护（ESM）通道
若需商业再分发、ESM 支持或访问未公开的通道/版本，请联系 Canonical 团队（[官方联系方式](https://ubuntu.com/security/docker-images#get-in-touch) 或发送邮件至 rocks@canonical.com）。


## 使用方法和配置说明

### 本地启动镜像

#### 基础运行命令
```sh
docker run -d --name dotnet-aspnet-container -e TZ=UTC docker.xuanyuan.run/ubuntu/dotnet-aspnet:8.0-24.04_stable
```
> 说明：默认情况下，容器会输出 .NET 帮助信息，因为需要指定应用程序路径（详见下文“运行 ASP.NET 应用”）。


### 入口点差异（dotnet vs pebble）

#### 版本 6.0、8.0 及 9.0-24.10
此类镜像基于 Dockerfile 构建，入口点为 `dotnet`：
```sh
# 示例：运行 8.0-24.04_stable 版本
docker run -d --name dotnet-aspnet-container -e TZ=UTC docker.xuanyuan.run/ubuntu/dotnet-aspnet:8.0-24.04_stable
# 查看日志（输出 .NET 帮助信息）
docker logs -f dotnet-aspnet-container
```

#### 版本 9.0-25.04 及更高
此类镜像为 Rock 格式，入口点变更为 `pebble enter`，需通过 `exec` 命令访问 `dotnet`：
```sh
# 示例：运行 9.0-25.04_edge 版本并执行 dotnet
docker run --rm docker.xuanyuan.run/ubuntu/dotnet-aspnet:9.0-25.04_edge exec dotnet
```


### 运行 ASP.NET 应用

以示例应用 [Azure-Samples/dotnetcore-docs-hello-world](https://github.com/Azure-Samples/dotnetcore-docs-hello-world) 为例，说明部署步骤。

#### 使用 6.0、8.0 或 9.0-24.10 版本镜像
```bash
# 克隆示例代码
git clone https://github.com/Azure-Samples/dotnetcore-docs-hello-world
cd dotnetcore-docs-hello-world

# 切换至兼容 .NET 8.0 的提交
git checkout 95b862ca3580c82835322d9eb45eb9ecfd731370

# 发布应用（需本地安装 dotnet8 包）
dotnet publish -c Release -o /app --self-contained false

# 运行容器（映射应用目录和端口）
docker run --rm -v $PWD/app:/app -p 8080:8080 docker.xuanyuan.run/ubuntu/dotnet-aspnet:8.0-24.04_stable /app/HelloWorld.dll
```
访问应用：`localhost:8080`


#### 使用 9.0-25.04 及更高版本镜像
```bash
# 克隆示例代码
git clone https://github.com/Azure-Samples/dotnetcore-docs-hello-world
cd dotnetcore-docs-hello-world

# 切换至兼容 .NET 8.0 的提交并修改项目文件以支持 .NET 9
git checkout 95b862ca3580c82835322d9eb45eb9ecfd731370
sed -i 's/net8.0/net9.0/' dotnetcoresample.csproj

# 发布应用（需本地安装 dotnet9 包）
dotnet publish -c Release -o /app --self-contained false

# 运行容器（映射应用目录和端口）
docker run --rm -v $PWD/app:/app -p 8080:8080 docker.xuanyuan.run/ubuntu/dotnet-aspnet:9.0-25.04_edge /app/HelloWorld.dll
```
访问应用：`localhost:8080`


### 构建 ASP.NET 应用镜像

#### 使用 6.0、8.0 或 9.0-24.10 版本作为基础镜像
```dockerfile
# 构建阶段：使用 Ubuntu 24.04 安装 .NET SDK
FROM docker.xuanyuan.run/ubuntu:24.04 AS builder
RUN apt-get update && apt-get install -y dotnet8 ca-certificates
WORKDIR /source
COPY . .
RUN dotnet publish -c Release -o /app --self-contained false

# 运行阶段：使用 Chiselled Ubuntu 镜像
FROM ubuntu.azurecr.io/dotnet-aspnet:8.0-24.04_stable
WORKDIR /app
COPY --from=builder /app ./

ENV PORT 8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "/app/dotnetcoresample.dll"]
```


#### 使用 9.0-25.04 及更高版本作为基础镜像
```dockerfile
# 构建阶段：使用 Ubuntu 25.04 安装 .NET SDK
FROM docker.xuanyuan.run/ubuntu:25.04 AS builder
RUN apt-get update && apt-get install -y dotnet9 ca-certificates
WORKDIR /source
COPY . .
RUN sed -i 's/net8.0/net9.0/' dotnetcoresample.csproj  # 修改项目文件以支持 .NET 9
RUN dotnet publish -c Release -r ubuntu.25.04-x64 --self-contained false -o /app

# 运行阶段：使用 Rock 格式镜像
FROM docker.xuanyuan.run/ubuntu/dotnet-aspnet:9.0-25.04_edge
WORKDIR /app
COPY --from=builder /app ./

CMD ["exec", "dotnet", "/app/dotnetcoresample.dll"]
```


### 调试容器
查看容器日志：
```sh
docker logs -f dotnet-aspnet-container
```


## Bug 与功能请求

若发现镜像 bug 或需请求功能，请通过以下链接提交 issue：  
[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

**提交要求**：
- 标题格式：`dotnet-aspnet: <问题摘要>`
- 需包含镜像摘要，可通过以下命令获取：
  ```sh
  docker images --no-trunc --quiet ubuntu/dotnet-aspnet:<tag>
  ```


## 已弃用通道与标签

以下通道/标签不再更新，请升级至新版本或联系 Canonical 获取支持。

| 跟踪（Track）       | 版本                          | 生命周期结束（EOL） | 升级路径 |
|--------------------|-------------------------------|---------------------|----------|
| ~~9.0-24.10~~      | dotnet-aspnet 9.0 on Ubuntu 24.10 | 07/2025             | -        |
| ~~6.0-22.04~~      | dotnet-aspnet 6.0 on Ubuntu 22.04 LTS | 11/2024             | -        |
| ~~7.0-23.04~~      | dotnet-aspnet 7.0 on Ubuntu 23.04 | 05/2024             | -        |
| ~~6.0-22.10~~      | dotnet-aspnet 6.0 on Ubuntu 22.10 | 07/2023             | -        |
| ~~7.0-22.10~~      | dotnet-aspnet 7.0 on Ubuntu 22.10 | 07/2023             | -        |

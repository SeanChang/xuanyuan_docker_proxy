---
image: library/rust
description: "Rust是一种由Mozilla主导开发的系统编程语言，其核心设计目标聚焦于安全性、速度与并发性能，通过创新的内存安全机制（如所有权系统）在无需垃圾回收的情况下保障程序安全，同时兼顾高效的执行速度与强大的并发处理能力，广泛适用于底层系统开发、嵌入式设备、高性能服务器及关键基础设施等对可靠性与性能要求严苛的领域。"
source: https://xuanyuan.cloud/zh/r/library/rust
canonical: https://xuanyuan.cloud/zh/r/library/rust
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/rust" title="library/rust Docker 镜像中文简介、标签列表与拉取命令">library/rust 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Rust Docker镜像使用指南


## 快速参考

### 基础信息
- **维护方**：  
  [Rust项目开发团队]   

- **获取帮助渠道**：  
  [Docker社区Slack] 、[Server Fault] 、[Unix & Linux Stack Exchange]  或 [Stack Overflow]   


## 支持的标签及对应Dockerfile链接

### Debian基础镜像
- **bullseye版本**：  
  `1-bullseye`、`1.90-bullseye`、`1.90.0-bullseye`、`bullseye`（对应的Dockerfile链接：[GitHub] ）  

- **bullseye精简版**：  
  `1-slim-bullseye`、`1.90-slim-bullseye`、`1.90.0-slim-bullseye`、`slim-bullseye`（对应的Dockerfile链接：[GitHub] ）  

- **bookworm版本**：  
  `1-bookworm`、`1.90-bookworm`、`1.90.0-bookworm`、`bookworm`（对应的Dockerfile链接：[GitHub] ）  

- **bookworm精简版**：  
  `1-slim-bookworm`、`1.90-slim-bookworm`、`1.90.0-slim-bookworm`、`slim-bookworm`（对应的Dockerfile链接：[GitHub] ）  

- **trixie版本**（含最新标签）：  
  `1-trixie`、`1.90-trixie`、`1.90.0-trixie`、`trixie`、`1`、`1.90`、`1.90.0`、`latest`（对应的Dockerfile链接：[GitHub] ）  

- **trixie精简版**（含精简标签）：  
  `1-slim-trixie`、`1.90-slim-trixie`、`1.90.0-slim-trixie`、`slim-trixie`、`1-slim`、`1.90-slim`、`1.90.0-slim`、`slim`（对应的Dockerfile链接：[GitHub] ）  


### Alpine基础镜像
- **Alpine 3.20版本**：  
  `1-alpine3.20`、`1.90-alpine3.20`、`1.90.0-alpine3.20`、`alpine3.20`（对应的Dockerfile链接：[GitHub] ）  

- **Alpine 3.21版本**：  
  `1-alpine3.21`、`1.90-alpine3.21`、`1.90.0-alpine3.21`、`alpine3.21`（对应的Dockerfile链接：[GitHub] ）  

- **Alpine 3.22版本**（含Alpine标签）：  
  `1-alpine3.22`、`1.90-alpine3.22`、`1.90.0-alpine3.22`、`alpine3.22`、`1-alpine`、`1.90-alpine`、`1.90.0-alpine`、`alpine`（对应的Dockerfile链接：[GitHub] ）  


## 快速参考（补充）

- **问题反馈地址**：  
  [[]]   

- **支持的架构**（更多信息见[官方说明] ）：  
  `amd64`（[镜像链接] ）、`arm32v7`（[镜像链接] ）、`arm64v8`（[镜像链接] ）、`i386`（[镜像链接] ）、`ppc64le`（[镜像链接] ）、`riscv64`（[镜像链接] ）、`s390x`（[镜像链接] ）  

- **镜像详情**：  
  [repo-info仓库的`repos/rust/`目录] （含历史记录：[链接] ），包含镜像元数据、传输大小等信息。  

- **镜像更新**：  
  关注[official-images仓库的`library/rust`标签] 或[`library/rust`文件] （历史记录：[链接] ）。  

- **本文档来源**：  
  [docs仓库的`rust/`目录] （历史记录：[链接] ）  


## 什么是Rust？

Rust是由Mozilla Research赞助的系统编程语言，设计目标是“安全、并发、实用”，支持函数式和命令式编程范式。语法类似C++，但在保持性能的同时提升了内存安全性。  

> 更多信息：[维基百科-Rust编程语言]()  

![Rust logo]   


## 如何使用此镜像

### 启动Rust实例运行应用
最直接的用法是将Rust容器同时作为构建和运行环境。以下是Dockerfile示例，可编译并运行项目：  

```dockerfile
FROM docker.xuanyuan.run/rust:1.67

WORKDIR /usr/src/myapp
COPY . .

RUN cargo install --path .

CMD ["myapp"]
```

构建并运行镜像：  
```console
$ docker build -t my-rust-app .
$ docker run -it --rm --name my-running-app my-rust-app
```

**说明**：上述镜像包含完整Rust工具链，体积约1.8GB。若只需运行编译后的应用，可使用多阶段构建减小体积：  

```dockerfile
# 构建阶段
FROM docker.xuanyuan.run/rust:1.67 as builder
WORKDIR /usr/src/myapp
COPY . .
RUN cargo install --path .

# 运行阶段
FROM docker.xuanyuan.run/debian:bullseye-slim
# 安装运行时依赖（根据实际需求调整）
RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*
# 复制编译产物
COPY --from=builder /usr/local/cargo/bin/myapp /usr/local/bin/myapp
CMD ["myapp"]
```

**注意**：运行阶段可能需要安装额外依赖（如`extra-runtime-dependencies`所示）。此方法生成的镜像体积可控制在200MB以内，若使用Alpine基础的Rust镜像，还可再减少约60MB。  

更多多阶段构建信息：[Docker多阶段构建文档] 。  


### 在容器内编译应用
若无需在容器内运行应用，仅需编译，可执行以下命令：  

```console
$ docker run --rm --user "$(id -u)":"$(id -g)" -v "$PWD":/usr/src/myapp -w /usr/src/myapp rust:1.23.0 cargo build --release
```

**说明**：  
- `--rm`：编译完成后自动删除容器；  
- `--user "$(id -u)":"$(id -g)"`：使用当前用户权限，避免文件权限问题；  
- `-v "$PWD":/usr/src/myapp`：将当前目录挂载到容器内`/usr/src/myapp`；  
- `-w /usr/src/myapp`：设置工作目录为挂载目录；  
- `cargo build --release`：编译项目，产物输出到`target/release/myapp`。  


## 镜像变体

rust镜像提供多种版本，适用于不同场景：  

### rust:<version>（默认版本）
最常用版本，包含完整工具链和基础依赖（基于`buildpack-deps`），适合作为构建基础或直接运行应用。标签中的`bullseye`、`bookworm`、`trixie`对应Debian发行版代号，建议显式指定以避免因Debian版本更新导致的依赖问题。  


### rust:<version>-slim（精简版本）
仅包含运行Rust所需的最小依赖，体积更小，但缺少默认版本中的常用工具。适合对镜像体积有严格要求，且无需额外构建工具的场景。  


### rust:<version>-alpine（Alpine版本）
基于Alpine Linux（体积约5MB），进一步减小镜像体积。但使用`musl libc`而非`glibc`，可能存在部分软件的libc兼容性问题。适合对体积敏感且确认无兼容性问题的场景。  


## 许可证

- 镜像中Rust软件的许可证信息：[Rust官方许可页面] 。  
- 镜像可能包含其他软件（如Bash等基础系统组件），其许可证需另行确认。  
- 镜像使用者需自行确保对包含的所有软件的使用符合相关许可证要求。

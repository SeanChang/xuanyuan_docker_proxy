---
image: library/golang
description: "Go（又称golang）是由Google开发并于2009年正式发布的一种通用、高级、命令式编程语言，其设计初衷是解决大规模软件开发中的效率、可读性与并发性问题，具有语法简洁、编译高效、标准库强大及原生支持并发等特点，广泛应用于后端开发、云服务、分布式系统等领域。"
source: https://xuanyuan.cloud/zh/r/library/golang
canonical: https://xuanyuan.cloud/zh/r/library/golang
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [library/golang — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/golang)

含镜像标签、拉取命令、部署文档与相关推荐。

[library/golang Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/library/golang)

# Go Docker 镜像使用指南


## 快速参考

### 维护者  
[Docker 社区]([])

### 获取帮助  
可通过 [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([]) 获取支持。


## 支持的标签及对应 Dockerfile 链接  
（关于“共享标签”与“简单标签”的区别，可参考 [FAQ]([])）


### 简单标签  
- [`1.25.2-trixie`, `1.25-trixie`, `1-trixie`, `trixie`]([])  
- [`1.25.2-bookworm`, `1.25-bookworm`, `1-bookworm`, `bookworm`]([])  
- [`1.25.2-alpine3.22`, `1.25-alpine3.22`, `1-alpine3.22`, `alpine3.22`, `1.25.2-alpine`, `1.25-alpine`, `1-alpine`, `alpine`]([])  
- [`1.25.2-alpine3.21`, `1.25-alpine3.21`, `1-alpine3.21`, `alpine3.21`]([])  
- Windows 相关标签（如 `windowsservercore-ltsc2025`、`nanoserver-ltsc2022` 等）及 1.24 版本标签可参考[原链接]([])  


### 共享标签  
- `1.25.2`, `1.25`, `1`, `latest`：  
  - 对应 [`1.25.2-trixie`]([])、[`1.25.2-windowsservercore-ltsc2025`]([]) 等  
- `1.24.8`, `1.24`：  
  - 对应 [`1.24.8-trixie`]([]) 等  


## 快速参考（续）  

### 提交 issue  
[[]]([])  

### 支持的架构  
[`amd64`]([])、[`arm32v6`]([])、[`arm64v8`]([])、`windows-amd64` 等（[更多信息]([])）  

### 镜像详情  
可查看 [repo-info 仓库的 `repos/golang/` 目录]([])（含元数据、传输大小等）  

### 镜像更新  
关注 [official-images 仓库的 `library/golang` 标签]([])  

### 描述来源  
[docs 仓库的 `golang/` 目录]([])  


## 什么是 Go？  
Go（又称 Golang）是谷歌开发的编程语言，静态类型，语法借鉴 C 语言，支持垃圾回收、类型安全，提供变长数组、键值映射等内置类型及丰富的标准库。  
> 更多信息：[维基百科]()  


## 如何使用此镜像  

### 启动 Go 应用实例  
直接将此镜像作为构建和运行环境。在 `Dockerfile` 中编写如下内容（假设项目使用 `go.mod` 管理依赖）：  

```dockerfile
FROM golang:1.25  
WORKDIR /usr/src/app  

# 预复制 go.mod 和 go.sum，避免依赖变动时重复下载  
COPY go.mod go.sum ./  
RUN go mod download  

COPY . .  
RUN go build -v -o /usr/local/bin/app ./...  

CMD ["app"]
```  

构建并运行镜像：  
```console
$ docker build -t my-golang-app .  
$ docker run -it --rm --name my-running-app my-golang-app  
```  


### 在容器内编译应用  
若无需在容器内运行，仅编译应用，可执行：  
```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.25 go build -v  
```  
（将当前目录挂载到容器，设置工作目录为挂载目录，执行 `go build` 编译项目）  

若项目有 `Makefile`，可直接运行 `make`：  
```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.25 make  
```  


### 交叉编译应用  
如需为非 `linux/amd64` 平台编译（如 `windows/386`）：  
```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e GOOS=windows -e GOARCH=386 golang:1.25 go build -v  
```  

如需同时编译多平台版本：  
```console
$ docker run --rm -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.25 bash  
$ for GOOS in darwin linux; do  
>   for GOARCH in 386 amd64; do  
>     export GOOS GOARCH  
>     go build -v -o myapp-$GOOS-$GOARCH  
>   done  
> done  
```  


### Git LFS 注意事项  
若下载依赖时出现“校验和不匹配”错误，可能是依赖使用了 [Git LFS]([])，需安装 Git LFS 以正确下载依赖并生成 `go.sum`。  


## 镜像变体  

### `golang:<版本>`  
默认镜像，适合作为构建和运行环境。标签中的 `bookworm`、`trixie` 为 Debian 发行版代号，建议显式指定以避免 Debian 版本更新导致的问题。  


### `golang:<版本>-alpine`  
基于 Alpine Linux，体积更小（约 5MB），但使用 musl libc 而非 glibc，可能存在兼容性问题（非 Go 官方支持，[详情]([])）。需自行安装 `git`、`gcc` 等工具。  


### `golang:<版本>-windowsservercore`  
基于 Windows Server Core，仅支持 Windows 10 专业版/企业版（周年更新）或 Windows Server 2016 及以上环境。  


### `golang:<版本>-tip`  
包含 Go 最新开发分支构建，每周更新，适合测试新特性（“tip”为 Go 社区对开发分支的称呼）。  


## 许可证  
镜像中软件的许可证信息见 [Go 官方声明]([])。  
镜像可能包含其他软件（如 Bash 等），用户需自行确保使用符合相关许可证要求。  
更多自动检测的许可证信息可查看 [repo-info 仓库的 `golang/` 目录]([])。

---
image: library/docker
description: "Docker in Docker（通常称为“dind”）是一种允许在Docker容器内部嵌套运行Docker引擎的技术，它能够在一个容器环境中启动、管理其他Docker容器，常用于持续集成/持续部署（CI/CD）流水线、Docker工具开发测试及需要隔离Docker环境的场景，通过这种方式可简化开发、测试和部署流程，同时保持容器化环境的独立性与一致性。"
source: https://xuanyuan.cloud/zh/r/library/docker
canonical: https://xuanyuan.cloud/zh/r/library/docker
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/docker" title="library/docker Docker 镜像中文简介、标签列表与拉取命令">library/docker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker 镜像使用指南


## 基础信息

### 维护者  
[Tianon（Docker 项目成员）]([])

### 获取帮助渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应 Dockerfile 链接  
（关于“共享标签”与“基础标签”的区别，参见 [FAQ]([])）

### 基础标签  
- [`28.5.1-cli`, `28.5-cli`, `28-cli`, `cli`, `28.5.1-cli-alpine3.22`]([])  
- [`28.5.1-dind`, `28.5-dind`, `28-dind`, `dind`, `28.5.1-dind-alpine3.22`, `28.5.1`, `28.5`, `28`, `latest`, `28.5.1-alpine3.22`]([])  
- [`28.5.1-dind-rootless`, `28.5-dind-rootless`, `28-dind-rootless`, `dind-rootless`]([])  
- [`28.5.1-windowsservercore-ltsc2025`, `28.5-windowsservercore-ltsc2025`, `28-windowsservercore-ltsc2025`, `windowsservercore-ltsc2025`]([])  
- [`28.5.1-windowsservercore-ltsc2022`, `28.5-windowsservercore-ltsc2022`, `28-windowsservercore-ltsc2022`, `windowsservercore-ltsc2022`]([])  

### 共享标签  
- `28.5.1-windowsservercore`, `28.5-windowsservercore`, `28-windowsservercore`, `windowsservercore`:  
  - [`28.5.1-windowsservercore-ltsc2025`]([])  
  - [`28.5.1-windowsservercore-ltsc2022`]([])  


## 扩展信息  

### 问题反馈地址  
[[]]([])  

### 支持的架构  
（详情参见 [官方说明]([])）  
[`amd64`]([]), [`arm32v6`]([]), [`arm32v7`]([]), [`arm64v8`]([]), [`windows-amd64`]([])  

### 镜像 artifact 详情  
[repo-info 仓库的 `repos/docker/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  

### 镜像更新  
[official-images 仓库的 `library/docker` 标签]([])  
[official-images 仓库的 `library/docker` 文件]([])（[历史记录]([])）  

### 本文档来源  
[docs 仓库的 `docker/` 目录]([])（[历史记录]([])）  


## 什么是 Docker-in-Docker？  

尽管通常不建议在 Docker 内部运行 Docker，但仍有一些合理场景（例如 Docker 自身的开发工作）。  

*Docker 是一个开源项目，通过在 Linux、macOS 和 Windows 上提供操作系统级虚拟化的抽象层和自动化工具，实现应用程序在软件容器中的自动化部署。*  

> 来源：[.org/wiki/Docker_(software)]()  

使用 Docker-in-Docker 前，建议阅读 Jérôme Petazzoni 的[相关博客文章]([])，其中详细介绍了其优缺点及潜在问题。  


## 如何使用本镜像  

### TLS 配置  
18.09+ 版本的 `dind` 镜像会通过环境变量 `DOCKER_TLS_CERTDIR` 指定的目录自动生成 TLS 证书。  

**注意**：18.09 版本默认禁用此功能（为保证兼容性）。若使用 `--network=host`、共享网络命名空间（如 Kubernetes Pod）或容器可被网络访问（包括通过网关接口访问 `dind` 实例中启动的容器），可能存在安全风险（例如主机系统被访问）。建议通过设置 `-e DOCKER_TLS_CERTDIR=/certs` 启用 TLS，19.03+ 版本默认启用。  

启用后，Docker 守护进程将以 `--host=tcp://0.0.0.0:2376 --tlsverify ...` 启动；禁用时则以 `--host=tcp://0.0.0.0:2375` 启动。  

`$DOCKER_TLS_CERTDIR` 目录下包含三个子目录：  
- `ca`：证书颁发机构文件（`cert.pem`、`key.pem`）  
- `server`：守护进程（`dockerd`）证书文件（`cert.pem`、`ca.pem`、`key.pem`）  
- `client`：客户端（`docker`）证书文件（`cert.pem`、`ca.pem`、`key.pem`，适用于 `DOCKER_CERT_PATH`）  

若需从“客户端”容器使用此功能，至少需共享 `$DOCKER_TLS_CERTDIR` 的 `client` 子目录（见下文示例）。  

如需禁用此行为，可直接覆盖容器命令或入口点运行 `dockerd`（例如 `... docker:dind dockerd ...` 或 `... --entrypoint dockerd docker:dind ...`）。  


### 启动守护进程实例  

```console
$ docker run --privileged --name some-docker -d \
	--network some-network --network-alias docker \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v some-docker-certs-ca:/certs/ca \
	-v some-docker-certs-client:/certs/client \
	docker:dind
```  

**注意**：`--privileged` 是 Docker-in-Docker 正常运行的必要参数，但会赋予容器对主机环境的完全访问权限，使用时需谨慎（详见 [Docker 文档]([])）。  


### 从其他容器连接  

```console
$ docker run --rm --network some-network \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v some-docker-certs-client:/certs/client:ro \
	docker:latest version
```  

（输出示例略，可显示客户端与服务端版本信息）  


### 自定义守护进程参数  

```console
$ docker run --privileged --name some-docker -d \
	--network some-network --network-alias docker \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v some-docker-certs-ca:/certs/ca \
	-v some-docker-certs-client:/certs/client \
	docker:dind --storage-driver overlay2
```  


### 运行时配置建议  

参考官方 systemd `docker.service` 配置，生产环境可考虑调整以下参数：  

```console
$ docker run --privileged --name some-docker -d \
	... \
	--ulimit nofile=-1 \
	--ulimit nproc=-1 \
	--ulimit core=-1 \
	--pids-limit -1 \
	--oom-score-adj -500 \
	docker:dind
```  

部分参数可能受主机 `dockerd` 限制（例如 `--ulimit nofile=-1` 可能报错 `error setting rlimit type 7: operation not permitted`），需根据实际环境调整。  


### 数据存储  

Docker 容器数据存储有两种常见方式：  
1. **Docker 管理存储**：默认方式，数据存储在主机系统的 Docker 内部卷中，优点是简单透明，缺点是主机工具难直接访问。  
2. **主机目录挂载**：在主机创建数据目录并挂载到容器内，优点是主机可直接访问，缺点是需手动确保目录存在及权限正确。  

**示例（主机目录挂载）**：  
1. 在主机创建目录：`/my/own/var-lib-docker`  
2. 启动容器：  

```console
$ docker run --privileged --name some-docker -v /my/own/var-lib-docker:/var/lib/docker -d docker:dind
```  

`-v /my/own/var-lib-docker:/var/lib/docker` 将主机目录挂载为容器内 Docker 数据目录。  


## 镜像变体  

### `docker:<version>`  
默认镜像，适用于临时容器（挂载代码启动应用）或作为基础镜像构建其他镜像。  


### `docker:<version>-rootless`  
无 root 权限变体，实验性特性（详情参见 [docker-library/docker#174]([])）。  

**注意**：与常规 `dind` 镜像相同，`--privileged` 是必要参数（[相关说明]([]) 及 [安全说明]([])）。  

**基础用法示例**：  

```console
$ docker run -d --name some-docker --privileged docker:dind-rootless
$ docker logs --tail=3 some-docker # 验证守护进程是否完成证书生成并监听
time="xxx" level=info msg="Daemon has completed initialization"
time="xxx" level=info msg="API listen on /run/user/1000/docker.sock"
time="xxx" level=info msg="API listen on [::]:2376"
$ docker exec -it some-docker docker-entrypoint.sh sh # 进入容器，自动配置 DOCKER_HOST
/ $ docker info --format '{{ json .SecurityOptions }}'
["name=seccomp,profile=default","name=rootless"]
```  

如需修改 UID/GID，可通过 Dockerfile 调整：  

```dockerfile
FROM docker:dind-rootless
USER root
RUN set -eux; \
	sed -i -e 's/^rootless:x:1000:1000:/rootless:x:1234:5678:/' /etc/passwd; \
	sed -i -e 's/^rootless:x:1000:/rootless:x:5678:/' /etc/group; \
	chown -R rootless ~rootless
USER rootless
```  


### `docker:<version>-windowsservercore`  
Windows 不支持嵌套容器，此变体仅包含客户端（需连接现有 Docker 引擎，例如通过 `-v //./pipe/docker_engine://./pipe/docker_engine` 挂载管道）。  


## 许可协议  

查看 [软件许可信息]([])。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如 Bash 等基础组件及依赖），可能适用不同许可协议。  

自动检测的附加许可信息可参见 [repo-info 仓库的 `docker/` 目录]([])。  

使用前，请确保遵守所有包含软件的许可协议。

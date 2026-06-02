<!-- xuanyuan-docker-images-zh
image: library/haproxy
source: https://xuanyuan.cloud/zh/r/library/haproxy
canonical: https://xuanyuan.cloud/zh/r/library/haproxy
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/haproxy" title="library/haproxy Docker 镜像中文简介、标签列表与拉取命令">library/haproxy — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/haproxy" title="library/haproxy Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/haproxy</a></p>

# HAProxy Docker 镜像介绍


## 基础信息

### 维护方  
[Docker 社区]([])


### 获取帮助渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应 Dockerfile 链接  

- [`3.3-dev9`、`3.3-dev`、`3.3-dev9-trixie`、`3.3-dev-trixie`]([])  
- [`3.3-dev9-alpine`、`3.3-dev-alpine`、`3.3-dev9-alpine3.22`、`3.3-dev-alpine3.22`]([])  
- [`3.2.6`、`3.2`、`latest`、`lts`、`3.2.6-trixie`、`3.2-trixie`、`trixie`、`lts-trixie`]([])  
- [`3.2.6-alpine`、`3.2-alpine`、`alpine`、`lts-alpine`、`3.2.6-alpine3.22`、`3.2-alpine3.22`、`alpine3.22`、`lts-alpine3.22`]([])  
- [`3.1.9`、`3.1`、`3.1.9-trixie`、`3.1-trixie`]([])  
- [`3.1.9-alpine`、`3.1-alpine`、`3.1.9-alpine3.22`、`3.1-alpine3.22`]([])  
- [`3.0.12`、`3.0`、`3.0.12-trixie`、`3.0-trixie`]([])  
- [`3.0.12-alpine`、`3.0-alpine`、`3.0.12-alpine3.22`、`3.0-alpine3.22`]([])  
- [`2.8.16`、`2.8`、`2.8.16-trixie`、`2.8-trixie`]([])  
- [`2.8.16-alpine`、`2.8-alpine`、`2.8.16-alpine3.22`、`2.8-alpine3.22`]([])  
- [`2.6.23`、`2.6`、`2.6.23-trixie`、`2.6-trixie`]([])  
- [`2.6.23-alpine`、`2.6-alpine`、`2.6.23-alpine3.22`、`2.6-alpine3.22`]([])  
- [`2.4.30`、`2.4`、`2.4.30-trixie`、`2.4-trixie`]([])  
- [`2.4.30-alpine`、`2.4-alpine`、`2.4.30-alpine3.22`、`2.4-alpine3.22`]([])  


## 基础信息（续）

### 问题反馈地址  
[[]]([])  


### 支持架构  
（更多信息：[[]]([])）  
[`amd64`]([])、[`arm32v5`]([])、[`arm32v6`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`i386`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])  


### 镜像详情  
[repo-info 仓库的 `repos/haproxy/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
[official-images 仓库的 `library/haproxy` 标签]([])  
[official-images 仓库的 `library/haproxy` 文件]([])（[历史记录]([])）  


### 描述来源  
[docs 仓库的 `haproxy/` 目录]([])（[历史记录]([])）  


## 什么是 HAProxy？  

HAProxy 是一款免费开源的高可用解决方案，通过将请求分发到多台服务器，为 TCP 和 HTTP 应用提供负载均衡和代理功能。它采用 C 语言编写，以高效（在处理器和内存使用方面）著称。  

> [.org/wiki/HAProxy]()  

![logo]([])  


## 如何使用此镜像  

由于 HAProxy 的配置需求因人而异，本镜像未提供默认配置。  

建议参考 [上游官方文档]([]) 了解配置方法，或查看 [上游示例目录]([];a=tree;f=examples) 获取参考。  


### 方法一：通过 Dockerfile 构建  

#### 创建 Dockerfile  
```dockerfile
FROM haproxy:2.3
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
```

#### 构建容器  
```console
$ docker build -t my-haproxy .
```

#### 测试配置文件  
```console
$ docker run -it --rm --name haproxy-syntax-check my-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
```
（检查配置文件语法是否正确）

#### 运行容器  
```console
$ docker run -d --name my-running-haproxy --sysctl net.ipv4.ip_unprivileged_port_start=0 my-haproxy
```
- 需内核版本 [4.11 或更高]([]) 才能使用 `--sysctl net.ipv4.ip_unprivileged_port_start=0`。  
- 如需将 HAProxy 监听的端口暴露到主机，需使用 `-p` 参数，例如 `-p 8080:80`（将主机 8080 端口映射到容器 80 端口），确保端口未被占用。  
- **注意**：2.4+ 版本容器默认以 `USER haproxy` 运行（因此需要上述 `--sysctl` 参数）；旧版本默认以 `root` 运行，若需非 root 用户运行，可添加 `--user haproxy`（或其他 UID）。  


### 方法二：直接挂载配置文件  

```console
$ docker run -d --name my-running-haproxy -v /path/to/etc/haproxy:/usr/local/etc/haproxy:ro --sysctl net.ipv4.ip_unprivileged_port_start=0 haproxy:2.3
```
- 主机 `/path/to/etc/haproxy` 目录需包含 `haproxy.cfg` 文件。  
- 若配置文件引用其他文件（如 `400.http`、`404.http` 等模板），需确保这些文件也存在于该目录中（简单配置通常无需额外文件）。  


### 重载配置  

若通过挂载方式使用配置文件，修改 `haproxy.cfg` 后，可向容器发送 `SIGHUP` 信号实现平滑重载：  

```console
$ docker kill -s HUP my-running-haproxy
```
镜像的入口脚本会将 `haproxy` 命令替换为上游的 `haproxy-systemd-wrapper`，负责信号处理以实现平滑重载。其底层使用 `haproxy -sf` 选项，在高负载下可能出现毫秒级连接失败窗口（详见 [HAProxy 启停说明]([])）。  


## 镜像变体  

`haproxy` 镜像提供多种变体，适用于不同场景：  


### `haproxy:<version>`  
默认镜像，适合大多数场景。若不确定需求，建议使用此版本。可作为临时容器（挂载代码并启动）或构建其他镜像的基础。  

部分标签包含版本代号（如 trixie），对应 [Debian 发行版]([])。如需安装额外依赖，建议显式指定代号以减少 Debian 版本更新带来的兼容性问题。  


### `haproxy:<version>-alpine`  
基于 [Alpine Linux]([])（[`alpine` 官方镜像]([])），体积更小（约 5MB），适合对镜像大小有严格要求的场景。  

**注意**：使用 `musl libc` 而非 `glibc`，部分依赖 glibc 的软件可能存在兼容性问题（详见 [相关讨论]([])）。Alpine 镜像通常不含额外工具（如 `git`、`bash`），需在 Dockerfile 中自行安装（参考 [alpine 镜像说明]([])）。  


## 许可  

查看本镜像包含软件的 [许可信息]([])。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础系统的 Bash 等），这些软件可能采用不同许可。  

自动检测到的额外许可信息可在 [repo-info 仓库的 `haproxy/` 目录]([]) 中查看。  

使用预构建镜像时，用户需自行确保符合所有包含软件的许可要求。</think># HAProxy Docker 镜像介绍


## 基础信息

### 维护方  
[Docker 社区]([])  


### 获取帮助渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

- [`3.3-dev9`、`3.3-dev`、`3.3-dev9-trixie`、`3.3-dev-trixie`]([])  
- [`3.3-dev9-alpine`、`3.3-dev-alpine`、`3.3-dev9-alpine3.22`、`3.3-dev-alpine3.22`]([])  
- [`3.2.6`、`3.2`、`latest`、`lts`、`3.2.6-trixie`、`3.2-trixie`、`trixie`、`lts-trixie`]([])  
- [`3.2.6-alpine`、`3.2-alpine`、`alpine`、`lts-alpine`、`3.2.6-alpine3.22`、`3.2-alpine3.22`、`alpine3.22`、`lts-alpine3.22`]([])  
- [`3.1.9`、`3.1`、`3.1.9-trixie`、`3.1-trixie`]([])  
- [`3.1.9-alpine`、`3.1-alpine`、`3.1.9-alpine3.22`、`3.1-alpine3.22`]([]

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/haproxy" title="library/haproxy Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/haproxy</a></p>

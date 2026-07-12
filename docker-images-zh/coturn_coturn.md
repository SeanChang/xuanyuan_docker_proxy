---
image: coturn/coturn
description: "这是基于coturn开源项目主分支的自动构建流程，用于持续集成并生成最新版本的TURN/STUN服务器软件，确保代码来源于主分支的最新提交，可支持WebRTC等实时通信场景下的NAT穿透需求，通过自动化构建提升开发效率与版本更新速度，适用于开发测试环境或需要及时获取主分支最新功能的部署场景。"
source: https://xuanyuan.cloud/zh/r/coturn/coturn
canonical: https://xuanyuan.cloud/zh/r/coturn/coturn
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/coturn/coturn" title="coturn/coturn Docker 镜像中文简介、标签列表与拉取命令">coturn/coturn 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Coturn TURN 服务器 Docker 镜像


[![Docker CI]([]  "Docker CI")] 
[![Docker Hub]([] "Docker Hub pulls")] 


[Docker Hub]  | [GitHub 容器仓库]  | [Quay.io]   

[更新日志]   


## 支持的标签及对应 Dockerfile 链接

- `4.7.0-r2`、`4.7.0-r2-debian`、`4.7.0`、`4.7.0-debian`、`4.7.0-trixie`、`4.7`、`4.7-debian`、`4.7-trixie`、`4`、`4-debian`、`4-trixie`、`debian`、`trixie`、`latest`  
  （基于 Debian 基础镜像，[Dockerfile 链接][d1]）  

- `4.7.0-r2-alpine`、`4.7.0-alpine`、`4.7.0-alpine3.22`、`4.7-alpine`、`4.7-alpine3.22`、`4-alpine`、`4-alpine3.22`、`alpine`、`alpine3.22`  
  （基于 Alpine Linux 基础镜像，[Dockerfile 链接][d2]）  


## 支持的平台

- `linux` 架构：`amd64`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`ppc64le`、`s390x`  


## 什么是 Coturn TURN 服务器？

TURN 服务器是一种 VoIP 媒体流量 NAT 穿透服务器和网关，也可作为通用网络流量 TURN 服务器和网关使用。  

> [github.com/coturn/coturn]   


## 如何使用此镜像

### 基本运行

运行容器即可启动 Coturn TURN 服务器：  
```bash
docker run -d -p 3478:3478 -p 3478:3478/udp -p 5349:5349 -p 5349:5349/udp -p 49152-65535:49152-65535/udp docker.xuanyuan.run/coturn/coturn
```


### 为什么开放这么多端口？

根据 [RFC 5766 第 6.2 节][RFC 5766 Section 6.2]，这些端口是 TURN 服务器用于媒体流量交换的端口。  

可通过 `min-port` 和 `max-port` 配置项修改端口范围：  
```bash
docker run -d -p 3478:3478 -p 3478:3478/udp -p 5349:5349 -p 5349:5349/udp -p 49160-49200:49160-49200/udp \
       docker.xuanyuan.run/coturn/coturn --min-port=49160 --max-port=49200
```

**推荐**直接使用主机网络（因为 Docker [处理大端口范围时性能较差][7]）：  
```bash
docker run -d --network=host docker.xuanyuan.run/coturn/coturn
```


### 配置方法

默认情况下，镜像使用 Coturn 的默认配置及 Dockerfile 中 `CMD` 指令指定的 CLI 选项。可通过以下方式自定义配置：

#### 1. 使用自定义配置文件

将本地配置文件挂载到容器内默认路径：  
```bash
docker run -d --network=host \
           -v $(pwd)/my.conf:/etc/coturn/turnserver.conf \
       docker.xuanyuan.run/coturn/coturn
```

#### 2. 直接指定命令行选项

启动时追加 CLI 选项覆盖默认配置：  
```bash
docker run -d --network=host docker.xuanyuan.run/coturn/coturn \
           -n --log-file=stdout \
           --min-port=49160 --max-port=49200 \
           --lt-cred-mech --fingerprint \
           --no-multicast-peers --no-cli \
           --no-tlsv1 --no-tlsv1_1 \
           --realm=my.realm.org  
```

#### 3. 指定其他路径的配置文件

通过 `-c` 参数指定自定义配置文件路径：  
```bash
docker run -d --network=host  \
           -v $(pwd)/my.conf:/my/coturn.conf \
       docker.xuanyuan.run/coturn/coturn -c /my/coturn.conf
```


### 自动检测外部 IP

可使用 `detect-external-ip` 工具在运行时自动检测 TURN 服务器的外部 IP。通过设置环境变量 `DETECT_EXTERNAL_IP`，可自动添加 `--external-ip=<检测到的外部 IP>` 参数；类似地，`DETECT_RELAY_IP`、`DETECT_EXTERNAL_IPV6`、`DETECT_RELAY_IPV6` 可用于添加 `--relay-ip` 或 IPv6 相关参数（多次使用仅计算一次值）：  

```bash
docker run -d --network=host \
           -e DETECT_EXTERNAL_IP=yes \
           -e DETECT_RELAY_IP=yes \
           docker.xuanyuan.run/coturn/coturn \
           -n --log-file=stdout
```

默认检测 [IPv4][IPv4] 地址，如需检测 [IPv6][IPv6] 地址，需添加 `--ipv6` 标志：  
```bash
docker run -d --network=host docker.xuanyuan.run/coturn/coturn \
           -n --log-file=stdout \
           --external-ip='$(detect-external-ip --ipv6)' \
           --relay-ip='$(detect-external-ip --ipv6)'
```


### 持久化

默认情况下，Coturn Docker 镜像将数据持久化在 `/var/lib/coturn/` 目录。使用 tmpfs 挂载该目录可提升性能：  
```bash
docker run -d --network=host --mount type=tmpfs,destination=/var/lib/coturn docker.xuanyuan.run/coturn/coturn
```


## 镜像版本说明

### `alpine` 变体

基于轻量级 [Alpine Linux 项目][1]（[alpine 官方镜像][2]）构建，镜像体积更小（约 5MB 基础镜像）。需注意其使用 [musl libc][4] 而非 [glibc][5]，部分依赖 glibc 的软件可能存在兼容性问题，但多数软件可正常运行。


### 标签格式说明

- `<X>`：最新主版本 `X` 的最新标签（多平台镜像）。  
- `<X.Y>`：最新次版本 `X.Y` 的最新标签（多平台镜像）。  
- `<X.Y.Z>-r<N>`/`<X.Y.Z.W>-r<N>`：具体版本 `X.Y.Z`（或 `X.Y.Z.W`）的第 `N` 次镜像修订标签（多平台镜像）。  
- `<X.Y.Z>-r<N>-<dist>`/`<X.Y.Z.W>-r<N>-<dist>`：具体版本在指定发行版（`alpine` 或 `debian`）上的第 `N` 次修订标签（多平台镜像）。  
- `<X.Y.Z>-r<N>-<dist>-<arch>`/`<X.Y.Z.W>-r<N>-<dist>-<arch>`：具体版本在指定发行版和架构上的第 `N` 次修订标签（单平台镜像）。  
- `edge-<dist>`：Coturn `master` 分支在指定发行版上的最新标签（多平台镜像）。  
- `edge-<dist>-<arch>`：Coturn `master` 分支在指定发行版和架构上的最新标签（单平台镜像）。  


## 许可证

Coturn 及其 Docker 镜像基于 [此许可证][90] 开源。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础发行版的 Bash 等），其许可证可能不同。使用前请确保遵守所有包含软件的相关许可证。


## 问题反馈

请勿在 [DockerHub][DockerHub] 或其他容器 registry 的评论区反馈问题或提问（我们无法及时查看）。  

如有问题或疑问，请通过 [GitHub issue][3] 联系我们。  


[DockerHub]: []]: ]:  5766 Section 6.2]: []]: []]: []]: []]: []]: []]: []]: []]: []]: []]: []

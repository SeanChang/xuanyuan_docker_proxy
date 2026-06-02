---
image: library/traefik
description: "Traefik 是一款专为云原生环境打造的边缘路由器，作为现代 HTTP 反向代理与负载均衡器，它能自动发现服务、动态配置路由规则，无缝集成 Kubernetes、Docker 等容器编排平台，简化微服务架构下的流量管理，支持 HTTPS、TLS 加密及多种协议，为云原生应用提供高效、安全、灵活的边缘流量处理能力。"
source: https://xuanyuan.cloud/zh/r/library/traefik
canonical: https://xuanyuan.cloud/zh/r/library/traefik
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [library/traefik — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/traefik)

含镜像标签、拉取命令、部署文档与相关推荐。

[library/traefik Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/library/traefik)

# Traefik Docker镜像介绍


## 快速参考

### 维护者  
[Traefik项目]([])


### 获取帮助  
[Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应Dockerfile链接  

### v3.5版本  
- **windowsservercore-ltsc2022基础镜像**：`v3.5.3-windowsservercore-ltsc2022`, `3.5.3-windowsservercore-ltsc2022`, `v3.5-windowsservercore-ltsc2022`, `3.5-windowsservercore-ltsc2022`, `v3-windowsservercore-ltsc2022`, `3-windowsservercore-ltsc2022`, `chabichou-windowsservercore-ltsc2022`, `windowsservercore-ltsc2022`  
  [Dockerfile链接]([])  

- **nanoserver-ltsc2022基础镜像**：`v3.5.3-nanoserver-ltsc2022`, `3.5.3-nanoserver-ltsc2022`, `v3.5-nanoserver-ltsc2022`, `3.5-nanoserver-ltsc2022`, `v3-nanoserver-ltsc2022`, `3-nanoserver-ltsc2022`, `chabichou-nanoserver-ltsc2022`, `nanoserver-ltsc2022`  
  [Dockerfile链接]([])  

- **Alpine基础镜像（默认）**：`v3.5.3`, `3.5.3`, `v3.5`, `3.5`, `v3`, `3`, `chabichou`, `latest`  
  [Dockerfile链接]([])  


### v2.11版本  
- **windowsservercore-ltsc2022基础镜像**：`v2.11.29-windowsservercore-ltsc2022`, `2.11.29-windowsservercore-ltsc2022`, `v2.11-windowsservercore-ltsc2022`, `2.11-windowsservercore-ltsc2022`, `v2-windowsservercore-ltsc2022`, `2-windowsservercore-ltsc2022`, `mimolette-windowsservercore-ltsc2022`  
  [Dockerfile链接]([])  

- **nanoserver-ltsc2022基础镜像**：`v2.11.29-nanoserver-ltsc2022`, `2.11.29-nanoserver-ltsc2022`, `v2.11-nanoserver-ltsc2022`, `2.11-nanoserver-ltsc2022`, `v2-nanoserver-ltsc2022`, `2-nanoserver-ltsc2022`, `mimolette-nanoserver-ltsc2022`  
  [Dockerfile链接]([])  

- **Alpine基础镜像**：`v2.11.29`, `2.11.29`, `v2.11`, `2.11`, `v2`, `2`, `mimolette`  
  [Dockerfile链接]([])  


## 更多快速参考  

### 问题反馈  
[GitHub Issues]([])  


### 支持的架构  
（[更多信息]([])）  
`amd64`([链接]([]))、`arm32v6`([链接]([]))、`arm64v8`([链接]([]))、`ppc64le`([链接]([]))、`riscv64`([链接]([]))、`s390x`([链接]([]))、`windows-amd64`([链接]([]))  


### 镜像详情  
[repo-info仓库的`traefik`目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
- [official-images仓库`library/traefik`标签]([])  
- [official-images仓库`library/traefik`文件]([])（[历史记录]([])）  


### 描述来源  
[docs仓库的`traefik`目录]([])（[历史记录]([])）  


![logo]([])


## Traefik简介  
[Traefik]([]) 是一款现代HTTP反向代理和入口控制器，可简化微服务部署。它能与现有基础设施组件（如Kubernetes、Docker、Swarm、Consul、Nomad、etcd、Amazon ECS等）集成，实现自动动态配置。只需将Traefik指向你的编排器，即可完成配置。


## 使用示例  

### Traefik v3  
#### 步骤1：配置文件  
创建`traefik.yml`，启用Docker provider和仪表盘UI：  
```yml
## traefik.yml

# Docker配置后端
providers:
  docker:
    defaultRule: "Host(`{{ trimPrefix `/` .Name }}.docker.localhost`)"

# API和仪表盘配置
api:
  insecure: true  # 允许未加密访问仪表盘（仅测试用）
```

#### 步骤2：启动Traefik  
```sh
docker run -d -p 8080:8080 -p 80:80 \
  -v $PWD/traefik.yml:/etc/traefik/traefik.yml \  # 挂载配置文件
  -v /var/run/docker.sock:/var/run/docker.sock \  # 挂载Docker socket（用于自动发现容器）
  traefik:v3
```

#### 步骤3：启动后端服务  
使用`traefik/whoami`镜像启动测试服务：  
```sh
docker run -d --name test traefik/whoami
```

#### 步骤4：访问服务  
通过Traefik的规则访问服务（`test.docker.localhost`）：  
```console
$ curl test.docker.localhost
Hostname: 0693100b16de
IP: 127.0.0.1
IP: ::1
IP: 192.168.215.4
RemoteAddr: 192.168.215.3:57618
GET / HTTP/1.1
Host: test.docker.localhost
User-Agent: curl/8.7.1
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 192.168.215.1
X-Forwarded-Host: test.docker.localhost
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: 8a37fd4f35fb
X-Real-Ip: 192.168.215.1
```

#### 步骤5：访问仪表盘  
在浏览器中打开`[]  
![Dashboard UI]([])  


### Traefik v2  
#### 步骤1：配置文件  
创建`traefik.yml`，配置与v3类似：  
```yml
## traefik.yml

# Docker配置后端
providers:
  docker:
    defaultRule: "Host(`{{ trimPrefix `/` .Name }}.docker.localhost`)"

# API和仪表盘配置
api:
  insecure: true
```

#### 步骤2：启动Traefik  
```sh
docker run -d -p 8080:8080 -p 80:80 \
-v $PWD/traefik.yml:/etc/traefik/traefik.yml \
-v /var/run/docker.sock:/var/run/docker.sock \
traefik:v2.11
```

#### 步骤3-5：启动服务、访问服务和仪表盘  
与v3步骤相同，仪表盘访问地址为`[]  


## 文档  
- v3.x 完整文档：[[]]([])  
- v2.11 文档：[[]]([])  
社区支持：[[]]([])  


## 镜像变体  

### `traefik:<version>`  
默认镜像，基于Alpine Linux，适合通用场景。可直接作为临时容器运行（挂载配置文件启动），也可作为基础镜像构建其他镜像。  


### `traefik:<version>-windowsservercore`  
基于Windows Server Core（`mcr.microsoft.com/windows/servercore`），仅在支持该基础镜像的环境中运行（如Windows 10专业版/企业版（周年更新）或Windows Server 2016）。  
Windows容器配置指南：[Windows Containers Quick Start]([])  


## 许可证  
- 镜像中软件的许可证信息：[Traefik LICENSE.md]([])  
- 基础镜像及依赖软件可能包含其他许可证，可参考[repo-info仓库的`traefik`目录]([])中的自动检测信息。  
使用前请确保遵守所有包含软件的许可证要求。

---
image: traefik/traefik
description: "非官方Traefik镜像，Traefik是一款用于反向代理和负载均衡的工具，建议使用官方镜像（https://hub.docker.com/_/traefik）。"
source: https://xuanyuan.cloud/zh/r/traefik/traefik
canonical: https://xuanyuan.cloud/zh/r/traefik/traefik
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/traefik/traefik" title="traefik/traefik Docker 镜像中文简介、标签列表与拉取命令">traefik/traefik — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/traefik/traefik" title="traefik/traefik Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/traefik/traefik</a>

# Traefik 镜像文档

## 镜像概述和主要用途

Traefik 是一款现代 HTTP 反向代理和入口控制器（ingress controller），旨在简化微服务部署流程。它能够与多种现有基础设施组件（如 Kubernetes、Docker、Swarm、Consul 等）无缝集成，并实现自动、动态的配置管理。用户仅需将 Traefik 指向目标编排工具，即可完成核心配置步骤，无需手动干预流量路由规则。

> **注意**：本镜像为非官方镜像，建议优先使用官方镜像：[https://hub.docker.com/_/traefik](https://hub.docker.com/_/traefik)

## 核心功能和特性

- **动态自动配置**：实时检测基础设施变化并自动更新路由规则，无需重启服务。
- **多平台集成**：原生支持 Kubernetes、Docker、Docker Swarm、Consul、Nomad、etcd、Amazon ECS 等多种编排和服务发现工具。
- **内置 API 和仪表盘**：提供 Web 仪表盘可视化展示路由、服务和中间件状态，支持通过 API 进行配置管理。
- **默认规则定义**：可通过配置文件预设路由规则模板，简化服务接入流程。
- **反向代理能力**：支持 HTTP/HTTPS 流量转发，自动处理 X-Forwarded-* 请求头，确保后端服务获取正确客户端信息。

## 使用场景和适用范围

- **微服务架构**：作为微服务集群的统一入口，管理跨服务流量路由和负载均衡。
- **容器化环境**：在 Docker、Kubernetes 等容器平台中，自动发现并代理容器服务。
- **多环境部署**：适用于开发、测试、生产等不同环境的反向代理需求，支持动态调整配置。
- **服务网格**：作为轻量级服务网格组件，处理服务注册、发现和流量控制。

## 使用方法和配置说明

### Traefik v3 使用示例

#### 1. 配置文件准备

创建 `traefik.yml` 配置文件，启用 Docker  provider 和仪表盘 UI：

```yaml
## traefik.yml

# Docker 配置后端
providers:
  docker:
    defaultRule: "Host(`{{ trimPrefix `/` .Name }}.docker.localhost`)"  # 默认路由规则：服务名.docker.localhost

# API 和仪表盘配置
api:
  insecure: true  # 允许不安全访问（仅用于测试环境，生产环境需配置 HTTPS）
```

#### 2. 启动 Traefik v3 容器

通过 Docker 运行 Traefik v3，映射端口并挂载配置文件和 Docker 套接字：

```bash
docker run -d -p 8080:8080 -p 80:80 \
  -v $PWD/traefik.yml:/etc/traefik/traefik.yml \
  -v /var/run/docker.sock:/var/run/docker.sock \
  traefik:v3
```

**参数说明**：
- `-p 8080:8080`：映射仪表盘和 API 端口
- `-p 80:80`：映射 HTTP 服务端口
- `-v $PWD/traefik.yml:/etc/traefik/traefik.yml`：挂载本地配置文件到容器内默认路径
- `-v /var/run/docker.sock:/var/run/docker.sock`：挂载 Docker 套接字，用于自动发现容器服务

#### 3. 部署后端服务

启动一个测试后端服务（使用 `traefik/whoami` 镜像）：

```bash
docker run -d --name test traefik/whoami
```

#### 4. 访问后端服务

通过 Traefik 访问服务，使用默认规则 `test.docker.localhost`（服务名 `test` 对应子域名）：

```bash
curl test.docker.localhost
```

**预期输出示例**：
```
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

#### 5. 访问 Traefik 仪表盘

打开浏览器访问 `http://localhost:8080`，查看路由、服务和中间件状态：

![Traefik v3 仪表盘](https://raw.githubusercontent.com/traefik/traefik/v3.2/docs/content/assets/img/webui-dashboard.png)

### Traefik v2 使用示例

#### 1. 配置文件准备

创建 `traefik.yml` 配置文件：

```yaml
## traefik.yml

# Docker 配置后端
providers:
  docker:
    defaultRule: "Host(`{{ trimPrefix `/` .Name }}.docker.localhost`)"

# API 和仪表盘配置
api:
  insecure: true
```

#### 2. 启动 Traefik v2 容器

运行 Traefik v2.11 版本：

```bash
docker run -d -p 8080:8080 -p 80:80 \
  -v $PWD/traefik.yml:/etc/traefik/traefik.yml \
  -v /var/run/docker.sock:/var/run/docker.sock \
  traefik:v2.11
```

#### 3. 部署后端服务及访问验证

同 v3 步骤 3-4，服务访问命令和预期输出类似：

```bash
docker run -d --name test traefik/whoami
curl test.docker.localhost
```

#### 4. 访问仪表盘

浏览器访问 `http://localhost:8080`：

![Traefik v2 仪表盘](https://raw.githubusercontent.com/traefik/traefik/v2.0/docs/content/assets/img/webui-dashboard.png)

## 参考文档和社区支持

- **官方文档**：
  - Traefik v3.x：[https://doc.traefik.io/traefik/](https://doc.traefik.io/traefik/)
  - Traefik v2.11：[https://doc.traefik.io/traefik/v2.11](https://doc.traefik.io/traefik/v2.11)
- **社区支持**：[https://community.traefik.io](https://community.traefik.io)

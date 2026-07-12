---
image: ubuntu/apache2
description: "Apache是一款安全且可扩展的开源HTTP服务器，提供由Canonical维护的长期支持版本。"
source: https://xuanyuan.cloud/zh/r/ubuntu/apache2
canonical: https://xuanyuan.cloud/zh/r/ubuntu/apache2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/apache2" title="ubuntu/apache2 Docker 镜像中文简介、标签列表与拉取命令">ubuntu/apache2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache2 | Ubuntu Docker镜像文档

## 镜像概述与主要用途

Canonical提供的Apache2 Docker镜像基于Ubuntu系统构建，旨在提供安全、高效的Web服务器环境。该镜像接收持续的安全更新，跟踪最新的Apache2版本与Ubuntu操作系统的组合，且完全免费使用，无用户速率限制。主要用途包括静态/动态内容托管、Web服务部署，适用于开发、测试及生产环境。


## 核心功能与特性

### Apache2 核心优势
Apache HTTP服务器项目致力于构建安全、高效且可扩展的HTTP服务器，作为符合标准的开源软件，长期保持互联网上最流行Web服务器的地位。

### 镜像特性
- **持续安全更新**：定期接收安全补丁，确保运行环境安全性。
- **长期支持（LTS）**：LTS通道提供长达5年的免费安全维护；通过Canonical的ESM（扩展安全维护）可获得最长10年的客户安全支持。
- **多架构支持**：兼容`amd64`、`arm64`、`ppc64el`、`s390x`等多种硬件架构。
- **通道稳定性保障**：镜像按`edge` → `beta` → `candidate` → `stable`序列发布，确保版本稳定性递进。


## 使用场景与适用范围
- **开发与测试环境**：快速部署Apache服务，验证Web应用功能。
- **生产环境**：依托Ubuntu的稳定性和安全更新，适用于企业级Web服务托管。
- **长期运行需求**：LTS/ESM支持满足对系统稳定性和安全性有严格要求的场景。
- **多架构部署**：支持混合云、边缘计算等跨架构部署需求。


## 使用方法与配置说明

### 本地部署

通过`docker run`命令启动镜像：

```bash
docker run -d --name apache2-container -e TZ=UTC -p 8080:80 docker.xuanyuan.run/ubuntu/apache2:2.4-22.04_beta
```

启动后可通过`http://localhost:8080`访问Apache服务器。


### 参数说明

| 参数 | 描述 |
|------|------|
| `-e TZ=UTC` | 设置容器时区（例如`UTC`、`Asia/Shanghai`）。 |
| `-p 8080:80` | 将容器内80端口映射到本地8080端口，暴露Web服务。 |
| `-v /local/path/to/website:/var/www/html` | 挂载本地网站目录到容器`/var/www/html`，自定义托管内容。 |
| `-v /path/to/apache2.conf:/etc/apache2/apache2.conf` | 挂载本地Apache配置文件（示例配置见[此处](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/apache2/plain/examples/config/apache2.conf?h=2.4-22.04)）。 |


### 测试与调试

#### 查看容器日志
```bash
docker logs -f apache2-container
```

#### 获取交互式Shell
```bash
docker exec -it apache2-container /bin/bash
```


### Kubernetes部署

#### 前置准备
1. 安装[MicroK8s](https://microk8s.io/)并启用必要组件：
   ```bash
   microk8s.enable dns storage
   snap alias microk8s.kubectl kubectl
   ```

2. 下载配置文件：
   - [apache2.conf](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/apache2/plain/examples/config/apache2.conf?h=2.4-22.04)
   - [index.html](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/apache2/plain/examples/config/html/index.html?h=2.4-22.04)
   - [apache2-deployment.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/apache2/plain/examples/apache2-deployment.yml?h=2.4-22.04)

#### 部署步骤
1. 创建配置映射：
   ```bash
   kubectl create configmap apache2-config --from-file=apache2=apache2.conf --from-file=apache2-site=index.html
   ```

2. 应用部署文件（需提前在`apache2-deployment.yml`中设置镜像标签，如`ubuntu/apache2:2.4-22.04_beta`）：
   ```bash
   kubectl apply -f apache2-deployment.yml
   ```

部署后通过`http://localhost:30080`访问服务。


## 标签与架构

### 可用标签与架构支持

| 通道标签 | 支持类型 | 当前版本 | 支持架构 |
|----------|----------|----------|----------|
| **`2.4-22.04_beta`** | ![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17) | Ubuntu 22.04 LTS上的Apache2 2.4 | `amd64`, `arm64`, `ppc64el`, `s390x` |
| `2.4-20.04_beta` | ![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17) | Ubuntu 20.04 LTS上的Apache2 2.4.41 | `amd64`, `arm64`, `ppc64el`, `s390x` |
| _`track_risk`_ | | | |

> **注**：斜体标签在`ubuntu/apache2`中不可用，仅为完整性展示。


### 通道稳定性说明
- **轨道（Track）**：应用版本与Ubuntu系列的组合（如`2.4-22.04`）。
- **通道顺序**：从稳定到不稳定依次为`stable` → `candidate` → `beta` → `edge`。风险较高的通道隐式可用（例如列出`beta`时可拉取`edge`）。
- **发布序列**：镜像严格按`edge` → `beta` → `candidate` → `stable`递进发布。


## 商业使用与扩展安全维护

若需商业再分发或访问未列出的通道/版本，通过[Canonical团队联系方式](https://ubuntu.com/security/docker-images#get-in-touch)（或邮件至rocks@canonical.com）获取支持。


## 问题反馈与功能请求

提交bug或功能请求：  
[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

**提交要求**：
- 标题格式：`apache2: <问题摘要>`
- 包含镜像完整摘要（通过以下命令获取）：
  ```bash
  docker images --no-trunc --quiet ubuntu/apache2:<标签>
  ```


## 废弃通道与标签

以下通道已停止更新，请升级至新通道：

| 轨道 | 版本 | 生命周期结束（EOL） | 升级路径 |
|------|------|---------------------|----------|
| ~~2.4-21.10~~ | Ubuntu 21.10上的Apache2 2.4.48 | 2022年7月 | 2.4-22.04_beta |
| ~~2.4-21.04~~ | Ubuntu 21.04上的Apache2 2.4.46 | 2022年1月 | ~~2.4-21.10~~ |
| _`track`_ | | | |

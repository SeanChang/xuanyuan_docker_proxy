---
image: wayofdev/nginx
description: "用于PHP开发的Nginx Docker镜像，支持SSL，基于轻量级Alpine，具备多架构支持。"
source: https://xuanyuan.cloud/zh/r/wayofdev/nginx
canonical: https://xuanyuan.cloud/zh/r/wayofdev/nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wayofdev/nginx" title="wayofdev/nginx Docker 镜像中文简介、标签列表与拉取命令">wayofdev/nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker镜像：Nginx

此**Docker镜像**提供了精简的**Nginx**设置，针对**本地PHP开发环境**进行了优化。

它旨在与[wayofdev/docker-php-dev](https://github.com/wayofdev/docker-php-dev)及其他(WOD)镜像无缝集成，为Web项目构建高效的本地开发生态系统。

## 🌟 为何选择此镜像进行本地开发？

- **基于Ansible的配置**：通过Ansible模板轻松自定义配置
- **优化PHP-FPM**：预配置用于PHP-FPM，支持快速本地测试和开发
- **SSL就绪**：内置HTTPS支持（使用自签名证书），在本地模拟生产环境
- **开发者友好**：内置工具和配置，提升本地开发工作流
- **灵活部署**：包含`k8s-alpine`变体，用于在本地测试Kubernetes设置
- **轻量级**：基于**Alpine Linux**，占用资源少，本地构建速度快
- **多架构支持**：支持**x86（AMD64）** 和**ARM64**架构，适配多种开发设备
- **定期更新**：持续维护和更新，与最新开发实践保持一致

适用于开发**Laravel**应用、**Symfony**项目或任何**PHP-based Web服务**，在本地环境中构建接近生产环境的开发环境。

提供创建、测试和调试Web应用的本地基础环境。

如果您**喜欢/使用**此镜像，请考虑⭐️**为其加星**。感谢！

## 📦 镜像变体

| 变体         | 描述                                                                 |
|--------------|----------------------------------------------------------------------|
| dev-alpine   | 用于本地开发环境，使用80和443端口。                                  |
| k8s-alpine   | 针对k8s和本地环境优化，使用8880和8443端口，无root权限。              |

## 🚀 使用方法

### → 拉取镜像

```bash
docker pull docker.xuanyuan.run/wayofdev/nginx:k8s-alpine-latest
```

将`k8s-alpine-latest`替换为您需要的类型和标签。

### → 可用镜像变体

- **类型**：k8s、dev
- **架构**：amd64、arm64

### → 在Docker Compose中使用

以下是典型设置的`docker-compose.yml`示例：

```yaml
services:
  app:
    image: docker.xuanyuan.run/wayofdev/php-dev:8.3-fpm-alpine-latest
    container_name: ${COMPOSE_PROJECT_NAME}-app
    restart: on-failure
    networks:
      - default
      - shared
    depends_on:
      - database
    links:
      - database
    volumes:
      - ./.github/assets:/assets:rw,cached
      - ./app:/app:rw,cached
      - ./.env:/app/.env
      - ~/.composer:/.composer
      - ~/.ssh:/home/www-data/.ssh
    environment:
      FAKETIME: '+2h'
      XDEBUG_MODE: '${XDEBUG_MODE:-off}'
      PHIVE_HOME: /app/.phive
    dns:
      - 8.8.8.8
    extra_hosts:
      - 'host.docker.internal:host-gateway'

  web:
    image: docker.xuanyuan.run/wayofdev/nginx:k8s-alpine-latest
    container_name: ${COMPOSE_PROJECT_NAME}-web
    restart: on-failure
    networks:
      - default
      - shared
    depends_on:
      - app
    links:
      - app
    volumes:
      - ./app:/app:rw,cached
      - ./.env:/app/.env
    labels:
      - traefik.enable=true
      - traefik.http.routers.api-${COMPOSE_PROJECT_NAME}-secure.rule=Host(`api.${COMPOSE_PROJECT_NAME}.docker`)
      - traefik.http.routers.api-${COMPOSE_PROJECT_NAME}-secure.entrypoints=websecure
      - traefik.http.routers.api-${COMPOSE_PROJECT_NAME}-secure.tls=true
      - traefik.http.services.api-${COMPOSE_PROJECT_NAME}-secure.loadbalancer.server.port=8880
      - traefik.docker.network=network.${SHARED_SERVICES_NAMESPACE}
```

#### 此配置包含

- 使用`wayofdev/php-dev`镜像的`app`服务，用于PHP处理。
- 使用[自定义Nginx镜像](https://github.com/wayofdev/docker-nginx)的`web`服务，用于提供应用访问。
- 默认网络和共享网络的配置。
- 应用代码、资源和配置文件的卷挂载。
- PHP和Xdebug配置的环境变量。
- 用于反向代理和SSL终止的Traefik标签。

#### 实际示例

有关如何在Docker Compose设置中使用此镜像的全面实际示例，请参考[wayofdev/laravel-starter-tpl](https://github.com/wayofdev/laravel-starter-tpl)仓库。该模板为Laravel项目提供了使用`wayofdev/php-dev`镜像的完整配置开发环境。

## ⚙️ 配置

Nginx镜像预配置为针对PHP应用的最佳性能，但您可以根据具体需求进一步自定义。

### → 默认配置

默认配置通过Ansible模板生成，包括：

- 针对PHP-FPM的优化设置
- 支持SSL/TLS的自签名证书
- 启用Gzip压缩
- 基本安全头

### → 自定义配置

虽然配置主要通过Ansible模板管理，但您可以通过以下方式进一步自定义：

1. **环境变量**：镜像使用以下环境变量：

   | 变量                  | 默认值   | 描述                         |
   |-----------------------|----------|------------------------------|
   | PHP_UPSTREAM_CONTAINER | app      | PHP-FPM容器名称              |
   | PHP_UPSTREAM_PORT      | 9000     | PHP-FPM容器端口              |

   在`docker-compose.yml`中设置这些变量：

   ```yaml
   services:
     web:
       image: docker.xuanyuan.run/wayofdev/nginx:k8s-alpine-latest
       environment:
         - PHP_UPSTREAM_CONTAINER=my-php-app
         - PHP_UPSTREAM_PORT=9001
   ```

2. **卷挂载**：如需更广泛的自定义，可挂载自己的配置文件：

   ```yaml
   services:
     web:
       image: docker.xuanyuan.run/wayofdev/nginx:k8s-alpine-latest
       volumes:
         - ./custom-nginx.conf:/etc/nginx/nginx.conf
         - ./custom-default.conf:/etc/nginx/conf.d/default.conf
   ```

### → SSL配置

镜像包含自签名SSL证书。如需使用自己的证书：

```yaml
services:
  web:
    image: docker.xuanyuan.run/wayofdev/nginx:k8s-alpine-latest
    volumes:
      - ./certs/cert.pem:/etc/nginx/ssl/cert.pem
      - ./certs/key.pem:/etc/nginx/ssl/key.pem
```

### → 高级配置

如需高级配置：

1. Fork此仓库
2. 修改`src`目录中的Ansible模板
3. 使用`make generate`重新生成Dockerfiles
4. 构建自定义镜像

## 🔨 开发

该项目使用一系列工具进行开发和测试。`Makefile`提供了简化开发流程的各种命令。

### → 依赖要求

- Docker
- Make
- Ansible
- goss和dgoss（用于测试）

### → 设置开发环境

克隆仓库：

```bash
git clone git@github.com:wayofdev/docker-nginx.git && \
cd docker-nginx
```

### → 生成Dockerfiles

Ansible用于生成Dockerfiles和配置。从Jinja模板源代码生成可分发的Dockerfiles：

```bash
make generate
```

### → 构建镜像

- 构建默认镜像：

  ```bash
  make build
  ```

  此命令构建Makefile中`IMAGE_TEMPLATE`变量指定的镜像。默认设置为`k8s-alpine`。

- 构建特定镜像：

  ```bash
  make build IMAGE_TEMPLATE="k8s-alpine"
  ```

  将`8.3-fpm-alpine`替换为所需的PHP版本、类型和操作系统。

- 构建所有镜像：

  ```bash
  make build IMAGE_TEMPLATE="k8s-alpine"
  make build IMAGE_TEMPLATE="dev-alpine"
  ```

  这些命令将构建所有支持的镜像变体。

## 🧪 测试

该项目采用测试方法确保Docker镜像的质量和功能。主要测试工具是[dgoss](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)，用于测试Docker容器。

### → 运行测试

可使用以下命令运行测试：

- 测试默认镜像：

  ```bash
  make test
  ```

  此命令测试Makefile中`IMAGE_TEMPLATE`变量指定的镜像（默认是`k8s-alpine`）。

- 测试特定镜像：

  ```bash
  make test IMAGE_TEMPLATE="k8s-alpine"
  ```

  将`k8s-alpine`替换为所需的镜像类型和操作系统。

- 测试所有镜像：

  ```bash
  make test IMAGE_TEMPLATE="k8s-alpine"
  make test IMAGE_TEMPLATE="dev-alpine"
  ```

### → 测试配置

测试配置在每个镜像变体的`goss.yaml`文件中定义，指定要运行的测试，包括：

- 文件存在性和权限
- 进程检查
- 端口可用性
- 包安装情况
- 命令输出

### → 测试流程

运行`make test`命令时，将执行以下步骤：

1. 构建指定的Docker镜像（如果尚未存在）。
2. dgoss针对Docker容器运行`goss.yaml`中定义的测试。
3. 测试结果显示在控制台中。

## 🔒 安全策略

该项目有[安全策略](.github/SECURITY.md)。

## 🙌 贡献指南

感谢您考虑为wayofdev社区做出贡献！我们欢迎各种形式的贡献。如果您想：

- 🤔 [提出功能建议](https://github.com/wayofdev/docker-nginx/issues/new?assignees=&labels=type%3A+enhancement&projects=&template=2-feature-request.yml&title=%5BFeature%5D%3A+)
- 🐛 [报告问题](https://github.com/wayofdev/docker-nginx/issues/new?assignees=&labels=type%3A+documentation%2Ctype%3A+maintenance&projects=&template=1-bug-report.yml&title=%5BBug%5D%3A+)
- 📖 [改进文档](https://github.com/wayofdev/docker-nginx/issues/new?assignees=&labels=type%3A+documentation%2Ctype%3A+maintenance&projects=&template=4-docs-bug-report.yml&title=%5BDocs%5D%3A+)
- 👨‍💻 [代码贡献](./.github/CONTRIBUTING.md)

欢迎参与。贡献前，请查阅我们的[贡献指南](.github/CONTRIBUTING.md)。

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge)](https://conventionalcommits.org)

## 🫡 贡献者

<p align="left">
<a href="https://github.com/wayofdev/docker-nginx/graphs/contributors">
<img align="left" src="https://img.shields.io/github/contributors-anon/wayofdev/docker-nginx?style=for-the-badge" alt="贡献者徽章"/>
</a>
<br>
<br>
</p>

## 🌐 社交链接

- **Twitter**：关注我们的组织[@wayofdev](https://twitter.com/intent/follow?screen_name=wayofdev)和作者[@wlotyp](https://twitter.com/intent/follow?screen_name=wlotyp)。
- **Discord**：加入我们的[Discord](https://discord.gg/CE3TcCC5vr)社区。

## ⚖️ 许可证

[![许可证](https://img.shields.io/github/license/wayofdev/docker-nginx?style=for-the-badge&color=blue)](./LICENSE.md)

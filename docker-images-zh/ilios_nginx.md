<!-- xuanyuan-docker-images-zh
image: ilios/nginx
source: https://xuanyuan.cloud/zh/r/ilios/nginx
canonical: https://xuanyuan.cloud/zh/r/ilios/nginx
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [ilios/nginx — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/ilios/nginx "ilios/nginx Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/ilios/nginx

# Ilios Docker镜像文档

## 镜像概述和主要用途
该仓库是官方Ilios Docker镜像的主页，包含在容器基础设施中运行这些镜像的示例配置。若需在容器环境中运行Ilios，`docker-compose.yml`文件可帮助理解各组件的协同工作方式。

## 核心功能和特性
- **自动构建与获取**：容器在Docker Hub自动构建，可通过https://hub.docker.com/u/ilios/访问
- **包含容器**：
  - php-fpm
  - nginx
  - mysql
  - mysql-demo
  - php-fpm-dev

## 使用场景和适用范围
示例配置文件暂不适用于生产环境，需根据实际环境定制，以确保MySQL和Ilios的数据在容器被移除或替换时不会丢失。主要适用于在容器环境中尝试运行Ilios的场景。

## 使用方法和配置说明
### 尝试运行Ilios容器的步骤
1. 克隆或[下载](https://github.com/ilios/docker/archive/master.zip)此仓库
2. [安装](https://docs.docker.com/compose/install/)Docker和docker-compose
3. 执行命令：`docker-compose -f demo-docker-compose.yml up -d`
4. 片刻后访问http://localhost:8000

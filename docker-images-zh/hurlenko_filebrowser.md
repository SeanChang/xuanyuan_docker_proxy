<!-- xuanyuan-docker-images-zh
image: hurlenko/filebrowser
source: https://xuanyuan.cloud/zh/r/hurlenko/filebrowser
canonical: https://xuanyuan.cloud/zh/r/hurlenko/filebrowser
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [hurlenko/filebrowser — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/hurlenko/filebrowser "hurlenko/filebrowser Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/hurlenko/filebrowser

# [filebrowser](https://github.com/filebrowser/filebrowser) Docker容器镜像

## 简介

filebrowser提供了一个基于Web的文件管理界面，可用于上传、删除、预览、重命名和编辑文件。它允许创建多个用户，每个用户可以拥有自己的目录。可作为独立应用或中间件使用。

## 目录
- [截图](#截图)
- [特性](#特性)
- [使用方法](#使用方法)
  - [Docker](#docker)
  - [docker-compose](#docker-compose)
  - [Nginx代理配置](#nginx代理配置)
  - [端口说明](#端口说明)
  - [支持的环境变量](#支持的环境变量)
  - [支持的卷](#支持的卷)
  - [附加多个目录](#附加多个目录)
- [构建镜像](#构建镜像)

## 截图

### 桌面版

![预览](https://user-images.githubusercontent.com/5447088/50716739-ebd26700-107a-11e9-9817-14230c53efd2.gif)

### 移动设备

| | |
|---|---|
![预览](https://user-images.githubusercontent.com/18035960/67269128-c7873000-f4be-11e9-89be-1fe33c3e973c.png) | ![预览](https://user-images.githubusercontent.com/18035960/67269151-d4a41f00-f4be-11e9-9b10-ec08c3a96692.png)

## 特性

- 可通过环境变量配置
- 可使用不同用户运行
- 支持多种架构，已在Ubuntu 18.04 (`amd64`)、Rock64 (`arm64`)和树莓派 (`arm32`)上测试

## 使用方法

### Docker

```bash
docker run -d --name filebrowser -p 80:8080 hurlenko/filebrowser
```

以当前用户身份运行并映射自定义卷位置：

```bash
docker run -d \
    --name filebrowser \
    --user $(id -u):$(id -g) \
    -p 8080:8080 \
    -v /数据目录:/data \
    -v /配置目录:/config \
    -e FB_BASEURL=/filebrowser \
    hurlenko/filebrowser
```

### docker-compose

最小化的`docker-compose.yml`配置：

```yaml
version: "3"

services:
  filebrowser:
    image: hurlenko/filebrowser
    user: "${UID}:${GID}"
    ports:
      - 443:8080
    volumes:
      - /数据目录:/data
      - /配置目录:/config
    environment:
      - FB_BASEURL=/filebrowser
    restart: always
```

运行命令：

```bash
docker-compose up
```

### Nginx代理配置

Nginx配置示例：

```nginx
location /filebrowser {
    # 防止502错误
    proxy_buffers 8 32k;
    proxy_buffer_size 64k;

    client_max_body_size 75M;

    # 重定向所有HTTP流量到localhost:8080
    proxy_pass http://localhost:8080;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    # 启用WebSocket支持
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_read_timeout 999999999;
}
```

### 端口说明

- `8080` - 默认filebrowser端口

### 支持的环境变量

环境变量以`FB_`为前缀，后跟大写的选项名称。例如，要通过环境变量设置"database"，应设置FB_DATABASE。可用选项列表可在[此处](https://filebrowser.org/cli/filebrowser#options)找到。

### 支持的卷

- `/data` - 要浏览的数据目录
- `/config` - `filebrowser.db`数据库文件位置

### 附加多个目录

若要附加多个目录，需将它们挂载为容器内数据目录(`默认是/data`)的子目录：

```bash
docker run \
    -v /路径/音乐:/data/music \
    -v /路径/电影:/data/movies \
    -v /路径/照片:/data/photos \
    hurlenko/filebrowser
```

## 构建镜像

```bash
git clone https://github.com/hurlenko/filebrowser-docker
cd filebrowser-docker
docker build -t hurlenko/filebrowser .
```

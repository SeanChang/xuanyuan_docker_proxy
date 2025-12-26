---
id: 7
title: 手把手教你在 Docker 中部署 Home Assistant
slug: docker-home-assistant
summary: 本文详细介绍在Docker中部署Home Assistant的全流程，含从轩辕镜像查看详情、多种方式拉取镜像，提供快速部署、持久化挂载（推荐）、docker-compose部署三种方案，还包含结果验证方法与常见问题解决办法。
category: Docker,Home Assistant
tags: home-assistant,docker,部署教程
image_name: homeassistant/home-assistant
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-home-assistant.png"
status: published
created_at: "2025-10-03 07:50:22"
updated_at: "2025-10-08 06:46:16"
---

# 手把手教你在 Docker 中部署 Home Assistant

> 本文详细介绍在Docker中部署Home Assistant的全流程，含从轩辕镜像查看详情、多种方式拉取镜像，提供快速部署、持久化挂载（推荐）、docker-compose部署三种方案，还包含结果验证方法与常见问题解决办法。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1、查看 Home Assistant 镜像详情
你可以在 轩辕镜像 中找到 Home Assistant 镜像页面：
👉 [https://xuanyuan.cloud/r/homeassistant/home-assistant](https://xuanyuan.cloud/r/homeassistant/home-assistant)

在镜像页面中，你会看到多种拉取方式，下面我们逐一说明如何部署。


## 2、下载 Home Assistant 镜像

### 2.1 使用轩辕镜像登录验证方式拉取
```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:stable
```

### 2.2 拉取后改名
```bash
docker pull docker.xuanyuan.run/homeassistant/home-assistant:stable \
&& docker tag docker.xuanyuan.run/homeassistant/home-assistant:stable homeassistant/home-assistant:stable \
&& docker rmi docker.xuanyuan.run/homeassistant/home-assistant:stable
```

**说明**：
- docker pull：从轩辕镜像拉取 Home Assistant 镜像，加速下载
- docker tag：将镜像重命名为官方标准名称，便于后续操作
- docker rmi：删除临时镜像标签，避免冗余占用空间

### 2.3 使用免登录方式拉取（推荐）
```bash
docker pull xxx.xuanyuan.run/homeassistant/home-assistant:stable \
&& docker tag xxx.xuanyuan.run/homeassistant/home-assistant:stable homeassistant/home-assistant:stable \
&& docker rmi xxx.xuanyuan.run/homeassistant/home-assistant:stable
```

### 2.4 官方直连方式
若网络环境良好，或已配置轩辕镜像访问支持器，可直接拉取：
```bash
docker pull homeassistant/home-assistant:stable
```

### 2.5 查看镜像是否拉取成功
```bash
docker images
```

若输出类似以下内容，说明镜像下载成功：
```
REPOSITORY                   TAG       IMAGE ID       CREATED         SIZE
homeassistant/home-assistant stable    123abc456def   1 week ago      2.1GB
```


## 3、部署 Home Assistant
以下使用已下载的 `homeassistant/home-assistant:stable` 镜像，提供三种部署方案，可根据场景选择。

### 3.1 快速部署（最简方式）
适合测试或临时使用，命令如下：
```bash
docker run -d --name home-assistant \
  --restart unless-stopped \
  -p 8123:8123 \
  homeassistant/home-assistant:stable
```

**核心参数说明**：
- --name home-assistant：容器名称，便于管理
- --restart unless-stopped：保证容器意外退出时自动重启
- -p 8123:8123：映射宿主机 8123 端口，Home Assistant 默认端口

**验证方式**：
浏览器访问 `http://服务器IP:8123`，应显示 Home Assistant 初始化页面。

### 3.2 持久化挂载目录（推荐方式）
Home Assistant 会存储大量配置文件（如自动化脚本、设备配置、日志等），必须挂载本地目录，保证重启后配置不会丢失。

第一步：创建宿主机目录
```bash
mkdir -p /data/homeassistant/config
```

第二步：启动容器并挂载目录
```bash
docker run -d --name home-assistant \
  --restart unless-stopped \
  -p 8123:8123 \
  -v /etc/localtime:/etc/localtime:ro \   # 与宿主机保持一致的时区
  -v /data/homeassistant/config:/config \ # 配置文件持久化目录
  --privileged \                          # 允许访问硬件（USB/Zigbee网关）
  homeassistant/home-assistant:stable
```

**目录映射说明**：
| 宿主机目录               | 容器内目录       | 用途                     |
|--------------------------|------------------|--------------------------|
| /data/homeassistant/config | /config          | 存放 Home Assistant 配置文件 |
| /etc/localtime           | /etc/localtime   | 保持时区一致             |

### 3.3 docker-compose 部署（适合企业/长期运行）
推荐使用 docker-compose 管理，便于一键启动/停止。

第一步：创建 `docker-compose.yml` 文件
```yaml
version: '3'
services:
  homeassistant:
    image: homeassistant/home-assistant:stable
    container_name: home-assistant
    restart: unless-stopped
    ports:
      - "8123:8123"
    volumes:
      - ./config:/config
      - /etc/localtime:/etc/localtime:ro
    privileged: true
```

第二步：启动服务
```bash
docker compose up -d
```

**补充说明**：
- 修改配置文件：直接编辑 config 目录下的 YAML 文件
- 停止服务：`docker compose down`
- 查看状态：`docker compose ps`


## 4、结果验证

### 浏览器验证
访问 `http://服务器IP:8123`，应显示 Home Assistant 初始化界面。第一次启动会提示创建用户和设置语言。

### 查看容器状态
```bash
docker ps
```
若 STATUS 为 Up，说明运行正常。

### 查看容器日志
```bash
docker logs -f home-assistant
```
无报错信息即可正常使用。


## 5、常见问题（FAQ）

### 5.1 访问不到 Home Assistant？
排查方向：
- 端口：确认 8123 已开放
  ```bash
  ufw allow 8123/tcp
  ```
  或
  ```bash
  firewalld --add-port=8123/tcp --permanent && firewall-cmd --reload
  ```
- 端口冲突：执行 `netstat -tuln | grep 8123`，检查是否被其他进程占用
- 容器未启动：`docker ps -a` 检查状态

### 5.2 如何接入智能硬件（Zigbee、USB 设备等）？
1. 确保启动参数中加了 `--privileged` 或 `--device=/dev/ttyUSB0`
2. 挂载宿主机的串口设备：
   ```bash
   docker run -d --name home-assistant \
     --restart unless-stopped \
     -p 8123:8123 \
     -v /data/homeassistant/config:/config \
     --device /dev/ttyUSB0:/dev/ttyUSB0 \
     homeassistant/home-assistant:stable
   ```
3. 在 Home Assistant 配置页面中添加对应的集成

### 5.3 配置文件在哪里？
所有配置文件都在 `/data/homeassistant/config`，常见文件：
- configuration.yaml：核心配置文件
- automations.yaml：自动化规则
- scripts.yaml：脚本
- home-assistant.log：日志

### 5.4 如何更新 Home Assistant？
```bash
docker pull homeassistant/home-assistant:stable
docker stop home-assistant
docker rm home-assistant
docker run -d ... （保持原有参数）
```
或使用 docker-compose：
```bash
docker compose pull
docker compose up -d
```

### 5.5 时区不正确？
容器启动时加上：
```bash
-v /etc/localtime:/etc/localtime:ro
```
即可保持与宿主机一致。


## 结尾
至此，你已掌握基于 轩辕镜像 的 Home Assistant 镜像拉取与 Docker 部署全流程。

- 初学者可从 快速部署 入手，体验智能家居平台功能
- 实际项目建议使用 持久化挂载，避免配置丢失
- 企业或长期运行建议选择 docker-compose 管理，方便维护升级

在此基础上，你还可以扩展 Home Assistant 的强大功能，例如：接入 Zigbee、MQTT、语音助手、自动化场景等，让智能家居真正服务于生活。


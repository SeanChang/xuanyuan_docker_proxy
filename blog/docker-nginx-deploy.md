---
id: 1
title: 手把手教你使用 Docker 部署 Nginx 教程
slug: docker-nginx-deploy
summary: 本文详细介绍了基于轩辕镜像的 Nginx 镜像拉取方法（含登录验证、免登录（推荐）、官方直连等方式），以及三种适合不同场景的 Docker 部署方案（快速部署用于测试、目录挂载用于实际项目、docker-compose 用于企业级场景），同时提供了服务验证步骤和常见问题解决方案（如端口访问、HTTPS 配置、日志切割、时区修正），内容循序渐进、操作指令完整，专为初学者设计，可直接对照执行完成 Nginx 部署。
category: Docker,Nginx
tags: nginx,docker,部署教程
image_name: library/nginx
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-nginx.png"
status: published
created_at: "2025-10-02 12:22:54"
updated_at: "2025-10-08 06:47:26"
---

# 手把手教你使用 Docker 部署 Nginx 教程

> 本文详细介绍了基于轩辕镜像的 Nginx 镜像拉取方法（含登录验证、免登录（推荐）、官方直连等方式），以及三种适合不同场景的 Docker 部署方案（快速部署用于测试、目录挂载用于实际项目、docker-compose 用于企业级场景），同时提供了服务验证步骤和常见问题解决方案（如端口访问、HTTPS 配置、日志切割、时区修正），内容循序渐进、操作指令完整，专为初学者设计，可直接对照执行完成 Nginx 部署。

在开始Nginx镜像拉取与部署操作前，我们先简要明确Nginx的核心价值与Docker部署的优势——这能帮助你更清晰地理解后续操作的意义。

## 关于 Nginx：核心功能与价值
Nginx 是一款轻量级、高性能的 HTTP 服务器与反向代理服务器，也是当前企业级 Web 服务中最常用的组件之一。它的核心作用可概括为四大类：  
- **静态服务**：直接搭建静态网页服务（如官网、产品文档、前端打包后的单页应用），支持高效处理静态资源（HTML、CSS、JS、图片等）；  
- **反向代理**：作为客户端与后端服务的“中间层”，转发请求至后端 API 或应用服务器（如 Tomcat、Node.js），隐藏真实服务地址，提升安全性；  
- **负载均衡**：面对高并发场景时，将请求均匀分发到多台后端机器，避免单点服务器过载，保障服务稳定性；  
- **SSL 终端**：统一处理 HTTPS 加密解密，管理 SSL 证书，无需后端服务单独配置 HTTPS，简化整体架构。  

其最大特点是**轻量（占用资源少）、稳定（故障率低）、高并发（单实例可支撑数万并发连接）**，因此成为中小微企业到大型互联网公司的“标配”服务组件。


## 为什么用 Docker 部署 Nginx？核心优势
传统方式部署 Nginx（如通过 `yum`/`apt` 安装、源码编译）常面临**环境不一致、依赖冲突、配置隔离差、迁移繁琐**等问题（例如：开发机上正常运行的 Nginx，到生产服务器因系统库版本不同启动失败；多服务混布时，Nginx 配置错误可能影响其他应用）。而 Docker 部署能完美解决这些痛点，核心优势如下：  

1. **环境绝对一致**：Nginx 镜像已打包所有运行依赖（系统库、配置模板、基础环境），无论在开发机、测试机还是生产服务器，只要能运行 Docker，Nginx 就能“开箱即用”，彻底避免“本地能跑、线上报错”；  
2. **轻量高效**：Docker 容器是进程级隔离，比虚拟机占用资源少 80% 以上，Nginx 容器启动仅需**秒级**，且可灵活限制 CPU/内存占用，避免资源浪费；  
3. **服务隔离安全**：Nginx 容器与主机、其他服务（如 MySQL、Redis）完全隔离，即使 Nginx 配置出错或崩溃，也不会影响其他应用，降低故障扩散风险；  
4. **快速迭代与回滚**：更新 Nginx 只需拉取新镜像、重启容器（10 秒内完成）；若新版本有问题，删除新容器、启动旧版本镜像即可回滚，比传统部署的“卸载-重装”高效 10 倍以上；  
5. **简化运维管理**：通过 `docker` 命令或 `docker-compose` 可一键实现 Nginx 启停、日志查看、状态监控（如 `docker logs nginx-web` 直接看日志），新手也能快速上手。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1、查看 Nginx 镜像
你可以在 **轩辕镜像** 中找到 Nginx 镜像页面：
👉 [https://xuanyuan.cloud/r/library/nginx](https://xuanyuan.cloud/r/library/nginx)

在页面中会看到多种拉取方式，下面我们逐一说明。

## 2、下载 Nginx 镜像

### 2.1 使用轩辕镜像登录验证的方式拉取
```bash
docker pull docker.xuanyuan.run/library/nginx:latest
```

### 2.2 拉取后改名
```bash
docker pull docker.xuanyuan.run/library/nginx:latest \
&& docker tag docker.xuanyuan.run/library/nginx:latest library/nginx:latest \
&& docker rmi docker.xuanyuan.run/library/nginx:latest
```

#### 说明：
- `docker pull`：从轩辕镜像访问支持拉取镜像
- `docker tag`：将镜像重命名为官方标准名称 `library/nginx:latest`，后续运行命令更简洁
- `docker rmi`：删除临时镜像标签，避免占用额外存储空间

### 2.3 使用免登录方式拉取（推荐）
基础拉取命令：
```bash
docker pull xxx.xuanyuan.run/library/nginx:latest
```

带重命名的完整命令：
```bash
docker pull xxx.xuanyuan.run/library/nginx:latest \
&& docker tag xxx.xuanyuan.run/library/nginx:latest library/nginx:latest \
&& docker rmi xxx.xuanyuan.run/library/nginx:latest
```

#### 说明：
免登录方式无需配置账户信息，新手可直接使用；镜像内容与 `docker.xuanyuan.run` 源完全一致，仅拉取地址不同。

### 2.4 官方直连方式
若网络可直连 Docker Hub，或已配置轩辕镜像访问支持器，可直接拉取官方镜像：
```bash
docker pull library/nginx:latest
```

### 2.5 查看镜像是否拉取成功
```bash
docker images
```

若输出类似以下内容，说明镜像下载成功：
```
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
library/nginx       latest    f652ca386ed1   2 weeks ago    142MB
```


## 3、部署 Nginx
以下使用已下载的 `library/nginx:latest` 镜像，提供三种部署方案，可根据场景选择。

### 3.1 快速部署（最简方式）
适合测试或临时使用，命令如下：
```bash
# 启动 Nginx 容器，命名为 nginx-test
# 宿主机 80 端口映射到容器 80 端口（Nginx 默认端口）
docker run -d --name nginx-test -p 80:80 library/nginx:latest
```

#### 核心参数说明：
- `--name nginx-test`：为容器指定名称，便于后续管理（如停止、重启）
- `-p 80:80`：端口映射，格式为「宿主机端口:容器端口」
- `-d`：后台运行容器

#### 验证方式：
浏览器访问 `http://服务器IP`，应显示 Nginx 官方欢迎页。

### 3.2 挂载目录（推荐方式，适合实际项目）
通过挂载宿主机目录，实现「配置持久化」「日志分离」「网页文件独立管理」，步骤如下：

#### 第一步：创建宿主机目录
```bash
# 一次性创建 html（网页）、conf（配置）、logs（日志）三个目录
mkdir -p /data/nginx/{html,conf,logs}
```

#### 第二步：准备测试网页
```bash
# 向 html 目录写入测试内容
echo "Hello from Xuanyuan Nginx!" > /data/nginx/html/index.html
```

#### 第三步：启动容器并挂载目录
```bash
docker run -d --name nginx-web \
  -p 80:80 -p 443:443 \  # 映射 HTTP(80) 和 HTTPS(443) 端口
  -v /data/nginx/html:/usr/share/nginx/html \  # 网页目录挂载
  -v /data/nginx/conf:/etc/nginx/conf.d \      # 配置目录挂载
  -v /data/nginx/logs:/var/log/nginx \        # 日志目录挂载
  library/nginx:latest
```

#### 目录映射说明：
| 宿主机目录          | 容器内目录                | 用途                 |
|---------------------|---------------------------|----------------------|
| `/data/nginx/html`  | `/usr/share/nginx/html`   | 存放网页文件（如 HTML、CSS） |
| `/data/nginx/conf`  | `/etc/nginx/conf.d`       | 存放 Nginx 配置文件   |
| `/data/nginx/logs`  | `/var/log/nginx`          | 存放访问日志、错误日志 |

#### 第四步：配置文件示例
新建 Nginx 基础配置文件 `/data/nginx/conf/default.conf`：
```nginx
server {
    listen       80;          # 监听 80 端口（HTTP）
    server_name  _;           # 匹配所有域名（可替换为实际域名，如 example.com）

    root   /usr/share/nginx/html;  # 网页根目录
    index  index.html;             # 默认首页

    access_log  /var/log/nginx/access.log;  # 访问日志路径
    error_log   /var/log/nginx/error.log;   # 错误日志路径

    # 处理请求的核心规则
    location / {
        try_files $uri $uri/ =404;  # 尝试访问文件/目录，不存在则返回 404
    }
}
```

#### 配置更新后重启容器
修改配置文件后，需重启容器使配置生效：
```bash
docker restart nginx-web
```

### 3.3 docker-compose 部署（适合企业级场景）
通过 `docker-compose.yml` 统一管理容器配置，支持一键启动/停止，步骤如下：

#### 第一步：创建 docker-compose.yml 文件
```yaml
version: '3'  # 指定 docker-compose 语法版本
services:
  nginx:
    image: library/nginx:latest  # 使用的镜像
    container_name: nginx-service  # 容器名称
    ports:
      - "80:80"   # HTTP 端口映射
      - "443:443" # HTTPS 端口映射
    volumes:
      - ./html:/usr/share/nginx/html   # 网页目录（相对路径，与 yml 同目录）
      - ./conf:/etc/nginx/conf.d       # 配置目录
      - ./logs:/var/log/nginx          # 日志目录
    restart: always  # 容器退出后自动重启（保障服务可用性）
```

#### 第二步：启动服务
在 `docker-compose.yml` 所在目录执行：
```bash
docker compose up -d
```

#### 补充说明：
- 若需修改配置/网页，直接操作当前目录下的 `html`、`conf` 文件夹即可
- 停止服务命令：`docker compose down`
- 查看服务状态：`docker compose ps`


## 4、结果验证
通过以下方式确认 Nginx 服务正常运行：

1. **浏览器验证**：  
   访问 `http://服务器IP`，应显示之前写入的测试内容（`Hello from Xuanyuan Nginx!`）或 Nginx 欢迎页。

2. **查看容器状态**：  
   ```bash
   docker ps
   ```
   若 `STATUS` 列显示 `Up`，说明容器正常运行。

3. **查看容器日志**：  
   以 `nginx-web` 容器为例（若用 `docker-compose` 则为 `nginx-service`）：
   ```bash
   docker logs nginx-web
   ```
   无报错信息即表示服务启动正常。


## 5、常见问题

### 5.1 访问不到网页？
排查方向：
- **安全组**：检查云服务器安全组是否放行 80（HTTP）、443（HTTPS）端口
- **防火墙**：检查服务器本地防火墙（如 `ufw` 或 `firewalld`）是否开放对应端口
  - `ufw` 开放端口：`sudo ufw allow 80/tcp && sudo ufw allow 443/tcp`
  - `firewalld` 开放端口：`sudo firewall-cmd --add-port=80/tcp --permanent && sudo firewall-cmd --add-port=443/tcp --permanent && sudo firewall-cmd --reload`
- **端口冲突**：执行 `netstat -tuln | grep 80` 查看 80 端口是否被其他进程占用，若占用需更换宿主机端口（如 `-p 8080:80`）

### 5.2 如何启用 HTTPS？
1. **准备证书**：获取 SSL 证书文件（通常包含 `fullchain.pem` 证书链和 `privkey.pem` 私钥），放到宿主机目录（如 `/data/nginx/certs`）。
2. **挂载证书目录**：在容器启动命令中添加证书挂载参数：
   ```bash
   -v /data/nginx/certs:/etc/nginx/certs
   ```
3. **修改 Nginx 配置**：更新 `default.conf`，添加 HTTPS 监听规则：
   ```nginx
   server {
       listen 443 ssl;  # 监听 443 端口（HTTPS）
       server_name 你的域名;  # 替换为实际域名（如 example.com）

       # 证书路径（容器内路径，对应宿主机 /data/nginx/certs）
       ssl_certificate     /etc/nginx/certs/fullchain.pem;
       ssl_certificate_key /etc/nginx/certs/privkey.pem;

       root   /usr/share/nginx/html;
       index  index.html;
   }
   ```
4. **重启容器**：`docker restart nginx-web`

### 5.3 日志文件过大怎么办？
- **方案1：使用 logrotate 切割日志**（推荐）：  
  在宿主机创建 `/etc/logrotate.d/nginx` 配置文件，设置日志切割规则（如按天切割、保留 7 天）：
  ```conf
  /data/nginx/logs/*.log {
      daily
      rotate 7
      compress
      delaycompress
      missingok
      notifempty
      create 0640 root root
  }
  ```
- **方案2：日志收集系统**：  
  配合 ELK Stack（Elasticsearch + Logstash + Kibana）或 Loki 等工具，实现日志集中收集、存储和分析。

### 5.4 容器内时区不正确？
在启动容器时，通过 `-e` 参数设置时区（以上海时区 `Asia/Shanghai` 为例）：
```bash
docker run -d -e TZ=Asia/Shanghai \
  --name nginx-web \
  -p 80:80 -p 443:443 \
  -v /data/nginx/html:/usr/share/nginx/html \
  -v /data/nginx/conf:/etc/nginx/conf.d \
  -v /data/nginx/logs:/var/log/nginx \
  library/nginx:latest
```

## 结尾
至此，你已掌握基于轩辕镜像的Nginx镜像拉取与Docker部署全流程——从镜像下载验证，到不同场景的部署实践，再到问题排查，每个步骤都配备了完整的操作命令和说明。对于初学者而言，建议先从「快速部署」熟悉流程，再尝试「目录挂载」方案理解持久化配置的意义，最后根据需求进阶到「docker-compose」管理。

在实际使用中，若遇到文档未覆盖的问题，可结合`docker logs 容器名`查看日志定位原因，或参考Nginx官方文档补充学习。随着实践深入，你还可以基于本文基础，进一步探索Nginx的反向代理、负载均衡、HTTPS高级配置等功能，让Nginx更好地支撑你的业务需求。


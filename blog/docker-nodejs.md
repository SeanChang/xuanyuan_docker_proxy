# Docker 容器化部署 Node.js 全指南

![Docker 容器化部署 Node.js 全指南](https://img.xuanyuan.dev/docker/blog/docker-node.png)

*分类: Docker,Node | 标签: nodejs,docker,部署教程 | 发布时间: 2025-10-03 07:43:00*

> 本文介绍如何在轩辕镜像查看Node.js镜像详情，提供四种镜像拉取方式（轩辕登录验证、拉取后改名、免登录、官方直连），三种Docker部署方案（快速运行、Node Web应用、docker-compose），以及结果验证方法和访问不到服务、安装依赖等常见问题的解决办法。
> 

### Node.js 简介

Node.js 是一个基于 Chrome V8 引擎的 JavaScript 运行时环境，它打破了传统浏览器对 JavaScript 的限制，允许开发者使用 JavaScript 编写服务器端代码。其核心特点是采用非阻塞、事件驱动的 I/O 模型，非常适合构建高性能、高并发的网络应用，如 API 服务、实时通信应用、微服务等。

Node.js 拥有全球最大的开源库生态系统之一——npm（Node Package Manager），提供了超过 200 万个可复用的包，能极大提升开发效率。无论是前端工程化工具（如 Webpack、Vite），还是后端服务开发，Node.js 都占据着重要地位。


### 为什么用 Docker 部署 Node.js？

Docker 是一种轻量级容器化技术，使用 Docker 部署 Node.js 应用能带来诸多优势：

1. **环境一致性**：Docker 容器封装了应用运行所需的全部依赖（Node.js 版本、npm 包、系统库等），确保应用在开发、测试、生产环境中表现一致，彻底解决"在我电脑上能运行"的经典问题。

2. **隔离性**：容器之间相互隔离，不同 Node.js 应用（甚至不同版本的 Node.js）可以在同一台服务器上独立运行，避免依赖冲突和资源抢占。

3. **快速部署与扩展**：Docker 镜像可快速分发和启动，配合编排工具（如 Docker Compose、Kubernetes），能实现 Node.js 应用的秒级启停和弹性扩展。

4. **版本控制**：Docker 镜像支持版本标签管理，可轻松回滚到历史版本，便于应用迭代和问题排查。

5. **资源高效**：相比传统虚拟机，容器共享宿主机内核，启动更快、占用资源更少，能在有限服务器资源上部署更多 Node.js 应用。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1、查看 Node.js 镜像详情
你可以在 **轩辕镜像** 中找到 Node.js 镜像页面：
👉 [https://xuanyuan.cloud/r/library/node](https://xuanyuan.cloud/r/library/node)

在镜像页面中，你会看到多种拉取方式，下面我们逐一说明如何部署。


## 2、下载 Node.js 镜像
### 2.1 使用轩辕镜像登录验证的方式拉取
```bash
docker pull docker.xuanyuan.run/library/node:latest
```

### 2.2 拉取后改名
```bash
docker pull docker.xuanyuan.run/library/node:latest \
&& docker tag docker.xuanyuan.run/library/node:latest library/node:latest \
&& docker rmi docker.xuanyuan.run/library/node:latest
```

**说明**：
- `docker pull`：从轩辕镜像访问支持拉取镜像
- `docker tag`：将镜像重命名为官方标准名称 `library/node:latest`，后续运行命令更简洁
- `docker rmi`：删除临时镜像标签，避免占用额外存储空间

### 2.3 使用免登录方式拉取（推荐）
#### 基础拉取命令：
```bash
docker pull xxx.xuanyuan.run/library/node:latest
```

#### 带重命名的完整命令：
```bash
docker pull xxx.xuanyuan.run/library/node:latest \
&& docker tag xxx.xuanyuan.run/library/node:latest library/node:latest \
&& docker rmi xxx.xuanyuan.run/library/node:latest
```

### 2.4 官方直连方式
若网络可直连 Docker Hub，或已配置轩辕镜像访问支持器，可直接拉取官方镜像：
```bash
docker pull library/node:latest
```

### 2.5 查看镜像是否拉取成功
```bash
docker images
```

**输出示例**：
```text
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
library/node        latest    7b1f3ef4f4e8   3 weeks ago    155MB
```


## 3、部署 Node.js
以下基于 `library/node:latest` 镜像，提供三种部署方案，可根据场景选择。

### 3.1 快速运行（最简方式）
适合测试或临时运行：

#### 第一步：编写测试脚本
```bash
mkdir -p /data/node && cd /data/node
echo "console.log('Hello from Xuanyuan Node.js!')" > app.js
```

#### 第二步：运行 Node 容器
```bash
docker run -it --rm \
  -v /data/node:/usr/src/app \
  -w /usr/src/app \
  library/node:latest \
  node app.js
```

**输出结果**：
```text
Hello from Xuanyuan Node.js!
```

**核心参数说明**：
- `-v /data/node:/usr/src/app`：挂载宿主机目录到容器，方便代码修改
- `-w /usr/src/app`：指定容器内的工作目录
- `--rm`：容器退出后自动删除，避免产生无用容器

### 3.2 启动 Node Web 应用（推荐方式）
适合实际项目部署，通过 Node.js 提供 HTTP 服务。

#### 第一步：准备项目代码
```bash
mkdir -p /data/node-web && cd /data/node-web
```

新建 `server.js`：
```javascript
// 简单的 Node.js Web 服务
const http = require('http');
const PORT = 3000;

http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Xuanyuan Node.js Server!\n');
}).listen(PORT);

console.log(`Server running at http://0.0.0.0:${PORT}/`);
```

#### 第二步：运行容器并映射端口
```bash
docker run -d --name node-web \
  -p 3000:3000 \
  -v /data/node-web:/usr/src/app \
  -w /usr/src/app \
  library/node:latest \
  node server.js
```

**验证方式**：
浏览器访问 `http://服务器IP:3000`，应显示：
```text
Hello from Xuanyuan Node.js Server!
```

### 3.3 docker-compose 部署（企业级推荐）
使用 `docker-compose.yml` 管理容器配置。

#### 第一步：编写 docker-compose.yml
```yaml
version: '3'
services:
  node:
    image: library/node:latest
    container_name: node-service
    working_dir: /usr/src/app
    volumes:
      - ./app:/usr/src/app
    ports:
      - "3000:3000"
    command: node server.js
    restart: always
```

#### 第二步：准备应用目录
```bash
mkdir -p app && cd app
```

`server.js` 内容同 3.2 中的 `server.js`。

#### 第三步：启动服务
```bash
docker compose up -d
```


## 4、结果验证
### 浏览器访问
打开 `http://服务器IP:3000`，应显示 `Hello from Xuanyuan Node.js Server!`

### 查看容器状态
```bash
docker ps
```
`STATUS` 列显示 `Up` 说明运行正常

### 查看日志
```bash
docker logs node-web
```
输出 `Server running at http://0.0.0.0:3000/` 说明启动成功


## 5、常见问题
### 5.1 为什么访问不到服务？
**排查方向**：
- 端口未放行：检查服务器安全组、防火墙是否开放 3000 端口
- 宿主机端口冲突：若 3000 被占用，可改用 `-p 8080:3000`

### 5.2 如何安装依赖？
进入容器执行 `npm install`：
```bash
docker exec -it node-web npm install express
```

或者在 `docker-compose.yml` 中预置 `command: npm install && node server.js`

### 5.3 如何启用热更新？
使用 `nodemon`：
```bash
docker exec -it node-web npm install -g nodemon
docker exec -it node-web nodemon server.js
```

### 5.4 如何指定 Node.js 版本？
拉取指定标签镜像，例如：
```bash
docker pull library/node:18
docker pull library/node:20
```

### 5.5 容器内时区不正确？
运行时加上：
```bash
-e TZ=Asia/Shanghai
```


## 结尾
至此，你已掌握基于 **轩辕镜像** 的 Node.js 镜像拉取与 Docker 部署全流程。

- 初学者：可以先用 **快速运行**，体验 Node.js 容器化开发。
- 实际项目：推荐 **挂载目录** 或 `docker-compose`，便于管理依赖与配置。
- 高级工程师：可基于本文继续扩展 CI/CD、PM2 进程守护、Kubernetes 部署等高级场景。


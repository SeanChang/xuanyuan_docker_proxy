---
id: 19
title: Grafana Docker 部署全流程
slug: grafana-docker
summary: Grafana 是一款开源的数据可视化与监控分析平台。它能从多种数据源（如 Prometheus、InfluxDB、MySQL、Elasticsearch、Loki、Graphite、Redis 等）中采集数据，并通过丰富的图表与仪表盘展示系统运行状况。
category: Docker,Grafana
tags: grafana,docker,部署教程
image_name: grafana/grafana
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-grafana.png"
status: published
created_at: "2025-10-08 06:43:54"
updated_at: "2025-10-08 06:43:54"
---

# Grafana Docker 部署全流程

> Grafana 是一款开源的数据可视化与监控分析平台。它能从多种数据源（如 Prometheus、InfluxDB、MySQL、Elasticsearch、Loki、Graphite、Redis 等）中采集数据，并通过丰富的图表与仪表盘展示系统运行状况。

## 📘 Grafana 是什么？

**Grafana** 是一款开源的数据可视化与监控分析平台。
它能从多种数据源（如 Prometheus、InfluxDB、MySQL、Elasticsearch、Loki、Graphite、Redis 等）中采集数据，并通过丰富的图表与仪表盘展示系统运行状况。

Grafana 的典型用途包括：

* ✅ **服务器与应用性能监控**：结合 Prometheus、Loki、Node Exporter 等，实时观察系统指标（CPU、内存、磁盘、网络等）。
* 📊 **日志与指标统一展示**：通过 Dashboard 可视化不同来源的数据，形成统一的监控中心。
* 🧠 **告警通知系统**：支持自定义告警规则，并可通过 Email、Slack、Telegram、钉钉等渠道通知。
* 🌐 **跨平台可扩展**：插件系统支持多种数据源与可视化组件，可用于 DevOps、IoT、业务监控等多种场景。

Grafana 提供 Web 界面访问，默认端口为 **3000**，默认账户密码为 `admin / admin`。

---

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1、查看 Grafana 镜像详情

你可以在 **轩辕镜像** 中找到 Grafana 镜像页面：
👉 [https://xuanyuan.cloud/r/grafana/grafana](https://xuanyuan.cloud/r/grafana/grafana)

该页面展示了 Grafana 官方镜像的版本信息、拉取命令与更新记录。

---

## 2、下载 Grafana 镜像

### 2.1 使用轩辕镜像登录验证的方式拉取

```bash
docker pull docker.xuanyuan.run/grafana/grafana:latest
```

### 2.2 拉取后改名

```bash
docker pull docker.xuanyuan.run/grafana/grafana:latest \
  && docker tag docker.xuanyuan.run/grafana/grafana:latest grafana/grafana:latest \
  && docker rmi docker.xuanyuan.run/grafana/grafana:latest
```

说明：

* `docker pull`：从轩辕镜像访问支持拉取镜像，访问表现快、稳定性高
* `docker tag`：重命名为官方标准名称，方便后续运行
* `docker rmi`：删除临时标签，节省存储空间

### 2.3 使用免登录方式拉取（推荐）

```bash
docker pull xxx.xuanyuan.run/grafana/grafana:latest \
  && docker tag xxx.xuanyuan.run/grafana/grafana:latest grafana/grafana:latest \
  && docker rmi xxx.xuanyuan.run/grafana/grafana:latest
```

免登录方式无需账号，新手推荐使用。

### 2.4 官方直连方式

若网络可直连 Docker Hub，也可直接拉取官方镜像：

```bash
docker pull grafana/grafana:latest
```

### 2.5 查看镜像是否下载成功

```bash
docker images
```

输出示例：

```
REPOSITORY         TAG       IMAGE ID       CREATED        SIZE
grafana/grafana    latest    3b6e6e2f6b77   2 weeks ago    330MB
```

---

## 3、部署 Grafana

### 3.1 快速部署（最简方式）

适合测试或临时使用：

```bash
docker run -d --name=grafana -p 3000:3000 grafana/grafana:latest
```

说明：

* `--name=grafana`：指定容器名称
* `-p 3000:3000`：映射宿主机端口到容器端口
* `-d`：后台运行

访问方式：

```
http://服务器IP:3000
```

默认账号密码：

```
admin / admin
```

---

### 3.2 持久化部署（推荐方式）

适用于生产环境，配置文件与数据可独立保存。

#### 第一步：创建宿主机目录

```bash
mkdir -p /data/grafana/{data,conf}
```

#### 第二步：启动容器并挂载目录

```bash
docker run -d --name=grafana \
  -p 3000:3000 \
  -e TZ=Asia/Shanghai \
  -v /data/grafana/data:/var/lib/grafana \
  -v /data/grafana/conf:/etc/grafana \
  grafana/grafana:latest
```

参数说明：

| 参数                    | 说明                       |
| --------------------- | ------------------------ |
| `-e TZ=Asia/Shanghai` | 设置容器时区为北京时间              |
| `/data/grafana/data`  | 存放 Grafana 数据（仪表盘、用户配置等） |
| `/data/grafana/conf`  | 挂载 Grafana 配置目录，便于独立修改   |
| `-p 3000:3000`        | 对外暴露 3000 端口             |

#### 第三步：访问验证

打开浏览器访问：

```
http://服务器IP:3000
```

输入账号密码 `admin / admin` 登录后，首次登录系统会要求修改密码。

---

### 3.3 docker-compose 部署（企业级推荐）

#### 第一步：创建 `docker-compose.yml`

```yaml
version: '3.8'
services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - TZ=Asia/Shanghai
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - ./data:/var/lib/grafana
      - ./conf:/etc/grafana
    restart: always
```

#### 第二步：启动服务

```bash
docker compose up -d
```

#### 第三步：常用命令

```bash
# 查看运行状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止服务
docker compose down
```

---

## 4、Grafana 登录与配置

### 4.1 登录界面

访问 `http://服务器IP:3000`
默认账户：

```
用户名：admin
密码：admin
```

首次登录后系统会提示修改密码。

### 4.2 添加数据源

登录后进入：

```
左侧菜单 → Connections → Data sources → Add data source
```

选择如：

* Prometheus
* MySQL
* Loki
* InfluxDB
* PostgreSQL
  等常用数据源，填入连接信息即可。

### 4.3 导入仪表盘

点击：

```
Dashboards → Import → 输入仪表盘ID 或 上传 JSON 文件
```

即可快速导入社区模板或自定义仪表盘。

---

## 5、常见问题与排查

### 5.1 无法访问 3000 端口？

检查防火墙或云安全组：

```bash
ufw allow 3000/tcp
```

或：

```bash
firewall-cmd --add-port=3000/tcp --permanent && firewall-cmd --reload
```

### 5.2 Grafana 数据丢失？

请确保已挂载 `/var/lib/grafana` 到宿主机目录。
Grafana 所有用户配置、仪表盘、数据源信息均保存在该目录下。

### 5.3 修改默认密码

可通过环境变量或 Web UI 修改：

```bash
docker exec -it grafana grafana-cli admin reset-admin-password 新密码
```

### 5.4 更改访问端口

启动命令修改为：

```bash
docker run -d --name=grafana -p 8080:3000 grafana/grafana:latest
```

访问地址改为 `http://服务器IP:8080`

---

## 6、验证运行状态

```bash
docker ps
```

输出示例：

```
CONTAINER ID   IMAGE                 COMMAND                  STATUS          PORTS                    NAMES
abc1234def56   grafana/grafana:latest "/run.sh"               Up 2 minutes    0.0.0.0:3000->3000/tcp   grafana
```

查看日志：

```bash
docker logs grafana
```

正常日志会出现：

```
HTTP Server Listen: [::]:3000
```

---

## ✅ 结尾总结

至此，你已完整掌握 **基于 Docker 的 Grafana 部署流程**：
从镜像拉取、持久化挂载、docker-compose 管理，到登录配置和故障排查。

* **初学者**：可直接使用快速部署命令体验 Grafana。
* **生产环境用户**：建议使用挂载卷方式保存数据。
* **企业级用户**：使用 `docker-compose` 管理多个监控组件（如 Prometheus、Loki、Grafana Stack）。

---

🧩 **延伸阅读：**

* 官方文档：[https://grafana.com/docs/](https://grafana.com/docs/)
* 官方镜像说明：[https://hub.docker.com/r/grafana/grafana](https://hub.docker.com/r/grafana/grafana)
* 轩辕镜像页面：[https://xuanyuan.cloud/r/grafana/grafana](https://xuanyuan.cloud/r/grafana/grafana)


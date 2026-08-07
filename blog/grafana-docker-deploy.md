# 指标日志一屏看清：Docker 部署 Grafana 可视化平台

![指标日志一屏看清：Docker 部署 Grafana 可视化平台](https://img.xuanyuan.dev/docker/blog/grafana.png)

*分类: Docker部署教程 | 标签: Grafana,Docker,轩辕镜像,监控可视化,可观测性,私有化部署,部署教程 | 发布时间: 2026-07-14 08:24:08*

> 零基础教程：Ubuntu 24.04 用轩辕镜像加速拉取 grafana/grafana:11.6.16-ubuntu、避开 3000 端口冲突、Docker Compose 持久化部署、登录与切换简体中文。含 11 张截图与 FAQ。

*本文基于 [grafana/grafana:11.6.16-ubuntu](https://xuanyuan.cloud/zh/r/grafana/grafana) 镜像，**Ubuntu 24.04 服务器**实测（IP `192.168.1.10`，宿主机端口 **3002**）*

Prometheus、Loki、InfluxDB 装了不少，可看着命令行和原始指标发愁？**Grafana** 是开源的数据可视化与监控分析平台——把多种数据源统一成仪表盘，浏览器里一屏看清系统状态。数据与面板都落在你自己的服务器上，不必依赖云监控大盘。

本文带你用 **Docker Compose** 跑通 Grafana：**轩辕镜像**加速拉取、处理同机 **3000 被 PM2 占用**、命名卷持久化、浏览器登录，再切换 **简体中文**，并逛一眼探索、导入仪表盘、连接与警报。Ubuntu 24.04 全程实测，附 **11 张截图** 与 FAQ。

国内用户从 Docker Hub 拉取可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速。镜像说明见 [grafana/grafana 镜像页](https://xuanyuan.cloud/zh/r/grafana/grafana)，官方 Docker 文档见 [Run Grafana Docker image](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)，总文档见 [Grafana Docs](https://grafana.com/docs/)。

![Docker 部署 Grafana 界面](https://img.xuanyuan.dev/docker/blog/grafana-5.png)

*图 0：Docker 部署 Grafana 封面*

## 一、Grafana 是什么？

**Grafana** 是 [Grafana Labs](https://grafana.com/) 维护的开源 **可观测性可视化平台**，专注把指标、日志、链路等数据画成图表与仪表盘。核心能力：

| 能力 | 说明 |
|------|------|
| 多数据源 | Prometheus、Loki、InfluxDB、MySQL、Elasticsearch、Tempo 等 |
| 仪表盘 | 面板组合、导入 grafana.com 社区大盘、告警联动 |
| 探索查询 | Explore / Drilldown 临时查图，无需先建 Dashboard |
| 插件 | 面板、数据源、应用插件可扩展 |
| 自托管 | Docker 一容器即可跑；默认内嵌 SQLite 存配置 |

典型使用场景：

- 对接 **Prometheus**，看服务器 / 容器 / 应用指标
- 对接 **Loki**，在同一界面查日志与指标
- 小团队 **私有监控大盘**，数据不出机房

> **与云监控的区别**：Grafana 自托管需自己维护实例与数据源，胜在 **面板自由、插件丰富、数据本地可控**。官方也提供 `grafana/grafana-enterprise`（默认推荐版，免费含 OSS 能力）；本文使用你已拉取的 **OSS** 镜像 `grafana/grafana`。

架构示意：

```text
浏览器 ──HTTP:3002──▶ Grafana 容器:3000
命名卷 grafana-storage ──▶ /var/lib/grafana（用户、仪表盘、SQLite）
Prometheus / Loki / MySQL 等 ──▶ 数据源连接（按需配置）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 **Ubuntu 24.04**） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 512 MB（推荐 **1 GB+**） |
| CPU | 单核即可；双核更从容 |
| 磁盘 | ≥ 1 GB（镜像 + 数据卷；仪表盘与插件会增长） |
| 端口 | 容器内 **3000**；本文宿主机映射 **3002**（因 **3000 被 PM2 占用**） |
| 工作目录 | `/www/wwwroot/grafana`（独立目录，勿与其他项目混用） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、拉取镜像

本文固定标签 **`11.6.16-ubuntu`**（官方 Ubuntu 变体，版本可复现）。生产环境也可按标签页选择其他小版本；不建议生产用裸 `latest`。

```bash
docker pull docker.xuanyuan.run/grafana/grafana:11.6.16-ubuntu
```

Ubuntu 24.04 实测完整输出：

```text
11.6.16-ubuntu: Pulling from grafana/grafana
78941f24d8bc: Pull complete
03a01e64b9c3: Pull complete
bb0c2c218eab: Pull complete
97e1ee089ace: Pull complete
71e476caffdd: Pull complete
38fae3ff381c: Pull complete
c65e3eecd58e: Pull complete
cb660065e50e: Pull complete
ad1342d6d05d: Pull complete
4f4fb700ef54: Pull complete
Digest: sha256:b8ec2df4415a1e8e2d0a177c4e8db4b639c5b98e8adddc4e5591adf809843be4
Status: Downloaded newer image for docker.xuanyuan.run/grafana/grafana:11.6.16-ubuntu
docker.xuanyuan.run/grafana/grafana:11.6.16-ubuntu
```

> 国内建议全程使用 `docker.xuanyuan.run` 加速域。更多标签见 [镜像标签列表](https://xuanyuan.cloud/r/grafana/grafana/tags)。

---

## 四、部署前：检查端口

Grafana 容器内监听 **3000**。若宿主机 3000 已被占用，只需改映射左侧端口。本文同机还跑过 WPS 等服务，实测：

```bash
ss -tlnp | grep -E ':3000|:3001|:3002'
```

```text
LISTEN 0      511          0.0.0.0:3000       0.0.0.0:*    users:(("PM2 v7.0.1: God",pid=1266811,fd=3))
```

| 端口 | 状态 | 结论 |
|------|------|------|
| **3000** | 被 **PM2** 占用 | 不可用 |
| **3001** | 本文 grep 未占用（留给 WPS HTTPS 等） | 避让 |
| **3002** | 空闲 | **Grafana 宿主机端口** |

定稿映射：`"3002:3000"`，浏览器访问 `http://192.168.1.10:3002`。

---

## 五、Docker Compose 部署

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/grafana
cd /www/wwwroot/grafana
```

### 5.2 编写 docker-compose.yml

推荐 **Docker 命名卷** 挂载 `/var/lib/grafana`（比 bind mount 少踩 UID `472` 权限坑）：

```yaml
services:
  grafana:
    image: docker.xuanyuan.run/grafana/grafana:11.6.16-ubuntu
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3002:3000"
    environment:
      - TZ=Asia/Shanghai
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=你的强密码
      - GF_SERVER_ROOT_URL=http://192.168.1.10:3002/
      - GF_USERS_DEFAULT_LANGUAGE=zh-Hans
    volumes:
      - grafana-storage:/var/lib/grafana

volumes:
  grafana-storage: {}
```

| 配置项 | 说明 |
|--------|------|
| `3002:3000` | 避开宿主机 PM2 占用的 3000 |
| `grafana-storage` | 持久化仪表盘、数据源、用户与 SQLite |
| `GF_SECURITY_ADMIN_PASSWORD` | 预设管理员密码，可跳过首次 `admin/admin` 强制改密 |
| `GF_SERVER_ROOT_URL` | **必须写成真实访问地址**（含端口）；勿把占位文案「你的服务器IP」原样写入 |
| `GF_USERS_DEFAULT_LANGUAGE=zh-Hans` | 新用户默认简体中文；已有用户仍可在 Profile 中改 |
| `11.6.16-ubuntu` | 固定版本，升级时改标签后 `pull && up -d` |

> 若坚持用宿主机目录 `./data` 做 bind mount，需 `chown -R 472:472 ./data`，或临时 `user: "0"`（不如命名卷稳妥）。

### 5.3 启动服务

```bash
docker compose up -d
```

实测输出：

```text
[+] Running 3/3
 ✔ Network grafana_default         Created
 ✔ Volume grafana_grafana-storage  Created
 ✔ Container grafana               Started
```

跟踪日志：

```bash
docker compose logs -f grafana
```

成功时可见类似：

```text
logger=settings ... msg="Starting Grafana" version=11.6.16 commit=a26b9d592b...
logger=settings ... msg="Config overridden from Environment variable" var="GF_SECURITY_ADMIN_USER=admin"
logger=settings ... msg="App mode production"
```

按 `Ctrl+C` 退出日志跟踪，容器继续在后台运行。

---

## 六、浏览器访问与登录

打开：`http://192.168.1.10:3002`

首次看到登录页，版本号与镜像一致：**Grafana v11.6.16**：

![Grafana 登录页](https://img.xuanyuan.dev/docker/blog/grafana-1.png)

*图 1：访问 `http://192.168.1.10:3002` 的登录页（Welcome to Grafana）*

| 项 | 值 |
|----|-----|
| 用户名 | `admin`（或你在 compose 中设置的 `GF_SECURITY_ADMIN_USER`） |
| 密码 | compose 中 `GF_SECURITY_ADMIN_PASSWORD` |

登录后进入英文欢迎页（若尚未改语言）：

![Grafana 英文首页](https://img.xuanyuan.dev/docker/blog/grafana-2.png)

*图 2：登录成功后的 Welcome 首页（可添加数据源、创建仪表盘）*

---

## 七、设置简体中文

Grafana **自带**简体中文，无需额外插件。注意：左侧 **管理 → Settings（服务器设置）** 不能改界面语言。

### 7.1 当前用户偏好（立刻生效）

1. 打开 `http://192.168.1.10:3002/profile`  
   或：左下角头像 → **Profile** → **Preferences**
2. **Language** 选择 **中文 (简体)**（代码 `zh-Hans`）
3. 点击 **Save**，刷新页面

![在 Profile 中选择简体中文](https://img.xuanyuan.dev/docker/blog/grafana-3.png)

*图 3：Profile → Preferences → Language 选择「中文 (简体)」*

### 7.2 环境变量（新用户默认中文）

compose 中已示例：

```yaml
- GF_USERS_DEFAULT_LANGUAGE=zh-Hans
```

该变量主要影响**之后新建的用户**；已存在的 `admin` 仍须按 7.1 改一次。改完 compose 后执行：

```bash
cd /www/wwwroot/grafana
docker compose up -d
```

切换成功后，侧栏变为「首页 / 仪表板 / 探索 / 警报 / 连接 / 管理」等中文菜单。

---

## 八、部署后逛一圈（功能确认）

以下界面用于确认部署可用，便于后续接 Prometheus 等数据源。

### 8.1 导入仪表盘

侧栏 **仪表板** → 导入。可上传 JSON、填 grafana.com 仪表盘 ID，或粘贴 JSON 模型：

![导入仪表盘（中文界面）](https://img.xuanyuan.dev/docker/blog/grafana-4.png)

*图 4：Import dashboard——上传 JSON 或加载社区大盘 ID*

### 8.2 探索（Explore）内置 Random Walk

未接外部数据源时，可用内置 **`-- Grafana --`** 数据源的 **Random Walk** 验证出图：

![探索查询 Random Walk](https://img.xuanyuan.dev/docker/blog/grafana-5.png)

*图 5：探索页用 Random Walk 画出折线，确认可视化正常*

### 8.3 Drilldown / Profiles 入门

Grafana 11.x 侧栏提供 Drilldown（Metrics / Logs / 个人资料）等入口，便于后续接齐 Metrics、Logs、Profiles：

![Drilldown 入口](https://img.xuanyuan.dev/docker/blog/grafana-6.png)

*图 6：Drilldown——Metrics / Logs / 个人资料入口*

![Profiles Drilldown 欢迎页](https://img.xuanyuan.dev/docker/blog/grafana-7.png)

*图 7：Grafana Profiles Drilldown 入门引导（中文）*

### 8.4 警报

侧栏 **警报**：规则、联络点、通知策略三大块：

![警报入门页](https://img.xuanyuan.dev/docker/blog/grafana-8.png)

*图 8：警报——Alert rules / Contact points / Notification policies*

### 8.5 添加数据源连接

侧栏 **连接 → 添加新连接**，可见 Prometheus、Loki、MySQL、InfluxDB 等（已预装）：

![添加新连接 / 数据源列表](https://img.xuanyuan.dev/docker/blog/grafana-9.png)

*图 9：添加新连接——选择并配置数据源*

### 8.6 管理入口

侧栏 **管理**：概况、插件和数据、用户和访问权限、身份验证等：

![管理页面](https://img.xuanyuan.dev/docker/blog/grafana-10.png)

*图 10：管理——组织级偏好、插件、用户与认证*

> 下一步常见动作：在「添加新连接」中配置 **Prometheus**（URL 如 `http://prometheus:9090`，需与 Grafana 同网络可达），再在仪表板导入社区大盘（如 Node Exporter 系列）。

---

## 九、可选进阶

### 9.1 预装插件

启动时可通过环境变量预装官方插件，例如：

```yaml
- GF_PLUGINS_PREINSTALL=grafana-clock-panel
```

详见 [官方 Docker 文档 · Install plugins](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/#install-plugins-in-the-docker-container)。

### 9.2 HTTPS 与反代

生产环境建议用 **Nginx / Caddy** 反代到 `127.0.0.1:3002`，配置正式证书，并把 `GF_SERVER_ROOT_URL` 改为 `https://grafana.example.com/`。公网切勿长期裸奔弱密码。

---

## 十、常见问题与踩坑 FAQ

**Q1：默认 3000 端口被占用怎么办？**

只改左侧宿主机端口，例如 `"3002:3000"`，并同步修改 `GF_SERVER_ROOT_URL` 与浏览器地址。排查：

```bash
ss -tlnp | grep :3000
```

**Q2：登录异常、链接跳转不对？**

检查 `GF_SERVER_ROOT_URL` 是否写成了**真实 IP/域名 + 端口**。若误写中文占位「你的服务器IP」，日志里会出现 URL 编码后的怪串，建议改成例如：

```yaml
- GF_SERVER_ROOT_URL=http://192.168.1.10:3002/
```

然后 `docker compose up -d`。

**Q3：bind mount 后容器起不来 / Permission denied？**

Grafana 进程默认 UID **472**。对宿主机目录执行 `chown -R 472:472 ./data`，或改用本文的命名卷。

**Q4：忘记管理员密码？**

在容器内可用官方 CLI 重置（容器名按实际）：

```bash
docker exec -it grafana grafana cli admin reset-admin-password 新密码
```

**Q5：界面还是英文？**

确认在 **Profile → Preferences → Language**，不要去服务器 Settings。环境变量 `GF_USERS_DEFAULT_LANGUAGE=zh-Hans` 只影响新用户默认值。

**Q6：如何升级镜像？**

```bash
cd /www/wwwroot/grafana
# 修改 docker-compose.yml 中的标签后：
docker compose pull
docker compose up -d
```

命名卷 `grafana-storage` 中的数据会保留。

**Q7：如何停止与卸载？**

```bash
cd /www/wwwroot/grafana
docker compose down          # 停止，卷保留
docker compose down -v       # 停止并删除数据卷（慎用）
```

**Q8：与 Docker Hub 官方镜像的关系？**

功能相同。`docker.xuanyuan.run/grafana/grafana` 为轩辕镜像加速同步版，便于国内拉取。官方坐标仍是 `grafana/grafana`。

---

## 十一、命令速查

| 操作 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/grafana/grafana:11.6.16-ubuntu` |
| 检查端口 | `ss -tlnp \| grep -E ':3000\|:3001\|:3002'` |
| 启动 | `cd /www/wwwroot/grafana && docker compose up -d` |
| 查看日志 | `docker compose logs -f grafana` |
| 访问 | `http://服务器IP:3002` |
| 个人资料（改语言） | `http://服务器IP:3002/profile` |
| 重启 | `docker compose restart grafana` |
| 停止 | `cd /www/wwwroot/grafana && docker compose down` |

---

## 十二、延伸阅读

| 主题 | 链接 |
|------|------|
| 轩辕镜像页 | https://xuanyuan.cloud/zh/r/grafana/grafana |
| Grafana 官方 Docker 安装 | https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/ |
| Grafana 文档首页 | https://grafana.com/docs/ |
| 配置 Docker 镜像 | https://grafana.com/docs/grafana/latest/setup-grafana/configure-docker/ |
| 轩辕镜像 | https://xuanyuan.cloud |

---

**总结**：`grafana/grafana:11.6.16-ubuntu` + Compose 命名卷 = **私有监控大盘，浏览器打开就能看图**。本文踩坑三点：**3000 被 PM2 占用则映射 3002**、**`GF_SERVER_ROOT_URL` 写真实地址**、**中文在 Profile Preferences（或 `GF_USERS_DEFAULT_LANGUAGE=zh-Hans`）**。下一步接上 Prometheus / Loki，导入社区仪表盘即可进入日常值班看板。



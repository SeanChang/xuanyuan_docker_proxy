# Jenkins Docker 部署教程：搭建属于自己的 CI/CD 持续集成平台

![Jenkins Docker 部署教程：搭建属于自己的 CI/CD 持续集成平台](https://img.xuanyuan.dev/docker/blog/docker-jenkins.png)

*分类: Docker部署教程 | 标签: Jenkins,Docker,轩辕镜像,CI/CD,持续集成,私有化部署,部署教程 | 发布时间: 2025-12-02 03:45:05*

> GitHub Actions、云厂商 CI 好用，但构建环境、插件版本、流水线数据都不在自己手里？Jenkins 是领先的开源自动化服务器——支持 持续集成（CI）、持续交付（CD），通过丰富插件生态把代码拉取、编译、测试、部署串成流水线，跑在你自己的服务器上，数据与配置完全可控。

*本文基于 [jenkins/jenkins:2.572-jdk21](https://xuanyuan.cloud/zh/r/jenkins/jenkins) 镜像，**Ubuntu 24.04 服务器**实测（IP `192.168.1.18`，端口 `8080`）*

GitHub Actions、云厂商 CI 好用，但构建环境、插件版本、流水线数据都不在自己手里？**Jenkins** 是领先的开源自动化服务器——支持 **持续集成（CI）、持续交付（CD）**，通过丰富插件生态把代码拉取、编译、测试、部署串成流水线，跑在你自己的服务器上，数据与配置完全可控。

本文带你用 **Docker 单容器** 跑通 Jenkins：**轩辕镜像**加速拉取、读懂 **weekly / LTS / JDK / 平台** 等标签差异、`docker run` 一键启动、`/var/jenkins_home` 持久化，再跟做 **Web 初始化向导**——解锁实例、安装推荐插件、创建管理员、配置 Jenkins URL，直至浏览器进入主控台。Ubuntu 24.04 全程实测，附 **11 张截图** 与 FAQ。

国内用户从 Docker Hub 拉取可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速。镜像说明见 [jenkins/jenkins 镜像页](https://xuanyuan.cloud/zh/r/jenkins/jenkins)，全部标签见 [标签列表](https://xuanyuan.cloud/r/jenkins/jenkins/tags)，官方 Docker 文档见 [jenkinsci/docker](https://github.com/jenkinsci/docker)。

---

## 一、Jenkins 是什么？

**Jenkins** 是一款 **开源、可自托管的自动化服务器**，GPL 许可，由全球社区维护。核心能力：

| 能力 | 说明 |
|------|------|
| 持续集成 | 代码提交后自动拉取、编译、单元测试 |
| 持续交付 / 部署 | 流水线串联构建产物发布到测试 / 生产环境 |
| Pipeline | 声明式 / 脚本式流水线，支持 Groovy DSL |
| 插件生态 | 数千插件覆盖 Git、Docker、Kubernetes、通知等 |
| 分布式构建 | Controller + Agent 架构，横向扩展执行节点 |

典型使用场景：

- 小团队 **私有 CI/CD**，替代 GitHub Actions / GitLab CI 的部分能力
- 内网 Git 仓库（Gitea、GitLab CE）的 **自动构建与部署**
- 需要 **固定构建环境、插件版本** 且数据不出机房的企业场景

> **与云 CI 的区别**：Jenkins 需自行维护服务器与插件升级，胜在 **完全私有化、插件自由、流水线数据本地可控**。若只需托管在 GitHub 上的开源项目构建，云 CI 更省心；若有内网代码或合规要求，Jenkins 更合适。

架构示意：

```text
浏览器 ──HTTP:8080──▶ Jenkins Controller 容器
宿主机 jenkins_home ──▶ /var/jenkins_home（配置、插件、任务、凭据）
Agent 节点 ──TCP:50000──▶ Controller（分布式构建，可选）
Git / Docker / K8s ──▶ 流水线插件调用（按需配置）
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 **Ubuntu 24.04**） |
| Docker | **Docker Engine ≥ 23.0**（须 Engine，Docker Desktop 不适用） |
| 内存 | ≥ 2 GB（推荐 **4 GB**，插件安装与首次启动较吃内存） |
| CPU | 双核 2.0 GHz 以上 |
| 磁盘 | ≥ 5 GB（镜像约 **801 MB** 磁盘占用 + `jenkins_home` 插件与构建缓存） |
| 端口 | **8080**（Web 界面）、**50000**（Agent 入站连接，单机可先映射备用） |
| 工作目录 | `/www/wwwroot/jenkins`（独立目录，勿与其他项目混用） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、镜像标签怎么选？

Jenkins 官方镜像 [`jenkins/jenkins`](https://xuanyuan.cloud/zh/r/jenkins/jenkins) 标签较多，命名大致遵循：

```text
<版本>-<JDK变体>-<基础系统/平台>
```

常见维度说明：

| 维度 | 含义 | 示例 |
|------|------|------|
| **版本号** | 具体 weekly 小版本，**生产推荐固定** | `2.572` |
| **LTS** | 长期支持线，更新节奏慢、更稳 | `lts-jdk21`、`lts-jdk17` |
| **latest** | 指向最新 weekly，**标签浮动，生产不推荐** | `latest`、`latest-jdk21` |
| **JDK** | 容器内 Java 运行时版本 | `jdk21`、`jdk17`、`jdk25` |
| **基础系统** | Debian（默认）、Alpine（更小）、Windows | `alpine-jdk21`、`windowsservercore-ltsc2025` |

### 3.1 本文涉及标签对照

| 官方标签 | 轩辕镜像加速拉取 | 说明 |
|----------|------------------|------|
| `jenkins/jenkins:2.572-jdk21` | `docker pull docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21` | **本文主镜像**：weekly **2.572** + **JDK 21**（Debian），功能新、适合尝鲜 |
| `jenkins/jenkins:2.572` | `docker pull docker.xuanyuan.run/jenkins/jenkins:2.572` | 同版本 weekly，使用镜像 **默认 JDK**（随版本可能为 17 或 21） |
| `jenkins/jenkins:latest-jdk21` | `docker pull docker.xuanyuan.run/jenkins/jenkins:latest-jdk21` | 最新 weekly + JDK 21，**标签随上游更新漂移** |
| `jenkins/jenkins:latest` | `docker pull docker.xuanyuan.run/jenkins/jenkins:latest` | 最新 weekly + 默认 JDK，**仅测试用，生产勿用** |
| `jenkins/jenkins:jdk25-hotspot-windowsservercore-ltsc2025` | `docker pull docker.xuanyuan.run/jenkins/jenkins:jdk25-hotspot-windowsservercore-ltsc2025` | **Windows Server 容器**，仅 Windows 主机 + Windows 容器模式；**Linux 服务器无法运行** |
| `jenkins/jenkins:lts-jdk21` | `docker pull docker.xuanyuan.run/jenkins/jenkins:lts-jdk21` | **LTS 长期支持** + JDK 21，生产环境更推荐 |
| `jenkins/jenkins:lts-jdk17` | `docker pull docker.xuanyuan.run/jenkins/jenkins:lts-jdk17` | LTS + JDK 17，部分旧插件兼容性更好 |

完整标签列表见 [轩辕镜像 jenkins/jenkins 标签页](https://xuanyuan.cloud/r/jenkins/jenkins/tags)。

### 3.2 weekly 与 LTS 怎么选？

| 类型 | 特点 | 适用 |
|------|------|------|
| **weekly**（如 `2.572-jdk21`） | 每约一周发布，含最新特性与修复 | 测试环境、想体验新功能 |
| **LTS**（如 `lts-jdk21`） | 长期支持线，约每 12 周一个 LTS 基线，补丁更保守 | **生产环境首选** |

### 3.3 其他变体（按需）

| 标签模式 | 说明 |
|----------|------|
| `2.572-alpine-jdk21` | Alpine 基础镜像，体积更小，部分原生依赖可能缺失 |
| `2.572-slim-jdk21` | Debian Slim，介于默认与 Alpine 之间 |
| `jdk25-hotspot-windowsservercore-*` | Windows 容器专用，与 Linux 部署无关 |

> **弃用提示**：旧镜像 `library/jenkins` 已弃用，请使用 **`jenkins/jenkins`**（见 [轩辕镜像页说明](https://xuanyuan.cloud/zh/r/jenkins/jenkins)）。

---

## 四、拉取镜像

本文固定 weekly 版本 **2.572-jdk21**：

```bash
docker pull docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21
```

成功时终端显示：

```text
Digest: sha256:72c7fd86182acc9cfff934c167879a8acbdb303af1a8b4ee5df5fc1b1ea3833a
Status: Downloaded newer image for docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21
docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21
```

确认本地镜像：

```bash
docker images
```

本文实测输出：

```text
IMAGE                                             ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21   72c7fd86182a        801MB          290MB    U
```

---

## 五、检测端口占用

Jenkins 默认占用 **8080**（Web）与 **50000**（Agent）。部署前确认宿主机未被占用——本仓库 [Redmine 部署教程](https://xuanyuan.cloud/blog/redmine-docker-deploy) 亦常用 **8080**，若已跑 Redmine 等需改用其他宿主机端口（如 `8081:8080`）。

```bash
ss -tlnp | grep -E ':8080|:50000'
docker ps --format 'table {{.Names}}\t{{.Ports}}' | grep -E '8080|50000'
```

本文实测 **无输出**，8080 / 50000 均空闲，可直接使用默认映射。

---

## 六、创建持久化目录

Jenkins 所有数据（配置、插件、任务、凭据、构建历史）存放在容器内 **`/var/jenkins_home`**，必须挂载到宿主机。

```bash
mkdir -p /www/wwwroot/jenkins/jenkins_home
chown -R 1000:1000 /www/wwwroot/jenkins/jenkins_home
```

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `/www/wwwroot/jenkins/jenkins_home` | `/var/jenkins_home` | **必挂**：配置、插件、任务、凭据、工作空间 |

> 容器内进程以用户 **`jenkins`（UID 1000）** 运行。跳过 `chown` 可能导致无法写入配置、容器反复重启。

---

## 七、启动容器（docker run）

```bash
docker run -d \
  --name jenkins \
  --restart=unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/jenkins/jenkins_home:/var/jenkins_home \
  docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21
```

| 参数 | 说明 |
|------|------|
| `-p 8080:8080` | Web 管理界面 |
| `-p 50000:50000` | Agent 入站 TCP 连接（分布式构建时需要） |
| `-e TZ=Asia/Shanghai` | 时区，国内建议上海 |
| `-v ...:/var/jenkins_home` | **必挂**，升级镜像时数据不丢 |
| `--restart=unless-stopped` | 系统重启后自动恢复 |

**8080 已被占用时**，仅改 Web 映射（示例改用 8081）：

```bash
-p 8081:8080
```

浏览器访问地址同步改为 `http://<IP>:8081`。

**可选：在 Jenkins 流水线中构建 Docker 镜像** 时，追加挂载 Docker 套接字（有安全风险，仅 CI 需要时启用）：

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

---

## 八、验证启动与日志

### 8.1 确认容器运行

```bash
docker ps -a | grep jenkins
```

本文实测：

```text
3ff0f0ee0d3a   docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21   "/usr/bin/tini -- /u…"   ...   Up ...   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp, 0.0.0.0:50000->50000/tcp, [::]:50000->50000/tcp   jenkins
```

### 8.2 查看日志

```bash
docker logs -f jenkins
```

关键日志片段（本文实测）：

```text
2026-07-08 07:24:46.087+0000 [id=30]    INFO    jenkins.model.Jenkins#<init>: Starting version 2.572
...
2026-07-08 07:24:51.525+0000 [id=37]    INFO    jenkins.install.SetupWizard#init:
...
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:
...
This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
...
2026-07-08 07:25:10.663+0000 [id=30]    INFO    hudson.lifecycle.Lifecycle#onReady: Jenkins is fully up and running
```

出现 **`Jenkins is fully up and running`** 表示 Web 已就绪。首次启动约 **1～3 分钟**（解压 war、初始化插件骨架）。

按 `Ctrl+C` 退出日志跟随。

### 8.3 本机 curl 测试

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080
```

本文返回 **`403`**——表示 Jenkins 已响应，但尚未完成「解锁」向导，**属正常现象**。完成初始密码验证后，浏览器 GET 将返回 `200`。

### 8.4 读取初始管理员密码

日志中的密码与文件内容一致；推荐用命令读取（**每次部署随机生成，勿照搬本文示例**）：

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## 九、浏览器初始化向导

在浏览器打开（将 IP 换成你的服务器地址）：

```text
http://192.168.1.18:8080
```

### 9.1 解锁 Jenkins

将上节读取的 **32 位初始密码** 粘贴到「管理员密码」框，点击 **继续**：

![解锁 Jenkins：粘贴 initialAdminPassword 中的管理员密码](https://img.xuanyuan.dev/docker/blog/jenkins-1.png)

*图 1：解锁 Jenkins 页面*

### 9.2 安装推荐插件

选择 **安装推荐的插件**（Install suggested plugins），自动安装 Pipeline、Git、Credentials 等常用插件：

![自定义 Jenkins：选择安装推荐的插件](https://img.xuanyuan.dev/docker/blog/jenkins-2.png)

*图 2：插件安装方式选择*

插件下载与安装需 **3～10 分钟**（视网络而定），进度条与右侧依赖列表实时更新：

![新手入门：推荐插件安装进度，Folders、Git、Pipeline 等](https://img.xuanyuan.dev/docker/blog/jenkins-3.png)

*图 3：推荐插件安装中*

> 若插件中心连接慢，可稍后在 **Manage Jenkins → Plugins** 中重试或配置镜像源；本文实测首次安装顺利完成。

### 9.3 创建第一个管理员用户

插件装完后，创建 **持久管理员账号**（替代仅用于解锁的初始密码）：

![创建第一个管理员用户：填写用户名 admin、全名与邮箱](https://img.xuanyuan.dev/docker/blog/jenkins-4.png)

*图 4：创建管理员用户*

| 字段 | 本文示例 |
|------|----------|
| 用户名 | `admin` |
| 全名 | `xuanyuan` |
| 邮箱 | `xuanyuancloud@foxmail.com` |

密码请自行设置强密码；也可点击 **使用 admin 账户继续** 跳过（不推荐生产环境）。

### 9.4 实例配置（Jenkins URL）

确认 **Jenkins URL** 为浏览器实际访问地址（影响邮件通知、构建日志中的链接）：

![实例配置：Jenkins URL 设为 http://192.168.1.18:8080/](https://img.xuanyuan.dev/docker/blog/jenkins-5.png)

*图 5：实例 URL 配置*

若后续改用域名或反向代理，可在 **Manage Jenkins → System** 中修改。

### 9.5 安装完成

点击 **保存并完成**，进入就绪页：

![Jenkins 已就绪：点击开始使用 Jenkins](https://img.xuanyuan.dev/docker/blog/jenkins-6.png)

*图 6：初始化完成*

点击 **开始使用 Jenkins** 进入主控台。

---

## 十、主界面与管理

### 10.1 欢迎页与新建任务

主控台显示 **欢迎来到 Jenkins!**，可点击 **Create a job** 创建第一个流水线或自由风格项目：

![Jenkins 主控台：Welcome to Jenkins，Create a job 与 Set up an agent](https://img.xuanyuan.dev/docker/blog/jenkins-7.png)

*图 7：Jenkins 主控台欢迎页*

### 10.2 新建 Item

点击左侧 **+ 新建 Item**，输入任务名称并选择类型（**Freestyle project** 或 **流水线 Pipeline**）：

![新建 Item：输入任务名称，选择 Freestyle project 或 Pipeline](https://img.xuanyuan.dev/docker/blog/jenkins-8.png)

*图 8：新建任务类型选择*

| 类型 | 适用 |
|------|------|
| **Freestyle project** | 经典任务，GUI 配置构建步骤 |
| **流水线 Pipeline** | Jenkinsfile 声明式 / 脚本式流水线，**现代项目首选** |
| **文件夹 Folder** | 多项目分组管理 |

### 10.3 系统管理

点击左侧 **Manage Jenkins**（或右上角齿轮）进入系统配置、插件管理、节点与凭据：

![Manage Jenkins：系统配置、插件管理、节点和云、Security 与凭据](https://img.xuanyuan.dev/docker/blog/jenkins-9.png)

*图 9：Manage Jenkins 概览*

页面顶部黄色提示建议配置 **Agent 分布式构建**——生产环境不建议大量任务跑在 Controller 内置节点上，可按需 **Set up an agent**。

### 10.4 内置节点状态

**Manage Jenkins → Nodes** 可查看 **Built-In Node**（Controller 自身）的磁盘、内存与执行器：

![节点和云管理：Built-In Node Linux amd64，空闲磁盘 86.78 GiB](https://img.xuanyuan.dev/docker/blog/jenkins-10.png)

*图 10：内置节点资源状态*

本文环境显示 **0/2** 执行器空闲，表示可同时跑 2 个构建任务。

### 10.5 界面主题（可选）

点击右上角用户菜单 → **Theme**，可切换 **Light / Dark / Dark (System)**：

![用户菜单 Theme：切换 Dark 深色主题](https://img.xuanyuan.dev/docker/blog/jenkins-11.png)

*图 11：深色主题切换*

推荐插件中包含 **Dark Theme**，安装向导完成后即可使用。

---

## 十一、Docker Compose 方案（可选）

验证 `docker run` 正常后，可改用 Compose 便于维护。在 `/www/wwwroot/jenkins/docker-compose.yml`：

```yaml
services:
  jenkins:
    container_name: jenkins
    image: docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21
    restart: unless-stopped
    ports:
      - "8080:8080"
      - "50000:50000"
    environment:
      TZ: Asia/Shanghai
    volumes:
      - /www/wwwroot/jenkins/jenkins_home:/var/jenkins_home
```

迁移步骤：

```bash
docker stop jenkins
docker rm jenkins
cd /www/wwwroot/jenkins
docker compose up -d
```

---

## 十二、防火墙放行

若本机 `curl http://127.0.0.1:8080` 正常、局域网浏览器 **连接超时**，检查 UFW 与宝塔：

```bash
ufw status
ufw allow 8080/tcp
ufw allow 50000/tcp   # 若将来挂 Agent
```

若使用 **宝塔面板**：**安全 → 额外放行 8080**（及 50000）。

确认服务器 IP：

```bash
ip addr | grep 192.168
```

本文输出：`inet 192.168.1.18/24 ...`

---

## 十三、可选扩展

### 13.1 挂载 Docker 套接字（流水线构建镜像）

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

Controller 内可直接 `docker build`，但等同于授予容器 **宿主机 Docker 权限**，生产需评估风险。

### 13.2 添加 Agent 节点

分布式构建时，在 Agent 机器上运行 [jenkins/inbound-agent](https://xuanyuan.cloud/zh/r/jenkins/inbound-agent) 或 [jenkins/ssh-agent](https://xuanyuan.cloud/zh/r/jenkins/ssh-agent)，Controller 地址填 `http://<Controller-IP>:8080`，入站端口 **50000**。

### 13.3 切换 LTS 镜像

生产环境可将镜像 tag 改为 `lts-jdk21`，**保留同一 `jenkins_home` 卷** 后重建容器即可，Jenkins 会自动执行配置迁移。

---

## 十四、生产环境建议

### 14.1 固定镜像 digest

```bash
docker pull docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21
docker inspect docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21 --format='{{index .RepoDigests 0}}'
```

本文拉取 digest：`sha256:72c7fd86182acc9cfff934c167879a8acbdb303af1a8b4ee5df5fc1b1ea3833a`

### 14.2 备份 jenkins_home

```bash
docker stop jenkins
tar -czf jenkins-home-backup-$(date +%Y%m%d).tar.gz -C /www/wwwroot/jenkins jenkins_home
docker start jenkins
```

也可在 **Manage Jenkins → System** 中配合 ThinBackup 等插件做定时备份。

### 14.3 升级镜像

```bash
docker pull docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21   # 或新 tag / lts-jdk21
docker stop jenkins
docker rm jenkins
# 用相同 -v 路径重新 docker run，或 docker compose up -d
```

**切勿删除** `jenkins_home` 目录，否则插件、任务与凭据全部丢失。

### 14.4 Nginx 反向代理（示例）

生产建议域名 + HTTPS 访问：

```nginx
server {
    listen 443 ssl;
    server_name jenkins.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 90;
    }
}
```

需在 Jenkins **Manage Jenkins → System → Jenkins URL** 中改为 `https://jenkins.example.com/`。

---

## 十五、常见问题 FAQ

**Q1：`curl` 返回 403 是报错吗？**

不是。未完成解锁向导时 Jenkins 对匿名请求返回 **403**，表示服务已运行。浏览器完成初始密码验证后即可正常访问。

**Q2：8080 端口被占用怎么办？**

```bash
ss -tlnp | grep 8080
```

改用 `-p 8081:8080` 映射，浏览器访问 `:8081`。

**Q3：容器反复 Restarting？**

多为 **`jenkins_home` 权限问题**。执行 `chown -R 1000:1000 /www/wwwroot/jenkins/jenkins_home` 后重建容器。用 `docker logs jenkins` 确认。

**Q4：忘记初始密码且未完成向导？**

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

若文件已删除（向导已完成），使用创建的管理员账号登录；均不可用需按官方文档重置（会涉及 `jenkins_home` 操作，谨慎处理）。

**Q5：`2.572-jdk21` 与 `lts-jdk21` 选哪个？**

- 尝鲜 / 测试：**weekly** `2.572-jdk21`（本文）
- 生产长期运行：**LTS** `lts-jdk21`

**Q6：Linux 服务器能跑 `jdk25-hotspot-windowsservercore-ltsc2025` 吗？**

**不能**。该标签为 **Windows 容器**，仅适用于 Windows Server 主机。Linux 请选 Debian / Alpine 系标签。

**Q7：首次插件安装很慢？**

插件从 Jenkins 更新中心下载，国内网络可能较慢。可在 **Manage Jenkins → Plugins → Advanced** 配置更新中心镜像，或重试安装。

**Q8：如何重启 Jenkins？**

```bash
docker restart jenkins
# 或 Compose
docker compose restart
```

**Q9：如何卸载？**

```bash
docker stop jenkins
docker rm jenkins
# 保留数据：不删 jenkins_home
# 彻底清理：
# rm -rf /www/wwwroot/jenkins/jenkins_home
```

**Q10：能否与 Home Assistant 共用目录？**

**不建议**。Jenkins 使用独立目录 `/www/wwwroot/jenkins`，与 [Home Assistant 部署](https://xuanyuan.cloud/blog/home-assistant-docker-deploy) 的 `/www/wwwroot/homeassistant` 分开，避免配置混淆。

---

## 十六、命令速查

| 步骤 | 命令 |
|------|------|
| 拉取镜像 | `docker pull docker.xuanyuan.run/jenkins/jenkins:2.572-jdk21` |
| 检测端口 | `ss -tlnp \| grep -E ':8080\|:50000'` |
| 创建目录 | `mkdir -p /www/wwwroot/jenkins/jenkins_home && chown -R 1000:1000 /www/wwwroot/jenkins/jenkins_home` |
| 启动容器 | 见第七节 `docker run` |
| 查看状态 | `docker ps -a \| grep jenkins` |
| 查看日志 | `docker logs -f jenkins` |
| 初始密码 | `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword` |
| 本机探测 | `curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080` |
| 浏览器访问 | `http://<服务器IP>:8080` |
| Compose 启动 | `cd /www/wwwroot/jenkins && docker compose up -d` |

---

## 相关链接

- [jenkins/jenkins 镜像页（轩辕镜像）](https://xuanyuan.cloud/zh/r/jenkins/jenkins)
- [jenkins/jenkins 全部标签](https://xuanyuan.cloud/r/jenkins/jenkins/tags)
- [Jenkins 官方 Docker 仓库 README](https://github.com/jenkinsci/docker)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)
- [jenkins/inbound-agent 镜像（Agent 节点）](https://xuanyuan.cloud/zh/r/jenkins/inbound-agent)


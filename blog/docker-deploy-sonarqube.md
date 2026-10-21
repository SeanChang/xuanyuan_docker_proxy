# Docker 部署 SonarQube：轻松搭建代码质量与安全分析平台

![Docker 部署 SonarQube：轻松搭建代码质量与安全分析平台](https://imgs.xuanyuan.cloud/docker/blog/SonarQube/SonarQube.webp)

*分类: Docker部署教程 | 标签: SonarQube,library/sonarqube,Docker,轩辕镜像,代码质量,私有化部署,部署教程 | 发布时间: 2026-10-20 19:40:29*

> SonarQube Community Build 是面向开发团队的免费自托管代码分析服务，旨在集中检查缺陷、代码异味和基础安全问题，并通过质量门禁整理每次扫描的结果。本文将介绍如何通过 Docker Compose 快速部署 SonarQube，搭建代码质量分析平台，帮助你在自己的服务器上查看扫描结果，适合内网评估及个人项目试用等场景。

*本文基于 [library/sonarqube:26.4.0.121862-community](https://xuanyuan.cloud/zh/r/library/sonarqube)，界面页脚为 **Community Build v26.4.0.121862**。*

## SonarQube 是什么

SonarQube Community Build 是 SonarSource 提供的免费自托管代码分析服务。`library/sonarqube` 里带 `community` 的标签就是这一版。它把一次扫描里的缺陷、代码异味和基础安全问题放到你自己的服务器上，在浏览器里按项目查看。

与把仓库只交给云端托管平台自带的检查相比，这一版的分析服务跑在你的机器上。本文截图的页脚是 Community Build v26.4.0.121862，用的是内置数据库。页面上写明，这份内置库只适合评估。

## SonarQube 能做什么

- **查看缺陷和代码异味**：把空指针、资源泄漏、过长函数和重复代码列出来。
- **查看基础安全问题**：在问题列表和 Security Hotspots 里看安全相关的结果。
- **用质量门禁看结果**：导航里有 Quality gates，用来看这次分析是否通过。
- **创建本地项目或从代码平台导入**：可以建一个本地项目，也可以从 GitHub、GitLab、Azure DevOps 和 Bitbucket 导入。
- **覆盖 21 种语言和框架**：官方镜像说明里，Community Build 的分析范围是 21 种编程语言和框架。

## 为什么要使用 SonarQube

项目变大以后，缺陷和重复代码常常要到上线前才集中出现。接手的人要自己把逻辑翻一遍，也缺少一份集中的问题清单。

Community Build 把扫描结果留在自己的服务器上。浏览器打开就能按项目查看。它适合想在内网做代码检查、并先用内置库试用的个人和小团队。给团队长期使用时，换成 PostgreSQL，见「改用 PostgreSQL」。

## 使用 Docker 部署 SonarQube

SonarQube 可以用 Docker 把 Community Build 跑起来。开始之前准备好 Docker，并按主机要求留出内存、空闲磁盘和内核参数。内置数据库只适合评估。

接下来用 Docker Compose 写好端口和数据卷，完成启动，再在浏览器里登录、修改初始密码，并创建一个本地项目做扫描。

## 环境要求

本文命令使用 `library/sonarqube:26.4.0.121862-community`。标签怎么对应，见「标签怎么选」。官方硬件要求的起点是 **4 GB** 内存；规模上来以后，要求表里给到 16 GB。磁盘不要写满，空闲不要低于 10%。用量到达 Elasticsearch 的默认水位后，索引会被限制写入。

内置 H2 只适合评估。截图顶部写明：它不支持扩容，不支持升级到新版本，也不支持迁到别的数据库。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/sonarqube` 换成 `~/docker/sonarqube`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`）。官方安装说明建议 Engine 20.10 及以上 |
| 架构 | **linux/amd64**、**linux/arm64** |
| 内存 | 起点 **4 GB** |
| 内核 | `vm.max_map_count` 至少为 524288，`fs.file-max` 至少为 131072 |
| 端口 | 宿主机 **9000** → 容器 **9000** |
| 工作目录 | `/www/wwwroot/sonarqube` |
| 数据 | 命名卷挂到 `/opt/sonarqube/data`、`/opt/sonarqube/logs`、`/opt/sonarqube/extensions` |
| 账号 | 初始用户名和密码都是 `admin`。首次登录必须修改密码 |

```bash
docker --version
docker compose version
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```

`ulimit` 只对当前会话生效。两个 `sysctl` 要开机后仍然生效，再执行：

```bash
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > … <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

三张截图的页脚是 **Community Build v26.4.0.121862**。本文命令使用 **`26.4.0.121862-community`**。

2026-10-20 查看 Docker Hub 官方镜像说明时，`latest` 和 `community` 都指向 **`26.10.0.133078-community`**。那一版和这三张截图不是同一个构建。26.10 还提高了 Web 和 Compute Engine 的默认堆内存，内存本来就紧的机器不要直接改过去。

Docker Hub 上 `26.4.0.121862-community` 的清单 digest 为 `sha256:bd377c7955e6f8deceb865f1661f12e5b434732b1f223e32dfc91a5164e7bec5`，推送时间是 2026-05-01。linux/amd64 压缩大小为 1069502454 字节，linux/arm64 为 1068821160 字节。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`26.4.0.121862-community`** | 截图页脚对应的 Community Build | **是** |
| `community`、`latest` | 2026-10-20 指向 `26.10.0.133078-community` | 否 |
| `developer`、`enterprise`、`datacenter-*` | SonarQube Server 商业版 | 否 |

AI CodeFix 以及「30 种以上语言」写在 SonarQube Server 的说明里，不在这个 community 标签上。

完整标签见 [library/sonarqube 标签列表](https://xuanyuan.cloud/r/library/sonarqube/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/library/sonarqube:26.4.0.121862-community
```

拉完后确认本地有这个标签，再写 Compose：

```bash
docker images docker.xuanyuan.run/library/sonarqube:26.4.0.121862-community
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/sonarqube`。这一套使用内置 H2，和截图顶部的评估提示一致。三个命名卷分别对应官方说明里的数据、日志和插件目录。不挂这些目录时，删除容器会丢掉内置库里的项目和用户。

宿主机 **9000** 映射到容器 **9000**。先完成「环境要求」里的 `sysctl`，再启动。本文 Compose 没有设置 `SONAR_ES_BOOTSTRAP_CHECKS_DISABLE`。

### 创建目录

```bash
mkdir -p /www/wwwroot/sonarqube
chown -R "$USER:$USER" /www/wwwroot/sonarqube
cd /www/wwwroot/sonarqube

# macOS：mkdir -p ~/docker/sonarqube && cd ~/docker/sonarqube
```

当前用户不是 root 时，给 `mkdir` 和 `chown` 加上 `sudo`。

### 编写 compose.yaml

```bash
cd /www/wwwroot/sonarqube
cat > compose.yaml <<'EOF'
services:
  sonarqube:
    image: docker.xuanyuan.run/library/sonarqube:26.4.0.121862-community
    container_name: sonarqube
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
EOF
```

| 项 | 说明 |
|----|------|
| `"9000:9000"` | 宿主机 **9000** → 容器 **9000** |
| `sonarqube_data` | 内置库和 Elasticsearch 索引，容器内 `/opt/sonarqube/data` |
| `sonarqube_extensions` | 第三方插件，容器内 `/opt/sonarqube/extensions` |
| `sonarqube_logs` | 访问日志、Web、Compute Engine 和 Elasticsearch 日志 |
| 无 JDBC 变量 | 不设置数据库变量时使用内置 H2 |

同一个数据卷不要同时挂给两个 SonarQube 容器。

### 启动

```bash
cd /www/wwwroot/sonarqube
docker compose up -d
docker compose ps
docker compose logs --tail 50 sonarqube
```

启动后等 1～2 分钟再打开浏览器。页面一直打不开时，按「常见问题」看日志。

## 登录并修改密码

浏览器访问 `http://服务器IP:9000`。把 IP 换成这台机器的地址。在服务器本机上可以用 `http://127.0.0.1:9000`。

初始用户名和密码都是 `admin`。登录页左侧标题是 Welcome to SonarQube，下面是 Username 和 Password，按钮是「Log in」。右侧标题是 SonarQube Server: Your independent code verification layer。

![SonarQube 登录页：左侧 Welcome to SonarQube，含 Username 与 Password，右侧为 SonarQube Server 介绍](https://imgs.xuanyuan.cloud/docker/blog/docker-sonarqube.png)

首次登录会进入修改密码页。标题是 Update your password。黄色提示是：This account should not use the default password. 三个输入框依次是 Old Password、Password、Confirm Password，按钮是「Update」。Old Password 填刚才的 `admin`，新密码不要继续用 `admin`。

![SonarQube 修改密码页：Update your password，提示不要继续使用默认密码](https://imgs.xuanyuan.cloud/docker/blog/docker-sonarqube-2.png)

## 创建项目并扫描

改完密码后打开创建项目页。标题是 How do you want to create your project? 上面是从 Azure DevOps、Bitbucket Cloud、Bitbucket Server、GitHub、GitLab 导入。本地试用点「Create a local project」。页脚是 Community Build v26.4.0.121862。顶部横幅写明内置数据库只适合评估。

![SonarQube 创建项目页：How do you want to create your project，含 Create a local project，页脚为 Community Build v26.4.0.121862](https://imgs.xuanyuan.cloud/docker/blog/docker-sonarqube-3.png)

1. 点「Create a local project」。
2. Project Key 填项目标识，例如 `my-first-project`。Display Name 填显示名。Main Branch Name 默认是 `main`。然后点「Set Up」。
3. 点「Generate Token」。令牌名称可以填 `local-scan-token`，再点「Generate」。
4. 令牌只显示一次。复制下来，后面的扫描命令要用。关掉页面以后不能再查看同一串令牌。

扫描器装在宿主机上，不在这个容器里。按 [SonarScanner 文档](https://docs.sonarsource.com/sonarqube-community-build/analyzing-source-code/scanners/sonarscanner/) 下载对应系统的 Scanner CLI。解压后把 `bin` 加进 PATH。新开一个终端，执行 `sonar-scanner -h`，能打出用法即可。

进入要扫描的项目目录。把令牌换成上一步复制的值。`sonar.sources=.` 表示从当前目录扫。只想扫某个源码目录时，把 `.` 换成那个目录。

```bash
sonar-scanner 
  -Dsonar.projectKey=my-first-project 
  -Dsonar.sources=. 
  -Dsonar.host.url=http://127.0.0.1:9000 
  -Dsonar.token=你的令牌
```

扫描器不在这台服务器上时，把 `127.0.0.1` 换成 SonarQube 那台机器的地址。

Windows 的 PowerShell：

```powershell
sonar-scanner.bat -Dsonar.projectKey=my-first-project -Dsonar.sources=. -Dsonar.host.url=http://127.0.0.1:9000 -Dsonar.token=你的令牌
```

扫描时间随项目大小变化。结束时终端里会出现 `EXECUTION SUCCESS`。

## 查看分析结果

回到浏览器，刷新这个项目。结果按缺陷、漏洞和代码异味分开。点开一条可以看到代码位置和说明。覆盖率要配合单元测试报告才会有数字。重复代码在 Duplications 里看。

导航里还有 Issues、Rules、Quality profiles、Quality gates 和 Administration。

## 改用 PostgreSQL

给团队继续用时，不要停留在内置 H2 上。Community Build 26.4 的 PostgreSQL 范围是 14 到 18。26.8 起改成 15 到 18。本文数据库镜像使用 **`postgres:15.12`**。

截图那套内置库不能迁到 PostgreSQL。下面是一套新的 Compose，JDBC 变量按官方容器说明来写。先停掉正在跑的内置库，并删掉它的数据卷。删卷会清掉评估期间的用户、项目和扫描结果。

```bash
cd /www/wwwroot/sonarqube
docker compose down -v
```

然后覆盖 `compose.yaml`，并写上数据库密码。`你的强密码` 换成自己的密码。用户名和库名用 `sonar`，要和 JDBC 地址里的库名一致。

```bash
cd /www/wwwroot/sonarqube
cat > .env <<'EOF'
POSTGRES_PASSWORD=你的强密码
EOF

cat > compose.yaml <<'EOF'
services:
  sonarqube:
    image: docker.xuanyuan.run/library/sonarqube:26.4.0.121862-community
    container_name: sonarqube
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    ports:
      - "9000:9000"

  db:
    image: docker.xuanyuan.run/library/postgres:15.12
    container_name: sonarqube-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: sonar
    volumes:
      - postgresql_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sonar -d sonar"]
      interval: 10s
      timeout: 5s
      retries: 10

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
  postgresql_data:
EOF
```

拉取数据库镜像并启动：

```bash
cd /www/wwwroot/sonarqube
docker pull docker.xuanyuan.run/library/postgres:15.12
docker compose up -d
docker compose ps
```

这套配置会重新初始化。用 `admin` / `admin` 再次登录，并重新修改密码、重新创建项目。不要把内置库的旧卷挂到已经配置了 PostgreSQL 的容器上。

同一套数据库 schema 只连接一个 SonarQube 实例。第二个容器再去连同一个库，数据会损坏。

## 备选：docker run

没有 Compose、只想临时打开页面时，可以用 `docker run`。标签和端口与上面的 Compose 相同。这条命令不挂数据卷，容器删除后内置库就没了。`SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true` 会跳过 Elasticsearch 的启动检查。Linux 上优先完成「环境要求」里的 `sysctl`，不要靠这个变量长期运行。

已经有名为 `sonarqube` 的容器时，先停掉 Compose 或删掉同名容器。

```bash
docker rm -f sonarqube
docker run -d 
  --name sonarqube 
  -p 9000:9000 
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true 
  docker.xuanyuan.run/library/sonarqube:26.4.0.121862-community
```

查看状态：

```bash
docker ps --filter name=sonarqube
docker logs --tail 50 sonarqube
```

浏览器地址与「登录并修改密码」相同。分析还在跑时，`docker stop` 默认大约 10 秒后会强行结束。官方建议加上 `--stop-timeout 3600`，让进行中的任务做完。

## 常见问题

**Q1：日志里出现 `vm.max_map_count is too low`？**

SonarQube 带有 Elasticsearch。在宿主机执行「环境要求」里的 `sysctl`。改健康检查不能代替这个内核参数。

Docker Desktop 里如果不能改宿主机的 `sysctl`，可以在临时的 `docker run` 上保留 `SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true`。这是跳过检查，不是把内核参数补上。

**Q2：容器退出，或者页面打不开？**

先看 `docker compose logs --tail 100 sonarqube`。内存低于 4 GB 时，Docker Desktop 打开「Settings」→「Resources」，把 Memory 调到至少 4 GB，再点「Apply & Restart」。Linux 上确认 `sysctl vm.max_map_count` 的值至少是 524288。

**Q3：为什么命令里不用 `latest`？**

截图页脚是 26.4.0.121862。2026-10-20 的 `latest` 指向 26.10.0.133078-community，界面和内存需求都可能不同。对照见「标签怎么选」。

**Q4：9000 已经被占用？**

只改映射的宿主机端口，例如 `19000:9000`。容器内仍然是 9000。浏览器地址和 `sonar.host.url` 改成新的宿主机端口。

**Q5：能不能在内置库上直接升级镜像？**

不能。创建项目页的横幅写明，内置库不支持升级到新版本，也不支持迁到别的数据库引擎。要换标签或改用 PostgreSQL，按「改用 PostgreSQL」新建数据，再重新扫描。

**Q6：令牌关掉页面就找不到了？**

生成时只显示一次。丢失后在这个项目里再生成一个新令牌，扫描命令改用新值。不要把令牌写进仓库。

**Q7：扫描结果里没有覆盖率？**

覆盖率要有单元测试报告。只跑 `sonar-scanner`、没有把测试报告交上去时，这一项不会有数字。

**Q8：登录页上的 AI 和 30 多种语言，这个镜像都有吗？**

这三张图是 Community Build。官方镜像说明里，AI CodeFix 和 30 种以上语言属于 SonarQube Server。Community Build 写的是 21 种语言和框架上的缺陷、代码异味和基础安全分析。

## 命令速查

```bash
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072

docker pull docker.xuanyuan.run/library/sonarqube:26.4.0.121862-community

cd /www/wwwroot/sonarqube
docker compose up -d
docker compose ps
docker compose logs --tail 50 sonarqube
docker compose restart sonarqube
docker compose down
```

`docker compose down` 保留命名卷。`docker compose down -v` 会删掉内置库或 PostgreSQL 里的数据。

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:9000`。初始账号是 `admin` / `admin`，首次登录后必须修改密码。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [library/sonarqube 镜像页](https://xuanyuan.cloud/zh/r/library/sonarqube) | [https://xuanyuan.cloud/zh/r/library/sonarqube](https://xuanyuan.cloud/zh/r/library/sonarqube) |
| [library/sonarqube 概览](https://xuanyuan.cloud/r/library/sonarqube) | [https://xuanyuan.cloud/r/library/sonarqube](https://xuanyuan.cloud/r/library/sonarqube) |
| [library/sonarqube 标签列表](https://xuanyuan.cloud/r/library/sonarqube/tags) | [https://xuanyuan.cloud/r/library/sonarqube/tags](https://xuanyuan.cloud/r/library/sonarqube/tags) |
| [library/postgres 镜像页](https://xuanyuan.cloud/zh/r/library/postgres) | [https://xuanyuan.cloud/zh/r/library/postgres](https://xuanyuan.cloud/zh/r/library/postgres) |
| [Docker Hub · sonarqube](https://hub.docker.com/_/sonarqube) | [https://hub.docker.com/_/sonarqube](https://hub.docker.com/_/sonarqube) |
| [用 Docker 安装 Community Build](https://docs.sonarsource.com/sonarqube-community-build/server-installation/from-docker-image/installation-overview) | [https://docs.sonarsource.com/sonarqube-community-build/server-installation/from-docker-image/installation-overview](https://docs.sonarsource.com/sonarqube-community-build/server-installation/from-docker-image/installation-overview) |
| [启动容器](https://docs.sonarsource.com/sonarqube-community-build/server-installation/from-docker-image/set-up-and-start-container) | [https://docs.sonarsource.com/sonarqube-community-build/server-installation/from-docker-image/set-up-and-start-container](https://docs.sonarsource.com/sonarqube-community-build/server-installation/from-docker-image/set-up-and-start-container) |
| [安装数据库](https://docs.sonarsource.com/sonarqube-community-build/server-installation/installing-the-database) | [https://docs.sonarsource.com/sonarqube-community-build/server-installation/installing-the-database](https://docs.sonarsource.com/sonarqube-community-build/server-installation/installing-the-database) |
| [主机要求](https://docs.sonarsource.com/sonarqube-community-build/server-installation/server-host-requirements) | [https://docs.sonarsource.com/sonarqube-community-build/server-installation/server-host-requirements](https://docs.sonarsource.com/sonarqube-community-build/server-installation/server-host-requirements) |
| [SonarScanner](https://docs.sonarsource.com/sonarqube-community-build/analyzing-source-code/scanners/sonarscanner/) | [https://docs.sonarsource.com/sonarqube-community-build/analyzing-source-code/scanners/sonarscanner/](https://docs.sonarsource.com/sonarqube-community-build/analyzing-source-code/scanners/sonarscanner/) |
| [Community Build 发行说明](https://docs.sonarsource.com/sonarqube-community-build/server-update-and-maintenance/release-notes) | [https://docs.sonarsource.com/sonarqube-community-build/server-update-and-maintenance/release-notes](https://docs.sonarsource.com/sonarqube-community-build/server-update-and-maintenance/release-notes) |
| [SonarQube Community Edition](https://www.sonarsource.com/open-source-editions/sonarqube-community-edition/) | [https://www.sonarsource.com/open-source-editions/sonarqube-community-edition/](https://www.sonarsource.com/open-source-editions/sonarqube-community-edition/) |
| [GitHub · SonarSource/sonarqube](https://github.com/SonarSource/sonarqube) | [https://github.com/SonarSource/sonarqube](https://github.com/SonarSource/sonarqube) |
| [GitHub · SonarSource/docker-sonarqube](https://github.com/SonarSource/docker-sonarqube) | [https://github.com/SonarSource/docker-sonarqube](https://github.com/SonarSource/docker-sonarqube) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/sonarqube-docker-deploy



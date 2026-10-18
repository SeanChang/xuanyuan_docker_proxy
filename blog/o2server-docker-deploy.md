# Docker 部署 O2OA（翱途）：轻松搭建企业协同办公平台

![Docker 部署 O2OA（翱途）：轻松搭建企业协同办公平台](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa.webp)

*分类: Docker部署教程 | 标签: O2OA,翱途,o2oa/o2server,Docker,轩辕镜像,协同办公,OA,私有化部署,部署教程 | 发布时间: 2026-10-14 16:00:37*

> O2OA（翱途）是一款面向企业的开源协同办公与应用开发平台，旨在把流程、门户、信息和组织数据集中管理，并通过浏览器完成审批和门户搭建。本文将介绍如何通过 Docker Compose 部署 O2OA，搭建私有化协同办公平台，帮助团队把流程和信息留在自己的服务器上，适合企业 OA 及内部审批门户等场景。

## O2OA 是什么

O2OA（翱途）是浙江兰德纵横网络技术股份有限公司开源的企业应用开发平台。它在浏览器里提供流程审批、信息发布、门户页面和组织数据，用来建设企业内部的协同办公系统。

和工作表、公有云 OA 相比，O2OA 把流程、门户、信息和组织放在同一套可以装在自己服务器上的系统里。现成功能可以直接用，也可以继续做表单和流程。

## O2OA 能做什么

- **流程审批**：设计并流转请假、报销一类审批。
- **信息发布**：发布新闻、公告和文档，并控制谁能看。
- **门户页面**：按自己的栏目搭办公首页。
- **组织与人员**：维护部门、人员和角色。
- **数据与服务**：做数据表和查询，也可以写定时任务和接口。

## 为什么要使用 O2OA

审批和附件散在聊天记录、表格里时，改过一版就对不上。放到按人数计费的公有云，这些数据还要离开自己的网络。

O2OA 把这套系统留在自己的服务器上。适合要自建办公系统的团队，也适合要在上面继续做表单和流程的人。

## 使用 Docker 部署 O2OA

O2OA 可以用 Docker 跑起来，宿主机不必先装 Java。开始之前准备好 Docker。这份镜像自带数据库，第一次用浏览器打开时要做初始化。

下面用 Docker Compose 启动服务，并在浏览器里完成初始化。

## 环境要求

本文命令使用 **`o2oa/o2server:9.5.2`**。这个标签目前只有 linux/amd64，原因见「标签怎么选」。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）；macOS 把 `/www/wwwroot/o2server` 换成 `~/docker/o2server`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| CPU / 内存 | 官方安装说明是 4 核以上、预留内存 4 GB 以上，并认为 4 核 8 GB 以上的服务器可以正常运行。本次测试没有记录这台机器的内存 |
| 架构 | **linux/amd64**。`9.5.2` 在 Docker Hub 上没有 arm64 |
| 磁盘 | 本机 `docker images` 显示 CONTENT SIZE **849 MB**，DISK USAGE **2.6 GB**。数据和日志另计。官方安装说明建议磁盘 10 GB 以上 |
| 端口 | 宿主机 **8080** → 容器 **80**。容器内的 80 保持不动 |
| 工作目录 | `/www/wwwroot/o2server` |
| 数据目录 | `data/` 挂到镜像内的 MySQL、配置、日志和站点文件 |

只在本机打开时可以用 `http://127.0.0.1:8080`。给别人用、或放到公网时，在前面加 HTTPS，见「使用域名访问」。

```bash
docker --version
docker compose version
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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

[O2OA 的 Docker 说明](https://www.o2oa.net/cms/serverdeployment/713.html)把 `o2oa/o2server` 定义为默认同步版本，镜像里带 MySQL，默认就连这个库。Docker Hub 上，`latest` 与 **`9.5.2`** 在 2026-04-20 指向同一份 linux/amd64 镜像。`latest` 以后会变，本文命令使用 **`9.5.2`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`9.5.2`** | 当前与 `latest` 相同的稳定版本，linux/amd64 | **是** |
| `latest` | 现在等于 `9.5.2`，以后会变 | 否 |
| `9.5.1` / `9.5.0` | 更早的 9.5 构建 | 否 |
| `10.0.beta` / `10.0.0_mysql_20250509` | 2025-05 的测试构建，推送时间早于 `9.5.2` | 否 |
| `9.2.1` | 较旧版本，Docker Hub 上同时有 amd64 和 arm64 | 仅 ARM 机器，见常见问题 |
| `9.2.1-arm` | 只含 arm64 的旧标签 | 否 |

同组织还有另外两个镜像，本文不部署：

| 镜像 | 官方说明 |
|------|----------|
| `o2oa/onlyoffice` | 集成 OnlyOffice Docs 社区版，内置 PostgreSQL |
| `o2oa/baseo2server` | 不集成数据库，需要自己准备库 |

完整标签见[标签列表](https://xuanyuan.cloud/r/o2oa/o2server/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/o2oa/o2server:9.5.2
```

Ubuntu 24.04 上拉取完成后，`docker images` 显示：

```text
IMAGE                                     ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/o2oa/o2server:9.5.2   0735c7806150        2.6GB          849MB    U
```

## Docker Compose 部署

官方下载页上的自定义启动命令，把 MySQL 数据、配置、自定义应用、日志和站点文件挂到宿主机。本文沿用这些容器内路径，宿主机放在 `/www/wwwroot/o2server/data`。`docker compose down` 不加额外参数时，不会删除 `data/`。目录里已经有初始化数据时，不要清空它。

官方快速示例是 `-p 80:80`。冒号左边是宿主机端口，可以改；冒号右边是容器端口，官方不建议改。本文写成 **8080:80**，避免和机器上已有的网站抢 80。浏览器打开 `http://127.0.0.1:8080`。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。`docker rm` 不删除 `data/`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p 
  /www/wwwroot/o2server/data/mysql/lib/mysql 
  /www/wwwroot/o2server/data/mysql/etc/mysql 
  /www/wwwroot/o2server/data/o2server/config 
  /www/wwwroot/o2server/data/o2server/custom 
  /www/wwwroot/o2server/data/o2server/dynamic 
  /www/wwwroot/o2server/data/o2server/local 
  /www/wwwroot/o2server/data/o2server/logs 
  /www/wwwroot/o2server/data/o2server/webroot
sudo chown -R "$USER":"$USER" /www/wwwroot/o2server
```

同名容器还在时：

```bash
docker rm -f o2server
```

2. 写入 `compose.yaml`。容器监听 80，宿主机使用 8080。

```bash
cd /www/wwwroot/o2server
cat > compose.yaml <<'EOF'
name: o2server

services:
  o2server:
    image: docker.xuanyuan.run/o2oa/o2server:9.5.2
    container_name: o2server
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - ./data/mysql/lib/mysql:/var/lib/mysql
      - ./data/mysql/etc/mysql:/etc/mysql
      - ./data/o2server/config:/opt/o2server/config
      - ./data/o2server/custom:/opt/o2server/custom
      - ./data/o2server/dynamic:/opt/o2server/dynamic
      - ./data/o2server/local:/opt/o2server/local
      - ./data/o2server/logs:/opt/o2server/logs
      - ./data/o2server/webroot:/opt/o2server/webroot
EOF
```

3. 启动：

```bash
cd /www/wwwroot/o2server
docker compose up -d
```

4. 看状态。`o2server` 应为 Up，并且能看到 `0.0.0.0:8080->80/tcp`。1099、3306、33060 如果出现在列表里，只是镜像声明的端口，本文没有映到宿主机。

```bash
docker compose ps
```

容器是 Up 之后，按「浏览器初始化」打开页面。

## 浏览器初始化

容器是 Up 之后，在跑 Docker 的这台机器上打开：

```text
http://127.0.0.1:8080
```

从别的电脑访问时，把 `127.0.0.1` 换成这台机器的 IP。本次测试打开的是 `http://192.168.1.35:8080/`。云服务器还要在安全组里放行 **8080**。

O2OA V8.1 之后没有预置管理员密码。页面标题是「欢迎使用 O2OA（翱途）企业应用开发平台」，副标题是「首次启动服务器需要进行服务器初始化配置」。下面设的密码请自己记下。管理员权限很大，密码丢失后官方说明是无法找回。

1. 左侧标题是「设置管理员密码」。密码必须 8 位以上，同时包含数字、字母和特殊字符（`#?!@$%^&*-`）。右侧两个输入框的提示是「请设置管理员密码」和「请再次输入密码」。填完点「下一步」。

![O2OA 初始化：设置管理员密码，要求 8 位以上并含数字、字母和特殊字符](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-1.webp)

2. 左侧标题变成「设置数据库」。右侧是「您已初始化了数据库」，不用填主机和账号，点「下一步」。页面写着，要改数据库时，等服务器启动后进入「系统配置」-「服务器配置」-「数据库配置」。左侧说明这份内置库适合开发和演示；正式环境再换外部的 MySQL 8、Oracle 12C 或 SQL Server 2012。官方说明 `o2oa/o2server` 的内置库是 MySQL。

![O2OA 初始化：数据库页显示您已初始化了数据库](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-2.webp)

3. 左侧标题是「初始化数据」。没有要导入的 zip 时，不要点「选择 zip 文件」，直接点「下一步」。

![O2OA 初始化数据：将 zip 文件拖动到此处，不需要时点下一步](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-3.webp)

4. 「初始化信息」页有三项：管理员密码已设置、数据库：已初始化数据库、不导入数据文件。确认后点「执行」。

![O2OA 初始化信息：管理员密码已设置，点执行](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-4.webp)

5. 点「执行」。页面先显示「服务器初始化正在执行中…」，随后变成「正在启动 O2OA（翱途）服务器…」。这一步会停一阵。先不要删容器，也不要重设密码。

![O2OA 执行初始化：服务器初始化正在执行中](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-5.webp)

![O2OA 执行初始化：正在启动 O2OA 服务器](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-6.webp)

启动还没完成时打开首页，会看到 Jetty 的 404。本次测试在 `http://192.168.1.35:8080/` 上就是这个页面：

```text
HTTP ERROR 404 Not Found
URI:	/
STATUS:	404
MESSAGE:	Not Found
SERVLET:	-
```

当时容器仍然是 Up，端口已经映射好。这是点「执行」之后拍的 `docker compose ps`，不是刚 `up -d` 的瞬间：

```text
NAME       IMAGE                                     COMMAND                  SERVICE    CREATED          STATUS          PORTS
o2server   docker.xuanyuan.run/o2oa/o2server:9.5.2   "/opt/o2server-entry…"   o2server   34 minutes ago   Up 33 minutes   1099/tcp, 3306/tcp, 33060/tcp, 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
```

看日志：

```bash
docker compose logs --tail 80 o2server
```

同一时刻的末尾还在部署应用。节选如下，`mbind: Operation not permitted` 实际重复了三行：

```text
o2server  | deploy war:/opt/o2server/x_query_assemble_designer.war.
o2server  | 2026-10-14 15:20:24.089 [ForkJoinPool.commonPool-worker-3] INFO com.x.base.core.project.Context - com.x.base.core.project.x_query_assemble_designer loading datas, entity size:34.
o2server  | 2026-10-14 15:21:21.855 [ContextQuartzScheduler-x_processplatform_assemble_bam_Worker-2] ERROR com.x.processplatform.assemble.bam.schedule.StateTimer - id:5769399a-4455-4634-96da-dc49c1e013ae, name:com.x.processplatform.assemble.bam.schedule.StateTimer, message:can not find application with name:com.x.base.core.project.x_organization_assemble_express., exception:com.x.base.core.project.ExceptionFindApplicationName.
o2server  | mbind: Operation not permitted
```

`mbind` 表示容器不允许做内存绑定，不是内存已经用尽。`can not find application` 来自定时任务，容器没有因此退出。前面还有多行 `deploy war` 和 `loading datas`。这段日志里没有 `OutOfMemoryError`。

`deploy war` 还在增加时，继续等。不再增加后，再打开 `http://IP:8080/`。若日志长时间不再增长、页面仍是这个 404，对照官方的 4 核 8 GB 再决定要不要加大内存。不要为了这个 404 删掉 `data/`。

6. 启动完成后，再打开首页，会进入登录页。标题是「企业办公平台」。用「密码登录」，用户名填 `xadmin`，密码填初始化时设置的那一个，点「登录」。页面上还有「短信验证登录」和「忘记密码?」，这次没用。

![O2OA 登录页：企业办公平台，用户名 xadmin](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-7.webp)

7. 登录后右上角是 `xadmin`。首页左侧是「办公中心」。中间是「最新信息」「我的会议」「待办」和「网盘文件」。刚初始化完，信息和待办都是空的。右侧日历是当月，本次测试显示 2026 年 10 月，14 日标成今天。

![O2OA 首页：办公中心，待办为空，右侧是 2026 年 10 月日历](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-8.webp)

8. 点左侧「办公中心」，打开「待办」。中间是「没有要处理的待办」和「新建流程文件」。左下角按钮是「新建流程」。

![O2OA 办公中心：待办为空，可新建流程](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-9.webp)

9. 右上角进入「个人设置」，打开「个人信息」。姓名和工号都是 `xadmin`，邮件地址是 `xadmin@o2oa.net`，语言设置是「简体中文」。要改这些内容时，改完点「保存个人信息」。

![O2OA 个人设置：姓名 xadmin，邮件地址 xadmin@o2oa.net](https://imgs.xuanyuan.cloud/docker/blog/o2oa/o2oa-10.webp)

## 使用域名访问

只在本机使用时，可以继续用 `http://127.0.0.1:8080`。要用域名给别人打开时，在 O2OA 前面放一层反向代理，并由代理做 HTTPS。

下面是一段 Nginx 示例。把 `oa.example.com` 换成你的域名。O2OA 仍监听本机 8080，容器内端口仍是 80。

```nginx
server {
    listen 80;
    server_name oa.example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

改完后重载 Nginx。证书和 HTTPS 的其余做法见官方的[HTTP 端口规划](https://www.o2oa.net/cms/serverdeployment/501.html)。单机按本文部署时，不要改容器里的 80。

## 备选：docker run

上面的 Compose 已经在跑时，停在那里即可，不必再做这一节。

没有 Compose、只想短期打开看看时，用一条 `docker run`。8080 上已经有 Compose 里的容器时，先停掉它。数据目录用 `/www/wwwroot/o2server-run`，不要挂上面的 `data/`。

官方快速命令使用 `-it`，控制台留在前台。下面这条加上 `-d`，容器在后台运行。要看启动过程，用 `docker logs`。

```bash
cd /www/wwwroot/o2server
docker compose down
```

```bash
sudo mkdir -p 
  /www/wwwroot/o2server-run/data/mysql/lib/mysql 
  /www/wwwroot/o2server-run/data/mysql/etc/mysql 
  /www/wwwroot/o2server-run/data/o2server/config 
  /www/wwwroot/o2server-run/data/o2server/custom 
  /www/wwwroot/o2server-run/data/o2server/dynamic 
  /www/wwwroot/o2server-run/data/o2server/local 
  /www/wwwroot/o2server-run/data/o2server/logs 
  /www/wwwroot/o2server-run/data/o2server/webroot
sudo chown -R "$USER":"$USER" /www/wwwroot/o2server-run
docker run -d 
  --name o2server 
  --restart unless-stopped 
  -p 8080:80 
  -v /www/wwwroot/o2server-run/data/mysql/lib/mysql:/var/lib/mysql 
  -v /www/wwwroot/o2server-run/data/mysql/etc/mysql:/etc/mysql 
  -v /www/wwwroot/o2server-run/data/o2server/config:/opt/o2server/config 
  -v /www/wwwroot/o2server-run/data/o2server/custom:/opt/o2server/custom 
  -v /www/wwwroot/o2server-run/data/o2server/dynamic:/opt/o2server/dynamic 
  -v /www/wwwroot/o2server-run/data/o2server/local:/opt/o2server/local 
  -v /www/wwwroot/o2server-run/data/o2server/logs:/opt/o2server/logs 
  -v /www/wwwroot/o2server-run/data/o2server/webroot:/opt/o2server/webroot 
  docker.xuanyuan.run/o2oa/o2server:9.5.2
```

然后打开 `http://127.0.0.1:8080`，按「浏览器初始化」填写。日志：

```bash
docker logs --tail 80 o2server
```

试用结束、要回到 Compose 时，停掉这个容器，再启动原来的 Compose。不要删除 `/www/wwwroot/o2server/data`。

```bash
docker stop o2server && docker rm o2server
cd /www/wwwroot/o2server
docker compose up -d
```

## 常见问题

**Q1：登录密码是不是 `o2`？**

不是。安装包旧说明里出现过账号 `xadmin`、密码 `o2`。O2OA V8.1 之后没有默认密码，要在初始化页自己设置。页面要求 8 位以上，同时包含数字、字母和特殊字符（`#?!@$%^&*-`）。密码丢失后官方说明是无法找回。登录账号仍是 `xadmin`。

**Q2：首页是 HTTP ERROR 404？**

这是点「执行」之后、应用还在部署时的页面，不是密码设错。日志和当时的 `docker compose ps` 在「浏览器初始化」。`deploy war` 还在增加时继续等，不要删 `data/`。不再增加后重新打开首页。本次测试等部署结束后进入了登录页。`mbind: Operation not permitted` 不是内存用尽。日志长时间不再增长、页面仍是 404，并且机器低于官方的 4 核 8 GB 时，再把内存加到官方建议后启动。

**Q3：8080 完全打不开？**

按这个顺序看：

1. `docker compose ps` 里 `o2server` 是否为 Up。
2. 在服务器上打开 `http://127.0.0.1:8080`。本机打不开时，再看 `docker compose logs --tail 80 o2server`。
3. 本机通、别的电脑不通时，检查安全组和防火墙是否放行了 8080。本次测试从另一台电脑打开 `http://192.168.1.35:8080/`，初始化页是能开的。

**Q4：刷新后又回到初始化？**

管理员密码和业务数据在 `/www/wwwroot/o2server/data`。Compose 没有挂载这些目录时，删掉容器就会丢掉初始化结果。确认 `compose.yaml` 里的卷还在，并且没有删过 `data/`。

**Q5：这是 ARM 机器，拉取失败？**

`9.5.2` 在 Docker Hub 上只有 linux/amd64。本文没有在 ARM 上实测。ARM 机器不要拉这个标签。较旧的 `9.2.1` 同时有 amd64 和 arm64，那是更早的版本。

**Q6：要不要映射 20020、20030 和 3306？**

安装包文档要求开放 80、20020、20030。Docker 官方示例只映射 Web 端口，容器内是 80。本文不把 20020、20030 映到宿主机。`docker compose ps` 里能看到 `3306/tcp`，那是容器里的数据库端口，官方示例没有把它映出来。不要再加一条 `3306:3306`。

**Q7：`onlyoffice` 和 `baseo2server` 能换进这篇吗？**

不能替换进本文的 `image:`。`o2oa/onlyoffice` 还包含 OnlyOffice，数据库是 PostgreSQL。`o2oa/baseo2server` 不带数据库，要自己准备库。只部署默认同步版本、并使用内置 MySQL 时，用 `o2oa/o2server:9.5.2`。

**Q8：如何升级？**

先备份整个 `data/`。把 `compose.yaml` 里的标签改成新的具体版本，不要改成 `latest`，然后执行：

```bash
cd /www/wwwroot/o2server
docker compose pull
docker compose up -d
```

不要删除 `data/`。

**Q9：如何停止？**

还要保留初始化数据和上传文件时，不要删除 `data/`。

```bash
cd /www/wwwroot/o2server
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop o2server && docker rm o2server
```

站点不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/o2server/data /www/wwwroot/o2server-run
```

**Q10：正式环境可以一直用镜像里的数据库吗？**

可以先用它把系统跑起来。初始化页不用填连接信息，本文也没有改。官方建议正式环境换独立的 MySQL 8、Oracle 12C 或 SQL Server 2012，并开启平台自带的定期备份。安装包文档里的 H2 是未换数据库时的内嵌库；`o2oa/o2server` 的官方说明是内置 MySQL。

**Q11：可以把 8080 直接暴露到公网吗？**

`xadmin` 能管理系统。给公网使用时，用「使用域名访问」里的反向代理做 HTTPS，不要长期开放明文的 8080。宿主机 8080 已被占用时，把 Compose 里的 `"8080:80"` 改成 `"18080:80"`，访问 `http://IP:18080`。只改冒号左边。

## 命令速查

```bash
docker pull docker.xuanyuan.run/o2oa/o2server:9.5.2

cd /www/wwwroot/o2server
docker compose up -d
docker compose ps
docker compose logs --tail 80 o2server
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://127.0.0.1:8080`，为 `xadmin` 设置密码，数据库页保持「您已初始化了数据库」，没有 zip 就点「下一步」，最后点「执行」。点执行后若首页是 Jetty 404，先等应用部署完再登录。数据在 `data/`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [o2oa/o2server 镜像页](https://xuanyuan.cloud/zh/r/o2oa/o2server) | [https://xuanyuan.cloud/zh/r/o2oa/o2server](https://xuanyuan.cloud/zh/r/o2oa/o2server) |
| [o2oa/o2server 概览](https://xuanyuan.cloud/r/o2oa/o2server) | [https://xuanyuan.cloud/r/o2oa/o2server](https://xuanyuan.cloud/r/o2oa/o2server) |
| [o2oa/o2server 标签列表](https://xuanyuan.cloud/r/o2oa/o2server/tags) | [https://xuanyuan.cloud/r/o2oa/o2server/tags](https://xuanyuan.cloud/r/o2oa/o2server/tags) |
| [Docker Hub · o2oa/o2server](https://hub.docker.com/r/o2oa/o2server) | [https://hub.docker.com/r/o2oa/o2server](https://hub.docker.com/r/o2oa/o2server) |
| [GitHub · o2oa/o2oa](https://github.com/o2oa/o2oa) | [https://github.com/o2oa/o2oa](https://github.com/o2oa/o2oa) |
| [O2OA 官网](https://www.o2oa.net/) | [https://www.o2oa.net/](https://www.o2oa.net/) |
| [通过 Docker Hub 部署](https://www.o2oa.net/cms/serverdeployment/713.html) | [https://www.o2oa.net/cms/serverdeployment/713.html](https://www.o2oa.net/cms/serverdeployment/713.html) |
| [服务器下载（含数据卷命令）](https://www.o2oa.net/mobilex/get/download.html) | [https://www.o2oa.net/mobilex/get/download.html](https://www.o2oa.net/mobilex/get/download.html) |
| [HTTP 端口规划](https://www.o2oa.net/cms/serverdeployment/501.html) | [https://www.o2oa.net/cms/serverdeployment/501.html](https://www.o2oa.net/cms/serverdeployment/501.html) |
| [o2oa/onlyoffice 镜像页](https://xuanyuan.cloud/r/o2oa/onlyoffice) | [https://xuanyuan.cloud/r/o2oa/onlyoffice](https://xuanyuan.cloud/r/o2oa/onlyoffice) |
| [o2oa/baseo2server 镜像页](https://xuanyuan.cloud/r/o2oa/baseo2server) | [https://xuanyuan.cloud/r/o2oa/baseo2server](https://xuanyuan.cloud/r/o2oa/baseo2server) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

`o2oa/onlyoffice` 带 OnlyOffice 和 PostgreSQL，`o2oa/baseo2server` 不带数据库。本文只部署 `o2oa/o2server`。

## 阅读原文

[https://xuanyuan.cloud/blog/o2server-docker-deploy](https://xuanyuan.cloud/blog/o2server-docker-deploy)



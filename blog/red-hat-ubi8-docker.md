# Red Hat UBI8 镜像详解与 Docker 部署全流程

![Red Hat UBI8 镜像详解与 Docker 部署全流程](https://img.xuanyuan.dev/docker/blog/docker-ubi8.png)

*分类: Docker,UBI8 | 标签: red-hat-ubi8,docker,部署教程 | 发布时间: 2025-10-10 03:10:57*

> 如果你需要一个“靠谱、安全、能长期用”的容器基础镜像，尤其是企业级场景（比如部署核心业务应用），UBI8 是首选之一。

## 一、Red Hat UBI8 到底是什么？有什么用？
Red Hat UBI8（Universal Base Image 8，通用基础镜像）是 Red Hat 官方设计并维护的容器基础层，专门用来承载你的**容器化应用、中间件（如 Tomcat、MySQL）和各类工具**——简单说，它就像容器世界里的“操作系统底层”，所有需要容器化运行的程序，都可以把 UBI8 当作“地基”来搭建。

从实际使用角度，UBI8 有几个核心价值，不管是初学者还是企业级工程师都得了解：
- **免费可分发**：不用花钱就能下载、使用，还能基于它二次打包自己的应用镜像，不用担心版权问题；
- **官方维护+定期更新**：Red Hat 团队会持续给 UBI8 打安全补丁、更新系统库，比自己找的第三方基础镜像（如随意找的 CentOS 镜像）更稳定、安全；
- **企业级兼容性**：作为 Red Hat 生态的一部分，UBI8 能完美适配 Red Hat 旗下产品（如 OpenShift、RHEL），同时也兼容绝大多数 Linux 容器化应用，不会出现“应用在其他基础镜像能跑，在 UBI8 跑不了”的情况；
- **轻量且精简**：相比完整的 RHEL 系统镜像，UBI8 只保留了容器运行必需的组件，体积更小，启动更快，适合部署在服务器、云平台等各种环境。

简单总结：如果你需要一个“靠谱、安全、能长期用”的容器基础镜像，尤其是企业级场景（比如部署核心业务应用），UBI8 是首选之一。


## 二、准备工作：先装 Docker（没装的看这里）
如果你的 Linux 服务器还没装 Docker 和 Docker Compose，直接用下面的一键脚本——支持 CentOS、Ubuntu、Debian 等绝大多数发行版，还能自动配置轩辕镜像访问支持源（拉取 UBI8 更快），不用手动改配置，新手也能一步到位：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```
执行完脚本后，输入 `docker --version` 和 `docker compose --version`，能看到版本号就说明装好了。


## 三、第一步：找到并拉取 Red Hat UBI8 镜像
我们用“轩辕镜像”来拉取 UBI8（地址：https://xuanyuan.cloud/r/redhat/ubi8 ），这个源在国内访问更快，还提供多种拉取方式，按需选就行。

### 3.1 先看镜像信息（可选，了解细节）
打开上面的轩辕镜像链接，页面里会显示 UBI8 的最新版本、镜像大小、更新时间，还有不同架构（如 amd64、arm64）的拉取命令，高级工程师可以根据服务器架构选择对应版本，初学者直接用默认的 `latest` 版本就行。

### 3.2 拉取 UBI8 镜像（4种方式，推荐第3种）
#### 方式1：轩辕镜像登录验证拉取（适合需要镜像权限的场景）
如果你的团队配置了轩辕镜像的登录权限，用这个命令：
```bash
docker pull docker.xuanyuan.run/redhat/ubi8:latest
```
“latest”是镜像的最新版本标签，如果你需要指定版本（比如 `8.9`），把“latest”换成具体版本号就行（如 `docker.xuanyuan.run/redhat/ubi8:8.9`）。

#### 方式2：拉取后改名（方便后续使用）
有些时候，拉取的镜像名太长（比如带“docker.xuanyuan.run”前缀），后续启动容器时命令不方便记，可以拉取后改个短名字：
```bash
# 先拉取镜像
docker pull docker.xuanyuan.run/redhat/ubi8:latest \
# 改名为“redhat/ubi8:latest”（官方标准名）
&& docker tag docker.xuanyuan.run/redhat/ubi8:latest redhat/ubi8:latest \
# 删除原来的长名镜像，避免占存储空间
&& docker rmi docker.xuanyuan.run/redhat/ubi8:latest
```
解释下这三个命令：
- `docker pull`：从轩辕镜像源下载镜像；
- `docker tag`：给镜像加一个新标签（相当于“别名”），不改变镜像本身；
- `docker rmi`：删除原来的标签（不是删镜像文件），释放标签占用的资源。

#### 方式3：免登录拉取（推荐！新手直接用）
不用注册账号，不用输密码，直接拉取，访问表现还快，适合大多数场景：
```bash
# 基础拉取命令
docker pull xxx.xuanyuan.run/redhat/ubi8:latest

# 带改名的完整命令（推荐，后续用着方便）
docker pull xxx.xuanyuan.run/redhat/ubi8:latest \
&& docker tag xxx.xuanyuan.run/redhat/ubi8:latest redhat/ubi8:latest \
&& docker rmi xxx.xuanyuan.run/redhat/ubi8:latest
```
这个方式的镜像内容和“docker.xuanyuan.run”源完全一样，只是拉取地址不用登录，新手不用纠结权限问题。

#### 方式4：官方直连拉取（适合能访问 Docker Hub 的环境）
如果你的服务器能直接连 Docker Hub（比如海外服务器），或者已经配置了轩辕镜像访问支持器（前面的一键脚本已经配了），可以直接拉 Red Hat 官方镜像：
```bash
docker pull redhat/ubi8:latest
```

### 3.3 验证镜像是否拉取成功
不管用哪种方式，拉完后执行这个命令检查：
```bash
docker images
```
如果输出里有类似下面的内容，说明拉取成功了：
```
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
redhat/ubi8         latest    7f88b8111111   3 days ago     235MB
```


## 四、第二步：部署 UBI8 容器（3种场景，按需选）
UBI8 是基础镜像，部署时要根据你的需求选方案——比如测试用就简单启动，实际项目要持久化数据，企业级场景用 Compose 管理。

### 4.1 快速部署（测试/临时使用，适合新手）
如果只是想先“用起来”UBI8，比如测试基础环境是否正常，用这个命令：
```bash
# 启动 UBI8 容器，命名为“ubi8-test”
docker run -d -it --name ubi8-test redhat/ubi8:latest /bin/bash
```
#### 命令参数解释（新手必看）：
- `-d`：让容器在后台运行（不会占用当前终端）；
- `-it`：启用交互式终端（因为 UBI8 默认没有前台进程，不加这个容器会启动后立即退出）；
- `--name ubi8-test`：给容器起个名字“ubi8-test”，后续停止、重启容器时直接用这个名字，不用记长 ID；
- `/bin/bash`：容器启动后执行的命令（启动 Bash 终端，保持容器运行）。

#### 怎么用这个测试容器？
进入容器内部操作（比如查看系统版本、安装工具）：
```bash
# 进入“ubi8-test”容器的 Bash 终端
docker exec -it ubi8-test bash
```
进去后可以试几个命令，比如：
- 查看系统版本：`cat /etc/redhat-release`（会显示“Red Hat Enterprise Linux release 8.x”）；
- 安装简单工具（如 wget）：`microdnf install wget -y`（UBI8 用 microdnf 代替 yum，更轻量）；
- 退出容器：输入 `exit` 就行，容器还会在后台运行。

### 4.2 挂载目录部署（实际项目用，持久化数据）
测试完后，实际项目里用 UBI8，必须做“数据持久化”——比如容器里的配置文件、日志、业务数据，要存在宿主机（你的服务器）上，不然容器删了数据就没了。

#### 步骤1：在宿主机创建挂载目录
先在服务器上建几个目录，用来存 UBI8 容器的配置、日志和数据：
```bash
# 一次性创建 3 个目录（conf：配置，logs：日志，data：数据）
mkdir -p /data/ubi8/{conf,logs,data}
```
“/data/ubi8”是宿主机上的目录路径，你可以改成自己习惯的路径（比如 /opt/ubi8），只要后续命令对应上就行。

#### 步骤2：启动容器并挂载目录
```bash
docker run -d -it --name ubi8-prod \
  # 挂载宿主机目录到容器内（格式：宿主机路径:容器内路径）
  -v /data/ubi8/conf:/etc/ubi8/conf \
  -v /data/ubi8/logs:/var/log/ubi8 \
  -v /data/ubi8/data:/opt/ubi8/data \
  # （可选）设置时区，避免容器内时间和宿主机不一致
  -e TZ=Asia/Shanghai \
  redhat/ubi8:latest /bin/bash
```

#### 目录挂载说明（清晰对应，不怕搞混）：
| 宿主机目录          | 容器内目录          | 用途说明                                  |
|---------------------|---------------------|-------------------------------------------|
| `/data/ubi8/conf`   | `/etc/ubi8/conf`    | 存容器的配置文件（如后续部署应用的配置）  |
| `/data/ubi8/logs`   | `/var/log/ubi8`     | 存容器的日志文件（方便在宿主机查看日志）  |
| `/data/ubi8/data`   | `/opt/ubi8/data`    | 存业务数据（如数据库文件、缓存文件）      |

#### 怎么验证挂载生效？
在宿主机的 data 目录下写个文件，看容器里能不能读到：
1. 宿主机执行：`echo "UBI8 持久化测试" > /data/ubi8/data/test.txt`；
2. 进入容器：`docker exec -it ubi8-prod bash`；
3. 容器内查看：`cat /opt/ubi8/data/test.txt`，能看到“UBI8 持久化测试”就说明挂载成功了。

### 4.3 Docker Compose 部署（企业级场景，适合高级工程师）
如果你的项目里有多个容器（比如 UBI8 上部署了 Java 应用，还要连 MySQL 容器），用 Docker Compose 能统一管理所有容器的配置，一键启动/停止，不用记一堆命令。

#### 步骤1：创建 docker-compose.yml 文件
在服务器上找个目录（比如 /opt/ubi8-compose），创建 `docker-compose.yml` 文件：
```yaml
version: '3.8'  # Compose 语法版本，3.8 兼容大多数 Docker 版本
services:
  # 定义 UBI8 服务，名称叫“ubi8-service”
  ubi8-service:
    image: redhat/ubi8:latest  # 使用的 UBI8 镜像
    container_name: ubi8-enterprise  # 容器名称
    restart: always  # 容器意外退出后自动重启（保障服务不中断）
    tty: true  # 保持终端运行（类似 -t 参数，避免容器退出）
    stdin_open: true  # 启用标准输入（类似 -i 参数）
    environment:
      - TZ=Asia/Shanghai  # 设置时区
      # （可选）添加其他环境变量，比如应用的配置参数
      # - APP_ENV=production
    volumes:
      # 挂载目录，和前面的“挂载目录部署”对应
      - ./conf:/etc/ubi8/conf
      - ./logs:/var/log/ubi8
      - ./data:/opt/ubi8/data
    # （可选）暴露端口，如果 UBI8 上部署了 Web 应用，需要映射端口
    # ports:
    #   - "8080:8080"  # 宿主机 8080 端口映射到容器 8080 端口
```

#### 步骤2：启动服务
1. 进入 `docker-compose.yml` 所在的目录（比如 /opt/ubi8-compose）；
2. 执行启动命令：
```bash
# 后台启动所有服务（-d 表示后台运行）
docker compose up -d
```

#### 常用 Compose 命令（高级工程师必备）：
- 停止服务：`docker compose down`（不会删挂载的数据，放心用）；
- 查看服务状态：`docker compose ps`（看容器是否在运行）；
- 查看容器日志：`docker compose logs ubi8-service`（只看 UBI8 容器的日志）；
- 重启服务：`docker compose restart ubi8-service`。


## 五、第三步：验证 UBI8 容器是否正常运行
不管用哪种部署方式，都要确认容器没问题，这几步必做：

### 1. 查看容器状态
```bash
docker ps | grep ubi8
```
如果输出里的“STATUS”列显示“Up”（比如“Up 5 minutes”），说明容器在正常运行。

### 2. 检查容器内环境
进入容器，执行基本命令，确认系统和工具正常：
```bash
# 进入容器
docker exec -it 容器名 bash  # 容器名是你起的，比如 ubi8-test、ubi8-prod

# 容器内执行以下命令，验证环境
cat /etc/redhat-release  # 看系统版本，确认是 UBI8
microdnf --version       # 看包管理工具是否正常
date                     # 看时间是否和宿主机一致（如果设了时区）
```

### 3. 验证持久化（针对挂载目录部署）
前面已经讲过，这里再补一个场景：在容器内写文件，宿主机查看——确保数据双向同步：
1. 容器内执行：`echo "企业级数据测试" > /opt/ubi8/data/enterprise.txt`；
2. 宿主机执行：`cat /data/ubi8/data/enterprise.txt`（路径对应你挂载的宿主机目录），能看到内容就没问题。


## 六、常见问题（踩过的坑都在这了）
### 1. 拉取镜像失败，提示“network error”或“timeout”？
- 原因：网络不好，或者镜像源没配置对；
- 解决：用前面的“免登录拉取”方式（xxx.xuanyuan.run 源），或者重新执行 Docker 一键安装脚本（会自动配置轩辕加速源）。

### 2. 容器启动后立即退出，STATUS 显示“Exited”？
- 原因：UBI8 是基础镜像，没有默认的前台进程，没加 `-it` 或 `tty: true` 参数；
- 解决：
  - 快速部署：加 `-it` 参数（参考 4.1 的命令）；
  - Compose 部署：确保 `docker-compose.yml` 里有 `tty: true` 和 `stdin_open: true`（参考 4.3 的配置）。

### 3. 容器内用 microdnf 安装软件，提示“no package available”？
- 原因：UBI8 的默认软件源可能没包含某些工具，或者需要更新源；
- 解决：先更新源，再安装：
```bash
# 容器内执行
microdnf update -y  # 更新软件源缓存
microdnf install 软件名 -y  # 比如 install wget -y、install vim -y
```

### 4. 挂载目录时，提示“permission denied”（权限不足）？
- 原因：宿主机目录的权限太低，容器内用户（默认是 root）没权限读写；
- 解决：给宿主机的挂载目录加权限：
```bash
# 宿主机执行，替换成你的目录路径
chmod -R 755 /data/ubi8
# 或者给目录改所有者（和容器内用户一致，默认是 root）
chown -R root:root /data/ubi8
```

### 5. 容器内时间和宿主机不一致？
- 原因：没设置时区，容器用默认的 UTC 时间；
- 解决：
  - 启动时加环境变量：`-e TZ=Asia/Shanghai`（参考 4.2 的命令）；
  - Compose 部署：在 `environment` 里加 `- TZ=Asia/Shanghai`（参考 4.3 的配置）。


## 七、结尾：UBI8 后续怎么用？
UBI8 本身是基础镜像，不是“应用”，部署完后，你可以基于它做这些事：
- 新手：练习 Linux 命令（容器里操作，不怕搞坏宿主机）；
- 开发：打包自己的应用（比如把 Java 项目、Python 项目放到 UBI8 里，做成新镜像）；
- 企业级：部署中间件（如在 UBI8 上装 Nginx、Redis、PostgreSQL，用 Compose 管理）。

如果后续遇到问题，优先看容器日志（`docker logs 容器名`），大多数问题能从日志里找到原因；也可以参考 Red Hat 官方文档（https://access.redhat.com/documentation/en-us/red_hat_universal_base_image/8 ），里面有更详细的 UBI8 用法。

从快速测试到企业级部署，这篇教程覆盖了所有关键步骤，跟着做就能把 UBI8 用起来——新手先练熟“快速部署”和“挂载目录”，高级工程师可以重点研究 Compose 配置和镜像二次打包，按需进阶就行。


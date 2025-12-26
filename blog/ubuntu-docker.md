# Ubuntu Docker 容器化部署教程

![Ubuntu Docker 容器化部署教程](https://img.xuanyuan.dev/docker/blog/docker-ubuntu.png)

*分类: Docker,Ubuntu | 标签: ubuntu,docker,部署教程 | 发布时间: 2025-10-10 02:33:47*

> 无论是开发测试环境搭建、企业服务部署，还是容器化项目落地，Ubuntu 都能提供“快速、安全、简单”的基础环境支撑。

## 关于 Ubuntu：从桌面到云端的全能 Linux 系统
根据 Ubuntu 官方定义，Ubuntu 是一款基于 Debian 的开源 Linux 操作系统，其应用范围覆盖**个人桌面、企业级服务器、公有云/私有云（如 OpenStack）、物联网设备**，是当前全球最流行的 Linux 发行版之一。

它的核心价值与用途可概括为以下几点：
1. **容器与云原生的首选平台**：Ubuntu 是容器技术的“黄金搭档”——从 Docker 到 Kubernetes（K8s）再到 LXD，它能高效支撑容器的部署、扩展与管理，也是公有云上（如 AWS、Azure、阿里云）使用量最高的操作系统，支持大规模容器集群运行；
2. **全场景适用性**：个人用户可用于日常办公、开发（兼容 Java、Python、Go 等主流开发语言）；企业用户可搭建 Web 服务、数据库集群、大数据平台（Hadoop/Spark）；物联网场景下可适配嵌入式设备（如树莓派）；
3. **稳定与安全兼顾**：由 Canonical 公司维护，提供长期支持（LTS）版本（如 22.04 LTS 支持 5 年，24.04 LTS 支持至 2030 年），定期推送安全更新，避免系统漏洞风险；
4. **开源与生态丰富**：遵循开源协议，用户可自由修改、分发代码；官方及社区提供海量软件包（通过 `apt` 命令一键安装），配套文档与技术社区（如 Stack Overflow、Ubuntu Forums）完善，问题解决成本低。

简单来说：无论是开发测试环境搭建、企业服务部署，还是容器化项目落地，Ubuntu 都能提供“快速、安全、简单”的基础环境支撑。


## 准备工作：安装 Docker 与 Docker Compose
若你的 Linux 系统尚未安装 Docker，直接使用以下**一键安装脚本**（推荐方案）——该脚本支持 CentOS、Ubuntu、Debian 等主流发行版，可自动安装 Docker、Docker Compose，并配置轩辕镜像访问支持源（解决国内拉取镜像慢的问题）。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本执行完成后，可通过以下命令验证 Docker 是否安装成功：
```bash
docker --version  # 查看 Docker 版本
docker compose version  # 查看 Docker Compose 版本
```
若输出类似 `Docker version 27.0.3, build 7d4bcd8` 的信息，说明安装成功。


## Ubuntu 镜像：镜像介绍与拉取
我们将基于**轩辕镜像仓库**（`https://xuanyuan.cloud/r/library/ubuntu`）拉取 Ubuntu 镜像，仓库中提供了多个版本的镜像标签（Tags），对应不同 Ubuntu 发行版，核心标签如下：
我们提供
| 镜像标签                | 对应 Ubuntu 版本 | 说明                          |
|-------------------------|------------------|-------------------------------|
| `22.04`, `jammy`        | 22.04 LTS        | 长期支持版（推荐生产环境）    |
| `24.04`, `noble`, `latest` | 24.04 LTS    | 最新长期支持版（默认首选）    |
| `25.04`, `plucky`       | 25.04            | 短期版本（更新快，支持 9 个月）|
| `25.10`, `questing`, `rolling` | 25.10    | 滚动更新版（最新版本，适合测试）|

下面提供 4 种拉取方式，可根据你的网络环境和权限选择。


### 3.1 方式一：轩辕镜像登录验证拉取
若已配置轩辕镜像仓库登录信息，可直接通过验证地址拉取（适合企业用户，镜像拉取更稳定）：
```bash
# 拉取最新 LTS 版（24.04，对应标签 latest）
docker pull docker.xuanyuan.run/library/ubuntu:latest

# 若需指定版本（如 22.04 LTS），替换标签即可
docker pull docker.xuanyuan.run/library/ubuntu:22.04
```


### 3.2 方式二：拉取后重命名（简化后续命令）
若觉得镜像名过长，可拉取后重命名为官方标准格式（`library/ubuntu:版本`），方便后续启动容器时使用：
```bash
# 1. 拉取轩辕镜像
docker pull docker.xuanyuan.run/library/ubuntu:24.04

# 2. 重命名为官方格式
docker tag docker.xuanyuan.run/library/ubuntu:24.04 library/ubuntu:24.04

# 3. 删除临时镜像标签（避免占用额外存储空间）
docker rmi docker.xuanyuan.run/library/ubuntu:24.04
```


### 3.3 方式三：免登录拉取（推荐初学者）
无需配置登录信息，直接通过免登录地址拉取，镜像内容与登录方式完全一致，操作更简单：
```bash
# 基础拉取命令（拉取 24.04 LTS 版）
docker pull xxx.xuanyuan.run/library/ubuntu:24.04

# 带重命名的完整命令（一步到位）
docker pull xxx.xuanyuan.run/library/ubuntu:24.04 \
&& docker tag xxx.xuanyuan.run/library/ubuntu:24.04 library/ubuntu:24.04 \
&& docker rmi xxx.xuanyuan.run/library/ubuntu:24.04
```


### 3.4 方式四：官方直连拉取（适合海外网络）
若你的服务器可直连 Docker Hub，或已通过轩辕镜像访问支持器配置了全局加速，可直接拉取官方镜像：
```bash
# 拉取最新 LTS 版
docker pull library/ubuntu:latest

# 拉取指定版本（如 22.04 LTS）
docker pull library/ubuntu:22.04
```


### 3.5 验证镜像是否拉取成功
执行以下命令查看本地镜像列表：
```bash
docker images
```
若输出类似以下内容，说明镜像拉取成功：
```
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
library/ubuntu      24.04     08d22c0ceb1d   1 week ago     77.8MB
library/ubuntu      latest    08d22c0ceb1d   1 week ago     77.8MB
```


## Ubuntu 容器部署：三种场景方案
下面介绍「快速测试」「持久化挂载」「企业级 docker-compose」三种部署方案，覆盖从初学者测试到生产环境使用的全场景。


### 4.1 方案一：快速部署（适合测试/临时使用）
该方案无需复杂配置，一键启动 Ubuntu 容器，适合快速验证环境或临时执行命令。

#### 操作命令：
```bash
# 启动 Ubuntu 容器，命名为 ubuntu-test（便于后续管理）
# -d：后台运行容器；-it：分配交互式终端（确保容器不退出）
docker run -d -it --name ubuntu-test library/ubuntu:24.04
```

#### 核心参数解释：
- `-d`：让容器在后台运行，避免占用当前终端；
- `-it`：`-i`（交互式）+ `-t`（分配伪终端），确保容器能保持运行（Ubuntu 镜像默认无前台进程，不加 `-it` 会启动后立即退出）；
- `--name ubuntu-test`：给容器指定名称，后续停止、我们提供重启时直接用名称，无需记容器 ID。

#### 进入容器操作：
启动后，可通过以下命令进入容器内部，执行 Linux 命令（如安装软件、查看系统信息）：
```bash
# 进入 ubuntu-test 容器的 bash 终端
docker exec -it ubuntu-test bash

# 进入后可执行以下命令测试：
cat /etc/os-release  # 查看 Ubuntu 版本信息
apt update           # 更新软件源（首次执行需几分钟）
apt install -y curl  # 安装 curl 工具
curl --version       # 验证 curl 是否安装成功
```

#### 停止/删除容器：
```bash
# 停止容器
docker stop ubuntu-test

# 删除容器（需先停止，或加 -f 强制删除运行中的容器）
docker rm ubuntu-test
```


### 4.2 方案二：挂载目录（持久化部署，适合实际项目）
快速部署的容器一旦删除，内部数据（如安装的软件、创建的文件）会丢失。通过**宿主机目录挂载**，可实现「数据持久化」「配置独立管理」，适合需要长期使用的场景（如在容器内搭建服务）。

#### 核心思路：
在宿主机创建目录，将其挂载到容器内的指定路径，容器内对该路径的操作会同步到宿主机，即使容器删除，宿主机目录的数据也不会丢失。

#### 步骤 1：创建宿主机挂载目录
我们在宿主机的 `/data/ubuntu` 下创建 3 个目录，分别用于存储数据、配置文件、日志：
```bash
# 一次性创建 3 个目录（-p 确保父目录存在）
mkdir -p /data/ubuntu/{data,config,logs}
```

#### 步骤 2：启动容器并挂载目录
```bash
# 启动容器，命名为 ubuntu-prod（生产环境用名称）
docker run -d -it --name ubuntu-prod \
  -v /data/ubuntu/data:/root/data \    # 宿主机数据目录 → 容器内 /root/data
  -v /data/ubuntu/config:/etc/config \ # 宿主机配置目录 → 容器内 /etc/config
  -v /data/ubuntu/logs:/var/log \      # 宿主机日志目录 → 容器内 /var/log
  library/ubuntu:24.04
```

#### 目录挂载说明：
| 宿主机目录          | 容器内目录        | 用途说明                          |
|---------------------|-------------------|-----------------------------------|
| `/data/ubuntu/data` | `/root/data`      | 存储容器内的业务数据（如脚本、文件）|
| `/data/ubuntu/config` | `/etc/config`   | 存储容器内服务的配置文件（如 nginx.conf）|
| `/data/ubuntu/logs` | `/var/log`        | 存储容器内的系统日志、应用日志    |

#### 验证持久化效果：
```bash
# 1. 进入容器，在挂载目录创建文件
docker exec -it ubuntu-prod bash
echo "Ubuntu container data" > /root/data/test.txt  # 在容器内创建文件
exit  # 退出容器

# 2. 在宿主机查看文件是否同步
cat /data/ubuntu/data/test.txt
```
若输出 `Ubuntu container data`，说明挂载成功，数据已同步到宿主机。


### 4.3 方案三：docker-compose 部署（企业级场景）
对于需要长期维护、多容器协同（如 Ubuntu 容器 + Nginx 容器 + MySQL 容器）的场景，使用 `docker-compose` 可通过配置文件统一管理容器，实现「一键启动/停止/重启」，简化运维操作。

#### 步骤 1：创建 docker-compose 配置文件
在宿主机创建一个目录（如 `/opt/ubuntu-compose`），并在该目录下创建 `docker-compose.yml` 文件：
```bash
# 创建目录并进入
mkdir -p /opt/ubuntu-compose && cd /opt/ubuntu-compose

# 创建 docker-compose.yml 文件（用 nano 编辑器，新手友好）
nano docker-compose.yml
```

将以下内容粘贴到文件中（按 `Ctrl+O` 保存，`Ctrl+X` 退出 nano）：
```yaml
version: '3.8'  # 指定 docker-compose 语法版本（兼容主流 Docker 版本）
services:
  ubuntu-service:  # 服务名称（自定义）
    image: library/ubuntu:24.04  # 使用的 Ubuntu 镜像
    container_name: ubuntu-compose  # 容器名称
    tty: true  # 保持终端连接（替代 -t 参数，确保容器不退出）
    volumes:  # 挂载目录配置
      - ./data:/root/data  # 宿主机 ./data（与 yml 同目录）→ 容器 /root/data
      - ./config:/etc/config
      - ./logs:/var/log
    environment:  # 环境变量配置（示例：设置时区）
      - TZ=Asia/Shanghai
    restart: always  # 容器退出后自动重启（保障服务可用性，生产环境必加）
    # 可选：暴露端口（若容器内搭建服务，如 SSH，需映射端口）
    # ports:
    #   - "2222:22"  # 宿主机 2222 端口 → 容器 22 端口（SSH 默认端口）
```

#### 步骤 2：启动服务
在 `docker-compose.yml` 所在目录（`/opt/ubuntu-compose`）执行以下命令：
```bash
# 后台启动服务（-d 表示后台运行）
docker compose up -d

# 首次启动会自动创建 ./data、./config、./logs 目录（无需手动创建）
```

#### 常用 docker-compose 命令：
```bash
# 查看服务状态
docker compose ps

# 进入容器（服务名称为 ubuntu-service，对应配置文件中的 services 下的名称）
docker compose exec ubuntu-service bash

# 查看容器日志（实时输出，按 Ctrl+C 退出）
docker compose logs -f ubuntu-service

# 停止服务（容器不删除）
docker compose stop

# 停止并删除服务（容器、网络会删除，挂载目录数据保留）
docker compose down

# 重启服务
docker compose restart
```


## 部署结果验证
无论使用哪种方案，都可通过以下方式验证 Ubuntu 容器是否正常运行：

### 1. 查看容器状态
```bash
# 查看所有运行中的容器
docker ps

# 查看指定容器（如 ubuntu-prod）状态
docker inspect -f '{{.State.Status}}' ubuntu-prod
```
若输出 `running`，说明容器正常运行。

### 2. 验证系统信息
进入容器后，执行以下命令确认系统版本：
```bash
# 进入容器
docker exec -it 容器名 bash

# 查看 Ubuntu 版本
lsb_release -a  # 或 cat /etc/os-release
```
输出应包含 `Release: 24.04`（或你选择的版本），说明容器内系统正常。

### 3. 验证持久化（仅方案二、三）
在宿主机挂载目录创建文件，进入容器查看是否同步，或反之，确保数据不会因容器重启/重建丢失。


## 常见问题与解决方案
### 6.1 容器启动后立即退出？
**原因**：Ubuntu 镜像默认无前台进程，若启动时未加 `-it`（方案一）或 `tty: true`（方案三），容器会因无运行进程而退出。  
**解决**：启动命令中添加 `-it` 参数（如方案一），或在 docker-compose 中添加 `tty: true`（如方案三）。

### 6.2 容器内 `apt update` 访问表现慢？
**原因**：默认软件源是 Ubuntu 官方源（海外地址），国内访问慢。  
**解决**：替换为国内源（如阿里云源），步骤如下：
```bash
# 进入容器
docker exec -it 容器名 bash

# 备份默认源文件
mv /etc/apt/sources.list /etc/apt/sources.list.bak

# 写入阿里云源（以 24.04 LTS 为例，版本代号 noble）
cat > /etc/apt/sources.list << EOF
deb http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse
EOF

# 重新更新源
apt update
```

### 6.3 挂载目录权限不足？
**原因**：宿主机目录权限过低，容器内用户（默认 root）无法读写。  
**解决**：临时测试可放宽宿主机目录权限（生产环境需按需配置更严格权限）：
```bash
# 给宿主机挂载目录赋予读写权限
chmod -R 755 /data/ubuntu  # 或 777（测试用，不推荐生产）
```

### 6.4 容器内时区与宿主机不一致？
**原因**：Docker 容器默认使用 UTC 时区，与国内（Asia/Shanghai）时差 8 小时。  
**解决**：启动时通过环境变量或挂载时区文件设置：
```bash
# 方式 1：通过 -e 参数设置时区（方案一/二）
docker run -d -it --name ubuntu-test -e TZ=Asia/Shanghai library/ubuntu:24.04

# 方式 2：挂载宿主机时区文件（更彻底，方案一/二）
docker run -d -it --name ubuntu-test \
  -v /etc/timezone:/etc/timezone:ro \
  -v /etc/localtime:/etc/localtime:ro \
  library/ubuntu:24.04

# 方式 3：docker-compose 中设置环境变量（方案三）
# 在 environment 中添加 - TZ=Asia/Shanghai（参考方案三配置）
```

### 6.5 如何在 Ubuntu 容器内安装 SSH 服务？
**场景**：需要通过 SSH 远程连接容器（如远程调试）。  
**步骤**：
```bash
# 1. 进入容器
docker exec -it ubuntu-prod bash

# 2. 安装 openssh-server
apt update && apt install -y openssh-server

# 3. 配置 SSH（允许 root 登录，仅测试用，生产需创建普通用户）
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 4. 设置 root 密码
passwd root  # 按提示输入密码（如 123456，测试用）

# 5. 启动 SSH 服务
service ssh start

# 6. 退出容器，重启容器（确保 SSH 服务开机启动，可选）
exit
docker restart ubuntu-prod

# 7. 宿主机测试连接（假设容器映射端口 2222）
ssh root@localhost -p 2222  # 输入密码即可登录
```


## 总结
本教程从 Ubuntu 系统介绍到 Docker 部署全流程，覆盖了「测试→实际项目→企业级」三种场景，无论是初学者还是高级工程师，都能找到适合自己的操作方案：
- 初学者：先从「快速部署」熟悉容器操作，再尝试「挂载目录」理解持久化；
- 高级工程师：可基于「docker-compose」扩展多容器协同，结合权限配置、时区同步、SSH 远程等需求优化部署方案。

若在实践中遇到问题，优先通过 `docker logs 容器名` 查看日志定位原因，或参考 Ubuntu 官方文档（[ubuntu.com](https://ubuntu.com/)）、Docker 官方文档补充学习。随着使用深入，你还可以在 Ubuntu 容器内搭建 Web 服务、数据库、开发环境等，充分发挥 Ubuntu 与 Docker 的协同优势。


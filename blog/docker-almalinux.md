# Docker 部署 AlmaLinux 全流程教程

![Docker 部署 AlmaLinux 全流程教程](https://img.xuanyuan.dev/docker/blog/docker-almalinux.png)

*分类: Docker,AlmaLinux  | 标签: almalinux,docker,部署教程 | 发布时间: 2025-10-26 06:27:05*

> AlmaLinux 作为 RHEL 二进制兼容的免费企业级发行版，由 CloudLinux 团队发起、基金会维护，不仅解决了 CentOS 停更后的替代需求，更以“永久免费+10年长期支持”成为企业服务器部署的优选。而通过 Docker 部署，能彻底规避传统装机“环境不一致、迁移难、版本管理乱”的痛点，尤其适合遗留 CentOS 系统迁移、微服务基础设施搭建等场景。

AlmaLinux 作为 RHEL 二进制兼容的免费企业级发行版，由 CloudLinux 团队发起、基金会维护，不仅解决了 CentOS 停更后的替代需求，更以“永久免费+10年长期支持”成为企业服务器部署的优选。而通过 Docker 部署，能彻底规避传统装机“环境不一致、迁移难、版本管理乱”的痛点，尤其适合遗留 CentOS 系统迁移、微服务基础设施搭建等场景。下面结合轩辕镜像平台特性，带大家从环境准备到部署验证一步步落地。


## 关于 AlmaLinux
### 1. AlmaLinux 核心价值
作为企业级发行版的“后起之秀”，其竞争力集中在三个关键维度：
- **兼容性无短板**：与 RHEL 二进制 1:1 兼容，原 CentOS、RHEL 上的应用（如 Nginx、MySQL、Java 服务）可直接迁移，无需修改配置或依赖，省去“重编译、调参数”的麻烦
- **长期稳定保障**：每个版本提供 10 年安全更新（比如 AlmaLinux 8 支持到 2029 年，9 支持到 2032 年），比普通发行版多 5-7 年支持周期，适合关键业务长期运行
- **轻量与灵活兼顾**：提供“默认镜像”（含完整 DNF 工具链）和“Minimal 镜像”（仅含 microdnf，体积缩小 40%），可根据场景选择，比如微服务用 Minimal 版节省资源，传统服务用默认版方便运维

### 2. Docker 部署 AlmaLinux 核心优势
对比传统“光盘装机+手动配环境”，Docker 方式更贴合现代运维节奏：
- **环境绝对一致**：镜像已打包所有依赖（系统库、包管理器、基础工具），开发机、测试机、生产服务器跑的都是同一个环境，再也不会出现“本地能跑、线上报错”
- **资源占用极低**：容器是进程级隔离，比虚拟机省 80% 内存——AlmaLinux  默认镜像仅 200MB 左右，Minimal 版仅 120MB，启动耗时 2-3 秒，适合高密度部署
- **版本管理灵活**：可同时跑 AlmaLinux 8 和 9 容器，分别部署依赖不同系统版本的应用（比如老项目用 8，新项目用 9），互不干扰
- **迁移成本为零**：通过 `docker save` 导出镜像，拷贝到新服务器 `docker load` 就能用，3 分钟完成跨机器迁移，比传统“重装系统+装软件”快 10 倍以上
- **运维门槛低**：用 `docker` 命令就能启停、日志查看、备份，新手学 10 分钟就能上手，不用记复杂的 Linux 装机命令


## 🧰 准备工作
部署前需确保系统已安装 Docker 环境，未安装的用户可通过轩辕镜像提供的脚本一键配置：

### Linux Docker & Docker Compose 一键安装
脚本支持 CentOS、Ubuntu、Debian 等主流发行版，自动配置镜像访问支持源，避免拉取镜像慢的问题：
```bash
# 一键安装 Docker + Docker Compose，全程无需手动干预
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### 验证安装结果
执行以下命令，若输出 Docker 和 Docker Compose 版本信息，说明安装成功：
```bash
docker --version && docker compose --version
```
示例输出（版本号可能不同，正常）：
```
Docker version 27.0.3, build 7d4bcd8
Docker Compose version v2.20.2
```


## 1. 查看并拉取 AlmaLinux 镜像
AlmaLinux 镜像已同步至轩辕镜像平台，支持“默认版”“Minimal 版”及多版本标签，可根据需求选择：

### 1.1 镜像信息查询
先访问轩辕镜像的 AlmaLinux 详情页，查看标签、更新记录、架构支持等信息：
👉 [轩辕镜像 AlmaLinux 页面](https://xuanyuan.cloud/r/library/almalinux)

关键提示：
- `almalinux:latest` 始终指向最新稳定版（当前是 9.6），适合大多数场景
- 需精简环境选 `almalinux:minimal`（或对应版本，如 `almalinux:9-minimal`）
- 老项目兼容选 8 系列标签（如 `almalinux:8`），新项目优先用 9 系列

### 1.2 多种拉取方式（按需选择）
#### 方式 1：轩辕镜像免登录拉取（推荐新手）
无需注册账户，直接拉取最新稳定版（默认镜像）：
```bash
# 拉取最新版默认镜像（等价于 almalinux:9.6）
docker pull xxx.xuanyuan.run/library/almalinux:latest

# 若需 Minimal 精简版，拉取这个标签
docker pull xxx.xuanyuan.run/library/almalinux:minimal
```

#### 方式 2：轩辕镜像登录拉取（企业用户）
已注册轩辕镜像平台的用户，可通过登录获取更稳定的拉取体验：
```bash
# 登录轩辕镜像（首次登录需输入用户名+密码）
docker login docker.xuanyuan.run

# 拉取 AlmaLinux 8 版本（适配老项目）
docker pull docker.xuanyuan.run/library/almalinux:8

# 拉取 8 系列 Minimal 版
docker pull docker.xuanyuan.run/library/almalinux:8-minimal
```

#### 方式 3：官方 Docker Hub 拉取（多架构需求）
若需要 arm64v8、ppc64le 等非 amd64 架构镜像，可直接从官方仓库拉取：
```bash
# 官方仓库拉取最新版默认镜像
docker pull almalinux:latest

# 拉取 arm64v8 架构的 9 版本
docker pull arm64v8/almalinux:9
```

#### 方式 4：拉取后重命名（简化后续命令）
若拉取地址较长，可重命名为简洁标签，方便后续使用：
```bash
# 将轩辕镜像拉取的镜像重命名为 almalinux:latest
docker tag xxx.xuanyuan.run/library/almalinux:latest almalinux:latest

# 删除原标签（可选，避免占用额外标签空间）
docker rmi xxx.xuanyuan.run/library/almalinux:latest
```

### 1.3 验证拉取结果
执行以下命令，若能看到 AlmaLinux 镜像信息，说明拉取成功：
```bash
docker images | grep almalinux
```
示例输出：
```
REPOSITORY          TAG           IMAGE ID       CREATED        SIZE
almalinux           latest        a1b2c3d4e5f6   1 week ago     202MB
almalinux           minimal       b2c3d4e5f6a1   1 week ago     125MB
```


## 2. 部署 AlmaLinux 实战（三种方案）
结合“测试验证”“生产使用”“企业批量管理”三种场景，提供对应的部署方案，均基于 AlmaLinux 9（最新稳定版）演示。

### 2.1 快速部署（最简测试场景）
适合临时验证环境、学习 Linux 命令、测试依赖兼容性等场景，一键启动交互式容器：
```bash
# 启动容器并进入命令行，命名为 alma-test
docker run -it --name alma-test almalinux:latest /bin/bash
```

#### 核心参数说明
- `-it`：交互式运行（保持终端连接，能直接输入命令）
- `--name alma-test`：给容器起固定名称，后续停止、重启更方便
- `/bin/bash`：启动后默认进入 Bash 命令行（AlmaLinux 默认 Shell）

#### 基础操作演示
进入容器后，可执行以下命令熟悉环境：
```bash
# 查看系统版本（确认是 AlmaLinux 9）
cat /etc/almalinux-release

# 安装基础工具（测试 DNF 包管理器）
dnf install -y wget vim net-tools

# 查看 IP 地址（验证网络正常）
ip addr

# 退出容器：临时退出（容器继续运行）按 Ctrl+P+Q；完全退出（停止容器）输入 exit
```

### 2.2 挂载目录部署（推荐生产场景）
通过宿主机目录挂载，实现“数据持久化、配置独立管理、日志分离”——即使容器删除，数据也不会丢失，适合生产环境使用。

#### 第一步：创建宿主机挂载目录
根据实际需求创建“数据目录”“配置目录”“日志目录”（路径可自定义，这里用 `/data/alma` 为例）：
```bash
# 一次性创建三个核心目录
mkdir -p /data/alma/{data,conf,logs}

# 给目录授权（避免容器内用户无读写权限，生产环境可按需调整权限）
chmod -R 777 /data/alma
```

#### 第二步：启动容器并挂载目录
```bash
docker run -d --name alma-prod \
  -p 2222:22 \  # 映射 SSH 端口（如需远程连接容器内服务）
  -p 8080:80 \  # 映射 HTTP 端口（后续部署 Nginx、Tomcat 等服务用）
  -v /data/alma/data:/var/data \  # 数据目录挂载（存业务数据）
  -v /data/alma/conf:/etc/custom \  # 配置目录挂载（存自定义配置）
  -v /data/alma/logs:/var/log/custom \  # 日志目录挂载（存应用日志）
  -e TZ=Asia/Shanghai \  # 设置时区（解决容器默认 UTC 时区问题）
  almalinux:latest \
  # 后台运行命令（确保容器不退出，这里以启动 crond 定时任务为例）
  /bin/bash -c "dnf install -y crontabs && crond -n"
```

#### 目录映射说明
| 宿主机目录          | 容器内目录        | 核心用途                  |
|---------------------|-------------------|---------------------------|
| `/data/alma/data`  | `/var/data`       | 存放业务数据（如数据库文件、应用配置文件）|
| `/data/alma/conf`  | `/etc/custom`     | 存放自定义配置（如服务启动脚本、环境变量）|
| `/data/alma/logs`  | `/var/log/custom` | 存放应用日志（如服务运行日志、错误日志）|

#### 进入运行中的容器
部署后如需操作容器（如安装软件、修改配置），执行以下命令：
```bash
# 进入已启动的 alma-prod 容器
docker exec -it alma-prod /bin/bash
```

### 2.3 Docker Compose 部署（企业级批量管理）
适合多服务组合场景（如 AlmaLinux + Nginx + MySQL + Redis），通过 `docker-compose.yml` 配置文件统一管理，支持一键启停、批量部署，运维效率更高。

#### 第一步：创建 docker-compose.yml 配置文件
在 `/data/alma-compose` 目录下创建配置文件（路径可自定义）：
```yaml
version: '3.8'  # 适配 Docker Compose 新版本特性
services:
  alma:
    image: almalinux:latest  # 使用的 AlmaLinux 镜像
    container_name: alma-service  # 容器名称（固定，方便管理）
    ports:
      - "2222:22"  # SSH 端口映射
      - "8080:80"  # HTTP 端口映射
    volumes:
      - ./data:/var/data  # 数据目录（相对路径，与 yml 文件同目录）
      - ./conf:/etc/custom  # 配置目录
      - ./logs:/var/log/custom  # 日志目录
    environment:
      - TZ=Asia/Shanghai  # 时区配置（上海时区）
      - LANG=en_US.UTF-8  # 字符集配置（避免中文乱码）
    restart: always  # 容器故障自动重启（保障服务高可用）
    command: /bin/bash -c "dnf install -y openssh-server && /usr/sbin/sshd -D"  # 启动 SSH 服务
```

#### 第二步：创建配套目录并启动服务
```bash
# 1. 创建与配置文件对应的目录（data、conf、logs）
mkdir -p /data/alma-compose/{data,conf,logs}
cd /data/alma-compose  # 进入配置文件所在目录

# 2. 启动服务（后台运行，-d 表示 detached 模式）
docker compose up -d

# 3. 常用管理命令（按需使用）
docker compose ps  # 查看服务状态（是否正常运行）
docker compose stop  # 停止服务（容器保留）
docker compose down  # 停止并删除容器（数据在挂载目录，不会丢失）
docker compose logs -f  # 实时查看容器日志（排查问题用）
docker compose restart  # 重启服务
```


## 3. 部署结果验证
通过以下三步，确认 AlmaLinux 容器正常运行且功能可用：

### 3.1 基础状态验证
```bash
# 查看容器是否在运行（STATUS 列显示 Up 即为正常）
docker ps | grep alma

# 查看容器资源占用（确认 CPU、内存使用正常，无异常占用）
docker stats alma-prod  # 按 Ctrl+C 退出统计
```

### 3.2 环境功能验证
```bash
# 1. 进入容器（以 alma-prod 为例）
docker exec -it alma-prod /bin/bash

# 2. 验证包管理器（安装 Nginx 测试，Minimal 版需用 microdnf）
dnf install -y nginx  # 默认版用 dnf；Minimal 版替换为 microdnf install -y nginx
systemctl start nginx  # 启动 Nginx

# 3. 验证挂载目录（在容器内创建文件，宿主机查看是否同步）
echo "AlmaLinux production data" > /var/data/test.txt
exit  # 退出容器

# 4. 宿主机查看文件（确认挂载生效，能看到容器内创建的文件）
cat /data/alma/data/test.txt
```

### 3.3 服务访问验证
若部署时映射了 80 端口且启动了 Nginx，可通过浏览器或 `curl` 验证服务是否可访问：
```bash
# 宿主机本地访问容器内 Nginx
curl http://127.0.0.1:8080

# 远程访问（需开放服务器安全组 8080 端口）
curl http://服务器公网IP:8080
```
若输出 Nginx 欢迎页内容（或自定义页面），说明服务部署成功。


## 4. 常见问题排查
### 4.1 拉取镜像时提示“标签不存在”
**原因**：输入的标签错误（如 `almalinux:10` 尚未发布，或 `almalinux:9.7` 未同步）。  
**解决方案**：参考轩辕镜像页面的“支持标签列表”，用正确标签拉取，比如：
```bash
# 拉取已支持的 9.6 版本
docker pull xxx.xuanyuan.run/library/almalinux:9.6
```

### 4.2 Minimal 版无法使用 dnf 命令
**原因**：Minimal 镜像是精简版，默认只装了 `microdnf`（轻量包管理器），没装完整 `dnf`。  
**解决方案**：直接用 `microdnf` 或手动安装 `dnf`：
```bash
# 方案 1：用 microdnf 安装软件
microdnf install -y vim

# 方案 2：安装完整 dnf（适合长期使用 Minimal 版）
microdnf install -y dnf
```

### 4.3 容器内时区显示错误（与本地差 8 小时）
**原因**：容器默认用 UTC 时区，未配置本地时区。  
**解决方案**：
- 启动时加 `-e TZ=Asia/Shanghai`（推荐，永久生效）
- 已启动容器临时修改（重启后失效）：
  ```bash
  docker exec -it alma-prod /bin/bash
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  date  # 验证时区是否正确
  ```

### 4.4 挂载目录后“权限被拒绝”
**原因**：宿主机目录权限不足，容器内用户（默认 root，部分场景是普通用户）无读写权限。  
**解决方案**：
```bash
# 1. 宿主机给目录授权（生产环境可按实际用户组调整，这里用 777 方便测试）
chmod -R 777 /data/alma

# 2. 或启动时指定 root 用户（确保权限足够）
docker run -d -u root --name alma-prod -v /data/alma:/var/data almalinux:latest
```

### 4.5 dnf 安装软件访问表现慢
**原因**：默认用官方源，国内访问访问表现慢。  
**解决方案**：替换为国内镜像源（以阿里云为例）：
```bash
# 进入容器后执行
echo -e "[base]\nname=AlmaLinux \$releasever - Base - mirrors.aliyun.com\nbaseurl=http://mirrors.aliyun.com/almalinux/\$releasever/BaseOS/\$basearch/os/\ngpgcheck=1\ngpgkey=http://mirrors.aliyun.com/almalinux/RPM-GPG-KEY-AlmaLinux" > /etc/yum.repos.d/base.repo
dnf clean all && dnf makecache  # 清理缓存并生成新缓存
```


## 结尾
至此，你已掌握 AlmaLinux 的 Docker 部署全流程——从镜像拉取的多种方案，到适配不同场景的部署实战，再到问题排查的具体方法，每个步骤都贴合实际运维需求。

对于新手，建议先从“快速部署”熟悉 AlmaLinux 环境，再尝试“挂载目录”方案理解持久化的重要性；企业用户推荐用“Docker Compose 部署”，配合轩辕镜像访问支持，可支撑生产级服务的稳定运行。


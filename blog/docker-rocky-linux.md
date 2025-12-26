# Docker 部署 Rocky Linux 全流程教程

![Docker 部署 Rocky Linux 全流程教程](https://img.xuanyuan.dev/docker/blog/docker-rocky-linux.png)

*分类: Docker,Rocky Linux | 标签: rocky-linux,docker,部署教程 | 发布时间: 2025-10-26 06:20:35*

> Rocky Linux 作为 CentOS 停更后的最优替代方案，与 RHEL 完全兼容且提供 10 年长期支持，是企业级服务器部署的首选。而通过 Docker 部署，能彻底解决传统部署中“环境不一致、迁移繁琐、版本管理混乱”等痛点，尤其适合遗留 CentOS 系统迁移、企业级服务搭建等场景。

Rocky Linux 作为 CentOS 停更后的最优替代方案，与 RHEL 完全兼容且提供 10 年长期支持，是企业级服务器部署的首选。而通过 Docker 部署，能彻底解决传统部署中“环境不一致、迁移繁琐、版本管理混乱”等痛点，尤其适合遗留 CentOS 系统迁移、企业级服务搭建等场景。下面结合轩辕镜像平台特性，带大家完成从环境准备到部署验证的全流程。

## 关于 Rocky Linux
### 1.  Rocky Linux 核心价值
作为 CentOS 创始人发起的社区发行版，其核心竞争力集中在三点：
- **兼容性拉满**：基于 RHEL 源代码构建，移除品牌标识后与 RHEL 功能 1:1 匹配，原 CentOS 上的应用可无缝迁移，无需修改配置
- **长期稳定支持**：每个版本提供 10 年安全更新，比如 Rocky Linux 8 支持到 2029 年，9 支持到 2032 年，远超普通发行版
- **多架构适配**：原生支持 amd64、arm64v8、ppc64le、s390x 等架构，覆盖物理机、云服务器、嵌入式设备等全场景

### 2.  Docker 部署 Rocky Linux 核心优势
对比传统的光盘安装或 ISO 部署，Docker 方式的优势更贴合现代运维需求：
- **环境一致性**：镜像已打包完整依赖，从开发机到生产服务器，只要能运行 Docker 就能“开箱即用”，避免“本地跑通、线上报错”
- **轻量高效**：容器仅占用进程级资源，比虚拟机节省 80% 以上内存，Rocky Linux 基础镜像仅 200MB 左右，启动耗时不超过 3 秒
- **版本隔离**：可同时运行 Rocky Linux 8 和 9 两个版本容器，分别部署不同版本依赖的应用，互不干扰
- **快速迁移**：通过镜像导出/导入，3 分钟即可完成跨服务器迁移，比传统“重装系统+配置环境”效率提升 10 倍
- **简化管理**：用 Docker 命令即可实现启停、备份、更新，新手也能快速上手，无需掌握复杂的 Linux 装机流程

## 🧰 准备工作
部署前需确保系统已安装 Docker 环境，未安装的用户可按以下步骤操作：

### Linux Docker & Docker Compose 一键安装
推荐使用轩辕镜像提供的一键安装脚本，支持 CentOS、Ubuntu、Debian 等主流发行版，自动配置镜像访问支持源：
```bash
# 一键安装 Docker 及 Docker Compose
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

## 1. 查看并拉取 Rocky Linux 镜像
Rocky Linux 镜像已同步至轩辕镜像平台，支持多版本和精简版，可根据需求选择拉取方式：

### 1.1 镜像信息查询
先访问轩辕镜像平台的 Rocky Linux 详情页，查看标签、更新记录等信息：
👉 [轩辕镜像 Rocky Linux 页面](https://xuanyuan.cloud/r/rockylinux/rockylinux)

关键提示：**无 `latest` 标签**，需指定主版本号（8 或 9），推荐优先选择 9 版本（最新稳定版）；同时提供 `minimal` 精简版（仅含基础依赖，体积更小）。

### 1.2 多种拉取方式（按需选择）
#### 方式 1：轩辕镜像免登录拉取（推荐新手）
无需配置账户，直接拉取最新稳定版（以 9 版本为例）：
```bash
# 拉取 Rocky Linux 9 基础版
docker pull xxx.xuanyuan.run/library/rockylinux:9

# 若需精简版，拉取 minimal 标签
docker pull xxx.xuanyuan.run/library/rockylinux:9-minimal
```

#### 方式 2：轩辕镜像登录拉取（企业用户）
已注册轩辕镜像平台的用户，可通过登录方式拉取：
```bash
# 登录轩辕镜像（首次使用需输入用户名密码）
docker login docker.xuanyuan.run

# 拉取 Rocky Linux 8 版本（适配旧应用）
docker pull docker.xuanyuan.run/library/rockylinux:8
```

#### 方式 3：官方 Docker Hub 拉取（获取最新镜像）
因技术限制，轩辕镜像可能未同步最新镜像，需最新版本可直接从官方仓库拉取：
```bash
# 官方仓库拉取 Rocky Linux 9
docker pull rockylinux/rockylinux:9
```

#### 方式 4：拉取后重命名（简化后续命令）
若拉取地址较长，可重命名为简洁标签：
```bash
# 将轩辕镜像拉取的镜像重命名为 rockylinux:9
docker tag xxx.xuanyuan.run/library/rockylinux:9 rockylinux:9

# 删除原标签（可选，节省空间）
docker rmi xxx.xuanyuan.run/library/rockylinux:9
```

### 1.3 验证拉取结果
执行以下命令，若能看到 Rockylinux 镜像信息，说明拉取成功：
```bash
docker images | grep rockylinux
```
示例输出：
```
REPOSITORY          TAG           IMAGE ID       CREATED        SIZE
rockylinux          9             7f277199191f   2 weeks ago    205MB
rockylinux          9-minimal     8a3f8d44444c   2 weeks ago    110MB
```

## 2. 部署 Rocky Linux 实战
结合不同使用场景，本文提供从“快速测试”到“企业级部署”的完整方案，均基于 Rocky Linux 9 版本演示。

### 2.1 快速部署
适合临时验证环境、学习 Linux 命令等场景，一键启动交互式容器：
```bash
# 启动容器并进入命令行，命名为 rocky-test
docker run -it --name rocky-test rockylinux:9 /bin/bash
```

#### 核心参数说明
- `-it`：交互式运行，保持终端连接（能直接在容器内输入命令）
- `--name rocky-test`：给容器起固定名称，后续管理更方便
- `/bin/bash`：启动后默认进入 Bash 命令行

#### 基础操作演示
进入容器后，可执行以下命令验证环境：
```bash
# 查看系统版本（确认是 Rocky Linux 9）
cat /etc/rocky-release

# 安装基础工具（测试包管理器）
dnf install -y wget vim

# 退出容器（临时退出保留容器：Ctrl+P+Q；完全退出停止容器：exit）
```

### 2.2 挂载目录部署（推荐生产场景）
通过宿主机目录挂载，实现“数据持久化、配置独立管理、日志分离”，避免容器销毁后数据丢失。

#### 第一步：创建宿主机挂载目录
根据实际需求创建数据、配置、日志目录（路径可自定义）：
```bash
# 一次性创建三个核心目录
mkdir -p /data/rocky/{data,conf,logs}

# 给目录授权（避免容器内权限不足）
chmod -R 777 /data/rocky
```

#### 第二步：启动容器并挂载目录
```bash
docker run -d --name rocky-prod \
  -p 2222:22 \  # 映射 SSH 端口（如需远程连接容器）
  -p 8080:80 \  # 映射 HTTP 端口（后续部署服务用）
  -v /data/rocky/data:/var/data \  # 数据目录挂载
  -v /data/rocky/conf:/etc/custom \  # 自定义配置目录挂载
  -v /data/rocky/logs:/var/log/custom \  # 日志目录挂载
  -e TZ=Asia/Shanghai \  # 设置时区（解决容器时区偏差）
  rockylinux:9 \
  # 后台运行命令（确保容器不退出）
  /bin/bash -c "dnf install -y crond && crond -n"
```

#### 目录映射说明
| 宿主机目录          | 容器内目录        | 核心用途                  |
|---------------------|-------------------|---------------------------|
| `/data/rocky/data`  | `/var/data`       | 存放业务数据（如数据库文件）|
| `/data/rocky/conf`  | `/etc/custom`     | 存放自定义配置文件        |
| `/data/rocky/logs`  | `/var/log/custom` | 存放应用日志              |

#### 进入运行中的容器
部署后如需操作容器，执行以下命令：
```bash
# 进入已启动的 rocky-prod 容器
docker exec -it rocky-prod /bin/bash
```

### 2.3 Docker Compose 部署（企业级批量管理）
适合多服务组合场景（如 Rocky Linux + Nginx + MySQL），通过配置文件统一管理，支持一键启停。

#### 第一步：创建 docker-compose.yml 配置文件
在任意目录创建配置文件（推荐放在 `/data/rocky-compose` 目录）：
```yaml
version: '3.8'  # 适配 Docker Compose 新版本
services:
  rocky:
    image: rockylinux:9  # 使用的镜像
    container_name: rocky-service  # 容器名称
    ports:
      - "2222:22"
      - "8080:80"
    volumes:
      - ./data:/var/data
      - ./conf:/etc/custom
      - ./logs:/var/log/custom
    environment:
      - TZ=Asia/Shanghai  # 时区配置
      - LANG=en_US.UTF-8  # 字符集配置
    restart: always  # 容器故障自动重启（保障高可用）
    command: /bin/bash -c "dnf install -y openssh-server && /usr/sbin/sshd -D"  # 启动 SSH 服务
```

#### 第二步：创建配套目录并启动
```bash
# 1. 创建与配置文件对应的目录
mkdir -p /data/rocky-compose/{data,conf,logs}
cd /data/rocky-compose

# 2. 启动服务（后台运行）
docker compose up -d

# 3. 常用管理命令
docker compose ps  # 查看服务状态
docker compose stop  # 停止服务
docker compose down  # 停止并删除容器
docker compose logs -f  # 实时查看日志
```

## 3. 部署结果验证
通过以下方式确认 Rocky Linux 容器正常运行：

### 3.1 基础状态验证
```bash
# 查看容器是否在运行（STATUS 列显示 Up 即为正常）
docker ps | grep rocky

# 查看容器资源占用（确认内存、CPU 使用正常）
docker stats rocky-prod
```

### 3.2 环境功能验证
```bash
# 1. 进入容器
docker exec -it rocky-prod /bin/bash

# 2. 验证包管理器（Rocky Linux 9 默认用 dnf）
dnf update -y  # 更新系统包
dnf install -y nginx  # 安装 Nginx 测试

# 3. 验证挂载目录（在容器内创建文件，宿主机查看是否同步）
echo "test data" > /var/data/test.txt
exit  # 退出容器

# 4. 宿主机查看文件（确认挂载生效）
cat /data/rocky/data/test.txt
```

### 3.3 服务访问验证
若部署时映射了 80 端口并安装了 Nginx，可通过浏览器或 curl 验证：
```bash
# 宿主机访问容器内 Nginx
curl http://127.0.0.1:8080
```
若输出 Nginx 欢迎页内容，说明服务部署成功。

## 4. 常见问题排查
### 4.1 拉取镜像时提示“无 latest 标签”
**原因**：Rocky Linux 官方未提供 latest 标签，需指定具体版本。  
**解决方案**：用 `rockylinux:9` 或 `rockylinux:8` 替代 latest，例如：
```bash
docker pull rockylinux/rockylinux:9
```

### 4.2 精简版（minimal）无法使用 dnf 命令
**原因**：minimal 版本默认只安装 microdnf 轻量包管理器。  
**解决方案**：直接使用 microdnf 或安装 dnf：
```bash
# 用 microdnf 安装软件
microdnf install -y vim

# 或安装完整 dnf（适合长期使用）
microdnf install -y dnf
```

### 4.3 容器内时区显示错误（与本地时差 8 小时）
**解决方案**：启动时添加时区环境变量，或进入容器后手动修改：
```bash
# 启动时指定时区（推荐）
docker run -d -e TZ=Asia/Shanghai --name rocky-test rockylinux:9

# 已启动容器修改时区（临时方案）
docker exec -it rocky-test /bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
date  # 验证时区
```

### 4.4 挂载目录后提示“权限被拒绝”
**原因**：宿主机目录权限不足，容器内用户无读写权限。  
**解决方案**：给宿主机目录授权，或启动时指定 root 用户：
```bash
# 1. 宿主机授权
chmod -R 777 /data/rocky

# 2. 或启动时指定 root 用户
docker run -d -u root --name rocky-prod -v /data/rocky:/var/data rockylinux:9
```

### 4.5 dnf 安装软件时访问表现慢
**解决方案**：替换为国内镜像源（以阿里云为例）：
```bash
# 进入容器后执行
echo -e "[base]\nname=Rocky Linux \$releasever - Base - mirrors.aliyun.com\nbaseurl=http://mirrors.aliyun.com/rocky/\$releasever/BaseOS/\$basearch/os/\ngpgcheck=1\ngpgkey=http://mirrors.aliyun.com/rocky/RPM-GPG-KEY-Rocky-9" > /etc/yum.repos.d/base.repo
dnf clean all && dnf makecache
```

## 结尾
至此，你已掌握 Rocky Linux 的 Docker 部署全流程——从镜像拉取的多种方案，到适配不同场景的部署实战，再到常见问题的解决办法，每个步骤都贴合实际运维需求。

对于新手，建议先从“快速部署”熟悉 Rocky Linux 环境，再尝试“挂载目录”方案理解持久化的重要性；企业用户推荐直接使用“Docker Compose 部署”，配合镜像访问支持和国内源优化，可支撑生产级服务运行。


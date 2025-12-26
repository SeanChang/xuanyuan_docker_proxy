# Docker 部署 openEuler 教程及常见问题解决

![Docker 部署 openEuler 教程及常见问题解决](https://img.xuanyuan.dev/docker/blog/docker-openeuler.png)

*分类: Docker,openEuler | 标签: openeuler,docker,部署教程 | 发布时间: 2025-10-31 06:30:06*

> openEuler 作为华为主导的开源 Linux 发行版，以“多架构适配、云原生友好、长期稳定支持”为核心优势，在企业级服务器、边缘计算、云原生场景中应用广泛。通过 Docker 部署 openEuler，能将其系统优势与容器化的“环境一致、轻量高效、快速迁移”特性深度结合，彻底解决传统部署中“架构适配繁琐、版本管理混乱、跨环境迁移难”的痛点。

openEuler 作为华为主导的开源 Linux 发行版，以“多架构适配、云原生友好、长期稳定支持”为核心优势，在企业级服务器、边缘计算、云原生场景中应用广泛。通过 Docker 部署 openEuler，能将其系统优势与容器化的“环境一致、轻量高效、快速迁移”特性深度结合，彻底解决传统部署中“架构适配繁琐、版本管理混乱、跨环境迁移难”的痛点。下面结合轩辕镜像平台特性，从环境准备到落地验证，带大家走通完整部署流程。


## 关于 openEuler
### 1. openEuler 核心价值
作为开源生态中的重要发行版，openEuler 的竞争力集中在三个关键维度，精准匹配企业级需求：
- **多架构全适配**：原生支持 ARM64、x86-64、loongarch64 等架构，既能运行在普通 x86 服务器，也能完美适配鲲鹏、龙芯等国产 CPU，无需二次编译即可跨架构部署
- **版本体系清晰**：分 LTS 长期支持版（如 24.03-lts、22.03-lts）和创新版（如 25.09、24.09），LTS 版提供 5 年支持，创新版聚焦新功能，可按需选择
- **云原生与开源生态**：深度集成 Kubernetes、Docker 等云原生工具，且兼容 CentOS、RHEL 软件生态，原有 Linux 应用可无缝迁移

### 2. Docker 部署 openEuler 核心优势
对比传统“ISO 装机+手动配环境”，Docker 部署方式更贴合现代运维节奏：
- **架构适配零成本**：镜像已按架构预构建，拉取时自动匹配服务器架构（或手动指定），不用再花时间编译适配，比如鲲鹏服务器直接拉取 ARM64 镜像即可用
- **资源占用极致轻量**：基础镜像仅 150MB 左右，启动耗时 2 秒内，比虚拟机节省 80% 内存，单台服务器可高密度部署数十个容器
- **版本隔离不踩坑**：可同时运行 22.03-lts（稳定生产）和 25.09（创新测试）两个版本容器，分别承载不同业务，互不干扰
- **迁移效率翻倍**：通过 `docker save` 导出镜像，拷贝到新服务器 `docker load` 就能启动，5 分钟完成跨机房迁移，比传统“重装系统+装依赖”快 10 倍
- **运维门槛降低**：用 Docker 命令即可实现启停、日志查看、备份，不用记 openEuler 复杂的系统配置命令，新手也能快速上手


## 🧰 准备工作
部署前需确保服务器已安装 Docker 环境，无论是 x86-64、ARM64 还是 loongarch64 架构均适用，未安装的用户可通过轩辕镜像一键脚本配置：

### Linux Docker & Docker Compose 一键安装
脚本支持 openEuler、CentOS、Ubuntu 等主流发行版，自动配置轩辕镜像访问支持源，避免拉取镜像时访问表现慢：
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


## 1. 查看并拉取 openEuler 镜像
openEuler 镜像已同步至轩辕镜像平台，标签体系清晰（按版本号命名），支持 `latest` 标签（指向最新推荐版），且覆盖多架构，拉取前需明确版本和架构需求。

### 1.1 镜像信息查询
先访问轩辕镜像的 openEuler 详情页，确认所需版本标签、架构支持、更新记录：
👉 [轩辕镜像 openEuler 页面](https://xuanyuan.cloud/r/openeuler/openeuler)

关键标签与版本说明（避免选错版本）：
| 标签类型       | 示例标签                | 特点                                  | 适用场景                          |
|----------------|-------------------------|---------------------------------------|-----------------------------------|
| LTS 长期支持版 | 24.03-lts-sp2、24.03    | 最新 LTS 系列，提供 5 年支持，补丁全  | 生产环境、关键业务                |
| LTS 旧版       | 22.03-lts-sp4、22.03    | 稳定成熟，适配大量遗留软件            | 遗留项目、需要长期稳定的场景      |
| 创新版         | 25.09、24.09            | 含最新功能，更新频率高                | 测试新功能、开发环境              |
| 通用标签       | latest                  | 指向最新推荐版（当前是 24.03-lts-sp2）| 快速部署、不指定版本的场景        |

### 1.2 多种拉取方式（按需选择）
#### 方式 1：默认架构快速拉取（推荐新手）
无需指定架构，Docker 会自动匹配服务器架构，直接拉取最新推荐版：
```bash
# 拉取 latest 标签（最新推荐版，当前为 24.03-lts-sp2）
docker pull xxx.xuanyuan.run/openeuler/openeuler:latest

# 拉取指定 LTS 版（如 24.03-lts-sp2，生产环境推荐）
docker pull xxx.xuanyuan.run/openeuler/openeuler:24.03-lts-sp2

# 拉取创新版（如 25.09，测试新功能用）
docker pull xxx.xuanyuan.run/openeuler/openeuler:25.09
```

#### 方式 2：指定架构拉取
若服务器是特殊架构（如 ARM64 鲲鹏、loongarch64 龙芯），需明确指定架构，避免镜像与硬件不兼容：
```bash
# 拉取 ARM64 架构 24.03-lts-sp2 版（鲲鹏服务器用）
docker pull --platform=linux/arm64 openeuler/openeuler:24.03-lts-sp2

# 拉取 x86-64 架构 24.03-lts-sp2 版（普通 x86 服务器用）
docker pull --platform=linux/amd64 openeuler/openeuler:24.03-lts-sp2

# 拉取 loongarch64 架构 24.03-lts-sp2 版（龙芯服务器用）
docker pull --platform=linux/loongarch64 openeuler/openeuler:24.03-lts-sp2
```

#### 方式 3：轩辕镜像访问支持拉取（国内服务器推荐）
国内服务器直接拉取官方镜像可能较慢，通过轩辕镜像访问支持拉取，访问表现提升 3-5 倍：
```bash
# 轩辕镜像访问支持拉取 latest 版
docker pull xxx.xuanyuan.run/openeuler/openeuler:latest

# 加速拉取 ARM64 架构 22.03-lts-sp4 版
docker pull --platform=linux/arm64 xxx.xuanyuan.run/openeuler/openeuler:22.03-lts-sp4
```

#### 方式 4：拉取后重命名（简化后续命令）
若镜像标签较长或地址复杂，可重命名为简洁标签，方便后续启动容器：
```bash
# 将拉取的 24.03-lts-sp2 版重命名为 openeuler:lts
docker tag openeuler/openeuler:24.03-lts-sp2 openeuler:lts

# 删除原标签（可选，避免标签混乱）
docker rmi openeuler/openeuler:24.03-lts-sp2
```

### 1.3 验证拉取结果
执行以下命令，若能看到 openEuler 镜像信息，说明拉取成功：
```bash
docker images | grep openeuler
```
示例输出（ARM64 架构）：
```
REPOSITORY          TAG           IMAGE ID       CREATED        SIZE
openeuler/openeuler 24.03-lts-sp2  a1b2c3d4e5f6   2 weeks ago    158MB
openeuler           lts           a1b2c3d4e5f6   2 weeks ago    158MB
```


## 2. 部署 openEuler 实战（三种方案）
结合“测试验证”“生产部署”“企业批量管理”三种核心场景，提供对应的部署方案，均以 24.03-lts-sp2 版（生产首选）为例。

### 2.1 快速部署（最简测试场景）
适合临时验证环境、测试软件兼容性、学习 openEuler 命令等场景，一键启动交互式容器：
```bash
# 启动容器并进入命令行，命名为 openeuler-test（指定架构加 --platform）
docker run -it --name openeuler-test openeuler/openeuler:24.03-lts-sp2 /bin/bash
```

#### 核心参数说明
- `-it`：交互式运行（保持终端连接，能直接输入命令）
- `--name openeuler-test`：给容器指定固定名称，后续停止、重启不用记容器 ID
- `/bin/bash`：启动后默认进入 Bash 命令行（openEuler 默认 Shell）
- 特殊架构需加 `--platform=linux/arm64` 等参数，与拉取时一致

#### 基础操作演示
进入容器后，可执行以下命令熟悉 openEuler 特性：
```bash
# 查看系统版本（确认是 24.03-lts-sp2 版）
cat /etc/openEuler-release

# 查看架构信息（确认与服务器架构匹配）
arch

# 安装基础工具（测试 dnf 包管理器）
dnf install -y vim wget net-tools

# 验证云原生工具兼容性（安装 docker 客户端测试）
dnf install -y docker-client
docker --version

# 退出容器：临时退出（容器继续运行）按 Ctrl+P+Q；完全退出（停止容器）输入 exit
```

### 2.2 挂载目录部署（推荐生产场景）
通过宿主机目录挂载，实现“数据持久化、配置独立管理、日志分离”——即使容器意外删除，业务数据和配置也不会丢失，适合生产环境部署服务。

#### 第一步：创建宿主机挂载目录
根据实际需求创建“数据目录”（存业务数据）、“配置目录”（存服务配置）、“日志目录”（存运行日志），路径以 `/data/openeuler` 为例：
```bash
# 一次性创建三个核心目录
mkdir -p /data/openeuler/{data,conf,logs}

# 授权目录（避免容器内用户无读写权限，生产环境可按实际用户组调整）
chmod -R 777 /data/openeuler
```

#### 第二步：启动容器并挂载目录
```bash
docker run -d --name openeuler-prod \
  -p 2222:22 \  # 映射 SSH 端口（远程管理容器内服务）
  -p 8080:80 \  # 映射 HTTP 端口（部署 Web 服务用）
  -v /data/openeuler/data:/var/data \  # 数据目录挂载（存业务数据）
  -v /data/openeuler/conf:/etc/custom \  # 配置目录挂载（存服务配置）
  -v /data/openeuler/logs:/var/log/custom \  # 日志目录挂载（存运行日志）
  -e TZ=Asia/Shanghai \  # 设置时区（解决容器默认 UTC 时区问题）
  --platform=linux/arm64 \  # 按服务器架构调整（如 x86 用 amd64）
  openeuler/openeuler:24.03-lts-sp2 \
  # 后台运行命令（确保容器不退出，这里以启动 crond 定时任务为例）
  /bin/bash -c "dnf install -y crontabs && crond -n"
```

#### 目录映射说明
| 宿主机目录              | 容器内目录        | 核心用途                                  |
|-------------------------|-------------------|-------------------------------------------|
| `/data/openeuler/data`  | `/var/data`       | 存放业务数据（如数据库文件、应用数据）    |
| `/data/openeuler/conf`  | `/etc/custom`     | 存放自定义配置（如服务启动脚本、环境变量）|
| `/data/openeuler/logs`  | `/var/log/custom` | 存放应用日志（如服务运行日志、错误日志）  |

#### 进入运行中的容器
部署后如需操作容器（如安装服务、修改配置），执行以下命令：
```bash
# 进入已启动的 openeuler-prod 容器
docker exec -it openeuler-prod /bin/bash
```

### 2.3 Docker Compose 部署（企业级批量管理）
适合多服务组合场景（如 openEuler + Nginx + MySQL），通过 `docker-compose.yml` 配置文件统一管理，支持一键启停、批量部署，运维效率更高。

#### 第一步：创建 docker-compose.yml 配置文件
在 `/data/openeuler-compose` 目录下创建配置文件（路径可自定义）：
```yaml
version: '3.8'  # 适配 Docker Compose 新版本特性
services:
  openeuler:
    image: openeuler/openeuler:24.03-lts-sp2  # 使用的 openEuler 镜像
    container_name: openeuler-service  # 容器名称（固定，方便管理）
    platform: linux/arm64  # 按服务器架构调整（amd64/arm64/loongarch64）
    ports:
      - "2222:22"  # SSH 端口映射（远程管理）
      - "8080:80"  # HTTP 端口映射（部署服务用）
    volumes:
      - ./data:/var/data  # 数据目录（相对路径，与 yml 文件同目录）
      - ./conf:/etc/custom  # 配置目录
      - ./logs:/var/log/custom  # 日志目录
    environment:
      - TZ=Asia/Shanghai  # 时区配置（上海时区，避免日志时间偏差）
      - LANG=en_US.UTF-8  # 字符集配置（避免中文乱码）
    restart: always  # 容器故障自动重启（保障服务高可用）
    command: /bin/bash -c "dnf install -y openssh-server && /usr/sbin/sshd -D"  # 启动 SSH 服务
```

#### 第二步：创建配套目录并启动服务
```bash
# 1. 创建与配置文件对应的目录（data、conf、logs）
mkdir -p /data/openeuler-compose/{data,conf,logs}
cd /data/openeuler-compose  # 进入配置文件所在目录

# 2. 启动服务（后台运行，-d 表示 detached 模式）
docker compose up -d

# 3. 常用管理命令（按需使用）
docker compose ps  # 查看服务状态（是否正常运行）
docker compose stop  # 停止服务（容器保留，数据不丢失）
docker compose down  # 停止并删除容器（挂载目录数据仍在）
docker compose logs -f  # 实时查看容器日志（排查问题用）
docker compose restart  # 重启服务（配置修改后生效）
```


## 3. 部署结果验证
通过以下三步，确认 openEuler 容器正常运行且核心功能（架构适配、数据持久化、服务可用性）可用：

### 3.1 基础状态验证
```bash
# 查看容器是否在运行（STATUS 列显示 Up 即为正常）
docker ps | grep openeuler

# 查看容器资源占用（确认 CPU、内存无异常占用，符合资源规划）
docker stats openeuler-prod  # 按 Ctrl+C 退出统计
```

### 3.2 环境功能验证
```bash
# 1. 进入容器（以 openeuler-prod 为例）
docker exec -it openeuler-prod /bin/bash

# 2. 验证包管理器与依赖（安装 Web 服务依赖）
dnf install -y gcc pcre-devel zlib-devel
ldconfig -p | grep pcre  # 确认依赖已安装

# 3. 验证挂载目录同步（容器内创建文件，宿主机查看是否存在）
echo "openEuler production data" > /var/data/test.txt
exit  # 退出容器

# 4. 宿主机验证挂载（确认文件同步，说明挂载生效）
cat /data/openeuler/data/test.txt
```

### 3.3 服务访问验证
若部署时映射了 80 端口且安装了 Nginx，可通过以下命令验证服务连通性：
```bash
# 1. 容器内安装并启动 Nginx
docker exec -it openeuler-prod dnf install -y nginx
docker exec -it openeuler-prod systemctl start nginx

# 2. 宿主机访问 Nginx 服务
curl http://127.0.0.1:8080
```
若输出 Nginx 欢迎页内容，说明服务部署正常且端口映射生效。


## 4. 常见问题排查
### 4.1 拉取镜像时提示“架构不支持”
**原因**：指定的架构与镜像支持的架构不匹配，比如给 loongarch64 服务器拉取了仅支持 ARM64 的镜像。  
**解决方案**：参考轩辕镜像页面的“支持架构”说明，拉取对应架构镜像，示例：
```bash
# 龙芯服务器拉取 loongarch64 架构镜像
docker pull --platform=linux/loongarch64 openeuler/openeuler:24.03-lts-sp2
```

### 4.2 容器内 dnf 安装软件访问表现慢
**原因**：默认用官方源，国内访问访问表现慢。  
**解决方案**：切换为国内镜像源（以华为云为例）：
```bash
# 容器内执行
echo -e "[base]\nname=openEuler-24.03-LTS-SP2 - Base - repo.huaweicloud.com\nbaseurl=https://repo.huaweicloud.com/openeuler/openEuler-24.03-LTS-SP2/OS/\$basearch/\nenabled=1\ngpgcheck=1\ngpgkey=https://repo.huaweicloud.com/openeuler/openEuler-24.03-LTS-SP2/OS/\$basearch/RPM-GPG-KEY-openEuler" > /etc/yum.repos.d/base.repo
dnf clean all && dnf makecache
```

### 4.3 容器内时区与本地差 8 小时
**原因**：容器默认使用 UTC 时区，未配置本地时区。  
**解决方案**：
- 启动时加 `-e TZ=Asia/Shanghai`（永久生效，推荐）：
  ```bash
  docker run -d -e TZ=Asia/Shanghai --name openeuler-test openeuler/openeuler:24.03-lts-sp2
  ```
- 已启动容器临时修改（重启后失效）：
  ```bash
  docker exec -it openeuler-test /bin/bash
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  date  # 验证时区是否正确
  ```

### 4.4 挂载目录后“权限被拒绝”
**原因**：宿主机目录权限不足，或容器内用户无读写权限。  
**解决方案**：
```bash
# 1. 宿主机给目录授权（生产环境可按实际用户组调整，测试用 777）
chmod -R 777 /data/openeuler

# 2. 启动时指定 root 用户（确保权限足够）
docker run -d -u root --name openeuler-prod -v /data/openeuler:/var/data openeuler/openeuler:24.03-lts-sp2
```

### 4.5 容器启动后立即退出（状态码 137）
**原因**：openEuler 镜像精简，默认无后台运行进程，容器启动后无任务可执行。  
**解决方案**：启动时指定后台运行命令，比如：
```bash
docker run -d --name openeuler-test openeuler/openeuler:24.03-lts-sp2 /bin/bash -c "while true; do sleep 3600; done"
```


## 结尾
至此，你已掌握 openEuler 的 Docker 部署全流程——从镜像拉取的架构匹配、版本选择，到适配不同场景的部署方案，再到实际问题的排查技巧，每个步骤都贴合企业级运维需求。


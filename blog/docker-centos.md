---
id: 40
title: Docker 部署 CentOS：全流程指南
slug: docker-centos
summary: CentOS 官方已于 2024 年 6 月 30 日停止所有版本的维护与更新（EOL），现有镜像不再提供安全补丁和功能迭代。当前 Docker 部署 CentOS 仅适用于遗留系统兼容、历史项目测试等场景，不建议用于新生产环境。下文将详细说明部署流程，并提供成熟的替代方案供你选择。
category: Docker,CentOS
tags: centos,docker,部署教程
image_name: library/centos
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-centos.png"
status: published
created_at: "2025-10-26 06:03:00"
updated_at: "2025-10-28 01:49:30"
---

# Docker 部署 CentOS：全流程指南

> CentOS 官方已于 2024 年 6 月 30 日停止所有版本的维护与更新（EOL），现有镜像不再提供安全补丁和功能迭代。当前 Docker 部署 CentOS 仅适用于遗留系统兼容、历史项目测试等场景，不建议用于新生产环境。下文将详细说明部署流程，并提供成熟的替代方案供你选择。

CentOS 官方已于 2024 年 6 月 30 日停止所有版本的维护与更新（EOL），现有镜像不再提供安全补丁和功能迭代。当前 Docker 部署 CentOS 仅适用于遗留系统兼容、历史项目测试等场景，**不建议用于新生产环境**。下文将详细说明部署流程，并提供成熟的替代方案供你选择。

## 关于 CentOS
CentOS 曾是基于红帽企业 Linux（RHEL）源代码构建的社区级发行版，核心优势集中在三点：
- 与 RHEL 1:1 功能兼容，可无缝运行企业级应用，无需修改配置
- 10 年长期支持周期，稳定性强，曾是服务器领域的"标配"
- 完全免费且可再分发，降低企业运维成本

但随着红帽调整开源策略，CentOS 项目终止，后续推出的 CentOS Stream 转为 RHEL 上游测试版本，不再具备原 CentOS 的稳定特性。当前 Docker 镜像的最后更新停留在 2020 年 11 月，存在未修复的安全漏洞，生产环境使用风险极高。

## 为什么仍需 Docker 部署 CentOS？
尽管已停止维护，在特定场景下 Docker 部署仍是高效选择：
1. 遗留系统迁移过渡：原有业务基于 CentOS 开发，暂未完成迁移时，容器化部署可快速搭建兼容环境
2. 测试验证需求：需要复现历史项目的运行环境，验证兼容性或排查旧版本问题
3. 临时开发环境：短期使用且不涉及敏感数据的开发场景，容器隔离可避免影响主机环境
4. 学习实践：熟悉 RHEL 系 Linux 操作，容器化部署无需占用完整服务器资源

## 📌 推荐替代方案（优先选择）
对于新项目或需要长期运行的服务，推荐以下与 CentOS 兼容的替代发行版，均支持 Docker 部署：

### 1. Rocky Linux
- 核心优势：由 CentOS 创始人发起，完全兼容 RHEL，社区驱动维护，免费无商业限制
- 适用场景：企业级生产环境、原 CentOS 7/8 用户迁移首选
- Docker 镜像：`docker pull rockylinux/rockylinux:latest`
- 镜像详情：👉 [轩辕镜像 Rocky Linux 页面](https://xuanyuan.cloud/r/rockylinux/rockylinux)

### 2. AlmaLinux OS
- 核心优势：与 RHEL 二进制兼容，提供 10 年长期支持，商业公司赞助保障可持续性
- 适用场景：服务器部署、数据库服务、企业应用运行
- Docker 镜像：`docker pull almalinux/almalinux:latest`
- 镜像详情：👉 [轩辕镜像 AlmaLinux 页面](https://xuanyuan.cloud/r/library/almalinux)

### 3. Oracle Linux
- 核心优势：基于 RHEL 源代码，完全免费，提供可选付费支持，内存管理优化出色
- 适用场景：预算有限但需要 RHEL 兼容性的企业，Oracle 生态用户
- Docker 镜像：`docker pull oraclelinux:latest`
- 镜像详情：👉 [轩辕镜像 Oracle Linux 页面](https://xuanyuan.cloud/r/library/oraclelinux)

### 4. Ubuntu Server
- 核心优势：社区活跃，软件包丰富，部署简单，云平台支持完善
- 适用场景：通用服务器、开发环境、轻量级应用部署
- Docker 镜像：`docker pull ubuntu:latest`
- 镜像详情：👉 [轩辕镜像 Ubuntu 页面](https://xuanyuan.cloud/r/library/ubuntu)

## 🧰 准备工作
若你的系统尚未安装 Docker，请先完成环境配置：

### Linux Docker & Docker Compose 一键安装
脚本支持主流 Linux 发行版，自动配置轩辕镜像访问支持源，简化安装流程：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

验证安装成功：
```bash
docker --version && docker compose --version
```
输出版本信息即表示安装完成。

## 1、查看并拉取 CentOS 镜像
CentOS 镜像已归档至轩辕镜像平台，仅保留历史标签（无最新版本）：
👉 [轩辕镜像 CentOS 页面](https://xuanyuan.cloud/r/library/centos)

### 1.1 支持的镜像标签
仅推荐拉取 CentOS 7 镜像（兼容性最好，使用量最大），其他版本漏洞风险更高：
```bash
# 拉取 CentOS 7 镜像（推荐）
docker pull docker.xuanyuan.run/library/centos:7

# 可选：拉取后重命名为简洁标签
docker tag docker.xuanyuan.run/library/centos:7 centos:7
```

### 1.2 免登录快速拉取（推荐）
无需配置账户，直接拉取镜像：
```bash
docker pull xxx.xuanyuan.run/library/centos:7
```

### 1.3 验证拉取结果
```bash
docker images | grep centos
```
输出类似以下内容即成功：
```
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
centos              7         8652b9f0cb4c   2 years ago    204MB
```

## 2、Docker 部署 CentOS 实战
提供三种部署方案，根据使用场景选择，所有方案均基于 CentOS 7 镜像。

### 2.1 快速部署（最简测试）
适合临时验证环境，一键启动交互式容器：
```bash
# 启动容器并进入命令行，命名为 centos-test
docker run -it --name centos-test centos:7 /bin/bash
```

#### 核心参数说明：
- `-it`：交互式运行，保持终端连接
- `--name centos-test`：指定容器名称，便于后续管理
- `/bin/bash`：启动后进入 Bash 命令行

#### 退出与重启：
- 临时退出（容器后台运行）：按 `Ctrl+P+Q`
- 完全退出（停止容器）：按 `Ctrl+D` 或输入 `exit`
- 重启容器并重新进入：`docker restart centos-test && docker exec -it centos-test /bin/bash`

### 2.2 挂载目录部署（推荐，持久化配置）
通过目录挂载实现文件共享、配置持久化，避免容器销毁后数据丢失：

#### 第一步：创建宿主机挂载目录
```bash
# 创建数据、配置、日志三个目录，按需调整路径
mkdir -p /data/centos/{data,conf,logs}
```

#### 第二步：启动容器并挂载目录
```bash
docker run -d --name centos-web \
  -p 8080:80 \  # 端口映射（宿主机8080:容器80），按需调整
  -v /data/centos/data:/var/data \  # 数据目录挂载
  -v /data/centos/conf:/etc/conf \  # 配置目录挂载
  -v /data/centos/logs:/var/log \   # 日志目录挂载
  -e TZ=Asia/Shanghai \  # 设置时区（解决容器时区偏差）
  centos:7 \
  /bin/bash -c "while true; do echo 'CentOS container running' >> /var/log/run.log; sleep 3600; done"
```

#### 目录映射说明：
| 宿主机目录          | 容器内目录    | 用途                 |
|---------------------|---------------|----------------------|
| `/data/centos/data` | `/var/data`   | 存放业务数据文件     |
| `/data/centos/conf` | `/etc/conf`   | 存放自定义配置文件   |
| `/data/centos/logs` | `/var/log`    | 存放运行日志         |

#### 进入运行中的容器：
```bash
docker exec -it centos-web /bin/bash
```

### 2.3 docker-compose 部署（企业级管理）
适合多服务组合或长期运行，通过配置文件统一管理：

#### 第一步：创建 docker-compose.yml 文件
```yaml
version: '3'
services:
  centos:
    image: centos:7
    container_name: centos-service
    ports:
      - "8080:80"
      - "2222:22"  # 若需 SSH 连接可映射22端口
    volumes:
      - ./data:/var/data
      - ./conf:/etc/conf
      - ./logs:/var/log
    environment:
      - TZ=Asia/Shanghai
    restart: on-failure  # 容器故障时自动重启
    command: /bin/bash -c "yum install -y crontabs && crond -n"  # 示例：安装定时任务并启动
```

#### 第二步：启动与管理服务
```bash
# 启动服务（在 yml 文件所在目录执行）
docker compose up -d

# 查看状态
docker compose ps

# 停止服务（保留容器）
docker compose stop

# 停止并删除容器
docker compose down
```

## 3、CentOS 容器关键配置优化
### 3.1 修复 yum 源（解决镜像源失效问题）
CentOS 7 官方源已停止维护，需替换为第三方镜像源：
```bash
# 进入容器后执行
sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*.repo
sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo
yum clean all && yum makecache
```

### 3.2 安装基础工具
默认镜像精简，需手动安装常用工具：
```bash
yum install -y wget curl vim net-tools telnet
```

### 3.3 启用 systemd 服务（可选）
CentOS 7 容器支持 systemd，但需特殊配置：
```bash
# 1. 创建 Dockerfile 构建基础镜像
cat > Dockerfile << EOF
FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ \$i == systemd-tmpfiles-setup.service ] || rm -f \$i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
EOF

# 2. 构建镜像
docker build -t centos7-systemd .

# 3. 启动容器
docker run -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro centos7-systemd
```

### 3.4 解决存储驱动限制
CentOS 容器默认使用 Device Mapper 存储驱动，存在 100GB 存储池限制，建议切换为 OverlayFS：
```bash
# 1. 停止 Docker 服务
systemctl stop docker

# 2. 备份原有数据（可选）
mv /var/lib/docker /var/lib/docker.bak

# 3. 修改 Docker 配置
cat > /etc/docker/daemon.json << EOF
{
  "storage-driver": "overlay2"
}
EOF

# 4. 重启 Docker
systemctl daemon-reload && systemctl start docker
```

## 4、常见问题排查
### 4.1 容器启动失败（状态码 139）
原因：CentOS 6/7 依赖 vsyscall 系统调用，部分主机默认禁用
解决方案：
```bash
# 检查主机是否支持 vsyscall
grep vsyscall /proc/self/maps

# 无输出则添加内核参数
grubby --args="vsyscall=emulated" --update-kernel="$(grubby --default-kernel)"
reboot  # 重启生效
```

### 4.2 yum 安装软件报错
原因：镜像源失效或缓存问题
解决方案：
- 执行 3.1 节的镜像源替换命令
- 关闭 GPG 校验（临时方案）：`yum install -y 软件名 --nogpgcheck`

### 4.3 容器内时区不正确
解决方案：启动时添加时区环境变量
```bash
docker run -d -e TZ=Asia/Shanghai --name centos-test centos:7
```

### 4.4 挂载目录权限不足
原因：宿主机目录权限与容器内用户权限不匹配
解决方案：
```bash
# 1. 调整宿主机目录权限
chmod -R 777 /data/centos

# 2. 或启动时指定用户
docker run -d -u root --name centos-test -v /data/centos:/var/data centos:7
```

## 结尾
本文详细覆盖了 Docker 部署 CentOS 的全流程，从镜像拉取、多场景部署到配置优化和问题排查，适用于遗留系统兼容等特定需求。但再次强调，CentOS 已终止维护，**新环境请优先选择 Rocky Linux、AlmaLinux 等替代方案**，避免安全风险。


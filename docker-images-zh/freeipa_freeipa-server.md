---
image: freeipa/freeipa-server
description: "FreeIPA服务器容器，提供集中式身份认证、授权和账户管理服务，支持在容器中部署主服务器或副本，通过systemd管理服务，适用于开发测试与生产环境，支持数据持久化、版本升级及多标签选择（稳定版/开发版）。"
source: https://xuanyuan.cloud/zh/r/freeipa/freeipa-server
canonical: https://xuanyuan.cloud/zh/r/freeipa/freeipa-server
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/freeipa/freeipa-server" title="freeipa/freeipa-server Docker 镜像中文简介、标签列表与拉取命令">freeipa/freeipa-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/freeipa/freeipa-server" title="freeipa/freeipa-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/freeipa/freeipa-server</a>

# FreeIPA服务器容器

## 概述

FreeIPA服务器容器镜像基于[freeipa/freeipa-container](https://github.com/freeipa/freeipa-container)构建，提供集中式身份认证、授权、账户管理及域名服务（DNS）。容器通过systemd管理内部服务，支持部署主服务器或副本，数据通过持久化存储卷保存，可实现配置与数据的升级迁移。

## 核心功能与特性

- **多环境支持**：提供稳定版（`almalinux-9`/`rocky-9`）、开发测试版（`fedora-*`）及最新版（`fedora-rawhide`）标签
- **服务管理**：通过systemd统一管理FreeIPA相关服务（如LDAP、Kerberos、DNS等）
- **数据持久化**：配置与数据存储于`/data`目录，支持通过卷挂载实现持久化
- **灵活部署**：支持主服务器（`ipa-server-install`）和副本（`ipa-replica-install`）部署
- **安装选项**：支持命令行参数、环境变量及配置文件三种方式传递安装参数
- **自动升级**：使用新版本镜像时，自动检测并升级旧数据目录的配置与数据
- **调试工具**：提供环境变量及命令参数用于故障排查与容器调试

## 使用场景

- **开发测试**：快速部署FreeIPA服务进行功能验证或集成测试
- **生产环境**：通过稳定版标签（如`rocky-9-4.*.*`）部署集中式身份认证服务
- **多环境隔离**：通过容器化部署实现不同环境（开发/测试/生产）的服务隔离
- **高可用架构**：部署多个副本服务器实现服务冗余

## 使用方法

### 镜像选择

| 用途         | 推荐标签                          | 说明                     |
|--------------|-----------------------------------|--------------------------|
| 生产环境     | `freeipa/freeipa-server:rocky-9`  | 稳定版，基于Rocky Linux 9 |
| 生产环境（固定版本） | `freeipa/freeipa-server:rocky-9-4.*.*` | 指定FreeIPA版本，更高稳定性 |
| 开发测试     | `freeipa/freeipa-server:fedora-*` | 基于Fedora，包含新特性   |
| 最新特性     | `freeipa/freeipa-server:fedora-rawhide` | 最新开发版本             |

### 运行前准备

#### 容器运行时配置
- **Podman**：无需特殊配置，直接使用`podman run`
- **Docker（cgroups v2）**：需在`/etc/docker/daemon.json`中添加`{ "userns-remap": "default" }`，重启Docker服务
- **Docker（cgroups v1）**：运行时需添加参数`-v /sys/fs/cgroup:/sys/fs/cgroup:ro`
- **SELinux启用系统**：执行`setsebool -P container_manage_cgroup 1`允许容器管理cgroup

#### 数据目录准备
创建主机数据目录并挂载至容器`/data`：
```bash
mkdir /var/lib/ipa-data  # 主机数据目录
```

### 部署主服务器

#### 交互式安装
首次运行时通过`ipa-server-install`交互式配置（默认命令，可省略）：
```bash
podman run --name freeipa-server -ti \
  -h ipa.example.test \  # 设置容器主机名（必须）
  --read-only \          # 只读根文件系统（推荐）
  -v /var/lib/ipa-data:/data:Z \  # 挂载数据卷（Z选项修复SELinux上下文）
  freeipa/freeipa-server ipa-server-install -r EXAMPLE.TEST --no-ntp
```

#### 非交互式安装
使用`-U`参数及环境变量实现无人值守安装：
```bash
docker run --name freeipa-server -ti \
  -h ipa.example.test \
  --read-only \
  -v /var/lib/ipa-data:/data:Z \
  -e PASSWORD=Secret123 \  # 管理员密码
  freeipa/freeipa-server ipa-server-install -U -r EXAMPLE.TEST --no-ntp
```

#### 安装选项传递方式
1. **命令行参数**：直接在容器启动命令后添加`ipa-server-install`参数（如上述示例）
2. **环境变量**：通过`-e IPA_SERVER_INSTALL_OPTS="参数"`传递，例如：
   ```bash
   podman run ... -e IPA_SERVER_INSTALL_OPTS="-U -r EXAMPLE.TEST --no-ntp" freeipa/freeipa-server
   ```
3. **配置文件**：在数据卷目录创建`ipa-server-install-options`文件，每行一个参数：
   ```ini
   # /var/lib/ipa-data/ipa-server-install-options内容
   --realm=EXAMPLE.TEST
   --ds-password=DirSrvPass123
   --admin-password=AdminPass123
   ```

### 部署副本服务器
通过`ipa-replica-install`命令部署副本，需指定主服务器信息：
```bash
podman run --name freeipa-replica -ti \
  -h replica.example.test \
  --read-only \
  -v /var/lib/ipa-replica-data:/data:Z \
  freeipa/freeipa-server ipa-replica-install --server=ipa.example.test -p Secret123
```
> 副本安装选项也可通过`ipa-replica-install-options`文件传递（同主服务器文件方式）

### 网络配置
若需从外部访问FreeIPA服务，需映射端口并设置`IPA_SERVER_IP`环境变量：
```bash
docker run ... \
  -e IPA_SERVER_IP=10.12.0.98 \  # 容器对外暴露的IP（需与主机端口映射对应）
  -p 53:53/udp -p 53:53 \       # DNS
  -p 80:80 -p 443:443 \         # HTTP/HTTPS
  -p 389:389 -p 636:636 \       # LDAP/LDAPS
  -p 88:88 -p 464:464 \         # Kerberos
  -p 88:88/udp -p 464:464/udp \
  -p 123:123/udp \              # NTP（若启用）
  freeipa/freeipa-server ...
```

## IPA客户端容器

### 构建客户端镜像
选择基于目标OS的`*-client`分支，构建镜像：
```bash
git clone https://github.com/freeipa/freeipa-container.git
cd freeipa-container
git checkout fedora-client  # 选择OS分支（如fedora-client、rocky-client等）
docker build -t freeipa-client .
```

### 运行客户端容器
客户端需正确配置DNS或直接链接到服务器容器：
```bash
docker run --privileged \
  --link freeipa-server-container:ipa \  # 链接到服务器容器
  -e PASSWORD=Secret123 \                # 管理员密码
  -ti freeipa-client
```
> 首次运行时自动执行`ipa-client-install`完成域加入

## 调试

### 调试环境变量
- `DEBUG_TRACE=1`：启用脚本执行跟踪（显示详细执行过程）
- `DEBUG_NO_EXIT=1`：脚本失败后不退出容器，可通过`exec`进入调试：
  ```bash
  podman exec -it freeipa-server-container bash  # 进入运行中的容器
  ```

### 命令行调试选项
- `exit-on-finished`：配置完成后自动退出容器（用于一次性部署脚本）
  ```bash
  docker run ... freeipa/freeipa-server exit-on-finished -U -r EXAMPLE.TEST
  ```
- `no-exit`：同`DEBUG_NO_EXIT=1`，作为命令参数使用：
  ```bash
  podman run ... freeipa/freeipa-server no-exit -U -r EXAMPLE.TEST
  ```

## 升级注意事项
1. 使用新版本镜像启动容器，挂载原数据卷：
   ```bash
   podman run ... -v /var/lib/ipa-data:/data:Z freeipa/freeipa-server:rocky-9-new
   ```
2. 容器会自动检测数据版本差异并尝试升级配置与数据
3. **强烈建议**升级前备份数据卷目录：`cp -a /var/lib/ipa-data /var/lib/ipa-data-backup`

## 测试与CI
可通过项目测试脚本验证容器功能：
```bash
# 使用Docker运行测试
tests/run-partial-tests.sh Dockerfile

# 使用Podman运行测试
docker=podman tests/run-partial-tests.sh Dockerfile
```

## 许可证
本镜像基于Apache License 2.0许可，详见[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)。

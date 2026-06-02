---
image: linuxserver/openssh-server
description: "提供OpenSSH服务器服务，支持远程登录与服务器管理，具备易于部署、配置灵活的特点，适用于各类需要安全远程访问的场景。"
source: https://xuanyuan.cloud/zh/r/linuxserver/openssh-server
canonical: https://xuanyuan.cloud/zh/r/linuxserver/openssh-server
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [linuxserver/openssh-server — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/openssh-server)

含镜像标签、拉取命令、部署文档与相关推荐。

[linuxserver/openssh-server Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/linuxserver/openssh-server)

# linuxserver/openssh-server

## 镜像概述和主要用途

[OpenSSH Server](https://www.openssh.com/) 镜像是一个沙箱环境，允许通过 SSH 访问而无需授予对整个服务器的密钥权限。通常，通过私钥授予 SSH 访问意味着给予服务器的完全访问权限，而此容器创建了一个受限的沙箱环境，用户只能访问映射的文件夹和容器内运行的进程。

该镜像由 [LinuxServer.io](https://linuxserver.io) 团队维护，提供定期更新、安全加固和简化的用户权限管理，适用于需要安全隔离 SSH 访问的场景。

## 核心功能和特性

### LinuxServer.io 通用特性
- 定期及时的应用更新
- 简单的用户映射（PGID、PUID）
- 基于 s6 overlay 的自定义基础镜像
- 每周基础 OS 更新，跨整个 LinuxServer.io 生态系统共享通用层，以最小化空间占用、 downtime 和带宽消耗
- 定期安全更新

### OpenSSH Server 特定功能
- 支持通过环境变量自动配置公钥（`PUBLIC_KEY`、`PUBLIC_KEY_FILE`、`PUBLIC_KEY_DIR`、`PUBLIC_KEY_URL`）
- 可选密码访问控制（`PASSWORD_ACCESS`）
- 细粒度 sudo 权限管理（`SUDO_ACCESS`），支持密码或密码less sudo
- 多架构支持（x86-64、arm64）
- 日志重定向至标准输出（`LOG_STDOUT`）
- 自定义用户名称（`USER_NAME`）
- 集成密钥生成辅助脚本

## 支持的架构

该镜像通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/openssh-server:latest` 即可自动获取对应架构的镜像，也可通过标签指定特定架构：

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 使用场景和适用范围

- **安全隔离的 SSH 访问**：为第三方或自动化流程提供受限 SSH 访问，仅允许访问特定映射目录
- **备份服务器**：允许远程服务器通过 SSH 上传备份文件，限制访问范围至备份目录
- **多实例隔离**：通过不同端口和卷映射运行多个容器，实现不同用户/服务的访问隔离
- **自动化运维**：为 CI/CD 流程提供受限 SSH 访问，执行特定操作（如文件传输、命令执行）

## 使用方法和配置说明

### 应用设置

#### 公钥配置
- 若设置 `PUBLIC_KEY`、`PUBLIC_KEY_FILE` 或 `PUBLIC_KEY_DIR` 环境变量，指定的公钥将自动添加至 `authorized_keys`
- 未设置上述变量时，需手动将公钥添加至 `/config/.ssh/authorized_keys` 并重启容器
- 移除公钥相关环境变量不会从 `authorized_keys` 中删除已添加的密钥
- `PUBLIC_KEY_FILE` 和 `PUBLIC_KEY_DIR` 支持 Docker secrets

#### 密码访问（不推荐用于公网环境）
- 通过 `PASSWORD_ACCESS=true` 启用密码访问，需同时设置 `USER_PASSWORD` 或 `USER_PASSWORD_FILE`

#### 连接方式
```bash
ssh -i /path/to/private/key -p <映射端口> <用户名>@<服务器IP>
```

#### Sudo 权限
- 设置 `SUDO_ACCESS=true` 允许 sudo 访问，未设置 `USER_PASSWORD` 时为密码less sudo
- `USER_PASSWORD` 或 `USER_PASSWORD_FILE` 用于设置 sudo 密码

#### 自定义配置
- 通过卷映射 `/etc/motd` 自定义登录欢迎信息
- 通过 `--hostname` 参数设置容器主机名

### 密钥生成

容器提供密钥生成辅助脚本，运行以下命令生成 SSH 公私钥对：

```bash
docker run --rm -it --entrypoint /keygen.sh linuxserver/openssh-server
```

按照提示操作，生成的密钥将显示在控制台输出，需自行保存。

### 部署示例

#### Docker Compose（推荐）

```yaml
---
services:
  openssh-server:
    image: lscr.io/linuxserver/openssh-server:latest
    container_name: openssh-server
    hostname: openssh-server  # 可选
    environment:
      - PUID=1000               # 用户ID
      - PGID=1000               # 组ID
      - TZ=Etc/UTC              # 时区
      - PUBLIC_KEY=yourpublickey  # 可选，公钥内容
      - PUBLIC_KEY_FILE=/path/to/file  # 可选，公钥文件路径
      - PUBLIC_KEY_DIR=/path/to/directory/containing/_only_/pubkeys  # 可选，公钥目录
      - PUBLIC_KEY_URL=https://github.com/username.keys  # 可选，公钥URL
      - SUDO_ACCESS=false       # 可选，是否允许sudo
      - PASSWORD_ACCESS=false   # 可选，是否允许密码访问
      - USER_PASSWORD=password  # 可选，用户密码
      - USER_PASSWORD_FILE=/path/to/file  # 可选，密码文件路径
      - USER_NAME=linuxserver.io  # 可选，用户名（默认：linuxserver.io）
      - LOG_STDOUT=             # 可选，设置为true将日志输出至stdout
    volumes:
      - /path/to/openssh-server/config:/config  # 配置目录
    ports:
      - 2222:2222               # SSH端口映射
    restart: unless-stopped
```

#### Docker CLI

```bash
docker run -d \
  --name=openssh-server \
  --hostname=openssh-server `# 可选` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PUBLIC_KEY=yourpublickey `# 可选` \
  -e PUBLIC_KEY_FILE=/path/to/file `# 可选` \
  -e PUBLIC_KEY_DIR=/path/to/directory/containing/_only_/pubkeys `# 可选` \
  -e PUBLIC_KEY_URL=https://github.com/username.keys `# 可选` \
  -e SUDO_ACCESS=false `# 可选` \
  -e PASSWORD_ACCESS=false `# 可选` \
  -e USER_PASSWORD=password `# 可选` \
  -e USER_PASSWORD_FILE=/path/to/file `# 可选` \
  -e USER_NAME=linuxserver.io `# 可选` \
  -e LOG_STDOUT= `# 可选` \
  -p 2222:2222 \
  -v /path/to/openssh-server/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/openssh-server:latest
```

### 参数说明

| 参数 | 功能 |
| :----: | --- |
| `--hostname=` | 可选，定义容器主机名 |
| `-p 2222:2222` | SSH端口映射（主机:容器） |
| `-e PUID=1000` | 用户ID，用于权限映射 |
| `-e PGID=1000` | 组ID，用于权限映射 |
| `-e TZ=Etc/UTC` | 时区，参考 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e PUBLIC_KEY=yourpublickey` | 可选，公钥内容，自动添加至authorized_keys |
| `-e PUBLIC_KEY_FILE=/path/to/file` | 可选，公钥文件路径（支持Docker secrets） |
| `-e PUBLIC_KEY_DIR=/path/to/directory` | 可选，公钥目录路径（仅包含公钥文件，支持Docker secrets） |
| `-e PUBLIC_KEY_URL=https://github.com/username.keys` | 可选，公钥URL，从URL获取公钥 |
| `-e SUDO_ACCESS=false` | 设置为`true`允许sudo访问，未设置密码时为密码less sudo |
| `-e PASSWORD_ACCESS=false` | 设置为`true`允许密码访问，需配合`USER_PASSWORD`或`USER_PASSWORD_FILE` |
| `-e USER_PASSWORD=password` | 可选，用户密码（用于sudo或密码访问） |
| `-e USER_PASSWORD_FILE=/path/to/file` | 可选，密码文件路径（覆盖`USER_PASSWORD`，支持Docker secrets） |
| `-e USER_NAME=linuxserver.io` | 可选，SSH用户名（默认：linuxserver.io） |
| `-e LOG_STDOUT=` | 设置为`true`将日志输出至stdout而非文件 |
| `-v /config` | 配置目录，包含所有相关配置文件 |

### 从文件加载环境变量（Docker Secrets）

通过 `FILE__` 前缀从文件加载环境变量，例如：

```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```

上述命令将从 `/run/secrets/mysecretvariable` 文件内容设置 `MYVAR` 环境变量。

### 应用运行的Umask设置

通过 `-e UMASK=022` 覆盖容器内服务的默认umask设置。Umask通过减法调整权限，而非直接设置权限，详情参考 [Umask说明](https://en.wikipedia.org/wiki/Umask)。

### 用户/组ID

使用卷映射时，可通过 `PUID` 和 `PGID` 解决权限问题。确保主机卷目录的所有者与容器内的 `PUID`/`PGID` 一致。通过以下命令获取当前用户的ID：

```bash
id your_user
```

示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=openssh-server&query=%24.mods%5B%27openssh-server%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=openssh-server) [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal)

通过 Docker Mods 扩展容器功能，上述链接可查看适用于该镜像的特定mods和通用mods。

## 支持信息

### 容器内Shell访问
```bash
docker exec -it openssh-server /bin/bash
```

### 实时监控日志
```bash
docker logs -f openssh-server
```

### 容器版本号
```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' openssh-server
```

### 镜像版本号
```bash
docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/openssh-server:latest
```

## 更新说明

### 通过Docker Compose更新
- 更新镜像：
  - 所有镜像：
    ```bash
    docker-compose pull
    ```
  - 单个镜像：
    ```bash
    docker-compose pull openssh-server
    ```
- 更新容器：
  - 所有容器：
    ```bash
    docker-compose up -d
    ```
  - 单个容器：
    ```bash
    docker-compose up -d openssh-server
    ```
- 清理旧镜像：
  ```bash
  docker image prune
  ```

### 通过Docker Run更新
- 更新镜像：
  ```bash
  docker pull lscr.io/linuxserver/openssh-server:latest
  ```
- 停止运行中的容器：
  ```bash
  docker stop openssh-server
  ```
- 删除容器：
  ```bash
  docker rm openssh-server
  ```
- 使用相同参数重新创建容器（配置通过卷映射保留）
- 清理旧镜像：
  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun

推荐使用 [Diun](https://crazymax.dev/diun/) 接收更新通知，不建议使用自动更新容器的工具。

## 本地构建

如需本地修改或开发，可按以下步骤构建镜像：

```bash
git clone https://github.com/linuxserver/docker-openssh-server.git
cd docker-openssh-server
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/openssh-server:latest .
```

在x86_64硬件上构建ARM变体（反之亦然）：

```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```

注册后，使用 `-f Dockerfile.aarch64` 指定架构对应的Dockerfile。

## 版本历史

- **05.07.25:** - 基于Alpine 3.22重建
- **10.02.25:** - 添加sshd_config.d支持
- **12.01.25:** - 基于Alpine 3.21重建
- **24.11.24:** - 将sshd_config迁移至/config/sshd/sshd_config
- **31.05.24:** - 基于Alpine 3.20重建
- **04.05.24:** - 容器启动时显示SSH主机公钥
- **09.03.24:** - 基于Alpine 3.19重建
- **12.06.23:** - 基于Alpine 3.18重建，弃用armhf架构
- **05.03.23:** - 基于Alpine 3.17重建
- **18.10.22:** - 修复密码/无密码sudo的错误行为
- **11.10.22:** - 基于Alpine 3.16重建，迁移至s6v3
- **15.09.22:** - 添加支持代理的netcat-openbsd
- **18.07.22:** - 修复服务权限以兼容s6 v3升级
- **16.04.22:** - 基于Alpine 3.15重建
- **16.11.21:** - 添加PUBLIC_KEY_URL选项
- **28.06.21:** - 基于Alpine 3.14重建，添加PAM支持
- **10.02.21:** - 基于Alpine 3.13重建，添加openssh-client（用于scp）
- **21.10.20:** - 实现s6-log日志功能，支持本地时间戳和日志解析（如fail2ban）
- **20.10.20:** - 为sftp设置umask
- **01.06.20:** - 基于Alpine 3.12重建
- **18.01.20:** - 添加密钥生成脚本
- **13.01.20:** - 添加openssh-sftp-server
- **19.12.19:** - 基于Alpine 3.11重建
- **17.10.19:** - 初始发布

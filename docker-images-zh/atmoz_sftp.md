---
image: atmoz/sftp
description: "易于使用的SFTP服务器"
source: https://xuanyuan.cloud/zh/r/atmoz/sftp
canonical: https://xuanyuan.cloud/zh/r/atmoz/sftp
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atmoz/sftp" title="atmoz/sftp Docker 镜像中文简介、标签列表与拉取命令">atmoz/sftp — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/atmoz/sftp" title="atmoz/sftp Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/atmoz/sftp</a>

# SFTP 镜像文档


## 概述

SFTP 镜像是一个基于 OpenSSH 的轻量级、易用的 SSH 文件传输协议（SFTP）服务器。它提供安全的文件传输能力，支持多种用户配置方式和灵活的卷挂载，适用于个人、团队或服务器间的安全文件共享场景。


## 核心功能与特性

- **多方式用户定义**：支持通过命令参数、`SFTP_USERS` 环境变量或配置文件（`/etc/sftp/users.conf`）定义用户
- **自定义用户属性**：可指定密码（明文或加密）、UID、GID，以及自动创建用户主目录下的子目录
- **灵活卷挂载**：用户被限制在其主目录（chroot），支持挂载主机目录或数据卷到用户主目录内
- **SSH 密钥认证**：支持通过挂载公钥文件实现无密码登录，提升安全性
- **自定义脚本执行**：容器启动时自动运行 `/etc/sftp.d/` 目录下的脚本，支持自定义初始化逻辑
- **多基础镜像支持**：提供 Debian（稳定，体积较大）和 Alpine（轻量，版本较新）两种版本


## 使用场景与适用范围

- 个人或团队间的安全文件传输与共享
- 服务器与客户端之间的加密文件同步
- 开发/测试环境中容器与主机的文件交换
- 需要限制用户访问范围的文件服务（如仅允许访问特定子目录）
- 需自定义用户权限与目录结构的文件存储服务


## 支持的标签及对应 Dockerfile 链接

- [`debian`, `latest` (*Dockerfile*)](https://github.com/atmoz/sftp/blob/master/Dockerfile)  
  ![Docker Image Size (debian)](https://img.shields.io/docker/image-size/atmoz/sftp/debian?label=debian&logo=debian&style=plastic)
- [`alpine` (*Dockerfile*)](https://github.com/atmoz/sftp/blob/master/Dockerfile-alpine)  
  ![Docker Image Size (alpine)](https://img.shields.io/docker/image-size/atmoz/sftp/alpine?label=alpine&logo=Alpine%20Linux&style=plastic)


## 使用方法

### 用户定义

支持三种用户定义方式，语法统一为：  
`user:pass[:e][:uid[:gid[:dir1[,dir2]...]]]`  

| 字段       | 说明                                                                 |
|------------|----------------------------------------------------------------------|
| `user`     | 用户名（必填）                                                       |
| `pass`     | 密码（必填，若使用密钥登录可留空，格式为 `user::uid...`）            |
| `:e`       | 可选标记，指示密码为加密格式（如 MD5 加密）                          |
| `uid`      | 可选用户 ID，用于匹配主机文件系统权限                                |
| `gid`      | 可选用户组 ID，用于匹配主机文件系统权限                              |
| `dir1...`  | 可选子目录列表，将在用户主目录下自动创建并赋予写权限（若不存在）      |

#### 定义方式：
1. **命令参数**：直接在 `docker run` 或 `docker-compose` 的 `command` 中指定用户
2. **环境变量**：通过 `SFTP_USERS` 环境变量定义（格式同上）
3. **配置文件**：挂载文件到 `/etc/sftp/users.conf`（每行一个用户，格式同上）


### 卷挂载

- **用户主目录限制**：用户被 chroot 到其主目录（`/home/<user>`），无法访问主目录外的文件
- **数据持久化**：建议挂载主机目录或数据卷到用户主目录内（如 `/home/foo/upload`），避免直接挂载 `/home`（用户无法在主目录根目录创建文件）
- **主机密钥挂载**：为保持服务器指纹一致性，可挂载主机 SSH 密钥文件（`/etc/ssh/ssh_host_*`）


### 环境变量

| 变量名       | 说明                                                                 |
|--------------|----------------------------------------------------------------------|
| `SFTP_USERS` | 定义用户，格式同命令参数（如 `SFTP_USERS="foo:pass:1001 bar:abc:1002"`） |


## 使用示例

### 最简单的 docker run 示例

```bash
docker run -p 22:22 -d atmoz/sftp foo:pass:::upload
```

**说明**：  
- 创建用户 `foo`，密码 `pass`，自动在其主目录下创建 `upload` 子目录  
- 容器 SSH 端口（22）映射到主机 22 端口，可通过 `sftp foo@<主机IP>` 登录并上传文件到 `upload` 目录


### 共享主机目录（自定义 UID）

挂载主机目录到用户主目录，并指定 UID 以匹配主机权限：

```bash
docker run \
    -v /host/path/upload:/home/foo/upload \  # 挂载主机目录到用户子目录
    -p 2222:22 -d atmoz/sftp \              # 映射容器 22 端口到主机 2222 端口
    foo:pass:1001                           # 用户 foo，密码 pass，UID=1001
```


### 使用 Docker Compose

```yaml
sftp:
    image: atmoz/sftp
    volumes:
        - /host/path/upload:/home/foo/upload  # 挂载主机目录
    ports:
        - "2222:22"                           # 端口映射
    command: foo:pass:1001                    # 用户定义（格式：user:pass:uid）
```

#### 登录方法：
通过 OpenSSH 客户端连接：  
```bash
sftp -P 2222 foo@<主机IP>  # -P 指定主机端口（2222），foo 为用户名
```


### 通过配置文件定义用户

将用户信息存储在配置文件中，便于管理多用户：

1. 创建主机配置文件 `/host/path/users.conf`：
   ```ini
   foo:123:1001:100    # 用户 foo，密码 123，UID=1001，GID=100
   bar:abc:1002:100    # 用户 bar，密码 abc，UID=1002，GID=100
   baz:xyz:1003:100    # 用户 baz，密码 xyz，UID=1003，GID=100
   ```

2. 启动容器：
   ```bash
   docker run \
       -v /host/path/users.conf:/etc/sftp/users.conf:ro \  # 只读挂载配置文件
       -v sftp_data:/home \                               # 挂载数据卷存储用户主目录
       -p 2222:22 -d atmoz/sftp
   ```


### 使用加密密码

通过 `:e` 标记加密密码（需提前生成加密字符串）：

```bash
docker run \
    -v /host/path/share:/home/foo/share \
    -p 2222:22 -d atmoz/sftp \
    'foo:$1$0G2g0GSt$ewU0t6GXG15.0hWoOX8X9.:e:1001'  # 加密密码（MD5格式），UID=1001
```

#### 生成加密密码：
使用 `atmoz/makepasswd` 工具生成 MD5 加密密码：  
```bash
echo -n "your-password" | docker run -i --rm atmoz/makepasswd --crypt-md5 --clearfrom=-
```


### SSH 密钥登录（无密码）

通过挂载公钥文件实现密钥认证（无需密码）：

```bash
docker run \
    -v /host/path/id_rsa.pub:/home/foo/.ssh/keys/id_rsa.pub:ro \  # 挂载公钥到用户密钥目录
    -v /host/path/share:/home/foo/share \
    -p 2222:22 -d atmoz/sftp \
    foo::1001  # 密码留空（仅允许密钥登录），UID=1001
```

**说明**：  
- 公钥需挂载到用户主目录下的 `.ssh/keys/` 目录（容器会自动将所有公钥追加到 `.ssh/authorized_keys`）  
- 不可直接挂载 `.ssh/authorized_keys` 文件（OpenSSH 要求该文件权限为 600，直接挂载可能权限错误）


### 自定义 SSH 主机密钥（推荐）

默认容器会自动生成 SSH 主机密钥，若需避免重建容器时用户收到 MITM 警告，可挂载自定义主机密钥：

1. 生成主机密钥（主机执行）：
   ```bash
   ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null  # Ed25519 密钥
   ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null   # RSA 密钥（4096位）
   ```

2. 启动容器时挂载密钥：
   ```bash
   docker run \
       -v /host/path/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key \
       -v /host/path/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
       -v /host/path/share:/home/foo/share \
       -p 2222:22 -d atmoz/sftp \
       foo::1001
   ```


### 执行自定义脚本

容器启动时自动运行 `/etc/sftp.d/` 目录下的脚本，用于自定义初始化（如绑定挂载目录）：

1. 创建脚本 `/host/path/bindmount.sh`：
   ```bash
   #!/bin/bash
   # 绑定挂载示例：将主机目录挂载到用户子目录

   function bindmount() {
       if [ -d "$1" ]; then
           mkdir -p "$2"
       fi
       mount --bind $3 "$1" "$2"  # $3 为可选参数（如 --read-only）
   }

   # 绑定挂载（需容器开启 CAP_SYS_ADMIN 权限）
   bindmount /data/common /home/dave/common
   bindmount /data/docs /home/peter/docs --read-only  # 只读挂载
   ```

2. 启动容器（需添加 `--cap-add=SYS_ADMIN` 权限）：
   ```bash
   docker run \
       --cap-add=SYS_ADMIN \  # 允许使用 mount 命令
       -v /host/path/bindmount.sh:/etc/sftp.d/bindmount.sh \
       -v /host/data:/data \   # 挂载主机数据目录
       -p 2222:22 -d atmoz/sftp \
       dave::1001 peter::1002
   ```


## Debian 与 Alpine 版本的区别

| 特性       | Debian 版本                          | Alpine 版本                          |
|------------|--------------------------------------|--------------------------------------|
| **体积**   | 较大（约 200MB+）                    | 极小（约 20MB+，比 Debian 小 10 倍） |
| **稳定性** | 高（仅修复 bug 和安全问题，发布周期约 2 年） | 较快（发布周期约 6 个月，版本更新频繁） |
| **OpenSSH 版本** | 较旧但稳定                          | 较新（随 Alpine 发行版更新）         |

**选择建议**：追求稳定性选 Debian，追求轻量和新版本选 Alpine。


## OpenSSH 版本说明

OpenSSH 版本取决于基础镜像的发行版：  
- **Alpine 版本**：查看 [Alpine 官方包列表](https://pkgs.alpinelinux.org/packages?name=openssh&branch=&repo=main&arch=x86_64)  
- **Debian 版本**：查看 [Debian 官方包列表](https://packages.debian.org/search?keywords=openssh-server&searchon=names&exact=1&suite=all&section=main)  

**注意**：镜像构建延迟可能导致 OpenSSH 版本略滞后于基础镜像官方包（通常 1-5 天），如需精确版本可手动克隆源码构建。

---
image: jmcombs/sftp
description: "atmoz/sftp的分支版本，新增SCP支持与多平台适配，提供SFTP服务。"
source: https://xuanyuan.cloud/zh/r/jmcombs/sftp
canonical: https://xuanyuan.cloud/zh/r/jmcombs/sftp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jmcombs/sftp" title="jmcombs/sftp Docker 镜像中文简介、标签列表与拉取命令">jmcombs/sftp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SFTP Docker镜像文档


## 镜像概述

SFTP Docker镜像是一个基于OpenSSH的轻量级SFTP（SSH文件传输协议）和SCP服务器，支持多用户配置、卷挂载和自定义SSH密钥。该镜像为atmoz/sftp的分支版本，新增了SCP支持和多平台兼容性，适用于安全、便捷的文件传输场景。


## 支持的标签

| 标签         | 说明                                                                 | Dockerfile链接                                                                 |
|--------------|----------------------------------------------------------------------|-------------------------------------------------------------------------------|
| `debian`     | 基于Debian系统，默认标签（`latest`）                                 | [Dockerfile](https://github.com/jmcombs/sftp/blob/master/Dockerfile)          |
| `alpine`     | 基于Alpine系统，体积更小                                             | [Dockerfile-alpine](https://github.com/jmcombs/sftp/blob/master/Dockerfile-alpine) |


## 核心功能与特性

1. **多协议支持**：兼容SFTP（SSH文件传输协议）和SCP（安全复制协议），基于OpenSSH实现。  
2. **灵活的用户管理**：支持通过命令参数、环境变量或配置文件定义用户，支持密码加密和SSH密钥登录。  
3. **权限控制**：可自定义用户UID/GID，确保挂载卷的权限与主机文件系统一致。  
4. **数据持久化**：支持卷挂载，用户主目录可映射至主机目录或Docker卷，确保数据持久化。  
5. **安全增强**：支持自定义SSH主机密钥，避免容器重建导致的MITM警告；支持只读挂载和目录权限控制。  
6. **自定义扩展**：可通过`/etc/sftp.d/`目录执行自定义启动脚本，实现高级配置（如绑定挂载、权限调整等）。  
7. **多平台支持**：适配多种架构，满足不同环境需求。  


## 适用场景

- **开发/测试环境**：本地或服务器间的文件传输与共享。  
- **多用户文件共享**：为不同用户配置隔离的文件空间，支持读写权限控制。  
- **自动化备份**：作为SCP/SFTP服务端接收自动备份数据。  
- **CI/CD流水线**：在构建流程中传输构建产物或配置文件。  


## 使用方法与配置说明

### 用户配置

用户可通过以下三种方式定义，语法格式为：  
`user:pass[:e][:uid[:gid[:dir1[,dir2]...]]]`  

| 参数   | 说明                                                                 |
|--------|----------------------------------------------------------------------|
| `user` | 用户名（必填）                                                       |
| `pass` | 密码（明文或加密，若加密需添加`:e`标记）                             |
| `e`    | 可选，标记密码为加密格式（如使用`crypt`生成的哈希）                   |
| `uid`  | 可选，用户ID（自定义以匹配主机文件权限）                             |
| `gid`  | 可选，组ID                                                           |
| `dir`  | 可选，用户主目录下的子目录列表（自动创建，具有写权限）               |

**示例**：`foo:pass:1001:100:upload,docs` 表示用户`foo`，密码`pass`，UID=1001，GID=100，自动创建`upload`和`docs`子目录。


### 配置方式

#### 1. 命令参数定义用户  
直接在启动命令中指定用户，多个用户用空格分隔：  
```bash
docker run ... jmcombs/sftp "user1:pass1:1001" "user2:pass2:1002:100:data"
```

#### 2. 环境变量定义用户  
通过`SFTP_USERS`环境变量传入用户配置：  
```bash
docker run -e SFTP_USERS="user1:pass1:1001 user2:pass2:1002" ... jmcombs/sftp
```

#### 3. 配置文件定义用户  
挂载包含用户配置的文件至`/etc/sftp/users.conf`（只读权限）：  
```bash
docker run -v /host/users.conf:/etc/sftp/users.conf:ro ... jmcombs/sftp
```  
配置文件格式（每行一个用户）：  
```ini
user1:pass1:1001:100:upload  # 用户1：密码明文，UID=1001，GID=100，创建upload目录
user2:$1$xyz$abc:e:1002      # 用户2：密码加密（带:e标记），UID=1002
```


### 卷挂载注意事项

- **用户目录隔离**：用户被chroot限制在其主目录（`/home/<user>`），需通过子目录实现文件上传（用户无法直接在主目录创建文件）。  
- **权限匹配**：若需修改主机文件系统权限，需手动指定用户UID/GID（与主机一致）。  
- **SSH主机密钥**：为避免容器重建导致的主机指纹变化，建议挂载自定义密钥文件（`/etc/ssh/ssh_host_*`）。  


## 部署示例

### 1. 最简单示例  
创建用户`foo`（密码`pass`），自动生成`upload`目录，映射容器22端口至主机22端口：  
```bash
docker run -p 22:22 -d docker.xuanyuan.run/jmcombs/sftp foo:pass:::upload
```


### 2. 共享主机目录（含Docker Compose）  
将主机目录挂载至用户`foo`的`upload`子目录，指定UID=1001以匹配主机权限：  

#### Docker命令：  
```bash
docker run \
  -v /host/upload:/home/foo/upload \  # 挂载主机目录至用户子目录
  -p 2222:22 \                        # 主机2222端口映射容器22端口
  -d jmcombs/sftp \
  foo:pass:1001                       # 用户配置：用户名foo，密码pass，UID=1001
```

#### Docker Compose配置：  
```yaml
version: "3"
services:
  sftp:
    image: docker.xuanyuan.run/jmcombs/sftp
    volumes:
      - /host/upload:/home/foo/upload  # 挂载主机目录
    ports:
      - "2222:22"                      # 端口映射
    command: foo:pass:1001             # 用户配置
```

**登录方式**：使用SFTP客户端连接主机2222端口：  
```bash
sftp -P 2222 foo@<主机IP>
```


### 3. 通过配置文件管理多用户  
挂载用户配置文件，批量定义用户：  

1. 主机创建`users.conf`：  
```ini
foo:123:1001:100:data  # 用户foo，密码123，UID=1001，GID=100，创建data目录
bar:456:1002:100:docs  # 用户bar，密码456，UID=1002，GID=100，创建docs目录
```

2. 启动容器：  
```bash
docker run \
  -v /host/users.conf:/etc/sftp/users.conf:ro \  # 挂载配置文件（只读）
  -v sftp_data:/home \                           # 挂载卷存储用户数据
  -p 2222:22 -d jmcombs/sftp
```


### 4. 加密密码登录  
使用加密密码（需添加`:e`标记），避免明文传输：  

1. 生成加密密码（使用Python `crypt`模块）：  
```bash
docker run --rm docker.xuanyuan.run/python:alpine python -c "import crypt; print(crypt.crypt('YOUR_PASSWORD'))"
```  
输出示例：`$1$0G2g0GSt$ewU0t6GXG15.0hWoOX8X9.`

2. 启动容器（使用单引号包裹加密密码）：  
```bash
docker run \
  -v /host/share:/home/foo/share \
  -p 2222:22 -d docker.xuanyuan.run/jmcombs/sftp \
  'foo:$1$0G2g0GSt$ewU0t6GXG15.0hWoOX8X9.:e:1001'  # :e标记表示密码已加密
```


### 5. SSH密钥登录（无密码）  
挂载公钥文件至用户`.ssh/keys/`目录，自动添加至`authorized_keys`：  

```bash
docker run \
  -v /host/id_rsa.pub:/home/foo/.ssh/keys/id_rsa.pub:ro \  # 挂载公钥
  -v /host/share:/home/foo/share \
  -p 2222:22 -d jmcombs/sftp \
  foo::1001  # 密码留空（仅允许密钥登录），UID=1001
```


### 6. 自定义SSH主机密钥  
挂载自定义主机密钥，避免容器重建导致指纹变化：  

1. 生成主机密钥：  
```bash
ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null  # ED25519密钥
ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null   # RSA密钥
```

2. 启动容器时挂载密钥：  
```bash
docker run \
  -v /host/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key \
  -v /host/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key \
  -v /host/share:/home/foo/share \
  -p 2222:22 -d docker.xuanyuan.run/jmcombs/sftp \
  foo::1001
```


### 7. 执行自定义启动脚本  
将脚本挂载至`/etc/sftp.d/`目录，容器启动时自动执行（如绑定挂载目录）：  

1. 创建脚本`/host/sftp.d/bindmount.sh`：  
```bash
#!/bin/bash
# 绑定挂载示例：将/data/common共享至多个用户目录

function bindmount() {
  mkdir -p "$2"
  mount --bind "$1" "$2"  # 绑定挂载源目录至目标目录
}

bindmount /data/common /home/dave/common  # 用户dave的common目录
bindmount /data/common /home/peter/common # 用户peter的common目录
bindmount /data/docs /home/peter/docs --read-only  # 只读挂载docs目录
```

2. 启动容器（需添加`CAP_SYS_ADMIN`权限）：  
```bash
docker run \
  --cap-add=CAP_SYS_ADMIN \  # 允许mount系统调用
  -v /host/sftp.d:/etc/sftp.d:ro \  # 挂载脚本目录
  -v /data:/data \  # 挂载源数据目录
  -p 2222:22 -d jmcombs/sftp \
  dave::1001 peter::1002  # 创建用户dave和peter
```


## Debian与Alpine版本差异

| 特性         | Debian版本                  | Alpine版本                    |
|--------------|-----------------------------|-------------------------------|
| 镜像大小     | 较大（约200MB）             | 极小（约20MB，小10倍）        |
| OpenSSH版本  | 稳定，仅包含安全修复和bugfix | 版本更新较快（6个月发布周期）  |
| 适用场景     | 稳定性优先的生产环境        | 资源受限环境（如边缘设备）     |


## OpenSSH版本说明

OpenSSH版本取决于基础镜像的包管理系统：  
- **Debian**：版本由Debian官方维护，注重稳定性，仅更新安全补丁。  
- **Alpine**：版本随Alpine滚动更新，可能包含较新功能。  

可通过以下链接查询具体版本：  
- [Alpine OpenSSH包列表](https://pkgs.alpinelinux.org/packages?name=openssh&branch=&repo=main&arch=x86_64)  
- [Debian OpenSSH Server包列表](https://packages.debian.org/search?keywords=openssh-server&searchon=names&exact=1&suite=all&section=main)  


## 每日构建

镜像每日自动构建，确保集成基础镜像和OpenSSH的最新安全更新。

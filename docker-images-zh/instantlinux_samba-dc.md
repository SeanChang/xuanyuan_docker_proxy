---
image: instantlinux/samba-dc
description: "这是一个Samba域控制器Docker镜像，支持域的创建（provision）和加入（join），需配置静态IP和持久化卷，运行于host网络模式并具备CAP_SYS_ADMIN权限，适用于构建Active Directory环境，提供域管理、DNS服务及用户认证功能。"
source: https://xuanyuan.cloud/zh/r/instantlinux/samba-dc
canonical: https://xuanyuan.cloud/zh/r/instantlinux/samba-dc
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/instantlinux/samba-dc" title="instantlinux/samba-dc Docker 镜像中文简介、标签列表与拉取命令">instantlinux/samba-dc 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## samba-dc
[![](https://img.shields.io/docker/v/instantlinux/samba-dc?sort=date)](https://hub.docker.com/r/instantlinux/samba-dc/tags "版本徽章") [![](https://img.shields.io/docker/image-size/instantlinux/samba-dc?sort=date)](https://github.com/instantlinux/docker-tools/tree/main/images/samba-dc "镜像大小徽章") ![](https://img.shields.io/badge/platform-amd64%20arm64%20arm%2Fv6%20arm%2Fv7-blue "平台支持徽章") [![](https://img.shields.io/badge/dockerfile-latest-blue)](https://gitlab.com/instantlinux/docker-tools/-/blob/main/images/samba/Dockerfile "Dockerfile链接")

### 镜像概述和主要用途
samba-dc是一个Samba域控制器Docker镜像，用于搭建Active Directory（AD）环境。它支持域的初始化创建（provision）和加入现有域（join），提供域管理、用户认证、DNS服务等核心功能。该镜像需配置静态IP和持久化DNS记录，运行于host网络模式并具备CAP_SYS_ADMIN权限，适用于企业内部网络的域环境构建。

### 核心功能和特性
- **域操作支持**：支持域初始化创建（provision）和加入现有域（join），可作为独立域控制器或辅助域控制器
- **网络与权限**：需运行于host网络模式，具备CAP_SYS_ADMIN权限，确保网络协议栈和系统资源访问
- **持久化存储**：需挂载`/etc/samba`和`/var/lib/samba`作为持久化卷，保存域配置和数据
- **灵活配置**：支持通过环境变量设置常用参数，或通过`/etc/samba/conf.d`目录下的配置文件进行高级自定义
- **多平台支持**：兼容amd64、arm64、arm/v6、arm/v7等架构
- **DNS服务**：集成DNS服务，支持DNS更新、转发器配置，满足域环境的名称解析需求

### 使用场景和适用范围
- 企业内部Active Directory域环境搭建
- 替代Windows Server域控制器，降低部署成本
- 与Windows客户端（如Windows 7）和其他Samba域控制器集成
- 需集中管理用户、权限和文件共享的网络环境

### 使用方法和配置说明

#### 基本要求
- 域控制器必须配置静态IP地址和持久化DNS记录
- 容器需运行于`network_mode:host`模式，并添加`cap_add:CAP_SYS_ADMIN`权限
- 必须指定`NETBIOS_NAME`或主机名作为NETBIOS名称
- 需挂载`/etc/samba`和`/var/lib/samba`作为持久化卷（首次运行时`/var/lib/samba`为空将触发`DOMAIN_ACTION`指定的操作）

#### 环境变量配置
| 变量 | 默认值 | 描述 |
|------|--------|------|
| ADMIN_PASSWORD_SECRET | samba-admin-password | 管理员密码密钥名称（见下方"Secrets"部分） |
| ALLOW_DNS_UPDATES | secure | 启用DNS更新（取值：secure、nonsecure、no） |
| BIND_INTERFACES_ONLY | yes | 是否仅绑定指定IP地址或接口 |
| DNS_FORWARDER | (none) | `smb.conf`中`dns forwarder`配置值 |
| DOMAIN_ACTION | provision | 域操作类型（provision：创建域；join：加入域） |
| DOMAIN_LOGONS | yes | 是否支持工作组登录 |
| DOMAIN_MASTER | no | WAN范围浏览列表整理（详见[samba文档](https://www.samba.org/samba/docs/man/manpages-3/smb.conf.5.html)） |
| INTERFACES | lo eth0 | IP地址或接口列表 |
| LOG_LEVEL | 1 | 日志详细程度（数值越高日志越详细） |
| MODEL | standard | 进程模型（single：单进程；standard：标准；thread：线程） |
| NETBIOS_NAME | (hostname -s) | NETBIOS名称 |
| REALM | ad.example.com | AD DNS域（使用小写字母） |
| SERVER_STRING | Samba Domain Controller | 服务器标识字符串 |
| TZ | UTC | 本地时区 |
| WINBIND_USE_DEFAULT_DOMAIN | yes | 是否允许用户名不带域名前缀 |
| WORKGROUP | AD | 工作组（域前缀，文档较少） |

#### Secrets配置
仅在首次运行（域创建或加入）时需要，**请勿在其他时间保留域控制器管理员密钥**。密钥为Docker Secret，包含初始Samba管理员密码（需足够复杂）。

| 密钥 | 描述 |
|------|------|
| samba-admin-password | 域管理员密码 |

Secrets可通过Kubernetes Secrets、文件（详见示例[docker-compose.yml](https://github.com/instantlinux/docker-tools/blob/main/images/samba-dc/docker-compose.yml)）或Swarm Secrets指定。

#### 部署示例

##### Docker Run命令
```bash
docker run -d \
  --name samba-dc \
  --network=host \
  --cap-add=CAP_SYS_ADMIN \
  -v /path/to/etc/samba:/etc/samba \
  -v /path/to/var/lib/samba:/var/lib/samba \
  -e REALM=ad.example.com \
  -e WORKGROUP=AD \
  -e NETBIOS_NAME=DC01 \
  -e DOMAIN_ACTION=provision \
  -e TZ=Asia/Shanghai \
  --secret docker.xuanyuan.run/samba-admin-password \
  instantlinux/samba-dc
```

##### Docker Compose配置（示例片段）
```yaml
version: '3.8'
services:
  samba-dc:
    image: docker.xuanyuan.run/instantlinux/samba-dc
    network_mode: host
    cap_add:
      - CAP_SYS_ADMIN
    volumes:
      - /path/to/etc/samba:/etc/samba
      - /path/to/var/lib/samba:/var/lib/samba
    environment:
      - REALM=ad.example.com
      - WORKGROUP=AD
      - NETBIOS_NAME=DC01
      - DOMAIN_ACTION=provision
      - TZ=Asia/Shanghai
    secrets:
      - samba-admin-password
    restart: always

secrets:
  samba-admin-password:
    file: ./samba-admin-password.txt
```

### 状态说明
- "join"命令已在Windows Server 2008 Active Directory和其他Samba4域控制器上测试通过
- "provision"已在Windows 7客户端环境中作为Samba4域控制器测试通过
- "BIND_INTERFACES_ONLY"选项当前可用
- 多实例samba-dc复制功能存在困难（版本4.8.8及以上未解决，未来版本可能修复）

### 注意事项
#### DNS配置
首次创建域控制器后需手动添加DNS记录：
```bash
export LDB_MODULES_PATH=/usr/lib/samba/ldb
ldbsearch -H /var/lib/samba/private/sam.ldb '(invocationid=*)' \
 --cross-ncs objectguid|grep -i -B 1 -A 1 <新DC主机名>
samba-tool dns add dc01 _msdcs.ether.ci.net <上述命令获取的GUID> \
 CNAME <新DC的FQDN> -UAdministrator
```

#### 复制问题排查
- 若与旧版本Samba存在LDAP SASL复制错误，在`/etc/samba/conf.d/0global.conf`中添加：
  ```
  ldap server require strong auth = no
  ```
- 检查复制状态：`samba-tool drs showrepl`
- 检查本地数据库：`samba-tool dbcheck`、`samba-tool drs kcc`
- 双向复制测试（替换`<NC>`为`drs showrepl`输出中的命名上下文）：
  ```bash
  samba-tool drs replicate dc1 dc2 dc=<foo>,dc=<suffix> --full-sync
  samba-tool drs replicate dc2 dc1 dc=<foo>,dc=<suffix> --full-sync
  ```

#### DNS记录管理
使用`nslookup`或`host`验证DC的FQDN DNS记录（应仅包含一个正确IP），添加/删除记录：
```bash
samba-tool dns add <dc> <domain> <dc> A <ip> -Uadministrator
samba-tool dns delete <dc> <domain> <dc> A <ip> -Uadministrator
```

#### 其他常见问题
- 日志中出现"samba_dnsupdate tsig verify failure"：在每个控制器上执行`samba_dnsupdate --all-names --use-samba-tool`
- 域加入失败提示"LDAP error 10 LDAP_REFERRAL"：清理所有域控制器上的 stale DNS记录：
  ```bash
  for DC in dc1 dc2 dc3; do
    samba-tool dns delete $DC _msdcs.<domain> <错误中的GUID> CNAME <主机> -Uadministrator
  done
  ```
- 清理secondary DC复制状态：关闭secondary DC，清空`/var/lib/samba/private`卷，在primary DC执行：
  ```bash
  samba-tool domain demote --remove-other-dead-server=<badhost>
  samba-tool dbcheck --cross-ncs --fix
  ```
  然后重启secondary DC并设置`DOMAIN_ACTION=join`

### 贡献指南
如需改进此镜像，请参考[CONTRIBUTING](https://github.com/instantlinux/docker-tools/blob/main/CONTRIBUTING.md)。

[![](https://img.shields.io/badge/license-GPL--3.0-red.svg)](https://choosealicense.com/licenses/gpl-3.0/ "许可证徽章") [![](https://img.shields.io/badge/code-samba_team%2Fsamba-blue.svg)](https://gitlab.com/samba-team/samba "代码仓库")

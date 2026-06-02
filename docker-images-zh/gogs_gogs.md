---
image: gogs/gogs
description: "Gogs是一款轻松便捷的自托管Git服务，它采用Go语言开发，具有轻量级特性，部署简单且资源占用低，适合个人开发者或小型团队搭建私有代码仓库，支持仓库管理、用户权限控制、分支管理等Git核心功能，能够帮助用户轻松实现代码的版本控制与协作管理，无需复杂配置即可快速上手使用。"
source: https://xuanyuan.cloud/zh/r/gogs/gogs
canonical: https://xuanyuan.cloud/zh/r/gogs/gogs
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [gogs/gogs — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/gogs/gogs)

含镜像标签、拉取命令、部署文档与相关推荐。

[gogs/gogs Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/gogs/gogs)

# Docker 部署 Gogs


## 基本说明
Gogs 项目详情可参考 [GitHub 仓库]([])。


## 使用方法

为避免数据存放在容器内，建议将数据目录挂载到宿主机（示例中使用 `/var/gogs` 映射容器内 `/data`），可根据实际情况调整路径。


### 基础部署步骤
```sh
# 拉取镜像
$ docker pull gogs/gogs

# 创建宿主机数据目录
$ mkdir -p /var/gogs

# 首次运行容器（端口映射：宿主机10022→容器22，宿主机10880→容器3000；数据挂载）
$ docker run --name=gogs -p 10022:22 -p 10880:3000 -v /var/gogs:/data gogs/gogs

# 若容器已停止，重新启动
$ docker start gogs
```

**注意**：  
- 需将容器内 SSH 服务端口映射到宿主机，并在首次配置 Gogs 时正确设置 SSH 端口和访问地址。  
- 按上述配置，克隆仓库的命令示例：`git clone ssh://git@hostname:10022/username/myrepo.git`。  


### 数据目录结构
宿主机 `/var/gogs` 目录存储 Git 仓库和 Gogs 数据，结构如下：
```
/var/gogs
├── git
│   └── gogs-repositories  # Git 仓库存储目录
├── ssh                    # Gogs SSH 密钥文件
└── gogs                   # Gogs 配置、数据及日志
    ├── conf               # 配置文件
    ├── data               # 应用数据
    └── log                # 日志文件
```


### 自定义目录说明
Docker 环境下，宿主机 `/var/gogs/gogs` 目录对应容器内 `/data/gogs` 目录，此目录即 Gogs 的「custom」目录。无需额外创建层级，直接编辑该目录下的文件即可完成自定义配置。


### 使用 Docker 卷存储数据
除本地目录挂载外，也可使用 Docker 卷持久化数据：
```sh
# 创建 Docker 卷
$ docker volume create --name gogs-data

# 首次运行容器（使用卷挂载数据）
$ docker run --name=gogs -p 10022:22 -p 10880:3000 -v gogs-data:/data gogs/gogs
```


## 配置说明


### 应用基本配置
多数配置项直观易懂，以下为 Docker 环境中需特别注意的项：

- **仓库根路径（Repository Root Path）**：保持默认 `/home/git/gogs-repositories`，`start.sh` 已自动创建符号链接。  
- **运行用户（Run User）**：保持默认 `git`，`finalize.sh` 已预先配置该用户。  
- **域名（Domain）**：填写 Docker 容器 IP（如 `192.168.99.100`）；若需从其他物理机访问，填写宿主机的域名或 IP。  
- **SSH 端口（SSH Port）**：填写宿主机暴露的端口。例如容器内 SSH 监听 22，宿主机映射为 10022:22，则此处填 `10022`。**不推荐在 Docker 容器内使用内置 SSH 服务器**。  
- **HTTP 端口（HTTP Port）**：填写容器内 Gogs 监听端口（默认 3000），与宿主机映射端口无关（如宿主机映射 10880:3000，此处仍填 `3000`）。  
- **应用 URL（Application URL）**：组合域名和宿主机暴露的 HTTP 端口（如 `[]  

完整配置文档见 [Gogs 官方文档]([])。


### 容器环境变量选项
可通过环境变量配置容器功能，以下为常用选项：

#### SOCAT_LINK  
- **可选值**：`true`/`false`/`1`/`0`  
- **默认值**：`true`  
- **作用**：通过 socat 将链接容器的端口绑定到本地 socket，链接容器暴露的所有端口会映射到本地对应端口。  
- **注意**：在 Rancher、Kubernetes 等管理环境中需禁用（设为 `0` 或 `false`），因依赖 Docker 链接容器时生成的环境变量。


#### RUN_CROND  
- **可选值**：`true`/`false`/`1`/`0`  
- **默认值**：`false`  
- **作用**：启用容器内 crond 服务。默认定期运行 `/etc/periodic/${period}` 下的脚本，自定义定时任务可添加到 `/var/spool/cron/crontabs/`。


#### 备份相关变量（需配合 RUN_CROND=true 使用）  
- **BACKUP_INTERVAL**：备份间隔，支持小时（h）、天（d）、月（M），如 `3h`（每 3 小时）、`7d`（每 7 天），最小值为 `1h`。默认 `null`（不启用）。  
- **BACKUP_RETENTION**：备份保留时间，支持分钟（m）、天（d），如 `360m`（6 小时）、`2d`（2 天），最小值为 `60m`。默认 `7d`。  
- **BACKUP_ARG_CONFIG**：指定 `gogs backup` 的 `--config` 参数路径，如 `/app/gogs/example/custom/config`。默认 `null`。  
- **BACKUP_ARG_EXCLUDE_REPOS**：指定 `gogs backup` 的 `--exclude-repos` 参数，排除无需备份的仓库，如 `test-repo1,test-repo2`。默认 `null`。  


## 备份系统
启用自动备份需同时设置 `RUN_CROND=true` 和 `BACKUP_INTERVAL`：  
- `BACKUP_INTERVAL` 控制备份频率，`BACKUP_RETENTION` 控制旧备份自动删除策略。  


## 升级步骤
⚠️ **务必确保数据卷已挂载到容器外** ⚠️  

1. 拉取最新镜像：`docker pull gogs/gogs`  
2. 停止旧容器：`docker stop gogs`  
3. 删除旧容器：`docker rm gogs`  
4. 按首次部署步骤重新创建容器（保持相同的端口映射和数据卷挂载）。  


## 已知问题
- 无法在 Raspberry 1（armv6l）上构建容器，因基础镜像 `alpine` 未提供该平台的 `go` 包。  


## 参考链接
- [在 Docker 内的 Gogs 与本地系统共享 22 端口的方法]([])

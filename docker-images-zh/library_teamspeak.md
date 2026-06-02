---
image: library/teamspeak
description: "TeamSpeak 是一款通过互联网实现高质量语音通信的软件，广泛应用于团队协作、游戏联机、远程会议等场景，凭借出色的语音清晰度、稳定的连接性能以及对多人实时互动的支持，帮助用户跨越网络距离，实现高效顺畅的语音交流。"
source: https://xuanyuan.cloud/zh/r/library/teamspeak
canonical: https://xuanyuan.cloud/zh/r/library/teamspeak
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [library/teamspeak — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/teamspeak)

含镜像标签、拉取命令、部署文档与相关推荐。

[library/teamspeak Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/library/teamspeak)

# TeamSpeak Docker 镜像使用指南


## 快速参考

### 维护者  
TeamSpeak 开发团队：[nwerensteijn]([]) 和 [muenchow]([])  


### 获取帮助  
可通过以下渠道获取支持：  
- [Docker 社区 Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


### 问题反馈  
若遇到问题，可在 [GitHub 仓库]([]) 提交。  


### 支持架构  
无支持架构  


### 镜像信息  
- **镜像元数据**：可查看 [repo-info 仓库的 teamspeak 目录]([])（含传输大小等）。  
- **镜像更新**：通过 [official-images 仓库的 library/teamspeak 标签]([]) 或 [文件历史]([]) 追踪。  


## 什么是 TeamSpeak？  
TeamSpeak 提供适用于在线游戏、教育训练、企业内部沟通及亲友联系的语音通信解决方案。其核心优势在于易用性高、安全性强、语音质量优，且系统资源和带宽占用低。  

> 官网：[teamspeak.com]([])  


## 如何使用此镜像  

### 查看许可协议  
运行以下命令查看 TeamSpeak 许可协议：  
```console
$ docker run -e TS3SERVER_LICENSE=view teamspeak
```  


### 启动 TeamSpeak 服务器  
需接受许可协议并映射端口至主机，命令如下：  
```console
$ docker run -p 9987:9987/udp -p 10011:10011 -p 30033:30033 -e TS3SERVER_LICENSE=accept teamspeak
```  
启动后，可通过 TeamSpeak 客户端连接 `localhost`。**请记录生成的服务器查询密码和管理员权限密钥**，用于服务器管理。  


### 容器 Shell 访问  
使用 `docker exec` 进入容器内部：  
```console
$ docker exec -it some-teamspeak sh  # "some-teamspeak" 为容器名称
```  
查看服务器日志：  
```console
$ docker logs some-teamspeak
```  


### 使用 docker compose  
以下是 `compose.yaml` 示例，需配合 MariaDB 数据库使用：  
```yaml
services:
  teamspeak:
    image: teamspeak
    restart: always
    ports:
      - 9987:9987/udp  # 语音通信端口
      - 10011:10011    # ServerQuery 端口
      - 30033:30033    # 文件传输端口
    environment:
      TS3SERVER_DB_PLUGIN: ts3db_mariadb  # 使用 MariaDB 数据库
      TS3SERVER_DB_SQLCREATEPATH: create_mariadb  # 数据库初始化脚本路径
      TS3SERVER_DB_HOST: db  # 数据库主机（对应下方 db 服务）
      TS3SERVER_DB_USER: root  # 数据库用户名
      TS3SERVER_DB_PASSWORD: example  # 数据库密码
      TS3SERVER_DB_NAME: teamspeak  # 数据库名称
      TS3SERVER_DB_WAITUNTILREADY: 30  # 等待数据库就绪时间（秒）
      TS3SERVER_LICENSE: accept  # 接受许可协议
  db:
    image: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example  # MariaDB  root 密码
      MYSQL_DATABASE: teamspeak  # 自动创建数据库
```  
执行 `docker compose up` 启动服务，通过客户端连接 `localhost:9987` 或服务器 IP 即可。  


## 环境变量配置  
启动容器时，可通过环境变量调整服务器配置，常用变量如下：  

### 基础配置  
- **TS3SERVER_LICENSEPATH**：指定 `licensekey.dat` 的查找目录，默认 `/var/ts3server/`。  
- **TS3SERVER_LICENSE**：必须设置为 `accept` 以启动服务器，或 `view` 查看许可。  


### 数据库配置  
- **TS3SERVER_DB_PLUGIN**：数据库类型（如 `ts3db_mariadb` 对应 MariaDB）。  
- **TS3SERVER_DB_SQLCREATEPATH**：数据库初始化脚本路径（相对于 `TS3SERVER_DB_SQLPATH`，默认 `/opt/ts3server/sql/`）。  
- **TS3SERVER_DB_CONNECTIONS**：数据库最大并发连接数（2-100，默认 10）。  


### 日志与查询配置  
- **TS3SERVER_LOG_PATH**：日志文件存储目录，默认 `/var/ts3server/logs/`。  
- **TS3SERVER_LOG_QUERY_COMMANDS**：设为 `1` 记录所有查询命令（可能导致日志过大，建议默认 `0`）。  
- **TS3SERVER_QUERY_PROTOCOLS**：ServerQuery 支持的协议（`raw` 对应 10011/tcp，`ssh` 对应 10022/tcp，逗号分隔，留空则禁用）。  


## 注意事项  

### 插入许可证文件  
若需使用超过 1 个虚拟服务器或 32 人插槽，需挂载 `licensekey.dat`：  
```console
$ docker run --name some-teamspeak -v /本地路径/licensekey.dat:/var/ts3server/licensekey.dat teamspeak:tag
```  
若已挂载数据目录（见下文），可将 `licensekey.dat` 复制到挂载目录，重启容器即可生效。  


### 数据持久化存储  
为避免容器删除导致数据丢失，需挂载数据目录至主机：  
1. 在主机创建目录，如 `/my/own/datadir`。  
2. 启动容器时挂载该目录：  
```console
$ docker run --name some-teamspeak -v /my/own/datadir:/var/ts3server/ -d teamspeak:tag
```  
TeamSpeak 会将数据（配置、日志等）保存在 `/var/ts3server/`，挂载后数据持久化至主机目录。  


## 许可证信息  
- 镜像中软件的许可协议见 [GitHub 仓库]([])。  
- 镜像可能包含其他软件（如基础系统工具），其许可需用户自行确认合规性。  

使用前请确保遵守所有包含软件的许可协议。

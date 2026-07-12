---
image: thingsboard/tb-postgres
description: "单实例的ThingsBoard物联网平台搭配PostgreSQL数据库，其中ThingsBoard作为开源物联网解决方案，可实现设备连接、数据采集、实时处理与可视化监控等核心功能，而PostgreSQL作为强大的开源关系型数据库，具备高稳定性、数据完整性及复杂查询支持，二者结合为中小型物联网项目提供高效、可靠的数据管理与应用支撑环境。"
source: https://xuanyuan.cloud/zh/r/thingsboard/tb-postgres
canonical: https://xuanyuan.cloud/zh/r/thingsboard/tb-postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/thingsboard/tb-postgres" title="thingsboard/tb-postgres Docker 镜像中文简介、标签列表与拉取命令">thingsboard/tb-postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ThingsBoard 简介  

ThingsBoard 是一款开源物联网平台，主要用于数据收集、处理、可视化及设备管理。  


## 文档  

ThingsBoard 官方文档托管于 [thingsboard.io] 。  

[![智能计量演示]([] "智能计量演示")]   


## 运行  

### 准备工作  
启动 Docker 容器前，需先创建数据和日志存储目录，并修改目录所有者（需 sudo 权限，执行时会请求密码）：  
```bash  
$ mkdir -p ~/.mytb-data && sudo chown -R 799:799 ~/.mytb-data  
$ mkdir -p ~/.mytb-logs && sudo chown -R 799:799 ~/.mytb-logs  
```  


### 启动容器  
直接执行以下命令运行 Docker 容器：  
```bash  
$ docker run -it -p 9090:9090 -p 1883:1883 -p 7070:7070 -p 5683-5688:5683-5688/udp -v ~/.mytb-data:/data -v ~/.mytb-logs:/var/log/thingsboard --name mytb --restart always thingsboard/tb-postgres  
```  

#### 各参数说明：  
- `docker run`：运行容器  
- `-it`：附加终端会话，实时显示 ThingsBoard 进程输出  
- `-p 9090:9090`：本地 9090 端口映射到容器内部 HTTP 端口 9090  
- `-p 1883:1883`：本地 1883 端口映射到容器内部 MQTT 端口 1883  
- `-p 7070:7070`：本地 7070 端口映射到容器内部 Edge RPC 端口 7070  
- `-p 5683-5688:5683-5688/udp`：本地 UDP 端口 5683-5688 映射到容器内部 COAP 和 LwM2M 端口  
- `-v ~/.mytb-data:/data`：将主机目录 `~/.mytb-data` 挂载到 ThingsBoard 数据库数据目录  
- `-v ~/.mytb-logs:/var/log/thingsboard`：将主机目录 `~/.mytb-logs` 挂载到 ThingsBoard 日志目录  
- `--name mytb`：容器本地友好名称  
- `--restart always`：系统重启或容器故障时自动重启  


### 访问与登录  
执行上述命令后，在浏览器中打开 `[]}:9090`，即可看到登录页面。默认凭据如下：  
- **系统管理员**：[邮箱已删除] / sysadmin  
- **租户管理员**：[邮箱已删除] / tenant  
- **客户用户**：[邮箱已删除] / customer  

（登录后可在账号 profile 页面修改密码。）  


### 容器管理  
- **分离终端会话**：按 `Ctrl-p` + `Ctrl-q`，容器将在后台继续运行  
- **重新附加会话（查看日志）**：  
  ```bash  
  $ docker attach mytb  
  ```  
- **停止容器**：  
  ```bash  
  $ docker stop mytb  
  ```  
- **启动容器**：  
  ```bash  
  $ docker start mytb  
  ```  


## 升级  
如需更新到最新镜像，执行以下命令：  
```bash  
$ docker pull docker.xuanyuan.run/thingsboard/tb-postgres  
$ docker stop mytb  
$ docker run -it -v ~/.mytb-data:/data --rm thingsboard/tb-postgres upgrade-tb.sh  
$ docker rm mytb  
$ docker run -it -p 9090:9090 -p 1883:1883 -p 7070:7070 -p 5683-5688:5683-5688/udp -v ~/.mytb-data:/data -v ~/.mytb-logs:/var/log/thingsboard --name mytb --restart always thingsboard/tb-postgres  
```  

**注意**：请将命令中的 `~/.mytb-data` 替换为容器创建时实际使用的主机目录。

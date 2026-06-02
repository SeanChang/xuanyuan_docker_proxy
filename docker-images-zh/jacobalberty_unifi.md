---
image: jacobalberty/unifi
description: "UniFi无线接入点控制器是一款用于集中管理多台无线接入点的网络管理工具，可实现AP部署配置、用户接入控制、网络状态实时监控、流量数据分析、安全策略制定实施及固件统一更新等功能，支持远程管理与无缝漫游，能有效优化网络性能，助力构建稳定、高效、安全的企业级无线网络环境。"
source: https://xuanyuan.cloud/zh/r/jacobalberty/unifi
canonical: https://xuanyuan.cloud/zh/r/jacobalberty/unifi
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jacobalberty/unifi" title="jacobalberty/unifi Docker 镜像中文简介、标签列表与拉取命令">jacobalberty/unifi — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jacobalberty/unifi" title="jacobalberty/unifi Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jacobalberty/unifi</a>

# Unifi-in-Docker (unifi-docker)  
这是Ubiquiti Networks Unifi Controller的Docker化版本。  


## 为什么需要它？  
用Docker部署Unifi Controller，能省去版本兼容、Java依赖或操作系统更新的麻烦——容器把所有组件打包成一个经过充分测试的整体。安装只需几行命令，升级时停掉旧容器、启动新容器即可，就是这么简单。  

该容器已在Ubuntu、Debian、macOS、Windows甚至树莓派上测试通过。  


## 当前信息  
最新“稳定版”为Unifi Controller 7.1.68，目前无影响该版本的热修复或CVE安全警告。  


## 安装、运行、停止与升级  

### 前提：安装Docker  
先在“Docker主机”（运行Docker和Unifi Controller的机器）上安装Docker。可参考网上的安装指南，Windows用户可查看[微软Docker安装教程]([])。  


### 第一步：创建目录（一次性操作）  
在Docker主机上创建`unifi`目录，并在其中新建`data`和`log`子目录，用于存储配置和日志：  
```bash
cd  # 默认使用当前用户的家目录
mkdir -p unifi/data
mkdir -p unifi/log
```  
*注：本文默认Linux/Unix/macOS用户使用家目录存放`unifi`目录。若需自定义路径，可参考下文“命令行选项”调整。*  


### 第二步：启动Unifi容器  
每次启动Unifi时，执行以下命令（各参数说明见下文“命令行选项”）：  
```bash
docker run -d --init \
   --restart=unless-stopped \
   -p 8080:8080 -p 8443:8443 -p 3478:3478/udp \
   -e TZ='Africa/Johannesburg' \
   -v ~/unifi:/unifi \
   --user unifi \
   --name unifi \
   jacobalberty/unifi
```  

等待1-2分钟（Unifi Controller启动后），访问`[]  


#### 启动注意事项  
1. **证书警告**：首次访问时浏览器会提示“不受信任的证书”，确认Docker主机地址正确后，同意继续连接。  
2. **设置“Inform Host”IP**：Unifi设备需要通过Docker主机的IP找到控制器，需按下文“设备接入”步骤配置。  


### 第三步：停止容器  
如需修改启动参数，先停止并删除容器，再用新参数重新运行（`docker rm`仅删除容器名称，无需重建）：  
```bash
docker stop unifi
docker rm unifi
```  


### 第四步：升级Unifi Controller  
Unifi的配置和数据默认保存在Docker主机的`~/unifi`目录（容器内无数据留存）。升级只需拉取新版本容器，复用本地配置：  
1. **务必备份**：将配置备份到其他设备（每次升级必做）。  
2. 按上述步骤停止当前容器。  
3. 用新版本标签重新执行`docker run`命令（标签说明见下文“支持的标签”）。  


## 命令行选项说明  
`docker run`命令的关键参数如下：  

| 参数 | 说明 |  
|------|------|  
| `-d` | 后台运行模式 |  
| `--init` | 推荐添加，确保进程退出后被正确回收 |  
| `--restart=unless-stopped` | 容器意外停止时自动重启（手动停止除外） |  
| `-p 8080:8080 ...` | 端口映射，`8080/tcp`（设备控制）、`8443/tcp`（Web界面）、`3478/udp`（STUN服务）为必选，其他可选端口见下文“暴露端口” |  
| `-e TZ=...` | 设置时区，格式如`Asia/Shanghai`，时区列表见[维基百科]() |  
| `-v ~/unifi:/unifi` | 将主机`~/unifi`目录挂载到容器内`/unifi`目录（自定义路径需修改`~/unifi`部分） |  
| `--user unifi` | 以非root用户（uid/gid 999/999）运行，见下文“非root用户运行” |  
| `jacobalberty/unifi` | Docker镜像名称，从[Dockerhub]([])拉取，可通过标签指定版本 |  


## 支持的镜像标签  
通过标签指定Unifi Controller版本，默认（无标签）为最新稳定版。常见标签如下：  

| 标签 | 说明 | 更新日志 |  
|------|------|----------|  
| `latest`、`7.1.68` | 当前稳定版：7.1.68（2022-07-29） | [7.1.68更新日志]([]) |  
| `rc` | 最新候选版本：7.2.92-rc（2022-07-29） | [7.2.91-rc更新日志]([]) |  
| `stable6` | 稳定版6最终版：6.5.55 | [6.5.55更新日志]([]) |  
| `stable5` | 稳定版5最终版：5.4.23 | [5.14.23更新日志]([]) |  


### 多架构支持  
所有镜像均支持`amd64`、`armhf`、`arm64`架构。`armhf`架构目前依赖MongoDB 3.4，因32位ARM缺乏MongoDB支持，后续可能逐步淘汰，但至少支持到Ubuntu 18.04停止维护。  


## 设备接入与控制器发现  
### 覆盖“Inform Host”IP  
Unifi设备需通过Docker主机IP找到控制器（容器默认IP为172.17.x.x，设备连接的是主机外部IP），需手动覆盖Inform Host：  
1. 登录Unifi Controller Web界面，进入**设置 > 系统 > 其他配置 > 覆盖Inform主机**（页面底部）。  
2. 勾选“启用”，填入Docker主机的IP地址，保存设置。  
3. 重启容器（`docker stop unifi` + `docker run ...`）。  

其他接入方法可参考[Side Projects]([])。  


## 卷说明  
容器内`/unifi`目录包含以下关键子目录（数据持久化到主机`~/unifi`）：  

| 容器内路径 | 作用 | 原路径（旧版） |  
|------------|------|----------------|  
| `/unifi/data` | 配置数据存储 | `/var/lib/unifi` |  
| `/unifi/log` | 日志文件 | `/var/log/unifi` |  
| `/unifi/cert` | 自定义SSL证书存放 | `/var/cert/unifi` |  
| `/unifi/init.d` | 容器启动时执行的脚本 | - |  
| `/var/run/unifi` | 运行时信息（如PID文件） | - |  


## 环境变量  
通过`-e`参数设置，常用变量如下：  

| 变量 | 说明 | 默认值 |  
|------|------|--------|  
| `TZ` | 时区，如`Asia/Shanghai` | - |  
| `UNIFI_HTTP_PORT` | Web界面HTTP端口（会重定向到HTTPS） | 8080 |  
| `UNIFI_HTTPS_PORT` | Web界面HTTPS端口 | 8443 |  
| `PORTAL_HTTP_PORT` | 门户HTTP重定向端口 | 80 |  
| `PORTAL_HTTPS_PORT` | 门户HTTPS重定向端口 | 8843 |  
| `UNIFI_STDOUT` | 日志同时输出到stdout（除server.log外） | 未设置 |  
| `LOTSOFDEVICES` | 设备数量多或主机性能低时启用（如树莓派），优化JVM和数据库参数 | 未设置 |  
| `JVM_MAX_HEAP_SIZE` | JVM最大堆内存，大环境建议调大 | 1024M |  


## 暴露端口  
必选端口（启动命令已包含）：  
- `8080/tcp`：设备控制  
- `8443/tcp`：Web界面+API  
- `3478/udp`：STUN服务  

可选端口（按需添加`-p`映射）：  
- `8843/tcp`：HTTPS门户  
- `8880/tcp`：HTTP门户  
- `6789/tcp`：测速（仅unifi5）  

更多端口说明见[UniFi - Ports Used]([])。  


## 非root用户运行  
默认容器以root运行，推荐用`--user unifi`（uid/gid 999/999）以非root用户启动。注意：  
- 非root用户默认无法绑定1024以下端口，如需绑定，需添加`--sysctl net.ipv4.ip_unprivileged_port_start=0`参数。  


## 证书配置  
自定义SSL证书需挂载卷到`/unifi/cert`，文件命名规则：  
- `cert.pem`：证书文件  
- `privkey.pem`：私钥  
- `chain.pem`：证书链  

如需自定义文件名，通过环境变量`CERTNAME`（证书名）和`CERT_PRIVATE_NAME`（私钥名）指定，如`-e CERTNAME=my-cert.pem`。Let's Encrypt证书会自动添加Identrust X3 CA链，若证书已包含链，可设`CERT_IS_CHAIN=true`。  


## 补充信息  
本文已涵盖基础操作，更多技术细节可参考[Side Projects and Background Info]([])。  

## TODO  
目前暂无待办事项，欢迎通过[Issues]([])提出建议。

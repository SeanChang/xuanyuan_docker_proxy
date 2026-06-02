---
image: johngong/baidunetdisk
description: "需要提醒的是，百度网盘官方并未推出过“VNC版”客户端，此类非官方版本可能存在安全风险，如信息泄露、恶意程序植入等，且使用非官方软件可能违反相关服务协议。建议您通过百度网盘官方渠道下载和使用正版客户端，以保障账号和数据安全。"
source: https://xuanyuan.cloud/zh/r/johngong/baidunetdisk
canonical: https://xuanyuan.cloud/zh/r/johngong/baidunetdisk
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/johngong/baidunetdisk" title="johngong/baidunetdisk Docker 镜像中文简介、标签列表与拉取命令">johngong/baidunetdisk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 群晖NAS百度网盘Docker部署指南


## 项目简介  
本文介绍如何在群晖NAS上通过Docker部署百度网盘，方便本地管理和下载文件。项目源码及更多细节可查看GitHub仓库：[[]]([])。  

**特别感谢**：本项目基于 [jlesage/docker-baseimage-gui]([]) 基础镜像开发，感谢原作者的开源贡献。


## 支持版本  
当前支持以下架构的百度网盘客户端版本：  

| 名称         | 版本    | 说明       |
| :----------- | :------ | :--------- |
| baidunetdisk | 4.17.7  | amd64架构  |
| baidunetdisk | 4.17.7  | arm64架构  |


## 注意事项  
使用过程中若遇到以下问题，可按对应方法解决：  

1. **重启群晖后网盘无法登录**（适用于版本 3.0.1.2）：  
   需删除配置文件夹中的 `baidunetdiskdata.db` 文件（下载进度会保留）；若设置界面闪退，需删除账户文件夹中的 `userConf.db` 文件，之后重启Docker容器即可。  

2. **升级至 3.5.0 版本后下载位置配置**：  
   升级后需手动在网盘客户端右上角「设置」中重新指定下载路径。  


## 部署步骤  

### 一、命令行部署  
通过SSH登录群晖NAS后，执行以下命令完成部署。  

#### 1. 下载镜像  
根据网络环境选择镜像源，执行对应命令拉取镜像：  

| 镜像源       | 拉取命令                                  |
| :----------- | :---------------------------------------- |
| DockerHub    | `docker pull johngong/baidunetdisk:latest` |
| GitHub       | `docker pull ghcr.io/gshang2017/baidunetdisk:latest` |

#### 2. 创建容器  
替换以下命令中的 `<本地配置文件路径>` 和 `<本地下载路径>` 为实际路径（如 `/volume1/docker/baidunetdisk/config` 和 `/volume1/downloads`），执行创建容器：  

```bash
docker create \
   --name=baidunetdisk \
   -p 5800:5800 \
   -p 5900:5900 \
   -v <本地配置文件路径>:/config \
   -v <本地下载路径>:/config/baidunetdiskdownload \
   --restart unless-stopped \
   johngong/baidunetdisk:latest
```

#### 3. 运行容器  
```bash
docker start baidunetdisk
```

#### 4. 停止容器  
```bash
docker stop baidunetdisk
```

#### 5. 删除容器  
```bash
docker rm baidunetdisk
```

#### 6. 删除镜像  
```bash
docker image rm johngong/baidunetdisk:latest
```


### 二、群晖Docker界面部署  
通过群晖DSM的「Docker」套件图形界面配置，步骤如下：  

#### 1. 卷设置（文件映射）  
在「卷」选项卡中添加本地文件夹与容器内路径的映射：  

| 配置项                | 说明                                  |
| :-------------------- | :------------------------------------ |
| 本地文件夹1 → 容器路径 | `<本地下载路径>` → `/config/baidunetdiskdownload`（百度网盘下载路径，3.3.2及以上版本需手动在客户端设置） |
| 本地文件夹2 → 容器路径 | `<本地配置文件路径>` → `/config`（百度网盘配置文件存储路径） |

#### 2. 端口设置（端口映射）  
在「端口设置」选项卡中配置本地端口与容器端口的映射：  

| 配置项          | 说明                                  |
| :-------------- | :------------------------------------ |
| 本地端口1:5800  | Web界面访问端口，通过 `群晖IP:本地端口1` 访问 |
| 本地端口2:5900  | VNC协议访问端口（若不使用VNC客户端可忽略），通过 `群晖IP:本地端口2` 访问 |

#### 3. 环境变量设置  
在「环境」选项卡中添加以下键值对（根据需求调整，默认值可省略）：  

| 参数键                 | 说明                                  | 默认值       |
| :--------------------- | :------------------------------------ | :----------- |
| `VNC_PASSWORD`         | VNC访问密码（若启用VNC）               | -            |
| `USER_ID`              | 用户ID（uid）                         | 1000         |
| `GROUP_ID`             | 用户组ID（gid）                       | 1000         |
| `NOVNC_LANGUAGE`       | Web界面语言（`zh_Hans`为中文，`en`为英文） | `zh_Hans`    |
| `ENABLE_DISABLE_GPU`   | 是否关闭硬件加速（`true`关闭，`false`开启） | `false`      |


## 参数说明  
以下是创建容器时常用参数的详细说明，适用于命令行和图形界面部署：  

| 参数                                  | 说明                                  |
| :------------------------------------ | :------------------------------------ |
| `--name=baidunetdisk`                 | 容器名称，可自定义                    |
| `-p 5800:5800`                        | Web界面端口映射，本地端口:容器端口    |
| `-p 5900:5900`                        | VNC端口映射（可选）                   |
| `-v <本地路径>:/config`               | 配置文件路径映射                      |
| `-v <本地路径>:/config/baidunetdiskdownload` | 下载路径映射                      |
| `--restart unless-stopped`            | 容器重启策略（异常停止后自动重启）    |


## 其他说明  
更多高级参数配置（如网络模式、资源限制等），可参考基础镜像文档：[jlesage/baseimage-gui]([])。

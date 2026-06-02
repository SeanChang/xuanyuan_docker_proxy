---
image: fauria/vsftpd
description: "基于CentOS 7构建的vsftpd Docker镜像，vsftpd作为一款以安全、高效和稳定为核心特性的FTP服务器，该镜像不仅支持被动模式以适应复杂网络环境下的文件传输需求，还集成了虚拟用户功能，可通过独立配置实现对FTP访问权限的精细化管控，适用于需要安全、便捷文件传输服务的容器化部署场景。"
source: https://xuanyuan.cloud/zh/r/fauria/vsftpd
canonical: https://xuanyuan.cloud/zh/r/fauria/vsftpd
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fauria/vsftpd" title="fauria/vsftpd Docker 镜像中文简介、标签列表与拉取命令">fauria/vsftpd — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/fauria/vsftpd" title="fauria/vsftpd Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/fauria/vsftpd</a>

# fauria/vsftpd  

![docker_logo]([])![docker_fauria_logo]([])  

[![Docker Pulls]([])]([])  
[![Docker Build Status]([])]([])  
[![]([])]([] "fauria/vsftpd")  


## 简介  
这是一个基于Docker的vsftpd服务器容器，主要特性包括：  
- 基于CentOS 7基础镜像  
- 集成vsftpd 3.0版本  
- 支持虚拟用户  
- 支持被动模式  
- 日志可输出到文件或STDOUT  


## 安装  
可通过Docker Hub直接拉取镜像：  
```bash
docker pull fauria/vsftpd
```


## 环境变量  
容器运行时可通过环境变量配置参数，具体如下：  


----

* **变量名**：`FTP_USER`  
* **默认值**：admin  
* **接受值**：任意字符串（避免空格和特殊字符）  
* **说明**：默认FTP账号的用户名。若未通过该变量指定，默认使用“admin”。  


----

* **变量名**：`FTP_PASS`  
* **默认值**：随机字符串  
* **接受值**：任意字符串  
* **说明**：默认FTP账号的密码。若未指定，容器会自动生成16位随机字符串，可通过`docker logs <容器名>`查看。  


----

* **变量名**：`PASV_ADDRESS`  
* **默认值**：Docker主机IP/主机名  
* **接受值**：任意IPv4地址或主机名（需配合`PASV_ADDR_RESOLVE`使用）  
* **说明**：被动模式下使用的IP地址。若未指定，默认使用Docker主机的路由IP（可能为内网地址）。  


----

* **变量名**：`PASV_ADDR_RESOLVE`  
* **默认值**：NO  
* **接受值**：NO|YES  
* **说明**：设为YES时，`PASV_ADDRESS`可填主机名（而非IP地址）。  


----

* **变量名**：`PASV_ENABLE`  
* **默认值**：YES  
* **接受值**：NO|YES  
* **说明**：设为NO时，禁用被动模式数据连接。  


----

* **变量名**：`PASV_MIN_PORT`  
* **默认值**：21100  
* **接受值**：任意有效端口号  
* **说明**：被动模式端口范围的下限。需通过`docker run -p`参数映射端口。  


----

* **变量名**：`PASV_MAX_PORT`  
* **默认值**：21110  
* **接受值**：任意有效端口号  
* **说明**：被动模式端口范围的上限。端口范围越大，容器启动时间可能越长。  


----

* **变量名**：`XFERLOG_STD_FORMAT`  
* **默认值**：NO  
* **接受值**：NO|YES  
* **说明**：设为YES时，传输日志将采用xferlog标准格式。  


----

* **变量名**：`LOG_STDOUT`  
* **默认值**：空字符串  
* **接受值**：任意字符串（非空则启用）  
* **说明**：设为非空时，vsftpd日志将输出到STDOUT，可通过`docker logs <容器名>`查看。  


----

* **变量名**：`FILE_OPEN_MODE`  
* **默认值**：0666  
* **接受值**：文件系统权限值  
* **说明**：上传文件的创建权限。权限掩码（umask）会叠加在此值上。若需上传文件可执行，可改为0777。  


----

* **变量名**：`LOCAL_UMASK`  
* **默认值**：077  
* **接受值**：文件系统权限值  
* **说明**：本地用户创建文件时的权限掩码。若需指定八进制值，需加前缀“0”（否则视为十进制）。  


----

* **变量名**：`REVERSE_LOOKUP_ENABLE`  
* **默认值**：YES  
* **接受值**：NO|YES  
* **说明**：设为NO可避免因DNS反向解析无响应导致的性能问题。  


----

* **变量名**：`PASV_PROMISCUOUS`  
* **默认值**：NO  
* **接受值**：NO|YES  
* **说明**：设为YES时，禁用被动模式下“数据连接需与控制连接同IP”的安全检查。仅在特殊场景（如安全隧道、FXP支持）下启用。  


----

* **变量名**：`PORT_PROMISCUOUS`  
* **默认值**：NO  
* **接受值**：NO|YES  
* **说明**：设为YES时，禁用主动模式下“数据连接仅允许连接客户端”的安全检查。仅在FXP支持等特殊场景下启用。  


## 暴露端口与数据卷  
- **暴露端口**：20（数据端口）、21（控制端口）  
- **数据卷**：  
  - `/home/vsftpd`：用户主目录（存储FTP文件）  
  - `/var/log/vsftpd`：日志存储目录  

> **注意**：若需将`/home/vsftpd`目录与主机共享，需确保主机目录权限对应用户ID 14（容器内ftp用户）和组ID 50（容器内ftp组）。  


## 使用案例  

### 1. 临时测试容器  
快速启动一个临时容器用于测试：  
```bash
docker run --rm fauria/vsftpd
```


### 2. 绑定数据目录（默认用户）  
创建容器并绑定主机数据目录，使用默认FTP用户（admin，密码需从日志获取）：  
```bash
docker run -d -p 21:21 -v /本地数据目录:/home/vsftpd --name vsftpd fauria/vsftpd
# 查看默认密码：
docker logs vsftpd
```


### 3. 生产环境配置（自定义用户+被动模式）  
配置固定用户、端口范围及开机自启，适用于生产环境：  
```bash
docker run -d \
  -v /本地数据目录:/home/vsftpd \
  -p 20:20 -p 21:21 -p 21100-21110:21100-21110 \
  -e FTP_USER=myuser -e FTP_PASS=mypass \
  -e PASV_ADDRESS=服务器公网IP -e PASV_MIN_PORT=21100 -e PASV_MAX_PORT=21110 \
  --name vsftpd --restart=always fauria/vsftpd
```


### 4. 手动添加FTP用户（现有容器）  
对运行中的容器添加新用户：  
```bash
# 进入容器终端
docker exec -i -t vsftpd bash

# 创建用户目录
mkdir /home/vsftpd/myuser

# 添加用户到虚拟用户列表（格式：用户名\n密码）
echo -e "myuser\nmypass" >> /etc/vsftpd/virtual_users.txt

# 生成用户数据库
/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db

# 退出容器并重启
exit
docker restart vsftpd
```

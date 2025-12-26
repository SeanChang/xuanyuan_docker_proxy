---
id: 51
title: NGINX WEBUI Docker容器化部署指南
slug: nginx-webui-docker
summary: NGINXWEBUI是一款基于Web的图形化Nginx配置管理工具，旨在简化Nginx服务器的配置与管理流程。通过直观的网页界面，用户可快速配置反向代理、负载均衡、SSL证书、TCP转发等常用Nginx功能，无需手动编写复杂的配置文件。该工具集成了证书自动申请与续签、配置文件备份与回滚、远程服务器管理等实用功能，适用于需要高效管理Nginx服务器的个人用户与企业环境。
category: Docker,NGINXWEBUI
tags: nginx,docker,部署教程
image_name: cym1102/nginxwebui
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-nginxwebui.png"
status: published
created_at: "2025-11-09 17:10:03"
updated_at: "2025-11-11 02:05:37"
---

# NGINX WEBUI Docker容器化部署指南

> NGINXWEBUI是一款基于Web的图形化Nginx配置管理工具，旨在简化Nginx服务器的配置与管理流程。通过直观的网页界面，用户可快速配置反向代理、负载均衡、SSL证书、TCP转发等常用Nginx功能，无需手动编写复杂的配置文件。该工具集成了证书自动申请与续签、配置文件备份与回滚、远程服务器管理等实用功能，适用于需要高效管理Nginx服务器的个人用户与企业环境。

## 概述

NGINX WEBUI是一款基于Web的图形化Nginx配置管理工具，旨在简化Nginx服务器的配置与管理流程。通过直观的网页界面，用户可快速配置反向代理、负载均衡、SSL证书、TCP转发等常用Nginx功能，无需手动编写复杂的配置文件。该工具集成了证书自动申请与续签、配置文件备份与回滚、远程服务器管理等实用功能，适用于需要高效管理Nginx服务器的个人用户与企业环境。

本文将详细介绍NGINX WEBUI的Docker容器化部署方案，包括环境准备、镜像管理、容器部署、功能测试及生产环境优化建议，帮助用户快速实现NGINX WEBUI的标准化部署。


## 环境准备

### Docker环境安装

部署NGINX WEBUI前需确保服务器已安装Docker环境。推荐使用以下一键安装脚本，自动完成Docker及相关组件的部署与配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 说明：该脚本适用于Ubuntu、CentOS等主流Linux发行版，执行过程中需root权限，建议在全新环境中运行。


## 镜像准备

### 镜像拉取命令

使用轩辕镜像访问支持地址拉取指定版本镜像（推荐标签为`latest`）：

```bash
# 拉取NGINX WEBUI镜像（使用轩辕访问支持地址）
docker pull docker.xuanyuan.me/cym1102/nginxwebui:latest
```

### 镜像验证

拉取完成后，通过以下命令验证镜像信息：

```bash
# 查看本地镜像列表
docker images | grep nginxwebui

# 预期输出示例：
# docker.xuanyuan.me/cym1102/nginxwebui   latest    xxxxxxxx    2 weeks ago    500MB
```


## 容器部署

### 基础部署命令

使用`docker run`命令启动NGINX WEBUI容器，关键参数说明如下：

```bash
docker run -itd \
  --name nginxwebui \  # 容器名称，便于管理
  -v /home/nginxWebUI:/home/nginxWebUI \  # 挂载数据卷，存放配置、证书、数据库等
  -e BOOT_OPTIONS="--server.port=8080" \  # Java启动参数，可修改端口（默认8080）
  --privileged=true \  # 赋予容器特权，确保证书管理等功能正常
  --net=host \  # 使用主机网络模式，映射所有端口（内部Nginx可能使用任意端口）
  docker.xuanyuan.me/cym1102/nginxwebui:latest  # 镜像地址（访问支持地址）
```

### 参数详解

- **数据卷挂载（-v /home/nginxWebUI:/home/nginxWebUI）**：  
  该路径存放项目所有核心数据，包括SQLite数据库、Nginx配置文件、SSL证书、日志等。升级镜像时，保留此目录可确保数据不丢失，建议定期备份。

- **网络模式（--net=host）**：  
  NGINX WEBUI内部集成Nginx服务，可能动态使用多个端口（如80、443及用户自定义端口），使用主机网络模式可直接映射主机所有端口，避免端口映射冲突。

- **启动参数（-e BOOT_OPTIONS）**：  
  支持自定义Java启动参数，例如修改端口：`--server.port=9090`；开启接口文档：`--knife4j.production=false`（访问`http://IP:端口/doc.html`查看接口文档）。

### 容器状态检查

部署完成后，验证容器运行状态：

```bash
# 查看容器运行状态
docker ps | grep nginxwebui

# 查看容器日志（验证服务启动情况）
docker logs -f nginxwebui
```

> 日志默认路径：容器内`/home/nginxWebUI/log/nginxWebUI.log`，对应主机路径`/home/nginxWebUI/log/nginxWebUI.log`。


## 功能测试

### 访问Web界面

在浏览器中访问`http://服务器IP:8080`（默认端口8080，若修改需对应调整），首次访问将提示初始化管理员账号，按指引设置用户名和密码。

### 核心功能测试

#### 1. 反向代理配置
- 登录后进入「反向代理」模块，点击「新增」
- 配置域名、目标服务器地址、端口等参数
- 点击「保存」并生成Nginx配置，验证代理是否生效

#### 2. SSL证书管理
- 进入「证书管理」模块，选择「申请证书」
- 输入域名，选择证书提供商（如Let's Encrypt）
- 配置DNS验证信息（如阿里云AK/SK），提交申请
- 验证证书是否自动配置到对应域名

#### 3. 配置文件管理
- 进入「生成conf文件」模块，查看自动生成的Nginx配置
- 支持手动编辑配置内容，确认无误后点击「覆盖并重启Nginx」
- 检查Nginx服务是否正常重启，配置是否生效

#### 4. 数据备份验证
- 进入「备份文件管理」模块，查看自动生成的配置文件备份
- 尝试回滚到历史版本，验证配置恢复功能是否正常


## 生产环境建议

### 数据备份策略

- **定期备份数据卷**：  
  使用`crontab`定时执行备份脚本，压缩`/home/nginxWebUI`目录并存储至外部存储：
  ```bash
  # 示例：每日凌晨3点备份数据
  0 3 * * * tar -zcvf /backup/nginxwebui_$(date +%Y%m%d).tar.gz /home/nginxWebUI
  ```

- **数据库独立备份**：  
  单独备份SQLite数据库文件（`/home/nginxWebUI/sqlite.db`），避免数据损坏导致服务不可用。

### 安全加固

- **端口限制**：  
  若无需开放所有端口，可替换`--net=host`为端口映射（需明确Nginx使用的端口）：
  ```bash
  # 示例：映射80、443、8080端口（需确保内部Nginx仅使用这些端口）
  -p 80:80 -p 443:443 -p 8080:8080
  ```

- **文件权限控制**：  
  主机`/home/nginxWebUI`目录权限建议设置为`700`，仅root用户可读写，避免非授权访问：
  ```bash
  chmod -R 700 /home/nginxWebUI
  ```

- **防火墙配置**：  
  使用`ufw`或`firewalld`限制端口访问，仅允许信任IP访问管理端口（如8080）。

### 资源与性能优化

- **容器资源限制**：  
  添加`--memory=2g --memory-swap=2g --cpus=1`限制容器资源使用，避免过度占用主机资源。

- **日志轮转**：  
  配置日志轮转工具（如`logrotate`），定期切割`/home/nginxWebUI/log`目录下的日志文件，防止磁盘空间耗尽。

### 镜像更新策略

定期检查官方标签页面（[DOC_URL_TAGS](https://xuanyuan.cloud/r/cym1102/nginxwebui/tags)），更新镜像时遵循以下步骤：
1. 拉取新版本镜像：`docker pull docker.xuanyuan.me/cym1102/nginxwebui:latest`
2. 停止旧容器：`docker stop nginxwebui`
3. 启动新容器（使用相同数据卷挂载）：`docker run ...`（同部署命令）
4. 验证服务正常后，删除旧容器：`docker rm 旧容器ID`


## 故障排查

### 容器无法启动

#### 问题现象：
执行`docker run`后，容器状态为`Exited`，或`docker ps`中无容器记录。

#### 排查步骤：
1. **检查端口占用**：  
   若修改了`--server.port`，确认端口未被占用：
   ```bash
   netstat -tulpn | grep 8080  # 替换为实际端口
   ```

2. **检查挂载路径权限**：  
   确保主机`/home/nginxWebUI`目录存在且权限正确：
   ```bash
   mkdir -p /home/nginxWebUI && chmod -R 777 /home/nginxWebUI  # 临时赋予777权限测试
   ```

3. **查看启动日志**：  
   不使用`-d`参数（后台运行），直接前台启动查看错误：
   ```bash
   docker run -it --rm ...（其他参数） docker.xuanyuan.me/cym1102/nginxwebui:latest
   ```

### 服务无法访问

#### 问题现象：
容器运行正常，但浏览器无法访问`http://IP:8080`。

#### 排查步骤：
1. **检查容器日志**：  
   ```bash
   docker logs nginxwebui | grep -i error  # 查找错误信息
   ```

2. **验证网络模式**：  
   若未使用`--net=host`，确认端口映射正确；使用主机网络时，检查防火墙是否放行端口。

3. **检查Java服务状态**：  
   进入容器内部，验证Java进程是否运行：
   ```bash
   docker exec -it nginxwebui bash
   ps -ef | grep java  # 查看是否有nginxWebUI进程
   ```

### 证书申请失败

#### 问题现象：
在「证书管理」中申请Let's Encrypt证书失败。

#### 排查步骤：
1. **确认网络连接**：  
   容器内测试网络连通性：
   ```bash
   docker exec -it nginxwebui ping acme-v02.api.letsencrypt.org
   ```

2. **验证权限**：  
   确保容器已启用`--privileged=true`，并检查证书存放路径权限。

3. **检查DNS配置**：  
   若使用DNS验证模式（如阿里云），确认AK/SK正确且具有域名解析权限。

### 密码找回

若忘记管理员密码，通过以下步骤重置：

1. **安装SQLite工具**：  
   ```bash
   apt install sqlite3  # Ubuntu/Debian
   # 或
   yum install sqlite3  # CentOS/RHEL
   ```

2. **修改数据库**：  
   ```bash
   # 进入SQLite命令行
   sqlite3 /home/nginxWebUI/sqlite.db

   # 查看管理员表（默认表名admin）
   SELECT * FROM admin;

   # 更新密码（示例：重置密码为Admin123）
   UPDATE admin SET password = '21232f297a57a5a743894a0e4a801fc3' WHERE username = 'admin';
   # 注：'21232f297a57a5a743894a0e4a801fc3' 为MD5加密后的'admin'，若需自定义密码需生成对应MD5值

   # 退出
   .quit
   ```

3. **重启容器**：  
   ```bash
   docker restart nginxwebui
   ```


## 参考资源

- **官方轩辕镜像文档**：[NGINXWEBUI文档](https://xuanyuan.cloud/r/cym1102/nginxwebui)
- **镜像标签**：[Docker镜像标签页面](https://xuanyuan.cloud/r/cym1102/nginxwebui/tags)
- **GitHub仓库**：[cym1102/nginxWebUI](https://github.com/cym1102/nginxWebUI)
- **Gitee仓库**：[cym1102/nginxWebUI](https://gitee.com/cym1102/nginxWebUI)
- **演示地址**：[http://test.nginxwebui.cn:8080](http://test.nginxwebui.cn:8080)（用户名：admin，密码：Admin123）


## 总结

本文详细介绍了NGINX WEBUI的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境优化及故障排查等关键环节。通过容器化部署，可快速搭建图形化Nginx管理平台，简化配置流程，提升运维效率。

**关键要点**：
- 使用轩辕镜像访问支持（docker.xuanyuan.me）可显著提升镜像拉取访问表现
- 必须挂载`/home/nginxWebUI`数据卷，确保配置、证书等核心数据持久化
- 采用`--net=host`网络模式，避免Nginx动态端口映射冲突
- 定期备份数据卷目录，防止数据丢失

**后续建议**：
- 深入学习NGINXWEBUI高级特性，如远程服务器管理、配置同步、接口开发等功能
- 结合业务需求，配置日志轮转、资源监控等运维工具，保障服务稳定运行
- 关注官方仓库更新，及时升级镜像以获取新功能和安全补丁
- 针对生产环境，制定完善的容灾方案，如多节点部署、配置文件版本控制等


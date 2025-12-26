# CALIBRE-WEB Docker 容器化部署指南

![CALIBRE-WEB Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-calibre-web.png)

*分类: Docker,CALIBRE-WEB | 标签: calibre-web,docker,部署教程 | 发布时间: 2025-12-11 08:26:02*

> CALIBRE-WEB是一个基于Web的电子书管理应用，它提供了一个简洁的界面用于浏览、阅读和下载电子书，支持使用现有的Calibre数据库。

## 概述

CALIBRE-WEB是一个基于Web的电子书管理应用，它提供了一个简洁的界面用于浏览、阅读和下载电子书，支持使用现有的Calibre数据库。该应用由LinuxServer.io团队提供容器化支持，具备以下特点：

- 定期及时的应用更新
- 简单的用户权限映射（PGID、PUID）
- 自定义基础镜像与s6 overlay
- 每周基础操作系统更新，在整个LinuxServer.io生态系统中共享通用层，以最小化空间使用、停机时间和带宽消耗
- 定期安全更新

CALIBRE-WEB还支持集成Google Drive，并允许通过应用本身编辑元数据和管理Calibre库。该软件是library的一个分支，采用GPL v3许可证授权。

## 环境准备

在开始部署CALIBRE-WEB之前，需要先确保Docker环境已正确安装。对于大多数Linux发行版，可以使用以下一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

该脚本将自动安装Docker和Docker Compose，并配置必要的系统参数。安装完成后，建议启用并启动Docker服务：

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

## 镜像准备

### 拉取CALIBRE-WEB镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的CALIBRE-WEB镜像：

```bash
docker pull xxx.xuanyuan.run/linuxserver/calibre-web:latest
```

如需指定特定版本，可参考[CALIBRE-WEB镜像标签列表](https://xuanyuan.cloud/r/linuxserver/calibre-web/tags)选择合适的标签替换上述命令中的`latest`。

## 容器部署

CALIBRE-WEB容器部署支持两种方式：Docker Compose（推荐）和Docker CLI。两种方式都能实现相同的功能，可根据个人习惯选择。

### 使用Docker Compose部署

创建一个名为`docker-compose.yml`的文件，内容如下：

```yaml
---
services:
  calibre-web:
    image: xxx.xuanyuan.run/linuxserver/calibre-web:latest
    container_name: calibre-web
    environment:
      - PUID=1000               # 用户ID，用于权限映射
      - PGID=1000               # 组ID，用于权限映射
      - TZ=Etc/UTC              # 时区设置，例如Asia/Shanghai
      - DOCKER_MODS=linuxserver/mods:universal-calibre # 可选，启用电子书转换功能（仅64位系统）
      - OAUTHLIB_RELAX_TOKEN_SCOPE=1 # 可选，允许Google OAUTH支持
    volumes:
      - /path/to/calibre-web/data:/config  # 配置文件存储路径
      - /path/to/calibre/library:/books    # Calibre库存储路径
    ports:
      - 8083:8083               # Web界面端口映射
    restart: unless-stopped     # 自动重启策略
```

**参数说明**：

- `PUID`和`PGID`：用于解决容器内用户与宿主机用户的权限问题，可通过`id your_username`命令查看当前用户的UID和GID
- `TZ`：时区设置，国内用户可设置为`Asia/Shanghai`
- `DOCKER_MODS`：可选参数，用于启用电子书转换功能，仅支持64位系统
- `volumes`：需要将宿主机的实际路径替换`/path/to/calibre-web/data`和`/path/to/calibre/library`
- `ports`：默认Web界面端口为8083，可根据需要修改宿主机端口

创建完成后，在该文件所在目录执行以下命令启动容器：

```bash
docker-compose up -d
```

### 使用Docker CLI部署

如果不使用Docker Compose，可直接通过docker run命令部署：

```bash
docker run -d \
  --name=calibre-web \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e DOCKER_MODS=linuxserver/mods:universal-calibre `#可选` \
  -e OAUTHLIB_RELAX_TOKEN_SCOPE=1 `#可选` \
  -p 8083:8083 \
  -v /path/to/calibre-web/data:/config \
  -v /path/to/calibre/library:/books \
  --restart unless-stopped \
  xxx.xuanyuan.run/linuxserver/calibre-web:latest
```

请将上述命令中的`/path/to/calibre-web/data`和`/path/to/calibre/library`替换为宿主机上的实际路径。其他参数与Docker Compose方式相同。

## 功能测试

容器启动后，可通过以下步骤验证CALIBRE-WEB是否正常工作：

### 访问Web界面

打开浏览器，访问`http://服务器IP:8083`，应该能看到CALIBRE-WEB的登录界面。

### 初始登录

使用默认管理员凭据登录：
- 用户名：admin
- 密码：admin123

首次登录后，系统会要求您修改默认密码以提高安全性。

### 配置Calibre库位置

在初始设置界面，需要指定Calibre库的位置。根据容器部署时的卷映射配置，应输入`/books`作为Calibre库位置。

### 验证基本功能

1. 检查是否可以浏览电子书（如果库中已有书籍）
2. 尝试上传一本电子书到库中
3. 测试阅读功能是否正常
4. 检查设置页面是否可访问

### 查看容器日志

通过以下命令查看容器运行日志，确认是否有错误信息：

```bash
docker logs -f calibre-web
```

如无错误信息且Web界面正常访问，则说明CALIBRE-WEB部署成功。按`Ctrl+C`可退出日志查看。

## 生产环境建议

为确保CALIBRE-WEB在生产环境中稳定可靠运行，建议考虑以下配置：

### 数据备份策略

1. **定期备份配置数据**：对`/path/to/calibre-web/data`目录进行定期备份，确保配置信息不会丢失
2. **Calibre库备份**：如果Calibre库包含重要数据，建议实施定期备份策略
3. **自动化备份**：可使用cron任务或其他自动化工具实现定期备份，示例：

```bash
# 每日凌晨2点备份Calibre配置和库数据
0 2 * * * tar -czf /backup/calibre-$(date +\%Y\%m\%d).tar.gz /path/to/calibre-web/data /path/to/calibre/library
```

### 资源配置优化

1. **内存分配**：根据库中电子书数量和并发访问量，适当调整容器内存限制。对于小型图书馆，512MB内存通常足够；对于大型图书馆或高并发场景，建议分配1GB或更多内存
2. **CPU资源**：CALIBRE-WEB对CPU资源要求不高，一般场景下1核CPU即可满足需求
3. **存储性能**：建议使用SSD存储以提高电子书加载访问表现，特别是对于包含大量图片的PDF文件

### 安全加固

1. **使用非root用户运行**：容器默认以非root用户运行，确保宿主机目录权限正确配置
2. **设置强密码**：确保管理员密码复杂度足够高，避免使用默认密码
3. **HTTPS访问**：通过反向代理（如Nginx、Traefik）配置HTTPS，加密传输数据
4. **网络隔离**：限制CALIBRE-WEB仅在必要的网络范围内可访问，避免暴露在公网

### 监控与维护

1. **容器状态监控**：使用工具如Prometheus+Grafana或简单的监控脚本，定期检查容器运行状态
2. **日志管理**：配置日志轮转，避免日志文件过大占用磁盘空间
3. **定期更新**：定期更新CALIBRE-WEB镜像以获取最新功能和安全补丁：

```bash
# 使用Docker Compose更新
docker-compose pull
docker-compose up -d

# 使用Docker CLI更新
docker pull xxx.xuanyuan.run/linuxserver/calibre-web:latest
docker stop calibre-web
docker rm calibre-web
# 重新运行之前的docker run命令
```

## 故障排查

### 常见问题及解决方法

#### 1. 权限问题

**症状**：无法读取或写入文件，Web界面提示权限错误。

**解决方法**：
- 确保宿主机上的`/path/to/calibre-web/data`和`/path/to/calibre/library`目录权限正确，建议设置为755
- 检查PUID和PGID是否与宿主机目录所有者匹配，可通过`chown`命令调整目录所有者：

```bash
chown -R 1000:1000 /path/to/calibre-web/data
chown -R 1000:1000 /path/to/calibre/library
```

#### 2. 端口冲突

**症状**：容器启动失败，日志中出现"bind: address already in use"错误。

**解决方法**：
- 检查8083端口是否已被其他服务占用：`netstat -tulpn | grep 8083`
- 如端口冲突，修改端口映射为未被占用的端口，例如使用8084端口：`-p 8084:8083`

#### 3. 忘记管理员密码

**症状**：无法登录管理界面，忘记管理员密码。

**解决方法**：
- 通过以下命令重置管理员密码（将`<user>`替换为用户名，`<pass>`替换为新密码）：

```bash
docker exec -it calibre-web python3 /app/calibre-web/cps.py -p /config/app.db -s <user>:<pass>
```

- 例如重置admin用户密码为newpassword123：

```bash
docker exec -it calibre-web python3 /app/calibre-web/cps.py -p /config/app.db -s admin:newpassword123
```

#### 4. 电子书转换功能无法使用

**症状**：尝试转换电子书格式时失败。

**解决方法**：
- 确保已添加`DOCKER_MODS=linuxserver/mods:universal-calibre`环境变量
- 确认系统架构为64位（该功能仅支持64位系统）
- 在Calibre-Web管理页面（基本配置：外部二进制文件）设置Calibre电子书转换器路径：
  - 对于0.6.21及更低版本：`/usr/bin/ebook-convert`
  - 对于0.6.22及更高版本：`/usr/bin/`

#### 5. 容器启动后无法访问Web界面

**症状**：容器状态显示正常运行，但无法通过浏览器访问Web界面。

**解决方法**：
- 检查宿主机防火墙是否允许8083端口访问：`sudo ufw status`（如使用ufw防火墙）
- 确认端口映射是否正确：`docker ps | grep calibre-web`
- 查看容器日志寻找错误信息：`docker logs calibre-web`

## 参考资源

1. [CALIBRE-WEB镜像文档（轩辕）](https://xuanyuan.cloud/r/linuxserver/calibre-web)
2. [CALIBRE-WEB镜像标签列表](https://xuanyuan.cloud/r/linuxserver/calibre-web/tags)
3. [LinuxServer.io官方网站](https://linuxserver.io/)
4. [Calibre-Web GitHub项目](https://github.com/janeczku/calibre-web)
5. [Docker官方文档](https://docs.docker.com/)
6. [Docker Compose文档](https://docs.docker.com/compose/)

## 总结

本文详细介绍了CALIBRE-WEB的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境建议和故障排查等内容。通过Docker方式部署CALIBRE-WEB可以简化安装过程，提高系统可维护性，并确保环境一致性。

**关键要点**：
- 使用一键脚本可快速部署Docker环境
- 轩辕镜像访问支持可提升镜像拉取访问表现
- 容器部署支持Docker Compose和Docker CLI两种方式
- 正确配置PUID和PGID可避免权限问题
- 生产环境中应实施数据备份和安全加固措施
- 忘记管理员密码可通过命令行重置

**后续建议**：
- 深入学习CALIBRE-WEB的高级特性，如Google Drive集成、用户权限管理等
- 根据实际使用情况优化资源配置，提升系统性能
- 探索CALIBRE-WEB的API功能，实现与其他系统的集成
- 关注项目官方更新，及时获取新功能和安全补丁信息
- 考虑搭建ELK或其他日志分析系统，对CALIBRE-WEB运行日志进行集中管理和分析


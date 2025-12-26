# Komga Docker 容器化部署指南

![Komga Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-komga.png)

*分类: Docker,Komga | 标签: komga,docker,部署教程 | 发布时间: 2025-12-14 11:09:53*

> Komga 是一款专为漫画和 manga 设计的媒体服务器应用，能够通过API提供页面服务与流式传输功能。作为容器化应用，Komga 具备部署便捷、环境一致性高、资源隔离性好等特点，适合个人用户和小型团队搭建私有漫画库服务。本文将详细介绍如何通过Docker容器化方式部署KOMGA，包括环境准备、镜像拉取、容器配置、功能测试及生产环境优化等关键步骤，帮助用户快速实现KOMGA的稳定运行。

## 概述

Komga 是一款专为漫画和 manga 设计的媒体服务器应用，能够通过API提供页面服务与流式传输功能。作为容器化应用，Komga 具备部署便捷、环境一致性高、资源隔离性好等特点，适合个人用户和小型团队搭建私有漫画库服务。本文将详细介绍如何通过Docker容器化方式部署KOMGA，包括环境准备、镜像拉取、容器配置、功能测试及生产环境优化等关键步骤，帮助用户快速实现KOMGA的稳定运行。


## 环境准备

### Docker环境安装

Komga 基于Docker容器化部署，首先需要在目标服务器上安装Docker环境。推荐使用轩辕云提供的一键安装脚本，该脚本会自动配置Docker及相关依赖，适用于主流Linux发行版（Ubuntu、CentOS、Debian等）。

执行以下命令安装Docker：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，可通过以下命令验证Docker是否正常运行：

```bash
docker --version  # 查看Docker版本
systemctl status docker  # 检查Docker服务状态
```

若输出Docker版本信息且服务状态为`active (running)`，则表示Docker环境安装成功。


## 镜像准备

### 拉取 Komga 镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的KOMGA镜像：

```bash
docker pull xxx.xuanyuan.run/gotson/komga:latest
```

拉取完成后，可通过以下命令查看本地镜像列表，确认镜像已成功下载：

```bash
docker images | grep gotson/komga
```

若输出包含`xxx.xuanyuan.run/gotson/komga:latest`的记录，则表示镜像拉取成功。如需使用其他版本，可访问[KOMGA镜像标签列表](https://xuanyuan.cloud/r/gotson/komga/tags)查看所有可用标签，并将命令中的`latest`替换为目标标签。


## 容器部署

### 基础部署命令

KOMGA容器部署需配置数据持久化、端口映射及必要的环境变量。以下是基础部署命令，适用于快速启动服务进行功能验证：

```bash
docker run -d \
  --name komga \
  -p <host_port>:<container_port> \
  -v /data/komga/config:/config \
  -v /data/komga/data:/data \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  xxx.xuanyuan.run/gotson/komga:latest
```

#### 参数说明：
- `-d`：后台运行容器
- `--name komga`：指定容器名称为`komga`，便于后续管理
- `-p <host_port>:<container_port>`：端口映射，需根据[KOMGA镜像文档（轩辕）](https://xuanyuan.cloud/r/gotson/komga)获取容器内服务端口，并替换`<container_port>`，`<host_port>`为宿主机端口（如8080）
- `-v /data/komga/config:/config`：挂载配置目录，持久化KOMGA配置文件
- `-v /data/komga/data:/data`：挂载数据目录，存储漫画资源及应用数据
- `-e TZ=Asia/Shanghai`：设置时区为上海，确保日志时间与本地一致
- `--restart unless-stopped`：容器退出时自动重启（除非手动停止）

### 自定义配置调整

根据实际需求，可添加以下可选参数优化部署：

#### 资源限制
为避免容器过度占用系统资源，可通过`--memory`和`--cpus`限制资源使用：

```bash
--memory=2G --cpus=1
```

#### 环境变量扩展
根据[KOMGA镜像文档（轩辕）](https://xuanyuan.cloud/r/gotson/komga)，可添加应用特定环境变量，如设置管理员账户：

```bash
-e ADMIN_USER=admin -e ADMIN_PASSWORD=your_secure_password
```

> **注意**：生产环境中，密码应使用强密码并避免明文暴露，建议通过文件挂载或密钥管理工具传递敏感信息。

### 部署验证

容器启动后，通过以下命令检查运行状态：

```bash
docker ps | grep komga
```

若输出中`STATUS`为`Up`，则表示容器正常运行。


## 功能测试

### 服务访问测试

KOMGA启动后，可通过宿主机IP和映射的端口访问服务。若使用默认配置且映射端口为8080，可在浏览器中访问：

```
http://<server_ip>:8080
```

或通过`curl`命令测试API响应：

```bash
curl -I http://<server_ip>:8080
```

若返回`200 OK`或类似成功状态码，则表示服务可正常访问。

### 日志查看

通过容器日志可排查服务启动及运行过程中的问题：

```bash
docker logs komga
```

重点关注是否有`Started KomgaApplication`等启动成功的日志信息，或错误提示（如端口占用、目录权限问题）。

### 基础功能验证

1. **资源添加测试**：通过Web界面或API上传测试漫画文件，验证资源是否能被正确识别
2. **API访问测试**：根据官方API文档（可参考[KOMGA镜像文档（轩辕）](https://xuanyuan.cloud/r/gotson/komga)），使用`curl`或API工具调用基础接口，如获取漫画列表：

```bash
curl http://<server_ip>:8080/api/v1/books
```

若返回JSON格式的资源列表，则表示核心功能正常。


## 生产环境建议

### 数据备份策略

KOMGA的数据目录（`/data/komga/data`）存储漫画资源及元数据，需定期备份以防止数据丢失：

- **手动备份**：通过`rsync`或`tar`命令定期备份挂载目录：

```bash
tar -czf /backup/komga_data_$(date +%Y%m%d).tar.gz /data/komga/data
```

- **自动备份**：使用`crontab`设置定时任务，或通过备份工具（如borgbackup）实现增量备份。

### 网络安全加固

1. **端口防护**：避免直接暴露服务端口到公网，建议通过Nginx反向代理，并启用HTTPS：

```nginx
server {
    listen 443 ssl;
    server_name komga.example.com;

    ssl_certificate /etc/nginx/certs/cert.pem;
    ssl_certificate_key /etc/nginx/certs/key.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

2. **访问控制**：通过防火墙（如ufw）限制端口访问来源，仅允许可信IP：

```bash
ufw allow from 192.168.1.0/24 to any port 8080
```

### 监控与维护

1. **容器监控**：使用`docker stats komga`实时查看容器资源占用，或通过Prometheus+Grafana监控长期性能。
2. **定期更新**：关注[KOMGA镜像标签列表](https://xuanyuan.cloud/r/gotson/komga/tags)获取新版本，按以下步骤更新：

```bash
# 拉取新版本镜像
docker pull xxx.xuanyuan.run/gotson/komga:latest
# 停止旧容器
docker stop komga
# 启动新容器（使用原部署命令）
docker run -d --name komga ... xxx.xuanyuan.run/gotson/komga:latest
# 清理旧镜像（可选）
docker rmi <旧镜像ID>
```


## 故障排查

### 容器无法启动

1. **检查端口占用**：使用`netstat`或`ss`确认宿主机端口未被占用：

```bash
ss -tuln | grep <host_port>
```

若端口已被占用，需更换`<host_port>`或停止占用进程。

2. **目录权限问题**：挂载目录权限不足会导致容器启动失败，可通过以下命令修复：

```bash
chmod -R 755 /data/komga
chown -R 1000:1000 /data/komga  # 假设容器内运行用户ID为1000
```

3. **查看启动日志**：未加`-d`参数启动容器，可直接查看控制台输出；或通过`docker logs komga`查看启动日志，定位错误原因。

### 服务无法访问

1. **容器内服务状态**：进入容器检查服务是否正常运行：

```bash
docker exec -it komga /bin/sh
# 检查服务进程
ps aux | grep komga
# 测试容器内端口
curl http://localhost:<container_port>
```

2. **防火墙规则**：检查宿主机防火墙是否放行`<host_port>`：

```bash
ufw status | grep <host_port>  # Ubuntu/Debian
firewall-cmd --list-ports | grep <host_port>  # CentOS/RHEL
```

### 数据丢失或损坏

1. **检查挂载配置**：确认`-v`参数挂载正确，避免使用临时目录：

```bash
docker inspect komga | grep Mounts -A 20
```

2. **恢复备份**：若数据损坏，使用最近备份恢复：

```bash
tar -xzf /backup/komga_data_<日期>.tar.gz -C /
```


## 参考资源

1. **KOMGA项目官方GitHub**：[https://github.com/gotson/komga](https://github.com/gotson/komga)（项目源代码及官方文档）
2. **KOMGA镜像文档（轩辕）**：[https://xuanyuan.cloud/r/gotson/komga](https://xuanyuan.cloud/r/gotson/komga)（轩辕镜像部署说明）
3. **KOMGA镜像标签列表**：[https://xuanyuan.cloud/r/gotson/komga/tags](https://xuanyuan.cloud/r/gotson/komga/tags)（所有可用镜像版本）
4. **Docker官方文档**：[https://docs.docker.com/](https://docs.docker.com/)（Docker基础操作及最佳实践）


## 总结

本文详细介绍了KOMGA的Docker容器化部署方案，从环境准备、镜像拉取、容器配置到功能测试、生产优化及故障排查，提供了完整的部署流程。通过容器化部署，用户可快速搭建KOMGA漫画服务器，实现漫画资源的集中管理与API服务。

**关键要点**：
- 使用轩辕云一键脚本快速部署Docker环境，简化前期准备工作
- 通过轩辕镜像访问支持拉取KOMGA镜像，提升下载效率
- 容器部署需注意端口映射（参考官方文档获取正确端口）和数据卷挂载，确保数据持久化
- 生产环境中需关注资源限制、网络安全、定期备份及版本更新，保障服务稳定运行

**后续建议**：
- 深入学习KOMGA高级特性，如用户权限管理、API集成、元数据管理等，提升服务可用性
- 根据实际资源规模调整容器资源配置，平衡性能与成本
- 结合自动化工具（如Docker Compose、Kubernetes）实现服务编排，简化多实例管理
- 定期查阅[KOMGA项目官方GitHub](https://github.com/gotson/komga)和[KOMGA镜像文档（轩辕）](https://xuanyuan.cloud/r/gotson/komga)，获取最新功能及安全更新信息。


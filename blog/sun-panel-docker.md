---
id: 57
title: SUN-PANEL Docker 容器化部署指南
slug: sun-panel-docker
summary: SUN-PANEL是一款多功能的服务器与NAS导航面板，同时也可作为Homepage和浏览器首页使用。它提供直观的界面，帮助用户集中管理服务器资源、NAS文件导航以及常用网页入口，适用于个人用户、家庭NAS用户及小型企业环境。SUN-PANEL支持多语言界面，提供丰富的自定义选项，能够整合各类服务链接与系统状态监控，为用户打造个性化的网络导航中心。
category: SUN-PANEL,Docker
tags: sun-panel,docker,部署教程
image_name: hslr/sun-panel
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-sun-panel.png"
status: published
created_at: "2025-11-11 08:42:03"
updated_at: "2025-11-13 01:31:51"
---

# SUN-PANEL Docker 容器化部署指南

> SUN-PANEL是一款多功能的服务器与NAS导航面板，同时也可作为Homepage和浏览器首页使用。它提供直观的界面，帮助用户集中管理服务器资源、NAS文件导航以及常用网页入口，适用于个人用户、家庭NAS用户及小型企业环境。SUN-PANEL支持多语言界面，提供丰富的自定义选项，能够整合各类服务链接与系统状态监控，为用户打造个性化的网络导航中心。

## 概述

SUN-PANEL是一款多功能的服务器与NAS导航面板，同时也可作为Homepage和浏览器首页使用。它提供直观的界面，帮助用户集中管理服务器资源、NAS文件导航以及常用网页入口，适用于个人用户、家庭NAS用户及小型企业环境。SUN-PANEL支持多语言界面，提供丰富的自定义选项，能够整合各类服务链接与系统状态监控，为用户打造个性化的网络导航中心。

## 环境准备

### Docker环境安装

部署SUN-PANEL前需确保服务器已安装Docker环境。推荐使用以下一键安装脚本，适用于主流Linux发行版（Ubuntu、Debian、CentOS、Fedora等）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，可通过以下命令验证Docker是否正常运行：

```bash
docker --version  # 查看Docker版本
docker info       # 查看Docker系统信息
```

## 镜像准备

### 镜像拉取命令

```bash
docker pull xxx.xuanyuan.run/hslr/sun-panel:latest
```

> 说明：`latest`为推荐标签（RECOMMENDED_TAG），如需指定其他版本，可将`latest`替换为具体标签，如`v1.0.0`等。

### 查看可用镜像标签

SUN-PANEL提供多个版本标签，可通过以下链接查看所有可用标签：
[SUN-PANEL镜像标签列表](https://xuanyuan.cloud/r/hslr/sun-panel/tags)

选择标签时建议考虑以下因素：
- 生产环境优先选择稳定版本标签（如`v1.2.3`）
- 测试环境可尝试最新开发版本（如`dev`或`beta`标签）
- 避免使用无版本标识的`latest`标签用于关键生产环境

### 验证镜像拉取结果

拉取完成后，通过以下命令验证镜像是否成功下载：

```bash
docker images | grep sun-panel
```

预期输出示例：
```
xxx.xuanyuan.run/hslr/sun-panel   latest    abc12345   2 weeks ago   150MB
```

## 容器部署

### 基础部署命令

以下是SUN-PANEL的基础容器启动命令，包含必要的端口映射与数据持久化配置：

```bash
docker run -d \
  --name sun-panel \
  --restart=always \
  -p 80:80 \
  -v /opt/sun-panel/data:/app/data \
  xxx.xuanyuan.run/hslr/sun-panel:latest
```

命令参数说明：
- `-d`：后台运行容器
- `--name sun-panel`：指定容器名称为sun-panel，便于后续管理
- `--restart=always`：设置容器开机自启，并在异常退出时自动重启
- `-p 80:80`：端口映射（主机端口:容器端口），此处假设容器内使用80端口提供Web服务（具体端口请参考官方文档确认）
- `-v /opt/sun-panel/data:/app/data`：数据卷挂载，将容器内数据目录持久化到主机的`/opt/sun-panel/data`目录

### 高级配置选项

根据实际需求，可添加以下高级配置参数：

#### 自定义端口映射

若主机80端口已被占用，可修改端口映射为其他端口，例如使用8080端口：

```bash
-p 8080:80
```

#### 环境变量配置

SUN-PANEL可能支持通过环境变量调整配置，例如设置时区、日志级别等（具体支持的环境变量请参考官方文档）：

```bash
-e TZ="Asia/Shanghai" \
-e LOG_LEVEL="info"
```

#### 资源限制

为避免容器过度占用系统资源，可添加资源限制参数：

```bash
--memory=512m \
--cpus=0.5
```

上述配置限制容器最大使用512MB内存和0.5个CPU核心。

### 容器状态验证

部署完成后，通过以下命令检查容器运行状态：

```bash
docker ps | grep sun-panel
```

健康运行的容器状态应为`Up`，示例输出：
```
abc123456789   xxx.xuanyuan.run/hslr/sun-panel:latest   "/entrypoint.sh"   5 minutes ago   Up 5 minutes   0.0.0.0:80->80/tcp   sun-panel
```

## 功能测试

### 访问Web界面

在浏览器中输入服务器IP地址（或域名）及映射端口，访问SUN-PANEL界面：
- 若使用默认80端口：`http://<服务器IP>`
- 若使用自定义端口（如8080）：`http://<服务器IP>:8080`

首次访问可能需要完成初始化设置，例如创建管理员账户、设置语言偏好等。

### 基础功能验证

完成初始化后，建议验证以下核心功能：

1. **界面加载测试**：确认页面元素加载完整，无明显布局错乱
2. **导航链接添加**：尝试添加一个新的导航链接（如NAS文件服务地址），验证保存功能正常
3. **主题切换**：测试深色/浅色主题切换功能（如有）
4. **响应式布局**：通过调整浏览器窗口大小，验证移动端适配效果
5. **数据持久化测试**：添加测试数据后重启容器，确认数据未丢失

```bash
# 重启容器命令（用于测试数据持久化）
docker restart sun-panel
```

### 登录与权限验证

若系统包含用户认证功能，测试以下场景：
- 使用管理员账户登录，确认具备全部操作权限
- 尝试使用错误凭据登录，验证权限控制有效
- （如有）创建普通用户，测试权限分级效果

## 生产环境建议

### 数据安全强化

1. **数据备份策略**
   - 定期备份持久化目录`/opt/sun-panel/data`，建议每日自动备份
   - 备份命令示例：
     ```bash
     mkdir -p /var/backups/sun-panel
     cp -r /opt/sun-panel/data /var/backups/sun-panel/$(date +%Y%m%d)
     ```

2. **权限控制**
   - 限制主机数据目录权限，仅允许必要用户访问：
     ```bash
     chmod -R 700 /opt/sun-panel/data
     chown -R root:root /opt/sun-panel/data
     ```

### 网络安全配置

1. **端口安全**
   - 避免直接暴露80/443端口到公网，建议通过反向代理（如Nginx）转发
   - 配置防火墙，仅允许特定IP段访问SUN-PANEL服务：
     ```bash
     # UFW防火墙示例（允许192.168.1.0/24网段访问80端口）
     ufw allow from 192.168.1.0/24 to any port 80
     ```

2. **HTTPS加密**
   通过Nginx或Traefik等反向代理配置HTTPS，示例Nginx配置片段：
   ```nginx
   server {
       listen 443 ssl;
       server_name panel.example.com;
       
       ssl_certificate /etc/nginx/certs/fullchain.pem;
       ssl_certificate_key /etc/nginx/certs/privkey.pem;
       
       location / {
           proxy_pass http://localhost:80;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

### 容器管理优化

1. **监控集成**
   - 使用Prometheus+Grafana监控容器资源使用情况
   - 配置容器健康检查：
     ```bash
     docker run -d \
       --name sun-panel \
       --restart=always \
       -p 80:80 \
       -v /opt/sun-panel/data:/app/data \
       --health-cmd "curl -f http://localhost/ || exit 1" \
       --health-interval 30s \
       --health-timeout 10s \
       --health-retries 3 \
       xxx.xuanyuan.run/hslr/sun-panel:latest
     ```

2. **日志管理**
   - 配置日志轮转，避免日志文件过大：
     ```bash
     # 创建日志轮转配置文件
     cat > /etc/logrotate.d/docker-sun-panel << EOF
     /var/lib/docker/containers/*/*-json.log {
         daily
         rotate 7
         compress
         delaycompress
         missingok
         copytruncate
     }
     EOF
     ```

### 高可用部署

对于关键业务场景，可考虑以下高可用方案：
1. 使用Docker Compose管理多容器部署
2. 结合Kubernetes实现容器编排与自动扩缩容
3. 跨节点数据同步（如使用rsync或分布式存储）

## 故障排查

### 常见问题及解决方法

1. **容器启动失败**

   - 检查日志：
     ```bash
     docker logs sun-panel
     ```
   - 常见原因及解决：
     - 端口冲突：更换主机端口（如`-p 8080:80`）
     - 数据目录权限问题：修复目录权限`chmod -R 777 /opt/sun-panel/data`（临时测试用，生产环境需使用最小权限）
     - 镜像损坏：重新拉取镜像`docker pull xxx.xuanyuan.run/hslr/sun-panel:latest`

2. **Web界面无法访问**

   - 检查网络连接：
     ```bash
     # 检查容器端口是否监听
     docker exec sun-panel netstat -tuln
     
     # 检查主机端口映射
     netstat -tuln | grep 80
     ```
   - 防火墙规则：确保防火墙允许对应端口访问
   - 容器健康状态：
     ```bash
     docker inspect --format='{{.State.Health.Status}}' sun-panel
     ```

3. **数据丢失问题**

   - 确认数据卷挂载正确：
     ```bash
     docker inspect -f '{{ .Mounts }}' sun-panel
     ```
   - 检查宿主机目录是否存在数据文件：
     ```bash
     ls -la /opt/sun-panel/data
     ```
   - 恢复最近备份：从`/var/backups/sun-panel`目录恢复数据

4. **性能问题**

   - 检查资源使用情况：
     ```bash
     docker stats sun-panel
     ```
   - 增加资源限制：调整`--memory`和`--cpus`参数
   - 优化宿主机性能：关闭不必要的服务，增加系统资源

### 高级排查工具

1. **容器详细信息查看**
   ```bash
   docker inspect sun-panel
   ```

2. **进入容器内部调试**
   ```bash
   docker exec -it sun-panel /bin/sh
   ```

3. **查看容器进程**
   ```bash
   docker top sun-panel
   ```

## 参考资源

### 官方文档与资源

- [SUN-PANEL中文文档](https://sun-panel-doc.enianteam.com/zh_cn)
- [SUN-PANEL官方Demo](http://sunpaneldemo.enianteam.com)
- [SUN-PANEL GitHub仓库](https://github.com/hslr-s/sun-panel)

### 轩辕镜像相关资源

- [SUN-PANEL镜像文档（轩辕）](https://xuanyuan.cloud/r/hslr/sun-panel)
- [SUN-PANEL镜像标签列表](https://xuanyuan.cloud/r/hslr/sun-panel/tags)
- [轩辕镜像访问支持服务说明](https://xuanyuan.cloud)

### 相关技术文档

- [Docker官方文档](https://docs.docker.com/)
- [Docker Compose使用指南](https://docs.docker.com/compose/)
- [Nginx反向代理配置](https://nginx.org/en/docs/)

## 总结

本文详细介绍了SUN-PANEL的Docker容器化部署方案，从环境准备、镜像拉取到容器部署、功能测试及生产环境优化，提供了一套完整的实施指南。通过容器化部署，用户可快速搭建SUN-PANEL服务，实现服务器与NAS资源的集中管理与导航。

**关键要点**：
- 使用一键脚本可快速完成Docker环境部署与轩辕镜像访问支持配置
- 镜像拉取需根据名称结构选择正确格式，`hslr/sun-panel`采用多段镜像名格式
- 数据持久化是生产环境部署的关键，需确保挂载目录正确配置
- 定期备份与监控是保障服务稳定运行的重要措施

**后续建议**：
- 深入学习SUN-PANEL高级特性，如自定义主题、API集成等功能
- 根据实际业务需求调整容器资源配置，平衡性能与资源消耗
- 关注项目官方更新，及时升级镜像以获取新功能与安全修复
- 探索容器编排方案，如Docker Compose或Kubernetes，提升服务可用性

通过本文档提供的方案，用户可在各类Linux环境中快速部署稳定、安全的SUN-PANEL服务，有效提升服务器与NAS资源的管理效率。


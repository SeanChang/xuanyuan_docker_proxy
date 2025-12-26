# QUARTZUI Docker 容器化部署指南

![QUARTZUI Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-quartzui.png)

*分类: Docker,QUARTZUI | 标签: quartzui,docker,部署教程 | 发布时间: 2025-12-02 03:31:15*

> QUARTZUI 是一款基于 Quartz.NET 3.0 的 Web 管理界面，专为简化定时任务管理而设计。该工具采用容器化打包，实现开箱即用，内置 SQLite 持久化存储，具有语言无关性、业务代码零污染、支持 RESTful 风格接口等特性，配置过程简单直观，适合各类需要定时任务管理的场景。

## 概述

QUARTZUI 是一款基于 Quartz.NET 3.0 的 Web 管理界面，专为简化定时任务管理而设计。该工具采用容器化打包，实现开箱即用，内置 SQLite 持久化存储，具有语言无关性、业务代码零污染、支持 RESTful 风格接口等特性，配置过程简单直观，适合各类需要定时任务管理的场景。

本文档将详细介绍如何通过 Docker 容器化方式部署 QUARTZUI，包括环境准备、镜像拉取、容器部署、功能测试及生产环境优化建议，旨在为用户提供一套完整、可复现的部署方案。


## 环境准备

### Docker 环境安装

部署 QUARTZUI 前需确保服务器已安装 Docker 环境。推荐使用以下一键安装脚本，自动完成 Docker 及相关组件的安装与配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本执行完成后，可通过以下命令验证 Docker 是否安装成功：

```bash
docker --version  # 验证Docker引擎版本
docker-compose --version  # 验证Docker Compose版本（若已安装）
```

## 镜像准备

### 镜像信息确认

QUARTZUI 官方 Docker 镜像信息如下：
- 推荐标签：`latest`（稳定版本）
- 标签列表：[QUARTZUI 镜像标签列表](https://xuanyuan.cloud/r/bennyzhao/quartzui/tags)


### 镜像拉取命令

根据镜像名称格式（多段镜像名），采用以下命令通过轩辕镜像访问支持拉取：

```bash
# 拉取推荐的latest标签
docker pull xxx.xuanyuan.run/bennyzhao/quartzui:latest

# 如需指定其他版本，替换标签即可（例如拉取1.0.0版本）
# docker pull xxx.xuanyuan.run/bennyzhao/quartzui:1.0.0
```

拉取完成后，可通过以下命令验证镜像是否成功下载：

```bash
docker images | grep bennyzhao/quartzui
```

若输出类似以下结果，说明镜像拉取成功：
```
xxx.xuanyuan.run/bennyzhao/quartzui   latest    abc12345   2 weeks ago   500MB
```


## 容器部署

### 基础部署命令

基于拉取的镜像，通过以下命令启动 QUARTZUI 容器，实现基础功能部署：

```bash
docker run -d \
  --name quartzui \
  --restart=unless-stopped \
  --privileged=true \
  -p 5088:80 \
  -v /fileData/quartzuifile:/app/File \
  xxx.xuanyuan.run/bennyzhao/quartzui:latest
```

### 参数说明

上述命令各参数作用如下：
- `-d`：后台运行容器
- `--name quartzui`：指定容器名称为 `quartzui`，便于后续管理
- `--restart=unless-stopped`：容器退出时自动重启（除非手动停止）
- `--privileged=true`：赋予容器扩展权限，确保数据卷挂载及文件操作正常
- `-p 5088:80`：端口映射，将容器内 80 端口映射到主机 5088 端口（主机端口可根据需求调整）
- `-v /fileData/quartzuifile:/app/File`：数据卷挂载，将宿主机 `/fileData/quartzuifile` 目录挂载到容器内 `/app/File` 目录，用于持久化 SQLite 数据库文件及日志


### 部署验证

容器启动后，通过以下命令检查运行状态：

```bash
# 查看容器运行状态
docker ps | grep quartzui

# 查看容器日志（确认启动过程无错误）
docker logs -f quartzui
```

若日志输出类似 `Application started. Press Ctrl+C to shut down.`，说明容器启动成功。


## 功能测试

### 访问 Web 界面

在浏览器中输入以下地址访问 QUARTZUI 管理界面：
```
http://<服务器IP>:5088
```

其中 `<服务器IP>` 替换为部署容器的服务器实际 IP 地址。若访问成功，将显示 QUARTZUI 的登录或主界面（具体取决于版本设计）。


### 核心功能验证

#### 1. 界面加载测试
- 验证指标：页面是否正常加载，无 404/500 等错误。
- 操作步骤：访问上述 URL，观察页面响应情况。


#### 2. 任务管理测试
- 验证指标：能否正常添加、编辑、删除定时任务。
- 操作步骤：
  1. 在界面中找到“任务管理”模块，点击“新增任务”；
  2. 填写任务名称、Cron 表达式（如 `0/10 * * * * ?` 表示每 10 秒执行一次）、任务描述等信息；
  3. 保存任务，观察任务是否出现在列表中；
  4. 尝试编辑任务参数，确认修改生效；
  5. 删除任务，确认列表中任务已移除。


#### 3. 数据持久化测试
- 验证指标：容器重启后，任务数据是否保留。
- 操作步骤：
  1. 添加一个测试任务并保存；
  2. 执行 `docker restart quartzui` 重启容器；
  3. 重新访问界面，检查之前添加的任务是否仍存在。


## 生产环境建议

### 安全性优化

1. **非 root 用户运行**  
   默认容器以 root 用户运行，存在安全风险。建议通过 `--user` 参数指定非 root 用户运行：
   ```bash
   # 提前在宿主机创建用户（例如 uid=1001，gid=1001）
   docker run -d \
     --name quartzui \
     --restart=unless-stopped \
     --user 1001:1001 \
     -p 5088:80 \
     -v /fileData/quartzuifile:/app/File \
     xxx.xuanyuan.run/bennyzhao/quartzui:latest
   ```

2. **数据卷权限控制**  
   限制宿主机挂载目录权限，仅赋予必要读写权限：
   ```bash
   # 创建目录并设置权限
   mkdir -p /fileData/quartzuifile
   chown -R 1001:1001 /fileData/quartzuifile
   chmod -R 700 /fileData/quartzuifile  # 仅所有者可读写
   ```


### 性能与稳定性优化

1. **资源限制**  
   通过 `--memory` 和 `--cpus` 限制容器资源占用，避免影响其他服务：
   ```bash
   docker run -d \
     --name quartzui \
     --restart=unless-stopped \
     --memory=512m \  # 限制最大内存为512MB
     --cpus=0.5 \     # 限制CPU使用为0.5核
     -p 5088:80 \
     -v /fileData/quartzuifile:/app/File \
     xxx.xuanyuan.run/bennyzhao/quartzui:latest
   ```

2. **日志管理**  
   配置日志轮转，避免日志文件过大：
   ```bash
   docker run -d \
     --name quartzui \
     --log-driver json-file \
     --log-opt max-size=10m \  # 单个日志文件最大10MB
     --log-opt max-file=3 \    # 最多保留3个日志文件
     -p 5088:80 \
     -v /fileData/quartzuifile:/app/File \
     xxx.xuanyuan.run/bennyzhao/quartzui:latest
   ```


### 高可用建议

1. **数据备份**  
   定期备份挂载的数据卷目录 `/fileData/quartzuifile`，避免数据丢失：
   ```bash
   # 每日凌晨3点备份（可通过crontab配置）
   0 3 * * * tar -zcvf /backup/quartzui_$(date +%Y%m%d).tar.gz /fileData/quartzuifile
   ```

2. **负载均衡**  
   若需支持高并发，可部署多个 QUARTZUI 实例，通过 Nginx 等反向代理实现负载均衡：
   ```nginx
   # Nginx配置示例
   http {
     upstream quartzui_servers {
       server 127.0.0.1:5088;  # 实例1
       server 127.0.0.1:5089;  # 实例2（需修改端口并启动第二个容器）
     }
     
     server {
       listen 80;
       server_name quartzui.example.com;
       
       location / {
         proxy_pass http://quartzui_servers;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
       }
     }
   }
   ```


## 故障排查

### 常见问题及解决方法

#### 1. 容器启动后无法访问 Web 界面

**排查步骤**：
1. 检查容器是否正常运行：`docker ps | grep quartzui`，若未运行，执行 `docker logs quartzui` 查看错误日志。
2. 检查端口映射是否冲突：`netstat -tuln | grep 5088`，若端口已被占用，修改 `-p` 参数更换主机端口（例如 `-p 5089:80`）。
3. 检查防火墙规则：确保主机 5088 端口已开放（例如 `ufw allow 5088` 或 `firewall-cmd --add-port=5088/tcp --permanent`）。

**解决示例**：若日志显示“Address already in use”，说明端口冲突，重新启动容器并更换端口：
```bash
docker stop quartzui && docker rm quartzui
docker run -d --name quartzui --restart=unless-stopped -p 5089:80 -v /fileData/quartzuifile:/app/File xxx.xuanyuan.run/bennyzhao/quartzui:latest
```


#### 2. 任务数据重启后丢失

**排查步骤**：
1. 检查数据卷挂载是否正确：`docker inspect quartzui | grep Mounts -A 20`，确认宿主机目录 `/fileData/quartzuifile` 已正确挂载到 `/app/File`。
2. 检查宿主机目录权限：`ls -ld /fileData/quartzuifile`，确保容器用户有读写权限（例如权限为 `drwx------ 2 1001 1001`）。

**解决示例**：若权限不足，修正宿主机目录权限：
```bash
chown -R 1001:1001 /fileData/quartzuifile
chmod -R 700 /fileData/quartzuifile
docker restart quartzui
```


#### 3. 容器频繁重启

**排查步骤**：
1. 查看容器退出码：`docker inspect -f '{{.State.ExitCode}}' quartzui`，非 0 表示异常退出。
2. 查看详细日志：`docker logs quartzui`，根据日志中的错误信息定位问题（如内存溢出、配置错误等）。

**解决示例**：若日志显示“Out of memory”，增加容器内存限制：
```bash
docker stop quartzui && docker rm quartzui
docker run -d --name quartzui --restart=unless-stopped --memory=1g -p 5088:80 -v /fileData/quartzuifile:/app/File xxx.xuanyuan.run/bennyzhao/quartzui:latest
```


## 参考资源

1. **项目官方资源**  
   - [QUARTZUI GitHub 仓库](https://github.com/zhaopeiym/quartzui)（项目源代码及官方文档）

2. **轩辕镜像资源**  
   - [QUARTZUI 镜像文档（轩辕）](https://xuanyuan.cloud/r/bennyzhao/quartzui)（镜像详细说明）
   - [QUARTZUI 镜像标签列表](https://xuanyuan.cloud/r/bennyzhao/quartzui/tags)（所有可用版本标签）

3. **Docker 官方文档**  
   - [Docker Run 命令参考](https://docs.docker.com/engine/reference/commandline/run/)
   - [Docker 数据卷管理](https://docs.docker.com/storage/volumes/)


## 总结

本文详细介绍了 QUARTZUI 的 Docker 容器化部署方案，从环境准备、镜像拉取到容器部署、功能测试，再到生产环境优化及故障排查，提供了一套完整的操作指南。通过容器化部署，可快速实现 QUARTZUI 的开箱即用，同时保障数据持久化与服务稳定性。


### 关键要点
- **环境准备**：使用一键脚本 `bash <(wget -qO- https://xuanyuan.cloud/docker.sh)` 快速部署 Docker 环境，自动配置轩辕镜像访问支持。
- **镜像拉取**：采用命令 `docker pull xxx.xuanyuan.run/bennyzhao/quartzui:latest` 拉取。
- **容器部署**：核心命令为 `docker run -d --name quartzui --restart=unless-stopped -p 5088:80 -v /fileData/quartzuifile:/app/File xxx.xuanyuan.run/bennyzhao/quartzui:latest`，需注意数据卷挂载以保证数据持久化。
- **功能验证**：通过访问 `http://<服务器IP>:5088` 验证 Web 界面加载、任务管理及数据持久化功能。


### 后续建议
- **深入学习**：参考 [QUARTZUI GitHub 仓库](https://github.com/zhaopeiym/quartzui) 探索高级特性，如 RESTful API 集成、任务监控告警等。
- **配置优化**：根据业务需求调整容器资源限制（内存、CPU）、日志策略及端口映射。
- **安全加固**：生产环境中建议启用 HTTPS（通过 Nginx 反向代理配置 SSL）、限制容器权限，并定期更新镜像至最新稳定版本。


### 参考链接
- [QUARTZUI GitHub 官方仓库](https://github.com/zhaopeiym/quartzui)
- [QUARTZUI 镜像文档（轩辕）](https://xuanyuan.cloud/r/bennyzhao/quartzui)
- [Docker 官方文档 - Run 命令](https://docs.docker.com/engine/reference/commandline/run/)


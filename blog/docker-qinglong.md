# Docker 容器化部署 QINGLONG 面板指南

![Docker 容器化部署 QINGLONG 面板指南](https://img.xuanyuan.dev/docker/blog/docker-qinglong.png)

*分类: QINGLONG,Docker | 标签: qinglong,docker,部署教程 | 发布时间: 2025-11-09 11:02:10*

> QINGLONG（中文名称：青龙）是一款支持多脚本语言的定时任务管理面板，具备脚本在线管理、环境变量配置、任务日志查看、系统级通知等核心功能。该工具支持Python3、JavaScript、Shell、TypeScript等多种脚本语言，提供深色模式和移动端操作支持，适用于需要自动化任务调度的场景。

## 概述

QINGLONG（中文名称：青龙）是一款支持多脚本语言的定时任务管理面板，具备脚本在线管理、环境变量配置、任务日志查看、系统级通知等核心功能。该工具支持Python3、JavaScript、Shell、TypeScript等多种脚本语言，提供深色模式和移动端操作支持，适用于需要自动化任务调度的场景。

本文档提供基于Docker容器化技术的QINGLONG部署方案，通过容器化部署可实现环境隔离、快速迁移和版本控制，简化部署流程并提高系统可靠性。


## 环境准备

### Docker环境安装

QINGLONG采用Docker容器化部署，需先确保服务器已安装Docker环境。推荐使用以下一键安装脚本：

```bash
# 一键安装Docker环境（支持主流Linux发行版）
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本执行过程中需根据提示完成权限配置，安装完成后可通过以下命令验证Docker状态：

```bash
# 验证Docker服务状态
systemctl status docker

# 验证Docker版本信息
docker --version
```


## 镜像准备

### 镜像信息确认

QINGLONG官方Docker镜像信息如下：
- 镜像名称：`whyour/qinglong`
- 推荐标签：`latest`（基于Alpine构建）、`debian`（基于Debian-slim构建，适用于需要特定依赖的场景）
- 镜像文档：[QINGLONG部署文档](https://xuanyuan.cloud/r/whyour/qinglong)
- 标签列表：[QINGLONG镜像标签](https://xuanyuan.cloud/r/whyour/qinglong/tags)

### 镜像拉取命令

使用轩辕镜像访问支持地址拉取命令如下：

```bash
# 拉取最新稳定版（Alpine基础镜像）
docker pull docker.xuanyuan.me/whyour/qinglong:latest

# 如需使用Debian基础镜像（适用于依赖Alpine不支持的场景）
docker pull docker.xuanyuan.me/whyour/qinglong:debian
```

> **说明**：若需要特定版本，可将`latest`替换为具体版本标签，如`v2.15.0`，版本列表可参考[QINGLONG镜像标签](https://xuanyuan.cloud/r/whyour/qinglong/tags)。

### 镜像验证

拉取完成后，通过以下命令验证镜像信息：

```bash
# 查看本地镜像列表
docker images | grep whyour/qinglong

# 输出示例（版本号可能不同）：
# docker.xuanyuan.me/whyour/qinglong   latest    abc12345   2 weeks ago   500MB
```


## 容器部署

### 基础部署（单容器模式）

推荐使用以下命令部署QINGLONG容器，包含数据持久化、端口映射和基础配置：

```bash
# 创建数据目录（用于持久化存储配置和任务数据）
mkdir -p $PWD/ql/data

# 启动QINGLONG容器
docker run -dit \
  --name qinglong \                   # 容器名称
  --hostname qinglong \               # 容器主机名
  --restart unless-stopped \          # 重启策略：异常退出时自动重启
  -v $PWD/ql/data:/ql/data \          # 挂载数据卷（持久化配置和任务数据）
  -p 5700:5700 \                      # 端口映射（主机端口:容器端口，默认5700）
  -e QlBaseUrl="/" \                  # 基础路径（默认为"/"，子路径部署时需修改）
  -e QlPort="5700" \                  # 服务端口（需与容器端口保持一致）
  docker.xuanyuan.me/whyour/qinglong:latest  # 镜像地址及标签
```

> **参数说明**：
> - `-v $PWD/ql/data:/ql/data`：数据卷挂载，确保容器重启后配置、任务和日志不丢失
> - `-p 5700:5700`：默认端口映射，若服务器5700端口已被占用，可修改主机端口（如`8080:5700`）
> - `--restart unless-stopped`：确保服务异常退出后自动恢复，提高可用性

### 高级部署（自定义配置）

根据实际需求，可添加以下环境变量和配置参数：

```bash
docker run -dit \
  --name qinglong \
  --hostname qinglong \
  --restart unless-stopped \
  -v $PWD/ql/data:/ql/data \
  -v $PWD/ql/scripts:/ql/scripts \     # 额外挂载自定义脚本目录
  -p 5700:5700 \
  -e QlBaseUrl="/" \
  -e QlPort="5700" \
  -e QlConfig="/ql/data/config/config.js" \  # 配置文件路径
  -e TZ="Asia/Shanghai" \               # 设置时区（默认可能为UTC，建议显式指定）
  -e LANG="zh_CN.UTF-8" \               # 设置语言编码
  --memory 2g \                         # 内存限制（根据服务器配置调整）
  --cpus 1 \                            # CPU核心限制
  docker.xuanyuan.me/whyour/qinglong:latest
```

### Docker Compose部署（推荐生产环境）

对于多容器协同或更复杂的部署场景，推荐使用Docker Compose管理服务。

#### 1. 安装Docker Compose

```bash
# 安装Docker Compose（适用于Linux x86_64架构）
curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 添加执行权限
chmod +x /usr/local/bin/docker-compose

# 验证安装
docker-compose --version
```

#### 2. 创建docker-compose.yml文件

```yaml
version: '3.8'

services:
  qinglong:
    image: docker.xuanyuan.me/whyour/qinglong:latest
    container_name: qinglong
    hostname: qinglong
    restart: unless-stopped
    volumes:
      - ./ql/data:/ql/data
      # 可选：挂载自定义脚本目录
      # - ./ql/scripts:/ql/scripts
    ports:
      - "5700:5700"
    environment:
      - QlBaseUrl="/"
      - QlPort="5700"
      - TZ="Asia/Shanghai"
      - LANG="zh_CN.UTF-8"
    # 可选：资源限制
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 2G
```

#### 3. 启动服务

```bash
# 在docker-compose.yml所在目录执行
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```


## 功能测试

### 服务访问验证

容器启动后（约30秒初始化时间），通过以下方式访问QINGLONG管理界面：

```
http://服务器IP:5700
```

首次访问需完成初始化配置，根据页面提示设置管理员账号密码。

### 核心功能测试

#### 1. 任务管理测试

1. 登录管理界面后，进入「任务管理」模块
2. 点击「新建任务」，配置以下参数：
   - 任务名称：测试任务
   - 命令类型：Shell
   - 执行命令：`echo "Hello QINGLONG" u0026u0026 date`
   - 定时规则：`*/1 * * * *`（每分钟执行一次）
3. 保存任务并手动触发执行，查看日志输出是否正常

#### 2. 脚本管理测试

1. 进入「脚本管理」模块，点击「新建脚本」
2. 输入脚本名称（如`test.js`），选择JavaScript类型
3. 输入测试代码：
   ```javascript
   console.log("QINGLONG JavaScript测试脚本");
   console.log("当前时间：", new Date().toLocaleString());
   ```
4. 保存脚本后，创建任务执行该脚本，验证脚本运行正常

#### 3. 环境变量配置测试

1. 进入「环境变量」模块，点击「新增变量」
2. 设置变量名：`TEST_ENV`，变量值：`Hello World`
3. 创建测试任务，执行命令：`echo $TEST_ENV`
4. 查看任务日志，确认环境变量生效（输出`Hello World`）

### 服务可用性验证

```bash
# 检查容器运行状态
docker inspect -f '{{.State.Status}}' qinglong

# 输出应为"running"，表示容器正常运行

# 检查端口监听状态
netstat -tuln | grep 5700

# 输出示例（表示5700端口已正常监听）：
# tcp6       0      0 :::5700                 :::*                    LISTEN
```


## 生产环境建议

### 数据备份策略

QINGLONG的核心数据存储在`/ql/data`目录，建议配置定期备份：

```bash
# 创建备份脚本（backup_ql.sh）
#!/bin/bash
BACKUP_DIR="/var/backups/qinglong"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# 备份数据目录
tar -zcvf $BACKUP_DIR/ql_data_$TIMESTAMP.tar.gz -C $(dirname $PWD/ql/data) $(basename $PWD/ql/data)

# 保留最近30天备份
find $BACKUP_DIR -name "ql_data_*.tar.gz" -mtime +30 -delete
```

添加执行权限并配置定时任务：

```bash
# 添加执行权限
chmod +x backup_ql.sh

# 配置每日凌晨3点自动备份
crontab -e
# 添加以下内容
0 3 * * * /path/to/backup_ql.sh
```

### 安全加固措施

1. **端口安全**：生产环境建议通过反向代理（如Nginx）访问QINGLONG，避免直接暴露端口，并配置HTTPS加密传输：

```nginx
# Nginx配置示例
server {
    listen 443 ssl;
    server_name qinglong.example.com;  # 替换为实际域名

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://127.0.0.1:5700;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

2. **权限控制**：限制数据目录权限，避免容器内权限溢出：

```bash
# 设置数据目录权限（仅当前用户可写）
chmod 700 $PWD/ql/data
```

3. **密码策略**：配置强密码并定期更换，启用两步验证（在QINGLONG管理界面「系统设置」中开启）。

### 性能优化建议

1. **资源配置**：根据任务数量调整容器资源限制，建议最低配置：
   - CPU：1核
   - 内存：1GB
   - 磁盘：10GB（SSD推荐，提升IO性能）

2. **日志轮转**：配置Docker日志轮转，避免日志文件占用过多磁盘空间：

```bash
# 创建Docker日志配置文件
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# 重启Docker服务使配置生效
sudo systemctl restart docker
```

3. **镜像选择**：若任务依赖较多系统库，建议使用`debian`标签镜像（`whyour/qinglong:debian`），避免Alpine系统的依赖兼容性问题。


## 故障排查

### 容器启动失败

#### 问题现象
执行`docker run`后容器未正常启动，通过`docker ps`查看无运行中的qinglong容器。

#### 排查步骤

1. **查看启动日志**：
   ```bash
   docker logs qinglong
   ```

2. **常见原因及解决方法**：
   - **端口冲突**：日志中出现`bind: address already in use`，需修改主机端口映射（如`-p 5701:5700`）
   - **数据卷权限**：日志中出现`permission denied`，需检查数据目录权限：
     ```bash
     # 修复目录权限
     chown -R 1000:1000 $PWD/ql/data  # 假设容器内运行用户ID为1000
     ```
   - **镜像损坏**：尝试重新拉取镜像：
     ```bash
     docker pull docker.xuanyuan.me/whyour/qinglong:latest
     ```

### 服务访问异常

#### 问题现象
容器状态正常，但无法通过浏览器访问管理界面。

#### 排查步骤

1. **网络连通性检查**：
   ```bash
   # 检查服务器本地访问
   curl http://127.0.0.1:5700

   # 检查防火墙规则
   firewall-cmd --list-ports  # 查看开放端口（CentOS）
   ufw status                 # 查看防火墙状态（Ubuntu）
   ```

2. **容器网络检查**：
   ```bash
   # 查看容器IP
   docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' qinglong

   # 进入容器测试服务状态
   docker exec -it qinglong curl http://localhost:5700
   ```

3. **配置检查**：确认`QlPort`环境变量与端口映射一致，基础路径`QlBaseUrl`配置正确。

### 任务执行失败

#### 问题现象
任务状态显示失败，日志中出现错误信息。

#### 排查步骤

1. **查看详细日志**：在管理界面「任务管理」中点击任务「日志」按钮，查看具体错误信息。

2. **常见原因及解决方法**：
   - **依赖缺失**：日志中出现`command not found`，需在容器内安装依赖：
     ```bash
     # 进入容器
     docker exec -it qinglong /bin/sh
     
     # Alpine系统安装依赖（以curl为例）
     apk add --no-cache curl
     
     # Debian系统安装依赖
     apt update u0026u0026 apt install -y curl
     ```
   - **脚本语法错误**：根据日志提示修正脚本语法
   - **环境变量缺失**：检查任务依赖的环境变量是否已配置


## 参考资源

### 官方文档
- QINGLONG轩辕镜像文档：[https://xuanyuan.cloud/r/whyour/qinglong](https://xuanyuan.cloud/r/whyour/qinglong)
- QINGLONG镜像标签：[https://xuanyuan.cloud/r/whyour/qinglong/tags](https://xuanyuan.cloud/r/whyour/qinglong/tags)

### Docker相关文档
- Docker官方文档：[https://docs.docker.com/](https://docs.docker.com/)
- Docker Compose文档：[https://docs.docker.com/compose/](https://docs.docker.com/compose/)

### 技术社区
- QINGLONG GitHub仓库：[https://github.com/whyour/qinglong](https://github.com/whyour/qinglong)


## 总结

本文详细介绍了QINGLONG的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境优化及故障排查等环节，为QINGLONG的快速上手指南。通过容器化部署，可显著降低环境配置复杂度，提高系统可维护性和迁移效率。

**关键要点**：
- 使用轩辕一键脚本可快速部署Docker环境并配置镜像访问支持
- 镜像拉取需注意非官方镜像格式（`whyour/qinglong`），无需添加`library`前缀
- 数据卷挂载是确保配置和任务持久化的核心步骤，生产环境必须配置
- 端口映射和环境变量需保持一致，避免服务访问异常

**后续建议**：
- 深入学习QINGLONG内置命令（如`task`、`ql`）以提升任务管理效率
- 根据实际业务需求调整容器资源配置，平衡性能与资源消耗
- 定期关注官方更新日志，及时获取功能优化和安全补丁
- 结合监控工具（如Prometheus、Grafana）实现服务状态实时监控


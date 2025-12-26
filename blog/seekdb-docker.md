# SEEKDB Docker 容器化部署指南

![SEEKDB Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-seekdb.png)

*分类: Docker,SEEKDB | 标签: seekdb,docker,部署教程 | 发布时间: 2025-12-03 15:10:26*

> OceanBase seekdb 是 OceanBase 打造的一款开发者友好的 AI 原生数据库产品，专注于为 AI 应用提供高效的混合搜索能力。它支持向量、文本、结构化与半结构化数据的统一存储与检索，并通过内置 AI Functions 支持数据嵌入、重排与库内实时推理。seekdb 在继承 OceanBase 核心引擎高性能优势与 MySQL 全面兼容特性的基础上，通过深度优化数据搜索架构，为开发者提供更符合 AI 应用数据处理需求的解决方案。

## 概述

OceanBase seekdb 是 OceanBase 打造的一款开发者友好的 AI 原生数据库产品，专注于为 AI 应用提供高效的混合搜索能力。它支持向量、文本、结构化与半结构化数据的统一存储与检索，并通过内置 AI Functions 支持数据嵌入、重排与库内实时推理。seekdb 在继承 OceanBase 核心引擎高性能优势与 MySQL 全面兼容特性的基础上，通过深度优化数据搜索架构，为开发者提供更符合 AI 应用数据处理需求的解决方案。

本文档将详细介绍如何通过Docker容器化方式部署SEEKDB，包括环境准备、镜像拉取、容器配置、功能测试及生产环境优化建议，为开发和测试团队提供一套完整、可复现的部署方案。所有操作基于官方推荐的最佳实践，并结合国内网络环境特点，提供镜像访问支持方案以确保部署过程高效稳定。


## 环境准备

### Docker环境安装

部署SEEKDB容器前需确保主机已安装Docker环境。推荐使用以下一键安装脚本，适用于主流Linux发行版（Ubuntu、Debian、CentOS、Fedora等）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本将自动完成Docker引擎、Docker Compose的安装，并配置开机自启。安装完成后，可通过以下命令验证Docker状态：

```bash
docker --version          # 验证Docker引擎版本
docker compose version    # 验证Docker Compose版本
systemctl status docker   # 检查Docker服务状态
```

## 镜像准备

### 拉取官方推荐版本

官方推荐标签为`latest`，执行以下命令拉取最新稳定版：

```bash
docker pull xxx.xuanyuan.run/oceanbase/seekdb:latest
```

如需指定其他版本，可通过[SEEKDB镜像标签列表](https://xuanyuan.cloud/r/oceanbase/seekdb/tags)查看所有可用标签，替换上述命令中的`latest`即可。例如拉取`v1.0.0`版本：

```bash
docker pull xxx.xuanyuan.run/oceanbase/seekdb:v1.0.0
```

### 镜像验证

拉取完成后，通过以下命令验证镜像信息：

```bash
docker images | grep oceanbase/seekdb
```

预期输出类似：

```
xxx.xuanyuan.run/oceanbase/seekdb   latest    abc12345   2 weeks ago   1.2GB
```

可通过`docker inspect`命令查看镜像详细配置（如暴露端口、环境变量默认值等）：

```bash
docker inspect xxx.xuanyuan.run/oceanbase/seekdb:latest
```


## 容器部署

### 基本部署命令

SEEKDB容器默认暴露两个端口：
- `2881`：数据库服务端口（用于客户端连接）
- `2886`：Web管理界面端口（用于可视化操作）

执行以下命令启动基础版SEEKDB容器：

```bash
docker run -d \
  --name seekdb \
  -p 2881:2881 \
  -p 2886:2886 \
  xxx.xuanyuan.run/oceanbase/seekdb:latest
```

参数说明：
- `-d`：后台运行容器
- `--name seekdb`：指定容器名称为`seekdb`（便于后续管理）
- `-p 2881:2881`：映射主机2881端口到容器2881端口
- `-p 2886:2886`：映射主机2886端口到容器2886端口

启动后，通过以下命令检查容器状态：

```bash
docker ps | grep seekdb  # 查看运行状态
docker logs -f seekdb    # 实时查看启动日志（Ctrl+C退出）
```

### 带初始化脚本的部署

如需在容器启动时自动执行SQL初始化脚本（如创建数据库、表结构、初始数据），可通过挂载脚本目录并指定环境变量实现：

1. **准备初始化脚本**：在主机创建脚本目录并编写SQL文件（支持`.sql`和`.sql.gz`格式）：

```bash
mkdir -p ./seekdb-init-scripts
# 创建示例初始化脚本（创建测试数据库和表）
cat > ./seekdb-init-scripts/init_test_db.sql << 'EOF'
CREATE DATABASE IF NOT EXISTS test_db;
USE test_db;
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO users (name, email) VALUES ('Test User', 'test@example.com');
EOF
```

2. **启动容器并挂载脚本目录**：

```bash
docker run -d \
  --name seekdb-with-init \
  -p 2881:2881 \
  -p 2886:2886 \
  -v $PWD/seekdb-init-scripts:/root/boot/init.d \  # 挂载主机脚本目录到容器内路径
  -e INIT_SCRIPTS_PATH=/root/boot/init.d \         # 指定容器内脚本目录路径
  xxx.xuanyuan.run/oceanbase/seekdb:latest
```

> **注意**：初始化脚本中请勿修改root用户密码，如需修改密码请使用`ROOT_PASSWORD`环境变量。

### 数据持久化部署

默认情况下，SEEKDB数据存储在容器内部的`/var/lib/oceanbase`目录，容器删除后数据将丢失。为实现数据持久化，需将该目录挂载到主机目录：

1. **创建主机数据目录**：

```bash
mkdir -p ./seekdb-data
chmod 777 ./seekdb-data  # 确保容器有读写权限（生产环境建议更严格的权限控制）
```

2. **启动带数据挂载的容器**：

```bash
docker run -d \
  --name seekdb-persistent \
  -p 2881:2881 \
  -p 2886:2886 \
  -v $PWD/seekdb-data:/var/lib/oceanbase \  # 挂载数据目录
  xxx.xuanyuan.run/oceanbase/seekdb:latest
```

### 环境变量配置

SEEKDB支持通过环境变量自定义配置，常用变量如下表所示：

| 变量名称           | 描述                                                                 | 默认值  | 示例值       |
|--------------------|----------------------------------------------------------------------|---------|--------------|
| ROOT_PASSWORD      | root用户密码                                                         | 空      | S3cretP@ss123|
| CPU_COUNT          | CPU核心数限制                                                        | 2       | 4            |
| MEMORY_LIMIT       | 内存限制                                                            | 2G      | 4G           |
| LOG_DISK_SIZE      | 日志磁盘大小限制                                                    | 2G      | 5G           |
| DATAFILE_SIZE      | 初始数据文件大小                                                    | 2G      | 10G          |
| DATAFILE_NEXT      | 数据文件自动扩展步长                                                | 2G      | 5G           |
| DATAFILE_MAXSIZE   | 数据文件最大大小                                                    | 50G     | 100G         |
| INIT_SCRIPTS_PATH  | 初始化SQL脚本目录（容器内路径）                                      | 空      | /root/init   |
| SEEKDB_DATABASE    | 启动时自动创建的数据库名称                                          | 空      | app_db       |

**示例：自定义资源配置和密码**

```bash
docker run -d \
  --name seekdb-custom-config \
  -p 2881:2881 \
  -p 2886:2886 \
  -v $PWD/seekdb-data:/var/lib/oceanbase \
  -e ROOT_PASSWORD="S3cretP@ss123" \
  -e CPU_COUNT=4 \
  -e MEMORY_LIMIT=8G \
  -e DATAFILE_SIZE=20G \
  -e SEEKDB_DATABASE=app_db \
  xxx.xuanyuan.run/oceanbase/seekdb:latest
```

### 自定义配置文件部署

如需修改更多SEEKDB配置参数（环境变量未覆盖的参数），可通过挂载自定义配置文件实现。默认配置文件路径为容器内`/etc/oceanbase/seekdb.cnf`，内容如下：

```ini
datafile_size=2G
datafile_next=2G
datafile_maxsize=50G
cpu_count=4
memory_limit=2G
log_disk_size=2G
# 其他参数按"key=value"格式添加
```

**部署步骤**：

1. **创建自定义配置文件**：

```bash
cat > ./seekdb.cnf << 'EOF'
datafile_size=10G
datafile_next=5G
datafile_maxsize=100G
cpu_count=8
memory_limit=16G
log_disk_size=10G
# 自定义连接超时时间
connect_timeout=300
# 自定义最大连接数
max_connections=1000
EOF
```

2. **启动容器并挂载配置文件**：

```bash
docker run -d \
  --name seekdb-custom-cnf \
  -p 2881:2881 \
  -p 2886:2886 \
  -v $PWD/seekdb-data:/var/lib/oceanbase \
  -v $PWD/seekdb.cnf:/etc/oceanbase/seekdb.cnf \  # 挂载自定义配置文件
  xxx.xuanyuan.run/oceanbase/seekdb:latest
```

> **注意**：使用自定义配置文件时，请勿同时指定资源相关环境变量（如`CPU_COUNT`、`MEMORY_LIMIT`等），以免配置冲突。


## 功能测试

### 数据库连接测试

SEEKDB兼容MySQL协议，可使用MySQL客户端连接：

1. **安装MySQL客户端**（如未安装）：

```bash
# Ubuntu/Debian
apt-get update && apt-get install -y mysql-client

# CentOS/RHEL
yum install -y mysql

# macOS (Homebrew)
brew install mysql-client
```

2. **连接SEEKDB**：

- 未设置密码时：
  ```bash
  mysql -h 127.0.0.1 -P 2881 -u root
  ```

- 设置密码后（如`ROOT_PASSWORD=S3cretP@ss123`）：
  ```bash
  mysql -h 127.0.0.1 -P 2881 -u root -p'S3cretP@ss123'
  ```

3. **验证连接和初始化数据**：

连接成功后，执行SQL命令验证：

```sql
-- 查看数据库列表（应包含初始化脚本创建的test_db或环境变量指定的app_db）
SHOW DATABASES;

-- 查看测试表数据（如使用了初始化脚本）
USE test_db;
SELECT * FROM users;
```

预期输出：

```
+----+-----------+------------------+---------------------+
| id | name      | email            | created_at          |
+----+-----------+------------------+---------------------+
|  1 | Test User | test@example.com | 2024-05-20 12:34:56 |
+----+-----------+------------------+---------------------+
```

### Web管理界面访问

SEEKDB提供Web管理界面，通过浏览器访问：

```
http://<服务器IP>:2886
```

- **登录**：使用root用户和`ROOT_PASSWORD`环境变量设置的密码（未设置时密码为空，直接点击登录）
- **功能**：界面包含数据库管理、SQL查询、用户权限、性能监控等模块，可通过图形化方式操作数据库

### 初始化脚本执行验证

如使用了初始化脚本，可通过以下方式验证执行情况：

1. **查看容器日志**：

```bash
docker logs seekdb-with-init | grep "init scripts executed"
```

预期输出包含类似：`Successfully executed 1 init scripts from /root/boot/init.d`

2. **数据库内验证**：通过MySQL客户端连接后，检查脚本创建的数据库、表和数据是否存在（如前文"数据库连接测试"步骤）。


## 生产环境建议

### 硬件资源配置

根据业务规模，建议生产环境最低配置：

| 规格       | 小型应用（测试/开发） | 中型应用（日活10万） | 大型应用（日活100万+） |
|------------|----------------------|----------------------|------------------------|
| CPU核心数  | 2核                  | 8核                  | 16核+                  |
| 内存       | 4GB                  | 16GB                 | 32GB+                  | 50GB+
| 磁盘空间   | 20GB SSD             | 100GB SSD            | 500GB SSD+             |
| 网络带宽   | 100Mbps              | 1Gbps                | 10Gbps                 |

通过`CPU_COUNT`和`MEMORY_LIMIT`环境变量控制资源分配，建议设置为物理资源的50%-70%（预留系统和其他服务资源）。

### 数据备份策略

1. **定期备份**：通过定时任务执行数据库备份，推荐使用`mysqldump`工具：

```bash
# 创建备份脚本
cat > ./backup_seekdb.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/path/to/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# 备份全库
mysqldump -h 127.0.0.1 -P 2881 -u root -p'$ROOT_PASSWORD' --all-databases > $BACKUP_DIR/seekdb_full_$TIMESTAMP.sql

# 压缩备份文件
gzip $BACKUP_DIR/seekdb_full_$TIMESTAMP.sql

# 删除7天前的备份
find $BACKUP_DIR -name "seekdb_full_*.sql.gz" -mtime +7 -delete
EOF

# 添加执行权限
chmod +x ./backup_seekdb.sh

# 设置定时任务（每天凌晨3点执行）
crontab -e
# 添加：0 3 * * * /path/to/backup_seekdb.sh
```

2. **备份验证**：定期测试备份文件的恢复能力，确保备份有效。

3. **异地备份**：重要数据建议存储到异地或云存储服务（如AWS S3、阿里云OSS等）。

### 监控配置

1. **容器监控**：使用Prometheus+Grafana监控容器资源使用：

```bash
# 启动Prometheus（需提前准备prometheus.yml配置）
docker run -d --name prometheus -p 9090:9090 -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

# 启动Grafana
docker run -d --name grafana -p 3000:3000 grafana/grafana
```

2. **数据库监控**：集成MySQL Exporter采集数据库指标：

```bash
docker run -d \
  --name mysql-exporter \
  -e DATA_SOURCE_NAME="root:S3cretP@ss123@(127.0.0.1:2881)/" \
  prom/mysqld-exporter
```

3. **告警配置**：设置关键指标告警（如磁盘空间使用率>80%、连接数>阈值、备份失败等）。

### 安全加固

1. **密码管理**：
   - 使用强密码（至少8位，包含大小写字母、数字和特殊符号）
   - 定期更换密码（建议90天）
   - 通过环境变量`ROOT_PASSWORD`设置，避免明文存储

2. **网络隔离**：
   - 生产环境不暴露Web管理界面（2886端口）到公网，如需访问可通过VPN或跳板机
   - 限制数据库端口（2881）仅允许应用服务器访问，通过防火墙设置：
     ```bash
     # 只允许192.168.1.0/24网段访问2881端口
     ufw allow from 192.168.1.0/24 to any port 2881
     ```

3. **最小权限原则**：创建业务专用数据库用户，避免直接使用root用户：

```sql
CREATE USER 'app_user'@'%' IDENTIFIED BY 'AppP@ss123';
GRANT SELECT, INSERT, UPDATE, DELETE ON app_db.* TO 'app_user'@'%';
FLUSH PRIVILEGES;
```

4. **容器安全**：
   - 使用非root用户运行容器（需修改Dockerfile重新构建镜像）
   - 设置容器资源限制，避免资源耗尽：
     ```bash
     docker run -d \
       --name seekdb-secure \
       --memory=16g \
       --memory-swap=16g \
       --cpus=8 \
       --user=1000:1000 \  # 非root用户ID
       -p 2881:2881 \
       -v ./seekdb-data:/var/lib/oceanbase \
       xxx.xuanyuan.run/oceanbase/seekdb:latest
     ```

### 版本管理与更新

1. **版本选择**：生产环境建议使用稳定版标签（如`v1.0.0`）而非`latest`，避免自动更新到未测试版本。

2. **更新流程**：
   - 在测试环境验证新版本兼容性
   - 备份数据
   - 停止旧容器：`docker stop seekdb`
   - 启动新容器（使用新版本镜像，挂载原数据目录）：
     ```bash
     docker run -d \
       --name seekdb-new \
       -p 2881:2881 \
       -p 2886:2886 \
       -v ./seekdb-data:/var/lib/oceanbase \
       -e ROOT_PASSWORD="S3cretP@ss123" \
       xxx.xuanyuan.run/oceanbase/seekdb:v1.1.0  # 新版本标签
     ```
   - 验证新版本功能正常后，删除旧容器：`docker rm seekdb`


## 故障排查

### 容器启动失败

1. **查看启动日志**：

```bash
docker logs seekdb  # 替换为实际容器名称
```

2. **常见原因及解决**：

- **端口冲突**：日志中包含`Bind for 0.0.0.0:2881 failed: port is already allocated`
  - 解决：更换主机端口或停止占用端口的服务：
    ```bash
    # 查找占用端口的进程
    netstat -tulpn | grep 2881
    # 停止进程或更换端口映射：-p 28810:2881
    ```

- **资源不足**：日志中包含`Cannot allocate memory`或`no space left on device`
  - 解决：增加主机内存/磁盘空间，或降低`MEMORY_LIMIT`、`DATAFILE_SIZE`等配置

- **权限问题**：数据目录权限不足，日志中包含`Permission denied`
  - 解决：修改主机数据目录权限：`chmod 777 ./seekdb-data`（生产环境建议更精细的权限控制）

### 数据库连接失败

1. **检查容器状态**：

```bash
docker ps | grep seekdb  # 确保容器正在运行
```

2. **检查端口映射**：

```bash
docker port seekdb  # 查看容器端口映射情况
```

预期输出：
```
2881/tcp -> 0.0.0.0:2881
2886/tcp -> 0.0.0.0:2886
```

3. **网络连通性测试**：

```bash
telnet 127.0.0.1 2881  # 测试本地连接
telnet <服务器IP> 2881  # 测试远程连接（需开放防火墙）
```

4. **密码错误**：错误提示`Access denied for user 'root'@'localhost' (using password: YES)`
   - 解决：确认`ROOT_PASSWORD`环境变量设置正确，或通过容器日志查找初始密码（如未设置环境变量）

### 初始化脚本不执行

1. **检查挂载配置**：

```bash
# 查看容器挂载情况
docker inspect -f '{{ .Mounts }}' seekdb-with-init
```

确保主机目录正确挂载到`/root/boot/init.d`，且挂载类型为`bind`。

2. **检查脚本格式**：
   - 脚本文件必须以`.sql`或`.sql.gz`为扩展名
   - 脚本内容需符合SQL语法规范（可在本地数据库测试执行）

3. **查看脚本执行日志**：

```bash
docker logs seekdb-with-init | grep "init script"
```

根据错误提示修复脚本（如语法错误、权限问题等）。

### 性能问题排查

1. **查看数据库状态**：

```sql
SHOW STATUS;  # 查看数据库状态指标
SHOW PROCESSLIST;  # 查看当前连接和执行中的SQL
EXPLAIN <SQL语句>;  # 分析慢查询语句的执行计划
```

2. **查看容器资源使用**：

```bash
docker stats seekdb  # 实时查看CPU、内存、网络IO、磁盘IO使用情况
```

3. **常见性能问题解决**：
   - **CPU使用率高**：优化慢查询，增加CPU资源（`CPU_COUNT`）
   - **内存不足**：增加内存配置（`MEMORY_LIMIT`），优化缓存设置
   - **磁盘IO高**：使用更快的存储介质（SSD/NVMe），调整`DATAFILE_NEXT`减少文件扩展频率


## 参考资源

- [SEEKDB镜像文档（轩辕）](https://xuanyuan.cloud/r/oceanbase/seekdb)
- [SEEKDB镜像标签列表](https://xuanyuan.cloud/r/oceanbase/seekdb/tags)
- Docker官方文档：[Docker run 参考](https://docs.docker.com/engine/reference/commandline/run/)
- MySQL官方文档：[mysqldump备份工具](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)


## 总结

本文详细介绍了SEEKDB的Docker容器化部署方案，从环境准备、镜像拉取、容器配置到功能测试，提供了一套完整的实施指南。通过容器化部署，SEEKDB实现了环境一致性、快速部署和资源隔离，特别适合开发测试环境和中小型生产应用。

**关键要点**：
- 使用轩辕镜像访问支持服务可大幅提升国内环境下的镜像拉取访问表现，配置通过一键脚本自动完成
- SEEKDB镜像拉取命令格式为`docker pull xxx.xuanyuan.run/oceanbase/seekdb:{TAG}`
- 核心端口为2881（数据库服务）和2886（Web界面），生产环境建议仅暴露必要端口
- 通过环境变量（如`ROOT_PASSWORD`、`CPU_COUNT`）和自定义配置文件可灵活调整实例参数
- 数据持久化需挂载`/var/lib/oceanbase`目录，结合定期备份策略确保数据安全

**后续建议**：
- 深入学习SEEKDB的高级特性，如分布式部署、读写分离、数据分片等
- 根据业务负载特征优化数据库配置，如调整缓存大小、连接池参数、索引设计等
- 构建完善的监控告警体系，实时掌握数据库运行状态，提前发现并解决潜在问题
- 定期关注官方镜像更新，及时升级到稳定版本以获取新功能和安全补丁

通过本文档的指导，用户可快速实现SEEKDB的容器化部署，并根据实际需求进行扩展和优化，为业务应用提供可靠的数据存储服务。


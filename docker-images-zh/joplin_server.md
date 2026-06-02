---
image: joplin/server
description: "Joplin Server是开源笔记应用Joplin的官方后端服务，主要用于支持用户数据同步、笔记管理等核心功能，而官方Joplin Server Docker镜像则是由Joplin开发团队正式发布的容器化部署方案，其设计初衷是简化服务器搭建流程，确保部署环境的一致性与运行稳定性，方便用户通过Docker快速部署和运行Joplin Server，从而满足个人或团队对笔记数据的安全存储与高效同步需求。"
source: https://xuanyuan.cloud/zh/r/joplin/server
canonical: https://xuanyuan.cloud/zh/r/joplin/server
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [joplin/server — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/joplin/server)

含镜像标签、拉取命令、部署文档与相关推荐。

[joplin/server Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/joplin/server)

# Joplin Server 安装指南


## 前置要求
- **Docker Engine**：用于运行Joplin Server，需根据操作系统安装。参考[Docker官方文档]([])完成安装。  
- **Docker Compose**：若不使用PostgreSQL存储数据（如笔记、标签等内容），需安装Docker Compose。参考[Docker Compose官方文档]([])完成安装。  


## Docker环境配置
### 基础配置步骤
1. 复制[.env-sample文件]([])到Docker配置文件目录（例如`/home/[用户名]/docker`）。  
2. 将文件重命名为`.env`。  
3. 运行以下命令测试默认配置启动服务器：  
   ```shell
   docker run --env-file .env -p 22300:22300 joplin/server:latest
   ```  
   服务器默认监听本地`22300`端口，使用SQLite数据库（适合测试，无需额外配置）。生产环境需连接外部数据库，配置方法见下文。  


## Docker镜像标签说明
支持以下标签，可根据需求选择：  
- `latest`：最新稳定版  
- `beta`：最新测试版  
- 主版本号（如`2`、`2-beta`）  
- 次版本号（如`2.1`、`2.2`、`2.3-beta`）  
- 补丁版本号（如`2.0.4`、`2.2.8-beta`）  


## 数据库配置
Joplin Server支持连接现有PostgreSQL服务器或通过docker-compose创建新数据库。  

### 连接现有PostgreSQL服务器
通过`.env`文件配置数据库参数，支持两种方式：  

#### 方式1：单独配置参数
```conf
DB_CLIENT=pg
POSTGRES_PASSWORD=joplin  # 数据库密码
POSTGRES_DATABASE=joplin  # 数据库名称
POSTGRES_USER=joplin      # 数据库用户
POSTGRES_PORT=5432        # 端口（默认5432）
POSTGRES_HOST=localhost   # 数据库地址
```

#### 方式2：使用连接字符串
```conf
DB_CLIENT=pg
POSTGRES_CONNECTION_STRING=postgresql://用户名:密码@数据库地址:端口/joplin
```

> **注意**：需确保数据库及用户已存在（Joplin Server不会自动创建）。  
> - Windows/macOS（Docker Desktop）：`localhost`自动映射，无需额外配置。  
> - Linux：需在`docker run`命令中添加`--net=host --add-host=host.docker.internal:127.0.0.1`以映射本地地址。  


### 使用docker-compose创建数据库
1. 下载[示例docker-compose文件]([])到Docker配置目录（如`/home/[用户名]/docker/docker-compose.yml`）。  
2. 根据需求修改文件中的配置项（如端口、密码等）。  


## 反向代理配置（可选）
仅当需要通过互联网访问Joplin Server时需配置反向代理。可参考以下文档：  
- [Apache反向代理配置]([])  
- [Nginx反向代理配置]()  


## 存储配置（可选）
默认情况下，笔记、标签等内容存储在数据库中。如需将内容存储到外部（如文件系统、AWS S3），可通过`STORAGE_DRIVER`环境变量配置。  

### 新安装时配置存储
#### 文件系统存储
设置内容保存到本地目录：  
```env
STORAGE_DRIVER=Type=Filesystem; Path=/path/to/dir  # 替换为实际目录路径
```

#### AWS S3存储
```env
STORAGE_DRIVER=Type=S3; Region=区域代码; AccessKeyId=访问密钥; SecretAccessKeyId=密钥; Bucket=桶名称
```


### 现有安装迁移存储
需配置主存储（新位置）和回退存储（原位置），确保数据迁移过程中服务可用。  

#### 1. 配置环境变量
以从数据库迁移到文件系统为例：  
```env
STORAGE_DRIVER=Type=Filesystem; Path=/path/to/dir  # 主存储（新位置）
STORAGE_DRIVER_FALLBACK=Type=Database; Mode=ReadAndWrite  # 回退存储（原数据库）
```

> **回退模式说明**：  
> - `ReadAndWrite`：新内容同时写入主存储和回退存储（安全模式，便于回滚）。  
> - `ReadAndClear`：迁移后自动清理回退存储中的旧数据（适合确认新存储稳定后使用）。  
> 建议先使用`ReadAndWrite`模式。

#### 2. 迁移历史数据
执行命令将旧存储（如数据库）中的内容迁移到新存储（如文件系统）：  
```bash
docker exec -it 容器ID node packages/server/dist/app.js storage import --connection 'Type=Filesystem; Path=/path/to/dir'
```

#### 3. 验证迁移结果
在数据库中执行以下SQL，确认所有内容已迁移（`content_storage_id > 1`表示已迁移到新存储，`1`为数据库存储）：  
```sql
SELECT count(*), content_storage_id FROM items GROUP BY content_storage_id;
```


## 管理页面访问与配置
### 访问管理页面
- **本地访问**：`[]]:22300`  
- **互联网访问**：通过反向代理域名（如`[]  

### 修改管理员密码
默认管理员账号：  
- 邮箱：`admin@localhost`  
- 密码：`admin`  

登录后，点击右上角「Profile」修改密码（必须操作，确保安全）。  

### 创建同步用户
建议创建非管理员用户用于客户端同步：  
1. 进入「Users」页面，点击「Create User」。  
2. 使用新用户的邮箱和密码配置Joplin客户端同步。  


## 查看日志
通过Docker命令查看日志：  
```bash
# Docker方式
docker logs --follow 容器ID

# docker-compose方式
docker-compose --file docker-compose.server.yml logs
```


## 开发环境配置
### 数据库设置
#### SQLite（默认）
无需额外配置，直接使用。

#### PostgreSQL
从项目根目录运行：  
```bash
docker-compose --file docker-compose.server-dev.yml up
```

### 启动服务器
进入`packages/server`目录，运行：  
```bash
npm run start-dev
```


## 变更日志
[查看变更日志]([])


## 许可证
详见[LICENSE.md]([])

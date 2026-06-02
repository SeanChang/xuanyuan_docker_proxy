<!-- xuanyuan-docker-images-zh
image: kodcloud/kodbox
source: https://xuanyuan.cloud/zh/r/kodcloud/kodbox
canonical: https://xuanyuan.cloud/zh/r/kodcloud/kodbox
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [kodcloud/kodbox — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kodcloud/kodbox "kodcloud/kodbox Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/kodcloud/kodbox

# 可道云 Docker 镜像部署指南


## 一、快速启动  
若需快速体验可道云，直接运行以下命令启动容器（默认使用 80 端口）：  
```bash
docker run -d -p 80:80 kodcloud/kodbox
```


## 二、数据持久化配置  
为避免容器重启导致数据丢失，需创建本地目录并挂载到容器内站点目录：  

1. **创建数据目录**（本地路径可自定义，此处以 `/data` 为例）：  
   ```bash
   mkdir /data
   ```  

2. **启动容器并挂载目录**：  
   ```bash
   docker run -d -p 80:80 -v /data:/var/www/html kodcloud/kodbox
   ```  
   （`/data` 为本地目录，`/var/www/html` 为容器内站点根目录）


## 三、HTTPS 方式启动  
若需通过 HTTPS 访问，需准备 SSL 证书（格式需为 `fullchain.pem` 和 `privkey.pem`），并按以下步骤操作：  

### 使用已有 SSL 证书  
将证书文件放入本地目录（如 `/path/to/ssl`），启动容器时挂载证书目录至 `/etc/nginx/ssl`，并映射 443 端口：  
```bash
docker run -d -p 443:443 -v "/path/to/ssl":/etc/nginx/ssl --name kodbox kodcloud/kodbox
```  


## 四、使用 docker-compose 部署（推荐）  
若需完整环境（含数据库、缓存服务），推荐通过 `docker-compose` 部署，步骤如下：  

### 部署步骤  
1. **克隆仓库并进入目录**：  
   ```bash
   git clone [] kodbox
   cd ./kodbox/compose/
   ```  

2. **配置密码**：  
   - 编辑 `db.env` 文件，设置数据库密码（如 `MYSQL_ROOT_PASSWORD=your_password`）。  
   - 确保 `docker-compose.yml` 中 `MYSQL_ROOT_PASSWORD` 与 `db.env` 一致。  

3. **启动服务**：  
   ```bash
   docker-compose up -d
   ```  


### docker-compose.yml 配置说明  
以下为核心配置项解释（可根据需求修改）：  
```yaml
version: '3.5'

services:
  db:  # 数据库服务（MariaDB）
    image: mariadb:lts
    volumes:
      - "./db:/var/lib/mysql"  # 本地数据库目录（可修改为实际路径）
    environment:
      - MYSQL_ROOT_PASSWORD=  # 需与 db.env 中密码一致
    # 其他配置：事务隔离、自动升级等

  app:  # 可道云应用服务
    image: kodcloud/kodbox
    ports:
      - 80:80  # 左侧为本地访问端口（可修改，如 8080:80）
    volumes:
      - "./site:/var/www/html"  # 本地站点目录（可修改为实际路径）
    environment:
      - MYSQL_HOST=db  # 数据库服务名（与 db 服务对应）
      - REDIS_HOST=redis  # Redis 服务名（与 redis 服务对应）
    depends_on:  # 依赖服务（先启动 db 和 redis）
      - db
      - redis

  redis:  # 缓存服务（Redis）
    image: redis:alpine
```  


## 五、通过环境变量自动配置  
首次运行时，可通过环境变量预先配置数据库、管理员账户等信息，无需手动填写安装页面。  

### 1. 数据库配置（MySQL/MariaDB）  
设置以下变量后，安装时将自动读取，无需手动输入：  
- `MYSQL_DATABASE`: 数据库名（如 `kodbox_db`）。  
- `MYSQL_USER`: 数据库用户名（如 `kodbox_user`）。  
- `MYSQL_PASSWORD`: 数据库用户密码。  
- `MYSQL_HOST`: 数据库地址（如 `db`，对应 docker-compose 中的服务名）。  
- `MYSQL_PORT`: 数据库端口（默认 3306，无需修改时可省略）。  


### 2. 管理员账户配置  
若已配置数据库变量，可进一步设置管理员账户（需同时设置用户名和密码）：  
- `KODBOX_ADMIN_USER`: 管理员用户名（如 `admin`）。  
- `KODBOX_ADMIN_PASSWORD`: 管理员密码。  
- `RANDOM_ADMIN_PASSWORD`: 设为 `true` 时自动生成随机密码，可通过容器日志查看。  


### 3. 其他系统参数  
- **用户/用户组**：  
  - `PUID`: 站点运行用户（nginx）的 UID。  
  - `PGID`: 站点运行用户组的 GID。  
- **PHP 参数**（可调整性能）：  
  - `FPM_MAX`: PHP-FPM 最大进程数（默认 50）。  
  - `FPM_START`: 初始进程数（默认 10）。  
  - `FPM_MIN_SPARE`/`FPM_MAX_SPARE`: 最小/最大空闲进程数（默认 10/30）。  


## 六、其他设置  
更多高级配置（如自定义容器 IP、挂载 NFS/SMB 卷），可参考官方文档：  
- [自定义容器 IP]([])  
- [挂载 NFS 卷]([])  
- [挂载 SMB 卷]([])

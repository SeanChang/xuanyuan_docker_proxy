<!-- xuanyuan-docker-images-zh
image: bitnami/mariadb
source: https://xuanyuan.cloud/zh/r/bitnami/mariadb
canonical: https://xuanyuan.cloud/zh/r/bitnami/mariadb
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnami/mariadb" title="bitnami/mariadb Docker 镜像中文简介、标签列表与拉取命令">bitnami/mariadb — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/bitnami/mariadb" title="bitnami/mariadb Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/mariadb</a></p>

# Bitnami MariaDB 软件包介绍


## 什么是 MariaDB？

MariaDB 是一款开源的社区开发 SQL 数据库服务器，因其企业级功能、灵活性以及与主流科技公司的合作，在全球范围内被广泛使用。

[MariaDB 官方概述]([])  
**商标说明**：本软件清单由 Bitnami 打包。所提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或认可。


## Bitnami MariaDB 镜像特点

Bitnami MariaDB 镜像是经过安全加固的最小化漏洞（CVE）镜像，由 Bitnami 构建和维护。该镜像基于云优化、安全加固的企业级操作系统 Photon Linux 开发，核心优势包括：  
- 热门开源软件的安全加固镜像，接近零漏洞  
- 漏洞分类与优先级排序（含 VEX 声明、KEV 和 EPSS 评分）  
- 合规性支持（FIPS、STIG、离线部署选项），包含安全物料清单（SBOM）  
- 通过 in-toto 实现软件供应链溯源证明  
- 原生支持 Helm 图表（互联网主流部署方式）  

每个镜像均附带安全元数据，可在 [Bitnami 公共目录]([]) 中查看（部分数据需 [Bitnami 商业订阅]([])）。若需基于 Debian Linux 的旧版镜像，可参考 Bitnami Legacy 仓库。


## 快速启动（TL;DR）

以下命令适用于开发环境快速启动（**生产环境请勿使用**）：  
```console
docker run --name mariadb -e ALLOW_EMPTY_PASSWORD=yes bitnami/mariadb:latest
```

> **警告**：上述快速启动仅用于开发环境。生产环境需修改默认不安全凭据，并参考下文「配置」章节进行安全部署。


## 在 Kubernetes 中部署 MariaDB

通过 Helm 图表部署 Bitnami 应用是在 Kubernetes 上快速启动的推荐方式。具体安装步骤可参考 [Bitnami MariaDB Chart GitHub 仓库]([])。


## 为什么使用非 root 容器？

非 root 容器镜像能增加一层安全防护，通常推荐用于生产环境。但由于运行时采用非 root 用户，特权操作通常受限。更多关于非 root 容器的信息可参考 [Bitnami 文档]([])。


## 支持的标签及对应 Dockerfile 链接

Bitnami 镜像标签策略（滚动标签与固定标签的区别）可参考 [官方文档]([])。各标签的对应关系可查看分支目录下的 `tags-info.yaml` 文件（例如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）。

可通过关注 [bitnami/containers GitHub 仓库]([]) 获取项目更新。


## 获取镜像

### 推荐方式：从 Docker Hub 拉取预构建镜像  
```console
docker pull bitnami/mariadb:latest  # 拉取最新版
```  
如需指定版本，可使用标签拉取（[可用版本列表]([])）：  
```console
docker pull bitnami/mariadb:[TAG]  # 将 [TAG] 替换为具体版本，如 11.4.2
```

### 手动构建镜像  
若需自定义构建，可克隆仓库并执行 `docker build`：  
```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM  # 替换 APP、VERSION、操作系统路径占位符
docker build -t bitnami/APP:latest .
```


## 数据持久化

若直接删除容器，所有数据将丢失。为避免数据丢失，需挂载持久化卷至容器内 `/bitnami/mariadb` 路径（首次运行时，空挂载目录会自动初始化）。

### Docker 命令方式  
```console
docker run \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /本地路径/mariadb-persistence:/bitnami/mariadb \  # 替换为本地实际路径
    bitnami/mariadb:latest
```

### Docker Compose 方式  
修改项目的 [`docker-compose.yml`]([]) 文件，添加卷挂载配置：  
```yaml
services:
  mariadb:
    ...
    volumes:
      - /本地路径/mariadb-persistence:/bitnami/mariadb  # 替换为本地实际路径
    ...
```

> **注意**：由于镜像为非 root 容器，挂载的文件和目录需确保 UID `1001` 有读写权限。


## 容器间连接

通过 Docker 容器网络，MariaDB 容器可被其他应用容器访问，同一网络内的容器可通过容器名作为主机名通信。


### 基于 Docker 命令的连接  

#### 步骤 1：创建网络  
```console
docker network create app-tier --driver bridge
```

#### 步骤 2：启动 MariaDB 服务端容器  
通过 `--network app-tier` 将容器加入网络：  
```console
docker run -d --name mariadb-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    bitnami/mariadb:latest
```

#### 步骤 3：启动 MariaDB 客户端容器并连接  
启动客户端容器，通过网络连接服务端：  
```console
docker run -it --rm \
    --network app-tier \
    bitnami/mariadb:latest mysql -h mariadb-server -u root
```


### 基于 Docker Compose 的连接  

Docker Compose 会自动创建网络并将服务加入其中。以下示例中，`myapp` 服务需连接 MariaDB：  
```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  mariadb:
    image: bitnami/mariadb:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    networks:
      - app-tier
  myapp:
    image: YOUR_APPLICATION_IMAGE  # 替换为实际应用镜像
    networks:
      - app-tier
```

> **重要**：  
> 1. 需将 `YOUR_APPLICATION_IMAGE` 替换为实际应用镜像；  
> 2. 应用容器中通过主机名 `mariadb` 连接 MariaDB 服务端。

启动容器：  
```console
docker-compose up -d
```


## 配置


### 环境变量

#### 可自定义环境变量  

| 变量名                          | 描述                                                                 | 默认值       |
|---------------------------------|----------------------------------------------------------------------|--------------|
| `ALLOW_EMPTY_PASSWORD`          | 是否允许无密码访问 MariaDB                                           | `no`         |
| `MARIADB_AUTHENTICATION_PLUGIN` | 首次初始化时配置的认证插件（如 `mysql_native_password`）             | `nil`        |
| `MARIADB_ROOT_USER`             | 数据库 root 用户名称                                                 | `root`       |
| `MARIADB_ROOT_PASSWORD`         | root 用户密码                                                       | `nil`        |
| `MARIADB_USER`                  | 首次初始化时创建的普通数据库用户                                     | `nil`        |
| `MARIADB_PASSWORD`              | 普通用户密码                                                         | `nil`        |
| `MARIADB_DATABASE`              | 首次初始化时创建的数据库名称                                         | `nil`        |
| `MARIADB_MASTER_HOST`           | 主从复制中主节点的地址                                               | `nil`        |
| `MARIADB_MASTER_PORT_NUMBER`    | 主节点端口                                                           | `3306`       |
| `MARIADB_MASTER_ROOT_USER`      | 主节点 root 用户名称                                                 | `root`       |
| `MARIADB_MASTER_ROOT_PASSWORD`  | 主节点 root 用户密码                                                 | `nil`        |
| `MARIADB_REPLICATION_USER`      | 复制用户名称                                                         | `nil`        |
| `MARIADB_REPLICATION_PASSWORD`  | 复制用户密码                                                         | `nil`        |
| `MARIADB_PORT_NUMBER`           | MariaDB 服务端口                                                     | `nil`        |
| `MARIADB_CHARACTER_SET`         | 默认字符集                                                           | `utf8`       |
| `MARIADB_COLLATE`               | 默认排序规则                                                         | `utf8_general_ci` |


#### 只读环境变量（不可自定义）  

| 变量名                          | 描述                                      | 值                                  |
|---------------------------------|-------------------------------------------|-------------------------------------|
| `DB_FLAVOR`                     | 数据库类型（固定为 MariaDB）               | `mariadb`                           |
| `DB_DATA_DIR`                   | 数据文件存储路径                          | `${DB_VOLUME_DIR}/data`             |
| `DB_CONF_FILE`                  | 主配置文件路径                            | `${DB_CONF_DIR}/my.cnf`             |
| `MARIADB_DEFAULT_PORT_NUMBER`   | 默认端口                                  | `3306`                              |


### 初始化新实例  

容器首次启动时，会自动执行 `/docker-entrypoint-startdb.d` 目录下扩展名为 `.sh`、`.sql` 或 `.sql.gz` 的文件。可通过挂载卷将自定义脚本放入该目录，实现初始化逻辑（如创建表、插入数据）。  

> **说明**：`.sh` 脚本会在所有节点执行，`.sql` 和 `.sql.gz` 仅在主节点执行（主从复制场景）。导入大型数据库时，建议使用 `.sql` 格式（`.sql.gz` 需实时解压，可能影响性能）。


### 启动参数配置  

通过 `MARIADB_EXTRA_FLAGS` 环境变量可传递额外启动参数（如连接数限制）：  
```console
docker run --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_EXTRA_FLAGS='--max-connections=155 --max-connect-errors=1000' \
    bitnami/mariadb:latest
```


### 核心配置场景示例  


#### 1. 设置 root 用户密码（首次运行）  

通过 `MARIADB_ROOT_PASSWORD` 环境变量设置 root 用户密码（生产环境必须配置）：  
```console
docker run --name mariadb \
    -e MARIADB_ROOT_PASSWORD=your_secure_password \  # 替换为安全密码
    bitnami/mariadb:latest
```


#### 2. 允许空密码（仅开发环境）  

开发环境可通过 `ALLOW_EMPTY_PASSWORD=yes` 跳过密码配置（生产环境禁止）：  
```console
docker run --name mariadb -e ALLOW_EMPTY_PASSWORD=yes bitnami/mariadb:latest
```


#### 3. 首次运行时创建数据库  

通过 `MARIADB_DATABASE` 环境变量指定初始化数据库名称：  
```console
docker run --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_DATABASE=my_app_db \  # 数据库名称
    bitnami/mariadb:latest
```


#### 4. 创建普通数据库用户  

通过 `MARIADB_USER` 和 `MARIADB_PASSWORD` 创建受限用户（仅有权限访问 `MARIADB_DATABASE` 指定的数据库）：  
```console
docker run --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_USER=app_user \      # 用户名
    -e MARIADB_PASSWORD=user_pwd \  # 用户密码
    -e MARIADB_DATABASE=my_app_db \ # 关联数据库
    bitnami/mariadb:latest
```

> **注意**：若启用 `ALLOW_EMPTY_PASSWORD`，root 用户将允许远程无密码访问。生产环境需通过 `MARIADB_ROOT_PASSWORD` 设置 root 密码。


### 字符集与排序规则配置  

通过以下环境变量自定义数据库默认字符集和排序规则：  
- `MARIADB_CHARACTER_SET`：字符集（默认 `utf8`）  
- `MARIADB_COLLATE`：排序规则（默认 `utf8_general_ci`）  

示例：  
```console
docker run --name mariadb \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -e MARIADB_CHARACTER_SET=utf8mb4 \
    -e MARIADB_COLLATE=utf8mb4_unicode_ci \
    bitnami/mariadb:latest
```

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnami/mariadb" title="bitnami/mariadb Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/mariadb</a></p>

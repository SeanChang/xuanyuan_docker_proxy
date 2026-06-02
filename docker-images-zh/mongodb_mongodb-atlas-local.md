---
image: mongodb/mongodb-atlas-local
description: "通过Docker创建、管理和自动化MongoDB Atlas Local资源"
source: https://xuanyuan.cloud/zh/r/mongodb/mongodb-atlas-local
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[mongodb/mongodb-atlas-local](https://xuanyuan.cloud/zh/r/mongodb/mongodb-atlas-local)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# mongodb/mongodb-atlas-local
通过Docker创建、管理和自动化MongoDB Atlas Local资源

## 镜像概述
这是Atlas Local体验的Docker镜像。

使用MongoDB Atlas Local Docker镜像，可在您偏好的本地环境中基于MongoDB Atlas构建应用程序，并在整个软件开发生命周期中访问[Atlas Search](https://www.mongodb.com/products/platform/atlas-search)和[Atlas Vector Search](https://www.mongodb.com/products/platform/atlas-vector-search)等功能。

### 快速开始
1. 拉取Docker镜像。

> 要拉取最新的Docker镜像，运行`docker pull mongodb/mongodb-atlas-local`。

> 如果运行`docker pull mongodb/mongodb-atlas-local`时未指定版本标签，Docker会自动拉取最新版本的Docker镜像（`mongodb/mongodb-atlas-local:latest`）。

> 要拉取特定版本的Docker镜像，运行以下命令，将`<tag>`替换为版本标签：`docker pull mongodb/mongodb-atlas-local:<tag>`。

2. 运行数据库 `docker run -p 27017:27017 --name atlas-local mongodb/mongodb-atlas-local`

3. 等待容器变为健康状态。
    - 使用`docker compose`时，可通过以下配置依赖健康状态：
    ```yaml
depends_on:
  atlas-local:
    condition: service_healthy
    ```
   - 或使用bash：```while [ "`docker inspect -f {{.State.Health.Status}} atlas-local`" != "healthy" ]; do sleep 2; done```

4. 连接数据库 `mongosh "mongodb://localhost/?directConnection=true"`

### Docker部署方案示例

#### 使用docker run部署
```bash
docker run -d \
  -p 27017:27017 \
  --name atlas-local \
  -e MONGODB_INITDB_ROOT_USERNAME=admin \
  -e MONGODB_INITDB_ROOT_PASSWORD=securepassword \
  -e MONGODB_INITDB_DATABASE=myapp \
  -v ./init-scripts:/docker-entrypoint-initdb.d \
  mongodb/mongodb-atlas-local
```

#### 使用docker compose部署
创建`docker-compose.yml`文件：
```yaml
version: '3.8'
services:
  atlas-local:
    image: mongodb/mongodb-atlas-local
    container_name: atlas-local
    ports:
      - "27017:27017"
    environment:
      MONGODB_INITDB_ROOT_USERNAME: admin
      MONGODB_INITDB_ROOT_PASSWORD: securepassword
      MONGODB_INITDB_DATABASE: myapp
      DO_NOT_TRACK: 1  # 禁用遥测
      MONGOT_LOG_FILE: /dev/stdout  # 将mongot日志输出到stdout
      RUNNER_LOG_FILE: /dev/stdout  # 将runner日志输出到stdout
    volumes:
      - ./init-scripts:/docker-entrypoint-initdb.d  # 挂载初始化脚本目录
      - atlas-data:/data/db  # 持久化数据（可选）
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh "mongodb://admin:securepassword@localhost:27017/myapp?directConnection=true" --quiet
      interval: 5s
      timeout: 5s
      retries: 5
    restart: unless-stopped

volumes:
  atlas-data:  # 定义数据卷（可选）
```

### 认证

要为本地部署设置认证，请指定以下环境变量：

* `MONGODB_INITDB_ROOT_USERNAME`：根用户的用户名。
* `MONGODB_INITDB_ROOT_PASSWORD`：根用户的密码。

您也可以通过文件映射设置，以增加额外的安全层。指定以下环境变量：

* `MONGODB_INITDB_ROOT_USERNAME_FILE`：包含根用户用户名的文件路径。
* `MONGODB_INITDB_ROOT_PASSWORD_FILE`：包含根用户密码的文件路径。

### 数据初始化（Seeding）

将卷映射到`/docker-entrypoint-initdb.d`，该目录包含的`.sh`或`.js`文件将按字母顺序执行。

默认连接的数据库为`test`，除非设置了环境变量`MONGODB_INITDB_DATABASE`。

在初始化脚本中，您可以使用`$CONNECTION_STRING`作为连接数据库的URI，它包含数据库的默认连接字符串。

### 日志

默认情况下，我们仅将`mongod`日志重定向到stdout和stderr。您可以设置额外的环境变量以启用更多日志：

* `MONGOT_LOG_FILE`：用于存储Atlas Search（`mongot`）日志的文件路径。
* `RUNNER_LOG_FILE`：用于存储`runner`日志的文件路径。

注意：这两个变量都可以设置为`/dev/stdout`或`/dev/stderr`以方便使用。

### 遥测（Telemetry）

此镜像收集匿名遥测数据，以帮助我们改进产品并为您提供更好的用户体验。您可以通过将`DO_NOT_TRACK`环境变量设置为`1`来选择退出遥测。

### 文档
有关更多信息，请参见[使用Docker创建本地Atlas部署](https://dochub.mongodb.org/core/atlas-cli-deploy-docker)。

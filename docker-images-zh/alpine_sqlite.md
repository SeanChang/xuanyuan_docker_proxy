---
image: alpine/sqlite
description: "基于Alpine Linux的SQLite3 Docker镜像，用于通过容器快速执行SQLite3命令，支持自动创建数据库文件及进行数据库表创建等操作。"
source: https://xuanyuan.cloud/zh/r/alpine/sqlite
canonical: https://xuanyuan.cloud/zh/r/alpine/sqlite
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/sqlite" title="alpine/sqlite Docker 镜像中文简介、标签列表与拉取命令">alpine/sqlite 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# alpine/sqlite 镜像文档


## 一、镜像概述和主要用途

`alpine/sqlite` 是基于 Alpine Linux 构建的轻量级 SQLite3 容器化镜像，集成了 SQLite3 数据库的命令行工具。SQLite3 是一款嵌入式关系型数据库，以其零配置、无需服务进程、文件型存储等特性广泛应用于轻量级数据存储场景。该镜像旨在提供快速、便捷的 SQLite3 运行环境，适用于开发测试、临时数据处理或轻量级应用的数据持久化需求。


## 二、核心功能与特性

### 核心功能
- 集成完整的 SQLite3 命令行工具，支持标准 SQL 语法及 SQLite3 扩展功能
- 支持数据库文件的创建、查询、插入、更新、删除等操作
- 支持通过命令行直接执行 SQL 语句或脚本文件

### 特性
- **轻量级**：基于 Alpine Linux，镜像体积极小（通常仅数 MB），资源占用低
- **零配置**：无需预配置服务，直接运行即可使用
- **自动创建数据库**：若指定的数据库文件不存在，将自动创建
- **数据持久化**：通过 Docker 卷挂载可实现数据库文件的持久化存储
- **快速启动**：容器启动速度快，适合临时任务或频繁启停场景


## 三、使用场景和适用范围

### 适用场景
- **开发测试**：在开发环境中快速验证 SQL 语句或数据库逻辑
- **临时数据存储**：需短期保存数据且无需复杂管理的场景（如日志、缓存）
- **轻量级应用**：资源受限环境下的小型应用数据持久化（如嵌入式设备、边缘计算）
- **教学演示**：演示 SQLite3 基本用法或 SQL 语法教学


## 四、使用方法和配置说明

### 基本使用方式
通过 `docker run` 命令启动容器，指定数据库文件和需执行的 SQL 操作。核心语法如下：

```bash
docker run [选项] alpine/sqlite <数据库文件> <SQL命令|SQL脚本>
```


### 关键参数说明
| 参数         | 说明                                                                 |
|--------------|----------------------------------------------------------------------|
| `-ti`        | 分配交互式终端，支持命令行输入（用于交互式操作）                     |
| `--rm`       | 容器退出后自动删除，避免残留容器文件                                 |
| `-v <宿主机路径>:<容器路径>` | 挂载宿主机目录到容器内，实现数据库文件持久化（必填，否则数据会丢失） |
| `-w <容器工作目录>`       | 设置容器内工作目录，建议与挂载路径一致，便于文件路径管理             |


### 数据持久化
SQLite3 数据库以单一文件存储，容器内默认无持久化存储，需通过挂载宿主机目录实现数据保留。示例中挂载当前目录到容器 `/apps` 目录，数据库文件将保存在宿主机当前路径下。


## 五、Docker 部署示例

### 1. 基本操作示例（创建表并验证）
#### 步骤1：创建数据库和表
若指定的数据库文件（如 `test.db`）不存在，容器将自动创建。执行以下命令创建 `users` 表：

```bash
# 挂载当前目录到容器 /apps，在 /apps 目录下操作 test.db
docker run -ti --rm -v $(pwd):/apps -w /apps docker.xuanyuan.run/alpine/sqlite test.db "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT);"
```

#### 步骤2：验证表已创建
再次执行相同命令，因表已存在，将返回错误提示，确认表创建成功：

```bash
docker run -ti --rm -v $(pwd):/apps -w /apps docker.xuanyuan.run/alpine/sqlite test.db "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT);"
```

输出：
```
Error: in prepare, table users already exists
  CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT);
               ^--- error here
```

#### 步骤3：查看宿主机数据库文件
宿主机当前目录下将生成 `test.db` 文件，验证数据持久化成功：

```bash
ls -l test.db
```


### 2. 交互式操作示例
通过 `-ti` 参数进入 SQLite3 交互式终端，手动执行多条命令：

```bash
docker run -ti --rm -v $(pwd):/apps -w /apps docker.xuanyuan.run/alpine/sqlite test.db
```

进入终端后，可执行 SQL 命令（以 `.exit` 退出）：

```sql
sqlite> INSERT INTO users (name) VALUES ('Alice');
sqlite> SELECT * FROM users;
1|Alice
sqlite> .exit
```


### 3. 执行 SQL 脚本文件
将 SQL 命令写入脚本文件（如 `init.sql`），通过容器执行：

#### 步骤1：创建脚本文件 `init.sql`
```sql
CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, price REAL);
INSERT INTO products (name, price) VALUES ('Laptop', 4999.99);
INSERT INTO products (name, price) VALUES ('Phone', 2999.99);
```

#### 步骤2：执行脚本
```bash
docker run -ti --rm -v $(pwd):/apps -w /apps docker.xuanyuan.run/alpine/sqlite test.db < init.sql
```

#### 步骤3：验证数据
通过交互式终端查询：

```bash
docker run -ti --rm -v $(pwd):/apps -w /apps docker.xuanyuan.run/alpine/sqlite test.db
sqlite> SELECT * FROM products;
1|Laptop|4999.99
2|Phone|2999.99
sqlite> .exit
```


### 4. docker-compose 配置示例
创建 `docker-compose.yml` 实现更便捷的启动配置：

```yaml
version: '3'
services:
  sqlite:
    image: docker.xuanyuan.run/alpine/sqlite
    volumes:
      - ./data:/apps  # 宿主机 ./data 目录挂载到容器 /apps，持久化数据库文件
    working_dir: /apps
    command: test.db  # 启动后进入交互式终端（若需执行命令，替换为 "test.db 'SQL命令'"）
    tty: true        # 分配终端
    stdin_open: true # 保持标准输入打开
```

启动容器：
```bash
docker-compose up
```

进入交互式终端后即可执行 SQL 操作，数据保存在宿主机 `./data/test.db`。


## 六、注意事项
1. **数据持久化**：必须通过 `-v` 参数挂载宿主机目录，否则容器退出后数据库文件将丢失。
2. **权限问题**：若宿主机挂载目录权限不足，可能导致容器无法读写文件，建议确保宿主机目录有读写权限（如 `chmod 777 ./data`，生产环境按需调整）。
3. **SQLite 限制**：SQLite 不适合高并发写操作，请勿用于生产环境的高性能数据存储场景。

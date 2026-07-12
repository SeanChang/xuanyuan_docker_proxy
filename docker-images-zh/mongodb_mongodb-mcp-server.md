---
image: mongodb/mongodb-mcp-server
description: "官方MongoDB MCP服务器镜像，用于部署和运行MongoDB MCP服务，提供官方支持的可靠运行环境。"
source: https://xuanyuan.cloud/zh/r/mongodb/mongodb-mcp-server
canonical: https://xuanyuan.cloud/zh/r/mongodb/mongodb-mcp-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mongodb/mongodb-mcp-server" title="mongodb/mongodb-mcp-server Docker 镜像中文简介、标签列表与拉取命令">mongodb/mongodb-mcp-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MongoDB MCP Server

MongoDB官方MCP服务器，一个用于与MongoDB数据库和MongoDB Atlas交互的模型上下文协议(Model Context Protocol)服务器。

## 镜像概述和主要用途

MongoDB MCP Server是实现模型上下文协议(MCP)的服务器，提供与MongoDB数据库和MongoDB Atlas云服务的交互能力。该服务器允许MCP客户端通过标准化接口访问MongoDB工具和服务，实现数据库管理、集群操作和数据查询等功能。

## 核心功能和特性

- 提供MongoDB Atlas云服务管理工具，支持组织、项目和集群的创建与管理
- 提供MongoDB数据库操作工具，支持数据查询、插入、更新和删除等操作
- 灵活的配置选项，支持直接数据库连接或Atlas API认证
- 可定制的工具访问控制，支持禁用特定工具或操作类型
- 只读模式支持，限制仅允许读取和元数据操作
- 完整的日志记录功能，便于问题诊断和审计

## 使用场景和适用范围

MongoDB MCP Server适用于需要通过MCP协议与MongoDB交互的各类客户端应用，包括但不限于：

- 开发环境中的数据库管理和操作
- 通过AI助手或IDE插件访问MongoDB数据库
- 自动化脚本和工作流中的数据库操作
- MongoDB Atlas云服务的远程管理
- 需要限制数据库操作权限的共享环境

支持的MCP客户端包括：Windsurf、VSCode、Claude Desktop和Cursor等。

## 前提条件

- Node.js (v20或更高版本)

```shell
node -v
```

- MongoDB连接字符串或Atlas API凭据，**服务器未配置将无法启动**。
  - 使用Atlas工具需要**服务账户Atlas API凭据**。可在MongoDB Atlas中创建服务账户并使用其凭据进行认证。详见"Atlas API访问"部分。
  - 若已有MongoDB连接字符串，可直接用于连接MongoDB实例。

## 详细使用方法和配置说明

### 快速开始

大多数MCP客户端需要创建或修改配置文件以添加MCP服务器。

注意：不同客户端的配置文件语法可能不同。请参考以下链接获取最新语法说明：

- **Windsurf**: https://docs.windsurf.com/windsurf/mcp
- **VSCode**: https://code.visualstudio.com/docs/copilot/chat/mcp-servers
- **Claude Desktop**: https://modelcontextprotocol.io/quickstart/user
- **Cursor**: https://docs.cursor.com/context/model-context-protocol

您可以提供MongoDB连接字符串或Atlas API凭据：

#### 选项A: 无配置

```shell
docker run --rm -i \
  docker.xuanyuan.run/mongodb/mongodb-mcp-server:latest
```

#### 选项B: 使用MongoDB连接字符串

```shell
docker run --rm -i \
  -e MDB_MCP_CONNECTION_STRING="mongodb+srv://username:password@cluster.mongodb.net/myDatabase" \
  docker.xuanyuan.run/mongodb/mongodb-mcp-server:latest
```

#### 选项C: 使用Atlas API凭据

```shell
docker run --rm -i \
  -e MDB_MCP_API_CLIENT_ID="your-atlas-service-accounts-client-id" \
  -e MDB_MCP_API_CLIENT_SECRET="your-atlas-service-accounts-client-secret" \
  docker.xuanyuan.run/mongodb/mongodb-mcp-server:latest
```

#### MCP配置文件

无选项配置：

```json
{
  "mcpServers": {
    "MongoDB": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "mongodb/mongodb-mcp-server:latest"]
    }
  }
}
```

使用连接字符串：

```json
{
  "mcpServers": {
    "MongoDB": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-e",
        "MDB_MCP_CONNECTION_STRING=mongodb+srv://username:password@cluster.mongodb.net/myDatabase",
        "mongodb/mongodb-mcp-server:latest"
      ]
    }
  }
}
```

使用Atlas API凭据：

```json
{
  "mcpServers": {
    "MongoDB": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-e",
        "MDB_MCP_API_CLIENT_ID=your-atlas-service-accounts-client-id",
        "-e",
        "MDB_MCP_API_CLIENT_SECRET=your-atlas-service-accounts-client-secret",
        "mongodb/mongodb-mcp-server:latest"
      ]
    }
  }
}
```

### 支持的工具

#### 工具列表

##### MongoDB Atlas工具

- `atlas-list-orgs` - 列出MongoDB Atlas组织
- `atlas-list-projects` - 列出MongoDB Atlas项目
- `atlas-create-project` - 创建新的MongoDB Atlas项目
- `atlas-list-clusters` - 列出MongoDB Atlas集群
- `atlas-inspect-cluster` - 检查特定的MongoDB Atlas集群
- `atlas-create-free-cluster` - 创建免费的MongoDB Atlas集群
- `atlas-connect-cluster` - 连接到MongoDB Atlas集群
- `atlas-inspect-access-list` - 检查有权访问MongoDB Atlas集群的IP/CIDR范围
- `atlas-create-access-list` - 配置MongoDB Atlas集群的IP/CIDR访问列表
- `atlas-list-db-users` - 列出MongoDB Atlas数据库用户
- `atlas-create-db-user` - 创建MongoDB Atlas数据库用户

注意：Atlas工具仅在配置部分设置凭据后可用。

##### MongoDB数据库工具

- `connect` - 连接到MongoDB实例
- `find` - 对MongoDB集合运行查询
- `aggregate` - 对MongoDB集合运行聚合操作
- `count` - 获取MongoDB集合中的文档数量
- `insert-one` - 向MongoDB集合插入单个文档
- `insert-many` - 向MongoDB集合插入多个文档
- `create-index` - 为MongoDB集合创建索引
- `update-one` - 更新MongoDB集合中的单个文档
- `update-many` - 更新MongoDB集合中的多个文档
- `rename-collection` - 重命名MongoDB集合
- `delete-one` - 从MongoDB集合中删除单个文档
- `delete-many` - 从MongoDB集合中删除多个文档
- `drop-collection` - 从MongoDB数据库中删除集合
- `drop-database` - 删除MongoDB数据库
- `list-databases` - 列出MongoDB连接的所有数据库
- `list-collections` - 列出给定数据库的所有集合
- `collection-indexes` - 描述集合的索引
- `collection-schema` - 描述集合的模式
- `collection-storage-size` - 获取集合的大小(MB)
- `db-stats` - 返回MongoDB数据库的统计信息

### 配置

MongoDB MCP Server可通过多种方法配置，优先级从高到低如下：

1. 命令行参数
2. 环境变量

#### 配置选项

| 选项             | 描述                                                                 |
|------------------|----------------------------------------------------------------------|
| `apiClientId`    | 用于认证的Atlas API客户端ID                                           |
| `apiClientSecret`| 用于认证的Atlas API客户端密钥                                         |
| `connectionString`| MongoDB连接字符串，用于直接数据库连接(可选，用户可在每次工具调用时提供) |
| `logPath`        | 存储日志的文件夹                                                     |
| `disabledTools`  | 要禁用的工具名称、操作类型和/或工具类别的数组                          |
| `readOnly`       | 设置为true时，仅允许读取和元数据操作类型，禁用创建/更新/删除操作       |
| `telemetry`      | 设置为disabled时，禁用遥测数据收集                                    |

##### 日志路径

默认日志位置如下：

- Windows: `%LOCALAPPDATA%\mongodb\mongodb-mcp\.app-logs`
- macOS/Linux: `~/.mongodb/mongodb-mcp/.app-logs`

##### 禁用工具

可以使用`disabledTools`选项禁用特定工具或工具类别。此选项接受字符串数组，其中每个字符串可以是工具名称、操作类型或类别。

数组的构造方式取决于所使用的配置方法：

- 对于**环境变量**配置，使用逗号分隔的字符串：`export MDB_MCP_DISABLED_TOOLS="create,update,delete,atlas,collectionSchema"`。
- 对于**命令行参数**配置，使用空格分隔的字符串：`--disabledTools create update delete atlas collectionSchema`。

工具类别：

- `atlas` - MongoDB Atlas工具，如列出集群、创建集群等。
- `mongodb` - MongoDB数据库工具，如find、aggregate等。

操作类型：

- `create` - 创建资源的工具，如创建集群、插入文档等。
- `update` - 更新资源的工具，如更新文档、重命名集合等。
- `delete` - 删除资源的工具，如删除文档、删除集合等。
- `read` - 读取资源的工具，如查询、聚合、列出集群等。
- `metadata` - 读取元数据的工具，如列出数据库、列出集合、集合模式等。

##### 只读模式

`readOnly`配置选项允许将MCP服务器限制为仅使用具有"read"和"metadata"操作类型的工具。启用后，所有具有"create"、"update"或"delete"操作类型的工具将不会在服务器上注册。

这在希望提供MongoDB数据访问进行分析但不允许修改数据或基础设施的场景中非常有用。

可以通过以下方式启用只读模式：

- **环境变量**: `export MDB_MCP_READ_ONLY=true`
- **命令行参数**: `--readOnly`

当只读模式激活时，服务器日志中将显示一条消息，指示由于此限制而阻止注册的工具。

##### 遥测

`telemetry`配置选项允许禁用遥测数据收集。启用时，MCP服务器将收集使用数据并发送给MongoDB。

可以通过以下方式禁用遥测：

- **环境变量**: `export MDB_MCP_TELEMETRY=disabled`
- **命令行参数**: `--telemetry disabled`
- **DO_NOT_TRACK环境变量**: `export DO_NOT_TRACK=1`

#### Atlas API访问

要使用Atlas API工具，需要在MongoDB Atlas中创建服务账户：

1. **创建服务账户:**

   - 登录MongoDB Atlas: [cloud.mongodb.com](https://cloud.mongodb.com)
   - 导航至"访问管理器">"组织访问"
   - 点击"添加新">"应用">"服务账户"
   - 输入服务账户的名称、描述和过期时间(例如："MCP, MCP Server Access, 7 days")
   - 选择适当的权限(如需完全访问，请使用组织所有者)
   - 点击"创建"

要了解有关服务账户的更多信息，请查看[MongoDB Atlas文档](https://www.mongodb.com/docs/atlas/api/service-accounts-overview/)。

2. **保存客户端凭据:**

   - 创建后，将显示客户端ID和客户端密钥
   - **重要提示:** 立即复制并保存客户端密钥，因为它不会再次显示

3. **添加访问列表条目:**

   - 将您的IP地址添加到API访问列表

4. **配置MCP服务器:**
   - 使用以下配置方法之一设置`apiClientId`和`apiClientSecret`

#### 配置方法

##### 环境变量

设置以`MDB_MCP_`为前缀的环境变量，后跟大写的选项名称(使用下划线分隔):

```shell
# 设置Atlas API凭据(通过服务账户)
export MDB_MCP_API_CLIENT_ID="your-atlas-service-accounts-client-id"
export MDB_MCP_API_CLIENT_SECRET="your-atlas-service-accounts-client-secret"

# 设置自定义MongoDB连接字符串
export MDB_MCP_CONNECTION_STRING="mongodb+srv://username:password@cluster.mongodb.net/myDatabase"

export MDB_MCP_LOG_PATH="/path/to/logs"
```

Docker部署示例:

```shell
docker run --rm -i \
  -e MDB_MCP_API_CLIENT_ID="your-atlas-service-accounts-client-id" \
  -e MDB_MCP_API_CLIENT_SECRET="your-atlas-service-accounts-client-secret" \
  -e MDB_MCP_CONNECTION_STRING="mongodb+srv://username:password@cluster.mongodb.net/myDatabase" \
  docker.xuanyuan.run/mongodb/mongodb-mcp-server:latest
```

##### MCP配置文件示例

使用环境变量的连接字符串配置:

```json
{
  "mcpServers": {
    "MongoDB": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mongodb/mongodb-mcp-server"],
      "env": {
        "MDB_MCP_CONNECTION_STRING": "mongodb+srv://username:password@cluster.mongodb.net/myDatabase"
      }
    }
  }
}
```

使用Atlas API凭据的配置:

```json
{
  "mcpServers": {
    "MongoDB": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mongodb/mongodb-mcp-server"],
      "env": {
        "MDB_MCP_API_CLIENT_ID": "your-atlas-service-accounts-client-id",
        "MDB_MCP_API_CLIENT_SECRET": "your-atlas-service-accounts-client-secret"
      }
    }
  }
}
```

##### 命令行参数

启动服务器时将配置选项作为命令行参数传递:

```shell
docker run -i --rm docker.xuanyuan.run/mongodb/mongodb-mcp-server \
  --apiClientId="your-atlas-service-accounts-client-id" \
  --apiClientSecret="your-atlas-service-accounts-client-secret" \
  --connectionString="mongodb+srv://username:password@cluster.mongodb.net/myDatabase" \
  --logPath=/path/to/logs
```

使用命令行参数的MCP配置文件示例:

```json
{
  "mcpServers": {
    "MongoDB": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "mongodb/mongodb-mcp-server",
        "--connectionString",
        "mongodb+srv://username:password@cluster.mongodb.net/myDatabase"
      ]
    }
  }
}
```

### Docker Compose配置示例

```yaml
version: '3'
services:
  mongodb-mcp-server:
    image: docker.xuanyuan.run/mongodb/mongodb-mcp-server:latest
    environment:
      - MDB_MCP_API_CLIENT_ID=your-atlas-service-accounts-client-id
      - MDB_MCP_API_CLIENT_SECRET=your-atlas-service-accounts-client-secret
      # 或者使用直接连接字符串
      # - MDB_MCP_CONNECTION_STRING=mongodb+srv://username:password@cluster.mongodb.net/myDatabase
      - MDB_MCP_LOG_PATH=/logs
      - MDB_MCP_READ_ONLY=false
      - MDB_MCP_TELEMETRY=enabled
    volumes:
      - ./logs:/logs
    stdin_open: true
    tty: true
```

## 贡献

有兴趣贡献吗？太好了！请查看我们的[贡献指南](https://github.com/mongodb-js/mongodb-mcp-server/blob/main/CONTRIBUTING.md)，了解代码贡献、标准、添加新工具和故障排除信息的指南。

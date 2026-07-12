---
image: openfga/cli
description: "用于与OpenFGA服务器交互的跨平台命令行工具"
source: https://xuanyuan.cloud/zh/r/openfga/cli
canonical: https://xuanyuan.cloud/zh/r/openfga/cli
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openfga/cli" title="openfga/cli Docker 镜像中文简介、标签列表与拉取命令">openfga/cli 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenFGA CLI 中文技术文档


## 1. 镜像概述和主要用途

OpenFGA CLI 是一款跨平台命令行工具，用于与 OpenFGA 服务器交互。OpenFGA 是基于 Google Zanzibar 论文实现的开源细粒度授权（Fine-Grained Authorization）解决方案，而该 CLI 提供了便捷的命令集，支持管理存储实例、授权模型、关系元组及执行权限查询等核心操作，适用于开发、测试及生产环境中 OpenFGA 服务的日常运维与集成。


## 2. 核心功能和特性

### 2.1 存储实例管理
- 创建、查询、列出、删除存储实例
- 导入/导出存储实例（含授权模型、关系元组及测试用例）

### 2.2 授权模型管理
- 读写授权模型（支持 FGA、JSON、模块化格式）
- 验证授权模型语法及逻辑正确性
- 运行授权模型测试用例
- 模型格式转换（FGA ↔ JSON ↔ 模块化格式）

### 2.3 关系元组管理
- 写入、删除、查询关系元组
- 监控关系元组变更（Watch）
- 批量处理元组（支持 JSON、YAML、CSV 等文件格式）

### 2.4 关系查询
- 权限检查（Check）：验证用户对资源的权限
- 关系展开（Expand）：展示权限继承链
- 对象/关系/用户列表查询：按权限筛选资源或主体


## 3. 使用场景和适用范围

### 3.1 开发与测试
- 本地验证授权模型设计（无需部署 OpenFGA 服务）
- 编写自动化测试用例验证权限逻辑

### 3.2 生产环境管理
- 批量导入/更新关系元组（如用户-角色映射）
- 监控元组变更以触发下游业务逻辑
- 导出存储实例备份或迁移数据

### 3.3 自动化集成
- CI/CD 流程中嵌入授权模型验证步骤
- 脚本化管理多环境（开发/测试/生产）存储实例


## 4. 安装与部署

### 4.1 Docker 部署
#### 4.1.1 拉取镜像
```bash
docker pull docker.xuanyuan.run/openfga/cli
```

#### 4.1.2 基本运行
```bash
docker run -it docker.xuanyuan.run/openfga/cli --help # 查看帮助
```

#### 4.1.3 带配置文件运行
挂载本地配置文件（`~/.fga.yaml`）到容器中：
```bash
docker run -it -v ~/.fga.yaml:/root/.fga.yaml docker.xuanyuan.run/openfga/cli store list
```

#### 4.1.4 环境变量配置示例
```bash
docker run -it -e FGA_API_URL=https://api.openfga.example.com \
  -e FGA_STORE_ID=01H0H015178Y2V4CX10C2KGHF4 \
  docker.xuanyuan.run/openfga/cli model list
```

#### 4.1.5 Docker Compose 示例
```yaml
version: '3'
services:
  fga-cli:
    image: docker.xuanyuan.run/openfga/cli
    environment:
      - FGA_API_URL=https://api.openfga.example.com
      - FGA_CLIENT_ID=your-client-id
      - FGA_CLIENT_SECRET=your-client-secret
      - FGA_STORE_ID=your-store-id
    volumes:
      - ./models:/app/models  # 挂载本地模型文件
    command: model write --file /app/models/model.fga
```

### 4.2 其他安装方式
#### 4.2.1 Brew（macOS/Linux）
```bash
brew install openfga/tap/fga
```

#### 4.2.2 Linux 包管理
- Debian/Ubuntu：
  ```bash
  sudo apt install ./fga_<version>_linux_<arch>.deb
  ```
- Fedora/RHEL：
  ```bash
  sudo dnf install ./fga_<version>_linux_<arch>.rpm
  ```
- Alpine：
  ```bash
  sudo apk add --allow-untrusted ./fga_<version>_linux_<arch>.apk
  ```

#### 4.2.3 Windows
通过 Scoop 安装：
```bash
scoop install openfga
```

#### 4.2.4 Go 源码安装
```bash
go install github.com/openfga/cli/cmd/fga@latest
```

#### 4.2.5 手动下载
从 [GitHub Releases](https://github.com/openfga/cli/releases) 下载预编译二进制文件，添加到系统 PATH。


## 4. 配置说明

### 4.1 配置方式
支持三种配置方式（优先级：命令行标志 > 环境变量 > 配置文件）：

| 配置项                | 命令行标志         | 环境变量             | 配置文件（~/.fga.yaml） |
|-----------------------|--------------------|----------------------|-------------------------|
| API 地址              | `--api-url`        | `FGA_API_URL`        | `api-url`               |
| 共享密钥              | `--api-token`      | `FGA_API_TOKEN`      | `api-token`             |
| OAuth 客户端 ID       | `--client-id`      | `FGA_CLIENT_ID`      | `client-id`             |
| OAuth 客户端密钥      | `--client-secret`  | `FGA_CLIENT_SECRET`  | `client-secret`         |
| OAuth 作用域          | `--api-scopes`     | `FGA_API_SCOPES`     | `api-scopes`            |
| Token 签发者          | `--api-token-issuer` | `FGA_API_TOKEN_ISSUER` | `api-token-issuer`      |
| Token 受众            | `--api-audience`   | `FGA_API_AUDIENCE`   | `api-audience`          |
| 存储实例 ID           | `--store-id`       | `FGA_STORE_ID`       | `store-id`              |
| 授权模型 ID           | `--model-id`       | `FGA_MODEL_ID`       | `model-id`              |

### 4.2 配置文件示例（~/.fga.yaml）
```yaml
# Auth0 FGA 示例配置
api-url: https://api.us1.fga.dev
client-id: 4Zb..UYjaHreLKOJuU8
client-secret: J3...2pBwiauD
api-audience: https://api.us1.fga.dev/
api-token-issuer: auth.fga.dev
store-id: 01H0H015178Y2V4CX10C2KGHF4
```


## 5. 使用方法

### 5.1 存储实例管理（store）

#### 5.1.1 创建存储实例
```bash
# 仅创建存储
fga store create --name "FGA Demo Store"

# 创建存储并自动导入模型
fga store create --name "Demo" --model model.fga
```
响应示例：
```json
{
  "store": {
    "id": "01H6H9CNQRP2TVCFR7899XGNY8",
    "name": "Demo",
    "created_at": "2023-07-29T16:58:28.984402Z",
    "updated_at": "2023-07-29T16:58:28.984402Z"
  },
  "model": {
    "authorization_model_id": "01H6H9CNQV36Y9WS1RJGRN8D06"
  }
}
```

#### 5.1.2 导入存储实例
```bash
fga store import --file store.fga.yaml --max-parallel-requests 8
```
（支持导入模型、元组及测试用例，文件格式参考 [Store File Format](https://github.com/openfga/cli/blob/main/docs/STORE_FILE.md)）

#### 5.1.3 导出存储实例
```bash
# 导出到终端
fga store export --store-id 01H0H015178Y2V4CX10C2KGHF4

# 导出到文件
fga store export --store-id <id> --output-file backup.fga.yaml
```

#### 5.1.4 列出存储实例
```bash
fga store list --max-pages 10
```

#### 5.1.5 查询存储实例详情
```bash
fga store get --store-id 01H0H015178Y2V4CX10C2KGHF4
```

#### 5.1.6 删除存储实例
```bash
fga store delete --store-id 01H0H015178Y2V4CX10C2KGHF4
```


### 5.2 授权模型管理（model）

#### 5.2.1 写入授权模型
```bash
# 从文件写入（FGA 格式）
fga model write --store-id <id> --file model.fga

# 从 JSON 字符串写入
fga model write --store-id <id> '{"schema_version":"1.1","type_definitions":[{"type":"user"},{"type":"document","relations":{"can_view":{"this":{}}}}]}' --format json
```

#### 5.2.2 查询授权模型
```bash
# 查询最新模型（FGA 格式）
fga model get --store-id <id>

# 查询指定模型（JSON 格式）
fga model get --store-id <id> --model-id <model-id> --format json
```

#### 5.2.3 验证授权模型
```bash
fga model validate --file model.fga --format fga
```
响应示例（有效模型）：
```json
{"is_valid":true}
```

#### 5.2.4 运行模型测试用例
```bash
# 运行单个测试文件
fga model test --tests tests/demo.fga.yaml

# 运行目录下所有测试文件
fga model test --tests "tests/**/*.fga.yaml"
```
测试文件格式示例（YAML）：
```yaml
model: |
  model schema 1.1
  type user
  type document
    relations
      define can_view: [user]
tuples:
  - user: user:anne
    relation: can_view
    object: document:1
tests:
  - name: anne_can_view
    check:
      - user: user:anne
        object: document:1
        assertions:
          can_view: true
```


### 5.3 关系元组管理（tuple）

#### 5.3.1 写入关系元组
```bash
# 单行写入
fga tuple write user:anne can_view document:roadmap --store-id <id>

# 批量写入（从文件）
fga tuple write --store-id <id> --file tuples.json --max-parallel-requests 8
```
批量文件示例（JSON）：
```json
[
  {"user":"user:bob","relation":"can_edit","object":"document:roadmap"},
  {"user":"user:carol","relation":"can_view","object":"document:roadmap"}
]
```

#### 5.3.2 查询关系元组
```bash
# 查询所有元组
fga tuple read --store-id <id>

# 按对象筛选
fga tuple read --store-id <id> --object document:roadmap
```

#### 5.3.3 监控元组变更
```bash
fga tuple changes --store-id <id> --type document --start-time 2024-01-01T00:00:00Z
```


### 5.4 关系查询

#### 5.4.1 权限检查（Check）
```bash
fga query check --store-id <id> --user user:anne --relation can_view --object document:roadmap
```
响应示例：
```json
{"allowed":true}
```

#### 5.4.2 展开权限链（Expand）
```bash
fga query expand --store-id <id> --user user:anne --relation can_view --object document:roadmap
```

#### 5.4.3 列出用户可访问的对象
```bash
fga query list-objects --store-id <id> --user user:anne --type document --relation can_view
```


## 6. 从源码构建

### 6.1 前置条件
- Go 1.20 及以上版本

### 6.2 构建步骤
```bash
# 克隆仓库
git clone https://github.com/openfga/cli.git && cd cli

# 构建二进制文件
go build -o ./dist/fga ./cmd/fga/main.go

# 或使用 make
make build

# 运行
./dist/fga --version
```


## 7. 资源与参考

- [OpenFGA 官方文档](https://openfga.dev/docs)
- [OpenFGA API 文档](https://openfga.dev/api/service)
- [Zanzibar 论文](https://research.google/pubs/pub48190/)
- [存储文件格式规范](https://github.com/openfga/cli/blob/main/docs/STORE_FILE.md)


## 8. 贡献与许可

- **贡献**：欢迎通过 [GitHub Issues](https://github.com/openfga/cli/issues) 或 PR 参与开发。
- **许可**：Apache License 2.0（详见 [LICENSE](https://github.com/openfga/cli/blob/main/LICENSE)）。

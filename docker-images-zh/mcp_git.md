---
image: mcp/git
description: "提供Git仓库交互与自动化能力，支持Git操作的自动化处理。"
source: https://xuanyuan.cloud/zh/r/mcp/git
canonical: https://xuanyuan.cloud/zh/r/mcp/git
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/git" title="mcp/git Docker 镜像中文简介、标签列表与拉取命令">mcp/git 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Git (Reference) MCP Server 中文技术文档


## 1. 镜像概述与主要用途

Git (Reference) MCP Server 是一个基于 Model Context Protocol (MCP) 的服务器镜像，专注于 Git 仓库的交互与自动化操作。该镜像提供了一系列预配置的 Git 工具，支持常见的仓库管理操作（如分支创建、提交、差异比较等），适用于需要集成 Git 操作的自动化流程或 AI 应用场景。


## 2. 核心功能与特性

### 2.1 基本特性

| 属性                | 详情                                                                 |
|---------------------|----------------------------------------------------------------------|
| **Docker 镜像**     | [mcp/git](https://hub.docker.com/repository/docker/mcp/git)          |
| **作者**            | [modelcontextprotocol](https://github.com/modelcontextprotocol)      |
| **代码仓库**        | https://github.com/modelcontextprotocol/servers                      |
| **Dockerfile**      | https://github.com/modelcontextprotocol/servers/blob/2025.4.24/src/git/Dockerfile |
| **镜像构建者**      | Docker Inc.                                                          |
| **Docker Scout 健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/git) |
| **验证签名**        | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/git --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证**          | MIT License                                                          |


### 2.2 核心工具集

该镜像提供 12 个 Git 操作工具，支持常见的仓库管理场景，工具列表如下：

| 工具名称               | 简短描述                                   |
|------------------------|--------------------------------------------|
| `git_add`              | 将文件内容添加到暂存区                     |
| `git_checkout`         | 切换分支                                   |
| `git_commit`           | 记录更改到仓库（提交）                     |
| `git_create_branch`    | 从基础分支（可选）创建新分支               |
| `git_diff`             | 显示分支或提交之间的差异                   |
| `git_diff_staged`      | 显示已暂存的更改                           |
| `git_diff_unstaged`    | 显示工作目录中未暂存的更改                 |
| `git_init`             | 初始化新的 Git 仓库                        |
| `git_log`              | 显示提交日志                               |
| `git_reset`            | 取消所有暂存的更改                         |
| `git_show`             | 显示指定提交的内容                         |
| `git_status`           | 显示工作区状态                             |


## 3. 使用场景与适用范围

- **自动化 Git 工作流**：集成到脚本或应用中，自动执行分支创建、提交、差异检查等操作。
- **CI/CD 流程集成**：在持续集成/部署流程中，通过容器化方式安全执行 Git 操作。
- **AI 应用集成**：作为 MCP Server 与 AI 模型（如 Anthropic Claude）配合，实现基于自然语言指令的 Git 仓库管理。
- **本地开发辅助**：快速搭建隔离的 Git 操作环境，避免影响本地 Git 配置。


## 4. 详细使用方法与配置说明

### 4.1 基础部署（Docker Run）

通过 Docker 直接运行镜像，挂载本地目录以访问 Git 仓库：

```bash
docker run -i --rm -v /本地目录:/容器内目录 docker.xuanyuan.run/mcp/git
```

**参数说明**：
- `-i`：交互模式，支持输入操作指令。
- `--rm`：容器退出后自动删除，避免残留。
- `-v /本地目录:/容器内目录`：挂载本地 Git 仓库目录到容器，确保容器可访问目标仓库。


### 4.2 Docker Compose 配置

创建 `docker-compose.yml` 文件，定义持久化挂载和服务配置：

```yaml
version: '3'
services:
  git-mcp-server:
    image: docker.xuanyuan.run/mcp/git
    volumes:
      - /path/to/local/git/repos:/repos  # 挂载本地 Git 仓库目录
    stdin_open: true  # 保持标准输入打开（等价于 -i）
    tty: true         # 分配伪终端（可选，增强交互体验）
```

启动服务：
```bash
docker-compose up -d
```


### 4.3 MCP Server 配置示例

在 MCP 兼容的应用中（如 Claude Desktop），通过以下 JSON 配置集成该服务器：

```json
{
  "mcpServers": {
    "git": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-v",
        "/local-directory:/local-directory",  # 替换为实际本地目录
        "mcp/git"
      ]
    }
  }
}
```

**说明**：该配置定义了名为 `git` 的 MCP Server，通过 Docker 启动 `mcp/git` 镜像，并挂载本地目录以访问 Git 仓库。


## 5. 工具详情与参数说明

### 5.1 `git_add`
**功能**：将文件内容添加到暂存区  
**参数**：

| 参数名    | 类型   | 描述                 |
|-----------|--------|----------------------|
| `files`   | array  | 待添加的文件路径列表 |
| `repo_path` | string | Git 仓库在容器内的路径 |


### 5.2 `git_checkout`
**功能**：切换分支  
**参数**：

| 参数名       | 类型   | 描述                 |
|--------------|--------|----------------------|
| `branch_name` | string | 目标分支名称         |
| `repo_path`  | string | Git 仓库在容器内的路径 |


### 5.3 `git_commit`
**功能**：记录更改到仓库（提交）  
**参数**：

| 参数名       | 类型   | 描述                 |
|--------------|--------|----------------------|
| `message`    | string | 提交信息             |
| `repo_path`  | string | Git 仓库在容器内的路径 |


### 5.4 `git_create_branch`
**功能**：从基础分支（可选）创建新分支  
**参数**：

| 参数名        | 类型   | 描述                          |
|---------------|--------|-------------------------------|
| `branch_name` | string | 新分支名称                    |
| `repo_path`   | string | Git 仓库在容器内的路径        |
| `base_branch` | string | 基础分支名称（可选，默认基于当前分支） |


### 5.5 `git_diff`
**功能**：显示分支或提交之间的差异  
**参数**：

| 参数名    | 类型   | 描述                          |
|-----------|--------|-------------------------------|
| `repo_path` | string | Git 仓库在容器内的路径        |
| `target`   | string | 目标分支或提交哈希（如 `main` 或 `a1b2c3d`） |


### 5.6 `git_diff_staged`
**功能**：显示已暂存的更改  
**参数**：

| 参数名    | 类型   | 描述                 |
|-----------|--------|----------------------|
| `repo_path` | string | Git 仓库在容器内的路径 |


### 5.7 `git_diff_unstaged`
**功能**：显示工作目录中未暂存的更改  
**参数**：

| 参数名    | 类型   | 描述                 |
|-----------|--------|----------------------|
| `repo_path` | string | Git 仓库在容器内的路径 |


### 5.8 `git_init`
**功能**：初始化新的 Git 仓库  
**参数**：

| 参数名    | 类型   | 描述                          |
|-----------|--------|-------------------------------|
| `repo_path` | string | 目标目录路径（将在此初始化仓库） |


### 5.9 `git_log`
**功能**：显示提交日志  
**参数**：

| 参数名     | 类型    | 描述                          |
|------------|---------|-------------------------------|
| `repo_path` | string  | Git 仓库在容器内的路径        |
| `max_count` | integer | 显示的最大提交数（可选）      |


### 5.10 `git_reset`
**功能**：取消所有暂存的更改  
**参数**：

| 参数名    | 类型   | 描述                 |
|-----------|--------|----------------------|
| `repo_path` | string | Git 仓库在容器内的路径 |


### 5.11 `git_show`
**功能**：显示指定提交的内容  
**参数**：

| 参数名    | 类型   | 描述                          |
|-----------|--------|-------------------------------|
| `repo_path` | string | Git 仓库在容器内的路径        |
| `revision` | string | 提交哈希或分支名称（如 `HEAD~1`） |


### 5.12 `git_status`
**功能**：显示工作区状态  
**参数**：

| 参数名    | 类型   | 描述                 |
|-----------|--------|----------------------|
| `repo_path` | string | Git 仓库在容器内的路径 |


## 6. 安全性说明

### 6.1 镜像签名验证

通过 Cosign 验证镜像完整性和签名：

```bash
COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/git --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub
```

**说明**：确保使用官方提供的公钥验证镜像，避免运行篡改后的版本。


## 7. 许可证

本镜像基于 MIT License 开源，详情参见 [许可证文件](https://github.com/modelcontextprotocol/servers/blob/main/LICENSE)。

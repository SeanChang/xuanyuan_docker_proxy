---
image: eclipse/centos
description: "基于CentOS的最小化环境，仅集成git和openssh，适用于需要轻量版本控制系统和SSH服务的场景。"
source: https://xuanyuan.cloud/zh/r/eclipse/centos
canonical: https://xuanyuan.cloud/zh/r/eclipse/centos
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/eclipse/centos" title="eclipse/centos Docker 镜像中文简介、标签列表与拉取命令">eclipse/centos 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Eclipse Che 基础栈 Docker 镜像

## 镜像概述和主要用途

本镜像属于 Eclipse Che 项目的 Stacks 组件，基于 CentOS 构建最小化运行环境，仅包含 git 和 openssh 基础工具。主要用途是作为 Eclipse Che 工作空间的基础栈，为开发者提供轻量级、可移植的容器化开发环境，支持基本版本控制操作和 SSH 远程访问功能。


## 核心功能和特性

### 核心功能
- 基于 CentOS 的最小化操作系统环境，资源占用低
- 内置 git 工具，支持代码克隆、提交、推送等基础版本控制操作
- 内置 openssh 服务，支持通过 SSH 协议进行远程访问和操作
- 符合 Eclipse Che Stack 规范，可无缝集成到 Che 工作空间管理体系

### 特性优势
- **轻量化**：仅包含必要工具，减少冗余依赖，提升启动速度
- **兼容性**：基于 CentOS 构建，兼容主流 Linux 开发工具链
- **可扩展性**：可作为基础镜像，通过添加额外依赖扩展功能
- **标准化**：遵循 Eclipse Che 工作空间规范，确保跨环境一致性


## 使用场景和适用范围

### 适用场景
- 需要轻量级开发环境的场景（如资源受限环境、基础代码管理任务）
- 需通过 SSH 进行远程代码操作或调试的工作流
- 作为定制化开发栈的基础镜像（如添加特定语言运行时或构建工具）
- 快速搭建临时开发环境，避免本地环境配置冲突

### 适用人群
- Eclipse Che 用户（需基础工作空间支持）
- 追求轻量化开发环境的开发者
- 需要标准化基础开发环境的团队


## 详细使用方法和配置说明

### 前置要求
- Docker Engine 20.10+（兼容 Linux/macOS/Windows，需开启 Docker 服务）
- Eclipse Che 服务器环境（4.0+版本，用于工作空间管理）
- 网络可访问 Docker Hub 或私有镜像仓库（用于拉取镜像）


### Docker 部署示例

#### 1. 基础测试（直接运行容器）
通过以下命令启动镜像并进入交互式终端，验证环境完整性：
```bash
docker run -it --rm eclipse/che-stack-centos-minimal:latest /bin/bash
```
> 说明：`--rm` 参数表示容器退出后自动清理，适合临时测试；`-it` 启用交互式终端。


#### 2. 作为 Eclipse Che 工作空间栈使用
在 Eclipse Che 中配置自定义栈，需创建 `stack.json` 定义文件，示例如下：
```json
{
  "name": "CentOS Minimal Stack",
  "description": "CentOS-based minimal stack with git and openssh",
  "components": {
    "dockerimage": {
      "image": "eclipse/che-stack-centos-minimal:latest",
      "memoryLimit": "512m",  // 限制工作空间内存占用
      "cpuLimit": "0.5"       // 限制 CPU 资源（可选）
    }
  },
  "tags": ["centos", "minimal", "git", "ssh"],
  "commands": [
    {
      "name": "Start SSH",
      "commandLine": "service ssh start",
      "type": "init"  // 工作空间启动时自动执行
    }
  ]
}
```
通过 Che 管理界面导入该 JSON 文件，即可在创建工作空间时选择本栈。


#### 3. Docker Compose 集成（配合 Che 服务器）
若需在本地部署 Che 服务器并关联本栈，可使用以下 `docker-compose.yml` 配置：
```yaml
version: '3'
services:
  che-server:
    image: eclipse/che-server:latest
    ports:
      - "8080:8080"  // Che 控制台访问端口
    volumes:
      - che-data:/data  // 持久化 Che 配置和元数据
    environment:
      - CHE_WORKSPACE_STACKS_REPOSITORY=https://github.com/eclipse/che-dockerfiles.git  // 栈定义仓库地址
      - CHE_LOG_LEVEL=INFO  // 日志级别（可选：DEBUG/INFO/WARN/ERROR）

  workspace-example:
    image: eclipse/che-stack-centos-minimal:latest
    depends_on:
      - che-server
    volumes:
      - workspace-data:/workspace  // 持久化工作空间代码
    environment:
      - CHE_WORKSPACE_ID=minimal-workspace-01  // 工作空间唯一标识
    networks:
      - che-network  // 与 Che 服务器共享网络

volumes:
  che-data:
  workspace-data:

networks:
  che-network:
    driver: bridge
```
启动服务：
```bash
docker-compose up -d
```


### 关键配置说明

#### 端口映射
| 端口    | 用途                  | 映射建议          |
|---------|-----------------------|-------------------|
| 22      | SSH 服务端口          | 本地端口映射（如 `-p 2222:22`） |
| 8080    | Che 服务器 Web 端口    | 必须映射（如 `-p 8080:8080`） |


#### 环境变量
| 变量名                          | 说明                                  | 默认值                                  |
|---------------------------------|---------------------------------------|-----------------------------------------|
| `CHE_WORKSPACE_ID`              | 工作空间唯一标识                      | 自动生成（建议手动指定便于管理）         |
| `CHE_WORKSPACE_STACKS_REPOSITORY` | Che 栈定义仓库地址                   | `https://github.com/eclipse/che-dockerfiles.git` |
| `MEMORY_LIMIT`                  | 容器内存限制                          | `512m`                                  |


#### 数据卷挂载
| 挂载路径       | 用途                  | 建议配置                          |
|----------------|-----------------------|-----------------------------------|
| `/data`        | Che 服务器配置数据    | 本地目录挂载（如 `-v ./che-data:/data`） |
| `/workspace`   | 工作空间代码存储      | 本地目录挂载（如 `-v ./workspace:/workspace`） |


### 基础操作示例

#### 1. 通过 SSH 访问工作空间
1. 在工作空间内启动 SSH 服务：
   ```bash
   service ssh start
   ```
2. 本地通过 SSH 连接（需提前映射 22 端口）：
   ```bash
   ssh root@localhost -p 2222  # 默认 root 用户，无密码（生产环境需配置密码/密钥）
   ```

#### 2. 使用 git 拉取代码
```bash
git clone https://github.com/example/project.git /workspace/project
```


## 注意事项
- **安全性**：默认配置下 SSH 无密码访问，生产环境需通过 `passwd` 命令设置密码或配置 SSH 密钥认证。
- **扩展性**：如需添加工具（如 `gcc`、`java`），可通过 Dockerfile 基于本镜像构建定制镜像：
  ```dockerfile
  FROM eclipse/che-stack-centos-minimal:latest
  RUN yum install -y gcc  # 添加 gcc 编译器
  ```
- **兼容性**：已测试兼容 Eclipse Che 4.0+、Docker 20.10+，支持 Linux/macOS/Windows（需开启 WSL2 或 Docker Desktop）。


## 相关资源
- [Eclipse Che 官方文档](https://eclipse.org/che/docs/)
- [Che Stacks 定制指南](https://github.com/eclipse/che/blob/master/CUSTOMIZING.md)
- [Eclipse Che GitHub 仓库](https://github.com/eclipse/che)

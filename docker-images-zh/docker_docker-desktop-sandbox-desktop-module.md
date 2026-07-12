---
image: docker/docker-desktop-sandbox-desktop-module
description: "用于编码代理沙箱的模块，提供安全隔离的运行环境，支持编码代理执行代码、测试和调试任务，确保主系统安全，适用于开发和测试编码代理场景。"
source: https://xuanyuan.cloud/zh/r/docker/docker-desktop-sandbox-desktop-module
canonical: https://xuanyuan.cloud/zh/r/docker/docker-desktop-sandbox-desktop-module
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/docker/docker-desktop-sandbox-desktop-module" title="docker/docker-desktop-sandbox-desktop-module Docker 镜像中文简介、标签列表与拉取命令">docker/docker-desktop-sandbox-desktop-module 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 编码代理沙箱模块镜像文档

## 镜像概述和主要用途

本镜像是一个专为编码代理设计的沙箱模块，旨在提供安全隔离的运行环境，用于隔离编码代理的代码执行过程。通过该沙箱，编码代理可在受限环境中执行代码、运行测试用例及调试程序，有效防止恶意代码或错误操作对主系统造成影响。主要用途包括：支持编码代理的开发与测试、隔离代码执行风险、保障主系统安全稳定运行。


## 核心功能和特性

### 1. 安全隔离机制
- 基于轻量级容器技术实现进程级隔离，限制沙箱内程序对主机资源的直接访问。
- 默认禁用沙箱与外部网络的直接连接（可通过配置开启），降低网络攻击风险。

### 2. 多语言代码执行支持
- 内置常见编程语言运行环境（如Python、JavaScript、Java等），支持编码代理执行多类型代码文件。
- 可通过扩展配置添加更多编程语言支持。

### 3. 资源限制管控
- 支持配置CPU、内存、磁盘空间等资源限制，防止沙箱内程序过度占用主机资源。
- 提供超时控制机制，自动终止长时间运行的任务，避免资源滥用。

### 4. 执行日志与审计
- 记录沙箱内代码执行的详细日志（包括执行时间、代码内容、输出结果、错误信息等），便于后续审计和问题排查。
- 支持日志导出至外部存储（如文件、ELK等），满足合规性需求。


## 使用场景和适用范围

### 使用场景
- **编码代理开发测试**：开发者可在沙箱中测试编码代理的代码生成、执行逻辑，无需担心影响本地开发环境。
- **自动化代码评审**：编码代理在沙箱内运行静态代码分析工具（如ESLint、Pylint），隔离评审过程与主系统。
- **教育平台代码练习**：学生提交的代码在沙箱中执行，防止恶意代码破坏教学服务器，保障平台安全。
- **AI编码助手后端**：AI编码助手生成的代码通过沙箱验证执行结果，确保代码可运行性后再返回给用户。

### 适用范围
- 编码代理开发者、AI代码助手服务商、教育机构、需要隔离代码执行的企业研发团队。


## 使用方法和配置说明

### 环境要求
- Docker Engine 20.10+ 或兼容的容器运行时。
- 主机需分配至少1GB内存、10GB磁盘空间用于沙箱运行。


### Docker部署示例

#### 1. 基础运行命令
通过`docker run`直接启动沙箱容器：
```bash
docker run -d \
  --name coding-agent-sandbox \
  -e ALLOWED_LANGUAGES="python,javascript" \  # 允许执行的编程语言（逗号分隔）
  -e RESOURCE_LIMIT_MEM="1G" \              # 内存限制
  -e RESOURCE_LIMIT_CPU="1" \               # CPU核心限制
  -e LOG_LEVEL="info" \                     # 日志级别（debug/info/warn/error）
  -v /path/to/local/logs:/app/logs \        # 挂载日志目录（可选）
  coding-agent-sandbox:latest
```

#### 2. Docker Compose配置
创建`docker-compose.yml`文件，定义沙箱服务：
```yaml
version: '3'
services:
  sandbox:
    image: docker.xuanyuan.run/coding-agent-sandbox:latest
    container_name: coding-agent-sandbox
    environment:
      - ALLOWED_LANGUAGES=python,javascript,java
      - RESOURCE_LIMIT_MEM=2G
      - RESOURCE_LIMIT_CPU=2
      - NETWORK_ENABLED=false  # 是否允许沙箱访问外部网络（默认false）
      - TASK_TIMEOUT=300       # 任务超时时间（秒，默认300）
    volumes:
      - ./sandbox-logs:/app/logs
    restart: unless-stopped
```
启动服务：`docker-compose up -d`


### 配置参数说明
| 环境变量名              | 描述                                  | 默认值                  | 示例值                          |
|-------------------------|---------------------------------------|-------------------------|---------------------------------|
| `ALLOWED_LANGUAGES`     | 允许在沙箱中执行的编程语言（逗号分隔） | `python,javascript`     | `python,java,c++`               |
| `RESOURCE_LIMIT_CPU`    | 沙箱可使用的CPU核心数                  | `1`                     | `2`（限制为2核心）              |
| `RESOURCE_LIMIT_MEM`    | 沙箱可使用的最大内存量                | `512M`                  | `1G`（限制为1GB）               |
| `RESOURCE_LIMIT_DISK`   | 沙箱可使用的最大磁盘空间              | `1G`                    | `2G`（限制为2GB）               |
| `NETWORK_ENABLED`       | 是否允许沙箱访问外部网络              | `false`                 | `true`（开启网络访问）          |
| `TASK_TIMEOUT`          | 单个代码执行任务的超时时间（秒）      | `300`                   | `60`（超时时间1分钟）           |
| `LOG_LEVEL`             | 日志输出级别                          | `info`                  | `debug`（输出详细调试日志）     |
| `LOG_OUTPUT_PATH`       | 沙箱日志存储路径（容器内路径）        | `/app/logs/sandbox.log` | `/var/log/sandbox/execution.log`|


### 基本使用流程
1. **启动沙箱容器**：通过上述`docker run`或`docker-compose`命令启动沙箱服务。
2. **提交代码任务**：编码代理通过沙箱暴露的API（如HTTP接口）提交代码执行请求（需提前部署API服务，此处省略API细节）。
3. **获取执行结果**：沙箱执行代码后，返回执行结果（输出、错误信息、执行状态）至编码代理。
4. **查看日志**：通过挂载的日志目录或`docker logs coding-agent-sandbox`命令查看执行日志。


## 注意事项
- 生产环境中建议配合反向代理和身份认证机制，限制对沙箱API的访问。
- 定期更新镜像至最新版本，以获取安全补丁和功能优化。
- 对于高并发场景，建议部署沙箱集群并启用负载均衡，避免单容器压力过大。

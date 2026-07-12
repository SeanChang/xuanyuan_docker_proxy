---
image: ddsderek/runlike
description: "runlike是一个根据运行中的Docker容器生成对应docker run命令的工具，帮助用户快速获取容器启动参数，便于重现或复制容器配置。"
source: https://xuanyuan.cloud/zh/r/ddsderek/runlike
canonical: https://xuanyuan.cloud/zh/r/ddsderek/runlike
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ddsderek/runlike" title="ddsderek/runlike Docker 镜像中文简介、标签列表与拉取命令">ddsderek/runlike 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# runlike Docker镜像文档

## 镜像概述
runlike Docker镜像是一款轻量级工具，旨在通过分析运行中的Docker容器配置，自动生成对应的`docker run`命令。该工具通过挂载Docker守护进程的Unix套接字（`/var/run/docker.sock`）与Docker引擎通信，提取容器的启动参数（如端口映射、数据卷挂载、环境变量等），并转换为可直接执行的命令，解决用户忘记容器启动参数的痛点。

## 核心功能与特性
- **自动生成启动命令**：输入容器名称或ID，即可生成完整的`docker run`命令，包含所有原始启动参数
- **轻量级设计**：镜像体积小，运行时无需持久化存储，使用`--rm`参数可实现"用完即删"，不占用系统资源
- **零额外依赖**：仅需挂载Docker套接字即可工作，无需在主机安装Docker客户端或其他工具

## 使用场景与适用范围
- **容器配置重现**：当需要重新创建具有相同配置的容器时，快速生成启动命令
- **参数文档记录**：为运行中的容器生成可复用的启动命令，用于文档或配置管理
- **学习与调试**：帮助理解容器的实际启动参数，辅助Docker命令学习和问题排查

## 使用方法与配置说明

### 基本使用命令
```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock docker.xuanyuan.run/ddsderek/runlike YOUR-CONTAINER
```

### 参数详解
- `--rm`：容器退出后自动删除，避免残留临时容器文件
- `-v /var/run/docker.sock:/var/run/docker.sock`：挂载Docker守护进程的Unix套接字，是工具与Docker引擎通信的必要配置
- `ddsderek/runlike`：runlike工具的Docker镜像名称
- `YOUR-CONTAINER`：目标容器的名称或ID，需替换为实际运行中的容器标识符

### 使用示例
若需获取名为`web-server`的容器的启动命令，执行：
```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock docker.xuanyuan.run/ddsderek/runlike web-server
```

### 输出示例
执行上述命令后，将输出类似以下的`docker run`命令（具体参数取决于目标容器配置）：
```bash
docker run --name=web-server -p 8080:80 -v /host/data:/app/data -e "ENV=prod" --restart=always docker.xuanyuan.run/nginx:alpine
```

## 注意事项
- 确保目标容器处于运行状态，工具仅能分析正在运行的容器
- 主机需具备对`/var/run/docker.sock`的读写权限，否则可能导致通信失败
- 镜像需使用正确的容器名称或ID，若容器不存在或已停止，工具将返回错误信息

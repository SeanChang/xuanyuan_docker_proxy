---
image: homebrew/ubuntu20.04
description: "包含Homebrew开源包管理器的Ubuntu 20.04 Docker镜像。"
source: https://xuanyuan.cloud/zh/r/homebrew/ubuntu20.04
canonical: https://xuanyuan.cloud/zh/r/homebrew/ubuntu20.04
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/homebrew/ubuntu20.04" title="homebrew/ubuntu20.04 Docker 镜像中文简介、标签列表与拉取命令">homebrew/ubuntu20.04 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Homebrew/ubuntu20.04

## 镜像说明
这是一个包含[Homebrew](https://brew.sh)开源包管理器的Ubuntu 20.04 Docker镜像。

## 安装位置
Homebrew在Linux系统中按默认支持位置（`/home/linuxbrew/.linuxbrew/bin/bin`）进行配置，可直接使用二进制包。

## 包含内容
镜像包含运行Homebrew所需的所有必要开发依赖、gems，以及Homebrew/homebrew-core Git tap。

## 用途
主要用于Homebrew的CI（持续集成）和开发工作流，同时可供Linux系统上的Homebrew用户使用，通过常规执行`brew`命令即可操作。

## Docker部署方案示例
### 拉取镜像
```bash
docker pull docker.xuanyuan.run/homebrew/ubuntu20.04
```

### 运行容器并验证Homebrew
```bash
docker run -it --rm docker.xuanyuan.run/homebrew/ubuntu20.04 brew --version
```

## 获取帮助
使用中如需帮助，可访问[Homebrew/discussions](https://github.com/orgs/Homebrew/discussions)。

## 许可证
Homebrew采用[BSD 2-Clause "Simplified" License](https://github.com/Homebrew/brew/blob/master/LICENSE.txt)许可协议。

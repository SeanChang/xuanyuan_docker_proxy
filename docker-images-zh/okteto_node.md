---
image: okteto/node
description: "用于与Okteto CLI配合的Node.js开发环境镜像，适用于在Kubernetes环境中进行Node.js应用的开发、调试与测试。"
source: https://xuanyuan.cloud/zh/r/okteto/node
canonical: https://xuanyuan.cloud/zh/r/okteto/node
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/okteto/node" title="okteto/node Docker 镜像中文简介、标签列表与拉取命令">okteto/node 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述

该镜像包含适用于Node.js的开发环境，旨在与[Okteto CLI](https://github.com/okteto/okteto)配合使用。[Okteto](https://okteto.com/)是面向开发者的Kubernetes工具，提供简化的Kubernetes开发体验。

## 特性

- 预配置Node.js运行时环境，无需手动安装配置；
- 原生支持Okteto CLI，便于集成到Kubernetes开发工作流；
- 优化开发体验，支持代码热重载、远程调试等开发场景。

## 使用场景

- 在Kubernetes集群中进行Node.js应用的本地开发与远程调试；
- 简化基于Kubernetes的Node.js项目开发流程，提升团队协作效率；
- 快速搭建一致的Node.js开发环境，确保开发环境与生产环境一致性。

## 部署示例

### 基本使用

通过Docker命令启动开发环境：
```bash
docker run -it --rm docker.xuanyuan.run/okteto/node-dev-env
```

### 结合Okteto CLI使用

1. 确保已安装Okteto CLI；
2. 在Node.js项目根目录创建`okteto.yml`配置文件；
3. 执行以下命令启动开发环境：
```bash
okteto up
```

上述命令将利用该镜像启动Node.js开发环境，并将本地代码同步至Kubernetes集群，支持实时开发与调试。

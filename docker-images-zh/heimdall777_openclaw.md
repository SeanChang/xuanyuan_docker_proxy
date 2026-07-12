---
image: heimdall777/openclaw
description: "openclaw Docker镜像是基于GitHub仓库https://github.com/openclaw/openclaw的Dockerfile构建的镜像，用于运行或开发openclaw相关应用。"
source: https://xuanyuan.cloud/zh/r/heimdall777/openclaw
canonical: https://xuanyuan.cloud/zh/r/heimdall777/openclaw
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/heimdall777/openclaw" title="heimdall777/openclaw Docker 镜像中文简介、标签列表与拉取命令">heimdall777/openclaw 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# openclaw Docker镜像文档

## 镜像概述
openclaw Docker镜像是基于GitHub仓库[openclaw/openclaw](https://github.com/openclaw/openclaw)提供的Dockerfile构建的容器化环境，旨在为openclaw应用提供便捷、一致的运行和开发环境。

## 核心功能与特性
- **官方构建**：基于项目官方Dockerfile构建，确保与openclaw应用的兼容性
- **环境一致性**：封装应用运行所需依赖，避免环境差异导致的问题
- **部署便捷**：通过容器化方式简化openclaw应用的部署流程

## 使用场景
- 开发环境：快速搭建openclaw应用的本地开发环境
- 测试环境：在隔离环境中验证openclaw应用功能
- 生产部署：作为openclaw应用的运行载体，确保环境一致性

## 使用方法

### 基本运行
若镜像已发布至Docker Hub，可直接拉取并运行：
```bash
docker run -it --rm docker.xuanyuan.run/openclaw/openclaw
```

### 本地构建镜像
如需基于源码构建镜像，执行以下步骤：
1. 克隆GitHub仓库：
   ```bash
   git clone https://github.com/openclaw/openclaw.git
   cd openclaw
   ```
2. 构建镜像：
   ```bash
   docker build -t openclaw/openclaw .
   ```

### 配置说明
目前官方Dockerfile未明确提供额外配置参数，详细使用方式请参考[项目GitHub仓库](https://github.com/openclaw/openclaw)的文档说明。

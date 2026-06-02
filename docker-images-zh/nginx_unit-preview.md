---
image: nginx/unit-preview
description: "用于预览Unit新功能的Docker镜像，提供便捷的测试环境，帮助开发者提前体验和评估即将发布的功能特性，无需手动搭建复杂开发环境。"
source: https://xuanyuan.cloud/zh/r/nginx/unit-preview
canonical: https://xuanyuan.cloud/zh/r/nginx/unit-preview
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nginx/unit-preview" title="nginx/unit-preview Docker 镜像中文简介、标签列表与拉取命令">nginx/unit-preview 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

该Docker镜像专为预览Unit的新功能而设计，提供隔离、便捷的测试环境。开发者无需手动配置复杂的开发环境，通过该镜像可快速部署并体验Unit即将发布的功能特性，支持提前评估功能完整性、兼容性及潜在问题。

## 核心功能与特性

- **最新功能预览**：内置Unit最新开发版本，包含尚未正式发布的新功能及改进。
- **隔离测试环境**：基于Docker容器隔离特性，避免对本地开发环境造成干扰。
- **快速部署流程**：简化部署步骤，通过简短命令即可启动预览环境，无需复杂配置。
- **轻量级设计**：优化镜像体积，减少资源占用，适用于本地开发机及CI/CD管道。

## 使用场景与适用范围

- **开发者功能测试**：开发人员在Unit新版本发布前，验证新功能的功能完整性及兼容性。
- **功能评估与验证**：技术团队评估新功能是否满足业务需求，制定迁移或适配计划。
- **测试报告编写**：基于预览环境生成新功能测试报告或使用文档。
- **CI/CD集成**：作为自动化测试环节，在持续集成流程中验证新功能对现有系统的影响。

## 使用方法

### 基本使用

通过以下命令快速启动镜像，体验Unit新功能：

```bash
docker run -d -p 8080:80 --name unit-preview unit-preview-features:latest
```

**说明**：  
- `-d`：后台运行容器  
- `-p 8080:80`：映射容器80端口至主机8080端口  
- `--name unit-preview`：指定容器名称为`unit-preview`  

### 访问服务

容器启动后，通过 `http://localhost:8080` 访问Unit服务，具体功能路径及使用方式请参考Unit官方文档中对应预览功能的说明。

### 配置参数

#### 环境变量

支持通过以下环境变量自定义配置：

| 环境变量         | 说明                                                                 | 默认值       |
|------------------|----------------------------------------------------------------------|--------------|
| `UNIT_LOG_LEVEL` | 日志级别，可选值：`debug`/`info`/`warn`/`error`                      | `info`       |
| `UNIT_PORT`      | 容器内服务监听端口，修改时需同步调整端口映射（如 `-p 8081:81`）       | `80`         |
| `FEATURE_FLAGS`  | 启用的预览功能标志，多值用逗号分隔（如 `feature-a,feature-b`）       | 启用所有功能 |

**示例**：指定日志级别为`debug`并仅启用`feature-x`功能  
```bash
docker run -d -p 8080:80 -e UNIT_LOG_LEVEL=debug -e FEATURE_FLAGS=feature-x --name unit-preview unit-preview-features:latest
```

#### 数据持久化（可选）

通过挂载本地目录保留测试数据（默认数据目录为`/data`）：

```bash
docker run -d -p 8080:80 -v ./local-test-data:/data --name unit-preview unit-preview-features:latest
```

### docker-compose配置示例

创建`docker-compose.yml`文件，配置如下：

```yaml
version: '3'
services:
  unit-preview:
    image: unit-preview-features:latest
    ports:
      - "8080:80"
    environment:
      - UNIT_LOG_LEVEL=info
      - FEATURE_FLAGS=feature-x,feature-y
    volumes:
      - ./test-data:/data  # 持久化测试数据
    restart: unless-stopped  # 容器退出时自动重启（非生产环境建议）
```

启动命令：  
```bash
docker-compose up -d
```

### 注意事项

- 该镜像包含的功能为预览版，存在不稳定风险，**禁止用于生产环境**。  
- 镜像版本随Unit开发进度更新，建议定期执行`docker pull unit-preview-features:latest`获取最新预览功能。  
- 功能异常排查：通过容器日志定位问题，命令为 `docker logs unit-preview`。

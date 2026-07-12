---
image: hashicorp/dev-portal
description: "用于运行HashiCorp开发者门户和产品文档网站的容器。"
source: https://xuanyuan.cloud/zh/r/hashicorp/dev-portal
canonical: https://xuanyuan.cloud/zh/r/hashicorp/dev-portal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/dev-portal" title="hashicorp/dev-portal Docker 镜像中文简介、标签列表与拉取命令">hashicorp/dev-portal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# HashiCorp 产品文档站点 Docker 镜像

## 镜像概述和主要用途
本Docker镜像用于在本地运行HashiCorp开发者门户及产品文档站点，基于Next.js应用框架以开发模式运行。镜像并非独立使用，主要供HashiCorp产品文档的贡献者或开发者在本地环境中运行和预览产品文档站点，支持文档内容的开发与验证。

## 核心功能和特性
- **基于Next.js框架**：内置Next.js应用，以开发模式运行，支持文档内容的实时更新与预览
- **灵活的内容挂载**：支持挂载产品文档的内容目录、静态资源、数据文件及重定向配置，便于本地修改与预览
- **环境配置支持**：可通过环境变量及`.env`文件自定义运行参数，适配不同产品文档的需求
- **缓存持久化**：通过命名卷持久化Next.js构建缓存（`.next`目录），提升重复启动效率

## 使用场景和适用范围

### 适用范围
HashiCorp产品文档的贡献者、开发者或维护人员。

### 使用场景
- 本地开发产品文档内容（如修改文档文本、调整页面结构）
- 预览文档站点的显示效果，验证格式、链接及功能正确性
- 配合产品仓库的构建流程，快速启动文档预览环境

## 详细的使用方法和配置说明

### 基本使用流程
使用需依赖具体HashiCorp产品仓库的`/website`目录。通常在该目录下执行`make`命令即可通过本镜像启动文档站点（具体以产品仓库的构建脚本为准）。

### Docker运行示例
以下为Waypoint产品文档的启动命令示例，可根据实际产品调整参数：

```bash
docker run -it \
    --publish "3000:3000" \
    --rm \
    --tty \
    --volume "$(pwd)/content:/app/content" \
    --volume "$(pwd)/public:/app/public" \
    --volume "$(pwd)/data:/app/data" \
    --volume "$(pwd)/redirects.js:/app/redirects.js" \
    --volume "next-dir:/app/website-preview/.next" \
    --volume "$(pwd)/.env:/app/.env" \
    -e "REPO=waypoint" \
    docker.xuanyuan.run/hashicorp/dev-portal
```

### 参数说明

#### 网络与交互参数
- `--publish "3000:3000"`：将容器内3000端口（Next.js默认开发端口）映射到主机3000端口，用于访问文档站点
- `--rm`：容器停止后自动删除容器文件，清理环境
- `--tty`：分配交互终端，支持日志输出与控制

#### 挂载卷配置
- `--volume "$(pwd)/content:/app/content"`：挂载产品仓库的`content`目录（文档内容文件）到容器内，实现内容实时更新
- `--volume "$(pwd)/public:/app/public"`：挂载静态资源目录（如图片、样式文件）
- `--volume "$(pwd)/data:/app/data"`：挂载数据文件目录（如文档索引、配置数据）
- `--volume "$(pwd)/redirects.js:/app/redirects.js"`：挂载重定向配置文件，定义页面跳转规则
- `--volume "next-dir:/app/website-preview/.next"`：命名卷`next-dir`用于持久化Next.js的构建缓存（`.next`目录），加速后续启动
- `--volume "$(pwd)/.env:/app/.env"`：挂载环境变量配置文件（`.env`），自定义应用运行参数

#### 环境变量
- `-e "REPO=waypoint"`：指定产品仓库名称（如`waypoint`），用于加载对应产品的文档配置

## 社区支持
如在使用本Docker镜像过程中遇到问题，请在[Dev Portal仓库](https://github.com/hashicorp/dev-portal/issues)提交issue。

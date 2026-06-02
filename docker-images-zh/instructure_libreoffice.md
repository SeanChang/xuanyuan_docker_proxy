---
image: instructure/libreoffice
description: "LibreOffice是一款开源办公套件Docker镜像，集成文字处理、电子表格、演示文稿等工具，适用于文档创建、编辑及格式转换等办公任务。"
source: https://xuanyuan.cloud/zh/r/instructure/libreoffice
canonical: https://xuanyuan.cloud/zh/r/instructure/libreoffice
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/instructure/libreoffice" title="instructure/libreoffice Docker 镜像中文简介、标签列表与拉取命令">instructure/libreoffice — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/instructure/libreoffice" title="instructure/libreoffice Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/instructure/libreoffice</a>

# Instructure 开源基础 Docker 镜像

## 镜像概述和主要用途

Instructure 开源基础 Docker 镜像是一套用于构建语言基础镜像及其 Web 服务器（Passenger）对应版本的基础镜像集合。该镜像通过模板化系统实现多版本镜像的统一管理与构建，旨在为 Instructure 相关应用的开发、部署提供标准化的底层环境支持，简化多语言版本、多配置场景下的基础镜像维护流程。


## 核心功能和特性

### 模板化生成机制
- 基于模板系统（`template` 目录）统一管理镜像构建配置，支持批量生成不同版本的基础镜像，减少重复开发工作。

### 多版本管理能力
- 通过 `manifest` 文件中的 `versions` 对象定义各语言版本的构建参数，每个对象对应特定语言的版本目录（如 `ruby/3.1`、`python/3.9`），实现多版本并行维护。

### 配置参数合并
- 支持 `defaults` 全局默认配置与 `versions` 版本特定配置的自动合并，优先使用版本配置覆盖默认配置，提升配置复用性和灵活性。

### 自动化更改传播
- 提供 `rake` 命令工具，可将 `template` 目录的配置修改自动同步到所有版本的构建目录，确保各版本镜像配置一致性。

### 模板变量注入
- 自动向 `manifest` 中指定的模板文件注入 `version`（版本号）和 `generation_message`（生成信息）变量，确保镜像构建元数据可追溯。


## 使用场景和适用范围

### 目标用户
- Instructure 项目开发者及运维人员，需管理多语言版本基础镜像的团队。

### 典型场景
- 构建标准化的语言基础镜像（如 Ruby、Python 等）及配套 Passenger Web 服务器镜像。
- 维护多语言版本的基础环境（如 Ruby 3.1、3.2 并行支持），确保开发、测试、生产环境一致性。
- 批量更新基础镜像配置（如安全补丁、依赖升级），并同步应用到所有版本。


## 详细的使用方法和配置说明

### 环境准备
- 依赖工具：Ruby（用于运行 `rake` 命令）、Docker、Git。
- 项目结构：包含语言目录（如 `ruby`、`python`），每个目录下含 `template` 模板目录、`manifest` 配置文件及版本目录（如 `3.1`、`3.2`）。


### 更新镜像流程

#### 1. 修改模板文件
根据需求调整目标语言的模板配置（以 Ruby 为例）：
```bash
# 进入 Ruby 语言的模板目录
cd ruby/template
# 编辑 Dockerfile 模板（添加新依赖或配置）
vim Dockerfile.template
```


#### 2. 配置 manifest 文件
`manifest` 文件（位于语言目录根目录，如 `ruby/manifest.json`）定义构建参数，格式示例：
```json
{
  "defaults": {
    "base_image": "ubuntu:22.04",
    "packages": ["curl", "git"]
  },
  "versions": {
    "3.1": {
      "ruby_version": "3.1.4",
      "packages": ["curl", "git", "nodejs"]
    },
    "3.2": {
      "ruby_version": "3.2.2",
      "packages": ["curl", "git", "nodejs", "yarn"]
    }
  },
  "templates": ["Dockerfile.template", "config/passenger.conf.template"]
}
```

- **核心配置项**：
  - `defaults`：全局默认配置（如基础镜像版本、通用依赖包），所有版本共享。
  - `versions`：版本特定配置，键为版本号（如 `3.1`），值为该版本的个性化参数（如语言版本、额外依赖），可覆盖 `defaults` 中同名配置。
  - `templates`：需注入变量的模板文件列表（支持相对路径）。


#### 3. 传播模板更改
运行 `rake` 命令将 `template` 目录的修改同步到所有版本的构建目录：
```bash
# 在项目根目录执行
rake
```
该命令会根据 `manifest` 配置，将 `template` 目录下的文件渲染到对应版本目录（如 `ruby/3.1`、`ruby/3.2`），并自动注入 `version` 和 `generation_message` 变量。


#### 4. 构建镜像
以 Ruby 3.1 版本为例，进入版本目录执行构建：
```bash
cd ruby/3.1
docker build -t instructure/ruby-base:3.1 .
```


### 配置参数说明

#### manifest 文件参数
| 参数名          | 说明                                                                 |
|-----------------|----------------------------------------------------------------------|
| `defaults`      | 全局默认配置，所有版本共享，如 `base_image: "ubuntu:22.04"`          |
| `versions`      | 版本配置集合，键为版本号（如 `3.1`），值为该版本的个性化配置          |
| `templates`     | 需要注入变量的模板文件路径列表（相对 `template` 目录）                |


#### 模板文件变量
模板文件中可使用以下自动注入的变量：
- `version`：当前版本号（从 `versions` 对象的键获取，如 `3.1`）。
- `generation_message`：镜像生成元信息（默认包含生成时间、构建主机等，可自定义）。


## Docker 部署方案示例

### 构建特定版本镜像（以 Ruby 3.2 为例）
```bash
# 1. 克隆项目代码
git clone <项目仓库地址>
cd instructure-base-images/ruby

# 2. 修改模板配置（如需）
vim template/Dockerfile.template

# 3. 传播更改到版本目录
rake

# 4. 构建镜像
cd 3.2
docker build -t instructure/ruby-base:3.2 .

# 5. 验证镜像
docker run --rm instructure/ruby-base:3.2 ruby -v  # 输出 Ruby 3.2.2
```

### docker-compose 批量构建配置（示例）
在项目根目录创建 `docker-compose.yml`：
```yaml
version: '3.8'
services:
  ruby-3.1:
    build: ./ruby/3.1
    image: instructure/ruby-base:3.1
  ruby-3.2:
    build: ./ruby/3.2
    image: instructure/ruby-base:3.2
  python-3.9:
    build: ./python/3.9
    image: instructure/python-base:3.9
```
执行批量构建：
```bash
docker-compose build

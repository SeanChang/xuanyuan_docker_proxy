---
image: hashicorp/learn-website
description: "用于构建learn.hashicorp.com网站的Docker镜像"
source: https://xuanyuan.cloud/zh/r/hashicorp/learn-website
canonical: https://xuanyuan.cloud/zh/r/hashicorp/learn-website
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/learn-website" title="hashicorp/learn-website Docker 镜像中文简介、标签列表与拉取命令">hashicorp/learn-website 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# HashiCorp Learn Docker镜像文档

## 1. 镜像概述和主要用途

HashiCorp Learn Docker镜像是用于构建和本地开发HashiCorp学习平台（learn.hashicorp.com）的容器化解决方案。该镜像封装了平台运行所需的全部依赖环境，允许开发者在无需本地配置Node.js的情况下快速搭建开发环境，支持内容预览、热重载及静态站点生成，主要用于平台内容的本地开发、测试和构建。


## 2. 核心功能和特性

- **无依赖环境**：仅需Docker即可运行，无需预先安装Node.js及相关依赖
- **热重载支持**：修改内容后自动刷新，无需重启开发环境
- **双模式运行**：支持预构建镜像快速启动和本地镜像构建（用于依赖变更场景）
- **静态站点生成**：可生成用于部署的静态文件
- **跨平台兼容**：支持Docker for Mac、Windows等主流系统


## 3. 使用场景和适用范围

- **内容开发者**：编写或修改learn.hashicorp.com平台的教程、文档等Markdown内容
- **前端开发者**：调试平台界面样式、交互逻辑及组件功能
- **环境隔离需求**：需要在统一环境中开发，避免本地依赖冲突
- **快速上手场景**：新贡献者无需复杂配置即可启动开发环境


## 4. 使用方法和配置说明

### 4.1 前提条件

- 安装Docker Engine（20.10+）及Docker Compose
- 克隆HashiCorp Learn项目代码库


### 4.2 使用预构建镜像（推荐）

通过预构建镜像可快速启动开发环境，适用于常规内容开发：

```bash
# 拉取并运行预构建镜像（映射3000端口，挂载项目目录）
docker run -it -p 3000:3000 -v $(pwd):/app docker.xuanyuan.run/hashicorp/learn:latest
```

**参数说明**：
- `-p 3000:3000`：将容器3000端口映射到本地，用于访问开发服务
- `-v $(pwd):/app`：挂载本地项目目录到容器，实现文件实时同步
- `-it`：交互式终端，支持日志输出和Ctrl+C终止


### 4.3 本地构建镜像（依赖变更时）

当修改`package.json`等依赖文件时，需重新构建本地镜像：

```bash
# 构建本地镜像（基于项目Dockerfile）
docker build -t learn-website-local .

# 使用本地镜像启动开发服务
docker run -it -p 3000:3000 -v $(pwd):/app docker.xuanyuan.run/learn-website-local
```


### 4.4 访问本地服务

服务启动后，通过以下地址访问本地平台：
- 开发环境：`http://localhost:3000`
- 首次页面导航可能出现样式加载延迟，刷新页面即可解决


## 5. 内容组织与术语

### 5.1 核心术语

- **Curriculum（课程）**：特定产品的所有Track和Topic集合，如`/consul`对应Consul课程
- **Track**：一组相关Topic的逻辑分组，无独立页面，仅在课程页展示为分组，如"Getting Started"
- **Topic**：单个学习指南页面，如`/consul/getting-started/install`


### 5.2 文件系统结构

内容文件按以下层次组织：
```
pages/
└── {product}/              # Curriculum级目录（如consul/、terraform/）
    ├── {trackName}/        # Track级目录（可多层嵌套，构成Track名称）
    │   └── {topic}.mdx     # Topic文件
    └── __shared__/         # 跨Track共享的Topic目录
```

**示例解析**：
`pages/consul/advanced/advanced-operations/autopilot.mdx`
- `consul/`：Curriculum（课程）
- `advanced/advanced-operations/`：Track（轨道）
- `autopilot.mdx`：Topic（主题页面）


### 5.3 Markdown内容创建

#### 5.3.1 Markdown样式指南

遵循[HashiCorp工程Markdown风格指南](https://github.com/hashicorp/engineering-docs/blob/master/writing/markdown.md)，采用CommonMark规范，支持：
- 代码块语法高亮（需指定[有效语言](https://github.com/highlightjs/highlight.js/tree/master/src/languages)）
- 自定义告警框（基于[remark-plugins](https://github.com/hashicorp/remark-plugins/tree/master/plugins/paragraph-custom-alerts)）
- MDX语法（可嵌入React组件）


#### 5.3.2 页面编写（.mdx文件）

创建扩展名为`.mdx`的文件（仅允许单个扩展名），路径即URL路由（如`pages/hello/world.mdx`对应`/hello/world`）。文件需包含YAML前置元数据（Frontmatter），必填项：

```yaml
---
name: "页面标题"               # HTML标题
content_length: 5             # 预计阅读时间（分钟，可通过`npm run estimate-reading-times`自动生成）
id: "unique-topic-id"         # 用于课程关联的唯一标识
products_used: ["consul"]     # 涉及的HashiCorp产品列表
description: "页面简短描述"    # 用于元数据和课程列表展示
level: "getting-started"      # 内容级别，可选：getting-started/operations-and-development
---
```


#### 5.3.3 添加到课程

需在`data/{product}.yml`中配置Topic与Track的关联，示例：

```yaml
# data/consul.yml
tracks:
  - name: "Getting Started"
    id: getting-started
    topics:
      - install               # 对应Topic的id字段
      - configure
      - autopilot             # 关联pages/consul/getting-started/autopilot.mdx
```


### 5.4 跨Track共享Topic

支持在同一产品的多个Track中共享Topic，步骤如下：

1. **创建共享目录**：在`pages/{product}/`下创建`__shared__`目录
   ```bash
   mkdir pages/terraform/__shared__
   ```

2. **编写共享Topic**：在`__shared__`目录中创建`.mdx`文件，文件名建议与`id`一致
   ```mdx
   # pages/terraform/__shared__/reference-architecture.mdx
   ---
   id: reference-architecture  # 共享标识，用于Track引用
   level: Implementation
   products_used: ["terraform"]
   # 其他元数据...
   ---
   ```

3. **关联到Track**：在`data/{product}.yml`的多个Track中引用该`id`
   ```yaml
   # data/terraform.yml
   tracks:
     - name: "Day One"
       topics: [setup, reference-architecture]  # 引用共享Topic
     - name: "Operations"
       topics: [scale, reference-architecture]   # 同一Topic关联到另一Track
   ```

4. **创建符号链接**：在各Track目录中创建指向共享文件的符号链接
   ```bash
   # 示例：为Day One Track创建链接
   cd pages/terraform/day-one
   ln -s ../__shared__/reference-architecture.mdx reference-architecture.mdx
   ```


## 6. 注意事项

### 6.1 Windows用户注意事项

- **符号链接支持**：克隆仓库时需启用符号链接：
  ```bash
  git clone -c core.symlinks=true https://github.com/hashicorp/learn.git
  ```
- **权限要求**：创建符号链接可能需要管理员权限或启用"开发者模式"（Windows 10+）


### 6.2 可选视觉差异测试（Percy）

Percy用于检测UI视觉变化，仅在分支名以`run-percy`开头时触发（如`run-percy.update-style`），流程建议：

1. 创建`run-percy-catchup`分支运行Percy，批准历史变更
2. 基于该分支创建功能分支（如`run-percy.feature-name`），获取无干扰的差异结果

> 权限说明：需通过#team-mktg-webdev申请Percy访问权限

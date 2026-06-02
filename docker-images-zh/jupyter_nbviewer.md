---
image: jupyter/nbviewer
description: "用于查看Jupyter Notebook文件的轻量级工具，无需运行完整内核即可展示文档内容，适用于分享和预览场景。"
source: https://xuanyuan.cloud/zh/r/jupyter/nbviewer
canonical: https://xuanyuan.cloud/zh/r/jupyter/nbviewer
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jupyter/nbviewer" title="jupyter/nbviewer Docker 镜像中文简介、标签列表与拉取命令">jupyter/nbviewer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jupyter Notebook Viewer 镜像文档

[![Latest PyPI version](https://img.shields.io/pypi/v/nbviewer?logo=pypi)](https://pypi.python.org/pypi/nbviewer)
[![TravisCI build status](https://img.shields.io/travis/jupyter/nbviewer/master?logo=travis)](https://travis-ci.org/jupyter/nbviewer)
[![GitHub](https://img.shields.io/badge/issue_tracking-github-blue?logo=github)](https://github.com/jupyter/nbviewer/issues)
[![Gitter](https://img.shields.io/badge/social_chat-gitter-blue?logo=gitter)](https://gitter.im/jupyter/nbviewer)


## 1. 镜像概述与主要用途

Jupyter NBViewer 是 [The Jupyter Notebook Viewer](http://nbviewer.jupyter.org) 背后的 Web 应用程序，由 [OVHcloud](https://ovhcloud.com) 提供托管服务。通过本地运行此镜像，可在私有网络中获得 nbviewer 的大部分功能，实现 Jupyter 笔记本的在线查看与共享。


## 2. 核心功能与特性

- **多来源支持**：内置多种笔记本来源提供商（`url`、`gist`、`github`、`local`），支持从URL、Gist、GitHub仓库及本地文件加载笔记本。
- **GitHub Enterprise 集成**：通过配置API地址，支持企业内部GitHub实例中的笔记本查看。
- **缓存优化**：生产环境中使用 memcached 缓存结果，提升访问速度。
- **JupyterHub 集成**：可作为 JupyterHub 服务运行，实现基于身份验证的安全访问控制。
- **可扩展性**：支持自定义提供商（笔记本来源）和格式（展示方式），满足特定需求。
- **开发友好**：提供本地开发环境配置，支持代码热重载和调试模式。


## 3. 使用场景与适用范围

- **本地网络文档共享**：在团队内部网络部署，方便共享和查看 Jupyter 笔记本。
- **企业内部知识库**：结合 GitHub Enterprise，实现企业私有笔记本的在线展示。
- **开发与测试**：开发 nbviewer 扩展功能时，本地快速搭建测试环境。
- **安全访问控制**：集成 JupyterHub，限制未认证用户访问敏感笔记本资源。


## 4. 使用方法与配置说明

### 4.1 快速启动（Docker）

#### 4.1.1 基本运行

若已安装 Docker，可直接拉取并运行官方镜像：

```shell
# 拉取镜像
docker pull jupyter/nbviewer

# 运行容器，映射端口 8080
docker run -p 8080:8080 jupyter/nbviewer
```

镜像会随 `master` 分支更新自动构建，确保获取最新版本。


#### 4.1.2 配置 GitHub 访问（推荐）

为提升 GitHub 访问速度和友好性，建议配置 GitHub OAuth 密钥或个人访问令牌：

- **使用 OAuth 密钥**：
  ```shell
  docker run -p 8080:8080 \
    -e 'GITHUB_OAUTH_KEY=你的OAuth密钥' \
    -e 'GITHUB_OAUTH_SECRET=你的OAuth密钥密钥' \
    jupyter/nbviewer
  ```

- **使用个人访问令牌**：
  ```shell
  docker run -p 8080:8080 \
    -e 'GITHUB_API_TOKEN=你的GitHub个人访问令牌' \
    jupyter/nbviewer
  ```


### 4.2 GitHub Enterprise 配置

访问企业内部 GitHub 实例时，需设置 `GITHUB_API_URL` 指定 API 端点（格式为 `https://<实例域名>/api/v3/`），并配合 OAuth 密钥或 API 令牌使用：

```shell
docker run -p 8080:8080 \
  -e 'GITHUB_OAUTH_KEY=企业OAuth密钥' \
  -e 'GITHUB_OAUTH_SECRET=企业OAuth密钥密钥' \
  -e 'GITHUB_API_URL=https://ghe.example.com/api/v3/' \
  jupyter/nbviewer
```

配置后，所有 GitHub API 请求将指向企业实例，支持访问内部笔记本。


### 4.3 基础 URL 配置

NBViewer 的基础 URL 优先级如下：
1. 若设置环境变量 `JUPYTERHUB_SERVICE_PREFIX`，则以此值为基础 URL（JupyterHub 集成时自动配置）。
2. 若未设置上述变量，可通过命令行参数 `--base-url` 指定，例如：
   ```shell
   python -m nbviewer --base-url=/nbviewer/
   ```


### 4.4 本地开发环境

#### 4.4.1 Docker 本地构建

如需基于源码修改并构建镜像：

```shell
# 克隆仓库（若未克隆）
git clone https://github.com/jupyter/nbviewer.git
cd nbviewer

# 构建本地镜像
docker build -t nbviewer .

# 运行本地镜像
docker run -p 8080:8080 nbviewer
```


#### 4.4.2 Docker Compose 配置（含 memcached）

生产环境中 NBViewer 使用 memcached 缓存，通过 docker-compose 可快速搭建含缓存的本地开发环境：

```shell
# 安装 docker-compose（若未安装）
pip install docker-compose

# 启动服务（nbviewer + memcached）
cd nbviewer
docker-compose up
```

服务启动后，访问 `http://localhost:8080` 即可使用，代码修改后自动重载。


#### 4.4.3 本地源码安装

需先安装系统依赖包（名称可能因系统而异，以下为 Debian/Ubuntu 示例）：

```shell
# 安装系统依赖
sudo apt-get install libmemcached-dev libcurl4-openssl-dev pandoc libevent-dev libgnutls28-dev

# 克隆仓库并安装 Python 依赖
git clone https://github.com/jupyter/nbviewer.git
cd nbviewer
pip install -r requirements.txt
```

##### 静态资源构建

静态资源（CSS/JS）需通过 `npm` 和 `invoke` 构建：

```shell
# 安装开发依赖
pip install -r requirements-dev.txt
npm install

# 下载前端依赖并构建 CSS
invoke bower  # 下载组件到 nbviewer/static/components
invoke less    # 编译 LESS 为 CSS（添加 -d 生成源码映射，用于调试）
```

##### 本地运行（调试模式）

```shell
# 启动调试模式（自动重载、禁用缓存）
python -m nbviewer --debug --no-cache
```


### 4.5 配置文件与命令行参数

#### 4.5.1 配置文件生成

NBViewer 支持通过配置文件（默认 `nbviewer_config.py`）自定义参数。生成默认配置文件：

```shell
# 生成默认配置（所有可配置项均注释，显示默认值）
python -m nbviewer --generate-config

# 生成自定义名称的配置文件
python -m nbviewer --generate-config --config-file=my_config.py
```

配置文件使用 Jupyter 标准配置语法（基于 traitlets），例如修改默认端口：

```python
# 在配置文件中添加
c.NBViewer.port = 9000  # 将默认端口改为 9000
```


#### 4.5.2 命令行参数

通过 `--help` 查看常用参数，`--help-all` 查看所有可配置项：

```shell
# 查看常用参数
python -m nbviewer --help

# 查看所有可配置项
python -m nbviewer --help-all
```

常用参数示例：
- `--debug`：启用调试模式，自动重载代码
- `--no-cache`：禁用缓存，用于开发测试
- `--port=9000`：指定服务端口（等价于 `c.NBViewer.port=9000`）


### 4.6 环境变量说明

| 环境变量                | 作用说明                                                                 |
|-------------------------|--------------------------------------------------------------------------|
| `GITHUB_OAUTH_KEY`      | GitHub OAuth 应用的客户端 ID，用于提升 GitHub API 访问速率限制。         |
| `GITHUB_OAUTH_SECRET`   | GitHub OAuth 应用的客户端密钥，与 `GITHUB_OAUTH_KEY` 配合使用。          |
| `GITHUB_API_TOKEN`      | GitHub 个人访问令牌，替代 OAuth 密钥，用于 API 认证。                    |
| `GITHUB_API_URL`        | GitHub API 基础 URL，用于 GitHub Enterprise（如 `https://ghe.example.com/api/v3/`）。 |
| `JUPYTERHUB_SERVICE_PREFIX` | JupyterHub 服务路径前缀，设置后作为 NBViewer 的基础 URL。               |


## 5. 扩展开发

### 5.1 自定义提供商（Providers）

提供商定义笔记本的来源，nbviewer 内置 `url`、`gist`、`github`、`local` 提供商。自定义提供商需实现以下功能：

#### 5.1.1 URI 重写（`uri_rewrites`）

若仅需修改 URL 格式（如适配特定网站的链接规则），实现 `uri_rewrites` 函数，将用户输入的 URI 转换为标准格式。示例参考 [Dropbox 提供商](https://github.com/jupyter/nbviewer/blob/master/nbviewer/providers/dropbox/handlers.py)。


#### 5.1.2 自定义处理器（`default_handlers`）

若需对接外部 API（如从特定平台加载笔记本），实现 `default_handlers`，定义请求处理逻辑。示例参考 [GitHub 提供商](https://github.com/jupyter/nbviewer/blob/master/nbviewer/providers/github/handlers.py)。


### 5.2 自定义格式（Formats）

格式定义笔记本的展示方式，内置支持 `html`（默认）、`slides`（幻灯片）、`script`（代码脚本）。开发新格式需实现对应的渲染逻辑，建议先通过 [GitHub Issues](https://github.com/jupyter/nbviewer/issues) 或 [Gitter](https://gitter.im/jupyter/nbviewer) 讨论设计方案。


## 6. 安全配置

### 6.1 JupyterHub 集成

将 NBViewer 作为 JupyterHub 服务运行，可限制未认证用户访问。修改 JupyterHub 配置文件 `jupyterhub_config.py`，添加服务定义：

```python
c.JupyterHub.services = [
    {
        'name': 'nbviewer',          # 服务名称，访问路径为 /services/nbviewer
        'url': 'http://127.0.0.1:9000',  # NBViewer 服务地址
        'cwd': '/path/to/nbviewer',  # nbviewer 源码目录
        'command': ['python', '-m', 'nbviewer']  # 启动命令
    }
]
```

JupyterHub 会自动设置 `JUPYTERHUB_*` 环境变量（如 `JUPYTERHUB_SERVICE_PREFIX`），NBViewer 读取后自动配置基础 URL 和认证逻辑。


## 7. 贡献指南

若希望贡献代码或改进功能，参考 [CONTRIBUTING.md](https://github.com/jupyter/nbviewer/blob/master/CONTRIBUTING.md)，包含开发环境设置、测试流程、提交规范等详细说明。


## 8. 问题反馈

- **使用帮助**：通过 [jupyter/help](https://github.com/jupyter/help) issue 跟踪器寻求安装或使用帮助。
- **功能建议/漏洞报告**：通过 [jupyter/nbviewer](https://github.com/jupyter/nbviewer) issue 跟踪器提交。
- **社区交流**：加入 [Gitter 聊天室](https://gitter.im/jupyter/nbviewer) 参与讨论。

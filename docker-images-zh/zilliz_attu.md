---
image: zilliz/attu
description: "Attu是Milvus的一站式管理工具，提供图形化界面用于监控、管理和操作Milvus向量数据库，可显著降低Milvus的管理成本，支持Milvus 2.x版本，兼容Zilliz Cloud及自建Milvus服务。"
source: https://xuanyuan.cloud/zh/r/zilliz/attu
canonical: https://xuanyuan.cloud/zh/r/zilliz/attu
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zilliz/attu" title="zilliz/attu Docker 镜像中文简介、标签列表与拉取命令">zilliz/attu — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/zilliz/attu" title="zilliz/attu Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/zilliz/attu</a>

# Attu

[![typescript](https://badges.aleen42.com/src/typescript.svg)](https://badges.aleen42.com/src/typescript.svg)
[![downloads](https://img.shields.io/docker/pulls/zilliz/attu)](https://hub.docker.com/r/zilliz/attu/tags)

Attu是Milvus的一站式管理工具，通过图形化界面可显著降低Milvus向量数据库的管理成本，支持监控、数据操作、集合管理、向量搜索等核心功能。

<img src="https://github.com/zilliztech/attu/raw/main/.github/images/screenshot.png" width="800" alt="Attu首页" />

## 安装指南

开始前，请确保已在[Zilliz Cloud](https://cloud.zilliz.com/signup)或[自建服务器](https://milvus.io/docs/install_standalone-docker.md)上安装Milvus。

### 兼容性说明

| Milvus版本 | 推荐Attu版本                                                      |
|------------|-------------------------------------------------------------------|
| 2.5.x      | [v2.5.6](https://github.com/zilliztech/attu/releases/tag/v2.5.6)  |
| 2.4.x      | [v2.4.12](https://github.com/zilliztech/attu/releases/tag/v2.4.12)|
| 2.3.x      | [v2.3.5](https://github.com/zilliztech/attu/releases/tag/v2.3.5)  |
| 2.2.x      | [v2.2.8](https://github.com/zilliztech/attu/releases/tag/v2.2.8)  |
| 2.1.x      | [v2.2.2](https://github.com/zilliztech/attu/releases/tag/v2.2.2)  |

### 使用Docker运行Attu

以下是启动Attu容器的步骤：

```bash
docker run -p 8000:3000 -e MILVUS_URL={milvus服务器IP}:19530 zilliz/attu:v2.4
```

确保Attu容器可访问Milvus服务器IP。启动后，在浏览器中输入`http://{Attu服务器IP}:8000`即可访问Attu图形界面。

#### Attu Docker可选环境变量

| 参数             | 示例                  | 是否必填 | 描述                                   |
|------------------|-----------------------|----------|----------------------------------------|
| MILVUS_URL       | 192.168.0.1:19530     | 否       | Milvus服务器URL                        |
| ATTU_LOG_LEVEL   | info                  | 否       | Attu日志级别                           |
| ROOT_CERT_PATH   | /path/to/root/cert    | 否       | 根证书路径                             |
| PRIVATE_KEY_PATH | /path/to/private/key  | 否       | 私钥路径                               |
| CERT_CHAIN_PATH  | /path/to/cert/chain   | 否       | 证书链路径                             |
| SERVER_NAME      | your_server_name      | 否       | 服务器名称                             |
| SERVER_PORT      | 8080                  | 否       | 服务器监听端口，默认3000               |

> 注意：`MILVUS_URL`必须是Attu容器可访问的地址，因此"127.0.0.1"或"localhost"无法正常工作。

#### Attu SSL配置示例

```bash
docker run -p 8000:3000 \
-v /本地TLS文件路径:/app/tls \
-e ATTU_LOG_LEVEL=info  \
-e ROOT_CERT_PATH=/app/tls/ca.pem \
-e PRIVATE_KEY_PATH=/app/tls/client.key \
-e CERT_CHAIN_PATH=/app/tls/client.pem \
-e SERVER_NAME=your_server_name \
zilliz/attu:dev
```

#### 自定义服务器端口示例

_以下命令使用主机网络模式运行容器，并指定自定义服务器监听端口_

```bash
docker run --network host \
-v /本地TLS文件路径:/app/tls \
-e ATTU_LOG_LEVEL=info  \
-e SERVER_NAME=your_server_name \
-e SERVER_PORT=8080 \
zilliz/attu:dev
```

### 在Kubernetes中运行Attu

开始前，请确保K8s集群中已安装并运行Milvus（参考[Milvus集群安装文档](https://milvus.io/docs/install_cluster-milvusoperator.md)）。Attu仅支持Milvus 2.x版本。

部署步骤：

```bash
kubectl apply -f https://raw.githubusercontent.com/zilliztech/attu/main/attu-k8s-deploy.yaml
```

确保Attu Pod可访问Milvus服务。示例配置中默认连接`my-release-milvus:19530`，需根据实际Milvus服务名称修改。更灵活的方式是使用ConfigMap，详见[示例](https://raw.githubusercontent.com/zilliztech/attu/main/examples/attu-k8s-deploy-ConfigMap.yaml)。

### 安装桌面应用

如偏好桌面版，可下载[Attu桌面应用](https://github.com/zilliztech/attu/releases/)。

### 本地构建Docker镜像

- 开发版：`yarn run build:dev`
- 发布版：`yarn run build:release`

## 常见问题

- 无法登录系统
  > 确保Milvus服务器IP可从Attu容器访问。[#161](https://github.com/zilliztech/attu/issues/161)
- 待补充

## 更多截图

| 数据视图                                                                         | 集合树视图                                                                    |
|----------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| <img src="https://github.com/zilliztech/attu/raw/main/.github/images/data_preview.png" alt="数据预览" width="800" /> | <img src="https://github.com/zilliztech/attu/raw/main/.github/images/collections.png" alt="集合树" width="800" /> |

| 创建集合                                                                       | 向量搜索                                                                     |
|------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| <img src="https://github.com/zilliztech/attu/raw/main/.github/images/create_collection.png" alt="创建集合" width="800" /> | <img src="https://github.com/zilliztech/attu/raw/main/.github/images/vector_search.png" alt="向量搜索" width="800" /> |

## ✨ 代码贡献

感谢您对Attu贡献的兴趣！以下是本地构建Attu以贡献代码、测试新功能或尝试开放PR的步骤：

### 构建服务器

1. Fork并克隆Attu仓库。
2. 终端中运行`cd server`进入服务器目录。
3. 运行`yarn install`安装依赖。
4. 开发模式启动服务器：`yarn start`。
5. 创建PR分支：`git checkout -b my-branch`。

### 构建客户端

1. Fork并克隆Attu仓库。
2. 终端中运行`cd client`进入客户端目录。
3. 运行`yarn install`安装依赖。
4. 开发模式启动客户端：`yarn start`。
5. 创建PR分支：`git checkout -b my-branch`。

### 提交Pull Request

1. 完成修改并确保测试通过。
2. 提交更改并推送到您的fork仓库。
3. 创建指向Attu主分支的Pull Request。

我们感谢您对Attu的任何贡献，无论大小。感谢支持本项目！

#### ❓ 有问题或遇到困难？

如遇到bug或需请求新功能，请创建[GitHub issue](https://github.com/zilliztech/attu/issues/new/choose)。提交前请先检查是否已有相同issue。

### 有用的链接

以下是Milvus相关资源，帮助您快速上手：

- [Milvus文档](https://milvus.io/docs)：包含安装指南、教程和API文档的详细信息。
- [Milvus Python SDK](https://github.com/milvus-io/pymilvus)：Python开发工具包，提供创建和查询向量的简洁接口。
- [Milvus Java SDK](https://github.com/milvus-io/milvus-sdk-java)：Java开发工具包，功能与Python SDK类似。
- [Milvus Go SDK](https://github.com/milvus-io/milvus-sdk-go)：Go语言API，适用于Go开发者。
- [Milvus Node SDK](https://github.com/milvus-io/milvus-sdk-node)：Node.js API，适用于Node.js开发者。
- [Feder](https://github.com/zilliztech/feder)：JavaScript工具，用于帮助理解嵌入向量。

## 社区

💬 加入Milvus Discord社区，分享知识、提问和参与讨论。不仅是代码交流，更是与志同道合者连接的平台！点击下方链接加入：

<a href="https://discord.com/invite/8uyFbECzPX"><img style="display:block; margin: '8px';" src="https://assets-global.website-files.com/6257adef93867e50d84d30e2/636e0b5061df29d55a92d945_full_logo_blurple_RGB.svg" alt="Discord社区"/></a>

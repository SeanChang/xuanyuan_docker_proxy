---
image: library/express-gateway
description: "已弃用的Express Gateway官方Docker镜像，是用于API和微服务的API网关。"
source: https://xuanyuan.cloud/zh/r/library/express-gateway
canonical: https://xuanyuan.cloud/zh/r/library/express-gateway
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/express-gateway" title="library/express-gateway Docker 镜像中文简介、标签列表与拉取命令">library/express-gateway 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 弃用通知

该项目已不再维护。详情或有意接管项目者请阅读[此处](https://github.com/ExpressGateway/express-gateway/issues/1011#issuecomment-748354599)。


# Express Gateway Docker镜像文档

## 镜像概述

Express Gateway Docker镜像是Express Gateway的官方容器化分发版本（已弃用）。Express Gateway是一款API网关，专为API和微服务架构设计，可作为微服务架构的核心组件，无论使用何种语言或平台，均能保护微服务并通过API将其暴露。该网关基于Node.js、ExpressJS及Express中间件构建，旨在提供无缝的微服务开发、编排和管理平台，无需引入额外基础设施。

官方文档：[https://express-gateway.io/docs](https://express-gateway.io/docs)


## 核心功能与特性

- **基于Express及中间件构建**：完全采用Express生态系统，可复用丰富的Express中间件
- **动态集中配置**：支持动态调整配置，无需重启服务
- **API消费者与凭证管理**：提供用户、应用及凭证的管理功能
- **插件及插件框架**：支持自定义插件扩展功能，提供灵活的插件开发框架
- **分布式数据存储**：支持分布式环境下的数据存储需求
- **命令行界面（CLI）**：提供便捷的命令行工具进行管理操作
- **管理API**：通过API接口实现网关的程序化管理


## 使用场景与适用范围

适用于各类微服务架构环境，主要用于：
- 统一API入口，简化客户端与微服务间的交互
- 实现API访问控制、认证与授权
- 对API请求进行限流、监控与日志记录
- 微服务的路由与负载均衡
- 协议转换（如HTTP到gRPC）及请求/响应转换


## 使用方法与配置说明

### 依赖服务（可选）

若使用身份相关功能（如`users`、`applications`、`credentials`），需依赖Redis存储数据。若无需此类功能，可跳过此步骤。

#### 启动Redis容器

```shell
docker run -d --name express-gateway-data-store \
           -p 6379:6379 \
           docker.xuanyuan.run/redis:alpine
```


### 启动Express Gateway实例

#### 基本启动命令（无身份功能）

```shell
docker run -d --name docker.xuanyuan.run/express-gateway \
    -v /my/own/datadir:/var/lib/eg \
    -p 8080:8080 \
    -p 9876:9876 \
    docker.xuanyuan.run/express-gateway
```

#### 启动命令（需身份功能，链接Redis）

```shell
docker run -d --name docker.xuanyuan.run/express-gateway \
    --link express-gateway-data-store:eg-database \
    -v /my/own/datadir:/var/lib/eg \
    -p 8080:8080 \
    -p 9876:9876 \
    docker.xuanyuan.run/express-gateway
```

#### 参数说明
- `-v /my/own/datadir:/var/lib/eg`：挂载本地目录到容器内，用于持久化配置文件和数据，**必须挂载**，否则网关无法正常启动
- `-p 8080:8080`：API网关端口（客户端请求入口）
- `-p 9876:9876`：管理端口（CLI及管理API端口）
- `--link express-gateway-data-store:eg-database`：链接Redis容器（仅在使用身份功能时需要）
- 若需启用HTTPS，需额外暴露HTTPS端口（如`-p 443:443`）


### 安装自定义插件

可基于官方镜像构建包含自定义插件的新镜像，步骤如下：

1. 创建`Dockerfile`：
   ```dockerfile
   FROM docker.xuanyuan.run/express-gateway
   RUN yarn global add express-gateway-plugin-name  # 替换为实际插件名称
   ```

2. 构建新镜像：
   ```shell
   docker build -t my-express-gateway .
   ```

3. 使用自定义镜像启动：
   ```shell
   docker run -d --name docker.xuanyuan.run/my-express-gateway \
       -v /my/own/datadir:/var/lib/eg \
       -p 8080:8080 \
       -p 9876:9876 \
       docker.xuanyuan.run/my-express-gateway
   ```


### 配置文件说明

容器内配置文件路径为`/var/lib/eg`，需通过卷挂载本地目录进行持久化。配置详情请参考官方文档：[express-gateway.io/docs](http://express-gateway.io/docs)


## 注意事项

- **已弃用**：该项目及镜像不再维护，不建议用于生产环境
- **端口映射**：根据实际需求暴露端口（如HTTPS端口）
- **配置依赖**：必须挂载包含有效配置文件的目录，否则容器无法正常启动
- **架构支持**：当前无官方支持的硬件架构
- **标签支持**：无官方支持的镜像标签


## 许可证信息

- 软件许可证：[查看许可证详情](https://github.com/ExpressGateway/express-gateway/blob/master/LICENSE)
- 镜像中包含的其他软件（如基础系统组件、依赖库等）可能具有独立许可证，可参考[repo-info仓库的`express-gateway`目录](https://github.com/docker-library/repo-info/tree/master/repos/express-gateway)获取自动检测的许可证信息

使用本镜像即表示您同意遵守所有包含软件的相关许可证条款。

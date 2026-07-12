---
image: oryd/hydra-idp-react
description: "Hydra的示例性身份提供者及用户登录与同意UI，仅作示例使用，请勿用于生产环境。"
source: https://xuanyuan.cloud/zh/r/oryd/hydra-idp-react
canonical: https://xuanyuan.cloud/zh/r/oryd/hydra-idp-react
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oryd/hydra-idp-react" title="oryd/hydra-idp-react Docker 镜像中文简介、标签列表与拉取命令">oryd/hydra-idp-react 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# hydra-idp-react

## 镜像概述

hydra-idp-react是一个用于Hydra的示例性身份提供者（Identity Provider）及用户登录与同意界面。文档仍在完善中。请注意，此应用本身不执行实际功能，登录仅在被Hydra请求时才有效。更多信息请参考[教程](https://ory-am.gitbooks.io/hydra/content/tutorial.html)。

## 核心功能与特性

- 提供用户登录界面，处理登录请求
- 实现同意管理界面，允许用户授权访问请求
- 与Hydra REST API集成，处理身份验证流程
- 包含用户服务示例，可扩展对接LDAP、数据库等用户存储

## 使用场景

适用于开发和测试环境中，演示Hydra的身份验证和授权流程，帮助理解Hydra的工作原理。**请勿用于生产环境**。

## 使用方法

### 通过Docker运行

```bash
$ docker run -d -p 3000:3000 --name my-hydra-consent-ui oryd/hydra-idp-react
```

访问应用：
- Linux：
  ```bash
  $ open http://localhost:3000/
  ```
- OSX（Docker Shell）：
  ```bash
  $ open http://$(docker-machine ip default):3000/
  ```
- Windows（Docker Shell）：
  ```bash
  $ start "" http://$(docker-machine ip default):3000/
  ```

### 通过NodeJS运行源码

1. 安装依赖：
   ```bash
   $ npm i
   ```

2. 启动开发服务器：
   ```bash
   $ npm run dev
   ```

3. 访问应用：
   - Linux/OSX：
     ```bash
     $ open http://localhost:3000
     ```
   - Windows：
     ```bash
     $ start "" http://localhost:3000/
     ```

## 关键文件说明

由于项目使用webpack和React，文件结构较复杂。核心登录逻辑相关文件：

- `src/common/components/SignIn/index.js`：处理登录和同意逻辑的根组件，设置事件处理、显示UI并在同意后重定向到Hydra
- `src/common/components/SignIn`：其他组件为简单的JSX模板
- `src/common/service/hydra.js`：Hydra REST API交互辅助工具
- `src/common/service/userService.js`：用户服务示例，可扩展对接LDAP、Postgres、MySQL、MongoDB等
- `src/server/handler/auth.js`：提供两个API端点
  - `/api/login`：处理登录请求，接收用户名密码，验证和解码同意挑战
  - `/api/consent`：创建签名的同意令牌

## 配置说明

要与Hydra连接，需通过以下方式之一提供配置：

1. 在用户主目录中放置包含有效凭据的`.hydra.yml`文件
2. 设置环境变量：
   - `CLIENT_ID`：OAuth2客户端ID
   - `CLIENT_SECRET`：OAuth2客户端密钥
   - `HYDRA_URL`：Hydra服务URL

**客户端要求**：
- 允许执行`authorize_code`和`client_credentials`流程
- 能够接收`code`和`token`响应类型
- 已授予`hydra.keys.get`和`core`作用域

## 警告

开发环境中，Hydra通常使用自签名TLS证书。因此`npm run dev`会设置`NODE_TLS_REJECT_UNAUTHORIZED=0`，该选项**会跳过所有TLS验证，仅在本地机器测试时使用，绝不可用于生产环境**。

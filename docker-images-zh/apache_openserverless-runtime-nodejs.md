---
image: apache/openserverless-runtime-nodejs
description: "Apache OpenWhisk的Node.js运行时，来自Apache OpenServerless（孵化中）项目，用于在Serverless环境中运行Node.js应用。"
source: https://xuanyuan.cloud/zh/r/apache/openserverless-runtime-nodejs
canonical: https://xuanyuan.cloud/zh/r/apache/openserverless-runtime-nodejs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/openserverless-runtime-nodejs" title="apache/openserverless-runtime-nodejs Docker 镜像中文简介、标签列表与拉取命令">apache/openserverless-runtime-nodejs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache OpenWhisk Node.js Runtime 镜像文档


## 1. 镜像概述和主要用途

本镜像为 Apache OpenServerless（孵化中）项目提供的 Apache OpenWhisk Node.js 运行时环境，用于在 Apache OpenWhisk 无服务器平台上执行 Node.js 编写的无服务器函数（Action）。其核心用途是作为 OpenWhisk 平台的执行载体，为 Node.js 函数提供轻量级、隔离的运行环境，支持函数的触发、执行、资源管理及生命周期控制。


## 2. 核心功能和特性

### 2.1 核心功能
- 提供 Node.js 函数的隔离执行环境，支持函数的初始化、调用与销毁生命周期管理。
- 与 Apache OpenWhisk 平台深度集成，支持事件触发（如 HTTP 请求、消息队列、定时任务等）驱动函数执行。
- 内置函数输入/输出处理机制，支持标准 JSON 格式数据交换。

### 2.2 关键特性
- **轻量级设计**：最小化运行时依赖，降低资源占用，提升函数启动速度。
- **多版本支持**：兼容主流 Node.js 版本（具体版本需参考镜像标签，如 `nodejs18`、`nodejs20` 等）。
- **资源隔离**：基于容器技术实现函数间的 CPU、内存资源隔离，避免相互干扰。
- **日志集成**：支持将函数执行日志输出至 OpenWhisk 平台日志系统，便于问题排查。
- **标准化接口**：遵循 OpenWhisk 运行时规范，确保函数与平台的兼容性。


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **事件驱动型应用**：如文件上传后自动处理（格式转换、内容分析）、消息队列消息消费（数据清洗、通知推送）等。
- **API 后端服务**：作为 HTTP API 的后端逻辑处理单元，响应外部请求。
- **定时任务**：通过 OpenWhisk 定时触发器执行周期性任务（如数据备份、报表生成）。
- **微服务组件**：作为分布式系统中的轻量级功能模块，处理特定业务逻辑。

### 3.2 适用范围
- **用户**：需要在 OpenWhisk 平台上开发、部署 Node.js 无服务器函数的开发者或企业。
- **环境**：支持开发、测试及生产环境，需配合 Apache OpenWhisk 平台使用。


## 4. 详细使用方法和配置说明

### 4.1 前提条件
- 已部署 Apache OpenWhisk 平台（或使用公共 OpenWhisk 服务）。
- 安装 OpenWhisk CLI（`wsk`）并配置平台访问凭证（通过 `wsk property set` 设置 API 主机和认证令牌）。


### 4.2 部署 Node.js 函数至 OpenWhisk

#### 4.2.1 编写 Node.js 函数代码
创建函数文件（如 `index.js`），遵循 OpenWhisk Node.js 函数规范（默认导出 `main` 函数，接收 `params` 参数并返回结果）：
```javascript
// index.js
function main(params) {
  const name = params.name || 'World';
  return { message: `Hello, ${name}!` };
}

exports.main = main;
```

#### 4.2.2 创建 OpenWhisk Action
通过 `wsk action create` 命令将函数部署为 OpenWhisk Action，指定使用本 Node.js 运行时镜像（若平台未默认配置）：
```bash
# 语法：wsk action create <action-name> <函数文件> --docker <镜像名称>
wsk action create hello-nodejs index.js --docker apache/openwhisk-nodejs-runtime:<tag>
```
> 说明：`<tag>` 需替换为具体 Node.js 版本标签（如 `nodejs18`），具体标签可参考镜像仓库说明。

#### 4.2.3 调用函数
通过 `wsk action invoke` 调用已部署的 Action：
```bash
# 同步调用并获取结果
wsk action invoke hello-nodejs --param name "OpenWhisk" --result

# 输出：{ "message": "Hello, OpenWhisk!" }
```


### 4.3 Docker 部署与集成（平台级配置）
若需在自定义 OpenWhisk 集群中指定使用本运行时镜像，可通过修改 OpenWhisk 控制器配置（如 `controller.env`）设置默认 Node.js 运行时：
```env
# controller.env 配置示例
RUNTIMES_NODEJS=<镜像名称>:<tag>  # 如 apache/openwhisk-nodejs-runtime:nodejs18
```
重启控制器后，新建 Node.js Action 将默认使用该镜像。


### 4.4 配置参数与环境变量

#### 4.4.1 函数配置参数（通过 `wsk action create` 或 `update` 命令指定）
- `--memory <MB>`：设置函数内存限制（如 `--memory 256`，默认 256MB）。
- `--timeout <ms>`：设置函数超时时间（如 `--timeout 30000`，默认 60000ms）。
- `--concurrency <num>`：设置函数最大并发实例数（需平台支持）。

#### 4.4.2 环境变量（函数运行时可访问）
- **系统内置变量**（由 OpenWhisk 注入）：
  - `__OW_ACTION_NAME`：当前 Action 名称（如 `/namespace/hello-nodejs`）。
  - `__OW_NAMESPACE`：当前命名空间。
  - `__OW_REQUEST_ID`：请求唯一 ID。
- **用户自定义变量**：通过 `--param` 或 `--param-file` 传递，在函数 `params` 参数中获取（如 4.2.1 示例中的 `name` 参数）。


## 5. 注意事项
- 镜像标签需与 Node.js 版本对应，避免因版本不兼容导致函数执行失败。
- 函数代码需遵循 OpenWhisk 运行时规范（默认导出 `main` 函数），否则会触发初始化错误。
- 生产环境中建议配合 OpenWhisk 平台的日志（如 ELK  stack）和监控（如 Prometheus）工具使用，提升可观测性。

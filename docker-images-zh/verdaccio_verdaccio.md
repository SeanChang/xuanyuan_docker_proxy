---
image: verdaccio/verdaccio
description: "Verdaccio官方Docker镜像是一款轻量级的私有Node.js代理仓库，旨在帮助开发者高效管理Node.js包，它既能作为私有仓库存储内部开发的npm包以保护敏感代码和知识产权，又能作为代理缓存公共npm仓库的包以显著提升依赖下载速度并节省带宽，同时基于Docker容器化设计，具备部署简单、配置灵活、资源占用低等特点，非常适合团队或企业在内部网络环境中搭建专属的npm包管理系统，满足私有包管理与公共包加速的双重需求。"
source: https://xuanyuan.cloud/zh/r/verdaccio/verdaccio
canonical: https://xuanyuan.cloud/zh/r/verdaccio/verdaccio
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/verdaccio/verdaccio" title="verdaccio/verdaccio Docker 镜像中文简介、标签列表与拉取命令">verdaccio/verdaccio 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Verdaccio 4：轻量本地私有 npm 仓库


## 简介  
[Verdaccio]  是一款简单的**零配置本地私有 npm 仓库**，无需完整数据库即可快速启动。它内置轻量数据库，支持代理其他仓库（如 npmjs.org）并缓存下载的模块。若需扩展存储能力，可通过社区插件对接 Amazon S3、Google Cloud Storage 等服务，或自定义插件。


## 安装  
通过 npm 全局安装：  
```bash
npm install --global verdaccio
```


## 主要功能  

### 1. 使用私有包  
在企业内部使用 npm 包管理系统，无需将代码公开，私有包的使用体验与公共包一致。

### 2. 缓存 npmjs.org 仓库  
多服务器环境下，通过缓存 npmjs.org 内容减少网络延迟（每个包/版本仅需连接一次 npmjs.org），并提供有限故障转移能力（如 npmjs.org 故障时可使用缓存内容），避免因公共仓库问题（如包突然下架、404 错误）影响开发。

### 3. 链接多个仓库  
企业内若有多个 registry，可通过 Verdaccio 的「上行链路」功能将多个源串联，实现单个端点拉取多仓库包。

### 4. 覆盖公共包  
如需使用修改后的第三方包（如修复 bug 但原作者未合并 PR），可在本地以相同名称发布自定义版本。

### 5. E2E 测试支持  
Verdaccio 启动速度快（几秒内），适合作为 CI 环境的轻量 registry。众多开源项目（如 create-react-app、pnpm、storybook）均用其进行端到端测试。


## 快速开始  

### 1. 启动服务  
终端运行以下命令启动 Verdaccio：  
```bash
verdaccio
```

### 2. 配置 npm  registry（可选）  
设置全局 registry：  
```bash
npm set registry []  
或单次使用：  
```bash
NPM_CONFIG_REGISTRY=[] npm i
```

### 3. 访问管理界面  
浏览器打开 [[]] ，可查看本地包列表并搜索。  

> ⚠️ 注意：Verdaccio 暂不支持 PM2 集群模式，使用集群模式可能导致异常行为。


## 发布包  

### 步骤 1：创建用户并登录  
```bash
npm adduser --registry []  
若使用 HTTPS，需配置 CA（设为 `null` 表示从系统获取 CA 列表）：  
```bash
npm set ca null
```

### 步骤 2：发布包  
```bash
npm publish --registry []  
系统会提示输入用户凭证，信息将保存在 Verdaccio 服务器中。


## Docker 部署  

### 拉取镜像  
```bash
docker pull docker.xuanyuan.run/verdaccio/verdaccio  # 最新版
# 或指定版本
docker pull docker.xuanyuan.run/verdaccio/verdaccio:4
```

### 运行容器  
```bash
docker run -it --rm --name verdaccio -p 4873:4873 docker.xuanyuan.run/verdaccio/verdaccio
```  
更多 Docker 配置示例见 [官方仓库] 。


## 功能兼容性  

Verdaccio 支持 npm 客户端的大部分标准功能，以下为核心支持情况：  

### 基本功能  
- 安装包（`npm install`、`npm upgrade` 等）：✅ 支持  
- 发布包（`npm publish`）：✅ 支持  

### 高级包控制  
- 撤销发布（`npm unpublish`）：✅ 支持  
- 打标签（`npm tag`）：✅ 支持  
- 弃用包（`npm deprecate`）：✅ 支持  

### 用户管理  
- 注册用户（`npm adduser`）：✅ 支持  
- 修改密码（`npm profile set password`）：✅ 支持  
- 转移包所有权（`npm owner add`）：❌ 暂不支持（欢迎 PR）  
- Token 管理（`npm token`）：✅ 支持  

### 其他功能  
- 搜索（`npm search`）：✅ 支持（命令行/浏览器）  
-  Ping（`npm ping`）：✅ 支持  
- 标星（`npm star`/`unstar`/`stars`）：✅ 支持  
- 安全审计（`npm/yarn audit`）：✅ 支持  


## 社区与支持  

- **核心团队**：由 Juan Picado、Ayush Sharma 等志愿者维护，可通过 []  或  交流。  
- **使用案例**：create-react-app、Gatsby、Babel.js、Vue CLI、Angular CLI 等知名项目均在使用。  
- **贡献与捐赠**：项目依赖社区贡献，欢迎通过 [OpenCollective]  捐赠支持。  


## 安全反馈  
若发现安全漏洞，请参考 [安全政策]  提交报告。


## 许可证  
Verdaccio 基于 [MIT 许可证]  开源。文档及 logo（除 `/thanks` 目录）采用 [CC BY 4.0]  协议。

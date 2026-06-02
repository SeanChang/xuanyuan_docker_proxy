<!-- xuanyuan-docker-images-zh
image: chainguard/node
source: https://xuanyuan.cloud/zh/r/chainguard/node
canonical: https://xuanyuan.cloud/zh/r/chainguard/node
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [chainguard/node — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/chainguard/node "chainguard/node Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/chainguard/node

# Chainguard Node 镜像文档

## 镜像概述和主要用途

Chainguard Node 镜像是由 Chainguard 提供的 Node.js 容器镜像，旨在帮助用户构建、交付和运行安全的软件。该镜像以低至零 CVE（常见漏洞和暴露）漏洞为核心特性，作为 Node.js 应用的基础镜像，确保从开发到部署的全流程安全性。

## 核心功能和特性

- **低至零 CVE 漏洞**：经过严格安全优化，包含极低甚至零已知 CVE 漏洞，显著降低应用受攻击风险。
- **高安全性**：遵循 Chainguard 安全最佳实践构建，基础组件最小化且经过安全加固。
- **多源分发**：同时发布于 Docker Hub 和 Chainguard Registry（cgr.dev），提供灵活的拉取渠道。
- **兼容性**：兼容标准 Node.js 应用开发流程，可无缝集成现有构建和部署管道。

## 使用场景和适用范围

- **生产环境 Node.js 应用**：适用于生产环境中运行的 Node.js 服务，保障基础镜像安全性。
- **安全敏感型应用开发**：金融、医疗、政务等对安全性要求较高的领域，作为基础镜像降低安全风险。
- **合规性要求场景**：需满足严格安全合规标准的项目，利用低 CVE 特性简化合规验证。

## 使用方法和配置说明

### 下载镜像

该镜像可从 Docker Hub 和 Chainguard Registry 获取，支持 `latest` 及其他特定版本标签。

#### 从 Docker Hub 拉取

```bash
docker pull chainguard/node:latest
```

#### 从 Chainguard Registry 拉取

若遇到 Docker Hub 速率限制，可使用 Chainguard Registry：

```bash
docker pull cgr.dev/chainguard/node:latest
```

### 运行容器示例

以下示例展示如何使用该镜像运行 Node.js 应用：

1. 准备应用代码（如 `app.js`）：

```javascript
console.log("使用 Chainguard Node 镜像运行安全应用！");
```

2. 运行容器并挂载应用代码：

```bash
docker run --rm -v $(pwd):/app chainguard/node:latest node /app/app.js
```

### 配置参数与环境变量

遵循标准 Node.js 镜像的环境变量规范，常用配置包括：

- `NODE_ENV`：指定运行环境（如 `production`、`development`），默认未设置。
- `NODE_PATH`：自定义 Node.js 模块搜索路径。

更多配置细节可参考 [Chainguard 镜像目录概述](https://images.chainguard.dev/directory/image/node/overview)。

## 补充信息

- **版本与 FIPS 支持**：查看 [版本列表](https://images.chainguard.dev/directory/image/node/versions) 获取包含 FIPS 支持的其他版本。
- **SBOMs 与安全信息**：访问 [SBOMs](https://images.chainguard.dev/directory/image/node/sbom)、[安全公告](https://images.chainguard.dev/directory/image/node/advisories) 和 [漏洞信息](https://images.chainguard.dev/directory/image/node/vulnerabilities) 页面获取详细组件及安全数据。
- **支持与帮助**：遇到问题可参考 [Chainguard 镜像 FAQ](https://edu.chainguard.dev/chainguard/chainguard-images/faq/) 或通过 [联系页面](https://www.chainguard.dev/contact) 获取支持。

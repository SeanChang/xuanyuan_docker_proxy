<!-- xuanyuan-docker-images-zh
image: envoyproxy/envoy
source: https://xuanyuan.cloud/zh/r/envoyproxy/envoy
canonical: https://xuanyuan.cloud/zh/r/envoyproxy/envoy
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [envoyproxy/envoy — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/envoyproxy/envoy "envoyproxy/envoy Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/envoyproxy/envoy

# ![Envoy proxy server](https://github.com/envoyproxy/envoy/raw/main/distribution/dockerhub/envoy-icon.png) Envoy 代理服务器

## 快速参考

- **维护者**:

    [Envoy社区](https://github.com/envoyproxy/envoy)

- **获取帮助**:

    [官方文档](https://www.envoyproxy.io/docs)，[Envoy社区Slack](https://envoyproxy.slack.com/)

## 支持的标签及对应的 Dockerfile 链接

- [v1.33-latest](https://github.com/envoyproxy/envoy/blob/release/v1.33/ci/Dockerfile-envoy)

- [v1.32-latest](https://github.com/envoyproxy/envoy/blob/release/v1.32/ci/Dockerfile-envoy)

- [v1.31-latest](https://github.com/envoyproxy/envoy/blob/release/v1.31/ci/Dockerfile-envoy)

- [v1.30-latest](https://github.com/envoyproxy/envoy/blob/release/v1.30/ci/Dockerfile-envoy)

- [dev](https://github.com/envoyproxy/envoy/blob/release/main/ci/Dockerfile-envoy)

## 快速参考（续）

- 问题提交地址:
  https://github.com/envoyproxy/envoy/issues

- 支持的架构:

  `amd64`

  `arm64`

## 镜像变体

对于稳定的 Envoy 版本，会为该版本及其 minor 版本的最新版创建镜像。

例如，如果 `1.73.x` 系列的最新版本是 `1.73.7`，则会创建以下镜像：
- `envoyproxy/envoy:v1.73.7`
- `envoyproxy/envoy:v1.73-latest`

类似策略适用于各版本变体的镜像创建。

### `envoyproxy/envoy:<version>`

这些镜像仅包含基于 Ubuntu 基础镜像构建的 Envoy 核心二进制文件。

### `envoyproxy/envoy:contrib-<version>`

这些镜像包含启用了所有 contrib 扩展的 Envoy 二进制文件。

### `envoyproxy/envoy:distroless-<version>`

这些镜像仅包含基于 [distroless](https://github.com/GoogleContainerTools/distroless)（`nonroot`/`nossl`）基础镜像构建的 Envoy 核心二进制文件。

这些镜像是在容器中部署 Envoy 的最高效且安全的方式。

### `envoyproxy/envoy:tools-<version>`

这些镜像包含与代理二进制文件分离但对支持系统（如 CI、配置生成管道等）有用的工具。

### `envoyproxy/envoy:debug-<version>`/`envoyproxy/envoy:<variant>-debug-<version>`

这些镜像为每个变体构建，包含带有调试符号的 Envoy 二进制文件。

### `envoyproxy/envoy:dev`/`envoyproxy/envoy:dev-<SHA>`/`envoyproxy/envoy:<variant>-dev`/`envoyproxy/envoy:<variant>-dev-<SHA>`

开发镜像由 Envoy 的持续集成从 `main` 分支创建，并带有 `dev` 后缀标签。

为每个版本化变体创建镜像。

对于每个变体，镜像标记为仅带 `dev` 后缀和带 `dev-<SHA>` 后缀，其中 `SHA` 是创建镜像的 Envoy `main` 分支的提交哈希。

例如，在提交 `7c1c4a0e` 构建后，将创建 `envoyproxy/envoy:dev-7c1c4a0e10a7a0771ac06ce8cf8fa2c6ce86281b` 镜像，且 `envoyproxy/envoy:dev` 镜像会标记为此镜像，直到下一次构建。

### `envoyproxy/envoy:google-vrp-<version>`

这些镜像包含作为 [Google 漏洞奖励计划 (VRP)](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/security/google_vrp.html) 一部分用于测试和研究漏洞的工具。

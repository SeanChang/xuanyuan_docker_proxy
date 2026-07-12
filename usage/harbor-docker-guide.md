# Harbor Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/harbor

适用于已自建 Harbor 仓库的用户，通过将轩辕镜像专业版专属域名配置为 Harbor 的远程仓库端点，一次性打通 docker.io / ghcr.io / gcr.io / quay.io / nvcr.io 等常见镜像源的加速访问。

## 目录

- [1. 前期准备：确认轩辕镜像专属域名](#1-前期准备确认轩辕镜像专属域名)
- [2. 在 Harbor 中配置 docker.io 镜像代理](#2-在-harbor-中配置-dockerio-镜像代理)
- [3. 在 Harbor 中配置其他镜像源代理（以 GHCR 为例）](#3-在-harbor-中配置其他镜像源代理以-ghcr-为例)
- [4. 通过 Harbor 代理拉取镜像（命令示例）](#4-通过-harbor-代理拉取镜像命令示例)
- [5. 连通性验证与常见问题排查](#5-连通性验证与常见问题排查)

## 1. 前期准备：确认轩辕镜像专属域名

在将 Harbor 配置为代理仓库之前，请先在轩辕镜像控制台确认您的各类专属域名（专业版支持免登录拉取），后续将在 Harbor 中直接作为远程仓库的端点 URL 使用：

**常见专属域名类型：**

- **主专属域名**：例如 `***.xuanyuan.run`，用于加速 `docker.io` 镜像
- **GHCR 专属域名**：例如 `***-ghcr.xuanyuan.run`，用于加速 `ghcr.io` 镜像
- **GCR 专属域名**：例如 `***-gcr.xuanyuan.run`，用于加速 `gcr.io` 镜像
- **其他仓库专属域名**：如 `***-quay.xuanyuan.run`（对应 `quay.io`）、`***-nvcr.xuanyuan.run`（对应 `nvcr.io`）等

> **提示**：您可以在[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fharbor)轩辕镜像官网后，进入左侧菜单**「专属域名」**页面查看上述域名。专业版专属域名支持免登录拉取，无需在 Harbor 中配置任何账号密码，非常适合作为 Harbor 的远程仓库代理端点。

## 2. 在 Harbor 中配置 docker.io 镜像代理

这里以 docker.io 为例，演示如何在 Harbor 中创建一个 Proxy Repository，将主专属域名配置为远程端点。

**操作路径：**

1. 登录 Harbor 管理后台（平台域名如 harbor.example.com）。
2. 左侧菜单进入 **「仓库管理」→「远程仓库」**。
3. 点击右上角**「新建远程仓库」**，按照下表填写关键字段。

| 字段 | 推荐填写 |
|------|----------|
| 远程仓库类型 | **Proxy Repository** |
| 仓库名称 | 建议填写：`docker.io`（仅作为 Harbor 内部区分使用） |
| 提供商 | 选择 **Docker Hub** |
| 端点 URL（Endpoint URL） | 填写：`https://***.xuanyuan.run`（请将 `***.xuanyuan.run` 替换为您的主专属域名） |
| 认证 | **无需填写**账号密码，保持为空（专属域名免登录） |
| 缓存与同步 | 可按需勾选 **「缓存镜像」**、**「自动同步」** 等，以减少重复拉取延迟 |

**关键字段填写（精简版）：**

- **类型**：Proxy Repository
- **仓库名称**：docker.io
- **提供商**：Docker Hub
- **端点 URL**：`https://***.xuanyuan.run`
- **认证**：不勾选、不填写任何账号密码

> **提示**：**为什么不需要账号密码？**专业版专属域名本身已经和您的帐户绑定，并支持免登录鉴权，所以 Harbor 只需把请求转发到专属域名即可，无需再配置额外 credential，极大简化了 Harbor 的接入成本。

## 3. 在 Harbor 中配置其他镜像源代理（以 GHCR 为例）

对于 ghcr.io、gcr.io、quay.io、nvcr.io 等其他镜像源，思路与 docker.io 完全一致：在 Harbor 中新建一个对应的 Proxy Repository，并将对应的专属域名写入端点 URL。

**以 GHCR 为例的推荐配置：**

- **远程仓库类型**：Proxy Repository
- **仓库名称**：可填 `ghcr.io`
- **提供商**：GitHub Container Registry
- **端点 URL**：`https://***-ghcr.xuanyuan.run`（替换为您的 GHCR 专属域名）
- **认证**：无需填写账号密码
- **缓存策略**：可按项目需要勾选镜像缓存 / 自动同步

**常见镜像源与专属域名对应关系：**

| 原始镜像源 | Harbor 端点 URL 示例（专属域名） |
|-----------|--------------------------------|
| docker.io | https://***.xuanyuan.run |
| ghcr.io | https://***-ghcr.xuanyuan.run |
| gcr.io | https://***-gcr.xuanyuan.run |
| quay.io | https://***-quay.xuanyuan.run |
| nvcr.io | https://***-nvcr.xuanyuan.run |

**常见镜像源端点写法（速查）：**

- docker.io → `https://***.xuanyuan.run`
- ghcr.io → `https://***-ghcr.xuanyuan.run`
- gcr.io → `https://***-gcr.xuanyuan.run`
- quay.io → `https://***-quay.xuanyuan.run`
- nvcr.io → `https://***-nvcr.xuanyuan.run`

更多仓库（K8s、MCR、Elastic、Oracle、GitLab 等）的专属域名前缀规则，请参考 [专属域名拉取教程](https://xuanyuan.cloud/usage/nologin) 与 [多仓库镜像教程总览](./mirror-tutorial-docker-guide.md)。

> **提示**：**配置思路统一：**对于每一个外部镜像源（docker.io / ghcr.io / gcr.io / quay.io / nvcr.io 等），都在 Harbor 中建立一个对应名称的 Proxy Repository，并将「端点 URL」指向对应的轩辕镜像专属域名即可。Harbor 之后会统一从您的 Harbor 域名对外提供镜像拉取服务。

## 4. 通过 Harbor 代理拉取镜像（命令示例）

完成 Harbor 远程仓库配置后，后续只需要面向 Harbor 自身拉取镜像即可。Harbor 会在后台通过轩辕镜像专属域名去访问外部源。

**通用命令模板：**

```bash
docker pull harbor.example.com/[远程仓库名称]/[镜像路径]:[标签]
```

其中 `harbor.example.com` 为您的 Harbor 域名，`[远程仓库名称]` 为上文配置的 Proxy Repository 名称，如 `docker.io` 或 `ghcr.io`。

**示例 1：通过 Harbor 拉取 docker.io 的 nginx**

```bash
docker pull harbor.example.com/docker.io/library/nginx:latest
```

对应的原始地址为 `docker.io/library/nginx:latest`，Harbor 会自动通过主专属域名去拉取并缓存。

**示例 2：通过 Harbor 拉取 ghcr.io 的镜像**

```bash
docker pull harbor.example.com/ghcr.io/owner/image:tag
```

对应的原始地址为 `ghcr.io/owner/image:tag`，Harbor 会通过您配置的 GHCR 专属域名代理访问。

> **提示**：建议您在项目中统一使用 Harbor 域名（如 `harbor.example.com/docker.io/...`），而不要混用多个外部 Registry 域名，这样更便于权限控制、审计和缓存命中。

## 5. 连通性验证与常见问题排查

当您发现 Harbor 拉取失败或下载速度异常时，可以按照以下步骤快速自查问题来源：是 Harbor 配置问题、网络问题，还是专属域名自身不可达。

### 1）在 Harbor 服务器上测试专属域名连通性

登录 Harbor 所在服务器，执行以下命令（以主专属域名为例）：

```bash
curl -v https://***.xuanyuan.run/v2/
```

若返回 **HTTP 200** 或 **HTTP 401** 状态码均属于正常：401 表示服务可达、但未携带完整镜像路径，是专属域名免登录模式下的常见返回。

### 2）查看 Harbor 日志

若 curl 正常但通过 Harbor 拉取失败，请在 Harbor 服务器上检查核心服务日志，关注是否有连接外部端点失败或 401/402/5xx 等信息：

- Harbor 部署为 Docker Compose / Helm 时，可分别查看 jobservice、core、registry 等组件的日志
- 重点检查远程仓库配置名对应的错误堆栈，确认是否拼写错误、端点 URL 填错，或者专属域名解析失败

### 3）网络与防火墙排查

- 确认 Harbor 所在服务器可以正常访问 `*.xuanyuan.run` 域名（无公司防火墙、代理、DNS 污染等拦截）
- 如存在企业代理，建议先将 Harbor 节点配置为直连互联网，或在代理中允许直连专属域名

> **提示**：**拉取频繁失败的典型原因：**端点 URL 填写了错误的专属域名、Harbor 中误配置了认证信息、或 Harbor 所在机器无法访问外网。建议先用 curl 单独验证专属域名，再结合 Harbor 日志定位具体仓库与请求路径。

# Portainer Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/portainer

本教程适用于已经在服务器上安装好 Docker 和 Portainer 的用户，通过在 Portainer 中新增使用轩辕镜像专属域名的镜像仓库，实现在 Web 控制台中创建容器时自动走加速通道，无需在 Portainer 内重复配置账号密码。

## 目录

- [1. 前期准备：专属域名与 Portainer 环境](#1-前期准备专属域名与-portainer-环境)
- [2. 在 Portainer 中新增加速镜像仓库（docker.io）](#2-在-portainer-中新增加速镜像仓库dockerio)
- [3. 在 Portainer 中选择加速镜像仓库并创建容器](#3-在-portainer-中选择加速镜像仓库并创建容器)
- [4. 关键界面示例（截图说明）](#4-关键界面示例截图说明)
- [5. 连通性验证与常见问题排查](#5-连通性验证与常见问题排查)

## 1. 前期准备：专属域名与 Portainer 环境

在开始 Portainer 配置之前，请先确认以下条件已经满足：

- 已在服务器上安装好 **Docker**，并确保可以正常拉取镜像。
- 已部署 **Portainer**（社区版或企业版均可），并能通过浏览器访问 Portainer Web 控制台（例如 `https://portainer.example.com` 或通过服务器 IP + 端口访问）。
- 已在轩辕镜像控制台中开通并记下您的**专属域名**，例如：
  - **主专属域名**：`***.xuanyuan.run`（对应 docker.io）
  - **GHCR 专属域名**：`***-ghcr.xuanyuan.run`（对应 ghcr.io，可选）
  - **GCR / Quay / NVCR / GitLab 等专属域名**：如 `***-gcr.xuanyuan.run`、`***-quay.xuanyuan.run`、`***-gitlab.xuanyuan.run` 等（可选）

> **提示**：轩辕镜像专业版专属域名支持免登录拉取，**在 Portainer 中配置镜像仓库时无需再填写用户名 / 密码**，只要把专属域名当作镜像仓库地址使用即可。专属域名可在[控制台「专属域名」](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fportainer)页面查看。

## 2. 在 Portainer 中新增加速镜像仓库（docker.io）

这里以 docker.io 为例，在 Portainer 的 **Registries**（镜像仓库）功能中新增一个指向轩辕镜像专属域名的仓库，后续创建容器时选择该仓库即可走加速。

1. 使用管理员账号登录 Portainer Web 控制台。
2. 在左侧菜单中进入 **「Registries / 镜像仓库」**（部分版本在 **Settings → Registries** 中）。
3. 点击页面右上角的 **「Add registry / 添加仓库」**。
4. 在弹出的表单中，选择或填写以下信息（不同 Portainer 版本字段略有差异，可按含义对应）：

| 字段 | 推荐填写 |
|------|----------|
| Name / 仓库名称 | 建议填写：`docker.io (xuanyuan)` 或 `dockerhub-accelerated`，便于区分。 |
| Registry URL / 仓库地址 | 填写：`https://***.xuanyuan.run`（将 `***.xuanyuan.run` 替换为您的主专属域名）。 |
| Registry type / 类型 | 选择 **Custom registry** 或 **DockerHub**（根据 Portainer 版本，二者均可，本质是自定义一个使用专属域名的镜像仓库）。 |
| Authentication / 认证 | 对于**专属域名方式**（如 `https://***.xuanyuan.run`）：保持关闭或不勾选 Authentication，**不要**在 Portainer 中填写用户名 / 密码。此时依赖专属域名的免登录特性，适合大多数专业版用户。对于**登录方式**（例如直接使用 `https://docker.xuanyuan.run`）：可以在 Authentication 中勾选认证，并填写轩辕镜像的**镜像账户 / 镜像密码**，效果等价于在命令行执行 `docker login docker.xuanyuan.run`。这种方式适合尚未开通专属域名、或需要访问需要登录的私有仓库场景，配置方法可结合「登录配置」教程使用。 |

> **提示**：**Portainer 与 Docker 的关系：**Portainer 只是一个 Web 管理面板，真正拉取镜像的是后端的 Docker 守护进程。在 Portainer 中新增使用专属域名的镜像仓库后，Portainer 会在生成拉取镜像的指令时自动拼接专属域名，无需在主机上额外修改 Docker 配置。

## 3. 在 Portainer 中选择加速镜像仓库并创建容器

完成仓库创建后，在 Portainer 中新建容器或 Stacks 时，只需选择刚才配置的加速仓库，然后填写原始的镜像名称即可。

1. 进入对应的 **Environment / 环境**，在左侧菜单中选择 **Containers** 或 **Stacks**。
2. 点击 **「Add container / 新建容器」**（或在 Stack 中填写 compose 文件）。
3. 在镜像输入区域旁边（部分版本在「Registry」下拉框中），选择刚才创建的 `docker.io (xuanyuan)` 仓库。
4. 在镜像名称中，填写**原始镜像路径**，例如：
   - 官方 nginx：`library/nginx:latest`
   - MySQL：`mysql:8`

   Portainer 会自动使用您选择的加速仓库作为前缀，即相当于拉取 `***.xuanyuan.run/library/nginx:latest` 等镜像。
5. 填写容器名称、端口映射、环境变量等其他信息，点击 **「Deploy the container / 部署」** 即可。

**在 Stacks 中使用：** 若通过 Stack 部署，可在 compose 文件的 `image` 字段中直接写专属域名完整路径（如 `***.xuanyuan.run/library/nginx:latest`），或在 Portainer 的 Stack 编辑器中选择对应 Registry 后填写原始镜像路径。

> **重要提示**：镜像名称中**不需要再次写上专属域名**，只需要填写原始仓库的路径（如 `library/nginx:latest`）。专属域名前缀由 Portainer 根据您选择的 Registry 自动补齐。

### 可选：为 GHCR 等其他仓库新增 Registry

若需在 Portainer 中拉取 `ghcr.io`、`gcr.io` 等镜像，请按第 2 节步骤再新增一个 Registry，将 **Registry URL** 分别填写为 `https://***-ghcr.xuanyuan.run`、`https://***-gcr.xuanyuan.run` 等对应专属域名，同样保持 Authentication 关闭。创建容器时在 Registry 下拉框中选择对应仓库即可。

## 4. 关键界面示例（截图说明）

下方三张截图展示了在 Portainer 中配置和使用轩辕镜像专属域名的关键界面，您可以对照自己的环境一步步核对设置是否正确。

### ① Registries 列表：新增使用轩辕镜像的镜像仓库

![Portainer Registries 列表中新增使用轩辕镜像加速的仓库](https://img.xuanyuan.dev/docker/portainer/portainer1.png)

图 1：在 Portainer 的 Registries 页面中，可以看到额外新增的使用轩辕镜像加速的 docker.io 仓库（示例为登录验证方式，同样支持免登录专属域名方式）。

### ② Registry 详情：以 docker.xuanyuan.run 登录验证方式为例

![Portainer 中配置使用登录验证方式的 Docker Registry 详情](https://img.xuanyuan.dev/docker/portainer/portainer2.png)

图 2：示例中使用的是**登录验证方式**：`Registry URL` 为 `https://docker.xuanyuan.run`，并在 Authentication 中填写了镜像账户与镜像密码。如果您使用**专属域名免登录方式**，只需将 URL 换成 `https://***.xuanyuan.run`，并关闭认证即可。

### ③ 创建容器：选择加速仓库并填写镜像名称

![Portainer 创建容器时选择使用轩辕镜像加速的 Registry](https://img.xuanyuan.dev/docker/portainer/portainer3.png)

图 3：在新建容器界面中，从 Registry 下拉框中选择刚才新增的加速仓库（无论是登录验证方式还是免登录专属域名方式），然后在镜像名称中填写原始路径（如 `library/nginx:latest`），Portainer 会自动拼接专属域名前缀。

## 5. 连通性验证与常见问题排查

若在 Portainer 中拉取镜像失败或速度异常，可以按下面的顺序快速排查问题所在。

### 1）在 Docker 主机测试专属域名连通性

登录运行 Portainer 所连接的 Docker 主机，执行：

```bash
curl -v https://***.xuanyuan.run/v2/
```

若返回 **HTTP 200** 或 **HTTP 401**，说明主机可以访问专属域名，网络层通常没有问题。若连接超时或被拒绝，请优先检查防火墙 / 代理 / DNS 配置。

### 2）检查 Portainer Registry 配置

- 确认 **Registry URL** 是否准确填写为您的专属域名，并包含 `https://` 前缀。
- 确认 **Authentication** 未勾选、未填写用户名和密码（专属域名本身免登录）。
- 如果只配置了 docker.io 的加速仓库，而在 Portainer 中尝试拉取 ghcr.io / gcr.io 等镜像，则需要为这些仓库分别新增对应专属域名的 Registry。

### 3）查看 Portainer 与 Docker 日志

- 在 Portainer 部署主机上查看容器日志，确认是否有连接专属域名失败、DNS 解析错误或 4xx / 5xx 等错误。
- 在 Docker 主机上使用 `docker logs` 或 `journalctl -u docker -f` 等命令观察拉取过程中的报错信息。
- 若通过 Stack 部署失败，请检查 compose 文件中 `image` 字段是否使用了正确的专属域名或 Registry 选择。

> **提示**：**常见错误提示示例：**若 Portainer 报错 `unknown host ***.xuanyuan.run`，通常是 DNS / 网络问题；若返回 `401 Unauthorized` 或 `402 Payment Required`，请检查是否使用了正确的专属域名、以及账号流量是否充足。402 表示流量耗尽，请登录 [控制台](https://xuanyuan.cloud/dashboard) 充值或等待流量重置。

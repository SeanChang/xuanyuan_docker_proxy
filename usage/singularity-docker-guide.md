# Singularity / Apptainer Docker 镜像源配置教程

适用于 HPC 集群、科学计算环境。推荐专属域名方式（docker://xxx.xuanyuan.run/...，免登录）；亦可使用环境变量登录拉取 docker.io 镜像（不推荐，仅支持 docker.xuanyuan.run）。

## 1. 关于 Singularity 和 Apptainer

**Apptainer** 是 Singularity 项目的社区分支，两者功能基本相同，命令也基本兼容。本教程同时适用于 Singularity 和 Apptainer。

请使用以下命令查看版本：

```bash
singularity --version
```

或（如果使用的是 Apptainer）：

```bash
apptainer --version
```

## 2. 安装 Singularity/Apptainer

如果您的系统尚未安装 Singularity 或 Apptainer，可以使用以下方法安装：

**Ubuntu/Debian（推荐使用 Apptainer）：**

```bash
sudo add-apt-repository ppa:apptainer/ppa -y
sudo apt update
sudo apt install -y apptainer
```

**CentOS/RHEL：**

```bash
sudo yum install -y epel-release
sudo yum install -y singularity
```

**从源码编译安装：**

```bash
# 从源码编译安装（适用于高级用户）
# 参考官方文档：https://apptainer.org/docs/admin/main/installation.html
```

> **注意**：更多安装方法请参考官方文档：[Apptainer 安装文档](https://apptainer.org/docs/admin/main/installation.html) 或 [Singularity 安装文档](https://sylabs.io/guides/latest/user-guide/installation.html)

## 3. 专属域名方式（推荐）

若您已分配专属域名，此方式无需设置环境变量，直接在 `docker://` 地址中指定专属域名即可，比环境变量登录更简单。

**基本用法：**

```bash
singularity pull myapp.sif docker://xxx.xuanyuan.run/library/nginx:alpine
```

或使用 Apptainer 命令：

```bash
apptainer pull myapp.sif docker://xxx.xuanyuan.run/library/nginx:alpine
```

> **注意**：**重要提示：**请将命令中的 `xxx` 替换为您的专属域名前缀。例如，如果您的专属域名为 `123abc.xuanyuan.run`，则应将 `xxx` 替换为 `123abc`。

**多仓库镜像拉取示例：**

```bash
# Docker Hub 镜像
singularity pull nginx.sif docker://xxx.xuanyuan.run/library/nginx:alpine

# GitHub Container Registry 镜像
singularity pull ghcr.sif docker://xxx-ghcr.xuanyuan.run/namespace/image:tag

# Google Container Registry 镜像
singularity pull gcr.sif docker://xxx-gcr.xuanyuan.run/project/image:tag

# Quay.io 镜像
singularity pull quay.sif docker://xxx-quay.xuanyuan.run/namespace/image:tag

# Kubernetes Registry 镜像
singularity pull k8s.sif docker://xxx-k8s.xuanyuan.run/namespace/image:tag
```

> **注意**：**优势：**无需设置环境变量或登录凭据，直接在命令中指定专属域名即可。适合无 shell 登录需求、批量脚本、多 registry 后缀（GHCR、GCR 等）场景。

## 4. 环境变量登录方式（不推荐，仅支持 docker.io）

若您尚未分配专属域名，可在 HPC 作业脚本中通过环境变量向 Singularity/Apptainer 传递凭据，拉取 `docker://docker.xuanyuan.run/...`（docker.io）镜像。**此方式不推荐**，且不支持 GHCR、GCR 等其他 registry，请优先使用上方专属域名方式。

在本站完成注册并[充值流量包](https://xuanyuan.cloud/recharge)后，在个人中心「镜像仓库信息」中获取**镜像账户**和**镜像密码**。

**1. 设置环境变量（推荐 SingularityCE 变量名）：**

```bash
export SINGULARITY_DOCKER_USERNAME=镜像账户
export SINGULARITY_DOCKER_PASSWORD=镜像密码
```

**2. 拉取镜像：**

```bash
singularity pull test.sif docker://docker.xuanyuan.run/library/nginx:latest
```

或使用 Apptainer 命令：

```bash
apptainer pull test1.sif docker://docker.xuanyuan.run/library/redis:latest
```

**Apptainer 兼容变量名：**

```bash
# 使用 Apptainer 时也可改用以下变量名（可消除兼容提示）
export APPTAINER_DOCKER_USERNAME=镜像账户
export APPTAINER_DOCKER_PASSWORD=镜像密码
```

> **注意**：**镜像账户**和**镜像密码**可在[登录](https://xuanyuan.cloud/)后，在左侧菜单栏「个人中心」→「用户信息」→「镜像仓库信息」中查看。

> **重要**：**不支持 docker login：**Singularity/Apptainer 不会自动读取 `~/.docker/config.json` 中的 Docker 凭据，请勿照搬 Docker CLI 的 `docker login` 流程。

> **注意**：**变量名提示：**若使用 Apptainer 且已设置 `SINGULARITY_DOCKER_*`，可能出现 `SINGULARITY_DOCKER_* is set, but APPTAINER_DOCKER_* is preferred` 提示，Apptainer 仍会使用已设置的凭据，可忽略；若希望消除提示，可改用 `APPTAINER_DOCKER_USERNAME/PASSWORD`。

**安全提示：**环境变量会出现在进程列表中，HPC 共享节点请谨慎使用；脚本场景可在拉取完成后执行 `unset SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD`，或仅在作业脚本内设置。

**适用范围：**仅支持 `docker.xuanyuan.run`（docker.io）；其他 registry 请使用上方专属域名后缀方式。

## 5. 验证配置是否生效

拉取镜像后，可以通过以下方式验证配置是否生效：

- 观察拉取速度，如果明显快于直接拉取官方源，说明配置生效
- 检查镜像文件是否成功下载到本地（`ls -lh test.sif`）
- 专属域名方式：在网络抓包工具中查看是否访问了您的专属域名
- 环境变量登录（docker.io）：确认未出现 UNAUTHORIZED 或 402 错误

**专属域名示例：**

```bash
singularity pull test.sif docker://xxx.xuanyuan.run/library/alpine:latest
```

**环境变量登录示例（docker.io）：**

```bash
singularity pull test.sif docker://docker.xuanyuan.run/library/nginx:latest
```

拉取成功后，可以使用 `ls -lh test.sif` 查看镜像文件。

## 6. 常见问题

| 问题描述 | 可能原因 | 解决方法 |
|----------|----------|----------|
| 镜像拉取失败 | 专属域名拼写错误；专属域名没有流量；镜像账户或密码错误（环境变量登录）；镜像路径不正确；网络连接问题 | 检查命令中的域名是否正确，确保将 xxx 替换为您的专属域名前缀；前往[充值页面](https://xuanyuan.cloud/recharge)充值流量包；确认镜像路径格式正确，例如：docker://xxx.xuanyuan.run/library/nginx:alpine；检查网络连接和防火墙设置 |
| 拉取速度没有提升 | 仍在使用官方源地址；专属域名配置错误；网络环境限制 | 确认命令中使用的是专属域名（xxx.xuanyuan.run），而不是官方源地址；检查域名配置是否正确；使用网络抓包工具验证实际访问的地址 |
| 设置了 docker login 仍拉取失败 | Singularity/Apptainer 不读取 Docker 凭据 | 改用 `SINGULARITY_DOCKER_USERNAME/PASSWORD` 环境变量；或使用专属域名方式（步骤 3） |
| 出现 SINGULARITY_DOCKER_* is set, but APPTAINER_* is preferred | Apptainer 仍识别 SingularityCE 变量名 | 非错误，Apptainer 仍会使用 `SINGULARITY_DOCKER_*` 凭据；可忽略，或改用 `APPTAINER_DOCKER_*` 消除提示 |
| 环境变量登录后 402 / UNAUTHORIZED | 流量耗尽；镜像账户或密码错误 | 前往[充值页面](https://xuanyuan.cloud/recharge)充值流量包；核对个人中心「镜像仓库信息」中的账户密码 |
| 命令不存在 | 未安装 Singularity 或 Apptainer | 参考步骤 2 安装 Singularity 或 Apptainer |

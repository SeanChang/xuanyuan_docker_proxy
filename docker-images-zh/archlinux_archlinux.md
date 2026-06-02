---
image: archlinux/archlinux
description: "Arch Linux提供符合OCI标准的容器镜像，通过多个仓库分发，包括DockerHub官方库（每周更新）及DockerHub、quay.io的archlinux仓库（每日更新），适用于构建和运行容器化的Arch Linux环境。"
source: https://xuanyuan.cloud/zh/r/archlinux/archlinux
canonical: https://xuanyuan.cloud/zh/r/archlinux/archlinux
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/archlinux/archlinux" title="archlinux/archlinux Docker 镜像中文简介、标签列表与拉取命令">archlinux/archlinux — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/archlinux/archlinux" title="archlinux/archlinux Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/archlinux/archlinux</a>

# Arch Linux OCI 镜像文档


## 1. 镜像概述和主要用途

Arch Linux 提供符合 OCI（开放容器倡议）标准的容器镜像，旨在将 Arch Linux 的滚动发布特性和灵活性引入容器环境。这些镜像可用于开发环境搭建、CI/CD 流水线、软件测试以及需要轻量级 Arch Linux 基础的应用部署。

镜像通过多个仓库分发，支持不同更新频率（每日/每周），并提供多种功能版本以满足不同场景需求。


## 2. 核心功能和特性

### 2.1 符合 OCI 标准
所有镜像均遵循 OCI 规范，兼容 Docker、Podman 等主流容器运行时。

### 2.2 多版本镜像
提供三种预构建版本，对应不同元包（meta package）：
- `base`：基础版本，约 150 MiB，包含核心系统组件
- `base-devel`：开发版本，约 260 MiB，包含基础开发工具链
- `multilib-devel`：多架构开发版本，约 300 MiB，支持 32 位架构开发

### 2.3 灵活的标签策略
- `latest` 标签默认指向 `base` 版本
- 支持日期+构建号标签（如 `base-devel-20201118.0.9436`），便于版本追溯

### 2.4 滚动更新支持
镜像定期更新，但因 Arch Linux 滚动发布特性，建议启动容器后立即执行 `pacman -Syu` 以确保系统组件最新。

### 2.5 安全特性
- 除官方 DockerHub 库镜像外，所有镜像均通过 cosign 无密钥签名（keyless signing）
- 为避免密钥滥用，镜像默认剥离 pacman lsign 密钥，首次使用需手动初始化（见注意事项）


## 3. 使用场景和适用范围

| 镜像版本       | 适用场景                                  | 典型用途                                  |
|----------------|-------------------------------------------|-------------------------------------------|
| `base`         | 基础运行环境                              | 轻量级应用部署、系统测试                  |
| `base-devel`   | 开发环境                                  | 编译软件、构建包、开发工具链依赖          |
| `multilib-devel` | 多架构（32位/64位）开发环境              | 需要兼容32位库的软件编译、跨架构测试      |


## 4. 使用方法和配置说明

### 4.1 获取镜像

#### 4.1.1 官方 DockerHub 库（每周更新）
```sh
docker pull archlinux:latest  # 默认获取 base 版本
docker pull archlinux:base-devel  # 获取 base-devel 版本
```

#### 4.1.2 Arch Linux DockerHub 仓库（每日更新）
```sh
docker pull archlinux/archlinux:latest  # base 版本
docker pull archlinux/archlinux:base-devel  # base-devel 版本
docker pull archlinux/archlinux:multilib-devel  # multilib-devel 版本
```

#### 4.1.3 Quay.io 仓库（每日更新）
```sh
docker pull quay.io/archlinux/archlinux:latest
```

#### 4.1.4 GitHub Container Registry（每日更新）
```sh
docker pull ghcr.io/archlinux/archlinux:latest
```


### 4.2 验证镜像

非官方 DockerHub 库的镜像均通过 cosign 签名，可使用以下命令验证完整性：

```sh
# 验证 DockerHub 每日镜像
cosign verify docker.io/archlinux/archlinux:latest \
  --certificate-identity-regexp="https://gitlab\.archlinux\.org/archlinux/archlinux-docker//\.gitlab-ci\.yml@refs/tags/v[0-9]+\.0\.[0-9]+" \
  --certificate-oidc-issuer=https://gitlab.archlinux.org

# 验证 Quay.io 镜像
cosign verify quay.io/archlinux/archlinux:latest \
  --certificate-identity-regexp="https://gitlab\.archlinux\.org/archlinux/archlinux-docker//\.gitlab-ci\.yml@refs/tags/v[0-9]+\.0\.[0-9]+" \
  --certificate-oidc-issuer=https://gitlab.archlinux.org

# 验证 GHCR 镜像
cosign verify ghcr.io/archlinux/archlinux:latest \
  --certificate-identity-regexp="https://gitlab\.archlinux\.org/archlinux/archlinux-docker//\.gitlab-ci\.yml@refs/tags/v[0-9]+\.0\.[0-9]+" \
  --certificate-oidc-issuer=https://gitlab.archlinux.org
```


### 4.3 基本使用

#### 4.3.1 启动交互式容器
```sh
# 启动 base 版本容器并进入交互式终端
docker run -it --rm archlinux:latest /bin/bash

# 启动后立即更新系统（必做步骤）
pacman -Syu  # 按提示确认更新
```

#### 4.3.2 运行开发环境（base-devel）
```sh
# 启动 base-devel 容器，挂载当前目录作为工作区
docker run -it --rm -v $(pwd):/workspace archlinux/archlinux:base-devel /bin/bash

# 在容器内编译软件（示例：安装 git 并克隆仓库）
pacman -S --noconfirm git
cd /workspace
git clone https://github.com/example/project.git
```


### 4.4 安全注意事项

> ⚠️⚠️⚠️ 注意：出于安全考虑，镜像默认剥离 pacman lsign 密钥。这是因为相同密钥会被分发到所有基于同一镜像的容器，可能被恶意攻击者利用（如中间人攻击）。首次使用时需执行以下命令生成 lsign 密钥，但**切勿分发此密钥**：
> ```sh
> pacman-key --init
> ```
> ⚠️⚠️⚠️


## 5. 构建自定义镜像

如需基于官方模板构建自定义 Arch Linux 镜像，可使用 [官方仓库](https://gitlab.archlinux.org/archlinux/archlinux-docker) 提供的脚本。


### 5.1 依赖项

在 Arch Linux 主机上安装以下依赖包：
- `make`
- `devtools`（提供 pacman.conf 配置）
- `git`（获取提交/修订号）
- `podman`
- `fakechroot`
- `fakeroot`

确保当前用户可直接运行 Podman（执行 `podman info` 测试）。


### 5.2 构建命令

通过 `make` 目标构建不同版本镜像：
```sh
# 构建 base 版本镜像（标签 archlinux:base）
make image-base

# 构建 base-devel 版本镜像（标签 archlinux:base-devel）
make image-base-devel

# 构建 multilib-devel 版本镜像（标签 archlinux:multilib-devel）
make image-multilib-devel
```


## 6. 流水线与维护

### 6.1 每日发布
每日镜像通过 [GitLab CI](https://gitlab.archlinux.org/archlinux/archlinux-docker/-/blob/master/.gitlab-ci.yml) 定时构建，使用自有运行器基础设施。构建流程：
1. 生成根文件系统归档并上传至 [包仓库](https://gitlab.archlinux.org/archlinux/archlinux-docker/-/packages)
2. 多阶段 Dockerfile 下载归档并验证完整性，解压为 OCI 镜像层
3. 通过 Podman 构建并推送到外部仓库（DockerHub、Quay.io、GHCR）


### 6.2 每周发布
每周发布至官方 DockerHub 库，流程与每日构建一致，通过自动 [PR](https://github.com/docker-library/official-images/pulls?q=is%3Apr+archlinux+is%3Aclosed+author%3Aarchlinux-github) 更新 [official-images 库](https://github.com/docker-library/official-images/blob/master/library/archlinux)，由 GitHub 流水线构建并发布。


### 6.3 开发流程
特性分支的变更会触发流水线构建和测试，开发镜像上传至 [GitLab 容器仓库](https://gitlab.archlinux.org/archlinux/archlinux-docker/container_registry)。


### 6.4 维护事项
每年 6 月需更新 `GITLAB_PROJECT_TOKEN` 变量：
1. GitLab 管理员创建新 [访问令牌](https://gitlab.archlinux.org/archlinux/archlinux-docker/-/settings/access_tokens)，权限范围设为 `api` 和 `write_repository`，角色为 `Maintainer`
2. 新生成的 Bot 用户需被授予 `releases` 分支的访问权限


## 参考链接
- [官方 DockerHub 库](https://hub.docker.com/_/archlinux)
- [Arch Linux DockerHub 仓库](https://hub.docker.com/r/archlinux/archlinux)
- [Quay.io 仓库](https://quay.io/repository/archlinux/archlinux)
- [GHCR 仓库](https://github.com/archlinux/archlinux-docker/pkgs/container/archlinux)
- [cosign 无密钥签名](https://docs.sigstore.dev/cosign/openid_signing/)
- [官方构建仓库](https://gitlab.archlinux.org/archlinux/archlinux-docker)

---
image: composer/composer
description: "非官方构建的Composer容器镜像，与官方composer镜像功能一致且发布速度更快，用于PHP项目依赖管理。"
source: https://xuanyuan.cloud/zh/r/composer/composer
canonical: https://xuanyuan.cloud/zh/r/composer/composer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/composer/composer" title="composer/composer Docker 镜像中文简介、标签列表与拉取命令">composer/composer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Composer Docker 镜像文档


## 镜像概述

Composer 是 PHP 的依赖管理工具，使用 PHP 编写。它允许您声明项目所依赖的库，并自动管理（安装/更新）这些依赖。

更多关于 Composer 的信息，请参阅 [官方文档](https://getcomposer.org/doc/)。

![logo](https://raw.githubusercontent.com/docker-library/docs/58f7363e6cfa78f8cd54af16eab51c63c1232002/composer/logo.png)


## 核心功能与特性

- **依赖管理**：自动解析并安装 PHP 项目的依赖库，支持版本约束
- **缓存机制**：支持依赖包缓存，加速重复安装过程
- **全局配置**：可通过挂载目录实现配置持久化与共享
- **权限兼容**：支持指定运行用户，避免主机文件系统权限问题
- **私有仓库支持**：通过 SSH 代理集成访问私有代码仓库
- **轻量级设计**：镜像精简，专注于 Composer 运行，不包含完整 PHP 运行时


## 使用场景与适用范围

- PHP 项目的依赖安装与更新（无本地 PHP 环境时）
- CI/CD 流程中集成依赖管理步骤
- 多环境一致性保障（避免本地与生产环境依赖差异）
- 解决开发环境中 Composer 权限问题
- 快速临时运行 Composer 命令（无需全局安装）


## 使用方法

### 基本使用

运行 `composer/composer` 镜像的基础命令如下：

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  composer/composer install
```

**参数说明**：
- `--rm`：容器退出后自动删除
- `--interactive --tty`：交互式终端支持（允许命令行输入）
- `--volume $PWD:/app`：将当前目录挂载到容器内 `/app` 目录（项目根目录）


### 持久化缓存与全局配置

可通过挂载主机的 Composer 主目录到容器，实现缓存持久化或共享全局配置：

#### 默认配置（非 XDG 规范）

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --volume ${COMPOSER_HOME:-$HOME/.composer}:/tmp \
  composer/composer install
```

> **注意**：此方法依赖于镜像中默认将 `COMPOSER_HOME` 设置为 `/tmp` 的特性。

#### XDG 规范兼容配置

若遵循 XDG 规范，可通过环境变量指定缓存与配置目录：

```console
$ docker run --rm --interactive --tty \
  --env COMPOSER_HOME \
  --env COMPOSER_CACHE_DIR \
  --volume ${COMPOSER_HOME:-$HOME/.config/composer}:$COMPOSER_HOME \
  --volume ${COMPOSER_CACHE_DIR:-$HOME/.cache/composer}:$COMPOSER_CACHE_DIR \
  --volume $PWD:/app \
  composer/composer install
```

**环境变量说明**：
- `COMPOSER_HOME`：Composer 全局配置目录
- `COMPOSER_CACHE_DIR`：依赖包缓存目录


### 文件系统权限

默认情况下，Composer 在容器内以 root 用户运行，可能导致主机文件系统权限问题。可通过指定用户解决：

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --user $(id -u):$(id -g) \
  composer/composer install
```

**参数说明**：
- `--user $(id -u):$(id -g)`：使用当前主机用户的 UID 和 GID 运行容器（需系统支持 `id` 命令）


### 私有仓库与 SSH 代理

访问私有仓库时，需共享 SSH 凭据或挂载 SSH 代理套接字：

#### 基础私有仓库访问

```console
$ eval $(ssh-agent); \
  docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
  --env SSH_AUTH_SOCK=/ssh-auth.sock \
  docker.xuanyuan.run/composer/composer install
```

> **注意**：macOS 用户需使用 Docker For Mac v2.2.0.0 或更高版本（参见 [docker/for-mac#410](https://github.com/docker/for-mac/issues/410)）。

#### 结合非 root 用户的私有仓库访问

当同时使用非 root 用户和私有仓库时，需挂载主机的用户信息文件避免 SSH 用户不存在错误：

```console
$ eval $(ssh-agent); \
  docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --env SSH_AUTH_SOCK=/ssh-auth.sock \
  --user $(id -u):$(id -g) \
  docker.xuanyuan.run/composer/composer install
```

**参数说明**：
- `--volume /etc/passwd:/etc/passwd:ro`：只读挂载主机用户信息
- `--volume /etc/group:/etc/group:ro`：只读挂载主机用户组信息


## 故障排除

### PHP 版本与扩展问题

本镜像旨在无需主机 PHP 环境即可快速运行 Composer，**不应依赖容器内的 PHP 版本**。镜像未针对每个 PHP 版本提供单独标签，因不建议将其用作基础镜像或生产环境镜像。

若依赖或 Composer 脚本需要特定 PHP 扩展，建议按以下优先级解决：

#### 1. 创建自定义构建镜像（推荐）

使用多阶段构建将 Composer 集成到您的 PHP 镜像中（Docker 17.05+ 支持）：

```dockerfile
# 方法 1：从完整镜像复制
COPY --from=composer/composer:latest /usr/bin/composer /usr/bin/composer

# 方法 2：从二进制-only 标签复制（更精简）
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
```

#### 2. 在 composer.json 中指定平台配置

通过 `config.platform` 声明目标 PHP 版本及扩展：

```json
{
  "config": {
    "platform": {
      "php": "MAJOR.MINOR.PATCH",  // 例如 "7.4.33"
      "ext-something": "1"         // 声明扩展存在（版本号设为 "1"）
    }
  }
}
```

#### 3. 忽略平台要求（不推荐）

通过命令行标志跳过平台检查和脚本执行：

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  composer/composer install --ignore-platform-reqs --no-scripts
```

**标志说明**：
- `--ignore-platform-reqs`：忽略 PHP 版本及扩展要求
- `--no-scripts`：不执行 `composer.json` 中定义的脚本


## 许可证信息

查看包含在此镜像中的软件的许可证信息：[Composer 许可证](https://github.com/composer/composer/blob/master/LICENSE)。

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础发行版的 Bash 等），这些软件可能具有独立许可证。更多自动检测的许可证信息可参见 [repo-info 仓库的 composer 目录](https://github.com/docker-library/repo-info/tree/master/repos/composer)。

使用预构建镜像时，用户有责任确保对镜像中所有软件的使用符合相关许可证要求。

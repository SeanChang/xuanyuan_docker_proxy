<!-- xuanyuan-docker-images-zh
image: library/composer
source: https://xuanyuan.cloud/zh/r/library/composer
canonical: https://xuanyuan.cloud/zh/r/library/composer
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/composer" title="library/composer Docker 镜像中文简介、标签列表与拉取命令">library/composer — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/composer" title="library/composer Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/composer</a></p>

# Composer Docker镜像文档

## 1. 镜像概述

### 1.1 简介

Composer是一个用PHP编写的PHP依赖管理工具，允许您声明项目所依赖的库，并为您管理（安装/更新）这些依赖关系。

### 1.2 维护者

由[Rob Bast](https://github.com/alcohol)维护，社区[贡献者](https://github.com/composer/docker/graphs/contributors)提供支持。

## 2. 支持的标签和架构

### 2.1 可用标签

- [`2.8.12`, `2.8`, `2`, `latest`](https://github.com/composer/docker/blob/517441df1032e9914b7b7ab43e8ad0ce0d05a14e/latest/Dockerfile)
- [`2.2.25`, `2.2`](https://github.com/composer/docker/blob/a037fe423a4fef8030b2a8c3131da0934a6295dd/2.2/Dockerfile)
- [`1.10.27`, `1.10`, `1`](https://github.com/composer/docker/blob/a037fe423a4fef8030b2a8c3131da0934a6295dd/1.10/Dockerfile)

### 2.2 支持的架构

- [`amd64`](https://hub.docker.com/r/amd64/composer/)
- [`arm32v6`](https://hub.docker.com/r/arm32v6/composer/)
- [`arm32v7`](https://hub.docker.com/r/arm32v7/composer/)
- [`arm64v8`](https://hub.docker.com/r/arm64v8/composer/)
- [`i386`](https://hub.docker.com/r/i386/composer/)
- [`ppc64le`](https://hub.docker.com/r/ppc64le/composer/)
- [`riscv64`](https://hub.docker.com/r/riscv64/composer/)
- [`s390x`](https://hub.docker.com/r/s390x/composer/)

## 3. 核心功能和特性

- 声明和管理PHP项目依赖
- 自动解决依赖冲突
- 支持私有和公共代码仓库
- 可扩展的插件系统
- 支持版本约束和分支选择

## 4. 使用场景和适用范围

- PHP项目的依赖管理
- CI/CD流程中的依赖安装步骤
- 开发环境的依赖一致性维护
- 多环境部署时的依赖版本控制

## 5. 使用方法和配置说明

### 5.1 基本使用

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  composer <command>
```

### 5.2 持久化缓存/全局配置

可以将Composer主目录从主机绑定挂载到容器中，以启用持久缓存或共享全局配置：

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --volume ${COMPOSER_HOME:-$HOME/.composer}:/tmp \
  composer <command>
```

> **注意**: 这依赖于镜像中默认将`COMPOSER_HOME`值设置为`/tmp`的事实。

如果您的环境遵循XDG规范：

```console
$ docker run --rm --interactive --tty \
  --env COMPOSER_HOME \
  --env COMPOSER_CACHE_DIR \
  --volume ${COMPOSER_HOME:-$HOME/.config/composer}:$COMPOSER_HOME \
  --volume ${COMPOSER_CACHE_DIR:-$HOME/.cache/composer}:$COMPOSER_CACHE_DIR \
  --volume $PWD:/app \
  composer <command>
```

### 5.3 文件系统权限

默认情况下，Composer在容器内以root用户身份运行。这可能导致主机文件系统上的权限问题。您可以通过使用不同的用户运行容器来解决此问题：

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --user $(id -u):$(id -g) \
  composer <command>
```

详情请参见: https://docs.docker.com/engine/reference/run/#user

> **注意**: Docker for Mac的行为有所不同，此提示可能不适用于Docker for Mac用户。

### 5.4 私有仓库/SSH代理

当需要访问私有仓库时，您需要共享配置的凭据，或将`ssh-agent`套接字挂载到正在运行的容器中：

```console
$ eval $(ssh-agent); \
  docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
  --env SSH_AUTH_SOCK=/ssh-auth.sock \
  composer <command>
```

**注意**: 在OSX上，这需要Docker For Mac v2.2.0.0或更高版本，参见[docker/for-mac#410](https://github.com/docker/for-mac/issues/410)。

当将私有仓库的使用与以其他用户身份运行Composer结合时，可能会遇到不存在的用户错误（由ssh抛出）。要解决此问题，请将主机的passwd和group文件（只读）绑定挂载到容器中：

```console
$ eval $(ssh-agent); \
  docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --env SSH_AUTH_SOCK=/ssh-auth.sock \
  --user $(id -u):$(id -g) \
  composer <command>
```

## 6. 故障排除

### 6.1 PHP版本和扩展问题

此镜像旨在快速运行Composer，无需在主机上安装PHP运行时。不应依赖容器中的PHP版本。我们不提供每个支持的PHP版本的Composer镜像，因为我们不鼓励将Composer用作基础镜像或生产镜像。

我们努力提供尽可能精简的镜像，仅用于运行Composer。有时依赖项或Composer[脚本](https://getcomposer.org/doc/articles/scripts.md)需要某些PHP扩展。

解决建议：

- （最佳方案）创建自己的构建镜像并[安装](https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md)Composer。
  
  **注意**: Docker 17.05引入了[多阶段构建](https://docs.docker.com/develop/develop-images/multistage-build/)，极大简化了这一过程：
  
  ```dockerfile
  COPY --from=composer /usr/bin/composer /usr/bin/composer
  ```

- （替代方案）在`composer.json`中指定目标[平台](https://getcomposer.org/doc/06-config.md#platform)/扩展：
  
  ```json
  {
    "config": {
      "platform": {
        "php": "MAJOR.MINOR.PATCH",
        "ext-something": "MAJOR.MINOR.PATCH"
      }
    }
  }
  ```

- （不推荐）向`install`或`update`传递[`--ignore-platform-reqs`](https://getcomposer.org/doc/03-cli.md#install-i)和/或`--no-scripts`标志：
  
  ```console
  $ docker run --rm --interactive --tty \
    --volume $PWD:/app \
    composer install --ignore-platform-reqs --no-scripts
  ```

## 7. 部署示例

### 7.1 基本安装依赖

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  composer install
```

### 7.2 创建新项目

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  composer create-project laravel/laravel my-project
```

### 7.3 更新依赖

```console
$ docker run --rm --interactive --tty \
  --volume $PWD:/app \
  composer update
```

### 7.4 Docker Compose集成

```yaml
version: '3'

services:
  composer:
    image: composer:latest
    volumes:
      - .:/app
      - ${COMPOSER_HOME:-$HOME/.composer}:/tmp
    user: ${UID:-1000}:${GID:-1000}
    command: install
```

## 8. 问题反馈和支持

### 8.1 提交问题

[https://github.com/composer/docker/issues](https://github.com/composer/docker/issues?q=)

### 8.2 获取帮助

- [Docker社区Slack](https://dockr.ly/comm-slack)
- [Server Fault](https://serverfault.com/help/on-topic)
- [Unix & Linux](https://unix.stackexchange.com/help/on-topic)
- [Stack Overflow](https://stackoverflow.com/help/on-topic)

### 8.3 镜像信息

- **镜像更新**: [official-images repo's `library/composer` label](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fcomposer)
- **发布的镜像工件详情**: [repo-info repo's `repos/composer/` directory](https://github.com/docker-library/repo-info/blob/master/repos/composer) ([历史](https://github.com/docker-library/repo-info/commits/master/repos/composer))

## 9. 许可证信息

查看此镜像中包含的软件的[许可证信息](https://github.com/composer/composer/blob/master/LICENSE)。

与所有Docker镜像一样，这些镜像可能还包含其他可能在其他许可证下的软件（例如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

一些能够自动检测到的其他许可证信息可能位于[`repo-info`仓库的`composer/`目录](https://github.com/docker-library/repo-info/tree/master/repos/composer)中。

至于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用都符合其中包含的所有软件的相关许可证。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/composer" title="library/composer Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/composer</a></p>

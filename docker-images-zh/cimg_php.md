---
image: cimg/php
description: "CircleCI PHP便捷镜像，专为PHP项目在CircleCI平台上的持续集成流程设计，提供预配置环境以简化集成部署。"
source: https://xuanyuan.cloud/zh/r/cimg/php
canonical: https://xuanyuan.cloud/zh/r/cimg/php
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cimg/php" title="cimg/php Docker 镜像中文简介、标签列表与拉取命令">cimg/php 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# cimg/php Docker镜像文档


## 镜像概述和主要用途

`cimg/php` 是由CircleCI构建的Docker镜像，专为持续集成（CI）环境设计，用于替代旧版 `circleci/php` 镜像。该镜像包含完整的PHP运行环境、Composer依赖管理工具及常用PHP扩展，可直接用于CircleCI流水线中的构建任务，确保PHP项目在CI环境中高效完成构建、测试等流程。


## 核心功能和特性

### 完整的PHP环境
- 包含指定版本的PHP解释器，支持多种PHP版本（如7.4、8.0等）。
- 内置Composer（v2版本，2020年11月及以后构建的标签），用于PHP依赖管理。

### PHP扩展支持
- 集成PEAR（PHP扩展与应用库仓库）、PECL（PHP扩展社区库）及Docker PHP Helper脚本，便于安装和管理PHP扩展。
- 支持通过 `mlocati/docker-php-extension-installer` 工具快速安装扩展（如xsl、xdebug等）。

### 多变体支持
- **Node.js变体**：在基础镜像上额外安装Node.js，标签格式为 `<php-version>-node`（如 `7.4.26-node`）。
- **Browsers变体**：包含Node.js、Java、Selenium及浏览器依赖，配合CircleCI Browser Tools orb可安装Chrome/Firefox，标签格式为 `<php-version>-browsers`（如 `7.4.26-browsers`）。

### 灵活的标签方案
- 标签格式：`cimg/php:<php-version>[-variant]`
  - `<php-version>`：PHP版本，支持完整SemVer（如 `7.4.26`）或次要版本（如 `7.4`，自动指向最新补丁版本）。
  - `[-variant]`：可选变体标识（`-node` 或 `-browsers`）。


## 使用场景和适用范围

适用于需要在CircleCI流水线中运行PHP项目构建、测试的场景，尤其适合：
- PHP应用的持续集成构建流程。
- 需要PHP与Node.js协同的前端+后端项目构建。
- 依赖浏览器环境的PHP应用测试（如Selenium自动化测试）。


## 详细的使用方法和配置说明

### 基本使用（CircleCI配置）

在CircleCI配置文件（`.circleci/config.yml`）中，通过 `docker` 执行器使用该镜像：

```yaml
jobs:
  build:
    docker:
      - image: cimg/php:7.4.26  # 指定PHP版本
    steps:
      - checkout  # 拉取代码
      - run: php --version  # 验证PHP版本
      - run: composer install  # 安装依赖
```


### 安装PHP扩展

#### 方法1：使用PECL安装扩展
通过 `pecl` 命令安装PECL扩展（如pcov）：
```bash
sudo pecl install pcov
```

#### 方法2：使用扩展安装工具
通过 `install-php-extensions` 脚本安装支持的扩展（需管理员权限）：
```bash
sudo -E install-php-extensions xsl xdebug  # 安装xsl和xdebug扩展
sudo docker-php-ext-enable xdebug  # 启用xdebug（部分扩展需手动启用）
```

#### 方法3：手动编译安装扩展
通过Docker PHP Helper脚本手动编译安装核心扩展（如iconv）：
```bash
sudo docker-php-source extract && \  # 提取PHP源码
sudo docker-php-ext-configure iconv  # 配置扩展（如需自定义参数可添加--with-*） && \
sudo docker-php-ext-install iconv && \  # 编译安装扩展
sudo docker-php-ext-enable iconv && \  # 启用扩展
docker-php-source delete  # 清理源码
```


### Composer版本切换

默认包含Composer v2，如需切换到Composer v1：
```yaml
steps:
  - run: sudo composer self-update --1  # 降级到Composer v1
```


### 变体使用示例

#### Node.js变体
包含Node.js环境，适用于需Node.js构建的PHP项目：
```yaml
jobs:
  build:
    docker:
      - image: cimg/php:7.4.26-node  # Node.js变体标签
    steps:
      - checkout
      - run: php --version  # 验证PHP
      - run: node --version  # 验证Node.js
      - run: npm install  # 使用npm安装前端依赖
```

#### Browsers变体
包含浏览器依赖，配合 `browser-tools` orb安装Chrome/Firefox：
```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1  # 引入浏览器工具orb
jobs:
  test:
    docker:
      - image: cimg/php:7.4.26-browsers  # Browsers变体标签
    steps:
      - browser-tools/install-browser-tools  # 安装Chrome/Firefox
      - checkout
      - run: google-chrome --version  # 验证Chrome安装
      - run: phpunit  # 运行依赖浏览器的测试
```


### 标签选择建议

- **固定补丁版本**（如 `7.4.26`）：确保构建环境稳定，避免意外更新。
- **次要版本标签**（如 `7.4`）：自动获取最新补丁版本，适合希望保持版本更新的场景。


## 开发与贡献

### 本地构建镜像

#### 克隆仓库
```bash
# 社区用户（需先Fork）
git clone --recurse-submodules <你的Fork仓库URL>
cd cimg-php
git submodule update --recursive  # 初始化子模块

# 维护者
git clone --recurse-submodules git@github.com:CircleCI-Public/cimg-php.git
```

#### 生成Dockerfile
使用 `gen-dockerfiles.sh` 脚本生成指定PHP版本的Dockerfile：
```bash
./shared/gen-dockerfiles.sh 7.4.26  # 生成PHP 7.4.26的Dockerfile
# 生成的Dockerfile位于 ./7.4/Dockerfile
```

#### 构建并测试镜像
```bash
cd 7.4
docker build -t test/php:7.4.26 .  # 本地构建镜像
docker run -it test/php:7.4.26 bash  # 运行容器测试
```


### 发布流程（维护者）

通过 `release.sh` 脚本发布新版本（以PHP 9.99为例）：
```bash
./shared/release.sh 9.99  # 自动创建分支、生成Dockerfile、提交并推送
```
提交信息需包含 `[release]`，触发CircleCI推送镜像至Docker Hub。


### 变更整合

- **构建脚本更新**：修改位于 `./shared` 子模块（独立仓库 [cimg-shared](https://github.com/CircleCI-Public/cimg-shared)），需更新子模块：
  ```bash
  cd shared && git pull && cd .. && git add shared && git commit -m "更新子模块"
  ```
- **父镜像变更**：新PHP版本镜像会自动继承父镜像更新，旧版本需重新构建为新版本。
- **PHP特定变更**：修改本仓库 `Dockerfile.template` 文件，重新生成Dockerfile。


## 附加资源

- [CircleCI官方文档](https://circleci.com/docs/)
- [CircleCI配置参考](https://circleci.com/docs/2.0/configuration-reference/)
- [Docker官方文档](https://docs.docker.com/)
- [PHP扩展安装工具](https://github.com/mlocati/docker-php-extension-installer)


## 许可证

本镜像仓库采用MIT许可证，详见 [LICENSE](https://raw.githubusercontent.com/CircleCI-Public/cimg-php/main/LICENSE)。

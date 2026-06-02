<!-- xuanyuan-docker-images-zh
image: 2000cubits/php-cli-developer
source: https://xuanyuan.cloud/zh/r/2000cubits/php-cli-developer
canonical: https://xuanyuan.cloud/zh/r/2000cubits/php-cli-developer
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/2000cubits/php-cli-developer" title="2000cubits/php-cli-developer Docker 镜像中文简介、标签列表与拉取命令">2000cubits/php-cli-developer — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/2000cubits/php-cli-developer" title="2000cubits/php-cli-developer Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/2000cubits/php-cli-developer</a></p>

# PHP CLI 开发工具镜像

## 镜像概述
本镜像基于官方PHP CLI镜像构建，专为PHP开发者设计，集成了常用开发工具与扩展，提供开箱即用的PHP命令行开发环境。通过整合开发必需的工具链，简化PHP应用的开发、调试、测试及脚本执行流程。

## 核心功能与特性

### 1. 完整的PHP运行环境
- 基于官方PHP CLI镜像，支持PHP 7.4+、8.0+等多个稳定版本（通过镜像标签区分，如`7.4-cli-dev`、`8.2-cli-dev`）
- 预安装常用PHP扩展：`mbstring`、`json`、`curl`、`xml`、`zip`、`pdo`等
- 支持扩展自定义安装与配置

### 2. 集成开发工具
- **依赖管理**：Composer（最新稳定版）
- **调试工具**：Xdebug（支持远程调试、性能分析）
- **测试工具**：PHPUnit（单元测试框架）
- **代码质量**：PHP_CodeSniffer（代码规范检查）、PHPStan（静态代码分析）
- **其他工具**：Git、nano、wget等系统工具

### 3. 灵活的环境配置
- 支持自定义php.ini配置
- 环境变量控制Xdebug等工具的启用状态
- 兼容主流Linux架构（amd64、arm64）

## 使用场景

### 1. 本地PHP开发
- 快速搭建隔离的PHP开发环境，避免本地环境冲突
- 运行和调试PHP脚本、命令行应用（如Laravel Artisan、Symfony Console）

### 2. 自动化脚本执行
- 运行定时任务、数据处理脚本等PHP CLI程序
- 集成到本地脚本或小型服务中执行后台任务

### 3. CI/CD流程集成
- 在持续集成/部署流程中执行单元测试、代码质量检查
- 作为构建环境编译PHP应用依赖（通过Composer）

### 4. 学习与教学
- 提供标准化的PHP环境，适合PHP初学者学习和实践

## 使用方法

### 基本使用

#### 1. 获取镜像
```bash
docker pull [镜像名称]:[版本标签]  # 例如: docker pull php-cli-dev:8.2
```

#### 2. 运行PHP脚本
将本地项目目录挂载到容器中，执行PHP脚本：
```bash
docker run --rm -v $(pwd):/app php-cli-dev:8.2 php /app/your-script.php
```

#### 3. 交互式终端
启动容器并进入交互式终端，进行开发调试：
```bash
docker run -it --rm -v $(pwd):/app php-cli-dev:8.2 /bin/bash
```

### 调试配置（Xdebug）
通过环境变量启用Xdebug并配置远程调试：
```bash
docker run --rm -v $(pwd):/app \
  -e XDEBUG_MODE=debug \
  -e XDEBUG_CLIENT_HOST=host.docker.internal \  # 本地调试时使用
  -e XDEBUG_CLIENT_PORT=9003 \
  php-cli-dev:8.2 php /app/debug-script.php
```

### 依赖管理（Composer）
在容器中使用Composer安装依赖：
```bash
docker run --rm -v $(pwd):/app php-cli-dev:8.2 composer install
```

### 单元测试（PHPUnit）
执行PHPUnit测试用例：
```bash
docker run --rm -v $(pwd):/app php-cli-dev:8.2 phpunit /app/tests
```

### 环境变量配置

| 环境变量                | 说明                                  | 默认值          |
|-------------------------|---------------------------------------|-----------------|
| `PHP_INI_DIR`           | PHP配置文件目录                       | `/usr/local/etc/php` |
| `XDEBUG_MODE`           | Xdebug运行模式（debug/develop/coverage） | `off`           |
| `XDEBUG_CLIENT_HOST`    | 调试客户端IP/主机名                   | `localhost`     |
| `XDEBUG_CLIENT_PORT`    | 调试客户端端口                         | `9003`          |
| `COMPOSER_HOME`         | Composer缓存目录                       | `/root/.composer` |

### 扩展管理
如需安装额外PHP扩展，可在Dockerfile中基于本镜像构建：
```dockerfile
FROM php-cli-dev:8.2
RUN docker-php-ext-install redis  # 安装Redis扩展
```

## 版本支持
镜像提供以下PHP版本标签（具体以实际镜像仓库为准）：
- `7.4`、`8.0`、`8.1`、`8.2`、`8.3`（最新稳定版）
- `latest`（默认指向最新PHP版本）

## 注意事项
- 生产环境建议使用官方PHP CLI镜像，本镜像包含开发工具，不适合生产部署
- 本地开发时，确保文件权限正确（可通过`-u $(id -u):$(id -g)`指定用户ID避免权限问题）
- 不同PHP版本对应的扩展支持可能存在差异，使用前请查阅对应版本的PHP官方文档

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/2000cubits/php-cli-developer" title="2000cubits/php-cli-developer Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/2000cubits/php-cli-developer</a></p>

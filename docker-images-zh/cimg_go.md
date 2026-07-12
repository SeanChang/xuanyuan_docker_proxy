---
image: cimg/go
description: "CircleCI Go便捷镜像，为Go语言项目提供持续集成环境支持。"
source: https://xuanyuan.cloud/zh/r/cimg/go
canonical: https://xuanyuan.cloud/zh/r/cimg/go
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cimg/go" title="cimg/go Docker 镜像中文简介、标签列表与拉取命令">cimg/go 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# cimg/go Docker镜像文档

## 镜像概述和主要用途

`cimg/go` 是由CircleCI开发的Docker镜像，专为持续集成(CI)构建设计，用于替代旧版 `circleci/golang` 镜像。该镜像包含完整的Go语言版本及其工具链、测试包装器 `gotestsum`，以及在CircleCI环境中成功完成构建所需的各类二进制文件和工具。其主要用途是为CircleCI环境中的Go项目提供一致、高效的CI构建环境。


## 核心功能和特性

### 基础功能
- **完整Go工具链**：包含Go编程语言及其全套工具，支持Go模块、官方Go代理服务器等标准功能。
- **测试工具集成**：预装 `gotestsum`，简化测试结果收集与展示。
- **环境优化**：针对CircleCI环境预配置，确保构建流程顺畅。

### 变体支持
- **Node.js变体**：在基础Go镜像上额外安装Node.js，通过标签 `-node` 启用（如 `cimg/go:1.17-node`）。
- **Browsers变体**：包含Node.js、Java、Selenium及浏览器依赖（通过apt预装），通过标签 `-browser` 启用（如 `cimg/go:1.17-browsers`），需配合 [CircleCI Browser Tools orb](https://circleci.com/developer/orbs/orb/circleci/browser-tools) 使用。

### 环境变量调整
- **GOPATH变更**：环境变量 `GOPATH` 从旧版的 `/go` 调整为 `$HOME/go`（展开为 `/home/circleci/go`），首次使用时需注意缓存配置适配。


## 使用场景和适用范围

- **CircleCI Go项目CI构建**：适用于所有需要在CircleCI环境中进行持续集成的Go项目，提供标准Go开发环境。
- **多工具链需求场景**：当Go项目同时依赖Node.js（如前端资源构建）时，可使用Node.js变体。
- **浏览器自动化测试**：需通过Selenium等工具进行浏览器自动化测试的Go项目，可使用Browsers变体。


## 使用方法和配置说明

### 基础使用

在CircleCI配置中，通过 `docker` 执行器引用该镜像。示例配置如下：

```yaml
jobs:
  build:
    docker:
      - image: cimg/go:1.17  # 使用Go 1.17版本
    steps:
      - checkout  # 拉取代码
      - run: go version  # 验证Go版本
      - run: go mod download  # 下载依赖
      - run: go test -v ./...  # 运行测试
```

### 变体使用

#### Node.js变体

需在标签后添加 `-node`，示例：

```yaml
jobs:
  build:
    docker:
      - image: cimg/go:1.17-node  # Go 1.17 + Node.js
    steps:
      - checkout
      - run: go version  # 验证Go
      - run: node --version  # 验证Node.js
      - run: npm install  # 安装Node.js依赖
```

#### Browsers变体

需在标签后添加 `-browser`，示例：

```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1  # 引入浏览器工具orb
jobs:
  build:
    docker:
      - image: cimg/go:1.17-browsers  # Go 1.17 + 浏览器工具
    steps:
      - browser-tools/install-browser-tools  # 安装Chrome/Firefox
      - checkout
      - run: go version
      - run: node --version
      - run: java --version
      - run: google-chrome --version  # 验证浏览器安装
```

### 标签方案

镜像标签格式为：  
`cimg/go:<go-version>[-variant]`

- `<go-version>`：Go版本号，支持完整SemVer（如 `1.17.13`）或次要版本（如 `1.17`，自动指向最新补丁版本）。  
  > **注意**：Go官方首次次要版本发布无 `.0` 后缀（如 `1.18` 而非 `1.18.0`），该镜像统一添加 `.0` 以适配工具链（如标签 `1.18` 对应Go `1.18.0`）。
- `[-variant]`：可选变体后缀，支持 `-node` 或 `-browser`。


## 开发与贡献

### 本地构建

1. **克隆仓库**（含子模块）：
   ```bash
   git clone --recurse-submodules https://github.com/CircleCI-Public/cimg-go.git
   cd cimg-go
   ```

2. **生成Dockerfile**（以Go 1.18为例）：
   ```bash
   ./shared/gen-dockerfiles.sh 1.18.0  # 生成1.18版本Dockerfile
   ```

3. **构建镜像**：
   ```bash
   cd 1.18
   docker build -t test/go:1.18.0 .
   ```

4. **本地测试**：
   ```bash
   docker run -it docker.xuanyuan.run/test/go:1.18.0 bash # 进入容器验证环境
   ```

### 贡献指南

- **工具链变更**：构建脚本修改需通过 [cimg-shared子模块仓库](https://github.com/CircleCI-Public/cimg-shared) 提交。
- **镜像特有变更**：修改 `Dockerfile.template` 后需重新生成Dockerfile（`gen-dockerfiles.sh`）。
- **PR流程**：提交PR前确保本地测试通过，PR需包含清晰的变更说明。


## 附加资源

- [CircleCI官方文档](https://circleci.com/docs/)
- [CircleCI配置参考](https://circleci.com/docs/2.0/configuration-reference/)
- [Docker官方文档](https://docs.docker.com/)
- [CircleCI Browser Tools orb](https://circleci.com/developer/orbs/orb/circleci/browser-tools)


## 许可证

本仓库采用MIT许可证，详情参见 [LICENSE](https://raw.githubusercontent.com/CircleCI-Public/cimg-go/main/LICENSE)。

<!-- xuanyuan-docker-images-zh
image: cimg/openjdk
source: https://xuanyuan.cloud/zh/r/cimg/openjdk
canonical: https://xuanyuan.cloud/zh/r/cimg/openjdk
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [cimg/openjdk — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/cimg/openjdk "cimg/openjdk Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/cimg/openjdk

# CircleCI 便捷镜像：OpenJDK  

**用于持续集成的 OpenJDK/Java Docker 镜像，专为 CircleCI 环境设计**  


该镜像旨在替代旧版 CircleCI OpenJDK 镜像 `circleci/openjdk`。  

`cimg/openjdk` 是由 CircleCI 开发的 Docker 镜像，专注于持续集成构建场景。每个标签包含特定版本的 OpenJDK、Java 开发工具包（JDK），以及在 CircleCI 环境中成功完成构建所需的二进制文件和工具。  


## 目录  

- [快速开始](#快速开始)  
- [镜像工作原理](#镜像工作原理)  
- [开发指南](#开发指南)  
- [贡献指南](#贡献指南)  
- [相关资源](#相关资源)  
- [许可证](#许可证)  


## 快速开始  

该镜像可与 CircleCI 的 `docker` 执行器配合使用。示例配置如下：  

```yaml
jobs:
  build:
    docker:
      - image: cimg/openjdk:15.0  # 使用 OpenJDK 镜像
    steps:
      - checkout  # 检出代码
      - run: java --version  # 验证 Java 版本
```  

上述示例中，`cimg/openjdk:15.0` 作为主容器镜像，标签 `15.0` 对应 OpenJDK v15.0.2 版本。配置后即可在任务步骤中使用 OpenJDK。  


## 镜像工作原理  

本镜像基于 [Adoptium]([]) 提供的 OpenJDK 构建，包含 Java 编程语言环境。  


### 变体镜像  

变体镜像基于基础镜像，额外集成特定工具以满足不同场景需求。  


#### Node.js 变体  
在基础 OpenJDK 镜像中预装 Node.js。使用时需在标签后添加 `-node` 后缀，例如：  

```yaml
jobs:
  build:
    docker:
      - image: cimg/openjdk:15.0-node  # Node.js 变体
    steps:
      - checkout
      - run: java --version  # 验证 Java
      - run: node --version  # 验证 Node.js
```  


#### 浏览器变体  
在基础镜像中预装 Node.js、Selenium 及浏览器依赖（通过 apt 安装），需配合 [CircleCI Browser Tools orb]([]) 使用（用于安装 Chrome/Firefox 浏览器）。使用时添加 `-browser` 后缀，例如：  

```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1  # 引入浏览器工具 orb
jobs:
  build:
    docker:
      - image: cimg/openjdk:15.0-browsers  # 浏览器变体
    steps:
      - browser-tools/install-browser-tools  # 安装浏览器
      - checkout
      - run: |
          node --version       # 验证 Node.js
          java --version       # 验证 Java
          google-chrome --version  # 验证 Chrome
```  


### 标签规则  

镜像标签格式如下：  

```
cimg/openjdk:<openjdk-version>[-variant]
```  

- `<openjdk-version>`：OpenJDK 版本号，支持完整语义化版本（如 `11.0.10`）或次要版本（如 `11.0`）。次要版本标签会自动指向最新补丁更新（例如 `11.0` 会从 11.0.10 自动更新到 11.0.11）。  
- `[-variant]`：可选变体后缀，如 `-node`（Node.js 变体）或 `-browser`（浏览器变体）。  


## 开发指南  

本地构建和运行镜像需满足以下环境要求：  
- Linux（已测试 Ubuntu）或 macOS 系统  
- Bash 4+  
- Docker Engine 19.03+  


### 克隆仓库  

#### 社区用户（无仓库写入权限）  
1. Fork 本仓库，克隆时需添加 `--recurse-submodules` 参数拉取子模块：  
   ```bash
   git clone --recurse-submodules <你的 Fork 仓库地址>
   ```  
2. 若已克隆，可通过以下命令补全子模块：  
   ```bash
   git submodule update --recursive
   ```  


#### 维护者（有仓库写入权限）  
直接克隆并拉取子模块：  
```bash
git clone --recurse-submodules [邮箱已删除]:CircleCI-Public/cimg-openjdk.git
```  


### 生成 Dockerfile  

使用 `gen-dockerfiles.sh` 脚本生成特定版本的 Dockerfile，需指定 OpenJDK 版本及 Adoptium 下载链接（因 Adoptium 版本号含额外构建号，需手动传入 URL）。例如生成 OpenJDK 11.0.5 的 Dockerfile：  

```bash
./shared/gen-dockerfiles.sh 11.0.5#[]  

生成的 Dockerfile 位于 `./11.0/Dockerfile`。  


### 本地构建与测试  

生成 Dockerfile 后，可本地构建并测试镜像：  
```bash
cd 11.0  # 进入版本目录
docker build -t test/openjdk:11.0.5 .  # 构建镜像
docker run -it test/openjdk:11.0.5 bash  # 运行容器测试
```  


### 批量构建镜像  

使用 `build-images.sh` 脚本批量构建本地镜像（需先生成 Dockerfile）：  
```bash
./build-images.sh
```  


### 发布官方镜像（仅维护者）  

通过 `release.sh` 脚本自动化发布流程（以 OpenJDK 9.9.9 为例，需替换为实际版本和 URL）：  

```bash
./shared/release.sh 9.9.9#[]  

该脚本会自动创建分支、生成 Dockerfile、提交变更并推送到 GitHub（提交信息含 `[release]` 标记，触发 CircleCI 流水线推送镜像至 Docker Hub）。后续需：  
1. 等待 CircleCI 构建通过  
2. 审核并合并 PR  


### 变更集成  

- **构建脚本更新**：`./shared` 子模块的变更需通过更新子模块同步：  
  ```bash
  cd shared && git pull && cd .. && git add shared && git commit -m "更新子模块"
  ```  
- **基础镜像变更**：默认不影响现有 OpenJDK 镜像（确保构建确定性），新镜像会自动集成基础镜像更新。  
- **OpenJDK 特定变更**：修改 `Dockerfile.template` 文件，重新生成 Dockerfile 即可生效。  


## 贡献指南  

欢迎提交 issue 和 PR，但建议注意以下事项：  

1. **工具纳入标准**：仅添加维护活跃且对多数 Java 开发者有用的工具（避免镜像体积过大）。  
2. **大型 PR 预讨论**：若 PR 工作量较大，建议先开 issue 讨论可行性。  
3. **issue 范围**：用于报告 bug 或请求工具增减；使用问题请前往 [CircleCI Discuss]([])。  


## 相关资源  

- [Adoptium]([])：OpenJDK 构建源  
- [CircleCI 文档]([])：官方配置指南  
- [CircleCI 配置参考]([])：`.circleci/config.yml` 语法说明  
- [Docker 文档]([])：Docker 基础学习资源  


## 许可证  

本仓库采用 MIT 许可证，详见 [LICENSE](./LICENSE)。

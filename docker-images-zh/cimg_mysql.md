---
image: cimg/mysql
description: "cimg/mysql Docker镜像基于官方MySQL稳定版构建，为开发与CI/CD环境提供轻量级高性能服务。内置优化配置，支持数据持久化与网络隔离，基于Ubuntu系统并包含常用客户端工具。可快速部署单节点实例及容器化架构集成，适合自动化测试、本地开发及小型生产环境。镜像定期更新，确保安全性与兼容性，简化数据库环境一致性管理。"
source: https://xuanyuan.cloud/zh/r/cimg/mysql
canonical: https://xuanyuan.cloud/zh/r/cimg/mysql
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cimg/mysql" title="cimg/mysql Docker 镜像中文简介、标签列表与拉取命令">cimg/mysql — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/cimg/mysql" title="cimg/mysql Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/cimg/mysql</a>

# CircleCI 便利镜像：MySQL  

专为 CircleCI 设计的 MySQL Docker 镜像，专注于持续集成场景  


## 状态与链接  
[![CircleCI 构建状态]([])]([])  
[![软件许可证：MIT]([])]([])  
[![Docker 拉取量]([])]([])  
[![CircleCI 社区讨论]([])]([])  
[![GitHub 仓库]([])]([])  


> **注意**：本镜像旨在替代旧版 CircleCI MySQL 镜像 `circleci/mysql`。  


`cimg/mysql` 是由 CircleCI 开发的 Docker 镜像，专为持续集成构建流程设计。  


## 支持政策  
CircleCI  Docker 便利镜像的支持政策可参考 [CircleCI 文档]([])。该政策明确了镜像的发布、更新及弃用规则。  


## 目录  
- [快速开始](#快速开始)  
- [镜像工作原理](#镜像工作原理)  
- [开发指南](#开发指南)  
- [贡献方式](#贡献方式)  
- [补充资源](#补充资源)  
- [许可证](#许可证)  


## 快速开始  
本镜像可作为次要镜像，与 CircleCI `docker` 执行器配合使用。示例如下：  

```yaml
jobs:
  build:
    docker:
      - image: cimg/go:1.17  # 主容器：CircleCI Go 镜像
      - image: cimg/mysql:8.0  # 次要容器：MySQL 镜像
    steps:
      - checkout  # 检出代码
```  

上述示例中，主容器使用 CircleCI Go 镜像，次要容器使用 MySQL 镜像（标签 `8.0` 对应 MySQL 8.0 版本）。在任务步骤中，可从主容器连接到 MySQL 实例。  


## 镜像工作原理  
本镜像包含完整的 MySQL 数据库及其工具链。  


### 关于 RAM 变体  
旧版镜像 `circleci/mysql` 提供过 RAM 优化变体，但当前版本已移除。我们正在评估该变体的实际性能提升效果，若您使用过旧版镜像并能提供 RAM 变体与普通变体的构建时间对比数据，欢迎通过 GitHub Issue 反馈。  


### 标签规则  
镜像标签格式如下：  
```
cimg/mysql:<mysql-version>
```  
其中 `<mysql-version>` 为 MySQL 版本号（如 `8.0` 对应 MySQL 8.0）。  


## 开发指南  
本地构建和运行镜像需满足以下条件：  
- 操作系统：Linux（已测试 Ubuntu）或 macOS  
- Bash 版本：v4+  
- Docker Engine 版本：v19.03+  


### 克隆仓库  
#### 社区用户（无仓库写入权限）  
1. 在 GitHub 上 Fork 本仓库。  
2. 克隆时需添加 `--recurse-submodules` 参数以拉取子模块：  
   ```bash
   git clone --recurse-submodules <您的 Fork 仓库地址>
   ```  
3. （若已克隆但未拉取子模块）可运行以下命令补全：  
   ```bash
   git submodule update --recursive
   ```  
4. （可选）添加上游仓库以便同步更新：  
   ```bash
   git remote add upstream []   ```  


#### 维护者（有仓库写入权限）  
直接克隆仓库并拉取子模块：  
```bash
git clone --recurse-submodules [邮箱已删除]:CircleCI-Public/cimg-mysql.git
```  


### 生成 Dockerfile  
使用 `gen-dockerfiles.sh` 脚本生成指定版本的 Dockerfile。例如，生成 MySQL 8.0 的 Dockerfile：  
```bash
./shared/gen-dockerfiles.sh 8.0
```  
生成的文件位于 `./8.0/Dockerfile`。  


### 本地构建与运行  
生成 Dockerfile 后，可本地构建并测试镜像：  
```bash
# 构建镜像
docker build -t test/mysql:8.0 -f 8.0/Dockerfile .

# 运行容器并进入交互终端
docker run -it test/mysql:8.0 bash
```  


### 批量构建镜像  
使用 `build-images.sh` 脚本批量构建镜像（需先生成 Dockerfile）：  
```bash
./build-images.sh
```  
正式发布时，此脚本将通过 CircleCI 流水线执行，而非本地运行。  


### 发布官方镜像（仅维护者）  
使用 `release.sh` 脚本简化发布流程。以发布 MySQL 9.99（示例版本）为例：  
```bash
./shared/release.sh 9.99
```  
该脚本会自动完成以下操作：  
- 创建新分支  
- 生成 Dockerfile  
- 提交变更并推送到 GitHub（提交信息以 `[release]` 结尾，用于触发 CircleCI 镜像推送流程）  

后续步骤：  
1. 等待 CircleCI 构建完成并通过检查。  
2. 审核并合并 PR。  
3. 主分支构建将自动发布镜像到 Docker Hub。  


### 整合变更  
变更来源不同，整合方式也不同：  

#### 构建脚本变更  
`./shared` 子模块的变更需在 [独立仓库]([]) 中进行。若需同步到本镜像，需更新子模块：  
```bash
cd shared
git pull  # 拉取子模块更新
cd ..
git add shared
git commit -m "更新子模块以支持 xxx 功能"
```  


#### 父镜像变更  
为保证构建确定性，父镜像变更不会自动同步到现有 MySQL 镜像中。新版本 MySQL 镜像会自动继承父镜像更新。若需将父镜像变更同步到现有 MySQL 镜像，需按新版本流程重新构建并发布。  


#### MySQL 镜像专属变更  
修改本仓库的 `Dockerfile.template` 文件可定制 MySQL 镜像。修改后需重新生成 Dockerfile 以生效（参考「生成 Dockerfile」步骤）。  


## 贡献方式  
欢迎通过 [Issue]([]) 反馈问题或提交 [Pull Request]([])。贡献前建议阅读 [贡献指南](.github/CONTRIBUTING.md)，了解最佳实践及团队协作规范。  


## 补充资源  
- [CircleCI 官方文档]([])：完整的 CircleCI 使用指南。  
- [CircleCI 配置参考]([])：详细说明 `.circleci/config.yml` 支持的所有配置项。  
- [Docker 官方文档]([])：深入学习 Docker 的基础资源。  


## 许可证  
本仓库采用 MIT 许可证，详情见 [LICENSE 文件](./LICENSE)。

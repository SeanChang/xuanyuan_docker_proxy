---
image: rustfs/rustfs
description: "这是一款高性能分布式对象存储系统，作为MinIO的替代方案，适用于大规模数据存储场景，具备高扩展性、高可靠性与高效数据处理能力，采用Apache 2.0开源许可协议，支持免费使用、商用部署及二次开发，为用户提供灵活且经济的分布式存储解决方案。"
source: https://xuanyuan.cloud/zh/r/rustfs/rustfs
canonical: https://xuanyuan.cloud/zh/r/rustfs/rustfs
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rustfs/rustfs" title="rustfs/rustfs Docker 镜像中文简介、标签列表与拉取命令">rustfs/rustfs — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rustfs/rustfs" title="rustfs/rustfs Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rustfs/rustfs</a>

# RustFS 介绍


## 项目概述  
RustFS 是一款基于 Rust 开发的高性能分布式对象存储软件。它具备与 MinIO 类似的核心特性，包括部署简易、S3 协议兼容、开源免费，以及对数据湖、AI 和大数据场景的原生支持。同时，RustFS 采用 Apache 2.0 许可证，对商业用户更友好；依托 Rust 语言的内存安全与高效特性，进一步提升了存储性能和分布式环境下的稳定性。


> ⚠️ **注意**：RustFS 目前处于快速开发阶段，**请勿用于生产环境**。


## 核心特性  
- **高性能**：基于 Rust 构建，兼顾运行速度与资源效率。  
- **分布式架构**：支持横向扩展与容错设计，适配大规模部署需求。  
- **S3 兼容**：无缝对接现有 S3 生态工具与应用。  
- **数据湖优化**：针对大数据分析、AI 训练等场景深度调优。  
- **开源透明**：采用 Apache 2.0 许可证，社区可自由贡献与审计。  
- **易用性**：简化部署与管理流程，降低技术门槛。  


## 核心优势  
与同类对象存储软件相比，RustFS 主要特点如下：  
- **开发语言**：基于 Rust 开发，避免 Go/C 语言可能存在的内存 GC 或泄漏问题，内存安全性更优。  
- **许可证友好**：Apache 2.0 许可证对商业场景无特殊限制，规避 AGPL 等协议可能带来的开源协议风险。  
- **本地化支持**：日志存储本地化，不向第三方传输；兼容国内外主流云厂商的 S3 服务。  
- **硬件适配**：对边缘网关、安全创新设备等场景支持更完善。  
- **成本可控**：社区版完全免费，商业版定价透明，无高额许可费用。  


## 快速部署指南  
以下三种方式任选其一，快速启动 RustFS：  


### 方式一：一键安装脚本（推荐新手）  
```bash
curl -O [] && bash install_rustfs.sh
```


### 方式二：Docker 快速启动  
```bash
# 稳定版（最新发布）
docker run -d -p 9000:9000 -v /data:/data rustfs/rustfs:latest

# 开发版（主分支快照）
docker run -d -p 9000:9000 -v /data:/data rustfs/rustfs:main-latest

# 指定版本（如 v1.0.0）
docker run -d -p 9000:9000 -v /data:/data rustfs/rustfs:v1.0.0
```


### 方式三：源码构建（高级用户）  
如需从源码构建多架构 Docker 镜像，执行以下脚本：  
```bash
# 本地构建多架构镜像
./docker-buildx.sh --build-arg RELEASE=latest

# 构建并推送到镜像仓库
./docker-buildx.sh --push

# 构建指定版本
./docker-buildx.sh --release v1.0.0 --push

# 自定义仓库地址
./docker-buildx.sh --registry your-registry.com --namespace yourname --push
```  
也可通过 Make 命令简化操作：  
```bash
make docker-buildx          # 本地构建
make docker-buildx-push     # 构建并推送
make docker-buildx-version VERSION=v1.0.0  # 构建指定版本
make help-docker            # 查看所有 Docker 相关命令
```


## 基本使用  
启动后，通过浏览器访问 `[] 打开管理控制台，默认账号密码为 `rustfsadmin`。可直接通过控制台创建存储桶、上传文件，或使用 S3 客户端工具（如 `awscli`、`rclone`）进行操作。


## 文档与支持  
- **详细文档**：访问 [RustFS 文档中心]([]) 获取配置说明、API 手册及高级用法。  
- **社区支持**：  
  - 常见问题：查看 [FAQ]([])；  
  - 交流讨论：参与 [GitHub Discussions]([])；  
  - 问题反馈：通过 [GitHub Issues]([]) 提交 bug 或建议。  


## 许可证  
RustFS 基于 **Apache 2.0 许可证** 开源，欢迎社区贡献代码或反馈。项目开发状态可通过 GitHub 提交记录、CI/CD 构建状态等指标查看。  

（*注：项目仍在快速迭代，生产环境使用前请评估稳定性。*）

---
image: triliumnext/notes
description: "使用TriliumNext Notes构建个人知识库"
source: https://xuanyuan.cloud/zh/r/triliumnext/notes
canonical: https://xuanyuan.cloud/zh/r/triliumnext/notes
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/triliumnext/notes" title="triliumnext/notes Docker 镜像中文简介、标签列表与拉取命令">triliumnext/notes 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TriliumNext 镜像文档

## 镜像概述和主要用途

TriliumNext 是一款个人知识库管理工具，最初为原始 Trilium 仓库（`zadam/trilium`）的分支项目。后经原作者转让，当前开发与维护工作在 [https://github.com/TriliumNext/Trilium](https://github.com/TriliumNext/Trilium) 持续进行。该 Docker 镜像提供便捷部署方式，帮助用户快速搭建功能完善的个人知识库系统，实现信息的结构化存储、组织与管理。

## 核心功能和特性

- **项目延续性**：继承原始 Trilium 的成熟功能体系，并持续接收更新与优化
- **个人知识库构建**：支持层级化笔记管理、富文本编辑、标签分类、关联链接等核心知识组织功能
- **数据持久化**：通过本地存储机制确保知识库数据安全，支持数据备份与迁移
- **跨平台兼容**：基于 Docker 容器化部署，可在 Linux、Windows、macOS 等主流操作系统运行

## 使用场景和适用范围

- **个人知识管理**：适用于学生、研究者、知识工作者等需要系统化整理学习笔记、研究资料、创意灵感的个人用户
- **内容创作辅助**：帮助博主、作者等组织文章素材、写作大纲及参考资料
- **学术资料管理**：支持文献摘要、实验数据、课程笔记等学术内容的结构化存储与快速检索
- **轻量信息协作**：可通过网络配置实现小型团队内部知识库共享（主要面向个人使用，协作功能需参考官方文档）

## 使用方法和配置说明

### Docker 快速启动

通过 `docker run` 命令启动容器，需挂载数据卷以持久化存储知识库数据：

```bash
docker run -d \
  --name trilium-next \
  -p 8080:8080 \
  -v /path/to/local/data:/root/trilium-data \
  docker.xuanyuan.run/triliumnext/trilium:latest
```

**参数说明**：
- `-d`：后台运行容器
- `--name trilium-next`：指定容器名称（可自定义）
- `-p 8080:8080`：端口映射（主机端口:容器端口，容器默认使用 8080 端口）
- `-v /path/to/local/data:/root/trilium-data`：数据卷挂载，`/path/to/local/data` 替换为本地存储路径，`/root/trilium-data` 为容器内数据目录

### Docker Compose 配置

创建 `docker-compose.yml` 文件简化部署：

```yaml
version: '3'
services:
  trilium-next:
    image: docker.xuanyuan.run/triliumnext/trilium:latest
    container_name: trilium-next
    ports:
      - "8080:8080"  # 端口映射，可修改主机端口（如 8081:8080）
    volumes:
      - /path/to/local/data:/root/trilium-data  # 本地数据目录映射
    restart: unless-stopped  # 容器退出时自动重启（除非手动停止）
```

启动服务：
```bash
docker-compose up -d
```

### 访问与初始化

容器启动后，通过浏览器访问 `http://<主机IP>:8080`（替换 `<主机IP>` 为部署设备的 IP 地址）即可进入 TriliumNext 界面。首次使用需完成管理员账户创建，随后可开始构建和管理知识库。

## 数据管理与维护

- **数据备份**：定期备份挂载目录 `/path/to/local/data` 下的文件，避免数据丢失
- **版本更新**：更新镜像时，先停止旧容器（`docker stop trilium-next`），拉取最新镜像（`docker pull docker.xuanyuan.run/triliumnext/trilium:latest`），再重新启动容器（数据卷挂载正确时，数据不会丢失）
- **端口修改**：如需使用非 8080 端口，修改 `-p` 参数的主机端口部分（如 `-p 8081:8080` 映射至主机 8081 端口）

## 官方资源

- 项目仓库：[https://github.com/TriliumNext/Trilium](https://github.com/TriliumNext/Trilium)
- 详细文档：参考项目仓库的 `README.md` 或 `docs` 目录获取完整功能说明与高级配置指南

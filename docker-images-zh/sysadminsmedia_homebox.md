---
image: sysadminsmedia/homebox
description: "Homebox是专为家庭用户打造的库存与组织系统。"
source: https://xuanyuan.cloud/zh/r/sysadminsmedia/homebox
canonical: https://xuanyuan.cloud/zh/r/sysadminsmedia/homebox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sysadminsmedia/homebox" title="sysadminsmedia/homebox Docker 镜像中文简介、标签列表与拉取命令">sysadminsmedia/homebox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述
Homebox是一款专为家庭用户设计的库存与组织系统，旨在帮助用户高效管理家庭物品、跟踪库存状态并实现个人物品的有序组织。该系统注重易用性和实用性，适合非技术背景的家庭用户快速上手。

## 特性
- **用户友好界面**：简洁直观的操作界面，无需专业知识即可轻松使用。
- **本地数据存储**：支持数据本地保存，保护家庭隐私，避免云端数据泄露风险。
- **自定义分类**：可根据家庭需求创建自定义物品分类和标签，灵活适配不同管理场景。
- **跨设备访问**：通过本地网络支持多设备访问，方便家庭成员共同管理。

## 使用场景
- **家庭物品管理**：整理和跟踪工具、厨房用具、家用电器等家庭常用物品。
- **个人收藏盘点**：管理书籍、影音制品、收藏品等个人物品的库存信息。
- **家庭库存监控**：记录食品、日用品等消耗品的库存量，及时提醒补充。

## Docker部署示例
### 前提条件
- 已安装Docker引擎。

### 部署步骤
1. **拉取镜像**
   从Docker镜像仓库拉取Homebox最新镜像：
   ```bash
docker pull ***-ghcr.xuanyuan.run/homeboxapp/homebox:latest
   ```

2. **运行容器**
   使用以下命令启动Homebox容器，挂载数据卷以持久化存储，并映射端口供本地访问：
   ```bash
docker run -d \
  --name homebox \
  -p 8080:80 \
  -v /path/to/homebox/data:/app/data \
  --restart unless-stopped \
  ***-ghcr.xuanyuan.run/homeboxapp/homebox:latest
   ```
   - `-p 8080:80`：将容器内80端口映射到主机8080端口，通过`http://localhost:8080`访问系统。
   - `-v /path/to/homebox/data:/app/data`：挂载主机目录到容器内数据目录，确保物品数据持久化。
   - `--restart unless-stopped`：容器退出时自动重启（除非手动停止）。

3. **访问系统**
   容器启动后，在浏览器中访问 `http://localhost:8080` 即可打开Homebox系统界面，完成初始设置后开始使用。

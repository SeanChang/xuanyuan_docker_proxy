---
image: ginuerzh/qwerty-learner
description: "qwerty-learner是一个开源的Web打字练习应用，支持多语言、多种键盘布局，提供实时打字统计和进度跟踪功能，帮助用户提升打字速度和准确性。"
source: https://xuanyuan.cloud/zh/r/ginuerzh/qwerty-learner
canonical: https://xuanyuan.cloud/zh/r/ginuerzh/qwerty-learner
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ginuerzh/qwerty-learner" title="ginuerzh/qwerty-learner Docker 镜像中文简介、标签列表与拉取命令">ginuerzh/qwerty-learner — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ginuerzh/qwerty-learner" title="ginuerzh/qwerty-learner Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ginuerzh/qwerty-learner</a>

# qwerty-learner Docker镜像文档

## 镜像概述
qwerty-learner是一个基于Web的开源打字练习应用，旨在通过交互式练习帮助用户提升打字速度和准确性。该应用支持多种语言、键盘布局，提供实时数据统计和学习进度跟踪，适用于打字初学者、程序员、日常办公用户等各类需要提升打字效率的人群。

## 核心功能与特性
- **多语言支持**：涵盖英语、中文（拼音/五笔）、日语等多种语言的打字练习内容
- **多键盘布局适配**：支持QWERTY、Dvorak、Colemak等主流键盘布局，可按需切换
- **实时打字统计**：实时显示打字速度（WPM/CPM）、准确率、错误字符等关键数据
- **学习进度跟踪**：记录历史练习数据，生成学习曲线，可视化展示进步情况
- **自定义练习内容**：支持导入文本内容或选择特定主题（如代码、文章片段）进行专项练习
- **响应式设计**：适配桌面端和移动端浏览器，随时随地进行练习

## 使用场景
- **打字初学者**：系统学习键盘布局，从基础开始提升打字速度
- **程序员/开发者**：通过代码片段练习，提升编程时的代码输入效率
- **办公人员**：针对文档、邮件等日常文本进行练习，优化办公效率
- **语言学习者**：结合目标语言文本练习，同时提升语言熟练度和打字能力
- **盲打训练**：通过隐藏键盘提示功能，强化盲打习惯养成

## 使用方法与配置说明

### 前提条件
- 已安装Docker Engine（20.10+推荐）
- 已安装Docker Compose（可选，用于多容器管理）

### 快速部署（Docker Run）
通过以下命令快速启动容器：
```bash
docker run -d \
  --name qwerty-learner \
  -p 8080:80 \  # 映射容器80端口到主机8080端口（可自定义主机端口）
  -v ./custom-content:/app/public/custom \  # （可选）挂载自定义练习内容目录
  --restart unless-stopped \
  realkai42/qwerty-learner:latest
```
启动后，在浏览器中访问 `http://localhost:8080` 即可使用应用。

### Docker Compose 部署（推荐）
创建 `docker-compose.yml` 文件，配置如下：
```yaml
version: '3.8'
services:
  qwerty-learner:
    image: realkai42/qwerty-learner:latest
    container_name: qwerty-learner
    ports:
      - "8080:80"  # 主机端口:容器端口（可修改主机端口，如8888:80）
    volumes:
      - ./custom-content:/app/public/custom  # 自定义练习内容挂载（可选）
    restart: unless-stopped
```
执行以下命令启动服务：
```bash
docker-compose up -d
```

### 访问应用
容器启动后，通过浏览器访问 `http://<主机IP>:8080`（将 `<主机IP>` 替换为部署主机的IP地址，本地部署直接使用 `localhost`）。

### 环境变量配置
支持通过环境变量自定义应用行为，配置方式：在 `docker run` 或 `docker-compose.yml` 中添加 `-e 变量名=值`。常用变量如下：
- `PORT`: 容器内部服务端口（默认：80，修改需同步调整端口映射）
- `CUSTOM_CONTENT_PATH`: 自定义练习内容目录（默认：`/app/public/custom`，需配合 volumes 挂载使用）
- `DEFAULT_LANGUAGE`: 默认语言（可选值：`en`/`zh`/`ja`，默认：`en`）
- `DEFAULT_LAYOUT`: 默认键盘布局（可选值：`qwerty`/`dvorak`/`colemak`，默认：`qwerty`）

### 自定义练习内容
1. 在主机创建自定义内容目录（如 `./custom-content`）
2. 按以下格式添加文本文件（支持 `.txt` 格式）：
   - 文件名格式：`[语言]-[主题].txt`（如 `zh-essay.txt` 表示中文文章主题）
   - 文件内容：每行一段文本，作为练习素材
3. 启动容器时通过 `-v` 参数挂载目录，应用将自动识别并展示自定义内容

### 数据持久化
应用学习进度数据默认存储在浏览器本地存储（LocalStorage），如需多设备同步，需通过外部服务（如云存储）手动导出/导入进度文件（路径：应用设置 → 导出进度）。

## 常见问题
- **端口冲突**：若主机8080端口被占用，修改 `-p` 参数中的主机端口（如 `-p 8888:80`）
- **自定义内容不显示**：检查文件命名格式是否正确，确保挂载路径与 `CUSTOM_CONTENT_PATH` 一致
- **中文显示乱码**：确保自定义文本文件编码为 UTF-8

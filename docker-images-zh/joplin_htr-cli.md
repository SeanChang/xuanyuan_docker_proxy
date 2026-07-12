---
image: joplin/htr-cli
description: "Joplin手写文本识别命令行工具，用于识别Joplin笔记中的手写内容，支持将手写文本转换为可编辑文本，方便用户管理和编辑手写笔记。"
source: https://xuanyuan.cloud/zh/r/joplin/htr-cli
canonical: https://xuanyuan.cloud/zh/r/joplin/htr-cli
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/joplin/htr-cli" title="joplin/htr-cli Docker 镜像中文简介、标签列表与拉取命令">joplin/htr-cli 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Joplin手写文本识别CLI镜像

## 概述
Joplin手写文本识别CLI镜像是一个专为Joplin笔记应用设计的Docker化命令行工具，提供手写文本识别功能。该镜像旨在帮助用户将Joplin笔记中的手写内容转换为可编辑文本，解决手写笔记难以搜索和编辑的问题，提升笔记管理效率。

## 核心功能
- **手写文本识别**：采用OCR技术识别手写文本，支持多种手写风格及常见语言
- **Joplin集成**：无缝对接Joplin笔记系统，可直接读取和处理Joplin中的手写笔记
- **命令行操作**：通过简洁的命令行指令完成识别任务，支持脚本化批量处理
- **多格式输出**：识别结果支持输出为纯文本(TXT)、Markdown等多种可编辑格式
- **轻量部署**：Docker容器化设计，无需复杂依赖配置，快速部署使用

## 使用场景
- **个人笔记管理**：将纸质手写笔记拍照导入Joplin后，转换为可编辑文本
- **学术研究**：处理包含手写批注的PDF笔记，提取批注内容进行整理
- **批量处理**：对历史手写笔记库进行批量识别，构建可搜索的文本笔记库
- **移动笔记同步**：配合Joplin移动端，识别手机拍摄的手写内容并同步为文本笔记

## 使用方法

### 前提条件
- 已安装Docker Engine（20.10+版本）
- 已安装Joplin桌面版/服务器版，并启用Web Clipper API服务
- Joplin中已存储包含手写内容的笔记（图片格式）

### 获取镜像
从Docker仓库拉取最新镜像：
```bash
docker pull docker.xuanyuan.run/joplin-handwriting-ocr-cli:latest
```

### 基本使用示例

#### 1. 识别本地手写图片
将本地手写图片文件识别为文本：
```bash
docker run --rm \
  -v /本地图片目录:/input \
  -v /输出目录:/output \
  docker.xuanyuan.run/joplin-handwriting-ocr-cli:latest \
  recognize /input/handwriting_note.jpg \
  --output /output/result.txt \
  --language zh-CN
```

#### 2. 识别Joplin中的手写笔记
通过Joplin API直接识别指定笔记中的手写内容：
```bash
docker run --rm \
  -e JOPLIN_API_TOKEN="your_joplin_api_token" \
  -e JOPLIN_BASE_URL="http://host.docker.internal:41184" \
  docker.xuanyuan.run/joplin-handwriting-ocr-cli:latest \
  joplin-recognize \
  --note-id "your_note_id" \
  --update-note \
  --language en
```

## 配置说明

### 环境变量
| 变量名              | 说明                          | 默认值                  |
|---------------------|-------------------------------|-------------------------|
| JOPLIN_API_TOKEN    | Joplin API访问令牌            | 无（必填，用于Joplin交互） |
| JOPLIN_BASE_URL     | Joplin API服务地址            | http://localhost:41184  |
| OCR_LANGUAGE        | 默认识别语言                  | en（英语）              |
| LOG_LEVEL           | 日志级别（debug/info/warn/error） | info                |

### 命令行参数

#### `recognize` 命令（本地文件识别）
用于识别本地手写图片文件，基本语法：
```bash
docker run --rm [参数] recognize <输入路径> [选项]
```

选项说明：
- `--output <路径>`：指定识别结果输出路径（必填）
- `--language <语言代码>`：指定识别语言（如zh-CN、en、ja）
- `--format <格式>`：输出格式，支持txt、md（默认txt）
- `--dpi <数值>`：图片DPI值，影响识别精度（默认300）

#### `joplin-recognize` 命令（Joplin笔记识别）
用于直接处理Joplin中的手写笔记，基本语法：
```bash
docker run --rm [环境变量] joplin-recognize [选项]
```

选项说明：
- `--note-id <ID>`：Joplin笔记ID（必填）
- `--update-note`：将识别结果追加到原笔记末尾
- `--output <路径>`：同时输出结果到本地文件
- `--language <语言代码>`：指定识别语言（覆盖环境变量）

## 部署示例（docker-compose）
创建`docker-compose.yml`文件，配置批量处理环境：
```yaml
version: '3'
services:
  joplin-ocr:
    image: docker.xuanyuan.run/joplin-handwriting-ocr-cli:latest
    environment:
      - JOPLIN_API_TOKEN=your_api_token_here
      - JOPLIN_BASE_URL=http://host.docker.internal:41184
      - OCR_LANGUAGE=zh-CN
    volumes:
      - ./input:/app/input
      - ./output:/app/output
    command: sh -c "for file in /app/input/*.jpg; do recognize \$file --output /app/output/\$(basename \$file .jpg).txt; done"
```

启动批量处理：
```bash
docker-compose up
```

## 注意事项
- Joplin需开启Web Clipper服务（设置 > Web Clipper > 启用服务）
- 手写图片建议分辨率不低于300dpi，文字区域对比度适中
- 多语言识别需指定对应语言代码（如中日混合可使用zh-CN+ja）
- 首次运行可能需要下载语言模型（约100-300MB，取决于语言）

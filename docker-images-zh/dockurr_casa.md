---
image: dockurr/casa
description: "Docker容器化的CasaOS，无需在系统上直接安装即可运行的自托管操作系统。"
source: https://xuanyuan.cloud/zh/r/dockurr/casa
canonical: https://xuanyuan.cloud/zh/r/dockurr/casa
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dockurr/casa" title="dockurr/casa Docker 镜像中文简介、标签列表与拉取命令">dockurr/casa 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CasaOS Docker容器

CasaOS的Docker容器化版本，这是一个用于自托管的操作系统。

## 功能 ✨

* 无需在系统上直接安装即可运行CasaOS！

## 使用方法 🐳

### 通过Docker Compose：

```yaml
services:
  casa:
    image: docker.xuanyuan.run/dockurr/casa
    container_name: casa
    ports:
      - 8080:8080
    volumes:
      - ./casa:/DATA
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
    stop_grace_period: 1m
```

### 通过Docker CLI：

```bash
docker run -it --rm --name casa -p 8080:8080 -v "${PWD:-.}/casa:/DATA" -v "/var/run/docker.sock:/var/run/docker.sock" --stop-timeout 60 docker.io/dockurr/casa
```

### 通过GitHub Codespaces：

[![在GitHub Codespaces中打开](https://github.com/codespaces/badge.svg)](https://codespaces.new/dockur/casa)

## 截图 📸

<div align="center">
<a href="https://github.com/dockur/casa"><img src="https://raw.githubusercontent.com/dockur/casa/master/.github/screen.png" title="截图" style="max-width:100%;" width="256" /></a>
</div>

## 常见问题 💬

### 如何更改存储位置？

要更改存储位置，请在您的compose文件中包含以下绑定挂载：

```yaml
volumes:
  - ./casa:/DATA
```

将示例路径`./casa`替换为您想要的存储文件夹或命名卷。

## 致谢 🙏

特别感谢[@worph](https://github.com/worph)，本项目的实现离不开他宝贵的工作。

## 星标 🌟
[![Stars](https://starchart.cc/dockur/casa.svg?variant=adaptive)](https://starchart.cc/dockur/casa)

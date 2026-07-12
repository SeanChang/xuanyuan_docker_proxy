---
image: dockage/mailcatcher
description: "MailCatcher Docker镜像，运行一个简单的SMTP服务器，可捕获所有发送的邮件并在Web界面中显示。"
source: https://xuanyuan.cloud/zh/r/dockage/mailcatcher
canonical: https://xuanyuan.cloud/zh/r/dockage/mailcatcher
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dockage/mailcatcher" title="dockage/mailcatcher Docker 镜像中文简介、标签列表与拉取命令">dockage/mailcatcher 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MailCatcher

MailCatcher运行一个超简单的SMTP服务器，可捕获发送给它的所有邮件并在Web界面中显示。

## 安装

推荐通过Dockerhub获取自动构建的镜像：

```bash
docker pull docker.xuanyuan.run/dockage/mailcatcher:0.9.0
```

或者也可以本地构建镜像：

```bash
docker build --tag="$USER/mailcatcher" github.com/dockage/mailcatcher
```

## 快速开始

### 使用docker-compose（推荐）

```bash
wget https://raw.githubusercontent.com/dockage/mailcatcher/master/docker-compose.yml
docker-compose up
```

### 手动启动容器

```bash
docker run --name='mailcatcher' -d \
  --publish=1080:1080 \
  --publish=1025:1025 \
docker.xuanyuan.run/dockage/mailcatcher:0.9.0
```

## 快速参考

* 获取帮助：[官网](https://dockage.dev/)、[文档](https://dockage.dev/docs/)
* GitHub仓库：[dockage/mailcatcher](https://github.com/dockage/mailcatcher)
* 问题反馈：[GitHub issues](https://github.com/dockage/mailcatcher/issues)
* 维护者：Dockage团队（info@dockage.dev）
* 许可证：[license](https://github.com/dockage/mailcatcher/blob/main/LICENSE)，第三方组件许可证请参阅其文档

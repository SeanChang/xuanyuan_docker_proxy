---
image: elestio/uptime-kuma
description: "Uptime-Kuma是由Elestio验证并打包的开源监控工具，支持通过HTTP/S、TCP、DNS等协议监控服务状态。"
source: https://xuanyuan.cloud/zh/r/elestio/uptime-kuma
canonical: https://xuanyuan.cloud/zh/r/elestio/uptime-kuma
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elestio/uptime-kuma" title="elestio/uptime-kuma Docker 镜像中文简介、标签列表与拉取命令">elestio/uptime-kuma 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "通过我们的聊天功能获得即时帮助，并与社区和团队进行实时讨论。")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "查看所有存储库的源代码。")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "关于elestio、开源软件和DevOps技术的最新消息。")

# Uptime-Kuma，由Elestio验证并打包

[uptime-kuma](https://github.com/louislam/uptime-kuma) 是一款开源监控工具，能够通过HTTP/S、TCP、DNS及其他协议监控服务状态。

<img src="https://github.com/elestio-examples/uptime-kuma/blob/master/uptime-kuma.png?raw=true" alt="uptime-kuma" width="800">

如果您需要一个能够创建简单易用的监控仪表板来监控服务器、应用程序和服务状态的优秀解决方案，可在elestio上部署<a target="_blank" href="https://elest.io/open-source/uptime-kuma">完全托管的uptime-kuma</a>。

[![deploy](https://github.com/elestio-examples/uptime-kuma/raw/master/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/uptime-kuma)

# 为何使用Elestio镜像？

- Elestio与原始源代码的更新保持同步，并通过自动化流程快速发布此镜像的新版本。
- Elestio镜像提供对最新错误修复和功能的及时访问。
- 我们的团队执行质量控制检查，确保发布的产品符合我们的高标准。

# 使用方法

## Git克隆

您可以通过以下命令轻松部署：

    git clone https://github.com/elestio-examples/uptime-kuma.git

将测试文件夹中的.env文件复制到项目目录

    cp ./tests/.env ./.env

编辑.env文件并填入您自己的值。

创建具有正确权限的数据文件夹

    mkdir -p ./data;
    chown -R 1001:1001 ./data;

    apt install apache2-utils sqlite3 -y

使用以下命令运行项目

    docker-compose up -d

您可以通过 `http://your-domain:13001` 访问Web界面。

## Docker-compose

以下是一些帮助您开始创建容器的示例代码片段。

    version: '3.3'

    services:
    uptime-kuma:
        image: elestio/uptime-kuma:${SOFTWARE_VERSION_TAG}
        restart: always
        healthcheck:
        disable: true
        volumes:
        - ./data:/app/data
        ports:
        - '172.17.0.1:13001:3001'

### 环境变量

|       变量        |    值（示例）    |
| :---------------: | :-------------: |
|    ADMIN_EMAIL    | admin@gmail.com |
|   ADMIN_PASSWORD  |  your-password  |
| SOFTWARE_VERSION_TAG |     latest      |

# 维护

## 日志

Elestio uptime-kuma Docker镜像将容器日志发送到stdout。要查看日志，可使用以下命令：

    docker-compose logs -f

停止堆栈可使用以下命令：

    docker-compose down

## 使用Docker Compose进行备份与恢复

为简化备份和恢复操作，我们使用文件夹卷挂载。您只需使用docker-compose down停止堆栈，然后备份docker-compose.yml文件所在文件夹中的所有文件和子文件夹即可。

### 创建ZIP归档

例如，若要创建ZIP归档，请导航至包含docker-compose.yml文件的文件夹，并使用以下命令：

    zip -r myarchive.zip .

### 从ZIP归档恢复

要从ZIP归档恢复，请使用以下命令将归档解压缩到原始文件夹：

    unzip myarchive.zip -d /path/to/original/folder

### 启动堆栈

备份完成后，可使用以下命令再次启动堆栈：

    docker-compose up -d

就是这样！通过这些简单步骤，您可以使用Docker Compose轻松备份和恢复数据卷。

# 链接

- <a target="_blank" href="https://github.com/louislam/uptime-kuma.git">uptime-kuma GitHub仓库</a>

- <a target="_blank" href="https://docs.theme-park.dev/themes/uptime-kuma/">uptime-kuma文档</a>

- <a target="_blank" href="https://github.com/elestio-examples/uptime-kuma">Elestio/uptime-kuma GitHub仓库</a>

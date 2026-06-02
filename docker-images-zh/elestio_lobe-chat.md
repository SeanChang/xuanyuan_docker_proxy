<!-- xuanyuan-docker-images-zh
image: elestio/lobe-chat
source: https://xuanyuan.cloud/zh/r/elestio/lobe-chat
canonical: https://xuanyuan.cloud/zh/r/elestio/lobe-chat
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/elestio/lobe-chat" title="elestio/lobe-chat Docker 镜像中文简介、标签列表与拉取命令">elestio/lobe-chat — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/elestio/lobe-chat" title="elestio/lobe-chat Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/elestio/lobe-chat</a></p>

# Lobe Chat，由Elestio验证和打包

[Lobe Chat](https://chat-preview.lobehub.com/chat) - 一款开源、高性能的AI聊天框架。支持一键免费部署您的私人ChatGPT/Gemini/本地LLM应用。

如果您需要自动化备份、带SSL终止的反向代理、防火墙、自动化操作系统和软件更新，以及由Linux专家和开源爱好者组成的团队确保您的服务始终安全可用，可在<a target="_blank" href="https://elest.io/">elest.io</a>上部署<a target="_blank" href="https://elest.io/open-source/lobechat">完全托管的Lobe Chat</a>。

# 为何使用Elestio镜像？

- Elestio与原始源代码的更新保持同步，并通过自动化流程快速发布此镜像的新版本。
- Elestio镜像提供对最新错误修复和功能的及时访问。
- 我们的团队执行质量控制检查，确保发布的产品符合高标准。

# 使用方法

## Docker-compose

以下是帮助您开始创建容器的示例代码片段。

```yaml
version: "3.8"

services:
    lobe-chat:
        image: elestio/lobe-chat:latest
        restart: always
        ports:
            - "172.17.0.1:57392:3210"
        environment:
            OPENAI_API_KEY: ${OPENAI_API_KEY}
            ACCESS_CODE: ${ADMIN_PASSWORD}
```

### 环境变量

|       变量名        |      示例值       |
| :-----------------: | :---------------: |
| SOFTWARE_VERSION_TAG |      latest       |
|    ADMIN_PASSWORD    |   your-password   |
|        DOMAIN        |    your.domain    |
|    OPENAI_API_KEY    | your-openai-api-key |

## 访问方式

您可以通过以下地址访问Web界面：`http://your-domain:57392`

# 维护

## 日志

Elestio Lobe Chat Docker镜像将容器日志发送到stdout。要查看日志，可使用以下命令：

```bash
docker-compose logs -f
```

停止服务栈可使用以下命令：

```bash
docker-compose down
```

## 使用Docker Compose进行备份和恢复

为简化备份和恢复操作，我们使用文件夹卷挂载。您只需使用docker-compose down停止服务栈，然后备份docker-compose.yml文件所在文件夹中的所有文件和子文件夹。

### 创建ZIP归档

例如，若要创建ZIP归档，请导航到包含docker-compose.yml文件的文件夹并使用以下命令：

```bash
zip -r myarchive.zip .
```

### 从ZIP归档恢复

要从ZIP归档恢复，使用以下命令将归档解压缩到原始文件夹：

```bash
unzip myarchive.zip -d /path/to/original/folder
```

### 启动服务栈

备份完成后，可使用以下命令再次启动服务栈：

```bash
docker-compose up -d
```

通过这些简单步骤，您可以轻松使用Docker Compose备份和恢复数据卷。

# 链接

- <a target="_blank" href="https://github.com/lobehub/lobe-chat">Lobe Chat GitHub仓库</a>

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/elestio/lobe-chat" title="elestio/lobe-chat Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/elestio/lobe-chat</a></p>

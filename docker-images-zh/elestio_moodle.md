---
image: elestio/moodle
description: "Elestio验证和打包的Moodle镜像，提供开源学习管理系统(LMS)，支持在线课程交付、学生管理和虚拟课堂，适用于各种规模的教育和培训场景，具备灵活定制和丰富功能特性。"
source: https://xuanyuan.cloud/zh/r/elestio/moodle
canonical: https://xuanyuan.cloud/zh/r/elestio/moodle
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elestio/moodle" title="elestio/moodle Docker 镜像中文简介、标签列表与拉取命令">elestio/moodle 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Elestio验证和打包的Moodle

[Moodle](https://github.com/moodle/moodle) 是全球领先的开源学习平台。它是一个灵活、可定制且功能丰富的学习管理系统(LMS)，被全球教育工作者、培训师和组织广泛信任，用于交付在线课程、管理学生和运行各种规模的虚拟课堂。

如果您需要自动化备份、带SSL终止的反向代理、防火墙、自动化操作系统和软件更新，以及由Linux专家和开源爱好者组成的团队确保服务始终安全可用，可在<a target="_blank" href="https://elest.io/">elest.io</a>上部署<a target="_blank" href="https://elest.io/open-source/moodle">完全托管的Moodle</a>。

# 为什么使用Elestio镜像？

- Elestio与原始源代码的更新保持同步，并通过自动化流程快速发布此镜像的新版本。
- Elestio镜像提供对最新错误修复和功能的及时访问。
- 我们的团队执行质量控制检查，确保发布的产品符合高标准。

# 使用方法

## Docker-compose

以下是帮助您开始创建容器的示例代码片段。

```yaml
version: '3.3'
services:

  mariadb:
    image: docker.xuanyuan.run/mariadb:10.11
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
      MARIADB_USER: ${MARIADB_USER}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
      MARIADB_DATABASE: ${MARIADB_DATABASE}
    volumes:
      - ./mariadb_data:/var/lib/mysql

  moodle:
    image: docker.xuanyuan.run/elestio/moodle:${SOFTWARE_VERSION_TAG}
    restart: always
    environment:
      MOODLE_DATABASE_TYPE: mariadb
      MOODLE_DATABASE_HOST: mariadb
      MOODLE_DATABASE_PORT_NUMBER: 3306
      MOODLE_DATABASE_NAME: ${MARIADB_DATABASE}
      MOODLE_DATABASE_USER: ${MARIADB_USER}
      MOODLE_DATABASE_PASSWORD: ${MARIADB_PASSWORD}
      MOODLE_USERNAME: ${MOODLE_USERNAME}
      MOODLE_PASSWORD: ${MOODLE_PASSWORD}
      MOODLE_EMAIL: ${MOODLE_EMAIL}
      MOODLE_SITE_NAME: Moodle
      MOODLE_HOST: https://${DOMAIN}
    volumes:
      - ./moodledata:/var/moodledata
    ports:
      - "172.17.0.1:8080:80"
    depends_on:
      - mariadb
```

### 环境变量

| 变量名               | 示例值                  |
| :------------------- | :---------------------- |
| SOFTWARE_VERSION_TAG | latest                  |
| MARIADB_ROOT_PASSWORD | your-password           |
| MARIADB_USER         | moodle                  |
| MARIADB_PASSWORD     | your-password           |
| MARIADB_DATABASE     | moodle                  |
| MOODLE_USERNAME      | admin                   |
| MOODLE_PASSWORD      | your-password           |
| MOODLE_EMAIL         | admin@example.com       |
| MOODLE_HOST          | https://your.domain.tld |

# 维护

## 日志

Elestio Moodle Docker镜像将容器日志发送到stdout。要查看日志，可使用以下命令：

```bash
docker-compose logs -f
```

要停止服务栈，可使用以下命令：

```bash
docker-compose down
```

## 使用Docker Compose进行备份和恢复

为简化备份和恢复操作，我们使用文件夹卷挂载。您只需使用`docker-compose down`停止服务栈，然后备份`docker-compose.yml`文件所在目录中的所有文件和子文件夹。

### 创建ZIP归档

例如，若要创建ZIP归档，请导航到包含`docker-compose.yml`文件的目录，使用以下命令：

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

- <a target="_blank" href="https://github.com/moodle/moodle">Moodle GitHub仓库</a>
- <a target="_blank" href="https://docs.moodle.org/">Moodle文档</a>

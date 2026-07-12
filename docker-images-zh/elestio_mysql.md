---
image: elestio/mysql
description: "由Elestio验证和打包的MySQL"
source: https://xuanyuan.cloud/zh/r/elestio/mysql
canonical: https://xuanyuan.cloud/zh/r/elestio/mysql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elestio/mysql" title="elestio/mysql Docker 镜像中文简介、标签列表与拉取命令">elestio/mysql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MySQL，由Elestio验证和打包

[MySQL](https://www.mysql.com/) 是一个开源的关系型数据库管理系统（RDBMS）。世界上许多大型组织依靠它为其高流量网站、业务关键系统和打包软件提供支持。它几乎可以在所有平台上运行，包括Linux、UNIX和Windows。

如果您需要自动备份、带SSL终止的反向代理、防火墙、自动操作系统和软件更新，以及由Linux专家和开源爱好者组成的团队确保您的服务始终安全且正常运行，可在<a target="_blank" href="https://elest.io/">elest.io</a>上部署<a target="_blank" href="https://elest.io/open-source/mysql">完全托管的MySQL</a>。

# 为什么使用Elestio镜像？

- Elestio与原始源代码的更新保持同步，并通过我们的自动化流程快速发布此镜像的新版本。
- Elestio镜像提供对最新错误修复和功能的及时访问。
- 我们的团队执行质量控制检查，确保我们发布的产品符合高标准。

# 使用方法

## Docker-compose

以下是一些示例代码片段，帮助您开始创建容器。

```yaml
version: "3"
services:
mysql:
    image: docker.xuanyuan.run/elestio/mysql:${SOFTWARE_VERSION_TAG}
    restart: always
    command: mysqld --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --max_connections=1000 --gtid-mode=ON --enforce-gtid-consistency=ON
    environment:
        MYSQL_ROOT_PASSWORD: ${SOFTWARE_PASSWORD}
    ports:
        - 172.17.0.1:3306:3306
    volumes:
        - ./data:/var/lib/mysql

pma:
    image: docker.xuanyuan.run/phpmyadmin
    restart: always
    links:
        - mysql:mysql
    ports:
        - "172.17.0.1:24581:80"
    environment:
        PMA_HOST: mysql
        PMA_PORT: 3306
        PMA_USER: root
        PMA_PASSWORD: ${SOFTWARE_PASSWORD}
        UPLOAD_LIMIT: 500M
        MYSQL_USERNAME: root
        MYSQL_ROOT_PASSWORD: ${SOFTWARE_PASSWORD}
    depends_on:
        - mysql
```

### 环境变量

| 变量名               | 示例值          |
| :------------------- | :-------------- |
| SOFTWARE_PASSWORD    | your-password   |
| SOFTWARE_VERSION_TAG | "8.0 or latest" |

## 访问方式

您可以通过以下地址访问Web UI：`http://your-domain:24581`

# 维护

## 日志

Elestio MySQL Docker镜像将容器日志发送到stdout。要查看日志，可使用以下命令：

```bash
docker-compose logs -f
```

要停止堆栈，可使用以下命令：

```bash
docker-compose down
```

## 使用Docker Compose进行备份和恢复

为了简化备份和恢复操作，我们使用文件夹卷挂载。您只需使用docker-compose down停止堆栈，然后备份docker-compose.yml文件所在文件夹中的所有文件和子文件夹。

### 创建ZIP归档

例如，如果您想创建ZIP归档，请导航到包含docker-compose.yml文件的文件夹，并使用以下命令：

```bash
zip -r myarchive.zip .
```

### 从ZIP归档恢复

要从ZIP归档恢复，请使用以下命令将归档解压缩到原始文件夹：

```bash
unzip myarchive.zip -d /path/to/original/folder
```

### 启动堆栈

备份完成后，您可以使用以下命令再次启动堆栈：

```bash
docker-compose up -d
```

就是这样！通过这些简单步骤，您可以使用Docker Compose轻松备份和恢复数据卷。

# 链接

- <a target="_blank" href="https://dev.mysql.com/doc/">MySQL文档</a>
- <a target="_blank" href="https://github.com/docker-library/mysql">MySQL Github仓库</a>
- <a target="_blank" href="https://github.com/elestio-examples/mysql">Elestio/mysql Github仓库</a>

<!-- xuanyuan-docker-images-zh
image: elestio/postgres
source: https://xuanyuan.cloud/zh/r/elestio/postgres
canonical: https://xuanyuan.cloud/zh/r/elestio/postgres
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/elestio/postgres" title="elestio/postgres Docker 镜像中文简介、标签列表与拉取命令">elestio/postgres — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/elestio/postgres" title="elestio/postgres Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/elestio/postgres</a></p>

# Postgres，由Elestio验证和打包

[Postgres](https://github.com/postgres/postgres) 是一款高级对象关系型数据库管理系统，支持SQL标准的扩展子集，包括事务、外键、子查询、触发器、用户定义类型和函数。此发行版还包含C语言绑定。

如果您需要自动化备份、带SSL终止的反向代理、防火墙、自动化操作系统和软件更新，以及由Linux专家和开源爱好者组成的团队确保服务始终安全可用，可在<a target="_blank" href="https://elest.io/">elest.io</a>上部署<a target="_blank" href="https://elest.io/open-source/postgresql">完全托管的Postgres</a>。

[![deploy](https://cf.appdrag.com/dashboard-openvm-clo-b2d42c/uploads/deploy-on-elestio-eMJS.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/postgres)

# 为什么使用Elestio镜像？

- Elestio与原始源的更新保持同步，并通过自动化流程快速发布此镜像的新版本。
- Elestio镜像提供对最新错误修复和功能的及时访问。
- 我们的团队执行质量控制检查，确保发布的产品符合高标准。

# 用法

## Docker-compose

以下是帮助您开始创建容器的示例代码片段。

```yaml
version: '3.4'
services:
    postgres:
        image: elestio/postgres:${SOFTWARE_VERSION_TAG}
        restart: always
        environment:
            POSTGRES_DB: postgres
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: ${SOFTWARE_PASSWORD}
            PGDATA: /var/lib/postgresql/data
        volumes:
            - ./data:/var/lib/postgresql/data
        ports:
            - "172.17.0.1:5432:5432"
```

### 环境变量

| 变量名               | 示例值           |
| :------------------- | :--------------- |
| SOFTWARE_VERSION_TAG | latest           |
| SOFTWARE_PASSWORD    | your-password    |

# 维护

## 日志

Elestio Postgres Docker镜像将容器日志发送到stdout。要查看日志，可使用以下命令：

```bash
docker-compose logs -f
```

要停止堆栈，可使用以下命令：

```bash
docker-compose down
```

## 使用Docker Compose进行备份和恢复

为简化备份和恢复操作，我们使用文件夹卷挂载。您只需使用`docker-compose down`停止堆栈，然后备份`docker-compose.yml`文件所在目录中的所有文件和子文件夹。

### 创建ZIP归档

例如，若要创建ZIP归档，请导航到包含`docker-compose.yml`文件的目录，并使用以下命令：

```bash
zip -r myarchive.zip .
```

### 从ZIP归档恢复

要从ZIP归档恢复，请使用以下命令将归档解压到原始目录：

```bash
unzip myarchive.zip -d /path/to/original/folder
```

### 启动堆栈

备份完成后，可使用以下命令重新启动堆栈：

```bash
docker-compose up -d
```

通过这些简单步骤，您可以轻松使用Docker Compose备份和恢复数据卷。

# 链接

- <a target="_blank" href="https://github.com/postgres/postgres">Postgres GitHub仓库</a>

- <a target="_blank" href="https://www.postgresql.org/docs/">Postgres文档</a>

- <a target="_blank" href="https://github.com/elestio-examples/postgres">Elestio/postgres GitHub仓库</a>

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/elestio/postgres" title="elestio/postgres Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/elestio/postgres</a></p>

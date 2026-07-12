---
image: atlassian/fisheye
description: "Fisheye：跨SVN、Git和Perforce仓库进行搜索、监控和跟踪。"
source: https://xuanyuan.cloud/zh/r/atlassian/fisheye
canonical: https://xuanyuan.cloud/zh/r/atlassian/fisheye
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/fisheye" title="atlassian/fisheye Docker 镜像中文简介、标签列表与拉取命令">atlassian/fisheye 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Fisheye
跨CVS、SVN、Git、Mercurial和Perforce仓库进行搜索、监控和跟踪。

# Crucible
通过同行代码审查发现错误并提高代码质量。

## 概述
此Docker容器可轻松启动和运行Fisheye或Crucible实例。注意：示例中将以Fisheye为例进行说明。

## 快速启动
运行以下命令：

    docker run -d -p 8080:8080 docker.xuanyuan.run/atlassian/fisheye
应用将在http://localhost:8080可用，配置向导将引导您完成设置。

## 配置
要通过环境变量配置Fisheye，需设置：`FISHEYE_OPTS=-Dfecru.configure.from.env.variables=true`，并使用以下变量：
* `FECRU_CONFIGURE_LICENSE_FISHEYE`
* `FECRU_CONFIGURE_LICENSE_CRUCIBLE`
* `FECRU_CONFIGURE_ADMIN_PASSWORD`
* `FECRU_CONFIGURE_DB_TYPE`
* `FECRU_CONFIGURE_DB_HOST`
* `FECRU_CONFIGURE_DB_PORT`
* `FECRU_CONFIGURE_DB_NAME`
* `FECRU_CONFIGURE_DB_USER`
* `FECRU_CONFIGURE_DB_PASSWORD`
* `FECRU_CONFIGURE_DB_MIN_POOL_SIZE`
* `FECRU_CONFIGURE_DB_MAX_POOL_SIZE`

一个最小化的compose文件示例如下：
```
version: '2'
services:
  fecru:
    image: docker.xuanyuan.run/atlassian/fisheye:4.8.3
    ports:
    - "8080:8080"
    environment:
      - 'FISHEYE_OPTS=-Dfecru.configure.from.env.variables=true'
      # 许可证
      - 'FECRU_CONFIGURE_LICENSE_FISHEYE=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
      - 'FECRU_CONFIGURE_LICENSE_CRUCIBLE=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                                          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
      # 管理员密码
      - 'FECRU_CONFIGURE_ADMIN_PASSWORD=password'
      # 数据库
      - 'FECRU_CONFIGURE_DB_TYPE=postgresql'
      - 'FECRU_CONFIGURE_DB_HOST=db'
      - 'FECRU_CONFIGURE_DB_PORT=5432'
      - 'FECRU_CONFIGURE_DB_USER=postgres'
      - 'FECRU_CONFIGURE_DB_PASSWORD=password'
  db:
    image: docker.xuanyuan.run/postgres:11
    ports:
    - "5432:5432"
    environment:
    - "POSTGRES_USER=postgres"
    - "POSTGRES_PASSWORD=password"

```

您还可以使用以下标志挂载Fisheye实例目录：
```
-v /my_instance_folder:/atlassian/data/fisheye
```

（如果使用Crucible镜像，则为`atlassian/data/crucible`）。

注意：由于许可限制，Fisheye不随附MySQL或Oracle JDBC驱动程序。要使用这些数据库，您需要将合适的驱动程序复制到容器中并重启。例如，要将MySQL驱动程序复制到名为“fisheye”的容器中，可执行以下命令：

```
docker cp mysql-connector-java.x.y.z.jar fisheye:/atlassian/data/fisheye/lib/
docker restart fisheye
```

（对应Crucible则为`/atlassian/data/crucible/lib/`）

## 版本控制
`latest`标签对应Atlassian Fisheye或Crucible的最新版本。因此，`atlassian/fisheye:latest`将使用最新版本的Fisheye。

您也可以使用特定的主版本、主.次版本或主.次.补丁版本标签来指定Fisheye版本：
* atlassian/fisheye:4
* atlassian/fisheye:4.8
* atlassian/fisheye:4.8.3
* atlassian/crucible:4
* atlassian/crucible:4.8
* atlassian/crucible:4.8.3

所有4.8.3及以上版本均可用。

## 支持
如需产品支持，请访问：
* https://support.atlassian.com/fisheye/
* https://support.atlassian.com/crucible/

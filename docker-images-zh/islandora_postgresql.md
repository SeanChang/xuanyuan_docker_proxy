---
image: islandora/postgresql
description: "开源关系型数据库。"
source: https://xuanyuan.cloud/zh/r/islandora/postgresql
canonical: https://xuanyuan.cloud/zh/r/islandora/postgresql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/islandora/postgresql" title="islandora/postgresql Docker 镜像中文简介、标签列表与拉取命令">islandora/postgresql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PostgreSQL

PostgreSQL Docker镜像，对应[PostgreSQL]版本16.3。基于[Islandora-DevOps/isle-buildkit postgresql](https://github.com/Islandora-DevOps/isle-buildkit/tree/main/postgresql)构建。更多深入信息请参考[PostgreSQL文档]。

快速示例：启动PostgreSQL实例，并允许以`root`用户通过客户端登录。

```bash
docker run --rm -d --name postgresql docker.xuanyuan.run/islandora/postgresql
docker exec -ti postgresql psql -U root postgres
```

## 依赖

构建需要`islandora/base` Docker镜像。更多信息请参考[基础镜像README](./base)。

## 端口

| 端口 | 描述                 |
| :--- | :------------------- |
| 5432 | PostgreSQL客户端端口 |

## 设置

### 数据库设置

有关默认数据库连接配置的更多信息，请参见[基础镜像]中的文档。

| 环境变量               | 默认值 | 描述                                                                 |
| :--------------------- | :----- | :------------------------------------------------------------------- |
| POSTGRESQL_ROOT_USER   |        | 数据库root用户密码。默认为`DB_ROOT_PASSWORD`                         |
| POSTGRESQL_ROOT_PASSWORD |        | 数据库root用户（用于创建站点数据库）。默认为`DB_ROOT_USER`           |

[base image]: ../base/README.md
[PostgreSQL Documentation]: https://www.postgresql.org/docs/
[PostgreSQL]: https://www.postgresql.org/

---
image: lthub/moodle
description: "Moodle是一款免费开源的学习管理系统"
source: https://xuanyuan.cloud/zh/r/lthub/moodle
canonical: https://xuanyuan.cloud/zh/r/lthub/moodle
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lthub/moodle" title="lthub/moodle Docker 镜像中文简介、标签列表与拉取命令">lthub/moodle 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述
Moodle是一款免费开源的学习管理系统（LMS），该Docker镜像提供了Moodle的便捷部署方式，适用于教育机构、企业培训等场景，支持课程管理、用户管理、在线学习等功能。

## 已知问题
* 当使用NFS共享卷作为`/moodledata`目录时，可能会出现`session data file is not created by your uid`错误。这是由于NFS挂载的用户ID（UID）映射与本地用户ID不一致导致的。解决方法：使用Redis会话存储。
* 默认情况下，应用缓存使用文件存储，速度较慢。建议配置Redis作为应用缓存：通过“站点管理”->“插件”->“缓存”->“配置”路径，在“Redis”行下点击“添加实例”进行设置。

## Docker部署方案示例
以下是使用Docker Compose部署Moodle的基本示例：

```yaml
version: '3'
services:
  db:
    image: docker.xuanyuan.run/mariadb:10.6
    volumes:
      - db_data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=example_root_password
      - MYSQL_DATABASE=moodle
      - MYSQL_USER=moodleuser
      - MYSQL_PASSWORD=moodlepassword
    restart: always

  moodle:
    image: docker.xuanyuan.run/moodle
    depends_on:
      - db
    ports:
      - "80:80"
    volumes:
      - moodle_data:/var/www/html/moodledata
      - ./moodle_html:/var/www/html
    environment:
      - MOODLE_DB_HOST=db
      - MOODLE_DB_NAME=moodle
      - MOODLE_DB_USER=moodleuser
      - MOODLE_DB_PASSWORD=moodlepassword
    restart: always

volumes:
  db_data:
  moodle_data:
```

**说明**：该示例使用MariaDB作为数据库，挂载`moodle_data`卷存储`/moodledata`，并将Moodle服务暴露在80端口。根据实际需求调整环境变量和端口映射。

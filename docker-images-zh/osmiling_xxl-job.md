---
image: osmiling/xxl-job
description: "xxl-job分布式定时任务调度中心Docker镜像，包含调度中心(admin)，需配合外部MySQL数据库使用，用于分布式环境下的定时任务管理与调度。"
source: https://xuanyuan.cloud/zh/r/osmiling/xxl-job
canonical: https://xuanyuan.cloud/zh/r/osmiling/xxl-job
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/osmiling/xxl-job" title="osmiling/xxl-job Docker 镜像中文简介、标签列表与拉取命令">osmiling/xxl-job — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/osmiling/xxl-job" title="osmiling/xxl-job Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/osmiling/xxl-job</a>

# xxl-job 分布式定时任务调度中心 Docker 镜像文档

## 快速参考

- 开源代码地址：**[github](https://github.com/xuxueli/xxl-job)**  **[gitee](http://gitee.com/xuxueli0323/xxl-job)**
- 代码维护者：**xuxueli**
- 中文文档地址：**[中文文档](https://www.xuxueli.com/xxl-job/)**
- Docker镜像维护：https://github.com/loulangogogo/docker-hub
- 提交问题：**[有问题](https://github.com/loulangogogo/docker-hub/issues)**
- 提交功能改进：**[功能改进](https://github.com/loulangogogo/docker-hub/issues)**

> **注：本镜像只包含了 admin（调度中心），executor执行器可以根据源代码启动测试，或在自己的项目中编写。**

> **【本Docker镜像来自GitHub开源代码，如有侵权请联系作者删除。】**


## 初始化一个实例

该镜像依赖外部 MySQL 数据库，需先创建库表。可参考官方文档创建，或查看 [xxl-job.sql（注意选择版本）](https://github.com/xuxueli/xxl-job/blob/3.3.1-release/doc/db/tables_xxl_job.sql)。

### Docker 启动

```bash
docker run --name xxl-job -e DB_HOST=127.0.0.1 -e DB_PORT=3306 -e DB_USER=root -e DB_NAME=xxl_job -e DB_PASSWORD=root -p 8080:8080 osmiling/xxl-job:tag
```

### Docker Compose 配置

```yaml
version: '3.1'

services:
  xxl-job:
    image: osmiling/xxl-job:3.3.1
    container_name: xxl-job
    logging:
      driver: json-file
      options:
        max-size: "100m"
        max-file: "5"
    restart: always
    ports:
      - "8080:8080"
    environment:
      DB_HOST: 127.0.0.1
      DB_PORT: 3306
      DB_NAME: xxl_job
      DB_USER: root
      DB_PASSWORD: root
    volumes:
        - /etc/localtime:/etc/localtime # 将宿主机时间挂载到容器内部，权限只读
        - ./logs:/data/applogs/xxl-job # 将日志文件挂载到宿主机
```


## 环境变量

| 变量              | 说明                                                     | 默认值                              | 版本  |
|-------------------|----------------------------------------------------------|-------------------------------------|-------|
| SERVER_PORT       | 端口设置                                                 | 8080                                | 2.4.1 |
| SERVER_PATH       | 应用上下文路径                                           | /xxl-job-admin                      | 2.4.1 |
| DB_HOST           | MySQL 主机 IP                                            | 127.0.0.1                           | 2.4.1 |
| DB_PORT           | MySQL 端口                                               | 3306                                | 2.4.1 |
| DB_USER           | MySQL 用户名                                             | root                                | 2.4.1 |
| DB_NAME           | MySQL 数据库名称                                         | xxl-job                             | 2.4.2 |
| DB_PASSWORD       | MySQL 密码                                               | 123456                              | 2.4.1 |
| MAIL_HOST         | 邮箱 SMTP 服务器（如 smtp.qq.com）                       | smtp.163.com                        | 2.4.1 |
| MAIL_PORT         | 邮箱 SMTP 端口                                           | 25                                  | 2.4.1 |
| MAIL_USER         | 邮箱登录名                                               | your_email@163.com                  | 2.4.1 |
| MAIL_PASSWORD     | 邮箱授权码                                               | xxx                                 | 2.4.1 |
| MAIL_FROM         | 发件人邮箱地址                                           | your_password_or_authorization_code | 2.4.1 |
| JOB_ACCESS_TOKEN  | xxl-job 访问令牌                                         | default_token                       | 2.4.1 |
| JOB_TIMEOUT       | 调度中心向执行器发起 HTTP 回调时的连接读取超时时间（秒） | 5                                   | 3.3.0 |
| JOB_FAST_POOL_MAX | 快速线程池最大值                                         | 300                                 | 3.3.0 |
| JOB_SLOW_POOL_MAX | 慢速线程池最大值                                         | 200                                 | 3.3.0 |
| JOB_LOG_DAYS      | 日志保留天数                                             | 30                                  | 3.3.0 |

**注意：环境变量对应项目中的 application.properties 配置项。**

> **若环境变量无法满足配置需求，可自行映射 application.properties 文件启动。**

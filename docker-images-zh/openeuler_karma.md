---
image: openeuler/karma
description: "Karma官方Docker镜像，基于openEuler构建，是Prometheus Alertmanager的告警仪表盘，弥补Alertmanager UI在仪表盘功能上的不足，提供告警浏览和静默管理等功能。"
source: https://xuanyuan.cloud/zh/r/openeuler/karma
canonical: https://xuanyuan.cloud/zh/r/openeuler/karma
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/karma" title="openeuler/karma Docker 镜像中文简介、标签列表与拉取命令">openeuler/karma 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 快速参考

- Karma官方Docker镜像。

- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)。

- 获取帮助：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler](https://gitee.com/openeuler/community)。

# karma | openEuler
当前的karma Docker镜像基于[openEuler](https://repo.openeuler.org/)构建。本仓库可免费使用，且不受每用户速率限制。

Karma是Prometheus Alertmanager的告警仪表盘。Alertmanager UI虽有助于浏览告警和管理静默规则，但作为仪表盘工具存在不足——karma旨在填补这一空白。

更多信息请访问[karma官网](https://karma-dashboard.io)。

# 支持的标签及对应Dockerfile链接
每个karma Docker镜像的标签由karma版本和基础镜像版本组成，详情如下：

| 标签 | 当前信息 | 架构 |
|--|--|--|
|[0.120-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/karma/0.120/24.03-lts/Dockerfile)| 基于openEuler 24.03-LTS的Karma 0.120 | amd64、arm64 |

# 使用方法

- 本地启动镜像：

  ```bash
  docker run -d --name my-karma -p 8080:8080 docker.xuanyuan.run/openeuler/karma:0.120-oe2403lts
  ```
  实例`my-karma`启动后，可通过`http://localhost:8080`访问Karma实例。

- 参数说明：

  | 参数 | 描述 |
  |--|--|
  | `-p 8080:8080` | 将Karma暴露在`localhost:8080`。 |

- 调试容器：

  ```bash
  docker logs -f my-karma
  ```

- 获取交互式shell：

  ```bash
  docker exec -it my-karma /bin/bash
  ```

# 问答
如遇问题或需使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

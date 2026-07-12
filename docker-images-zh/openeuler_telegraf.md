---
image: openeuler/telegraf
description: "基于openEuler的官方Telegraf Docker镜像，是轻量级服务器代理，用于收集、处理、聚合和写入来自数据库、系统及IoT传感器的指标，Go编写，单二进制文件，内存占用极低。"
source: https://xuanyuan.cloud/zh/r/openeuler/telegraf
canonical: https://xuanyuan.cloud/zh/r/openeuler/telegraf
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/telegraf" title="openeuler/telegraf Docker 镜像中文简介、标签列表与拉取命令">openeuler/telegraf 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 快速参考

- 官方Telegraf Docker镜像。

- 维护者者：[openEuler CloudNative SIG](](https://gitee.com/openeuler/cloudnative)

- 获取帮助：：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler](https://gitee.com.com/openeuler/community)。

# Telegraf | openEuler
当前Telegraf Docker镜像基于[openEuler](https://repo.openeuler.org/)构建。本仓库可免费使用，且无每用户速率限制。

Teleraf是一款基于服务器的代理，用于从数据库、系统和IoT传感器收集并发送指标与事件。采用Go语言编写，编译为单个二进制文件，无外部依赖，内存占用极小。

更多信息请访问[Telegraf官网](https://docs.influxdata.com/telegraf/v1/)。

# 支持的标签及对应Dockerfile链接
每个`telegraf` Docker镜像的标签由`telegraf`版本和基础镜像版本组成，详情如下：

| 标签 | 当前版本 | 架构 |
|------|----------|------|
|[1.36.3-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.36.3/24.03-lts-sp2/Dockerfile) | openEuler 24.03-LTS-SP2上的telegraf 1.36.3 | amd64, arm64 |
|[1.36.2-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.36.2/24.03-lts-sp2/Dockerfile) | openEuler 24.03-LTS-SP2上的telegraf 1.36.2 | amd64, arm64 |
|[1.36.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.36.1/24.03-lts-sp2/Dockerfile) | openEuler 24.03-LTS-SP2上的telegraf 1.36.1 | amd64, arm64 |
|[1.35.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.35.4/24.03-lts-sp1/Dockerfile) | openEuler 24.03-LTS-SP1上的telegraf 1.35.4 | amd64, arm64 |
|[1.29.5-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.29.5/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Telegraf 1.29.5 | amd64, arm64 |
|[1.31.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.31.1/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Telegraf 1.31.1 | amd64, arm64 |
|[1.32.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.0/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Telegraf 1.32.0 | amd64, arm64 |
|[1.32.1-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/20.03-lts-sp4/Dockerfile)| openEuler 20.03-LTS-SP4上的Telegraf 1.32.1 | amd64, arm64 |
|[1.32.1-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/22.03-lts-sp1/Dockerfile)| openEuler 22.03-LTS-SP1上的Telegraf 1.32.1 | amd64, arm64 |
|[1.32.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Telegraf 1.32.1 | amd64, arm64 |
|[1.32.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/22.03-lts-sp4/Dockerfile)| openEuler 22.03-LTS-SP4上的Telegraf 1.32.1 | amd64, arm64 |
|[1.32.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.1/24.03-lts/Dockerfile)| openEuler 24.03-LTS上的Telegraf 1.32.1 | amd64, arm64 |
|[1.32.2-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/22.03-lts-sp1/Dockerfile)| openEuler 22.03-LTS-SP1上的Telegraf 1.32.2 | amd64, arm64 |
|[1.32.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/22.03-lts-sp3/Dockerfile)| openEuler 22.03-LTS-SP3上的Telegraf 1.32.2 | amd64, arm64 |
|[1.32.2-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/22.03-lts-sp4/Dockerfile)| openEuler 22.03-LTS-SP4上的Telegraf 1.32.2 | amd64, arm64 |
|[1.32.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/telegraf/1.32.2/24.03-lts/Dockerfile)| openEuler 24.03-LTS上的Telegraf 1.32.2 | amd64, arm64 |

# 使用方法
用户可根据需求选择相应的`{Tag}`和容器启动选项。

- 从Docker拉取`openeuler/telegraf`镜像

  ```bash
  docker pull docker.xuanyuan.run/openeuler/telegraf:{Tag}
  ```

- 启动Telegraf实例

  ```bash
  docker run -d --name my-telegraf -p 8094:8094 -v /path/to/telegraf.conf:/etc/telegraf/telegraf.conf docker.xuanyuan.run/openeuler/telegraf:{Tag}
  ```
  实例`my-telegraf`启动后，可通过`http://localhost:8094`访问Telegraf服务。

- 容器启动选项

  | 选项 | 说明 |
  |------|------|
  | `-p 8094:8094` | 将Telegraf暴露在`localhost:8094`。 |
  | `-v /path/to/telegraf.conf:/etc/telegraf/telegraf.conf` | 本地[配置文件](https://docs.influxdata.com/telegraf/v1/) `telegraf.conf`。 |

- 查看容器运行日志

  ```bash
  docker logs -f my-telegraf
  ```

- 获取交互式shell

  ```bash
  docker exec -it my-telegraf /bin/bash
  ```

# 问答
如有任何问题或需使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

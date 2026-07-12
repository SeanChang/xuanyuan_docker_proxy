---
image: library/fluentd
description: "Fluentd是一个用于统一日志层的开源数据收集器"
source: https://xuanyuan.cloud/zh/r/library/fluentd
canonical: https://xuanyuan.cloud/zh/r/library/fluentd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/fluentd" title="library/fluentd Docker 镜像中文简介、标签列表与拉取命令">library/fluentd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 快速参考

- **维护者**：  
  [Fluentd](https://github.com/fluent/fluentd-docker-image)

- **获取帮助的途径**：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的 `Dockerfile` 链接

- [`v1.16.9-1.0`, `v1.16-1`](https://github.com/fluent/fluentd-docker-image/blob/505a1af75b4a4adb40d576df7b18cebab853264e/v1.16/alpine/Dockerfile)

- [`v1.16.9-debian-1.0`, `v1.16-debian-1`](https://github.com/fluent/fluentd-docker-image/blob/505a1af75b4a4adb40d576df7b18cebab853264e/v1.16/debian/Dockerfile)

- [`v1.19.0-debian-1.0`, `v1.19-debian-1`, `v1.19.0-1.0`, `v1.19-1`, `latest`](https://github.com/fluent/fluentd-docker-image/blob/42a0afa30b3821482bce1ba8e67266d745619724/v1.19/debian/Dockerfile)

# 快速参考（续）

- **问题提交地址**：  
  [https://github.com/fluent/fluentd-docker-image/issues](https://github.com/fluent/fluentd-docker-image/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/fluentd/), [`arm32v5`](https://hub.docker.com/r/arm32v5/fluentd/), [`arm32v6`](https://hub.docker.com/r/arm32v6/fluentd/), [`arm32v7`](https://hub.docker.com/r/arm32v7/fluentd/), [`arm64v8`](https://hub.docker.com/r/arm64v8/fluentd/), [`i386`](https://hub.docker.com/r/i386/fluentd/), [`ppc64le`](https://hub.docker.com/r/ppc64le/fluentd/), [`s390x`](https://hub.docker.com/r/s390x/fluentd/)

- **已发布镜像制品详情**：  
  [repo-info仓库的fluentd目录](https://github.com/docker-library/repo-info/blob/master/repos/fluentd) ([历史记录](https://github.com/docker-library/repo-info/commits/master/repos/fluentd))  
 （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的library/fluentd标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Ffluentd)  
  [official-images仓库的library/fluentd文件](https://github.com/docker-library/official-images/blob/master/library/fluentd) ([历史记录](https://github.com/docker-library/official-images/commits/master/library/fluentd))

- **本描述的来源**：  
  [docs仓库的fluentd目录](https://github.com/docker-library/docs/tree/master/fluentd) ([历史记录](https://github.com/docker-library/docs/commits/master/fluentd))

# 什么是Fluentd？

![logo](https://raw.githubusercontent.com/docker-library/docs/23d5a64f3f38c1cad2557ded3d3d16388d9239cb/fluentd/logo.png)

Fluentd是由[CNCF](https://www.cncf.io/project-faq/fluentd/)托管的用于统一日志层的流式数据收集器。Fluentd允许您统一数据收集和消费，以便更好地使用和理解数据。

更多信息，请查看[官方网站](https://www.fluentd.org/)和[文档网站](https://docs.fluentd.org/)。

# 如何运行镜像

```bash
$ docker run -p 24224:24224 -p 24224:24224/udp -u fluent -v /path/to/dir:/fluentd/log fluentd
2019-01-16 11:49:55 +0000 [info]: 配置文件解析成功 path="/fluentd/etc/fluent.conf"
...
2019-01-16 11:58:27 +0000 [info]: #0 [input1] 监听端口 port=24224 bind="0.0.0.0"
2019-01-16 11:58:27 +0000 [info]: #0 fluentd工作进程已启动 worker = 0
```

Docker官方镜像仅支持v1.4.2及更高版本。如需了解更多详情，请查看[fluentd-docker-image README](https://github.com/fluent/fluentd-docker-image/blob/master/README.md)。

# 许可证

查看[许可证信息](https://github.com/fluent/fluentd/blob/master/LICENSE)以了解本镜像中包含的软件的许可证。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可证（例如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

一些能够自动检测到的额外许可证信息可能位于[repo-info仓库的fluentd目录](https://github.com/docker-library/repo-info/tree/master/repos/fluentd)中。

至于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用都符合其中包含的所有软件的相关许可证要求。

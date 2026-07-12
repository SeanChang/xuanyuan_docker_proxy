---
image: zabbix/zabbix-build-base
description: "Zabbix构建基础环境"
source: https://xuanyuan.cloud/zh/r/zabbix/zabbix-build-base
canonical: https://xuanyuan.cloud/zh/r/zabbix/zabbix-build-base
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zabbix/zabbix-build-base" title="zabbix/zabbix-build-base Docker 镜像中文简介、标签列表与拉取命令">zabbix/zabbix-build-base 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

## 什么是Zabbix？

Zabbix是企业级开源分布式监控解决方案。Zabbix能够监控网络的众多参数以及服务器的健康状态和完整性。它采用灵活的通知机制，允许用户为几乎任何事件配置基于电子邮件的告警，从而实现对服务器问题的快速响应。Zabbix基于存储的数据提供出色的报告和数据可视化功能，使其成为容量规划的理想选择。有关Zabbix组件的更多信息和相关下载，请访问https://hub.docker.com/u/zabbix/ 和 https://zabbix.com。

## 什么是Zabbix build base？

Zabbix build base镜像是为构建Zabbix组件准备的构建环境。它包含所有必需的软件包、二进制文件和工具。

## Zabbix build base镜像

这些是唯一的官方Zabbix build base Docker镜像。它们基于Alpine Linux v3.22、Ubuntu 24.04（noble）、CentOS Stream 10和Oracle Linux 10镜像构建。可用的镜像版本如下：

- Zabbix build base 6.0（标签：alpine-6.0-latest、ubuntu-6.0-latest、ol-6.0-latest）
- Zabbix build base 6.0.*（标签：alpine-6.0.*、ubuntu-6.0.*、ol-6.0.*）
- Zabbix build base 7.0（标签：alpine-7.0-latest、ubuntu-7.0-latest、ol-7.0-latest）
- Zabbix build base 7.0.*（标签：alpine-7.0.*、ubuntu-7.0.*、ol-7.0.*、ltsc2019-7.0.*、ltsc2022-7.0.*）
- Zabbix build base 7.2（标签：alpine-7.2-latest、ubuntu-7.2-latest、ol-7.2-latest）
- Zabbix build base 7.2.*（标签：alpine-7.2.*、ubuntu-7.2.*、ol-7.2.*、ltsc2019-7.2.*、ltsc2022-7.2.*）
- Zabbix build base 7.4（标签：alpine-7.4-latest、ubuntu-7.4-latest、ol-7.4-latest、alpine-latest、ubuntu-latest、ol-latest、latest）
- Zabbix build base 7.4.*（标签：alpine-7.4.*、ubuntu-7.4.*、ol-7.4.*、ltsc2019-7.4.*、ltsc2022-7.4.*）
- Zabbix build base 8.0（标签：alpine-trunk、ubuntu-trunk、ol-trunk、ltsc2019-trunk、ltsc2022-trunk）

镜像会在新版本发布时更新。带有`latest`标签的镜像基于Alpine Linux。

## 如何使用此镜像

该镜像用于构建Zabbix组件，是[MySQL](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/build-mysql)、[PostgreSQL](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/build-pgsql)和[SQLite3](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/build-sqlite3)基础镜像的基础。虽然该镜像仅包含必需的软件包，但MySQL、PostgreSQL和SQLite3基础镜像会编译Zabbix组件并为其使用做好准备。

## 镜像变体

`zabbix-build-base`镜像有多种版本，每种版本都针对特定用例设计。

### `zabbix-build-base:alpine-<version>`

此镜像基于流行的[Alpine Linux项目](http://alpinelinux.org)，可在[`alpine`官方镜像](https://hub.docker.com/_/alpine)中获取。Alpine Linux比大多数发行版基础镜像小得多（约5MB），因此通常会生成更精简的镜像。

当需要最终镜像体积尽可能小时，强烈推荐使用此变体。需要注意的主要问题是它使用[musl libc](http://www.musl-libc.org)而非[glibc及相关库](http://www.etalabs.net/compare_libcs.html)，因此某些软件可能会因libc需求的深度而遇到问题。不过，大多数软件对此没有问题，因此此变体通常是非常安全的选择。有关可能出现的问题以及使用基于Alpine的镜像的优缺点比较，请参阅[此Hacker News评论线程](https://news.ycombinator.com/item?id=10782897)。

为了最小化镜像大小，在基于Alpine的镜像中通常不包含额外的相关工具（如`git`或`bash`）。以此镜像为基础，可在自己的Dockerfile中添加所需的工具（如果不熟悉如何安装软件包，请参阅[`alpine`镜像描述](https://hub.docker.com/_/alpine/)中的示例）。

### `zabbix-build-base:ubuntu-<version>`

这是默认镜像。如果不确定自己的需求，建议使用此版本。它设计为既可作为临时容器（挂载源代码并启动容器以运行应用），也可作为构建其他镜像的基础。

### `zabbix-build-base:ol-<version>`

Oracle Linux是基于GNU通用公共许可证（GPLv2）发布的开源操作系统。它适用于通用用途或Oracle工作负载，经过每天超过128,000小时的真实世界工作负载严格测试，并包含独特的创新功能，如Ksplice（零停机内核补丁）、DTrace（实时诊断）、强大的Btrfs文件系统等。

## 支持的Docker版本

此镜像官方支持Docker 1.12.0版本。对旧版本（低至1.6）的支持基于尽力而为原则。有关如何升级Docker守护程序的详细信息，请参阅[Docker安装文档](https://docs.docker.com/installation/)。

## 用户反馈

### 文档

此镜像的文档存储在[`zabbix/zabbix-docker` GitHub仓库](https://github.com/zabbix/zabbix-docker/)的[`build-base/`目录](https://github.com/zabbix/zabbix-docker/tree/trunk/Dockerfiles/build-base)中。在尝试提交拉取请求之前，请务必熟悉该仓库的[`README.md`文件](https://github.com/zabbix/zabbix-docker/blob/master/README.md)。

### 问题

如果对此镜像有任何问题或疑问，请通过[GitHub issue](https://github.com/zabbix/zabbix-docker/issues)与我们联系。

#### 已知问题

### 贡献

我们欢迎您贡献新功能、修复或更新，无论大小；我们始终很高兴收到拉取请求，并会尽力尽快处理。

在开始编码之前，建议通过[GitHub issue](https://github.com/zabbix/zabbix-docker/issues)讨论您的计划，尤其是对于更复杂的贡献。这使其他贡献者有机会为您指明正确的方向，提供设计反馈，并帮助您了解是否有其他人正在处理相同的事情。

## 许可证

从Zabbix 7.0版本开始，所有后续Zabbix版本均采用GNU Affero通用公共许可证第3版（AGPLv3）发布。您可以修改相关版本并根据自由软件基金会发布的AGPLv3条款传播此类修改版本。有关更多详细信息，包括关于AGPLv3的常见问题解答，请参阅自由软件基金会的[通用FAQ](http://www.fsf.org/licenses/gpl-faq.html)。

Zabbix是开源软件，但如果您在商业环境中使用Zabbix，我们恳请您通过购买某种级别的技术支持来支持Zabbix的开发。所有之前的Zabbix软件版本（直至6.4）均采用GNU通用公共许可证第2版（GPLv2）发布。GPLv2和AGPLv3的正式条款可在http://www.fsf.org/licenses/查阅。

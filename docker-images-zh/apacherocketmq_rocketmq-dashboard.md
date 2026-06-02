---
image: apacherocketmq/rocketmq-dashboard
description: "这是一个用于Apache RocketMQ控制台的Docker镜像，提供直观的可视化界面，支持用户便捷监控和管理RocketMQ集群，可查看消息流转状态、集群节点信息、主题配置及消费者消费情况等，同时通过Docker容器化技术简化部署流程，实现快速启动与环境一致性，助力开发者和运维人员高效运维RocketMQ服务。"
source: https://xuanyuan.cloud/zh/r/apacherocketmq/rocketmq-dashboard
canonical: https://xuanyuan.cloud/zh/r/apacherocketmq/rocketmq-dashboard
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apacherocketmq/rocketmq-dashboard" title="apacherocketmq/rocketmq-dashboard Docker 镜像中文简介、标签列表与拉取命令">apacherocketmq/rocketmq-dashboard — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apacherocketmq/rocketmq-dashboard" title="apacherocketmq/rocketmq-dashboard Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apacherocketmq/rocketmq-dashboard</a>

# Apache RocketMQ Dashboard Docker 镜像使用介绍

## 一、概述

这个 Docker 镜像打包了 Apache RocketMQ Dashboard，让你能轻松通过 Docker 容器来部署和运行它。RocketMQ Dashboard 是一个可视化工具，方便你管理和监控 Apache RocketMQ 集群，像查看主题、消费者组、消息轨迹这些功能都能用。

## 二、主要特性/优势

用 Docker 镜像来跑 RocketMQ Dashboard，好处不少：

1.  **环境一致性**：不用再操心复杂的依赖配置，确保了在不同机器上都能跑。
2.  **部署简单**：几条命令就能搞定，省去手动安装 Java、配置环境变量这些步骤。
3.  **隔离性好**：容器化运行，和主机系统隔离开，互不影响。

## 三、使用方法

### 3.1 前提条件

你的机器上得先装好了 Docker。

### 3.2 获取镜像

打开终端，执行下面这个命令拉取最新的 RocketMQ Dashboard 镜像（具体的镜像名称和标签，你可以去 Docker Hub 或者官方仓库看看最新的）：

```bash
docker pull apache/rocketmq-dashboard:latest
```

### 3.3 运行容器

拉取完镜像，就可以用 `docker run` 命令启动容器了。关键是要配置好和 RocketMQ NameServer 的连接。

基本命令格式如下：

```bash
docker run -d -p [宿主机端口]:8080 -e "ROCKETMQ_CONFIG_NAMESRVADDR=[NameServer 地址:端口]" --name rocketmq-dashboard apache/rocketmq-dashboard:latest
```

**参数说明**：

*   `-d`：让容器在后台运行。
*   `-p [宿主机端口]:8080`：把容器里 Dashboard 的 8080 端口映射到你宿主机的指定端口（比如 8080:8080）。
*   `-e "ROCKETMQ_CONFIG_NAMESRVADDR=[NameServer 地址:端口]"`：设置环境变量，告诉 Dashboard 你的 RocketMQ NameServer 在哪里。例如，如果 NameServer 在本机，端口是 9876，那这里就填 `192.168.1.100:9876`（注意，这里得用宿主机能访问到的 NameServer 地址，不能直接用 localhost，除非 Dashboard 容器和 NameServer 在同一个网络且配置正确）。如果有多个 NameServer，就用分号隔开，像这样 `host1:9876;host2:9876`。
*   `--name rocketmq-dashboard`：给容器起个名字，方便管理。

**举个例子**：

假设你的 NameServer 地址是 `192.168.1.100:9876`，想把 Dashboard 的 8080 端口映射到宿主机的 8080 端口，命令就是：

```bash
docker run -d -p 8080:8080 -e "ROCKETMQ_CONFIG_NAMESRVADDR=192.168.1.100:9876" --name rocketmq-dashboard apache/rocketmq-dashboard:latest
```

### 3.4 访问 Dashboard

容器启动后，打开浏览器，输入 `[] IP 地址]:[宿主机端口]` 就能访问 Dashboard 了。比如上面的例子，就访问 `[] 3.5 自定义配置（可选）

要是你有其他配置需求，比如修改默认的端口（容器内的 8080 端口），可以通过 `-e` 参数传入更多环境变量，或者挂载自定义的配置文件。具体有哪些环境变量可以配置，可以参考 RocketMQ Dashboard 的官方文档，或者看看 Docker 镜像的说明。

## 四、注意事项

*   **端口冲突**：确保你宿主机上用来映射的端口（比如上面例子里的 8080）没有被其他程序占用。如果冲突了，换个宿主机端口就行，比如 `-p 8081:8080`。
*   **NameServer 地址**：`ROCKETMQ_CONFIG_NAMESRVADDR` 这个环境变量一定要设对，不然 Dashboard 连不上 RocketMQ 集群。如果 NameServer 也是用 Docker 跑的，要确保它们在同一个 Docker 网络，或者用宿主机的 IP 地址。
*   **持久化**：默认情况下，Dashboard 的配置可能不会持久化。如果需要，你可能要考虑挂载数据卷。
*   **生产环境**：上面说的是基本用法，生产环境用的话，还得考虑安全性（比如加认证）、高可用等因素。

## 五、获取更多信息

*   Apache RocketMQ 官网：[[]]([])
*   RocketMQ Dashboard GitHub 仓库：通常在 RocketMQ 主仓库的子模块或者相关链接里能找到。
*   Docker Hub 镜像页面：搜索 `rocketmq-dashboard` 可以找到官方或社区维护的镜像，上面会有更详细的说明。

<!-- xuanyuan-docker-images-zh
image: fluent/fluent-bit
source: https://xuanyuan.cloud/zh/r/fluent/fluent-bit
canonical: https://xuanyuan.cloud/zh/r/fluent/fluent-bit
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/fluent/fluent-bit" title="fluent/fluent-bit Docker 镜像中文简介、标签列表与拉取命令">fluent/fluent-bit — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/fluent/fluent-bit" title="fluent/fluent-bit Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/fluent/fluent-bit</a></p>

# Fluent Bit


[Fluent Bit]([]) 是一款轻量级高性能日志处理器。本仓库提供生产环境可用的容器镜像，稳定版基于 Distroless 构建，注重安全性，仅包含 Fluent Bit 二进制文件、必要系统库及基础配置。  

此外，我们还提供调试版镜像，包含 shell 和工具，可用于故障排查或测试场景。  

所有可用标签及版本详情，请参考官方文档：<[]>  


## 快速开始

### 步骤1：启动 Fluent Bit 实例  
运行一个 Fluent Bit 实例，该实例将通过 Forward 协议监听 TCP 24224 端口，并每秒将消息以 JSON 行格式输出到 STDOUT 接口：  
```shell
docker run -p 127.0.0.1:24224:24224 fluent/fluent-bit /fluent-bit/bin/fluent-bit -i forward -o stdout -p format=json_lines -f 1
```


### 步骤2：发送测试消息  
运行另一个容器发送测试消息。这次 Docker 容器将使用 Fluent Forward 协议作为日志驱动：  
```shell
docker run --log-driver=fluentd -t ubuntu echo "测试日志消息"
```


### 预期输出  
在 Fluent Bit 容器的 stdout 中，将看到类似以下输出：  
```shell
Fluent Bit v1.9.8
* Copyright (C) 2015-2022 The Fluent Bit Authors
* Fluent Bit is a CNCF sub-project under the umbrella of Fluentd
* [] 10:03:48] [ info] [fluent bit] version=1.9.8, commit=97a5e9dcf3, pid=1
[2022/09/16 10:03:48] [ info] [storage] version=1.2.0, type=memory-only, sync=normal, checksum=disabled, max_chunks_up=128
[2022/09/16 10:03:48] [ info] [cmetrics] version=0.3.6
[2022/09/16 10:03:48] [ info] [input:forward:forward.0] listening on 0.0.0.0:24224
[2022/09/16 10:03:48] [ info] [sp] stream processor started
[2022/09/16 10:03:48] [ info] [output:stdout:stdout.0] worker #0 started
{"date":1663322636.0,"source":"stdout","log":"测试日志消息\r","container_id":"e29e02e84ffa00116818a86f6f99305a7d0f77f25420eceeb9206b725f137af4","container_name":"/intelligent_austin"}
```


## Dockerfile  

具体定义可参考源码仓库：<[]>。  

容器构建流程参见此处：<[]>。  


## 联系我们  

可通过以下社区渠道联系我们：  
- Slack：<[]>（频道 #fluent-bit）  
- Github：<[]>  
- ：<  


## Fluent Bit 与 Fluentd  

[Fluent Bit]([]) 是 CNCF（云原生计算基金会）旗下 [Fluentd]([]) 项目的子项目。  


## 许可证  

本程序遵循 [Apache License v2.0]([]) 协议。  


## 作者  

[Fluent Bit]([]) 是 CNCF 旗下 Fluentd 项目的子项目，由 [众多贡献者]([]) 倾心打造。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/fluent/fluent-bit" title="fluent/fluent-bit Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/fluent/fluent-bit</a></p>

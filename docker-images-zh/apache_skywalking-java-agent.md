---
image: apache/skywalking-java-agent
description: "Apache SkyWalking的Java代理"
source: https://xuanyuan.cloud/zh/r/apache/skywalking-java-agent
canonical: https://xuanyuan.cloud/zh/r/apache/skywalking-java-agent
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/skywalking-java-agent" title="apache/skywalking-java-agent Docker 镜像中文简介、标签列表与拉取命令">apache/skywalking-java-agent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache SkyWalking Agent 镜像

**Docker镜像非ASF官方发布版本，仅为方便使用提供。建议优先通过源码构建。**

<img src="http://skywalking.apache.org/assets/logo.svg" alt="Sky Walking logo" height="90px" align="right" />

**SkyWalking**：一款应用性能监控（APM）系统，专为微服务、云原生和基于容器（Docker、Kubernetes、Mesos）的架构设计。

[![GitHub 星标](https://img.shields.io/github/stars/apache/skywalking.svg?style=for-the-badge&label=Stars&logo=github)](https://github.com/apache/skywalking)
[![Twitter 关注](https://img.shields.io/twitter/follow/asfskywalking.svg?style=for-the-badge&label=Follow&logo=twitter)](https://twitter.com/AsfSkyWalking)

Dockerfile可在[此处](https://github.com/apache/skywalking-docker)获取。

该镜像仅包含预构建的SkyWalking Java代理JAR包，并为容器化场景提供便捷配置。

# 如何使用此镜像

## 基于此镜像构建Java应用镜像

```dockerfile
FROM apache/skywalking-java-agent:9.4.0-jdk8

# ... 构建你的Java应用
```

你可以使用`CMD`或`ENTRYPOINT`启动Java应用，无需关心启用SkyWalking代理的Java选项，系统会自动应用。

## 将此镜像用作Kubernetes服务的sidecar

在Kubernetes场景中，你也可以将此代理镜像用作sidecar。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: agent-as-sidecar
spec:
  restartPolicy: Never

  volumes:
    - name: skywalking-agent
      emptyDir: { }

  containers:
    - name: agent-container
      image: apache/skywalking-java-agent:9.4.0-alpine
      volumeMounts:
        - name: skywalking-agent
          mountPath: /agent
      command: [ "/bin/sh" ]
      args: [ "-c", "cp -R /skywalking/agent /agent/" ]

    - name: app-container
      image: springio/gs-spring-boot-docker
      volumeMounts:
        - name: skywalking-agent
          mountPath: /skywalking
      env:
        - name: JAVA_TOOL_OPTIONS
          value: "-javaagent:/skywalking/agent/skywalking-agent.jar"
```

# 许可证

[Apache 2.0 许可证。](/LICENSE)

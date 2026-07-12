---
image: arm64v8/eclipse-temurin
description: "由Eclipse Temurin构建的OpenJDK二进制文件官方镜像，用于运行Java应用程序。"
source: https://xuanyuan.cloud/zh/r/arm64v8/eclipse-temurin
canonical: https://xuanyuan.cloud/zh/r/arm64v8/eclipse-temurin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/eclipse-temurin" title="arm64v8/eclipse-temurin Docker 镜像中文简介、标签列表与拉取命令">arm64v8/eclipse-temurin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm64v8/eclipse-temurin Docker镜像文档

## 镜像概述和主要用途

**注意：** 这是[`eclipse-temurin`官方镜像](https://hub.docker.com/_/eclipse-temurin)的`arm64v8`架构专用仓库。有关更多信息，请参见官方镜像文档中的["除amd64之外的架构？"](https://github.com/docker-library/official-images#architectures-other-than-amd64)和官方镜像FAQ中的["Git中的镜像源已更改，现在该怎么办？"](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

该仓库中的镜像包含由Eclipse Temurin构建的OpenJDK二进制文件，提供高性能、企业级、跨平台、开源许可且通过Java SE TCK测试的Java运行时环境，适用于Java生态系统的通用使用。

## 核心功能和特性

- 提供多个Java版本（8、11、17、21、25）的JDK和JRE环境
- 基于多种基础镜像（Ubuntu Jammy、Ubuntu Noble、UBI10 Minimal、UBI9 Minimal、Alpine）
- 支持非root用户运行，符合安全最佳实践
- 可自定义CA证书添加到信任存储
- 提供精简的Alpine版本，最小化镜像大小
- 所有构建均通过Java SE TCK测试，确保兼容性和可靠性

## 使用场景和适用范围

- Java应用程序的容器化部署
- 开发环境中的Java运行时
- CI/CD流水线中的Java构建环境
- 需要特定Java版本的应用程序部署
- 对镜像大小有严格要求的场景（Alpine变体）
- 企业级Java应用的生产环境部署

## 支持的标签和Dockerfile链接

### 简单标签(Simple Tags)

#### Java 8
- [`8u462-b08-jdk-jammy`, `8-jdk-jammy`, `8-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jdk/ubuntu/jammy/Dockerfile)
- [`8u462-b08-jdk-noble`, `8-jdk-noble`, `8-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jdk/ubuntu/noble/Dockerfile)
- [`8u462-b08-jdk-ubi10-minimal`, `8-jdk-ubi10-minimal`, `8-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jdk/ubi/ubi10-minimal/Dockerfile)
- [`8u462-b08-jdk-ubi9-minimal`, `8-jdk-ubi9-minimal`, `8-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jdk/ubi/ubi9-minimal/Dockerfile)
- [`8u462-b08-jre-jammy`, `8-jre-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jre/ubuntu/jammy/Dockerfile)
- [`8u462-b08-jre-noble`, `8-jre-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jre/ubuntu/noble/Dockerfile)
- [`8u462-b08-jre-ubi10-minimal`, `8-jre-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jre/ubi/ubi10-minimal/Dockerfile)
- [`8u462-b08-jre-ubi9-minimal`, `8-jre-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/8/jre/ubi/ubi9-minimal/Dockerfile)

#### Java 11
- [`11.0.28_6-jdk-jammy`, `11-jdk-jammy`, `11-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jdk/ubuntu/jammy/Dockerfile)
- [`11.0.28_6-jdk-noble`, `11-jdk-noble`, `11-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jdk/ubuntu/noble/Dockerfile)
- [`11.0.28_6-jdk-ubi10-minimal`, `11-jdk-ubi10-minimal`, `11-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jdk/ubi/ubi10-minimal/Dockerfile)
- [`11.0.28_6-jdk-ubi9-minimal`, `11-jdk-ubi9-minimal`, `11-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jdk/ubi/ubi9-minimal/Dockerfile)
- [`11.0.28_6-jre-jammy`, `11-jre-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jre/ubuntu/jammy/Dockerfile)
- [`11.0.28_6-jre-noble`, `11-jre-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jre/ubuntu/noble/Dockerfile)
- [`11.0.28_6-jre-ubi10-minimal`, `11-jre-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jre/ubi/ubi10-minimal/Dockerfile)
- [`11.0.28_6-jre-ubi9-minimal`, `11-jre-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/11/jre/ubi/ubi9-minimal/Dockerfile)

#### Java 17
- [`17.0.16_8-jdk-jammy`, `17-jdk-jammy`, `17-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jdk/ubuntu/jammy/Dockerfile)
- [`17.0.16_8-jdk-noble`, `17-jdk-noble`, `17-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jdk/ubuntu/noble/Dockerfile)
- [`17.0.16_8-jdk-ubi10-minimal`, `17-jdk-ubi10-minimal`, `17-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jdk/ubi/ubi10-minimal/Dockerfile)
- [`17.0.16_8-jdk-ubi9-minimal`, `17-jdk-ubi9-minimal`, `17-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jdk/ubi/ubi9-minimal/Dockerfile)
- [`17.0.16_8-jre-jammy`, `17-jre-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jre/ubuntu/jammy/Dockerfile)
- [`17.0.16_8-jre-noble`, `17-jre-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jre/ubuntu/noble/Dockerfile)
- [`17.0.16_8-jre-ubi10-minimal`, `17-jre-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jre/ubi/ubi10-minimal/Dockerfile)
- [`17.0.16_8-jre-ubi9-minimal`, `17-jre-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/17/jre/ubi/ubi9-minimal/Dockerfile)

#### Java 21
- [`21.0.8_9-jdk-alpine-3.20`, `21-jdk-alpine-3.20`, `21-alpine-3.20`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jdk/alpine/3.20/Dockerfile)
- [`21.0.8_9-jdk-alpine-3.21`, `21-jdk-alpine-3.21`, `21-alpine-3.21`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jdk/alpine/3.21/Dockerfile)
- [`21.0.8_9-jdk-alpine-3.22`, `21-jdk-alpine-3.22`, `21-alpine-3.22`, `21.0.8_9-jdk-alpine`, `21-jdk-alpine`, `21-alpine`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jdk/alpine/3.22/Dockerfile)
- [`21.0.8_9-jdk-jammy`, `21-jdk-jammy`, `21-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jdk/ubuntu/jammy/Dockerfile)
- [`21.0.8_9-jdk-noble`, `21-jdk-noble`, `21-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jdk/ubuntu/noble/Dockerfile)
- [`21.0.8_9-jdk-ubi10-minimal`, `21-jdk-ubi10-minimal`, `21-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jdk/ubi/ubi10-minimal/Dockerfile)
- [`21.0.8_9-jdk-ubi9-minimal`, `21-jdk-ubi9-minimal`, `21-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jdk/ubi/ubi9-minimal/Dockerfile)
- [`21.0.8_9-jre-alpine-3.20`, `21-jre-alpine-3.20`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jre/alpine/3.20/Dockerfile)
- [`21.0.8_9-jre-alpine-3.21`, `21-jre-alpine-3.21`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jre/alpine/3.21/Dockerfile)
- [`21.0.8_9-jre-alpine-3.22`, `21-jre-alpine-3.22`, `21.0.8_9-jre-alpine`, `21-jre-alpine`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jre/alpine/3.22/Dockerfile)
- [`21.0.8_9-jre-jammy`, `21-jre-jammy`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jre/ubuntu/jammy/Dockerfile)
- [`21.0.8_9-jre-noble`, `21-jre-noble`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jre/ubuntu/noble/Dockerfile)
- [`21.0.8_9-jre-ubi10-minimal`, `21-jre-ubi10-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jre/ubi/ubi10-minimal/Dockerfile)
- [`21.0.8_9-jre-ubi9-minimal`, `21-jre-ubi9-minimal`](https://github.com/adoptium/containers/blob/fc54f27893bb7c1ffb1d7eb82f2d22d7605e57bc/21/jre/ubi/ubi

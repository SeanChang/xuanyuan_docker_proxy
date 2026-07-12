---
image: findepi/graalvm
description: "轻量级容器化的GraalVM，功能类似openjdk镜像，包含GraalVM运行时环境，支持直接调用GraalVM二进制文件及多语言执行。"
source: https://xuanyuan.cloud/zh/r/findepi/graalvm
canonical: https://xuanyuan.cloud/zh/r/findepi/graalvm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/findepi/graalvm" title="findepi/graalvm Docker 镜像中文简介、标签列表与拉取命令">findepi/graalvm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GraalVM Docker容器

## 镜像概述和主要用途
该镜像与 [`openjdk`](https://hub.docker.com/_/openjdk/) 镜像类似，核心区别在于内置了GraalVM运行时环境，适用于需要使用GraalVM进行应用开发、运行和测试的场景。

## 核心功能和特性
- 包含完整的GraalVM运行时环境
- GraalVM二进制文件已添加至`$PATH`，可直接在容器中调用
- 提供多语言版本（polyglot），支持多种编程语言执行
- 轻量级设计，便于快速部署和集成

## 使用场景和适用范围
- Java应用程序的运行与测试
- 多语言开发环境（如Python等语言的执行）
- 构建基于GraalVM的自定义派生镜像

## 使用方法和配置说明

### 基础使用
由于GraalVM二进制文件已在`$PATH`中，可直接调用相关命令：

```bash
$ docker run findepi/graalvm java -version
openjdk version "17.0.8" 2023-07-18
OpenJDK Runtime Environment GraalVM CE 17.0.8+7.1 (build 17.0.8+7-jvmci-23.0-b15)
OpenJDK 64-Bit Server VM GraalVM CE 17.0.8+7.1 (build 17.0.8+7-jvmci-23.0-b15, mixed mode, sharing)
```

### 多语言版本使用
对于支持多语言的镜像版本（polyglot）：

```bash
$ docker run -i --rm findepi/graalvm:polyglot python -c 'print([42, 2**42])'
[42, 4398046511104]
```

## 源代码
源代码托管于 [https://github.com/findepi/graalvm-docker](https://github.com/findepi/graalvm-docker)

## 许可证
- 本仓库代码许可证：参见 [LICENSE](LICENSE)
- 预构建容器许可证：参见 https://github.com/oracle/graal#license

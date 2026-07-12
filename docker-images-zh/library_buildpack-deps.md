---
image: library/buildpack-deps
description: "包含常用构建依赖项，用于安装各种模块（如gems）的Docker镜像"
source: https://xuanyuan.cloud/zh/r/library/buildpack-deps
canonical: https://xuanyuan.cloud/zh/r/library/buildpack-deps
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/buildpack-deps" title="library/buildpack-deps Docker 镜像中文简介、标签列表与拉取命令">library/buildpack-deps 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# buildpack-deps 镜像文档

## 概述

`buildpack-deps` 镜像在设计理念上类似于 [Heroku 的 stack 镜像](https://github.com/heroku/stack-images/blob/master/bin/cedar.sh)，包含大量开发所需的"头文件"包，适用于 Ruby Gems、PyPI 模块等各类依赖的编译安装。例如，使用 `buildpack-deps` 可以在任意应用目录中执行 `bundle install`，而无需预先知晓构建依赖模块是否需要 `ssl.h` 等头文件。

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/buildpack-deps/logo.png)

## 核心功能与特性

### 完整版本（主标签）
包含大量开发依赖包，支持绝大多数 `gem install`、`npm install`、`pip install` 等命令无需额外安装头文件即可成功执行。

### curl 变体
基于基础镜像，仅包含 `curl`、`wget` 和 `ca-certificates` 包。适用于需下载文件但无需版本控制的场景（如 Java JRE 环境下载 JAR 包）。

### scm 变体
基于 `curl` 变体，额外包含多种版本控制工具：`bzr`、`git`、`hg` 和 `svn`（不含 `cvs`）。适用于需下载文件且需版本控制的场景（如 Java JDK 环境中检出代码）。

## 支持的标签

### Debian 系列
| 基础版本       | 完整版本标签                | curl 变体标签               | scm 变体标签                | Dockerfile 链接                                                                 |
|----------------|---------------------------|---------------------------|---------------------------|-------------------------------------------------------------------------------|
| Trixie (stable) | `trixie`, `stable`, `latest` | `trixie-curl`, `stable-curl`, `curl` | `trixie-scm`, `stable-scm`, `scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/1f4fe499c668d9a2e1578aa8db4f0b2d14482cf5/debian/trixie/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/1f4fe499c668d9a2e1578aa8db4f0b2d14482cf5/debian/trixie/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/1f4fe499c668d9a2e1578aa8db4f0b2d14482cf5/debian/trixie/scm/Dockerfile) |
| Bookworm (oldstable) | `bookworm`, `oldstable` | `bookworm-curl`, `oldstable-curl` | `bookworm-scm`, `oldstable-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/d0ecd4b7313e9bc6b00d9a4fe62ad5787bc197ae/debian/bookworm/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/3e18c3af1f5dce6a48abf036857f9097b6bd79cc/debian/bookworm/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/d0ecd4b7313e9bc6b00d9a4fe62ad5787bc197ae/debian/bookworm/scm/Dockerfile) |
| Bullseye (oldoldstable) | `bullseye`, `oldoldstable` | `bullseye-curl`, `oldoldstable-curl` | `bullseye-scm`, `oldoldstable-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/d0ecd4b7313e9bc6b00d9a4fe62ad5787bc197ae/debian/bullseye/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/93d6db0797f91ab674535553b7e0e762941a02d0/debian/bullseye/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/d0ecd4b7313e9bc6b00d9a4fe62ad5787bc197ae/debian/bullseye/scm/Dockerfile) |
| Forky (testing) | `forky`, `testing` | `forky-curl`, `testing-curl` | `forky-scm`, `testing-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/6fbd1fd6aa17031b10f11a97c31b9da1ac09db76/debian/forky/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/6fbd1fd6aa17031b10f11a97c31b9da1ac09db76/debian/forky/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/6fbd1fd6aa17031b10f11a97c31b9da1ac09db76/debian/forky/scm/Dockerfile) |
| Sid (unstable) | `sid`, `unstable` | `sid-curl`, `unstable-curl` | `sid-scm`, `unstable-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/2b3a8b7d1f8875865034be3bab98ddd737e37d5e/debian/sid/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/2b3a8b7d1f8875865034be3bab98ddd737e37d5e/debian/sid/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/2b3a8b7d1f8875865034be3bab98ddd737e37d5e/debian/sid/scm/Dockerfile) |

### Ubuntu 系列
| 基础版本    | 完整版本标签       | curl 变体标签          | scm 变体标签           | Dockerfile 链接                                                                 |
|-------------|------------------|----------------------|----------------------|-------------------------------------------------------------------------------|
| Noble (24.04) | `noble`, `24.04` | `noble-curl`, `24.04-curl` | `noble-scm`, `24.04-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/60dc5f9555c521de086b2f5770514faf69ee2cc4/ubuntu/noble/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/60dc5f9555c521de086b2f5770514faf69ee2cc4/ubuntu/noble/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/60dc5f9555c521de086b2f5770514faf69ee2cc4/ubuntu/noble/scm/Dockerfile) |
| Jammy (22.04) | `jammy`, `22.04` | `jammy-curl`, `22.04-curl` | `jammy-scm`, `22.04-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/d0ecd4b7313e9bc6b00d9a4fe62ad5787bc197ae/ubuntu/jammy/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/93d6db0797f91ab674535553b7e0e762941a02d0/ubuntu/jammy/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/d0ecd4b7313e9bc6b00d9a4fe62ad5787bc197ae/ubuntu/jammy/scm/Dockerfile) |
| Plucky (25.04) | `plucky`, `25.04` | `plucky-curl`, `25.04-curl` | `plucky-scm`, `25.04-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/ab3ae04e943ecb240a9691dfa1de219b4a3e32a0/ubuntu/plucky/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/ab3ae04e943ecb240a9691dfa1de219b4a3e32a0/ubuntu/plucky/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/ab3ae04e943ecb240a9691dfa1de219b4a3e32a0/ubuntu/plucky/scm/Dockerfile) |
| Questing (25.10) | `questing`, `25.10` | `questing-curl`, `25.10-curl` | `questing-scm`, `25.10-scm` | [完整](https://github.com/docker-library/buildpack-deps/blob/99e7dc24c50c0a7be371ea9e6aed6134ce4cbfeb/ubuntu/questing/Dockerfile)、[curl](https://github.com/docker-library/buildpack-deps/blob/99e7dc24c50c0a7be371ea9e6aed6134ce4cbfeb/ubuntu/questing/curl/Dockerfile)、[scm](https://github.com/docker-library/buildpack-deps/blob/99e7dc24c50c0a7be371ea9e6aed6134ce4cbfeb/ubuntu/questing/scm/Dockerfile) |

## 使用场景与适用范围

- **语言栈基础镜像**：作为 Ruby、Python、Node.js 等语言栈镜像的基础，提供编译依赖。
- **模块安装场景**：需执行 `gem install`、`npm install`、`pip install` 等命令，且预先未知依赖的开发头文件时。
- **精简需求场景**：仅需下载功能（curl 变体）或版本控制功能（scm 变体）时，减少镜像体积。

## 使用方法

### 基础使用

该镜像设计为语言栈镜像的基础层，通常作为 `FROM` 指令的基础镜像：

```dockerfile
# 使用完整版本作为 Ruby 镜像基础
FROM docker.xuanyuan.run/buildpack-deps:latest
RUN apt-get update && apt-get install -y ruby && rm -rf /var/lib/apt/lists/*
```

### 变体使用示例

#### curl 变体：下载文件
```bash
docker run --rm docker.xuanyuan.run/buildpack-deps:curl wget https://example.com/file.tar.gz
```

#### scm 变体：克隆代码仓库
```bash
docker run --rm docker.xuanyuan.run/buildpack-deps:scm git clone https://github.com/example/repo.git
```

#### 完整版本：安装 Ruby Gems
```bash
docker run -v $(pwd):/app --rm docker.xuanyuan.run/buildpack-deps:latest sh -c "cd /app && gem install bundler && bundle install"
```

## 维护与支持

- **维护者**：[Docker 社区](https://github.com/docker-library/buildpack-deps)
- **获取帮助**：[Docker Community Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)、[Stack Overflow](https://stackoverflow.com/help/on-topic)
- **支持架构**：`amd64`、`arm32v5`、`arm32v7`、`arm64v8`、`i386`、`mips64le`、`ppc64le`、`riscv64`、`s390x`
- **镜像更新**：[official-images 仓库 `library/buildpack-deps` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fbuildpack-deps)
- **问题反馈**：[GitHub Issues](https://github.com/docker-library/buildpack-deps/issues)

## 许可证

镜像中软件的许可证信息请参见 [Debian 许可指南](https://www.debian.org/social_contract#guidelines)。  
Docker 镜像可能包含其他软件（如 Bash 等基础发行版组件），其许可证可能不同。  
额外许可证信息可在 [repo-info 仓库的 `buildpack-deps` 目录](https://github.com/docker-library/repo-info/tree/master/repos/buildpack-deps) 中找到。  
使用前请确保遵守所有包含软件的许可证要求。

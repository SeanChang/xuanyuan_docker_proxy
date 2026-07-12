---
image: frapsoft/openssl
description: "基于Alpine Linux的轻量OpenSSL镜像（仅3MB），提供REPL交互环境、SSL证书创建等安全相关操作，适用于开发测试中的加密与证书管理场景。"
source: https://xuanyuan.cloud/zh/r/frapsoft/openssl
canonical: https://xuanyuan.cloud/zh/r/frapsoft/openssl
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/frapsoft/openssl" title="frapsoft/openssl Docker 镜像中文简介、标签列表与拉取命令">frapsoft/openssl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

![Docker Security](https://github.frapsoft.com/top/docker-security.jpg)

# Alpine Linux上的OpenSSL

_安全与渗透测试相关的Docker容器集合可在[此处](https://github.com/ellerbrock/docker-security-container)找到。_

[![Docker Automated Build](https://img.shields.io/docker/automated/frapsoft/openssl.svg)](https://hub.docker.com/r/frapsoft/openssl/) [![Docker Pulls](https://img.shields.io/docker/pulls/frapsoft/openssl.svg)](https://hub.docker.com/r/frapsoft/openssl/) [![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg)](https://github.com/ellerbrock/open-source-badges/) [![Gitter Chat](https://badges.gitter.im/frapopensslsoft/frapsoft.svg)](https://gitter.im/frapsoft/frapsoft/)

- Docker Hub: [frapsoft/openssl](https://hub.docker.com/r/frapsoft/openssl/)
- 代码仓库: <https://github.com/ellerbrock/openssl-docker>
- Dockerfile: <https://github.com/ellerbrock/openssl-docker/blob/master/Dockerfile>
- 基础镜像: [alpine](https://hub.docker.com/_/alpine/)

## 安装
`docker pull docker.xuanyuan.run/frapsoft/openssl`

## 示例

### OpenSSL REPL交互
`docker run -it frapsoft/openssl`

### 创建SSL证书
OpenSSL会提示输入相关信息，并将证书导出到当前目录下的`cert.pem`文件中：
`docker run -it -v $(pwd):/export frapsoft/openssl req -nodes -new -newkey rsa:2048 -sha256 -out /export/cert.pem`

更多信息请参考OpenSSL [官方文档](https://www.openssl.org/docs/)。

### 交互式Shell
`docker run -it --entrypoint /bin/ash frapsoft/openssl`

## 镜像概述
本镜像基于轻量级的Alpine Linux构建，镜像大小仅3MB，提供完整的OpenSSL工具环境，支持多种安全相关操作，适用于开发、测试场景中的加密、证书管理等需求。

## 核心功能
1. 提供OpenSSL交互式REPL环境，快速执行加密、解密等命令
2. 支持生成SSL证书文件并导出到本地目录
3. 可进入Alpine系统的交互式Shell进行自定义操作

## 使用场景
- 开发测试环境中快速生成SSL证书用于HTTPS服务配置
- 临时使用OpenSSL工具进行数据加密、签名验证等操作
- 学习或验证OpenSSL相关命令的使用

## 配置说明
- 通过`-v`参数挂载本地目录到容器内`/export`路径，实现证书文件导出
- 通过`--entrypoint`参数指定容器启动入口程序（如切换到Alpine的ash shell）

### 联系方式/社交媒体
获取Web开发、开源、工具、服务器与安全的最新资讯：

[![Twitter](https://github.frapsoft.com/social/twitter.png)](https://twitter.com/frapsoft/)[![Facebook](https://github.frapsoft.com/social/facebook.png)](https://www.facebook.com/frapsoft/)[![Google+](https://github.frapsoft.com/social/google-plus.png)](https://plus.google.com/116540931335841862774)[![Gitter](https://github.frapsoft.com/social/gitter.png)](https://gitter.im/frapsoft/frapsoft/)[![Github](https://github.frapsoft.com/social/github.png)](https://github.com/ellerbrock/)

---
image: etherpad/etherpad
description: "Etherpad是一款Web实时协作编辑器，可扩展支持数千并发用户，提供完整数据导出功能，允许在自有服务器部署并完全掌控数据。"
source: https://xuanyuan.cloud/zh/r/etherpad/etherpad
canonical: https://xuanyuan.cloud/zh/r/etherpad/etherpad
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/etherpad/etherpad" title="etherpad/etherpad Docker 镜像中文简介、标签列表与拉取命令">etherpad/etherpad 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Etherpad：Web实时协作编辑器

![Etherpad演示动画](https://github.com/ether/etherpad-lite/raw/6085/merge/doc/images/etherpad_demo.gif "Etherpad使用演示")

## 概述

Etherpad是一款Web实时协作编辑器，可扩展支持数千名并发实时用户，提供完整的数据导出功能，并能在您自己的服务器上运行，完全由您掌控数据。

## 核心功能与特性

- **实时协作**：多人同时编辑，实时显示各方更改
- **高可扩展性**：支持数千并发用户（[扩展测试](http://scale.etherpad.org/)）
- **数据导出**：提供完整数据导出能力（[了解详情](https://github.com/ether/etherpad-lite/wiki/Understanding-Etherpad's-Full-Data-Export-capabilities)）
- **自托管控制**：运行在自有服务器，确保数据安全与隐私
- **插件生态**：丰富的插件系统，支持功能高度自定义

## 使用场景

适用于团队协作编辑、文档共同创作、实时会议记录、多人协作撰稿等场景，尤其适合需要数据私有化和自主管理的组织或个人。

## 试用体验

- Wikimedia提供公共实例：[试用Etherpad](https://etherpad.wikimedia.org)
- 其他公共实例：[查看更多功能](https://github.com/ether/etherpad-lite/wiki/Sites-That-Run-Etherpad#sites-that-run-etherpad)

## 项目状态

目前正在寻找维护者，并提供部分资金支持。如有兴趣，请联系John McLear。

### 代码质量

[![代码质量](https://github.com/ether/etherpad-lite/actions/workflows/codeql-analysis.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/codeql-analysis.yml)
[![package.lock检查](https://github.com/ether/etherpad-lite/actions/workflows/lint-package-lock.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/lint-package-lock.yml)

### 测试状态

[![后端测试](https://github.com/ether/etherpad-lite/actions/workflows/backend-tests.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/backend-tests.yml)
[![模拟负载测试](https://github.com/ether/etherpad-lite/actions/workflows/load-test.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/load-test.yml)
[![速率限制测试](https://github.com/ether/etherpad-lite/actions/workflows/rate-limit.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/rate-limit.yml)
[![Docker文件测试](https://github.com/ether/etherpad-lite/actions/workflows/dockerfile.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/dockerfile.yml)
[![前端管理测试](https://github.com/ether/etherpad-lite/actions/workflows/frontend-admin-tests.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/frontend-admin-tests.yml)
[![前端测试](https://github.com/ether/etherpad-lite/actions/workflows/frontend-tests.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/frontend-tests.yml)
[![Sauce测试状态](https://saucelabs.com/buildstatus/etherpad.svg)](https://saucelabs.com/u/etherpad)
[![Windows构建](https://github.com/ether/etherpad-lite/actions/workflows/windows.yml/badge.svg?color=%2344b492)](https://github.com/ether/etherpad-lite/actions/workflows/windows.yml)

### 社区参与

[![Docker拉取量](https://img.shields.io/docker/pulls/etherpad/etherpad?color=%2344b492)](https://hub.docker.com/r/etherpad/etherpad)
[![Discord](https://img.shields.io/discord/741309013593030667?color=%2344b492)](https://discord.com/invite/daEjfhw)
[![Etherpad插件](https://img.shields.io/endpoint?url=https%3A%2F%2Fstatic.etherpad.org%2Fshields.json&color=%2344b492 "Etherpad插件")](https://static.etherpad.org/index.html)
![语言支持](https://img.shields.io/static/v1?label=Languages&message=105&color=%2344b492)
![翻译覆盖率](https://img.shields.io/static/v1?label=Languages&message=98%&color=%2344b492)

## Docker部署指南

### 基本运行命令

```bash
docker run -d -p 9001:9001 --name etherpad docker.xuanyuan.run/etherpad/etherpad
```

### Docker Compose配置示例

```yaml
version: '3'
services:
  etherpad:
    image: docker.xuanyuan.run/etherpad/etherpad
    container_name: etherpad
    ports:
      - "9001:9001"
    volumes:
      - ./etherpad_data:/opt/etherpad-lite/var
    environment:
      - NODE_ENV=production
      - DB_TYPE=sqlite
      - DB_FILENAME=/opt/etherpad-lite/var/dirty.db
    restart: unless-stopped
```

> 更多详细配置请参考[官方Docker文档](https://github.com/ether/etherpad-lite/blob/6085/merge/doc/docker.adoc)

## 插件系统

Etherpad通过插件实现高度自定义功能。

![基础安装界面](https://github.com/ether/etherpad-lite/raw/6085/merge/doc/images/etherpad_basic.png "基础安装")

![完整功能界面](https://github.com/ether/etherpad-lite/raw/6085/merge/doc/images/etherpad_full_features.png "可添加众多插件")

### 可用插件

查看完整插件列表：[Etherpad插件网站](https://static.etherpad.org)

### 插件安装方法

#### 通过管理界面安装
访问Etherpad管理界面（如：http://127.0.0.1:9０01/admin/plugins）进行插件管理。

#### 通过命令行安装
```bash
cd /path/to/etherpad-lite
# --no-save 和 --legacy-peer-deps 参数用于解决npm兼容性问题
npm install --no-save --legacy-peer-deps ep_${插件名称}
```

### 推荐插件组合

运行以下命令安装演示中展示的完整功能插件：

```bash
npm install --no-save --legacy-peer-deps \
  ep_align \
  ep_comments_page \
  ep_embedded_hyperlinks2 \
  ep_font_color \
  ep_headings2 \
  ep_markdown \
  ep_webrtc
```

#### 身份认证推荐插件
- [ep_openid_connect](https://github.com/ether/ep_openid_connect#readme)：OpenID Connect认证
- [ep_guest](https://github.com/ether/ep_guest#readme)：访客账户管理（如只读权限）
- [ep_user_displayname](https://github.com/ether/ep_user_displayname#readme)：用户显示名自动填充
- [ep_stable_authorid](https://github.com/ether/ep_stable_authorid#readme)：用户身份与属性关联

## 配置与优化

### 设置调整

Etherpad核心配置文件为`settings.json`，支持通过命令行参数指定不同配置文件：
```bash
src/bin/run.sh --settings /path/to/custom-settings.json
```

主要配置参数：
- `--credentials`：指定设置覆盖文件
- `--apikey`：指定API密钥文件
- `--sessionkey`：指定会话密钥文件

所有配置参数均可通过环境变量设置，格式为`${ENV_VAR}`或`${ENV_VAR:default_value}`。

### 安全加固

生产环境建议：
1. 使用专用数据库（如MySQL）替代默认的`dirtyDB`
2. 安装[ep_hash_auth插件](https://www.npmjs.com/package/ep_hash_auth)存储密码哈希
3. 配置HTTPS加密传输

### 皮肤自定义

访问以下地址进行皮肤可视化定制：
```
http://127.0.0.1:9001/p/test#skinvariantsbuilder
```

![皮肤变体定制](https://github.com/ether/etherpad-lite/raw/6085/merge/doc/images/etherpad_skin_variants.gif "皮肤变体")

## 开发资源

### HTTP API

Etherpad提供[HTTP API](https://github.com/ether/etherpad-lite/wiki/HTTP-API)用于管理文档、用户和组，推荐使用[官方客户端库](https://github.com/ether/etherpad-lite/wiki/HTTP-API-client-libraries)进行交互。API的OpenAPI定义可通过`/api/openapi.json`访问。

### jQuery插件

通过[jQuery插件](https://github.com/ether/etherpad-lite-jquery-plugin)可轻松将Etherpad嵌入网站。

## 许可证

[Apache License v2](http://www.apache.org/licenses/LICENSE-2.0.html)

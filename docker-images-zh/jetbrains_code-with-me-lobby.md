---
image: jetbrains/code-with-me-lobby
description: "JetBrains 官方 Code With Me Lobby 服务器镜像。"
source: https://xuanyuan.cloud/zh/r/jetbrains/code-with-me-lobby
canonical: https://xuanyuan.cloud/zh/r/jetbrains/code-with-me-lobby
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jetbrains/code-with-me-lobby" title="jetbrains/code-with-me-lobby Docker 镜像中文简介、标签列表与拉取命令">jetbrains/code-with-me-lobby 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Code With Me Lobby
![](https://camo.githubusercontent.com/b044da88664180ea9ad36112161507223610b3bd229f10a67e47145edf94a8f5/68747470733a2f2f6a622e67672f6261646765732f6f6666696369616c2d706c61737469632e737667)

## 什么是 Code With Me Lobby？

Lobby 服务器负责以下工作：

* 生成可用于加入 Code With Me 会话的链接
* 向客户端报告支持的功能列表（例如，是否允许 P2P）
* 在 P2P 不起作用或被禁止的情况下选择中继服务器

## 使用方法

有关如何使用 Code With Me Lobby 镜像的信息，请参阅我们的[文档](https://www.jetbrains.com/help/cwm/manual-setup.html#lobby)。

## Docker 部署示例

```bash
# 基本运行命令
docker run -d --name cwm-lobby -p 8123:8123 docker.xuanyuan.run/jetbrains/code-with-me-lobby

# 自定义配置运行
docker run -d --name cwm-lobby -p 8123:8123 -v /path/to/config:/config docker.xuanyuan.run/jetbrains/code-with-me-lobby --config /config/lobby.properties
```

## 许可信息

使用此镜像即表示您同意遵守 [Code With Me 许可协议](https://www.jetbrains.com/legal/docs/code-with-me/license.html)

有关本项目中使用的第三方许可列表，请参阅[此页面](https://www.jetbrains.com/legal/third-party-software/?product=CWML)。
